Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbYK0HJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbYK0HJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 02:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYK0HJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 02:09:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52778 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYK0HJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 02:09:18 -0500
Date: Thu, 27 Nov 2008 16:08:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       taka@valinux.co.jp
Subject: [RFC][PATCH 2/2] memcg: hierarchy reclaim with CGROUP ID
Message-Id: <20081127160828.6288a830.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081127160548.3274c8e6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081127160548.3274c8e6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement hierarchy reclaim by cgroup_id.

What changes:
	- reclaim is not done by tree-walk algorithm
	- mem_cgroup->last_schan_child is ID, not pointer.
	- no cgroup_lock.
	- scanning order is just defined by ID's order.
	  (Scan by round-robin logic.)
	- Order of scanning can be changed easily(maybe).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujisu.com>


 mm/memcontrol.c |  129 +++++++++++---------------------------------------------
 1 file changed, 27 insertions(+), 102 deletions(-)

Index: mmotm-2.6.28-Nov24/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov24.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov24/mm/memcontrol.c
@@ -148,7 +148,7 @@ struct mem_cgroup {
 	 * While reclaiming in a hiearchy, we cache the last child we
 	 * reclaimed from. Protected by cgroup_lock()
 	 */
-	struct mem_cgroup *last_scanned_child;
+	int		last_scan_child;
 	/*
 	 * Should the accounting and control be hierarchical, per subtree?
 	 */
@@ -472,102 +472,31 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
-#define mem_cgroup_from_res_counter(counter, member)	\
-	container_of(counter, struct mem_cgroup, member)
-
+#define mem_cgroup_from_res_counter(counter, member)   \
+		container_of(counter, struct mem_cgroup, member)
 /*
- * This routine finds the DFS walk successor. This routine should be
- * called with cgroup_mutex held
+ * get the cgroup under hierarchy under root. start from root->last_scan_child
+ * and root->last_scanned_child is updated.
  */
 static struct mem_cgroup *
-mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
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
-		mem_cgroup_put(curr);
-		cgroup = list_entry(curr_cgroup->children.next,
-						struct cgroup, sibling);
-		curr = mem_cgroup_from_cont(cgroup);
-		mem_cgroup_get(curr);
-		goto done;
-	}
-
-visit_parent:
-	if (curr_cgroup == root_cgroup) {
-		mem_cgroup_put(curr);
-		curr = root_mem;
-		mem_cgroup_get(curr);
-		goto done;
-	}
-
-	/*
-	 * Goto next sibling
-	 */
-	if (curr_cgroup->sibling.next != &curr_cgroup->parent->children) {
-		mem_cgroup_put(curr);
-		cgroup = list_entry(curr_cgroup->sibling.next, struct cgroup,
-						sibling);
-		curr = mem_cgroup_from_cont(cgroup);
-		mem_cgroup_get(curr);
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
-	root_mem->last_scanned_child = curr;
-	return curr;
-}
-
-/*
- * Visit the first child (need not be the first child as per the ordering
- * of the cgroup list, since we track last_scanned_child) of @mem and use
- * that to reclaim free pages from.
- */
-static struct mem_cgroup *
-mem_cgroup_get_first_node(struct mem_cgroup *root_mem)
+mem_cgroup_get_reclaim_target(struct mem_cgroup *root_mem)
 {
 	struct cgroup *cgroup;
+	struct cgroup *root = root_mem->css.cgroup;
 	struct mem_cgroup *ret;
-	bool obsolete = (root_mem->last_scanned_child &&
-				root_mem->last_scanned_child->obsolete);
-
-	/*
-	 * Scan all children under the mem_cgroup mem
-	 */
-	cgroup_lock();
-	if (list_empty(&root_mem->css.cgroup->children)) {
-		ret = root_mem;
-		goto done;
-	}
-
-	if (!root_mem->last_scanned_child || obsolete) {
-
-		if (obsolete)
-			mem_cgroup_put(root_mem->last_scanned_child);
+	int id;
 
-		cgroup = list_first_entry(&root_mem->css.cgroup->children,
-				struct cgroup, sibling);
+	while (!ret) {
+		rcu_read_lock();
+		cgroup = cgroup_get_next(root_mem->last_scan_child, root, &id);
 		ret = mem_cgroup_from_cont(cgroup);
-		mem_cgroup_get(ret);
-	} else
-		ret = mem_cgroup_get_next_node(root_mem->last_scanned_child,
-						root_mem);
+		rcu_read_unlock();
+		root_mem->last_scan_child = id + 1;
+		if (ret->obsolete)
+			ret = NULL;
+	}
+	mem_cgroup_get(ret);
 
-done:
-	root_mem->last_scanned_child = ret;
-	cgroup_unlock();
 	return ret;
 }
 
@@ -581,7 +510,7 @@ done:
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 						gfp_t gfp_mask, bool noswap)
 {
-	struct mem_cgroup *next_mem;
+	struct mem_cgroup *next_mem, *start;
 	int ret = 0;
 
 	/*
@@ -595,23 +524,21 @@ static int mem_cgroup_hierarchical_recla
 	if (res_counter_check_under_limit(&root_mem->res))
 		return 0;
 
-	next_mem = mem_cgroup_get_first_node(root_mem);
-
-	while (next_mem != root_mem) {
+	next_mem = mem_cgroup_get_reclaim_target(root_mem);
+	start = next_mem;
+	do {
 		if (next_mem->obsolete) {
 			mem_cgroup_put(next_mem);
-			cgroup_lock();
-			next_mem = mem_cgroup_get_first_node(root_mem);
-			cgroup_unlock();
+			next_mem = mem_cgroup_get_reclaim_target(root_mem);
 			continue;
 		}
 		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
+		mem_cgroup_put(next_mem);
 		if (res_counter_check_under_limit(&root_mem->res))
-			return 0;
-		cgroup_lock();
-		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
-		cgroup_unlock();
-	}
+			break;
+		next_mem = mem_cgroup_get_reclaim_target(root_mem);
+	} while (start != next_mem);
+
 	return ret;
 }
 
@@ -1959,8 +1886,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 
-	mem->last_scanned_child = NULL;
-
 	return &mem->css;
 free_out:
 	for_each_node_state(node, N_POSSIBLE)

