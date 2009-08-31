Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZHaKnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZHaKnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZHaKnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:43:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:48391 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbZHaKnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182301558"
Message-Id: <20090831104216.759762658@intel.com>
References: <20090831102640.092092954@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 31 Aug 2009 18:26:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: lizf@cn.fujitsu.com
CC: nishimura@mxp.nes.nec.co.jp
cc: menage@google.com
CC: linux-mm <linux-mm@kvack.org>
Subject: [RFC][PATCH 2/4] memcg: rename and export try_get_mem_cgroup_from_page()
Content-Disposition: inline; filename=memcg-try_get_mem_cgroup_from_page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwpoison injection code need to get the mem_cgroup from
arbitrary page in order to check its css_id.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/memcontrol.h |    6 ++++++
 mm/memcontrol.c            |   12 +++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

--- linux-mm.orig/mm/memcontrol.c	2009-08-31 15:41:50.000000000 +0800
+++ linux-mm/mm/memcontrol.c	2009-08-31 15:41:53.000000000 +0800
@@ -1385,25 +1385,22 @@ static struct mem_cgroup *mem_cgroup_loo
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
@@ -1415,6 +1412,7 @@ static struct mem_cgroup *try_get_mem_cg
 	unlock_page_cgroup(pc);
 	return mem;
 }
+EXPORT_SYMBOL(try_get_mem_cgroup_from_page);
 
 /*
  * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
@@ -1749,7 +1747,7 @@ int mem_cgroup_try_charge_swapin(struct 
 	 */
 	if (!PageSwapCache(page))
 		return 0;
-	mem = try_get_mem_cgroup_from_swapcache(page);
+	mem = try_get_mem_cgroup_from_page(page);
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
--- linux-mm.orig/include/linux/memcontrol.h	2009-08-31 15:41:50.000000000 +0800
+++ linux-mm/include/linux/memcontrol.h	2009-08-31 15:41:53.000000000 +0800
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

-- 

