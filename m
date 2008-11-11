Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYKKBCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYKKBCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYKKBBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:01:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:48169 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYKKBBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:01:39 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2] adt74{62, 70,
	73}: Use DIV_ROUND_CLOSEST for rounded division
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Mon, 10 Nov 2008 17:01:37 -0800
Message-ID: <20081111010137.1730.24582.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify some hwmon drivers to use DIV_ROUND_CLOSEST instead of bloating
source with (naughty) macros.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/adt7462.c |   14 ++++++--------
 drivers/hwmon/adt7470.c |    8 +++-----
 drivers/hwmon/adt7473.c |   10 ++++------
 3 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 66107b4..1852f27 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -204,8 +204,6 @@ I2C_CLIENT_INSMOD_1(adt7462);
 #define MASK_AND_SHIFT(value, prefix)	\
 	(((value) & prefix##_MASK) >> prefix##_SHIFT)
 
-#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))
-
 struct adt7462_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -840,7 +838,7 @@ static ssize_t set_temp_min(struct device *dev,
 	if (strict_strtol(buf, 10, &temp) || !temp_enabled(data, attr->index))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000) + 64;
+	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -878,7 +876,7 @@ static ssize_t set_temp_max(struct device *dev,
 	if (strict_strtol(buf, 10, &temp) || !temp_enabled(data, attr->index))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000) + 64;
+	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -943,7 +941,7 @@ static ssize_t set_volt_max(struct device *dev,
 		return -EINVAL;
 
 	temp *= 1000; /* convert mV to uV */
-	temp = ROUND_DIV(temp, x);
+	temp = DIV_ROUND_CLOSEST(temp, x);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -985,7 +983,7 @@ static ssize_t set_volt_min(struct device *dev,
 		return -EINVAL;
 
 	temp *= 1000; /* convert mV to uV */
-	temp = ROUND_DIV(temp, x);
+	temp = DIV_ROUND_CLOSEST(temp, x);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -1250,7 +1248,7 @@ static ssize_t set_pwm_hyst(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 15);
 
 	/* package things up */
@@ -1337,7 +1335,7 @@ static ssize_t set_pwm_tmin(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000) + 64;
+	temp = DIV_ROUND_CLOSEST(temp, 1000) + 64;
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 1311a59..da6c930 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -137,8 +137,6 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
-#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
-
 struct adt7470_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -360,7 +358,7 @@ static ssize_t set_temp_min(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -394,7 +392,7 @@ static ssize_t set_temp_max(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
@@ -671,7 +669,7 @@ static ssize_t set_pwm_tmin(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index 18aa308..0a6ce23 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -129,8 +129,6 @@ I2C_CLIENT_INSMOD_1(adt7473);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
-#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
-
 struct adt7473_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -459,7 +457,7 @@ static ssize_t set_temp_min(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -495,7 +493,7 @@ static ssize_t set_temp_max(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -720,7 +718,7 @@ static ssize_t set_temp_tmax(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -756,7 +754,7 @@ static ssize_t set_temp_tmin(struct device *dev,
 	if (strict_strtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = ROUND_DIV(temp, 1000);
+	temp = DIV_ROUND_CLOSEST(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);

