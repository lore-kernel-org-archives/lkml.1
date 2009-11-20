Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZKTSvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZKTSvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZKTSvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:51:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35875 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZKTSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:51:03 -0500
Date: Fri, 20 Nov 2009 19:50:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: ads7846 touchscreen: fix pressure
Message-ID: <20091120185058.GA1472@ucw.cz>
References: <20091120182238.GA1344@ucw.cz> <20091120182528.GB16447@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120182528.GB16447@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > On Zaurus, pressure is reported inverted -- the lighter the pressure,
> > the bigger numerical value. This should fix it.
> > 
> 
> Thanks. Didn't you also have a bigger cleanup patch for ads7846?

Yes, I did, but I wanted to avoid risk for collision. So pick one...

--

Cleanup touchscreen driver and fix pressure on spitz.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/drivers/input/touchscreen/ads7846.c	2009-10-06 13:49:56.000000000 +0200
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


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
