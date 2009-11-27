Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZK0MVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZK0MVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZK0MVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:21:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:41817 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZK0MVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:21:37 -0500
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259322921.3878.28.camel@marge.simson.net>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259252785.31676.216.camel@laptop>
	 <1259322921.3878.28.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 13:21:39 +0100
Message-ID: <1259324499.6483.257.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm poking at it like so...

the below hasn't yet seen a compiler and I know there to still be a few
races in the ttwu() path.


---
 include/linux/sched.h |    6 +-
 kernel/fork.c         |    2 +-
 kernel/sched.c        |  170 +++++++++++++++++++++++++++++++------------------
 kernel/sched_fair.c   |   26 +++----
 4 files changed, 124 insertions(+), 80 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c46023..ff5ec5a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1099,7 +1099,7 @@ struct sched_class {
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
+	void (*fork) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
@@ -2456,7 +2456,7 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return task_thread_info(p)->cpu;
 }
 
-extern void set_task_cpu(struct task_struct *p, unsigned int cpu);
+extern void set_task_cpu_locked(struct task_struct *p, int cpu);
 
 #else
 
@@ -2465,7 +2465,7 @@ static inline unsigned int task_cpu(const struct task_struct *p)
 	return 0;
 }
 
-static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
+static inline void set_task_cpu_locked(struct task_struct *p, int cpu)
 {
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..29c4aec 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1242,7 +1242,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
-		set_task_cpu(p, smp_processor_id());
+		set_task_cpu_locked(p, smp_processor_id());
 
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 0cbf2ef..dced5af 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1967,7 +1967,7 @@ inline int task_curr(const struct task_struct *p)
 	return cpu_curr(task_cpu(p)) == p;
 }
 
-static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
+static inline void raw_set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
@@ -2008,6 +2008,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 void kthread_bind(struct task_struct *p, unsigned int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	struct rq *old_rq = task_rq(p);
 	unsigned long flags;
 
 	/* Must have done schedule() in kthread() before we set_task_cpu */
@@ -2016,13 +2017,14 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 		return;
 	}
 
-	spin_lock_irqsave(&rq->lock, flags);
-	update_rq_clock(rq);
+	local_irq_save(flags);
+	double_rq_lock(old_rq, rq);
 	set_task_cpu(p, cpu);
 	p->cpus_allowed = cpumask_of_cpu(cpu);
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
-	spin_unlock_irqrestore(&rq->lock, flags);
+	double_rq_unlock(old_rq, rq);
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(kthread_bind);
 
@@ -2056,40 +2058,101 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+static void set_task_cpu_all(struct task_struct *p, int old_cpu, int new_cpu)
+{
+	trace_sched_migrate_task(p, new_cpu);
+
+	p->se.nr_migrations++;
+#ifdef CONFIG_SCHEDSTATS
+	if (task_hot(p, old_rq->clock, NULL))
+		schedstat_inc(p, se.nr_forced2_migrations);
+#endif
+	perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
+
+	raw_set_task_cpu(p, new_cpu);
+}
 
-void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
+static void set_task_cpu(struct task_struct *p, int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
-	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
-		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
-	u64 clock_offset;
 
-	clock_offset = old_rq->clock - new_rq->clock;
+	if (old_cpu == new_cpu)
+		return;
 
-	trace_sched_migrate_task(p, new_cpu);
+	if (p->sched_class == &fair_sched_class) {
+		struct cfs_rq *old_cfsrq = task_cfs_rq(p),
+			      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 
-#ifdef CONFIG_SCHEDSTATS
-	if (p->se.wait_start)
-		p->se.wait_start -= clock_offset;
-	if (p->se.sleep_start)
-		p->se.sleep_start -= clock_offset;
-	if (p->se.block_start)
-		p->se.block_start -= clock_offset;
-#endif
-	if (old_cpu != new_cpu) {
-		p->se.nr_migrations++;
-#ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, old_rq->clock, NULL))
-			schedstat_inc(p, se.nr_forced2_migrations);
-#endif
-		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
-				     1, 1, NULL, 0);
+		p->se.vruntime -= old_cfsrq->min_vruntime -
+			new_cfsrq->min_vruntime;
+	}
+
+	set_task_cpu_all(p, old_cpu, new_cpu);
+}
+
+static inline
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+{
+	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+}
+
+/*
+ * self balance a task without holding both rq locks
+ *
+ * used by fork and wakeup, since in neither case the task was present
+ * on a rq the load-balancer wouldn't encounter it and move it away
+ * underneath us.
+ *
+ * and since we have IRQs disabled we keep off hot-unplug.
+ */
+static struct rq *
+balance_task(struct task_struct *p, int sd_flags, int wake_flags)
+{
+	struct rq *rq, *old_rq;
+	u64 vdelta;
+
+       	rq = old_rq = task_rq(p);
+
+	if (p->sched_class == &fair_sched_class)
+		vdelta = task_cfs_rq(p)->min_vruntime;
+
+	__task_rq_unlock(old_rq);
+
+	cpu = select_task_rq(p, sd_flags, wake_flags);
+
+	rq = cpu_rq(cpu);
+	spin_lock(&rq->lock);
+	if (rq == old_rq)
+		return rq;
+
+	update_rq_clock(rq);
+
+	set_task_cpu_all(p, task_cpu(p), cpu);
+
+	if (p->sched_class == &fair_sched_class) {
+		vdelta -= task_cfs_rq(p)->min_vruntime;
+		p->se.vruntime -= vdelta;
 	}
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
 
-	__set_task_cpu(p, new_cpu);
+	return rq;
+}
+
+void set_task_cpu_locked(struct task_struct *p, int new_cpu)
+{
+	struct rq *old_rq = task_rq(p);
+	struct rq *new_rq = cpu_rq(new_cpu);
+	unsigned long flags;
+
+	local_irq_save(flags);
+	double_rq_lock(old_rq, new_rq);
+	/*
+	 * called from fork() on the child task before it gets
+	 * put on the tasklist, no way we could've been migrated
+	 */
+	WARN_ON_ONCE(old_rq != task_rq(p));
+	set_task_cpu(p, new_cpu);
+	double_rq_unlock(old_rq, new_rq);
+	local_irq_restore(flags);
 }
 
 struct migration_req {
@@ -2373,19 +2436,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	 */
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
+
 	p->state = TASK_WAKING;
+	rq = balance_task(p, SD_BALANCE_WAKE, wake_flags);
 	task_rq_unlock(rq, &flags);
 
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu) {
-		local_irq_save(flags);
-		rq = cpu_rq(cpu);
-		update_rq_clock(rq);
-		set_task_cpu(p, cpu);
-		local_irq_restore(flags);
-	}
-	rq = task_rq_lock(p, &flags);
-
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
@@ -2557,8 +2612,9 @@ static void __sched_fork(struct task_struct *p)
  */
 void sched_fork(struct task_struct *p, int clone_flags)
 {
-	int cpu = get_cpu();
 	unsigned long flags;
+	struct *rq;
+	int cpu;
 
 	__sched_fork(p);
 
@@ -2592,13 +2648,15 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
-#ifdef CONFIG_SMP
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
-#endif
-	local_irq_save(flags);
-	update_rq_clock(cpu_rq(cpu));
-	set_task_cpu(p, cpu);
-	local_irq_restore(flags);
+	rq = task_rq_lock(current, &flags);
+	update_rq_clock(rq);
+
+	if (p->sched_class->fork)
+		p->sched_class->fork(p);
+
+	rq = balance_task(p, SD_BALANCE_FORK, 0);
+	task_rq_unlock(rq, &flags);
+
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2631,17 +2689,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
-
-	if (!p->sched_class->task_new || !current->se.on_rq) {
-		activate_task(rq, p, 0);
-	} else {
-		/*
-		 * Let the scheduling class do new task startup
-		 * management (if any):
-		 */
-		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
-	}
+	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
@@ -3156,7 +3204,7 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
+	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);
@@ -6980,7 +7028,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
-	__set_task_cpu(idle, cpu);
+	raw_set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0ff21af..7c27d2f 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1922,28 +1922,26 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 }
 
 /*
- * Share the fairness runtime between parent and child, thus the
- * total amount of pressure for CPU stays equal - new tasks
- * get a chance to run but frequent forkers are not allowed to
- * monopolize the CPU. Note: the parent runqueue is locked,
- * the child is not running yet.
+ * Called at fork, before the child is on the tasklist and before
+ * self-balance, current (parent) his rq is locked.
  */
-static void task_new_fair(struct rq *rq, struct task_struct *p)
+static void fork_fair(struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
+	struct rq *rq = this_rq();
+	struct cfs_rq *cfs_rq = task_cfs_rq(current);
+	struct sched_entity *se = &p->se, *curr = cfs_rq-curr;
 	int this_cpu = smp_processor_id();
 
+	if (unlikely(task_cpu(p) != this_cpu))
+		raw_set_task_cpu(p, this_cpu);
+	
 	sched_info_queued(p);
-
 	update_curr(cfs_rq);
 	if (curr)
 		se->vruntime = curr->vruntime;
 	place_entity(cfs_rq, se, 1);
 
-	/* 'curr' will be NULL if the child belongs to a different group */
-	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr && entity_before(curr, se)) {
+	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
@@ -1951,8 +1949,6 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 		swap(curr->vruntime, se->vruntime);
 		resched_task(rq->curr);
 	}
-
-	enqueue_task_fair(rq, p, 0);
 }
 
 /*
@@ -2056,7 +2052,7 @@ static const struct sched_class fair_sched_class = {
 
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
-	.task_new		= task_new_fair,
+	.fork			= fork_fair,
 
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,


