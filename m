Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZDOBjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZDOBjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZDOBjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:39:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52233 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZDOBjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:39:15 -0400
Subject: [RFC][PATCH 1/8] Convert alpha to use arch_getoffset()
 infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
In-Reply-To: <1239759393.6064.30.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>  <1239759393.6064.30.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:39:11 -0700
Message-Id: <1239759551.6064.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts alpha to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

NOT FOR INCLUSION
Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 9fb8aae..4434481 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -45,6 +45,14 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config GENERIC_TIME
+	bool
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	bool
+	default y
+
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index b04e2cb..8f7eb6d 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -408,28 +408,17 @@ time_init(void)
  * part.  So we can't do the "find absolute time in terms of cycles" thing
  * that the other ports do.
  */
-void
-do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long sec, usec, seq;
 	unsigned long delta_cycles, delta_usec, partial_tick;
 
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		delta_cycles = rpcc() - state.last_time;
-		sec = xtime.tv_sec;
-		usec = (xtime.tv_nsec / 1000);
-		partial_tick = state.partial_tick;
-
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
 #ifdef CONFIG_SMP
 	/* Until and unless we figure out how to get cpu cycle counters
 	   in sync and keep them there, we can't use the rpcc tricks.  */
 	delta_usec = 0;
 #else
+	delta_cycles = rpcc() - state.last_time;
+	partial_tick = state.partial_tick;
 	/*
 	 * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
 	 *	= cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
@@ -448,62 +437,9 @@ do_gettimeofday(struct timeval *tv)
 	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
 #endif
 
-	usec += delta_usec;
-	if (usec >= 1000000) {
-		sec += 1;
-		usec -= 1000000;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int
-do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-	unsigned long delta_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-
-	/* The offset that is added into time in do_gettimeofday above
-	   must be subtracted out here to keep a coherent view of the
-	   time.  Without this, a full-tick error is possible.  */
-
-#ifdef CONFIG_SMP
-	delta_nsec = 0;
-#else
-	delta_nsec = rpcc() - state.last_time;
-	delta_nsec = (delta_nsec * state.scaled_ticks_per_cycle 
-		      + state.partial_tick) * 15625;
-	delta_nsec = ((delta_nsec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
-	delta_nsec *= 1000;
-#endif
-
-	nsec -= delta_nsec;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
+	return delta_usec * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
 /*
  * In order to set the CMOS clock precisely, set_rtc_mmss has to be
  * called 500 ms after the second nowtime has started, because when


