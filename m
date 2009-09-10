Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZIJTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZIJTRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZIJTRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZIJTRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:17:46 -0400
Date: Thu, 10 Sep 2009 21:13:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cpusets: rework guarantee_online_cpus() to fix
	deadlock with cpu_down()
Message-ID: <20090910191351.GA32647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose that task T bound to CPU takes callback_mutex. If cpu_down(CPU)
happens before T drops callback_mutex we have a deadlock.

stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
cpuset_lock() and hangs forever because CPU is already dead and thus
T can't be scheduled.

To simplify the testing, I added schedule_timeout_interruptible(3*HZ)
to cpuset_sprintf_cpulist() under mutex_lock(callback_mutex). Then,

	mkdir -p /dev/cpuset
	mount -t cgroup -ocpuset cpuset /dev/cpuset
	mkdir -p /dev/cpuset/XXX
	taskset -p 2 $$
	cat /dev/cpuset/XXX/cpuset.cpus

and, on another console,

	echo 0 >> /sys/devices/system/cpu/cpu1/online

Before this patch cpuset/hotplug subsytems deadlock, after this patch
everething is OK.

Since the previous patch we can access cs->cpus_allowed safely either
under the global callback_mutex or cs->cpumask_lock.

This patch:

	- kills cpuset_lock() and cpuset_cpus_allowed_locked()

	- converts move_task_off_dead_cpu() to use cpuset_cpus_allowed()

Then we change guarantee_online_cpus(),

	- take cs->cpumask_lock instead of callback_mutex

	- do NOT scan cs->parent cpusets. If there are no online CPUs in
	  cs->cpus_allowed, we use cpu_online_mask. This is only possible
	  when we are called by cpu_down() hooks, in that case
	  cpuset_track_online_cpus(CPU_DEAD) will fix things later.

In particular, this all means sched_setaffinity() takes the per cpuset
spinlock instead of global callback_mutex, and hotplug can forget about
complications added by cpusets.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |   13 -----------
 kernel/sched.c         |    4 ---
 kernel/cpuset.c        |   56 ++++++++++---------------------------------------
 3 files changed, 13 insertions(+), 60 deletions(-)

--- CPUHP/include/linux/cpuset.h~2_KILL_CPUSET_LOCK	2009-09-10 18:48:25.000000000 +0200
+++ CPUHP/include/linux/cpuset.h	2009-09-10 20:27:29.000000000 +0200
@@ -21,8 +21,6 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p,
-				       struct cpumask *mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -69,9 +67,6 @@ struct seq_file;
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -105,11 +100,6 @@ static inline void cpuset_cpus_allowed(s
 {
 	cpumask_copy(mask, cpu_possible_mask);
 }
-static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-					      struct cpumask *mask)
-{
-	cpumask_copy(mask, cpu_possible_mask);
-}
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
@@ -157,9 +147,6 @@ static inline void cpuset_task_status_al
 {
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
--- CPUHP/kernel/sched.c~2_KILL_CPUSET_LOCK	2009-09-10 18:48:25.000000000 +0200
+++ CPUHP/kernel/sched.c	2009-09-10 20:27:29.000000000 +0200
@@ -7136,7 +7136,7 @@ again:
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu >= nr_cpu_ids) {
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		cpuset_cpus_allowed(p, &p->cpus_allowed);
 		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
 
 		/*
@@ -7550,7 +7550,6 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -7565,7 +7564,6 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);
--- CPUHP/kernel/cpuset.c~2_KILL_CPUSET_LOCK	2009-09-10 20:06:39.000000000 +0200
+++ CPUHP/kernel/cpuset.c	2009-09-10 20:28:11.000000000 +0200
@@ -268,16 +268,23 @@ static struct file_system_type cpuset_fs
  * Call with callback_mutex held.
  */
 
-static void guarantee_online_cpus(const struct cpuset *cs,
-				  struct cpumask *pmask)
+static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
 {
-	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
-		cs = cs->parent;
 	if (cs)
+		spin_lock(&cs->cpumask_lock);
+	/*
+	 * cs->cpus_allowed must include online CPUs, or we are called
+	 * from cpu_down() hooks. In that case use cpu_online_mask
+	 * temporary until scan_for_empty_cpusets() moves us to ->parent
+	 * cpuset.
+	 */
+	if (cs && cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 	else
 		cpumask_copy(pmask, cpu_online_mask);
-	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
+
+	if (cs)
+		spin_unlock(&cs->cpumask_lock);
 }
 
 /*
@@ -2106,20 +2113,8 @@ void __init cpuset_init_smp(void)
  * subset of cpu_online_map, even if this means going outside the
  * tasks cpuset.
  **/
-
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
-	mutex_lock(&callback_mutex);
-	cpuset_cpus_allowed_locked(tsk, pmask);
-	mutex_unlock(&callback_mutex);
-}
-
-/**
- * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be called with callback_mutex held.
- **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
-{
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);
 	task_unlock(tsk);
@@ -2311,33 +2306,6 @@ int __cpuset_node_allowed_hardwall(int n
 }
 
 /**
- * cpuset_lock - lock out any changes to cpuset structures
- *
- * The out of memory (oom) code needs to mutex_lock cpusets
- * from being changed while it scans the tasklist looking for a
- * task in an overlapping cpuset.  Expose callback_mutex via this
- * cpuset_lock() routine, so the oom code can lock it, before
- * locking the task list.  The tasklist_lock is a spinlock, so
- * must be taken inside callback_mutex.
- */
-
-void cpuset_lock(void)
-{
-	mutex_lock(&callback_mutex);
-}
-
-/**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a page
  *
  * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for

