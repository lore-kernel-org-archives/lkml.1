Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZAHKSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZAHKSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZAHKS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:18:26 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44539 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZAHKSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:18:25 -0500
Date: Thu, 8 Jan 2009 19:15:01 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com,
       nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH 3/4] memcg: fix for mem_cgroup_hierarchical_reclaim
Message-Id: <20090108191501.dc469a51.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If root_mem has no children, last_scaned_child is set to root_mem itself.
But after some children added to root_mem, mem_cgroup_get_next_node can
mem_cgroup_put the root_mem although root_mem has not been mem_cgroup_get.

This patch fixes this behavior by:
- Set last_scanned_child to NULL if root_mem has no children or DFS search
  has returned to root_mem itself(root_mem is not a "child" of root_mem).
  Make mem_cgroup_get_first_node return root_mem in this case.
  There are no mem_cgroup_get/put for root_mem.
- Rename mem_cgroup_get_next_node to __mem_cgroup_get_next_node, and
  mem_cgroup_get_first_node to mem_cgroup_get_next_node.
  Make mem_cgroup_hierarchical_reclaim call only new mem_cgroup_get_next_node.


Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 288e22c..dc38a0e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -622,7 +622,7 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
  * called with hierarchy_mutex held
  */
 static struct mem_cgroup *
-mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
+__mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
 {
 	struct cgroup *cgroup, *curr_cgroup, *root_cgroup;
 
@@ -644,8 +644,8 @@ mem_cgroup_get_next_node(struct mem_cgroup *curr, struct mem_cgroup *root_mem)
 visit_parent:
 	if (curr_cgroup == root_cgroup) {
 		mem_cgroup_put(curr);
-		curr = root_mem;
-		mem_cgroup_get(curr);
+		/* caller handles NULL case */
+		curr = NULL;
 		goto done;
 	}
 
@@ -668,7 +668,6 @@ visit_parent:
 	goto visit_parent;
 
 done:
-	root_mem->last_scanned_child = curr;
 	return curr;
 }
 
@@ -678,20 +677,29 @@ done:
  * that to reclaim free pages from.
  */
 static struct mem_cgroup *
-mem_cgroup_get_first_node(struct mem_cgroup *root_mem)
+mem_cgroup_get_next_node(struct mem_cgroup *root_mem)
 {
 	struct cgroup *cgroup;
 	struct mem_cgroup *ret;
 	bool obsolete;
 
-	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
-
 	/*
 	 * Scan all children under the mem_cgroup mem
 	 */
 	mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
+
+	obsolete = mem_cgroup_is_obsolete(root_mem->last_scanned_child);
+
 	if (list_empty(&root_mem->css.cgroup->children)) {
-		ret = root_mem;
+		/*
+		 * root_mem might have children before and last_scanned_child
+		 * may point to one of them.
+		 */
+		if (root_mem->last_scanned_child) {
+			VM_BUG_ON(!obsolete);
+			mem_cgroup_put(root_mem->last_scanned_child);
+		}
+		ret = NULL;
 		goto done;
 	}
 
@@ -705,13 +713,13 @@ mem_cgroup_get_first_node(struct mem_cgroup *root_mem)
 		ret = mem_cgroup_from_cont(cgroup);
 		mem_cgroup_get(ret);
 	} else
-		ret = mem_cgroup_get_next_node(root_mem->last_scanned_child,
+		ret = __mem_cgroup_get_next_node(root_mem->last_scanned_child,
 						root_mem);
 
 done:
 	root_mem->last_scanned_child = ret;
 	mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
-	return ret;
+	return (ret) ? ret : root_mem;
 }
 
 static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
@@ -769,21 +777,18 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 	if (!root_mem->use_hierarchy)
 		return ret;
 
-	next_mem = mem_cgroup_get_first_node(root_mem);
+	next_mem = mem_cgroup_get_next_node(root_mem);
 
 	while (next_mem != root_mem) {
 		if (mem_cgroup_is_obsolete(next_mem)) {
-			mem_cgroup_put(next_mem);
-			next_mem = mem_cgroup_get_first_node(root_mem);
+			next_mem = mem_cgroup_get_next_node(root_mem);
 			continue;
 		}
 		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
 						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
 			return 0;
-		mutex_lock(&mem_cgroup_subsys.hierarchy_mutex);
-		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
-		mutex_unlock(&mem_cgroup_subsys.hierarchy_mutex);
+		next_mem = mem_cgroup_get_next_node(root_mem);
 	}
 	return ret;
 }
