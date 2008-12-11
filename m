Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYLKVwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYLKVwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYLKVwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:52:13 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:45081 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757541AbYLKVwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:52:10 -0500
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Trent Piepho <tpiepho@freescale.com>, devicetree-discuss@ozlabs.org,
       Grant Likely <grant.likely@secretlab.ca>,
       Sean MacLennan <smaclennan@pikatech.com>
Subject: [PATCH v2 1/4] leds: Support OpenFirmware led bindings
Date: Thu, 11 Dec 2008 13:49:55 -0800
Message-Id: <1229032198-19775-1-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bindings to support LEDs defined as of_platform devices in addition to
the existing bindings for platform devices.

New options in Kconfig allow the platform binding code and/or the
of_platform code to be turned on.  The of_platform code is of course only
available on archs that have OF support.

The existing probe and remove methods are refactored to use new functions
create_gpio_led(), to create and register one led, and delete_gpio_led(),
to unregister and free one led.  The new probe and remove methods for the
of_platform driver can then share most of the common probe and remove code
with the platform driver.

The suspend and resume methods aren't shared, but they are very short.  The
actual led driving code is the same for LEDs created by either binding.

The OF bindings are based on patch by Anton Vorontsov
<avorontsov@ru.mvista.com>.  They have been extended to allow multiple LEDs
per device.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Sean MacLennan <smaclennan@pikatech.com>
CC: devicetree-discuss@ozlabs.org
---
 Documentation/powerpc/dts-bindings/gpio/led.txt |   46 ++++-
 drivers/leds/Kconfig                            |   21 ++-
 drivers/leds/leds-gpio.c                        |  237 ++++++++++++++++++-----
 3 files changed, 250 insertions(+), 54 deletions(-)

diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
index ff51f4c..4fe14de 100644
--- a/Documentation/powerpc/dts-bindings/gpio/led.txt
+++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
@@ -1,15 +1,43 @@
-LED connected to GPIO
+LEDs connected to GPIO lines
 
 Required properties:
-- compatible : should be "gpio-led".
-- label : (optional) the label for this LED. If omitted, the label is
+- compatible : should be "gpio-leds".
+
+Each LED is represented as a sub-node of the gpio-leds device.  Each
+node's name represents the name of the corresponding LED.
+
+LED sub-node properties:
+- gpios :  Should specify the LED's GPIO, see "Specifying GPIO information
+  for devices" in Documentation/powerpc/booting-without-of.txt.  Active
+  low LEDs should be indicated using flags in the GPIO specifier.
+- label :  (optional) The label for this LED.  If omitted, the label is
   taken from the node name (excluding the unit address).
-- gpios : should specify LED GPIO.
+- linux,default-trigger :  (optional) This parameter, if present, is a
+  string defining the trigger assigned to the LED.  Current triggers are:
+    "backlight" - LED will act as a back-light, controlled by the framebuffer
+		  system
+    "default-on" - LED will turn on
+    "heartbeat" - LED "double" flashes at a load average based rate
+    "ide-disk" - LED indicates disk activity
+    "timer" - LED flashes at a fixed, configurable rate
 
-Example:
+Examples:
 
-led@0 {
-	compatible = "gpio-led";
-	label = "hdd";
-	gpios = <&mcu_pio 0 1>;
+leds {
+	compatible = "gpio-leds";
+	hdd {
+		label = "IDE Activity";
+		gpios = <&mcu_pio 0 1>; /* Active low */
+		linux,default-trigger = "ide-disk";
+	};
 };
+
+run-control {
+	compatible = "gpio-leds";
+	red {
+		gpios = <&mpc8572 6 0>;
+	};
+	green {
+		gpios = <&mpc8572 7 0>;
+	};
+}
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e7fb7d2..6c6dc96 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -111,7 +111,26 @@ config LEDS_GPIO
 	help
 	  This option enables support for the LEDs connected to GPIO
 	  outputs. To be useful the particular board must have LEDs
-	  and they must be connected to the GPIO lines.
+	  and they must be connected to the GPIO lines.  The LEDs must be
+	  defined as platform devices and/or OpenFirmware platform devices.
+	  The code to use these bindings can be selected below.
+
+config LEDS_GPIO_PLATFORM
+	bool "Platform device bindings for GPIO LEDs"
+	depends on LEDS_GPIO
+	default y
+	help
+	  Let the leds-gpio driver drive LEDs which have been defined as
+	  platform devices.  If you don't know what this means, say yes.
+
+config LEDS_GPIO_OF
+	bool "OpenFirmware platform device bindings for GPIO LEDs"
+	depends on LEDS_GPIO && OF_DEVICE
+	default y
+	help
+	  Let the leds-gpio driver drive LEDs which have been defined as
+	  of_platform devices.  For instance, LEDs which are listed in a "dts"
+	  file.
 
 config LEDS_HP_DISK
 	tristate "LED Support for disk protection LED on HP notebooks"
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index b13bd29..be4d6aa 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2007 8D Technologies inc.
  * Raphael Assenat <raph@8d.com>
+ * Copyright (C) 2008 Freescale Semiconductor, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -71,50 +72,72 @@ static int gpio_blink_set(struct led_classdev *led_cdev,
 	return led_dat->platform_gpio_blink_set(led_dat->gpio, delay_on, delay_off);
 }
 
-static int gpio_led_probe(struct platform_device *pdev)
+static int __devinit create_gpio_led(const struct gpio_led *template,
+	struct gpio_led_data *led_dat, struct device *parent,
+	int (*blink_set)(unsigned, unsigned long *, unsigned long *))
+{
+	int ret;
+
+	ret = gpio_request(template->gpio, template->name);
+	if (ret < 0)
+		return ret;
+
+	led_dat->cdev.name = template->name;
+	led_dat->cdev.default_trigger = template->default_trigger;
+	led_dat->gpio = template->gpio;
+	led_dat->can_sleep = gpio_cansleep(template->gpio);
+	led_dat->active_low = template->active_low;
+	if (blink_set) {
+		led_dat->platform_gpio_blink_set = blink_set;
+		led_dat->cdev.blink_set = gpio_blink_set;
+	}
+	led_dat->cdev.brightness_set = gpio_led_set;
+	led_dat->cdev.brightness = LED_OFF;
+
+	ret = gpio_direction_output(led_dat->gpio, led_dat->active_low);
+	if (ret < 0)
+		goto err;
+
+	INIT_WORK(&led_dat->work, gpio_led_work);
+
+	ret = led_classdev_register(parent, &led_dat->cdev);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+err:
+	gpio_free(led_dat->gpio);
+	return ret;
+}
+
+static void delete_gpio_led(struct gpio_led_data *led)
+{
+	led_classdev_unregister(&led->cdev);
+	cancel_work_sync(&led->work);
+	gpio_free(led->gpio);
+}
+
+/* Code to creates LEDs from platform devices */
+#ifdef CONFIG_LEDS_GPIO_PLATFORM
+static int __devinit gpio_led_probe(struct platform_device *pdev)
 {
 	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
-	struct gpio_led *cur_led;
-	struct gpio_led_data *leds_data, *led_dat;
+	struct gpio_led_data *leds_data;
 	int i, ret = 0;
 
 	if (!pdata)
 		return -EBUSY;
 
 	leds_data = kzalloc(sizeof(struct gpio_led_data) * pdata->num_leds,
-				GFP_KERNEL);
+			    GFP_KERNEL);
 	if (!leds_data)
 		return -ENOMEM;
 
 	for (i = 0; i < pdata->num_leds; i++) {
-		cur_led = &pdata->leds[i];
-		led_dat = &leds_data[i];
-
-		ret = gpio_request(cur_led->gpio, cur_led->name);
+		ret = create_gpio_led(&pdata->leds[i], &leds_data[i],
+				      &pdev->dev, pdata->gpio_blink_set);
 		if (ret < 0)
 			goto err;
-
-		led_dat->cdev.name = cur_led->name;
-		led_dat->cdev.default_trigger = cur_led->default_trigger;
-		led_dat->gpio = cur_led->gpio;
-		led_dat->can_sleep = gpio_cansleep(cur_led->gpio);
-		led_dat->active_low = cur_led->active_low;
-		if (pdata->gpio_blink_set) {
-			led_dat->platform_gpio_blink_set = pdata->gpio_blink_set;
-			led_dat->cdev.blink_set = gpio_blink_set;
-		}
-		led_dat->cdev.brightness_set = gpio_led_set;
-		led_dat->cdev.brightness = LED_OFF;
-
-		gpio_direction_output(led_dat->gpio, led_dat->active_low);
-
-		INIT_WORK(&led_dat->work, gpio_led_work);
-
-		ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
-		if (ret < 0) {
-			gpio_free(led_dat->gpio);
-			goto err;
-		}
 	}
 
 	platform_set_drvdata(pdev, leds_data);
@@ -122,13 +145,8 @@ static int gpio_led_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	if (i > 0) {
-		for (i = i - 1; i >= 0; i--) {
-			led_classdev_unregister(&leds_data[i].cdev);
-			cancel_work_sync(&leds_data[i].work);
-			gpio_free(leds_data[i].gpio);
-		}
-	}
+	for (i = i - 1; i >= 0; i--)
+		delete_gpio_led(&leds_data[i]);
 
 	kfree(leds_data);
 
@@ -143,11 +161,8 @@ static int __devexit gpio_led_remove(struct platform_device *pdev)
 
 	leds_data = platform_get_drvdata(pdev);
 
-	for (i = 0; i < pdata->num_leds; i++) {
-		led_classdev_unregister(&leds_data[i].cdev);
-		cancel_work_sync(&leds_data[i].work);
-		gpio_free(leds_data[i].gpio);
-	}
+	for (i = 0; i < pdata->num_leds; i++)
+		delete_gpio_led(&leds_data[i]);
 
 	kfree(leds_data);
 
@@ -211,7 +226,141 @@ static void __exit gpio_led_exit(void)
 module_init(gpio_led_init);
 module_exit(gpio_led_exit);
 
-MODULE_AUTHOR("Raphael Assenat <raph@8d.com>");
+MODULE_ALIAS("platform:leds-gpio");
+#endif /* CONFIG_LEDS_GPIO_PLATFORM */
+
+/* Code to create from OpenFirmware platform devices */
+#ifdef CONFIG_LEDS_GPIO_OF
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+
+struct gpio_led_of_platform_data {
+	int num_leds;
+	struct gpio_led_data led_data[];
+};
+
+static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
+					const struct of_device_id *match)
+{
+	struct device_node *np = ofdev->node, *child;
+	struct gpio_led led;
+	struct gpio_led_of_platform_data *pdata;
+	int count = 0, ret;
+
+	/* count LEDs defined by this device, so we know how much to allocate */
+	for_each_child_of_node(np, child)
+		count++;
+	if (!count)
+		return 0; /* or ENODEV? */
+
+	pdata = kzalloc(sizeof(*pdata) + sizeof(struct gpio_led_data) * count,
+			GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	memset(&led, 0, sizeof(led));
+	for_each_child_of_node(np, child) {
+		enum of_gpio_flags flags;
+
+		led.gpio = of_get_gpio_flags(child, 0, &flags);
+		led.active_low = flags & OF_GPIO_ACTIVE_LOW;
+		led.name = of_get_property(child, "label", NULL) ? : child->name;
+		led.default_trigger =
+			of_get_property(child, "linux,default-trigger", NULL);
+
+		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
+				      &ofdev->dev, NULL);
+		if (ret < 0) {
+			of_node_put(child);
+			goto err;
+		}
+	}
+
+	dev_set_drvdata(&ofdev->dev, pdata);
+
+	return 0;
+
+err:
+	for (count = pdata->num_leds - 2; count >= 0; count--)
+		delete_gpio_led(&pdata->led_data[count]);
+
+	kfree(pdata);
+
+	return ret;
+}
+
+static int __devexit of_gpio_leds_remove(struct of_device *ofdev)
+{
+	struct gpio_led_of_platform_data *pdata = dev_get_drvdata(&ofdev->dev);
+	int i;
+
+	for (i = 0; i < pdata->num_leds; i++)
+		delete_gpio_led(&pdata->led_data[i]);
+
+	kfree(pdata);
+
+	dev_set_drvdata(&ofdev->dev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int of_gpio_led_suspend(struct of_device *ofdev, pm_message_t state)
+{
+	struct gpio_led_of_platform_data *pdata = dev_get_drvdata(&ofdev->dev);
+	int i;
+
+	for (i = 0; i < pdata->num_leds; i++)
+		led_classdev_suspend(&pdata->leds_data[i].cdev);
+
+	return 0;
+}
+
+static int of_gpio_led_resume(struct of_device *ofdev)
+{
+	struct gpio_led_of_platform_data *pdata = dev_get_drvdata(&ofdev->dev);
+	int i;
+
+	for (i = 0; i < pdata->num_leds; i++)
+		led_classdev_resume(&pdata->leds_data[i].cdev);
+
+	return 0;
+}
+#else
+#define of_gpio_led_suspend NULL
+#define of_gpio_led_resume NULL
+#endif /* CONFIG_PM */
+
+static const struct of_device_id of_gpio_leds_match[] = {
+	{ .compatible = "gpio-leds", },
+	{},
+};
+
+static struct of_platform_driver of_gpio_leds_driver = {
+	.driver = {
+		.name = "of_gpio_leds",
+		.owner = THIS_MODULE,
+	},
+	.match_table = of_gpio_leds_match,
+	.probe = of_gpio_leds_probe,
+	.remove = __devexit_p(of_gpio_leds_remove),
+	.suspend = of_gpio_led_suspend,
+	.resume = of_gpio_led_resume,
+};
+
+static int __init of_gpio_leds_init(void)
+{
+	return of_register_platform_driver(&of_gpio_leds_driver);
+}
+module_init(of_gpio_leds_init);
+
+static void __exit of_gpio_leds_exit(void)
+{
+	of_unregister_platform_driver(&of_gpio_leds_driver);
+}
+module_exit(of_gpio_leds_exit);
+#endif
+
+MODULE_AUTHOR("Raphael Assenat <raph@8d.com>, Trent Piepho <tpiepho@freescale.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:leds-gpio");
-- 
1.5.4.1

