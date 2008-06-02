Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYFBIgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYFBIgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYFBIf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:35:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYFBIfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:35:23 -0400
Message-ID: <4843AFC9.7000100@cn.fujitsu.com>
Date: Mon, 02 Jun 2008 16:31:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: [PATCH 1/2] cpusets: restructure the function update_cpumask() and
 update_nodemask()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

extract two functions from update_cpumask() and update_nodemask().They will be
used later for updating tasks' cpus_allowed and mems_allowed after CPU/NODE
offline/online.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>

---
 kernel/cpuset.c |  179 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 108 insertions(+), 71 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 86ea9e3..dc16f71 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -766,6 +766,37 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 }
 
 /**
+ * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
+ * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
+ *
+ * Called with cgroup_mutex held
+ *
+ * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
+ * calling callback functions for each.
+ *
+ * Return 0 if successful, -errno if not.
+ */
+static int update_tasks_cpumask(struct cpuset *cs)
+{
+	struct cgroup_scanner scan;
+	struct ptr_heap heap;
+	int retval;
+
+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
+	if (retval)
+		return retval;
+
+	scan.cg = cs->css.cgroup;
+	scan.test_task = cpuset_test_cpumask;
+	scan.process_task = cpuset_change_cpumask;
+	scan.heap = &heap;
+	retval = cgroup_scan_tasks(&scan);
+
+	heap_free(&heap);
+	return retval;
+}
+
+/**
  * update_cpumask - update the cpus_allowed mask of a cpuset and all tasks in it
  * @cs: the cpuset to consider
  * @buf: buffer of cpu numbers written to this cpuset
@@ -773,8 +804,6 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 static int update_cpumask(struct cpuset *cs, char *buf)
 {
 	struct cpuset trialcs;
-	struct cgroup_scanner scan;
-	struct ptr_heap heap;
 	int retval;
 	int is_load_balanced;
 
@@ -807,10 +836,6 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
-	if (retval)
-		return retval;
-
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
@@ -821,12 +846,9 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	 * Scan tasks in the cpuset, and update the cpumasks of any
 	 * that need an update.
 	 */
-	scan.cg = cs->css.cgroup;
-	scan.test_task = cpuset_test_cpumask;
-	scan.process_task = cpuset_change_cpumask;
-	scan.heap = &heap;
-	cgroup_scan_tasks(&scan);
-	heap_free(&heap);
+	retval = update_tasks_cpumask(cs);
+	if (retval < 0)
+		return retval;
 
 	if (is_load_balanced)
 		rebuild_sched_domains();
@@ -882,72 +904,25 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 	mutex_unlock(&callback_mutex);
 }
 
-/*
- * Handle user request to change the 'mems' memory placement
- * of a cpuset.  Needs to validate the request, update the
- * cpusets mems_allowed and mems_generation, and for each
- * task in the cpuset, rebind any vma mempolicies and if
- * the cpuset is marked 'memory_migrate', migrate the tasks
- * pages to the new memory.
- *
- * Call with cgroup_mutex held.  May take callback_mutex during call.
- * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
- * lock each such tasks mm->mmap_sem, scan its vma's and rebind
- * their mempolicies to the cpusets new mems_allowed.
- */
-
 static void *cpuset_being_rebound;
 
-static int update_nodemask(struct cpuset *cs, char *buf)
+/**
+ * update_tasks_nodemask - Update the nodemasks of tasks in the cpuset.
+ * @cs: the cpuset in which each task's mems_allowed mask needs to be changed
+ * @oldmem: old mems_allowed of cpuset cs
+ *
+ * Called with cgroup_mutex held
+ * Return 0 if successful, -errno if not.
+ */
+static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 {
-	struct cpuset trialcs;
-	nodemask_t oldmem;
 	struct task_struct *p;
 	struct mm_struct **mmarray;
 	int i, n, ntasks;
 	int migrate;
 	int fudge;
-	int retval;
 	struct cgroup_iter it;
-
-	/*
-	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
-	 * it's read-only
-	 */
-	if (cs == &top_cpuset)
-		return -EACCES;
-
-	trialcs = *cs;
-
-	/*
-	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
-	 * Since nodelist_parse() fails on an empty mask, we special case
-	 * that parsing.  The validate_change() call ensures that cpusets
-	 * with tasks have memory.
-	 */
-	buf = strstrip(buf);
-	if (!*buf) {
-		nodes_clear(trialcs.mems_allowed);
-	} else {
-		retval = nodelist_parse(buf, trialcs.mems_allowed);
-		if (retval < 0)
-			goto done;
-	}
-	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
-						node_states[N_HIGH_MEMORY]);
-	oldmem = cs->mems_allowed;
-	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
-		retval = 0;		/* Too easy - nothing to do */
-		goto done;
-	}
-	retval = validate_change(cs, &trialcs);
-	if (retval < 0)
-		goto done;
-
-	mutex_lock(&callback_mutex);
-	cs->mems_allowed = trialcs.mems_allowed;
-	cs->mems_generation = cpuset_mems_generation++;
-	mutex_unlock(&callback_mutex);
+	int retval;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
@@ -1014,7 +989,7 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 
 		mpol_rebind_mm(mm, &cs->mems_allowed);
 		if (migrate)
-			cpuset_migrate_mm(mm, &oldmem, &cs->mems_allowed);
+			cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
 		mmput(mm);
 	}
 
@@ -1026,6 +1001,69 @@ done:
 	return retval;
 }
 
+/*
+ * Handle user request to change the 'mems' memory placement
+ * of a cpuset.  Needs to validate the request, update the
+ * cpusets mems_allowed and mems_generation, and for each
+ * task in the cpuset, rebind any vma mempolicies and if
+ * the cpuset is marked 'memory_migrate', migrate the tasks
+ * pages to the new memory.
+ *
+ * Call with cgroup_mutex held.  May take callback_mutex during call.
+ * Will take tasklist_lock, scan tasklist for tasks in cpuset cs,
+ * lock each such tasks mm->mmap_sem, scan its vma's and rebind
+ * their mempolicies to the cpusets new mems_allowed.
+ */
+static int update_nodemask(struct cpuset *cs, char *buf)
+{
+	struct cpuset trialcs;
+	nodemask_t oldmem;
+	int retval;
+
+	/*
+	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
+	 * it's read-only
+	 */
+	if (cs == &top_cpuset)
+		return -EACCES;
+
+	trialcs = *cs;
+
+	/*
+	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
+	 * Since nodelist_parse() fails on an empty mask, we special case
+	 * that parsing.  The validate_change() call ensures that cpusets
+	 * with tasks have memory.
+	 */
+	buf = strstrip(buf);
+	if (!*buf) {
+		nodes_clear(trialcs.mems_allowed);
+	} else {
+		retval = nodelist_parse(buf, trialcs.mems_allowed);
+		if (retval < 0)
+			goto done;
+	}
+	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
+						node_states[N_HIGH_MEMORY]);
+	oldmem = cs->mems_allowed;
+	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
+		retval = 0;		/* Too easy - nothing to do */
+		goto done;
+	}
+	retval = validate_change(cs, &trialcs);
+	if (retval < 0)
+		goto done;
+
+	mutex_lock(&callback_mutex);
+	cs->mems_allowed = trialcs.mems_allowed;
+	cs->mems_generation = cpuset_mems_generation++;
+	mutex_unlock(&callback_mutex);
+
+	retval = update_tasks_nodemask(cs, &oldmem);
+done:
+	return retval;
+}
+
 int current_cpuset_is_being_rebound(void)
 {
 	return task_cs(current) == cpuset_being_rebound;
@@ -1938,7 +1976,6 @@ void __init cpuset_init_smp(void)
 }
 
 /**
-
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
  * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
-- 
1.5.4.rc3



