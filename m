Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbXLRWFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbXLRWFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXLRWFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:05:04 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54316 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXLRWFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:05:03 -0500
Date: Tue, 18 Dec 2007 22:03:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] tmpfs: make shmem_unuse more preemptible
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182202180.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem_unuse is at present an unbroken search through every swap vector page
of every tmpfs file which might be swapped, all under shmem_swaplist_lock.
This dates from long ago, when the caller held mmlist_lock over it all too:
long gone, but there's never been much pressure for preemptible swapoff.

Make it a little more preemptible, replacing shmem_swaplist_lock by
shmem_swaplist_mutex, inserting a cond_resched in the main loop, and
a cond_resched_lock (on info->lock) at one convenient point in the
shmem_unuse_inode loop, where it has no outstanding kmap_atomic.

If we're serious about preemptible swapoff, there's much further to go
e.g. I'm stupid to let the kmap_atomics of the decreasingly significant
HIGHMEM case dictate preemptiblility for other configs.  But as in the
earlier patch to make swapoff scan ptes preemptibly, my hidden agenda is
really towards making memcgroups work, hardly about preemptibility at all.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- tmpfs5/mm/shmem.c	2007-12-05 16:42:19.000000000 +0000
+++ tmpfs6/mm/shmem.c	2007-12-06 16:34:56.000000000 +0000
@@ -193,7 +193,7 @@ static struct backing_dev_info shmem_bac
 };
 
 static LIST_HEAD(shmem_swaplist);
-static DEFINE_SPINLOCK(shmem_swaplist_lock);
+static DEFINE_MUTEX(shmem_swaplist_mutex);
 
 static void shmem_free_blocks(struct inode *inode, long pages)
 {
@@ -796,9 +796,9 @@ static void shmem_delete_inode(struct in
 		inode->i_size = 0;
 		shmem_truncate(inode);
 		if (!list_empty(&info->swaplist)) {
-			spin_lock(&shmem_swaplist_lock);
+			mutex_lock(&shmem_swaplist_mutex);
 			list_del_init(&info->swaplist);
-			spin_unlock(&shmem_swaplist_lock);
+			mutex_unlock(&shmem_swaplist_mutex);
 		}
 	}
 	BUG_ON(inode->i_blocks);
@@ -851,6 +851,14 @@ static int shmem_unuse_inode(struct shme
 	for (idx = SHMEM_NR_DIRECT; idx < limit; idx += ENTRIES_PER_PAGE, dir++) {
 		if (unlikely(idx == stage)) {
 			shmem_dir_unmap(dir-1);
+			if (cond_resched_lock(&info->lock)) {
+				/* check it has not been truncated */
+				if (limit > info->next_index) {
+					limit = info->next_index;
+					if (idx >= limit)
+						goto lost2;
+				}
+			}
 			dir = shmem_dir_map(info->i_indirect) +
 			    ENTRIES_PER_PAGE/2 + idx/ENTRIES_PER_PAGEPAGE;
 			while (!*dir) {
@@ -924,7 +932,7 @@ int shmem_unuse(swp_entry_t entry, struc
 	struct shmem_inode_info *info;
 	int found = 0;
 
-	spin_lock(&shmem_swaplist_lock);
+	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
 		info = list_entry(p, struct shmem_inode_info, swaplist);
 		if (!info->swapped)
@@ -935,8 +943,9 @@ int shmem_unuse(swp_entry_t entry, struc
 			found = 1;
 			break;
 		}
+		cond_resched();
 	}
-	spin_unlock(&shmem_swaplist_lock);
+	mutex_unlock(&shmem_swaplist_mutex);
 	return found;
 }
 
@@ -996,10 +1005,10 @@ static int shmem_writepage(struct page *
 		shmem_swp_unmap(entry);
 		spin_unlock(&info->lock);
 		if (list_empty(&info->swaplist)) {
-			spin_lock(&shmem_swaplist_lock);
+			mutex_lock(&shmem_swaplist_mutex);
 			/* move instead of add in case we're racing */
 			list_move_tail(&info->swaplist, &shmem_swaplist);
-			spin_unlock(&shmem_swaplist_lock);
+			mutex_unlock(&shmem_swaplist_mutex);
 		}
 		swap_duplicate(swap);
 		BUG_ON(page_mapped(page));
