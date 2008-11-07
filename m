Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKGS5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKGS5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYKGS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:56:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44860 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYKGS4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:56:43 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 3/5] adt7470: Check input range when sysfs files are written
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Fri, 07 Nov 2008 10:56:36 -0800
Message-ID: <20081107185636.13022.54109.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement correct rounding and range checking for adt7470.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/adt7470.c |   75 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index d368d8f..1311a59 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -137,6 +137,8 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
+#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
+
 struct adt7470_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -353,7 +355,13 @@ static ssize_t set_temp_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->temp_min[attr->index] = temp;
@@ -381,7 +389,13 @@ static ssize_t set_temp_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->temp_max[attr->index] = temp;
@@ -430,11 +444,13 @@ static ssize_t set_fan_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 
-	if (!temp)
+	if (strict_strtol(buf, 10, &temp) || !temp)
 		return -EINVAL;
+
 	temp = FAN_RPM_TO_PERIOD(temp);
+	temp = SENSORS_LIMIT(temp, 1, 65534);
 
 	mutex_lock(&data->lock);
 	data->fan_max[attr->index] = temp;
@@ -465,11 +481,13 @@ static ssize_t set_fan_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 
-	if (!temp)
+	if (strict_strtol(buf, 10, &temp) || !temp)
 		return -EINVAL;
+
 	temp = FAN_RPM_TO_PERIOD(temp);
+	temp = SENSORS_LIMIT(temp, 1, 65534);
 
 	mutex_lock(&data->lock);
 	data->fan_min[attr->index] = temp;
@@ -507,9 +525,12 @@ static ssize_t set_force_pwm_max(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
 	mutex_lock(&data->lock);
 	data->force_pwm_max = temp;
 	reg = i2c_smbus_read_byte_data(client, ADT7470_REG_CFG);
@@ -537,7 +558,12 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm[attr->index] = temp;
@@ -564,7 +590,12 @@ static ssize_t set_pwm_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_max[attr->index] = temp;
@@ -592,7 +623,12 @@ static ssize_t set_pwm_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_min[attr->index] = temp;
@@ -630,7 +666,13 @@ static ssize_t set_pwm_tmin(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_tmin[attr->index] = temp;
@@ -658,11 +700,14 @@ static ssize_t set_pwm_auto(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
 	int pwm_auto_reg = ADT7470_REG_PWM_CFG(attr->index);
 	int pwm_auto_reg_mask;
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
 	if (attr->index % 2)
 		pwm_auto_reg_mask = ADT7470_PWM2_AUTO_MASK;
 	else
@@ -716,10 +761,14 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = cvt_auto_temp(simple_strtol(buf, NULL, 10));
 	int pwm_auto_reg = ADT7470_REG_PWM_AUTO_TEMP(attr->index);
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = cvt_auto_temp(temp);
 	if (temp < 0)
 		return temp;
 

