Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZBPM1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZBPM1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZBPM1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:27:10 -0500
Received: from smtp.nokia.com ([192.100.122.230]:30208 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbZBPM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:27:08 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <me@felipe.balbi.com>, Richard Purdie <rpurdie@rpsys.net>,
       Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH] leds: triggers: introduce gpio led trigger
Date: Mon, 16 Feb 2009 14:12:04 +0200
Message-Id: <1234786324-4271-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.1.265.g9a013
X-OriginalArrivalTime: 16 Feb 2009 12:26:51.0002 (UTC) FILETIME=[D81805A0:01C99031]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <me@felipe.balbi.com>

The gpio led trigger will allow leds to be triggered by
gpio events.

There's a timer function that keeps checking the gpio
value in order to know when we need to turn leds on/off.

It's useful for usecases as n810's keypad leds that could
be triggered by the gpio event generated when user slides
up to show the keypad.

We also provide means for userland to tell us what is the
desired brightness for that special led when it goes on
so userland could use information from ambient light sensors
and not set led brightness too high if it's not necessary.

This trigger was tested with n810.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/leds/Kconfig        |   13 +++
 drivers/leds/Makefile       |    1 +
 drivers/leds/ledtrig-gpio.c |  229 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-gpio.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 7427136..2bd77d5 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -216,6 +216,19 @@ config LEDS_TRIGGER_BACKLIGHT
 
 	  If unsure, say N.
 
+config LEDS_TRIGGER_GPIO
+	tristate "LED GPIO Trigger"
+	depends on LEDS_TRIGGERS
+	depends on GPIOLIB
+	help
+	  This allows LEDs to be controlled by gpio events. It's good
+	  when using gpios as switches and triggering the needed LEDs
+	  from there. One use case is n810's keypad LEDs that could
+	  be triggered by this trigger when user slides up to show
+	  keypad.
+
+	  If unsure, say N.
+
 config LEDS_TRIGGER_DEFAULT_ON
 	tristate "LED Default ON Trigger"
 	depends on LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9d76f0f..c9e5d31 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -30,4 +30,5 @@ obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
+obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
new file mode 100644
index 0000000..af24dcf
--- /dev/null
+++ b/drivers/leds/ledtrig-gpio.c
@@ -0,0 +1,229 @@
+/*
+ * ledtrig-gio.c - LED Trigger Based on GPIO events
+ *
+ * Copyright 2009 Felipe Balbi <me@felipebalbi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+#include "leds.h"
+
+struct gpio_trig_data {
+	struct delayed_work work;
+	struct led_classdev *led;
+
+	unsigned desired_brightness;	/* desired brightness when led is on */
+	unsigned inverted;		/* true when gpio is inverted */
+	unsigned gpio;			/* gpio that triggers the leds */
+};
+
+static ssize_t gpio_trig_brightness_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	return sprintf(buf, "%u\n", gpio_data->desired_brightness);
+}
+
+static ssize_t gpio_trig_brightness_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t n)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+	unsigned desired_brightness;
+	int ret;
+
+	ret = sscanf(buf, "%u", &desired_brightness);
+	if (ret < 1 || desired_brightness > 255) {
+		dev_err(dev, "invalid value\n");
+		return -EINVAL;
+	}
+
+	gpio_data->desired_brightness = desired_brightness;
+
+	return n;
+}
+static DEVICE_ATTR(desired_brightness, 0644, gpio_trig_brightness_show,
+		gpio_trig_brightness_store);
+
+static ssize_t gpio_trig_inverted_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	return sprintf(buf, "%s\n", gpio_data->inverted ? "yes" : "no");
+}
+
+static ssize_t gpio_trig_inverted_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t n)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+	unsigned inverted;
+	int ret;
+
+	ret = sscanf(buf, "%u", &inverted);
+	if (ret < 1) {
+		dev_err(dev, "invalid value\n");
+		return -EINVAL;
+	}
+
+	gpio_data->inverted = !!inverted;
+
+	return n;
+}
+static DEVICE_ATTR(inverted, 0644, gpio_trig_inverted_show,
+		gpio_trig_inverted_store);
+
+static ssize_t gpio_trig_gpio_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	return sprintf(buf, "%u\n", gpio_data->gpio);
+}
+
+static ssize_t gpio_trig_gpio_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t n)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+	unsigned gpio;
+	int ret;
+
+	ret = sscanf(buf, "%u", &gpio);
+	if (ret < 1) {
+		dev_err(dev, "couldn't read gpio number\n");
+		cancel_delayed_work(&gpio_data->work);
+		return -EINVAL;
+	}
+
+	gpio_data->gpio = gpio;
+	schedule_delayed_work(&gpio_data->work, msecs_to_jiffies(50));
+
+	return n;
+}
+static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
+
+static void gpio_trig_work(struct work_struct *work)
+{
+	struct gpio_trig_data *gpio_data = container_of(work,
+			struct gpio_trig_data, work.work);
+
+	if (!gpio_data->gpio)
+		goto out;
+
+	if (!gpio_data->inverted) {
+		if (gpio_get_value(gpio_data->gpio)) {
+			if (gpio_data->desired_brightness)
+				led_set_brightness(gpio_data->led,
+						gpio_data->desired_brightness);
+			else
+				led_set_brightness(gpio_data->led, LED_FULL);
+		} else {
+			led_set_brightness(gpio_data->led, LED_OFF);
+		}
+	} else {
+		if (!gpio_get_value(gpio_data->gpio)) {
+			if (gpio_data->desired_brightness)
+				led_set_brightness(gpio_data->led,
+						gpio_data->desired_brightness);
+			else
+				led_set_brightness(gpio_data->led, LED_FULL);
+		} else {
+			led_set_brightness(gpio_data->led, LED_OFF);
+		}
+	}
+
+out:
+	/* Completely arbitrary constant. I'm guessing user won't be able
+	 * to trigger gpio event twice in less then 50ms and in case of
+	 * having to trigger several leds, we won't notice the delay between
+	 * them.
+	 */
+	schedule_delayed_work(&gpio_data->work, msecs_to_jiffies(50));
+}
+
+static void gpio_trig_activate(struct led_classdev *led)
+{
+	struct gpio_trig_data *gpio_data;
+	int ret;
+
+	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
+	if (!gpio_data)
+		return;
+
+	ret = device_create_file(led->dev, &dev_attr_gpio);
+	if (ret)
+		goto err_gpio;
+
+	ret = device_create_file(led->dev, &dev_attr_inverted);
+	if (ret)
+		goto err_inverted;
+
+	ret = device_create_file(led->dev, &dev_attr_desired_brightness);
+	if (ret)
+		goto err_brightness;
+
+	gpio_data->led = led;
+	led->trigger_data = gpio_data;
+	INIT_DELAYED_WORK(&gpio_data->work, gpio_trig_work);
+
+	return;
+
+err_brightness:
+	device_remove_file(led->dev, &dev_attr_inverted);
+
+err_inverted:
+	device_remove_file(led->dev, &dev_attr_gpio);
+
+err_gpio:
+	kfree(gpio_data);
+}
+
+static void gpio_trig_deactivate(struct led_classdev *led)
+{
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	if (gpio_data) {
+		device_remove_file(led->dev, &dev_attr_gpio);
+		device_remove_file(led->dev, &dev_attr_inverted);
+		device_remove_file(led->dev, &dev_attr_desired_brightness);
+		cancel_delayed_work(&gpio_data->work);
+		kfree(gpio_data);
+	}
+}
+
+static struct led_trigger gpio_led_trigger = {
+	.name		= "gpio",
+	.activate	= gpio_trig_activate,
+	.deactivate	= gpio_trig_deactivate,
+};
+
+static int __init gpio_trig_init(void)
+{
+	return led_trigger_register(&gpio_led_trigger);
+}
+module_init(gpio_trig_init);
+
+static void __exit gpio_trig_exit(void)
+{
+	led_trigger_unregister(&gpio_led_trigger);
+}
+module_exit(gpio_trig_exit);
+
+MODULE_AUTHOR("Felipe Balbi <me@felipebalbi.com>");
+MODULE_DESCRIPTION("GPIO LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.6.1.265.g9a013

