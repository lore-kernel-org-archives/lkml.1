Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYLNLhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYLNLhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYLNLfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:45 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34180 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYLNLfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:43 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 7/7] regulator: PCF50633 pmic driver
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Liam Girdwood <lrg@simlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 14 Dec 2008 16:34:00 +0530
Message-ID: <20081214110400.3307.57681.stgit@cff.thadambail>
In-Reply-To: <20081214110152.3307.50843.stgit@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Liam Girdwood <lrg@simlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig              |    7 +
 drivers/regulator/Makefile             |    1 
 drivers/regulator/pcf50633-regulator.c |  338 ++++++++++++++++++++++++++++++++
 3 files changed, 346 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/pcf50633-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 39360e2..e7e0cf1 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -73,4 +73,11 @@ config REGULATOR_DA903X
 	  Say y here to support the BUCKs and LDOs regulators found on
 	  Dialog Semiconductor DA9030/DA9034 PMIC.
 
+config REGULATOR_PCF50633
+	tristate "PCF50633 regulator driver"
+        depends on MFD_PCF50633
+	help
+	 Say Y here to support the voltage regulators and convertors
+	 on PCF50633
+
 endif
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 254d40c..61b30c6 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,5 +11,6 @@ obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
+obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
new file mode 100644
index 0000000..5277760
--- /dev/null
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -0,0 +1,338 @@
+/* NXP PCF50633 PMIC Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte and Andy Green and Werner Almesberger
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/regulator/driver.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/pmic.h>
+
+#define PCF50633_REGULATOR(_name, _id) 		\
+	{					\
+		.name = _name, 			\
+		.id = _id,			\
+		.ops = &pcf50633_regulator_ops,	\
+		.type = REGULATOR_VOLTAGE, 	\
+		.owner = THIS_MODULE, 		\
+	}
+
+const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
+	[PCF50633_REGULATOR_AUTO]	= PCF50633_REG_AUTOOUT,
+	[PCF50633_REGULATOR_DOWN1]	= PCF50633_REG_DOWN1OUT,
+	[PCF50633_REGULATOR_DOWN2]	= PCF50633_REG_DOWN2OUT,
+	[PCF50633_REGULATOR_MEMLDO]	= PCF50633_REG_MEMLDOOUT,
+	[PCF50633_REGULATOR_LDO1]	= PCF50633_REG_LDO1OUT,
+	[PCF50633_REGULATOR_LDO2]	= PCF50633_REG_LDO2OUT,
+	[PCF50633_REGULATOR_LDO3]	= PCF50633_REG_LDO3OUT,
+	[PCF50633_REGULATOR_LDO4]	= PCF50633_REG_LDO4OUT,
+	[PCF50633_REGULATOR_LDO5]	= PCF50633_REG_LDO5OUT,
+	[PCF50633_REGULATOR_LDO6]	= PCF50633_REG_LDO6OUT,
+	[PCF50633_REGULATOR_HCLDO]	= PCF50633_REG_HCLDOOUT,
+};
+
+/* Bits from voltage value */
+static u8 auto_voltage_bits(unsigned int millivolts)
+{
+	if (millivolts < 1800)
+		return 0;
+	if (millivolts > 3800)
+		return 0xff;
+
+	millivolts -= 625;
+
+	return millivolts / 25;
+}
+
+static u8 down_voltage_bits(unsigned int millivolts)
+{
+	if (millivolts < 625)
+		return 0;
+	else if (millivolts > 3000)
+		return 0xff;
+
+	millivolts -= 625;
+
+	return millivolts / 25;
+}
+
+static u8 ldo_voltage_bits(unsigned int millivolts)
+{
+	if (millivolts < 900)
+		return 0;
+	else if (millivolts > 3600)
+		return 0x1f;
+
+	millivolts -= 900;
+	return millivolts / 100;
+}
+
+/* Obtain voltage value from bits */
+
+static unsigned int auto_voltage_value(u8 bits)
+{
+	if (bits < 0x2f)
+		return 0;
+
+	return 625 + (bits * 25);
+}
+
+
+static unsigned int down_voltage_value(u8 bits)
+{
+	return 625 + (bits * 25);
+}
+
+
+static unsigned int ldo_voltage_value(u8 bits)
+{
+	bits &= 0x1f;
+
+	return 900 + (bits * 100);
+}
+
+static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
+						int min_uV, int max_uV)
+{
+	struct pcf50633 *pcf;
+	int regulator_id, millivolts;
+	u8 volt_bits, regnr;
+
+	pcf = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	millivolts = min_uV / 1000;
+
+	regnr = pcf50633_regulator_registers[regulator_id];
+
+	switch (regulator_id) {
+	case PCF50633_REGULATOR_AUTO:
+		volt_bits = auto_voltage_bits(millivolts);
+		break;
+	case PCF50633_REGULATOR_DOWN1:
+		volt_bits = down_voltage_bits(millivolts);
+		break;
+	case PCF50633_REGULATOR_DOWN2:
+		volt_bits = down_voltage_bits(millivolts);
+		break;
+	case PCF50633_REGULATOR_LDO1:
+	case PCF50633_REGULATOR_LDO2:
+	case PCF50633_REGULATOR_LDO3:
+	case PCF50633_REGULATOR_LDO4:
+	case PCF50633_REGULATOR_LDO5:
+	case PCF50633_REGULATOR_LDO6:
+	case PCF50633_REGULATOR_HCLDO:
+		volt_bits = ldo_voltage_bits(millivolts);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return pcf50633_reg_write(pcf, regnr, volt_bits);
+}
+
+static int pcf50633_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf;
+	int regulator_id, millivolts, volt_bits;
+	u8 regnr;
+
+	pcf = rdev_get_drvdata(rdev);;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	regnr = pcf50633_regulator_registers[regulator_id];
+
+	volt_bits = pcf50633_reg_read(pcf, regnr);
+	if (volt_bits < 0)
+		return -1;
+
+	switch (regulator_id) {
+	case PCF50633_REGULATOR_AUTO:
+		millivolts = auto_voltage_value(volt_bits);
+		break;
+	case PCF50633_REGULATOR_DOWN1:
+		millivolts = down_voltage_value(volt_bits);
+		break;
+	case PCF50633_REGULATOR_DOWN2:
+		millivolts = down_voltage_value(volt_bits);
+		break;
+	case PCF50633_REGULATOR_LDO1:
+	case PCF50633_REGULATOR_LDO2:
+	case PCF50633_REGULATOR_LDO3:
+	case PCF50633_REGULATOR_LDO4:
+	case PCF50633_REGULATOR_LDO5:
+	case PCF50633_REGULATOR_LDO6:
+	case PCF50633_REGULATOR_HCLDO:
+		millivolts = ldo_voltage_value(volt_bits);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return millivolts * 1000;
+}
+
+static int pcf50633_regulator_enable(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
+	int regulator_id;
+	u8 regnr;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* The *ENA register is always one after the *OUT register */
+	regnr = pcf50633_regulator_registers[regulator_id] + 1;
+
+	return pcf50633_reg_set_bit_mask(pcf, regnr, PCF50633_REGULATOR_ON,
+						       PCF50633_REGULATOR_ON);
+
+}
+
+static int pcf50633_regulator_disable(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
+	int regulator_id;
+	u8 regnr;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* the *ENA register is always one after the *OUT register */
+	regnr = pcf50633_regulator_registers[regulator_id] + 1;
+
+	return pcf50633_reg_set_bit_mask(pcf, regnr,
+					PCF50633_REGULATOR_ON, 0);
+}
+
+static int pcf50633_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
+	int regulator_id = rdev_get_id(rdev);
+	u8 regnr;
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= PCF50633_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* the *ENA register is always one after the *OUT register */
+	regnr = pcf50633_regulator_registers[regulator_id] + 1;
+
+	return pcf50633_reg_read(pcf, regnr) & PCF50633_REGULATOR_ON;
+}
+
+struct regulator_ops pcf50633_regulator_ops = {
+	.set_voltage = pcf50633_regulator_set_voltage,
+	.get_voltage = pcf50633_regulator_get_voltage,
+	.enable = pcf50633_regulator_enable,
+	.disable = pcf50633_regulator_disable,
+	.is_enabled = pcf50633_regulator_is_enabled,
+	.set_suspend_enable = pcf50633_regulator_enable,
+	.set_suspend_disable = pcf50633_regulator_disable,
+};
+
+static struct regulator_desc regulators[] = {
+	[PCF50633_REGULATOR_AUTO] =
+		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO),
+	[PCF50633_REGULATOR_DOWN1] =
+		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1),
+	[PCF50633_REGULATOR_DOWN2] =
+		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2),
+	[PCF50633_REGULATOR_LDO1] =
+		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1),
+	[PCF50633_REGULATOR_LDO2] =
+		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2),
+	[PCF50633_REGULATOR_LDO3] =
+		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3),
+	[PCF50633_REGULATOR_LDO4] =
+		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4),
+	[PCF50633_REGULATOR_LDO5] =
+		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5),
+	[PCF50633_REGULATOR_LDO6] =
+		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6),
+	[PCF50633_REGULATOR_HCLDO] =
+		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO),
+	[PCF50633_REGULATOR_MEMLDO] =
+		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO),
+};
+
+int __init pcf50633_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev;
+	struct pcf50633 *pcf;
+
+	pcf = pdev->dev.driver_data;
+
+	rdev = regulator_register(&regulators[pdev->id], &pdev->dev, pcf);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	if (pcf->pdata->regulator_registered)
+		pcf->pdata->regulator_registered(pcf, pdev->id);
+
+	return 0;
+}
+
+static int __devexit pcf50633_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+
+	return 0;
+}
+
+struct platform_driver pcf50633_regulator_driver = {
+	.driver = {
+		.name = "pcf50633-regltr",
+	},
+	.probe = pcf50633_regulator_probe,
+	.remove = __devexit_p(pcf50633_regulator_remove),
+};
+
+static int __init pcf50633_regulator_init(void)
+{
+	return platform_driver_register(&pcf50633_regulator_driver);
+}
+module_init(pcf50633_regulator_init);
+
+static void __exit pcf50633_regulator_exit(void)
+{
+	platform_driver_unregister(&pcf50633_regulator_driver);
+}
+module_exit(pcf50633_regulator_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 regulator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-regulator");

