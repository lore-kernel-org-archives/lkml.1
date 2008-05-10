Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYEJSku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYEJSku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 14:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYEJSkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 14:40:42 -0400
Received: from verein.lst.de ([213.95.11.210]:57829 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYEJSkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 14:40:41 -0400
Date: Sat, 10 May 2008 20:39:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kill generic_file_direct_IO
Message-ID: <20080510183956.GA14315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_direct_IO is a common helper around the invocation of
->direct_IO.  But there's almost nothing to shared between the read
and write side, so we're better off without this helper.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-04-29 08:35:05.000000000 +0200
+++ linux-2.6/mm/filemap.c	2008-05-05 09:29:57.000000000 +0200
@@ -42,9 +42,6 @@
 
 #include <asm/mman.h>
 
-static ssize_t
-generic_file_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs);
 
 /*
  * Shared mappings implemented 30.11.1994. It's not fully working yet,
@@ -1204,8 +1201,11 @@ generic_file_aio_read(struct kiocb *iocb
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
-			retval = generic_file_direct_IO(READ, iocb,
-						iov, pos, nr_segs);
+			retval = filemap_write_and_wait(mapping);
+			if (!retval) {
+				retval = mapping->a_ops->direct_IO(READ, iocb,
+							iov, pos, nr_segs);
+			}
 			if (retval > 0)
 				*ppos = pos + retval;
 		}
@@ -1998,11 +1998,55 @@ generic_file_direct_write(struct kiocb *
 	struct address_space *mapping = file->f_mapping;
 	struct inode	*inode = mapping->host;
 	ssize_t		written;
+	size_t		write_len;
+	pgoff_t		end;
 
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
 
-	written = generic_file_direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	/*
+	 * Unmap all mmappings of the file up-front.
+	 *
+	 * This will cause any pte dirty bits to be propagated into the
+	 * pageframes for the subsequent filemap_write_and_wait().
+	 */
+	write_len = iov_length(iov, *nr_segs);
+	end = (pos + write_len - 1) >> PAGE_CACHE_SHIFT;
+       	if (mapping_mapped(mapping))
+		unmap_mapping_range(mapping, pos, write_len, 0);
+
+	written = filemap_write_and_wait(mapping);
+	if (written)
+		goto out;
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	if (mapping->nrpages) {
+		written = invalidate_inode_pages2_range(mapping,
+					pos >> PAGE_CACHE_SHIFT, end);
+		if (written)
+			goto out;
+	}
+
+	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+
+	/*
+	 * Finally, try again to invalidate clean pages which might have been
+	 * cached by non-direct readahead, or faulted in by get_user_pages()
+	 * if the source of the write was an mmap'ed region of the file
+	 * we're writing.  Either one is a pretty crazy thing to do,
+	 * so we don't support it 100%.  If this invalidation
+	 * fails, tough, the write still worked...
+	 */
+	if (mapping->nrpages) {
+		invalidate_inode_pages2_range(mapping,
+					      pos >> PAGE_CACHE_SHIFT, end);
+	}
+
 	if (written > 0) {
 		loff_t end = pos + written;
 		if (end > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
@@ -2018,6 +2062,7 @@ generic_file_direct_write(struct kiocb *
 	 * i_mutex is held, which protects generic_osync_inode() from
 	 * livelocking.  AIO O_DIRECT ops attempt to sync metadata here.
 	 */
+out:
 	if ((written >= 0 || written == -EIOCBQUEUED) &&
 	    ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		int err = generic_osync_inode(inode, mapping, OSYNC_METADATA);
@@ -2505,66 +2550,6 @@ ssize_t generic_file_aio_write(struct ki
 }
 EXPORT_SYMBOL(generic_file_aio_write);
 
-/*
- * Called under i_mutex for writes to S_ISREG files.   Returns -EIO if something
- * went wrong during pagecache shootdown.
- */
-static ssize_t
-generic_file_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs)
-{
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	ssize_t retval;
-	size_t write_len;
-	pgoff_t end = 0; /* silence gcc */
-
-	/*
-	 * If it's a write, unmap all mmappings of the file up-front.  This
-	 * will cause any pte dirty bits to be propagated into the pageframes
-	 * for the subsequent filemap_write_and_wait().
-	 */
-	if (rw == WRITE) {
-		write_len = iov_length(iov, nr_segs);
-		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
-	       	if (mapping_mapped(mapping))
-			unmap_mapping_range(mapping, offset, write_len, 0);
-	}
-
-	retval = filemap_write_and_wait(mapping);
-	if (retval)
-		goto out;
-
-	/*
-	 * After a write we want buffered reads to be sure to go to disk to get
-	 * the new data.  We invalidate clean cached page from the region we're
-	 * about to write.  We do this *before* the write so that we can return
-	 * -EIO without clobbering -EIOCBQUEUED from ->direct_IO().
-	 */
-	if (rw == WRITE && mapping->nrpages) {
-		retval = invalidate_inode_pages2_range(mapping,
-					offset >> PAGE_CACHE_SHIFT, end);
-		if (retval)
-			goto out;
-	}
-
-	retval = mapping->a_ops->direct_IO(rw, iocb, iov, offset, nr_segs);
-
-	/*
-	 * Finally, try again to invalidate clean pages which might have been
-	 * cached by non-direct readahead, or faulted in by get_user_pages()
-	 * if the source of the write was an mmap'ed region of the file
-	 * we're writing.  Either one is a pretty crazy thing to do,
-	 * so we don't support it 100%.  If this invalidation
-	 * fails, tough, the write still worked...
-	 */
-	if (rw == WRITE && mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping, offset >> PAGE_CACHE_SHIFT, end);
-	}
-out:
-	return retval;
-}
-
 /**
  * try_to_release_page() - release old fs-specific metadata on a page
  *
