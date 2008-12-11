Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbYLKVuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbYLKVuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYLKVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:50:20 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:44831 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbYLKVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:50:19 -0500
From: Trent Piepho <tpiepho@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Trent Piepho <tpiepho@freescale.com>
Subject: [PATCH v2 4/4] leds: Use tristate property in platform data
Date: Thu, 11 Dec 2008 13:49:58 -0800
Message-Id: <1229032198-19775-4-git-send-email-tpiepho@freescale.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0812111326480.28806@t2.domain.actdsltmp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the two boolean properties default_state and keep_state with a
single tristate property that can be set to
LEDS_GPIO_DEFSTATE_(ON|OFF|KEEP).  This ends up being more complicated,
requires more code, and makes developers remember not just the name of the
field to set but also the symbolic constant to set it to.  Yet despite
these shortcomings it remains more popular.

Signed-off-by: Trent Piepho <tpiepho@freescale.com>
---
 drivers/leds/leds-gpio.c |   15 +++++++++++----
 include/linux/leds.h     |    7 +++++--
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index bb9d9ff..2d1b71f 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -92,10 +92,10 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 		led_dat->cdev.blink_set = gpio_blink_set;
 	}
 	led_dat->cdev.brightness_set = gpio_led_set;
-	if (template->keep_state)
+	if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
 		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
 	else
-		state = template->default_state;
+		state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
 	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
 
 	ret = gpio_direction_output(led_dat->gpio, led_dat->active_low ^ state);
@@ -273,8 +273,15 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
 		led.default_trigger =
 			of_get_property(child, "linux,default-trigger", NULL);
 		state = of_get_property(child, "default-state", NULL);
-		led.default_state = state && !strcmp(state, "on");
-		led.keep_state = state && !strcmp(state, "keep");
+		if (state) {
+			if (!strcmp(state, "keep")) {
+				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
+			} else if(!strcmp(state, "on")) {
+				led.default_state = LEDS_GPIO_DEFSTATE_ON;
+			} else {
+				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
+			}
+		}
 
 		ret = create_gpio_led(&led, &pdata->led_data[pdata->num_leds++],
 				      &ofdev->dev, NULL);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index c51b625..f4a125c 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -138,9 +138,12 @@ struct gpio_led {
 	const char *default_trigger;
 	unsigned 	gpio;
 	u8 		active_low;
-	u8		default_state;	/* 0 = off, 1 = on */
-	u8		keep_state; /* overrides default_state */
+	u8		default_state;
+	/* default_state should be one of LEDS_GPIO_DEFSTATE_(ON|OFF|KEEP) */
 };
+#define LEDS_GPIO_DEFSTATE_OFF	0
+#define LEDS_GPIO_DEFSTATE_ON	1
+#define LEDS_GPIO_DEFSTATE_KEEP	2
 
 struct gpio_led_platform_data {
 	int 		num_leds;
-- 
1.5.4.1

