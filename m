Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYA3Akv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYA3Akv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYA3Akm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:40:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:11576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYA3Akk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:40:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=gSd4Zi9ocwZ7OhQRiEwC58d6lO7RPJqj8nttseOHlkaInEksnS+opwghMJg/CwfOe
	64CzXWOIDhy6M5wHShB2A==
Message-ID: <479FC767.5070903@google.com>
Date: Tue, 29 Jan 2008 16:40:07 -0800
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: [PATCH] Update comments in cpuset.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update comments in cpuset.c

Some of the comments in kernel/cpuset.c were stale following the
transition to control groups; this patch updates them to more closely
match reality.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Paul Jackson <pj@sgi.com>

---
 kernel/cpuset.c |  128 ++++++++++++++++++--------------------------------------
 1 file changed, 43 insertions(+), 85 deletions(-)

Index: linux-2.6.24-rc6-mm1/kernel/cpuset.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/kernel/cpuset.c
+++ linux-2.6.24-rc6-mm1/kernel/cpuset.c
@@ -64,7 +64,7 @@
  */
 int number_of_cpusets __read_mostly;
 
-/* Retrieve the cpuset from a cgroup */
+/* Forward declare cgroup structures */
 struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
@@ -160,17 +160,17 @@ static inline int is_spread_slab(const s
  * number, and avoid having to lock and reload mems_allowed unless
  * the cpuset they're using changes generation.
  *
- * A single, global generation is needed because attach_task() could
+ * A single, global generation is needed because cpuset_attach_task() could
  * reattach a task to a different cpuset, which must not have its
  * generation numbers aliased with those of that tasks previous cpuset.
  *
  * Generations are needed for mems_allowed because one task cannot
- * modify anothers memory placement.  So we must enable every task,
+ * modify another's memory placement.  So we must enable every task,
  * on every visit to __alloc_pages(), to efficiently check whether
  * its current->cpuset->mems_allowed has changed, requiring an update
  * of its current->mems_allowed.
  *
- * Since cpuset_mems_generation is guarded by manage_mutex,
+ * Since writes to cpuset_mems_generation are guarded by the cgroup lock
  * there is no need to mark it atomic.
  */
 static int cpuset_mems_generation;
@@ -182,17 +182,20 @@ static struct cpuset top_cpuset = {
 };
 
 /*
- * We have two global cpuset mutexes below.  They can nest.
- * It is ok to first take manage_mutex, then nest callback_mutex.  We also
- * require taking task_lock() when dereferencing a tasks cpuset pointer.
- * See "The task_lock() exception", at the end of this comment.
+ * There are two global mutexes guarding cpuset structures.  The first
+ * is the main control groups cgroup_mutex, accessed via
+ * cgroup_lock()/cgroup_unlock().  The second is the cpuset-specific
+ * callback_mutex, below. They can nest.  It is ok to first take
+ * cgroup_mutex, then nest callback_mutex.  We also require taking
+ * task_lock() when dereferencing a task's cpuset pointer.  See "The
+ * task_lock() exception", at the end of this comment.
  *
  * A task must hold both mutexes to modify cpusets.  If a task
- * holds manage_mutex, then it blocks others wanting that mutex,
+ * holds cgroup_mutex, then it blocks others wanting that mutex,
  * ensuring that it is the only task able to also acquire callback_mutex
  * and be able to modify cpusets.  It can perform various checks on
  * the cpuset structure first, knowing nothing will change.  It can
- * also allocate memory while just holding manage_mutex.  While it is
+ * also allocate memory while just holding cgroup_mutex.  While it is
  * performing these checks, various callback routines can briefly
  * acquire callback_mutex to query cpusets.  Once it is ready to make
  * the changes, it takes callback_mutex, blocking everyone else.
@@ -208,60 +211,16 @@ static struct cpuset top_cpuset = {
  * The task_struct fields mems_allowed and mems_generation may only
  * be accessed in the context of that task, so require no locks.
  *
- * Any task can increment and decrement the count field without lock.
- * So in general, code holding manage_mutex or callback_mutex can't rely
- * on the count field not changing.  However, if the count goes to
- * zero, then only attach_task(), which holds both mutexes, can
- * increment it again.  Because a count of zero means that no tasks
- * are currently attached, therefore there is no way a task attached
- * to that cpuset can fork (the other way to increment the count).
- * So code holding manage_mutex or callback_mutex can safely assume that
- * if the count is zero, it will stay zero.  Similarly, if a task
- * holds manage_mutex or callback_mutex on a cpuset with zero count, it
- * knows that the cpuset won't be removed, as cpuset_rmdir() needs
- * both of those mutexes.
- *
  * The cpuset_common_file_write handler for operations that modify
- * the cpuset hierarchy holds manage_mutex across the entire operation,
+ * the cpuset hierarchy holds cgroup_mutex across the entire operation,
  * single threading all such cpuset modifications across the system.
  *
  * The cpuset_common_file_read() handlers only hold callback_mutex across
  * small pieces of code, such as when reading out possibly multi-word
  * cpumasks and nodemasks.
  *
- * The fork and exit callbacks cpuset_fork() and cpuset_exit(), don't
- * (usually) take either mutex.  These are the two most performance
- * critical pieces of code here.  The exception occurs on cpuset_exit(),
- * when a task in a notify_on_release cpuset exits.  Then manage_mutex
- * is taken, and if the cpuset count is zero, a usermode call made
- * to /sbin/cpuset_release_agent with the name of the cpuset (path
- * relative to the root of cpuset file system) as the argument.
- *
- * A cpuset can only be deleted if both its 'count' of using tasks
- * is zero, and its list of 'children' cpusets is empty.  Since all
- * tasks in the system use _some_ cpuset, and since there is always at
- * least one task in the system (init), therefore, top_cpuset
- * always has either children cpusets and/or using tasks.  So we don't
- * need a special hack to ensure that top_cpuset cannot be deleted.
- *
- * The above "Tale of Two Semaphores" would be complete, but for:
- *
- *	The task_lock() exception
- *
- * The need for this exception arises from the action of attach_task(),
- * which overwrites one tasks cpuset pointer with another.  It does
- * so using both mutexes, however there are several performance
- * critical places that need to reference task->cpuset without the
- * expense of grabbing a system global mutex.  Therefore except as
- * noted below, when dereferencing or, as in attach_task(), modifying
- * a tasks cpuset pointer we use task_lock(), which acts on a spinlock
- * (task->alloc_lock) already in the task_struct routinely used for
- * such matters.
- *
- * P.S.  One more locking exception.  RCU is used to guard the
- * update of a tasks cpuset pointer by attach_task() and the
- * access of task->cpuset->mems_generation via that pointer in
- * the routine cpuset_update_task_memory_state().
+ * Accessing a task's cpuset should be done in accordance with the
+ * guidelines for accessing subsystem state in kernel/cgroup.c
  */
 
 static DEFINE_MUTEX(callback_mutex);
@@ -354,15 +313,14 @@ static void guarantee_online_mems(const 
  * Do not call this routine if in_interrupt().
  *
  * Call without callback_mutex or task_lock() held.  May be
- * called with or without manage_mutex held.  Thanks in part to
- * 'the_top_cpuset_hack', the tasks cpuset pointer will never
+ * called with or without cgroup_mutex held.  Thanks in part to
+ * 'the_top_cpuset_hack', the task's cpuset pointer will never
  * be NULL.  This routine also might acquire callback_mutex and
  * current->mm->mmap_sem during call.
  *
  * Reading current->cpuset->mems_generation doesn't need task_lock
  * to guard the current->cpuset derefence, because it is guarded
- * from concurrent freeing of current->cpuset by attach_task(),
- * using RCU.
+ * from concurrent freeing of current->cpuset using RCU.
  *
  * The rcu_dereference() is technically probably not needed,
  * as I don't actually mind if I see a new cpuset pointer but
@@ -424,7 +382,7 @@ void cpuset_update_task_memory_state(voi
  *
  * One cpuset is a subset of another if all its allowed CPUs and
  * Memory Nodes are a subset of the other, and its exclusive flags
- * are only set if the other's are set.  Call holding manage_mutex.
+ * are only set if the other's are set.  Call holding cgroup_mutex.
  */
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
@@ -442,7 +400,7 @@ static int is_cpuset_subset(const struct
  * If we replaced the flag and mask values of the current cpuset
  * (cur) with those values in the trial cpuset (trial), would
  * our various subset and exclusive rules still be valid?  Presumes
- * manage_mutex held.
+ * cgroup_mutex held.
  *
  * 'cur' is the address of an actual, in-use cpuset.  Operations
  * such as list traversal that depend on the actual address of the
@@ -476,7 +434,10 @@ static int validate_change(const struct 
 	if (!is_cpuset_subset(trial, par))
 		return -EACCES;
 
-	/* If either I or some sibling (!= me) is exclusive, we can't overlap */
+	/*
+	 * If either I or some sibling (!= me) is exclusive, we can't
+	 * overlap
+	 */
 	list_for_each_entry(cont, &par->css.cgroup->children, sibling) {
 		c = cgroup_cs(cont);
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
@@ -733,7 +694,7 @@ static inline int started_after(void *p1
 }
 
 /*
- * Call with manage_mutex held.  May take callback_mutex during call.
+ * Call with cgroup_mutex held.  May take callback_mutex during call.
  */
 
 static int update_cpumask(struct cpuset *cs, char *buf)
@@ -854,11 +815,11 @@ static int update_cpumask(struct cpuset 
  *    Temporarilly set tasks mems_allowed to target nodes of migration,
  *    so that the migration code can allocate pages on these nodes.
  *
- *    Call holding manage_mutex, so our current->cpuset won't change
- *    during this call, as manage_mutex holds off any attach_task()
+ *    Call holding cgroup_mutex, so current's cpuset won't change
+ *    during this call, as cgroup_mutex holds off any attach_task()
  *    calls.  Therefore we don't need to take task_lock around the
  *    call to guarantee_online_mems(), as we know no one is changing
- *    our tasks cpuset.
+ *    our task's cpuset.
  *
  *    Hold callback_mutex around the two modifications of our tasks
  *    mems_allowed to synchronize with cpuset_mems_allowed().
@@ -903,7 +864,7 @@ static void cpuset_migrate_mm(struct mm_
  * the cpuset is marked 'memory_migrate', migrate the tasks
  * pages to the new memory.
  *
- * Call with manage_mutex held.  May take callback_mutex during call.
+ * Call with cgroup_mutex held.  May take callback_mutex during call.
  * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
  * lock each such tasks mm->mmap_sem, scan its vma's and rebind
  * their mempolicies to the cpusets new mems_allowed.
@@ -1016,7 +977,7 @@ static int update_nodemask(struct cpuset
 	 * tasklist_lock.  Forks can happen again now - the mpol_copy()
 	 * cpuset_being_rebound check will catch such forks, and rebind
 	 * their vma mempolicies too.  Because we still hold the global
-	 * cpuset manage_mutex, we know that no other rebind effort will
+	 * cgroup_mutex, we know that no other rebind effort will
 	 * be contending for the global variable cpuset_being_rebound.
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
@@ -1031,7 +992,7 @@ static int update_nodemask(struct cpuset
 		mmput(mm);
 	}
 
-	/* We're done rebinding vma's to this cpusets new mems_allowed. */
+	/* We're done rebinding vmas to this cpuset's new mems_allowed. */
 	kfree(mmarray);
 	cpuset_being_rebound = NULL;
 	retval = 0;
@@ -1045,7 +1006,7 @@ int current_cpuset_is_being_rebound(void
 }
 
 /*
- * Call with manage_mutex held.
+ * Call with cgroup_mutex held.
  */
 
 static int update_memory_pressure_enabled(struct cpuset *cs, char *buf)
@@ -1066,7 +1027,7 @@ static int update_memory_pressure_enable
  * cs:	the cpuset to update
  * buf:	the buffer where we read the 0 or 1
  *
- * Call with manage_mutex held.
+ * Call with cgroup_mutex held.
  */
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs, char *buf)
@@ -1200,6 +1161,7 @@ static int fmeter_getrate(struct fmeter 
 	return val;
 }
 
+/* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys *ss,
 			     struct cgroup *cont, struct task_struct *tsk)
 {
@@ -1547,7 +1509,8 @@ static int cpuset_populate(struct cgroup
  * If this becomes a problem for some users who wish to
  * allow that scenario, then cpuset_post_clone() could be
  * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
- * (and likewise for mems) to the new cgroup.
+ * (and likewise for mems) to the new cgroup. Called with cgroup_mutex
+ * held.
  */
 static void cpuset_post_clone(struct cgroup_subsys *ss,
 			      struct cgroup *cgroup)
@@ -1571,11 +1534,8 @@ static void cpuset_post_clone(struct cgr
 
 /*
  *	cpuset_create - create a cpuset
- *	parent:	cpuset that will be parent of the new cpuset.
- *	name:		name of the new cpuset. Will be strcpy'ed.
- *	mode:		mode to set on new inode
- *
- *	Must be called with the mutex on the parent inode held
+ *	ss:	cpuset cgroup subsystem
+ *	cont:	control group that the new cpuset will be part of
  */
 
 static struct cgroup_subsys_state *cpuset_create(
@@ -1703,7 +1663,7 @@ int __init cpuset_init(void)
  * only one of CPUs or nodes needed to be checked on a given call.
  * This was done to minimize text size rather than cpu cycles.
  *
- * Call with both manage_mutex and callback_mutex held.
+ * Call with both cgroup_mutex and callback_mutex held.
  *
  * Recursive, on depth of cpuset subtree.
  */
@@ -1826,7 +1786,7 @@ cpumask_t cpuset_cpus_allowed(struct tas
 
 /**
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be  called with callback_mutex held.
+ * Must be called with callback_mutex held.
  **/
 cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
 {
@@ -2163,10 +2123,8 @@ void __cpuset_memory_pressure_bump(void)
  *  - Used for /proc/<pid>/cpuset.
  *  - No need to task_lock(tsk) on this tsk->cpuset reference, as it
  *    doesn't really matter if tsk->cpuset changes after we read it,
- *    and we take manage_mutex, keeping attach_task() from changing it
- *    anyway.  No need to check that tsk->cpuset != NULL, thanks to
- *    the_top_cpuset_hack in cpuset_exit(), which sets an exiting tasks
- *    cpuset to top_cpuset.
+ *    and we take cgroup_mutex, keeping attach_task() from changing it
+ *    anyway.
  */
 static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 {
