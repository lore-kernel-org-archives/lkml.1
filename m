Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZG1OWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZG1OWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZG1OWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:22:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55705 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752159AbZG1OWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:22:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 18/23] regulator: Add WM831x LDO support
Date: Tue, 28 Jul 2009 15:22:02 +0100
Message-Id: <1248790922-26694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248702372-29534-17-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248702372-29534-17-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of devices provide three types of LDO:

 - General purpose LDOs supporting voltages from 0.9-3.3V
 - High performance analogue LDOs supporting voltages from 1-3.5V
 - Very low power consumption LDOs intended to support always on
   functionality.

This patch adds support for all three kinds of LDO. Each regulator
is probed as an individual platform device with resources used to
provide the register map location of the regulator. Mixed hardware
and software control of regulators is not current supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---

Support missing platform data for the chip as a whole.

 drivers/regulator/Makefile           |    1 +
 drivers/regulator/wm831x-ldo.c       |  852 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/regulator.h |  626 +++++++++++++++++++++++++
 3 files changed, 1479 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/wm831x-ldo.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index b1d2b82..a0a635f 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
+obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
new file mode 100644
index 0000000..bb61aed
--- /dev/null
+++ b/drivers/regulator/wm831x-ldo.c
@@ -0,0 +1,852 @@
+/*
+ * wm831x-ldo.c  --  LDO driver for the WM831x series
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
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/regulator.h>
+#include <linux/mfd/wm831x/pdata.h>
+
+#define WM831X_LDO_MAX_NAME 6
+
+#define WM831X_LDO_CONTROL       0
+#define WM831X_LDO_ON_CONTROL    1
+#define WM831X_LDO_SLEEP_CONTROL 2
+
+#define WM831X_ALIVE_LDO_ON_CONTROL    0
+#define WM831X_ALIVE_LDO_SLEEP_CONTROL 1
+
+struct wm831x_ldo {
+	char name[WM831X_LDO_MAX_NAME];
+	struct regulator_desc desc;
+	int base;
+	struct wm831x *wm831x;
+	struct regulator_dev *regulator;
+};
+
+/*
+ * Shared
+ */
+
+static int wm831x_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+	int reg;
+
+	reg = wm831x_reg_read(wm831x, WM831X_LDO_ENABLE);
+	if (reg < 0)
+		return reg;
+
+	if (reg & mask)
+		return 1;
+	else
+		return 0;
+}
+
+static int wm831x_ldo_enable(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+
+	return wm831x_set_bits(wm831x, WM831X_LDO_ENABLE, mask, mask);
+}
+
+static int wm831x_ldo_disable(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+
+	return wm831x_set_bits(wm831x, WM831X_LDO_ENABLE, mask, 0);
+}
+
+static irqreturn_t wm831x_ldo_uv_irq(int irq, void *data)
+{
+	struct wm831x_ldo *ldo = data;
+
+	regulator_notifier_call_chain(ldo->regulator,
+				      REGULATOR_EVENT_UNDER_VOLTAGE,
+				      NULL);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * General purpose LDOs
+ */
+
+#define WM831X_GP_LDO_SELECTOR_LOW 0xe
+#define WM831X_GP_LDO_MAX_SELECTOR 0x1f
+
+static int wm831x_gp_ldo_list_voltage(struct regulator_dev *rdev,
+				      unsigned int selector)
+{
+	/* 0.9-1.6V in 50mV steps */
+	if (selector <= WM831X_GP_LDO_SELECTOR_LOW)
+		return 900000 + (selector * 50000);
+	/* 1.7-3.3V in 50mV steps */
+	if (selector <= WM831X_GP_LDO_MAX_SELECTOR)
+		return 1600000 + ((selector - WM831X_GP_LDO_SELECTOR_LOW)
+				  * 100000);
+	return -EINVAL;
+}
+
+static int wm831x_gp_ldo_set_voltage_int(struct regulator_dev *rdev, int reg,
+					 int min_uV, int max_uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int vsel, ret;
+
+	if (min_uV < 900000)
+		vsel = 0;
+	else if (min_uV < 1700000)
+		vsel = ((min_uV - 900000) / 50000);
+	else
+		vsel = ((min_uV - 1700000) / 100000)
+			+ WM831X_GP_LDO_SELECTOR_LOW + 1;
+
+	ret = wm831x_gp_ldo_list_voltage(rdev, vsel);
+	if (ret < 0)
+		return ret;
+	if (ret < min_uV || ret > max_uV)
+		return -EINVAL;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_LDO1_ON_VSEL_MASK, vsel);
+}
+
+static int wm831x_gp_ldo_set_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
+
+	return wm831x_gp_ldo_set_voltage_int(rdev, reg, min_uV, max_uV);
+}
+
+static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
+					     int uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	int reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
+
+	return wm831x_gp_ldo_set_voltage_int(rdev, reg, uV, uV);
+}
+
+static int wm831x_gp_ldo_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= WM831X_LDO1_ON_VSEL_MASK;
+
+	return wm831x_gp_ldo_list_voltage(rdev, ret);
+}
+
+static unsigned int wm831x_gp_ldo_get_mode(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int ctrl_reg = ldo->base + WM831X_LDO_CONTROL;
+	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	unsigned int ret;
+
+	ret = wm831x_reg_read(wm831x, on_reg);
+	if (ret < 0)
+		return 0;
+
+	if (!(ret & WM831X_LDO1_ON_MODE))
+		return REGULATOR_MODE_NORMAL;
+
+	ret = wm831x_reg_read(wm831x, ctrl_reg);
+	if (ret < 0)
+		return 0;
+
+	if (ret & WM831X_LDO1_LP_MODE)
+		return REGULATOR_MODE_STANDBY;
+	else
+		return REGULATOR_MODE_IDLE;
+}
+
+static int wm831x_gp_ldo_set_mode(struct regulator_dev *rdev,
+				  unsigned int mode)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int ctrl_reg = ldo->base + WM831X_LDO_CONTROL;
+	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	int ret;
+
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		ret = wm831x_set_bits(wm831x, on_reg,
+				      WM831X_LDO1_ON_MODE, 0);
+		if (ret < 0)
+			return ret;
+		break;
+
+	case REGULATOR_MODE_IDLE:
+		ret = wm831x_set_bits(wm831x, ctrl_reg,
+				      WM831X_LDO1_LP_MODE,
+				      WM831X_LDO1_LP_MODE);
+		if (ret < 0)
+			return ret;
+
+		ret = wm831x_set_bits(wm831x, on_reg,
+				      WM831X_LDO1_ON_MODE,
+				      WM831X_LDO1_ON_MODE);
+		if (ret < 0)
+			return ret;
+
+	case REGULATOR_MODE_STANDBY:
+		ret = wm831x_set_bits(wm831x, ctrl_reg,
+				      WM831X_LDO1_LP_MODE, 0);
+		if (ret < 0)
+			return ret;
+
+		ret = wm831x_set_bits(wm831x, on_reg,
+				      WM831X_LDO1_ON_MODE,
+				      WM831X_LDO1_ON_MODE);
+		if (ret < 0)
+			return ret;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int wm831x_gp_ldo_get_status(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+	int ret;
+
+	/* Is the regulator on? */
+	ret = wm831x_reg_read(wm831x, WM831X_LDO_STATUS);
+	if (ret < 0)
+		return ret;
+	if (!(ret & mask))
+		return REGULATOR_STATUS_OFF;
+
+	/* Is it reporting under voltage? */
+	ret = wm831x_reg_read(wm831x, WM831X_LDO_UV_STATUS);
+	if (ret & mask)
+		return REGULATOR_STATUS_ERROR;
+
+	ret = wm831x_gp_ldo_get_mode(rdev);
+	if (ret < 0)
+		return ret;
+	else
+		return regulator_mode_to_status(ret);
+}
+
+static unsigned int wm831x_gp_ldo_get_optimum_mode(struct regulator_dev *rdev,
+						   int input_uV,
+						   int output_uV, int load_uA)
+{
+	if (load_uA < 20000)
+		return REGULATOR_MODE_STANDBY;
+	if (load_uA < 50000)
+		return REGULATOR_MODE_IDLE;
+	return REGULATOR_MODE_NORMAL;
+}
+
+
+static struct regulator_ops wm831x_gp_ldo_ops = {
+	.list_voltage = wm831x_gp_ldo_list_voltage,
+	.get_voltage = wm831x_gp_ldo_get_voltage,
+	.set_voltage = wm831x_gp_ldo_set_voltage,
+	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
+	.get_mode = wm831x_gp_ldo_get_mode,
+	.set_mode = wm831x_gp_ldo_set_mode,
+	.get_status = wm831x_gp_ldo_get_status,
+	.get_optimum_mode = wm831x_gp_ldo_get_optimum_mode,
+
+	.is_enabled = wm831x_ldo_is_enabled,
+	.enable = wm831x_ldo_enable,
+	.disable = wm831x_ldo_disable,
+};
+
+static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	struct wm831x_ldo *ldo;
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
+
+	if (pdata == NULL || pdata->ldo[id] == NULL)
+		return -ENODEV;
+
+	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
+	if (ldo == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	ldo->wm831x = wm831x;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	ldo->base = res->start;
+
+	snprintf(ldo->name, sizeof(ldo->name), "LDO%d", id + 1);
+	ldo->desc.name = ldo->name;
+	ldo->desc.id = id;
+	ldo->desc.type = REGULATOR_VOLTAGE;
+	ldo->desc.n_voltages = WM831X_GP_LDO_MAX_SELECTOR + 1;
+	ldo->desc.ops = &wm831x_gp_ldo_ops;
+	ldo->desc.owner = THIS_MODULE;
+
+	ldo->regulator = regulator_register(&ldo->desc, &pdev->dev,
+					     pdata->ldo[id], ldo);
+	if (IS_ERR(ldo->regulator)) {
+		ret = PTR_ERR(ldo->regulator);
+		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	irq = platform_get_irq_byname(pdev, "UV");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_ldo_uv_irq,
+				 IRQF_TRIGGER_RISING, ldo->name,
+				 ldo);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
+			irq, ret);
+		goto err_regulator;
+	}
+
+	platform_set_drvdata(pdev, ldo);
+
+	return 0;
+
+err_regulator:
+	regulator_unregister(ldo->regulator);
+err:
+	kfree(ldo);
+	return ret;
+}
+
+static __devexit int wm831x_gp_ldo_remove(struct platform_device *pdev)
+{
+	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = ldo->wm831x;
+
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), ldo);
+	regulator_unregister(ldo->regulator);
+	kfree(ldo);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_gp_ldo_driver = {
+	.probe = wm831x_gp_ldo_probe,
+	.remove = __devexit_p(wm831x_gp_ldo_remove),
+	.driver		= {
+		.name	= "wm831x-ldo",
+	},
+};
+
+/*
+ * Analogue LDOs
+ */
+
+
+#define WM831X_ALDO_SELECTOR_LOW 0xc
+#define WM831X_ALDO_MAX_SELECTOR 0x1f
+
+static int wm831x_aldo_list_voltage(struct regulator_dev *rdev,
+				      unsigned int selector)
+{
+	/* 1-1.6V in 50mV steps */
+	if (selector <= WM831X_ALDO_SELECTOR_LOW)
+		return 1000000 + (selector * 50000);
+	/* 1.7-3.5V in 50mV steps */
+	if (selector <= WM831X_ALDO_MAX_SELECTOR)
+		return 1600000 + ((selector - WM831X_ALDO_SELECTOR_LOW)
+				  * 100000);
+	return -EINVAL;
+}
+
+static int wm831x_aldo_set_voltage_int(struct regulator_dev *rdev, int reg,
+					 int min_uV, int max_uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int vsel, ret;
+
+	if (min_uV < 1000000)
+		vsel = 0;
+	else if (min_uV < 1700000)
+		vsel = ((min_uV - 1000000) / 50000);
+	else
+		vsel = ((min_uV - 1700000) / 100000)
+			+ WM831X_ALDO_SELECTOR_LOW + 1;
+
+	ret = wm831x_aldo_list_voltage(rdev, vsel);
+	if (ret < 0)
+		return ret;
+	if (ret < min_uV || ret > max_uV)
+		return -EINVAL;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_LDO7_ON_VSEL_MASK, vsel);
+}
+
+static int wm831x_aldo_set_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
+
+	return wm831x_aldo_set_voltage_int(rdev, reg, min_uV, max_uV);
+}
+
+static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
+					     int uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	int reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
+
+	return wm831x_aldo_set_voltage_int(rdev, reg, uV, uV);
+}
+
+static int wm831x_aldo_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= WM831X_LDO7_ON_VSEL_MASK;
+
+	return wm831x_aldo_list_voltage(rdev, ret);
+}
+
+static unsigned int wm831x_aldo_get_mode(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	unsigned int ret;
+
+	ret = wm831x_reg_read(wm831x, on_reg);
+	if (ret < 0)
+		return 0;
+
+	if (ret & WM831X_LDO7_ON_MODE)
+		return REGULATOR_MODE_IDLE;
+	else
+		return REGULATOR_MODE_NORMAL;
+}
+
+static int wm831x_aldo_set_mode(struct regulator_dev *rdev,
+				  unsigned int mode)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int ctrl_reg = ldo->base + WM831X_LDO_CONTROL;
+	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
+	int ret;
+
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		ret = wm831x_set_bits(wm831x, on_reg,
+				      WM831X_LDO7_ON_MODE, 0);
+		if (ret < 0)
+			return ret;
+		break;
+
+	case REGULATOR_MODE_IDLE:
+		ret = wm831x_set_bits(wm831x, ctrl_reg,
+				      WM831X_LDO7_ON_MODE,
+				      WM831X_LDO7_ON_MODE);
+		if (ret < 0)
+			return ret;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int wm831x_aldo_get_status(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+	int ret;
+
+	/* Is the regulator on? */
+	ret = wm831x_reg_read(wm831x, WM831X_LDO_STATUS);
+	if (ret < 0)
+		return ret;
+	if (!(ret & mask))
+		return REGULATOR_STATUS_OFF;
+
+	/* Is it reporting under voltage? */
+	ret = wm831x_reg_read(wm831x, WM831X_LDO_UV_STATUS);
+	if (ret & mask)
+		return REGULATOR_STATUS_ERROR;
+
+	ret = wm831x_aldo_get_mode(rdev);
+	if (ret < 0)
+		return ret;
+	else
+		return regulator_mode_to_status(ret);
+}
+
+static struct regulator_ops wm831x_aldo_ops = {
+	.list_voltage = wm831x_aldo_list_voltage,
+	.get_voltage = wm831x_aldo_get_voltage,
+	.set_voltage = wm831x_aldo_set_voltage,
+	.set_suspend_voltage = wm831x_aldo_set_suspend_voltage,
+	.get_mode = wm831x_aldo_get_mode,
+	.set_mode = wm831x_aldo_set_mode,
+	.get_status = wm831x_aldo_get_status,
+
+	.is_enabled = wm831x_ldo_is_enabled,
+	.enable = wm831x_ldo_enable,
+	.disable = wm831x_ldo_disable,
+};
+
+static __devinit int wm831x_aldo_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	struct wm831x_ldo *ldo;
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
+
+	if (pdata == NULL || pdata->ldo[id] == NULL)
+		return -ENODEV;
+
+	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
+	if (ldo == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	ldo->wm831x = wm831x;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	ldo->base = res->start;
+
+	snprintf(ldo->name, sizeof(ldo->name), "LDO%d", id + 1);
+	ldo->desc.name = ldo->name;
+	ldo->desc.id = id;
+	ldo->desc.type = REGULATOR_VOLTAGE;
+	ldo->desc.n_voltages = WM831X_ALDO_MAX_SELECTOR + 1;
+	ldo->desc.ops = &wm831x_aldo_ops;
+	ldo->desc.owner = THIS_MODULE;
+
+	ldo->regulator = regulator_register(&ldo->desc, &pdev->dev,
+					     pdata->ldo[id], ldo);
+	if (IS_ERR(ldo->regulator)) {
+		ret = PTR_ERR(ldo->regulator);
+		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	irq = platform_get_irq_byname(pdev, "UV");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_ldo_uv_irq,
+				 IRQF_TRIGGER_RISING, ldo->name,
+				 ldo);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
+			irq, ret);
+		goto err_regulator;
+	}
+
+	platform_set_drvdata(pdev, ldo);
+
+	return 0;
+
+err_regulator:
+	regulator_unregister(ldo->regulator);
+err:
+	kfree(ldo);
+	return ret;
+}
+
+static __devexit int wm831x_aldo_remove(struct platform_device *pdev)
+{
+	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = ldo->wm831x;
+
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), ldo);
+	regulator_unregister(ldo->regulator);
+	kfree(ldo);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_aldo_driver = {
+	.probe = wm831x_aldo_probe,
+	.remove = __devexit_p(wm831x_aldo_remove),
+	.driver		= {
+		.name	= "wm831x-aldo",
+	},
+};
+
+/*
+ * Alive LDO
+ */
+
+#define WM831X_ALIVE_LDO_MAX_SELECTOR 0xf
+
+static int wm831x_alive_ldo_list_voltage(struct regulator_dev *rdev,
+				      unsigned int selector)
+{
+	/* 0.8-1.55V in 50mV steps */
+	if (selector <= WM831X_ALIVE_LDO_MAX_SELECTOR)
+		return 800000 + (selector * 50000);
+	return -EINVAL;
+}
+
+static int wm831x_alive_ldo_set_voltage_int(struct regulator_dev *rdev,
+					    int reg,
+					    int min_uV, int max_uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int vsel, ret;
+
+	vsel = (min_uV - 800000) / 50000;
+
+	ret = wm831x_alive_ldo_list_voltage(rdev, vsel);
+	if (ret < 0)
+		return ret;
+	if (ret < min_uV || ret > max_uV)
+		return -EINVAL;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_LDO11_ON_VSEL_MASK, vsel);
+}
+
+static int wm831x_alive_ldo_set_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	int reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
+
+	return wm831x_alive_ldo_set_voltage_int(rdev, reg, min_uV, max_uV);
+}
+
+static int wm831x_alive_ldo_set_suspend_voltage(struct regulator_dev *rdev,
+					     int uV)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	int reg = ldo->base + WM831X_ALIVE_LDO_SLEEP_CONTROL;
+
+	return wm831x_alive_ldo_set_voltage_int(rdev, reg, uV, uV);
+}
+
+static int wm831x_alive_ldo_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int reg = ldo->base + WM831X_ALIVE_LDO_ON_CONTROL;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= WM831X_LDO11_ON_VSEL_MASK;
+
+	return wm831x_alive_ldo_list_voltage(rdev, ret);
+}
+
+static int wm831x_alive_ldo_get_status(struct regulator_dev *rdev)
+{
+	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = ldo->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+	int ret;
+
+	/* Is the regulator on? */
+	ret = wm831x_reg_read(wm831x, WM831X_LDO_STATUS);
+	if (ret < 0)
+		return ret;
+	if (ret & mask)
+		return REGULATOR_STATUS_ON;
+	else
+		return REGULATOR_STATUS_OFF;
+}
+
+static struct regulator_ops wm831x_alive_ldo_ops = {
+	.list_voltage = wm831x_alive_ldo_list_voltage,
+	.get_voltage = wm831x_alive_ldo_get_voltage,
+	.set_voltage = wm831x_alive_ldo_set_voltage,
+	.set_suspend_voltage = wm831x_alive_ldo_set_suspend_voltage,
+	.get_status = wm831x_alive_ldo_get_status,
+
+	.is_enabled = wm831x_ldo_is_enabled,
+	.enable = wm831x_ldo_enable,
+	.disable = wm831x_ldo_disable,
+};
+
+static __devinit int wm831x_alive_ldo_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	struct wm831x_ldo *ldo;
+	struct resource *res;
+	int ret;
+
+	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
+
+	if (pdata == NULL || pdata->ldo[id] == NULL)
+		return -ENODEV;
+
+	ldo = kzalloc(sizeof(struct wm831x_ldo), GFP_KERNEL);
+	if (ldo == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	ldo->wm831x = wm831x;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	ldo->base = res->start;
+
+	snprintf(ldo->name, sizeof(ldo->name), "LDO%d", id + 1);
+	ldo->desc.name = ldo->name;
+	ldo->desc.id = id;
+	ldo->desc.type = REGULATOR_VOLTAGE;
+	ldo->desc.n_voltages = WM831X_ALIVE_LDO_MAX_SELECTOR + 1;
+	ldo->desc.ops = &wm831x_alive_ldo_ops;
+	ldo->desc.owner = THIS_MODULE;
+
+	ldo->regulator = regulator_register(&ldo->desc, &pdev->dev,
+					     pdata->ldo[id], ldo);
+	if (IS_ERR(ldo->regulator)) {
+		ret = PTR_ERR(ldo->regulator);
+		dev_err(wm831x->dev, "Failed to register LDO%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, ldo);
+
+	return 0;
+
+err:
+	kfree(ldo);
+	return ret;
+}
+
+static __devexit int wm831x_alive_ldo_remove(struct platform_device *pdev)
+{
+	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
+
+	regulator_unregister(ldo->regulator);
+	kfree(ldo);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_alive_ldo_driver = {
+	.probe = wm831x_alive_ldo_probe,
+	.remove = __devexit_p(wm831x_alive_ldo_remove),
+	.driver		= {
+		.name	= "wm831x-alive-ldo",
+	},
+};
+
+static int __init wm831x_ldo_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&wm831x_gp_ldo_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x GP LDO driver: %d\n", ret);
+
+	ret = platform_driver_register(&wm831x_aldo_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x ALDO driver: %d\n", ret);
+
+	ret = platform_driver_register(&wm831x_alive_ldo_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x alive LDO driver: %d\n",
+		       ret);
+
+	return 0;
+}
+subsys_initcall(wm831x_ldo_init);
+
+static void __exit wm831x_ldo_exit(void)
+{
+	platform_driver_unregister(&wm831x_alive_ldo_driver);
+	platform_driver_unregister(&wm831x_aldo_driver);
+	platform_driver_unregister(&wm831x_gp_ldo_driver);
+}
+module_exit(wm831x_ldo_exit);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM831x LDO driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-ldo");
+MODULE_ALIAS("platform:wm831x-aldo");
+MODULE_ALIAS("platform:wm831x-aliveldo");
diff --git a/include/linux/mfd/wm831x/regulator.h b/include/linux/mfd/wm831x/regulator.h
index c74d6aa..f954663 100644
--- a/include/linux/mfd/wm831x/regulator.h
+++ b/include/linux/mfd/wm831x/regulator.h
@@ -567,6 +567,588 @@
 #define WM831X_DC4_SLPENA_WIDTH                      1  /* DC4_SLPENA */
 
 /*
+ * R16488 (0x4068) - LDO1 Control
+ */
+#define WM831X_LDO1_ERR_ACT_MASK                0xC000  /* LDO1_ERR_ACT - [15:14] */
+#define WM831X_LDO1_ERR_ACT_SHIFT                   14  /* LDO1_ERR_ACT - [15:14] */
+#define WM831X_LDO1_ERR_ACT_WIDTH                    2  /* LDO1_ERR_ACT - [15:14] */
+#define WM831X_LDO1_HWC_SRC_MASK                0x1800  /* LDO1_HWC_SRC - [12:11] */
+#define WM831X_LDO1_HWC_SRC_SHIFT                   11  /* LDO1_HWC_SRC - [12:11] */
+#define WM831X_LDO1_HWC_SRC_WIDTH                    2  /* LDO1_HWC_SRC - [12:11] */
+#define WM831X_LDO1_HWC_VSEL                    0x0400  /* LDO1_HWC_VSEL */
+#define WM831X_LDO1_HWC_VSEL_MASK               0x0400  /* LDO1_HWC_VSEL */
+#define WM831X_LDO1_HWC_VSEL_SHIFT                  10  /* LDO1_HWC_VSEL */
+#define WM831X_LDO1_HWC_VSEL_WIDTH                   1  /* LDO1_HWC_VSEL */
+#define WM831X_LDO1_HWC_MODE_MASK               0x0300  /* LDO1_HWC_MODE - [9:8] */
+#define WM831X_LDO1_HWC_MODE_SHIFT                   8  /* LDO1_HWC_MODE - [9:8] */
+#define WM831X_LDO1_HWC_MODE_WIDTH                   2  /* LDO1_HWC_MODE - [9:8] */
+#define WM831X_LDO1_FLT                         0x0080  /* LDO1_FLT */
+#define WM831X_LDO1_FLT_MASK                    0x0080  /* LDO1_FLT */
+#define WM831X_LDO1_FLT_SHIFT                        7  /* LDO1_FLT */
+#define WM831X_LDO1_FLT_WIDTH                        1  /* LDO1_FLT */
+#define WM831X_LDO1_SWI                         0x0040  /* LDO1_SWI */
+#define WM831X_LDO1_SWI_MASK                    0x0040  /* LDO1_SWI */
+#define WM831X_LDO1_SWI_SHIFT                        6  /* LDO1_SWI */
+#define WM831X_LDO1_SWI_WIDTH                        1  /* LDO1_SWI */
+#define WM831X_LDO1_LP_MODE                     0x0001  /* LDO1_LP_MODE */
+#define WM831X_LDO1_LP_MODE_MASK                0x0001  /* LDO1_LP_MODE */
+#define WM831X_LDO1_LP_MODE_SHIFT                    0  /* LDO1_LP_MODE */
+#define WM831X_LDO1_LP_MODE_WIDTH                    1  /* LDO1_LP_MODE */
+
+/*
+ * R16489 (0x4069) - LDO1 ON Control
+ */
+#define WM831X_LDO1_ON_SLOT_MASK                0xE000  /* LDO1_ON_SLOT - [15:13] */
+#define WM831X_LDO1_ON_SLOT_SHIFT                   13  /* LDO1_ON_SLOT - [15:13] */
+#define WM831X_LDO1_ON_SLOT_WIDTH                    3  /* LDO1_ON_SLOT - [15:13] */
+#define WM831X_LDO1_ON_MODE                     0x0100  /* LDO1_ON_MODE */
+#define WM831X_LDO1_ON_MODE_MASK                0x0100  /* LDO1_ON_MODE */
+#define WM831X_LDO1_ON_MODE_SHIFT                    8  /* LDO1_ON_MODE */
+#define WM831X_LDO1_ON_MODE_WIDTH                    1  /* LDO1_ON_MODE */
+#define WM831X_LDO1_ON_VSEL_MASK                0x001F  /* LDO1_ON_VSEL - [4:0] */
+#define WM831X_LDO1_ON_VSEL_SHIFT                    0  /* LDO1_ON_VSEL - [4:0] */
+#define WM831X_LDO1_ON_VSEL_WIDTH                    5  /* LDO1_ON_VSEL - [4:0] */
+
+/*
+ * R16490 (0x406A) - LDO1 SLEEP Control
+ */
+#define WM831X_LDO1_SLP_SLOT_MASK               0xE000  /* LDO1_SLP_SLOT - [15:13] */
+#define WM831X_LDO1_SLP_SLOT_SHIFT                  13  /* LDO1_SLP_SLOT - [15:13] */
+#define WM831X_LDO1_SLP_SLOT_WIDTH                   3  /* LDO1_SLP_SLOT - [15:13] */
+#define WM831X_LDO1_SLP_MODE                    0x0100  /* LDO1_SLP_MODE */
+#define WM831X_LDO1_SLP_MODE_MASK               0x0100  /* LDO1_SLP_MODE */
+#define WM831X_LDO1_SLP_MODE_SHIFT                   8  /* LDO1_SLP_MODE */
+#define WM831X_LDO1_SLP_MODE_WIDTH                   1  /* LDO1_SLP_MODE */
+#define WM831X_LDO1_SLP_VSEL_MASK               0x001F  /* LDO1_SLP_VSEL - [4:0] */
+#define WM831X_LDO1_SLP_VSEL_SHIFT                   0  /* LDO1_SLP_VSEL - [4:0] */
+#define WM831X_LDO1_SLP_VSEL_WIDTH                   5  /* LDO1_SLP_VSEL - [4:0] */
+
+/*
+ * R16491 (0x406B) - LDO2 Control
+ */
+#define WM831X_LDO2_ERR_ACT_MASK                0xC000  /* LDO2_ERR_ACT - [15:14] */
+#define WM831X_LDO2_ERR_ACT_SHIFT                   14  /* LDO2_ERR_ACT - [15:14] */
+#define WM831X_LDO2_ERR_ACT_WIDTH                    2  /* LDO2_ERR_ACT - [15:14] */
+#define WM831X_LDO2_HWC_SRC_MASK                0x1800  /* LDO2_HWC_SRC - [12:11] */
+#define WM831X_LDO2_HWC_SRC_SHIFT                   11  /* LDO2_HWC_SRC - [12:11] */
+#define WM831X_LDO2_HWC_SRC_WIDTH                    2  /* LDO2_HWC_SRC - [12:11] */
+#define WM831X_LDO2_HWC_VSEL                    0x0400  /* LDO2_HWC_VSEL */
+#define WM831X_LDO2_HWC_VSEL_MASK               0x0400  /* LDO2_HWC_VSEL */
+#define WM831X_LDO2_HWC_VSEL_SHIFT                  10  /* LDO2_HWC_VSEL */
+#define WM831X_LDO2_HWC_VSEL_WIDTH                   1  /* LDO2_HWC_VSEL */
+#define WM831X_LDO2_HWC_MODE_MASK               0x0300  /* LDO2_HWC_MODE - [9:8] */
+#define WM831X_LDO2_HWC_MODE_SHIFT                   8  /* LDO2_HWC_MODE - [9:8] */
+#define WM831X_LDO2_HWC_MODE_WIDTH                   2  /* LDO2_HWC_MODE - [9:8] */
+#define WM831X_LDO2_FLT                         0x0080  /* LDO2_FLT */
+#define WM831X_LDO2_FLT_MASK                    0x0080  /* LDO2_FLT */
+#define WM831X_LDO2_FLT_SHIFT                        7  /* LDO2_FLT */
+#define WM831X_LDO2_FLT_WIDTH                        1  /* LDO2_FLT */
+#define WM831X_LDO2_SWI                         0x0040  /* LDO2_SWI */
+#define WM831X_LDO2_SWI_MASK                    0x0040  /* LDO2_SWI */
+#define WM831X_LDO2_SWI_SHIFT                        6  /* LDO2_SWI */
+#define WM831X_LDO2_SWI_WIDTH                        1  /* LDO2_SWI */
+#define WM831X_LDO2_LP_MODE                     0x0001  /* LDO2_LP_MODE */
+#define WM831X_LDO2_LP_MODE_MASK                0x0001  /* LDO2_LP_MODE */
+#define WM831X_LDO2_LP_MODE_SHIFT                    0  /* LDO2_LP_MODE */
+#define WM831X_LDO2_LP_MODE_WIDTH                    1  /* LDO2_LP_MODE */
+
+/*
+ * R16492 (0x406C) - LDO2 ON Control
+ */
+#define WM831X_LDO2_ON_SLOT_MASK                0xE000  /* LDO2_ON_SLOT - [15:13] */
+#define WM831X_LDO2_ON_SLOT_SHIFT                   13  /* LDO2_ON_SLOT - [15:13] */
+#define WM831X_LDO2_ON_SLOT_WIDTH                    3  /* LDO2_ON_SLOT - [15:13] */
+#define WM831X_LDO2_ON_MODE                     0x0100  /* LDO2_ON_MODE */
+#define WM831X_LDO2_ON_MODE_MASK                0x0100  /* LDO2_ON_MODE */
+#define WM831X_LDO2_ON_MODE_SHIFT                    8  /* LDO2_ON_MODE */
+#define WM831X_LDO2_ON_MODE_WIDTH                    1  /* LDO2_ON_MODE */
+#define WM831X_LDO2_ON_VSEL_MASK                0x001F  /* LDO2_ON_VSEL - [4:0] */
+#define WM831X_LDO2_ON_VSEL_SHIFT                    0  /* LDO2_ON_VSEL - [4:0] */
+#define WM831X_LDO2_ON_VSEL_WIDTH                    5  /* LDO2_ON_VSEL - [4:0] */
+
+/*
+ * R16493 (0x406D) - LDO2 SLEEP Control
+ */
+#define WM831X_LDO2_SLP_SLOT_MASK               0xE000  /* LDO2_SLP_SLOT - [15:13] */
+#define WM831X_LDO2_SLP_SLOT_SHIFT                  13  /* LDO2_SLP_SLOT - [15:13] */
+#define WM831X_LDO2_SLP_SLOT_WIDTH                   3  /* LDO2_SLP_SLOT - [15:13] */
+#define WM831X_LDO2_SLP_MODE                    0x0100  /* LDO2_SLP_MODE */
+#define WM831X_LDO2_SLP_MODE_MASK               0x0100  /* LDO2_SLP_MODE */
+#define WM831X_LDO2_SLP_MODE_SHIFT                   8  /* LDO2_SLP_MODE */
+#define WM831X_LDO2_SLP_MODE_WIDTH                   1  /* LDO2_SLP_MODE */
+#define WM831X_LDO2_SLP_VSEL_MASK               0x001F  /* LDO2_SLP_VSEL - [4:0] */
+#define WM831X_LDO2_SLP_VSEL_SHIFT                   0  /* LDO2_SLP_VSEL - [4:0] */
+#define WM831X_LDO2_SLP_VSEL_WIDTH                   5  /* LDO2_SLP_VSEL - [4:0] */
+
+/*
+ * R16494 (0x406E) - LDO3 Control
+ */
+#define WM831X_LDO3_ERR_ACT_MASK                0xC000  /* LDO3_ERR_ACT - [15:14] */
+#define WM831X_LDO3_ERR_ACT_SHIFT                   14  /* LDO3_ERR_ACT - [15:14] */
+#define WM831X_LDO3_ERR_ACT_WIDTH                    2  /* LDO3_ERR_ACT - [15:14] */
+#define WM831X_LDO3_HWC_SRC_MASK                0x1800  /* LDO3_HWC_SRC - [12:11] */
+#define WM831X_LDO3_HWC_SRC_SHIFT                   11  /* LDO3_HWC_SRC - [12:11] */
+#define WM831X_LDO3_HWC_SRC_WIDTH                    2  /* LDO3_HWC_SRC - [12:11] */
+#define WM831X_LDO3_HWC_VSEL                    0x0400  /* LDO3_HWC_VSEL */
+#define WM831X_LDO3_HWC_VSEL_MASK               0x0400  /* LDO3_HWC_VSEL */
+#define WM831X_LDO3_HWC_VSEL_SHIFT                  10  /* LDO3_HWC_VSEL */
+#define WM831X_LDO3_HWC_VSEL_WIDTH                   1  /* LDO3_HWC_VSEL */
+#define WM831X_LDO3_HWC_MODE_MASK               0x0300  /* LDO3_HWC_MODE - [9:8] */
+#define WM831X_LDO3_HWC_MODE_SHIFT                   8  /* LDO3_HWC_MODE - [9:8] */
+#define WM831X_LDO3_HWC_MODE_WIDTH                   2  /* LDO3_HWC_MODE - [9:8] */
+#define WM831X_LDO3_FLT                         0x0080  /* LDO3_FLT */
+#define WM831X_LDO3_FLT_MASK                    0x0080  /* LDO3_FLT */
+#define WM831X_LDO3_FLT_SHIFT                        7  /* LDO3_FLT */
+#define WM831X_LDO3_FLT_WIDTH                        1  /* LDO3_FLT */
+#define WM831X_LDO3_SWI                         0x0040  /* LDO3_SWI */
+#define WM831X_LDO3_SWI_MASK                    0x0040  /* LDO3_SWI */
+#define WM831X_LDO3_SWI_SHIFT                        6  /* LDO3_SWI */
+#define WM831X_LDO3_SWI_WIDTH                        1  /* LDO3_SWI */
+#define WM831X_LDO3_LP_MODE                     0x0001  /* LDO3_LP_MODE */
+#define WM831X_LDO3_LP_MODE_MASK                0x0001  /* LDO3_LP_MODE */
+#define WM831X_LDO3_LP_MODE_SHIFT                    0  /* LDO3_LP_MODE */
+#define WM831X_LDO3_LP_MODE_WIDTH                    1  /* LDO3_LP_MODE */
+
+/*
+ * R16495 (0x406F) - LDO3 ON Control
+ */
+#define WM831X_LDO3_ON_SLOT_MASK                0xE000  /* LDO3_ON_SLOT - [15:13] */
+#define WM831X_LDO3_ON_SLOT_SHIFT                   13  /* LDO3_ON_SLOT - [15:13] */
+#define WM831X_LDO3_ON_SLOT_WIDTH                    3  /* LDO3_ON_SLOT - [15:13] */
+#define WM831X_LDO3_ON_MODE                     0x0100  /* LDO3_ON_MODE */
+#define WM831X_LDO3_ON_MODE_MASK                0x0100  /* LDO3_ON_MODE */
+#define WM831X_LDO3_ON_MODE_SHIFT                    8  /* LDO3_ON_MODE */
+#define WM831X_LDO3_ON_MODE_WIDTH                    1  /* LDO3_ON_MODE */
+#define WM831X_LDO3_ON_VSEL_MASK                0x001F  /* LDO3_ON_VSEL - [4:0] */
+#define WM831X_LDO3_ON_VSEL_SHIFT                    0  /* LDO3_ON_VSEL - [4:0] */
+#define WM831X_LDO3_ON_VSEL_WIDTH                    5  /* LDO3_ON_VSEL - [4:0] */
+
+/*
+ * R16496 (0x4070) - LDO3 SLEEP Control
+ */
+#define WM831X_LDO3_SLP_SLOT_MASK               0xE000  /* LDO3_SLP_SLOT - [15:13] */
+#define WM831X_LDO3_SLP_SLOT_SHIFT                  13  /* LDO3_SLP_SLOT - [15:13] */
+#define WM831X_LDO3_SLP_SLOT_WIDTH                   3  /* LDO3_SLP_SLOT - [15:13] */
+#define WM831X_LDO3_SLP_MODE                    0x0100  /* LDO3_SLP_MODE */
+#define WM831X_LDO3_SLP_MODE_MASK               0x0100  /* LDO3_SLP_MODE */
+#define WM831X_LDO3_SLP_MODE_SHIFT                   8  /* LDO3_SLP_MODE */
+#define WM831X_LDO3_SLP_MODE_WIDTH                   1  /* LDO3_SLP_MODE */
+#define WM831X_LDO3_SLP_VSEL_MASK               0x001F  /* LDO3_SLP_VSEL - [4:0] */
+#define WM831X_LDO3_SLP_VSEL_SHIFT                   0  /* LDO3_SLP_VSEL - [4:0] */
+#define WM831X_LDO3_SLP_VSEL_WIDTH                   5  /* LDO3_SLP_VSEL - [4:0] */
+
+/*
+ * R16497 (0x4071) - LDO4 Control
+ */
+#define WM831X_LDO4_ERR_ACT_MASK                0xC000  /* LDO4_ERR_ACT - [15:14] */
+#define WM831X_LDO4_ERR_ACT_SHIFT                   14  /* LDO4_ERR_ACT - [15:14] */
+#define WM831X_LDO4_ERR_ACT_WIDTH                    2  /* LDO4_ERR_ACT - [15:14] */
+#define WM831X_LDO4_HWC_SRC_MASK                0x1800  /* LDO4_HWC_SRC - [12:11] */
+#define WM831X_LDO4_HWC_SRC_SHIFT                   11  /* LDO4_HWC_SRC - [12:11] */
+#define WM831X_LDO4_HWC_SRC_WIDTH                    2  /* LDO4_HWC_SRC - [12:11] */
+#define WM831X_LDO4_HWC_VSEL                    0x0400  /* LDO4_HWC_VSEL */
+#define WM831X_LDO4_HWC_VSEL_MASK               0x0400  /* LDO4_HWC_VSEL */
+#define WM831X_LDO4_HWC_VSEL_SHIFT                  10  /* LDO4_HWC_VSEL */
+#define WM831X_LDO4_HWC_VSEL_WIDTH                   1  /* LDO4_HWC_VSEL */
+#define WM831X_LDO4_HWC_MODE_MASK               0x0300  /* LDO4_HWC_MODE - [9:8] */
+#define WM831X_LDO4_HWC_MODE_SHIFT                   8  /* LDO4_HWC_MODE - [9:8] */
+#define WM831X_LDO4_HWC_MODE_WIDTH                   2  /* LDO4_HWC_MODE - [9:8] */
+#define WM831X_LDO4_FLT                         0x0080  /* LDO4_FLT */
+#define WM831X_LDO4_FLT_MASK                    0x0080  /* LDO4_FLT */
+#define WM831X_LDO4_FLT_SHIFT                        7  /* LDO4_FLT */
+#define WM831X_LDO4_FLT_WIDTH                        1  /* LDO4_FLT */
+#define WM831X_LDO4_SWI                         0x0040  /* LDO4_SWI */
+#define WM831X_LDO4_SWI_MASK                    0x0040  /* LDO4_SWI */
+#define WM831X_LDO4_SWI_SHIFT                        6  /* LDO4_SWI */
+#define WM831X_LDO4_SWI_WIDTH                        1  /* LDO4_SWI */
+#define WM831X_LDO4_LP_MODE                     0x0001  /* LDO4_LP_MODE */
+#define WM831X_LDO4_LP_MODE_MASK                0x0001  /* LDO4_LP_MODE */
+#define WM831X_LDO4_LP_MODE_SHIFT                    0  /* LDO4_LP_MODE */
+#define WM831X_LDO4_LP_MODE_WIDTH                    1  /* LDO4_LP_MODE */
+
+/*
+ * R16498 (0x4072) - LDO4 ON Control
+ */
+#define WM831X_LDO4_ON_SLOT_MASK                0xE000  /* LDO4_ON_SLOT - [15:13] */
+#define WM831X_LDO4_ON_SLOT_SHIFT                   13  /* LDO4_ON_SLOT - [15:13] */
+#define WM831X_LDO4_ON_SLOT_WIDTH                    3  /* LDO4_ON_SLOT - [15:13] */
+#define WM831X_LDO4_ON_MODE                     0x0100  /* LDO4_ON_MODE */
+#define WM831X_LDO4_ON_MODE_MASK                0x0100  /* LDO4_ON_MODE */
+#define WM831X_LDO4_ON_MODE_SHIFT                    8  /* LDO4_ON_MODE */
+#define WM831X_LDO4_ON_MODE_WIDTH                    1  /* LDO4_ON_MODE */
+#define WM831X_LDO4_ON_VSEL_MASK                0x001F  /* LDO4_ON_VSEL - [4:0] */
+#define WM831X_LDO4_ON_VSEL_SHIFT                    0  /* LDO4_ON_VSEL - [4:0] */
+#define WM831X_LDO4_ON_VSEL_WIDTH                    5  /* LDO4_ON_VSEL - [4:0] */
+
+/*
+ * R16499 (0x4073) - LDO4 SLEEP Control
+ */
+#define WM831X_LDO4_SLP_SLOT_MASK               0xE000  /* LDO4_SLP_SLOT - [15:13] */
+#define WM831X_LDO4_SLP_SLOT_SHIFT                  13  /* LDO4_SLP_SLOT - [15:13] */
+#define WM831X_LDO4_SLP_SLOT_WIDTH                   3  /* LDO4_SLP_SLOT - [15:13] */
+#define WM831X_LDO4_SLP_MODE                    0x0100  /* LDO4_SLP_MODE */
+#define WM831X_LDO4_SLP_MODE_MASK               0x0100  /* LDO4_SLP_MODE */
+#define WM831X_LDO4_SLP_MODE_SHIFT                   8  /* LDO4_SLP_MODE */
+#define WM831X_LDO4_SLP_MODE_WIDTH                   1  /* LDO4_SLP_MODE */
+#define WM831X_LDO4_SLP_VSEL_MASK               0x001F  /* LDO4_SLP_VSEL - [4:0] */
+#define WM831X_LDO4_SLP_VSEL_SHIFT                   0  /* LDO4_SLP_VSEL - [4:0] */
+#define WM831X_LDO4_SLP_VSEL_WIDTH                   5  /* LDO4_SLP_VSEL - [4:0] */
+
+/*
+ * R16500 (0x4074) - LDO5 Control
+ */
+#define WM831X_LDO5_ERR_ACT_MASK                0xC000  /* LDO5_ERR_ACT - [15:14] */
+#define WM831X_LDO5_ERR_ACT_SHIFT                   14  /* LDO5_ERR_ACT - [15:14] */
+#define WM831X_LDO5_ERR_ACT_WIDTH                    2  /* LDO5_ERR_ACT - [15:14] */
+#define WM831X_LDO5_HWC_SRC_MASK                0x1800  /* LDO5_HWC_SRC - [12:11] */
+#define WM831X_LDO5_HWC_SRC_SHIFT                   11  /* LDO5_HWC_SRC - [12:11] */
+#define WM831X_LDO5_HWC_SRC_WIDTH                    2  /* LDO5_HWC_SRC - [12:11] */
+#define WM831X_LDO5_HWC_VSEL                    0x0400  /* LDO5_HWC_VSEL */
+#define WM831X_LDO5_HWC_VSEL_MASK               0x0400  /* LDO5_HWC_VSEL */
+#define WM831X_LDO5_HWC_VSEL_SHIFT                  10  /* LDO5_HWC_VSEL */
+#define WM831X_LDO5_HWC_VSEL_WIDTH                   1  /* LDO5_HWC_VSEL */
+#define WM831X_LDO5_HWC_MODE_MASK               0x0300  /* LDO5_HWC_MODE - [9:8] */
+#define WM831X_LDO5_HWC_MODE_SHIFT                   8  /* LDO5_HWC_MODE - [9:8] */
+#define WM831X_LDO5_HWC_MODE_WIDTH                   2  /* LDO5_HWC_MODE - [9:8] */
+#define WM831X_LDO5_FLT                         0x0080  /* LDO5_FLT */
+#define WM831X_LDO5_FLT_MASK                    0x0080  /* LDO5_FLT */
+#define WM831X_LDO5_FLT_SHIFT                        7  /* LDO5_FLT */
+#define WM831X_LDO5_FLT_WIDTH                        1  /* LDO5_FLT */
+#define WM831X_LDO5_SWI                         0x0040  /* LDO5_SWI */
+#define WM831X_LDO5_SWI_MASK                    0x0040  /* LDO5_SWI */
+#define WM831X_LDO5_SWI_SHIFT                        6  /* LDO5_SWI */
+#define WM831X_LDO5_SWI_WIDTH                        1  /* LDO5_SWI */
+#define WM831X_LDO5_LP_MODE                     0x0001  /* LDO5_LP_MODE */
+#define WM831X_LDO5_LP_MODE_MASK                0x0001  /* LDO5_LP_MODE */
+#define WM831X_LDO5_LP_MODE_SHIFT                    0  /* LDO5_LP_MODE */
+#define WM831X_LDO5_LP_MODE_WIDTH                    1  /* LDO5_LP_MODE */
+
+/*
+ * R16501 (0x4075) - LDO5 ON Control
+ */
+#define WM831X_LDO5_ON_SLOT_MASK                0xE000  /* LDO5_ON_SLOT - [15:13] */
+#define WM831X_LDO5_ON_SLOT_SHIFT                   13  /* LDO5_ON_SLOT - [15:13] */
+#define WM831X_LDO5_ON_SLOT_WIDTH                    3  /* LDO5_ON_SLOT - [15:13] */
+#define WM831X_LDO5_ON_MODE                     0x0100  /* LDO5_ON_MODE */
+#define WM831X_LDO5_ON_MODE_MASK                0x0100  /* LDO5_ON_MODE */
+#define WM831X_LDO5_ON_MODE_SHIFT                    8  /* LDO5_ON_MODE */
+#define WM831X_LDO5_ON_MODE_WIDTH                    1  /* LDO5_ON_MODE */
+#define WM831X_LDO5_ON_VSEL_MASK                0x001F  /* LDO5_ON_VSEL - [4:0] */
+#define WM831X_LDO5_ON_VSEL_SHIFT                    0  /* LDO5_ON_VSEL - [4:0] */
+#define WM831X_LDO5_ON_VSEL_WIDTH                    5  /* LDO5_ON_VSEL - [4:0] */
+
+/*
+ * R16502 (0x4076) - LDO5 SLEEP Control
+ */
+#define WM831X_LDO5_SLP_SLOT_MASK               0xE000  /* LDO5_SLP_SLOT - [15:13] */
+#define WM831X_LDO5_SLP_SLOT_SHIFT                  13  /* LDO5_SLP_SLOT - [15:13] */
+#define WM831X_LDO5_SLP_SLOT_WIDTH                   3  /* LDO5_SLP_SLOT - [15:13] */
+#define WM831X_LDO5_SLP_MODE                    0x0100  /* LDO5_SLP_MODE */
+#define WM831X_LDO5_SLP_MODE_MASK               0x0100  /* LDO5_SLP_MODE */
+#define WM831X_LDO5_SLP_MODE_SHIFT                   8  /* LDO5_SLP_MODE */
+#define WM831X_LDO5_SLP_MODE_WIDTH                   1  /* LDO5_SLP_MODE */
+#define WM831X_LDO5_SLP_VSEL_MASK               0x001F  /* LDO5_SLP_VSEL - [4:0] */
+#define WM831X_LDO5_SLP_VSEL_SHIFT                   0  /* LDO5_SLP_VSEL - [4:0] */
+#define WM831X_LDO5_SLP_VSEL_WIDTH                   5  /* LDO5_SLP_VSEL - [4:0] */
+
+/*
+ * R16503 (0x4077) - LDO6 Control
+ */
+#define WM831X_LDO6_ERR_ACT_MASK                0xC000  /* LDO6_ERR_ACT - [15:14] */
+#define WM831X_LDO6_ERR_ACT_SHIFT                   14  /* LDO6_ERR_ACT - [15:14] */
+#define WM831X_LDO6_ERR_ACT_WIDTH                    2  /* LDO6_ERR_ACT - [15:14] */
+#define WM831X_LDO6_HWC_SRC_MASK                0x1800  /* LDO6_HWC_SRC - [12:11] */
+#define WM831X_LDO6_HWC_SRC_SHIFT                   11  /* LDO6_HWC_SRC - [12:11] */
+#define WM831X_LDO6_HWC_SRC_WIDTH                    2  /* LDO6_HWC_SRC - [12:11] */
+#define WM831X_LDO6_HWC_VSEL                    0x0400  /* LDO6_HWC_VSEL */
+#define WM831X_LDO6_HWC_VSEL_MASK               0x0400  /* LDO6_HWC_VSEL */
+#define WM831X_LDO6_HWC_VSEL_SHIFT                  10  /* LDO6_HWC_VSEL */
+#define WM831X_LDO6_HWC_VSEL_WIDTH                   1  /* LDO6_HWC_VSEL */
+#define WM831X_LDO6_HWC_MODE_MASK               0x0300  /* LDO6_HWC_MODE - [9:8] */
+#define WM831X_LDO6_HWC_MODE_SHIFT                   8  /* LDO6_HWC_MODE - [9:8] */
+#define WM831X_LDO6_HWC_MODE_WIDTH                   2  /* LDO6_HWC_MODE - [9:8] */
+#define WM831X_LDO6_FLT                         0x0080  /* LDO6_FLT */
+#define WM831X_LDO6_FLT_MASK                    0x0080  /* LDO6_FLT */
+#define WM831X_LDO6_FLT_SHIFT                        7  /* LDO6_FLT */
+#define WM831X_LDO6_FLT_WIDTH                        1  /* LDO6_FLT */
+#define WM831X_LDO6_SWI                         0x0040  /* LDO6_SWI */
+#define WM831X_LDO6_SWI_MASK                    0x0040  /* LDO6_SWI */
+#define WM831X_LDO6_SWI_SHIFT                        6  /* LDO6_SWI */
+#define WM831X_LDO6_SWI_WIDTH                        1  /* LDO6_SWI */
+#define WM831X_LDO6_LP_MODE                     0x0001  /* LDO6_LP_MODE */
+#define WM831X_LDO6_LP_MODE_MASK                0x0001  /* LDO6_LP_MODE */
+#define WM831X_LDO6_LP_MODE_SHIFT                    0  /* LDO6_LP_MODE */
+#define WM831X_LDO6_LP_MODE_WIDTH                    1  /* LDO6_LP_MODE */
+
+/*
+ * R16504 (0x4078) - LDO6 ON Control
+ */
+#define WM831X_LDO6_ON_SLOT_MASK                0xE000  /* LDO6_ON_SLOT - [15:13] */
+#define WM831X_LDO6_ON_SLOT_SHIFT                   13  /* LDO6_ON_SLOT - [15:13] */
+#define WM831X_LDO6_ON_SLOT_WIDTH                    3  /* LDO6_ON_SLOT - [15:13] */
+#define WM831X_LDO6_ON_MODE                     0x0100  /* LDO6_ON_MODE */
+#define WM831X_LDO6_ON_MODE_MASK                0x0100  /* LDO6_ON_MODE */
+#define WM831X_LDO6_ON_MODE_SHIFT                    8  /* LDO6_ON_MODE */
+#define WM831X_LDO6_ON_MODE_WIDTH                    1  /* LDO6_ON_MODE */
+#define WM831X_LDO6_ON_VSEL_MASK                0x001F  /* LDO6_ON_VSEL - [4:0] */
+#define WM831X_LDO6_ON_VSEL_SHIFT                    0  /* LDO6_ON_VSEL - [4:0] */
+#define WM831X_LDO6_ON_VSEL_WIDTH                    5  /* LDO6_ON_VSEL - [4:0] */
+
+/*
+ * R16505 (0x4079) - LDO6 SLEEP Control
+ */
+#define WM831X_LDO6_SLP_SLOT_MASK               0xE000  /* LDO6_SLP_SLOT - [15:13] */
+#define WM831X_LDO6_SLP_SLOT_SHIFT                  13  /* LDO6_SLP_SLOT - [15:13] */
+#define WM831X_LDO6_SLP_SLOT_WIDTH                   3  /* LDO6_SLP_SLOT - [15:13] */
+#define WM831X_LDO6_SLP_MODE                    0x0100  /* LDO6_SLP_MODE */
+#define WM831X_LDO6_SLP_MODE_MASK               0x0100  /* LDO6_SLP_MODE */
+#define WM831X_LDO6_SLP_MODE_SHIFT                   8  /* LDO6_SLP_MODE */
+#define WM831X_LDO6_SLP_MODE_WIDTH                   1  /* LDO6_SLP_MODE */
+#define WM831X_LDO6_SLP_VSEL_MASK               0x001F  /* LDO6_SLP_VSEL - [4:0] */
+#define WM831X_LDO6_SLP_VSEL_SHIFT                   0  /* LDO6_SLP_VSEL - [4:0] */
+#define WM831X_LDO6_SLP_VSEL_WIDTH                   5  /* LDO6_SLP_VSEL - [4:0] */
+
+/*
+ * R16506 (0x407A) - LDO7 Control
+ */
+#define WM831X_LDO7_ERR_ACT_MASK                0xC000  /* LDO7_ERR_ACT - [15:14] */
+#define WM831X_LDO7_ERR_ACT_SHIFT                   14  /* LDO7_ERR_ACT - [15:14] */
+#define WM831X_LDO7_ERR_ACT_WIDTH                    2  /* LDO7_ERR_ACT - [15:14] */
+#define WM831X_LDO7_HWC_SRC_MASK                0x1800  /* LDO7_HWC_SRC - [12:11] */
+#define WM831X_LDO7_HWC_SRC_SHIFT                   11  /* LDO7_HWC_SRC - [12:11] */
+#define WM831X_LDO7_HWC_SRC_WIDTH                    2  /* LDO7_HWC_SRC - [12:11] */
+#define WM831X_LDO7_HWC_VSEL                    0x0400  /* LDO7_HWC_VSEL */
+#define WM831X_LDO7_HWC_VSEL_MASK               0x0400  /* LDO7_HWC_VSEL */
+#define WM831X_LDO7_HWC_VSEL_SHIFT                  10  /* LDO7_HWC_VSEL */
+#define WM831X_LDO7_HWC_VSEL_WIDTH                   1  /* LDO7_HWC_VSEL */
+#define WM831X_LDO7_HWC_MODE_MASK               0x0300  /* LDO7_HWC_MODE - [9:8] */
+#define WM831X_LDO7_HWC_MODE_SHIFT                   8  /* LDO7_HWC_MODE - [9:8] */
+#define WM831X_LDO7_HWC_MODE_WIDTH                   2  /* LDO7_HWC_MODE - [9:8] */
+#define WM831X_LDO7_FLT                         0x0080  /* LDO7_FLT */
+#define WM831X_LDO7_FLT_MASK                    0x0080  /* LDO7_FLT */
+#define WM831X_LDO7_FLT_SHIFT                        7  /* LDO7_FLT */
+#define WM831X_LDO7_FLT_WIDTH                        1  /* LDO7_FLT */
+#define WM831X_LDO7_SWI                         0x0040  /* LDO7_SWI */
+#define WM831X_LDO7_SWI_MASK                    0x0040  /* LDO7_SWI */
+#define WM831X_LDO7_SWI_SHIFT                        6  /* LDO7_SWI */
+#define WM831X_LDO7_SWI_WIDTH                        1  /* LDO7_SWI */
+
+/*
+ * R16507 (0x407B) - LDO7 ON Control
+ */
+#define WM831X_LDO7_ON_SLOT_MASK                0xE000  /* LDO7_ON_SLOT - [15:13] */
+#define WM831X_LDO7_ON_SLOT_SHIFT                   13  /* LDO7_ON_SLOT - [15:13] */
+#define WM831X_LDO7_ON_SLOT_WIDTH                    3  /* LDO7_ON_SLOT - [15:13] */
+#define WM831X_LDO7_ON_MODE                     0x0100  /* LDO7_ON_MODE */
+#define WM831X_LDO7_ON_MODE_MASK                0x0100  /* LDO7_ON_MODE */
+#define WM831X_LDO7_ON_MODE_SHIFT                    8  /* LDO7_ON_MODE */
+#define WM831X_LDO7_ON_MODE_WIDTH                    1  /* LDO7_ON_MODE */
+#define WM831X_LDO7_ON_VSEL_MASK                0x001F  /* LDO7_ON_VSEL - [4:0] */
+#define WM831X_LDO7_ON_VSEL_SHIFT                    0  /* LDO7_ON_VSEL - [4:0] */
+#define WM831X_LDO7_ON_VSEL_WIDTH                    5  /* LDO7_ON_VSEL - [4:0] */
+
+/*
+ * R16508 (0x407C) - LDO7 SLEEP Control
+ */
+#define WM831X_LDO7_SLP_SLOT_MASK               0xE000  /* LDO7_SLP_SLOT - [15:13] */
+#define WM831X_LDO7_SLP_SLOT_SHIFT                  13  /* LDO7_SLP_SLOT - [15:13] */
+#define WM831X_LDO7_SLP_SLOT_WIDTH                   3  /* LDO7_SLP_SLOT - [15:13] */
+#define WM831X_LDO7_SLP_MODE                    0x0100  /* LDO7_SLP_MODE */
+#define WM831X_LDO7_SLP_MODE_MASK               0x0100  /* LDO7_SLP_MODE */
+#define WM831X_LDO7_SLP_MODE_SHIFT                   8  /* LDO7_SLP_MODE */
+#define WM831X_LDO7_SLP_MODE_WIDTH                   1  /* LDO7_SLP_MODE */
+#define WM831X_LDO7_SLP_VSEL_MASK               0x001F  /* LDO7_SLP_VSEL - [4:0] */
+#define WM831X_LDO7_SLP_VSEL_SHIFT                   0  /* LDO7_SLP_VSEL - [4:0] */
+#define WM831X_LDO7_SLP_VSEL_WIDTH                   5  /* LDO7_SLP_VSEL - [4:0] */
+
+/*
+ * R16509 (0x407D) - LDO8 Control
+ */
+#define WM831X_LDO8_ERR_ACT_MASK                0xC000  /* LDO8_ERR_ACT - [15:14] */
+#define WM831X_LDO8_ERR_ACT_SHIFT                   14  /* LDO8_ERR_ACT - [15:14] */
+#define WM831X_LDO8_ERR_ACT_WIDTH                    2  /* LDO8_ERR_ACT - [15:14] */
+#define WM831X_LDO8_HWC_SRC_MASK                0x1800  /* LDO8_HWC_SRC - [12:11] */
+#define WM831X_LDO8_HWC_SRC_SHIFT                   11  /* LDO8_HWC_SRC - [12:11] */
+#define WM831X_LDO8_HWC_SRC_WIDTH                    2  /* LDO8_HWC_SRC - [12:11] */
+#define WM831X_LDO8_HWC_VSEL                    0x0400  /* LDO8_HWC_VSEL */
+#define WM831X_LDO8_HWC_VSEL_MASK               0x0400  /* LDO8_HWC_VSEL */
+#define WM831X_LDO8_HWC_VSEL_SHIFT                  10  /* LDO8_HWC_VSEL */
+#define WM831X_LDO8_HWC_VSEL_WIDTH                   1  /* LDO8_HWC_VSEL */
+#define WM831X_LDO8_HWC_MODE_MASK               0x0300  /* LDO8_HWC_MODE - [9:8] */
+#define WM831X_LDO8_HWC_MODE_SHIFT                   8  /* LDO8_HWC_MODE - [9:8] */
+#define WM831X_LDO8_HWC_MODE_WIDTH                   2  /* LDO8_HWC_MODE - [9:8] */
+#define WM831X_LDO8_FLT                         0x0080  /* LDO8_FLT */
+#define WM831X_LDO8_FLT_MASK                    0x0080  /* LDO8_FLT */
+#define WM831X_LDO8_FLT_SHIFT                        7  /* LDO8_FLT */
+#define WM831X_LDO8_FLT_WIDTH                        1  /* LDO8_FLT */
+#define WM831X_LDO8_SWI                         0x0040  /* LDO8_SWI */
+#define WM831X_LDO8_SWI_MASK                    0x0040  /* LDO8_SWI */
+#define WM831X_LDO8_SWI_SHIFT                        6  /* LDO8_SWI */
+#define WM831X_LDO8_SWI_WIDTH                        1  /* LDO8_SWI */
+
+/*
+ * R16510 (0x407E) - LDO8 ON Control
+ */
+#define WM831X_LDO8_ON_SLOT_MASK                0xE000  /* LDO8_ON_SLOT - [15:13] */
+#define WM831X_LDO8_ON_SLOT_SHIFT                   13  /* LDO8_ON_SLOT - [15:13] */
+#define WM831X_LDO8_ON_SLOT_WIDTH                    3  /* LDO8_ON_SLOT - [15:13] */
+#define WM831X_LDO8_ON_MODE                     0x0100  /* LDO8_ON_MODE */
+#define WM831X_LDO8_ON_MODE_MASK                0x0100  /* LDO8_ON_MODE */
+#define WM831X_LDO8_ON_MODE_SHIFT                    8  /* LDO8_ON_MODE */
+#define WM831X_LDO8_ON_MODE_WIDTH                    1  /* LDO8_ON_MODE */
+#define WM831X_LDO8_ON_VSEL_MASK                0x001F  /* LDO8_ON_VSEL - [4:0] */
+#define WM831X_LDO8_ON_VSEL_SHIFT                    0  /* LDO8_ON_VSEL - [4:0] */
+#define WM831X_LDO8_ON_VSEL_WIDTH                    5  /* LDO8_ON_VSEL - [4:0] */
+
+/*
+ * R16511 (0x407F) - LDO8 SLEEP Control
+ */
+#define WM831X_LDO8_SLP_SLOT_MASK               0xE000  /* LDO8_SLP_SLOT - [15:13] */
+#define WM831X_LDO8_SLP_SLOT_SHIFT                  13  /* LDO8_SLP_SLOT - [15:13] */
+#define WM831X_LDO8_SLP_SLOT_WIDTH                   3  /* LDO8_SLP_SLOT - [15:13] */
+#define WM831X_LDO8_SLP_MODE                    0x0100  /* LDO8_SLP_MODE */
+#define WM831X_LDO8_SLP_MODE_MASK               0x0100  /* LDO8_SLP_MODE */
+#define WM831X_LDO8_SLP_MODE_SHIFT                   8  /* LDO8_SLP_MODE */
+#define WM831X_LDO8_SLP_MODE_WIDTH                   1  /* LDO8_SLP_MODE */
+#define WM831X_LDO8_SLP_VSEL_MASK               0x001F  /* LDO8_SLP_VSEL - [4:0] */
+#define WM831X_LDO8_SLP_VSEL_SHIFT                   0  /* LDO8_SLP_VSEL - [4:0] */
+#define WM831X_LDO8_SLP_VSEL_WIDTH                   5  /* LDO8_SLP_VSEL - [4:0] */
+
+/*
+ * R16512 (0x4080) - LDO9 Control
+ */
+#define WM831X_LDO9_ERR_ACT_MASK                0xC000  /* LDO9_ERR_ACT - [15:14] */
+#define WM831X_LDO9_ERR_ACT_SHIFT                   14  /* LDO9_ERR_ACT - [15:14] */
+#define WM831X_LDO9_ERR_ACT_WIDTH                    2  /* LDO9_ERR_ACT - [15:14] */
+#define WM831X_LDO9_HWC_SRC_MASK                0x1800  /* LDO9_HWC_SRC - [12:11] */
+#define WM831X_LDO9_HWC_SRC_SHIFT                   11  /* LDO9_HWC_SRC - [12:11] */
+#define WM831X_LDO9_HWC_SRC_WIDTH                    2  /* LDO9_HWC_SRC - [12:11] */
+#define WM831X_LDO9_HWC_VSEL                    0x0400  /* LDO9_HWC_VSEL */
+#define WM831X_LDO9_HWC_VSEL_MASK               0x0400  /* LDO9_HWC_VSEL */
+#define WM831X_LDO9_HWC_VSEL_SHIFT                  10  /* LDO9_HWC_VSEL */
+#define WM831X_LDO9_HWC_VSEL_WIDTH                   1  /* LDO9_HWC_VSEL */
+#define WM831X_LDO9_HWC_MODE_MASK               0x0300  /* LDO9_HWC_MODE - [9:8] */
+#define WM831X_LDO9_HWC_MODE_SHIFT                   8  /* LDO9_HWC_MODE - [9:8] */
+#define WM831X_LDO9_HWC_MODE_WIDTH                   2  /* LDO9_HWC_MODE - [9:8] */
+#define WM831X_LDO9_FLT                         0x0080  /* LDO9_FLT */
+#define WM831X_LDO9_FLT_MASK                    0x0080  /* LDO9_FLT */
+#define WM831X_LDO9_FLT_SHIFT                        7  /* LDO9_FLT */
+#define WM831X_LDO9_FLT_WIDTH                        1  /* LDO9_FLT */
+#define WM831X_LDO9_SWI                         0x0040  /* LDO9_SWI */
+#define WM831X_LDO9_SWI_MASK                    0x0040  /* LDO9_SWI */
+#define WM831X_LDO9_SWI_SHIFT                        6  /* LDO9_SWI */
+#define WM831X_LDO9_SWI_WIDTH                        1  /* LDO9_SWI */
+
+/*
+ * R16513 (0x4081) - LDO9 ON Control
+ */
+#define WM831X_LDO9_ON_SLOT_MASK                0xE000  /* LDO9_ON_SLOT - [15:13] */
+#define WM831X_LDO9_ON_SLOT_SHIFT                   13  /* LDO9_ON_SLOT - [15:13] */
+#define WM831X_LDO9_ON_SLOT_WIDTH                    3  /* LDO9_ON_SLOT - [15:13] */
+#define WM831X_LDO9_ON_MODE                     0x0100  /* LDO9_ON_MODE */
+#define WM831X_LDO9_ON_MODE_MASK                0x0100  /* LDO9_ON_MODE */
+#define WM831X_LDO9_ON_MODE_SHIFT                    8  /* LDO9_ON_MODE */
+#define WM831X_LDO9_ON_MODE_WIDTH                    1  /* LDO9_ON_MODE */
+#define WM831X_LDO9_ON_VSEL_MASK                0x001F  /* LDO9_ON_VSEL - [4:0] */
+#define WM831X_LDO9_ON_VSEL_SHIFT                    0  /* LDO9_ON_VSEL - [4:0] */
+#define WM831X_LDO9_ON_VSEL_WIDTH                    5  /* LDO9_ON_VSEL - [4:0] */
+
+/*
+ * R16514 (0x4082) - LDO9 SLEEP Control
+ */
+#define WM831X_LDO9_SLP_SLOT_MASK               0xE000  /* LDO9_SLP_SLOT - [15:13] */
+#define WM831X_LDO9_SLP_SLOT_SHIFT                  13  /* LDO9_SLP_SLOT - [15:13] */
+#define WM831X_LDO9_SLP_SLOT_WIDTH                   3  /* LDO9_SLP_SLOT - [15:13] */
+#define WM831X_LDO9_SLP_MODE                    0x0100  /* LDO9_SLP_MODE */
+#define WM831X_LDO9_SLP_MODE_MASK               0x0100  /* LDO9_SLP_MODE */
+#define WM831X_LDO9_SLP_MODE_SHIFT                   8  /* LDO9_SLP_MODE */
+#define WM831X_LDO9_SLP_MODE_WIDTH                   1  /* LDO9_SLP_MODE */
+#define WM831X_LDO9_SLP_VSEL_MASK               0x001F  /* LDO9_SLP_VSEL - [4:0] */
+#define WM831X_LDO9_SLP_VSEL_SHIFT                   0  /* LDO9_SLP_VSEL - [4:0] */
+#define WM831X_LDO9_SLP_VSEL_WIDTH                   5  /* LDO9_SLP_VSEL - [4:0] */
+
+/*
+ * R16515 (0x4083) - LDO10 Control
+ */
+#define WM831X_LDO10_ERR_ACT_MASK               0xC000  /* LDO10_ERR_ACT - [15:14] */
+#define WM831X_LDO10_ERR_ACT_SHIFT                  14  /* LDO10_ERR_ACT - [15:14] */
+#define WM831X_LDO10_ERR_ACT_WIDTH                   2  /* LDO10_ERR_ACT - [15:14] */
+#define WM831X_LDO10_HWC_SRC_MASK               0x1800  /* LDO10_HWC_SRC - [12:11] */
+#define WM831X_LDO10_HWC_SRC_SHIFT                  11  /* LDO10_HWC_SRC - [12:11] */
+#define WM831X_LDO10_HWC_SRC_WIDTH                   2  /* LDO10_HWC_SRC - [12:11] */
+#define WM831X_LDO10_HWC_VSEL                   0x0400  /* LDO10_HWC_VSEL */
+#define WM831X_LDO10_HWC_VSEL_MASK              0x0400  /* LDO10_HWC_VSEL */
+#define WM831X_LDO10_HWC_VSEL_SHIFT                 10  /* LDO10_HWC_VSEL */
+#define WM831X_LDO10_HWC_VSEL_WIDTH                  1  /* LDO10_HWC_VSEL */
+#define WM831X_LDO10_HWC_MODE_MASK              0x0300  /* LDO10_HWC_MODE - [9:8] */
+#define WM831X_LDO10_HWC_MODE_SHIFT                  8  /* LDO10_HWC_MODE - [9:8] */
+#define WM831X_LDO10_HWC_MODE_WIDTH                  2  /* LDO10_HWC_MODE - [9:8] */
+#define WM831X_LDO10_FLT                        0x0080  /* LDO10_FLT */
+#define WM831X_LDO10_FLT_MASK                   0x0080  /* LDO10_FLT */
+#define WM831X_LDO10_FLT_SHIFT                       7  /* LDO10_FLT */
+#define WM831X_LDO10_FLT_WIDTH                       1  /* LDO10_FLT */
+#define WM831X_LDO10_SWI                        0x0040  /* LDO10_SWI */
+#define WM831X_LDO10_SWI_MASK                   0x0040  /* LDO10_SWI */
+#define WM831X_LDO10_SWI_SHIFT                       6  /* LDO10_SWI */
+#define WM831X_LDO10_SWI_WIDTH                       1  /* LDO10_SWI */
+
+/*
+ * R16516 (0x4084) - LDO10 ON Control
+ */
+#define WM831X_LDO10_ON_SLOT_MASK               0xE000  /* LDO10_ON_SLOT - [15:13] */
+#define WM831X_LDO10_ON_SLOT_SHIFT                  13  /* LDO10_ON_SLOT - [15:13] */
+#define WM831X_LDO10_ON_SLOT_WIDTH                   3  /* LDO10_ON_SLOT - [15:13] */
+#define WM831X_LDO10_ON_MODE                    0x0100  /* LDO10_ON_MODE */
+#define WM831X_LDO10_ON_MODE_MASK               0x0100  /* LDO10_ON_MODE */
+#define WM831X_LDO10_ON_MODE_SHIFT                   8  /* LDO10_ON_MODE */
+#define WM831X_LDO10_ON_MODE_WIDTH                   1  /* LDO10_ON_MODE */
+#define WM831X_LDO10_ON_VSEL_MASK               0x001F  /* LDO10_ON_VSEL - [4:0] */
+#define WM831X_LDO10_ON_VSEL_SHIFT                   0  /* LDO10_ON_VSEL - [4:0] */
+#define WM831X_LDO10_ON_VSEL_WIDTH                   5  /* LDO10_ON_VSEL - [4:0] */
+
+/*
+ * R16517 (0x4085) - LDO10 SLEEP Control
+ */
+#define WM831X_LDO10_SLP_SLOT_MASK              0xE000  /* LDO10_SLP_SLOT - [15:13] */
+#define WM831X_LDO10_SLP_SLOT_SHIFT                 13  /* LDO10_SLP_SLOT - [15:13] */
+#define WM831X_LDO10_SLP_SLOT_WIDTH                  3  /* LDO10_SLP_SLOT - [15:13] */
+#define WM831X_LDO10_SLP_MODE                   0x0100  /* LDO10_SLP_MODE */
+#define WM831X_LDO10_SLP_MODE_MASK              0x0100  /* LDO10_SLP_MODE */
+#define WM831X_LDO10_SLP_MODE_SHIFT                  8  /* LDO10_SLP_MODE */
+#define WM831X_LDO10_SLP_MODE_WIDTH                  1  /* LDO10_SLP_MODE */
+#define WM831X_LDO10_SLP_VSEL_MASK              0x001F  /* LDO10_SLP_VSEL - [4:0] */
+#define WM831X_LDO10_SLP_VSEL_SHIFT                  0  /* LDO10_SLP_VSEL - [4:0] */
+#define WM831X_LDO10_SLP_VSEL_WIDTH                  5  /* LDO10_SLP_VSEL - [4:0] */
+
+/*
+ * R16519 (0x4087) - LDO11 ON Control
+ */
+#define WM831X_LDO11_ON_SLOT_MASK               0xE000  /* LDO11_ON_SLOT - [15:13] */
+#define WM831X_LDO11_ON_SLOT_SHIFT                  13  /* LDO11_ON_SLOT - [15:13] */
+#define WM831X_LDO11_ON_SLOT_WIDTH                   3  /* LDO11_ON_SLOT - [15:13] */
+#define WM831X_LDO11_OFFENA                     0x1000  /* LDO11_OFFENA */
+#define WM831X_LDO11_OFFENA_MASK                0x1000  /* LDO11_OFFENA */
+#define WM831X_LDO11_OFFENA_SHIFT                   12  /* LDO11_OFFENA */
+#define WM831X_LDO11_OFFENA_WIDTH                    1  /* LDO11_OFFENA */
+#define WM831X_LDO11_VSEL_SRC                   0x0080  /* LDO11_VSEL_SRC */
+#define WM831X_LDO11_VSEL_SRC_MASK              0x0080  /* LDO11_VSEL_SRC */
+#define WM831X_LDO11_VSEL_SRC_SHIFT                  7  /* LDO11_VSEL_SRC */
+#define WM831X_LDO11_VSEL_SRC_WIDTH                  1  /* LDO11_VSEL_SRC */
+#define WM831X_LDO11_ON_VSEL_MASK               0x000F  /* LDO11_ON_VSEL - [3:0] */
+#define WM831X_LDO11_ON_VSEL_SHIFT                   0  /* LDO11_ON_VSEL - [3:0] */
+#define WM831X_LDO11_ON_VSEL_WIDTH                   4  /* LDO11_ON_VSEL - [3:0] */
+
+/*
+ * R16520 (0x4088) - LDO11 SLEEP Control
+ */
+#define WM831X_LDO11_SLP_SLOT_MASK              0xE000  /* LDO11_SLP_SLOT - [15:13] */
+#define WM831X_LDO11_SLP_SLOT_SHIFT                 13  /* LDO11_SLP_SLOT - [15:13] */
+#define WM831X_LDO11_SLP_SLOT_WIDTH                  3  /* LDO11_SLP_SLOT - [15:13] */
+#define WM831X_LDO11_SLP_VSEL_MASK              0x000F  /* LDO11_SLP_VSEL - [3:0] */
+#define WM831X_LDO11_SLP_VSEL_SHIFT                  0  /* LDO11_SLP_VSEL - [3:0] */
+#define WM831X_LDO11_SLP_VSEL_WIDTH                  4  /* LDO11_SLP_VSEL - [3:0] */
+
+/*
  * R16526 (0x408E) - Power Good Source 1
  */
 #define WM831X_DC4_OK                           0x0008  /* DC4_OK */
@@ -586,6 +1168,50 @@
 #define WM831X_DC1_OK_SHIFT                          0  /* DC1_OK */
 #define WM831X_DC1_OK_WIDTH                          1  /* DC1_OK */
 
+/*
+ * R16527 (0x408F) - Power Good Source 2
+ */
+#define WM831X_LDO10_OK                         0x0200  /* LDO10_OK */
+#define WM831X_LDO10_OK_MASK                    0x0200  /* LDO10_OK */
+#define WM831X_LDO10_OK_SHIFT                        9  /* LDO10_OK */
+#define WM831X_LDO10_OK_WIDTH                        1  /* LDO10_OK */
+#define WM831X_LDO9_OK                          0x0100  /* LDO9_OK */
+#define WM831X_LDO9_OK_MASK                     0x0100  /* LDO9_OK */
+#define WM831X_LDO9_OK_SHIFT                         8  /* LDO9_OK */
+#define WM831X_LDO9_OK_WIDTH                         1  /* LDO9_OK */
+#define WM831X_LDO8_OK                          0x0080  /* LDO8_OK */
+#define WM831X_LDO8_OK_MASK                     0x0080  /* LDO8_OK */
+#define WM831X_LDO8_OK_SHIFT                         7  /* LDO8_OK */
+#define WM831X_LDO8_OK_WIDTH                         1  /* LDO8_OK */
+#define WM831X_LDO7_OK                          0x0040  /* LDO7_OK */
+#define WM831X_LDO7_OK_MASK                     0x0040  /* LDO7_OK */
+#define WM831X_LDO7_OK_SHIFT                         6  /* LDO7_OK */
+#define WM831X_LDO7_OK_WIDTH                         1  /* LDO7_OK */
+#define WM831X_LDO6_OK                          0x0020  /* LDO6_OK */
+#define WM831X_LDO6_OK_MASK                     0x0020  /* LDO6_OK */
+#define WM831X_LDO6_OK_SHIFT                         5  /* LDO6_OK */
+#define WM831X_LDO6_OK_WIDTH                         1  /* LDO6_OK */
+#define WM831X_LDO5_OK                          0x0010  /* LDO5_OK */
+#define WM831X_LDO5_OK_MASK                     0x0010  /* LDO5_OK */
+#define WM831X_LDO5_OK_SHIFT                         4  /* LDO5_OK */
+#define WM831X_LDO5_OK_WIDTH                         1  /* LDO5_OK */
+#define WM831X_LDO4_OK                          0x0008  /* LDO4_OK */
+#define WM831X_LDO4_OK_MASK                     0x0008  /* LDO4_OK */
+#define WM831X_LDO4_OK_SHIFT                         3  /* LDO4_OK */
+#define WM831X_LDO4_OK_WIDTH                         1  /* LDO4_OK */
+#define WM831X_LDO3_OK                          0x0004  /* LDO3_OK */
+#define WM831X_LDO3_OK_MASK                     0x0004  /* LDO3_OK */
+#define WM831X_LDO3_OK_SHIFT                         2  /* LDO3_OK */
+#define WM831X_LDO3_OK_WIDTH                         1  /* LDO3_OK */
+#define WM831X_LDO2_OK                          0x0002  /* LDO2_OK */
+#define WM831X_LDO2_OK_MASK                     0x0002  /* LDO2_OK */
+#define WM831X_LDO2_OK_SHIFT                         1  /* LDO2_OK */
+#define WM831X_LDO2_OK_WIDTH                         1  /* LDO2_OK */
+#define WM831X_LDO1_OK                          0x0001  /* LDO1_OK */
+#define WM831X_LDO1_OK_MASK                     0x0001  /* LDO1_OK */
+#define WM831X_LDO1_OK_SHIFT                         0  /* LDO1_OK */
+#define WM831X_LDO1_OK_WIDTH                         1  /* LDO1_OK */
+
 #define WM831X_ISINK_MAX_ISEL 56
 extern int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL];
 
-- 
1.6.3.3

