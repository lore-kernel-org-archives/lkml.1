Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYLJPmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYLJPmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYLJPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:42:13 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:58445 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYLJPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:42:12 -0500
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Trent Piepho <tpiepho@freescale.com>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 3/4] leds: Let GPIO LEDs keep their current state
Date: Wed, 10 Dec 2008 07:41:42 -0800
Message-Id: <1228923703-16370-3-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1228923703-16370-1-git-send-email-tpiepho@freescale.com>
References: <1228923703-16370-1-git-send-email-tpiepho@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let GPIO LEDs get their initial value from whatever the current state of
the GPIO line is.  On some systems the LEDs are put into some state by the
firmware or hardware before Linux boots, and it is desired to have them
keep this state which is otherwise unknown to Linux.

This requires that the underlying GPIO driver support reading the value of
output GPIOs.  Some drivers support this and some do not.

The platform data for the platform device binding gets a new field
'keep_state' which turns this on.  keep_state overrides default_state.

For the OpenFirmware bindings, the "default-state" property gains a new
allowable setting "keep".

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/powerpc/dts-bindings/gpio/led.txt |   16 ++++++++++++----
 drivers/leds/leds-gpio.c                        |   12 ++++++++----
 include/linux/leds.h                            |    3 ++-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
index 5df384d..064db92 100644
--- a/Documentation/powerpc/dts-bindings/gpio/led.txt
+++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
@@ -21,10 +21,12 @@ LED sub-node properties:
     "ide-disk" - LED indicates disk activity
     "timer" - LED flashes at a fixed, configurable rate
 - default-state:  (optional) The initial state of the LED.  Valid
-  values are "on" and "off".  If the LED is already on or off and the
-  default-state property is set the to same value, then no glitch
-  should be produced where the LED momentarily turns off (or on).
-  The default is off if this property is not present.
+  values are "on", "off", and "keep".  If the LED is already on or off
+  and the default-state property is set the to same value, then no
+  glitch should be produced where the LED momentarily turns off (or
+  on).  The "keep" setting will keep the LED at whatever its current
+  state is, without producing a glitch.  The default is off if this
+  property is not present.
 
 Examples:
 
@@ -35,6 +37,12 @@ leds {
 		gpios = <&mcu_pio 0 1>; /* Active low */
 		linux,default-trigger = "ide-disk";
 	};
+
+	fault {
+		gpios = <&mcu_pio 1 0>;
+		/* Keep LED on if BIOS detected hardware fault */
+		default-state = "keep";
+	};
 };
 
 run-control {
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 21084a3..e33cdd3 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -76,7 +76,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 	struct gpio_led_data *led_dat, struct device *parent,
 	int (*blink_set)(unsigned, unsigned long *, unsigned long *))
 {
-	int ret;
+	int ret, state;
 
 	ret = gpio_request(template->gpio, template->name);
 	if (ret < 0)
@@ -92,10 +92,13 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 		led_dat->cdev.blink_set = gpio_blink_set;
 	}
 	led_dat->cdev.brightness_set = gpio_led_set;
-	led_dat->cdev.brightness = template->default_state ? LED_FULL : LED_OFF;
+	if (template->keep_state)
+		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
+	else
+		state = template->default_state;
+	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
 
-	gpio_direction_output(led_dat->gpio,
-	                      led_dat->active_low ^ template->default_state);
+	gpio_direction_output(led_dat->gpio, led_dat->active_low ^ state);
 
 	INIT_WORK(&led_dat->work, gpio_led_work);
 
@@ -266,6 +269,7 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
 			of_get_property(child, "linux,default-trigger", NULL);
 		state = of_get_property(child, "default-state", NULL);
 		led.default_state = state && !strcmp(state, "on");
+		led.keep_state = state && !strcmp(state, "keep");
 
 		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
 				      &ofdev->dev, NULL);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index caa3987..c51b625 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -138,7 +138,8 @@ struct gpio_led {
 	const char *default_trigger;
 	unsigned 	gpio;
 	u8 		active_low;
-	u8		default_state;
+	u8		default_state;	/* 0 = off, 1 = on */
+	u8		keep_state; /* overrides default_state */
 };
 
 struct gpio_led_platform_data {
-- 
1.5.4.1

