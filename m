Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbXJZSza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbXJZSza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJZSzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:55:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47755 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXJZSzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:55:19 -0400
Date: Fri, 26 Oct 2007 11:55:11 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mhoffman@lightlink.com, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] i5k_amb: Convert macros to C functions
Message-ID: <20071026185511.GB7333@tree.beaverton.ibm.com>
References: <20070716221429.GF2619@tree.beaverton.ibm.com> <20070730033840.GG31314@jupiter.solarsys.private> <20070730192606.GD2795@tree.beaverton.ibm.com> <200707302141.l6ULfAnT021069@e1.ny.us.ibm.com> <20070731183706.GG2795@tree.beaverton.ibm.com> <20071016125429.GG3731@jupiter.solarsys.private> <20071016230657.GA6408@tree.beaverton.ibm.com> <20071018131550.GA3526@jupiter.solarsys.private> <20071018202243.GF31309@tree.beaverton.ibm.com> <20071025161912.9e4ef550.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025161912.9e4ef550.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm objected to some of the macros, so convert them into functions.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/i5k_amb.c |   65 +++++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index 7fdbe81..6ac5c6f 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -47,16 +47,35 @@
 #define AMB_CONFIG_SIZE			2048
 #define AMB_FUNC_3_OFFSET		768
 
-#define AMB_REG_TEMP_STATUS(amb)	((amb) * AMB_CONFIG_SIZE + \
-			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_STATUS_ADDR)
-#define AMB_REG_TEMP_MIN(amb)		((amb) * AMB_CONFIG_SIZE + \
-			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MIN_ADDR)
-#define AMB_REG_TEMP_MID(amb)		((amb) * AMB_CONFIG_SIZE + \
-			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MID_ADDR)
-#define AMB_REG_TEMP_MAX(amb)		((amb) * AMB_CONFIG_SIZE + \
-			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MAX_ADDR)
-#define AMB_REG_TEMP(amb)		((amb) * AMB_CONFIG_SIZE + \
-			AMB_FUNC_3_OFFSET + AMB_REG_TEMP_ADDR)
+static unsigned long amb_reg_temp_status(unsigned int amb)
+{
+	return AMB_FUNC_3_OFFSET + AMB_REG_TEMP_STATUS_ADDR +
+	       AMB_CONFIG_SIZE * amb;
+}
+
+static unsigned long amb_reg_temp_min(unsigned int amb)
+{
+	return AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MIN_ADDR +
+	       AMB_CONFIG_SIZE * amb;
+}
+
+static unsigned long amb_reg_temp_mid(unsigned int amb)
+{
+	return AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MID_ADDR +
+	       AMB_CONFIG_SIZE * amb;
+}
+
+static unsigned long amb_reg_temp_max(unsigned int amb)
+{
+	return AMB_FUNC_3_OFFSET + AMB_REG_TEMP_MAX_ADDR +
+	       AMB_CONFIG_SIZE * amb;
+}
+
+static unsigned long amb_reg_temp(unsigned int amb)
+{
+	return AMB_FUNC_3_OFFSET + AMB_REG_TEMP_ADDR +
+	       AMB_CONFIG_SIZE * amb;
+}
 
 #define MAX_MEM_CHANNELS		4
 #define MAX_AMBS_PER_CHANNEL		16
@@ -72,8 +91,10 @@
 #define REAL_MAX_AMBS_PER_CHANNEL	15
 #define KNOBS_PER_AMB			5
 
-#define AMB_NUM_FROM_REG(byte_num, bit_num)	((byte_num) * \
-			MAX_AMBS_PER_CHANNEL) + (bit_num)
+static unsigned long amb_num_from_reg(unsigned int byte_num, unsigned int bit)
+{
+	return byte_num * MAX_AMBS_PER_CHANNEL + bit;
+}
 
 #define AMB_SYSFS_NAME_LEN		16
 struct i5k_device_attribute {
@@ -121,8 +142,8 @@ static ssize_t show_amb_alarm(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i5k_amb_data *data = dev_get_drvdata(dev);
 
-	if (!(amb_read_byte(data, AMB_REG_TEMP_STATUS(attr->index)) & 0x20) &&
-	     (amb_read_byte(data, AMB_REG_TEMP_STATUS(attr->index)) & 0x8))
+	if (!(amb_read_byte(data, amb_reg_temp_status(attr->index)) & 0x20) &&
+	     (amb_read_byte(data, amb_reg_temp_status(attr->index)) & 0x8))
 		return sprintf(buf, "1\n");
 	else
 		return sprintf(buf, "0\n");
@@ -140,7 +161,7 @@ static ssize_t store_amb_min(struct device *dev,
 	if (temp > 255)
 		temp = 255;
 
-	amb_write_byte(data, AMB_REG_TEMP_MIN(attr->index), temp);
+	amb_write_byte(data, amb_reg_temp_min(attr->index), temp);
 	return count;
 }
 
@@ -156,7 +177,7 @@ static ssize_t store_amb_mid(struct device *dev,
 	if (temp > 255)
 		temp = 255;
 
-	amb_write_byte(data, AMB_REG_TEMP_MID(attr->index), temp);
+	amb_write_byte(data, amb_reg_temp_mid(attr->index), temp);
 	return count;
 }
 
@@ -172,7 +193,7 @@ static ssize_t store_amb_max(struct device *dev,
 	if (temp > 255)
 		temp = 255;
 
-	amb_write_byte(data, AMB_REG_TEMP_MAX(attr->index), temp);
+	amb_write_byte(data, amb_reg_temp_max(attr->index), temp);
 	return count;
 }
 
@@ -183,7 +204,7 @@ static ssize_t show_amb_min(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i5k_amb_data *data = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n",
-		500 * amb_read_byte(data, AMB_REG_TEMP_MIN(attr->index)));
+		500 * amb_read_byte(data, amb_reg_temp_min(attr->index)));
 }
 
 static ssize_t show_amb_mid(struct device *dev,
@@ -193,7 +214,7 @@ static ssize_t show_amb_mid(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i5k_amb_data *data = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n",
-		500 * amb_read_byte(data, AMB_REG_TEMP_MID(attr->index)));
+		500 * amb_read_byte(data, amb_reg_temp_mid(attr->index)));
 }
 
 static ssize_t show_amb_max(struct device *dev,
@@ -203,7 +224,7 @@ static ssize_t show_amb_max(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i5k_amb_data *data = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n",
-		500 * amb_read_byte(data, AMB_REG_TEMP_MAX(attr->index)));
+		500 * amb_read_byte(data, amb_reg_temp_max(attr->index)));
 }
 
 static ssize_t show_amb_temp(struct device *dev,
@@ -213,7 +234,7 @@ static ssize_t show_amb_temp(struct device *dev,
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i5k_amb_data *data = dev_get_drvdata(dev);
 	return sprintf(buf, "%d\n",
-		500 * amb_read_byte(data, AMB_REG_TEMP(attr->index)));
+		500 * amb_read_byte(data, amb_reg_temp(attr->index)));
 }
 
 static int __devinit i5k_amb_hwmon_init(struct platform_device *pdev)
@@ -241,7 +262,7 @@ static int __devinit i5k_amb_hwmon_init(struct platform_device *pdev)
 		for (j = 0; j < REAL_MAX_AMBS_PER_CHANNEL; j++, c >>= 1) {
 			struct i5k_device_attribute *iattr;
 
-			k = AMB_NUM_FROM_REG(i, j);
+			k = amb_num_from_reg(i, j);
 			if (!(c & 0x1))
 				continue;
 			d++;
