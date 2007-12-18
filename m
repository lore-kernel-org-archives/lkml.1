Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbXLRWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbXLRWIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXLRWIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:08:06 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54594 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbXLRWIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:08:04 -0500
Date: Tue, 18 Dec 2007 22:06:48 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] tmpfs: fix shmem_swaplist races
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182205450.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intensive swapoff testing shows shmem_unuse spinning on an entry in
shmem_swaplist pointing to itself: how does that come about?  Days pass...

First guess is this: shmem_delete_inode tests list_empty without taking the
global mutex (so the swapping case doesn't slow down the common case); but
there's an instant in shmem_unuse_inode's list_move_tail when the list entry
may appear empty (a rare case, because it's actually moving the head not the
the list member).  So there's a danger of leaving the inode on the swaplist
when it's freed, then reinitialized to point to itself when reused.  Fix that
by skipping the list_move_tail when it's a no-op, which happens to plug this.

But this same spinning then surfaces on another machine.  Ah, I'd never
suspected it, but shmem_writepage's swaplist manipulation is unsafe: though
we still hold page lock, which would hold off inode deletion if the page were
in pagecache, it doesn't hold off once it's in swapcache (free_swap_and_cache
doesn't wait on locked pages).  Hmm: we could put the the inode on swaplist
earlier, but then shmem_unuse_inode could never prune unswapped inodes.

Fix this with an igrab before dropping info->lock, as in shmem_unuse_inode;
though I am a little uneasy about the iput which has to follow - it works,
and I see nothing wrong with it, but it is surprising that shmem inode
deletion may now occur below shmem_writepage.  Revisit this fix later?

And while we're looking at these races: the way shmem_unuse tests swapped
without holding info->lock looks unsafe, if we've more than one swap area:
a racing shmem_writepage on another page of the same inode could be putting
it in swapcache, just as we're deciding to remove the inode from swaplist -
there's a danger of going on swap without being listed, so a later swapoff
would hang, being unable to locate the entry.  Move that test and removal
down into shmem_unuse_inode, once info->lock is held.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- tmpfs8/mm/shmem.c	2007-12-06 19:20:29.000000000 +0000
+++ tmpfs9/mm/shmem.c	2007-12-17 16:12:29.000000000 +0000
@@ -833,6 +833,10 @@ static int shmem_unuse_inode(struct shme
 	idx = 0;
 	ptr = info->i_direct;
 	spin_lock(&info->lock);
+	if (!info->swapped) {
+		list_del_init(&info->swaplist);
+		goto lost2;
+	}
 	limit = info->next_index;
 	size = limit;
 	if (size > SHMEM_NR_DIRECT)
@@ -894,8 +898,15 @@ found:
 	inode = igrab(&info->vfs_inode);
 	spin_unlock(&info->lock);
 
-	/* move head to start search for next from here */
-	list_move_tail(&shmem_swaplist, &info->swaplist);
+	/*
+	 * Move _head_ to start search for next from here.
+	 * But be careful: shmem_delete_inode checks list_empty without taking
+	 * mutex, and there's an instant in list_move_tail when info->swaplist
+	 * would appear empty, if it were the only one on shmem_swaplist.  We
+	 * could avoid doing it if inode NULL; or use this minor optimization.
+	 */
+	if (shmem_swaplist.next != &info->swaplist)
+		list_move_tail(&shmem_swaplist, &info->swaplist);
 	mutex_unlock(&shmem_swaplist_mutex);
 
 	error = 1;
@@ -955,10 +966,7 @@ int shmem_unuse(swp_entry_t entry, struc
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
 		info = list_entry(p, struct shmem_inode_info, swaplist);
-		if (info->swapped)
-			found = shmem_unuse_inode(info, entry, page);
-		else
-			list_del_init(&info->swaplist);
+		found = shmem_unuse_inode(info, entry, page);
 		cond_resched();
 		if (found)
 			goto out;
@@ -1021,18 +1029,23 @@ static int shmem_writepage(struct page *
 		remove_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
+		if (list_empty(&info->swaplist))
+			inode = igrab(inode);
+		else
+			inode = NULL;
 		spin_unlock(&info->lock);
-		if (list_empty(&info->swaplist)) {
-			mutex_lock(&shmem_swaplist_mutex);
-			/* move instead of add in case we're racing */
-			list_move_tail(&info->swaplist, &shmem_swaplist);
-			mutex_unlock(&shmem_swaplist_mutex);
-		}
 		swap_duplicate(swap);
 		BUG_ON(page_mapped(page));
 		page_cache_release(page);	/* pagecache ref */
 		set_page_dirty(page);
 		unlock_page(page);
+		if (inode) {
+			mutex_lock(&shmem_swaplist_mutex);
+			/* move instead of add in case we're racing */
+			list_move_tail(&info->swaplist, &shmem_swaplist);
+			mutex_unlock(&shmem_swaplist_mutex);
+			iput(inode);
+		}
 		return 0;
 	}
 
