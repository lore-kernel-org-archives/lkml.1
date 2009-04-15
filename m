Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZDOBgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZDOBgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZDOBgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:36:38 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54349 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbZDOBgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:36:37 -0400
Subject: [RESEND][PATCH 2/2] Convert sh to use arch_getoffset()
 infrastructure.
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rmk+lkml@arm.linux.org.uk,
       cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
       geert@linux-m68k.org, Roman Zippel <zippel@linux-m68k.org>,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       wli@holomorphy.com, rth@twiddle.net
In-Reply-To: <1239759251.6064.27.camel@localhost>
References: <1239759163.6064.25.camel@localhost>
	 <1239759251.6064.27.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:36:33 -0700
Message-Id: <1239759393.6064.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts sh to use GENERIC_TIME via the arch_getoffset()
infrastructure 

I have tried cross-compiling this for sh3 and sh4. Also little has
changed since my last submission where it was acked. So I've taken my
best swing at converting this, but I'm not 100% confident I got it
right. Any assistance from arch maintainers or testers would be great.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index e7390dd..6ee1240 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -74,7 +74,7 @@ config GENERIC_IOMAP
 	bool
 
 config GENERIC_TIME
-	def_bool n
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
 	def_bool n
@@ -451,6 +451,10 @@ config SH_TMU
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
index c34e1e0..b824291 100644
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


