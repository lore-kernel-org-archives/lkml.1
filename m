Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXH1TSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXH1TSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbXH1TIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58823 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757043AbXH1THi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:38 -0400
Message-Id: <20070828190734.354330400@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:18 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [27/36] Compound page zeroing and flushing
Content-Disposition: inline; filename=0027-Compound-page-zeroing-and-flushing.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We may now have to zero and flush higher order pages. Implement
clear_mapping_page and flush_mapping_page to do that job. Replace
the flushing and clearing at some key locations for the pagecache.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/libfs.c              |    4 ++--
 include/linux/highmem.h |   31 +++++++++++++++++++++++++++++--
 mm/filemap.c            |    4 ++--
 mm/filemap_xip.c        |    4 ++--
 4 files changed, 35 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c	2007-08-27 20:51:55.000000000 -0700
+++ linux-2.6/fs/libfs.c	2007-08-27 21:08:04.000000000 -0700
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
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2007-08-27 19:22:17.000000000 -0700
+++ linux-2.6/include/linux/highmem.h	2007-08-27 21:08:04.000000000 -0700
@@ -124,14 +124,41 @@ static inline void clear_highpage(struct
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
+/*
+ * Clear a higher order page
+ */
+static inline void clear_mapping_page(struct page *page)
+{
+	int nr_pages = compound_pages(page);
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
+	int nr_pages = compound_pages(page);
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		flush_dcache_page(page + i);
+}
+
 static inline void zero_user_segments(struct page *page,
 	unsigned start1, unsigned end1,
 	unsigned start2, unsigned end2)
 {
 	void *kaddr = kmap_atomic(page, KM_USER0);
 
-	BUG_ON(end1 > PAGE_SIZE ||
-		end2 > PAGE_SIZE);
+	BUG_ON(end1 > compound_size(page) ||
+		end2 > compound_size(page));
 
 	if (end1 > start1)
 		memset(kaddr + start1, 0, end1 - start1);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-08-27 19:31:13.000000000 -0700
+++ linux-2.6/mm/filemap.c	2007-08-27 21:08:04.000000000 -0700
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
--- linux-2.6.orig/mm/filemap_xip.c	2007-08-27 20:51:40.000000000 -0700
+++ linux-2.6/mm/filemap_xip.c	2007-08-27 21:08:04.000000000 -0700
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
 

-- 
