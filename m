Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXB0Bde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXB0Bde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343AbXB0Bde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:33:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34102 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXB0Bdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:33:33 -0500
Subject: [PATCH] Convert h8/300 to generic timekeeping
From: john stultz <johnstul@us.ibm.com>
To: ysato@users.sourceforge.jp
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 17:33:29 -0800
Message-Id: <1172540009.15970.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently h8/300 does not implement sub-jiffy timekeeping, so there is
no benefit to having arch specific timekeeping code.

This patch simply removes those functions and enables the generic
timekeeping code.

I don't have the hardware, so this is completely untested.

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

