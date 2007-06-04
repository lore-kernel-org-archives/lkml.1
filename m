Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXFDPi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXFDPi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXFDPhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:37:50 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44953 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbXFDPht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:37:49 -0400
Subject: [PATCH -mm 3/5] swap: Have swap_free() mark pages with errors as
	bad
From: Richard Purdie <rpurdie@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 16:36:42 +0100
Message-Id: <1180971402.6313.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
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

Index: linux-2.6.21/include/linux/swap.h
===================================================================
--- linux-2.6.21.orig/include/linux/swap.h	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/include/linux/swap.h	2007-06-04 11:39:23.000000000 +0100
@@ -248,7 +248,7 @@ extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int swap_duplicate(swp_entry_t);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
-extern void swap_free(swp_entry_t);
+extern void swap_free(swp_entry_t, struct page *);
 extern void free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
@@ -309,7 +309,7 @@ static inline int swap_duplicate(swp_ent
 	return 0;
 }
 
-static inline void swap_free(swp_entry_t swp)
+static inline void swap_free(swp_entry_t swp, struct page *page)
 {
 }
 
Index: linux-2.6.21/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21.orig/kernel/power/swsusp.c	2007-06-04 09:48:41.000000000 +0100
+++ linux-2.6.21/kernel/power/swsusp.c	2007-06-04 11:40:01.000000000 +0100
@@ -138,7 +138,7 @@ sector_t alloc_swapdev_block(int swap)
 	offset = swp_offset(get_swap_page_of_type(swap));
 	if (offset) {
 		if (swsusp_extents_insert(offset))
-			swap_free(swp_entry(swap, offset));
+			swap_free(swp_entry(swap, offset), NULL);
 		else
 			return swapdev_block(swap, offset);
 	}
@@ -162,7 +162,7 @@ void free_all_swap_pages(int swap)
 		ext = container_of(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free(swp_entry(swap, offset));
+			swap_free(swp_entry(swap, offset), NULL);
 
 		kfree(ext);
 	}
Index: linux-2.6.21/mm/memory.c
===================================================================
--- linux-2.6.21.orig/mm/memory.c	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/mm/memory.c	2007-06-04 11:39:23.000000000 +0100
@@ -2210,7 +2210,7 @@ static int do_swap_page(struct mm_struct
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
 
-	swap_free(entry);
+	swap_free(entry, page);
 	if (vm_swap_full())
 		remove_exclusive_swap_page(page);
 	unlock_page(page);
Index: linux-2.6.21/mm/shmem.c
===================================================================
--- linux-2.6.21.orig/mm/shmem.c	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/mm/shmem.c	2007-06-04 11:39:23.000000000 +0100
@@ -875,7 +875,7 @@ found:
 	 * Decrement swap count even when the entry is left behind:
 	 * try_to_unuse will skip over mms, then reincrement count.
 	 */
-	swap_free(entry);
+	swap_free(entry, page);
 	return 1;
 }
 
@@ -955,7 +955,7 @@ static int shmem_writepage(struct page *
 	shmem_swp_unmap(entry);
 unlock:
 	spin_unlock(&info->lock);
-	swap_free(swap);
+	swap_free(swap, page);
 redirty:
 	set_page_dirty(page);
 	return AOP_WRITEPAGE_ACTIVATE;	/* Return with the page locked */
@@ -1198,7 +1198,7 @@ repeat:
 			flush_dcache_page(filepage);
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
-			swap_free(swap);
+			swap_free(swap, swappage);
 		} else if (!(error = move_from_swap_cache(
 				swappage, idx, mapping))) {
 			info->flags |= SHMEM_PAGEIN;
@@ -1206,7 +1206,7 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			filepage = swappage;
-			swap_free(swap);
+			swap_free(swap, swappage);
 		} else {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
Index: linux-2.6.21/mm/swapfile.c
===================================================================
--- linux-2.6.21.orig/mm/swapfile.c	2007-06-04 09:48:41.000000000 +0100
+++ linux-2.6.21/mm/swapfile.c	2007-06-04 11:39:23.000000000 +0100
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
Index: linux-2.6.21/mm/swap_state.c
===================================================================
--- linux-2.6.21.orig/mm/swap_state.c	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/mm/swap_state.c	2007-06-04 11:39:23.000000000 +0100
@@ -109,7 +109,7 @@ int add_to_swap_cache(struct page *page,
 	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
 	 */
 	if (error) {
-		swap_free(entry);
+		swap_free(entry, NULL);
 		if (error == -EEXIST)
 			INC_CACHE_INFO(exist_race);
 		return error;
@@ -182,11 +182,11 @@ int add_to_swap(struct page * page, gfp_
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
@@ -208,7 +208,7 @@ void delete_from_swap_cache(struct page 
 	__delete_from_swap_cache(page);
 	write_unlock_irq(&swapper_space.tree_lock);
 
-	swap_free(entry);
+	swap_free(entry, page);
 	page_cache_release(page);
 }
 
Index: linux-2.6.21/mm/vmscan.c
===================================================================
--- linux-2.6.21.orig/mm/vmscan.c	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/mm/vmscan.c	2007-06-04 11:39:23.000000000 +0100
@@ -412,7 +412,7 @@ int remove_mapping(struct address_space 
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		write_unlock_irq(&mapping->tree_lock);
-		swap_free(swap);
+		swap_free(swap, page);
 		__put_page(page);	/* The pagecache ref */
 		return 1;
 	}

