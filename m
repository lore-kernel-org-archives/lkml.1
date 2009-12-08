Return-Path: <linux-kernel-owner+w=401wt.eu-S966400AbZLHVTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966400AbZLHVTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966388AbZLHVSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:18:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966288AbZLHVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:32 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com,
       hugh.dickins@tiscali.co.uk, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [21/31] memcg: rename and export try_get_mem_cgroup_from_page()
Message-Id: <20091208211637.7EF75B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

So that the hwpoison injector can get mem_cgroup for arbitrary page
and thus know whether it is owned by some mem_cgroup task(s).

CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   11 ++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

Index: linux/mm/memcontrol.c
===================================================================
--- linux.orig/mm/memcontrol.c
+++ linux/mm/memcontrol.c
@@ -1379,25 +1379,22 @@ static struct mem_cgroup *mem_cgroup_loo
 	return container_of(css, struct mem_cgroup, css);
 }
 
-static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
+struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 	struct page_cgroup *pc;
 	unsigned short id;
 	swp_entry_t ent;
 
 	VM_BUG_ON(!PageLocked(page));
 
-	if (!PageSwapCache(page))
-		return NULL;
-
 	pc = lookup_page_cgroup(page);
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
 		mem = pc->mem_cgroup;
 		if (mem && !css_tryget(&mem->css))
 			mem = NULL;
-	} else {
+	} else if (PageSwapCache(page)) {
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup(ent);
 		rcu_read_lock();
@@ -1742,7 +1739,7 @@ int mem_cgroup_try_charge_swapin(struct
 	 */
 	if (!PageSwapCache(page))
 		return 0;
-	mem = try_get_mem_cgroup_from_swapcache(page);
+	mem = try_get_mem_cgroup_from_page(page);
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
Index: linux/include/linux/memcontrol.h
===================================================================
--- linux.orig/include/linux/memcontrol.h
+++ linux/include/linux/memcontrol.h
@@ -68,6 +68,7 @@ extern unsigned long mem_cgroup_isolate_
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
+extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 static inline
@@ -189,6 +190,11 @@ mem_cgroup_move_lists(struct page *page,
 {
 }
 
+static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
+{
+	return NULL;
+}
+
 static inline int mm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
 {
 	return 1;
