Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbZHHP0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbZHHP0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZHHP0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:26:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42844 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZHHP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:26:12 -0400
Date: Fri, 7 Aug 2009 20:09:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Subject: ads7846: clean up, fix pressure reporting
Message-ID: <20090807180941.GF1728@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix pressure reporting, and clean up debug prints.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff -ur touchscreen.ofic/ads7846.c touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c	2009-07-15 01:41:30.000000000 +0200
+++ b/drivers/input/touchscreen/ads7846.c	2009-07-15 10:49:00.000000000 +0200
@@ -29,10 +29,14 @@
 #include <linux/spi/ads7846.h>
 #include <asm/irq.h>
 
+#ifndef VERBOSE
+#undef dev_dbg
+#define dev_dbg(...) do {} while(0)
+#endif
 
 /*
  * This code has been heavily tested on a Nokia 770, and lightly
- * tested on other ads7846 devices (OSK/Mistral, Lubbock).
+ * tested on other ads7846 devices (OSK/Mistral, Lubbock, Spitz).
  * TSC2046 is just newer ads7846 silicon.
  * Support for ads7843 tested on Atmel at91sam926x-EK.
  * Support for ads7845 has only been stubbed in.
@@ -43,7 +47,7 @@
  * have to maintain our own SW IRQ disabled status. This should be
  * removed as soon as the affected platform's IRQ handling is fixed.
  *
- * app note sbaa036 talks in more detail about accurate sampling...
+ * App note sbaa036 talks in more detail about accurate sampling...
  * that ought to help in situations like LCDs inducing noise (which
  * can also be helped by using synch signals) and more generally.
  * This driver tries to utilize the measures described in the app
@@ -566,10 +570,8 @@
 	 * once more the measurement
 	 */
 	if (packet->tc.ignore || Rt > ts->pressure_max) {
-#ifdef VERBOSE
-		pr_debug("%s: ignored %d pressure %d\n",
-			dev_name(&ts->spi->dev), packet->tc.ignore, Rt);
-#endif
+		dev_dbg(&ts->spi->dev, "ignored %d pressure %d\n",
+			packet->tc.ignore, Rt);
 		hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
 			      HRTIMER_MODE_REL);
 		return;
@@ -584,10 +586,11 @@
 			Rt = 0;
 	}
 
-	/* NOTE: We can't rely on the pressure to determine the pen down
-	 * state, even this controller has a pressure sensor.  The pressure
-	 * value can fluctuate for quite a while after lifting the pen and
-	 * in some cases may not even settle at the expected value.
+	/* NOTE: We can't rely on the pressure to determine the pen
+	 * down state, not even if this controller has a pressure
+	 * sensor.  The pressure value can fluctuate for quite a while
+	 * after lifting the pen and in some cases may not even settle
+	 * at the expected value.
 	 *
 	 * The only safe way to check for the pen up condition is in the
 	 * timer by reading the pen signal state (it's a GPIO _and_ IRQ).
@@ -598,9 +601,7 @@
 		if (!ts->pendown) {
 			input_report_key(input, BTN_TOUCH, 1);
 			ts->pendown = 1;
-#ifdef VERBOSE
 			dev_dbg(&ts->spi->dev, "DOWN\n");
-#endif
 		}
 
 		if (ts->swap_xy)
@@ -608,12 +609,10 @@
 
 		input_report_abs(input, ABS_X, x);
 		input_report_abs(input, ABS_Y, y);
-		input_report_abs(input, ABS_PRESSURE, Rt);
+		input_report_abs(input, ABS_PRESSURE, ts->pressure_max-Rt);
 
 		input_sync(input);
-#ifdef VERBOSE
 		dev_dbg(&ts->spi->dev, "%4d/%4d/%4d\n", x, y, Rt);
-#endif
 	}
 
 	hrtimer_start(&ts->timer, ktime_set(0, TS_POLL_PERIOD),
@@ -723,9 +722,7 @@
 			input_sync(input);
 
 			ts->pendown = 0;
-#ifdef VERBOSE
 			dev_dbg(&ts->spi->dev, "UP\n");
-#endif
 		}
 
 		/* measurement cycle ended */


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
