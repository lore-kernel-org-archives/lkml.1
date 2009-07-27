Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbZG0NsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbZG0NsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZG0Nru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:47:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59143 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754659AbZG0Nq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH 14/22] leds: Add WM831x status LED driver
Date: Mon, 27 Jul 2009 14:46:04 +0100
Message-Id: <1248702372-29534-14-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x devices feature two software controlled status LEDs with
hardware assisted blinking.

The device can also autonomously control the LEDs based on a selection
of sources.  This can be configured at boot time using either platform
data or the chip OTP.  A sysfs file in the style of that for triggers
allowing the control source to be configured at run time.  Triggers
can't be used here since they can't depend on the implementation details
of a specific LED type.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig              |    7 +
 drivers/leds/Makefile             |    1 +
 drivers/leds/leds-wm831x-status.c |  341 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/status.h |   34 ++++
 4 files changed, 383 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-wm831x-status.c
 create mode 100644 include/linux/mfd/wm831x/status.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 7c8e712..edfd4e3 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -195,6 +195,13 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
+config LEDS_WM831X_STATUS
+	tristate "LED support for status LEDs on WM831x PMICs"
+	depends on LEDS_CLASS && MFD_WM831X
+	help
+	  This option enables support for the status LEDs of the WM831x
+          series of PMICs.
+
 config LEDS_WM8350
 	tristate "LED Support for WM8350 AudioPlus PMIC"
 	depends on LEDS_CLASS && MFD_WM8350
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e8cdcf7..46d7270 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
+obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
 
diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
new file mode 100644
index 0000000..c586d05
--- /dev/null
+++ b/drivers/leds/leds-wm831x-status.c
@@ -0,0 +1,341 @@
+/*
+ * LED driver for WM831x status LEDs
+ *
+ * Copyright(C) 2009 Wolfson Microelectronics PLC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/status.h>
+
+
+struct wm831x_status {
+	struct led_classdev cdev;
+	struct wm831x *wm831x;
+	struct work_struct work;
+	struct mutex mutex;
+
+	spinlock_t value_lock;
+	int reg;     /* Control register */
+	int reg_val; /* Control register value */
+
+	int blink;
+	int blink_time;
+	int blink_cyc;
+	int src;
+	enum led_brightness brightness;
+};
+
+#define to_wm831x_status(led_cdev) \
+	container_of(led_cdev, struct wm831x_status, cdev)
+
+static void wm831x_status_work(struct work_struct *work)
+{
+	struct wm831x_status *led = container_of(work, struct wm831x_status,
+						 work);
+	unsigned long flags;
+
+	mutex_lock(&led->mutex);
+
+	led->reg_val &= ~(WM831X_LED_SRC_MASK | WM831X_LED_MODE_MASK |
+			  WM831X_LED_DUTY_CYC_MASK | WM831X_LED_DUR_MASK);
+
+	spin_lock_irqsave(&led->value_lock, flags);
+
+	led->reg_val |= led->src << WM831X_LED_SRC_SHIFT;
+	if (led->blink) {
+		led->reg_val |= 2 << WM831X_LED_MODE_SHIFT;
+		led->reg_val |= led->blink_time << WM831X_LED_DUR_SHIFT;
+		led->reg_val |= led->blink_cyc;
+	} else {
+		if (led->brightness != LED_OFF)
+			led->reg_val |= 1 << WM831X_LED_MODE_SHIFT;
+	}
+
+	spin_unlock_irqrestore(&led->value_lock, flags);
+
+	wm831x_reg_write(led->wm831x, led->reg, led->reg_val);
+
+	mutex_unlock(&led->mutex);
+}
+
+static void wm831x_status_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct wm831x_status *led = to_wm831x_status(led_cdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->value_lock, flags);
+	led->brightness = value;
+	if (value == LED_OFF)
+		led->blink = 0;
+	schedule_work(&led->work);
+	spin_unlock_irqrestore(&led->value_lock, flags);
+}
+
+static int wm831x_status_blink_set(struct led_classdev *led_cdev,
+				   unsigned long *delay_on,
+				   unsigned long *delay_off)
+{
+	struct wm831x_status *led = to_wm831x_status(led_cdev);
+	unsigned long flags;
+	int ret = 0;
+
+	/* Pick some defaults if we've not been given times */
+	if (*delay_on == 0 && *delay_off == 0) {
+		*delay_on = 250;
+		*delay_off = 250;
+	}
+
+	spin_lock_irqsave(&led->value_lock, flags);
+
+	/* We only have a limited selection of settings, see if we can
+	 * support the configuration we're being given */
+	switch (*delay_on) {
+	case 1000:
+		led->blink_time = 0;
+		break;
+	case 250:
+		led->blink_time = 1;
+		break;
+	case 125:
+		led->blink_time = 2;
+		break;
+	case 62:
+	case 63:
+		/* Actually 62.5ms */
+		led->blink_time = 3;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret == 0) {
+		switch (*delay_off / *delay_on) {
+		case 1:
+			led->blink_cyc = 0;
+			break;
+		case 3:
+			led->blink_cyc = 1;
+			break;
+		case 4:
+			led->blink_cyc = 2;
+			break;
+		case 8:
+			led->blink_cyc = 3;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+	}
+
+	if (ret == 0)
+		led->blink = 1;
+	else
+		led->blink = 0;
+
+	/* Always update; if we fail turn off blinking since we expect
+	 * a software fallback. */
+	schedule_work(&led->work);
+
+	spin_unlock_irqrestore(&led->value_lock, flags);
+
+	return ret;
+}
+
+static const char *led_src_texts[] = {
+	"otp",
+	"power",
+	"charger",
+	"soft",
+};
+
+static ssize_t wm831x_status_src_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct wm831x_status *led = to_wm831x_status(led_cdev);
+	int i;
+	ssize_t ret = 0;
+
+	mutex_lock(&led->mutex);
+
+	for (i = 0; i < ARRAY_SIZE(led_src_texts); i++)
+		if (i == led->src)
+			ret += sprintf(&buf[ret], "[%s] ", led_src_texts[i]);
+		else
+			ret += sprintf(&buf[ret], "%s ", led_src_texts[i]);
+
+	mutex_unlock(&led->mutex);
+
+	ret += sprintf(&buf[ret], "\n");
+
+	return ret;
+}
+
+static ssize_t wm831x_status_src_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct wm831x_status *led = to_wm831x_status(led_cdev);
+	char name[20];
+	int i;
+	size_t len;
+
+	name[sizeof(name) - 1] = '\0';
+	strncpy(name, buf, sizeof(name) - 1);
+	len = strlen(name);
+
+	if (len && name[len - 1] == '\n')
+		name[len - 1] = '\0';
+
+	for (i = 0; i < ARRAY_SIZE(led_src_texts); i++) {
+		if (!strcmp(name, led_src_texts[i])) {
+			mutex_lock(&led->mutex);
+
+			led->src = i;
+			schedule_work(&led->work);
+
+			mutex_unlock(&led->mutex);
+		}
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(src, 0644, wm831x_status_src_show, wm831x_status_src_store);
+
+static int wm831x_status_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_pdata *chip_pdata;
+	struct wm831x_status_pdata pdata;
+	struct wm831x_status *drvdata;
+	struct resource *res;
+	int id = pdev->id % ARRAY_SIZE(chip_pdata->status);
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "No I/O resource\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	drvdata = kzalloc(sizeof(struct wm831x_status), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+	dev_set_drvdata(&pdev->dev, drvdata);
+
+	drvdata->wm831x = wm831x;
+	drvdata->reg = res->start;
+
+	if (wm831x->dev->platform_data)
+		chip_pdata = wm831x->dev->platform_data;
+	else
+		chip_pdata = NULL;
+
+	memset(&pdata, 0, sizeof(pdata));
+	if (chip_pdata && chip_pdata->status[id])
+		memcpy(&pdata, chip_pdata->status[id], sizeof(pdata));
+	else
+		pdata.name = dev_name(&pdev->dev);
+
+	mutex_init(&drvdata->mutex);
+	INIT_WORK(&drvdata->work, wm831x_status_work);
+	spin_lock_init(&drvdata->value_lock);
+
+	/* We cache the configuration register and read startup values
+	 * from it. */
+	drvdata->reg_val = wm831x_reg_read(wm831x, drvdata->reg);
+
+	if (drvdata->reg_val & WM831X_LED_MODE_MASK)
+		drvdata->brightness = LED_FULL;
+	else
+		drvdata->brightness = LED_OFF;
+
+	/* Set a default source if configured, otherwise leave the
+	 * current hardware setting.
+	 */
+	if (pdata.default_src == WM831X_STATUS_PRESERVE) {
+		drvdata->src = drvdata->reg_val;
+		drvdata->src &= WM831X_LED_SRC_MASK;
+		drvdata->src >>= WM831X_LED_SRC_SHIFT;
+	} else {
+		drvdata->src = pdata.default_src - 1;
+	}
+
+	drvdata->cdev.name = pdata.name;
+	drvdata->cdev.default_trigger = pdata.default_trigger;
+	drvdata->cdev.brightness_set = wm831x_status_set;
+	drvdata->cdev.blink_set = wm831x_status_blink_set;
+
+	ret = led_classdev_register(wm831x->dev, &drvdata->cdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
+		goto err_led;
+	}
+
+	ret = device_create_file(drvdata->cdev.dev, &dev_attr_src);
+	if (ret != 0)
+		dev_err(&pdev->dev,
+			"No source control for LED: %d\n", ret);
+
+	return 0;
+
+err_led:
+	led_classdev_unregister(&drvdata->cdev);
+	kfree(drvdata);
+err:
+	return ret;
+}
+
+static int wm831x_status_remove(struct platform_device *pdev)
+{
+	struct wm831x_status *drvdata = platform_get_drvdata(pdev);
+
+	device_remove_file(drvdata->cdev.dev, &dev_attr_src);
+	led_classdev_unregister(&drvdata->cdev);
+	kfree(drvdata);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_status_driver = {
+	.driver = {
+		   .name = "wm831x-status",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = wm831x_status_probe,
+	.remove = wm831x_status_remove,
+};
+
+static int __devinit wm831x_status_init(void)
+{
+	return platform_driver_register(&wm831x_status_driver);
+}
+module_init(wm831x_status_init);
+
+static void wm831x_status_exit(void)
+{
+	platform_driver_unregister(&wm831x_status_driver);
+}
+module_exit(wm831x_status_exit);
+
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("WM831x status LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-status");
diff --git a/include/linux/mfd/wm831x/status.h b/include/linux/mfd/wm831x/status.h
new file mode 100644
index 0000000..6bc090d
--- /dev/null
+++ b/include/linux/mfd/wm831x/status.h
@@ -0,0 +1,34 @@
+/*
+ * include/linux/mfd/wm831x/status.h -- Status LEDs for WM831x
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM831X_STATUS_H__
+#define __MFD_WM831X_STATUS_H__
+
+#define WM831X_LED_SRC_MASK                    0xC000  /* LED_SRC - [15:14] */
+#define WM831X_LED_SRC_SHIFT                       14  /* LED_SRC - [15:14] */
+#define WM831X_LED_SRC_WIDTH                        2  /* LED_SRC - [15:14] */
+#define WM831X_LED_MODE_MASK                   0x0300  /* LED_MODE - [9:8] */
+#define WM831X_LED_MODE_SHIFT                       8  /* LED_MODE - [9:8] */
+#define WM831X_LED_MODE_WIDTH                       2  /* LED_MODE - [9:8] */
+#define WM831X_LED_SEQ_LEN_MASK                0x0030  /* LED_SEQ_LEN - [5:4] */
+#define WM831X_LED_SEQ_LEN_SHIFT                    4  /* LED_SEQ_LEN - [5:4] */
+#define WM831X_LED_SEQ_LEN_WIDTH                    2  /* LED_SEQ_LEN - [5:4] */
+#define WM831X_LED_DUR_MASK                    0x000C  /* LED_DUR - [3:2] */
+#define WM831X_LED_DUR_SHIFT                        2  /* LED_DUR - [3:2] */
+#define WM831X_LED_DUR_WIDTH                        2  /* LED_DUR - [3:2] */
+#define WM831X_LED_DUTY_CYC_MASK               0x0003  /* LED_DUTY_CYC - [1:0] */
+#define WM831X_LED_DUTY_CYC_SHIFT                   0  /* LED_DUTY_CYC - [1:0] */
+#define WM831X_LED_DUTY_CYC_WIDTH                   2  /* LED_DUTY_CYC - [1:0] */
+
+#endif
-- 
1.6.3.3

