Return-Path: <linux-kernel-owner+w=401wt.eu-S1751358AbZIHOks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbZIHOks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZIHOkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:40:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbZIHOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:40:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 1/1] posix-cpu-timers: fix CPUCLOCK_{PROF,VIRT} periodic tics precision -v1
Date: Tue,  8 Sep 2009 16:40:08 +0200
Message-Id: <1252420808-4273-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1252420808-4273-1-git-send-email-sgruszka@redhat.com>
References: <1250001100-3936-1-git-send-email-sgruszka@redhat.com>
 <1252420808-4273-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating next expires time and timer overrun value for periodic
timer use real nanosecond interval value provided by user (same 64 bits
algorithm as for CPUCLOCK_SCHED). Then round up values for cputime
resolution based on nanosecond value of one cpu tick.

With CONFIG_VIRT_CPU_ACCOUNTING=y we do not need to any extra conversions
because cputime is 64 bit value accurately accounted.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/linux/posix-timers.h |   19 ++++++++
 kernel/itimer.c              |   11 ----
 kernel/posix-cpu-timers.c    |  104 +++++++++++++++++++++++++++++-------------
 3 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..a3fbeb7 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -15,6 +15,10 @@ struct cpu_timer_list {
 	union cpu_time_count expires, incr;
 	struct task_struct *task;
 	int firing;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	u32 error;
+	u64 real_incr;
+#endif
 };
 
 #define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
@@ -119,4 +123,19 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 
 void update_rlimit_cpu(unsigned long rlim_new);
 
+/*
+ * Helper for calculating error when rounding time values providing
+ * in nano or micro seconds to cputime_t ticks.
+ */
+static inline u32 cputime_sub_ns(cputime_t ct, s64 real_ns)
+{
+	struct timespec ts;
+	s64 cpu_ns;
+
+	cputime_to_timespec(ct, &ts);
+	cpu_ns = timespec_to_ns(&ts);
+
+	return (cpu_ns <= real_ns) ? 0 : cpu_ns - real_ns;
+}
+
 #endif
diff --git a/kernel/itimer.c b/kernel/itimer.c
index b03451e..33db81d 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -129,17 +129,6 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static inline u32 cputime_sub_ns(cputime_t ct, s64 real_ns)
-{
-	struct timespec ts;
-	s64 cpu_ns;
-
-	cputime_to_timespec(ct, &ts);
-	cpu_ns = timespec_to_ns(&ts);
-
-	return (cpu_ns <= real_ns) ? 0 : cpu_ns - real_ns;
-}
-
 static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 			   const struct itimerval *const value,
 			   struct itimerval *const ovalue)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..eb8774c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -118,6 +118,11 @@ static inline cputime_t cputime_div_non_zero(cputime_t time, unsigned long div)
 }
 
 /*
+ * One jiffy in nanoseconds, calculated using real frequency of hardware timer.
+ */
+static u32 onecputick;
+
+/*
  * Update expiry time from increment, and increase overrun count,
  * given the current clock sample.
  */
@@ -125,47 +130,69 @@ static void bump_cpu_timer(struct k_itimer *timer,
 				  union cpu_time_count now)
 {
 	int i;
+	unsigned long long now_ll, expires, delta, incr;
 
 	if (timer->it.cpu.incr.sched == 0)
 		return;
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
-		unsigned long long delta, incr;
-
+#endif
 		if (now.sched < timer->it.cpu.expires.sched)
 			return;
+
+		now_ll = now.sched;
+		expires = timer->it.cpu.expires.sched;
 		incr = timer->it.cpu.incr.sched;
-		delta = now.sched + incr - timer->it.cpu.expires.sched;
-		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; incr < delta - incr; i++)
-			incr = incr << 1;
-		for (; i >= 0; incr >>= 1, i--) {
-			if (delta < incr)
-				continue;
-			timer->it.cpu.expires.sched += incr;
-			timer->it_overrun += 1 << i;
-			delta -= incr;
-		}
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	} else {
-		cputime_t delta, incr;
-
 		if (cputime_lt(now.cpu, timer->it.cpu.expires.cpu))
 			return;
-		incr = timer->it.cpu.incr.cpu;
-		delta = cputime_sub(cputime_add(now.cpu, incr),
-				    timer->it.cpu.expires.cpu);
-		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; cputime_lt(incr, cputime_sub(delta, incr)); i++)
-			     incr = cputime_add(incr, incr);
-		for (; i >= 0; incr = cputime_halve(incr), i--) {
-			if (cputime_lt(delta, incr))
-				continue;
-			timer->it.cpu.expires.cpu =
-				cputime_add(timer->it.cpu.expires.cpu, incr);
-			timer->it_overrun += 1 << i;
-			delta = cputime_sub(delta, incr);
+
+		now_ll = cputime_to_jiffies(now.cpu);
+		now_ll *= onecputick;
+
+		expires = cputime_to_jiffies(timer->it.cpu.expires.cpu);
+		expires *= onecputick;
+		expires -= timer->it.cpu.error;
+
+		incr = timer->it.cpu.real_incr;
+	}
+#endif
+
+	delta = now_ll + incr - expires;
+
+	/* Don't use (incr*2 < delta), incr*2 might overflow. */
+	for (i = 0; incr < delta - incr; i++)
+		incr = incr << 1;
+	for (; i >= 0; incr >>= 1, i--) {
+		if (delta < incr)
+			continue;
+		expires += incr;
+		timer->it_overrun += 1 << i;
+		delta -= incr;
+	}
+
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED)
+#endif
+		timer->it.cpu.expires.sched = expires;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	else {
+		unsigned long exp_jiffy;
+		u32 error;
+
+		error = do_div(expires, onecputick);
+		if (error == 0) {
+			exp_jiffy = expires;
+			timer->it.cpu.error = 0;
+		} else {
+			exp_jiffy = expires + 1;
+			timer->it.cpu.error = onecputick - error;
 		}
+		timer->it.cpu.expires.cpu = jiffies_to_cputime(exp_jiffy);
 	}
+#endif
 }
 
 static inline cputime_t prof_ticks(struct task_struct *p)
@@ -398,6 +425,10 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 	new_timer->it.cpu.incr.sched = 0;
 	new_timer->it.cpu.expires.sched = 0;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	new_timer->it.cpu.error = 0;
+	new_timer->it.cpu.real_incr = 0;
+#endif
 
 	read_lock(&tasklist_lock);
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
@@ -843,6 +874,16 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	timer->it.cpu.incr = timespec_to_sample(timer->it_clock,
 						&new->it_interval);
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+	if (CPUCLOCK_WHICH(timer->it_clock) != CPUCLOCK_SCHED) {
+		cputime_t val = timespec_to_cputime(&new->it_value);
+		s64 ns_val = timespec_to_ns(&new->it_value);
+
+		timer->it.cpu.error = cputime_sub_ns(val, ns_val);
+		timer->it.cpu.real_incr = timespec_to_ns(&new->it_interval);
+	}
+#endif
+
 	/*
 	 * This acts as a modification timestamp for the timer,
 	 * so any automatic reload attempt will punt on seeing
@@ -1074,7 +1115,6 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
-static u32 onecputick;
 
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 			     cputime_t *expires, cputime_t cur_time, int signo)
@@ -1715,13 +1755,13 @@ static __init int init_posix_cpu_timers(void)
 	};
 	struct timespec ts;
 
-	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
-	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
-
 	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
 	WARN_ON(ts.tv_sec != 0);
 
+	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
+	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
+
 	return 0;
 }
 __initcall(init_posix_cpu_timers);
-- 
1.6.2.5

