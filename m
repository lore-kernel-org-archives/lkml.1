Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbXFDPij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbXFDPij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbXFDPh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:37:56 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44955 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758027AbXFDPhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:37:55 -0400
Subject: [PATCH -mm 4/5] swap: Add try_to_unuse_page_entry()
From: Richard Purdie <rpurdie@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 16:36:48 +0100
Message-Id: <1180971408.6313.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add try_to_unuse_page_entry() which can be used to unuse page entries.

This needs try_to_unuse_anon() which is also added, similar to
try_to_unmap_anon().

Originally based on a patch by Nick Piggin from LKML with changes of my
own after hints from Hugh Dickins.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 include/linux/rmap.h |    6 +++++
 include/linux/swap.h |    1 
 mm/rmap.c            |    2 -
 mm/swapfile.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 1 deletion(-)

Index: linux-2.6.21/mm/swapfile.c
===================================================================
--- linux-2.6.21.orig/mm/swapfile.c	2007-06-04 11:39:23.000000000 +0100
+++ linux-2.6.21/mm/swapfile.c	2007-06-04 11:40:15.000000000 +0100
@@ -646,6 +646,61 @@ static int unuse_mm(struct mm_struct *mm
 	return 0;
 }
 
+static int try_to_unuse_anon(swp_entry_t entry, struct page *page)
+{
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+
+	anon_vma = page_lock_anon_vma(page);
+	if (!anon_vma)
+		return 0;
+
+	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+		if (unuse_vma(vma, entry, page))
+			break;
+	}
+	spin_unlock(&anon_vma->lock);
+	return 0;
+}
+
+
+void try_to_unuse_page_entry(struct page *page)
+{
+	struct swap_info_struct *si;
+	unsigned short *swap_map;
+	swp_entry_t entry;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(!PageSwapCache(page));
+	BUG_ON(PageWriteback(page));
+	BUG_ON(PagePrivate(page));
+
+	entry.val = page_private(page);
+	si = swap_info_get(entry);
+	if (!si) {
+		WARN_ON(1);
+		return;
+	}
+	swap_map = &si->swap_map[swp_offset(entry)];
+	spin_unlock(&swap_lock);
+
+	BUG_ON(*swap_map == SWAP_MAP_BAD);
+
+	if (!shmem_unuse(entry, page)) {
+		try_to_unuse_anon(entry, page);
+		delete_from_swap_cache(page);
+	} else if (PageSwapCache(page)) {
+		/*
+		 * shmem_unuse deleted a swappage from the swap cache, but the
+		 * move to filepage failed so it left swappage in cache and
+		 * lowered its swap count to pass quickly through the loops in
+		 * try_to_unuse(). We must reincrement the count to try again
+		 * later (ick).
+		 */
+		swap_duplicate(entry);
+	}
+}
+
 /*
  * Scan swap_map from current position to next entry still in use.
  * Recycle to start on reaching the end, returning 0 when empty.
Index: linux-2.6.21/include/linux/rmap.h
===================================================================
--- linux-2.6.21.orig/include/linux/rmap.h	2007-06-04 09:48:40.000000000 +0100
+++ linux-2.6.21/include/linux/rmap.h	2007-06-04 11:40:15.000000000 +0100
@@ -101,6 +101,11 @@ pte_t *page_check_address(struct page *,
 unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
 
 /*
+ * Used by try_to_unuse_anon() and try_to_unmap_anon()
+ */
+struct anon_vma *page_lock_anon_vma(struct page *page);
+
+/*
  * Cleans the PTEs of shared mappings.
  * (and since clean PTEs should also be readonly, write protects them too)
  *
@@ -122,6 +127,7 @@ static inline int page_mkclean(struct pa
 	return 0;
 }
 
+#define page_lock_anon_vma(page)	(0)
 
 #endif	/* CONFIG_MMU */
 
Index: linux-2.6.21/mm/rmap.c
===================================================================
--- linux-2.6.21.orig/mm/rmap.c	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/mm/rmap.c	2007-06-04 11:40:15.000000000 +0100
@@ -178,7 +178,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-static struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
Index: linux-2.6.21/include/linux/swap.h
===================================================================
--- linux-2.6.21.orig/include/linux/swap.h	2007-06-04 11:39:23.000000000 +0100
+++ linux-2.6.21/include/linux/swap.h	2007-06-04 11:40:15.000000000 +0100
@@ -257,6 +257,7 @@ extern sector_t swapdev_block(int, pgoff
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
+extern void try_to_unuse_page_entry(struct page *page);
 struct backing_dev_info;
 
 extern spinlock_t swap_lock;

