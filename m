Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYKGS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYKGS6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYKGS5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:57:07 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:39693 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYKGS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:57:05 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 4/5] adt7473: Check inputs from sysfs writes
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Fri, 07 Nov 2008 10:56:41 -0800
Message-ID: <20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement proper rounding and range checking for adt7473.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/adt7473.c |   89 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index b9a8ea3..18aa308 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -129,6 +129,8 @@ I2C_CLIENT_INSMOD_1(adt7473);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
+#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
+
 struct adt7473_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -357,7 +359,12 @@ static ssize_t set_volt_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int volt = encode_volt(attr->index, simple_strtol(buf, NULL, 10));
+	long volt;
+
+	if (strict_strtol(buf, 10, &volt))
+		return -EINVAL;
+
+	volt = encode_volt(attr->index, volt);
 
 	mutex_lock(&data->lock);
 	data->volt_min[attr->index] = volt;
@@ -386,7 +393,12 @@ static ssize_t set_volt_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int volt = encode_volt(attr->index, simple_strtol(buf, NULL, 10));
+	long volt;
+
+	if (strict_strtol(buf, 10, &volt))
+		return -EINVAL;
+
+	volt = encode_volt(attr->index, volt);
 
 	mutex_lock(&data->lock);
 	data->volt_max[attr->index] = volt;
@@ -419,7 +431,8 @@ static int decode_temp(u8 twos_complement, u8 raw)
 
 static u8 encode_temp(u8 twos_complement, int cooked)
 {
-	return twos_complement ? cooked & 0xFF : cooked + 64;
+	u8 ret = twos_complement ? cooked & 0xFF : cooked + 64;
+	return SENSORS_LIMIT(ret, 0, 255);
 }
 
 static ssize_t show_temp_min(struct device *dev,
@@ -441,7 +454,12 @@ static ssize_t set_temp_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -472,7 +490,12 @@ static ssize_t set_temp_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -515,11 +538,13 @@ static ssize_t set_fan_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
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
@@ -558,7 +583,10 @@ static ssize_t set_max_duty_at_crit(struct device *dev,
 	u8 reg;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = !!temp;
@@ -587,7 +615,12 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm[attr->index] = temp;
@@ -614,7 +647,12 @@ static ssize_t set_pwm_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_max[attr->index] = temp;
@@ -642,7 +680,12 @@ static ssize_t set_pwm_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_min[attr->index] = temp;
@@ -672,7 +715,12 @@ static ssize_t set_temp_tmax(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -703,7 +751,12 @@ static ssize_t set_temp_tmin(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -741,7 +794,10 @@ static ssize_t set_pwm_enable(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	switch (temp) {
 	case 0:
@@ -805,7 +861,10 @@ static ssize_t set_pwm_auto_temp(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	switch (temp) {
 	case 1:

