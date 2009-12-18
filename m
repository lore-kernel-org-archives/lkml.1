Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZLRSzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZLRSzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZLRSzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:55:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43656 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZLRSzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:55:20 -0500
Date: Fri, 18 Dec 2009 19:55:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091218185506.GA5859@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

These contain some difficult race fixes from Peter - would be nice to pull 
them early in the -rc2 cycle, in case there's any problems with them.

 Thanks,

	Ingo

------------------>
David Miller (1):
      sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

Frederic Weisbecker (1):
      sched: Teach might_sleep() about preemptible RCU

Ingo Molnar (1):
      sched: Make warning less noisy

Joe Perches (1):
      sched: Use pr_fmt() and pr_<level>()

Peter Zijlstra (16):
      sched: Mark boot-cpu active before smp_init()
      sched: Fix task_hot() test order
      sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE
      sched: Use TASK_WAKING for fork wakups
      sched: Ensure set_task_cpu() is never called on blocked tasks
      sched: Fix sched_exec() balancing
      sched: Fix select_task_rq() vs hotplug issues
      sched: Move kthread_bind() back to kthread.c
      sched: Add pre and post wakeup hooks
      sched: Remove the cfs_rq dependency from set_task_cpu()
      sched: Simplify set_task_cpu()
      sched: Move TASK_STATE_TO_CHAR_STR near the TASK_state bits
      sched: Add missing state chars to TASK_STATE_TO_CHAR_STR
      sched: Update task_state_arraypwith new states
      sched: Assert task state bits at build time
      sched: Fix broken assertion

Rafael J. Wysocki (1):
      sched: Make wakeup side and atomic variants of completion API irq safe

Thomas Gleixner (3):
      sched: Use rcu in sys_sched_getscheduler/sys_sched_getparam()
      sched: Use rcu in sched_get/set_affinity()
      sched: Use rcu in sched_get_rr_param()

Xiaotian Feng (1):
      sched: Fix set_cpu_active() in cpu_down()


 fs/proc/array.c         |   19 ++-
 include/linux/rcutiny.h |    5 +
 include/linux/rcutree.h |   11 ++
 include/linux/sched.h   |   13 +-
 init/main.c             |    7 +-
 kernel/cpu.c            |   24 +---
 kernel/kthread.c        |   23 +++
 kernel/sched.c          |  401 ++++++++++++++++++++++++-----------------------
 kernel/sched_clock.c    |   23 ++-
 kernel/sched_fair.c     |   53 ++++++-
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    4 +-
 12 files changed, 336 insertions(+), 249 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 4badde1..f560325 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -134,13 +134,16 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
  * simple bit tests.
  */
 static const char *task_state_array[] = {
-	"R (running)",		/*  0 */
-	"S (sleeping)",		/*  1 */
-	"D (disk sleep)",	/*  2 */
-	"T (stopped)",		/*  4 */
-	"T (tracing stop)",	/*  8 */
-	"Z (zombie)",		/* 16 */
-	"X (dead)"		/* 32 */
+	"R (running)",		/*   0 */
+	"S (sleeping)",		/*   1 */
+	"D (disk sleep)",	/*   2 */
+	"T (stopped)",		/*   4 */
+	"t (tracing stop)",	/*   8 */
+	"Z (zombie)",		/*  16 */
+	"X (dead)",		/*  32 */
+	"x (dead)",		/*  64 */
+	"K (wakekill)",		/* 128 */
+	"W (waking)",		/* 256 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
@@ -148,6 +151,8 @@ static inline const char *get_task_state(struct task_struct *tsk)
 	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
 	const char **p = &task_state_array[0];
 
+	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
+
 	while (state) {
 		p++;
 		state >>= 1;
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index c4ba9a7..96cc307 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -101,4 +101,9 @@ static inline void exit_rcu(void)
 {
 }
 
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c93eee5..8044b1b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,6 +45,12 @@ extern void __rcu_read_unlock(void);
 extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
+/*
+ * Defined as macro as it is a very low level header
+ * included from areas that don't even know about current
+ */
+#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock(void)
@@ -63,6 +69,11 @@ static inline void exit_rcu(void)
 {
 }
 
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock_bh(void)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c858f3..3754387 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -192,6 +192,12 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
+#define TASK_STATE_MAX		512
+
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+
+extern char ___assert_task_state[1 - 2*!!(
+		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
 
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
@@ -1091,7 +1097,8 @@ struct sched_class {
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const struct cpumask *newmask);
@@ -1115,7 +1122,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p);
+	void (*moved_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
@@ -2594,8 +2601,6 @@ static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 }
 #endif /* CONFIG_MM_OWNER */
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
-
 #endif /* __KERNEL__ */
 
 #endif
diff --git a/init/main.c b/init/main.c
index c3db4a9..dac44a9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -369,12 +369,6 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
-	/*
-	 * Set up the current CPU as possible to migrate to.
-	 * The other ones will be done by cpu_up/cpu_down()
-	 */
-	set_cpu_active(smp_processor_id(), true);
-
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
@@ -486,6 +480,7 @@ static void __init boot_cpu_init(void)
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
 	set_cpu_online(cpu, true);
+	set_cpu_active(cpu, true);
 	set_cpu_present(cpu, true);
 	set_cpu_possible(cpu, true);
 }
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 291ac58..1c8ddd6 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -209,6 +209,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -ENOMEM;
 
 	cpu_hotplug_begin();
+	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -280,18 +281,6 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	set_cpu_active(cpu, false);
-
-	/*
-	 * Make sure the all cpus did the reschedule and are not
-	 * using stale version of the cpu_active_mask.
-	 * This is not strictly necessary becuase stop_machine()
-	 * that we run down the line already provides the required
-	 * synchronization. But it's really a side effect and we do not
-	 * want to depend on the innards of the stop_machine here.
-	 */
-	synchronize_sched();
-
 	err = _cpu_down(cpu, 0);
 
 out:
@@ -382,19 +371,12 @@ int disable_nonboot_cpus(void)
 		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
-	/* We take down all of the non-boot CPUs in one shot to avoid races
+	/*
+	 * We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
 
-	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
-			continue;
-		set_cpu_active(cpu, false);
-	}
-
-	synchronize_sched();
-
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
diff --git a/kernel/kthread.c b/kernel/kthread.c
index ab7ae57..fbb6222 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -150,6 +150,29 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 EXPORT_SYMBOL(kthread_create);
 
 /**
+ * kthread_bind - bind a just-created kthread to a cpu.
+ * @p: thread created by kthread_create().
+ * @cpu: cpu (might not be online, must be possible) for @k to run on.
+ *
+ * Description: This function is equivalent to set_cpus_allowed(),
+ * except that @cpu doesn't need to be online, and the thread must be
+ * stopped (i.e., just returned from kthread_create()).
+ */
+void kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
+		WARN_ON(1);
+		return;
+	}
+
+	p->cpus_allowed = cpumask_of_cpu(cpu);
+	p->rt.nr_cpus_allowed = 1;
+	p->flags |= PF_THREAD_BOUND;
+}
+EXPORT_SYMBOL(kthread_bind);
+
+/**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
diff --git a/kernel/sched.c b/kernel/sched.c
index 18cceee..720df10 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -26,6 +26,8 @@
  *              Thomas Gleixner, Mike Kravetz
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
@@ -2002,39 +2004,6 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		p->sched_class->prio_changed(rq, p, oldprio, running);
 }
 
-/**
- * kthread_bind - bind a just-created kthread to a cpu.
- * @p: thread created by kthread_create().
- * @cpu: cpu (might not be online, must be possible) for @k to run on.
- *
- * Description: This function is equivalent to set_cpus_allowed(),
- * except that @cpu doesn't need to be online, and the thread must be
- * stopped (i.e., just returned from kthread_create()).
- *
- * Function lives here instead of kthread.c because it messes with
- * scheduler internals which require locking.
- */
-void kthread_bind(struct task_struct *p, unsigned int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	raw_spin_lock_irqsave(&rq->lock, flags);
-	update_rq_clock(rq);
-	set_task_cpu(p, cpu);
-	p->cpus_allowed = cpumask_of_cpu(cpu);
-	p->rt.nr_cpus_allowed = 1;
-	p->flags |= PF_THREAD_BOUND;
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
-}
-EXPORT_SYMBOL(kthread_bind);
-
 #ifdef CONFIG_SMP
 /*
  * Is this task likely cache-hot:
@@ -2044,6 +2013,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 {
 	s64 delta;
 
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
@@ -2052,9 +2024,6 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
 
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
 	if (sysctl_sched_migration_cost == -1)
 		return 1;
 	if (sysctl_sched_migration_cost == 0)
@@ -2065,22 +2034,24 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
-
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
-	int old_cpu = task_cpu(p);
-	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
-		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
+#ifdef CONFIG_SCHED_DEBUG
+	/*
+	 * We should never call set_task_cpu() on a blocked task,
+	 * ttwu() will sort out the placement.
+	 */
+	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
+			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+#endif
 
 	trace_sched_migrate_task(p, new_cpu);
 
-	if (old_cpu != new_cpu) {
-		p->se.nr_migrations++;
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
-				     1, 1, NULL, 0);
-	}
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
+	if (task_cpu(p) == new_cpu)
+		return;
+
+	p->se.nr_migrations++;
+	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
 
 	__set_task_cpu(p, new_cpu);
 }
@@ -2105,13 +2076,10 @@ migrate_task(struct task_struct *p, int dest_cpu, struct migration_req *req)
 
 	/*
 	 * If the task is not on a runqueue (and not running), then
-	 * it is sufficient to simply update the task's cpu field.
+	 * the next wake-up will properly place the task.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p)) {
-		update_rq_clock(rq);
-		set_task_cpu(p, dest_cpu);
+	if (!p->se.on_rq && !task_running(rq, p))
 		return 0;
-	}
 
 	init_completion(&req->done);
 	req->task = p;
@@ -2317,10 +2285,73 @@ void task_oncpu_function_call(struct task_struct *p,
 }
 
 #ifdef CONFIG_SMP
+static int select_fallback_rq(int cpu, struct task_struct *p)
+{
+	int dest_cpu;
+	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+
+	/* Look for allowed, online CPU in same node. */
+	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+			return dest_cpu;
+
+	/* Any allowed, online CPU? */
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	if (dest_cpu < nr_cpu_ids)
+		return dest_cpu;
+
+	/* No more Mr. Nice Guy. */
+	if (dest_cpu >= nr_cpu_ids) {
+		rcu_read_lock();
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		rcu_read_unlock();
+		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk(KERN_INFO "process %d (%s) no "
+			       "longer affine to cpu%d\n",
+			       task_pid_nr(p), p->comm, cpu);
+		}
+	}
+
+	return dest_cpu;
+}
+
+/*
+ * Called from:
+ *
+ *  - fork, @p is stable because it isn't on the tasklist yet
+ *
+ *  - exec, @p is unstable, retry loop
+ *
+ *  - wake-up, we serialize ->cpus_allowed against TASK_WAKING so
+ *             we should be good.
+ */
 static inline
 int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+
+	/*
+	 * In order not to call set_task_cpu() on a blocking task we need
+	 * to rely on ttwu() to place the task on a valid ->cpus_allowed
+	 * cpu.
+	 *
+	 * Since this is common to all placement strategies, this lives here.
+	 *
+	 * [ this allows ->select_task() to simply return task_cpu(p) and
+	 *   not worry about this generic constraint ]
+	 */
+	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
+		     !cpu_active(cpu)))
+		cpu = select_fallback_rq(task_cpu(p), p);
+
+	return cpu;
 }
 #endif
 
@@ -2375,6 +2406,10 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
+
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(rq, p);
+
 	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
@@ -2438,8 +2473,8 @@ out_running:
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 
 	if (unlikely(rq->idle_stamp)) {
 		u64 delta = rq->clock - rq->idle_stamp;
@@ -2538,14 +2573,6 @@ static void __sched_fork(struct task_struct *p)
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
-
-	/*
-	 * We mark the process as running here, but have not actually
-	 * inserted it onto the runqueue yet. This guarantees that
-	 * nobody will actually run it, and a signal or other external
-	 * event cannot wake it up and insert it on the runqueue either.
-	 */
-	p->state = TASK_RUNNING;
 }
 
 /*
@@ -2556,6 +2583,12 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	int cpu = get_cpu();
 
 	__sched_fork(p);
+	/*
+	 * We mark the process as waking here. This guarantees that
+	 * nobody will actually run it, and a signal or other external
+	 * event cannot wake it up and insert it on the runqueue either.
+	 */
+	p->state = TASK_WAKING;
 
 	/*
 	 * Revert to default priority/policy on fork if requested.
@@ -2624,14 +2657,15 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	BUG_ON(p->state != TASK_RUNNING);
+	BUG_ON(p->state != TASK_WAKING);
+	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
 }
@@ -3101,21 +3135,36 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 }
 
 /*
- * If dest_cpu is allowed for this process, migrate the task to it.
- * This is accomplished by forcing the cpu_allowed mask to only
- * allow dest_cpu, which will force the cpu onto dest_cpu. Then
- * the cpu_allowed mask is restored.
+ * sched_exec - execve() is a valuable balancing opportunity, because at
+ * this point the task has the smallest effective memory and cache footprint.
  */
-static void sched_migrate_task(struct task_struct *p, int dest_cpu)
+void sched_exec(void)
 {
+	struct task_struct *p = current;
 	struct migration_req req;
+	int dest_cpu, this_cpu;
 	unsigned long flags;
 	struct rq *rq;
 
+again:
+	this_cpu = get_cpu();
+	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	if (dest_cpu == this_cpu) {
+		put_cpu();
+		return;
+	}
+
 	rq = task_rq_lock(p, &flags);
+	put_cpu();
+
+	/*
+	 * select_task_rq() can race against ->cpus_allowed
+	 */
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu)))
-		goto out;
+	    || unlikely(!cpu_active(dest_cpu))) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
 
 	/* force the process onto the specified CPU */
 	if (migrate_task(p, dest_cpu, &req)) {
@@ -3130,24 +3179,10 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 
 		return;
 	}
-out:
 	task_rq_unlock(rq, &flags);
 }
 
 /*
- * sched_exec - execve() is a valuable balancing opportunity, because at
- * this point the task has the smallest effective memory and cache footprint.
- */
-void sched_exec(void)
-{
-	int new_cpu, this_cpu = get_cpu();
-	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
-	put_cpu();
-	if (new_cpu != this_cpu)
-		sched_migrate_task(current, new_cpu);
-}
-
-/*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
  */
@@ -5340,8 +5375,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
 {
 	struct pt_regs *regs = get_irq_regs();
 
-	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
-		prev->comm, prev->pid, preempt_count());
+	pr_err("BUG: scheduling while atomic: %s/%d/0x%08x\n",
+	       prev->comm, prev->pid, preempt_count());
 
 	debug_show_held_locks(prev);
 	print_modules();
@@ -5911,14 +5946,15 @@ EXPORT_SYMBOL(wait_for_completion_killable);
  */
 bool try_wait_for_completion(struct completion *x)
 {
+	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irq(&x->wait.lock);
+	spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
 	else
 		x->done--;
-	spin_unlock_irq(&x->wait.lock);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(try_wait_for_completion);
@@ -5933,12 +5969,13 @@ EXPORT_SYMBOL(try_wait_for_completion);
  */
 bool completion_done(struct completion *x)
 {
+	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irq(&x->wait.lock);
+	spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
-	spin_unlock_irq(&x->wait.lock);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(completion_done);
@@ -6457,7 +6494,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (p) {
 		retval = security_task_getscheduler(p);
@@ -6465,7 +6502,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
 			retval = p->policy
 				| (p->sched_reset_on_fork ? SCHED_RESET_ON_FORK : 0);
 	}
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
@@ -6483,7 +6520,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	if (!param || pid < 0)
 		return -EINVAL;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	retval = -ESRCH;
 	if (!p)
@@ -6494,7 +6531,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 		goto out_unlock;
 
 	lp.sched_priority = p->rt_priority;
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/*
 	 * This one might sleep, we cannot do it with a spinlock held ...
@@ -6504,7 +6541,7 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
@@ -6515,22 +6552,18 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
 	if (!p) {
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 		put_online_cpus();
 		return -ESRCH;
 	}
 
-	/*
-	 * It is not safe to call set_cpus_allowed with the
-	 * tasklist_lock held. We will bump the task_struct's
-	 * usage count and then drop tasklist_lock.
-	 */
+	/* Prevent p going away */
 	get_task_struct(p);
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
 		retval = -ENOMEM;
@@ -6616,7 +6649,7 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	int retval;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -6632,7 +6665,7 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	task_rq_unlock(rq, &flags);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	put_online_cpus();
 
 	return retval;
@@ -6876,7 +6909,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 		return -EINVAL;
 
 	retval = -ESRCH;
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	if (!p)
 		goto out_unlock;
@@ -6889,13 +6922,13 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 	time_slice = p->sched_class->get_rr_interval(rq, p);
 	task_rq_unlock(rq, &flags);
 
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 	return retval;
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return retval;
 }
 
@@ -6907,23 +6940,23 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-13.13s %c", p->comm,
+	pr_info("%-13.13s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT " running  ");
+		pr_cont(" running  ");
 	else
-		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
+		pr_cont(" %08lx ", thread_saved_pc(p));
 #else
 	if (state == TASK_RUNNING)
-		printk(KERN_CONT "  running task    ");
+		pr_cont("  running task    ");
 	else
-		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
+		pr_cont(" %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
+	pr_cont("%5lu %5d %6d 0x%08lx\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent),
 		(unsigned long)task_thread_info(p)->flags);
 
@@ -6935,11 +6968,9 @@ void show_state_filter(unsigned long state_filter)
 	struct task_struct *g, *p;
 
 #if BITS_PER_LONG == 32
-	printk(KERN_INFO
-		"  task                PC stack   pid father\n");
+	pr_info("  task                PC stack   pid father\n");
 #else
-	printk(KERN_INFO
-		"  task                        PC stack   pid father\n");
+	pr_info("  task                        PC stack   pid father\n");
 #endif
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
@@ -6986,6 +7017,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	__sched_fork(idle);
+	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
@@ -7100,7 +7132,23 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	struct rq *rq;
 	int ret = 0;
 
+	/*
+	 * Since we rely on wake-ups to migrate sleeping tasks, don't change
+	 * the ->cpus_allowed mask from under waking tasks, which would be
+	 * possible when we change rq->lock in ttwu(), so synchronize against
+	 * TASK_WAKING to avoid that.
+	 */
+again:
+	while (p->state == TASK_WAKING)
+		cpu_relax();
+
 	rq = task_rq_lock(p, &flags);
+
+	if (p->state == TASK_WAKING) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
+
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
@@ -7156,7 +7204,7 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
 	struct rq *rq_dest, *rq_src;
-	int ret = 0, on_rq;
+	int ret = 0;
 
 	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
@@ -7172,12 +7220,13 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;
 
-	on_rq = p->se.on_rq;
-	if (on_rq)
+	/*
+	 * If we're not on a rq, the next wake-up will ensure we're
+	 * placed properly.
+	 */
+	if (p->se.on_rq) {
 		deactivate_task(rq_src, p, 0);
-
-	set_task_cpu(p, dest_cpu);
-	if (on_rq) {
+		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
 		check_preempt_curr(rq_dest, p, 0);
 	}
@@ -7273,37 +7322,10 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	int dest_cpu;
-	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
 
 again:
-	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
-			goto move;
-
-	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
-	if (dest_cpu < nr_cpu_ids)
-		goto move;
-
-	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
-
-		/*
-		 * Don't tell them about moving exiting tasks or
-		 * kernel threads (both mm NULL), since they never
-		 * leave kernel.
-		 */
-		if (p->mm && printk_ratelimit()) {
-			printk(KERN_INFO "process %d (%s) no "
-			       "longer affine to cpu%d\n",
-			       task_pid_nr(p), p->comm, dead_cpu);
-		}
-	}
+	dest_cpu = select_fallback_rq(dead_cpu, p);
 
-move:
 	/* It can have affinity changed while we were choosing. */
 	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
 		goto again;
@@ -7806,48 +7828,44 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
 	if (!(sd->flags & SD_LOAD_BALANCE)) {
-		printk("does not load-balance\n");
+		pr_cont("does not load-balance\n");
 		if (sd->parent)
-			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
-					" has parent");
+			pr_err("ERROR: !SD_LOAD_BALANCE domain has parent\n");
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	pr_cont("span %s level %s\n", str, sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-		printk(KERN_ERR "ERROR: domain->span does not contain "
-				"CPU%d\n", cpu);
+		pr_err("ERROR: domain->span does not contain CPU%d\n", cpu);
 	}
 	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
-		printk(KERN_ERR "ERROR: domain->groups does not contain"
-				" CPU%d\n", cpu);
+		pr_err("ERROR: domain->groups does not contain CPU%d\n", cpu);
 	}
 
 	printk(KERN_DEBUG "%*s groups:", level + 1, "");
 	do {
 		if (!group) {
-			printk("\n");
-			printk(KERN_ERR "ERROR: group is NULL\n");
+			pr_cont("\n");
+			pr_err("ERROR: group is NULL\n");
 			break;
 		}
 
 		if (!group->cpu_power) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: domain->cpu_power not "
-					"set\n");
+			pr_cont("\n");
+			pr_err("ERROR: domain->cpu_power not set\n");
 			break;
 		}
 
 		if (!cpumask_weight(sched_group_cpus(group))) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: empty group\n");
+			pr_cont("\n");
+			pr_err("ERROR: empty group\n");
 			break;
 		}
 
 		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
-			printk(KERN_CONT "\n");
-			printk(KERN_ERR "ERROR: repeated CPUs\n");
+			pr_cont("\n");
+			pr_err("ERROR: repeated CPUs\n");
 			break;
 		}
 
@@ -7855,23 +7873,21 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
-		printk(KERN_CONT " %s", str);
+		pr_cont(" %s", str);
 		if (group->cpu_power != SCHED_LOAD_SCALE) {
-			printk(KERN_CONT " (cpu_power = %d)",
-				group->cpu_power);
+			pr_cont(" (cpu_power = %d)", group->cpu_power);
 		}
 
 		group = group->next;
 	} while (group != sd->groups);
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 
 	if (!cpumask_equal(sched_domain_span(sd), groupmask))
-		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
+		pr_err("ERROR: groups don't span domain->span\n");
 
 	if (sd->parent &&
 	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
-		printk(KERN_ERR "ERROR: parent span is not a superset "
-			"of domain->span\n");
+		pr_err("ERROR: parent span is not a superset of domain->span\n");
 	return 0;
 }
 
@@ -8427,8 +8443,7 @@ static int build_numa_sched_groups(struct s_data *d,
 	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 			  GFP_KERNEL, num);
 	if (!sg) {
-		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
-		       num);
+		pr_warning("Can not alloc domain group for node %d\n", num);
 		return -ENOMEM;
 	}
 	d->sched_group_nodes[num] = sg;
@@ -8457,8 +8472,8 @@ static int build_numa_sched_groups(struct s_data *d,
 		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
 				  GFP_KERNEL, num);
 		if (!sg) {
-			printk(KERN_WARNING
-			       "Can not alloc domain group for node %d\n", j);
+			pr_warning("Can not alloc domain group for node %d\n",
+				   j);
 			return -ENOMEM;
 		}
 		sg->cpu_power = 0;
@@ -8686,7 +8701,7 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 	d->sched_group_nodes = kcalloc(nr_node_ids,
 				      sizeof(struct sched_group *), GFP_KERNEL);
 	if (!d->sched_group_nodes) {
-		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		pr_warning("Can not alloc sched group node list\n");
 		return sa_notcovered;
 	}
 	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
@@ -8703,7 +8718,7 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 		return sa_send_covered;
 	d->rd = alloc_rootdomain();
 	if (!d->rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
+		pr_warning("Cannot alloc root domain\n");
 		return sa_tmpmask;
 	}
 	return sa_rootdomain;
@@ -9668,7 +9683,7 @@ void __init sched_init(void)
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
-	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
 
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }
@@ -9685,13 +9700,11 @@ void __might_sleep(char *file, int line, int preempt_offset)
 		return;
 	prev_jiffy = jiffies;
 
-	printk(KERN_ERR
-		"BUG: sleeping function called from invalid context at %s:%d\n",
-			file, line);
-	printk(KERN_ERR
-		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
-			in_atomic(), irqs_disabled(),
-			current->pid, current->comm);
+	pr_err("BUG: sleeping function called from invalid context at %s:%d\n",
+	       file, line);
+	pr_err("in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
+	       in_atomic(), irqs_disabled(),
+	       current->pid, current->comm);
 
 	debug_show_held_locks(current);
 	if (irqs_disabled())
@@ -10083,7 +10096,7 @@ void sched_move_task(struct task_struct *tsk)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk);
+		tsk->sched_class->moved_group(tsk, on_rq);
 #endif
 
 	if (unlikely(running))
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 479ce56..5b49613 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -236,6 +236,18 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
+unsigned long long cpu_clock(int cpu)
+{
+	unsigned long long clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(cpu);
+	local_irq_restore(flags);
+
+	return clock;
+}
+
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 void sched_clock_init(void)
@@ -251,17 +263,12 @@ u64 sched_clock_cpu(int cpu)
 	return sched_clock();
 }
 
-#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 unsigned long long cpu_clock(int cpu)
 {
-	unsigned long long clock;
-	unsigned long flags;
+	return sched_clock_cpu(cpu);
+}
 
-	local_irq_save(flags);
-	clock = sched_clock_cpu(cpu);
-	local_irq_restore(flags);
+#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
-	return clock;
-}
 EXPORT_SYMBOL_GPL(cpu_clock);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5bedf6e..42ac3c9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -510,6 +510,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
 }
@@ -765,16 +766,26 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
+#define ENQUEUE_WAKEUP	1
+#define ENQUEUE_MIGRATE 2
+
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
+	 * Update the normalized vruntime before updating min_vruntime
+	 * through callig update_curr().
+	 */
+	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_MIGRATE))
+		se->vruntime += cfs_rq->min_vruntime;
+
+	/*
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
 	account_entity_enqueue(cfs_rq, se);
 
-	if (wakeup) {
+	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
 	}
@@ -828,6 +839,14 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
+
+	/*
+	 * Normalize the entity after updating the min_vruntime because the
+	 * update can refer to the ->curr item and we need to reflect this
+	 * movement in our normalized position.
+	 */
+	if (!sleep)
+		se->vruntime -= cfs_rq->min_vruntime;
 }
 
 /*
@@ -1038,13 +1057,19 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int flags = 0;
+
+	if (wakeup)
+		flags |= ENQUEUE_WAKEUP;
+	if (p->state == TASK_WAKING)
+		flags |= ENQUEUE_MIGRATE;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
-		wakeup = 1;
+		enqueue_entity(cfs_rq, se, flags);
+		flags = ENQUEUE_WAKEUP;
 	}
 
 	hrtick_update(rq);
@@ -1120,6 +1145,14 @@ static void yield_task_fair(struct rq *rq)
 
 #ifdef CONFIG_SMP
 
+static void task_waking_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	se->vruntime -= cfs_rq->min_vruntime;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group
@@ -1429,6 +1462,9 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	}
 
 	for_each_domain(cpu, tmp) {
+		if (!(tmp->flags & SD_LOAD_BALANCE))
+			continue;
+
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
@@ -1975,6 +2011,8 @@ static void task_fork_fair(struct task_struct *p)
 		resched_task(rq->curr);
 	}
 
+	se->vruntime -= cfs_rq->min_vruntime;
+
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -2028,12 +2066,13 @@ static void set_curr_task_fair(struct rq *rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p)
+static void moved_group_fair(struct task_struct *p, int on_rq)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_curr(cfs_rq);
-	place_entity(cfs_rq, &p->se, 1);
+	if (!on_rq)
+		place_entity(cfs_rq, &p->se, 1);
 }
 #endif
 
@@ -2073,6 +2112,8 @@ static const struct sched_class fair_sched_class = {
 	.move_one_task		= move_one_task_fair,
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
+
+	.task_waking		= task_waking_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 5f93b57..21b969a 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -35,7 +35,7 @@ static void
 dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
 {
 	raw_spin_unlock_irq(&rq->lock);
-	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
+	pr_err("bad: scheduling from the idle thread!\n");
 	dump_stack();
 	raw_spin_lock_irq(&rq->lock);
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index d2ea282..f48328a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1472,7 +1472,7 @@ static void post_schedule_rt(struct rq *rq)
  * If we are not running and we are not going to reschedule soon, we should
  * try to push tasks away now
  */
-static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
+static void task_woken_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
@@ -1753,7 +1753,7 @@ static const struct sched_class rt_sched_class = {
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
-	.task_wake_up		= task_wake_up_rt,
+	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
 #endif
 
