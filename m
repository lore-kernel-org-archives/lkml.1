Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXLRWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXLRWGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXLRWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:06:36 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60262 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXLRWGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:06:35 -0500
Date: Tue, 18 Dec 2007 22:05:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] tmpfs: radix_tree_preloading
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182204210.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick has observed that shmem.c still uses GFP_ATOMIC when adding to page
cache or swap cache, without any radix tree preload: so tending to deplete
emergency reserves of memory.

GFP_ATOMIC remains appropriate in shmem_writepage's add_to_swap_cache:
it's being called under memory pressure, so must not wait for more memory
to become available.  But shmem_unuse_inode now has a window in which it
can and should preload with GFP_KERNEL, and say GFP_NOWAIT instead of
GFP_ATOMIC in its add_to_page_cache.

shmem_getpage is not so straightforward: its filepage/swappage integrity
relies upon exchanging between caches under spinlock, and it would need a
lot of restructuring to place the preloads correctly.  Instead, follow
its pattern of retrying on races: use GFP_NOWAIT instead of GFP_ATOMIC in
add_to_page_cache, and begin each circuit of the repeat loop with a sleeping
radix_tree_preload, followed immediately by radix_tree_preload_end - that
won't guarantee success in the next add_to_page_cache, but doesn't need to.

And we can then remove that bothersome congestion_wait: when needed,
it'll automatically get done in the course of the radix_tree_preload.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- tmpfs7/mm/shmem.c	2007-12-06 18:11:26.000000000 +0000
+++ tmpfs8/mm/shmem.c	2007-12-06 19:20:29.000000000 +0000
@@ -901,12 +901,16 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error)
+		goto out;
+	error = 1;
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
 	if (ptr && ptr->val == entry.val)
 		error = add_to_page_cache(page, inode->i_mapping,
-						idx, GFP_ATOMIC);
+						idx, GFP_NOWAIT);
 	if (error == -EEXIST) {
 		struct page *filepage = find_get_page(inode->i_mapping, idx);
 		error = 1;
@@ -931,6 +935,7 @@ found:
 	if (ptr)
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
+	radix_tree_preload_end();
 out:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1185,6 +1190,16 @@ repeat:
 		goto done;
 	error = 0;
 	gfp = mapping_gfp_mask(mapping);
+	if (!filepage) {
+		/*
+		 * Try to preload while we can wait, to not make a habit of
+		 * draining atomic reserves; but don't latch on to this cpu.
+		 */
+		error = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
+		if (error)
+			goto failed;
+		radix_tree_preload_end();
+	}
 
 	spin_lock(&info->lock);
 	shmem_recalc_inode(inode);
@@ -1266,7 +1281,7 @@ repeat:
 			set_page_dirty(filepage);
 			swap_free(swap);
 		} else if (!(error = add_to_page_cache(
-				swappage, mapping, idx, GFP_ATOMIC))) {
+				swappage, mapping, idx, GFP_NOWAIT))) {
 			info->flags |= SHMEM_PAGEIN;
 			shmem_swp_set(info, entry, 0);
 			shmem_swp_unmap(entry);
@@ -1280,10 +1295,6 @@ repeat:
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
 			page_cache_release(swappage);
-			if (error == -ENOMEM) {
-				/* let kswapd refresh zone for GFP_ATOMICs */
-				congestion_wait(WRITE, HZ/50);
-			}
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
@@ -1338,7 +1349,7 @@ repeat:
 				shmem_swp_unmap(entry);
 			}
 			if (error || swap.val || 0 != add_to_page_cache_lru(
-					filepage, mapping, idx, GFP_ATOMIC)) {
+					filepage, mapping, idx, GFP_NOWAIT)) {
 				spin_unlock(&info->lock);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
