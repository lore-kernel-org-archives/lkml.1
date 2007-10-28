Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbXJ1K1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbXJ1K1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJ1K1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:27:34 -0400
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:50129 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXJ1K1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:27:33 -0400
Message-ID: <47247135.6060206@freemail.hu>
Date: Sun, 28 Oct 2007 12:23:33 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Rodrigo Pereira <rodripe@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] leds-clevo-mail: hw acceleration for Clevo mail LED driver
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Add support for hardware accelerated LED blinking for the mail LED
commonly found on Clevo notebooks.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.24-rc1.c/drivers/leds/Kconfig linux-2.6.24-rc1.d/drivers/leds/Kconfig
--- linux-2.6.24-rc1.c/drivers/leds/Kconfig	2007-10-28 09:09:45.000000000 +0100
+++ linux-2.6.24-rc1.d/drivers/leds/Kconfig	2007-10-28 09:09:25.000000000 +0100
@@ -122,9 +122,11 @@ config LEDS_CLEVO_MAIL
 	  programs through the leds subsystem. This LED have three
 	  known mode: off, blink at 0.5Hz and blink at 1Hz.

-	  As this LED cannot change it's brightness it blinks instead.
-	  The brightness value 0 means off, 1..127 means blink at 0.5Hz
-	  and 128..255 means blink at 1Hz.
+	  The driver supports two kinds of interface: using ledtrig-timer
+	  or through /sys/class/leds/clevo::mail/brightness. As this LED
+	  cannot change it's brightness it blinks instead. The brightness
+	  value 0 means off, 1..127 means blink at 0.5Hz and 128..255 means
+	  blink at 1Hz.

 	  This module can drive the mail LED for the following notebooks:

diff -uprN linux-2.6.24-rc1.c/drivers/leds/leds-clevo-mail.c linux-2.6.24-rc1.d/drivers/leds/leds-clevo-mail.c
--- linux-2.6.24-rc1.c/drivers/leds/leds-clevo-mail.c	2007-10-28 10:20:49.000000000 +0100
+++ linux-2.6.24-rc1.d/drivers/leds/leds-clevo-mail.c	2007-10-28 10:20:55.000000000 +0100
@@ -92,9 +92,46 @@ static void clevo_mail_led_set(struct le

 }

+static int clevo_mail_led_blink(struct led_classdev *led_cdev,
+				unsigned long* delay_on,
+				unsigned long* delay_off)
+{
+	int status = -EINVAL;
+
+	if (*delay_on == 0 /* ms */ && *delay_off == 0 /* ms */) {
+		/* Special case: the leds subsystem requested us to
+		 * chose one user friendly blinking of the LED, and
+		 * start it. Let's blink the led slowly (0.5Hz).
+		 */
+		*delay_on = 1000; /* ms */
+		*delay_off = 1000; /* ms */
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_0_5HZ);
+		status = 0;
+
+	} else if (*delay_on == 500 /* ms */ && *delay_off == 500 /* ms */) {
+		/* blink the led with 1Hz */
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_1HZ);
+		status = 0;
+
+	} else if (*delay_on == 1000 /* ms */ && *delay_off == 1000 /* ms */) {
+		/* blink the led with 0.5Hz */
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_0_5HZ);
+		status = 0;
+
+	} else {
+		printk(KERN_DEBUG KBUILD_MODNAME
+		       ": clevo_mail_led_blink(..., %lu, %lu),"
+		       " returning -EINVAL (unsupported)\n",
+		       *delay_on, *delay_off);
+	}
+
+	return status;
+}
+
 static struct led_classdev clevo_mail_led = {
 	.name			= "clevo::mail",
 	.brightness_set		= clevo_mail_led_set,
+	.blink_set		= clevo_mail_led_blink,
 };

 static int __init clevo_mail_led_probe(struct platform_device *pdev)
