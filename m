Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZBKOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZBKOk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZBKOkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:40:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZBKOkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:40:11 -0500
Date: Wed, 11 Feb 2009 15:39:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC git pull] timer fixes
Message-ID: <20090211143955.GA4821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

[RFC]

Please consider pulling the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

They reason for the RFC is these commits:

   signal: re-add dead task accumulation stats.
   timers: split process wide cpu clocks/timers
   timers: split process wide cpu clocks/timers, fix
   timers: fix TIMER_ABSTIME for process wide cpu timers

They fix a reported 3% regression, but the fix got a bit large. The plain revert of:

   490dea4: itimers: remove the per-cpu-ish-ness

Would be quite large in itself too, and would likely regress on larger boxes due to 
its n^2 nature. My preferred solution would be to go with Peter's fixes in this 
tree.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      timers: split process wide cpu clocks/timers, remove spurious warning

Pavel Emelyanov (2):
      x86: fix hpet timer reinit for x86_64
      x86: clean up hpet timer reinit

Peter Zijlstra (4):
      signal: re-add dead task accumulation stats.
      timers: split process wide cpu clocks/timers
      timers: split process wide cpu clocks/timers, fix
      timers: fix TIMER_ABSTIME for process wide cpu timers

Suresh Siddha (1):
      sched: fix nohz load balancer on cpu offline


 arch/x86/kernel/hpet.c    |   12 ++++-
 include/linux/init_task.h |   11 ++--
 include/linux/sched.h     |   64 +++++++++++++------------
 kernel/exit.c             |    3 +
 kernel/fork.c             |    3 +-
 kernel/itimer.c           |    4 +-
 kernel/posix-cpu-timers.c |  117 +++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched.c            |   17 ++++--
 kernel/sched_stats.h      |   45 ++++++++++-------
 kernel/signal.c           |    8 ++--
 10 files changed, 209 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..388254f 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -897,7 +897,7 @@ static unsigned long hpet_rtc_flags;
 static int hpet_prev_update_sec;
 static struct rtc_time hpet_alarm_time;
 static unsigned long hpet_pie_count;
-static unsigned long hpet_t1_cmp;
+static u32 hpet_t1_cmp;
 static unsigned long hpet_default_delta;
 static unsigned long hpet_pie_delta;
 static unsigned long hpet_pie_limit;
@@ -905,6 +905,14 @@ static unsigned long hpet_pie_limit;
 static rtc_irq_handler irq_handler;
 
 /*
+ * Check that the hpet counter c1 is ahead of the c2
+ */
+static inline int hpet_cnt_ahead(u32 c1, u32 c2)
+{
+	return (s32)(c2 - c1) < 0;
+}
+
+/*
  * Registers a IRQ handler.
  */
 int hpet_register_irq_handler(rtc_irq_handler handler)
@@ -1075,7 +1083,7 @@ static void hpet_rtc_timer_reinit(void)
 		hpet_t1_cmp += delta;
 		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+	} while (!hpet_cnt_ahead(hpet_t1_cmp, hpet_readl(HPET_COUNTER)));
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index ea0ea1a..e752d97 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -48,12 +48,11 @@ extern struct fs_struct init_fs;
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
-	.cputime	= { .totals = {					\
-		.utime = cputime_zero,					\
-		.stime = cputime_zero,					\
-		.sum_exec_runtime = 0,					\
-		.lock = __SPIN_LOCK_UNLOCKED(sig.cputime.totals.lock),	\
-	}, },								\
+	.cputimer	= { 						\
+		.cputime = INIT_CPUTIME,				\
+		.running = 0,						\
+		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
+	},								\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2127e95..8981e52 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -443,7 +443,6 @@ struct pacct_struct {
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
  * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
- * @lock:		lock for fields in this struct
  *
  * This structure groups together three kinds of CPU time that are
  * tracked for threads and thread groups.  Most things considering
@@ -454,23 +453,33 @@ struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
 	unsigned long long sum_exec_runtime;
-	spinlock_t lock;
 };
 /* Alternate field names when used to cache expirations. */
 #define prof_exp	stime
 #define virt_exp	utime
 #define sched_exp	sum_exec_runtime
 
+#define INIT_CPUTIME	\
+	(struct task_cputime) {					\
+		.utime = cputime_zero,				\
+		.stime = cputime_zero,				\
+		.sum_exec_runtime = 0,				\
+	}
+
 /**
- * struct thread_group_cputime - thread group interval timer counts
- * @totals:		thread group interval timers; substructure for
- *			uniprocessor kernel, per-cpu for SMP kernel.
+ * struct thread_group_cputimer - thread group interval timer counts
+ * @cputime:		thread group interval timers.
+ * @running:		non-zero when there are timers running and
+ * 			@cputime receives updates.
+ * @lock:		lock for fields in this struct.
  *
  * This structure contains the version of task_cputime, above, that is
- * used for thread group CPU clock calculations.
+ * used for thread group CPU timer calculations.
  */
-struct thread_group_cputime {
-	struct task_cputime totals;
+struct thread_group_cputimer {
+	struct task_cputime cputime;
+	int running;
+	spinlock_t lock;
 };
 
 /*
@@ -519,10 +528,10 @@ struct signal_struct {
 	cputime_t it_prof_incr, it_virt_incr;
 
 	/*
-	 * Thread group totals for process CPU clocks.
-	 * See thread_group_cputime(), et al, for details.
+	 * Thread group totals for process CPU timers.
+	 * See thread_group_cputimer(), et al, for details.
 	 */
-	struct thread_group_cputime cputime;
+	struct thread_group_cputimer cputimer;
 
 	/* Earliest-expiration cache. */
 	struct task_cputime cputime_expires;
@@ -559,7 +568,7 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t cutime, cstime;
+	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
@@ -568,6 +577,14 @@ struct signal_struct {
 	struct task_io_accounting ioac;
 
 	/*
+	 * Cumulative ns of schedule CPU time fo dead threads in the
+	 * group, not including a zombie group leader, (This only differs
+	 * from jiffies_to_ns(utime + stime) if sched_clock uses something
+	 * other than jiffies.)
+	 */
+	unsigned long long sum_sched_runtime;
+
+	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
 	 * to get both rlim_cur and rlim_max atomically, and either one
@@ -2183,27 +2200,14 @@ static inline int spin_needbreak(spinlock_t *lock)
 /*
  * Thread group CPU time accounting.
  */
-
-static inline
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
-{
-	struct task_cputime *totals = &tsk->signal->cputime.totals;
-	unsigned long flags;
-
-	spin_lock_irqsave(&totals->lock, flags);
-	*times = *totals;
-	spin_unlock_irqrestore(&totals->lock, flags);
-}
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	sig->cputime.totals = (struct task_cputime){
-		.utime = cputime_zero,
-		.stime = cputime_zero,
-		.sum_exec_runtime = 0,
-	};
-
-	spin_lock_init(&sig->cputime.totals.lock);
+	sig->cputimer.cputime = INIT_CPUTIME;
+	spin_lock_init(&sig->cputimer.lock);
+	sig->cputimer.running = 0;
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
diff --git a/kernel/exit.c b/kernel/exit.c
index f80dec3..efd30cc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -118,6 +118,8 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
+		sig->utime = cputime_add(sig->utime, task_utime(tsk));
+		sig->stime = cputime_add(sig->stime, task_stime(tsk));
 		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
@@ -126,6 +128,7 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 242a706..e8e854a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -851,13 +851,14 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->tty_old_pgrp = NULL;
 	sig->tty = NULL;
 
-	sig->cutime = sig->cstime = cputime_zero;
+	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
 	sig->cgtime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
+	sig->sum_sched_runtime = 0;
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 6a5fe93..58762f7 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -62,7 +62,7 @@ int do_getitimer(int which, struct itimerval *value)
 			struct task_cputime cputime;
 			cputime_t utime;
 
-			thread_group_cputime(tsk, &cputime);
+			thread_group_cputimer(tsk, &cputime);
 			utime = cputime.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
@@ -82,7 +82,7 @@ int do_getitimer(int which, struct itimerval *value)
 			struct task_cputime times;
 			cputime_t ptime;
 
-			thread_group_cputime(tsk, &times);
+			thread_group_cputimer(tsk, &times);
 			ptime = cputime_add(times.utime, times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index fa07da9..2313a4c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -230,6 +230,71 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+{
+	struct sighand_struct *sighand;
+	struct signal_struct *sig;
+	struct task_struct *t;
+
+	*times = INIT_CPUTIME;
+
+	rcu_read_lock();
+	sighand = rcu_dereference(tsk->sighand);
+	if (!sighand)
+		goto out;
+
+	sig = tsk->signal;
+
+	t = tsk;
+	do {
+		times->utime = cputime_add(times->utime, t->utime);
+		times->stime = cputime_add(times->stime, t->stime);
+		times->sum_exec_runtime += t->se.sum_exec_runtime;
+
+		t = next_thread(t);
+	} while (t != tsk);
+
+	times->utime = cputime_add(times->utime, sig->utime);
+	times->stime = cputime_add(times->stime, sig->stime);
+	times->sum_exec_runtime += sig->sum_sched_runtime;
+out:
+	rcu_read_unlock();
+}
+
+static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
+{
+	if (cputime_gt(b->utime, a->utime))
+		a->utime = b->utime;
+
+	if (cputime_gt(b->stime, a->stime))
+		a->stime = b->stime;
+
+	if (b->sum_exec_runtime > a->sum_exec_runtime)
+		a->sum_exec_runtime = b->sum_exec_runtime;
+}
+
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+{
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct task_cputime sum;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cputimer->lock, flags);
+	if (!cputimer->running) {
+		cputimer->running = 1;
+		/*
+		 * The POSIX timer interface allows for absolute time expiry
+		 * values through the TIMER_ABSTIME flag, therefore we have
+		 * to synchronize the timer to the clock every time we start
+		 * it.
+		 */
+		thread_group_cputime(tsk, &sum);
+		update_gt_cputime(&cputimer->cputime, &sum);
+	}
+	*times = cputimer->cputime;
+	spin_unlock_irqrestore(&cputimer->lock, flags);
+}
+
 /*
  * Sample a process (thread group) clock for the given group_leader task.
  * Must be called with tasklist_lock held for reading.
@@ -457,7 +522,7 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(tsk, &cputime);
+	thread_group_cputimer(tsk, &cputime);
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
 }
@@ -964,6 +1029,19 @@ static void check_thread_timers(struct task_struct *tsk,
 	}
 }
 
+static void stop_process_timers(struct task_struct *tsk)
+{
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	unsigned long flags;
+
+	if (!cputimer->running)
+		return;
+
+	spin_lock_irqsave(&cputimer->lock, flags);
+	cputimer->running = 0;
+	spin_unlock_irqrestore(&cputimer->lock, flags);
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -987,13 +1065,15 @@ static void check_process_timers(struct task_struct *tsk,
 	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it_virt_expires, cputime_zero) &&
-	    list_empty(&timers[CPUCLOCK_SCHED]))
+	    list_empty(&timers[CPUCLOCK_SCHED])) {
+		stop_process_timers(tsk);
 		return;
+	}
 
 	/*
 	 * Collect the current process totals.
 	 */
-	thread_group_cputime(tsk, &cputime);
+	thread_group_cputimer(tsk, &cputime);
 	utime = cputime.utime;
 	ptime = cputime_add(utime, cputime.stime);
 	sum_sched_runtime = cputime.sum_exec_runtime;
@@ -1259,7 +1339,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	if (!task_cputime_zero(&sig->cputime_expires)) {
 		struct task_cputime group_sample;
 
-		thread_group_cputime(tsk, &group_sample);
+		thread_group_cputimer(tsk, &group_sample);
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
@@ -1329,6 +1409,33 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 }
 
 /*
+ * Sample a process (thread group) timer for the given group_leader task.
+ * Must be called with tasklist_lock held for reading.
+ */
+static int cpu_timer_sample_group(const clockid_t which_clock,
+				  struct task_struct *p,
+				  union cpu_time_count *cpu)
+{
+	struct task_cputime cputime;
+
+	thread_group_cputimer(p, &cputime);
+	switch (CPUCLOCK_WHICH(which_clock)) {
+	default:
+		return -EINVAL;
+	case CPUCLOCK_PROF:
+		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
+		break;
+	case CPUCLOCK_VIRT:
+		cpu->cpu = cputime.utime;
+		break;
+	case CPUCLOCK_SCHED:
+		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		break;
+	}
+	return 0;
+}
+
+/*
  * Set one of the process-wide special case CPU timers.
  * The tsk->sighand->siglock must be held by the caller.
  * The *newval argument is relative and we update it to be absolute, *oldval
@@ -1341,7 +1448,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
-	cpu_clock_sample_group(clock_idx, tsk, &now);
+	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
 		if (!cputime_eq(*oldval, cputime_zero)) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 242d0d4..e1fc67d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3890,19 +3890,24 @@ int select_nohz_load_balancer(int stop_tick)
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
-		/*
-		 * If we are going offline and still the leader, give up!
-		 */
-		if (!cpu_active(cpu) &&
-		    atomic_read(&nohz.load_balancer) == cpu) {
+		if (!cpu_active(cpu)) {
+			if (atomic_read(&nohz.load_balancer) != cpu)
+				return 0;
+
+			/*
+			 * If we are going offline and still the leader,
+			 * give up!
+			 */
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
+
 			return 0;
 		}
 
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
+
 		/* time for ilb owner also to sleep */
 		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 8ab0cef..a8f93dd 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -296,19 +296,21 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 static inline void account_group_user_time(struct task_struct *tsk,
 					   cputime_t cputime)
 {
-	struct task_cputime *times;
-	struct signal_struct *sig;
+	struct thread_group_cputimer *cputimer;
 
 	/* tsk == current, ensure it is safe to use ->signal */
 	if (unlikely(tsk->exit_state))
 		return;
 
-	sig = tsk->signal;
-	times = &sig->cputime.totals;
+	cputimer = &tsk->signal->cputimer;
 
-	spin_lock(&times->lock);
-	times->utime = cputime_add(times->utime, cputime);
-	spin_unlock(&times->lock);
+	if (!cputimer->running)
+		return;
+
+	spin_lock(&cputimer->lock);
+	cputimer->cputime.utime =
+		cputime_add(cputimer->cputime.utime, cputime);
+	spin_unlock(&cputimer->lock);
 }
 
 /**
@@ -324,19 +326,21 @@ static inline void account_group_user_time(struct task_struct *tsk,
 static inline void account_group_system_time(struct task_struct *tsk,
 					     cputime_t cputime)
 {
-	struct task_cputime *times;
-	struct signal_struct *sig;
+	struct thread_group_cputimer *cputimer;
 
 	/* tsk == current, ensure it is safe to use ->signal */
 	if (unlikely(tsk->exit_state))
 		return;
 
-	sig = tsk->signal;
-	times = &sig->cputime.totals;
+	cputimer = &tsk->signal->cputimer;
+
+	if (!cputimer->running)
+		return;
 
-	spin_lock(&times->lock);
-	times->stime = cputime_add(times->stime, cputime);
-	spin_unlock(&times->lock);
+	spin_lock(&cputimer->lock);
+	cputimer->cputime.stime =
+		cputime_add(cputimer->cputime.stime, cputime);
+	spin_unlock(&cputimer->lock);
 }
 
 /**
@@ -352,7 +356,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 static inline void account_group_exec_runtime(struct task_struct *tsk,
 					      unsigned long long ns)
 {
-	struct task_cputime *times;
+	struct thread_group_cputimer *cputimer;
 	struct signal_struct *sig;
 
 	sig = tsk->signal;
@@ -361,9 +365,12 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (unlikely(!sig))
 		return;
 
-	times = &sig->cputime.totals;
+	cputimer = &sig->cputimer;
+
+	if (!cputimer->running)
+		return;
 
-	spin_lock(&times->lock);
-	times->sum_exec_runtime += ns;
-	spin_unlock(&times->lock);
+	spin_lock(&cputimer->lock);
+	cputimer->cputime.sum_exec_runtime += ns;
+	spin_unlock(&cputimer->lock);
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index b6b3676..2a74fe8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1367,7 +1367,6 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
-	struct task_cputime cputime;
 	int ret = sig;
 
 	BUG_ON(sig == -1);
@@ -1397,9 +1396,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
-	thread_group_cputime(tsk, &cputime);
-	info.si_utime = cputime_to_jiffies(cputime.utime);
-	info.si_stime = cputime_to_jiffies(cputime.stime);
+	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
+				tsk->signal->utime));
+	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
+				tsk->signal->stime));
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
