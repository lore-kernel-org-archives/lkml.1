Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYIJS3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYIJS3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIJS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:28:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37941 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751208AbYIJS25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:28:57 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@kernel.org>, Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Add WM8400 regulator support
Date: Wed, 10 Sep 2008 19:28:54 +0100
Message-Id: <1221071334-19381-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20080910182825.GB16721@rakim.wolfsonmicro.main>
 <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8400 provides two programmable DCDC step-down (buck) convertors
and four low-dropout (LDO) regulators. This driver provides support for
runtime managment of these in the standard regulator API.

Support for configuration of the suspend and hibernate mode behaviour
of the regulators is not yet included.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig            |    8 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/wm8400-regulator.c |  367 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8400-private.h   |    1 +
 include/linux/mfd/wm8400.h           |   40 ++++
 5 files changed, 417 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/wm8400-regulator.c
 create mode 100644 include/linux/mfd/wm8400.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ea1cbed..b67e18d 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -56,6 +56,14 @@ config REGULATOR_BQ24022
 	  charging select between 100 mA and 500 mA charging current
 	  limit.
 
+config REGULATOR_WM8400
+	tristate "Wolfson Microelectroncis WM8400 AudioPlus PMIC"
+	depends on MFD_WM8400
+	select REGULATOR
+	help
+	  This driver provides support for the voltage regulators of the
+	  WM8400 AudioPlus PMIC.
+
 source "drivers/regulator/wm8350/Kconfig"
 
 endmenu
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 1c09819..fcb10dc 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
+obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
 
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
new file mode 100644
index 0000000..03f2576
--- /dev/null
+++ b/drivers/regulator/wm8400-regulator.c
@@ -0,0 +1,367 @@
+/*
+ * Regulator support for WM8400
+ *
+ * Copyright 2008 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/wm8400-private.h>
+
+static int wm8400_ldo_is_enabled(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	u16 val;
+
+	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
+	return (val & WM8400_LDO1_ENA) != 0;
+}
+
+static int wm8400_ldo_enable(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+
+	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
+			       WM8400_LDO1_ENA, WM8400_LDO1_ENA);
+}
+
+static int wm8400_ldo_disable(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+
+	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
+			       WM8400_LDO1_ENA, 0);
+}
+
+static int wm8400_ldo_get_voltage(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	u16 val;
+
+	val = wm8400_reg_read(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev));
+	val &= WM8400_LDO1_VSEL_MASK;
+
+	if (val < 15)
+		return 900000 + (val * 50000);
+	else
+		return 1600000 + ((val - 14) * 100000);
+}
+
+static int wm8400_ldo_set_voltage(struct regulator_dev *dev,
+				  int min_uV, int max_uV)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	u16 val;
+
+	if (min_uV < 900000 || min_uV > 3300000)
+		return -EINVAL;
+
+	if (min_uV < 1700000) {
+		/* Steps of 50mV from 900mV;  */
+		val = (min_uV - 850001) / 50000;
+
+		if ((val * 50000) + 900000 > max_uV)
+			return -EINVAL;
+		BUG_ON((val * 50000) + 900000 < min_uV);
+	} else {
+		/* Steps of 100mV from 1700mV */
+		val = ((min_uV - 1600001) / 100000);
+
+		if ((val * 100000) + 1700000 > max_uV)
+			return -EINVAL;
+		BUG_ON((val * 100000) + 1700000 < min_uV);
+
+		val += 0xf;
+	}
+
+	return wm8400_set_bits(wm8400, WM8400_LDO1_CONTROL + rdev_get_id(dev),
+			       WM8400_LDO1_VSEL_MASK, val);
+}
+
+static struct regulator_ops wm8400_ldo_ops = {
+	.is_enabled = wm8400_ldo_is_enabled,
+	.enable = wm8400_ldo_enable,
+	.disable = wm8400_ldo_disable,
+	.get_voltage = wm8400_ldo_get_voltage,
+	.set_voltage = wm8400_ldo_set_voltage,
+};
+
+static int wm8400_dcdc_is_enabled(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+	u16 val;
+
+	val = wm8400_reg_read(wm8400, WM8400_DCDC1_CONTROL_1 + offset);
+	return (val & WM8400_DC1_ENA) != 0;
+}
+
+static int wm8400_dcdc_enable(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+
+	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+			       WM8400_DC1_ENA, WM8400_DC1_ENA);
+}
+
+static int wm8400_dcdc_disable(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+
+	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+			       WM8400_DC1_ENA, 0);
+}
+
+static int wm8400_dcdc_get_voltage(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	u16 val;
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+
+	val = wm8400_reg_read(wm8400, WM8400_DCDC1_CONTROL_1 + offset);
+	val &= WM8400_DC1_VSEL_MASK;
+
+	return 850000 + (25000 * val);
+}
+
+static int wm8400_dcdc_set_voltage(struct regulator_dev *dev,
+				  int min_uV, int max_uV)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	u16 val;
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+
+	if (min_uV < 850000)
+		return -EINVAL;
+
+	val = (min_uV - 825001) / 25000;
+
+	if (850000 + (25000 * val) > max_uV)
+		return -EINVAL;
+	BUG_ON(850000 + (25000 * val) < min_uV);
+
+	return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+			       WM8400_DC1_VSEL_MASK, val);
+}
+
+static unsigned int wm8400_dcdc_get_mode(struct regulator_dev *dev)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+	u16 data[2];
+	int ret;
+
+	ret = wm8400_block_read(wm8400, WM8400_DCDC1_CONTROL_1 + offset, 2,
+				data);
+	if (ret != 0)
+		return 0;
+
+	/* Datasheet: hibernate */
+	if (data[0] & WM8400_DC1_SLEEP)
+		return REGULATOR_MODE_STANDBY;
+
+	/* Datasheet: standby */
+	if (!(data[0] & WM8400_DC1_ACTIVE))
+		return REGULATOR_MODE_IDLE;
+
+	/* Datasheet: active with or without force PWM */
+	if (data[1] & WM8400_DC1_FRC_PWM)
+		return REGULATOR_MODE_FAST;
+	else
+		return REGULATOR_MODE_NORMAL;
+}
+
+static int wm8400_dcdc_set_mode(struct regulator_dev *dev, unsigned int mode)
+{
+	struct wm8400 *wm8400 = rdev_get_drvdata(dev);
+	int offset = (rdev_get_id(dev) - WM8400_DCDC1) * 2;
+	int ret;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		/* Datasheet: active with force PWM */
+		ret = wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_2 + offset,
+				      WM8400_DC1_FRC_PWM, WM8400_DC1_FRC_PWM);
+		if (ret != 0)
+			return ret;
+
+		return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+				       WM8400_DC1_ACTIVE | WM8400_DC1_SLEEP,
+				       WM8400_DC1_ACTIVE);
+
+	case REGULATOR_MODE_NORMAL:
+		/* Datasheet: active */
+		ret = wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_2 + offset,
+				      WM8400_DC1_FRC_PWM, 0);
+		if (ret != 0)
+			return ret;
+
+		return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+				       WM8400_DC1_ACTIVE | WM8400_DC1_SLEEP,
+				       WM8400_DC1_ACTIVE);
+
+	case REGULATOR_MODE_IDLE:
+		/* Datasheet: standby */
+		ret = wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+				      WM8400_DC1_ACTIVE, 0);
+		if (ret != 0)
+			return ret;
+		return wm8400_set_bits(wm8400, WM8400_DCDC1_CONTROL_1 + offset,
+				       WM8400_DC1_SLEEP, 0);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static unsigned int wm8400_dcdc_get_optimum_mode(struct regulator_dev *dev,
+						 int input_uV, int output_uV,
+						 int load_uA)
+{
+	return REGULATOR_MODE_IDLE;
+}
+
+static struct regulator_ops wm8400_dcdc_ops = {
+	.is_enabled = wm8400_dcdc_is_enabled,
+	.enable = wm8400_dcdc_enable,
+	.disable = wm8400_dcdc_disable,
+	.get_voltage = wm8400_dcdc_get_voltage,
+	.set_voltage = wm8400_dcdc_set_voltage,
+	.get_mode = wm8400_dcdc_get_mode,
+	.set_mode = wm8400_dcdc_set_mode,
+	.get_optimum_mode = wm8400_dcdc_get_optimum_mode,
+};
+
+static struct regulator_desc regulators[] = {
+	{
+		.name = "LDO1",
+		.id = WM8400_LDO1,
+		.ops = &wm8400_ldo_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO2",
+		.id = WM8400_LDO2,
+		.ops = &wm8400_ldo_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO3",
+		.id = WM8400_LDO3,
+		.ops = &wm8400_ldo_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO4",
+		.id = WM8400_LDO4,
+		.ops = &wm8400_ldo_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "DCDC1",
+		.id = WM8400_DCDC1,
+		.ops = &wm8400_dcdc_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "DCDC2",
+		.id = WM8400_DCDC2,
+		.ops = &wm8400_dcdc_ops,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init wm8400_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev;
+
+	rdev = regulator_register(&regulators[pdev->id], &pdev->dev);
+
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	return 0;
+}
+
+static int __devexit wm8400_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+
+	return 0;
+}
+
+static struct platform_driver wm8400_regulator_driver = {
+	.driver = {
+		.name = "wm8400-regulator",
+	},
+	.probe = wm8400_regulator_probe,
+	.remove = __devexit_p(wm8400_regulator_remove),
+};
+
+/**
+ * wm8400_register_regulator - enable software control of a WM8400 regulator
+ *
+ * This function enables software control of a WM8400 regulator via
+ * the regulator API.  It is intended to be called from the
+ * platform_init() callback of the WM8400 MFD driver.
+ *
+ * @param dev      The WM8400 device to operate on.
+ * @param reg      The regulator to control.
+ * @param initdata Regulator initdata for the regulator.
+ */
+int wm8400_register_regulator(struct device *dev, int reg,
+			      struct regulator_init_data *initdata)
+{
+	struct wm8400 *wm8400 = dev->driver_data;
+
+	if (wm8400->regulators[reg].name)
+		return -EBUSY;
+
+	initdata->driver_data = wm8400;
+
+	wm8400->regulators[reg].name = "wm8400-regulator";
+	wm8400->regulators[reg].id = reg;
+	wm8400->regulators[reg].dev.parent = dev;
+	wm8400->regulators[reg].dev.driver_data = wm8400;
+	wm8400->regulators[reg].dev.platform_data = initdata;
+
+	return platform_device_register(&wm8400->regulators[reg]);
+}
+EXPORT_SYMBOL_GPL(wm8400_register_regulator);
+
+static int __init wm8400_regulator_init(void)
+{
+	return platform_driver_register(&wm8400_regulator_driver);
+}
+module_init(wm8400_regulator_init);
+
+static void __exit wm8400_regulator_exit(void)
+{
+	platform_driver_unregister(&wm8400_regulator_driver);
+}
+module_exit(wm8400_regulator_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM8400 regulator driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8400-regulator");
diff --git a/include/linux/mfd/wm8400-private.h b/include/linux/mfd/wm8400-private.h
index ae6a882..55c0fd9 100644
--- a/include/linux/mfd/wm8400-private.h
+++ b/include/linux/mfd/wm8400-private.h
@@ -21,6 +21,7 @@
 #ifndef __LINUX_MFD_WM8400_PRIV_H
 #define __LINUX_MFD_WM8400_PRIV_H
 
+#include <linux/mfd/wm8400.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 
diff --git a/include/linux/mfd/wm8400.h b/include/linux/mfd/wm8400.h
new file mode 100644
index 0000000..b46b566
--- /dev/null
+++ b/include/linux/mfd/wm8400.h
@@ -0,0 +1,40 @@
+/*
+ * wm8400 client interface
+ *
+ * Copyright 2008 Wolfson Microelectronics plc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __LINUX_MFD_WM8400_H
+#define __LINUX_MFD_WM8400_H
+
+#include <linux/regulator/machine.h>
+
+#define WM8400_LDO1  0
+#define WM8400_LDO2  1
+#define WM8400_LDO3  2
+#define WM8400_LDO4  3
+#define WM8400_DCDC1 4
+#define WM8400_DCDC2 5
+
+struct wm8400_platform_data {
+	int (*platform_init)(struct device *dev);
+};
+
+int wm8400_register_regulator(struct device *dev, int reg,
+			      struct regulator_init_data *initdata);
+
+#endif
-- 
1.5.6.5

