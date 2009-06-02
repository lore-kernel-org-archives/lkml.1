Return-Path: <linux-kernel-owner+w=401wt.eu-S1757676AbZFBDIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676AbZFBDIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZFBDIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:08:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42879 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbZFBDIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:08:34 -0400
Date: Tue, 2 Jun 2009 12:07:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] add swap cache interface for swap reference
Message-Id: <20090602120701.5ad830af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090602120425.0bcff554.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090602120425.0bcff554.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replacement for
 mm-add-swap-cache-interface-for-swap-reference.patch in mmotm.
 but no changes.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In following patch, usage of swap cache will be recorded into swap_map.
This patch is for necessary interface changes to do that.

2 interfaces:
  - swapcache_prepare()
  - swapcache_free()
is added for allocating/freeing refcnt from swap-cache to existing
swap entries. But implementation itself is not changed under this patch.
At adding swapcache_free(), memcg's hook code is moved under swapcache_free().
This is better than using scattered hooks.

Changelog: v1->v2
 - fixed shmem_writepage() error path.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    7 +++++++
 mm/shmem.c           |    2 +-
 mm/swap_state.c      |   11 +++++------
 mm/swapfile.c        |   19 +++++++++++++++++++
 mm/vmscan.c          |    3 +--
 5 files changed, 33 insertions(+), 9 deletions(-)

Index: mmotm-2.6.30-May28/include/linux/swap.h
===================================================================
--- mmotm-2.6.30-May28.orig/include/linux/swap.h
+++ mmotm-2.6.30-May28/include/linux/swap.h
@@ -282,8 +282,10 @@ extern void si_swapinfo(struct sysinfo *
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int swap_duplicate(swp_entry_t);
+extern int swapcache_prepare(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern void swap_free(swp_entry_t);
+extern void swapcache_free(swp_entry_t, struct page *page);
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
@@ -352,11 +354,16 @@ static inline void show_swap_cache_info(
 
 #define free_swap_and_cache(swp)	is_migration_entry(swp)
 #define swap_duplicate(swp)		is_migration_entry(swp)
+#define swapcache_prepare(swp)		is_migration_entry(swp)
 
 static inline void swap_free(swp_entry_t swp)
 {
 }
 
+static inline void swapcache_free(swp_entry_t swp, struct page *page)
+{
+}
+
 static inline struct page *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
Index: mmotm-2.6.30-May28/mm/swap_state.c
===================================================================
--- mmotm-2.6.30-May28.orig/mm/swap_state.c
+++ mmotm-2.6.30-May28/mm/swap_state.c
@@ -162,11 +162,11 @@ int add_to_swap(struct page *page)
 			return 1;
 		case -EEXIST:
 			/* Raced with "speculative" read_swap_cache_async */
-			swap_free(entry);
+			swapcache_free(entry, NULL);
 			continue;
 		default:
 			/* -ENOMEM radix-tree allocation failure */
-			swap_free(entry);
+			swapcache_free(entry, NULL);
 			return 0;
 		}
 	}
@@ -188,8 +188,7 @@ void delete_from_swap_cache(struct page 
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&swapper_space.tree_lock);
 
-	mem_cgroup_uncharge_swapcache(page, entry);
-	swap_free(entry);
+	swapcache_free(entry, page);
 	page_cache_release(page);
 }
 
@@ -293,7 +292,7 @@ struct page *read_swap_cache_async(swp_e
 		/*
 		 * Swap entry may have been freed since our caller observed it.
 		 */
-		if (!swap_duplicate(entry))
+		if (!swapcache_prepare(entry))
 			break;
 
 		/*
@@ -317,7 +316,7 @@ struct page *read_swap_cache_async(swp_e
 		}
 		ClearPageSwapBacked(new_page);
 		__clear_page_locked(new_page);
-		swap_free(entry);
+		swapcache_free(entry, NULL);
 	} while (err != -ENOMEM);
 
 	if (new_page)
Index: mmotm-2.6.30-May28/mm/swapfile.c
===================================================================
--- mmotm-2.6.30-May28.orig/mm/swapfile.c
+++ mmotm-2.6.30-May28/mm/swapfile.c
@@ -510,6 +510,16 @@ void swap_free(swp_entry_t entry)
 }
 
 /*
+ * Called after dropping swapcache to decrease refcnt to swap entries.
+ */
+void swapcache_free(swp_entry_t entry, struct page *page)
+{
+	if (page)
+		mem_cgroup_uncharge_swapcache(page, entry);
+	return swap_free(entry);
+}
+
+/*
  * How many references to page are currently swapped out?
  */
 static inline int page_swapcount(struct page *page)
@@ -1979,6 +1989,15 @@ bad_file:
 	goto out;
 }
 
+/*
+ * Called when allocating swap cache for exising swap entry,
+ */
+int swapcache_prepare(swp_entry_t entry)
+{
+	return swap_duplicate(entry);
+}
+
+
 struct swap_info_struct *
 get_swap_info_struct(unsigned type)
 {
Index: mmotm-2.6.30-May28/mm/vmscan.c
===================================================================
--- mmotm-2.6.30-May28.orig/mm/vmscan.c
+++ mmotm-2.6.30-May28/mm/vmscan.c
@@ -477,8 +477,7 @@ static int __remove_mapping(struct addre
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
-		mem_cgroup_uncharge_swapcache(page, swap);
-		swap_free(swap);
+		swapcache_free(swap, page);
 	} else {
 		__remove_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
Index: mmotm-2.6.30-May28/mm/shmem.c
===================================================================
--- mmotm-2.6.30-May28.orig/mm/shmem.c
+++ mmotm-2.6.30-May28/mm/shmem.c
@@ -1097,7 +1097,7 @@ static int shmem_writepage(struct page *
 	shmem_swp_unmap(entry);
 unlock:
 	spin_unlock(&info->lock);
-	swap_free(swap);
+	swapcache_free(swap, NULL);
 redirty:
 	set_page_dirty(page);
 	if (wbc->for_reclaim)

