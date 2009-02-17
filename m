Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZBQLjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZBQLjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZBQLj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:39:28 -0500
Received: from smtp.nokia.com ([192.100.105.134]:22048 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZBQLj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:39:27 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <me@felipe.balbi.com>, Richard Purdie <rpurdie@rpsys.net>,
       Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH] leds: triggers: introduce gpio led trigger
Date: Tue, 17 Feb 2009 13:18:11 +0200
Message-Id: <1234869491-29630-2-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.1.265.g9a013
In-Reply-To: <1234869491-29630-1-git-send-email-felipe.balbi@nokia.com>
References: <20090216131426.GU21181@scadufax.research.nokia.com>
 <1234869491-29630-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 17 Feb 2009 11:33:07.0075 (UTC) FILETIME=[80E58D30:01C990F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <me@felipe.balbi.com>

The gpio led trigger will allow leds to be triggered by
gpio events.

When we give the led a gpio number, the trigger will
request_irq() on that so we don't have to keep polling
for gpio state.

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
 drivers/leds/ledtrig-gpio.c |  239 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 253 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-gpio.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 3b35fa5..a6e5b6b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -226,6 +226,19 @@ config LEDS_TRIGGER_BACKLIGHT
 
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
index baebce8..e39656c 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -31,4 +31,5 @@ obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
+obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
new file mode 100644
index 0000000..a247ae6
--- /dev/null
+++ b/drivers/leds/ledtrig-gpio.c
@@ -0,0 +1,239 @@
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
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+#include "leds.h"
+
+struct gpio_trig_data {
+	struct led_classdev *led;
+	struct work_struct work;
+
+	unsigned desired_brightness;	/* desired brightness when led is on */
+	unsigned inverted;		/* true when gpio is inverted */
+	unsigned gpio;			/* gpio that triggers the leds */
+};
+
+static irqreturn_t gpio_trig_irq(int irq, void *_led)
+{
+	struct led_classdev *led = _led;
+	struct gpio_trig_data *gpio_data = led->trigger_data;
+
+	/* just schedule_work since gpio_get_value can sleep */
+	schedule_work(&gpio_data->work);
+
+	return IRQ_HANDLED;
+};
+
+static void gpio_trig_work(struct work_struct *work)
+{
+	struct gpio_trig_data *gpio_data = container_of(work,
+			struct gpio_trig_data, work);
+	int tmp;
+
+       if (!gpio_data->gpio)
+	       return;
+
+       tmp = gpio_get_value(gpio_data->gpio);
+       if (gpio_data->inverted)
+	       tmp = !tmp;
+
+       if (tmp) {
+               if (gpio_data->desired_brightness)
+                       led_set_brightness(gpio_data->led,
+                                       gpio_data->desired_brightness);
+               else
+                       led_set_brightness(gpio_data->led, LED_FULL);
+       } else {
+               led_set_brightness(gpio_data->led, LED_OFF);
+       }
+}
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
+		flush_work(&gpio_data->work);
+		return -EINVAL;
+	}
+
+	if (!gpio) {
+		free_irq(gpio_to_irq(gpio_data->gpio), led);
+		return n;
+	}
+
+	if (gpio_data->gpio > 0 && gpio_data->gpio != gpio)
+		free_irq(gpio_to_irq(gpio_data->gpio), led);
+
+	gpio_data->gpio = gpio;
+	ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
+			IRQF_SHARED | IRQF_TRIGGER_RISING
+			| IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
+	if (ret)
+		dev_err(dev, "request_irq failed with error %d\n", ret);
+
+	return ret ? ret : n;
+}
+static DEVICE_ATTR(gpio, 0644, gpio_trig_gpio_show, gpio_trig_gpio_store);
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
+	INIT_WORK(&gpio_data->work, gpio_trig_work);
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
+		flush_work(&gpio_data->work);
+		free_irq(gpio_to_irq(gpio_data->gpio),led);
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

