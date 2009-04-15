Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZDOBov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZDOBov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZDOBom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:44:42 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46647 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZDOBol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:44:41 -0400
Subject: [RFC][PATCH 4/8] Convert cris to use arch_getoffset()
 infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
In-Reply-To: <1239759805.6064.36.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>  <1239759393.6064.30.camel@localhost>
	 <1239759551.6064.33.camel@localhost>  <1239759668.6064.35.camel@localhost>
	 <1239759805.6064.36.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:44:37 -0700
Message-Id: <1239759877.6064.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts cris to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

NOT FOR INCLUSION
Signed-off-by: John Stultz <johnstul@us.ibm.com>

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


