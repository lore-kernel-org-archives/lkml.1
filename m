Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXFNG2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXFNG2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXFNG2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:28:20 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53745 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750960AbXFNG2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:28:18 -0400
Message-ID: <381802490.10594@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070614062815.949361167@mail.ustc.edu.cn>
References: <20070614062447.058708836@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 14 Jun 2007 14:21:20 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] readahead: split ondemand readahead interface into two functions
Content-Disposition: inline; filename=readahead-interface-rusty.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split ondemand readahead interface into two functions.  I think this
makes it a little clearer for non-readahead experts (like Rusty).

Internally they both call ondemand_readahead(), but the page argument
is changed to an obvious boolean flag.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/ext3/dir.c      |    4 -
 fs/ext4/dir.c      |    4 -
 fs/splice.c        |    6 +-
 include/linux/mm.h |   20 ++++++---
 mm/filemap.c       |   10 ++--
 mm/readahead.c     |   95 ++++++++++++++++++++++++++-----------------
 6 files changed, 84 insertions(+), 55 deletions(-)

--- linux-2.6.22-rc4-mm2.orig/fs/ext3/dir.c
+++ linux-2.6.22-rc4-mm2/fs/ext3/dir.c
@@ -139,10 +139,10 @@ static int ext3_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
-				page_cache_readahead_ondemand(
+				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
-					NULL, index, 1);
+					index, 1);
 			filp->f_ra.prev_index = index;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
--- linux-2.6.22-rc4-mm2.orig/fs/ext4/dir.c
+++ linux-2.6.22-rc4-mm2/fs/ext4/dir.c
@@ -138,10 +138,10 @@ static int ext4_readdir(struct file * fi
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
-				page_cache_readahead_ondemand(
+				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
-					NULL, index, 1);
+					index, 1);
 			filp->f_ra.prev_index = index;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
--- linux-2.6.22-rc4-mm2.orig/fs/splice.c
+++ linux-2.6.22-rc4-mm2/fs/splice.c
@@ -304,8 +304,8 @@ __generic_file_splice_read(struct file *
 	 * readahead/allocate the rest.
 	 */
 	if (spd.nr_pages < nr_pages)
-		page_cache_readahead_ondemand(mapping, &in->f_ra, in,
-				NULL, index, req_pages - spd.nr_pages);
+		page_cache_sync_readahead(mapping, &in->f_ra, in,
+				index, req_pages - spd.nr_pages);
 
 	while (spd.nr_pages < nr_pages) {
 		/*
@@ -360,7 +360,7 @@ __generic_file_splice_read(struct file *
 		page = pages[page_nr];
 
 		if (PageReadahead(page))
-			page_cache_readahead_ondemand(mapping, &in->f_ra, in,
+			page_cache_async_readahead(mapping, &in->f_ra, in,
 					page, index, req_pages - page_nr);
 
 		/*
--- linux-2.6.22-rc4-mm2.orig/include/linux/mm.h
+++ linux-2.6.22-rc4-mm2/include/linux/mm.h
@@ -1146,12 +1146,20 @@ int do_page_cache_readahead(struct addre
 			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
-unsigned long page_cache_readahead_ondemand(struct address_space *mapping,
-			  struct file_ra_state *ra,
-			  struct file *filp,
-			  struct page *page,
-			  pgoff_t offset,
-			  unsigned long size);
+
+void page_cache_sync_readahead(struct address_space *mapping,
+			       struct file_ra_state *ra,
+			       struct file *filp,
+			       pgoff_t offset,
+			       unsigned long size);
+
+void page_cache_async_readahead(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *pg,
+				pgoff_t offset,
+				unsigned long size);
+
 unsigned long max_sane_readahead(unsigned long nr);
 
 /* Do stack extension */
--- linux-2.6.22-rc4-mm2.orig/mm/filemap.c
+++ linux-2.6.22-rc4-mm2/mm/filemap.c
@@ -913,15 +913,15 @@ void do_generic_mapping_read(struct addr
 find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_readahead_ondemand(mapping,
-					&ra, filp, page,
+			page_cache_sync_readahead(mapping,
+					&ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping,
+			page_cache_async_readahead(mapping,
 					&ra, filp, page,
 					index, last_index - index);
 		}
@@ -1382,14 +1382,14 @@ retry_find:
 	 */
 	if (VM_SequentialReadHint(vma)) {
 		if (!page) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_sync_readahead(mapping, ra, file,
 							   fdata->pgoff, 1);
 			page = find_lock_page(mapping, fdata->pgoff);
 			if (!page)
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
-			page_cache_readahead_ondemand(mapping, ra, file, page,
+			page_cache_async_readahead(mapping, ra, file, page,
 							   fdata->pgoff, 1);
 		}
 	}
--- linux-2.6.22-rc4-mm2.orig/mm/readahead.c
+++ linux-2.6.22-rc4-mm2/mm/readahead.c
@@ -351,7 +351,7 @@ static unsigned long get_next_ra_size(st
 static unsigned long
 ondemand_readahead(struct address_space *mapping,
 		   struct file_ra_state *ra, struct file *filp,
-		   struct page *page, pgoff_t offset,
+		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
 	unsigned long max;	/* max readahead pages */
@@ -379,7 +379,7 @@ ondemand_readahead(struct address_space 
 	 * Standalone, small read.
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	if (!page && !sequential) {
+	if (!hit_readahead_marker && !sequential) {
 		return __do_page_cache_readahead(mapping, filp,
 						offset, req_size, 0);
 	}
@@ -400,7 +400,7 @@ ondemand_readahead(struct address_space 
 	 * E.g. interleaved reads.
 	 * Not knowing its readahead pos/size, bet on the minimal possible one.
 	 */
-	if (page) {
+	if (hit_readahead_marker) {
 		ra_index++;
 		ra_size = min(4 * ra_size, max);
 	}
@@ -413,50 +413,71 @@ fill_ra:
 }
 
 /**
- * page_cache_readahead_ondemand - generic file readahead
+ * page_cache_sync_readahead - generic file readahead
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @filp: passed on to ->readpage() and ->readpages()
- * @page: the page at @offset, or NULL if non-present
- * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @offset: start offset into @mapping, in pagecache page-sized units
  * @req_size: hint: total size of the read which the caller is performing in
- *            PAGE_CACHE_SIZE units
+ *            pagecache pages
  *
- * page_cache_readahead_ondemand() is the entry point of readahead logic.
- * This function should be called when it is time to perform readahead:
- * 1) @page == NULL
- *    A cache miss happened, time for synchronous readahead.
- * 2) @page != NULL && PageReadahead(@page)
- *    A look-ahead hit occured, time for asynchronous readahead.
+ * page_cache_sync_readahead() should be called when a cache miss happened:
+ * it will submit the read.  The readahead logic may decide to piggyback more
+ * pages onto the read request if access patterns suggest it will improve
+ * performance.
  */
-unsigned long
-page_cache_readahead_ondemand(struct address_space *mapping,
-				struct file_ra_state *ra, struct file *filp,
-				struct page *page, pgoff_t offset,
-				unsigned long req_size)
+void page_cache_sync_readahead(struct address_space *mapping,
+			       struct file_ra_state *ra, struct file *filp,
+			       pgoff_t offset, unsigned long req_size)
 {
 	/* no read-ahead */
 	if (!ra->ra_pages)
-		return 0;
+		return;
 
-	if (page) {
-		/*
-		 * It can be PG_reclaim.
-		 */
-		if (PageWriteback(page))
-			return 0;
-
-		ClearPageReadahead(page);
-
-		/*
-		 * Defer asynchronous read-ahead on IO congestion.
-		 */
-		if (bdi_read_congested(mapping->backing_dev_info))
-			return 0;
-	}
+	/* do read-ahead */
+	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
+
+/**
+ * page_cache_async_readahead - file readahead for marked pages
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @filp: passed on to ->readpage() and ->readpages()
+ * @page: the page at @offset which has the PG_readahead flag set
+ * @offset: start offset into @mapping, in pagecache page-sized units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            pagecache pages
+ *
+ * page_cache_async_ondemand() should be called when a page is used which
+ * has the PG_readahead flag: this is a marker to suggest that the application
+ * has used up enough of the readahead window that we should start pulling in
+ * more pages. */
+void
+page_cache_async_readahead(struct address_space *mapping,
+			   struct file_ra_state *ra, struct file *filp,
+			   struct page *page, pgoff_t offset,
+			   unsigned long req_size)
+{
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return;
+
+	/*
+	 * Same bit is used for PG_readahead and PG_reclaim.
+	 */
+	if (PageWriteback(page))
+		return;
+
+	ClearPageReadahead(page);
+
+	/*
+	 * Defer asynchronous read-ahead on IO congestion.
+	 */
+	if (bdi_read_congested(mapping->backing_dev_info))
+		return;
 
 	/* do read-ahead */
-	return ondemand_readahead(mapping, ra, filp, page,
-					offset, req_size);
+	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
 }
-EXPORT_SYMBOL_GPL(page_cache_readahead_ondemand);
+EXPORT_SYMBOL_GPL(page_cache_async_readahead);

--
