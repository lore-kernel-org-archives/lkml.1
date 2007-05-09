Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbXEILnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbXEILnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXEILnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:43:03 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:60760
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXEILnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:43:01 -0400
Message-ID: <1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp>
Date: Wed, 9 May 2007 20:42:59 +0900 (JST)
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: "Richard Purdie" <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp><1178628407.6061.24.camel@localhost.localdomain>
In-Reply-To: <1178628407.6061.24.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard-san

>As far as I can tell, the existing timer trigger can do everything the
>blink trigger can (and more besides).
I want to blink LED in the initial state.
Because that of "the existing timer trigger" was impossible, I made "BLINK".

I thought about another solution.
Can the change that sets an initial value to delay_on and delay_off be added?

The matter of "Bitshift" is reserved until this case is solved.

kogiidena
---
diff -urpN OLD/include/linux/leds.h NEW/include/linux/leds.h
--- OLD/include/linux/leds.h	2007-05-07 12:12:15.000000000 +0900
+++ NEW/include/linux/leds.h	2007-05-09 19:17:01.000000000 +0900
@@ -14,6 +14,7 @@

 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/timer.h>

 struct device;
 struct class_device;
@@ -41,6 +42,7 @@ struct led_classdev {
 	struct class_device	*class_dev;
 	struct list_head	 node;			/* LED Device list */
 	char			*default_trigger;	/* Trigger to use */
+	void			*default_trigger_data;	/* Trigger to use */

 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */
@@ -110,6 +112,14 @@ extern void ledtrig_ide_activity(void);
 #define ledtrig_ide_activity() do {} while(0)
 #endif

+#ifdef CONFIG_LEDS_TRIGGER_TIMER
+struct timer_trig_data {
+	unsigned long delay_on;		/* milliseconds on */
+	unsigned long delay_off;	/* milliseconds off */
+	struct timer_list timer;
+};
+#endif
+
 /* For the leds-gpio driver */
 struct gpio_led {
 	const char *name;
diff -urpN OLD/drivers/leds/ledtrig-timer.c NEW/drivers/leds/ledtrig-timer.c
--- OLD/drivers/leds/ledtrig-timer.c	2007-04-28 06:49:26.000000000 +0900
+++ NEW/drivers/leds/ledtrig-timer.c	2007-05-09 19:12:35.000000000 +0900
@@ -24,12 +24,6 @@
 #include <linux/leds.h>
 #include "leds.h"

-struct timer_trig_data {
-	unsigned long delay_on;		/* milliseconds on */
-	unsigned long delay_off;	/* milliseconds off */
-	struct timer_list timer;
-};
-
 static void led_timer_function(unsigned long data)
 {
 	struct led_classdev *led_cdev = (struct led_classdev *) data;
@@ -124,6 +118,7 @@ static CLASS_DEVICE_ATTR(delay_off, 0644
 static void timer_trig_activate(struct led_classdev *led_cdev)
 {
 	struct timer_trig_data *timer_data;
+	struct timer_trig_data *def_trig_data = led_cdev->default_trigger_data;
 	int rc;

 	timer_data = kzalloc(sizeof(struct timer_trig_data), GFP_KERNEL);
@@ -143,6 +138,11 @@ static void timer_trig_activate(struct l
 				&class_device_attr_delay_off);
 	if (rc) goto err_out_delayon;

+	if (def_trig_data){
+		timer_data->delay_on  = def_trig_data->delay_on;
+		timer_data->delay_off = def_trig_data->delay_off;
+		mod_timer(&timer_data->timer, jiffies + 1);
+	}
 	return;

 err_out_delayon:





