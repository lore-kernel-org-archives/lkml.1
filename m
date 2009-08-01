Return-Path: <linux-kernel-owner+w=401wt.eu-S1751701AbZHAEuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbZHAEuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 00:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZHAEuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 00:50:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZHAEuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 00:50:37 -0400
Date: Sat, 1 Aug 2009 06:42:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] cpusets: rework guarantee_online_cpus() to fix deadlock
	with cpu_down()
Message-ID: <20090801044236.GA23975@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com> <20090730175108.GC3617@redhat.com> <4A725594.8020205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A725594.8020205@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Lai Jiangshan wrote:
>
>
> We can add cpuset_lock()/cpuset_unlock() around __stop_machine()
> in _cpu_down().

Yes I think this should work. CPU_DYING must not take cpuset_lock().

But. This way cpuset_lock() becomes even more subtle (and imho fragile).

What is even more importanrt (to me ;), you didn't answer my question:
why can't we kill this awful lock??? Why can't we simplify things?


I'm almost sure I missed something. As I said I do not understand cpusets
and honestly I'd like to avoid studying it.

You forced me to make another patch, please explain what I have missed ;)

Thanks!

Oleg.

-------------------------------------------------------------------------------
[PATCH] cpusets: rework guarantee_online_cpus() to fix deadlock with cpu_down()

I strongly believe the bug does exist, but this patch needs the review
from maintainers. COMPILE TESTED.

Suppose that task T bound to CPU takes callback_mutex. If cpu_down(CPU)
happens before T drops callback_mutex we have a deadlock.

stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
cpuset_lock() and hangs forever because CPU is already dead and thus
T can't be scheduled.

This patch:

	- kills cpuset_lock() and cpuset_cpus_allowed_locked()

	- converts move_task_off_dead_cpu() to use cpuset_cpus_allowed()

	- adds cpuset->cpumask_lock, this lock is taken by
	  update_cpumask() around cpumask_copy(cs->cpus_allowed, newcpus).

	  From now we can access cs->cpus_allowed safely either under the
	  global callback_mutex or cs->cpumask_lock.

Then we change guarantee_online_cpus(),

	- take cs->cpumask_lock instead of callback_mutex

	- do NOT scan cs->parent cpusets. If there are no online CPUs in
	  cs->cpus_allowed, we use cpu_online_mask. This is only possible
	  when we are called by cpu_down() hooks, in that case
	  cpuset_track_online_cpus(CPU_DEAD) will fix things later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |   13 ----------
 kernel/sched.c         |    4 ---
 kernel/cpuset.c        |   61 +++++++++++++------------------------------------
 3 files changed, 18 insertions(+), 60 deletions(-)

--- CPUHP/include/linux/cpuset.h~CPU_SET_LOCK	2009-08-01 04:29:15.000000000 +0200
+++ CPUHP/include/linux/cpuset.h	2009-08-01 05:08:25.000000000 +0200
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
--- CPUHP/kernel/sched.c~CPU_SET_LOCK	2009-08-01 04:29:15.000000000 +0200
+++ CPUHP/kernel/sched.c	2009-08-01 05:06:36.000000000 +0200
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
--- CPUHP/kernel/cpuset.c~CPU_SET_LOCK	2009-08-01 04:29:15.000000000 +0200
+++ CPUHP/kernel/cpuset.c	2009-08-01 06:29:15.000000000 +0200
@@ -92,6 +92,7 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
+	spinlock_t cpumask_lock;	/* protects ->cpus_allowed */
 	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
@@ -267,16 +268,23 @@ static struct file_system_type cpuset_fs
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
@@ -891,7 +899,9 @@ static int update_cpumask(struct cpuset 
 	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
+	spin_lock(&cs->cpumask_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	spin_unlock(&cs->cpumask_lock);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1781,6 +1791,8 @@ static struct cgroup_subsys_state *cpuse
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&cs->cpumask_lock);
 	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
 		kfree(cs);
 		return ERR_PTR(-ENOMEM);
@@ -2097,20 +2109,8 @@ void __init cpuset_init_smp(void)
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
@@ -2302,33 +2302,6 @@ int __cpuset_node_allowed_hardwall(int n
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

