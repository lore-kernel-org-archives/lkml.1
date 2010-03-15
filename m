Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935951Ab0COJMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:12:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935892Ab0COJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:08 -0400
Date: Mon, 15 Mar 2010 10:10:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] kill the broken and deadlockable
	cpuset_lock/cpuset_cpus_allowed_locked code
Message-ID: <20100315091003.GA9123@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just states the fact the cpusets/cpuhotplug interaction is
broken and removes the deadlockable code which only pretends to work.

- cpuset_lock() doesn't really work. It is needed for
  cpuset_cpus_allowed_locked() but we can't take this lock in
  try_to_wake_up()->select_fallback_rq() path.

- cpuset_lock() is deadlockable. Suppose that a task T bound to CPU takes
  callback_mutex. If cpu_down(CPU) happens before T drops callback_mutex
  stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
  cpuset_lock() and hangs forever because CPU is already dead and thus
  T can't be scheduled.

- cpuset_cpus_allowed_locked() is deadlockable too. It takes task_lock()
  which is not irq-safe, but try_to_wake_up() can be called from irq.

Kill them, and change select_fallback_rq() to use cpu_possible_mask, like
we currently do without CONFIG_CPUSETS.

Also, with or without this patch, with or without CONFIG_CPUSETS, the
callers of select_fallback_rq() can race with each other or with
set_cpus_allowed() pathes.

The subsequent patches try to to fix these problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |   13 -------------
 kernel/cpuset.c        |   27 +--------------------------
 kernel/sched.c         |   10 +++-------
 3 files changed, 4 insertions(+), 46 deletions(-)

--- 34-rc1/include/linux/cpuset.h~1_KILL_CPUSET_LOCK	2010-03-15 09:38:51.000000000 +0100
+++ 34-rc1/include/linux/cpuset.h	2010-03-15 09:40:16.000000000 +0100
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
--- 34-rc1/kernel/cpuset.c~1_KILL_CPUSET_LOCK	2010-03-15 09:38:51.000000000 +0100
+++ 34-rc1/kernel/cpuset.c	2010-03-15 09:40:16.000000000 +0100
@@ -2140,19 +2140,10 @@ void __init cpuset_init_smp(void)
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
 	mutex_lock(&callback_mutex);
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
+	mutex_unlock(&callback_mutex);
 }
 
 void cpuset_init_current_mems_allowed(void)
@@ -2341,22 +2332,6 @@ int __cpuset_node_allowed_hardwall(int n
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
  * cpuset_unlock - release lock on cpuset changes
  *
  * Undo the lock taken in a previous cpuset_lock() call.
--- 34-rc1/kernel/sched.c~1_KILL_CPUSET_LOCK	2010-03-15 09:38:51.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-15 09:40:16.000000000 +0100
@@ -2288,11 +2288,9 @@ static int select_fallback_rq(int cpu, s
 		return dest_cpu;
 
 	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		rcu_read_lock();
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		rcu_read_unlock();
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+	if (unlikely(dest_cpu >= nr_cpu_ids)) {
+		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+		dest_cpu = cpumask_any(cpu_active_mask);
 
 		/*
 		 * Don't tell them about moving exiting tasks or
@@ -5929,7 +5927,6 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5943,7 +5940,6 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		raw_spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);

