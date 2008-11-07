Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYKGS57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYKGS57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYKGS4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:56:50 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44958 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbYKGS4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:56:49 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 5/5] lm85: Support adt7468 chips
To: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Date: Fri, 07 Nov 2008 10:56:47 -0800
Message-ID: <20081107185647.13022.77669.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The adt7468 is a follow-on to the adt7463, so plumb in adt7468 support along
the same code paths.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/lm85.c |   52 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index 3ff0285..cfc1ee9 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -39,7 +39,8 @@
 static const unsigned short normal_i2c[] = { 0x2c, 0x2d, 0x2e, I2C_CLIENT_END };
 
 /* Insmod parameters */
-I2C_CLIENT_INSMOD_6(lm85b, lm85c, adm1027, adt7463, emc6d100, emc6d102);
+I2C_CLIENT_INSMOD_7(lm85b, lm85c, adm1027, adt7463, adt7468, emc6d100,
+		    emc6d102);
 
 /* The LM85 registers */
 
@@ -59,6 +60,12 @@ I2C_CLIENT_INSMOD_6(lm85b, lm85c, adm1027, adt7463, emc6d100, emc6d102);
 
 #define	LM85_REG_COMPANY		0x3e
 #define	LM85_REG_VERSTEP		0x3f
+
+#define	ADT7468_REG_CFG5		0x7c
+#define		ADT7468_OFF64		0x01
+#define	IS_ADT7468_OFF64(data)		\
+	((data)->type == adt7468 && !((data)->cfg5 & ADT7468_OFF64))
+
 /* These are the recognized values for the above regs */
 #define	LM85_COMPANY_NATIONAL		0x01
 #define	LM85_COMPANY_ANALOG_DEV		0x41
@@ -70,6 +77,8 @@ I2C_CLIENT_INSMOD_6(lm85b, lm85c, adm1027, adt7463, emc6d100, emc6d102);
 #define	LM85_VERSTEP_ADM1027		0x60
 #define	LM85_VERSTEP_ADT7463		0x62
 #define	LM85_VERSTEP_ADT7463C		0x6A
+#define	LM85_VERSTEP_ADT7468_1		0x71
+#define	LM85_VERSTEP_ADT7468_2		0x72
 #define	LM85_VERSTEP_EMC6D100_A0        0x60
 #define	LM85_VERSTEP_EMC6D100_A1        0x61
 #define	LM85_VERSTEP_EMC6D102		0x65
@@ -306,6 +315,7 @@ struct lm85_data {
 	u8 vid;			/* Register value */
 	u8 vrm;			/* VRM version */
 	u32 alarms;		/* Register encoding, combined */
+	u8 cfg5;		/* Config Register 5 on ADT7468 */
 	struct lm85_autofan autofan[3];
 	struct lm85_zone zone[3];
 };
@@ -685,6 +695,9 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *attr,
 	struct lm85_data *data = i2c_get_clientdata(client);
 	long val = simple_strtol(buf, NULL, 10);
 
+	if (IS_ADT7468_OFF64(data))
+		val += 64;
+
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = TEMP_TO_REG(val);
 	lm85_write_value(client, LM85_REG_TEMP_MIN(nr), data->temp_min[nr]);
@@ -708,6 +721,9 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *attr,
 	struct lm85_data *data = i2c_get_clientdata(client);
 	long val = simple_strtol(buf, NULL, 10);
 
+	if (IS_ADT7468_OFF64(data))
+		val += 64;
+
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = TEMP_TO_REG(val);
 	lm85_write_value(client, LM85_REG_TEMP_MAX(nr), data->temp_max[nr]);
@@ -1163,6 +1179,10 @@ static int lm85_detect(struct i2c_client *client, int kind,
 			case LM85_VERSTEP_ADT7463C:
 				kind = adt7463;
 				break;
+			case LM85_VERSTEP_ADT7468_1:
+			case LM85_VERSTEP_ADT7468_2:
+				kind = adt7468;
+				break;
 			}
 		} else if (company == LM85_COMPANY_SMSC) {
 			switch (verstep) {
@@ -1195,6 +1215,9 @@ static int lm85_detect(struct i2c_client *client, int kind,
 	case adt7463:
 		type_name = "adt7463";
 		break;
+	case adt7468:
+		type_name = "adt7468";
+		break;
 	case emc6d100:
 		type_name = "emc6d100";
 		break;
@@ -1246,10 +1269,11 @@ static int lm85_probe(struct i2c_client *client,
 	if (err)
 		goto err_kfree;
 
-	/* The ADT7463 has an optional VRM 10 mode where pin 21 is used
+	/* The ADT7463/68 have an optional VRM 10 mode where pin 21 is used
 	   as a sixth digital VID input rather than an analog input. */
 	data->vid = lm85_read_value(client, LM85_REG_VID);
-	if (!(data->type == adt7463 && (data->vid & 0x80)))
+	if (!((data->type == adt7463 || data->type == adt7468) &&
+	    (data->vid & 0x80)))
 		if ((err = sysfs_create_group(&client->dev.kobj,
 					&lm85_group_in4)))
 			goto err_remove_files;
@@ -1357,7 +1381,8 @@ static struct lm85_data *lm85_update_device(struct device *dev)
 		 * There are 2 additional resolution bits per channel and we
 		 * have room for 4, so we shift them to the left.
 		 */
-		if (data->type == adm1027 || data->type == adt7463) {
+		if (data->type == adm1027 || data->type == adt7463 ||
+		    data->type == adt7468) {
 			int ext1 = lm85_read_value(client,
 						   ADM1027_REG_EXTEND_ADC1);
 			int ext2 =  lm85_read_value(client,
@@ -1382,16 +1407,23 @@ static struct lm85_data *lm85_update_device(struct device *dev)
 			    lm85_read_value(client, LM85_REG_FAN(i));
 		}
 
-		if (!(data->type == adt7463 && (data->vid & 0x80))) {
+		if (!((data->type == adt7463 || data->type == adt7468) &&
+		    (data->vid & 0x80))) {
 			data->in[4] = lm85_read_value(client,
 				      LM85_REG_IN(4));
 		}
 
+		if (data->type == adt7468)
+			data->cfg5 = lm85_read_value(client, ADT7468_REG_CFG5);
+
 		for (i = 0; i <= 2; ++i) {
 			data->temp[i] =
 			    lm85_read_value(client, LM85_REG_TEMP(i));
 			data->pwm[i] =
 			    lm85_read_value(client, LM85_REG_PWM(i));
+
+			if (IS_ADT7468_OFF64(data))
+				data->temp[i] -= 64;
 		}
 
 		data->alarms = lm85_read_value(client, LM85_REG_ALARM1);
@@ -1446,7 +1478,8 @@ static struct lm85_data *lm85_update_device(struct device *dev)
 			    lm85_read_value(client, LM85_REG_FAN_MIN(i));
 		}
 
-		if (!(data->type == adt7463 && (data->vid & 0x80))) {
+		if (!((data->type == adt7463 || data->type == adt7468) &&
+		    (data->vid & 0x80))) {
 			data->in_min[4] = lm85_read_value(client,
 					  LM85_REG_IN_MIN(4));
 			data->in_max[4] = lm85_read_value(client,
@@ -1481,6 +1514,13 @@ static struct lm85_data *lm85_update_device(struct device *dev)
 			    lm85_read_value(client, LM85_REG_AFAN_LIMIT(i));
 			data->zone[i].critical =
 			    lm85_read_value(client, LM85_REG_AFAN_CRITICAL(i));
+
+			if (IS_ADT7468_OFF64(data)) {
+				data->temp_min[i] -= 64;
+				data->temp_max[i] -= 64;
+				data->zone[i].limit -= 64;
+				data->zone[i].critical -= 64;
+			}
 		}
 
 		i = lm85_read_value(client, LM85_REG_AFAN_SPIKE1);

