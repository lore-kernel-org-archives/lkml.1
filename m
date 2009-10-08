Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZJHGGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZJHGGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZJHGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34514 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZJHGFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/13] Blackfin: convert to use arch_gettimeoffset()
Date: Thu,  8 Oct 2009 02:04:17 -0400
Message-Id: <1254981869-21586-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

Convert Blackfin to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

I've taken my best swing at converting this, but I'm not 100% confident
I got it right.  My cross-compiler is now out of date (gcc4.2) so I
wasn't able to check if it compiled. Any assistance from arch
maintainers or testers to get this merged would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig       |   10 ++++---
 arch/blackfin/kernel/time.c |   63 +-----------------------------------------
 2 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9a01d44..e519882 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -229,7 +229,7 @@ endchoice
 
 config SMP
 	depends on BF561
-	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU,
@@ -613,12 +613,10 @@ comment "Kernel Timer/Scheduler"
 source kernel/Kconfig.hz
 
 config GENERIC_TIME
-	bool "Generic time"
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
-	depends on GENERIC_TIME
 	default y
 
 choice
@@ -653,6 +651,10 @@ config GPTMR0_CLOCKSOURCE
 	depends on GENERIC_CLOCKEVENTS
 	depends on !TICKSOURCE_GPTMR0
 
+config ARCH_USES_GETTIMEOFFSET
+	depends on !GENERIC_CLOCKEVENTS
+	def_bool y
+
 source kernel/time/Kconfig
 
 comment "Misc"
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index adb54aa..e5069fe 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -81,11 +81,11 @@ time_sched_init(irqreturn_t(*timer_routine) (int, void *))
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
@@ -184,65 +184,6 @@ void __init time_init(void)
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
-{
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
-
-	ntp_clear();
-
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-
-	return 0;
-}
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
-- 
1.6.5.rc2

