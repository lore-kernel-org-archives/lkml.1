Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbXJUM5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbXJUM5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXJUM4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:56:54 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:64630 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXJUM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:56:53 -0400
Message-ID: <471B4BF2.2060205@freemail.hu>
Date: Sun, 21 Oct 2007 14:54:10 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: Re: [PATCH 2/3] leds-clevo-mail: hw accelerated LED blink extension
References: <4718FCF3.4030401@freemail.hu>
In-Reply-To: <4718FCF3.4030401@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Extends the leds subsystem with a blink_set() callback function which can
be optionally implemented by a LED driver. If implemented, the driver can use
the hardware acceleration for blinking a LED.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.23.orig/Documentation/leds-class.txt linux-2.6.23/Documentation/leds-class.txt
--- linux-2.6.23.orig/Documentation/leds-class.txt	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/Documentation/leds-class.txt	2007-10-21 10:45:35.000000000 +0200
@@ -47,6 +49,19 @@ overhead, I suggest these become part of
 above leaves scope for further attributes should they be needed.


+
+Hardware accelerated blink of LEDs
+==================================
+
+Some LEDs can be programmed to blink without any CPU interaction. To
+support this feature, a LED driver can optionally implement the
+blink_set() function (see <linux/leds.h>). If implemeted, the
+ledtrig-timer tries to use it. The blink_set() function should return
+0 if the blink setting is supported, or -EINVAL otherwise, which means
+that the LED will be turned on and off from software by the leds
+subsystem.
+
+
 Known Issues
 ============

@@ -55,10 +70,6 @@ would cause nightmare dependency issues.
 compared to the benefits the simple trigger functionality brings. The
 rest of the LED subsystem can be modular.

-Some leds can be programmed to flash in hardware. As this isn't a generic
-LED device property, this should be exported as a device specific sysfs
-attribute rather than part of the class if this functionality is required.
-

 Future Development
 ==================
diff -uprN linux-2.6.23.orig/drivers/leds/Kconfig linux-2.6.23/drivers/leds/Kconfig
--- linux-2.6.23.orig/drivers/leds/Kconfig	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/leds/Kconfig	2007-10-21 12:04:50.000000000 +0200
@@ -115,7 +148,11 @@ config LEDS_TRIGGER_TIMER
 	depends on LEDS_TRIGGERS
 	help
 	  This allows LEDs to be controlled by a programmable timer
-	  via sysfs. If unsure, say Y.
+	  via sysfs. Some LED hardware can be programmed to start
+	  blinking the LED without any further software interaction.
+	  For more details read Documentation/leds-class.txt.
+
+	  If unsure, say Y.

 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
diff -uprN linux-2.6.23.orig/drivers/leds/ledtrig-timer.c linux-2.6.23/drivers/leds/ledtrig-timer.c
--- linux-2.6.23.orig/drivers/leds/ledtrig-timer.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/leds/ledtrig-timer.c	2007-10-18 18:21:34.000000000 +0200
@@ -77,8 +77,21 @@ static ssize_t led_delay_on_store(struct
 		count++;

 	if (count == size) {
-		timer_data->delay_on = state;
-		mod_timer(&timer_data->timer, jiffies + 1);
+		if (timer_data->delay_on != state) {
+			/* the new value differs from the previous */
+			timer_data->delay_on = state;
+
+			/* deactivate previous settings */
+			del_timer_sync(&timer_data->timer);
+
+			/* try to activate hardware acceleration, if any */
+			if (!led_cdev->blink_set ||
+			    led_cdev->blink_set(led_cdev,
+				timer_data->delay_on, timer_data->delay_off)) {
+				/* no hardware acceleration, blink via timer */
+				mod_timer(&timer_data->timer, jiffies + 1);
+			}
+		}
 		ret = count;
 	}

@@ -110,8 +123,21 @@ static ssize_t led_delay_off_store(struc
 		count++;

 	if (count == size) {
-		timer_data->delay_off = state;
-		mod_timer(&timer_data->timer, jiffies + 1);
+		if (timer_data->delay_off != state) {
+			/* the new value differs from the previous */
+			timer_data->delay_off = state;
+
+			/* deactivate previous settings */
+			del_timer_sync(&timer_data->timer);
+
+			/* try to activate hardware acceleration, if any */
+			if (!led_cdev->blink_set ||
+			    led_cdev->blink_set(led_cdev,
+				timer_data->delay_on, timer_data->delay_off)) {
+				/* no hardware acceleration, blink via timer */
+				mod_timer(&timer_data->timer, jiffies + 1);
+			}
+		}
 		ret = count;
 	}

diff -uprN linux-2.6.23.orig/include/linux/leds.h linux-2.6.23/include/linux/leds.h
--- linux-2.6.23.orig/include/linux/leds.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/linux/leds.h	2007-10-18 18:21:34.000000000 +0200
@@ -37,6 +37,10 @@ struct led_classdev {
 	void		(*brightness_set)(struct led_classdev *led_cdev,
 					  enum led_brightness brightness);

+	/* Activate hardware accelerated blink */
+	int		(*blink_set)(struct led_classdev *led_cdev,
+				     int delay_on, int delay_off);
+
 	struct device		*dev;
 	struct list_head	 node;			/* LED Device list */
 	char			*default_trigger;	/* Trigger to use */

