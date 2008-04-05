Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYDEBM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYDEBM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYDEBLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:11 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011102.033192000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:07 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] cpuset: modify cpuset_set_cpus_allowed to use cpumask pointer
Content-Disposition: inline; filename=cpuset_cpus_allowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Modify cpuset_cpus_allowed to return the currently allowed cpuset
    via a pointer argument instead of as the function return value.

  * Use new set_cpus_allowed_ptr function.

  * Cleanup CPU_MASK_ALL and NODE_MASK_ALL uses.

Depends on:
	[sched-devel]: sched: add new set_cpus_allowed_ptr function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpuset.h |   13 +++++++------
 kernel/cpuset.c        |   31 ++++++++++++-------------------
 kernel/sched.c         |    8 +++++---
 mm/pdflush.c           |    4 ++--
 4 files changed, 26 insertions(+), 30 deletions(-)

--- linux-2.6.x86.orig/include/linux/cpuset.h
+++ linux-2.6.x86/include/linux/cpuset.h
@@ -20,8 +20,8 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern cpumask_t cpuset_cpus_allowed(struct task_struct *p);
-extern cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p);
+extern void cpuset_cpus_allowed(struct task_struct *p, cpumask_t *mask);
+extern void cpuset_cpus_allowed_locked(struct task_struct *p, cpumask_t *mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -86,13 +86,14 @@ static inline int cpuset_init_early(void
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline cpumask_t cpuset_cpus_allowed(struct task_struct *p)
+static inline void cpuset_cpus_allowed(struct task_struct *p, cpumask_t *mask)
 {
-	return cpu_possible_map;
+	*mask = cpu_possible_map;
 }
-static inline cpumask_t cpuset_cpus_allowed_locked(struct task_struct *p)
+static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
+								cpumask_t *mask)
 {
-	return cpu_possible_map;
+	*mask = cpu_possible_map;
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
--- linux-2.6.x86.orig/kernel/cpuset.c
+++ linux-2.6.x86/kernel/cpuset.c
@@ -741,7 +741,7 @@ int cpuset_test_cpumask(struct task_stru
  */
 void cpuset_change_cpumask(struct task_struct *tsk, struct cgroup_scanner *scan)
 {
-	set_cpus_allowed(tsk, (cgroup_cs(scan->cg))->cpus_allowed);
+	set_cpus_allowed_ptr(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
 }
 
 /**
@@ -1269,7 +1269,7 @@ static void cpuset_attach(struct cgroup_
 
 	mutex_lock(&callback_mutex);
 	guarantee_online_cpus(cs, &cpus);
-	set_cpus_allowed(tsk, cpus);
+	set_cpus_allowed_ptr(tsk, &cpus);
 	mutex_unlock(&callback_mutex);
 
 	from = oldcs->mems_allowed;
@@ -1663,8 +1663,8 @@ static struct cgroup_subsys_state *cpuse
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	set_bit(CS_SYSTEM, &cs->flags);
-	cs->cpus_allowed = CPU_MASK_NONE;
-	cs->mems_allowed = NODE_MASK_NONE;
+	cpus_clear(cs->cpus_allowed);
+	nodes_clear(cs->mems_allowed);
 	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
 
@@ -1737,8 +1737,8 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
-	top_cpuset.cpus_allowed = CPU_MASK_ALL;
-	top_cpuset.mems_allowed = NODE_MASK_ALL;
+	cpus_setall(top_cpuset.cpus_allowed);
+	nodes_setall(top_cpuset.mems_allowed);
 
 	fmeter_init(&top_cpuset.fmeter);
 	top_cpuset.mems_generation = cpuset_mems_generation++;
@@ -1957,6 +1957,7 @@ void __init cpuset_init_smp(void)
 
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
+ * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
  *
  * Description: Returns the cpumask_t cpus_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
@@ -1964,35 +1965,27 @@ void __init cpuset_init_smp(void)
  * tasks cpuset.
  **/
 
-cpumask_t cpuset_cpus_allowed(struct task_struct *tsk)
+void cpuset_cpus_allowed(struct task_struct *tsk, cpumask_t *pmask)
 {
-	cpumask_t mask;
-
 	mutex_lock(&callback_mutex);
-	mask = cpuset_cpus_allowed_locked(tsk);
+	cpuset_cpus_allowed_locked(tsk, pmask);
 	mutex_unlock(&callback_mutex);
-
-	return mask;
 }
 
 /**
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
  * Must be called with callback_mutex held.
  **/
-cpumask_t cpuset_cpus_allowed_locked(struct task_struct *tsk)
+void cpuset_cpus_allowed_locked(struct task_struct *tsk, cpumask_t *pmask)
 {
-	cpumask_t mask;
-
 	task_lock(tsk);
-	guarantee_online_cpus(task_cs(tsk), &mask);
+	guarantee_online_cpus(task_cs(tsk), pmask);
 	task_unlock(tsk);
-
-	return mask;
 }
 
 void cpuset_init_current_mems_allowed(void)
 {
-	current->mems_allowed = NODE_MASK_ALL;
+	nodes_setall(current->mems_allowed);
 }
 
 /**
--- linux-2.6.x86.orig/kernel/sched.c
+++ linux-2.6.x86/kernel/sched.c
@@ -4996,13 +4996,13 @@ long sched_setaffinity(pid_t pid, cpumas
 	if (retval)
 		goto out_unlock;
 
-	cpus_allowed = cpuset_cpus_allowed(p);
+	cpuset_cpus_allowed(p, &cpus_allowed);
 	cpus_and(new_mask, new_mask, cpus_allowed);
  again:
 	retval = set_cpus_allowed(p, new_mask);
 
 	if (!retval) {
-		cpus_allowed = cpuset_cpus_allowed(p);
+		cpuset_cpus_allowed(p, &cpus_allowed);
 		if (!cpus_subset(new_mask, cpus_allowed)) {
 			/*
 			 * We must have raced with a concurrent cpuset
@@ -5719,7 +5719,9 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu >= nr_cpu_ids) {
-			cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
+			cpumask_t cpus_allowed;
+
+			cpuset_cpus_allowed_locked(p, &cpus_allowed);
 			/*
 			 * Try to stay on the same cpuset, where the
 			 * current cpuset may be a subset of all cpus.
--- linux-2.6.x86.orig/mm/pdflush.c
+++ linux-2.6.x86/mm/pdflush.c
@@ -187,8 +187,8 @@ static int pdflush(void *dummy)
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
 	 */
-	cpus_allowed = cpuset_cpus_allowed(current);
-	set_cpus_allowed(current, cpus_allowed);
+	cpuset_cpus_allowed(current, &cpus_allowed);
+	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	return __pdflush(&my_work);
 }

-- 
