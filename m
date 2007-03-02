Return-Path: <linux-kernel-owner+w=401wt.eu-S2992541AbXCBPzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992541AbXCBPzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992543AbXCBPzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:55:08 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49668 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992541AbXCBPzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:55:06 -0500
Subject: [PATCH 1/9] swap: Have swap_free() mark pages with errors as bad
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:54:32 +0000
Message-Id: <1172850872.11149.118.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass an optional struct page * to swap_free(), fixing up all users.

Have swap_free check the page for errors and if found, mark the swap
page as bad.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 include/linux/swap.h  |    4 ++--
 kernel/power/swsusp.c |    4 ++--
 mm/memory.c           |    2 +-
 mm/shmem.c            |    8 ++++----
 mm/swap_state.c       |    8 ++++----
 mm/swapfile.c         |   16 ++++++++++++----
 mm/vmscan.c           |    2 +-
 7 files changed, 26 insertions(+), 18 deletions(-)

Index: linux/include/linux/swap.h
===================================================================
--- linux.orig/include/linux/swap.h	2007-02-28 18:12:16.000000000 +0000
+++ linux/include/linux/swap.h	2007-02-28 18:13:08.000000000 +0000
@@ -245,7 +245,7 @@ extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
-extern void swap_free(swp_entry_t);
+extern void swap_free(swp_entry_t, struct page *);
 extern void free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
@@ -306,7 +306,7 @@ static inline int swap_duplicate(swp_ent
 	return 0;
 }
 
-static inline void swap_free(swp_entry_t swp)
+static inline void swap_free(swp_entry_t swp, struct page *page)
 {
 }
 
Index: linux/kernel/power/swsusp.c
===================================================================
--- linux.orig/kernel/power/swsusp.c	2007-02-28 18:12:16.000000000 +0000
+++ linux/kernel/power/swsusp.c	2007-02-28 18:12:34.000000000 +0000
@@ -140,7 +140,7 @@ sector_t alloc_swapdev_block(int swap, s
 	offset = swp_offset(get_swap_page_of_type(swap));
 	if (offset) {
 		if (bitmap_set(bitmap, offset))
-			swap_free(swp_entry(swap, offset));
+			swap_free(swp_entry(swap, offset), NULL);
 		else
 			return swapdev_block(swap, offset);
 	}
@@ -157,7 +157,7 @@ void free_all_swap_pages(int swap, struc
 		for (n = 0; n < BITMAP_PAGE_CHUNKS; n++)
 			for (test = 1UL; test; test <<= 1) {
 				if (bitmap->chunks[n] & test)
-					swap_free(swp_entry(swap, bit));
+					swap_free(swp_entry(swap, bit), NULL);
 				bit++;
 			}
 		bitmap = bitmap->next;
Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c	2007-02-28 18:12:16.000000000 +0000
+++ linux/mm/memory.c	2007-02-28 18:12:34.000000000 +0000
@@ -2091,7 +2091,7 @@ static int do_swap_page(struct mm_struct
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
 
-	swap_free(entry);
+	swap_free(entry, page);
 	if (vm_swap_full())
 		remove_exclusive_swap_page(page);
 	unlock_page(page);
Index: linux/mm/shmem.c
===================================================================
--- linux.orig/mm/shmem.c	2007-02-28 18:12:16.000000000 +0000
+++ linux/mm/shmem.c	2007-02-28 18:13:07.000000000 +0000
@@ -802,7 +802,7 @@ found:
 	 * Decrement swap count even when the entry is left behind:
 	 * try_to_unuse will skip over mms, then reincrement count.
 	 */
-	swap_free(entry);
+	swap_free(entry, page);
 	return 1;
 }
 
@@ -882,7 +882,7 @@ static int shmem_writepage(struct page *
 	shmem_swp_unmap(entry);
 unlock:
 	spin_unlock(&info->lock);
-	swap_free(swap);
+	swap_free(swap, page);
 redirty:
 	set_page_dirty(page);
 	return AOP_WRITEPAGE_ACTIVATE;	/* Return with the page locked */
@@ -1121,7 +1121,7 @@ repeat:
 			flush_dcache_page(filepage);
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
-			swap_free(swap);
+			swap_free(swap, swappage);
 		} else if (!(error = move_from_swap_cache(
 				swappage, idx, mapping))) {
 			info->flags |= SHMEM_PAGEIN;
@@ -1129,7 +1129,7 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			filepage = swappage;
-			swap_free(swap);
+			swap_free(swap, swappage);
 		} else {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
Index: linux/mm/swapfile.c
===================================================================
--- linux.orig/mm/swapfile.c	2007-02-28 18:12:16.000000000 +0000
+++ linux/mm/swapfile.c	2007-02-28 18:13:08.000000000 +0000
@@ -293,13 +293,21 @@ static int swap_entry_free(struct swap_i
  * Caller has made sure that the swapdevice corresponding to entry
  * is still around or has not been recycled.
  */
-void swap_free(swp_entry_t entry)
+void swap_free(swp_entry_t entry, struct page *page)
 {
 	struct swap_info_struct * p;
 
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, swp_offset(entry));
+		unsigned long offset = swp_offset(entry);
+		if (swap_entry_free(p, offset) == 0
+				&& page && unlikely(PageError(page))) {
+			p->swap_map[offset] = SWAP_MAP_BAD;
+			p->pages--;
+			nr_swap_pages--;
+			total_swap_pages--;
+			ClearPageError(page);
+		}
 		spin_unlock(&swap_lock);
 	}
 }
@@ -378,7 +386,7 @@ int remove_exclusive_swap_page(struct pa
 	spin_unlock(&swap_lock);
 
 	if (retval) {
-		swap_free(entry);
+		swap_free(entry, page);
 		page_cache_release(page);
 	}
 
@@ -514,7 +522,7 @@ static void unuse_pte(struct vm_area_str
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
 	page_add_anon_rmap(page, vma, addr);
-	swap_free(entry);
+	swap_free(entry, page);
 	/*
 	 * Move the page to the active list so it is not
 	 * immediately swapped out again after swapon.
Index: linux/mm/swap_state.c
===================================================================
--- linux.orig/mm/swap_state.c	2007-02-28 18:12:16.000000000 +0000
+++ linux/mm/swap_state.c	2007-02-28 18:12:34.000000000 +0000
@@ -108,7 +108,7 @@ static int add_to_swap_cache(struct page
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
 	if (error) {
-		swap_free(entry);
+		swap_free(entry, NULL);
 		if (error == -EEXIST)
 			INC_CACHE_INFO(exist_race);
 		return error;
@@ -178,11 +178,11 @@ int add_to_swap(struct page * page, gfp_
 		case -EEXIST:
 			/* Raced with "speculative" read_swap_cache_async */
 			INC_CACHE_INFO(exist_race);
-			swap_free(entry);
+			swap_free(entry, NULL);
 			continue;
 		default:
 			/* -ENOMEM radix-tree allocation failure */
-			swap_free(entry);
+			swap_free(entry, NULL);
 			return 0;
 		}
 	}
@@ -204,7 +204,7 @@ void delete_from_swap_cache(struct page 
 	__delete_from_swap_cache(page);
 	write_unlock_irq(&swapper_space.tree_lock);
 
-	swap_free(entry);
+	swap_free(entry, page);
 	page_cache_release(page);
 }
 
Index: linux/mm/vmscan.c
===================================================================
--- linux.orig/mm/vmscan.c	2007-02-28 18:12:16.000000000 +0000
+++ linux/mm/vmscan.c	2007-02-28 18:13:07.000000000 +0000
@@ -426,7 +426,7 @@ int remove_mapping(struct address_space 
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		write_unlock_irq(&mapping->tree_lock);
-		swap_free(swap);
+		swap_free(swap, page);
 		__put_page(page);	/* The pagecache ref */
 		return 1;
 	}


