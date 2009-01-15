Return-Path: <linux-kernel-owner+w=401wt.eu-S1763778AbZAOKbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763778AbZAOKbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbZAOKax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:30:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55450 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760483AbZAOKav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:30:51 -0500
Date: Thu, 15 Jan 2009 19:29:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 3/4] memcg: hierarchical reclaim by CSS ID
Message-Id: <20090115192943.7c1df53a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir, I updated comments for reclaim mechanism. If still unclear, 
plz order.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Use css ID in memcg.

Assigning CSS ID for each memcg and use css_get_next() for scanning hierarchy.

	Assume folloing tree.

	group_A (ID=3)
		/01 (ID=4)
		   /0A (ID=7)
		/02 (ID=10)
	group_B (ID=5)
	and task in group_A/01/0A hits limit at group_A.

	reclaim will be done in following order (round-robin).
	group_A(3) -> group_A/01 (4) -> group_A/01/0A (7) -> group_A/02(10)
	-> group_A -> .....

	Round robin by ID. The last visited cgroup is recorded and restart
	from it when it start reclaim again.
	(More smart algorithm can be implemented..)

	No cgroup_mutex or hierarchy_mutex is required.

Changelog (v2) -> (v3)
  - Added css_is_populatd() check
  - Adjusted to rc1 + Nishimrua's fixes.
  - Increased comments.

Changelog (v1) -> (v2)
  - Updated texts.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
Index: mmotm-2.6.29-Jan14/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Jan14.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Jan14/mm/memcontrol.c
@@ -154,9 +154,13 @@ struct mem_cgroup {
 
 	/*
 	 * While reclaiming in a hiearchy, we cache the last child we
-	 * reclaimed from. Protected by hierarchy_mutex
+	 * reclaimed from. scan_age is incremented when this is the root
+	 * of hierarchical reclaim and hierarchical reclaim visit this.
+	 * When scan_age is updated by 2, exit loop and check we have to
+	 * retry more. (see hierarchical reclaim codes.)
 	 */
-	struct mem_cgroup *last_scanned_child;
+	int last_scanned_child;
+	unsigned long scan_age;
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
@@ -628,103 +632,6 @@ unsigned long mem_cgroup_isolate_pages(u
 #define mem_cgroup_from_res_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
-/*
- * This routine finds the DFS walk successor. This routine should be
- * called with hierarchy_mutex held
- */
-static struct mem_cgroup *
-__mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
-{
-	struct cgroup *cgroup, *curr_cgroup, *root_cgroup;
-
-	curr_cgroup = curr->css.cgroup;
-	root_cgroup = root_mem->css.cgroup;
-
-	if (!list_empty(&curr_cgroup->children)) {
-		/*
-		 * Walk down to children
-		 */
-		cgroup = list_entry(curr_cgroup->children.next,
-						struct cgroup, sibling);
-		curr = mem_cgroup_from_cont(cgroup);
-		goto done;
-	}
-
-visit_parent:
-	if (curr_cgroup == root_cgroup) {
-		/* caller handles NULL case */
-		curr = NULL;
-		goto done;
-	}
-
-	/*
-	 * Goto next sibling
-	 */
-	if (curr_cgroup->sibling.next != &curr_cgroup->parent->children) {
-		cgroup = list_entry(curr_cgroup->sibling.next, struct cgroup,
-						sibling);
-		curr = mem_cgroup_from_cont(cgroup);
-		goto done;
-	}
-
-	/*
-	 * Go up to next parent and next parent's sibling if need be
-	 */
-	curr_cgroup = curr_cgroup->parent;
-	goto visit_parent;
-
-done:
-	return curr;
-}
-
-/*
- * Visit the first child (need not be the first child as per the ordering
- * of the cgroup list, since we track last_scanned_child) of @mem and use
- * that to reclaim free pages from.
- */
-static struct mem_cgroup *
-mem_cgroup_get_next_node(struct mem_cgroup *root_mem)
-{
-	struct cgroup *cgroup;
-	struct mem_cgroup *orig, *next;
-	bool obsolete;
-
-	/*
-	 * Scan all children under the mem_cgroup mem
-	 */
-	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
-
-	orig = root_mem->last_scanned_child;
-	obsolete = mem_cgroup_is_obsolete(orig);
-
-	if (list_empty(&root_mem->css.cgroup->children)) {
-		/*
-		 * root_mem might have children before and last_scanned_child
-		 * may point to one of them. We put it later.
-		 */
-		if (orig)
-			VM_BUG_ON(!obsolete);
-		next = NULL;
-		goto done;
-	}
-
-	if (!orig || obsolete) {
-		cgroup = list_first_entry(&root_mem->css.cgroup->children,
-				struct cgroup, sibling);
-		next = mem_cgroup_from_cont(cgroup);
-	} else
-		next = __mem_cgroup_get_next_node(orig, root_mem);
-
-done:
-	if (next)
-		mem_cgroup_get(next);
-	root_mem->last_scanned_child = next;
-	if (orig)
-		mem_cgroup_put(orig);
-	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
-	return (next) ? next : root_mem;
-}
-
 static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
 {
 	if (do_swap_account) {
@@ -754,46 +661,91 @@ static unsigned int get_swappiness(struc
 }
 
 /*
- * Dance down the hierarchy if needed to reclaim memory. We remember the
- * last child we reclaimed from, so that we don't end up penalizing
- * one child extensively based on its position in the children list.
+ * Visit the first child (need not be the first child as per the ordering
+ * of the cgroup list, since we track last_scanned_child) of @mem and use
+ * that to reclaim free pages from.
+ */
+static struct mem_cgroup *
+mem_cgroup_select_victim(struct mem_cgroup *root_mem)
+{
+	struct mem_cgroup *ret = NULL;
+	struct cgroup_subsys_state *css;
+	int nextid, found;
+
+	if (!root_mem->use_hierarchy) {
+		spin_lock(&root_mem->reclaim_param_lock);
+		root_mem->scan_age++;
+		spin_unlock(&root_mem->reclaim_param_lock);
+		css_get(&root_mem->css);
+		ret = root_mem;
+	}
+
+	while (!ret) {
+		rcu_read_lock();
+		nextid = root_mem->last_scanned_child + 1;
+		css = css_get_next(&mem_cgroup_subsys, nextid, &root_mem->css,
+				   &found);
+		if (css && css_is_populated(css) && css_tryget(css))
+			ret = container_of(css, struct mem_cgroup, css);
+
+		rcu_read_unlock();
+		/* Updates scanning parameter */
+		spin_lock(&root_mem->reclaim_param_lock);
+		if (!css) {
+			/* this means start scan from ID:1 */
+			root_mem->last_scanned_child = 0;
+			root_mem->scan_age++;
+		} else
+			root_mem->last_scanned_child = found;
+		spin_unlock(&root_mem->reclaim_param_lock);
+	}
+
+	return ret;
+}
+
+/*
+ * Scan the hierarchy if needed to reclaim memory. We remember the last child
+ * we reclaimed from, so that we don't end up penalizing one child extensively
+ * based on its position in the children list.
  *
  * root_mem is the original ancestor that we've been reclaim from.
+ *
+ * scan_age is updated every time when select_victim returns "root" and
+ * it's shared under system (per hierarchy root).
+ *
+ * We give up and return to the caller when scan_age is increased by 2. This
+ * means try_to_free_mem_cgroup_pages() is called against all children cgroup,
+ * at least once. The caller itself will do further retry if necessary.
  */
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 						gfp_t gfp_mask, bool noswap)
 {
-	struct mem_cgroup *next_mem;
-	int ret = 0;
-
-	/*
-	 * Reclaim unconditionally and don't check for return value.
-	 * We need to reclaim in the current group and down the tree.
-	 * One might think about checking for children before reclaiming,
-	 * but there might be left over accounting, even after children
-	 * have left.
-	 */
-	ret += try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
-					   get_swappiness(root_mem));
-	if (mem_cgroup_check_under_limit(root_mem))
-		return 1;	/* indicate reclaim has succeeded */
-	if (!root_mem->use_hierarchy)
-		return ret;
-
-	next_mem = mem_cgroup_get_next_node(root_mem);
-
-	while (next_mem != root_mem) {
-		if (mem_cgroup_is_obsolete(next_mem)) {
-			next_mem = mem_cgroup_get_next_node(root_mem);
-			continue;
-		}
-		ret += try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
-						   get_swappiness(next_mem));
+	struct mem_cgroup *victim;
+	unsigned long start_age;
+	int ret, total = 0;
+	/*
+	 * Reclaim memory from cgroups under root_mem in round robin.
+	 */
+	start_age = root_mem->scan_age;
+	/*
+ 	 * Assume a scan starting from somewhere 1,2,3,4,..
+ 	 * ...->1->2->3->4->1->2->3->4->1->2->3->4->.....
+ 	 * check that "1" is visited twice is enough for checking whether
+ 	 * all IDs are scanned. So, here, checking scan_age is updated by 2.
+	 * This scan_age is not time, but just a counter. time_after() is
+	 * a useful to check this kind of counters.
+ 	 */
+	while (time_after((start_age + 2UL), root_mem->scan_age)) {
+		victim = mem_cgroup_select_victim(root_mem);
+		/* we use swappiness of local cgroup */
+		ret = try_to_free_mem_cgroup_pages(victim, gfp_mask, noswap,
+						   get_swappiness(victim));
+		css_put(&victim->css);
+		total += ret;
 		if (mem_cgroup_check_under_limit(root_mem))
-			return 1;	/* indicate reclaim has succeeded */
-		next_mem = mem_cgroup_get_next_node(root_mem);
+			return 1 + total;
 	}
-	return ret;
+	return total;
 }
 
 bool mem_cgroup_oom_called(struct task_struct *task)
@@ -1319,7 +1271,6 @@ __mem_cgroup_uncharge_common(struct page
 	default:
 		break;
 	}
-
 	res_counter_uncharge(&mem->res, PAGE_SIZE);
 	if (do_swap_account && (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
 		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
@@ -2177,6 +2128,8 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	free_css_id(&mem_cgroup_subsys, &mem->css);
+
 	for_each_node_state(node, N_POSSIBLE)
 		free_mem_cgroup_per_zone_info(mem, node);
 
@@ -2214,11 +2167,12 @@ static struct cgroup_subsys_state * __re
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem, *parent;
+	long error = -ENOMEM;
 	int node;
 
 	mem = mem_cgroup_alloc();
 	if (!mem)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(error);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
@@ -2239,7 +2193,8 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->res, NULL);
 		res_counter_init(&mem->memsw, NULL);
 	}
-	mem->last_scanned_child = NULL;
+	mem->last_scanned_child = 0;
+	mem->scan_age = 0;
 	spin_lock_init(&mem->reclaim_param_lock);
 
 	if (parent)
@@ -2248,7 +2203,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(error);
 }
 
 static void mem_cgroup_pre_destroy(struct cgroup_subsys *ss,
@@ -2262,12 +2217,7 @@ static void mem_cgroup_destroy(struct cg
 				struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	struct mem_cgroup *last_scanned_child = mem->last_scanned_child;
 
-	if (last_scanned_child) {
-		VM_BUG_ON(!mem_cgroup_is_obsolete(last_scanned_child));
-		mem_cgroup_put(last_scanned_child);
-	}
 	mem_cgroup_put(mem);
 }
 
@@ -2306,6 +2256,7 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.populate = mem_cgroup_populate,
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
+	.use_id = 1,
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP

