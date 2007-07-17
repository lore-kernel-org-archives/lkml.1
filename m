Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbXGQKTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbXGQKTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbXGQKSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:18:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:9619 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932649AbXGQKSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:18:37 -0400
Message-ID: <469C977A.8000908@freemail.hu>
Date: Tue, 17 Jul 2007 12:18:34 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu; rv:1.7.12) Gecko/20050920
X-Accept-Language: hu, en, de
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Rodrigo Pereira <rodripe@gmail.com>
Subject: [PATCH 2/3] leds-clevo-mail: hw accelerated LED blink extension
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Extends the leds subsystem with a blink_set() callback function which can
optionally implemented by a LED driver. If implemented, the driver can use the
hardware acceleration for blinking a LED.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.22.orig/Documentation/leds-class.txt linux-2.6.22/Documentation/leds-class.txt
--- linux-2.6.22.orig/Documentation/leds-class.txt	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/Documentation/leds-class.txt	2007-07-16 20:53:38.000000000 +0200
@@ -47,6 +47,17 @@ overhead, I suggest these become part of
  above leaves scope for further attributes should they be needed.


+Hardware accelerated blink of LEDs
+==================================
+
+Some LEDs can be programmed to blink without any CPU interaction. To
+support this feature, a LED driver can optionally implement the
+blink_set() function (see <linux/leds.h>). If implemeted, the
+ledtrig-timer tries to use it. The blink_set() function should return
+1 if the blink setting is supported, or 0 otherwise, which means that
+the LED will be turned on and off from software.
+
+
  Known Issues
  ============

@@ -55,10 +66,6 @@ would cause nightmare dependency issues.
  compared to the benefits the simple trigger functionality brings. The
  rest of the LED subsystem can be modular.

-Some leds can be programmed to flash in hardware. As this isn't a generic
-LED device property, this should be exported as a device specific sysfs
-attribute rather than part of the class if this functionality is required.
-

  Future Development
  ==================
diff -uprN linux-2.6.22.orig/drivers/leds/ledtrig-timer.c linux-2.6.22/drivers/leds/ledtrig-timer.c
--- linux-2.6.22.orig/drivers/leds/ledtrig-timer.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/drivers/leds/ledtrig-timer.c	2007-07-17 09:43:20.000000000 +0200
@@ -76,8 +76,21 @@ static ssize_t led_delay_on_store(struct
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
+			    !led_cdev->blink_set(led_cdev,
+				timer_data->delay_on, timer_data->delay_off)) {
+				/* no hardware acceleration, blink via timer */
+				mod_timer(&timer_data->timer, jiffies + 1);
+			}
+		}
  		ret = count;
  	}

@@ -108,8 +121,21 @@ static ssize_t led_delay_off_store(struc
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
+			    !led_cdev->blink_set(led_cdev,
+				timer_data->delay_on, timer_data->delay_off)) {
+				/* no hardware acceleration, blink via timer */
+				mod_timer(&timer_data->timer, jiffies + 1);
+			}
+		}
  		ret = count;
  	}

diff -uprN linux-2.6.22.orig/include/linux/leds.h linux-2.6.22/include/linux/leds.h
--- linux-2.6.22.orig/include/linux/leds.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/include/linux/leds.h	2007-07-16 20:53:38.000000000 +0200
@@ -38,6 +38,11 @@ struct led_classdev {
  	void		(*brightness_set)(struct led_classdev *led_cdev,
  					  enum led_brightness brightness);

+	/* Activate hardware accelerated blink */
+	int		(*blink_set)(struct led_classdev *led_cdev,
+				     int delay_on, int delay_off);
+
+
  	struct class_device	*class_dev;
  	struct list_head	 node;			/* LED Device list */
  	char			*default_trigger;	/* Trigger to use */

