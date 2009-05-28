Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZE1FMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZE1FMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZE1FM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:12:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53487 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZE1FMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:12:25 -0400
Date: Thu, 28 May 2009 14:10:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 1/4] add swap cache interface for swap reference
Message-Id: <20090528141049.cc45a116.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/swap.h |    7 +++++++
 mm/swap_state.c      |   11 +++++------
 mm/swapfile.c        |   19 +++++++++++++++++++
 mm/vmscan.c          |    3 +--
 4 files changed, 32 insertions(+), 8 deletions(-)

Index: new-trial-swapcount2/include/linux/swap.h
===================================================================
--- new-trial-swapcount2.orig/include/linux/swap.h
+++ new-trial-swapcount2/include/linux/swap.h
@@ -301,8 +301,10 @@ extern void si_swapinfo(struct sysinfo *
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
@@ -371,11 +373,16 @@ static inline void show_swap_cache_info(
 
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
Index: new-trial-swapcount2/mm/swap_state.c
===================================================================
--- new-trial-swapcount2.orig/mm/swap_state.c
+++ new-trial-swapcount2/mm/swap_state.c
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
Index: new-trial-swapcount2/mm/swapfile.c
===================================================================
--- new-trial-swapcount2.orig/mm/swapfile.c
+++ new-trial-swapcount2/mm/swapfile.c
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
Index: new-trial-swapcount2/mm/vmscan.c
===================================================================
--- new-trial-swapcount2.orig/mm/vmscan.c
+++ new-trial-swapcount2/mm/vmscan.c
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

