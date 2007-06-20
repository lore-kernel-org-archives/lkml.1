Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbXFTSja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbXFTSja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbXFTSbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46751 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758144AbXFTSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:15 -0400
Message-Id: <20070620183013.728684220@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:40 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [33/37] Large blocksize: Compound page zeroing and flushing
Content-Disposition: inline; filename=vps_flush_compound_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We may now have to zero and flush higher order pages. Implement
clear_mapping_page and flush_mapping_page to do that job. Replace
the flushing and clearing at some key locations for the pagecache.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/libfs.c              |    4 ++--
 include/linux/highmem.h |   31 +++++++++++++++++++++++++++++--
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |    8 ++++----
 mm/filemap_xip.c        |    4 ++--
 5 files changed, 38 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc4-mm2/fs/libfs.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/libfs.c	2007-06-19 20:10:05.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/libfs.c	2007-06-19 20:10:45.000000000 -0700
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
Index: linux-2.6.22-rc4-mm2/include/linux/highmem.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/highmem.h	2007-06-19 20:06:06.000000000 -0700
+++ linux-2.6.22-rc4-mm2/include/linux/highmem.h	2007-06-19 20:30:06.000000000 -0700
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
Index: linux-2.6.22-rc4-mm2/mm/filemap.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/filemap.c	2007-06-19 20:10:52.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/filemap.c	2007-06-19 20:11:44.000000000 -0700
@@ -946,7 +946,7 @@ page_ok:
 		 * before reading the page on the kernel side.
 		 */
 		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
+			flush_mapping_page(page);
 
 		/*
 		 * When a sequential read accesses a page several times,
@@ -2004,7 +2004,7 @@ int pagecache_write_end(struct file *fil
 		unsigned offset = page_cache_offset(mapping, pos);
 		struct inode *inode = mapping->host;
 
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 		ret = aops->commit_write(file, page, offset, offset+len);
 		unlock_page(page);
 		page_cache_release(page);
@@ -2216,7 +2216,7 @@ static ssize_t generic_perform_write_2co
 			kunmap_atomic(src, KM_USER0);
 			copied = bytes;
 		}
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (unlikely(status < 0 || status == AOP_TRUNCATED_PAGE))
@@ -2314,7 +2314,7 @@ again:
 		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 		pagefault_enable();
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
Index: linux-2.6.22-rc4-mm2/mm/filemap_xip.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/filemap_xip.c	2007-06-19 20:12:10.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/filemap_xip.c	2007-06-19 20:12:46.000000000 -0700
@@ -103,7 +103,7 @@ do_xip_mapping_read(struct address_space
 		 * before reading the page on the kernel side.
 		 */
 		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
+			flush_mapping_page(page);
 
 		/*
 		 * Ok, we have the page, so now we can copy it to user space...
@@ -347,7 +347,7 @@ __xip_file_write(struct file *filp, cons
 		copied = bytes -
 			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
 		kunmap_atomic(kaddr, KM_USER0);
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 
 		if (likely(copied > 0)) {
 			status = copied;

-- 
