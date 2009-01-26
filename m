Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZAZRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZAZRWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZAZRWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:22:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZAZRWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:22:04 -0500
Date: Mon, 26 Jan 2009 18:21:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] timer fixes
Message-ID: <20090126172149.GA3321@elte.hu>
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jaswinder Singh Rajput (1):
      time-sched.c: tick_nohz_update_jiffies should be static

Peter Zijlstra (3):
      itimers: remove the per-cpu-ish-ness
      locking, hpet: annotate false positive warning
      hrtimers: fix inconsistent lock state on resume in hres_timers_resume

Steven Noonan (1):
      kernel/fork.c: unused variable 'ret'


 arch/x86/kernel/hpet.c    |    2 +-
 include/linux/init_task.h |    6 ++++
 include/linux/sched.h     |   29 +++++++++++-------
 include/linux/workqueue.h |    6 ++++
 kernel/fork.c             |   16 ++++------
 kernel/hrtimer.c          |    4 ++-
 kernel/posix-cpu-timers.c |   70 ---------------------------------------------
 kernel/sched_stats.h      |   33 +++++++++-----------
 kernel/time/tick-sched.c  |    2 +-
 9 files changed, 57 insertions(+), 111 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index cd759ad..bb2e0f0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -628,7 +628,7 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK(&work.work, hpet_work);
+		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
 		init_completion(&work.complete);
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 2f3c2d4..ea0ea1a 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -48,6 +48,12 @@ extern struct fs_struct init_fs;
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
+	.cputime	= { .totals = {					\
+		.utime = cputime_zero,					\
+		.stime = cputime_zero,					\
+		.sum_exec_runtime = 0,					\
+		.lock = __SPIN_LOCK_UNLOCKED(sig.cputime.totals.lock),	\
+	}, },								\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cae9b8..c20943e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -450,6 +450,7 @@ struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
 	unsigned long long sum_exec_runtime;
+	spinlock_t lock;
 };
 /* Alternate field names when used to cache expirations. */
 #define prof_exp	stime
@@ -465,7 +466,7 @@ struct task_cputime {
  * used for thread group CPU clock calculations.
  */
 struct thread_group_cputime {
-	struct task_cputime *totals;
+	struct task_cputime totals;
 };
 
 /*
@@ -2180,24 +2181,30 @@ static inline int spin_needbreak(spinlock_t *lock)
  * Thread group CPU time accounting.
  */
 
-extern int thread_group_cputime_alloc(struct task_struct *);
-extern void thread_group_cputime(struct task_struct *, struct task_cputime *);
-
-static inline void thread_group_cputime_init(struct signal_struct *sig)
+static inline
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
-	sig->cputime.totals = NULL;
+	struct task_cputime *totals = &tsk->signal->cputime.totals;
+	unsigned long flags;
+
+	spin_lock_irqsave(&totals->lock, flags);
+	*times = *totals;
+	spin_unlock_irqrestore(&totals->lock, flags);
 }
 
-static inline int thread_group_cputime_clone_thread(struct task_struct *curr)
+static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	if (curr->signal->cputime.totals)
-		return 0;
-	return thread_group_cputime_alloc(curr);
+	sig->cputime.totals = (struct task_cputime){
+		.utime = cputime_zero,
+		.stime = cputime_zero,
+		.sum_exec_runtime = 0,
+	};
+
+	spin_lock_init(&sig->cputime.totals.lock);
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
 {
-	free_percpu(sig->cputime.totals);
 }
 
 /*
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b362911..47151c8 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -118,6 +118,12 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
+#define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
+	do {							\
+		INIT_WORK(&(_work)->work, (_func));		\
+		init_timer_on_stack(&(_work)->timer);		\
+	} while (0)
+
 #define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
 	do {							\
 		INIT_WORK(&(_work)->work, (_func));		\
diff --git a/kernel/fork.c b/kernel/fork.c
index 1d68f12..81da4aa 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -817,17 +817,17 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
-	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
-		ret = thread_group_cputime_clone_thread(current);
-		if (likely(!ret)) {
-			atomic_inc(&current->signal->count);
-			atomic_inc(&current->signal->live);
-		}
-		return ret;
+		atomic_inc(&current->signal->count);
+		atomic_inc(&current->signal->live);
+		return 0;
 	}
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
+
+	if (sig)
+		posix_cpu_timers_init_group(sig);
+
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -864,8 +864,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
-	posix_cpu_timers_init_group(sig);
-
 	acct_init_pacct(&sig->pacct);
 
 	tty_audit_fork(sig);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1455b76..cb83c6d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -614,7 +614,9 @@ void clock_was_set(void)
  */
 void hres_timers_resume(void)
 {
-	/* Retrigger the CPU local events: */
+	WARN_ONCE(!irqs_disabled(),
+		  KERN_INFO "hres_timers_resume() called with IRQs enabled!");
+
 	retrigger_next_event(NULL);
 }
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 157de3a..fa07da9 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -10,76 +10,6 @@
 #include <linux/kernel_stat.h>
 
 /*
- * Allocate the thread_group_cputime structure appropriately and fill in the
- * current values of the fields.  Called from copy_signal() via
- * thread_group_cputime_clone_thread() when adding a second or subsequent
- * thread to a thread group.  Assumes interrupts are enabled when called.
- */
-int thread_group_cputime_alloc(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-	struct task_cputime *cputime;
-
-	/*
-	 * If we have multiple threads and we don't already have a
-	 * per-CPU task_cputime struct (checked in the caller), allocate
-	 * one and fill it in with the times accumulated so far.  We may
-	 * race with another thread so recheck after we pick up the sighand
-	 * lock.
-	 */
-	cputime = alloc_percpu(struct task_cputime);
-	if (cputime == NULL)
-		return -ENOMEM;
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (sig->cputime.totals) {
-		spin_unlock_irq(&tsk->sighand->siglock);
-		free_percpu(cputime);
-		return 0;
-	}
-	sig->cputime.totals = cputime;
-	cputime = per_cpu_ptr(sig->cputime.totals, smp_processor_id());
-	cputime->utime = tsk->utime;
-	cputime->stime = tsk->stime;
-	cputime->sum_exec_runtime = tsk->se.sum_exec_runtime;
-	spin_unlock_irq(&tsk->sighand->siglock);
-	return 0;
-}
-
-/**
- * thread_group_cputime - Sum the thread group time fields across all CPUs.
- *
- * @tsk:	The task we use to identify the thread group.
- * @times:	task_cputime structure in which we return the summed fields.
- *
- * Walk the list of CPUs to sum the per-CPU time fields in the thread group
- * time structure.
- */
-void thread_group_cputime(
-	struct task_struct *tsk,
-	struct task_cputime *times)
-{
-	struct task_cputime *totals, *tot;
-	int i;
-
-	totals = tsk->signal->cputime.totals;
-	if (!totals) {
-		times->utime = tsk->utime;
-		times->stime = tsk->stime;
-		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
-		return;
-	}
-
-	times->stime = times->utime = cputime_zero;
-	times->sum_exec_runtime = 0;
-	for_each_possible_cpu(i) {
-		tot = per_cpu_ptr(totals, i);
-		times->utime = cputime_add(times->utime, tot->utime);
-		times->stime = cputime_add(times->stime, tot->stime);
-		times->sum_exec_runtime += tot->sum_exec_runtime;
-	}
-}
-
-/*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
 void update_rlimit_cpu(unsigned long rlim_new)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index f2773b5..8ab0cef 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -296,6 +296,7 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 static inline void account_group_user_time(struct task_struct *tsk,
 					   cputime_t cputime)
 {
+	struct task_cputime *times;
 	struct signal_struct *sig;
 
 	/* tsk == current, ensure it is safe to use ->signal */
@@ -303,13 +304,11 @@ static inline void account_group_user_time(struct task_struct *tsk,
 		return;
 
 	sig = tsk->signal;
-	if (sig->cputime.totals) {
-		struct task_cputime *times;
+	times = &sig->cputime.totals;
 
-		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
-		times->utime = cputime_add(times->utime, cputime);
-		put_cpu_no_resched();
-	}
+	spin_lock(&times->lock);
+	times->utime = cputime_add(times->utime, cputime);
+	spin_unlock(&times->lock);
 }
 
 /**
@@ -325,6 +324,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 static inline void account_group_system_time(struct task_struct *tsk,
 					     cputime_t cputime)
 {
+	struct task_cputime *times;
 	struct signal_struct *sig;
 
 	/* tsk == current, ensure it is safe to use ->signal */
@@ -332,13 +332,11 @@ static inline void account_group_system_time(struct task_struct *tsk,
 		return;
 
 	sig = tsk->signal;
-	if (sig->cputime.totals) {
-		struct task_cputime *times;
+	times = &sig->cputime.totals;
 
-		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
-		times->stime = cputime_add(times->stime, cputime);
-		put_cpu_no_resched();
-	}
+	spin_lock(&times->lock);
+	times->stime = cputime_add(times->stime, cputime);
+	spin_unlock(&times->lock);
 }
 
 /**
@@ -354,6 +352,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 static inline void account_group_exec_runtime(struct task_struct *tsk,
 					      unsigned long long ns)
 {
+	struct task_cputime *times;
 	struct signal_struct *sig;
 
 	sig = tsk->signal;
@@ -362,11 +361,9 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (unlikely(!sig))
 		return;
 
-	if (sig->cputime.totals) {
-		struct task_cputime *times;
+	times = &sig->cputime.totals;
 
-		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
-		times->sum_exec_runtime += ns;
-		put_cpu_no_resched();
-	}
+	spin_lock(&times->lock);
+	times->sum_exec_runtime += ns;
+	spin_unlock(&times->lock);
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1b6c05b..d3f1ef4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -134,7 +134,7 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
