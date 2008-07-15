Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYGOMk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYGOMk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYGOMkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:40:16 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:5452 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754205AbYGOMkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:40:14 -0400
Date: Tue, 15 Jul 2008 16:40:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v2] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080715124013.GA13086@polina.dev.rtsoft.ru>
References: <20080715123822.GA10893@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080715123822.GA10893@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite leds-gpio and leds-of-gpio similar names and purposes, there
is not much code can be shared between the two drivers (both are mostly
driver bindings anyway).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 Documentation/powerpc/dts-bindings/gpio/led.txt |   15 ++
 drivers/leds/Kconfig                            |    8 +
 drivers/leds/Makefile                           |    1 +
 drivers/leds/leds-of-gpio.c                     |  193 +++++++++++++++++++++++
 4 files changed, 217 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/gpio/led.txt
 create mode 100644 drivers/leds/leds-of-gpio.c

diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
new file mode 100644
index 0000000..7e9ce81
--- /dev/null
+++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
@@ -0,0 +1,15 @@
+LED connected to GPIO
+
+Required properties:
+- compatible : should be "gpio-led".
+- label : (optional) the label for this LED. If omitted, the label is
+  taken from the node name (excluding the unit address).
+- gpios : should specify LED GPIO.
+
+Example:
+
+led@0 {
+	compatible = "gpio-led";
+	label = "hdd";
+	gpios = <&mcu_pio 0 0>;
+};
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 1c35dfa..ad7eab3 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -119,6 +119,14 @@ config LEDS_GPIO
 	  outputs. To be useful the particular board must have LEDs
 	  and they must be connected to the GPIO lines.
 
+config LEDS_OF_GPIO
+	tristate "LED Support for GPIO connected LEDs (OpenFirmware bindings)"
+	depends on LEDS_CLASS && OF_GPIO
+	help
+	  This option enables support for the LEDs connected to GPIO
+	  outputs. To be useful the particular board must have LEDs
+	  and they must be connected to the GPIO lines.
+
 config LEDS_CM_X270
 	tristate "LED Support for the CM-X270 LEDs"
 	depends on LEDS_CLASS && MACH_ARMCORE
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 7156f99..593775c 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
+obj-$(CONFIG_LEDS_OF_GPIO)		+= leds-of-gpio.o
 obj-$(CONFIG_LEDS_CM_X270)              += leds-cm-x270.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
diff --git a/drivers/leds/leds-of-gpio.c b/drivers/leds/leds-of-gpio.c
new file mode 100644
index 0000000..02c4290
--- /dev/null
+++ b/drivers/leds/leds-of-gpio.c
@@ -0,0 +1,193 @@
+/*
+ * LEDs driver for GPIOs (OpenFirmware bindings)
+ *
+ * Copyright (C) 2007 8D Technologies inc.
+ * Raphael Assenat <raph@8d.com>
+ * Copyright (C) 2008 MontaVista Software, Inc.
+ * Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+
+struct of_gpio_led {
+	struct device_node *np;
+	struct led_classdev cdev;
+	unsigned int gpio;
+	struct work_struct work;
+	u8 new_level;
+	u8 can_sleep;
+};
+
+static void gpio_led_work(struct work_struct *work)
+{
+	struct of_gpio_led *led = container_of(work, struct of_gpio_led, work);
+
+	gpio_set_value_cansleep(led->gpio, led->new_level);
+}
+
+static void gpio_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness value)
+{
+	struct of_gpio_led *led = container_of(led_cdev, struct of_gpio_led,
+					       cdev);
+	int level;
+
+	if (value == LED_OFF)
+		level = 0;
+	else
+		level = 1;
+
+	/* Setting GPIOs with I2C/etc requires a task context, and we don't
+	 * seem to have a reliable way to know if we're already in one; so
+	 * let's just assume the worst.
+	 */
+	if (led->can_sleep) {
+		led->new_level = level;
+		schedule_work(&led->work);
+	} else {
+		gpio_set_value(led->gpio, level);
+	}
+}
+
+static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
+					const struct of_device_id *match)
+{
+	int ret;
+	struct of_gpio_led *led;
+	struct device_node *np = ofdev->node;
+
+	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->np = of_node_get(np);
+
+	ret = of_get_gpio(np, 0);
+	if (!gpio_is_valid(ret)) {
+		dev_err(&ofdev->dev, "gpio is invalid\n");
+		goto err_get_gpio;
+	}
+	led->gpio = ret;
+	led->can_sleep = gpio_cansleep(led->gpio);
+
+	led->cdev.name = of_get_property(np, "label", NULL);
+	if (!led->cdev.name)
+		led->cdev.name = dev_name(&ofdev->dev);
+	led->cdev.brightness_set = gpio_led_set;
+
+	ret = gpio_request(led->gpio, dev_name(&ofdev->dev));
+	if (ret < 0) {
+		dev_err(&ofdev->dev, "could not request gpio, status is %d\n",
+			ret);
+		goto err_gpio;
+	}
+
+	ret = gpio_direction_output(led->gpio, 0);
+	if (ret) {
+		dev_err(&ofdev->dev, "gpio could not be an output, "
+			"status is %d\n", ret);
+		goto err_gpio;
+	}
+
+	INIT_WORK(&led->work, gpio_led_work);
+	dev_set_drvdata(&ofdev->dev, led);
+
+	ret = led_classdev_register(&ofdev->dev, &led->cdev);
+	if (ret < 0) {
+		dev_err(&ofdev->dev, "could register led cdev, status is %d\n",
+			ret);
+		gpio_free(led->gpio);
+		goto err_reg_cdev;
+	}
+
+	return 0;
+
+err_reg_cdev:
+	cancel_work_sync(&led->work);
+err_gpio:
+	gpio_free(led->gpio);
+err_get_gpio:
+	of_node_put(led->np);
+	kfree(led);
+	return ret;
+}
+
+static int __devexit of_gpio_leds_remove(struct of_device *ofdev)
+{
+	struct of_gpio_led *led = dev_get_drvdata(&ofdev->dev);
+
+	led_classdev_unregister(&led->cdev);
+	cancel_work_sync(&led->work);
+	gpio_free(led->gpio);
+	of_node_put(led->np);
+	kfree(led);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int of_gpio_led_suspend(struct of_device *ofdev, pm_message_t state)
+{
+	struct of_gpio_led *led = dev_get_drvdata(&ofdev->dev);
+
+	led_classdev_suspend(&led->cdev);
+	return 0;
+}
+
+static int of_gpio_led_resume(struct of_device *ofdev)
+{
+	struct of_gpio_led *led = dev_get_drvdata(&ofdev->dev);
+
+	led_classdev_resume(&led->cdev);
+	return 0;
+}
+#else
+#define of_gpio_led_suspend NULL
+#define of_gpio_led_resume NULL
+#endif /* CONFIG_PM */
+
+static const struct of_device_id of_gpio_leds_match[] = {
+	{ .compatible = "gpio-led", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
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
+
+MODULE_DESCRIPTION("OF GPIO LED driver");
+MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.5.4
