Return-Path: <linux-kernel-owner+w=401wt.eu-S1422948AbXBHNHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422948AbXBHNHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422979AbXBHNHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:07:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:36325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422948AbXBHNHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:07:40 -0500
From: Nick Piggin <npiggin@suse.de>
To: Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <akpm@linux-foundation.org>
Message-Id: <20070208105458.26443.41479.sendpatchset@linux.site>
In-Reply-To: <20070208105437.26443.35653.sendpatchset@linux.site>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
Subject: [patch 2/3] fs: introduce perform_write aop
Date: Thu,  8 Feb 2007 14:07:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new "perform_write" aop, which replaces prepare_write and commit_write
as a single call to copy a given amount of userdata at the given offset. This
is more flexible, because the implementation can determine how to best handle
errors, or multi-page ranges (eg. it may use a gang lookup), and only requires
one call into the fs.

One problem with this interface is that it cannot be used to write into the
filesystem by any means other than already-initialised buffers via iovecs. So
prepare/commit have to stay around for non-user data... 

Another thing is that it seems to be less able to be implemented in generic,
reusable code. It should be possible to introduce a new 2-op interface (or
maybe just a new error handler op) which can be used correctly in generic code.

I avoided that way in my first attempt because this seemed more elegant from
a logical POV. But after seeing the implementation, I'm having second
thoughts.

 include/linux/fs.h |    6 ++++
 mm/filemap.c       |   64 +++++++++++++++++++++++++++++++++--------------------
 2 files changed, 47 insertions(+), 23 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -447,6 +447,12 @@ struct address_space_operations {
 	 */
 	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
 	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
+
+	/*
+	 * perform_write replaces prepare and commit_write callbacks.
+	 */
+	int (*perform_write)(struct file *, struct iovec_iterator *, loff_t);
+
 	/* Unfortunately this kludge is needed for FIBMAP. Don't use it */
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1920,8 +1920,7 @@ EXPORT_SYMBOL(generic_file_direct_write)
  * Find or create a page at the given pagecache position. Return the locked
  * page. This function is specifically for buffered writes.
  */
-static struct page *__grab_cache_page(struct address_space *mapping,
-							pgoff_t index)
+struct page *__grab_cache_page(struct address_space *mapping, pgoff_t index)
 {
 	int status;
 	struct page *page;
@@ -1943,19 +1942,14 @@ repeat:
 	return page;
 }
 
-ssize_t
-generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos, loff_t *ppos,
-		size_t count, ssize_t written)
+static ssize_t generic_perform_write(struct file *file,
+				struct iovec_iterator *i, loff_t pos)
 {
-	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	const struct address_space_operations *a_ops = mapping->a_ops;
-	struct inode 	*inode = mapping->host;
-	long		status = 0;
-	struct iovec_iterator i;
-
-	iovec_iterator_init(&i, iov, nr_segs, count, written);
+	struct inode *inode = mapping->host;
+	long status = 0;
+	ssize_t written = 0;
 
 	do {
 		struct page *src_page;
@@ -1968,7 +1962,7 @@ generic_file_buffered_write(struct kiocb
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
-						iovec_iterator_count(&i));
+						iovec_iterator_count(i));
 
 		/*
 		 * a non-NULL src_page indicates that we're doing the
@@ -1986,7 +1980,7 @@ generic_file_buffered_write(struct kiocb
 		 * to check that the address is actually valid, when atomic
 		 * usercopies are used, below.
 		 */
-		if (unlikely(iovec_iterator_fault_in_readable(&i))) {
+		if (unlikely(iovec_iterator_fault_in_readable(i))) {
 			status = -EFAULT;
 			break;
 		}
@@ -2017,7 +2011,7 @@ generic_file_buffered_write(struct kiocb
 			 * same reason as we can't take a page fault with a
 			 * page locked (as explained below).
 			 */
-			copied = iovec_iterator_copy_from_user(src_page, &i,
+			copied = iovec_iterator_copy_from_user(src_page, i,
 								offset, bytes);
 			if (unlikely(copied == 0)) {
 				status = -EFAULT;
@@ -2056,7 +2050,7 @@ generic_file_buffered_write(struct kiocb
 			 * really matter.
 			 */
 			pagefault_disable();
-			copied = iovec_iterator_copy_from_user_atomic(page, &i,
+			copied = iovec_iterator_copy_from_user_atomic(page, i,
 								offset, bytes);
 			pagefault_enable();
 		} else {
@@ -2082,9 +2076,9 @@ generic_file_buffered_write(struct kiocb
 		if (src_page)
 			page_cache_release(src_page);
 
-		iovec_iterator_advance(&i, copied);
-		written += copied;
+		iovec_iterator_advance(i, copied);
 		pos += copied;
+		written += copied;
 
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
@@ -2108,13 +2102,37 @@ fs_write_aop_error:
 			continue;
 		else
 			break;
-	} while (iovec_iterator_count(&i));
-	*ppos = pos;
+	} while (iovec_iterator_count(i));
+
+	return written ? written : status;
+}
+
+ssize_t
+generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos, loff_t *ppos,
+		size_t count, ssize_t written)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	struct inode 	*inode = mapping->host;
+	long		status = 0;
+	struct iovec_iterator i;
+
+	iovec_iterator_init(&i, iov, nr_segs, count, written);
+	if (!a_ops->perform_write)
+		status = generic_perform_write(file, &i, pos);
+	else
+		status = a_ops->perform_write(file, &i, pos);
 
-	/*
-	 * For now, when the user asks for O_SYNC, we'll actually give O_DSYNC
-	 */
 	if (likely(status >= 0)) {
+		written += status;
+		*ppos = pos + status;
+
+		/*
+		 * For now, when the user asks for O_SYNC, we'll actually give
+		 * O_DSYNC
+		 */
 		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 			if (!a_ops->writepage || !is_sync_kiocb(iocb))
 				status = generic_osync_inode(inode, mapping,
