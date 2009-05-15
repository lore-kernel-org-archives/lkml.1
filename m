Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbZEOJRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbZEOJRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbZEOJRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:17:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46429 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbZEOJRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:17:40 -0400
Date: Fri, 15 May 2009 11:16:19 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] LP3971 PMIC regulator driver update
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC02245E9A11@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Accept-Language: en-US
Thread-topic: [PATCH] LP3971 PMIC regulator driver update
Thread-index: AcnVPc6K0UY+RtsARfCzACqUHwzbBg==
acceptlanguage: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes issues reported by Mark Brown in his review of National Semiconductors LP3971
PMIC regulator driver. It contains:
- a little code cleanup
- list_voltage() callback added
    
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>



diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 95c18bd..7f024b2 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -32,6 +32,11 @@ static int lp3971_set_bits(struct lp3971 *lp3971, u8 reg, u16 mask, u16 val);
 
 #define LP3971_SYS_CONTROL1_REG 0x07
 
+/* System control register 1 initial value,
+   bits 4 and 5 are EPROM programmable */
+#define SYS_CONTROL1_INIT_VAL 0x40
+#define SYS_CONTROL1_INIT_MASK 0xCF
+
 #define LP3971_BUCK_VOL_ENABLE_REG 0x10
 #define LP3971_BUCK_VOL_CHANGE_REG 0x20
 
@@ -91,7 +96,7 @@ const static int buck_voltage_map[] = {
 #define LDO_VOL_CONTR_SHIFT(x) ((x & 1) << 2)
 #define LDO_VOL_CONTR_MASK 0x0f
 
-const static int ldo45_voltage_map1[] = {
+const static int ldo45_voltage_map[] = {
 	1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350,
 	1400, 1500, 1800, 1900, 2500, 2800, 3000, 3300,
 };
@@ -105,8 +110,8 @@ const static int *ldo_voltage_map[] = {
 	ldo123_voltage_map, /* LDO1 */
 	ldo123_voltage_map, /* LDO2 */
 	ldo123_voltage_map, /* LDO3 */
-	ldo45_voltage_map1, /* LDO4 */
-	ldo45_voltage_map1, /* LDO5 */
+	ldo45_voltage_map, /* LDO4 */
+	ldo45_voltage_map, /* LDO5 */
 };
 
 #define LDO_VOL_VALUE_MAP(x) (ldo_voltage_map[(x - LP3971_LDO1)])
@@ -114,6 +119,12 @@ const static int *ldo_voltage_map[] = {
 #define LDO_VOL_MIN_IDX 0x00
 #define LDO_VOL_MAX_IDX 0x0f
 
+static int lp3971_ldo_list_voltage(struct regulator_dev *dev, unsigned index)
+{
+	int ldo = rdev_get_id(dev) - LP3971_LDO1;
+	return 1000 * LDO_VOL_VALUE_MAP(ldo)[index];
+}
+
 static int lp3971_ldo_is_enabled(struct regulator_dev *dev)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
@@ -180,6 +191,7 @@ static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
 }
 
 static struct regulator_ops lp3971_ldo_ops = {
+	.list_voltage = lp3971_ldo_list_voltage,
 	.is_enabled = lp3971_ldo_is_enabled,
 	.enable = lp3971_ldo_enable,
 	.disable = lp3971_ldo_disable,
@@ -187,6 +199,11 @@ static struct regulator_ops lp3971_ldo_ops = {
 	.set_voltage = lp3971_ldo_set_voltage,
 };
 
+static int lp3971_dcdc_list_voltage(struct regulator_dev *dev, unsigned index)
+{
+	return 1000 * buck_voltage_map[index];
+}
+
 static int lp3971_dcdc_is_enabled(struct regulator_dev *dev)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
@@ -228,8 +245,10 @@ static int lp3971_dcdc_get_voltage(struct regulator_dev *dev)
 
 	if (reg <= BUCK_TARGET_VOL_MAX_IDX)
 		val = 1000 * buck_voltage_map[reg];
-	else
+	else {
 		val = 0;
+		dev_warn(&dev->dev, "chip reported incorrect voltage value.\n");
+	}
 
 	return val;
 }
@@ -273,6 +292,7 @@ static int lp3971_dcdc_set_voltage(struct regulator_dev *dev,
 }
 
 static struct regulator_ops lp3971_dcdc_ops = {
+	.list_voltage = lp3971_dcdc_list_voltage,
 	.is_enabled = lp3971_dcdc_is_enabled,
 	.enable = lp3971_dcdc_enable,
 	.disable = lp3971_dcdc_disable,
@@ -285,6 +305,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO1",
 		.id = LP3971_LDO1,
 		.ops = &lp3971_ldo_ops,
+		.n_voltages = ARRAY_SIZE(ldo123_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -292,6 +313,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO2",
 		.id = LP3971_LDO2,
 		.ops = &lp3971_ldo_ops,
+		.n_voltages = ARRAY_SIZE(ldo123_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -299,6 +321,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO3",
 		.id = LP3971_LDO3,
 		.ops = &lp3971_ldo_ops,
+		.n_voltages = ARRAY_SIZE(ldo123_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -306,6 +329,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO4",
 		.id = LP3971_LDO4,
 		.ops = &lp3971_ldo_ops,
+		.n_voltages = ARRAY_SIZE(ldo45_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -313,6 +337,7 @@ static struct regulator_desc regulators[] = {
 		.name = "LDO5",
 		.id = LP3971_LDO5,
 		.ops = &lp3971_ldo_ops,
+		.n_voltages = ARRAY_SIZE(ldo45_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -320,6 +345,7 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC1",
 		.id = LP3971_DCDC1,
 		.ops = &lp3971_dcdc_ops,
+		.n_voltages = ARRAY_SIZE(buck_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -327,6 +353,7 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC2",
 		.id = LP3971_DCDC2,
 		.ops = &lp3971_dcdc_ops,
+		.n_voltages = ARRAY_SIZE(buck_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -334,6 +361,7 @@ static struct regulator_desc regulators[] = {
 		.name = "DCDC3",
 		.id = LP3971_DCDC3,
 		.ops = &lp3971_dcdc_ops,
+		.n_voltages = ARRAY_SIZE(buck_voltage_map),
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -456,8 +484,10 @@ static int __devinit lp3971_i2c_probe(struct i2c_client *i2c,
 
 	mutex_init(&lp3971->io_lock);
 
-	/* Detect LP3971 (initial system control 1 reg is '0x60') */
+	/* Detect LP3971 */
 	ret = lp3971_i2c_read(i2c, LP3971_SYS_CONTROL1_REG, 1, &val);
+	if (ret == 0 && (val & SYS_CONTROL1_INIT_MASK) != SYS_CONTROL1_INIT_VAL)
+		ret = -ENODEV;
 	if (ret < 0) {
 		dev_err(&i2c->dev, "failed to detect device\n");
 		goto err_detect;
