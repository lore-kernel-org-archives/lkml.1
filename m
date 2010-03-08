Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0CHKLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:11:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0CHKLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:11:12 -0500
Message-ID: <4B94CC6D.2070502@cn.fujitsu.com>
Date: Mon, 08 Mar 2010 18:07:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 3/4] cpuset: alloc nodemask_t at heap not stack
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1 to V2:
- None

Allocating nodemask_t at heap instead of stack.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 kernel/cpuset.c |   93 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9c5bb4f..f36e577 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -970,15 +970,20 @@ static void cpuset_change_nodemask(struct task_struct *p,
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
-	nodemask_t newmems;
+	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
+
+	if (!newmems)
+		return;
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, &newmems);
+	guarantee_online_mems(cs, newmems);
 
 	task_lock(p);
-	cpuset_change_task_nodemask(p, &newmems);
+	cpuset_change_task_nodemask(p, newmems);
 	task_unlock(p);
 
+	NODEMASK_FREE(newmems);
+
 	mm = get_task_mm(p);
 	if (!mm)
 		return;
@@ -1048,16 +1053,21 @@ static void update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem,
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			   const char *buf)
 {
-	nodemask_t oldmem;
+	NODEMASK_ALLOC(nodemask_t, oldmem, GFP_KERNEL);
 	int retval;
 	struct ptr_heap heap;
 
+	if (!oldmem)
+		return -ENOMEM;
+
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
 	 * it's read-only
 	 */
-	if (cs == &top_cpuset)
-		return -EACCES;
+	if (cs == &top_cpuset) {
+		retval = -EACCES;
+		goto done;
+	}
 
 	/*
 	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
@@ -1073,11 +1083,13 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			goto done;
 
 		if (!nodes_subset(trialcs->mems_allowed,
-				node_states[N_HIGH_MEMORY]))
-			return -EINVAL;
+				node_states[N_HIGH_MEMORY])) {
+			retval =  -EINVAL;
+			goto done;
+		}
 	}
-	oldmem = cs->mems_allowed;
-	if (nodes_equal(oldmem, trialcs->mems_allowed)) {
+	*oldmem = cs->mems_allowed;
+	if (nodes_equal(*oldmem, trialcs->mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
@@ -1093,10 +1105,11 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	cs->mems_allowed = trialcs->mems_allowed;
 	mutex_unlock(&callback_mutex);
 
-	update_tasks_nodemask(cs, &oldmem, &heap);
+	update_tasks_nodemask(cs, oldmem, &heap);
 
 	heap_free(&heap);
 done:
+	NODEMASK_FREE(oldmem);
 	return retval;
 }
 
@@ -1381,39 +1394,46 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 			  struct cgroup *oldcont, struct task_struct *tsk,
 			  bool threadgroup)
 {
-	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
+	NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
+	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
+
+	if (from == NULL || to == NULL)
+		return;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
 	}
-	guarantee_online_mems(cs, &to);
+	guarantee_online_mems(cs, to);
 
 	/* do per-task migration stuff possibly for each in the threadgroup */
-	cpuset_attach_task(tsk, &to, cs);
+	cpuset_attach_task(tsk, to, cs);
 	if (threadgroup) {
 		struct task_struct *c;
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			cpuset_attach_task(c, &to, cs);
+			cpuset_attach_task(c, to, cs);
 		}
 		rcu_read_unlock();
 	}
 
 	/* change mm; only needs to be done once even if threadgroup */
-	from = oldcs->mems_allowed;
-	to = cs->mems_allowed;
+	*from = oldcs->mems_allowed;
+	*to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
-		mpol_rebind_mm(mm, &to);
+		mpol_rebind_mm(mm, to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &from, &to);
+			cpuset_migrate_mm(mm, from, to);
 		mmput(mm);
 	}
+
+	NODEMASK_FREE(from);
+	NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -1558,13 +1578,21 @@ static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 {
-	nodemask_t mask;
+	NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
+	int retval;
+
+	if (mask == NULL)
+		return -ENOMEM;
 
 	mutex_lock(&callback_mutex);
-	mask = cs->mems_allowed;
+	*mask = cs->mems_allowed;
 	mutex_unlock(&callback_mutex);
 
-	return nodelist_scnprintf(page, PAGE_SIZE, mask);
+	retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
+
+	NODEMASK_FREE(mask);
+
+	return retval;
 }
 
 static ssize_t cpuset_common_file_read(struct cgroup *cont,
@@ -1993,7 +2021,10 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	nodemask_t oldmems;
+	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
+
+	if (oldmems == NULL)
+		return;
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2010,7 +2041,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
-		oldmems = cp->mems_allowed;
+		*oldmems = cp->mems_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
@@ -2026,9 +2057,10 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, &oldmems, NULL);
+			update_tasks_nodemask(cp, oldmems, NULL);
 		}
 	}
+	NODEMASK_FREE(oldmems);
 }
 
 /*
@@ -2086,16 +2118,19 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	nodemask_t oldmems;
+	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
+
+	if (oldmems == NULL)
+		return NOTIFY_DONE;
 
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-		oldmems = top_cpuset.mems_allowed;
+		*oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 		mutex_unlock(&callback_mutex);
-		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
+		update_tasks_nodemask(&top_cpuset, oldmems, NULL);
 		break;
 	case MEM_OFFLINE:
 		scan_for_empty_cpusets(&top_cpuset);
@@ -2104,6 +2139,8 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 		break;
 	}
 	cgroup_unlock();
+
+	NODEMASK_FREE(oldmems);
 	return NOTIFY_OK;
 }
 #endif
-- 
1.6.5.2


