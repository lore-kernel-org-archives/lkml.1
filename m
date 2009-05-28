Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZE1FPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZE1FPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbZE1FOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:14:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:34421 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbZE1FOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QBWePTiHVi7lDqqRPn/8QMTy1aQAKTlIC6w3phdT7WO8+Mb6lVXHNmRutONYJkdYNC
         gz0e6SkBrsjVSDdw5GWy66khwLww9Wxliax/AR4wi8/d8mwSB+HGmuloAjFTxDsIO4rz
         GsmAQ9FlDfVG4+JPzRMCHNmSH7KpF7SLsRIjE=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Eric Miao <eric.miao@marvell.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/3] regulator/max1586: support increased V3 voltage range
Date: Thu, 28 May 2009 07:15:16 +0200
Message-Id: <1243487718-5423-2-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <878wkibmv9.fsf@free.fr>
References: <878wkibmv9.fsf@free.fr>
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
 drivers/regulator/max1586.c       |   71 +++++++++++++++++++++++++++----------
 include/linux/regulator/max1586.h |   11 ++++++
 2 files changed, 63 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index bbbb55f..92799f4 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -29,7 +29,6 @@
 
 #define MAX1586_V3_MIN_UV   700000
 #define MAX1586_V3_MAX_UV  1475000
-#define MAX1586_V3_STEP_UV   25000
 
 #define MAX1586_V6_MIN_UV        0
 #define MAX1586_V6_MAX_UV  3000000
@@ -37,33 +36,52 @@
 #define I2C_V3_SELECT (0 << 5)
 #define I2C_V6_SELECT (1 << 5)
 
+struct max1586_data {
+	struct i2c_client *client;
+
+	/* min/max V3 voltage */
+	int min_uV;
+	int max_uV;
+
+	struct regulator_dev *rdev[0];
+};
+
 /*
  * V3 voltage
  * On I2C bus, sending a "x" byte to the max1586 means :
  *   set V3 to 0.700V + (x & 0x1f) * 0.025V
+ * This voltage can be increased by external resistors
+ * R24 and R25=100kOhm as described in the data sheet.
+ * The gain is approximately: 1 + R24/R25 + R24/185.5kOhm
  */
-static int max1586_v3_calc_voltage(unsigned selector)
+static int max1586_v3_calc_voltage(struct max1586_data *max1586,
+	unsigned selector)
 {
-	return MAX1586_V3_MIN_UV + (MAX1586_V3_STEP_UV * selector);
+	unsigned range_uV = max1586->max_uV - max1586->min_uV;
+
+	return max1586->min_uV + (selector * range_uV / MAX1586_V3_MAX_VSEL);
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
+	selector = ((min_uV - max1586->min_uV) * MAX1586_V3_MAX_VSEL +
+			range_uV - 1) / range_uV;
+	if (max1586_v3_calc_voltage(max1586, selector) > max_uV)
 		return -EINVAL;
 
 	dev_dbg(&client->dev, "changing voltage v3 to %dmv\n",
-		max1586_v3_calc_voltage(selector) / 1000);
+		max1586_v3_calc_voltage(max1586, selector) / 1000);
 
 	v3_prog = I2C_V3_SELECT | (u8) selector;
 	return i2c_smbus_write_byte(client, v3_prog);
@@ -71,9 +89,11 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 
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
@@ -164,14 +184,25 @@ static int max1586_pmic_probe(struct i2c_client *client,
 {
 	struct regulator_dev **rdev;
 	struct max1586_platform_data *pdata = client->dev.platform_data;
-	int i, id, ret = 0;
+	struct max1586_data *max1586;
+	int i, id, ret = -ENOMEM;
+
+	max1586 = kzalloc(sizeof(struct max1586_data) +
+			sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
+			GFP_KERNEL);
+	if (!max1586)
+		goto out;
 
-	rdev = kzalloc(sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
-		       GFP_KERNEL);
-	if (!rdev)
-		return -ENOMEM;
+	max1586->client = client;
 
-	ret = -EINVAL;
+	if (!pdata->v3_gain) {
+		ret = -EINVAL;
+		goto out_unmap;
+	}
+	max1586->min_uV = MAX1586_V3_MIN_UV * pdata->v3_gain / 1000000;
+	max1586->max_uV = MAX1586_V3_MAX_UV * pdata->v3_gain / 1000000;
+
+	rdev = max1586->rdev;
 	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
 		id = pdata->subdevs[i].id;
 		if (!pdata->subdevs[i].platform_data)
@@ -182,7 +213,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
 		}
 		rdev[i] = regulator_register(&max1586_reg[id], &client->dev,
 					     pdata->subdevs[i].platform_data,
-					     client);
+					     max1586);
 		if (IS_ERR(rdev[i])) {
 			ret = PTR_ERR(rdev[i]);
 			dev_err(&client->dev, "failed to register %s\n",
@@ -198,7 +229,9 @@ static int max1586_pmic_probe(struct i2c_client *client,
 err:
 	while (--i >= 0)
 		regulator_unregister(rdev[i]);
-	kfree(rdev);
+out_unmap:
+	kfree(max1586);
+out:
 	return ret;
 }
 
diff --git a/include/linux/regulator/max1586.h b/include/linux/regulator/max1586.h
index 2056973..4456319 100644
--- a/include/linux/regulator/max1586.h
+++ b/include/linux/regulator/max1586.h
@@ -26,6 +26,12 @@
 #define MAX1586_V3 0
 #define MAX1586_V6 1
 
+/* precalculated values for v3_gain */
+#define MAX1586_GAIN_NO_R24   1000000  /* 700000 .. 1475000 mV */
+#define MAX1586_GAIN_R24_3k32 1051098  /* 735768 .. 1550369 mV */
+#define MAX1586_GAIN_R24_5k11 1078648  /* 755053 .. 1591005 mV */
+#define MAX1586_GAIN_R24_7k5  1115432  /* 780802 .. 1645262 mV */
+
 /**
  * max1586_subdev_data - regulator data
  * @id: regulator Id (either MAX1586_V3 or MAX1586_V6)
@@ -43,10 +49,15 @@ struct max1586_subdev_data {
  * @num_subdevs: number of regultors used (may be 1 or 2)
  * @subdevs: regulator used
  *           At most, there will be a regulator for V3 and one for V6 voltages.
+ * @v3_gain: gain on the V3 voltage output multiplied by 1e6.
+ *           This can be calculated as ((1 + R24/R25 + R24/185.5kOhm) * 1e6)
+ *           for an external resistor configuration as described in the
+ *           data sheet (R25=100kOhm).
  */
 struct max1586_platform_data {
 	int num_subdevs;
 	struct max1586_subdev_data *subdevs;
+	int v3_gain;
 };
 
 #endif
-- 
1.6.3.1

