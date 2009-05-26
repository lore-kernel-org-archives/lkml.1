Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbZEZTin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbZEZTin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZEZTig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:38:36 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33158 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZEZTif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=swJJRvzY8WJwC7I7l5M0/iRf/BI1aczrmMKiZGJsNHT10H8bmzwZC8n4Ev2epcCc6h
         xL2cqhvdVlPpRgxmj/vR8eF/HbSEdF6m5Mcmez3IBmB3KBrafkvAuwTAE45KBDAM/l/e
         OrMdJidQ+Lbfo7icy00Ad/wkRqnV+ozyWrMaI=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <mark.brown@wolfsonmicro.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] regulator/max1586: support increased V3 voltage range
Date: Tue, 26 May 2009 21:39:08 +0200
Message-Id: <1243366748-8428-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The V3 regulator can be configured with an external resistor
connected to the feedback pin (R24 in the data sheet) to
increase the voltage range.

For example, hx4700 has R24 = 3.32 kOhm to achieve a maximum
V3 voltage of 1.55 V which is needed for 624 MHz CPU frequency.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/regulator/max1586.c       |   75 ++++++++++++++++++++++++++++---------
 include/linux/regulator/max1586.h |    7 +++
 2 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index bbbb55f..db11099 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -27,43 +27,56 @@
 #define MAX1586_V3_MAX_VSEL 31
 #define MAX1586_V6_MAX_VSEL 3
 
-#define MAX1586_V3_MIN_UV   700000
-#define MAX1586_V3_MAX_UV  1475000
-#define MAX1586_V3_STEP_UV   25000
-
 #define MAX1586_V6_MIN_UV        0
 #define MAX1586_V6_MAX_UV  3000000
 
 #define I2C_V3_SELECT (0 << 5)
 #define I2C_V6_SELECT (1 << 5)
 
+struct max1586_data {
+	struct i2c_client *client;
+
+	/* min/max V3 voltage */
+	int min_uV;
+	int max_uV;
+};
+
 /*
  * V3 voltage
  * On I2C bus, sending a "x" byte to the max1586 means :
- *   set V3 to 0.700V + (x & 0x1f) * 0.025V
+ *   set V3 to 0.700V + (x & 0x1f) * 0.025V,
+ *   set V3 to 0.730V + (x & 0x1f) * 0.026V,
+ *   set V3 to 0.750V + (x & 0x1f) * 0.027V or
+ *   set V3 to 0.780V + (x & 0x1f) * 0.028V
+ * depending on the external resistance R24.
  */
-static int max1586_v3_calc_voltage(unsigned selector)
+static int max1586_v3_calc_voltage(struct max1586_data *max1586,
+	unsigned selector)
 {
-	return MAX1586_V3_MIN_UV + (MAX1586_V3_STEP_UV * selector);
+	unsigned range_uV = max1586->max_uV - max1586->min_uV;
+
+	return max1586->min_uV + (selector * range_uV / 31);
 }
 
 static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 {
-	struct i2c_client *client = rdev_get_drvdata(rdev);
+	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
+	struct i2c_client *client = max1586->client;
+	unsigned range_uV = max1586->max_uV - max1586->min_uV;
 	unsigned selector;
 	u8 v3_prog;
 
-	if (min_uV < MAX1586_V3_MIN_UV || min_uV > MAX1586_V3_MAX_UV)
-		return -EINVAL;
-	if (max_uV < MAX1586_V3_MIN_UV || max_uV > MAX1586_V3_MAX_UV)
+	if (min_uV > max1586->max_uV || max_uV < max1586->min_uV)
 		return -EINVAL;
+	if (min_uV < max1586->min_uV)
+		min_uV = max1586->min_uV;
 
-	selector = (min_uV - MAX1586_V3_MIN_UV) / MAX1586_V3_STEP_UV;
-	if (max1586_v3_calc_voltage(selector) > max_uV)
+	selector = (min_uV - max1586->min_uV) * 31 / range_uV;
+	if (max1586_v3_calc_voltage(max1586, selector) > max_uV)
 		return -EINVAL;
 
 	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
-		max1586_v3_calc_voltage(selector) / 1000);
+		max1586_v3_calc_voltage(max1586, selector) / 1000);
 
 	v3_prog = I2C_V3_SELECT | (u8) selector;
 	return i2c_smbus_write_byte(client, v3_prog);
@@ -71,9 +84,11 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 
 static int max1586_v3_list(struct regulator_dev *rdev, unsigned selector)
 {
+	struct max1586_data *max1586 = rdev_get_drvdata(rdev);
+
 	if (selector > MAX1586_V3_MAX_VSEL)
 		return -EINVAL;
-	return max1586_v3_calc_voltage(selector);
+	return max1586_v3_calc_voltage(max1586, selector);
 }
 
 /*
@@ -164,12 +179,33 @@ static int max1586_pmic_probe(struct i2c_client *client,
 {
 	struct regulator_dev **rdev;
 	struct max1586_platform_data *pdata = client->dev.platform_data;
-	int i, id, ret = 0;
+	struct max1586_data *max1586;
+	int i, id, ret = -ENOMEM;
 
 	rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
 		       GFP_KERNEL);
 	if (!rdev)
-		return -ENOMEM;
+		goto out;
+
+	max1586 = kzalloc(sizeof(struct max1586_data *), GFP_KERNEL);
+	if (!max1586)
+		goto out_unmap;
+
+	max1586->client = client;
+	switch (pdata->r24) {
+	case MAX1586_R24_3k32:
+		max1586->min_uV = 730000;
+		max1586->max_uV = 1550000;
+		break;
+	case MAX1586_R24_5k11:
+		max1586->min_uV = 750000;
+		max1586->max_uV = 1600000;
+		break;
+	case MAX1586_R24_7k5:
+		max1586->min_uV = 780000;
+		max1586->max_uV = 1650000;
+		break;
+	}
 
 	ret = -EINVAL;
 	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
@@ -182,7 +218,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
 		}
 		rdev[i] = regulator_register(&max1586_reg[id], &client->dev,
 					     pdata->subdevs[i].platform_data,
-					     client);
+					     max1586);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
@@ -198,7 +234,10 @@ static int max1586_pmic_probe(struct i2c_client *client,
 err:
 	while (--i >= 0)
 		regulator_unregister(rdev[i]);
+	kfree(max1586);
+out_unmap:
 	kfree(rdev);
+out:
 	return ret;
 }
 
diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
index 2056973..cdf2010 100644
--- a/include/linux/regulator/max1586.h
+++ b/include/linux/regulator/max1586.h
@@ -26,6 +26,10 @@
 #define MAX1586_V3 0
 #define MAX1586_V6 1
 
+#define MAX1586_R24_3k32 3320
+#define MAX1586_R24_5k11 5110
+#define MAX1586_R24_7k5  7500
+
 /**
  * max1586_subdev_data - regulator data
  * @id: regulator Id (either MAX1586_V3 or MAX1586_V6)
@@ -43,10 +47,13 @@ struct max1586_subdev_data {
  * @num_subdevs: number of regultors used (may be 1 or 2)
  * @subdevs: regulator used
  *           At most, there will be a regulator for V3 and one for V6 voltages.
+ * @r24: external regulator to increase V3 range
+ *       (0, MAX1586_R24_3k32, MAX1586_R24_5k11 or MAX1586_R24_7k5)
  */
 struct max1586_platform_data {
 	int num_subdevs;
 	struct max1586_subdev_data *subdevs;
+	int r24;
 };
 
 #endif
-- 
1.6.3.1

