Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZG0Nrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZG0Nrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZG0Nrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:47:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59144 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754701AbZG0Nq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 09/22] backlight: Add WM831x backlight driver
Date: Mon, 27 Jul 2009 14:45:59 +0100
Message-Id: <1248702372-29534-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x series of PMICs provide DC-DC boost convertors and current
sinks which can be used together to drive LEDs for use as backlights.
Expose this functionality via the backlight API.

Since when used in this configuration the current sink and boost
convertor are very tightly coupled with a multi-stage startup for
the current sink which overlaps with the boost convertor startup
this driver bypasses the regulator API. Machine inititialisation
is responsible for ensuring that the regulators are not accessed
via both APIs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/Kconfig     |    7 +
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/wm831x_bl.c |  250 +++++++++++++++++++++++++++++++++++
 3 files changed, 258 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/wm831x_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 90861cd..205de1a 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -229,3 +229,10 @@ config BACKLIGHT_SAHARA
 	help
 	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
 	  backlight driver.
+
+config BACKLIGHT_WM831X
+	tristate "WM831x PMIC Backlight Driver"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_WM831X
+	help
+	  If you have a backlight driven by the ISINK and DCDC of a
+	  WM831x PMIC say y to enable the backlight driver for it.
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 4eb178c..df0b67c 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -24,4 +24,5 @@ obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
+obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
 
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
new file mode 100644
index 0000000..467bdb7
--- /dev/null
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -0,0 +1,250 @@
+/*
+ * Backlight driver for Wolfson Microelectronics WM831x PMICs
+ *
+ * Copyright 2009 Wolfson Microelectonics plc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/regulator.h>
+
+struct wm831x_backlight_data {
+	struct wm831x *wm831x;
+	int isink_reg;
+	int current_brightness;
+};
+
+static int wm831x_backlight_set(struct backlight_device *bl, int brightness)
+{
+	struct wm831x_backlight_data *data = bl_get_data(bl);
+	struct wm831x *wm831x = data->wm831x;
+	int power_up = !data->current_brightness && brightness;
+	int power_down = data->current_brightness && !brightness;
+	int ret;
+
+	if (power_up) {
+		/* Enable the ISINK */
+		ret = wm831x_set_bits(wm831x, data->isink_reg,
+				      WM831X_CS1_ENA, WM831X_CS1_ENA);
+		if (ret < 0)
+			goto err;
+
+		/* Enable the DC-DC */
+		ret = wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE,
+				      WM831X_DC4_ENA, WM831X_DC4_ENA);
+		if (ret < 0)
+			goto err;
+	}
+
+	if (power_down) {
+		/* DCDC first */
+		ret = wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE,
+				      WM831X_DC4_ENA, 0);
+		if (ret < 0)
+			goto err;
+
+		/* ISINK */
+		ret = wm831x_set_bits(wm831x, data->isink_reg,
+				      WM831X_CS1_DRIVE | WM831X_CS1_ENA, 0);
+		if (ret < 0)
+			goto err;
+	}
+
+	/* Set the new brightness */
+	ret = wm831x_set_bits(wm831x, data->isink_reg,
+			      WM831X_CS1_ISEL_MASK, brightness);
+	if (ret < 0)
+		goto err;
+
+	if (power_up) {
+		/* Drive current through the ISINK */
+		ret = wm831x_set_bits(wm831x, data->isink_reg,
+				      WM831X_CS1_DRIVE, WM831X_CS1_DRIVE);
+		if (ret < 0)
+			return ret;
+	}
+
+	data->current_brightness = brightness;
+
+	return 0;
+
+err:
+	/* If we were in the middle of a power transition always shut down
+	 * for safety.
+	 */
+	if (power_up || power_down) {
+		wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, WM831X_DC4_ENA, 0);
+		wm831x_set_bits(wm831x, data->isink_reg, WM831X_CS1_ENA, 0);
+	}
+
+	return ret;
+}
+
+static int wm831x_backlight_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+
+	if (bl->props.power != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	if (bl->props.state & BL_CORE_SUSPENDED)
+		brightness = 0;
+
+	return wm831x_backlight_set(bl, brightness);
+}
+
+static int wm831x_backlight_get_brightness(struct backlight_device *bl)
+{
+	struct wm831x_backlight_data *data = bl_get_data(bl);
+	return data->current_brightness;
+}
+
+static struct backlight_ops wm831x_backlight_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status	= wm831x_backlight_update_status,
+	.get_brightness	= wm831x_backlight_get_brightness,
+};
+
+static int wm831x_backlight_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *wm831x_pdata;
+	struct wm831x_backlight_pdata *pdata;
+	struct wm831x_backlight_data *data;
+	struct backlight_device *bl;
+	int ret, i, max_isel, isink_reg, dcdc_cfg;
+
+	/* We need platform data */
+	if (pdev->dev.parent->platform_data) {
+		wm831x_pdata = pdev->dev.parent->platform_data;
+		pdata = wm831x_pdata->backlight;
+	} else {
+		pdata = NULL;
+	}
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data supplied\n");
+		return -EINVAL;
+	}
+
+	/* Figure out the maximum current we can use */
+	for (i = 0; i < WM831X_ISINK_MAX_ISEL; i++) {
+		if (wm831x_isinkv_values[i] > pdata->max_uA)
+			break;
+	}
+
+	if (i == 0) {
+		dev_err(&pdev->dev, "Invalid max_uA: %duA\n", pdata->max_uA);
+		return -EINVAL;
+	}
+	max_isel = i - 1;
+
+	if (pdata->max_uA != wm831x_isinkv_values[max_isel])
+		dev_warn(&pdev->dev,
+			 "Maximum current is %duA not %duA as requested\n",
+			 wm831x_isinkv_values[max_isel], pdata->max_uA);
+
+	switch (pdata->isink) {
+	case 1:
+		isink_reg = WM831X_CURRENT_SINK_1;
+		dcdc_cfg = 0;
+		break;
+	case 2:
+		isink_reg = WM831X_CURRENT_SINK_2;
+		dcdc_cfg = WM831X_DC4_FBSRC;
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid ISINK %d\n", pdata->isink);
+		return -EINVAL;
+	}
+
+	/* Configure the ISINK to use for feedback */
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret < 0)
+		return ret;
+
+	ret = wm831x_set_bits(wm831x, WM831X_DC4_CONTROL, WM831X_DC4_FBSRC,
+			      dcdc_cfg);
+
+	wm831x_reg_lock(wm831x);
+	if (ret < 0)
+		return ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->wm831x = wm831x;
+	data->current_brightness = 0;
+	data->isink_reg = isink_reg;
+
+	bl = backlight_device_register("wm831x", &pdev->dev,
+			data, &wm831x_backlight_ops);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness = max_isel;
+	bl->props.brightness = max_isel;
+
+	platform_set_drvdata(pdev, bl);
+
+	/* Disable the DCDC if it was started so we can bootstrap */
+	wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, WM831X_DC4_ENA, 0);
+
+
+	backlight_update_status(bl);
+
+	return 0;
+}
+
+static int wm831x_backlight_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct wm831x_backlight_data *data = bl_get_data(bl);
+
+	backlight_device_unregister(bl);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver wm831x_backlight_driver = {
+	.driver		= {
+		.name	= "wm831x-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= wm831x_backlight_probe,
+	.remove		= wm831x_backlight_remove,
+};
+
+static int __init wm831x_backlight_init(void)
+{
+	return platform_driver_register(&wm831x_backlight_driver);
+}
+module_init(wm831x_backlight_init);
+
+static void __exit wm831x_backlight_exit(void)
+{
+	platform_driver_unregister(&wm831x_backlight_driver);
+}
+module_exit(wm831x_backlight_exit);
+
+MODULE_DESCRIPTION("Backlight Driver for WM831x PMICs");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-backlight");
-- 
1.6.3.3

