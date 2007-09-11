Return-Path: <linux-kernel-owner+w=401wt.eu-S966659AbXIKGVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966659AbXIKGVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762694AbXIKGGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50588 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762175AbXIKGEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:37 -0400
Message-Id: <20070911060431.829995993@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:17 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [27/41] Large page order operations, zeroing and flushing
Content-Disposition: inline; filename=0027-Compound-page-zeroing-and-flushing.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We may have to zero and flush higher order pages. Implement
clear_mapping_page and flush_mapping_page to do that job. Replace
the flushing and clearing at some key locations for the pagecache.

In some places it is necesssary to determine the page order in use
from the page struct since no mapping is available. Add a series of
page_cache_page_xx functions:

page_cache_head(page)		-> Determine head page from a tail page
page_cache_base_pages(page)		-> Number of base pages of a page
page_cache_page_order(page)	-> Determine page order of a page
page_cache_page_size(page)	-> Determine page size of a page
page_cache_page_shift(page)	-> Determine page shif of a page

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/libfs.c              |    4 +--
 fs/reiserfs/file.c      |    2 -
 include/linux/pagemap.h |   58 +++++++++++++++++++++++++++++++++++++++++++++---
 mm/filemap.c            |    4 +--
 mm/filemap_xip.c        |    4 +--
 5 files changed, 62 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h	2007-09-10 22:20:33.000000000 -0700
+++ linux-2.6/include/linux/pagemap.h	2007-09-10 22:37:25.000000000 -0700
@@ -91,6 +91,31 @@ static inline unsigned int page_cache_of
 	return pos & ~PAGE_MASK;
 }
 
+static inline struct page *page_cache_head(struct page *page)
+{
+	return page;
+}
+
+static inline int page_cache_base_pages(struct page *page)
+{
+	return 1;
+}
+
+static inline unsigned long page_cache_page_order(struct page *page)
+{
+	return 0;
+}
+
+static inline unsigned long page_cache_page_size(struct page *page)
+{
+	return PAGE_SIZE;
+}
+
+static inline unsigned long page_cache_page_shift(struct page *page)
+{
+	return PAGE_SHIFT;
+}
+
 static inline pgoff_t page_cache_index(struct address_space *a,
 		loff_t pos)
 {
@@ -263,6 +288,33 @@ static inline void wait_on_page_writebac
 extern void end_page_writeback(struct page *page);
 
 /*
+ * Clear a higher order page
+ */
+static inline void clear_mapping_page(struct page *page)
+{
+	int nr_pages = page_cache_base_pages(page);
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		clear_highpage(page + i);
+}
+
+/*
+ * Primitive support for flushing higher order pages.
+ *
+ * A bit stupid: On many platforms flushing the first page
+ * will flush any TLB starting there
+ */
+static inline void flush_mapping_page(struct page *page)
+{
+	int nr_pages = page_cache_base_pages(page);
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		flush_dcache_page(page + i);
+}
+
+/*
  * Zeroing of segments of a page
  */
 static inline void zero_user_segments(struct page *page,
@@ -271,8 +323,8 @@ static inline void zero_user_segments(st
 {
 	void *kaddr = kmap_atomic(page, KM_USER0);
 
-	BUG_ON(end1 > PAGE_SIZE ||
-		end2 > PAGE_SIZE);
+	BUG_ON(end1 > page_cache_page_size(page) ||
+		end2 > page_cache_page_size(page));
 
 	if (end1 > start1)
 		memset(kaddr + start1, 0, end1 - start1);
@@ -281,7 +333,7 @@ static inline void zero_user_segments(st
 		memset(kaddr + start2, 0, end2 - start2);
 
 	kunmap_atomic(kaddr, KM_USER0);
-	flush_dcache_page(page);
+	flush_mapping_page(page);
 }
 
 static inline void zero_user_segment(struct page *page,
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2007-09-10 22:20:33.000000000 -0700
+++ linux-2.6/fs/libfs.c	2007-09-10 22:37:05.000000000 -0700
@@ -330,8 +330,8 @@ int simple_rename(struct inode *old_dir,
 
 int simple_readpage(struct file *file, struct page *page)
 {
-	clear_highpage(page);
-	flush_dcache_page(page);
+	clear_mapping_page(page);
+	flush_mapping_page(page);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-09-10 22:20:33.000000000 -0700
+++ linux-2.6/mm/filemap.c	2007-09-10 22:37:17.000000000 -0700
@@ -941,7 +941,7 @@ page_ok:
 		 * before reading the page on the kernel side.
 		 */
 		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
+			flush_mapping_page(page);
 
 		/*
 		 * When a sequential read accesses a page several times,
@@ -1932,7 +1932,7 @@ generic_file_buffered_write(struct kiocb
 		else
 			copied = filemap_copy_from_user_iovec(page, offset,
 						cur_iov, iov_base, bytes);
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (status == AOP_TRUNCATED_PAGE) {
 			page_cache_release(page);
Index: linux-2.6/mm/filemap_xip.c
===================================================================
--- linux-2.6.orig/mm/filemap_xip.c	2007-09-10 22:20:33.000000000 -0700
+++ linux-2.6/mm/filemap_xip.c	2007-09-10 22:23:32.000000000 -0700
@@ -104,7 +104,7 @@ do_xip_mapping_read(struct address_space
 		 * before reading the page on the kernel side.
 		 */
 		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
+			flush_mapping_page(page);
 
 		/*
 		 * Ok, we have the page, so now we can copy it to user space...
@@ -320,7 +320,7 @@ __xip_file_write(struct file *filp, cons
 		}
 
 		copied = filemap_copy_from_user(page, offset, buf, bytes);
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 		if (likely(copied > 0)) {
 			status = copied;
 
Index: linux-2.6/fs/reiserfs/file.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/file.c	2007-09-10 22:20:33.000000000 -0700
+++ linux-2.6/fs/reiserfs/file.c	2007-09-10 22:23:32.000000000 -0700
@@ -748,7 +748,7 @@ static int reiserfs_copy_from_user_to_fi
 		page_fault = __copy_from_user(page_address(page) + offset, buf, count);
 					// Copy the data.
 		/* Flush processor's dcache for this page */
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 		kunmap(page);
 		buf += count;
 		write_bytes -= count;

-- 
