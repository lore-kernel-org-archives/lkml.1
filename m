Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbXI1IDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbXI1IDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbXI1IBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:01:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597AbXI1IBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:01:46 -0400
Message-Id: <20070928080041.891125000@chello.nl>
References: <20070928074200.436463000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 28 Sep 2007 09:42:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/12] mm: trylock_page
Content-Disposition: inline; filename=trylock_page.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace raw TestSetPageLocked() usage with trylock_page()

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/afs/write.c              |    2 +-
 fs/cifs/file.c              |    2 +-
 fs/jbd/commit.c             |    2 +-
 fs/jbd2/commit.c            |    2 +-
 fs/splice.c                 |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c |    4 ++--
 include/linux/pagemap.h     |    5 +++++
 mm/filemap.c                |    4 ++--
 mm/memory.c                 |    2 +-
 mm/migrate.c                |    4 ++--
 mm/rmap.c                   |    2 +-
 mm/shmem.c                  |    4 ++--
 mm/swap.c                   |    2 +-
 mm/swap_state.c             |    2 +-
 mm/swapfile.c               |    2 +-
 mm/truncate.c               |    4 ++--
 mm/vmscan.c                 |    4 ++--
 17 files changed, 27 insertions(+), 22 deletions(-)

Index: linux-2.6/fs/afs/write.c
===================================================================
--- linux-2.6.orig/fs/afs/write.c
+++ linux-2.6/fs/afs/write.c
@@ -404,7 +404,7 @@ static int afs_write_back_from_locked_pa
 			page = pages[loop];
 			if (page->index > wb->last)
 				break;
-			if (TestSetPageLocked(page))
+			if (!trylock_page(page))
 				break;
 			if (!PageDirty(page) ||
 			    page_private(page) != (unsigned long) wb) {
Index: linux-2.6/fs/cifs/file.c
===================================================================
--- linux-2.6.orig/fs/cifs/file.c
+++ linux-2.6/fs/cifs/file.c
@@ -1205,7 +1205,7 @@ retry:
 
 			if (first < 0)
 				lock_page(page);
-			else if (TestSetPageLocked(page))
+			else if (!trylock_page(page))
 				break;
 
 			if (unlikely(page->mapping != mapping)) {
Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c
+++ linux-2.6/fs/jbd/commit.c
@@ -63,7 +63,7 @@ static void release_buffer_page(struct b
 		goto nope;
 
 	/* OK, it's a truncated page */
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		goto nope;
 
 	page_cache_get(page);
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c
+++ linux-2.6/fs/jbd2/commit.c
@@ -63,7 +63,7 @@ static void release_buffer_page(struct b
 		goto nope;
 
 	/* OK, it's a truncated page */
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		goto nope;
 
 	page_cache_get(page);
Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -364,7 +364,7 @@ __generic_file_splice_read(struct file *
 			 * for an in-flight io page
 			 */
 			if (flags & SPLICE_F_NONBLOCK) {
-				if (TestSetPageLocked(page))
+				if (!trylock_page(page))
 					break;
 			} else
 				lock_page(page);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
@@ -665,7 +665,7 @@ xfs_probe_cluster(
 			} else
 				pg_offset = PAGE_CACHE_SIZE;
 
-			if (page->index == tindex && !TestSetPageLocked(page)) {
+			if (page->index == tindex && trylock_page(page)) {
 				pg_len = xfs_probe_page(page, pg_offset, mapped);
 				unlock_page(page);
 			}
@@ -749,7 +749,7 @@ xfs_convert_page(
 
 	if (page->index != tindex)
 		goto fail;
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		goto fail;
 	if (PageWriteback(page))
 		goto fail_unlock_page;
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h
+++ linux-2.6/include/linux/pagemap.h
@@ -167,6 +167,11 @@ static inline void lock_page(struct page
 		__lock_page(page);
 }
 
+static inline int trylock_page(struct page *page)
+{
+	return !TestSetPageLocked(page);
+}
+
 /*
  * lock_page_nosync should only be used if we can't pin the page's inode.
  * Doesn't play quite so well with block device plugging.
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -626,7 +626,7 @@ repeat:
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
 		page_cache_get(page);
-		if (TestSetPageLocked(page)) {
+		if (!trylock_page(page)) {
 			read_unlock_irq(&mapping->tree_lock);
 			__lock_page(page);
 			read_lock_irq(&mapping->tree_lock);
@@ -802,7 +802,7 @@ grab_cache_page_nowait(struct address_sp
 	struct page *page = find_get_page(mapping, index);
 
 	if (page) {
-		if (!TestSetPageLocked(page))
+		if (trylock_page(page))
 			return page;
 		page_cache_release(page);
 		return NULL;
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1650,7 +1650,7 @@ static int do_wp_page(struct mm_struct *
 	 * not dirty accountable.
 	 */
 	if (PageAnon(old_page)) {
-		if (!TestSetPageLocked(old_page)) {
+		if (trylock_page(old_page)) {
 			reuse = can_share_swap_page(old_page);
 			unlock_page(old_page);
 		}
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c
+++ linux-2.6/mm/migrate.c
@@ -568,7 +568,7 @@ static int move_to_new_page(struct page 
 	 * establishing additional references. We are the only one
 	 * holding a reference to the new page at this point.
 	 */
-	if (TestSetPageLocked(newpage))
+	if (!trylock_page(newpage))
 		BUG();
 
 	/* Prepare mapping for the new page.*/
@@ -621,7 +621,7 @@ static int unmap_and_move(new_page_t get
 		goto move_newpage;
 
 	rc = -EAGAIN;
-	if (TestSetPageLocked(page)) {
+	if (!trylock_page(page)) {
 		if (!force)
 			goto move_newpage;
 		lock_page(page);
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c
+++ linux-2.6/mm/rmap.c
@@ -401,7 +401,7 @@ int page_referenced(struct page *page, i
 			referenced += page_referenced_anon(page);
 		else if (is_locked)
 			referenced += page_referenced_file(page);
-		else if (TestSetPageLocked(page))
+		else if (!trylock_page(page))
 			referenced++;
 		else {
 			if (page->mapping)
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c
+++ linux-2.6/mm/shmem.c
@@ -1165,7 +1165,7 @@ repeat:
 		}
 
 		/* We have to do this with page locked to prevent races */
-		if (TestSetPageLocked(swappage)) {
+		if (!trylock_page(swappage)) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			wait_on_page_locked(swappage);
@@ -1224,7 +1224,7 @@ repeat:
 		shmem_swp_unmap(entry);
 		filepage = find_get_page(mapping, idx);
 		if (filepage &&
-		    (!PageUptodate(filepage) || TestSetPageLocked(filepage))) {
+		    (!PageUptodate(filepage) || !trylock_page(filepage))) {
 			spin_unlock(&info->lock);
 			wait_on_page_locked(filepage);
 			page_cache_release(filepage);
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c
+++ linux-2.6/mm/swap.c
@@ -412,7 +412,7 @@ void pagevec_strip(struct pagevec *pvec)
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 
-		if (PagePrivate(page) && !TestSetPageLocked(page)) {
+		if (PagePrivate(page) && trylock_page(page)) {
 			if (PagePrivate(page))
 				try_to_release_page(page, 0);
 			unlock_page(page);
Index: linux-2.6/mm/swap_state.c
===================================================================
--- linux-2.6.orig/mm/swap_state.c
+++ linux-2.6/mm/swap_state.c
@@ -252,7 +252,7 @@ int move_from_swap_cache(struct page *pa
  */
 static inline void free_swap_cache(struct page *page)
 {
-	if (PageSwapCache(page) && !TestSetPageLocked(page)) {
+	if (PageSwapCache(page) && trylock_page(page)) {
 		remove_exclusive_swap_page(page);
 		unlock_page(page);
 	}
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c
+++ linux-2.6/mm/swapfile.c
@@ -401,7 +401,7 @@ void free_swap_and_cache(swp_entry_t ent
 	if (p) {
 		if (swap_entry_free(p, swp_offset(entry)) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
-			if (page && unlikely(TestSetPageLocked(page))) {
+			if (page && unlikely(!trylock_page(page))) {
 				page_cache_release(page);
 				page = NULL;
 			}
Index: linux-2.6/mm/truncate.c
===================================================================
--- linux-2.6.orig/mm/truncate.c
+++ linux-2.6/mm/truncate.c
@@ -186,7 +186,7 @@ void truncate_inode_pages_range(struct a
 			if (page_index > next)
 				next = page_index;
 			next++;
-			if (TestSetPageLocked(page))
+			if (!trylock_page(page))
 				continue;
 			if (PageWriteback(page)) {
 				unlock_page(page);
@@ -279,7 +279,7 @@ unsigned long __invalidate_mapping_pages
 			pgoff_t index;
 			int lock_failed;
 
-			lock_failed = TestSetPageLocked(page);
+			lock_failed = !trylock_page(page);
 
 			/*
 			 * We really shouldn't be looking at the ->index of an
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -461,7 +461,7 @@ static unsigned long shrink_page_list(st
 		page = lru_to_page(page_list);
 		list_del(&page->lru);
 
-		if (TestSetPageLocked(page))
+		if (!trylock_page(page))
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
@@ -547,7 +547,7 @@ static unsigned long shrink_page_list(st
 				 * A synchronous write - probably a ramdisk.  Go
 				 * ahead and try to reclaim the page.
 				 */
-				if (TestSetPageLocked(page))
+				if (!trylock_page(page))
 					goto keep;
 				if (PageDirty(page) || PageWriteback(page))
 					goto keep_locked;

--

