Return-Path: <linux-kernel-owner+w=401wt.eu-S965472AbXCFSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbXCFSIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965464AbXCFSGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:06:15 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:39834 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965462AbXCFSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:06:13 -0500
Message-Id: <20070306180550.793803735@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 Mar 2007 19:04:46 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 3/8] per backing_dev dirty and writeback page accounting
Content-Disposition: inline; filename=per-backing_dev-dirty-and-writeback-page-accounting.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

[tomoki.sekiyama.qu@hitachi.com: bugfix]

Miklos Szeredi <mszeredi@suse.cz>:

Changes:
 - updated to apply after clear_page_dirty_for_io() race fix

This is needed for

 - balance_dirty_pages() deadlock fix
 - fuse dirty page accounting

I have no idea how serious the scalability problems with this are.  If
they are serious, different solutions can probably be found for the
above, but this is certainly the simplest.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/block/ll_rw_blk.c
===================================================================
--- linux.orig/block/ll_rw_blk.c	2007-03-06 11:19:16.000000000 +0100
+++ linux/block/ll_rw_blk.c	2007-03-06 13:40:08.000000000 +0100
@@ -201,6 +201,8 @@ EXPORT_SYMBOL(blk_queue_softirq_done);
  **/
 void blk_queue_make_request(request_queue_t * q, make_request_fn * mfn)
 {
+	struct backing_dev_info *bdi = &q->backing_dev_info;
+
 	/*
 	 * set defaults
 	 */
@@ -208,9 +210,11 @@ void blk_queue_make_request(request_queu
 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
 	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
 	q->make_request_fn = mfn;
-	q->backing_dev_info.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
-	q->backing_dev_info.state = 0;
-	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
+	bdi->ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
+	bdi->state = 0;
+	bdi->capabilities = BDI_CAP_MAP_COPY;
+	atomic_long_set(&bdi->nr_dirty, 0);
+	atomic_long_set(&bdi->nr_writeback, 0);
 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
@@ -3922,6 +3926,19 @@ static ssize_t queue_max_hw_sectors_show
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_nr_dirty_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lu\n",
+		atomic_long_read(&q->backing_dev_info.nr_dirty));
+
+}
+
+static ssize_t queue_nr_writeback_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%lu\n",
+		atomic_long_read(&q->backing_dev_info.nr_writeback));
+
+}
 
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
@@ -3946,6 +3963,16 @@ static struct queue_sysfs_entry queue_ma
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_nr_dirty_entry = {
+	.attr = {.name = "nr_dirty", .mode = S_IRUGO },
+	.show = queue_nr_dirty_show,
+};
+
+static struct queue_sysfs_entry queue_nr_writeback_entry = {
+	.attr = {.name = "nr_writeback", .mode = S_IRUGO },
+	.show = queue_nr_writeback_show,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -3957,6 +3984,8 @@ static struct attribute *default_attrs[]
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
+	&queue_nr_dirty_entry.attr,
+	&queue_nr_writeback_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
Index: linux/include/linux/backing-dev.h
===================================================================
--- linux.orig/include/linux/backing-dev.h	2007-03-06 11:19:18.000000000 +0100
+++ linux/include/linux/backing-dev.h	2007-03-06 13:40:08.000000000 +0100
@@ -28,6 +28,8 @@ struct backing_dev_info {
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
 	unsigned int capabilities; /* Device capabilities */
+	atomic_long_t nr_dirty;	/* Pages dirty against this BDI */
+	atomic_long_t nr_writeback;/* Pages under writeback against this BDI */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
 	void *congested_data;	/* Pointer to aux data for congested func */
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-03-06 13:28:26.000000000 +0100
+++ linux/mm/page-writeback.c	2007-03-06 13:45:55.000000000 +0100
@@ -743,6 +743,7 @@ void generic_page_dirtied(struct page *p
 	if (mapping) { /* Race with truncate? */
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			atomic_long_inc(&mapping->backing_dev_info->nr_dirty);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
@@ -896,6 +897,7 @@ int clear_page_dirty_for_io(struct page 
 			}
 
 			dec_zone_page_state(page, NR_FILE_DIRTY);
+			atomic_long_dec(&mapping->backing_dev_info->nr_dirty);
 		}
 		return 1;
 	}
@@ -913,10 +915,13 @@ int test_clear_page_writeback(struct pag
 
 		write_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestClearPageWriteback(page);
-		if (ret)
+		if (ret) {
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
+			atomic_long_dec(&mapping->backing_dev_info->
+					nr_writeback);
+		}
 		write_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
 		ret = TestClearPageWriteback(page);
@@ -934,10 +939,13 @@ int test_set_page_writeback(struct page 
 
 		write_lock_irqsave(&mapping->tree_lock, flags);
 		ret = TestSetPageWriteback(page);
-		if (!ret)
+		if (!ret) {
 			radix_tree_tag_set(&mapping->page_tree,
 						page_index(page),
 						PAGECACHE_TAG_WRITEBACK);
+			atomic_long_inc(&mapping->backing_dev_info->
+					nr_writeback);
+		}
 		if (!PageDirty(page))
 			radix_tree_tag_clear(&mapping->page_tree,
 						page_index(page),
Index: linux/mm/truncate.c
===================================================================
--- linux.orig/mm/truncate.c	2007-03-06 11:19:18.000000000 +0100
+++ linux/mm/truncate.c	2007-03-06 13:40:08.000000000 +0100
@@ -70,6 +70,7 @@ void cancel_dirty_page(struct page *page
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
+			atomic_long_dec(&mapping->backing_dev_info->nr_dirty);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);

--
