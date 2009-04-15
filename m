Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZDOBnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZDOBnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZDOBna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:43:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54839 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZDOBn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:43:29 -0400
Subject: [RFC][PATCH 3/8] Convert blackfin to use arch_getoffset()
 infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
In-Reply-To: <1239759668.6064.35.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>  <1239759393.6064.30.camel@localhost>
	 <1239759551.6064.33.camel@localhost>  <1239759668.6064.35.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:43:25 -0700
Message-Id: <1239759805.6064.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts blackfin to use GENERIC_TIME via the
arch_getoffset() infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 3640cdc..2b41547 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -606,9 +606,7 @@ comment "Kernel Timer/Scheduler"
 source kernel/Kconfig.hz
 
 config GENERIC_TIME
-	bool "Generic time"
-	depends on !SMP
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
@@ -628,6 +626,10 @@ config CYCLES_CLOCKSOURCE
 	  still be able to read it (such as for performance monitoring), but
 	  writing the registers will most likely crash the kernel.
 
+config ARCH_USES_GETTIMEOFFSET
+	depends on !CYCLES_CLOCKSOURCE
+	def_bool y
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 1bbacfb..ddd1827 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -85,11 +85,11 @@ time_sched_init(irqreturn_t(*timer_routine) (int, void *))
 #endif
 }
 
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 /*
  * Should return useconds since last timer tick
  */
-#ifndef CONFIG_GENERIC_TIME
-static unsigned long gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long offset;
 	unsigned long clocks_per_jiffy;
@@ -199,64 +199,29 @@ void __init time_init(void)
 	time_sched_init(timer_interrupt);
 }
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = gettimeoffset();
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / NSEC_PER_USEC);
-	}
-	while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= USEC_PER_SEC) {
-		usec -= USEC_PER_SEC;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+/*
+ * Should return nseconds since last timer tick
+ */
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
-	 * This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= (gettimeoffset() * NSEC_PER_USEC);
-
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+	unsigned long offset;
+	unsigned long clocks_per_jiffy;
 
-	ntp_clear();
+	clocks_per_jiffy = bfin_read_TPERIOD();
+	offset =
+	    (clocks_per_jiffy -
+	     bfin_read_TCOUNT()) / (((clocks_per_jiffy + 1) * HZ) /
+				    USEC_PER_SEC);
 
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
+	/* Check if we just wrapped the counters and maybe missed a tick */
+	if ((bfin_read_ILAT() & (1 << IRQ_CORETMR))
+	    && (offset < (100000 / HZ / 2)))
+		offset += (USEC_PER_SEC / HZ);
 
-	return 0;
+	return offset*1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
+#endif /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 /*
  * Scheduler clock - returns current time in nanosec units.


