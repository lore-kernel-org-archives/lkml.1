Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXLRWBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXLRWBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXLRWBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:01:34 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59859 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXLRWBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:01:33 -0500
Date: Tue, 18 Dec 2007 22:00:15 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] tmpfs: move swap swizzling into shmem
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182159280.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move_to_swap_cache and move_from_swap_cache functions (which swizzle a
page between tmpfs page cache and swap cache, to avoid page copying) are
only used by shmem.c; and our subsequent fix for unionfs needs different
treatments in the two instances of move_from_swap_cache.  Move them from
swap_state.c into their callsites shmem_writepage, shmem_unuse_inode and
shmem_getpage, making add_to_swap_cache externally visible.

shmem.c likes to say set_page_dirty where swap_state.c liked to say
SetPageDirty: respect that diversity, which __set_page_dirty_no_writeback
makes moot (and implies we should lose that "shift page from clean_pages
to dirty_pages list" comment: it's on neither).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
checkpatch.pl objects to the embedded assignment in
 -		} else if (!(error = move_from_swap_cache(
 +		} else if (!(error = add_to_page_cache(
but please let me not mess with that here.

 include/linux/swap.h |   15 ++++-----------
 mm/shmem.c           |   16 ++++++++++++----
 mm/swap_state.c      |   35 +----------------------------------
 3 files changed, 17 insertions(+), 49 deletions(-)

--- tmpfs2/include/linux/swap.h	2007-12-05 10:38:43.000000000 +0000
+++ tmpfs3/include/linux/swap.h	2007-12-05 16:42:18.000000000 +0000
@@ -224,11 +224,9 @@ extern struct address_space swapper_spac
 #define total_swapcache_pages  swapper_space.nrpages
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *, gfp_t);
+extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern void __delete_from_swap_cache(struct page *);
 extern void delete_from_swap_cache(struct page *);
-extern int move_to_swap_cache(struct page *, swp_entry_t);
-extern int move_from_swap_cache(struct page *, unsigned long,
-		struct address_space *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 extern struct page *lookup_swap_cache(swp_entry_t);
@@ -323,15 +321,10 @@ static inline struct page *lookup_swap_c
 
 #define can_share_swap_page(p)			(page_mapcount(p) == 1)
 
-static inline int move_to_swap_cache(struct page *page, swp_entry_t entry)
+static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
+							gfp_t gfp_mask)
 {
-	return 1;
-}
-
-static inline int move_from_swap_cache(struct page *page, unsigned long index,
-					struct address_space *mapping)
-{
-	return 1;
+	return -1;
 }
 
 static inline void __delete_from_swap_cache(struct page *page)
--- tmpfs2/mm/shmem.c	2007-12-05 10:38:45.000000000 +0000
+++ tmpfs3/mm/shmem.c	2007-12-05 16:42:18.000000000 +0000
@@ -884,7 +884,9 @@ lost2:
 found:
 	idx += offset;
 	inode = &info->vfs_inode;
-	if (move_from_swap_cache(page, idx, inode->i_mapping) == 0) {
+	if (add_to_page_cache(page, inode->i_mapping, idx, GFP_ATOMIC) == 0) {
+		delete_from_swap_cache(page);
+		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
 		shmem_swp_set(info, ptr + offset, 0);
 	}
@@ -972,7 +974,8 @@ static int shmem_writepage(struct page *
 	BUG_ON(!entry);
 	BUG_ON(entry->val);
 
-	if (move_to_swap_cache(page, swap) == 0) {
+	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
+		remove_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
 		spin_unlock(&info->lock);
@@ -982,6 +985,9 @@ static int shmem_writepage(struct page *
 			list_move_tail(&info->swaplist, &shmem_swaplist);
 			spin_unlock(&shmem_swaplist_lock);
 		}
+		swap_duplicate(swap);
+		page_cache_release(page);	/* pagecache ref */
+		set_page_dirty(page);
 		unlock_page(page);
 		return 0;
 	}
@@ -1217,13 +1223,15 @@ repeat:
 			SetPageUptodate(filepage);
 			set_page_dirty(filepage);
 			swap_free(swap);
-		} else if (!(error = move_from_swap_cache(
-				swappage, idx, mapping))) {
+		} else if (!(error = add_to_page_cache(
+				swappage, mapping, idx, GFP_ATOMIC))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
 			shmem_swp_unmap(entry);
+			delete_from_swap_cache(swappage);
 			spin_unlock(&info->lock);
 			filepage = swappage;
+			set_page_dirty(filepage);
 			swap_free(swap);
 		} else {
 			shmem_swp_unmap(entry);
--- tmpfs2/mm/swap_state.c	2007-12-05 16:42:16.000000000 +0000
+++ tmpfs3/mm/swap_state.c	2007-12-05 16:42:18.000000000 +0000
@@ -67,8 +67,7 @@ void show_swap_cache_info(void)
  * add_to_swap_cache resembles add_to_page_cache on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-static int add_to_swap_cache(struct page *page, swp_entry_t entry,
-			       gfp_t gfp_mask)
+int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
 {
 	int error;
 
@@ -183,38 +182,6 @@ void delete_from_swap_cache(struct page 
 	page_cache_release(page);
 }
 
-/*
- * Strange swizzling function only for use by shmem_writepage
- */
-int move_to_swap_cache(struct page *page, swp_entry_t entry)
-{
-	int err = add_to_swap_cache(page, entry, GFP_ATOMIC);
-	if (!err) {
-		remove_from_page_cache(page);
-		page_cache_release(page);	/* pagecache ref */
-		if (!swap_duplicate(entry))
-			BUG();
-		SetPageDirty(page);
-	}
-	return err;
-}
-
-/*
- * Strange swizzling function for shmem_getpage (and shmem_unuse)
- */
-int move_from_swap_cache(struct page *page, unsigned long index,
-		struct address_space *mapping)
-{
-	int err = add_to_page_cache(page, mapping, index, GFP_ATOMIC);
-	if (!err) {
-		delete_from_swap_cache(page);
-		/* shift page from clean_pages to dirty_pages list */
-		ClearPageDirty(page);
-		set_page_dirty(page);
-	}
-	return err;
-}
-
 /* 
  * If we are the only user, then try to free up the swap cache. 
  * 
