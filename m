Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZA2EIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZA2EIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZA2EID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:08:03 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60538 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbZA2EIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:08:00 -0500
Subject: [RFC][PATCH 3/10] Convert blackfin to use arch_getoffset()
	infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233202037.6895.30.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
	 <1233202037.6895.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:07:54 -0800
Message-Id: <1233202074.6895.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
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
index a949c4f..ebe5e28 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -576,9 +576,7 @@ comment "Kernel Timer/Scheduler"
 source kernel/Kconfig.hz
 
 config GENERIC_TIME
-	bool "Generic time"
-	depends on !SMP
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
@@ -598,6 +596,10 @@ config CYCLES_CLOCKSOURCE
 	  still be able to read it (such as for performance monitoring), but
 	  writing the registers will most likely crash the kernel.
 
+config ARCH_USES_GETTIMEOFFSET
+	depends on !CYCLES_CLOCKSOURCE
+	def_bool y
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 172b4c5..20870f7 100644
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
@@ -196,64 +196,29 @@ void __init time_init(void)
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


