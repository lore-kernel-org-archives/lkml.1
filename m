Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYBJLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYBJLxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbYBJLxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:53:06 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:56321 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329AbYBJLxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:53:04 -0500
Message-ID: <47AEE587.6010601@freemail.hu>
Date: Sun, 10 Feb 2008 12:52:39 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: disable triggers on brightness set
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <20080207232309.GA2041@khazad-dum.debian.net>
In-Reply-To: <20080207232309.GA2041@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable any active triggers when the brightness attribute is
set to zero.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
diff --git a/Documentation/leds-class.txt b/Documentation/leds-class.txt
index 56757c7..d2aebfb 100644
--- a/Documentation/leds-class.txt
+++ b/Documentation/leds-class.txt
@@ -19,6 +19,12 @@ optimises away.

 Complex triggers whilst available to all LEDs have LED specific
 parameters and work on a per LED basis. The timer trigger is an example.
+The timer trigger will periodically change the LED brightness between
+LED_OFF and the current brightness setting. The "on" and "off" time can
+be specified via /sys/class/leds/<device>/delay_{on,off} in milliseconds.
+You can change the brightness value of a LED independently of the timer
+trigger. However, if you set the brightness value to LED_OFF it will
+also disable the timer trigger.

 You can change triggers in a similar manner to the way an IO scheduler
 is chosen (via /sys/class/leds/<device>/trigger). Trigger specific
@@ -63,9 +69,9 @@ value if it is called with *delay_on==0 && *delay_off==0 parameters. In
 this case the driver should give back the chosen value through delay_on
 and delay_off parameters to the leds subsystem.

-Any call to the brightness_set() callback function should cancel the
-previously programmed hardware blinking function so setting the brightness
-to 0 can also cancel the blinking of the LED.
+Setting the brightness to zero with brightness_set() callback function
+should completely turn off the LED and cancel the previously programmed
+hardware blinking function, if any.


 Known Issues
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 4a93878..e6c5b98 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -51,6 +51,9 @@ static ssize_t led_brightness_store(struct device *dev,

 	if (count == size) {
 		ret = count;
+
+		if (state == LED_OFF)
+			led_trigger_remove(led_cdev);
 		led_set_brightness(led_cdev, state);
 	}

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 13c9026..21dd969 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -45,9 +45,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 		trigger_name[len - 1] = '\0';

 	if (!strcmp(trigger_name, "none")) {
-		down_write(&led_cdev->trigger_lock);
-		led_trigger_set(led_cdev, NULL);
-		up_write(&led_cdev->trigger_lock);
+		led_trigger_remove(led_cdev);
 		return count;
 	}

@@ -139,6 +137,13 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 	led_cdev->trigger = trigger;
 }

+void led_trigger_remove(struct led_classdev *led_cdev)
+{
+	down_write(&led_cdev->trigger_lock);
+	led_trigger_set(led_cdev, NULL);
+	up_write(&led_cdev->trigger_lock);
+}
+
 void led_trigger_set_default(struct led_classdev *led_cdev)
 {
 	struct led_trigger *trig;
@@ -231,6 +236,7 @@ void led_trigger_unregister_simple(struct led_trigger *trigger)

 /* Used by LED Class */
 EXPORT_SYMBOL_GPL(led_trigger_set);
+EXPORT_SYMBOL_GPL(led_trigger_remove);
 EXPORT_SYMBOL_GPL(led_trigger_set_default);
 EXPORT_SYMBOL_GPL(led_trigger_show);
 EXPORT_SYMBOL_GPL(led_trigger_store);
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index 12b6fe9..0214799 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -27,6 +27,11 @@ static inline void led_set_brightness(struct led_classdev *led_cdev,
 		led_cdev->brightness_set(led_cdev, value);
 }

+static inline int led_get_brightness(struct led_classdev *led_cdev)
+{
+	return led_cdev->brightness;
+}
+
 extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;

@@ -34,9 +39,11 @@ extern struct list_head leds_list;
 void led_trigger_set_default(struct led_classdev *led_cdev);
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
+void led_trigger_remove(struct led_classdev *led_cdev);
 #else
 #define led_trigger_set_default(x) do {} while(0)
 #define led_trigger_set(x, y) do {} while(0)
+#define led_trigger_remove(x) do {} while(0)
 #endif

 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 82c55d6..7062977 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -25,6 +25,9 @@
 #include "leds.h"

 struct timer_trig_data {
+	int brightness_on;		/* LED brightness during "on" period.
+					 * (LED_OFF < brightness_on <= LED_FULL)
+					 */
 	unsigned long delay_on;		/* milliseconds on */
 	unsigned long delay_off;	/* milliseconds off */
 	struct timer_list timer;
@@ -34,17 +37,26 @@ static void led_timer_function(unsigned long data)
 {
 	struct led_classdev *led_cdev = (struct led_classdev *) data;
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
-	unsigned long brightness = LED_OFF;
-	unsigned long delay = timer_data->delay_off;
+	unsigned long brightness;
+	unsigned long delay;

 	if (!timer_data->delay_on || !timer_data->delay_off) {
 		led_set_brightness(led_cdev, LED_OFF);
 		return;
 	}

-	if (!led_cdev->brightness) {
-		brightness = LED_FULL;
+	brightness = led_get_brightness(led_cdev);
+	if (!brightness) {
+		/* Time to switch the LED on. */
+		brightness = timer_data->brightness_on;
 		delay = timer_data->delay_on;
+	} else {
+		/* Store the current brightness value to be able
+		 * to restore it when the delay_off period is over.
+		 */
+		timer_data->brightness_on = brightness;
+		brightness = LED_OFF;
+		delay = timer_data->delay_off;
 	}

 	led_set_brightness(led_cdev, brightness);
@@ -156,6 +168,9 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
 	if (!timer_data)
 		return;

+	timer_data->brightness_on = led_get_brightness(led_cdev);
+	if (timer_data->brightness_on == LED_OFF)
+		timer_data->brightness_on = LED_FULL;
 	led_cdev->trigger_data = timer_data;

 	init_timer(&timer_data->timer);
