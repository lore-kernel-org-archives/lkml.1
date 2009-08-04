Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZHDADl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZHDADl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 20:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZHDADk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 20:03:40 -0400
Received: from smtp-out-065.synserver.de ([212.40.180.65]:1047 "HELO
	smtp-out-065.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753678AbZHDADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 20:03:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 25114
From: Lars-Peter Clausen <lars@metafoo.de>
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] Regulator: Implement list_voltage for pcf50633 regulator driver.
Date: Tue,  4 Aug 2009 02:03:52 +0200
Message-Id: <1249344232-19784-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements list_voltage for the pcf50644 regulator driver.
As the voltages are linearly scaled the code to convert register values to
voltages can be reused and most of the code can be shared with get_voltage.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/regulator/pcf50633-regulator.c |   96 +++++++++++++++++++++-----------
 1 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 8e14900..e19f451 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -24,11 +24,12 @@
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/pmic.h>
 
-#define PCF50633_REGULATOR(_name, _id) 		\
+#define PCF50633_REGULATOR(_name, _id, _n) 		\
 	{					\
 		.name = _name, 			\
 		.id = _id,			\
 		.ops = &pcf50633_regulator_ops,	\
+		.n_voltages = _n, \
 		.type = REGULATOR_VOLTAGE, 	\
 		.owner = THIS_MODULE, 		\
 	}
@@ -149,11 +150,42 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
 	return pcf50633_reg_write(pcf, regnr, volt_bits);
 }
 
+static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
+						u8 bits)
+{
+	int millivolts;
+
+	switch (id) {
+	case PCF50633_REGULATOR_AUTO:
+		millivolts = auto_voltage_value(bits);
+		break;
+	case PCF50633_REGULATOR_DOWN1:
+		millivolts = down_voltage_value(bits);
+		break;
+	case PCF50633_REGULATOR_DOWN2:
+		millivolts = down_voltage_value(bits);
+		break;
+	case PCF50633_REGULATOR_LDO1:
+	case PCF50633_REGULATOR_LDO2:
+	case PCF50633_REGULATOR_LDO3:
+	case PCF50633_REGULATOR_LDO4:
+	case PCF50633_REGULATOR_LDO5:
+	case PCF50633_REGULATOR_LDO6:
+	case PCF50633_REGULATOR_HCLDO:
+		millivolts = ldo_voltage_value(bits);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return millivolts * 1000;
+}
+
 static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
 {
 	struct pcf50633 *pcf;
-	int regulator_id, millivolts, volt_bits;
-	u8 regnr;
+	int regulator_id;
+	u8 volt_bits, regnr;
 
 	pcf = rdev_get_drvdata(rdev);
 
@@ -164,33 +196,32 @@ static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
 	regnr = pcf50633_regulator_registers[regulator_id];
 
 	volt_bits = pcf50633_reg_read(pcf, regnr);
-	if (volt_bits < 0)
-		return -1;
+
+	return pcf50633_regulator_voltage_value(regulator_id, volt_bits);
+}
+
+static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
+						unsigned int index)
+{
+	struct pcf50633 *pcf;
+	int regulator_id;
+
+	pcf = rdev_get_drvdata(rdev);;
+
+	regulator_id = rdev_get_id(rdev);
 
 	switch (regulator_id) {
 	case PCF50633_REGULATOR_AUTO:
-		millivolts = auto_voltage_value(volt_bits);
-		break;
-	case PCF50633_REGULATOR_DOWN1:
-		millivolts = down_voltage_value(volt_bits);
-		break;
-	case PCF50633_REGULATOR_DOWN2:
-		millivolts = down_voltage_value(volt_bits);
+		index += 0x2f;
 		break;
-	case PCF50633_REGULATOR_LDO1:
-	case PCF50633_REGULATOR_LDO2:
-	case PCF50633_REGULATOR_LDO3:
-	case PCF50633_REGULATOR_LDO4:
-	case PCF50633_REGULATOR_LDO5:
-	case PCF50633_REGULATOR_LDO6:
 	case PCF50633_REGULATOR_HCLDO:
-		millivolts = ldo_voltage_value(volt_bits);
+		index += 0x01;
 		break;
 	default:
-		return -EINVAL;
+		break;
 	}
 
-	return millivolts * 1000;
+	return pcf50633_regulator_voltage_value(regulator_id, index);
 }
 
 static int pcf50633_regulator_enable(struct regulator_dev *rdev)
@@ -246,6 +277,7 @@ static int pcf50633_regulator_is_enabled(struct regulator_dev *rdev)
 static struct regulator_ops pcf50633_regulator_ops = {
 	.set_voltage = pcf50633_regulator_set_voltage,
 	.get_voltage = pcf50633_regulator_get_voltage,
+	.list_voltage = pcf50633_regulator_list_voltage,
 	.enable = pcf50633_regulator_enable,
 	.disable = pcf50633_regulator_disable,
 	.is_enabled = pcf50633_regulator_is_enabled,
@@ -253,27 +285,27 @@ static struct regulator_ops pcf50633_regulator_ops = {
 
 static struct regulator_desc regulators[] = {
 	[PCF50633_REGULATOR_AUTO] =
-		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO),
+		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 80),
 	[PCF50633_REGULATOR_DOWN1] =
-		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1),
+		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1, 95),
 	[PCF50633_REGULATOR_DOWN2] =
-		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2),
+		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2, 95),
 	[PCF50633_REGULATOR_LDO1] =
-		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1),
+		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1, 27),
 	[PCF50633_REGULATOR_LDO2] =
-		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2),
+		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2, 27),
 	[PCF50633_REGULATOR_LDO3] =
-		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3),
+		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3, 27),
 	[PCF50633_REGULATOR_LDO4] =
-		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4),
+		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4, 27),
 	[PCF50633_REGULATOR_LDO5] =
-		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5),
+		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5, 27),
 	[PCF50633_REGULATOR_LDO6] =
-		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6),
+		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6, 27),
 	[PCF50633_REGULATOR_HCLDO] =
-		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO),
+		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO, 26),
 	[PCF50633_REGULATOR_MEMLDO] =
-		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO),
+		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO, 0),
 };
 
 static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
-- 
1.5.6.5

