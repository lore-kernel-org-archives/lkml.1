Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZA2EIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZA2EIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZA2EIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:08:31 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52825 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbZA2EIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:08:30 -0500
Subject: [RFC][PATCH 4/10] Convert cris to use arch_getoffset()
	infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233202074.6895.33.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
	 <1233202037.6895.30.camel@localhost.localdomain>
	 <1233202074.6895.33.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:08:24 -0800
Message-Id: <1233202104.6895.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
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

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 3462245..8082352 100644
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


