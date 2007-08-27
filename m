Return-Path: <linux-kernel-owner+w=401wt.eu-S932807AbXH0SeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbXH0SeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbXH0Sdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:33:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60624 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932689AbXH0Sdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:33:40 -0400
Date: Mon, 27 Aug 2007 13:33:38 -0500
From: Cliff Wickman <cpw@sgi.com>
To: akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       oleg@tv-sign.ru, pj@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] V4: hotplug cpu: migrate a task within its cpuset
Message-ID: <20070827183338.GA3752@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Version 4 calls cpuset_cpus_allowed_locked() outside of the
task_rq_lock to avoid the lock conflict that Oleg noticed.
And it consolidates what would have been very similar "if (dest_cpu == NR_CPUS)"
paths.  Also Oleg's observation.


Version 3 added a missing task_rq_lock()/task_rq_unlock() pair. (Oleg found)

There was discussion about this patch among:
Andrew Morton, Oleg Nesterov, Gautham Shenoy, Rusty Russell
regarding other approaches:
  refusing to offline a cpu with tasks pinned to it, or
  providing an administrator the ability to assign such tasks to other cpus

There is indeed an "assumption" in my patch that the cpuset containing a
pinned task's cpu is a better choice than any online cpu. I think that is
a reasonable assumption given the typical construction of a cpuset and the
reason a task is running in a cpuset.

And there will be coming cases, at least on some architectures, where a
cpu is offlined as a kernel reaction to a hardware error.  In that case
would it not be preferrable to re-pin such tasks and let them proceed?



When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
that have been running on that cpu.

Currently, such a task is migrated:
 1) to any cpu on the same node as the disabled cpu, which is both online
    and among that task's cpus_allowed
 2) to any cpu which is both online and among that task's cpus_allowed

It is typical of a multithreaded application running on a large NUMA system
to have its tasks confined to a cpuset so as to cluster them near the
memory that they share. Furthermore, it is typical to explicitly place such
a task on a specific cpu in that cpuset.  And in that case the task's
cpus_allowed includes only a single cpu.

This patch would insert a preference to migrate such a task to some cpu within
its cpuset (and set its cpus_allowed to its entire cpuset).

With this patch, migrate the task to:
 1) to any cpu on the same node as the disabled cpu, which is both online
    and among that task's cpus_allowed
 2) to any online cpu within the task's cpuset
 3) to any cpu which is both online and among that task's cpus_allowed


In order to do this, move_task_off_dead_cpu() must make a call to
cpuset_cpus_allowed_locked(), a new subset of cpuset_cpus_allowed(), that
will not block. (name change - per Oleg's suggestion)

Calls are made to cpuset_lock() and cpuset_unlock() in migration_call()
to set the cpuset mutex during the whole migrate_live_tasks() and
migrate_dead_tasks() procedure.

This patch depends on 2 patches from Oleg Nesterov:
  [PATCH 1/2] do CPU_DEAD migrating under read_lock(tasklist) instead of write_lock_irq(tasklist)
  [PATCH 2/2] migration_call(CPU_DEAD): use spin_lock_irq() instead of task_rq_lock()

Diffed against 2.6.23-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 include/linux/cpuset.h |    5 +++++
 kernel/cpuset.c        |   15 ++++++++++++++-
 kernel/sched.c         |   13 ++++++++++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

Index: linus.070821/kernel/sched.c
===================================================================
--- linus.070821.orig/kernel/sched.c
+++ linus.070821/kernel/sched.c
@@ -61,6 +61,7 @@
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
+#include <linux/cpuset.h>
 
 #include <asm/tlb.h>
 
@@ -5093,8 +5094,16 @@ restart:
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu == NR_CPUS) {
+		cpumask_t cpus_allowed = cpuset_cpus_allowed_locked();
+		/*
+		 * Try to stay on the same cpuset, where the current cpuset
+		 * may be a subset of all cpus.
+		 * The cpuset_cpus_allowed_locked() variant of
+		 * cpuset_cpus_allowed() will not block
+		 * It must be called within calls to cpuset_lock/cpuset_unlock.
+		 */
 		rq = task_rq_lock(p, &flags);
-		cpus_setall(p->cpus_allowed);
+		p->cpus_allowed = cpus_allowed;
 		dest_cpu = any_online_cpu(p->cpus_allowed);
 		task_rq_unlock(rq, &flags);
 
@@ -5412,6 +5421,7 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5425,6 +5435,7 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
+		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 
Index: linus.070821/include/linux/cpuset.h
===================================================================
--- linus.070821.orig/include/linux/cpuset.h
+++ linus.070821/include/linux/cpuset.h
@@ -22,6 +22,7 @@ extern void cpuset_init_smp(void);
 extern void cpuset_fork(struct task_struct *p);
 extern void cpuset_exit(struct task_struct *p);
 extern cpumask_t cpuset_cpus_allowed(struct task_struct *p);
+extern cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -87,6 +88,10 @@ static inline cpumask_t cpuset_cpus_allo
 {
 	return cpu_possible_map;
 }
+static inline cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p)
+{
+	return cpu_possible_map;
+}
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
Index: linus.070821/kernel/cpuset.c
===================================================================
--- linus.070821.orig/kernel/cpuset.c
+++ linus.070821/kernel/cpuset.c
@@ -2325,10 +2325,23 @@ cpumask_t cpuset_cpus_allowed(struct tas
 	cpumask_t mask;
 
 	mutex_lock(&callback_mutex);
+	mask = cpuset_cpus_allowed_locked(tsk);
+	mutex_unlock(&callback_mutex);
+
+	return mask;
+}
+
+/**
+ * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
+ * Must be  called with callback_mutex held.
+ **/
+cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
+{
+	cpumask_t mask;
+
 	task_lock(tsk);
 	guarantee_online_cpus(tsk->cpuset, &mask);
 	task_unlock(tsk);
-	mutex_unlock(&callback_mutex);
 
 	return mask;
 }
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
