Return-Path: <linux-kernel-owner+w=401wt.eu-S1760365AbYHOUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365AbYHOUb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbYHOUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:30:43 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36008
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758683AbYHOUak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:30:40 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v4 2/8] sched: add the basic PI infrastructure to the
	task_struct
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com, jkacur@gmail.com
Date: Fri, 15 Aug 2008 16:28:29 -0400
Message-ID: <20080815202828.668.68523.stgit@dev.haskins.net>
In-Reply-To: <20080815202408.668.23736.stgit@dev.haskins.net>
References: <20080815202408.668.23736.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first pass at converting the system to use the new PI library.
We dont go for a wholesale replacement quite yet so that we can focus
on getting the basic plumbing in place.  Later in the series we will
begin replacing some of the proprietary logic with the generic
framework.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h     |   37 +++++++--
 include/linux/workqueue.h |    2 
 kernel/fork.c             |    1 
 kernel/rcupreempt-boost.c |   23 +-----
 kernel/rtmutex.c          |    6 +
 kernel/sched.c            |  188 ++++++++++++++++++++++++++++++++-------------
 kernel/workqueue.c        |   39 ++++++++-
 7 files changed, 206 insertions(+), 90 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c885f78..5521a64 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,6 +87,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/kobject.h>
 #include <linux/latencytop.h>
+#include <linux/pi.h>
 
 #include <asm/processor.h>
 
@@ -1125,6 +1126,7 @@ struct task_struct {
 	int prio, static_prio, normal_prio;
 #ifdef CONFIG_PREEMPT_RCU_BOOST
 	int rcu_prio;
+	struct pi_source rcu_prio_src;
 #endif
 	const struct sched_class *sched_class;
 	struct sched_entity se;
@@ -1298,11 +1300,20 @@ struct task_struct {
 	/* Protection of the PI data structures: */
 	raw_spinlock_t pi_lock;
 
+	struct {
+		struct pi_source src;  /* represents normal_prio to 'this' */
+		struct pi_node node;
+		struct pi_sink sink;  /* registered to 'this' to get updates */
+		int prio;
+	} pi;
+
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
 	struct plist_head pi_waiters;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
+	int rtmutex_prio;
+	struct pi_source rtmutex_prio_src;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
@@ -1440,6 +1451,26 @@ struct task_struct {
 #endif
 };
 
+static inline int
+task_pi_boost(struct task_struct *p, struct pi_source *src,
+	      unsigned int flags)
+{
+	return pi_boost(&p->pi.node, src, flags);
+}
+
+static inline int
+task_pi_deboost(struct task_struct *p, struct pi_source *src,
+		unsigned int flags)
+{
+	return pi_deboost(&p->pi.node, src, flags);
+}
+
+static inline int
+task_pi_update(struct task_struct *p, unsigned int flags)
+{
+	return pi_update(&p->pi.node, flags);
+}
+
 #ifdef CONFIG_PREEMPT_RT
 # define set_printk_might_sleep(x) do { current->in_printk = x; } while(0)
 #else
@@ -1774,14 +1805,8 @@ int sched_rt_handler(struct ctl_table *table, int write,
 
 extern unsigned int sysctl_sched_compat_yield;
 
-extern void task_setprio(struct task_struct *p, int prio);
-
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
-static inline void rt_mutex_setprio(struct task_struct *p, int prio)
-{
-	task_setprio(p, prio);
-}
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 #else
 static inline int rt_mutex_getprio(struct task_struct *p)
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 229179e..3dc4ed9 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -11,6 +11,7 @@
 #include <linux/lockdep.h>
 #include <linux/plist.h>
 #include <linux/sched_prio.h>
+#include <linux/pi.h>
 #include <asm/atomic.h>
 
 struct workqueue_struct;
@@ -31,6 +32,7 @@ struct work_struct {
 #define WORK_STRUCT_WQ_DATA_MASK (~WORK_STRUCT_FLAG_MASK)
 	struct plist_node entry;
 	work_func_t func;
+	struct pi_source pi_src;
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index b49488d..399a0d0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -990,6 +990,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->rcu_flipctr_idx = 0;
 #ifdef CONFIG_PREEMPT_RCU_BOOST
 	p->rcu_prio = MAX_PRIO;
+	pi_source_init(&p->rcu_prio_src, &p->rcu_prio);
 	p->rcub_rbdp = NULL;
 	p->rcub_state = RCU_BOOST_IDLE;
 	INIT_LIST_HEAD(&p->rcub_entry);
diff --git a/kernel/rcupreempt-boost.c b/kernel/rcupreempt-boost.c
index 5282b19..e8d9d76 100644
--- a/kernel/rcupreempt-boost.c
+++ b/kernel/rcupreempt-boost.c
@@ -232,14 +232,11 @@ static inline int rcu_is_boosted(struct task_struct *task)
 static void rcu_boost_task(struct task_struct *task)
 {
 	WARN_ON(!irqs_disabled());
-	WARN_ON_SMP(!spin_is_locked(&task->pi_lock));
 
 	rcu_trace_boost_task_boost_called(RCU_BOOST_ME);
 
-	if (task->rcu_prio < task->prio) {
+	if (task_pi_boost(task, &task->rcu_prio_src, 0))
 		rcu_trace_boost_task_boosted(RCU_BOOST_ME);
-		task_setprio(task, task->rcu_prio);
-	}
 }
 
 /**
@@ -275,26 +272,17 @@ void __rcu_preempt_boost(void)
 	rbd = &__get_cpu_var(rcu_boost_data);
 	spin_lock(&rbd->rbs_lock);
 
-	spin_lock(&curr->pi_lock);
-
 	curr->rcub_rbdp = rbd;
 
 	rcu_trace_boost_try_boost(rbd);
 
-	prio = rt_mutex_getprio(curr);
-
 	if (list_empty(&curr->rcub_entry))
 		list_add_tail(&curr->rcub_entry, &rbd->rbs_toboost);
-	if (prio <= rbd->rbs_prio)
-		goto out;
-
-	rcu_trace_boost_boosted(curr->rcub_rbdp);
 
 	set_rcu_prio(curr, rbd->rbs_prio);
 	rcu_boost_task(curr);
 
  out:
-	spin_unlock(&curr->pi_lock);
 	spin_unlock_irqrestore(&rbd->rbs_lock, flags);
 }
 
@@ -353,15 +341,12 @@ void __rcu_preempt_unboost(void)
 
 	rcu_trace_boost_unboosted(rbd);
 
-	set_rcu_prio(curr, MAX_PRIO);
+	task_pi_deboost(curr, &curr->rcu_prio_src, 0);
 
-	spin_lock(&curr->pi_lock);
-	prio = rt_mutex_getprio(curr);
-	task_setprio(curr, prio);
+	set_rcu_prio(curr, MAX_PRIO);
 
 	curr->rcub_rbdp = NULL;
 
-	spin_unlock(&curr->pi_lock);
  out:
 	spin_unlock_irqrestore(&rbd->rbs_lock, flags);
 }
@@ -393,9 +378,7 @@ static int __rcu_boost_readers(struct rcu_boost_dat *rbd, int prio, unsigned lon
 		list_move_tail(&p->rcub_entry,
 			       &rbd->rbs_boosted);
 		set_rcu_prio(p, prio);
-		spin_lock(&p->pi_lock);
 		rcu_boost_task(p);
-		spin_unlock(&p->pi_lock);
 
 		/*
 		 * Now we release the lock to allow for a higher
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 377949a..7d11380 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -178,8 +178,10 @@ static void __rt_mutex_adjust_prio(struct task_struct *task)
 {
 	int prio = rt_mutex_getprio(task);
 
-	if (task->prio != prio)
-		rt_mutex_setprio(task, prio);
+	if (task->rtmutex_prio != prio) {
+		task->rtmutex_prio = prio;
+		task_pi_boost(task, &task->rtmutex_prio_src, 0);
+	}
 }
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 54ea580..0732a9b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1709,26 +1709,6 @@ static inline int normal_prio(struct task_struct *p)
 }
 
 /*
- * Calculate the current priority, i.e. the priority
- * taken into account by the scheduler. This value might
- * be boosted by RT tasks, or might be boosted by
- * interactivity modifiers. Will be RT if the task got
- * RT-boosted. If not then it returns p->normal_prio.
- */
-static int effective_prio(struct task_struct *p)
-{
-	p->normal_prio = normal_prio(p);
-	/*
-	 * If we are RT tasks or we were boosted to RT priority,
-	 * keep the priority unchanged. Otherwise, update priority
-	 * to the normal priority:
-	 */
-	if (!rt_prio(p->prio))
-		return p->normal_prio;
-	return p->prio;
-}
-
-/*
  * activate_task - move a task to the runqueue.
  */
 static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
@@ -2375,6 +2355,58 @@ static void __sched_fork(struct task_struct *p)
 	p->state = TASK_RUNNING;
 }
 
+static int
+task_pi_boost_cb(struct pi_sink *sink, struct pi_source *src,
+		 unsigned int flags)
+{
+	struct task_struct *p = container_of(sink, struct task_struct, pi.sink);
+
+	/*
+	 * We dont need any locking here, since the .boost operation
+	 * is already guaranteed to be mutually exclusive
+	 */
+	p->pi.prio = *src->prio;
+
+	return 0;
+}
+
+static int task_pi_update_cb(struct pi_sink *sink, unsigned int flags);
+
+static struct pi_sink_ops task_pi_sink = {
+    .boost = task_pi_boost_cb,
+    .update = task_pi_update_cb,
+};
+
+static inline void
+task_pi_init(struct task_struct *p)
+{
+	pi_node_init(&p->pi.node);
+
+	/*
+	 * Feed our initial state of normal_prio into the PI infrastructure.
+	 * We will update this whenever it changes
+	 */
+	p->pi.prio = p->normal_prio;
+	pi_source_init(&p->pi.src, &p->normal_prio);
+	task_pi_boost(p, &p->pi.src, PI_FLAG_DEFER_UPDATE);
+
+#ifdef CONFIG_RT_MUTEXES
+	p->rtmutex_prio = MAX_PRIO;
+	pi_source_init(&p->rtmutex_prio_src, &p->rtmutex_prio);
+	task_pi_boost(p, &p->rtmutex_prio_src, PI_FLAG_DEFER_UPDATE);
+#endif
+
+	/*
+	 * We add our own task as a dependency of ourselves so that
+	 * we get boost-notifications (via task_pi_boost_cb) whenever
+	 * our priority is changed (locally e.g. setscheduler() or
+	 * remotely via a pi-boost).
+	 */
+	pi_sink_init(&p->pi.sink, &task_pi_sink);
+	pi_add_sink(&p->pi.node, &p->pi.sink,
+		    PI_FLAG_DEFER_UPDATE | PI_FLAG_ALREADY_BOOSTED);
+}
+
 /*
  * fork()/clone()-time setup:
  */
@@ -2396,6 +2428,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+	task_pi_init(p);
+
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
@@ -2411,6 +2445,55 @@ void sched_fork(struct task_struct *p, int clone_flags)
 }
 
 /*
+ * In the past, task_setprio was exposed as an API.  This variant is only
+ * meant to be called from pi_update functions (namely, task_updateprio() and
+ * task_pi_update_cb()).  If you need to adjust the priority of a task,
+ * you should be using something like setscheduler() (permanent adjustments)
+ * or task_pi_boost() (temporary adjustments).
+ */
+static void
+task_setprio(struct task_struct *p, int prio)
+{
+	if (prio == p->prio)
+		return;
+
+	if (rt_prio(prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
+
+	p->prio = prio;
+}
+
+static inline void
+task_updateprio(struct task_struct *p)
+{
+	int prio = normal_prio(p);
+
+	if (p->normal_prio != prio) {
+		p->normal_prio = prio;
+		set_load_weight(p);
+
+		/*
+		 * Reboost our normal_prio entry, which will
+		 * also chain-update any of our PI dependencies (of course)
+		 * on our next update
+		 */
+		task_pi_boost(p, &p->pi.src, PI_FLAG_DEFER_UPDATE);
+	}
+
+	/*
+	 * If normal_prio is logically higher than our current setting,
+	 * just assign the priority/class immediately so that any callers
+	 * will see the update as synchronous without dropping the rq-lock
+	 * to do a pi_update.  Any descrepancy with pending pi-updates will
+	 * automatically be corrected after we drop the rq-lock.
+	 */
+	if (p->normal_prio < p->prio)
+		task_setprio(p, p->normal_prio);
+}
+
+/*
  * wake_up_new_task - wake up a newly created task for the first time.
  *
  * This function will do some initial scheduler statistics housekeeping
@@ -2426,7 +2509,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
 
-	p->prio = effective_prio(p);
+	task_updateprio(p);
 
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);
@@ -2447,6 +2530,8 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		p->sched_class->task_wake_up(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
+
+	task_pi_update(p, 0);
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -4887,27 +4972,25 @@ long __sched sleep_on_timeout(wait_queue_head_t *q, long timeout)
 EXPORT_SYMBOL(sleep_on_timeout);
 
 /*
- * task_setprio - set the current priority of a task
- * @p: task
- * @prio: prio value (kernel-internal form)
+ * Invoked whenever our priority changes by the PI library
  *
  * This function changes the 'effective' priority of a task. It does
  * not touch ->normal_prio like __setscheduler().
  *
- * Used by the rt_mutex code to implement priority inheritance logic
- * and by rcupreempt-boost to boost priorities of tasks sleeping
- * with rcu locks.
  */
-void task_setprio(struct task_struct *p, int prio)
+static int
+task_pi_update_cb(struct pi_sink *sink, unsigned int flags)
 {
-	unsigned long flags;
+	struct task_struct *p = container_of(sink, struct task_struct, pi.sink);
+	unsigned long iflags;
 	int oldprio, on_rq, running;
+	int prio = p->pi.prio;
 	struct rq *rq;
 	const struct sched_class *prev_class = p->sched_class;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
-	rq = task_rq_lock(p, &flags);
+	rq = task_rq_lock(p, &iflags);
 
 	/*
 	 * Idle task boosting is a nono in general. There is one
@@ -4929,6 +5012,10 @@ void task_setprio(struct task_struct *p, int prio)
 
 	update_rq_clock(rq);
 
+	/* If prio is not changing, bail */
+	if (prio == p->prio)
+		goto out_unlock;
+
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
@@ -4937,12 +5024,7 @@ void task_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	if (rt_prio(prio))
-		p->sched_class = &rt_sched_class;
-	else
-		p->sched_class = &fair_sched_class;
-
-	p->prio = prio;
+	task_setprio(p, prio);
 
 //	trace_special_pid(p->pid, __PRIO(oldprio), PRIO(p));
 
@@ -4956,7 +5038,9 @@ void task_setprio(struct task_struct *p, int prio)
 //	trace_special(prev_resched, _need_resched(), 0);
 
 out_unlock:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, &iflags);
+
+	return 0;
 }
 
 void set_user_nice(struct task_struct *p, long nice)
@@ -4990,9 +5074,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p);
 	old_prio = p->prio;
-	p->prio = effective_prio(p);
+	task_updateprio(p);
+
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
@@ -5007,6 +5091,8 @@ void set_user_nice(struct task_struct *p, long nice)
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);
+
+	task_pi_update(p, 0);
 }
 EXPORT_SYMBOL(set_user_nice);
 
@@ -5123,23 +5209,9 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 	BUG_ON(p->se.on_rq);
 
 	p->policy = policy;
-	switch (p->policy) {
-	case SCHED_NORMAL:
-	case SCHED_BATCH:
-	case SCHED_IDLE:
-		p->sched_class = &fair_sched_class;
-		break;
-	case SCHED_FIFO:
-	case SCHED_RR:
-		p->sched_class = &rt_sched_class;
-		break;
-	}
-
 	p->rt_priority = prio;
-	p->normal_prio = normal_prio(p);
-	/* we are holding p->pi_lock already */
-	p->prio = rt_mutex_getprio(p);
-	set_load_weight(p);
+
+	task_updateprio(p);
 }
 
 /**
@@ -5264,6 +5336,7 @@ recheck:
 	__task_rq_unlock(rq);
 	spin_unlock_irqrestore(&p->pi_lock, flags);
 
+	task_pi_update(p, 0);
 	rt_mutex_adjust_pi(p);
 
 	return 0;
@@ -6686,6 +6759,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		deactivate_task(rq, rq->idle, 0);
 		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
+		rq->idle->prio = rq->idle->normal_prio;
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
@@ -8395,6 +8469,8 @@ void __init sched_init(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains, NULL);
 #endif
 
+	task_pi_init(&init_task);
+
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);
 #endif
@@ -8460,7 +8536,9 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
+
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
+
 	if (on_rq) {
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f37979..5cd4b0e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -145,8 +145,13 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	plist_node_init(&work->entry, prio);
 	plist_add(&work->entry, &cwq->worklist);
 
-	if (boost_prio < cwq->thread->prio)
-		task_setprio(cwq->thread, boost_prio);
+	/*
+	 * FIXME: We want to boost to boost_prio, but we dont record that
+	 * value in the work_struct for later deboosting
+	 */
+	pi_source_init(&work->pi_src, &work->entry.prio);
+	task_pi_boost(cwq->thread, &work->pi_src, 0);
+
 	wake_up(&cwq->more_work);
 }
 
@@ -280,6 +285,10 @@ struct wq_barrier {
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	struct plist_head *worklist = &cwq->worklist;
+	struct pi_source pi_src;
+	int prio;
+
+	pi_source_init(&pi_src, &prio);
 
 	spin_lock_irq(&cwq->lock);
 	cwq->run_depth++;
@@ -292,10 +301,10 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 
 again:
 	while (!plist_head_empty(worklist)) {
-		int prio;
 		struct work_struct *work = plist_first_entry(worklist,
 						struct work_struct, entry);
 		work_func_t f = work->func;
+
 #ifdef CONFIG_LOCKDEP
 		/*
 		 * It is permissible to free the struct work_struct
@@ -316,14 +325,28 @@ again:
 		}
 		prio = max(prio, 0);
 
-		if (likely(cwq->thread->prio != prio))
-			task_setprio(cwq->thread, prio);
-
 		cwq->current_work = work;
 		plist_del(&work->entry, worklist);
 		plist_node_init(&work->entry, MAX_PRIO);
 		spin_unlock_irq(&cwq->lock);
 
+		/*
+		 * The owner is free to reuse the work object once we execute
+		 * the work->func() below.  Therefore we cannot leave the
+		 * work->pi_src boosting our thread or it may get stomped
+		 * on when the work item is requeued.
+		 *
+		 * So what we do is we boost ourselves with an on-the
+		 * stack copy of the priority of the work item, and then
+		 * deboost the workitem.  Once the work is complete, we
+		 * can then simply deboost the stack version.
+		 *
+		 * Note that this will not typically cause a pi-chain
+		 * update since we are boosting the node laterally
+		 */
+		task_pi_boost(current, &pi_src, PI_FLAG_DEFER_UPDATE);
+		task_pi_deboost(current, &work->pi_src, PI_FLAG_DEFER_UPDATE);
+
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
 		leak_check(NULL);
@@ -334,6 +357,9 @@ again:
 		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
 		leak_check(f);
 
+		/* Deboost the stack copy of the work->prio (see above) */
+		task_pi_deboost(current, &pi_src, 0);
+
 		spin_lock_irq(&cwq->lock);
 		cwq->current_work = NULL;
 		wake_up_all(&cwq->work_done);
@@ -357,7 +383,6 @@ again:
 			goto again;
 	}
 
-	task_setprio(cwq->thread, current->normal_prio);
 	cwq->run_depth--;
 	spin_unlock_irq(&cwq->lock);
 }

