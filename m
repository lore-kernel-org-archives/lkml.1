Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZG2V0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZG2V0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZG2V0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:26:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54305 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbZG2V0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:26:03 -0400
Date: Wed, 29 Jul 2009 23:22:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] cpusets: fix deadlock with cpu_down()->cpuset_lock()
Message-ID: <20090729212216.GB16970@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729212125.GA16970@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I strongly believe the bug does exist, but this patch needs the review
from maintainers.

Suppose that task T bound to CPU takes callback_mutex. If cpu_down(CPU)
happens before T drops callback_mutex we have a deadlock.

stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
cpuset_lock() and hangs forever because CPU is already dead and thus
T can't be scheduled.

This patch unexports cpuset_lock/cpuset_unlock and converts kernel/cpuset.c
to use these helpers instead of lock/unlock of callback_mutex. The only
reason for migration_call()->cpuset_lock() was cpuset_cpus_allowed_locked()
called by move_task_off_dead_cpu(), so this patch adds get_online_cpus() to
cpuset_lock().

IOW, with this patch migration_call(CPU_DEAD) runs without callback_mutex,
but kernel/cpuset.c always takes get_online_cpus() before callback_mutex.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |    6 ---
 kernel/sched.c         |    2 -
 kernel/cpuset.c        |   86 +++++++++++++++++++++----------------------------
 3 files changed, 37 insertions(+), 57 deletions(-)

--- CPUHP/include/linux/cpuset.h~CPU_SET_LOCK	2009-06-17 14:11:26.000000000 +0200
+++ CPUHP/include/linux/cpuset.h	2009-07-29 22:17:41.000000000 +0200
@@ -69,9 +69,6 @@ struct seq_file;
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -157,9 +154,6 @@ static inline void cpuset_task_status_al
 {
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
--- CPUHP/kernel/sched.c~CPU_SET_LOCK	2009-07-23 17:06:39.000000000 +0200
+++ CPUHP/kernel/sched.c	2009-07-29 22:18:33.000000000 +0200
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
--- CPUHP/kernel/cpuset.c~CPU_SET_LOCK	2009-06-17 14:11:26.000000000 +0200
+++ CPUHP/kernel/cpuset.c	2009-07-29 22:49:30.000000000 +0200
@@ -215,6 +215,21 @@ static struct cpuset top_cpuset = {
 
 static DEFINE_MUTEX(callback_mutex);
 
+static void cpuset_lock(void)
+{
+	/* Protect against cpu_down(), move_task_off_dead_cpu() needs
+	 * cpuset_cpus_allowed_locked()
+	 */
+	get_online_cpus();
+	mutex_lock(&callback_mutex);
+}
+
+static void cpuset_unlock(void)
+{
+	mutex_unlock(&callback_mutex);
+	put_online_cpus();
+}
+
 /*
  * cpuset_buffer_lock protects both the cpuset_name and cpuset_nodelist
  * buffers.  They are statically allocated to prevent using excess stack
@@ -890,9 +905,9 @@ static int update_cpumask(struct cpuset 
 
 	is_load_balanced = is_sched_load_balance(trialcs);
 
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 
 	/*
 	 * Scan tasks in the cpuset, and update the cpumasks of any
@@ -1093,9 +1108,9 @@ static int update_nodemask(struct cpuset
 	if (retval < 0)
 		goto done;
 
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	cs->mems_allowed = trialcs->mems_allowed;
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 
 	update_tasks_nodemask(cs, &oldmem, &heap);
 
@@ -1207,9 +1222,9 @@ static int update_flag(cpuset_flagbits_t
 	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
 			|| (is_spread_page(cs) != is_spread_page(trialcs)));
 
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	cs->flags = trialcs->flags;
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
@@ -1516,9 +1531,9 @@ static int cpuset_sprintf_cpulist(char *
 {
 	int ret;
 
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	ret = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 
 	return ret;
 }
@@ -1527,9 +1542,9 @@ static int cpuset_sprintf_memlist(char *
 {
 	nodemask_t mask;
 
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	mask = cs->mems_allowed;
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 
 	return nodelist_scnprintf(page, PAGE_SIZE, mask);
 }
@@ -1980,12 +1995,12 @@ static void scan_for_empty_cpusets(struc
 		oldmems = cp->mems_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
-		mutex_lock(&callback_mutex);
+		cpuset_lock();
 		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
 			    cpu_online_mask);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
-		mutex_unlock(&callback_mutex);
+		cpuset_unlock();
 
 		/* Move tasks from the empty cpuset to a parent */
 		if (cpumask_empty(cp->cpus_allowed) ||
@@ -2029,9 +2044,9 @@ static int cpuset_track_online_cpus(stru
 	}
 
 	cgroup_lock();
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
@@ -2055,9 +2070,9 @@ static int cpuset_track_online_nodes(str
 	switch (action) {
 	case MEM_ONLINE:
 	case MEM_OFFLINE:
-		mutex_lock(&callback_mutex);
+		cpuset_lock();
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-		mutex_unlock(&callback_mutex);
+		cpuset_unlock();
 		if (action == MEM_OFFLINE)
 			scan_for_empty_cpusets(&top_cpuset);
 		break;
@@ -2100,9 +2115,9 @@ void __init cpuset_init_smp(void)
 
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	cpuset_cpus_allowed_locked(tsk, pmask);
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 }
 
 /**
@@ -2135,11 +2150,11 @@ nodemask_t cpuset_mems_allowed(struct ta
 {
 	nodemask_t mask;
 
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 	task_lock(tsk);
 	guarantee_online_mems(task_cs(tsk), &mask);
 	task_unlock(tsk);
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 
 	return mask;
 }
@@ -2252,14 +2267,14 @@ int __cpuset_node_allowed_softwall(int n
 		return 1;
 
 	/* Not hardwall and node outside mems_allowed: scan up cpusets */
-	mutex_lock(&callback_mutex);
+	cpuset_lock();
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
 	task_unlock(current);
 
 	allowed = node_isset(node, cs->mems_allowed);
-	mutex_unlock(&callback_mutex);
+	cpuset_unlock();
 	return allowed;
 }
 
@@ -2302,33 +2317,6 @@ int __cpuset_node_allowed_hardwall(int n
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

