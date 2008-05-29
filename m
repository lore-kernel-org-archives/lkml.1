Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbYE2DGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbYE2DGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYE2DF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:05:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbYE2DF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:05:56 -0400
Message-ID: <483E1D77.30400@cn.fujitsu.com>
Date: Thu, 29 May 2008 11:05:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: [RFC] [PATCH] cpusets: update tasks' cpus_allowed and mems_allowed
 after CPU/NODE offline/online
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is, a task may run on the cpu/node which is not in its cpuset.cpus/
cpuset.mems.

It can be reproduced by the following commands:
-----------------------------------
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0-1 > /dev/cpuset/0/cpus
# echo 0 > /dev/cpuset/0/mems
# echo $$ > /dev/cpuset/0/tasks
# echo 0 > /sys/devices/system/cpu/cpu1/online
# echo 1 > /sys/devices/system/cpu/cpu1/online
-----------------------------------

There is only CPU0 in cpuset.cpus, but the task in this cpuset runs on
both CPU0 and CPU1.

It is because the task's cpu_allowed didn't get updated after we did
CPU offline/online manipulation. Similar for mem_allowed.

This patch fixes this bug expect for root cpuset. Because there is a
problem about root cpuset, in that whether it is necessary to update all
the tasks in root cpuset or not after cpu/node offline/online.

If updating, some kernel threads which is bound into a specified cpu will
be unbound.

If not updating, there is a bug in root cpuset. This bug is also caused
by offline/online manipulation. For example, there is a dual-cpu
machine. we create a sub cpuset in root cpuset and assign 1 to its cpus.
And then we attach some tasks into this sub cpuset. After this, we
offline CPU1. Now, the tasks in this new cpuset are moved into root
cpuset automatically because there is no cpu in sub cpuset. Then we
online CPU1, we find all the tasks which doesn't belong to root cpuset
originally just run on CPU0.

Maybe we need to add a flag in the task_struct to mark which task can't be
unbound?

Though the patch is a little big, most of the change is just code restruction.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 kernel/cpuset.c |  187 ++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 117 insertions(+), 70 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 86ea9e3..6473bcb 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -766,6 +766,38 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 }
 
 /**
+ * update_tasks_cpumask - Scan tasks in cpuset cs, and update the cpumasks of
+ * any that need an update.
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
+	int retval = 0;
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
@@ -773,8 +805,6 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 static int update_cpumask(struct cpuset *cs, char *buf)
 {
 	struct cpuset trialcs;
-	struct cgroup_scanner scan;
-	struct ptr_heap heap;
 	int retval;
 	int is_load_balanced;
 
@@ -807,10 +837,6 @@ static int update_cpumask(struct cpuset *cs, char *buf)
 	if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
 		return 0;
 
-	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);
-	if (retval)
-		return retval;
-
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
@@ -821,12 +847,9 @@ static int update_cpumask(struct cpuset *cs, char *buf)
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
@@ -882,72 +905,26 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
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
+ * update_tasks_nodemask - Scan tasks in cpuset cs, and update the nodemasks of
+ * any that need an update.
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
+	int retval = 0;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
@@ -1014,7 +991,7 @@ static int update_nodemask(struct cpuset *cs, char *buf)
 
 		mpol_rebind_mm(mm, &cs->mems_allowed);
 		if (migrate)
-			cpuset_migrate_mm(mm, &oldmem, &cs->mems_allowed);
+			cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
 		mmput(mm);
 	}
 
@@ -1026,6 +1003,69 @@ done:
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
@@ -1834,6 +1874,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct list_head queue;
 	struct cgroup *cont;
+	nodemask_t oldmems;
 
 	INIT_LIST_HEAD(&queue);
 
@@ -1853,6 +1894,8 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
+		oldmems = cp->mems_allowed;
+
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
@@ -1864,6 +1907,10 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
 		if (cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
+		else {
+			update_tasks_cpumask(cp);
+			update_tasks_nodemask(cp, &oldmems);
+		}
 	}
 }
 
-- 
1.5.4.rc3


