Return-Path: <linux-kernel-owner+w=401wt.eu-S935138AbZLGOIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138AbZLGOIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935078AbZLGOIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:08:24 -0500
Received: from openezx.org ([213.95.46.71]:56158 "EHLO openezx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935087AbZLGOIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:08:23 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Daniel Ribeiro <drwyrm@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       openezx-devel@lists.openezx.org,
       Linus Walleij <linus.ml.walleij@gmail.com>
Subject: [PATCH v2] leds: Add LED class driver for regulator driven LEDs.
Date: Mon,  7 Dec 2009 15:08:13 +0100
Message-Id: <1260194893-30149-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides an interface for controlling LEDs (or vibrators)
connected to PMICs for which there is a regulator framework driver.

This driver can be used, for instance, to control vibrator on all Motorola EZX
phones using the pcap-regulator driver services.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Addressed the observations from Mark Brown, Liam Girdwood and Linus Walleij.

Patch against:
git://git.o-hand.com/linux-rpurdie-leds for-mm

Changes since v1:
 - Use "vled" as supply id.
 - use regulator_get_exclusive
 - remove double semicolon
 - check for LED_OFF instead of 0
 - handle regulators which can't change voltages
 - rename led_regulator_get_vdd to led_regulator_get_voltage
 - split regulator_led_set_value out of led_work
 - allow setting an initial brightness value
 - fix sections markers (__devinit, __devexit, etc.)

The only slight doubt I still have is about
led_regulator_get_max_brightness(), I have to use regulator_set_voltage() there
to tell if a regulator has REGULATOR_CHANGE_VOLTAGE enabled.

Regards,
   Antonio

 drivers/leds/Kconfig           |    6 +
 drivers/leds/Makefile          |    1 +
 drivers/leds/leds-regulator.c  |  242 ++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-regulator.h |   46 ++++++++
 4 files changed, 295 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-regulator.c
 create mode 100644 include/linux/leds-regulator.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f12a996..8a0e1ec 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -229,6 +229,12 @@ config LEDS_PWM
 	help
 	  This option enables support for pwm driven LEDs
 
+config LEDS_REGULATOR
+	tristate "REGULATOR driven LED support"
+	depends on LEDS_CLASS && REGULATOR
+	help
+	  This option enables support for regulator driven LEDs.
+
 config LEDS_BD2802
 	tristate "LED driver for BD2802 RGB LED"
 	depends on LEDS_CLASS && I2C
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 176f0c6..9e63869 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
+obj-$(CONFIG_LEDS_REGULATOR)		+= leds-regulator.o
 obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
 obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
 obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
diff --git a/drivers/leds/leds-regulator.c b/drivers/leds/leds-regulator.c
new file mode 100644
index 0000000..7f00de3
--- /dev/null
+++ b/drivers/leds/leds-regulator.c
@@ -0,0 +1,242 @@
+/*
+ * leds-regulator.c - LED class driver for regulator driven LEDs.
+ *
+ * Copyright (C) 2009 Antonio Ospite <ospite@studenti.unina.it>
+ *
+ * Inspired by leds-wm8350 driver.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+#include <linux/leds-regulator.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+
+#define to_regulator_led(led_cdev) \
+	container_of(led_cdev, struct regulator_led, cdev)
+
+struct regulator_led {
+	struct led_classdev cdev;
+	enum led_brightness value;
+	int enabled;
+	struct mutex mutex;
+	struct work_struct work;
+
+	struct regulator *vcc;
+};
+
+static inline int led_regulator_get_max_brightness(struct regulator *supply)
+{
+	int ret;
+	int voltage = regulator_list_voltage(supply, 0);
+
+	if (voltage <= 0)
+		return 1;
+
+	/* even if regulator can't change voltages,
+	 * we still assume it can change status
+	 * and the LED can be turned on and off.
+	 */
+	ret = regulator_set_voltage(supply, voltage, voltage);
+	if (ret < 0)
+		return 1;
+
+	return regulator_count_voltages(supply);
+}
+
+static int led_regulator_get_voltage(struct regulator *supply,
+		enum led_brightness brightness)
+{
+	if (brightness == 0)
+		return -EINVAL;
+
+	return regulator_list_voltage(supply, brightness - 1);
+}
+
+
+static void regulator_led_enable(struct regulator_led *led)
+{
+	int ret;
+
+	if (led->enabled)
+		return;
+
+	ret = regulator_enable(led->vcc);
+	if (ret != 0) {
+		dev_err(led->cdev.dev, "Failed to enable vcc: %d\n", ret);
+		return;
+	}
+
+	led->enabled = 1;
+}
+
+static void regulator_led_disable(struct regulator_led *led)
+{
+	int ret;
+
+	if (!led->enabled)
+		return;
+
+	ret = regulator_disable(led->vcc);
+	if (ret != 0) {
+		dev_err(led->cdev.dev, "Failed to disable vcc: %d\n", ret);
+		return;
+	}
+
+	led->enabled = 0;
+}
+
+static void regulator_led_set_value(struct regulator_led *led)
+{
+	int voltage;
+	int ret;
+
+	mutex_lock(&led->mutex);
+
+	if (led->value == LED_OFF) {
+		regulator_led_disable(led);
+		goto out;
+	}
+
+	if (led->cdev.max_brightness > 1) {
+		voltage = led_regulator_get_voltage(led->vcc, led->value);
+		dev_dbg(led->cdev.dev, "brightness: %d voltage: %d\n",
+				led->value, voltage);
+
+		ret = regulator_set_voltage(led->vcc, voltage, voltage);
+		if (ret != 0)
+			dev_err(led->cdev.dev, "Failed to set voltage %d: %d\n",
+				voltage, ret);
+	}
+
+	regulator_led_enable(led);
+
+out:
+	mutex_unlock(&led->mutex);
+}
+
+static void led_work(struct work_struct *work)
+{
+	struct regulator_led *led;
+
+	led = container_of(work, struct regulator_led, work);
+	regulator_led_set_value(led);
+}
+
+static void regulator_led_brightness_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct regulator_led *led = to_regulator_led(led_cdev);
+
+	led->value = value;
+	schedule_work(&led->work);
+}
+
+static int __devinit regulator_led_probe(struct platform_device *pdev)
+{
+	struct led_regulator_platform_data *pdata = pdev->dev.platform_data;
+	struct regulator_led *led;
+	struct regulator *vcc;
+	int ret = 0;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "no platform data\n");
+		return -ENODEV;
+	}
+
+	vcc = regulator_get_exclusive(&pdev->dev, "vled");
+	if (IS_ERR(vcc)) {
+		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
+		return PTR_ERR(vcc);
+	}
+
+	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	if (led == NULL) {
+		ret = -ENOMEM;
+		goto err_vcc;
+	}
+
+	led->cdev.max_brightness = led_regulator_get_max_brightness(vcc);
+	if (pdata->brightness > led->cdev.max_brightness) {
+		dev_err(&pdev->dev, "Invalid default brightness %d\n",
+				pdata->brightness);
+		ret = -EINVAL;
+		goto err_led;
+	}
+	led->value = pdata->brightness;
+
+	led->cdev.brightness_set = regulator_led_brightness_set;
+	led->cdev.name = pdata->name;
+	led->cdev.flags |= LED_CORE_SUSPENDRESUME;
+	led->vcc = vcc;
+
+	mutex_init(&led->mutex);
+	INIT_WORK(&led->work, led_work);
+
+	platform_set_drvdata(pdev, led);
+
+	ret = led_classdev_register(&pdev->dev, &led->cdev);
+	if (ret < 0) {
+		cancel_work_sync(&led->work);
+		goto err_led;
+	}
+
+	/* to expose the default value to userspace */
+	led->cdev.brightness = led->value;
+
+	/* Set the default led status */
+	regulator_led_set_value(led);
+
+	return 0;
+
+err_led:
+	kfree(led);
+err_vcc:
+	regulator_put(vcc);
+	return ret;
+}
+
+static int __devexit regulator_led_remove(struct platform_device *pdev)
+{
+	struct regulator_led *led = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&led->cdev);
+	cancel_work_sync(&led->work);
+	regulator_led_disable(led);
+	regulator_put(led->vcc);
+	kfree(led);
+	return 0;
+}
+
+static struct platform_driver regulator_led_driver = {
+	.driver = {
+		   .name  = "leds-regulator",
+		   .owner = THIS_MODULE,
+		   },
+	.probe  = regulator_led_probe,
+	.remove = __devexit_p(regulator_led_remove),
+};
+
+static int __init regulator_led_init(void)
+{
+	return platform_driver_register(&regulator_led_driver);
+}
+module_init(regulator_led_init);
+
+static void __exit regulator_led_exit(void)
+{
+	platform_driver_unregister(&regulator_led_driver);
+}
+module_exit(regulator_led_exit);
+
+MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
+MODULE_DESCRIPTION("Regulator driven LED driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-regulator");
diff --git a/include/linux/leds-regulator.h b/include/linux/leds-regulator.h
new file mode 100644
index 0000000..a40275a
--- /dev/null
+++ b/include/linux/leds-regulator.h
@@ -0,0 +1,46 @@
+/*
+ * leds-regulator.h - platform data structure for regulator driven LEDs.
+ *
+ * Copyright (C) 2009 Antonio Ospite <ospite@studenti.unina.it>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __LINUX_LEDS_REGULATOR_H
+#define __LINUX_LEDS_REGULATOR_H
+
+/*
+ * Use "vled" as supply id when declaring the regulator consumer:
+ *
+ * static struct regulator_consumer_supply pcap_regulator_VVIB_consumers [] = {
+ * 	{ .dev_name = "leds-regulator.0", supply = "vled" },
+ * };
+ *
+ * If you have several regulator driven LEDs, you can append a numerical id to
+ * .dev_name as done above, and use the same id when declaring the platform
+ * device:
+ *
+ * static struct led_regulator_platform_data a780_vibrator_data = {
+ * 	.name   = "a780::vibrator",
+ * };
+ *
+ * static struct platform_device a780_vibrator = {
+ * 	.name = "leds-regulator",
+ * 	.id   = 0,
+ * 	.dev  = {
+ * 		.platform_data = &a780_vibrator_data,
+ * 	},
+ * };
+ */
+
+#include <linux/leds.h>
+
+struct led_regulator_platform_data {
+	char *name;                     /* LED name as expected by LED class */
+	enum led_brightness brightness; /* initial brightness value */
+};
+
+#endif /* __LINUX_LEDS_REGULATOR_H */
-- 
1.6.5.4

