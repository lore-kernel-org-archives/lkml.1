Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbYLKVu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbYLKVu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbYLKVuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:50:19 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:44826 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbYLKVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:50:17 -0500
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Trent Piepho <tpiepho@freescale.com>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 2/4] leds: Add option to have GPIO LEDs start on
Date: Thu, 11 Dec 2008 13:49:56 -0800
Message-Id: <1229032198-19775-2-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, there is the "default-on" trigger but there are problems with that.

For one, it's a inefficient way to do it and requires led trigger support
to be compiled in.

But the real reason is that is produces a glitch on the LED.  The GPIO is
allocate with the LED *off*, then *later* when then trigger runs it is
turned back on.  If the LED was already on via the GPIO's reset default or
action of the firmware, this produces a glitch where the LED goes from on
to off to on.  While normally this is fast enough that it wouldn't be
noticeable to a human observer, there are still serious problems.

One is that there may be something else on the GPIO line, like a hardware
alarm or watchdog, that is fast enough to notice the glitch.

Another is that the kernel may panic before the LED is turned back on, thus
hanging with the LED in the wrong state.  This is not just speculation, but
actually happened to me with an embedded system that has an LED which
should turn off when the kernel finishes booting, which was left in the
incorrect state due to a bug in the OF LED binding code.

The platform device binding gains a field in the platform data
"default_state" that controls this.  The OpenFirmware binding uses a
property named "default-state" that can be set to "on" or "off".  The
default if the property isn't present is off.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/powerpc/dts-bindings/gpio/led.txt |    9 ++++++++-
 drivers/leds/leds-gpio.c                        |    8 ++++++--
 include/linux/leds.h                            |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
index 4fe14de..5df384d 100644
--- a/Documentation/powerpc/dts-bindings/gpio/led.txt
+++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
@@ -16,10 +16,15 @@ LED sub-node properties:
   string defining the trigger assigned to the LED.  Current triggers are:
     "backlight" - LED will act as a back-light, controlled by the framebuffer
 		  system
-    "default-on" - LED will turn on
+    "default-on" - LED will turn on, but see "default-state" below
     "heartbeat" - LED "double" flashes at a load average based rate
     "ide-disk" - LED indicates disk activity
     "timer" - LED flashes at a fixed, configurable rate
+- default-state:  (optional) The initial state of the LED.  Valid
+  values are "on" and "off".  If the LED is already on or off and the
+  default-state property is set the to same value, then no glitch
+  should be produced where the LED momentarily turns off (or on).
+  The default is off if this property is not present.
 
 Examples:
 
@@ -36,8 +41,10 @@ run-control {
 	compatible = "gpio-leds";
 	red {
 		gpios = <&mpc8572 6 0>;
+		default-state = "off";
 	};
 	green {
 		gpios = <&mpc8572 7 0>;
+		default-state = "on";
 	};
 }
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index be4d6aa..1ad96d2 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -92,9 +92,10 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 		led_dat->cdev.blink_set = gpio_blink_set;
 	}
 	led_dat->cdev.brightness_set = gpio_led_set;
-	led_dat->cdev.brightness = LED_OFF;
+	led_dat->cdev.brightness = template->default_state ? LED_FULL : LED_OFF;
 
-	ret = gpio_direction_output(led_dat->gpio, led_dat->active_low);
+	ret = gpio_direction_output(led_dat->gpio,
+				led_dat->active_low ^ template->default_state);
 	if (ret < 0)
 		goto err;
 
@@ -261,12 +262,15 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
 	memset(&led, 0, sizeof(led));
 	for_each_child_of_node(np, child) {
 		enum of_gpio_flags flags;
+		const char *state;
 
 		led.gpio = of_get_gpio_flags(child, 0, &flags);
 		led.active_low = flags & OF_GPIO_ACTIVE_LOW;
 		led.name = of_get_property(child, "label", NULL) ? : child->name;
 		led.default_trigger =
 			of_get_property(child, "linux,default-trigger", NULL);
+		state = of_get_property(child, "default-state", NULL);
+		led.default_state = state && !strcmp(state, "on");
 
 		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
 				      &ofdev->dev, NULL);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index d3a73f5..caa3987 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -138,6 +138,7 @@ struct gpio_led {
 	const char *default_trigger;
 	unsigned 	gpio;
 	u8 		active_low;
+	u8		default_state;
 };
 
 struct gpio_led_platform_data {
-- 
1.5.4.1

