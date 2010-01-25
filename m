Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232Ab0AYTmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0AYTmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048Ab0AYTmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:42:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39383 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751537Ab0AYTmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:42:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add WM8994 regulator support
Date: Mon, 25 Jan 2010 19:41:57 +0000
Message-Id: <1264448517-12048-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994 contains two LDOs with mixed hardware/software control to
minimise the number of external supplies required while delivering
optimal voltages to minimise power consumption.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig            |    7 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/wm8994-regulator.c |  304 ++++++++++++++++++++++++++++++++++
 3 files changed, 312 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/wm8994-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 262f62e..1f89f16 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -104,6 +104,13 @@ config REGULATOR_WM8400
 	  This driver provides support for the voltage regulators of the
 	  WM8400 AudioPlus PMIC.
 
+config REGULATOR_WM8994
+	tristate "Wolfson Microelectronics WM8994 CODEC"
+	depends on MFD_WM8994
+	help
+	  This driver provides support for the voltage regulators on the
+	  WM8994 CODEC.
+
 config REGULATOR_DA903X
 	tristate "Support regulators on Dialog Semiconductor DA9030/DA9034 PMIC"
 	depends on PMIC_DA903X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index b3c806c..2d3838c 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
+obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
new file mode 100644
index 0000000..d09e018
--- /dev/null
+++ b/drivers/regulator/wm8994-regulator.c
@@ -0,0 +1,304 @@
+/*
+ * wm8994-regulator.c  --  Regulator driver for the WM8994
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/gpio.h>
+
+#include <linux/mfd/wm8994/core.h>
+#include <linux/mfd/wm8994/registers.h>
+#include <linux/mfd/wm8994/pdata.h>
+
+struct wm8994_ldo {
+	int enable;
+	int is_enabled;
+	struct regulator_dev *regulator;
+	struct wm8994 *wm8994;
+};
+
+#define WM8994_LDO1_MAX_SELECTOR 0x7
+#define WM8994_LDO2_MAX_SELECTOR 0x3
+
+static int wm8994_ldo_enable(struct regulator_dev *rdev)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+
+	/* If we have no soft control assume that the LDO is always enabled. */
+	if (!ldo->enable)
+		return 0;
+
+	gpio_set_value(ldo->enable, 1);
+	ldo->is_enabled = 1;
+
+	return 0;
+}
+
+static int wm8994_ldo_disable(struct regulator_dev *rdev)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+
+	/* If we have no soft control assume that the LDO is always enabled. */
+	if (!ldo->enable)
+		return -EINVAL;
+
+	gpio_set_value(ldo->enable, 0);
+	ldo->is_enabled = 0;
+
+	return 0;
+}
+
+static int wm8994_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+
+	return ldo->is_enabled;
+}
+
+static int wm8994_ldo_enable_time(struct regulator_dev *rdev)
+{
+	/* 3ms is fairly conservative but this shouldn't be too performance
+	 * critical; can be tweaked per-system if required. */
+	return 3000;
+}
+
+static int wm8994_ldo1_list_voltage(struct regulator_dev *rdev,
+				    unsigned int selector)
+{
+	if (selector > WM8994_LDO1_MAX_SELECTOR)
+		return -EINVAL;
+
+	return (selector * 100000) + 2400000;
+}
+
+static int wm8994_ldo1_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+	int val;
+
+	val = wm8994_reg_read(ldo->wm8994, WM8994_LDO_1);
+	if (val < 0)
+		return val;
+
+	val = (val & WM8994_LDO1_VSEL_MASK) >> WM8994_LDO1_VSEL_SHIFT;
+
+	return wm8994_ldo1_list_voltage(rdev, val);
+}
+
+static int wm8994_ldo1_set_voltage(struct regulator_dev *rdev,
+				   int min_uV, int max_uV)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+	int selector, v;
+
+	selector = (min_uV - 2400000) / 100000;
+	v = wm8994_ldo1_list_voltage(rdev, selector);
+	if (v < 0 || v > max_uV)
+		return -EINVAL;
+
+	selector <<= WM8994_LDO1_VSEL_SHIFT;
+
+	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_1,
+			       WM8994_LDO1_VSEL_MASK, selector);
+}
+
+static struct regulator_ops wm8994_ldo1_ops = {
+	.enable = wm8994_ldo_enable,
+	.disable = wm8994_ldo_disable,
+	.is_enabled = wm8994_ldo_is_enabled,
+	.enable_time = wm8994_ldo_enable_time,
+
+	.list_voltage = wm8994_ldo1_list_voltage,
+	.get_voltage = wm8994_ldo1_get_voltage,
+	.set_voltage = wm8994_ldo1_set_voltage,
+};
+
+static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
+				    unsigned int selector)
+{
+	if (selector > WM8994_LDO2_MAX_SELECTOR)
+		return -EINVAL;
+
+	return (selector * 100000) + 900000;
+}
+
+static int wm8994_ldo2_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+	int val;
+
+	val = wm8994_reg_read(ldo->wm8994, WM8994_LDO_2);
+	if (val < 0)
+		return val;
+
+	val = (val & WM8994_LDO2_VSEL_MASK) >> WM8994_LDO2_VSEL_SHIFT;
+
+	return wm8994_ldo2_list_voltage(rdev, val);
+}
+
+static int wm8994_ldo2_set_voltage(struct regulator_dev *rdev,
+				   int min_uV, int max_uV)
+{
+	struct wm8994_ldo *ldo = rdev_get_drvdata(rdev);
+	int selector, v;
+
+	selector = (min_uV - 900000) / 100000;
+	v = wm8994_ldo2_list_voltage(rdev, selector);
+	if (v < 0 || v > max_uV)
+		return -EINVAL;
+
+	selector <<= WM8994_LDO2_VSEL_SHIFT;
+
+	return wm8994_set_bits(ldo->wm8994, WM8994_LDO_2,
+			       WM8994_LDO2_VSEL_MASK, selector);
+}
+
+static struct regulator_ops wm8994_ldo2_ops = {
+	.enable = wm8994_ldo_enable,
+	.disable = wm8994_ldo_disable,
+	.is_enabled = wm8994_ldo_is_enabled,
+	.enable_time = wm8994_ldo_enable_time,
+
+	.list_voltage = wm8994_ldo2_list_voltage,
+	.get_voltage = wm8994_ldo2_get_voltage,
+	.set_voltage = wm8994_ldo2_set_voltage,
+};
+
+static struct regulator_desc wm8994_ldo_desc[] = {
+	{
+		.name = "LDO1",
+		.id = 1,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8994_LDO1_MAX_SELECTOR + 1,
+		.ops = &wm8994_ldo1_ops,
+		.owner = THIS_MODULE,
+	},
+	{
+		.name = "LDO2",
+		.id = 2,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = WM8994_LDO2_MAX_SELECTOR + 1,
+		.ops = &wm8994_ldo2_ops,
+		.owner = THIS_MODULE,
+	},
+};
+
+static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
+{
+	struct wm8994 *wm8994 = dev_get_drvdata(pdev->dev.parent);
+	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	struct wm8994_ldo *ldo;
+	int ret;
+
+	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
+
+	if (!pdata)
+		return -ENODEV;
+
+	ldo = kzalloc(sizeof(struct wm8994_ldo), GFP_KERNEL);
+	if (ldo == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	ldo->wm8994 = wm8994;
+
+	ldo->is_enabled = 1;
+
+	if (pdata->ldo[id].enable && gpio_is_valid(pdata->ldo[id].enable)) {
+		ldo->enable = pdata->ldo[id].enable;
+
+		ret = gpio_request(ldo->enable, "WM8994 LDO enable");
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Failed to get enable GPIO: %d\n",
+				ret);
+			goto err;
+		}
+
+		ret = gpio_direction_output(ldo->enable, ldo->is_enabled);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "Failed to set GPIO up: %d\n",
+				ret);
+			goto err_gpio;
+		}
+	}
+
+	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &pdev->dev,
+					     pdata->ldo[id].init_data, ldo);
+	if (IS_ERR(ldo->regulator)) {
+		ret = PTR_ERR(ldo->regulator);
+		dev_err(wm8994->dev, "Failed to register LDO%d: %d\n",
+			id + 1, ret);
+		goto err_gpio;
+	}
+
+	platform_set_drvdata(pdev, ldo);
+
+	return 0;
+
+err_gpio:
+	if (gpio_is_valid(ldo->enable))
+		gpio_free(ldo->enable);
+err:
+	kfree(ldo);
+	return ret;
+}
+
+static __devexit int wm8994_ldo_remove(struct platform_device *pdev)
+{
+	struct wm8994_ldo *ldo = platform_get_drvdata(pdev);
+
+	regulator_unregister(ldo->regulator);
+	if (gpio_is_valid(ldo->enable))
+		gpio_free(ldo->enable);
+	kfree(ldo);
+
+	return 0;
+}
+
+static struct platform_driver wm8994_ldo_driver = {
+	.probe = wm8994_ldo_probe,
+	.remove = __devexit_p(wm8994_ldo_remove),
+	.driver		= {
+		.name	= "wm8994-ldo",
+	},
+};
+
+static int __init wm8994_ldo_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&wm8994_ldo_driver);
+	if (ret != 0)
+		pr_err("Failed to register Wm8994 GP LDO driver: %d\n", ret);
+
+	return ret;
+}
+subsys_initcall(wm8994_ldo_init);
+
+static void __exit wm8994_ldo_exit(void)
+{
+	platform_driver_unregister(&wm8994_ldo_driver);
+}
+module_exit(wm8994_ldo_exit);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM8994 LDO driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm8994-ldo");
-- 
1.6.6

