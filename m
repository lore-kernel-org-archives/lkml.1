Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZG0Ns7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZG0Ns7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZG0Nrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:47:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59115 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754766AbZG0Nqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 20/22] regulator: Add WM831x ISINK support
Date: Mon, 27 Jul 2009 14:46:10 +0100
Message-Id: <1248702372-29534-20-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of PMICs provide two constant current sinks
designed to drive strings of serially connected LEDs for applications
such as backlights. This driver adds support for those regulators.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/Makefile       |    1 +
 drivers/regulator/wm831x-isink.c |  260 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 261 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/wm831x-isink.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index a0a635f..3a4cdf5 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl4030-regulator.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
+obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
 obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
new file mode 100644
index 0000000..64c407d
--- /dev/null
+++ b/drivers/regulator/wm831x-isink.c
@@ -0,0 +1,260 @@
+/*
+ * wm831x-isink.c  --  Current sink driver for the WM831x series
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
+#define WM831X_ISINK_MAX_NAME 7
+
+struct wm831x_isink {
+	char name[WM831X_ISINK_MAX_NAME];
+	struct regulator_desc desc;
+	int reg;
+	struct wm831x *wm831x;
+	struct regulator_dev *regulator;
+};
+
+static int wm831x_isink_enable(struct regulator_dev *rdev)
+{
+	struct wm831x_isink *isink = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = isink->wm831x;
+	int ret;
+
+	/* We have a two stage enable: first start the ISINK... */
+	ret = wm831x_set_bits(wm831x, isink->reg, WM831X_CS1_ENA,
+			      WM831X_CS1_ENA);
+	if (ret != 0)
+		return ret;
+
+	/* ...then enable drive */
+	ret = wm831x_set_bits(wm831x, isink->reg, WM831X_CS1_DRIVE,
+			      WM831X_CS1_DRIVE);
+	if (ret != 0)
+		wm831x_set_bits(wm831x, isink->reg, WM831X_CS1_ENA, 0);
+
+	return ret;
+
+}
+
+static int wm831x_isink_disable(struct regulator_dev *rdev)
+{
+	struct wm831x_isink *isink = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = isink->wm831x;
+	int ret;
+
+	ret = wm831x_set_bits(wm831x, isink->reg, WM831X_CS1_DRIVE, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = wm831x_set_bits(wm831x, isink->reg, WM831X_CS1_ENA, 0);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+
+}
+
+static int wm831x_isink_is_enabled(struct regulator_dev *rdev)
+{
+	struct wm831x_isink *isink = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = isink->wm831x;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, isink->reg);
+	if (ret < 0)
+		return ret;
+
+	if ((ret & (WM831X_CS1_ENA | WM831X_CS1_DRIVE)) ==
+	    (WM831X_CS1_ENA | WM831X_CS1_DRIVE))
+		return 1;
+	else
+		return 0;
+}
+
+static int wm831x_isink_set_current(struct regulator_dev *rdev,
+				    int min_uA, int max_uA)
+{
+	struct wm831x_isink *isink = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = isink->wm831x;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_isinkv_values); i++) {
+		int val = wm831x_isinkv_values[i];
+		if (min_uA >= val && val <= max_uA) {
+			ret = wm831x_set_bits(wm831x, isink->reg,
+					      WM831X_CS1_ISEL_MASK, i);
+			return ret;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int wm831x_isink_get_current(struct regulator_dev *rdev)
+{
+	struct wm831x_isink *isink = rdev_get_drvdata(rdev);
+	struct wm831x *wm831x = isink->wm831x;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, isink->reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= WM831X_CS1_ISEL_MASK;
+	if (ret > WM831X_ISINK_MAX_ISEL)
+		ret = WM831X_ISINK_MAX_ISEL;
+
+	return wm831x_isinkv_values[ret];
+}
+
+static struct regulator_ops wm831x_isink_ops = {
+	.is_enabled = wm831x_isink_is_enabled,
+	.enable = wm831x_isink_enable,
+	.disable = wm831x_isink_disable,
+	.set_current_limit = wm831x_isink_set_current,
+	.get_current_limit = wm831x_isink_get_current,
+};
+
+static irqreturn_t wm831x_isink_irq(int irq, void *data)
+{
+	struct wm831x_isink *isink = data;
+
+	regulator_notifier_call_chain(isink->regulator,
+				      REGULATOR_EVENT_OVER_CURRENT,
+				      NULL);
+
+	return IRQ_HANDLED;
+}
+
+
+static __devinit int wm831x_isink_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
+	struct wm831x_isink *isink;
+	int id = pdev->id % ARRAY_SIZE(pdata->isink);
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(&pdev->dev, "Probing ISINK%d\n", id + 1);
+
+	if (pdata->isink[id] == NULL)
+		return -ENODEV;
+
+	isink = kzalloc(sizeof(struct wm831x_isink), GFP_KERNEL);
+	if (isink == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	isink->reg = res->start;
+
+	/* For current parts this is correct; probably need to revisit
+	 * in future.
+	 */
+	snprintf(isink->name, sizeof(isink->name), "ISINK%d", id + 1);
+	isink->desc.name = isink->name;
+	isink->desc.id = id;
+	isink->desc.ops = &wm831x_isink_ops;
+	isink->desc.type = REGULATOR_CURRENT;
+	isink->desc.owner = THIS_MODULE;
+
+	isink->regulator = regulator_register(&isink->desc, &pdev->dev,
+					     pdata->isink[id], isink);
+	if (IS_ERR(isink->regulator)) {
+		ret = PTR_ERR(isink->regulator);
+		dev_err(wm831x->dev, "Failed to register ISINK%d: %d\n",
+			id + 1, ret);
+		goto err;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	ret = wm831x_request_irq(wm831x, irq, wm831x_isink_irq,
+				 IRQF_TRIGGER_RISING, isink->name,
+				 isink);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request ISINK IRQ %d: %d\n",
+			irq, ret);
+		goto err_regulator;
+	}
+
+	platform_set_drvdata(pdev, isink);
+
+	return 0;
+
+err_regulator:
+	regulator_unregister(isink->regulator);
+err:
+	kfree(isink);
+	return ret;
+}
+
+static __devexit int wm831x_isink_remove(struct platform_device *pdev)
+{
+	struct wm831x_isink *isink = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = isink->wm831x;
+
+	wm831x_free_irq(wm831x, platform_get_irq(pdev, 0), isink);
+
+	regulator_unregister(isink->regulator);
+	kfree(isink);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_isink_driver = {
+	.probe = wm831x_isink_probe,
+	.remove = __devexit_p(wm831x_isink_remove),
+	.driver		= {
+		.name	= "wm831x-isink",
+	},
+};
+
+static int __init wm831x_isink_init(void)
+{
+	int ret;
+	ret = platform_driver_register(&wm831x_isink_driver);
+	if (ret != 0)
+		pr_err("Failed to register WM831x ISINK driver: %d\n", ret);
+
+	return ret;
+}
+subsys_initcall(wm831x_isink_init);
+
+static void __exit wm831x_isink_exit(void)
+{
+	platform_driver_unregister(&wm831x_isink_driver);
+}
+module_exit(wm831x_isink_exit);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown");
+MODULE_DESCRIPTION("WM831x current sink driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-isink");
-- 
1.6.3.3

