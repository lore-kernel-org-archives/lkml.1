Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZKQLpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZKQLpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZKQLpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:45:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZKQLpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:45:06 -0500
Date: Tue, 17 Nov 2009 12:45:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
Message-ID: <20091117114502.GA1376@ucw.cz>
References: <E1N9Lt7-0007mK-2t@relay07.plus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1N9Lt7-0007mK-2t@relay07.plus.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> hx4700 touchscreen events were being dropped in ads7846_rx() because their pressure values consistently exceeded the platform maximum of 512; a sample of 256 pressure values were in the range 531 to 815. Doubling the platform maximum to 1024 allows hx4700 touchscreen events to pass the test.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>

Does pressure actually work as expected -- that is not inverted?
Because I need this patch on spitz...  but it may break your
machine...

Binary files linux-rc/drivers/input.ofic/built-in.o and linux-rc/drivers/input/built-in.o differ
diff -ur linux-rc/drivers/input.ofic/touchscreen/ads7846.c linux-rc/drivers/input/touchscreen/ads7846.c
--- linux-rc/drivers/input.ofic/touchscreen/ads7846.c	2009-10-06 13:49:56.000000000 +0200
+++ linux-rc/drivers/input/touchscreen/ads7846.c	2009-10-06 21:18:25.000000000 +0200
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
Binary files linux-rc/drivers/input.ofic/touchscreen/ads7846.o and linux-rc/drivers/input/touchscreen/ads7846.o differ
Binary files linux-rc/drivers/input.ofic/touchscreen/built-in.o and linux-rc/drivers/input/touchscreen/built-in.o differ

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
