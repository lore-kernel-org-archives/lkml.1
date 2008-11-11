Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYKKMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYKKMe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbYKKMep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:34:45 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:32971 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbYKKMeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:34:44 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 11 Nov 2008 18:04:17 +0530
Message-Id: <20081111123417.6566.52629.sendpatchset@balbir-laptop>
In-Reply-To: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
Subject: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch introduces hierarchical reclaim. When an ancestor goes over its
limit, the charging routine points to the parent that is above its limit.
The reclaim process then starts from the last scanned child of the ancestor
and reclaims until the ancestor goes below its limit.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |  179 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 152 insertions(+), 27 deletions(-)

diff -puN mm/memcontrol.c~memcg-hierarchical-reclaim mm/memcontrol.c
--- linux-2.6.28-rc2/mm/memcontrol.c~memcg-hierarchical-reclaim	2008-11-11 17:51:56.000000000 +0530
+++ linux-2.6.28-rc2-balbir/mm/memcontrol.c	2008-11-11 17:51:56.000000000 +0530
@@ -132,6 +132,11 @@ struct mem_cgroup {
 	 * statistics.
 	 */
 	struct mem_cgroup_stat stat;
+	/*
+	 * While reclaiming in a hiearchy, we cache the last child we
+	 * reclaimed from. Protected by cgroup_lock()
+	 */
+	struct mem_cgroup *last_scanned_child;
 };
 static struct mem_cgroup init_mem_cgroup;
 
@@ -467,6 +472,126 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
+static struct mem_cgroup *
+mem_cgroup_from_res_counter(struct res_counter *counter)
+{
+	return container_of(counter, struct mem_cgroup, res);
+}
+
+/*
+ * Dance down the hierarchy if needed to reclaim memory. We remember the
+ * last child we reclaimed from, so that we don't end up penalizing
+ * one child extensively based on its position in the children list.
+ *
+ * root_mem is the original ancestor that we've been reclaim from.
+ */
+static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *mem,
+						struct mem_cgroup *root_mem,
+						gfp_t gfp_mask)
+{
+	struct cgroup *cg_current, *cgroup;
+	struct mem_cgroup *mem_child;
+	int ret = 0;
+
+	/*
+	 * Reclaim unconditionally and don't check for return value.
+	 * We need to reclaim in the current group and down the tree.
+	 * One might think about checking for children before reclaiming,
+	 * but there might be left over accounting, even after children
+	 * have left.
+	 */
+	try_to_free_mem_cgroup_pages(mem, gfp_mask);
+
+	if (res_counter_check_under_limit(&root_mem->res))
+		return 0;
+
+	cgroup_lock();
+
+	if (list_empty(&mem->css.cgroup->children)) {
+		cgroup_unlock();
+		return 0;
+	}
+
+	/*
+	 * Scan all children under the mem_cgroup mem
+	 */
+	if (!mem->last_scanned_child)
+		cgroup = list_first_entry(&mem->css.cgroup->children,
+				struct cgroup, sibling);
+	else
+		cgroup = mem->last_scanned_child->css.cgroup;
+
+	cg_current = cgroup;
+
+	do {
+		struct list_head *next;
+
+		mem_child = mem_cgroup_from_cont(cgroup);
+		cgroup_unlock();
+
+		ret = mem_cgroup_hierarchical_reclaim(mem_child, root_mem,
+							gfp_mask);
+		cgroup_lock();
+		mem->last_scanned_child = mem_child;
+		if (res_counter_check_under_limit(&root_mem->res)) {
+			ret = 0;
+			goto done;
+		}
+
+		/*
+		 * Since we gave up the lock, it is time to
+		 * start from last cgroup
+		 */
+		cgroup = mem->last_scanned_child->css.cgroup;
+		next = cgroup->sibling.next;
+
+		if (next == &cg_current->parent->children)
+			cgroup = list_first_entry(&mem->css.cgroup->children,
+							struct cgroup, sibling);
+		else
+			cgroup = container_of(next, struct cgroup, sibling);
+	} while (cgroup != cg_current);
+
+done:
+	cgroup_unlock();
+	return ret;
+}
+
+/*
+ * Charge memory cgroup mem and check if it is over its limit. If so, reclaim
+ * from mem.
+ */
+static int mem_cgroup_charge_and_reclaim(struct mem_cgroup *mem, gfp_t gfp_mask)
+{
+	int ret = 0;
+	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct res_counter *fail_res;
+	struct mem_cgroup *mem_over_limit;
+
+	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE, &fail_res))) {
+		if (!(gfp_mask & __GFP_WAIT))
+			goto out;
+
+		/*
+		 * Is one of our ancestors over their limit?
+		 */
+		if (fail_res)
+			mem_over_limit = mem_cgroup_from_res_counter(fail_res);
+		else
+			mem_over_limit = mem;
+
+		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit,
+							mem_over_limit,
+							gfp_mask);
+
+		if (!nr_retries--) {
+			mem_cgroup_out_of_memory(mem, gfp_mask);
+			goto out;
+		}
+	}
+out:
+	return ret;
+}
 
 /**
  * mem_cgroup_try_charge - get charge of PAGE_SIZE.
@@ -484,8 +609,7 @@ int mem_cgroup_try_charge(struct mm_stru
 			gfp_t gfp_mask, struct mem_cgroup **memcg)
 {
 	struct mem_cgroup *mem;
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct res_counter *fail_res;
+
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
@@ -510,29 +634,9 @@ int mem_cgroup_try_charge(struct mm_stru
 		css_get(&mem->css);
 	}
 
+	if (mem_cgroup_charge_and_reclaim(mem, gfp_mask))
+		goto nomem;
 
-	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE, &fail_res))) {
-		if (!(gfp_mask & __GFP_WAIT))
-			goto nomem;
-
-		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
-			continue;
-
-		/*
-		 * try_to_free_mem_cgroup_pages() might not give us a full
-		 * picture of reclaim. Some pages are reclaimed and might be
-		 * moved to swap cache or just unmapped from the cgroup.
-		 * Check the limit again to see if the reclaim reduced the
-		 * current usage of the cgroup before giving up
-		 */
-		if (res_counter_check_under_limit(&mem->res))
-			continue;
-
-		if (!nr_retries--) {
-			mem_cgroup_out_of_memory(mem, gfp_mask);
-			goto nomem;
-		}
-	}
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -945,7 +1049,7 @@ static void mem_cgroup_force_empty_list(
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
-static int mem_cgroup_force_empty(struct mem_cgroup *mem)
+static int mem_cgroup_force_empty(struct mem_cgroup *mem, bool cgroup_locked)
 {
 	int ret = -EBUSY;
 	int node, zid;
@@ -959,8 +1063,20 @@ static int mem_cgroup_force_empty(struct
 	while (mem->res.usage > 0) {
 		if (atomic_read(&mem->css.cgroup->count) > 0)
 			goto out;
+
+		/*
+		 * We need to give up the cgroup lock if it is held, since
+		 * it creates the potential for deadlock. cgroup_mutex should
+		 * be acquired after cpu_hotplug lock. In this path, we
+		 * acquire the cpu_hotplug lock after acquiring the cgroup_mutex
+		 * Giving it up should be OK
+		 */
+		if (cgroup_locked)
+			cgroup_unlock();
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
+		if (cgroup_locked)
+			cgroup_lock();
 		for_each_node_state(node, N_POSSIBLE)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				struct mem_cgroup_per_zone *mz;
@@ -1025,7 +1141,7 @@ static int mem_cgroup_reset(struct cgrou
 
 static int mem_force_empty_write(struct cgroup *cont, unsigned int event)
 {
-	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont));
+	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont), false);
 }
 
 static const struct mem_cgroup_stat_desc {
@@ -1195,6 +1311,8 @@ mem_cgroup_create(struct cgroup_subsys *
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
 
+	mem->last_scanned_child = NULL;
+
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)
@@ -1208,7 +1326,7 @@ static void mem_cgroup_pre_destroy(struc
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	mem_cgroup_force_empty(mem);
+	mem_cgroup_force_empty(mem, true);
 }
 
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
@@ -1217,6 +1335,13 @@ static void mem_cgroup_destroy(struct cg
 	int node;
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
 
+	if (cont->parent) {
+		struct mem_cgroup *parent_mem =
+			mem_cgroup_from_cont(cont->parent);
+		if (parent_mem->last_scanned_child == mem)
+			parent_mem->last_scanned_child = NULL;
+	}
+
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
_

-- 
	Balbir
