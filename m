Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZG0Nq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZG0Nq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZG0Nq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59154 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754806AbZG0Nqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:32 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 16/22] regulator: Add WM831x DC-DC buck convertor support
Date: Mon, 27 Jul 2009 14:46:06 +0100
Message-Id: <1248702372-29534-16-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of devices all have 3 DC-DC buck convertors. This
driver implements software control for these regulators via the
regulator API.  Use with split hardware/software control of individual
regulators is not supported, though regulators not controlled by
software may be controlled via the hardware control interfaces.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/Kconfig            |    7 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/wm831x-dcdc.c      |  643 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/regulator.h |  571 ++++++++++++++++++++++++++++++
 4 files changed, 1222 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/wm831x-dcdc.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index da7483e..38ea5dc 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -82,6 +82,13 @@ config REGULATOR_TWL4030
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
 
+config REGULATOR_WM831X
+	tristate "Wolfson Microelcronics WM831x PMIC regulators"
+	depends on MFD_WM831X
+	help
+	  Support the voltage and current regulators of the WM831x series
+	  of PMIC devices.
+
 config REGULATOR_WM8350
 	tristate "Wolfson Microelectroncis WM8350 AudioPlus PMIC"
 	depends on MFD_WM8350
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 3a9748f..b1d2b82 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
+obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
new file mode 100644
index 0000000..97a7877
--- /dev/null
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -0,0 +1,643 @@
+/*
+ * wm831x-dcdc.c  --  DC-DC buck convertor driver for the WM831x series
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
+#define WM831X_BUCKV_MAX_SELECTOR 0x68
+#define WM831X_BUCKP_MAX_SELECTOR 0x66
+
+#define WM831X_DCDC_MODE_FAST    0
+#define WM831X_DCDC_MODE_NORMAL  1
+#define WM831X_DCDC_MODE_IDLE    2
+#define WM831X_DCDC_MODE_STANDBY 3
+
+#define WM831X_DCDC_MAX_NAME 6
+
+/* Register offsets in control block */
+#define WM831X_DCDC_CONTROL_1     0
+#define WM831X_DCDC_CONTROL_2     1
+#define WM831X_DCDC_ON_CONFIG     2
+#define WM831X_DCDC_SLEEP_CONTROL 3
+
+/*
+ * Shared
+ */
+
+struct wm831x_dcdc {
+	char name[WM831X_DCDC_MAX_NAME];
+	struct regulator_desc desc;
+	int base;
+	struct wm831x *wm831x;
+	struct regulator_dev *regulator;
+};
+
+static int wm831x_dcdc_is_enabled(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+	int reg;
+
+	reg = wm831x_reg_read(wm831x, WM831X_DCDC_ENABLE);
+	if (reg < 0)
+		return reg;
+
+	if (reg & mask)
+		return 1;
+	else
+		return 0;
+}
+
+static int wm831x_dcdc_enable(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+
+	return wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, mask, mask);
+}
+
+static int wm831x_dcdc_disable(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	int mask = 1 << rdev_get_id(rdev);
+
+	return wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, mask, 0);
+}
+
+static unsigned int wm831x_dcdc_get_mode(struct regulator_dev *rdev)
+
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+	int val;
+
+	val = wm831x_reg_read(wm831x, reg);
+	if (val < 0)
+		return val;
+
+	val = (val & WM831X_DC1_ON_MODE_MASK) >> WM831X_DC1_ON_MODE_SHIFT;
+
+	switch (val) {
+	case WM831X_DCDC_MODE_FAST:
+		return REGULATOR_MODE_FAST;
+	case WM831X_DCDC_MODE_NORMAL:
+		return REGULATOR_MODE_NORMAL;
+	case WM831X_DCDC_MODE_STANDBY:
+		return REGULATOR_MODE_STANDBY;
+	case WM831X_DCDC_MODE_IDLE:
+		return REGULATOR_MODE_IDLE;
+	default:
+		BUG();
+	}
+}
+
+static int wm831x_dcdc_set_mode_int(struct wm831x *wm831x, int reg,
+				    unsigned int mode)
+{
+	int val;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = WM831X_DCDC_MODE_FAST;
+		break;
+	case REGULATOR_MODE_NORMAL:
+		val = WM831X_DCDC_MODE_NORMAL;
+		break;
+	case REGULATOR_MODE_STANDBY:
+		val = WM831X_DCDC_MODE_STANDBY;
+		break;
+	case REGULATOR_MODE_IDLE:
+		val = WM831X_DCDC_MODE_IDLE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return wm831x_set_bits(wm831x, reg, WM831X_DC1_ON_MODE_MASK,
+			       val << WM831X_DC1_ON_MODE_SHIFT);
+}
+
+static int wm831x_dcdc_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+
+	return wm831x_dcdc_set_mode_int(wm831x, reg, mode);
+}
+
+static int wm831x_dcdc_set_suspend_mode(struct regulator_dev *rdev,
+					unsigned int mode)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
+
+	return wm831x_dcdc_set_mode_int(wm831x, reg, mode);
+}
+
+static int wm831x_dcdc_get_status(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	int ret;
+
+	/* First, check for errors */
+	ret = wm831x_reg_read(wm831x, WM831X_DCDC_UV_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & (1 << rdev_get_id(rdev))) {
+		dev_dbg(wm831x->dev, "DCDC%d under voltage\n",
+			rdev_get_id(rdev) + 1);
+		return REGULATOR_STATUS_ERROR;
+	}
+
+	/* DCDC1 and DCDC2 can additionally detect high voltage/current */
+	if (rdev_get_id(rdev) < 2) {
+		if (ret & (WM831X_DC1_OV_STS << rdev_get_id(rdev))) {
+			dev_dbg(wm831x->dev, "DCDC%d over voltage\n",
+				rdev_get_id(rdev) + 1);
+			return REGULATOR_STATUS_ERROR;
+		}
+
+		if (ret & (WM831X_DC1_HC_STS << rdev_get_id(rdev))) {
+			dev_dbg(wm831x->dev, "DCDC%d over current\n",
+				rdev_get_id(rdev) + 1);
+			return REGULATOR_STATUS_ERROR;
+		}
+	}
+
+	/* Is the regulator on? */
+	ret = wm831x_reg_read(wm831x, WM831X_DCDC_STATUS);
+	if (ret < 0)
+		return ret;
+	if (!(ret & (1 << rdev_get_id(rdev))))
+		return REGULATOR_STATUS_OFF;
+
+	/* TODO: When we handle hardware control modes so we can report the
+	 * current mode. */
+	return REGULATOR_STATUS_ON;
+}
+
+static irqreturn_t wm831x_dcdc_uv_irq(int irq, void *data)
+{
+	struct wm831x_dcdc *dcdc = data;
+
+	regulator_notifier_call_chain(dcdc->regulator,
+				      REGULATOR_EVENT_UNDER_VOLTAGE,
+				      NULL);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wm831x_dcdc_oc_irq(int irq, void *data)
+{
+	struct wm831x_dcdc *dcdc = data;
+
+	regulator_notifier_call_chain(dcdc->regulator,
+				      REGULATOR_EVENT_OVER_CURRENT,
+				      NULL);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * BUCKV specifics
+ */
+
+static int wm831x_buckv_list_voltage(struct regulator_dev *rdev,
+				      unsigned selector)
+{
+	if (selector <= 0x8)
+		return 600000;
+	if (selector <= WM831X_BUCKV_MAX_SELECTOR)
+		return 600000 + ((selector - 0x8) * 12500);
+	return -EINVAL;
+}
+
+static int wm831x_buckv_set_voltage_int(struct regulator_dev *rdev, int reg,
+					 int min_uV, int max_uV)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 vsel;
+
+	if (min_uV < 600000)
+		vsel = 0;
+	else if (min_uV <= 1800000)
+		vsel = ((min_uV - 600000) / 12500) + 8;
+	else
+		return -EINVAL;
+
+	if (wm831x_buckv_list_voltage(rdev, vsel) > max_uV)
+		return -EINVAL;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_DC1_ON_VSEL_MASK, vsel);
+}
+
+static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
+				     int min_uV, int max_uV)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+
+	return wm831x_buckv_set_voltage_int(rdev, reg, min_uV, max_uV);
+}
+
+static int wm831x_buckv_set_suspend_voltage(struct regulator_dev *rdev,
+					     int uV)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
+
+	return wm831x_buckv_set_voltage_int(rdev, reg, uV, uV);
+}
+
+static int wm831x_buckv_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+	int val;
+
+	val = wm831x_reg_read(wm831x, reg);
+	if (val < 0)
+		return val;
+
+	return wm831x_buckv_list_voltage(rdev, val & WM831X_DC1_ON_VSEL_MASK);
+}
+
+/* Current limit options */
+static u16 wm831x_dcdc_ilim[] = {
+	125, 250, 375, 500, 625, 750, 875, 1000
+};
+
+static int wm831x_buckv_set_current_limit(struct regulator_dev *rdev,
+					   int min_uA, int max_uA)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_CONTROL_2;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_dcdc_ilim); i++) {
+		if (max_uA <= wm831x_dcdc_ilim[i])
+			break;
+	}
+	if (i == ARRAY_SIZE(wm831x_dcdc_ilim))
+		return -EINVAL;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_DC1_HC_THR_MASK, i);
+}
+
+static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_CONTROL_2;
+	int val;
+
+	val = wm831x_reg_read(wm831x, reg);
+	if (val < 0)
+		return val;
+
+	return wm831x_dcdc_ilim[val & WM831X_DC1_HC_THR_MASK];
+}
+
+static struct regulator_ops wm831x_buckv_ops = {
+	.set_voltage = wm831x_buckv_set_voltage,
+	.get_voltage = wm831x_buckv_get_voltage,
+	.list_voltage = wm831x_buckv_list_voltage,
+	.set_suspend_voltage = wm831x_buckv_set_suspend_voltage,
+	.set_current_limit = wm831x_buckv_set_current_limit,
+	.get_current_limit = wm831x_buckv_get_current_limit,
+
+	.is_enabled = wm831x_dcdc_is_enabled,
+	.enable = wm831x_dcdc_enable,
+	.disable = wm831x_dcdc_disable,
+	.get_status = wm831x_dcdc_get_status,
+	.get_mode = wm831x_dcdc_get_mode,
+	.set_mode = wm831x_dcdc_set_mode,
+	.set_suspend_mode = wm831x_dcdc_set_suspend_mode,
+};
+
+static __devinit int wm831x_buckv_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
+	struct wm831x_dcdc *dcdc;
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
+
+	if (pdata->dcdc[id] == NULL)
+		return -ENODEV;
+
+	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	if (dcdc == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	dcdc->wm831x = wm831x;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	dcdc->base = res->start;
+
+	snprintf(dcdc->name, sizeof(dcdc->name), "DCDC%d", id + 1);
+	dcdc->desc.name = dcdc->name;
+	dcdc->desc.id = id;
+	dcdc->desc.type = REGULATOR_VOLTAGE;
+	dcdc->desc.n_voltages = WM831X_BUCKV_MAX_SELECTOR + 1;
+	dcdc->desc.ops = &wm831x_buckv_ops;
+	dcdc->desc.owner = THIS_MODULE;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
+					     pdata->dcdc[id], dcdc);
+	if (IS_ERR(dcdc->regulator)) {
+		ret = PTR_ERR(dcdc->regulator);
+		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	irq = platform_get_irq_byname(pdev, "UV");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_uv_irq,
+				 IRQF_TRIGGER_RISING, dcdc->name,
+				 dcdc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
+			irq, ret);
+		goto err_regulator;
+	}
+
+	irq = platform_get_irq_byname(pdev, "HC");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_oc_irq,
+				 IRQF_TRIGGER_RISING, dcdc->name,
+				 dcdc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request HC IRQ %d: %d\n",
+			irq, ret);
+		goto err_uv;
+	}
+
+	platform_set_drvdata(pdev, dcdc);
+
+	return 0;
+
+err_uv:
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+err_regulator:
+	regulator_unregister(dcdc->regulator);
+err:
+	kfree(dcdc);
+	return ret;
+}
+
+static __devexit int wm831x_buckv_remove(struct platform_device *pdev)
+{
+	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "HC"), dcdc);
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	regulator_unregister(dcdc->regulator);
+	kfree(dcdc);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_buckv_driver = {
+	.probe = wm831x_buckv_probe,
+	.remove = __devexit_p(wm831x_buckv_remove),
+	.driver		= {
+		.name	= "wm831x-buckv",
+	},
+};
+
+/*
+ * BUCKP specifics
+ */
+
+static int wm831x_buckp_list_voltage(struct regulator_dev *rdev,
+				      unsigned selector)
+{
+	if (selector <= WM831X_BUCKP_MAX_SELECTOR)
+		return 850000 + (selector * 25000);
+	else
+		return -EINVAL;
+}
+
+static int wm831x_buckp_set_voltage_int(struct regulator_dev *rdev, int reg,
+					int min_uV, int max_uV)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 vsel;
+
+	if (min_uV <= 34000000)
+		vsel = (min_uV - 850000) / 25000;
+	else
+		return -EINVAL;
+
+	if (wm831x_buckp_list_voltage(rdev, vsel) > max_uV)
+		return -EINVAL;
+
+	return wm831x_set_bits(wm831x, reg, WM831X_DC3_ON_VSEL_MASK, vsel);
+}
+
+static int wm831x_buckp_set_voltage(struct regulator_dev *rdev,
+				    int min_uV, int max_uV)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+
+	return wm831x_buckp_set_voltage_int(rdev, reg, min_uV, max_uV);
+}
+
+static int wm831x_buckp_set_suspend_voltage(struct regulator_dev *rdev,
+					    int uV)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	u16 reg = dcdc->base + WM831X_DCDC_SLEEP_CONTROL;
+
+	return wm831x_buckp_set_voltage_int(rdev, reg, uV, uV);
+}
+
+static int wm831x_buckp_get_voltage(struct regulator_dev *rdev)
+{
+	struct wm831x_dcdc *dcdc = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+	u16 reg = dcdc->base + WM831X_DCDC_ON_CONFIG;
+	int val;
+
+	val = wm831x_reg_read(wm831x, reg);
+	if (val < 0)
+		return val;
+
+	return wm831x_buckp_list_voltage(rdev, val & WM831X_DC3_ON_VSEL_MASK);
+}
+
+static struct regulator_ops wm831x_buckp_ops = {
+	.set_voltage = wm831x_buckp_set_voltage,
+	.get_voltage = wm831x_buckp_get_voltage,
+	.list_voltage = wm831x_buckp_list_voltage,
+	.set_suspend_voltage = wm831x_buckp_set_suspend_voltage,
+
+	.is_enabled = wm831x_dcdc_is_enabled,
+	.enable = wm831x_dcdc_enable,
+	.disable = wm831x_dcdc_disable,
+	.get_status = wm831x_dcdc_get_status,
+	.get_mode = wm831x_dcdc_get_mode,
+	.set_mode = wm831x_dcdc_set_mode,
+	.set_suspend_mode = wm831x_dcdc_set_suspend_mode,
+};
+
+static __devinit int wm831x_buckp_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	int id = pdev->id % ARRAY_SIZE(pdata->dcdc);
+	struct wm831x_dcdc *dcdc;
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(&pdev->dev, "Probing DCDC%d\n", id + 1);
+
+	if (pdata->dcdc[id] == NULL)
+		return -ENODEV;
+
+	dcdc = kzalloc(sizeof(struct wm831x_dcdc), GFP_KERNEL);
+	if (dcdc == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	dcdc->wm831x = wm831x;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	dcdc->base = res->start;
+
+	snprintf(dcdc->name, sizeof(dcdc->name), "DCDC%d", id + 1);
+	dcdc->desc.name = dcdc->name;
+	dcdc->desc.id = id;
+	dcdc->desc.type = REGULATOR_VOLTAGE;
+	dcdc->desc.n_voltages = WM831X_BUCKP_MAX_SELECTOR + 1;
+	dcdc->desc.ops = &wm831x_buckp_ops;
+	dcdc->desc.owner = THIS_MODULE;
+
+	dcdc->regulator = regulator_register(&dcdc->desc, &pdev->dev,
+					     pdata->dcdc[id], dcdc);
+	if (IS_ERR(dcdc->regulator)) {
+		ret = PTR_ERR(dcdc->regulator);
+		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	irq = platform_get_irq_byname(pdev, "UV");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_dcdc_uv_irq,
+				 IRQF_TRIGGER_RISING, dcdc->name,
+				 dcdc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
+			irq, ret);
+		goto err_regulator;
+	}
+
+	platform_set_drvdata(pdev, dcdc);
+
+	return 0;
+
+err_regulator:
+	regulator_unregister(dcdc->regulator);
+err:
+	kfree(dcdc);
+	return ret;
+}
+
+static __devexit int wm831x_buckp_remove(struct platform_device *pdev)
+{
+	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = dcdc->wm831x;
+
+	wm831x_free_irq(wm831x, platform_get_irq_byname(pdev, "UV"), dcdc);
+	regulator_unregister(dcdc->regulator);
+	kfree(dcdc);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_buckp_driver = {
+	.probe = wm831x_buckp_probe,
+	.remove = __devexit_p(wm831x_buckp_remove),
+	.driver		= {
+		.name	= "wm831x-buckp",
+	},
+};
+
+static int __init wm831x_dcdc_init(void)
+{
+	int ret;
+	ret = platform_driver_register(&wm831x_buckv_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x BUCKV driver: %d\n", ret);
+
+	ret = platform_driver_register(&wm831x_buckp_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x BUCKP driver: %d\n", ret);
+
+	return 0;
+}
+subsys_initcall(wm831x_dcdc_init);
+
+static void __exit wm831x_dcdc_exit(void)
+{
+	platform_driver_unregister(&wm831x_buckp_driver);
+	platform_driver_unregister(&wm831x_buckv_driver);
+}
+module_exit(wm831x_dcdc_exit);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM831x DC-DC convertor driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-buckv");
+MODULE_ALIAS("platform:wm831x-buckp");
diff --git a/include/linux/mfd/wm831x/regulator.h b/include/linux/mfd/wm831x/regulator.h
index b5d58fb..c74d6aa 100644
--- a/include/linux/mfd/wm831x/regulator.h
+++ b/include/linux/mfd/wm831x/regulator.h
@@ -15,6 +15,577 @@
 #ifndef __MFD_WM831X_REGULATOR_H__
 #define __MFD_WM831X_REGULATOR_H__
 
+/*
+ * R16462 (0x404E) - Current Sink 1
+ */
+#define WM831X_CS1_ENA                          0x8000  /* CS1_ENA */
+#define WM831X_CS1_ENA_MASK                     0x8000  /* CS1_ENA */
+#define WM831X_CS1_ENA_SHIFT                        15  /* CS1_ENA */
+#define WM831X_CS1_ENA_WIDTH                         1  /* CS1_ENA */
+#define WM831X_CS1_DRIVE                        0x4000  /* CS1_DRIVE */
+#define WM831X_CS1_DRIVE_MASK                   0x4000  /* CS1_DRIVE */
+#define WM831X_CS1_DRIVE_SHIFT                      14  /* CS1_DRIVE */
+#define WM831X_CS1_DRIVE_WIDTH                       1  /* CS1_DRIVE */
+#define WM831X_CS1_SLPENA                       0x1000  /* CS1_SLPENA */
+#define WM831X_CS1_SLPENA_MASK                  0x1000  /* CS1_SLPENA */
+#define WM831X_CS1_SLPENA_SHIFT                     12  /* CS1_SLPENA */
+#define WM831X_CS1_SLPENA_WIDTH                      1  /* CS1_SLPENA */
+#define WM831X_CS1_OFF_RAMP_MASK                0x0C00  /* CS1_OFF_RAMP - [11:10] */
+#define WM831X_CS1_OFF_RAMP_SHIFT                   10  /* CS1_OFF_RAMP - [11:10] */
+#define WM831X_CS1_OFF_RAMP_WIDTH                    2  /* CS1_OFF_RAMP - [11:10] */
+#define WM831X_CS1_ON_RAMP_MASK                 0x0300  /* CS1_ON_RAMP - [9:8] */
+#define WM831X_CS1_ON_RAMP_SHIFT                     8  /* CS1_ON_RAMP - [9:8] */
+#define WM831X_CS1_ON_RAMP_WIDTH                     2  /* CS1_ON_RAMP - [9:8] */
+#define WM831X_CS1_ISEL_MASK                    0x003F  /* CS1_ISEL - [5:0] */
+#define WM831X_CS1_ISEL_SHIFT                        0  /* CS1_ISEL - [5:0] */
+#define WM831X_CS1_ISEL_WIDTH                        6  /* CS1_ISEL - [5:0] */
+
+/*
+ * R16463 (0x404F) - Current Sink 2
+ */
+#define WM831X_CS2_ENA                          0x8000  /* CS2_ENA */
+#define WM831X_CS2_ENA_MASK                     0x8000  /* CS2_ENA */
+#define WM831X_CS2_ENA_SHIFT                        15  /* CS2_ENA */
+#define WM831X_CS2_ENA_WIDTH                         1  /* CS2_ENA */
+#define WM831X_CS2_DRIVE                        0x4000  /* CS2_DRIVE */
+#define WM831X_CS2_DRIVE_MASK                   0x4000  /* CS2_DRIVE */
+#define WM831X_CS2_DRIVE_SHIFT                      14  /* CS2_DRIVE */
+#define WM831X_CS2_DRIVE_WIDTH                       1  /* CS2_DRIVE */
+#define WM831X_CS2_SLPENA                       0x1000  /* CS2_SLPENA */
+#define WM831X_CS2_SLPENA_MASK                  0x1000  /* CS2_SLPENA */
+#define WM831X_CS2_SLPENA_SHIFT                     12  /* CS2_SLPENA */
+#define WM831X_CS2_SLPENA_WIDTH                      1  /* CS2_SLPENA */
+#define WM831X_CS2_OFF_RAMP_MASK                0x0C00  /* CS2_OFF_RAMP - [11:10] */
+#define WM831X_CS2_OFF_RAMP_SHIFT                   10  /* CS2_OFF_RAMP - [11:10] */
+#define WM831X_CS2_OFF_RAMP_WIDTH                    2  /* CS2_OFF_RAMP - [11:10] */
+#define WM831X_CS2_ON_RAMP_MASK                 0x0300  /* CS2_ON_RAMP - [9:8] */
+#define WM831X_CS2_ON_RAMP_SHIFT                     8  /* CS2_ON_RAMP - [9:8] */
+#define WM831X_CS2_ON_RAMP_WIDTH                     2  /* CS2_ON_RAMP - [9:8] */
+#define WM831X_CS2_ISEL_MASK                    0x003F  /* CS2_ISEL - [5:0] */
+#define WM831X_CS2_ISEL_SHIFT                        0  /* CS2_ISEL - [5:0] */
+#define WM831X_CS2_ISEL_WIDTH                        6  /* CS2_ISEL - [5:0] */
+
+/*
+ * R16464 (0x4050) - DCDC Enable
+ */
+#define WM831X_EPE2_ENA                         0x0080  /* EPE2_ENA */
+#define WM831X_EPE2_ENA_MASK                    0x0080  /* EPE2_ENA */
+#define WM831X_EPE2_ENA_SHIFT                        7  /* EPE2_ENA */
+#define WM831X_EPE2_ENA_WIDTH                        1  /* EPE2_ENA */
+#define WM831X_EPE1_ENA                         0x0040  /* EPE1_ENA */
+#define WM831X_EPE1_ENA_MASK                    0x0040  /* EPE1_ENA */
+#define WM831X_EPE1_ENA_SHIFT                        6  /* EPE1_ENA */
+#define WM831X_EPE1_ENA_WIDTH                        1  /* EPE1_ENA */
+#define WM831X_DC4_ENA                          0x0008  /* DC4_ENA */
+#define WM831X_DC4_ENA_MASK                     0x0008  /* DC4_ENA */
+#define WM831X_DC4_ENA_SHIFT                         3  /* DC4_ENA */
+#define WM831X_DC4_ENA_WIDTH                         1  /* DC4_ENA */
+#define WM831X_DC3_ENA                          0x0004  /* DC3_ENA */
+#define WM831X_DC3_ENA_MASK                     0x0004  /* DC3_ENA */
+#define WM831X_DC3_ENA_SHIFT                         2  /* DC3_ENA */
+#define WM831X_DC3_ENA_WIDTH                         1  /* DC3_ENA */
+#define WM831X_DC2_ENA                          0x0002  /* DC2_ENA */
+#define WM831X_DC2_ENA_MASK                     0x0002  /* DC2_ENA */
+#define WM831X_DC2_ENA_SHIFT                         1  /* DC2_ENA */
+#define WM831X_DC2_ENA_WIDTH                         1  /* DC2_ENA */
+#define WM831X_DC1_ENA                          0x0001  /* DC1_ENA */
+#define WM831X_DC1_ENA_MASK                     0x0001  /* DC1_ENA */
+#define WM831X_DC1_ENA_SHIFT                         0  /* DC1_ENA */
+#define WM831X_DC1_ENA_WIDTH                         1  /* DC1_ENA */
+
+/*
+ * R16465 (0x4051) - LDO Enable
+ */
+#define WM831X_LDO11_ENA                        0x0400  /* LDO11_ENA */
+#define WM831X_LDO11_ENA_MASK                   0x0400  /* LDO11_ENA */
+#define WM831X_LDO11_ENA_SHIFT                      10  /* LDO11_ENA */
+#define WM831X_LDO11_ENA_WIDTH                       1  /* LDO11_ENA */
+#define WM831X_LDO10_ENA                        0x0200  /* LDO10_ENA */
+#define WM831X_LDO10_ENA_MASK                   0x0200  /* LDO10_ENA */
+#define WM831X_LDO10_ENA_SHIFT                       9  /* LDO10_ENA */
+#define WM831X_LDO10_ENA_WIDTH                       1  /* LDO10_ENA */
+#define WM831X_LDO9_ENA                         0x0100  /* LDO9_ENA */
+#define WM831X_LDO9_ENA_MASK                    0x0100  /* LDO9_ENA */
+#define WM831X_LDO9_ENA_SHIFT                        8  /* LDO9_ENA */
+#define WM831X_LDO9_ENA_WIDTH                        1  /* LDO9_ENA */
+#define WM831X_LDO8_ENA                         0x0080  /* LDO8_ENA */
+#define WM831X_LDO8_ENA_MASK                    0x0080  /* LDO8_ENA */
+#define WM831X_LDO8_ENA_SHIFT                        7  /* LDO8_ENA */
+#define WM831X_LDO8_ENA_WIDTH                        1  /* LDO8_ENA */
+#define WM831X_LDO7_ENA                         0x0040  /* LDO7_ENA */
+#define WM831X_LDO7_ENA_MASK                    0x0040  /* LDO7_ENA */
+#define WM831X_LDO7_ENA_SHIFT                        6  /* LDO7_ENA */
+#define WM831X_LDO7_ENA_WIDTH                        1  /* LDO7_ENA */
+#define WM831X_LDO6_ENA                         0x0020  /* LDO6_ENA */
+#define WM831X_LDO6_ENA_MASK                    0x0020  /* LDO6_ENA */
+#define WM831X_LDO6_ENA_SHIFT                        5  /* LDO6_ENA */
+#define WM831X_LDO6_ENA_WIDTH                        1  /* LDO6_ENA */
+#define WM831X_LDO5_ENA                         0x0010  /* LDO5_ENA */
+#define WM831X_LDO5_ENA_MASK                    0x0010  /* LDO5_ENA */
+#define WM831X_LDO5_ENA_SHIFT                        4  /* LDO5_ENA */
+#define WM831X_LDO5_ENA_WIDTH                        1  /* LDO5_ENA */
+#define WM831X_LDO4_ENA                         0x0008  /* LDO4_ENA */
+#define WM831X_LDO4_ENA_MASK                    0x0008  /* LDO4_ENA */
+#define WM831X_LDO4_ENA_SHIFT                        3  /* LDO4_ENA */
+#define WM831X_LDO4_ENA_WIDTH                        1  /* LDO4_ENA */
+#define WM831X_LDO3_ENA                         0x0004  /* LDO3_ENA */
+#define WM831X_LDO3_ENA_MASK                    0x0004  /* LDO3_ENA */
+#define WM831X_LDO3_ENA_SHIFT                        2  /* LDO3_ENA */
+#define WM831X_LDO3_ENA_WIDTH                        1  /* LDO3_ENA */
+#define WM831X_LDO2_ENA                         0x0002  /* LDO2_ENA */
+#define WM831X_LDO2_ENA_MASK                    0x0002  /* LDO2_ENA */
+#define WM831X_LDO2_ENA_SHIFT                        1  /* LDO2_ENA */
+#define WM831X_LDO2_ENA_WIDTH                        1  /* LDO2_ENA */
+#define WM831X_LDO1_ENA                         0x0001  /* LDO1_ENA */
+#define WM831X_LDO1_ENA_MASK                    0x0001  /* LDO1_ENA */
+#define WM831X_LDO1_ENA_SHIFT                        0  /* LDO1_ENA */
+#define WM831X_LDO1_ENA_WIDTH                        1  /* LDO1_ENA */
+
+/*
+ * R16466 (0x4052) - DCDC Status
+ */
+#define WM831X_EPE2_STS                         0x0080  /* EPE2_STS */
+#define WM831X_EPE2_STS_MASK                    0x0080  /* EPE2_STS */
+#define WM831X_EPE2_STS_SHIFT                        7  /* EPE2_STS */
+#define WM831X_EPE2_STS_WIDTH                        1  /* EPE2_STS */
+#define WM831X_EPE1_STS                         0x0040  /* EPE1_STS */
+#define WM831X_EPE1_STS_MASK                    0x0040  /* EPE1_STS */
+#define WM831X_EPE1_STS_SHIFT                        6  /* EPE1_STS */
+#define WM831X_EPE1_STS_WIDTH                        1  /* EPE1_STS */
+#define WM831X_DC4_STS                          0x0008  /* DC4_STS */
+#define WM831X_DC4_STS_MASK                     0x0008  /* DC4_STS */
+#define WM831X_DC4_STS_SHIFT                         3  /* DC4_STS */
+#define WM831X_DC4_STS_WIDTH                         1  /* DC4_STS */
+#define WM831X_DC3_STS                          0x0004  /* DC3_STS */
+#define WM831X_DC3_STS_MASK                     0x0004  /* DC3_STS */
+#define WM831X_DC3_STS_SHIFT                         2  /* DC3_STS */
+#define WM831X_DC3_STS_WIDTH                         1  /* DC3_STS */
+#define WM831X_DC2_STS                          0x0002  /* DC2_STS */
+#define WM831X_DC2_STS_MASK                     0x0002  /* DC2_STS */
+#define WM831X_DC2_STS_SHIFT                         1  /* DC2_STS */
+#define WM831X_DC2_STS_WIDTH                         1  /* DC2_STS */
+#define WM831X_DC1_STS                          0x0001  /* DC1_STS */
+#define WM831X_DC1_STS_MASK                     0x0001  /* DC1_STS */
+#define WM831X_DC1_STS_SHIFT                         0  /* DC1_STS */
+#define WM831X_DC1_STS_WIDTH                         1  /* DC1_STS */
+
+/*
+ * R16467 (0x4053) - LDO Status
+ */
+#define WM831X_LDO11_STS                        0x0400  /* LDO11_STS */
+#define WM831X_LDO11_STS_MASK                   0x0400  /* LDO11_STS */
+#define WM831X_LDO11_STS_SHIFT                      10  /* LDO11_STS */
+#define WM831X_LDO11_STS_WIDTH                       1  /* LDO11_STS */
+#define WM831X_LDO10_STS                        0x0200  /* LDO10_STS */
+#define WM831X_LDO10_STS_MASK                   0x0200  /* LDO10_STS */
+#define WM831X_LDO10_STS_SHIFT                       9  /* LDO10_STS */
+#define WM831X_LDO10_STS_WIDTH                       1  /* LDO10_STS */
+#define WM831X_LDO9_STS                         0x0100  /* LDO9_STS */
+#define WM831X_LDO9_STS_MASK                    0x0100  /* LDO9_STS */
+#define WM831X_LDO9_STS_SHIFT                        8  /* LDO9_STS */
+#define WM831X_LDO9_STS_WIDTH                        1  /* LDO9_STS */
+#define WM831X_LDO8_STS                         0x0080  /* LDO8_STS */
+#define WM831X_LDO8_STS_MASK                    0x0080  /* LDO8_STS */
+#define WM831X_LDO8_STS_SHIFT                        7  /* LDO8_STS */
+#define WM831X_LDO8_STS_WIDTH                        1  /* LDO8_STS */
+#define WM831X_LDO7_STS                         0x0040  /* LDO7_STS */
+#define WM831X_LDO7_STS_MASK                    0x0040  /* LDO7_STS */
+#define WM831X_LDO7_STS_SHIFT                        6  /* LDO7_STS */
+#define WM831X_LDO7_STS_WIDTH                        1  /* LDO7_STS */
+#define WM831X_LDO6_STS                         0x0020  /* LDO6_STS */
+#define WM831X_LDO6_STS_MASK                    0x0020  /* LDO6_STS */
+#define WM831X_LDO6_STS_SHIFT                        5  /* LDO6_STS */
+#define WM831X_LDO6_STS_WIDTH                        1  /* LDO6_STS */
+#define WM831X_LDO5_STS                         0x0010  /* LDO5_STS */
+#define WM831X_LDO5_STS_MASK                    0x0010  /* LDO5_STS */
+#define WM831X_LDO5_STS_SHIFT                        4  /* LDO5_STS */
+#define WM831X_LDO5_STS_WIDTH                        1  /* LDO5_STS */
+#define WM831X_LDO4_STS                         0x0008  /* LDO4_STS */
+#define WM831X_LDO4_STS_MASK                    0x0008  /* LDO4_STS */
+#define WM831X_LDO4_STS_SHIFT                        3  /* LDO4_STS */
+#define WM831X_LDO4_STS_WIDTH                        1  /* LDO4_STS */
+#define WM831X_LDO3_STS                         0x0004  /* LDO3_STS */
+#define WM831X_LDO3_STS_MASK                    0x0004  /* LDO3_STS */
+#define WM831X_LDO3_STS_SHIFT                        2  /* LDO3_STS */
+#define WM831X_LDO3_STS_WIDTH                        1  /* LDO3_STS */
+#define WM831X_LDO2_STS                         0x0002  /* LDO2_STS */
+#define WM831X_LDO2_STS_MASK                    0x0002  /* LDO2_STS */
+#define WM831X_LDO2_STS_SHIFT                        1  /* LDO2_STS */
+#define WM831X_LDO2_STS_WIDTH                        1  /* LDO2_STS */
+#define WM831X_LDO1_STS                         0x0001  /* LDO1_STS */
+#define WM831X_LDO1_STS_MASK                    0x0001  /* LDO1_STS */
+#define WM831X_LDO1_STS_SHIFT                        0  /* LDO1_STS */
+#define WM831X_LDO1_STS_WIDTH                        1  /* LDO1_STS */
+
+/*
+ * R16468 (0x4054) - DCDC UV Status
+ */
+#define WM831X_DC2_OV_STS                       0x2000  /* DC2_OV_STS */
+#define WM831X_DC2_OV_STS_MASK                  0x2000  /* DC2_OV_STS */
+#define WM831X_DC2_OV_STS_SHIFT                     13  /* DC2_OV_STS */
+#define WM831X_DC2_OV_STS_WIDTH                      1  /* DC2_OV_STS */
+#define WM831X_DC1_OV_STS                       0x1000  /* DC1_OV_STS */
+#define WM831X_DC1_OV_STS_MASK                  0x1000  /* DC1_OV_STS */
+#define WM831X_DC1_OV_STS_SHIFT                     12  /* DC1_OV_STS */
+#define WM831X_DC1_OV_STS_WIDTH                      1  /* DC1_OV_STS */
+#define WM831X_DC2_HC_STS                       0x0200  /* DC2_HC_STS */
+#define WM831X_DC2_HC_STS_MASK                  0x0200  /* DC2_HC_STS */
+#define WM831X_DC2_HC_STS_SHIFT                      9  /* DC2_HC_STS */
+#define WM831X_DC2_HC_STS_WIDTH                      1  /* DC2_HC_STS */
+#define WM831X_DC1_HC_STS                       0x0100  /* DC1_HC_STS */
+#define WM831X_DC1_HC_STS_MASK                  0x0100  /* DC1_HC_STS */
+#define WM831X_DC1_HC_STS_SHIFT                      8  /* DC1_HC_STS */
+#define WM831X_DC1_HC_STS_WIDTH                      1  /* DC1_HC_STS */
+#define WM831X_DC4_UV_STS                       0x0008  /* DC4_UV_STS */
+#define WM831X_DC4_UV_STS_MASK                  0x0008  /* DC4_UV_STS */
+#define WM831X_DC4_UV_STS_SHIFT                      3  /* DC4_UV_STS */
+#define WM831X_DC4_UV_STS_WIDTH                      1  /* DC4_UV_STS */
+#define WM831X_DC3_UV_STS                       0x0004  /* DC3_UV_STS */
+#define WM831X_DC3_UV_STS_MASK                  0x0004  /* DC3_UV_STS */
+#define WM831X_DC3_UV_STS_SHIFT                      2  /* DC3_UV_STS */
+#define WM831X_DC3_UV_STS_WIDTH                      1  /* DC3_UV_STS */
+#define WM831X_DC2_UV_STS                       0x0002  /* DC2_UV_STS */
+#define WM831X_DC2_UV_STS_MASK                  0x0002  /* DC2_UV_STS */
+#define WM831X_DC2_UV_STS_SHIFT                      1  /* DC2_UV_STS */
+#define WM831X_DC2_UV_STS_WIDTH                      1  /* DC2_UV_STS */
+#define WM831X_DC1_UV_STS                       0x0001  /* DC1_UV_STS */
+#define WM831X_DC1_UV_STS_MASK                  0x0001  /* DC1_UV_STS */
+#define WM831X_DC1_UV_STS_SHIFT                      0  /* DC1_UV_STS */
+#define WM831X_DC1_UV_STS_WIDTH                      1  /* DC1_UV_STS */
+
+/*
+ * R16469 (0x4055) - LDO UV Status
+ */
+#define WM831X_INTLDO_UV_STS                    0x8000  /* INTLDO_UV_STS */
+#define WM831X_INTLDO_UV_STS_MASK               0x8000  /* INTLDO_UV_STS */
+#define WM831X_INTLDO_UV_STS_SHIFT                  15  /* INTLDO_UV_STS */
+#define WM831X_INTLDO_UV_STS_WIDTH                   1  /* INTLDO_UV_STS */
+#define WM831X_LDO10_UV_STS                     0x0200  /* LDO10_UV_STS */
+#define WM831X_LDO10_UV_STS_MASK                0x0200  /* LDO10_UV_STS */
+#define WM831X_LDO10_UV_STS_SHIFT                    9  /* LDO10_UV_STS */
+#define WM831X_LDO10_UV_STS_WIDTH                    1  /* LDO10_UV_STS */
+#define WM831X_LDO9_UV_STS                      0x0100  /* LDO9_UV_STS */
+#define WM831X_LDO9_UV_STS_MASK                 0x0100  /* LDO9_UV_STS */
+#define WM831X_LDO9_UV_STS_SHIFT                     8  /* LDO9_UV_STS */
+#define WM831X_LDO9_UV_STS_WIDTH                     1  /* LDO9_UV_STS */
+#define WM831X_LDO8_UV_STS                      0x0080  /* LDO8_UV_STS */
+#define WM831X_LDO8_UV_STS_MASK                 0x0080  /* LDO8_UV_STS */
+#define WM831X_LDO8_UV_STS_SHIFT                     7  /* LDO8_UV_STS */
+#define WM831X_LDO8_UV_STS_WIDTH                     1  /* LDO8_UV_STS */
+#define WM831X_LDO7_UV_STS                      0x0040  /* LDO7_UV_STS */
+#define WM831X_LDO7_UV_STS_MASK                 0x0040  /* LDO7_UV_STS */
+#define WM831X_LDO7_UV_STS_SHIFT                     6  /* LDO7_UV_STS */
+#define WM831X_LDO7_UV_STS_WIDTH                     1  /* LDO7_UV_STS */
+#define WM831X_LDO6_UV_STS                      0x0020  /* LDO6_UV_STS */
+#define WM831X_LDO6_UV_STS_MASK                 0x0020  /* LDO6_UV_STS */
+#define WM831X_LDO6_UV_STS_SHIFT                     5  /* LDO6_UV_STS */
+#define WM831X_LDO6_UV_STS_WIDTH                     1  /* LDO6_UV_STS */
+#define WM831X_LDO5_UV_STS                      0x0010  /* LDO5_UV_STS */
+#define WM831X_LDO5_UV_STS_MASK                 0x0010  /* LDO5_UV_STS */
+#define WM831X_LDO5_UV_STS_SHIFT                     4  /* LDO5_UV_STS */
+#define WM831X_LDO5_UV_STS_WIDTH                     1  /* LDO5_UV_STS */
+#define WM831X_LDO4_UV_STS                      0x0008  /* LDO4_UV_STS */
+#define WM831X_LDO4_UV_STS_MASK                 0x0008  /* LDO4_UV_STS */
+#define WM831X_LDO4_UV_STS_SHIFT                     3  /* LDO4_UV_STS */
+#define WM831X_LDO4_UV_STS_WIDTH                     1  /* LDO4_UV_STS */
+#define WM831X_LDO3_UV_STS                      0x0004  /* LDO3_UV_STS */
+#define WM831X_LDO3_UV_STS_MASK                 0x0004  /* LDO3_UV_STS */
+#define WM831X_LDO3_UV_STS_SHIFT                     2  /* LDO3_UV_STS */
+#define WM831X_LDO3_UV_STS_WIDTH                     1  /* LDO3_UV_STS */
+#define WM831X_LDO2_UV_STS                      0x0002  /* LDO2_UV_STS */
+#define WM831X_LDO2_UV_STS_MASK                 0x0002  /* LDO2_UV_STS */
+#define WM831X_LDO2_UV_STS_SHIFT                     1  /* LDO2_UV_STS */
+#define WM831X_LDO2_UV_STS_WIDTH                     1  /* LDO2_UV_STS */
+#define WM831X_LDO1_UV_STS                      0x0001  /* LDO1_UV_STS */
+#define WM831X_LDO1_UV_STS_MASK                 0x0001  /* LDO1_UV_STS */
+#define WM831X_LDO1_UV_STS_SHIFT                     0  /* LDO1_UV_STS */
+#define WM831X_LDO1_UV_STS_WIDTH                     1  /* LDO1_UV_STS */
+
+/*
+ * R16470 (0x4056) - DC1 Control 1
+ */
+#define WM831X_DC1_RATE_MASK                    0xC000  /* DC1_RATE - [15:14] */
+#define WM831X_DC1_RATE_SHIFT                       14  /* DC1_RATE - [15:14] */
+#define WM831X_DC1_RATE_WIDTH                        2  /* DC1_RATE - [15:14] */
+#define WM831X_DC1_PHASE                        0x1000  /* DC1_PHASE */
+#define WM831X_DC1_PHASE_MASK                   0x1000  /* DC1_PHASE */
+#define WM831X_DC1_PHASE_SHIFT                      12  /* DC1_PHASE */
+#define WM831X_DC1_PHASE_WIDTH                       1  /* DC1_PHASE */
+#define WM831X_DC1_FREQ_MASK                    0x0300  /* DC1_FREQ - [9:8] */
+#define WM831X_DC1_FREQ_SHIFT                        8  /* DC1_FREQ - [9:8] */
+#define WM831X_DC1_FREQ_WIDTH                        2  /* DC1_FREQ - [9:8] */
+#define WM831X_DC1_FLT                          0x0080  /* DC1_FLT */
+#define WM831X_DC1_FLT_MASK                     0x0080  /* DC1_FLT */
+#define WM831X_DC1_FLT_SHIFT                         7  /* DC1_FLT */
+#define WM831X_DC1_FLT_WIDTH                         1  /* DC1_FLT */
+#define WM831X_DC1_SOFT_START_MASK              0x0030  /* DC1_SOFT_START - [5:4] */
+#define WM831X_DC1_SOFT_START_SHIFT                  4  /* DC1_SOFT_START - [5:4] */
+#define WM831X_DC1_SOFT_START_WIDTH                  2  /* DC1_SOFT_START - [5:4] */
+#define WM831X_DC1_CAP_MASK                     0x0003  /* DC1_CAP - [1:0] */
+#define WM831X_DC1_CAP_SHIFT                         0  /* DC1_CAP - [1:0] */
+#define WM831X_DC1_CAP_WIDTH                         2  /* DC1_CAP - [1:0] */
+
+/*
+ * R16471 (0x4057) - DC1 Control 2
+ */
+#define WM831X_DC1_ERR_ACT_MASK                 0xC000  /* DC1_ERR_ACT - [15:14] */
+#define WM831X_DC1_ERR_ACT_SHIFT                    14  /* DC1_ERR_ACT - [15:14] */
+#define WM831X_DC1_ERR_ACT_WIDTH                     2  /* DC1_ERR_ACT - [15:14] */
+#define WM831X_DC1_HWC_SRC_MASK                 0x1800  /* DC1_HWC_SRC - [12:11] */
+#define WM831X_DC1_HWC_SRC_SHIFT                    11  /* DC1_HWC_SRC - [12:11] */
+#define WM831X_DC1_HWC_SRC_WIDTH                     2  /* DC1_HWC_SRC - [12:11] */
+#define WM831X_DC1_HWC_VSEL                     0x0400  /* DC1_HWC_VSEL */
+#define WM831X_DC1_HWC_VSEL_MASK                0x0400  /* DC1_HWC_VSEL */
+#define WM831X_DC1_HWC_VSEL_SHIFT                   10  /* DC1_HWC_VSEL */
+#define WM831X_DC1_HWC_VSEL_WIDTH                    1  /* DC1_HWC_VSEL */
+#define WM831X_DC1_HWC_MODE_MASK                0x0300  /* DC1_HWC_MODE - [9:8] */
+#define WM831X_DC1_HWC_MODE_SHIFT                    8  /* DC1_HWC_MODE - [9:8] */
+#define WM831X_DC1_HWC_MODE_WIDTH                    2  /* DC1_HWC_MODE - [9:8] */
+#define WM831X_DC1_HC_THR_MASK                  0x0070  /* DC1_HC_THR - [6:4] */
+#define WM831X_DC1_HC_THR_SHIFT                      4  /* DC1_HC_THR - [6:4] */
+#define WM831X_DC1_HC_THR_WIDTH                      3  /* DC1_HC_THR - [6:4] */
+#define WM831X_DC1_HC_IND_ENA                   0x0001  /* DC1_HC_IND_ENA */
+#define WM831X_DC1_HC_IND_ENA_MASK              0x0001  /* DC1_HC_IND_ENA */
+#define WM831X_DC1_HC_IND_ENA_SHIFT                  0  /* DC1_HC_IND_ENA */
+#define WM831X_DC1_HC_IND_ENA_WIDTH                  1  /* DC1_HC_IND_ENA */
+
+/*
+ * R16472 (0x4058) - DC1 ON Config
+ */
+#define WM831X_DC1_ON_SLOT_MASK                 0xE000  /* DC1_ON_SLOT - [15:13] */
+#define WM831X_DC1_ON_SLOT_SHIFT                    13  /* DC1_ON_SLOT - [15:13] */
+#define WM831X_DC1_ON_SLOT_WIDTH                     3  /* DC1_ON_SLOT - [15:13] */
+#define WM831X_DC1_ON_MODE_MASK                 0x0300  /* DC1_ON_MODE - [9:8] */
+#define WM831X_DC1_ON_MODE_SHIFT                     8  /* DC1_ON_MODE - [9:8] */
+#define WM831X_DC1_ON_MODE_WIDTH                     2  /* DC1_ON_MODE - [9:8] */
+#define WM831X_DC1_ON_VSEL_MASK                 0x007F  /* DC1_ON_VSEL - [6:0] */
+#define WM831X_DC1_ON_VSEL_SHIFT                     0  /* DC1_ON_VSEL - [6:0] */
+#define WM831X_DC1_ON_VSEL_WIDTH                     7  /* DC1_ON_VSEL - [6:0] */
+
+/*
+ * R16473 (0x4059) - DC1 SLEEP Control
+ */
+#define WM831X_DC1_SLP_SLOT_MASK                0xE000  /* DC1_SLP_SLOT - [15:13] */
+#define WM831X_DC1_SLP_SLOT_SHIFT                   13  /* DC1_SLP_SLOT - [15:13] */
+#define WM831X_DC1_SLP_SLOT_WIDTH                    3  /* DC1_SLP_SLOT - [15:13] */
+#define WM831X_DC1_SLP_MODE_MASK                0x0300  /* DC1_SLP_MODE - [9:8] */
+#define WM831X_DC1_SLP_MODE_SHIFT                    8  /* DC1_SLP_MODE - [9:8] */
+#define WM831X_DC1_SLP_MODE_WIDTH                    2  /* DC1_SLP_MODE - [9:8] */
+#define WM831X_DC1_SLP_VSEL_MASK                0x007F  /* DC1_SLP_VSEL - [6:0] */
+#define WM831X_DC1_SLP_VSEL_SHIFT                    0  /* DC1_SLP_VSEL - [6:0] */
+#define WM831X_DC1_SLP_VSEL_WIDTH                    7  /* DC1_SLP_VSEL - [6:0] */
+
+/*
+ * R16474 (0x405A) - DC1 DVS Control
+ */
+#define WM831X_DC1_DVS_SRC_MASK                 0x1800  /* DC1_DVS_SRC - [12:11] */
+#define WM831X_DC1_DVS_SRC_SHIFT                    11  /* DC1_DVS_SRC - [12:11] */
+#define WM831X_DC1_DVS_SRC_WIDTH                     2  /* DC1_DVS_SRC - [12:11] */
+#define WM831X_DC1_DVS_VSEL_MASK                0x007F  /* DC1_DVS_VSEL - [6:0] */
+#define WM831X_DC1_DVS_VSEL_SHIFT                    0  /* DC1_DVS_VSEL - [6:0] */
+#define WM831X_DC1_DVS_VSEL_WIDTH                    7  /* DC1_DVS_VSEL - [6:0] */
+
+/*
+ * R16475 (0x405B) - DC2 Control 1
+ */
+#define WM831X_DC2_RATE_MASK                    0xC000  /* DC2_RATE - [15:14] */
+#define WM831X_DC2_RATE_SHIFT                       14  /* DC2_RATE - [15:14] */
+#define WM831X_DC2_RATE_WIDTH                        2  /* DC2_RATE - [15:14] */
+#define WM831X_DC2_PHASE                        0x1000  /* DC2_PHASE */
+#define WM831X_DC2_PHASE_MASK                   0x1000  /* DC2_PHASE */
+#define WM831X_DC2_PHASE_SHIFT                      12  /* DC2_PHASE */
+#define WM831X_DC2_PHASE_WIDTH                       1  /* DC2_PHASE */
+#define WM831X_DC2_FREQ_MASK                    0x0300  /* DC2_FREQ - [9:8] */
+#define WM831X_DC2_FREQ_SHIFT                        8  /* DC2_FREQ - [9:8] */
+#define WM831X_DC2_FREQ_WIDTH                        2  /* DC2_FREQ - [9:8] */
+#define WM831X_DC2_FLT                          0x0080  /* DC2_FLT */
+#define WM831X_DC2_FLT_MASK                     0x0080  /* DC2_FLT */
+#define WM831X_DC2_FLT_SHIFT                         7  /* DC2_FLT */
+#define WM831X_DC2_FLT_WIDTH                         1  /* DC2_FLT */
+#define WM831X_DC2_SOFT_START_MASK              0x0030  /* DC2_SOFT_START - [5:4] */
+#define WM831X_DC2_SOFT_START_SHIFT                  4  /* DC2_SOFT_START - [5:4] */
+#define WM831X_DC2_SOFT_START_WIDTH                  2  /* DC2_SOFT_START - [5:4] */
+#define WM831X_DC2_CAP_MASK                     0x0003  /* DC2_CAP - [1:0] */
+#define WM831X_DC2_CAP_SHIFT                         0  /* DC2_CAP - [1:0] */
+#define WM831X_DC2_CAP_WIDTH                         2  /* DC2_CAP - [1:0] */
+
+/*
+ * R16476 (0x405C) - DC2 Control 2
+ */
+#define WM831X_DC2_ERR_ACT_MASK                 0xC000  /* DC2_ERR_ACT - [15:14] */
+#define WM831X_DC2_ERR_ACT_SHIFT                    14  /* DC2_ERR_ACT - [15:14] */
+#define WM831X_DC2_ERR_ACT_WIDTH                     2  /* DC2_ERR_ACT - [15:14] */
+#define WM831X_DC2_HWC_SRC_MASK                 0x1800  /* DC2_HWC_SRC - [12:11] */
+#define WM831X_DC2_HWC_SRC_SHIFT                    11  /* DC2_HWC_SRC - [12:11] */
+#define WM831X_DC2_HWC_SRC_WIDTH                     2  /* DC2_HWC_SRC - [12:11] */
+#define WM831X_DC2_HWC_VSEL                     0x0400  /* DC2_HWC_VSEL */
+#define WM831X_DC2_HWC_VSEL_MASK                0x0400  /* DC2_HWC_VSEL */
+#define WM831X_DC2_HWC_VSEL_SHIFT                   10  /* DC2_HWC_VSEL */
+#define WM831X_DC2_HWC_VSEL_WIDTH                    1  /* DC2_HWC_VSEL */
+#define WM831X_DC2_HWC_MODE_MASK                0x0300  /* DC2_HWC_MODE - [9:8] */
+#define WM831X_DC2_HWC_MODE_SHIFT                    8  /* DC2_HWC_MODE - [9:8] */
+#define WM831X_DC2_HWC_MODE_WIDTH                    2  /* DC2_HWC_MODE - [9:8] */
+#define WM831X_DC2_HC_THR_MASK                  0x0070  /* DC2_HC_THR - [6:4] */
+#define WM831X_DC2_HC_THR_SHIFT                      4  /* DC2_HC_THR - [6:4] */
+#define WM831X_DC2_HC_THR_WIDTH                      3  /* DC2_HC_THR - [6:4] */
+#define WM831X_DC2_HC_IND_ENA                   0x0001  /* DC2_HC_IND_ENA */
+#define WM831X_DC2_HC_IND_ENA_MASK              0x0001  /* DC2_HC_IND_ENA */
+#define WM831X_DC2_HC_IND_ENA_SHIFT                  0  /* DC2_HC_IND_ENA */
+#define WM831X_DC2_HC_IND_ENA_WIDTH                  1  /* DC2_HC_IND_ENA */
+
+/*
+ * R16477 (0x405D) - DC2 ON Config
+ */
+#define WM831X_DC2_ON_SLOT_MASK                 0xE000  /* DC2_ON_SLOT - [15:13] */
+#define WM831X_DC2_ON_SLOT_SHIFT                    13  /* DC2_ON_SLOT - [15:13] */
+#define WM831X_DC2_ON_SLOT_WIDTH                     3  /* DC2_ON_SLOT - [15:13] */
+#define WM831X_DC2_ON_MODE_MASK                 0x0300  /* DC2_ON_MODE - [9:8] */
+#define WM831X_DC2_ON_MODE_SHIFT                     8  /* DC2_ON_MODE - [9:8] */
+#define WM831X_DC2_ON_MODE_WIDTH                     2  /* DC2_ON_MODE - [9:8] */
+#define WM831X_DC2_ON_VSEL_MASK                 0x007F  /* DC2_ON_VSEL - [6:0] */
+#define WM831X_DC2_ON_VSEL_SHIFT                     0  /* DC2_ON_VSEL - [6:0] */
+#define WM831X_DC2_ON_VSEL_WIDTH                     7  /* DC2_ON_VSEL - [6:0] */
+
+/*
+ * R16478 (0x405E) - DC2 SLEEP Control
+ */
+#define WM831X_DC2_SLP_SLOT_MASK                0xE000  /* DC2_SLP_SLOT - [15:13] */
+#define WM831X_DC2_SLP_SLOT_SHIFT                   13  /* DC2_SLP_SLOT - [15:13] */
+#define WM831X_DC2_SLP_SLOT_WIDTH                    3  /* DC2_SLP_SLOT - [15:13] */
+#define WM831X_DC2_SLP_MODE_MASK                0x0300  /* DC2_SLP_MODE - [9:8] */
+#define WM831X_DC2_SLP_MODE_SHIFT                    8  /* DC2_SLP_MODE - [9:8] */
+#define WM831X_DC2_SLP_MODE_WIDTH                    2  /* DC2_SLP_MODE - [9:8] */
+#define WM831X_DC2_SLP_VSEL_MASK                0x007F  /* DC2_SLP_VSEL - [6:0] */
+#define WM831X_DC2_SLP_VSEL_SHIFT                    0  /* DC2_SLP_VSEL - [6:0] */
+#define WM831X_DC2_SLP_VSEL_WIDTH                    7  /* DC2_SLP_VSEL - [6:0] */
+
+/*
+ * R16479 (0x405F) - DC2 DVS Control
+ */
+#define WM831X_DC2_DVS_SRC_MASK                 0x1800  /* DC2_DVS_SRC - [12:11] */
+#define WM831X_DC2_DVS_SRC_SHIFT                    11  /* DC2_DVS_SRC - [12:11] */
+#define WM831X_DC2_DVS_SRC_WIDTH                     2  /* DC2_DVS_SRC - [12:11] */
+#define WM831X_DC2_DVS_VSEL_MASK                0x007F  /* DC2_DVS_VSEL - [6:0] */
+#define WM831X_DC2_DVS_VSEL_SHIFT                    0  /* DC2_DVS_VSEL - [6:0] */
+#define WM831X_DC2_DVS_VSEL_WIDTH                    7  /* DC2_DVS_VSEL - [6:0] */
+
+/*
+ * R16480 (0x4060) - DC3 Control 1
+ */
+#define WM831X_DC3_PHASE                        0x1000  /* DC3_PHASE */
+#define WM831X_DC3_PHASE_MASK                   0x1000  /* DC3_PHASE */
+#define WM831X_DC3_PHASE_SHIFT                      12  /* DC3_PHASE */
+#define WM831X_DC3_PHASE_WIDTH                       1  /* DC3_PHASE */
+#define WM831X_DC3_FLT                          0x0080  /* DC3_FLT */
+#define WM831X_DC3_FLT_MASK                     0x0080  /* DC3_FLT */
+#define WM831X_DC3_FLT_SHIFT                         7  /* DC3_FLT */
+#define WM831X_DC3_FLT_WIDTH                         1  /* DC3_FLT */
+#define WM831X_DC3_SOFT_START_MASK              0x0030  /* DC3_SOFT_START - [5:4] */
+#define WM831X_DC3_SOFT_START_SHIFT                  4  /* DC3_SOFT_START - [5:4] */
+#define WM831X_DC3_SOFT_START_WIDTH                  2  /* DC3_SOFT_START - [5:4] */
+#define WM831X_DC3_STNBY_LIM_MASK               0x000C  /* DC3_STNBY_LIM - [3:2] */
+#define WM831X_DC3_STNBY_LIM_SHIFT                   2  /* DC3_STNBY_LIM - [3:2] */
+#define WM831X_DC3_STNBY_LIM_WIDTH                   2  /* DC3_STNBY_LIM - [3:2] */
+#define WM831X_DC3_CAP_MASK                     0x0003  /* DC3_CAP - [1:0] */
+#define WM831X_DC3_CAP_SHIFT                         0  /* DC3_CAP - [1:0] */
+#define WM831X_DC3_CAP_WIDTH                         2  /* DC3_CAP - [1:0] */
+
+/*
+ * R16481 (0x4061) - DC3 Control 2
+ */
+#define WM831X_DC3_ERR_ACT_MASK                 0xC000  /* DC3_ERR_ACT - [15:14] */
+#define WM831X_DC3_ERR_ACT_SHIFT                    14  /* DC3_ERR_ACT - [15:14] */
+#define WM831X_DC3_ERR_ACT_WIDTH                     2  /* DC3_ERR_ACT - [15:14] */
+#define WM831X_DC3_HWC_SRC_MASK                 0x1800  /* DC3_HWC_SRC - [12:11] */
+#define WM831X_DC3_HWC_SRC_SHIFT                    11  /* DC3_HWC_SRC - [12:11] */
+#define WM831X_DC3_HWC_SRC_WIDTH                     2  /* DC3_HWC_SRC - [12:11] */
+#define WM831X_DC3_HWC_VSEL                     0x0400  /* DC3_HWC_VSEL */
+#define WM831X_DC3_HWC_VSEL_MASK                0x0400  /* DC3_HWC_VSEL */
+#define WM831X_DC3_HWC_VSEL_SHIFT                   10  /* DC3_HWC_VSEL */
+#define WM831X_DC3_HWC_VSEL_WIDTH                    1  /* DC3_HWC_VSEL */
+#define WM831X_DC3_HWC_MODE_MASK                0x0300  /* DC3_HWC_MODE - [9:8] */
+#define WM831X_DC3_HWC_MODE_SHIFT                    8  /* DC3_HWC_MODE - [9:8] */
+#define WM831X_DC3_HWC_MODE_WIDTH                    2  /* DC3_HWC_MODE - [9:8] */
+#define WM831X_DC3_OVP                          0x0080  /* DC3_OVP */
+#define WM831X_DC3_OVP_MASK                     0x0080  /* DC3_OVP */
+#define WM831X_DC3_OVP_SHIFT                         7  /* DC3_OVP */
+#define WM831X_DC3_OVP_WIDTH                         1  /* DC3_OVP */
+
+/*
+ * R16482 (0x4062) - DC3 ON Config
+ */
+#define WM831X_DC3_ON_SLOT_MASK                 0xE000  /* DC3_ON_SLOT - [15:13] */
+#define WM831X_DC3_ON_SLOT_SHIFT                    13  /* DC3_ON_SLOT - [15:13] */
+#define WM831X_DC3_ON_SLOT_WIDTH                     3  /* DC3_ON_SLOT - [15:13] */
+#define WM831X_DC3_ON_MODE_MASK                 0x0300  /* DC3_ON_MODE - [9:8] */
+#define WM831X_DC3_ON_MODE_SHIFT                     8  /* DC3_ON_MODE - [9:8] */
+#define WM831X_DC3_ON_MODE_WIDTH                     2  /* DC3_ON_MODE - [9:8] */
+#define WM831X_DC3_ON_VSEL_MASK                 0x007F  /* DC3_ON_VSEL - [6:0] */
+#define WM831X_DC3_ON_VSEL_SHIFT                     0  /* DC3_ON_VSEL - [6:0] */
+#define WM831X_DC3_ON_VSEL_WIDTH                     7  /* DC3_ON_VSEL - [6:0] */
+
+/*
+ * R16483 (0x4063) - DC3 SLEEP Control
+ */
+#define WM831X_DC3_SLP_SLOT_MASK                0xE000  /* DC3_SLP_SLOT - [15:13] */
+#define WM831X_DC3_SLP_SLOT_SHIFT                   13  /* DC3_SLP_SLOT - [15:13] */
+#define WM831X_DC3_SLP_SLOT_WIDTH                    3  /* DC3_SLP_SLOT - [15:13] */
+#define WM831X_DC3_SLP_MODE_MASK                0x0300  /* DC3_SLP_MODE - [9:8] */
+#define WM831X_DC3_SLP_MODE_SHIFT                    8  /* DC3_SLP_MODE - [9:8] */
+#define WM831X_DC3_SLP_MODE_WIDTH                    2  /* DC3_SLP_MODE - [9:8] */
+#define WM831X_DC3_SLP_VSEL_MASK                0x007F  /* DC3_SLP_VSEL - [6:0] */
+#define WM831X_DC3_SLP_VSEL_SHIFT                    0  /* DC3_SLP_VSEL - [6:0] */
+#define WM831X_DC3_SLP_VSEL_WIDTH                    7  /* DC3_SLP_VSEL - [6:0] */
+
+/*
+ * R16484 (0x4064) - DC4 Control
+ */
+#define WM831X_DC4_ERR_ACT_MASK                 0xC000  /* DC4_ERR_ACT - [15:14] */
+#define WM831X_DC4_ERR_ACT_SHIFT                    14  /* DC4_ERR_ACT - [15:14] */
+#define WM831X_DC4_ERR_ACT_WIDTH                     2  /* DC4_ERR_ACT - [15:14] */
+#define WM831X_DC4_HWC_SRC_MASK                 0x1800  /* DC4_HWC_SRC - [12:11] */
+#define WM831X_DC4_HWC_SRC_SHIFT                    11  /* DC4_HWC_SRC - [12:11] */
+#define WM831X_DC4_HWC_SRC_WIDTH                     2  /* DC4_HWC_SRC - [12:11] */
+#define WM831X_DC4_HWC_MODE                     0x0100  /* DC4_HWC_MODE */
+#define WM831X_DC4_HWC_MODE_MASK                0x0100  /* DC4_HWC_MODE */
+#define WM831X_DC4_HWC_MODE_SHIFT                    8  /* DC4_HWC_MODE */
+#define WM831X_DC4_HWC_MODE_WIDTH                    1  /* DC4_HWC_MODE */
+#define WM831X_DC4_RANGE_MASK                   0x000C  /* DC4_RANGE - [3:2] */
+#define WM831X_DC4_RANGE_SHIFT                       2  /* DC4_RANGE - [3:2] */
+#define WM831X_DC4_RANGE_WIDTH                       2  /* DC4_RANGE - [3:2] */
+#define WM831X_DC4_FBSRC                        0x0001  /* DC4_FBSRC */
+#define WM831X_DC4_FBSRC_MASK                   0x0001  /* DC4_FBSRC */
+#define WM831X_DC4_FBSRC_SHIFT                       0  /* DC4_FBSRC */
+#define WM831X_DC4_FBSRC_WIDTH                       1  /* DC4_FBSRC */
+
+/*
+ * R16485 (0x4065) - DC4 SLEEP Control
+ */
+#define WM831X_DC4_SLPENA                       0x0100  /* DC4_SLPENA */
+#define WM831X_DC4_SLPENA_MASK                  0x0100  /* DC4_SLPENA */
+#define WM831X_DC4_SLPENA_SHIFT                      8  /* DC4_SLPENA */
+#define WM831X_DC4_SLPENA_WIDTH                      1  /* DC4_SLPENA */
+
+/*
+ * R16526 (0x408E) - Power Good Source 1
+ */
+#define WM831X_DC4_OK                           0x0008  /* DC4_OK */
+#define WM831X_DC4_OK_MASK                      0x0008  /* DC4_OK */
+#define WM831X_DC4_OK_SHIFT                          3  /* DC4_OK */
+#define WM831X_DC4_OK_WIDTH                          1  /* DC4_OK */
+#define WM831X_DC3_OK                           0x0004  /* DC3_OK */
+#define WM831X_DC3_OK_MASK                      0x0004  /* DC3_OK */
+#define WM831X_DC3_OK_SHIFT                          2  /* DC3_OK */
+#define WM831X_DC3_OK_WIDTH                          1  /* DC3_OK */
+#define WM831X_DC2_OK                           0x0002  /* DC2_OK */
+#define WM831X_DC2_OK_MASK                      0x0002  /* DC2_OK */
+#define WM831X_DC2_OK_SHIFT                          1  /* DC2_OK */
+#define WM831X_DC2_OK_WIDTH                          1  /* DC2_OK */
+#define WM831X_DC1_OK                           0x0001  /* DC1_OK */
+#define WM831X_DC1_OK_MASK                      0x0001  /* DC1_OK */
+#define WM831X_DC1_OK_SHIFT                          0  /* DC1_OK */
+#define WM831X_DC1_OK_WIDTH                          1  /* DC1_OK */
+
 #define WM831X_ISINK_MAX_ISEL 56
 extern int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL];
 
-- 
1.6.3.3

