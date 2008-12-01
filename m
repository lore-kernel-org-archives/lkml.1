Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbYLAKGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbYLAKGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYLAKG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:06:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37844 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYLAKG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:06:26 -0500
Date: Mon, 1 Dec 2008 19:05:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       hugh@veritas.com, nickpiggin@yahoo.com.au, knikanth@suse.de,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/4] memcg: explaing memcg's gfp_mask behavior in explicit
 way.
Message-Id: <20081201190534.1612b0b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081201190021.f3ab1f17.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_xxx_charge(...gfpmask) function take gfpmask as its argument.
But this gfp_t is only used for check GFP_RECALIM_MASK. In other words,
memcg has no interst where the memory should be reclaimed from.
It just see usage of pages.

Using bare gfp_t is misleading and this is a patch for explaining
expected behavior in explicit way. (better name/code is welcome.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 include/linux/gfp.h |   19 +++++++++++++++++++
 mm/filemap.c        |    2 +-
 mm/memory.c         |   12 +++++++-----
 mm/shmem.c          |    8 ++++----
 mm/swapfile.c       |    2 +-
 mm/vmscan.c         |    3 +--
 6 files changed, 33 insertions(+), 13 deletions(-)

Index: mmotm-2.6.28-Nov30/include/linux/gfp.h
===================================================================
--- mmotm-2.6.28-Nov30.orig/include/linux/gfp.h
+++ mmotm-2.6.28-Nov30/include/linux/gfp.h
@@ -245,4 +245,23 @@ void drain_zone_pages(struct zone *zone,
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+static inline gfp_t gfp_memcg_mask(gfp_t gfp)
+{
+	gfp_t mask;
+	/*
+	 * Memory Resource Controller memory reclaim is called to reduce usage
+	 * of memory, not to get free memory from specified area.
+	 * Remove zone constraints.
+	 */
+	mask = gfp & GFP_RECLAIM_MASK;
+	return mask | (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
+}
+#else
+static inline gfp_t gfp_memcg_mask(gfp_t gfp)
+{
+	return gfp;
+}
+#endif
+
 #endif /* __LINUX_GFP_H */
Index: mmotm-2.6.28-Nov30/mm/filemap.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/filemap.c
+++ mmotm-2.6.28-Nov30/mm/filemap.c
@@ -461,7 +461,7 @@ int add_to_page_cache_locked(struct page
 	VM_BUG_ON(!PageLocked(page));
 
 	error = mem_cgroup_cache_charge(page, current->mm,
-					gfp_mask & ~__GFP_HIGHMEM);
+					gfp_memcg_mask(gfp_mask));
 	if (error)
 		goto out;
 
Index: mmotm-2.6.28-Nov30/mm/vmscan.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/vmscan.c
+++ mmotm-2.6.28-Nov30/mm/vmscan.c
@@ -1733,8 +1733,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	if (noswap)
 		sc.may_swap = 0;
 
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
+	sc.gfp_mask = gfp_memcg_mask(gfp_mask);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
 	return do_try_to_free_pages(zonelist, &sc);
 }
Index: mmotm-2.6.28-Nov30/mm/memory.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/memory.c
+++ mmotm-2.6.28-Nov30/mm/memory.c
@@ -1913,7 +1913,8 @@ gotten:
 	cow_user_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_HIGHUSER_MOVABLE))
+	if (mem_cgroup_newpage_charge(new_page, mm,
+			gfp_memcg_mask(GFP_HIGHUSER_MOVABLE)))
 		goto oom_free_new;
 
 	/*
@@ -2345,7 +2346,7 @@ static int do_swap_page(struct mm_struct
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
 	if (mem_cgroup_try_charge_swapin(mm, page,
-				GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
+		gfp_memcg_mask(GFP_HIGHUSER_MOVABLE), &ptr) == -ENOMEM) {
 		ret = VM_FAULT_OOM;
 		unlock_page(page);
 		goto out;
@@ -2437,7 +2438,8 @@ static int do_anonymous_page(struct mm_s
 		goto oom;
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_HIGHUSER_MOVABLE))
+	if (mem_cgroup_newpage_charge(page, mm,
+				gfp_memcg_mask(GFP_HIGHUSER_MOVABLE)))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -2528,8 +2530,8 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			if (mem_cgroup_newpage_charge(page,
-						mm, GFP_HIGHUSER_MOVABLE)) {
+			if (mem_cgroup_newpage_charge(page, mm,
+					gfp_memcg_mask(GFP_HIGHUSER_MOVABLE))) {
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
Index: mmotm-2.6.28-Nov30/mm/swapfile.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/swapfile.c
+++ mmotm-2.6.28-Nov30/mm/swapfile.c
@@ -698,7 +698,7 @@ static int unuse_pte(struct vm_area_stru
 	int ret = 1;
 
 	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
-					GFP_HIGHUSER_MOVABLE, &ptr))
+				gfp_memcg_mask(GFP_HIGHUSER_MOVABLE), &ptr))
 		ret = -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
Index: mmotm-2.6.28-Nov30/mm/shmem.c
===================================================================
--- mmotm-2.6.28-Nov30.orig/mm/shmem.c
+++ mmotm-2.6.28-Nov30/mm/shmem.c
@@ -924,8 +924,8 @@ found:
 	 * Charge page using GFP_HIGHUSER_MOVABLE while we can wait.
 	 * charged back to the user(not to caller) when swap account is used.
 	 */
-	error = mem_cgroup_cache_charge_swapin(page,
-			current->mm, GFP_HIGHUSER_MOVABLE, true);
+	error = mem_cgroup_cache_charge_swapin(page, current->mm,
+			gfp_memcg_mask(GFP_HIGHUSER_MOVABLE), true);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1267,7 +1267,7 @@ repeat:
 			 * charge against this swap cache here.
 			 */
 			if (mem_cgroup_cache_charge_swapin(swappage,
-						current->mm, gfp, false)) {
+				current->mm, gfp_memcg_mask(gfp), false)) {
 				page_cache_release(swappage);
 				error = -ENOMEM;
 				goto failed;
@@ -1385,7 +1385,7 @@ repeat:
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
-					GFP_HIGHUSER_MOVABLE);
+					gfp_memcg_mask(GFP_HIGHUSER_MOVABLE));
 			if (error) {
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);

