Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZBELd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZBELd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbZBELd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:33:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:39245 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbZBELdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:33:23 -0500
Message-Id: <20090205113139.119115519@chello.nl>
References: <20090205112414.104100700@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 12:24:16 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       seto.hidetoshi@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] timers: split process wide cpu clocks/timers
Content-Disposition: inline; filename=thread_group_cputime.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the process wide cpu timers/clocks so that we:

 1) don't mess up the kernel with too many threads,
 2) don't have a per-cpu allocation for each process,
 3) have no impact when not used.

In order to accomplish this we're going to split it into two parts:

 - clocks; which can take all the time they want since they run
           from user context -- ie. sys_clock_gettime(CLOCK_PROCESS_CPUTIME_ID)

 - timers; which need constant time sampling but since they're
           explicity used, the user can pay the overhead.

The clock readout will go back to a full sum of the thread group, while the
timers will run of a global 'clock' that only runs when needed, so only
programs that make use of the facility pay the price.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/init_task.h |   11 ++---
 include/linux/sched.h     |   54 +++++++++++++++-----------
 kernel/itimer.c           |    4 -
 kernel/posix-cpu-timers.c |   95 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_stats.h      |   45 ++++++++++++---------
 5 files changed, 155 insertions(+), 54 deletions(-)

Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
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
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -451,7 +451,6 @@ struct pacct_struct {
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
  * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
- * @lock:		lock for fields in this struct
  *
  * This structure groups together three kinds of CPU time that are
  * tracked for threads and thread groups.  Most things considering
@@ -462,23 +461,33 @@ struct task_cputime {
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
@@ -527,10 +536,10 @@ struct signal_struct {
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
@@ -2218,27 +2227,26 @@ static inline int spin_needbreak(spinloc
 /*
  * Thread group CPU time accounting.
  */
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
 
 static inline
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 {
-	struct task_cputime *totals = &tsk->signal->cputime.totals;
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 	unsigned long flags;
 
-	spin_lock_irqsave(&totals->lock, flags);
-	*times = *totals;
-	spin_unlock_irqrestore(&totals->lock, flags);
+	WARN_ON(!cputimer->running);
+
+	spin_lock_irqsave(&cputimer->lock, flags);
+	*times = cputimer->cputime;
+	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
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
Index: linux-2.6/kernel/itimer.c
===================================================================
--- linux-2.6.orig/kernel/itimer.c
+++ linux-2.6/kernel/itimer.c
@@ -62,7 +62,7 @@ int do_getitimer(int which, struct itime
 			struct task_cputime cputime;
 			cputime_t utime;
 
-			thread_group_cputime(tsk, &cputime);
+			thread_group_cputimer(tsk, &cputime);
 			utime = cputime.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
@@ -82,7 +82,7 @@ int do_getitimer(int which, struct itime
 			struct task_cputime times;
 			cputime_t ptime;
 
-			thread_group_cputime(tsk, &times);
+			thread_group_cputimer(tsk, &times);
 			ptime = cputime_add(times.utime, times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -230,6 +230,37 @@ static int cpu_clock_sample(const clocki
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
 /*
  * Sample a process (thread group) clock for the given group_leader task.
  * Must be called with tasklist_lock held for reading.
@@ -476,6 +507,29 @@ static void clear_dead_task(struct k_iti
 }
 
 /*
+ * Enable the process wide cpu timer accounting.
+ *
+ * serialized using ->sighand->siglock
+ */
+static void start_process_timers(struct task_struct *tsk)
+{
+	tsk->signal->cputimer.running = 1;
+	barrier();
+}
+
+/*
+ * Release the process wide timer accounting -- timer stops ticking when
+ * nobody cares about it.
+ *
+ * serialized using ->sighand->siglock
+ */
+static void stop_process_timers(struct task_struct *tsk)
+{
+	tsk->signal->cputimer.running = 0;
+	barrier();
+}
+
+/*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
  * for reading, and interrupts disabled.
@@ -495,6 +549,9 @@ static void arm_timer(struct k_itimer *t
 	BUG_ON(!irqs_disabled());
 	spin_lock(&p->sighand->siglock);
 
+	if (!CPUCLOCK_PERTHREAD(timer->it_clock))
+		start_process_timers(p);
+
 	listpos = head;
 	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
 		list_for_each_entry(next, head, entry) {
@@ -987,13 +1044,15 @@ static void check_process_timers(struct 
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
@@ -1259,7 +1318,7 @@ static inline int fastpath_timer_check(s
 	if (!task_cputime_zero(&sig->cputime_expires)) {
 		struct task_cputime group_sample;
 
-		thread_group_cputime(tsk, &group_sample);
+		thread_group_cputimer(tsk, &group_sample);
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
@@ -1329,6 +1388,33 @@ void run_posix_cpu_timers(struct task_st
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
@@ -1341,7 +1427,8 @@ void set_process_cpu_timer(struct task_s
 	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
-	cpu_clock_sample_group(clock_idx, tsk, &now);
+	start_process_timers(tsk);
+	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
 		if (!cputime_eq(*oldval, cputime_zero)) {
Index: linux-2.6/kernel/sched_stats.h
===================================================================
--- linux-2.6.orig/kernel/sched_stats.h
+++ linux-2.6/kernel/sched_stats.h
@@ -296,19 +296,21 @@ sched_info_switch(struct task_struct *pr
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
@@ -324,19 +326,21 @@ static inline void account_group_user_ti
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
@@ -352,7 +356,7 @@ static inline void account_group_system_
 static inline void account_group_exec_runtime(struct task_struct *tsk,
 					      unsigned long long ns)
 {
-	struct task_cputime *times;
+	struct thread_group_cputimer *cputimer;
 	struct signal_struct *sig;
 
 	sig = tsk->signal;
@@ -361,9 +365,12 @@ static inline void account_group_exec_ru
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

-- 

