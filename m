Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZA2EJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZA2EJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZA2EJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:09:06 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42141 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbZA2EJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:09:05 -0500
Subject: [RFC][PATCH 5/10] Convert m32r to use arch_getoffset()
	infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233202104.6895.35.camel@localhost.localdomain>
References: <1233201926.6895.25.camel@localhost.localdomain>
	 <1233201995.6895.27.camel@localhost.localdomain>
	 <1233202037.6895.30.camel@localhost.localdomain>
	 <1233202074.6895.33.camel@localhost.localdomain>
	 <1233202104.6895.35.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 20:08:59 -0800
Message-Id: <1233202139.6895.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts m32r to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>


diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index cabba33..c41234f 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -41,6 +41,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 6ea0177..01b67d0 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -48,7 +48,7 @@ extern void smp_local_timer_interrupt(void);
 
 static unsigned long latch;
 
-static unsigned long do_gettimeoffset(void)
+u32 arch_gettimeoffset(void)
 {
 	unsigned long  elapsed_time = 0;  /* [us] */
 
@@ -93,79 +93,10 @@ static unsigned long do_gettimeoffset(void)
 #error no chip configuration
 #endif
 
-	return elapsed_time;
+	return elapsed_time * 1000;
 }
 
 /*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-
-		usec = do_gettimeoffset();
-
-		/*
-		 * If time_adjust is negative then NTP is slowing the clock
-		 * so make sure not to go into next possible interval.
-		 * Better to lose some accuracy than have time go backwards..
-		 */
-		if (unlikely(time_adjust < 0))
-			usec = min(usec, max_ntp_tick);
-
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry(&xtime_lock, seq));
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
-	time_t wtm_sec, sec = tv->tv_sec;
- 	long wtm_nsec, nsec = tv->tv_nsec;
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
-	wtm_sec = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-/*
  * In order to set the CMOS clock precisely, set_rtc_mmss has to be
  * called 500 ms after the second nowtime has started, because when
  * nowtime is written into the registers of the CMOS clock, it will
@@ -192,6 +123,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
+	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
 	do_timer(1);
 
 #ifndef CONFIG_SMP


