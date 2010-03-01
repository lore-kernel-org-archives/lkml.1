Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0CAWvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:51:48 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47665 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0CAWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:51:47 -0500
Subject: [PATCH 1/3] Convert cris to arch_gettimeoffset()
From: john stultz <johnstul@us.ibm.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-cris-kernel@axis.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 14:51:37 -0800
Message-ID: <1267483897.4216.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts cris to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

The cris architecture is one of the last 2 arches that need to be
converted.

This patch applies on top of Linus' current -git tree

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. My cross-compiler is now out of date (gcc4.2) so I
wasn't able to check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/cris/Kconfig       |    6 ++++
 arch/cris/kernel/time.c |   68 +---------------------------------------------
 2 files changed, 8 insertions(+), 66 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 7adac38..059eac6 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -20,6 +20,12 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 config GENERIC_IOMAP
        bool
        default y
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index 074fe7d..a05dd31 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -42,75 +42,11 @@ unsigned long loops_per_usec;
 extern unsigned long do_slow_gettimeoffset(void);
 static unsigned long (*do_gettimeoffset)(void) = do_slow_gettimeoffset;
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- *
- * Note: Division is quite slow on CRIS and do_gettimeofday is called
- *       rather often. Maybe we should do some kind of approximation here
- *       (a naive approximation would be to divide by 1024).
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	signed long usec, sec;
-	local_irq_save(flags);
-	usec = do_gettimeoffset();
-
-        /*
-	 * If time_adjust is negative then NTP is slowing the clock
-	 * so make sure not to go into next possible interval.
-	 * Better to lose some accuracy than have time go backwards..
-	 */
-	if (unlikely(time_adjust < 0) && usec > tickadj)
-		usec = tickadj;
-
-	sec = xtime.tv_sec;
-	usec += xtime.tv_nsec / 1000;
-	local_irq_restore(flags);
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
+u32 arch_gettimeoffset(void)
 {
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= do_gettimeoffset() * NSEC_PER_USEC;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
+	return do_gettimeoffset() * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
 /*
  * BUG: This routine does not handle hour overflow properly; it just
  *      sets the minutes. Usually you'll only notice that after reboot!
-- 
1.6.0.4



