Return-Path: <linux-kernel-owner+w=401wt.eu-S1945985AbXBPQXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985AbXBPQXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945983AbXBPQXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:23:53 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49995 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945982AbXBPQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:23:52 -0500
To: akpm@linux-foundation.org
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] consolidate generic_writepages and mpage_writepages
Message-Id: <E1HI5rp-0000VA-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 16 Feb 2007 17:23:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up massive code duplication between mpage_writepages() and
generic_writepages().

The new generic function, write_cache_pages() takes a function pointer
argument, which will be called for each page to be written.

Maybe cifs_writepages() too can use this infrastructure, but I'm not
touching that with a ten-foot pole.

The upcoming page writeback support in fuse will also want this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/mpage.c
===================================================================
--- linux.orig/fs/mpage.c	2007-02-16 16:54:41.000000000 +0100
+++ linux/fs/mpage.c	2007-02-16 16:54:42.000000000 +0100
@@ -458,11 +458,18 @@ EXPORT_SYMBOL(mpage_readpage);
  * written, so it can intelligently allocate a suitably-sized BIO.  For now,
  * just allocate full-size (16-page) BIOs.
  */
-static struct bio *
-__mpage_writepage(struct bio *bio, struct page *page, get_block_t get_block,
-	sector_t *last_block_in_bio, int *ret, struct writeback_control *wbc,
-	writepage_t writepage_fn)
+struct mpage_data {
+	struct bio *bio;
+	sector_t last_block_in_bio;
+	get_block_t *get_block;
+	unsigned use_writepage;
+};
+
+static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
+			     void *data)
 {
+	struct mpage_data *mpd = data;
+	struct bio *bio = mpd->bio;
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
@@ -480,6 +487,7 @@ __mpage_writepage(struct bio *bio, struc
 	int length;
 	struct buffer_head map_bh;
 	loff_t i_size = i_size_read(inode);
+	int ret = 0;
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *head = page_buffers(page);
@@ -542,7 +550,7 @@ __mpage_writepage(struct bio *bio, struc
 
 		map_bh.b_state = 0;
 		map_bh.b_size = 1 << blkbits;
-		if (get_block(inode, block_in_file, &map_bh, 1))
+		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
 			goto confused;
 		if (buffer_new(&map_bh))
 			unmap_underlying_metadata(map_bh.b_bdev,
@@ -591,7 +599,7 @@ page_is_mapped:
 	/*
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
-	if (bio && *last_block_in_bio != blocks[0] - 1)
+	if (bio && mpd->last_block_in_bio != blocks[0] - 1)
 		bio = mpage_bio_submit(WRITE, bio);
 
 alloc_new:
@@ -648,7 +656,7 @@ alloc_new:
 					boundary_block, 1 << blkbits);
 		}
 	} else {
-		*last_block_in_bio = blocks[blocks_per_page - 1];
+		mpd->last_block_in_bio = blocks[blocks_per_page - 1];
 	}
 	goto out;
 
@@ -656,18 +664,19 @@ confused:
 	if (bio)
 		bio = mpage_bio_submit(WRITE, bio);
 
-	if (writepage_fn) {
-		*ret = (*writepage_fn)(page, wbc);
+	if (mpd->use_writepage) {
+		ret = mapping->a_ops->writepage(page, wbc);
 	} else {
-		*ret = -EAGAIN;
+		ret = -EAGAIN;
 		goto out;
 	}
 	/*
 	 * The caller has a ref on the inode, so *mapping is stable
 	 */
-	mapping_set_error(mapping, *ret);
+	mapping_set_error(mapping, ret);
 out:
-	return bio;
+	mpd->bio = bio;
+	return ret;
 }
 
 /**
@@ -690,120 +699,27 @@ out:
  * the call was made get new I/O started against them.  If wbc->sync_mode is
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
- *
- * If you fix this you should check generic_writepages() also!
  */
 int
 mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
-	struct bio *bio = NULL;
-	sector_t last_block_in_bio = 0;
-	int ret = 0;
-	int done = 0;
-	int (*writepage)(struct page *page, struct writeback_control *wbc);
-	struct pagevec pvec;
-	int nr_pages;
-	pgoff_t index;
-	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
-	int range_whole = 0;
-
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		return 0;
-	}
+	int ret;
 
-	writepage = NULL;
-	if (get_block == NULL)
-		writepage = mapping->a_ops->writepage;
-
-	pagevec_init(&pvec, 0);
-	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
-	} else {
-		index = wbc->range_start >> PAGE_CACHE_SHIFT;
-		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
-		scanned = 1;
+	if (!get_block)
+		ret = generic_writepages(mapping, wbc);
+	else {
+		struct mpage_data mpd = {
+			.bio = NULL,
+			.last_block_in_bio = 0,
+			.get_block = get_block,
+			.use_writepage = 1,
+		};
+
+		ret = write_cache_pages(mapping, wbc, __mpage_writepage, &mpd);
+		if (mpd.bio)
+			mpage_bio_submit(WRITE, mpd.bio);
 	}
-retry:
-	while (!done && (index <= end) &&
-			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-			PAGECACHE_TAG_DIRTY,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
-
-		scanned = 1;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-
-			/*
-			 * At this point we hold neither mapping->tree_lock nor
-			 * lock on the page itself: the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or even
-			 * swizzled back from swapper_space to tmpfs file
-			 * mapping
-			 */
-
-			lock_page(page);
-
-			if (unlikely(page->mapping != mapping)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (!wbc->range_cyclic && page->index > end) {
-				done = 1;
-				unlock_page(page);
-				continue;
-			}
-
-			if (wbc->sync_mode != WB_SYNC_NONE)
-				wait_on_page_writeback(page);
-
-			if (PageWriteback(page) ||
-					!clear_page_dirty_for_io(page)) {
-				unlock_page(page);
-				continue;
-			}
-
-			if (writepage) {
-				ret = (*writepage)(page, wbc);
-				mapping_set_error(mapping, ret);
-			} else {
-				bio = __mpage_writepage(bio, page, get_block,
-						&last_block_in_bio, &ret, wbc,
-						page->mapping->a_ops->writepage);
-			}
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
-				unlock_page(page);
-			if (ret || (--(wbc->nr_to_write) <= 0))
-				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
-				wbc->encountered_congestion = 1;
-				done = 1;
-			}
-		}
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = index;
-	if (bio)
-		mpage_bio_submit(WRITE, bio);
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepages);
@@ -811,15 +727,15 @@ EXPORT_SYMBOL(mpage_writepages);
 int mpage_writepage(struct page *page, get_block_t get_block,
 	struct writeback_control *wbc)
 {
-	int ret = 0;
-	struct bio *bio;
-	sector_t last_block_in_bio = 0;
-
-	bio = __mpage_writepage(NULL, page, get_block,
-			&last_block_in_bio, &ret, wbc, NULL);
-	if (bio)
-		mpage_bio_submit(WRITE, bio);
-
+	struct mpage_data mpd = {
+		.bio = NULL,
+		.last_block_in_bio = 0,
+		.get_block = get_block,
+		.use_writepage = 0,
+	};
+	int ret = __mpage_writepage(page, wbc, &mpd);
+	if (mpd.bio)
+		mpage_bio_submit(WRITE, mpd.bio);
 	return ret;
 }
 EXPORT_SYMBOL(mpage_writepage);
Index: linux/include/linux/mpage.h
===================================================================
--- linux.orig/include/linux/mpage.h	2007-02-16 16:54:41.000000000 +0100
+++ linux/include/linux/mpage.h	2007-02-16 16:54:42.000000000 +0100
@@ -12,7 +12,6 @@
 #ifdef CONFIG_BLOCK
 
 struct writeback_control;
-typedef int (writepage_t)(struct page *page, struct writeback_control *wbc);
 
 int mpage_readpages(struct address_space *mapping, struct list_head *pages,
 				unsigned nr_pages, get_block_t get_block);
Index: linux/include/linux/writeback.h
===================================================================
--- linux.orig/include/linux/writeback.h	2007-02-16 16:54:41.000000000 +0100
+++ linux/include/linux/writeback.h	2007-02-16 16:54:42.000000000 +0100
@@ -115,9 +115,14 @@ balance_dirty_pages_ratelimited(struct a
 	balance_dirty_pages_ratelimited_nr(mapping, 1);
 }
 
+typedef int (*writepage_t)(struct page *, struct writeback_control *, void *);
+
 int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0);
-extern int generic_writepages(struct address_space *mapping,
-			      struct writeback_control *wbc);
+int generic_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc);
+int write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 int sync_page_range(struct inode *inode, struct address_space *mapping,
 			loff_t pos, loff_t count);
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-02-16 16:54:41.000000000 +0100
+++ linux/mm/page-writeback.c	2007-02-16 17:04:30.000000000 +0100
@@ -579,31 +579,27 @@ void __init page_writeback_init(void)
 }
 
 /**
- * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
+ * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
+ * @writepage: function called for each page
+ * @data: data passed to writepage function
  *
- * This is a library function, which implements the writepages()
- * address_space_operation.
- *
- * If a page is already under I/O, generic_writepages() skips it, even
+ * If a page is already under I/O, write_cache_pages() skips it, even
  * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
  * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
  * and msync() need to guarantee that all the data which was dirty at the time
  * the call was made get new I/O started against them.  If wbc->sync_mode is
  * WB_SYNC_ALL then we were called for data integrity and we must wait for
  * existing IO to complete.
- *
- * Derived from mpage_writepages() - if you fix this you should check that
- * also!
  */
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc)
+int write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
-	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	struct pagevec pvec;
 	int nr_pages;
 	pgoff_t index;
@@ -616,12 +612,6 @@ int generic_writepages(struct address_sp
 		return 0;
 	}
 
-	writepage = mapping->a_ops->writepage;
-
-	/* deal with chardevs and other special file */
-	if (!writepage)
-		return 0;
-
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
@@ -673,8 +663,7 @@ retry:
 				continue;
 			}
 
-			ret = (*writepage)(page, wbc);
-			mapping_set_error(mapping, ret);
+			ret = (*writepage)(page, wbc, data);
 
 			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
 				unlock_page(page);
@@ -702,6 +691,39 @@ retry:
 	return ret;
 }
 
+EXPORT_SYMBOL(write_cache_pages);
+
+/*
+ * Function used by generic_writepages to call the real writepage
+ * function and set the mapping flags on error
+ */
+static int __writepage(struct page *page, struct writeback_control *wbc,
+		       void *data)
+{
+	struct address_space *mapping = data;
+	int ret = mapping->a_ops->writepage(page, wbc);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
+/**
+ * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
+ * @mapping: address space structure to write
+ * @wbc: subtract the number of written pages from *@wbc->nr_to_write
+ *
+ * This is a library function, which implements the writepages()
+ * address_space_operation.
+ */
+int generic_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc)
+{
+	/* deal with chardevs and other special file */
+	if (!mapping->a_ops->writepage)
+		return 0;
+
+	return write_cache_pages(mapping, wbc, __writepage, mapping);
+}
+
 EXPORT_SYMBOL(generic_writepages);
 
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
