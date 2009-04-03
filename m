Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbZDCIPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbZDCIPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbZDCIPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:15:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47486 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbZDCIPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:15:19 -0400
Date: Fri, 3 Apr 2009 17:13:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 5/9] add more hooks and check in lazy manner
Message-Id: <20090403171349.aa598593.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090403170835.a2d6cbc3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Adds 2 more soft limit update hooks.
 - uncharge
 - write to memory.soft_limit_in_bytes file.
And fixes issues under hierarchy. (This is the most complicated part...)

Because ucharge() can be called under very busy spin_lock, all checks should be 
done in lazy. We can use this lazy work to charge() part and make use of it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 11 deletions(-)

Index: softlimit-test2/mm/memcontrol.c
===================================================================
--- softlimit-test2.orig/mm/memcontrol.c
+++ softlimit-test2/mm/memcontrol.c
@@ -200,6 +200,8 @@ struct mem_cgroup {
 #define SL_ANON (0)
 #define SL_FILE (1)
 	atomic_t soft_limit_update;
+	struct work_struct soft_limit_work;
+
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -989,6 +991,23 @@ static int mem_cgroup_soft_limit_prio(st
 	return __calc_soft_limit_prio(max_excess);
 }
 
+static struct mem_cgroup *
+mem_cgroup_soft_limit_need_check(struct mem_cgroup *mem)
+{
+	struct res_counter *c = &mem->res;
+	unsigned long excess, prio;
+
+	do {
+		excess = res_counter_soft_limit_excess(c) >> PAGE_SHIFT;
+		prio = __calc_soft_limit_prio(excess);
+		mem = container_of(c, struct mem_cgroup, res);
+		if (mem->soft_limit_priority != prio)
+			return mem;
+		c = c->parent;
+	} while (c);
+	return NULL;
+}
+
 static void __mem_cgroup_requeue(struct mem_cgroup *mem, int prio)
 {
 	/* enqueue to softlimit queue */
@@ -1028,18 +1047,36 @@ __mem_cgroup_update_soft_limit_cb(struct
 	return 0;
 }
 
-static void mem_cgroup_update_soft_limit(struct mem_cgroup *mem)
+static void mem_cgroup_update_soft_limit_work(struct work_struct *work)
 {
-	int priority;
+	struct mem_cgroup *mem;
+
+	mem = container_of(work, struct mem_cgroup, soft_limit_work);
+
+	mem_cgroup_walk_tree(mem, NULL, __mem_cgroup_update_soft_limit_cb);
+	atomic_set(&mem->soft_limit_update, 0);
+	css_put(&mem->css);
+}
+
+static void mem_cgroup_update_soft_limit_lazy(struct mem_cgroup *mem)
+{
+	int ret, priority;
+	struct mem_cgroup * root;
+
+	/*
+	 * check status change under hierarchy.
+	 */
+	root = mem_cgroup_soft_limit_need_check(mem);
+	if (!root)
+		return;
+
+	if (atomic_inc_return(&root->soft_limit_update) > 1)
+		return;
+	css_get(&root->css);
+	ret = schedule_work(&root->soft_limit_work);
+	if (!ret)
+		css_put(&root->css);
 
-	/* check status change */
-	priority = mem_cgroup_soft_limit_prio(mem);
-	if (priority != mem->soft_limit_priority &&
-	    atomic_inc_return(&mem->soft_limit_update) > 1) {
-		mem_cgroup_walk_tree(mem, NULL,
-				     __mem_cgroup_update_soft_limit_cb);
-		atomic_set(&mem->soft_limit_update, 0);
-	}
 	return;
 }
 
@@ -1145,7 +1182,7 @@ static int __mem_cgroup_try_charge(struc
 	}
 
 	if (soft_fail && mem_cgroup_soft_limit_check(mem))
-		mem_cgroup_update_soft_limit(mem);
+		mem_cgroup_update_soft_limit_lazy(mem);
 
 	return 0;
 nomem:
@@ -1625,6 +1662,9 @@ __mem_cgroup_uncharge_common(struct page
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
+	if (mem->soft_limit_priority && mem_cgroup_soft_limit_check(mem))
+		mem_cgroup_update_soft_limit_lazy(mem);
+
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		css_put(&mem->css);
@@ -2163,6 +2203,9 @@ static int mem_cgroup_write(struct cgrou
 			ret = res_counter_set_soft_limit(&memcg->res, val);
 		else
 			ret = -EINVAL;
+		if (!ret)
+			mem_cgroup_update_soft_limit_lazy(memcg);
+
 		break;
 	default:
 		ret = -EINVAL; /* should be BUG() ? */
@@ -2648,6 +2691,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	INIT_LIST_HEAD(&mem->soft_limit_list[SL_ANON]);
 	INIT_LIST_HEAD(&mem->soft_limit_list[SL_FILE]);
 	spin_lock_init(&mem->reclaim_param_lock);
+	INIT_WORK(&mem->soft_limit_work, mem_cgroup_update_soft_limit_work);
 
 	if (parent)
 		mem->swappiness = get_swappiness(parent);

