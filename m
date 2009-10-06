Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZJHJD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZJHJD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZJHJD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:03:28 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43086 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbZJHJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:03:26 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] LED: add driver for LT3593 controlled LEDs
Date: Wed,  7 Oct 2009 05:41:00 +0800
Message-Id: <1254865260-13570-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LT3593 is a step-up DC/DC converter designed to drive up to ten
white LEDs in series. The current flow can be set with a control pin.

This driver controls any number of such devices connected on generic
GPIOs and exports the function as as platform_driver.

The gpio_led platform data struct definition is reused for this purpose.

Successfully tested on a PXA embedded board.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Richard Purdie <rpurdie@rpsys.net>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/leds/Kconfig       |    8 ++
 drivers/leds/Makefile      |    1 +
 drivers/leds/leds-lt3593.c |  218 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lt3593.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 7c8e712..80a183f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -229,6 +229,14 @@ config LEDS_BD2802
 	  This option enables support for BD2802GU RGB LED driver chips
 	  accessed via the I2C bus.
 
+config LEDS_LT3593
+	tristate "LED driver for LT3593 controllers"
+	depends on LEDS_CLASS && GENERIC_GPIO
+	help
+	  This option enables support for LEDs driven by a Linear Technology
+	  LT3593 controller. This controller uses a special one-wire pulse
+	  coding protocol to set the brightness.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e8cdcf7..3d79287 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
 obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
+obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
new file mode 100644
index 0000000..de69a5f
--- /dev/null
+++ b/drivers/leds/leds-lt3593.c
@@ -0,0 +1,218 @@
+/*
+ * LEDs driver for LT3593 controllers
+ *
+ * See the datasheet at http://cds.linear.com/docs/Datasheet/3593f.pdf
+ *
+ * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
+ *
+ * Based on leds-gpio.c,
+ *
+ *   Copyright (C) 2007 8D Technologies inc.
+ *   Raphael Assenat <raph@8d.com>
+ *   Copyright (C) 2008 Freescale Semiconductor, Inc.
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
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+
+#include <asm/gpio.h>
+
+struct lt3593_led_data {
+	struct led_classdev cdev;
+	unsigned gpio;
+	struct work_struct work;
+	u8 new_level;
+};
+
+static void lt3593_led_work(struct work_struct *work)
+{
+	int pulses;
+	struct lt3593_led_data	*led_dat =
+		container_of(work, struct lt3593_led_data, work);
+
+	/*
+	 * The LT3593 resets its internal current level register to the maximum
+	 * level on the first falling edge on the control pin. Each following
+	 * falling edge decreases the current level by 625uA. Up to 32 pulses
+	 * can be sent, so the maximum power reduction is 20mA.
+	 * After a timeout of 128us, the value is taken from the register and
+	 * applied is to the output driver.
+	 */
+
+	if (led_dat->new_level == 0) {
+		gpio_set_value_cansleep(led_dat->gpio, 0);
+		return;
+	}
+
+	pulses = 32 - (led_dat->new_level * 32) / 255;
+
+	if (pulses == 0) {
+		gpio_set_value_cansleep(led_dat->gpio, 0);
+		mdelay(1);
+		gpio_set_value_cansleep(led_dat->gpio, 1);
+		return;
+	}
+
+	gpio_set_value_cansleep(led_dat->gpio, 1);
+
+	while (pulses--) {
+		gpio_set_value_cansleep(led_dat->gpio, 0);
+		udelay(1);
+		gpio_set_value_cansleep(led_dat->gpio, 1);
+		udelay(1);
+	}
+}
+
+static void lt3593_led_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct lt3593_led_data *led_dat =
+		container_of(led_cdev, struct lt3593_led_data, cdev);
+
+	led_dat->new_level = value;
+	schedule_work(&led_dat->work);
+}
+
+static int __devinit create_lt3593_led(const struct gpio_led *template,
+	struct lt3593_led_data *led_dat, struct device *parent)
+{
+	int ret, state;
+
+	/* skip leds on GPIOs that aren't available */
+	if (!gpio_is_valid(template->gpio)) {
+		printk(KERN_INFO "%s: skipping unavailable LT3593 LED at gpio %d (%s)\n",
+				KBUILD_MODNAME, template->gpio, template->name);
+		return 0;
+	}
+
+	ret = gpio_request(template->gpio, template->name);
+	if (ret < 0)
+		return ret;
+
+	led_dat->cdev.name = template->name;
+	led_dat->cdev.default_trigger = template->default_trigger;
+	led_dat->gpio = template->gpio;
+
+	led_dat->cdev.brightness_set = lt3593_led_set;
+
+	state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
+	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
+
+	if (!template->retain_state_suspended)
+		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
+
+	ret = gpio_direction_output(led_dat->gpio, state);
+	if (ret < 0)
+		goto err;
+
+	INIT_WORK(&led_dat->work, lt3593_led_work);
+
+	ret = led_classdev_register(parent, &led_dat->cdev);
+	if (ret < 0)
+		goto err;
+
+	printk(KERN_INFO "%s: registered LT3593 LED '%s' at GPIO %d\n",
+		KBUILD_MODNAME, template->name, template->gpio);
+
+	return 0;
+
+err:
+	gpio_free(led_dat->gpio);
+	return ret;
+}
+
+static void delete_lt3593_led(struct lt3593_led_data *led)
+{
+	if (!gpio_is_valid(led->gpio))
+		return;
+
+	led_classdev_unregister(&led->cdev);
+	cancel_work_sync(&led->work);
+	gpio_free(led->gpio);
+}
+
+static int __devinit lt3593_led_probe(struct platform_device *pdev)
+{
+	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
+	struct lt3593_led_data *leds_data;
+	int i, ret = 0;
+
+	if (!pdata)
+		return -EBUSY;
+
+	leds_data = kzalloc(sizeof(struct lt3593_led_data) * pdata->num_leds,
+				GFP_KERNEL);
+	if (!leds_data)
+		return -ENOMEM;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		ret = create_lt3593_led(&pdata->leds[i], &leds_data[i],
+				      &pdev->dev);
+		if (ret < 0)
+			goto err;
+	}
+
+	platform_set_drvdata(pdev, leds_data);
+
+	return 0;
+
+err:
+	for (i = i - 1; i >= 0; i--)
+		delete_lt3593_led(&leds_data[i]);
+
+	kfree(leds_data);
+
+	return ret;
+}
+
+static int __devexit lt3593_led_remove(struct platform_device *pdev)
+{
+	int i;
+	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
+	struct lt3593_led_data *leds_data;
+
+	leds_data = platform_get_drvdata(pdev);
+
+	for (i = 0; i < pdata->num_leds; i++)
+		delete_lt3593_led(&leds_data[i]);
+
+	kfree(leds_data);
+
+	return 0;
+}
+
+static struct platform_driver lt3593_led_driver = {
+	.probe		= lt3593_led_probe,
+	.remove		= __devexit_p(lt3593_led_remove),
+	.driver		= {
+		.name	= "leds-lt3593",
+		.owner	= THIS_MODULE,
+	},
+};
+
+MODULE_ALIAS("platform:leds-lt3593");
+
+static int __init lt3593_led_init(void)
+{
+	return platform_driver_register(&lt3593_led_driver);
+}
+
+static void __exit lt3593_led_exit(void)
+{
+	platform_driver_unregister(&lt3593_led_driver);
+}
+
+module_init(lt3593_led_init);
+module_exit(lt3593_led_exit);
+
+MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
+MODULE_DESCRIPTION("LED driver for LT3593 controllers");
+MODULE_LICENSE("GPL");
-- 
1.6.0.4

