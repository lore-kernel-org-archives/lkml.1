Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZCWB7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZCWB7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 21:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZCWB7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 21:59:30 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49053 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZCWB73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 21:59:29 -0400
Date: Mon, 23 Mar 2009 01:57:26 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Rohland <hans-christoph.rohland@sap.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] shmem: writepage directly to swap
Message-ID: <Pine.LNX.4.64.0903230151140.11883@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synopsis: if shmem_writepage calls swap_writepage directly, most shmem swap
loads benefit, and a catastrophic interaction between SLUB and some flash
storage is avoided.

shmem_writepage() has always been peculiar in making no attempt to write:
it has just transferred a shmem page from file cache to swap cache, then let
that page make its way around the LRU again before being written and freed.

The idea was that people use tmpfs because they want those pages to stay in
RAM; so although we give it an overflow to swap, we should resist writing
too soon, giving those pages a second chance before they can be reclaimed.

That was always questionable, and I've toyed with this patch for years;
but never had a clear justification to depart from the original design.

It became more questionable in 2.6.28, when the split LRU patches classed
shmem and tmpfs pages as SwapBacked rather than as file_cache: that in
itself gives them more resistance to reclaim than normal file pages.
I prepared this patch for 2.6.29, but the merge window arrived before
I'd completed gathering statistics to justify sending it in.

Then while comparing SLQB against SLUB, running SLUB on a laptop I'd
habitually used with SLAB, I found SLUB to run my tmpfs kbuild swapping
tests five times slower than SLAB or SLQB - other machines slower too,
but nowhere near so bad.  Simpler "cp -a" swapping tests showed the same.

slub_max_order=0 brings sanity to all, but heavy swapping is too far from
normal to justify such a tuning.  The crucial factor on that laptop turns
out to be that I'm using an SD card for swap.  What happens is this:

By default, SLUB uses order-2 pages for shmem_inode_cache (and many other
fs inodes), so creating tmpfs files under memory pressure brings lumpy
reclaim into play.  One subpage of the order is chosen from the bottom
of the LRU as usual, then the other three picked out from their random
positions on the LRUs.

In a tmpfs load, many of these pages will be ones which already passed
through shmem_writepage, so already have swap allocated.  And though
their offsets on swap were probably allocated sequentially, now that
the pages are picked off at random, their swap offsets are scattered.

But the flash storage on the SD card is very sensitive to having its
writes merged: once swap is written at scattered offsets, performance
falls apart.  Rotating disk seeks increase too, but less disastrously.

So: stop giving shmem/tmpfs pages a second pass around the LRU,
write them out to swap as soon as their swap has been allocated.

It's surely possible to devise an artificial load which runs faster
the old way, one whose sizing is such that the tmpfs pages on their
second pass are the ones that are wanted again, and other pages not.

But I've not yet found such a load: on all machines, under the loads
I've tried, immediate swap_writepage speeds up shmem swapping: especially
when using the SLUB allocator (and more effectively than slub_max_order=0),
but also with the others; and it also reduces the variance between runs.
How much faster varies widely: a factor of five is rare, 5% is common.

One load which might have suffered: imagine a swapping shmem load in a
limited mem_cgroup on a machine with plenty of memory.  Before 2.6.29
the swapcache was not charged, and such a load would have run quickest
with the shmem swapcache never written to swap.  But now swapcache is
charged, so even this load benefits from shmem_writepage directly to swap.

Apologies for the #ifndef CONFIG_SWAP swap_writepage() stub in swap.h:
it's silly because that will never get called; but refactoring shmem.c
sensibly according to CONFIG_SWAP will be a separate task.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/linux/swap.h |    5 +++++
 mm/shmem.c           |    3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- 2.6.29-rc8/include/linux/swap.h	2009-01-11 01:33:38.000000000 +0000
+++ linux/include/linux/swap.h	2009-03-22 20:52:03.000000000 +0000
@@ -382,6 +382,11 @@ static inline struct page *swapin_readah
 	return NULL;
 }
 
+static inline int swap_writepage(struct page *p, struct writeback_control *wbc)
+{
+	return 0;
+}
+
 static inline struct page *lookup_swap_cache(swp_entry_t swp)
 {
 	return NULL;
--- 2.6.29-rc8/mm/shmem.c	2009-03-04 10:04:43.000000000 +0000
+++ linux/mm/shmem.c	2009-03-22 20:52:03.000000000 +0000
@@ -1067,8 +1067,7 @@ static int shmem_writepage(struct page *
 		swap_duplicate(swap);
 		BUG_ON(page_mapped(page));
 		page_cache_release(page);	/* pagecache ref */
-		set_page_dirty(page);
-		unlock_page(page);
+		swap_writepage(page, wbc);
 		if (inode) {
 			mutex_lock(&shmem_swaplist_mutex);
 			/* move instead of add in case we're racing */
