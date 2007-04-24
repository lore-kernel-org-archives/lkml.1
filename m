Return-Path: <linux-kernel-owner+w=401wt.eu-S1423178AbXDXWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423178AbXDXWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423175AbXDXWXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56810 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423178AbXDXWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:07 -0400
Message-Id: <20070424222306.764423792@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:15 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [10/17] Variable Order Page Cache: Add clearing and flushing function
Content-Disposition: inline; filename=var_pc_flush_zero
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flushing and clearing function for higher order pages.
These are provisional and will likely have to be optimized.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/libfs.c              |    4 ++--
 include/linux/highmem.h |   12 ++++++++++++
 include/linux/pagemap.h |   25 +++++++++++++++++++++++++
 mm/filemap.c            |    4 ++--
 4 files changed, 41 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc7/include/linux/pagemap.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-24 11:41:35.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-24 11:41:51.000000000 -0700
@@ -291,6 +291,31 @@ static inline void wait_on_page_writebac
 
 extern void end_page_writeback(struct page *page);
 
+/* Support for clearing higher order pages */
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
+ * Support for flushing higher order pages.
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
 /*
  * Fault a userspace page into pagetables.  Return non-zero on a fault.
  *
Index: linux-2.6.21-rc7/fs/libfs.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/libfs.c	2007-04-24 11:41:37.000000000 -0700
+++ linux-2.6.21-rc7/fs/libfs.c	2007-04-24 11:41:51.000000000 -0700
@@ -320,8 +320,8 @@ int simple_rename(struct inode *old_dir,
 
 int simple_readpage(struct file *file, struct page *page)
 {
-	clear_highpage(page);
-	flush_dcache_page(page);
+	clear_mapping_page(page);
+	flush_mapping_page(page);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
Index: linux-2.6.21-rc7/include/linux/highmem.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/highmem.h	2007-04-24 11:42:52.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/highmem.h	2007-04-24 11:59:31.000000000 -0700
@@ -81,6 +81,17 @@ static inline void clear_highpage(struct
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
+#ifdef CONFIG_LARGE_BLOCKSIZE
+/*
+ * Macro needed because flush_mapping_page definition is not available yet
+ * CONFIG_LARGE_BLOCKSIZE means !HIGHMEM
+ */
+#define memclear_highpage_flush(__page,__offset,__size) \
+{									\
+	memset(page_address(__page), (__offset), (__size));		\
+	flush_mapping_page(__page);					\
+}
+#else
 /*
  * Same but also flushes aliased cache contents to RAM.
  */
@@ -95,6 +106,7 @@ static inline void memclear_highpage_flu
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr, KM_USER0);
 }
+#endif
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-24 11:41:37.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-24 11:59:36.000000000 -0700
@@ -925,7 +925,7 @@ page_ok:
 		 * before reading the page on the kernel side.
 		 */
 		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
+			flush_mapping_page(page);
 
 		/*
 		 * When (part of) the same page is read multiple times
@@ -2139,7 +2139,7 @@ generic_file_buffered_write(struct kiocb
 		else
 			copied = filemap_copy_from_user_iovec(page, offset,
 						cur_iov, iov_base, bytes);
-		flush_dcache_page(page);
+		flush_mapping_page(page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (status == AOP_TRUNCATED_PAGE) {
 			page_cache_release(page);

--
