Return-Path: <linux-kernel-owner+w=401wt.eu-S933210AbZLFKAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbZLFKAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbZLFKAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:00:39 -0500
Received: from www.tglx.de ([62.245.132.106]:48289 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185AbZLFKAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:00:38 -0500
Date: Sun, 6 Dec 2009 10:59:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timers urgent for 2.6.33
Message-ID: <alpine.LFD.2.00.0912061055470.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus-urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus-urgent

Thanks,

	tglx

------------------>
Feng Tang (1):
      hrtimer: Fix /proc/timer_list regression

Lin Ming (1):
      timekeeping: Fix clock_gettime vsyscall time warp

Stanislaw Gruszka (1):
      itimers: Fix racy writes to cpu_itimer fields


 arch/ia64/kernel/time.c       |    4 ++--
 arch/powerpc/kernel/time.c    |    5 +++--
 arch/s390/kernel/time.c       |    3 ++-
 arch/x86/kernel/vsyscall_64.c |    5 +++--
 include/linux/clocksource.h   |    6 ++++--
 include/linux/hrtimer.h       |    4 +---
 kernel/itimer.c               |    7 +++++--
 kernel/time/timekeeping.c     |    6 +++---
 8 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 4990495..a35c661 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -473,7 +473,7 @@ void update_vsyscall_tz(void)
 {
 }
 
-void update_vsyscall(struct timespec *wall, struct clocksource *c)
+void update_vsyscall(struct timespec *wall, struct clocksource *c, u32 mult)
 {
         unsigned long flags;
 
@@ -481,7 +481,7 @@ void update_vsyscall(struct timespec *wall, struct clocksource *c)
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
-        fsyscall_gtod_data.clk_mult = c->mult;
+        fsyscall_gtod_data.clk_mult = mult;
         fsyscall_gtod_data.clk_shift = c->shift;
         fsyscall_gtod_data.clk_fsys_mmio = c->fsys_mmio;
         fsyscall_gtod_data.clk_cycle_last = c->cycle_last;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a136a11..3971331 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -828,7 +828,8 @@ static cycle_t timebase_read(struct clocksource *cs)
 	return (cycle_t)get_tb();
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     u32 mult)
 {
 	u64 t2x, stamp_xsec;
 
@@ -841,7 +842,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
-	t2x = (u64) clock->mult * 4611686018ULL;
+	t2x = (u64) mult * 4611686018ULL;
 	stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
 	do_div(stamp_xsec, 1000000000);
 	stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 34162a0..68e1ecf 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -214,7 +214,8 @@ struct clocksource * __init clocksource_default_clock(void)
 	return &clocksource_tod;
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     u32 mult)
 {
 	if (clock != &clocksource_tod)
 		return;
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8cb4974..62f39d7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -73,7 +73,8 @@ void update_vsyscall_tz(void)
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
+		     u32 mult)
 {
 	unsigned long flags;
 
@@ -82,7 +83,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
 	vsyscall_gtod_data.clock.vread = clock->vread;
 	vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
 	vsyscall_gtod_data.clock.mask = clock->mask;
-	vsyscall_gtod_data.clock.mult = clock->mult;
+	vsyscall_gtod_data.clock.mult = mult;
 	vsyscall_gtod_data.clock.shift = clock->shift;
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 83d2fbd..95e4995 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -280,10 +280,12 @@ extern struct clocksource * __init __weak clocksource_default_clock(void);
 extern void clocksource_mark_unstable(struct clocksource *cs);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
-extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
+extern void
+update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult);
 extern void update_vsyscall_tz(void);
 #else
-static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
+static inline void
+update_vsyscall(struct timespec *ts, struct clocksource *c, u32 mult)
 {
 }
 
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index ff037f0..9bace4b 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -446,7 +446,7 @@ extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
-	if (likely(!timer->start_site))
+	if (likely(!timer_stats_active))
 		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
@@ -457,8 +457,6 @@ extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
-	if (likely(!timer_stats_active))
-		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 
diff --git a/kernel/itimer.c b/kernel/itimer.c
index b03451e..d802883 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -146,6 +146,7 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 {
 	cputime_t cval, nval, cinterval, ninterval;
 	s64 ns_ninterval, ns_nval;
+	u32 error, incr_error;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
 	nval = timeval_to_cputime(&value->it_value);
@@ -153,8 +154,8 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	ninterval = timeval_to_cputime(&value->it_interval);
 	ns_ninterval = timeval_to_ns(&value->it_interval);
 
-	it->incr_error = cputime_sub_ns(ninterval, ns_ninterval);
-	it->error = cputime_sub_ns(nval, ns_nval);
+	error = cputime_sub_ns(nval, ns_nval);
+	incr_error = cputime_sub_ns(ninterval, ns_ninterval);
 
 	spin_lock_irq(&tsk->sighand->siglock);
 
@@ -168,6 +169,8 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	}
 	it->expires = nval;
 	it->incr = ninterval;
+	it->error = error;
+	it->incr_error = incr_error;
 	trace_itimer_state(clock_id == CPUCLOCK_VIRT ?
 			   ITIMER_VIRTUAL : ITIMER_PROF, value, nval);
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c3a4e29..2a6d3e3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -177,7 +177,7 @@ void timekeeping_leap_insert(int leapsecond)
 {
 	xtime.tv_sec += leapsecond;
 	wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&xtime, timekeeper.clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
 #ifdef CONFIG_GENERIC_TIME
@@ -337,7 +337,7 @@ int do_settimeofday(struct timespec *tv)
 	timekeeper.ntp_error = 0;
 	ntp_clear();
 
-	update_vsyscall(&xtime, timekeeper.clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
@@ -811,7 +811,7 @@ void update_wall_time(void)
 	update_xtime_cache(nsecs);
 
 	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&xtime, timekeeper.clock);
+	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
 /**
