Return-Path: <linux-kernel-owner+w=401wt.eu-S1422890AbXBHNHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422890AbXBHNHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422948AbXBHNHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:07:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:35364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422890AbXBHNHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:07:30 -0500
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <akpm@linux-foundation.org>
Message-Id: <20070208105446.26443.35864.sendpatchset@linux.site>
In-Reply-To: <20070208105437.26443.35653.sendpatchset@linux.site>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
Subject: [patch 1/3] fs: add an iovec iterator
Date: Thu,  8 Feb 2007 14:07:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an iterator data structure to operate over an iovec. Add usercopy
operators needed by generic_file_buffered_write, and convert that function
over.

 include/linux/fs.h |   32 ++++++++++++
 mm/filemap.c       |  132 ++++++++++++++++++++++++++++++++++++++++++-----------
 mm/filemap.h       |  103 -----------------------------------------
 3 files changed, 137 insertions(+), 130 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -395,6 +395,38 @@ struct page;
 struct address_space;
 struct writeback_control;
 
+struct iovec_iterator {
+	const struct iovec *iov;
+	unsigned long nr_segs;
+	size_t iov_offset;
+	size_t count;
+};
+
+size_t iovec_iterator_copy_from_user_atomic(struct page *page,
+		struct iovec_iterator *i, unsigned long offset, size_t bytes);
+size_t iovec_iterator_copy_from_user(struct page *page,
+		struct iovec_iterator *i, unsigned long offset, size_t bytes);
+void iovec_iterator_advance(struct iovec_iterator *i, size_t bytes);
+int iovec_iterator_fault_in_readable(struct iovec_iterator *i);
+
+static inline void iovec_iterator_init(struct iovec_iterator *i,
+			const struct iovec *iov, unsigned long nr_segs,
+			size_t count, size_t written)
+{
+	i->iov = iov;
+	i->nr_segs = nr_segs;
+	i->iov_offset = 0;
+	i->count = count + written;
+
+	iovec_iterator_advance(i, written);
+}
+
+static inline size_t iovec_iterator_count(struct iovec_iterator *i)
+{
+	return i->count;
+}
+
+
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -30,7 +30,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/cpuset.h>
-#include "filemap.h"
+#include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include "internal.h"
 
 /*
@@ -1679,8 +1679,7 @@ int remove_suid(struct dentry *dentry)
 }
 EXPORT_SYMBOL(remove_suid);
 
-size_t
-__filemap_copy_from_user_iovec_inatomic(char *vaddr,
+static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
 {
 	size_t copied = 0, left = 0;
@@ -1703,6 +1702,98 @@ __filemap_copy_from_user_iovec_inatomic(
 }
 
 /*
+ * Copy as much as we can into the page and return the number of bytes which
+ * were sucessfully copied.  If a fault is encountered then return the number of
+ * bytes which were copied.
+ */
+size_t iovec_iterator_copy_from_user_atomic(struct page *page,
+		struct iovec_iterator *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	BUG_ON(!in_atomic());
+	kaddr = kmap_atomic(page, KM_USER0);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_from_user_inatomic_nocache(kaddr + offset,
+							buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap_atomic(kaddr, KM_USER0);
+
+	return copied;
+}
+
+/*
+ * This has the same sideeffects and return value as
+ * iovec_iterator_copy_from_user_atomic().
+ * The difference is that it attempts to resolve faults.
+ * Page must not be locked.
+ */
+size_t iovec_iterator_copy_from_user(struct page *page,
+		struct iovec_iterator *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	kaddr = kmap(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap(page);
+	return copied;
+}
+
+static void __iovec_iterator_advance_iov(struct iovec_iterator *i, size_t bytes)
+{
+	if (likely(i->nr_segs == 1)) {
+		i->iov_offset += bytes;
+	} else {
+		const struct iovec *iov = i->iov;
+		size_t base = i->iov_offset;
+
+		while (bytes) {
+			int copy = min(bytes, iov->iov_len - base);
+
+			bytes -= copy;
+			base += copy;
+			if (iov->iov_len == base) {
+				iov++;
+				base = 0;
+			}
+		}
+		i->iov = iov;
+		i->iov_offset = base;
+	}
+}
+
+void iovec_iterator_advance(struct iovec_iterator *i, size_t bytes)
+{
+	BUG_ON(i->count < bytes);
+
+	__iovec_iterator_advance_iov(i, bytes);
+	i->count -= bytes;
+}
+
+int iovec_iterator_fault_in_readable(struct iovec_iterator *i)
+{
+	size_t seglen = min(i->iov->iov_len - i->iov_offset, i->count);
+	char __user *buf = i->iov->iov_base + i->iov_offset;
+	return fault_in_pages_readable(buf, seglen);
+}
+
+/*
  * Performs necessary checks before doing a write
  *
  * Can adjust writing position or amount of bytes to write.
@@ -1862,30 +1953,22 @@ generic_file_buffered_write(struct kiocb
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	struct inode 	*inode = mapping->host;
 	long		status = 0;
-	const struct iovec *cur_iov = iov; /* current iovec */
-	size_t		iov_offset = 0;	   /* offset in the current iovec */
-	char __user	*buf;
+	struct iovec_iterator i;
 
-	/*
-	 * handle partial DIO write.  Adjust cur_iov if needed.
-	 */
-	filemap_set_next_iovec(&cur_iov, nr_segs, &iov_offset, written);
+	iovec_iterator_init(&i, iov, nr_segs, count, written);
 
 	do {
 		struct page *src_page;
 		struct page *page;
 		pgoff_t index;		/* Pagecache index for current page */
 		unsigned long offset;	/* Offset into pagecache page */
-		unsigned long seglen;	/* Bytes remaining in current iovec */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 
-		buf = cur_iov->iov_base + iov_offset;
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
-		if (bytes > count)
-			bytes = count;
+		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
+						iovec_iterator_count(&i));
 
 		/*
 		 * a non-NULL src_page indicates that we're doing the
@@ -1893,10 +1976,6 @@ generic_file_buffered_write(struct kiocb
 		 */
 		src_page = NULL;
 
-		seglen = cur_iov->iov_len - iov_offset;
-		if (seglen > bytes)
-			seglen = bytes;
-
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
@@ -1907,7 +1986,7 @@ generic_file_buffered_write(struct kiocb
 		 * to check that the address is actually valid, when atomic
 		 * usercopies are used, below.
 		 */
-		if (unlikely(fault_in_pages_readable(buf, seglen))) {
+		if (unlikely(iovec_iterator_fault_in_readable(&i))) {
 			status = -EFAULT;
 			break;
 		}
@@ -1938,8 +2017,8 @@ generic_file_buffered_write(struct kiocb
 			 * same reason as we can't take a page fault with a
 			 * page locked (as explained below).
 			 */
-			copied = filemap_copy_from_user(src_page, offset,
-					cur_iov, nr_segs, iov_offset, bytes);
+			copied = iovec_iterator_copy_from_user(src_page, &i,
+								offset, bytes);
 			if (unlikely(copied == 0)) {
 				status = -EFAULT;
 				page_cache_release(page);
@@ -1977,8 +2056,8 @@ generic_file_buffered_write(struct kiocb
 			 * really matter.
 			 */
 			pagefault_disable();
-			copied = filemap_copy_from_user_atomic(page, offset,
-					cur_iov, nr_segs, iov_offset, bytes);
+			copied = iovec_iterator_copy_from_user_atomic(page, &i,
+								offset, bytes);
 			pagefault_enable();
 		} else {
 			void *src, *dst;
@@ -2003,10 +2082,9 @@ generic_file_buffered_write(struct kiocb
 		if (src_page)
 			page_cache_release(src_page);
 
+		iovec_iterator_advance(&i, copied);
 		written += copied;
-		count -= copied;
 		pos += copied;
-		filemap_set_next_iovec(&cur_iov, nr_segs, &iov_offset, copied);
 
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
@@ -2030,7 +2108,7 @@ fs_write_aop_error:
 			continue;
 		else
 			break;
-	} while (count);
+	} while (iovec_iterator_count(&i));
 	*ppos = pos;
 
 	/*
Index: linux-2.6/mm/filemap.h
===================================================================
--- linux-2.6.orig/mm/filemap.h
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- *	linux/mm/filemap.h
- *
- * Copyright (C) 1994-1999  Linus Torvalds
- */
-
-#ifndef __FILEMAP_H
-#define __FILEMAP_H
-
-#include <linux/types.h>
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/uio.h>
-#include <linux/uaccess.h>
-
-size_t
-__filemap_copy_from_user_iovec_inatomic(char *vaddr,
-					const struct iovec *iov,
-					size_t base,
-					size_t bytes);
-
-/*
- * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then return the number of
- * bytes which were copied.
- */
-static inline size_t
-filemap_copy_from_user_atomic(struct page *page, unsigned long offset,
-			const struct iovec *iov, unsigned long nr_segs,
-			size_t base, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	kaddr = kmap_atomic(page, KM_USER0);
-	if (likely(nr_segs == 1)) {
-		int left;
-		char __user *buf = iov->iov_base + base;
-		left = __copy_from_user_inatomic_nocache(kaddr + offset,
-							buf, bytes);
-		copied = bytes - left;
-	} else {
-		copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset,
-							iov, base, bytes);
-	}
-	kunmap_atomic(kaddr, KM_USER0);
-
-	return copied;
-}
-
-/*
- * This has the same sideeffects and return value as
- * filemap_copy_from_user_atomic().
- * The difference is that it attempts to resolve faults.
- */
-static inline size_t
-filemap_copy_from_user(struct page *page, unsigned long offset,
-			const struct iovec *iov, unsigned long nr_segs,
-			 size_t base, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	kaddr = kmap(page);
-	if (likely(nr_segs == 1)) {
-		int left;
-		char __user *buf = iov->iov_base + base;
-		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
-		copied = bytes - left;
-	} else {
-		copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset,
-							iov, base, bytes);
-	}
-	kunmap(page);
-	return copied;
-}
-
-static inline void
-filemap_set_next_iovec(const struct iovec **iovp, unsigned long nr_segs,
-						 size_t *basep, size_t bytes)
-{
-	if (likely(nr_segs == 1)) {
-		*basep += bytes;
-	} else {
-		const struct iovec *iov = *iovp;
-		size_t base = *basep;
-
-		while (bytes) {
-			int copy = min(bytes, iov->iov_len - base);
-
-			bytes -= copy;
-			base += copy;
-			if (iov->iov_len == base) {
-				iov++;
-				base = 0;
-			}
-		}
-		*iovp = iov;
-		*basep = base;
-	}
-}
-#endif
