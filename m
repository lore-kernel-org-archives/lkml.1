Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZDOBqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZDOBqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZDOBqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:46:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53843 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbZDOBqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:46:44 -0400
Subject: [RFC][PATCH 6/8] Convert m68k to use arch_getoffset()
 infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rmk+lkml@arm.linux.org.uk, cooloney@kernel.org, starvik@axis.com,
       takata@linux-m32r.org, geert@linux-m68k.org,
       Roman Zippel <zippel@linux-m68k.org>, lethal@linux-sh.org,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       rth@twiddle.net
In-Reply-To: <1239759929.6064.38.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>  <1239759393.6064.30.camel@localhost>
	 <1239759551.6064.33.camel@localhost>  <1239759668.6064.35.camel@localhost>
	 <1239759805.6064.36.camel@localhost>  <1239759877.6064.37.camel@localhost>
	 <1239759929.6064.38.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:46:40 -0700
Message-Id: <1239760000.6064.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts m68k to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I do not have cross compilers for these architectures, and in some cases
the architectures can be compiles both with and without clocksources. So
I've taken my best swing at converting this, but I'm not confident I got
it right. Any assistance from arch maintainers or testers would be
great.

NOT FOR INCLUSION
Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index fb87c08..29dd848 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -58,6 +58,12 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 54d9807..17dc2a3 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -91,77 +91,11 @@ void __init time_init(void)
 	mach_sched_init(timer_interrupt);
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-	unsigned long max_ntp_tick = tick_usec - tickadj;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		usec = mach_gettimeoffset();
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
-		usec += xtime.tv_nsec/1000;
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
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
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/* This is revolting. We need to set the xtime.tv_nsec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= 1000 * mach_gettimeoffset();
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
+	return mach_gettimeoffset() * 1000;
 }
 
-EXPORT_SYMBOL(do_settimeofday);
-
-
 static int __init rtc_init(void)
 {
 	struct platform_device *pdev;


