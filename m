Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYIXSxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYIXSxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYIXSw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:52:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYIXSw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:52:58 -0400
Date: Wed, 24 Sep 2008 14:52:18 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, agk@redhat.com,
       mbroz@redhat.com, chris@arachsys.com
Subject: [PATCH 2/3] Memory management livelock
In-Reply-To: <20080923164623.ce82c1c2.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid starvation when walking address space.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   20 ++++++++++++++++++++
 mm/page-writeback.c     |   37 ++++++++++++++++++++++++++++++++++++-
 mm/truncate.c           |   24 +++++++++++++++++++++++-
 4 files changed, 80 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc7-devel/include/linux/pagemap.h
===================================================================
--- linux-2.6.27-rc7-devel.orig/include/linux/pagemap.h	2008-09-24 02:57:37.000000000 +0200
+++ linux-2.6.27-rc7-devel/include/linux/pagemap.h	2008-09-24 02:59:04.000000000 +0200
@@ -21,6 +21,7 @@
 #define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
 #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
 #define AS_MM_ALL_LOCKS	(__GFP_BITS_SHIFT + 2)	/* under mm_take_all_locks() */
+#define AS_STARVATION	(__GFP_BITS_SHIFT + 3)	/* an anti-starvation barrier */
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
Index: linux-2.6.27-rc7-devel/mm/filemap.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/filemap.c	2008-09-24 02:59:33.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/filemap.c	2008-09-24 03:13:47.000000000 +0200
@@ -269,10 +269,19 @@ int wait_on_page_writeback_range(struct 
 	int nr_pages;
 	int ret = 0;
 	pgoff_t index;
+	long pages_to_process;
 
 	if (end < start)
 		return 0;
 
+	/*
+	 * Estimate the number of pages to process. If we process significantly
+	 * more than this, someone is making writeback pages under us.
+	 * We must pull the anti-starvation plug.
+	 */
+	pages_to_process = bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
+	pages_to_process += (pages_to_process >> 3) + 16;
+
 	pagevec_init(&pvec, 0);
 	index = start;
 	while ((index <= end) &&
@@ -288,6 +297,10 @@ int wait_on_page_writeback_range(struct 
 			if (page->index > end)
 				continue;
 
+			if (pages_to_process >= 0)
+				if (!pages_to_process--)
+					wait_on_bit_lock(&mapping->flags, AS_STARVATION, wait_action_schedule, TASK_UNINTERRUPTIBLE);
+
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
@@ -296,6 +309,13 @@ int wait_on_page_writeback_range(struct 
 		cond_resched();
 	}
 
+	if (pages_to_process < 0) {
+		smp_mb__before_clear_bit();
+		clear_bit(AS_STARVATION, &mapping->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&mapping->flags, AS_STARVATION);
+	}
+
 	/* Check for outstanding write errors */
 	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
 		ret = -ENOSPC;
Index: linux-2.6.27-rc7-devel/mm/page-writeback.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/page-writeback.c	2008-09-24 03:10:34.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/page-writeback.c	2008-09-24 03:20:24.000000000 +0200
@@ -435,6 +435,18 @@ static void balance_dirty_pages(struct a
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
+	/*
+	 * If there is sync() starving on this address space, block
+	 * writers until it finishes.
+	 */
+	if (unlikely(test_bit(AS_STARVATION, &mapping->flags))) {
+		wait_on_bit_lock(&mapping->flags, AS_STARVATION, wait_action_schedule, TASK_UNINTERRUPTIBLE);
+		smp_mb__before_clear_bit();
+		clear_bit(AS_STARVATION, &mapping->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&mapping->flags, AS_STARVATION);
+	}
+
 	for (;;) {
 		struct writeback_control wbc = {
 			.bdi		= bdi,
@@ -876,12 +888,21 @@ int write_cache_pages(struct address_spa
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
 	int range_whole = 0;
+	long pages_to_process;
 
 	if (wbc->nonblocking && bdi_write_congested(bdi)) {
 		wbc->encountered_congestion = 1;
 		return 0;
 	}
 
+	/*
+	 * Estimate the number of pages to process. If we process significantly
+	 * more than this, someone is making dirty pages under us.
+	 * Pull the anti-starvation plug to stop him.
+	 */
+	pages_to_process = bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+	pages_to_process += (pages_to_process >> 3) + 16;
+
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
@@ -902,7 +923,13 @@ retry:
 
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+			struct page *page;
+
+			if (pages_to_process >= 0)
+				if (!pages_to_process--)
+					wait_on_bit_lock(&mapping->flags, AS_STARVATION, wait_action_schedule, TASK_UNINTERRUPTIBLE);
+
+			page = pvec.pages[i];
 
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
@@ -949,6 +976,14 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+
+	if (pages_to_process < 0) {
+		smp_mb__before_clear_bit();
+		clear_bit(AS_STARVATION, &mapping->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&mapping->flags, AS_STARVATION);
+	}
+
 	if (!scanned && !done) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
Index: linux-2.6.27-rc7-devel/mm/truncate.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/truncate.c	2008-09-24 03:16:15.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/truncate.c	2008-09-24 03:18:00.000000000 +0200
@@ -392,6 +392,14 @@ int invalidate_inode_pages2_range(struct
 	int ret2 = 0;
 	int did_range_unmap = 0;
 	int wrapped = 0;
+	long pages_to_process;
+
+	/*
+	 * Estimate number of pages to process. If we process more, someone
+	 * is making pages under us.
+	 */
+	pages_to_process = mapping->nrpages;
+	pages_to_process += (pages_to_process >> 3) + 16;
 
 	pagevec_init(&pvec, 0);
 	next = start;
@@ -399,9 +407,15 @@ int invalidate_inode_pages2_range(struct
 		pagevec_lookup(&pvec, mapping, next,
 			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			struct page *page;
 			pgoff_t page_index;
 
+			if (pages_to_process >= 0)
+				if (!pages_to_process--)
+					wait_on_bit_lock(&mapping->flags, AS_STARVATION, wait_action_schedule, TASK_UNINTERRUPTIBLE);
+
+			page = pvec.pages[i];
+
 			lock_page(page);
 			if (page->mapping != mapping) {
 				unlock_page(page);
@@ -449,6 +463,14 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+
+	if (pages_to_process < 0) {
+		smp_mb__before_clear_bit();
+		clear_bit(AS_STARVATION, &mapping->flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&mapping->flags, AS_STARVATION);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);

