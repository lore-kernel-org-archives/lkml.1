Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYIXVYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYIXVYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYIXVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:24:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYIXVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:24:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-gmailtapped-by;
	b=hmXqlab7Dl7ACLIUrJfAmh2dmqr9Aky0ooI4zbvR9dszajZnoReWDDkBb4zE28sl2
	u2Vd/C/ME/z5ENasofMaQ==
Subject: [PATCH 2.6.27-rc5 incremental re-resubmit] Fix itimer/many thread
	hang.
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1222114936.21579.20.camel@bobble.smo.corp.google.com>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080918102353.GD20967@elte.hu>
	 <1222114936.21579.20.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 24 Sep 2008 14:23:36 -0700
Message-Id: <1222291416.30299.6.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of days ago I re-resubmitted the itimer/many thread hang.
Unfortunately, I had too many things going on at once and screwed it up,
not verifying the UP version and entirely missing a set of cleanups that
I had intended to include.  This rectifies that screwup.

At Ingo's request, this is an incremental patch, relative to the code in
his -tip tree.

These changes have been minimally tested on both UP and SMP
environments.  They simplify the UP code, consolidating pretty much all
of it with the SMP version and depending on lower-level SMP/UP handling
to take care of the differences.  It also cleans up some UP compile
errors, moves the scheduler stats-related macros into
kernel/sched_stats.h, cleans up a merge error in kernel/fork.c and has a
few other minor fixes and cleanups as suggested by Oleg and Ingo.
Again, thanks for the reviews, guys.

I'm dropping the original README; if you want it it's in the archives at
least three times.

Signed-off-by: Frank Mayhar <fmayhar@google.com>

 include/linux/kernel_stat.h |    1 +
 include/linux/sched.h       |  182 +------------------------------------------
 kernel/fork.c               |    5 +-
 kernel/posix-cpu-timers.c   |  155 +++++++++++++++---------------------
 kernel/sched.c              |   46 ++----------
 kernel/sched_stats.h        |   86 ++++++++++++++++++++
 6 files changed, 163 insertions(+), 312 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 21249d8..a97caac 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -70,6 +70,7 @@ static inline unsigned int kstat_irqs(unsigned int irq)
 	return sum;
 }
 
+extern unsigned long long task_delta_exec(struct task_struct *);
 extern void account_user_time(struct task_struct *, cputime_t);
 extern void account_user_time_scaled(struct task_struct *, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b7375af..a65ddb3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -454,15 +454,9 @@ struct task_cputime {
  * This structure contains the version of task_cputime, above, that is
  * used for thread group CPU clock calculations.
  */
-#ifdef CONFIG_SMP
 struct thread_group_cputime {
 	struct task_cputime *totals;
 };
-#else
-struct thread_group_cputime {
-	struct task_cputime totals;
-};
-#endif
 
 /*
  * NOTE! "signal_struct" does not have it's own
@@ -2142,22 +2136,20 @@ static inline int spin_needbreak(spinlock_t *lock)
 /*
  * Thread group CPU time accounting.
  */
-#ifdef CONFIG_SMP
 
-extern int thread_group_cputime_alloc_smp(struct task_struct *);
-extern void thread_group_cputime_smp(struct task_struct *, struct task_cputime *);
+extern int thread_group_cputime_alloc(struct task_struct *);
+extern void thread_group_cputime(struct task_struct *, struct task_cputime *);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
 	sig->cputime.totals = NULL;
 }
 
-static inline int thread_group_cputime_clone_thread(struct task_struct *curr,
-						    struct task_struct *new)
+static inline int thread_group_cputime_clone_thread(struct task_struct *curr)
 {
 	if (curr->signal->cputime.totals)
 		return 0;
-	return thread_group_cputime_alloc_smp(curr);
+	return thread_group_cputime_alloc(curr);
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
@@ -2165,172 +2157,6 @@ static inline void thread_group_cputime_free(struct signal_struct *sig)
 	free_percpu(sig->cputime.totals);
 }
 
-/**
- * thread_group_cputime - Sum the thread group time fields across all CPUs.
- *
- * This is a wrapper for the real routine, thread_group_cputime_smp().  See
- * that routine for details.
- */
-static inline void thread_group_cputime(
-	struct task_struct *tsk,
-	struct task_cputime *times)
-{
-	thread_group_cputime_smp(tsk, times);
-}
-
-/**
- * thread_group_cputime_account_user - Maintain utime for a thread group.
- *
- * @tgtimes:	Pointer to thread_group_cputime structure.
- * @cputime:	Time value by which to increment the utime field of that
- *		structure.
- *
- * If thread group time is being maintained, get the structure for the
- * running CPU and update the utime field there.
- */
-static inline void thread_group_cputime_account_user(
-	struct thread_group_cputime *tgtimes,
-	cputime_t cputime)
-{
-	if (tgtimes->totals) {
-		struct task_cputime *times;
-
-		times = per_cpu_ptr(tgtimes->totals, get_cpu());
-		times->utime = cputime_add(times->utime, cputime);
-		put_cpu_no_resched();
-	}
-}
-
-/**
- * thread_group_cputime_account_system - Maintain stime for a thread group.
- *
- * @tgtimes:	Pointer to thread_group_cputime structure.
- * @cputime:	Time value by which to increment the stime field of that
- *		structure.
- *
- * If thread group time is being maintained, get the structure for the
- * running CPU and update the stime field there.
- */
-static inline void thread_group_cputime_account_system(
-	struct thread_group_cputime *tgtimes,
-	cputime_t cputime)
-{
-	if (tgtimes->totals) {
-		struct task_cputime *times;
-
-		times = per_cpu_ptr(tgtimes->totals, get_cpu());
-		times->stime = cputime_add(times->stime, cputime);
-		put_cpu_no_resched();
-	}
-}
-
-/**
- * thread_group_cputime_account_exec_runtime - Maintain exec runtime for a
- *						thread group.
- *
- * @tgtimes:	Pointer to thread_group_cputime structure.
- * @ns:		Time value by which to increment the sum_exec_runtime field
- *		of that structure.
- *
- * If thread group time is being maintained, get the structure for the
- * running CPU and update the sum_exec_runtime field there.
- */
-static inline void thread_group_cputime_account_exec_runtime(
-	struct thread_group_cputime *tgtimes,
-	unsigned long long ns)
-{
-	if (tgtimes->totals) {
-		struct task_cputime *times;
-
-		times = per_cpu_ptr(tgtimes->totals, get_cpu());
-		times->sum_exec_runtime += ns;
-		put_cpu_no_resched();
-	}
-}
-
-#else /* CONFIG_SMP */
-
-static inline void thread_group_cputime_init(struct signal_struct *sig)
-{
-	sig->cputime.totals.utime = cputime_zero;
-	sig->cputime.totals.stime = cputime_zero;
-	sig->cputime.totals.sum_exec_runtime = 0;
-}
-
-static inline int thread_group_cputime_alloc(struct task_struct *tsk)
-{
-	return 0;
-}
-
-static inline void thread_group_cputime_free(struct signal_struct *sig)
-{
-}
-
-static inline int thread_group_cputime_clone_thread(struct task_struct *curr,
-						     struct task_struct *tsk)
-{
-	return 0;
-}
-
-static inline void thread_group_cputime(struct task_struct *tsk,
-					 struct task_cputime *cputime)
-{
-	*cputime = tsk->signal->cputime.totals;
-}
-
-static inline void thread_group_cputime_account_user(
-	struct thread_group_cputime *tgtimes,
-	cputime_t cputime)
-{
-	tgtimes->totals.utime = cputime_add(tgtimes->totals.utime, cputime);
-}
-
-static inline void thread_group_cputime_account_system(
-	struct thread_group_cputime *tgtimes,
-	cputime_t cputime)
-{
-	tgtimes->totals.stime = cputime_add(tgtimes->totals.stime, cputime);
-}
-
-static inline void thread_group_cputime_account_exec_runtime(
-	struct thread_group_cputime *tgtimes,
-	unsigned long long ns)
-{
-	tgtimes->totals.sum_exec_runtime += ns;
-}
-
-#endif /* CONFIG_SMP */
-
-static inline void account_group_user_time(struct task_struct *tsk,
-					    cputime_t cputime)
-{
-	struct signal_struct *sig;
-
-	sig = tsk->signal;
-	if (likely(sig))
-		thread_group_cputime_account_user(&sig->cputime, cputime);
-}
-
-static inline void account_group_system_time(struct task_struct *tsk,
-					      cputime_t cputime)
-{
-	struct signal_struct *sig;
-
-	sig = tsk->signal;
-	if (likely(sig))
-		thread_group_cputime_account_system(&sig->cputime, cputime);
-}
-
-static inline void account_group_exec_runtime(struct task_struct *tsk,
-					       unsigned long long ns)
-{
-	struct signal_struct *sig;
-
-	sig = tsk->signal;
-	if (likely(sig))
-		thread_group_cputime_account_exec_runtime(&sig->cputime, ns);
-}
-
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff --git a/kernel/fork.c b/kernel/fork.c
index 5c1fc7a..06db4d0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -797,7 +797,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
-		ret = thread_group_cputime_clone_thread(current, tsk);
+		ret = thread_group_cputime_clone_thread(current);
 		if (likely(!ret)) {
 			atomic_inc(&current->signal->count);
 			atomic_inc(&current->signal->live);
@@ -840,9 +840,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
-	INIT_LIST_HEAD(&sig->cpu_timers[0]);
-	INIT_LIST_HEAD(&sig->cpu_timers[1]);
-	INIT_LIST_HEAD(&sig->cpu_timers[2]);
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 9a7ea04..153dcb2 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -7,50 +7,46 @@
 #include <linux/errno.h>
 #include <linux/math64.h>
 #include <asm/uaccess.h>
+#include <linux/kernel_stat.h>
 
-#ifdef CONFIG_SMP
 /*
- * Allocate the thread_group_cputime structure appropriately for SMP kernels
- * and fill in the current values of the fields.  Called from copy_signal()
- * via thread_group_cputime_clone_thread() when adding a second or subsequent
+ * Allocate the thread_group_cputime structure appropriately and fill in the
+ * current values of the fields.  Called from copy_signal() via
+ * thread_group_cputime_clone_thread() when adding a second or subsequent
  * thread to a thread group.  Assumes interrupts are enabled when called.
  */
-int thread_group_cputime_alloc_smp(struct task_struct *tsk)
+int thread_group_cputime_alloc(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
 	struct task_cputime *cputime;
 
 	/*
 	 * If we have multiple threads and we don't already have a
-	 * per-CPU task_cputime struct, allocate one and fill it in with
-	 * the times accumulated so far.
+	 * per-CPU task_cputime struct (checked in the caller), allocate
+	 * one and fill it in with the times accumulated so far.  We may
+	 * race with another thread so recheck after we pick up the sighand
+	 * lock.
 	 */
-	if (sig->cputime.totals)
-		return 0;
 	cputime = alloc_percpu(struct task_cputime);
 	if (cputime == NULL)
 		return -ENOMEM;
-	read_lock(&tasklist_lock);
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (sig->cputime.totals) {
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 		free_percpu(cputime);
 		return 0;
 	}
 	sig->cputime.totals = cputime;
-	cputime = per_cpu_ptr(sig->cputime.totals, get_cpu());
+	cputime = per_cpu_ptr(sig->cputime.totals, smp_processor_id());
 	cputime->utime = tsk->utime;
 	cputime->stime = tsk->stime;
 	cputime->sum_exec_runtime = tsk->se.sum_exec_runtime;
-	put_cpu_no_resched();
 	spin_unlock_irq(&tsk->sighand->siglock);
-	read_unlock(&tasklist_lock);
 	return 0;
 }
 
 /**
- * thread_group_cputime_smp - Sum the thread group time fields across all CPUs.
+ * thread_group_cputime - Sum the thread group time fields across all CPUs.
  *
  * @tsk:	The task we use to identify the thread group.
  * @times:	task_cputime structure in which we return the summed fields.
@@ -58,7 +54,7 @@ int thread_group_cputime_alloc_smp(struct task_struct *tsk)
  * Walk the list of CPUs to sum the per-CPU time fields in the thread group
  * time structure.
  */
-void thread_group_cputime_smp(
+void thread_group_cputime(
 	struct task_struct *tsk,
 	struct task_cputime *times)
 {
@@ -83,8 +79,6 @@ void thread_group_cputime_smp(
 	}
 }
 
-#endif /* CONFIG_SMP */
-
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
@@ -300,7 +294,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p);
+		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
 	return 0;
@@ -309,16 +303,15 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 /*
  * Sample a process (thread group) clock for the given group_leader task.
  * Must be called with tasklist_lock held for reading.
- * Must be called with tasklist_lock held for reading, and p->sighand->siglock.
  */
-static int cpu_clock_sample_group_locked(unsigned int clock_idx,
-					 struct task_struct *p,
-					 union cpu_time_count *cpu)
+static int cpu_clock_sample_group(const clockid_t which_clock,
+				  struct task_struct *p,
+				  union cpu_time_count *cpu)
 {
 	struct task_cputime cputime;
 
 	thread_group_cputime(p, &cputime);
-	switch (clock_idx) {
+	switch (which_clock) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
@@ -328,29 +321,12 @@ static int cpu_clock_sample_group_locked(unsigned int clock_idx,
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = thread_group_sched_runtime(p);
+		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
 	return 0;
 }
 
-/*
- * Sample a process (thread group) clock for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
- */
-static int cpu_clock_sample_group(const clockid_t which_clock,
-				  struct task_struct *p,
-				  union cpu_time_count *cpu)
-{
-	int ret;
-	unsigned long flags;
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	ret = cpu_clock_sample_group_locked(CPUCLOCK_WHICH(which_clock), p,
-					    cpu);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	return ret;
-}
-
 
 int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
@@ -1324,29 +1300,37 @@ static inline int task_cputime_expired(const struct task_cputime *sample,
  * fastpath_timer_check - POSIX CPU timers fast path.
  *
  * @tsk:	The task (thread) being checked.
- * @sig:	The signal pointer for that task.
  *
- * If there are no timers set return false.  Otherwise snapshot the task and
- * thread group timers, then compare them with the corresponding expiration
- # times.  Returns true if a timer has expired, else returns false.
+ * Check the task and thread group timers.  If both are zero (there are no
+ * timers set) return false.  Otherwise snapshot the task and thread group
+ * timers and compare them with the corresponding expiration times.  Return
+ * true if a timer has expired, else return false.
  */
-static inline int fastpath_timer_check(struct task_struct *tsk,
-					struct signal_struct *sig)
+static inline int fastpath_timer_check(struct task_struct *tsk)
 {
-	struct task_cputime task_sample = {
-		.utime = tsk->utime,
-		.stime = tsk->stime,
-		.sum_exec_runtime = tsk->se.sum_exec_runtime
-	};
-	struct task_cputime group_sample;
+	struct signal_struct *sig = tsk->signal;
 
-	if (task_cputime_zero(&tsk->cputime_expires) &&
-	    task_cputime_zero(&sig->cputime_expires))
+	if (unlikely(!sig))
 		return 0;
-	if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
-		return 1;
-	thread_group_cputime(tsk, &group_sample);
-	return task_cputime_expired(&group_sample, &sig->cputime_expires);
+
+	if (!task_cputime_zero(&tsk->cputime_expires)) {
+		struct task_cputime task_sample = {
+			.utime = tsk->utime,
+			.stime = tsk->stime,
+			.sum_exec_runtime = tsk->se.sum_exec_runtime
+		};
+
+		if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
+			return 1;
+	}
+	if (!task_cputime_zero(&sig->cputime_expires)) {
+		struct task_cputime group_sample;
+
+		thread_group_cputime(tsk, &group_sample);
+		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
+			return 1;
+	}
+	return 0;
 }
 
 /*
@@ -1358,43 +1342,34 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
-	struct signal_struct *sig;
-	struct sighand_struct *sighand;
-	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
 
-	/* Pick up tsk->signal and make sure it's valid. */
-	sig = tsk->signal;
 	/*
 	 * The fast path checks that there are no expired thread or thread
-	 * group timers.  If that's so, just return.  Also check that
-	 * tsk->signal is non-NULL; this probably can't happen but cover the
-	 * possibility anyway.
+	 * group timers.  If that's so, just return.
 	 */
-	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig))
+	if (!fastpath_timer_check(tsk))
 		return;
 
-	sighand = lock_task_sighand(tsk, &flags);
-	if (likely(sighand)) {
-		/*
-		 * Here we take off tsk->signal->cpu_timers[N] and
-		 * tsk->cpu_timers[N] all the timers that are firing, and
-		 * put them on the firing list.
-		 */
-		check_thread_timers(tsk, &firing);
-		check_process_timers(tsk, &firing);
+	spin_lock(&tsk->sighand->siglock);
+	/*
+	 * Here we take off tsk->signal->cpu_timers[N] and
+	 * tsk->cpu_timers[N] all the timers that are firing, and
+	 * put them on the firing list.
+	 */
+	check_thread_timers(tsk, &firing);
+	check_process_timers(tsk, &firing);
 
-		/*
-		 * We must release these locks before taking any timer's lock.
-		 * There is a potential race with timer deletion here, as the
-		 * siglock now protects our private firing list.  We have set
-		 * the firing flag in each timer, so that a deletion attempt
-		 * that gets the timer lock before we do will give it up and
-		 * spin until we've taken care of that timer below.
-		 */
-	}
-	unlock_task_sighand(tsk, &flags);
+	/*
+	 * We must release these locks before taking any timer's lock.
+	 * There is a potential race with timer deletion here, as the
+	 * siglock now protects our private firing list.  We have set
+	 * the firing flag in each timer, so that a deletion attempt
+	 * that gets the timer lock before we do will give it up and
+	 * spin until we've taken care of that timer below.
+	 */
+	spin_unlock(&tsk->sighand->siglock);
 
 	/*
 	 * Now that all the timers on our list have the firing flag,
@@ -1433,7 +1408,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
-	cpu_clock_sample_group_locked(clock_idx, tsk, &now);
+	cpu_clock_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
 		if (!cputime_eq(*oldval, cputime_zero)) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 746c086..30b73fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4048,55 +4048,21 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 /*
  * Return any ns on the sched_clock that have not yet been banked in
  * @p in case that task is currently running.
- *
- * Called with task_rq_lock() held on @rq.
  */
-static unsigned long long task_delta_exec(struct task_struct *p, struct rq *rq)
+unsigned long long task_delta_exec(struct task_struct *p)
 {
+	struct rq *rq;
+	unsigned long flags;
+	u64 ns = 0;
+
 	if (task_current(rq, p)) {
 		u64 delta_exec;
 
 		update_rq_clock(rq);
 		delta_exec = rq->clock - p->se.exec_start;
 		if ((s64)delta_exec > 0)
-			return delta_exec;
+			ns = delta_exec;
 	}
-	return 0;
-}
-
-/*
- * Return p->sum_exec_runtime plus any more ns on the sched_clock
- * that have not yet been banked in case the task is currently running.
- */
-unsigned long long task_sched_runtime(struct task_struct *p)
-{
-	unsigned long flags;
-	u64 ns;
-	struct rq *rq;
-
-	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
-
-	return ns;
-}
-
-/*
- * Return sum_exec_runtime for the thread group plus any more ns on the
- * sched_clock that have not yet been banked in case the task is currently
- * running.
- */
-unsigned long long thread_group_sched_runtime(struct task_struct *p)
-{
-	unsigned long flags;
-	u64 ns;
-	struct rq *rq;
-	struct task_cputime totals;
-
-	rq = task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
-	ns = totals.sum_exec_runtime + task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
 
 	return ns;
 }
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 8385d43..b8c1569 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -270,3 +270,89 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 #define sched_info_switch(t, next)		do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
 
+/*
+ * The following are functions that support scheduler-internal time accounting.
+ * These functions are generally called at the timer tick.  None of this depends
+ * on CONFIG_SCHEDSTATS.
+ */
+
+/**
+ * account_group_user_time - Maintain utime for a thread group.
+ *
+ * @tsk:	Pointer to task structure.
+ * @cputime:	Time value by which to increment the utime field of the
+ *		thread_group_cputime structure.
+ *
+ * If thread group time is being maintained, get the structure for the
+ * running CPU and update the utime field there.
+ */
+static inline void account_group_user_time(struct task_struct *tsk,
+					   cputime_t cputime)
+{
+	struct signal_struct *sig;
+
+	sig = tsk->signal;
+	if (unlikely(!sig))
+		return;
+	if (sig->cputime.totals) {
+		struct task_cputime *times;
+
+		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
+		times->utime = cputime_add(times->utime, cputime);
+		put_cpu_no_resched();
+	}
+}
+
+/**
+ * account_group_system_time - Maintain stime for a thread group.
+ *
+ * @tsk:	Pointer to task structure.
+ * @cputime:	Time value by which to increment the stime field of the
+ *		thread_group_cputime structure.
+ *
+ * If thread group time is being maintained, get the structure for the
+ * running CPU and update the stime field there.
+ */
+static inline void account_group_system_time(struct task_struct *tsk,
+					     cputime_t cputime)
+{
+	struct signal_struct *sig;
+
+	sig = tsk->signal;
+	if (unlikely(!sig))
+		return;
+	if (sig->cputime.totals) {
+		struct task_cputime *times;
+
+		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
+		times->stime = cputime_add(times->stime, cputime);
+		put_cpu_no_resched();
+	}
+}
+
+/**
+ * account_group_exec_runtime - Maintain exec runtime for a thread group.
+ *
+ * @tsk:	Pointer to task structure.
+ * @ns:		Time value by which to increment the sum_exec_runtime field
+ *		of the thread_group_cputime structure.
+ *
+ * If thread group time is being maintained, get the structure for the
+ * running CPU and update the sum_exec_runtime field there.
+ */
+static inline void account_group_exec_runtime(struct task_struct *tsk,
+					      unsigned long long ns)
+{
+	struct signal_struct *sig;
+
+	sig = tsk->signal;
+	if (unlikely(!sig))
+		return;
+	if (sig->cputime.totals) {
+		struct task_cputime *times;
+
+		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
+		times->sum_exec_runtime += ns;
+		put_cpu_no_resched();
+	}
+}

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

