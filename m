Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbXDQG2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbXDQG2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXDQG2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:28:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXDQG2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:28:10 -0400
Date: Tue, 17 Apr 2007 08:27:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417062735.GB12385@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417052550.GA9491@1wt.eu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20070417052550.GA9491@1wt.eu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Willy Tarreau <w@1wt.eu> wrote:

> Have you tried previous version with the fair-fork patch ? It might be 
> possible that your workload is sensible to the fork()'s child getting 
> much CPU upon startup.

the fair-fork patch is now included in -v2, but that was already in 
-v2-rc0 too that i sent to Gene separately. I've attached the 
-rc0->final delta.

Gene, could you please apply this patch to your -v2-rc0 tree and do a 
quick double-check that indeed these changes cause the regression?

	Ingo

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sched-cfs-v2-rc0-final-delta.patch"

---
 include/linux/sched.h     |    7 +
 kernel/exit.c             |    2 
 kernel/posix-cpu-timers.c |   24 ++---
 kernel/rtmutex.c          |    2 
 kernel/sched.c            |  191 +++++++++++++++++++++++++---------------------
 kernel/sched_debug.c      |   14 +--
 kernel/sched_fair.c       |   80 +++++++++++++------
 kernel/sched_rt.c         |   21 +++++
 kernel/sysctl.c           |    8 +
 9 files changed, 218 insertions(+), 131 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -798,12 +798,15 @@ struct sched_class {
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p);
 	void (*requeue_task) (struct rq *rq, struct task_struct *p);
 
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
+
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 	struct task_struct * (*load_balance_start) (struct rq *rq);
 	struct task_struct * (*load_balance_next) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
+	void (*task_new) (struct rq *rq, struct task_struct *p);
 
 	void (*task_init) (struct rq *rq, struct task_struct *p);
 };
@@ -838,7 +841,8 @@ struct task_struct {
 	u64 last_ran;
 
 	s64 wait_runtime;
-	u64 exec_runtime, fair_key;
+	u64 sum_exec_runtime, fair_key;
+	s64 sum_wait_runtime;
 	long nice_offset;
 	s64 hog_limit;
 
@@ -1236,6 +1240,7 @@ extern char * sched_print_task_state(str
 
 extern unsigned int sysctl_sched_max_hog_history;
 extern unsigned int sysctl_sched_granularity;
+extern unsigned int sysctl_sched_child_runs_first;
 
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c
+++ linux/kernel/exit.c
@@ -112,7 +112,7 @@ static void __exit_signal(struct task_st
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
 		sig->nivcsw += tsk->nivcsw;
-		sig->sum_sched_runtime += tsk->exec_runtime;
+		sig->sum_sched_runtime += tsk->sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
 
Index: linux/kernel/posix-cpu-timers.c
===================================================================
--- linux.orig/kernel/posix-cpu-timers.c
+++ linux/kernel/posix-cpu-timers.c
@@ -161,7 +161,7 @@ static inline cputime_t virt_ticks(struc
 }
 static inline unsigned long long sched_ns(struct task_struct *p)
 {
-	return (p == current) ? current_sched_runtime(p) : p->exec_runtime;
+	return (p == current) ? current_sched_runtime(p) : p->sum_exec_runtime;
 }
 
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
@@ -249,7 +249,7 @@ static int cpu_clock_sample_group_locked
 		cpu->sched = p->signal->sum_sched_runtime;
 		/* Add in each other live thread.  */
 		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->exec_runtime;
+			cpu->sched += t->sum_exec_runtime;
 		}
 		cpu->sched += sched_ns(p);
 		break;
@@ -422,7 +422,7 @@ int posix_cpu_timer_del(struct k_itimer 
  */
 static void cleanup_timers(struct list_head *head,
 			   cputime_t utime, cputime_t stime,
-			   unsigned long long exec_runtime)
+			   unsigned long long sum_exec_runtime)
 {
 	struct cpu_timer_list *timer, *next;
 	cputime_t ptime = cputime_add(utime, stime);
@@ -451,10 +451,10 @@ static void cleanup_timers(struct list_h
 	++head;
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (timer->expires.sched < exec_runtime) {
+		if (timer->expires.sched < sum_exec_runtime) {
 			timer->expires.sched = 0;
 		} else {
-			timer->expires.sched -= exec_runtime;
+			timer->expires.sched -= sum_exec_runtime;
 		}
 	}
 }
@@ -467,7 +467,7 @@ static void cleanup_timers(struct list_h
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->exec_runtime);
+		       tsk->utime, tsk->stime, tsk->sum_exec_runtime);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
@@ -475,7 +475,7 @@ void posix_cpu_timers_exit_group(struct 
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime_add(tsk->utime, tsk->signal->utime),
 		       cputime_add(tsk->stime, tsk->signal->stime),
-		       tsk->exec_runtime + tsk->signal->sum_sched_runtime);
+		       tsk->sum_exec_runtime + tsk->signal->sum_sched_runtime);
 }
 
 
@@ -536,7 +536,7 @@ static void process_timer_rebalance(stru
 		nsleft = max_t(unsigned long long, nsleft, 1);
 		do {
 			if (likely(!(t->flags & PF_EXITING))) {
-				ns = t->exec_runtime + nsleft;
+				ns = t->sum_exec_runtime + nsleft;
 				if (t->it_sched_expires == 0 ||
 				    t->it_sched_expires > ns) {
 					t->it_sched_expires = ns;
@@ -1004,7 +1004,7 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_entry(timers->next,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->exec_runtime < t->expires.sched) {
+		if (!--maxfire || tsk->sum_exec_runtime < t->expires.sched) {
 			tsk->it_sched_expires = t->expires.sched;
 			break;
 		}
@@ -1049,7 +1049,7 @@ static void check_process_timers(struct 
 	do {
 		utime = cputime_add(utime, t->utime);
 		stime = cputime_add(stime, t->stime);
-		sum_sched_runtime += t->exec_runtime;
+		sum_sched_runtime += t->sum_exec_runtime;
 		t = next_thread(t);
 	} while (t != tsk);
 	ptime = cputime_add(utime, stime);
@@ -1208,7 +1208,7 @@ static void check_process_timers(struct 
 				t->it_virt_expires = ticks;
 			}
 
-			sched = t->exec_runtime + sched_left;
+			sched = t->sum_exec_runtime + sched_left;
 			if (sched_expires && (t->it_sched_expires == 0 ||
 					      t->it_sched_expires > sched)) {
 				t->it_sched_expires = sched;
@@ -1300,7 +1300,7 @@ void run_posix_cpu_timers(struct task_st
 
 	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
 	    (tsk->it_sched_expires == 0 ||
-	     tsk->exec_runtime < tsk->it_sched_expires))
+	     tsk->sum_exec_runtime < tsk->it_sched_expires))
 		return;
 
 #undef	UNEXPIRED
Index: linux/kernel/rtmutex.c
===================================================================
--- linux.orig/kernel/rtmutex.c
+++ linux/kernel/rtmutex.c
@@ -337,7 +337,7 @@ static inline int try_to_steal_lock(stru
 	 * interrupted, so we would delay a waiter with higher
 	 * priority as current->normal_prio.
 	 *
-	 * Note: in the rare case of a SCHED_FAIR task changing
+	 * Note: in the rare case of a SCHED_OTHER task changing
 	 * its priority and thus stealing the lock, next->task
 	 * might be current:
 	 */
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -101,8 +101,10 @@ unsigned long long __attribute__((weak))
 #define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
 #define DEF_TIMESLICE		(100 * HZ / 1000)
 
-#define TASK_PREEMPTS_CURR(p, rq) \
-	((p)->prio < (rq)->curr->prio)
+static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
+{
+	p->sched_class->check_preempt_curr(rq, p);
+}
 
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
@@ -227,7 +229,7 @@ char * sched_print_task_state(struct tas
 	P(exec_start);
 	P(last_ran);
 	P(wait_runtime);
-	P(exec_runtime);
+	P(sum_exec_runtime);
 #undef P
 
 	t0 = sched_clock();
@@ -431,38 +433,46 @@ static inline struct rq *this_rq_lock(vo
 	return rq;
 }
 
-#include "sched_stats.h"
-#include "sched_rt.c"
-#include "sched_fair.c"
-#include "sched_debug.c"
+/*
+ * resched_task - mark a task 'to be rescheduled now'.
+ *
+ * On UP this means the setting of the need_resched flag, on SMP it
+ * might also involve a cross-CPU call to trigger the scheduler on
+ * the target CPU.
+ */
+#ifdef CONFIG_SMP
 
-#define sched_class_highest (&rt_sched_class)
+#ifndef tsk_is_polling
+#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
+#endif
 
-static void enqueue_task(struct rq *rq, struct task_struct *p)
+static void resched_task(struct task_struct *p)
 {
-	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p);
-	p->on_rq = 1;
-}
+	int cpu;
 
-static void dequeue_task(struct rq *rq, struct task_struct *p)
-{
-	p->sched_class->dequeue_task(rq, p);
-	p->on_rq = 0;
-}
+	assert_spin_locked(&task_rq(p)->lock);
 
-static void requeue_task(struct rq *rq, struct task_struct *p)
-{
-	p->sched_class->requeue_task(rq, p);
-}
+	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
+		return;
 
-/*
- * __normal_prio - return the priority that is based on the static prio
- */
-static inline int __normal_prio(struct task_struct *p)
+	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
+
+	cpu = task_cpu(p);
+	if (cpu == smp_processor_id())
+		return;
+
+	/* NEED_RESCHED must be visible before we test polling */
+	smp_mb();
+	if (!tsk_is_polling(p))
+		smp_send_reschedule(cpu);
+}
+#else
+static inline void resched_task(struct task_struct *p)
 {
-	return p->static_prio;
+	assert_spin_locked(&task_rq(p)->lock);
+	set_tsk_need_resched(p);
 }
+#endif
 
 /*
  * To aid in avoiding the subversion of "niceness" due to uneven distribution
@@ -528,6 +538,41 @@ static inline void dec_nr_running(struct
 	dec_raw_weighted_load(rq, p);
 }
 
+static void activate_task(struct rq *rq, struct task_struct *p);
+
+#include "sched_stats.h"
+#include "sched_rt.c"
+#include "sched_fair.c"
+#include "sched_debug.c"
+
+#define sched_class_highest (&rt_sched_class)
+
+static void enqueue_task(struct rq *rq, struct task_struct *p)
+{
+	sched_info_queued(p);
+	p->sched_class->enqueue_task(rq, p);
+	p->on_rq = 1;
+}
+
+static void dequeue_task(struct rq *rq, struct task_struct *p)
+{
+	p->sched_class->dequeue_task(rq, p);
+	p->on_rq = 0;
+}
+
+static void requeue_task(struct rq *rq, struct task_struct *p)
+{
+	p->sched_class->requeue_task(rq, p);
+}
+
+/*
+ * __normal_prio - return the priority that is based on the static prio
+ */
+static inline int __normal_prio(struct task_struct *p)
+{
+	return p->static_prio;
+}
+
 /*
  * Calculate the expected normal priority: i.e. priority
  * without taking RT-inheritance into account. Might be
@@ -593,47 +638,6 @@ static void deactivate_task(struct rq *r
 	dec_nr_running(p, rq);
 }
 
-/*
- * resched_task - mark a task 'to be rescheduled now'.
- *
- * On UP this means the setting of the need_resched flag, on SMP it
- * might also involve a cross-CPU call to trigger the scheduler on
- * the target CPU.
- */
-#ifdef CONFIG_SMP
-
-#ifndef tsk_is_polling
-#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
-#endif
-
-static void resched_task(struct task_struct *p)
-{
-	int cpu;
-
-	assert_spin_locked(&task_rq(p)->lock);
-
-	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
-		return;
-
-	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
-
-	cpu = task_cpu(p);
-	if (cpu == smp_processor_id())
-		return;
-
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(p))
-		smp_send_reschedule(cpu);
-}
-#else
-static inline void resched_task(struct task_struct *p)
-{
-	assert_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
-}
-#endif
-
 /**
  * task_curr - is this task currently executing on a CPU?
  * @p: the task in question.
@@ -1113,10 +1117,8 @@ out_activate:
 	 * the waker guarantees that the freshly woken up task is going
 	 * to be considered on this CPU.)
 	 */
-	if (!sync || cpu != this_cpu) {
-		if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
-	}
+	if (!sync || cpu != this_cpu)
+		check_preempt_curr(rq, p);
 	success = 1;
 
 out_running:
@@ -1159,7 +1161,8 @@ static void task_running_tick(struct rq 
 static void __sched_fork(struct task_struct *p)
 {
 	p->wait_start_fair = p->exec_start = p->last_ran = 0;
-	p->exec_runtime = p->wait_runtime = 0;
+	p->sum_exec_runtime = p->wait_runtime = 0;
+	p->sum_wait_runtime = 0;
 
 	INIT_LIST_HEAD(&p->run_list);
 	p->on_rq = 0;
@@ -1208,6 +1211,12 @@ void sched_fork(struct task_struct *p, i
 }
 
 /*
+ * After fork, child runs first. (default) If set to 0 then
+ * parent will (try to) run first.
+ */
+unsigned int __read_mostly sysctl_sched_child_runs_first = 1;
+
+/*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
  * This function will do some initial scheduler statistics housekeeping
@@ -1218,15 +1227,25 @@ void fastcall wake_up_new_task(struct ta
 {
 	unsigned long flags;
 	struct rq *rq;
+	int this_cpu;
 
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
+	this_cpu = smp_processor_id(); /* parent's CPU */
 
 	p->prio = effective_prio(p);
-	activate_task(rq, p);
-	if (TASK_PREEMPTS_CURR(p, rq))
-		resched_task(rq->curr);
 
+	if (!sysctl_sched_child_runs_first || (clone_flags & CLONE_VM) ||
+			task_cpu(p) != this_cpu || !current->on_rq) {
+		activate_task(rq, p);
+	} else {
+		/*
+		 * Let the scheduling class do new task startup
+		 * management (if any):
+		 */
+		p->sched_class->task_new(rq, p);
+	}
+	check_preempt_curr(rq, p);
 	task_rq_unlock(rq, &flags);
 }
 
@@ -1559,8 +1578,7 @@ static void pull_task(struct rq *src_rq,
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
 	 */
-	if (TASK_PREEMPTS_CURR(p, this_rq))
-		resched_task(this_rq->curr);
+	check_preempt_curr(this_rq, p);
 }
 
 /*
@@ -2467,7 +2485,7 @@ DEFINE_PER_CPU(struct kernel_stat, kstat
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
- * Return current->exec_runtime plus any more ns on the sched_clock
+ * Return current->sum_exec_runtime plus any more ns on the sched_clock
  * that have not yet been banked.
  */
 unsigned long long current_sched_runtime(const struct task_struct *p)
@@ -2476,7 +2494,7 @@ unsigned long long current_sched_runtime
 	unsigned long flags;
 
 	local_irq_save(flags);
-	ns = p->exec_runtime + sched_clock() - p->last_ran;
+	ns = p->sum_exec_runtime + sched_clock() - p->last_ran;
 	local_irq_restore(flags);
 
 	return ns;
@@ -3176,8 +3194,9 @@ void rt_mutex_setprio(struct task_struct
 		if (task_running(rq, p)) {
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
+		} else {
+			check_preempt_curr(rq, p);
+		}
 	}
 	task_rq_unlock(rq, &flags);
 }
@@ -3469,8 +3488,9 @@ recheck:
 		if (task_running(rq, p)) {
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
-		} else if (TASK_PREEMPTS_CURR(p, rq))
-			resched_task(rq->curr);
+		} else {
+			check_preempt_curr(rq, p);
+		}
 	}
 	__task_rq_unlock(rq);
 	spin_unlock_irqrestore(&p->pi_lock, flags);
@@ -4183,8 +4203,7 @@ static int __migrate_task(struct task_st
 	if (p->on_rq) {
 		deactivate_task(rq_src, p);
 		activate_task(rq_dest, p);
-		if (TASK_PREEMPTS_CURR(p, rq_dest))
-			resched_task(rq_dest->curr);
+		check_preempt_curr(rq_dest, p);
 	}
 	ret = 1;
 out:
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -51,10 +51,10 @@ print_task(struct seq_file *m, struct rq
 		p->prio,
 		p->nice_offset,
 		p->hog_limit,
-		p->wait_start_fair,
+		p->wait_start_fair - rq->fair_clock,
 		p->exec_start,
-		p->last_ran,
-		p->exec_runtime);
+		p->sum_exec_runtime,
+		p->sum_wait_runtime);
 }
 
 static void print_rq(struct seq_file *m, struct rq *rq, u64 now)
@@ -66,10 +66,10 @@ static void print_rq(struct seq_file *m,
 	"\nrunnable tasks:\n"
 	"           task   PID     tree-key       delta    waiting"
 	"  switches  prio  nice-offset    hog-limit  wstart-fair   exec-start"
-	"     last-ran exec-runtime\n"
-	"------------------------------------------------------------------"
-	"------------------------------------------------------------------"
-	"-------------------\n");
+	"     sum-exec     sum-wait\n"
+	"---------------------------------------------------------"
+	"--------------------------------------------------------------------"
+	"--------------------------\n");
 
 	curr = first_fair(rq);
 	while (curr) {
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -27,15 +27,9 @@ static void __enqueue_task_fair(struct r
 {
 	struct rb_node **link = &rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
+	long long key = p->fair_key;
 	struct task_struct *entry;
 	int leftmost = 1;
-	long long key;
-
-	key = rq->fair_clock - p->wait_runtime;
-	if (unlikely(p->nice_offset))
-		key += p->nice_offset / (rq->nr_running + 1);
-
-	p->fair_key = key;
 
 	/*
 	 * Find the right place in the rbtree:
@@ -48,9 +42,9 @@ static void __enqueue_task_fair(struct r
 		 * the same key stay together.
 		 */
 		if (key < entry->fair_key) {
-			link = &(*link)->rb_left;
+			link = &parent->rb_left;
 		} else {
-			link = &(*link)->rb_right;
+			link = &parent->rb_right;
 			leftmost = 0;
 		}
 	}
@@ -138,7 +132,7 @@ static inline void update_curr(struct rq
 	delta_exec = convert_delta(rq, now - curr->exec_start, curr);
 	delta_fair = delta_exec/rq->nr_running;
 
-	curr->exec_runtime += delta_exec;
+	curr->sum_exec_runtime += delta_exec;
 	curr->exec_start = now;
 
 	rq->fair_clock += delta_fair;
@@ -182,6 +176,11 @@ update_stats_enqueue(struct rq *rq, stru
 	 */
 	if (p != rq->curr)
 		update_stats_wait_start(rq, p, now);
+
+	/*
+	 * Update the key:
+	 */
+	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;
 }
 
 /*
@@ -195,6 +194,7 @@ static inline void update_stats_wait_end
 	delta = scale_nice_down(rq, p, delta);
 
 	p->wait_runtime += delta;
+	p->sum_wait_runtime += delta;
 	rq->wait_runtime += delta;
 
 	p->wait_start_fair = 0;
@@ -275,6 +275,24 @@ static void requeue_task_fair(struct rq 
 	p->on_rq = 1;
 }
 
+/*
+ * Preempt the current task with a newly woken task if needed:
+ */
+static void check_preempt_curr_fair(struct rq *rq, struct task_struct *p)
+{
+	struct task_struct *curr = rq->curr;
+	long long __delta = curr->fair_key - p->fair_key;
+
+	/*
+	 * Take scheduling granularity into account - do not
+	 * preempt the current task unless the best task has
+	 * a larger than sched_granularity fairness advantage:
+	 */
+	if (p->prio < curr->prio ||
+			__delta > (unsigned long long)sysctl_sched_granularity)
+		resched_task(curr);
+}
+
 static struct task_struct * pick_next_task_fair(struct rq *rq)
 {
 	struct task_struct *p = __pick_next_task_fair(rq);
@@ -362,25 +380,36 @@ static void task_tick_fair(struct rq *rq
 	 * Dequeue and enqueue the task to update its
 	 * position within the tree:
 	 */
-	dequeue_task_fair(rq, curr);
-	curr->on_rq = 0;
-	enqueue_task_fair(rq, curr);
-	curr->on_rq = 1;
+	requeue_task_fair(rq, curr);
 
 	/*
 	 * Reschedule if another task tops the current one.
-	 *
-	 * Take scheduling granularity into account - do not
-	 * preempt the current task unless the best task has
-	 * a larger than sched_granularity fairness advantage:
 	 */
 	next = __pick_next_task_fair(rq);
-	if (next != curr) {
-		unsigned long long __delta = curr->fair_key - next->fair_key;
+	if (next != curr)
+		check_preempt_curr(rq, next);
+}
 
-		if (__delta > (unsigned long long)sysctl_sched_granularity)
-			set_tsk_need_resched(curr);
-	}
+/*
+ * Share the fairness runtime between parent and child, thus the
+ * total amount of pressure for CPU stays equal - new tasks
+ * get a chance to run but frequent forkers are not allowed to
+ * monopolize the CPU. Note: the parent runqueue is locked,
+ * the child is not running yet.
+ */
+static void task_new_fair(struct rq *rq, struct task_struct *p)
+{
+	sched_info_queued(p);
+	update_stats_enqueue(rq, p);
+	/*
+	 * Child runs first: we let it run before the parent
+	 * until it reschedules once. We set up a key so that
+	 * it will preempt the parent:
+	 */
+	p->fair_key = current->fair_key - sysctl_sched_granularity - 1;
+	__enqueue_task_fair(rq, p);
+	p->on_rq = 1;
+	inc_nr_running(p, rq);
 }
 
 static inline long
@@ -418,6 +447,8 @@ hog_limit(struct rq *rq, struct task_str
 	return -(long long)limit;
 }
 
+#define NICE_OFFSET_GRANULARITY 100000
+
 /*
  * Calculate and cache the nice offset and the hog limit values:
  */
@@ -441,12 +472,15 @@ struct sched_class fair_sched_class __re
 	.dequeue_task		= dequeue_task_fair,
 	.requeue_task		= requeue_task_fair,
 
+	.check_preempt_curr	= check_preempt_curr_fair,
+
 	.pick_next_task		= pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
 
 	.load_balance_start	= load_balance_start_fair,
 	.load_balance_next	= load_balance_next_fair,
 	.task_tick		= task_tick_fair,
+	.task_new		= task_new_fair,
 
 	.task_init		= task_init_fair,
 };
Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -34,6 +34,15 @@ static void requeue_task_rt(struct rq *r
 	list_move_tail(&p->run_list, array->queue + p->prio);
 }
 
+/*
+ * Preempt the current task with a newly woken task if needed:
+ */
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
+{
+	if (p->prio < rq->curr->prio)
+		resched_task(rq->curr);
+}
+
 static struct task_struct * pick_next_task_rt(struct rq *rq)
 {
 	struct prio_array *array = &rq->active;
@@ -140,6 +149,15 @@ static void task_tick_rt(struct rq *rq, 
 	}
 }
 
+/*
+ * No parent/child timeslice management necessary for RT tasks,
+ * just activate them:
+ */
+static void task_new_rt(struct rq *rq, struct task_struct *p)
+{
+	activate_task(rq, p);
+}
+
 static void task_init_rt(struct rq *rq, struct task_struct *p)
 {
 }
@@ -149,6 +167,8 @@ static struct sched_class rt_sched_class
 	.dequeue_task		= dequeue_task_rt,
 	.requeue_task		= requeue_task_rt,
 
+	.check_preempt_curr	= check_preempt_curr_rt,
+
 	.pick_next_task		= pick_next_task_rt,
 	.put_prev_task		= put_prev_task_rt,
 
@@ -156,5 +176,6 @@ static struct sched_class rt_sched_class
 	.load_balance_next	= load_balance_next_rt,
 
 	.task_tick		= task_tick_rt,
+	.task_new		= task_new_rt,
 	.task_init		= task_init_rt,
 };
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -222,6 +222,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_child_runs_first",
+		.data		= &sysctl_sched_child_runs_first,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
 		.data		= &panic_timeout,

--huq684BweRXVnRxX--
