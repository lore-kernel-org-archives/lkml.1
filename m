Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZDGK5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZDGK5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZDGK4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:56:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbZDGK4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:56:12 -0400
Message-ID: <49DB3071.5090200@cn.fujitsu.com>
Date: Tue, 07 Apr 2009 18:52:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC][PATCH 2/3] cpusets: update tasks' page/slab spread flags in
 time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the bug that the kernel didn't spread page cache/slab object
evenly over all the allowed nodes when spread flags were set by updating tasks'
page/slab spread flags in time.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 kernel/cpuset.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index be0cfcd..8bff8e6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -406,7 +406,6 @@ void cpuset_update_task_memory_state(void)
 		cs = task_cs(tsk); /* Maybe changed when task not locked */
 		guarantee_online_mems(cs, &tsk->mems_allowed);
 		tsk->cpuset_mems_generation = cs->mems_generation;
-		cpuset_update_task_spread_flag(cs, tsk);
 		task_unlock(tsk);
 		mutex_unlock(&callback_mutex);
 		mpol_rebind_task(tsk, &tsk->mems_allowed);
@@ -1204,6 +1203,46 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 }
 
 /*
+ * cpuset_change_flag - make a task's spread flags the same as its cpuset's
+ * @tsk: task to be updated
+ * @scan: struct cgroup_scanner containing the cgroup of the task
+ *
+ * Called by cgroup_scan_tasks() for each task in a cgroup.
+ *
+ * We don't need to re-check for the cgroup/cpuset membership, since we're
+ * holding cgroup_lock() at this point.
+ */
+static void cpuset_change_flag(struct task_struct *tsk,
+				struct cgroup_scanner *scan)
+{
+	cpuset_update_task_spread_flag(cgroup_cs(scan->cg), tsk);
+}
+
+/*
+ * update_tasks_flags - update the spread flags of tasks in the cpuset.
+ * @cs: the cpuset in which each task's spread flags needs to be changed
+ * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
+ *
+ * Called with cgroup_mutex held
+ *
+ * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
+ * calling callback functions for each.
+ *
+ * No return value. It's guaranteed that cgroup_scan_tasks() always returns 0
+ * if @heap != NULL.
+ */
+static void update_tasks_flags(struct cpuset *cs, struct ptr_heap *heap)
+{
+	struct cgroup_scanner scan;
+
+	scan.cg = cs->css.cgroup;
+	scan.test_task = NULL;
+	scan.process_task = cpuset_change_flag;
+	scan.heap = heap;
+	cgroup_scan_tasks(&scan);
+}
+
+/*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:		the bit to update (see cpuset_flagbits_t)
  * cs:		the cpuset to update
@@ -1216,8 +1255,10 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
 	struct cpuset *trialcs;
-	int err;
 	int balance_flag_changed;
+	int spread_flag_changed;
+	struct ptr_heap heap;
+	int err;
 
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs)
@@ -1232,9 +1273,16 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	if (err < 0)
 		goto out;
 
+	err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
+	if (err < 0)
+		goto out;
+
 	balance_flag_changed = (is_sched_load_balance(cs) !=
 				is_sched_load_balance(trialcs));
 
+	spread_flag_changed = ((is_spread_slab(cs) != is_spread_slab(trialcs))
+			|| (is_spread_page(cs) != is_spread_page(trialcs)));
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
@@ -1242,6 +1290,9 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
+	if (spread_flag_changed)
+		update_tasks_flags(cs, &heap);
+	heap_free(&heap);
 out:
 	free_trial_cpuset(trialcs);
 	return err;
@@ -1392,6 +1443,8 @@ static void cpuset_attach(struct cgroup_subsys *ss,
 	if (err)
 		return;
 
+	cpuset_update_task_spread_flag(cs, tsk);
+
 	from = oldcs->mems_allowed;
 	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
@@ -1453,11 +1506,9 @@ static int cpuset_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
 		break;
 	case FILE_SPREAD_PAGE:
 		retval = update_flag(CS_SPREAD_PAGE, cs, val);
-		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
-		cs->mems_generation = cpuset_mems_generation++;
 		break;
 	default:
 		retval = -EINVAL;
-- 
1.6.0.3


