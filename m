Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXLRWFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXLRWFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbXLRWFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:05:34 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54350 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXLRWFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:05:33 -0500
Date: Tue, 18 Dec 2007 22:04:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] tmpfs: open a window in shmem_unuse_inode
In-Reply-To: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0712182203260.27165@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of reasons (patches follow) why it would be good to open
a window for sleep in shmem_unuse_inode, between its search for a matching
swap entry, and its handling of the entry found.

shmem_unuse_inode must then use igrab to hold the inode against deletion in
that window, and its corresponding iput might result in deletion: so it had
better unlock_page before the iput, and might as well release the page too.

Nor is there any need to hold on to shmem_swaplist_mutex once we know we'll
leave the loop.  So this unwinding moves from try_to_unuse and shmem_unuse
into shmem_unuse_inode, in the case when it finds a match.

Let try_to_unuse break on error in the shmem_unuse case, as it does in the
unuse_mm case: though at this point in the series, no error to break on.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c    |   57 +++++++++++++++++++++++++++++-------------------
 mm/swapfile.c |   23 ++++++++-----------
 2 files changed, 45 insertions(+), 35 deletions(-)

--- tmpfs6/mm/shmem.c	2007-12-06 16:34:56.000000000 +0000
+++ tmpfs7/mm/shmem.c	2007-12-06 18:11:26.000000000 +0000
@@ -838,10 +838,8 @@ static int shmem_unuse_inode(struct shme
 	if (size > SHMEM_NR_DIRECT)
 		size = SHMEM_NR_DIRECT;
 	offset = shmem_find_swp(entry, ptr, ptr+size);
-	if (offset >= 0) {
-		shmem_swp_balance_unmap();
+	if (offset >= 0)
 		goto found;
-	}
 	if (!info->i_indirect)
 		goto lost2;
 
@@ -879,11 +877,11 @@ static int shmem_unuse_inode(struct shme
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			offset = shmem_find_swp(entry, ptr, ptr+size);
+			shmem_swp_unmap(ptr);
 			if (offset >= 0) {
 				shmem_dir_unmap(dir);
 				goto found;
 			}
-			shmem_swp_unmap(ptr);
 		}
 	}
 lost1:
@@ -893,10 +891,25 @@ lost2:
 	return 0;
 found:
 	idx += offset;
-	inode = &info->vfs_inode;
-	error = add_to_page_cache(page, inode->i_mapping, idx, GFP_ATOMIC);
+	inode = igrab(&info->vfs_inode);
+	spin_unlock(&info->lock);
+
+	/* move head to start search for next from here */
+	list_move_tail(&shmem_swaplist, &info->swaplist);
+	mutex_unlock(&shmem_swaplist_mutex);
+
+	error = 1;
+	if (!inode)
+		goto out;
+
+	spin_lock(&info->lock);
+	ptr = shmem_swp_entry(info, idx, NULL);
+	if (ptr && ptr->val == entry.val)
+		error = add_to_page_cache(page, inode->i_mapping,
+						idx, GFP_ATOMIC);
 	if (error == -EEXIST) {
 		struct page *filepage = find_get_page(inode->i_mapping, idx);
+		error = 1;
 		if (filepage) {
 			/*
 			 * There might be a more uptodate page coming down
@@ -911,16 +924,18 @@ found:
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
-		shmem_swp_set(info, ptr + offset, 0);
+		shmem_swp_set(info, ptr, 0);
+		swap_free(entry);
+		error = 1;	/* not an error, but entry was found */
 	}
-	shmem_swp_unmap(ptr);
+	if (ptr)
+		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
-	/*
-	 * Decrement swap count even when the entry is left behind:
-	 * try_to_unuse will skip over mms, then reincrement count.
-	 */
-	swap_free(entry);
-	return 1;
+out:
+	unlock_page(page);
+	page_cache_release(page);
+	iput(inode);		/* allows for NULL */
+	return error;
 }
 
 /*
@@ -935,18 +950,16 @@ int shmem_unuse(swp_entry_t entry, struc
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
 		info = list_entry(p, struct shmem_inode_info, swaplist);
-		if (!info->swapped)
+		if (info->swapped)
+			found = shmem_unuse_inode(info, entry, page);
+		else
 			list_del_init(&info->swaplist);
-		else if (shmem_unuse_inode(info, entry, page)) {
-			/* move head to start search for next from here */
-			list_move_tail(&shmem_swaplist, &info->swaplist);
-			found = 1;
-			break;
-		}
 		cond_resched();
+		if (found)
+			goto out;
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
-	return found;
+out:	return found;	/* 0 or 1 or -ENOMEM */
 }
 
 /*
--- tmpfs6/mm/swapfile.c	2007-12-05 10:38:45.000000000 +0000
+++ tmpfs7/mm/swapfile.c	2007-12-06 17:00:18.000000000 +0000
@@ -823,7 +823,7 @@ static int try_to_unuse(unsigned int typ
 			atomic_inc(&new_start_mm->mm_users);
 			atomic_inc(&prev_mm->mm_users);
 			spin_lock(&mmlist_lock);
-			while (*swap_map > 1 && !retval &&
+			while (*swap_map > 1 && !retval && !shmem &&
 					(p = p->next) != &start_mm->mmlist) {
 				mm = list_entry(p, struct mm_struct, mmlist);
 				if (!atomic_inc_not_zero(&mm->mm_users))
@@ -855,6 +855,13 @@ static int try_to_unuse(unsigned int typ
 			mmput(start_mm);
 			start_mm = new_start_mm;
 		}
+		if (shmem) {
+			/* page has already been unlocked and released */
+			if (shmem > 0)
+				continue;
+			retval = shmem;
+			break;
+		}
 		if (retval) {
 			unlock_page(page);
 			page_cache_release(page);
@@ -893,12 +900,6 @@ static int try_to_unuse(unsigned int typ
 		 * read from disk into another page.  Splitting into two
 		 * pages would be incorrect if swap supported "shared
 		 * private" pages, but they are handled by tmpfs files.
-		 *
-		 * Note shmem_unuse already deleted a swappage from
-		 * the swap cache, unless the move to filepage failed:
-		 * in which case it left swappage in cache, lowered its
-		 * swap count to pass quickly through the loops above,
-		 * and now we must reincrement count to try again later.
 		 */
 		if ((*swap_map > 1) && PageDirty(page) && PageSwapCache(page)) {
 			struct writeback_control wbc = {
@@ -909,12 +910,8 @@ static int try_to_unuse(unsigned int typ
 			lock_page(page);
 			wait_on_page_writeback(page);
 		}
-		if (PageSwapCache(page)) {
-			if (shmem)
-				swap_duplicate(entry);
-			else
-				delete_from_swap_cache(page);
-		}
+		if (PageSwapCache(page))
+			delete_from_swap_cache(page);
 
 		/*
 		 * So we could skip searching mms once swap count went
