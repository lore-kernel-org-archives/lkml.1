Return-Path: <linux-kernel-owner+w=401wt.eu-S1161094AbXDJXZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161094AbXDJXZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXDJXZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:25:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42744 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161094AbXDJXZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:25:04 -0400
Subject: [PATCH] h8300 trivial conversion to GENERIC_TIME
From: john stultz <johnstul@us.ibm.com>
To: ysato@users.sourceforge.jp
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 16:25:00 -0700
Message-Id: <1176247500.15198.72.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a trivial conversion of the h8300 arch to the GENERIC_TIME
infrastructure (h8300 does not have better then jiffies resolution, so
there are no clocksources to add). I have not tested this at all, but it
seems pretty straight forward

I'd appreciate any comments or feedback!

thanks
-john


Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 1734d96..86f6ca3 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -53,6 +53,10 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
 config TIME_LOW_RES
 	bool
 	default y
diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index d1ef615..91d3b56 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -66,55 +66,3 @@ void time_init(void)
 
 	platform_timer_setup(timer_interrupt);
 }
-
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long usec, sec;
-
-	read_lock_irqsave(&xtime_lock, flags);
-	usec = 0;
-	sec = xtime.tv_sec;
-	usec += (xtime.tv_nsec / 1000);
-	read_unlock_irqrestore(&xtime_lock, flags);
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_lock_irq(&xtime_lock);
-	/* This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	while (tv->tv_nsec < 0) {
-		tv->tv_nsec += NSEC_PER_SEC;
-		tv->tv_sec--;
-	}
-
-	xtime.tv_sec = tv->tv_sec;
-	xtime.tv_nsec = tv->tv_nsec;
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);

