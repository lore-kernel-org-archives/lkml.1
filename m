Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYLVKbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYLVKbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYLVKbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:31:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYLVKbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:31:01 -0500
Date: Mon, 22 Dec 2008 19:29:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [RFC][PATCH] memcg: fix shmem's swap accounting
Message-Id: <20081222192959.72ba2573.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shmem's swap accounting is broken now. 
 - At swap-in, most of pages are not charged back to original memcg,
   but charged againt current->mm,
This is a fix.
Maybe this is clearler than current implementation of memcg in mmotm.
But I'd like to postpone this until the next year, merge window will come soon.

Nishimura-san, please take this as known issue, I'll maintain/update this fix.

Thank you all for your help in this year.

Thanks,
-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, you can see following even when swap accounting is enabled.

 1. Create Group 01, and 02.
 2. allocate a "file" on tmpfs by a task under 01.
 3. swap out the "file" (by memory pressure)
 4. Read "file" from a task in group 02.
 5. the charge of "file" is moved to group 02.

This is not ideal behavior. This is because SwapCache which was loaded
by read-ahead is not taken into account..

This is a patch to fix shmem's swapcache behavior.
  - remove mem_cgroup_cache_charge_swapin().
  - Add SwapCache handler routine to mem_cgroup_cache_charge().
    By this, shmem's file cache is charged at add_to_page_cache()
    with GFP_NOWAIT.
  - pass the page of swapcache to shrink_mem_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    7 +-
 include/linux/swap.h       |    8 --
 mm/memcontrol.c            |  134 ++++++++++++++++++++-------------------------
 mm/shmem.c                 |   30 ++++------
 4 files changed, 76 insertions(+), 103 deletions(-)

Index: mmotm-2.6.28-Dec19/mm/shmem.c
===================================================================
--- mmotm-2.6.28-Dec19.orig/mm/shmem.c
+++ mmotm-2.6.28-Dec19/mm/shmem.c
@@ -929,11 +929,11 @@ found:
 	if (!inode)
 		goto out;
 	/*
-	 * Charge page using GFP_HIGHUSER_MOVABLE while we can wait.
-	 * charged back to the user(not to caller) when swap account is used.
+	 * Charge page using GFP_KERNEL while we can wait.
+	 * Charged back to the user(not to caller) when swap account is used.
+	 * add_to_page_cache() will be called with GFP_NOWAIT.
 	 */
-	error = mem_cgroup_cache_charge_swapin(page, current->mm, GFP_KERNEL,
-					true);
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1270,16 +1270,6 @@ repeat:
 				goto repeat;
 			}
 			wait_on_page_locked(swappage);
-			/*
-			 * We want to avoid charge at add_to_page_cache().
-			 * charge against this swap cache here.
-			 */
-			if (mem_cgroup_cache_charge_swapin(swappage,
-				current->mm, gfp & GFP_RECLAIM_MASK, false)) {
-				page_cache_release(swappage);
-				error = -ENOMEM;
-				goto failed;
-			}
 			page_cache_release(swappage);
 			goto repeat;
 		}
@@ -1334,15 +1324,19 @@ repeat:
 		} else {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
-			unlock_page(swappage);
-			page_cache_release(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_shrink_usage(current->mm,
+				error = mem_cgroup_shrink_usage(swappage,
+								current->mm,
 								gfp);
-				if (error)
+				if (error) {
+					unlock_page(swappage);
+					page_cache_release(swappage);
 					goto failed;
+				}
 			}
+			unlock_page(swappage);
+			page_cache_release(swappage);
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
Index: mmotm-2.6.28-Dec19/include/linux/swap.h
===================================================================
--- mmotm-2.6.28-Dec19.orig/include/linux/swap.h
+++ mmotm-2.6.28-Dec19/include/linux/swap.h
@@ -338,16 +338,8 @@ static inline void disable_swap_token(vo
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern int mem_cgroup_cache_charge_swapin(struct page *page,
-				struct mm_struct *mm, gfp_t mask, bool locked);
 extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
 #else
-static inline
-int mem_cgroup_cache_charge_swapin(struct page *page,
-				struct mm_struct *mm, gfp_t mask, bool locked)
-{
-	return 0;
-}
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
 {
Index: mmotm-2.6.28-Dec19/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec19.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec19/mm/memcontrol.c
@@ -886,6 +886,23 @@ nomem:
 	return -ENOMEM;
 }
 
+static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
+{
+	struct mem_cgroup *mem;
+	swp_entry_t ent;
+
+	if (!PageSwapCache(page))
+		return NULL;
+
+	ent.val = page_private(page);
+	mem = lookup_swap_cgroup(ent);
+	if (!mem)
+		return NULL;
+	if (!css_tryget(&mem->css))
+		return NULL;
+	return mem;
+}
+
 /*
  * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
  * USED state. If already USED, uncharge and return.
@@ -1077,6 +1094,9 @@ int mem_cgroup_newpage_charge(struct pag
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	struct mem_cgroup *mem = NULL;
+	int ret;
+
 	if (mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
@@ -1089,6 +1109,8 @@ int mem_cgroup_cache_charge(struct page 
 	 * For GFP_NOWAIT case, the page may be pre-charged before calling
 	 * add_to_page_cache(). (See shmem.c) check it here and avoid to call
 	 * charge twice. (It works but has to pay a bit larger cost.)
+	 * And when the page is SwapCache, it should take swap information
+	 * into account. This is under lock_page() now.
 	 */
 	if (!(gfp_mask & __GFP_WAIT)) {
 		struct page_cgroup *pc;
@@ -1105,15 +1127,40 @@ int mem_cgroup_cache_charge(struct page 
 		unlock_page_cgroup(pc);
 	}
 
-	if (unlikely(!mm))
+	if (do_swap_account && PageSwapCache(page)) {
+		mem = try_get_mem_cgroup_from_swapcache(page);
+		if (mem)
+			mm = NULL;
+		  else
+			mem = NULL;
+		/* SwapCache may be still linked to LRU now. */
+		mem_cgroup_lru_del_before_commit_swapcache(page);
+	}
+
+	if (unlikely(!mm && !mem))
 		mm = &init_mm;
 
 	if (page_is_file_cache(page))
 		return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
-	else
-		return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
+
+	ret = mem_cgroup_charge_common(page, mm, gfp_mask,
+				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+	if (mem)
+		css_put(&mem->css);
+	if (PageSwapCache(page))
+		mem_cgroup_lru_add_after_commit_swapcache(page);
+
+	if (do_swap_account && !ret && PageSwapCache(page)) {
+		swp_entry_t ent = {.val = page_private(page)};
+		/* avoid double counting */
+		mem = swap_cgroup_record(ent, NULL);
+		if (mem) {
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+			mem_cgroup_put(mem);
+		}
+	}
+	return ret;
 }
 
 /*
@@ -1127,7 +1174,6 @@ int mem_cgroup_try_charge_swapin(struct 
 				 gfp_t mask, struct mem_cgroup **ptr)
 {
 	struct mem_cgroup *mem;
-	swp_entry_t     ent;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -1135,7 +1181,6 @@ int mem_cgroup_try_charge_swapin(struct 
 
 	if (!do_swap_account)
 		goto charge_cur_mm;
-
 	/*
 	 * A racing thread's fault, or swapoff, may have already updated
 	 * the pte, and even removed page from swap cache: return success
@@ -1143,14 +1188,9 @@ int mem_cgroup_try_charge_swapin(struct 
 	 */
 	if (!PageSwapCache(page))
 		return 0;
-
-	ent.val = page_private(page);
-
-	mem = lookup_swap_cgroup(ent);
+	mem = try_get_mem_cgroup_from_swapcache(page);
 	if (!mem)
 		goto charge_cur_mm;
-	if (!css_tryget(&mem->css))
-		goto charge_cur_mm;
 	*ptr = mem;
 	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
 	/* drop extra refcnt from tryget */
@@ -1162,62 +1202,6 @@ charge_cur_mm:
 	return __mem_cgroup_try_charge(mm, mask, ptr, true);
 }
 
-#ifdef CONFIG_SWAP
-
-int mem_cgroup_cache_charge_swapin(struct page *page,
-			struct mm_struct *mm, gfp_t mask, bool locked)
-{
-	int ret = 0;
-
-	if (mem_cgroup_disabled())
-		return 0;
-	if (unlikely(!mm))
-		mm = &init_mm;
-	if (!locked)
-		lock_page(page);
-	/*
-	 * If not locked, the page can be dropped from SwapCache until
-	 * we reach here.
-	 */
-	if (PageSwapCache(page)) {
-		struct mem_cgroup *mem = NULL;
-		swp_entry_t ent;
-
-		ent.val = page_private(page);
-		if (do_swap_account) {
-			mem = lookup_swap_cgroup(ent);
-			if (mem) {
-				if (css_tryget(&mem->css))
-					mm = NULL; /* charge to recorded */
-				else
-					mem = NULL; /* charge to current */
-			}
-		}
-		/* SwapCache may be still linked to LRU now. */
-		mem_cgroup_lru_del_before_commit_swapcache(page);
-		ret = mem_cgroup_charge_common(page, mm, mask,
-				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
-		mem_cgroup_lru_add_after_commit_swapcache(page);
-		/* drop extra refcnt from tryget */
-		if (mem)
-			css_put(&mem->css);
-
-		if (!ret && do_swap_account) {
-			/* avoid double counting */
-			mem = swap_cgroup_record(ent, NULL);
-			if (mem) {
-				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-				mem_cgroup_put(mem);
-			}
-		}
-	}
-	if (!locked)
-		unlock_page(page);
-
-	return ret;
-}
-#endif
-
 void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 {
 	struct page_cgroup *pc;
@@ -1479,18 +1463,20 @@ void mem_cgroup_end_migration(struct mem
  * This is typically used for page reclaiming for shmem for reducing side
  * effect of page allocation from shmem, which is used by some mem_cgroup.
  */
-int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+int mem_cgroup_shrink_usage(struct page *page,
+			    struct mm_struct *mm,
+			    gfp_t gfp_mask)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
 	if (mem_cgroup_disabled())
 		return 0;
-	if (!mm)
-		return 0;
-
-	mem = try_get_mem_cgroup_from_mm(mm);
+	if (page)
+		mem = try_get_mem_cgroup_from_swapcache(page);
+	if (!mem && mm)
+		mem = try_get_mem_cgroup_from_mm(mm);
 	if (unlikely(!mem))
 		return 0;
 
Index: mmotm-2.6.28-Dec19/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Dec19.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Dec19/include/linux/memcontrol.h
@@ -56,8 +56,8 @@ extern void mem_cgroup_move_lists(struct
 				  enum lru_list from, enum lru_list to);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
-extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
-				
+extern int mem_cgroup_shrink_usage(struct page *page,
+			struct mm_struct *mm, gfp_t gfp_mask);
 
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
@@ -156,7 +156,8 @@ static inline void mem_cgroup_uncharge_c
 {
 }
 
-static inline int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+static inline int mem_cgroup_shrink_usage(struct page *page,
+			struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return 0;
 }

