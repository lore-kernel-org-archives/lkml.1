Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXJ1K1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXJ1K1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXJ1K07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:26:59 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57829 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXJ1K06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:26:58 -0400
Message-ID: <47247113.1020809@freemail.hu>
Date: Sun, 28 Oct 2007 12:22:59 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Rodrigo Pereira <rodripe@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] leds-clevo-mail: hw accelerated LED blink extension
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
diff -uprN linux-2.6.24-rc1.b/Documentation/leds-class.txt linux-2.6.24-rc1.c/Documentation/leds-class.txt
--- linux-2.6.24-rc1.b/Documentation/leds-class.txt	2007-10-28 09:20:07.000000000 +0100
+++ linux-2.6.24-rc1.c/Documentation/leds-class.txt	2007-10-28 09:35:54.000000000 +0100
@@ -49,6 +49,27 @@ overhead, I suggest these become part of
 above leaves scope for further attributes should they be needed.


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
+The blink_set() function should choose a user friendly blinking
+value if it is called with *delay_on==0 && *delay_off==0 parameters. In
+this case the driver should give back the chosen value through delay_on
+and delay_off parameters to the leds subsystem.
+
+Any call to the brightness_set() callback function should cancel the
+previously programmed hardware blinking function so setting the brightness
+to 0 can also cancel the blinking of the LED.
+
+
 Known Issues
 ============

@@ -57,10 +78,6 @@ would cause nightmare dependency issues.
 compared to the benefits the simple trigger functionality brings. The
 rest of the LED subsystem can be modular.

-Some leds can be programmed to flash in hardware. As this isn't a generic
-LED device property, this should be exported as a device specific sysfs
-attribute rather than part of the class if this functionality is required.
-

 Future Development
 ==================
diff -uprN linux-2.6.24-rc1.b/drivers/leds/Kconfig linux-2.6.24-rc1.c/drivers/leds/Kconfig
--- linux-2.6.24-rc1.b/drivers/leds/Kconfig	2007-10-28 09:13:13.000000000 +0100
+++ linux-2.6.24-rc1.c/drivers/leds/Kconfig	2007-10-28 09:09:45.000000000 +0100
@@ -152,7 +152,11 @@ config LEDS_TRIGGER_TIMER
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
diff -uprN linux-2.6.24-rc1.b/drivers/leds/ledtrig-timer.c linux-2.6.24-rc1.c/drivers/leds/ledtrig-timer.c
--- linux-2.6.24-rc1.b/drivers/leds/ledtrig-timer.c	2007-10-28 09:01:56.000000000 +0100
+++ linux-2.6.24-rc1.c/drivers/leds/ledtrig-timer.c	2007-10-28 08:16:50.000000000 +0100
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
+				&timer_data->delay_on, &timer_data->delay_off)) {
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
+				&timer_data->delay_on, &timer_data->delay_off)) {
+				/* no hardware acceleration, blink via timer */
+				mod_timer(&timer_data->timer, jiffies + 1);
+			}
+		}
 		ret = count;
 	}

@@ -143,6 +169,13 @@ static void timer_trig_activate(struct l
 	if (rc)
 		goto err_out_delayon;

+	/* If there is hardware support for blinking, start one
+	 * user friendly blink rate chosen by the driver.
+	 */
+	if (led_cdev->blink_set)
+		led_cdev->blink_set(led_cdev,
+			&timer_data->delay_on, &timer_data->delay_off);
+
 	return;

 err_out_delayon:
diff -uprN linux-2.6.24-rc1.b/include/linux/leds.h linux-2.6.24-rc1.c/include/linux/leds.h
--- linux-2.6.24-rc1.b/include/linux/leds.h	2007-10-28 09:01:56.000000000 +0100
+++ linux-2.6.24-rc1.c/include/linux/leds.h	2007-10-28 10:04:14.000000000 +0100
@@ -37,6 +37,11 @@ struct led_classdev {
 	void		(*brightness_set)(struct led_classdev *led_cdev,
 					  enum led_brightness brightness);

+	/* Activate hardware accelerated blink */
+	int		(*blink_set)(struct led_classdev *led_cdev,
+				     unsigned long *delay_on,
+				     unsigned long *delay_off);
+
 	struct device		*dev;
 	struct list_head	 node;			/* LED Device list */
 	char			*default_trigger;	/* Trigger to use */
