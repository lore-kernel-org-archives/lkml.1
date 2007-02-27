Return-Path: <linux-kernel-owner+w=401wt.eu-S1751451AbXB0Bll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbXB0Bll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXB0Bll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:41:41 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59050 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXB0Blk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:41:40 -0500
Subject: [RFC][PATCH] v850 generic timekeeping conversion
From: john stultz <johnstul@us.ibm.com>
To: uclinux-v850@lsi.nec.co.jp
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 17:41:35 -0800
Message-Id: <1172540495.15970.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to the h8/300 patch I just sent out, in that it converts
a arch that does not currently implement sub-jiffy timekeeping to use
the generic timekeeping code.

v850 however looks like it has some intent to implement sub-jiffy
timekeeping, so it may not yet be appropriate to try to convert, but I
figured I'd get the maintainer's input and submit the patch for comment.

And again, I do not have hardware, so this is completely untested.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/v850/Kconfig b/arch/v850/Kconfig
index 50ccc7f..5f54c12 100644
--- a/arch/v850/Kconfig
+++ b/arch/v850/Kconfig
@@ -37,6 +37,10 @@ config GENERIC_IRQ_PROBE
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
 config TIME_LOW_RES
 	bool
 	default y
diff --git a/arch/v850/kernel/time.c b/arch/v850/kernel/time.c
index 486e3a4..f0905b0 100644
--- a/arch/v850/kernel/time.c
+++ b/arch/v850/kernel/time.c
@@ -90,81 +90,6 @@ #endif /* 0 */
 	return IRQ_HANDLED;
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday (struct timeval *tv)
-{
-#if 0 /* DAVIDM later if possible */
-	extern volatile unsigned long lost_ticks;
-	unsigned long lost;
-#endif
-	unsigned long flags;
-	unsigned long usec, sec;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-#if 0
-		usec = mach_gettimeoffset ? mach_gettimeoffset () : 0;
-#else
-		usec = 0;
-#endif
-#if 0 /* DAVIDM later if possible */
-		lost = lost_ticks;
-		if (lost)
-			usec += lost * (1000000/HZ);
-#endif
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / 1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
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
-	write_seqlock_irq (&xtime_lock);
-
-	/* This is revolting. We need to set the xtime.tv_nsec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-#if 0
-	tv->tv_nsec -= mach_gettimeoffset() * 1000;
-#endif
-
-	while (tv->tv_nsec < 0) {
-		tv->tv_nsec += NSEC_PER_SEC;
-		tv->tv_sec--;
-	}
-
-	xtime.tv_sec = tv->tv_sec;
-	xtime.tv_nsec = tv->tv_nsec;
-
-	ntp_clear();
-
-	write_sequnlock_irq (&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
 static int timer_dev_id;
 static struct irqaction timer_irqaction = {
 	timer_interrupt,

