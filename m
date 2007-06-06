Return-Path: <linux-kernel-owner+w=401wt.eu-S933638AbXFFRbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbXFFRbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763714AbXFFRbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:31:16 -0400
Received: from mta-ps-be-02.sunrise.ch ([194.158.229.40]:38955 "EHLO
	mail-ps.sunrise.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761061AbXFFRbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:31:13 -0400
Message-Id: <200706061902.06738.robin.farine@terminus.org>
In-Reply-To: <ab8cd0edce36b4ea93429c7ab695f5a967b11365.1181149111.git.robin.farine@terminus.org>
References: <ab8cd0edce36b4ea93429c7ab695f5a967b11365.1181149111.git.robin.farine@terminus.org>
From: Robin Farine <robin.farine@terminus.org>
Date: Wed, 6 Jun 2007 19:02:06 +0200
Subject: [PATCH 2/2] LEDS: generic driver
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Farine <robin.farine@terminus.org>

This generic LED driver implements the platform independent part of a
LED driver letting platform specific code focus on the hardware
details. The driver binds to platform devices named "Generic-LED"
which provide the platform specific data and code needed to act on an
LED.

This is useful for platforms with exotic ways of controlling LEDs
which preclude the use of a common LED driver such as GPIO based
drivers.

Signed-off-by: Robin Farine <robin.farine@terminus.org>
---
 drivers/leds/Kconfig        |    7 ++
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-generic.c |  129 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds.h        |   17 ++++++
 4 files changed, 154 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-generic.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 87d2046..cbf19f8 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -95,6 +95,13 @@ config LEDS_COBALT
 	help
 	  This option enables support for the front LED on Cobalt Server
 
+config LEDS_GENERIC
+	tristate "Generic LED driver"
+	depends on LEDS_CLASS
+	help
+	  This option enables the generic LED driver that binds to
+	  platform devices named "Generic-LED".
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index aa2c18e..238abb4 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_GENERIC)		+= leds-generic.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff --git a/drivers/leds/leds-generic.c b/drivers/leds/leds-generic.c
new file mode 100644
index 0000000..f981ac6
--- /dev/null
+++ b/drivers/leds/leds-generic.c
@@ -0,0 +1,129 @@
+/*
+ * Generic LED driver
+ *
+ * This driver binds to platform devices named "Generic-LED". Platform specific
+ * code declares LEDs by registering one such platform device per LED with its
+ * dev.platform_data field pointing to an instance of struct led_generic_data or
+ * to an extension of it. The led_generic_data's name and brightness_set fields
+ * must be initialized to point to a valid string and function respectively.
+ *
+ * Copyright (C) 2007 Robin Farine <robin.farine@terminus.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+
+struct led_generic_device {
+	struct led_classdev super;
+	struct led_generic_data *pdata;
+};
+
+static inline struct led_generic_device *pdev_to_led(
+	struct platform_device *pdev)
+{
+	return platform_get_drvdata(pdev);
+}
+
+static inline struct led_generic_device *cdev_to_led(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct led_generic_device, super);
+}
+
+#ifdef CONFIG_PM
+static int leds_generic_suspend(struct platform_device *pdev,
+	pm_message_t state)
+{
+	struct led_generic_device *led = pdev_to_led(pdev);
+
+	(void)state;
+	led_classdev_suspend(&led->super);
+	return 0;
+}
+
+static int leds_generic_resume(struct platform_device *pdev)
+{
+	struct led_generic_device *led = pdev_to_led(pdev);
+
+	led_classdev_resume(&led->super);
+	return 0;
+}
+#else
+# define leds_generic_suspend NULL
+# define leds_generic_resume NULL
+#endif /* CONFIG_PM */
+
+static void leds_generic_set_brightness(struct led_classdev *cdev,
+					enum led_brightness brightness)
+{
+	struct led_generic_data *pdata = cdev_to_led(cdev)->pdata;
+
+	pdata->brightness_set(pdata, brightness);
+}
+
+static int leds_generic_remove(struct platform_device *pdev)
+{
+	struct led_generic_device *led = pdev_to_led(pdev);
+
+	led_classdev_unregister(&led->super);
+	platform_set_drvdata(pdev, NULL);
+	kfree(led);
+	return 0;
+}
+
+static int leds_generic_probe(struct platform_device *pdev)
+{
+	struct led_generic_device *led;
+	struct led_generic_data *pdata = pdev->dev.platform_data;
+	int res = 0;
+
+	led = kzalloc(sizeof(struct led_generic_device), GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&pdev->dev, "no memory for LED device\n");
+		res = -ENOMEM;
+		goto out;
+	}
+	led->super.name = pdata->name;
+	led->super.brightness_set = leds_generic_set_brightness;
+	led->super.default_trigger = pdata->trigger;
+	led->pdata = pdata;
+	platform_set_drvdata(pdev, led);
+	res = led_classdev_register(&pdev->dev, &led->super);
+	if (res < 0) {
+		dev_err(&pdev->dev, "could not register LED device\n");
+		platform_set_drvdata(pdev, NULL);
+		kfree(led);
+	}
+ out:
+	return res;
+}
+
+static struct platform_driver leds_generic_driver = {
+	.driver.name	= "Generic-LED",
+	.probe		= leds_generic_probe,
+	.remove		= leds_generic_remove,
+	.suspend	= leds_generic_suspend,
+	.resume		= leds_generic_resume,
+};
+
+static int __init leds_generic_init(void)
+{
+	return platform_driver_register(&leds_generic_driver);
+}
+
+static void __exit leds_generic_exit(void)
+{
+	platform_driver_unregister(&leds_generic_driver);
+}
+
+module_init(leds_generic_init);
+module_exit(leds_generic_exit);
+
+MODULE_AUTHOR("Robin Farine <robin.farine@terminus.org>");
+MODULE_DESCRIPTION("Generic LED driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 958a14d..c688304 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -27,6 +27,23 @@ enum led_brightness {
 	LED_FULL	= 255,
 };
 
+/*
+ * Generic LED driver platform data.
+ *
+ * A generic LED is represented by a platform device named "Generic-LED" with
+ * its dev.platform_data field set to point to an initialized instance of struct
+ * led_generic_data or to an extension of it. The led_generic_data's name and
+ * brightness_set fields must be initialized to point to a valid string and
+ * function respectively. The trigger field, if non-NULL, is used to tie the LED
+ * to a default trigger.
+ */
+struct led_generic_data {
+	const char *name;
+	const char *trigger;
+	void (*brightness_set)(const struct led_generic_data *led_data,
+			       enum led_brightness brightness);
+};
+
 struct led_classdev {
 	const char		*name;
 	int			 brightness;
-- 
1.5.2.1

