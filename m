Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbXLRWAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbXLRWAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXLRWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:00:21 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:59775 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbXLRWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:00:20 -0500
Date: Tue, 18 Dec 2007 21:59:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] tmpfs: shuffle add_to_swap_caches
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182157480.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_to_swap_cache doesn't amount to much: merge it into its sole caller
read_swap_cache_async.  But we'll be needing to call __add_to_swap_cache
from shmem.c, so promote it to the new add_to_swap_cache.  Both were
static, so there's no interface confusion to worry about.

And lose that inappropriate "Anon pages are already on the LRU" comment
in the merging: they're not already on the LRU, as Nick Piggin noticed.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/swap_state.c |   53 ++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

--- tmpfs1/mm/swap_state.c	2007-12-05 16:42:16.000000000 +0000
+++ tmpfs2/mm/swap_state.c	2007-12-05 16:42:16.000000000 +0000
@@ -64,10 +64,10 @@ void show_swap_cache_info(void)
 }
 
 /*
- * __add_to_swap_cache resembles add_to_page_cache on swapper_space,
+ * add_to_swap_cache resembles add_to_page_cache on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-static int __add_to_swap_cache(struct page *page, swp_entry_t entry,
+static int add_to_swap_cache(struct page *page, swp_entry_t entry,
 			       gfp_t gfp_mask)
 {
 	int error;
@@ -94,28 +94,6 @@ static int __add_to_swap_cache(struct pa
 	return error;
 }
 
-static int add_to_swap_cache(struct page *page, swp_entry_t entry,
-				gfp_t gfp_mask)
-{
-	int error;
-
-	BUG_ON(PageLocked(page));
-	if (!swap_duplicate(entry))
-		return -ENOENT;
-
-	SetPageLocked(page);
-	error = __add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL);
-	/*
-	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
-	 */
-	if (error) {
-		ClearPageLocked(page);
-		swap_free(entry);
-		return error;
-	}
-	return 0;
-}
-
 /*
  * This must be called only on pages that have
  * been verified to be in the swap cache.
@@ -165,7 +143,7 @@ int add_to_swap(struct page * page, gfp_
 		/*
 		 * Add it to the swap cache and mark it dirty
 		 */
-		err = __add_to_swap_cache(page, entry,
+		err = add_to_swap_cache(page, entry,
 				gfp_mask|__GFP_NOMEMALLOC|__GFP_NOWARN);
 
 		switch (err) {
@@ -210,7 +188,7 @@ void delete_from_swap_cache(struct page 
  */
 int move_to_swap_cache(struct page *page, swp_entry_t entry)
 {
-	int err = __add_to_swap_cache(page, entry, GFP_ATOMIC);
+	int err = add_to_swap_cache(page, entry, GFP_ATOMIC);
 	if (!err) {
 		remove_from_page_cache(page);
 		page_cache_release(page);	/* pagecache ref */
@@ -335,16 +313,21 @@ struct page *read_swap_cache_async(swp_e
 		}
 
 		/*
+		 * Swap entry may have been freed since our caller observed it.
+		 */
+		if (!swap_duplicate(entry))
+			break;
+
+		/*
 		 * Associate the page with swap entry in the swap cache.
-		 * May fail (-ENOENT) if swap entry has been freed since
-		 * our caller observed it.  May fail (-EEXIST) if there
-		 * is already a page associated with this entry in the
-		 * swap cache: added by a racing read_swap_cache_async,
-		 * or by try_to_swap_out (or shmem_writepage) re-using
-		 * the just freed swap entry for an existing page.
+		 * May fail (-EEXIST) if there is already a page associated
+		 * with this entry in the swap cache: added by a racing
+		 * read_swap_cache_async, or add_to_swap or shmem_writepage
+		 * re-using the just freed swap entry for an existing page.
 		 * May fail (-ENOMEM) if radix-tree node allocation failed.
 		 */
-		err = add_to_swap_cache(new_page, entry, gfp_mask);
+		SetPageLocked(new_page);
+		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
 		if (!err) {
 			/*
 			 * Initiate read into locked page and return.
@@ -353,7 +336,9 @@ struct page *read_swap_cache_async(swp_e
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
-	} while (err != -ENOENT && err != -ENOMEM);
+		ClearPageLocked(new_page);
+		swap_free(entry);
+	} while (err != -ENOMEM);
 
 	if (new_page)
 		page_cache_release(new_page);
