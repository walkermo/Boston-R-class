library(ggplot2)
library(reshape2)

#### load mtcars
data(mtcars)

#### lets take a look at the data and its structure
str(mtcars)
head(mtcars)
View(mtcars)

#### Before we starts plotting the data, notice that we have a few fields that
#### are numeric, but we probably won't use for measuring. We'll be using them
#### for grouping, categorizing, so convert those into factors
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$vs <- as.factor(mtcars$vs)
mtcars$am <- as.factor(mtcars$am)

#### simple bar chart
barplot(mtcars$mpg)

### change the color
barplot(mtcars$mpg, col = "Blue")

#### add labels
barplot(mtcars$mpg, main = "Vehicle miles per gallon", ylab= "MPG")

### add a line to show where the mean is
abline(h = median(mtcars$mpg))

### change the color of the line
abline(h = median(mtcars$mpg), col = "Red")

### make it horizontal, change measure label to x axis 
barplot(mtcars$mpg, main = "Vehicle miles per gallon", xlab= "MPG", horiz = TRUE)

### lets add the line again
abline(v = median(mtcars$mpg), col = "Red")

### now lets do a histogram
hist(mtcars$mpg, main = "Vehicle miles per gallon", xlab= "mpg", ylab = "Frequency")

### Add data values at top of bars
hist(mtcars$mpg, main = "Vehicle miles per gallon", xlab= "mpg",
     ylab = "Frequency", labels = TRUE)

#### What if we want to split data into categories? Let's make a boxplot
boxplot(mpg ~ cyl, data=mtcars)

###  now let's add labels
boxplot(mpg ~ cyl, data=mtcars, 
        xlab = "number of car cylinders", 
        ylab = "mpg")


### What if we want to see the relationship between two numeric variables?
#### Let's make a scatter plot
plot(mtcars$hp, mtcars$mpg, xlab = "horsepower", ylab = "mpg",
     main = "MPG vs horsepower")

### lets make the points a specific color
plot(hp ~ mpg, data = mtcars, xlab = "horsepower", ylab = "mpg",
     main = "MPG vs horsepower", col = "Red")

#### let's adjust the shapes of the points
plot(mtcars$hp, mtcars$mpg, xlab = "Horsepower", ylab = "mpg",
     main = "MPG vs horsepower", col = "Red", pch = 15)


#### lets adjust the color according to whether the car is an automatic or manual
plot(mtcars$hp, mtcars$mpg, xlab = "Horsepower", ylab = "mpg",
     main = "MPG vs horsepower", col = mtcars$am, pch = 15)

### lets adjust the size of the pointes
plot(mtcars$hp, mtcars$mpg, xlab = "horsepower", ylab = "mpg",
     main = "MPG vs horsepower", col = mtcars$am, pch = 15, cex = 0.5)

#### now let's add a regression line
plot(mtcars$hp, mtcars$mpg, xlab = "horsepower", ylab = "mpg",
           main = "MPG vs horsepower", col = mtcars$am, pch = 15, cex = 1, 
           abline(lm(mtcars$mpg ~ mtcars$hp)))

#### make it a dotted line
plot(mtcars$hp, mtcars$mpg, xlab = "horsepower", ylab = "mpg",
           main = "MPG vs horsepower", col = mtcars$am, pch = 15, cex = 1, 
           abline(lm(mtcars$mpg ~ mtcars$hp), lty = 2))

### lastly, let's add a legend
legend("topright", legend = c("Automatic", "Manual"),
       col = c("Black", "Red"), pch = 15)

#### let's read in a new dataset
vacants <- read.csv(file = "stl_vacants.csv")

### take a look at it
str(vacants)
View(vacants)

### to calculate the total number of vacants by year across
### the city, use aggregate
total_by_year <- aggregate(.~ Year, vacants[c("Year", "Number")], sum)

#### how would you make a barplot of total_by_year?


#### now let's add some year labels on the x axis
barplot(total_by_year$Number, names.arg = total_by_year$Year)

### now let's try a different type of chart
plot(total_by_year$Year, total_by_year$Number, type = "l")

### what if we want to plot multiple lines?

#### let's load the ggplot2 library, which can make much more attractive charts
library(ggplot2)

#### let's make a multi-line
ggplot(vacants, aes(x = Year, y = Number, group = Region, col = Region))
  + geom_line()

### now lets do a stacked bar chart
ggplot(vacants, aes(x = Year, y = Number, group = Region,
                    fill = Region)) + geom_bar(stat = "identity")

#### Lastly, let's slice out north st. louis and make a bar or line chart
### in ggplot. Your choice.


### A few more ggplot examples
### bar chart
data(tips)

# Creating a new data frame from tip that has an average tip grouped by time
average_tip <- aggregate(list(Tip = tips$tip), list(Time = factor(tips$time)), mean)

# Basic barchart
ggplot(average_tip, aes(x = Time, y = Tip, fill = Time)) + geom_bar(stat = "identity")

# Can tell R we don't want the legend by adding + guides(fill = False)

# Adding another factor group to the axis (grouping by gender and meal)
average_tip_gender <- aggregate(list(Tip = tips$tip),
                        list(Time = factor(tips$time), Gender = factor(tips$sex)), mean)

#### round the tip 
average_tip_gender$Tip <- round(average_tip_gender$Tip, 2)

tip_gender <- ggplot(average_tip_gender, aes(x = Time, y = Tip,
                  fill = Gender)) + geom_bar(stat = "identity")

tip_gender

# Not quite what we're looking for, likely 

# Change position to dodge
tip_gender <- ggplot(average_tip_gender, aes(x = Time, y = Tip,
                fill = Gender)) + geom_bar(stat = "identity", position = "dodge")

tip_gender

# Give our graph a title
tip_gender <- tip_gender + ggtitle("Average Tips by Meal")
tip_gender

# Give the axes titles
tip_gender <- tip_gender + xlab("Meal") + ylab("Dollars Tipped")
tip_gender

# Add the values to the top of the barchart
tip_gender <- tip_gender + geom_text(aes(label=Tip), position=position_dodge(width=0.9), vjust=-.25)
tip_gender

### other datasets to play with. R has dozens of built-in datasets,
### such as USArrests, tips. txhousing
data()

### 2017 city of st. Louis crimes
read.csv("2017_stl_crimes.csv")

### Or, use your own data.