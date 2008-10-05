Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYJEWPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYJEWPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYJEWPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:15:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbYJEWPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:15:01 -0400
Date: Sun, 5 Oct 2008 18:14:50 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: [PATCH 2/3] Fix fsync livelock
In-Reply-To: <20081001225404.4e973465.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix starvation in memory management.

The bug happens when one process is doing sequential buffered writes to
a block device (or file) and another process is attempting to execute
sync(), fsync() or direct-IO on that device (or file). This syncing
process will wait indefinitelly, until the first writing process
finishes.

For example, run these two commands:
dd if=/dev/zero of=/dev/sda1 bs=65536 &
dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct

The bug is caused by sequential walking of address space in
write_cache_pages and wait_on_page_writeback_range: if some other
process is constantly making dirty and writeback pages while these
functions run, the functions will wait on every new page, resulting in
indefinite wait.

To fix the starvation, I declared a bit mutex starvation_barrier in
struct address_space. The bit AS_STARVATION_BARRIER in
address_space->flags is used for actual locking. When the mutex is
taken, anyone making dirty pages on that address space should stop. The
functions that walk address space sequentially first estimate a number
of pages to process. If they process more than this amount (plus some
small delta), it means that someone is making dirty pages under them ---
they take the mutex and hold it until they finish. When the mutex is
taken, the function balance_dirty_pages will wait and not allow more
dirty pages being made.

The mutex is not really used as a mutex, it does not prevent access to
any critical section. It is used as a barrier that blocks new dirty
pages from being created. I use mutex and not wait queue to make sure
that the starvation can't happend the other way (if there were wait
queue, excessive calls to write_cache_pages and
wait_on_page_writeback_range would block balance_dirty_pages forever;
with mutex it is guaranteed that every process eventually makes
progress).

The essential property of this patch is that if the starvation doesn't
happen, no additional locks are taken and no atomic operations are
performed. So the patch shouldn't damage performance.

The indefinite starvation was observed in write_cache_pages and
wait_on_page_writeback_range. Another possibility where it could happen
is invalidate_inode_pages2_range.

There are two more functions that walk all the pages in address space,
but I think they don't need this starvation protection:
truncate_inode_pages_range: it is called with i_mutex locked, so no new
pages are created under it.
__invalidate_mapping_pages: it skips locked, dirty and writeback pages,
so there's no point in protecting the function against starving on them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/inode.c              |    1 +
 include/linux/fs.h      |    3 +++
 include/linux/pagemap.h |   14 ++++++++++++++
 mm/filemap.c            |    5 +++++
 mm/page-writeback.c     |   18 +++++++++++++++++-
 mm/swap_state.c         |    1 +
 mm/truncate.c           |   10 +++++++++-
 7 files changed, 50 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc8-devel/fs/inode.c
===================================================================
--- linux-2.6.27-rc8-devel.orig/fs/inode.c	2008-10-04 16:47:55.000000000 +0200
+++ linux-2.6.27-rc8-devel/fs/inode.c	2008-10-04 16:48:04.000000000 +0200
@@ -216,6 +216,7 @@ void inode_init_once(struct inode *inode
 	spin_lock_init(&inode->i_data.private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
 	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
+	bit_mutex_init(&inode->i_data.flags, AS_STARVATION_BARRIER, &inode->i_data.starvation_barrier);
 	i_size_ordered_init(inode);
 #ifdef CONFIG_INOTIFY
 	INIT_LIST_HEAD(&inode->inotify_watches);
Index: linux-2.6.27-rc8-devel/include/linux/fs.h
===================================================================
--- linux-2.6.27-rc8-devel.orig/include/linux/fs.h	2008-10-04 16:47:54.000000000 +0200
+++ linux-2.6.27-rc8-devel/include/linux/fs.h	2008-10-04 16:49:54.000000000 +0200
@@ -289,6 +289,7 @@ extern int dir_notify_enable;
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
+#include <linux/bit-mutex.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 
@@ -539,6 +540,8 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+
+	struct bit_mutex	starvation_barrier;/* taken when fsync starves */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
Index: linux-2.6.27-rc8-devel/include/linux/pagemap.h
===================================================================
--- linux-2.6.27-rc8-devel.orig/include/linux/pagemap.h	2008-10-04 16:47:54.000000000 +0200
+++ linux-2.6.27-rc8-devel/include/linux/pagemap.h	2008-10-04 16:48:04.000000000 +0200
@@ -21,6 +21,7 @@
 #define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
 #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
 #define AS_MM_ALL_LOCKS	(__GFP_BITS_SHIFT + 2)	/* under mm_take_all_locks() */
+#define AS_STARVATION_BARRIER (__GFP_BITS_SHIFT + 3) /* an anti-starvation barrier */
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
@@ -424,4 +425,17 @@ static inline int add_to_page_cache(stru
 	return error;
 }
 
+#define starvation_protection_head(n)				\
+	long pages_to_process = (n);				\
+	pages_to_process += (pages_to_process >> 3) + 16;
+
+#define starvation_protection_step(mapping)			\
+	if (pages_to_process >= 0)				\
+		if (!pages_to_process--)			\
+			bit_mutex_lock(&(mapping)->flags, AS_STARVATION_BARRIER, &(mapping)->starvation_barrier);
+
+#define starvation_protection_end(mapping)			\
+	if (pages_to_process < 0)				\
+		bit_mutex_unlock(&(mapping)->flags, AS_STARVATION_BARRIER, &(mapping)->starvation_barrier);
+
 #endif /* _LINUX_PAGEMAP_H */
Index: linux-2.6.27-rc8-devel/mm/filemap.c
===================================================================
--- linux-2.6.27-rc8-devel.orig/mm/filemap.c	2008-10-04 16:47:55.000000000 +0200
+++ linux-2.6.27-rc8-devel/mm/filemap.c	2008-10-04 16:48:04.000000000 +0200
@@ -269,6 +269,7 @@ int wait_on_page_writeback_range(struct 
 	int nr_pages;
 	int ret = 0;
 	pgoff_t index;
+	starvation_protection_head(bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK));
 
 	if (end < start)
 		return 0;
@@ -288,6 +289,8 @@ int wait_on_page_writeback_range(struct 
 			if (page->index > end)
 				continue;
 
+			starvation_protection_step(mapping);
+
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
@@ -296,6 +299,8 @@ int wait_on_page_writeback_range(struct 
 		cond_resched();
 	}
 
+	starvation_protection_end(mapping);
+
 	/* Check for outstanding write errors */
 	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
 		ret = -ENOSPC;
Index: linux-2.6.27-rc8-devel/mm/page-writeback.c
===================================================================
--- linux-2.6.27-rc8-devel.orig/mm/page-writeback.c	2008-10-04 16:47:55.000000000 +0200
+++ linux-2.6.27-rc8-devel/mm/page-writeback.c	2008-10-04 16:48:04.000000000 +0200
@@ -435,6 +435,14 @@ static void balance_dirty_pages(struct a
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
+	if (unlikely(bit_mutex_is_locked(&mapping->flags, AS_STARVATION_BARRIER,
+	    &mapping->starvation_barrier))) {
+		bit_mutex_lock(&mapping->flags, AS_STARVATION_BARRIER,
+			&mapping->starvation_barrier);
+		bit_mutex_unlock(&mapping->flags, AS_STARVATION_BARRIER,
+			&mapping->starvation_barrier);
+	}
+
 	for (;;) {
 		struct writeback_control wbc = {
 			.bdi		= bdi,
@@ -876,6 +884,7 @@ int write_cache_pages(struct address_spa
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
 	int range_whole = 0;
+	starvation_protection_head(bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE));
 
 	if (wbc->nonblocking && bdi_write_congested(bdi)) {
 		wbc->encountered_congestion = 1;
@@ -902,7 +911,11 @@ retry:
 
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+			struct page *page;
+
+			starvation_protection_step(mapping);
+
+			page = pvec.pages[i];
 
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
@@ -963,6 +976,9 @@ retry:
 
 	if (wbc->range_cont)
 		wbc->range_start = index << PAGE_CACHE_SHIFT;
+
+	starvation_protection_end(mapping);
+
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);
Index: linux-2.6.27-rc8-devel/mm/swap_state.c
===================================================================
--- linux-2.6.27-rc8-devel.orig/mm/swap_state.c	2008-10-04 16:47:55.000000000 +0200
+++ linux-2.6.27-rc8-devel/mm/swap_state.c	2008-10-04 17:14:03.000000000 +0200
@@ -43,6 +43,7 @@ struct address_space swapper_space = {
 	.a_ops		= &swap_aops,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
 	.backing_dev_info = &swap_backing_dev_info,
+	.starvation_barrier = __BIT_MUTEX_INITIALIZER(&swapper_space.flags, AS_STARVATION_BARRIER, swapper_space.starvation_barrier),
 };
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
Index: linux-2.6.27-rc8-devel/mm/truncate.c
===================================================================
--- linux-2.6.27-rc8-devel.orig/mm/truncate.c	2008-10-04 16:47:55.000000000 +0200
+++ linux-2.6.27-rc8-devel/mm/truncate.c	2008-10-04 16:48:04.000000000 +0200
@@ -392,6 +392,7 @@ int invalidate_inode_pages2_range(struct
 	int ret2 = 0;
 	int did_range_unmap = 0;
 	int wrapped = 0;
+	starvation_protection_head(mapping->nrpages);
 
 	pagevec_init(&pvec, 0);
 	next = start;
@@ -399,9 +400,13 @@ int invalidate_inode_pages2_range(struct
 		pagevec_lookup(&pvec, mapping, next,
 			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			struct page *page;
 			pgoff_t page_index;
 
+			starvation_protection_step(mapping);
+
+			page = pvec.pages[i];
+
 			lock_page(page);
 			if (page->mapping != mapping) {
 				unlock_page(page);
@@ -449,6 +454,9 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+
+	starvation_protection_end(mapping);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);

