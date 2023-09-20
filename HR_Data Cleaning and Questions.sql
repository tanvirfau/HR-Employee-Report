create database employee;
use employee;
select * from hr;
describe hr;

select * from hr;

alter table hr
change column ï»¿id emp_id varchar(20) null;

update hr
set birthdate = case
 when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
 else null
end;
select birthdate from hr;

alter table hr
modify column birthdate date;

update hr
set hire_date = case
 when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
 else null
end;

alter table hr
modify column hire_date date;

select hire_date from hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

select termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

alter table hr
modify column termdate date;


alter table hr add column age int;

update hr
set age = timestampdiff(YEAR, birthdate, curdate());

select birthdate, age from hr;

select 
 min(age) as youngest,
 max(age) as oldest
from hr;

select count(*) from hr where age < 18;

# QUESTIONS:
# 1. What is the gender breakdown of employees in the company?

select gender, count(*) as count
from hr 
where age >= 18 and termdate = '0000-00-00'
group by gender;

# 2. What is the race/ ethnicity breakdown of employees in the company?

select race, count(*) as count 
from hr
where age >= 18 and termdate = '0000-00-00'
group by race
order by count(*) DESC;
# 3. What is the age breakdown of employees in the company?
select age, count(*)
from hr
group by age
order by count(*) desc;

# 4. What is the age distribution of employees in the country?

select 
 min(age),
 max(age)
from hr
where age >= 18 and termdate = '0000-00-00';

select 
 case
  when age >= 18 and age <= 24 then '18-24'
  when age >= 24 and age <= 34 then '24-34'
  when age >= 35 and age <= 44 then '35-44'
  when age >= 45 and age <= 54 then '45-54'
  when age >= 55 and age <= 64 then '55-64'
  else '65+'
 end as age_group,
 count(*) as count 
from hr
where age >= 18 and termdate = '0000-00-00'
group by age_group
order by age_group;

select 
 case
  when age >= 18 and age <= 24 then '18-24'
  when age >= 24 and age <= 34 then '24-34'
  when age >= 35 and age <= 44 then '35-44'
  when age >= 45 and age <= 54 then '45-54'
  when age >= 55 and age <= 64 then '55-64'
  else '65+'
 end as age_group, gender,
 count(*) as count 
from hr
where age >= 18 and termdate = '0000-00-00'
group by age_group, gender
order by age_group, gender;

# 5. How many employees work at headquarters versus remote locations?

select location, count(*) as count 
from hr
where age >= 18 and termdate = '0000-00-00'
group by location;
 
# 6. What is the average length of employment for employees who have been terminated?

select
 round(avg(datediff(termdate, hire_date)) / 365, 0) as avg_length_employment
from hr
 where termdate <= curdate() and termdate != '0000-00-00' and age>=18;

# 7. How does the gender distribution vary across departments and job titles?

select department, gender, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by department, gender
order by department;

# 8. what is the distribution of job titles across the company?

select jobtitle, count(*) as count 
from hr
where age >= 18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle DESC;

# 9. which department has the highest turnover rate?

select department,
 total_count,
 terminated_count,
 terminated_count / total_count as termination_rate
from ( 
select department,
count(*) as total_count,
sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age>= 18
group by department) as subquery
order by termination_rate desc;

# 10. What is the distribution of employees across locations by city and state?

select location_state, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by location_state
order by count desc;
 
 # 11. How has the company's employee count changed over time based on hire and term dates?
 
 select year,
  hires,
  terminations,
  hires - terminations as net_change,
  round((hires-terminations) / hires * 100,2) as net_change_percent
from(
     select 
      year(hire_date) as year,
      count(*) as hires,
      sum( case when termdate <> '0000_00_00' and termdate <= curdate() then 1 else 0 end) as terminations
      from hr
      where age>= 18
      group by year(hire_date)
      ) as subquery
order by year asc;

# 12. What is the tenure distribution for each department?

select department, round(avg(datediff(termdate, hire_date) / 365), 0) as avg_tenure
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and age >=18
group by department;



 
 


