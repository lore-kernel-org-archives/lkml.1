Return-Path: <linux-kernel-owner+w=401wt.eu-S1763910AbYBLTUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763910AbYBLTUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbYBLTUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:20:13 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:36107
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755774AbYBLTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:20:09 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] add task migration_disable critical section
To: rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Tue, 12 Feb 2008 13:30:00 -0500
Message-ID: <20080212183000.10902.97544.stgit@novell1.haskins.net>
In-Reply-To: <20080212182512.10902.66459.stgit@novell1.haskins.net>
References: <20080212182512.10902.66459.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new critical-section primitive pair:

"migration_disable()" and "migration_enable()"

This allows you to force a task to remain on the current cpu, while
still remaining fully preemptible.  This is a better alternative to
modifying current->cpus_allowed because you dont have to worry about
colliding with another entity also modifying the cpumask_t while in
the critical section.

In fact, modifying the cpumask_t while in the critical section is
fully supported, but note that the behavior of set_cpus_allowed()
has slightly different behavior.  In the old code, the mask update
was synchronous: e.g. the task would be on a legal cpu when the call
returned.  The new behavior makes this asynchronous if the task is
currently in a migration-disabled critical section.  The task will
migrate to a legal cpu once the critical section ends.

This concept will be used later in the series.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    8 +++++
 kernel/fork.c             |    1 +
 kernel/sched.c            |   70 ++++++++++++++++++++++++++++++++++++---------
 kernel/sched_rt.c         |    6 +++-
 5 files changed, 70 insertions(+), 16 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 316a184..151197b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -137,6 +137,7 @@ extern struct group_info init_groups;
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= 0,						\
 	.lock_depth	= -1,						\
+	.migration_disable_depth = 0,					\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c87d46a..ab7768a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1109,6 +1109,7 @@ struct task_struct {
 	unsigned int ptrace;
 
 	int lock_depth;		/* BKL lock depth */
+	int migration_disable_depth;
 
 #ifdef CONFIG_SMP
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
@@ -2284,10 +2285,17 @@ static inline void inc_syscw(struct task_struct *tsk)
 
 #ifdef CONFIG_SMP
 void migration_init(void);
+int migration_disable(struct task_struct *tsk);
+void migration_enable(struct task_struct *tsk);
 #else
 static inline void migration_init(void)
 {
 }
+static inline int migration_disable(struct task_struct *tsk)
+{
+	return 0;
+}
+#define migration_enable(tsk) do {} while (0)
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/kernel/fork.c b/kernel/fork.c
index 8c00b55..7745937 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1127,6 +1127,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->cpu_timers[2]);
 	p->posix_timer_list = NULL;
 	p->lock_depth = -1;		/* -1 = no lock */
+	p->migration_disable_depth = 0;
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
diff --git a/kernel/sched.c b/kernel/sched.c
index e6ad493..cf32000 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1231,6 +1231,8 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 	u64 clock_offset;
 
+	BUG_ON(p->migration_disable_depth);
+
 	clock_offset = old_rq->clock - new_rq->clock;
 
 #ifdef CONFIG_SCHEDSTATS
@@ -1632,7 +1634,9 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int sync, int mutex)
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	cpu = p->sched_class->select_task_rq(p, sync);
+	if (!p->migration_disable_depth)
+		cpu = p->sched_class->select_task_rq(p, sync);
+
 	if (cpu != orig_cpu) {
 		set_task_cpu(p, cpu);
 		task_rq_unlock(rq, &flags);
@@ -5422,11 +5426,12 @@ static inline void sched_init_granularity(void)
  */
 int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
-	struct migration_req req;
 	unsigned long flags;
 	struct rq *rq;
 	int ret = 0;
 
+	migration_disable(p);
+
 	rq = task_rq_lock(p, &flags);
 	if (!cpus_intersects(new_mask, cpu_online_map)) {
 		ret = -EINVAL;
@@ -5440,21 +5445,11 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 		p->nr_cpus_allowed = cpus_weight(new_mask);
 	}
 
-	/* Can the task run on the task's current CPU? If so, we're done */
-	if (cpu_isset(task_cpu(p), new_mask))
-		goto out;
-
-	if (migrate_task(p, any_online_cpu(new_mask), &req)) {
-		/* Need help from migration thread: drop lock and wait. */
-		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
-		wait_for_completion(&req.done);
-		tlb_migrate_finish(p->mm);
-		return 0;
-	}
 out:
 	task_rq_unlock(rq, &flags);
 
+	migration_enable(p);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(set_cpus_allowed);
@@ -7883,3 +7878,50 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+#ifdef CONFIG_SMP
+int migration_disable(struct task_struct *p)
+{
+	unsigned long flags;
+	struct rq *rq = task_rq_lock(p, &flags);
+	int cpu = raw_smp_processor_id();
+
+	p->migration_disable_depth++;
+
+	task_rq_unlock(rq, &flags);
+
+	return cpu;
+}
+EXPORT_SYMBOL(migration_disable);
+
+void migration_enable(struct task_struct *p)
+{
+	struct migration_req req;
+	unsigned long flags;
+	struct rq *rq = task_rq_lock(p, &flags);
+
+	BUG_ON(!p->migration_disable_depth);
+	p->migration_disable_depth--;
+
+	/*
+	 * If the task is still not migratable, or if it is already on
+	 * an allowed CPU, just bail out
+	 */
+	if (p->migration_disable_depth
+	    || cpu_isset(task_cpu(p), p->cpus_allowed))
+		goto out;
+
+	if (migrate_task(p, any_online_cpu(p->cpus_allowed), &req)) {
+		/* Need help from migration thread: drop lock and wait. */
+		task_rq_unlock(rq, &flags);
+		wake_up_process(rq->migration_thread);
+		wait_for_completion(&req.done);
+		tlb_migrate_finish(p->mm);
+		return;
+	}
+
+ out:
+	task_rq_unlock(rq, &flags);
+}
+EXPORT_SYMBOL(migration_enable);
+#endif
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f1b5652..bec362c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -300,7 +300,8 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
 	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)) &&
-	    (p->nr_cpus_allowed > 1))
+	    (p->nr_cpus_allowed > 1) &&
+	    !p->migration_disable_depth)
 		return 1;
 	return 0;
 }
@@ -397,7 +398,8 @@ static int find_lowest_rq(struct task_struct *task)
 	int cpu      = task_cpu(task);
 	int count;
 
-	if (task->nr_cpus_allowed == 1)
+	if (task->nr_cpus_allowed == 1
+	    || task->migration_disable_depth)
 		return -1; /* No other targets possible */
 
 	count = find_lowest_cpus(task, lowest_mask);

