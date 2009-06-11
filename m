Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbZFKCK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbZFKCK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZFKCKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:10:48 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44195 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZFKCKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:10:48 -0400
Subject: [PATCH] Convert sh to use arch_getoffset() infrastructure
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 19:10:31 -0700
Message-Id: <1244686231.8085.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts sh to use GENERIC_TIME via the arch_getoffset()
infrastructure, reducing the amount of arch specific code we need to
maintain.

This patch got dropped last cycle due to the high flux rate of the sh
arch at the time, so I wanted to resubmit it again.

This patch applies on top of the "create arch_gettimeoffset
infrastructure." patch currently in -tip. 

http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=7d27558c4138ac6b3684dea35c2f4379b940a7dd;hp=a25cbd045a2ffc42787d4dbcbb9c7118f5f42732

I've taken my best swing at converting this, but I'm not 100% confident
I got it right. It does cross compile, so that's hopefully a good sign.
Any assistance from arch maintainers or testers to get this merged would
be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-(once long ago)-by: Paul Mundt <lethal@linux-sh.org>
---

 Kconfig                    |    7 +++--
 include/asm/timer.h        |    4 +-
 kernel/time_32.c           |   63 +++------------------------------------------
 kernel/time_64.c           |   53 +------------------------------------
 kernel/timers/timer-cmt.c  |    2 -
 kernel/timers/timer-mtu2.c |    2 -
 6 files changed, 16 insertions(+), 115 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index e7390dd..18166f2 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -74,7 +74,7 @@ config GENERIC_IOMAP
 	bool
 
 config GENERIC_TIME
-	def_bool n
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	def_bool n
@@ -446,11 +446,14 @@ config SH_TMU
 	bool "TMU timer support"
 	depends on CPU_SH3 || CPU_SH4
 	default y
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  This enables the use of the TMU as the system timer.
 
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+	depends on !SH_TMU
+
 config SH_CMT
 	bool "CMT timer support"
 	depends on SYS_SUPPORTS_CMT && CPU_SH2
diff --git a/arch/sh/include/asm/timer.h b/arch/sh/include/asm/timer.h
index 4c3b66e..f688df2 100644
--- a/arch/sh/include/asm/timer.h
+++ b/arch/sh/include/asm/timer.h
@@ -9,7 +9,7 @@ struct sys_timer_ops {
 	int (*init)(void);
 	int (*start)(void);
 	int (*stop)(void);
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	unsigned long (*get_offset)(void);
 #endif
 };
@@ -26,7 +26,7 @@ struct sys_timer {
 extern struct sys_timer tmu_timer, cmt_timer, mtu2_timer;
 extern struct sys_timer *sys_timer;
 
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 static inline unsigned long get_timer_offset(void)
 {
 	return sys_timer->ops->get_offset();
diff --git a/arch/sh/kernel/time_32.c b/arch/sh/kernel/time_32.c
index 1700d24..08016fb 100644
--- a/arch/sh/kernel/time_32.c
+++ b/arch/sh/kernel/time_32.c
@@ -44,65 +44,12 @@ static int null_rtc_set_time(const time_t secs)
 void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
-#ifndef CONFIG_GENERIC_TIME
-void do_gettimeofday(struct timeval *tv)
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		/*
-		 * Turn off IRQs when grabbing xtime_lock, so that
-		 * the sys_timer get_offset code doesn't have to handle it.
-		 */
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = get_timer_offset();
-		sec = xtime.tv_sec;
-		usec += xtime.tv_nsec / NSEC_PER_USEC;
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
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= get_timer_offset() * NSEC_PER_USEC;
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
-
-	return 0;
+	return get_timer_offset() * 1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
-#endif /* !CONFIG_GENERIC_TIME */
+#endif /* CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 /* last time the RTC clock got updated */
 static long last_rtc_update;
@@ -199,7 +146,7 @@ struct clocksource clocksource_sh = {
 	.name		= "SuperH",
 };
 
-#ifdef CONFIG_GENERIC_TIME
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 unsigned long long sched_clock(void)
 {
 	unsigned long long cycles;
diff --git a/arch/sh/kernel/time_64.c b/arch/sh/kernel/time_64.c
index 988c77c..f4f5e8a 100644
--- a/arch/sh/kernel/time_64.c
+++ b/arch/sh/kernel/time_64.c
@@ -144,59 +144,10 @@ static unsigned long usecs_since_tick(void)
 	return result;
 }
 
-void do_gettimeofday(struct timeval *tv)
+u32 arch_gettimeoffset(void)
 {
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = usecs_since_tick();
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
-	 * This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-	nsec -= 1000 * usecs_since_tick();
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
-
-	return 0;
+	return usecs_since_tick() * 1000;
 }
-EXPORT_SYMBOL(do_settimeofday);
 
 /* Dummy RTC ops */
 static void null_rtc_get_time(struct timespec *tv)
diff --git a/arch/sh/kernel/timers/timer-cmt.c b/arch/sh/kernel/timers/timer-cmt.c
index 9aa3486..c5e5ad7 100644
--- a/arch/sh/kernel/timers/timer-cmt.c
+++ b/arch/sh/kernel/timers/timer-cmt.c
@@ -177,7 +177,7 @@ static struct sys_timer_ops cmt_timer_ops = {
 	.init		= cmt_timer_init,
 	.start		= cmt_timer_start,
 	.stop		= cmt_timer_stop,
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	.get_offset	= cmt_timer_get_offset,
 #endif
 };
diff --git a/arch/sh/kernel/timers/timer-mtu2.c b/arch/sh/kernel/timers/timer-mtu2.c
index 9b0ef01..8a1dcc2 100644
--- a/arch/sh/kernel/timers/timer-mtu2.c
+++ b/arch/sh/kernel/timers/timer-mtu2.c
@@ -191,7 +191,7 @@ struct sys_timer_ops mtu2_timer_ops = {
 	.init		= mtu2_timer_init,
 	.start		= mtu2_timer_start,
 	.stop		= mtu2_timer_stop,
-#ifndef CONFIG_GENERIC_TIME
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	.get_offset	= mtu2_timer_get_offset,
 #endif
 };


