Return-Path: <linux-kernel-owner+w=401wt.eu-S1766860AbXDSQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766860AbXDSQgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766862AbXDSQfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:35:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51414 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766860AbXDSQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:35:31 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Message-Id: <20070419163530.11948.50731.sendpatchset@schroedinger.engr.sgi.com>
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Subject: [RFC 5/8] Enhance generic_read/write to support higher order pages
Date: Thu, 19 Apr 2007 09:35:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: Fix up mm/filemap.c

Fix up the function in mm/filemap.c to use the variable page cache.
This is pretty straightforward:

1. Convert the constants to function calls.
2. Use the mapping flush function

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/filemap.c |   63 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-18 21:28:30.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-18 22:07:10.000000000 -0700
@@ -302,8 +302,8 @@ int wait_on_page_writeback_range(struct 
 int sync_page_range(struct inode *inode, struct address_space *mapping,
 			loff_t pos, loff_t count)
 {
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t start = pos >> page_cache_shift(mapping);
+	pgoff_t end = (pos + count - 1) >> page_cache_shift(mapping);
 	int ret;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
@@ -334,8 +334,8 @@ EXPORT_SYMBOL(sync_page_range);
 int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
 			   loff_t pos, loff_t count)
 {
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t start = pos >> page_cache_shift(mapping);
+	pgoff_t end = (pos + count - 1) >> page_cache_shift(mapping);
 	int ret;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
@@ -364,7 +364,7 @@ int filemap_fdatawait(struct address_spa
 		return 0;
 
 	return wait_on_page_writeback_range(mapping, 0,
-				(i_size - 1) >> PAGE_CACHE_SHIFT);
+				(i_size - 1) >> page_cache_shift(mapping));
 }
 EXPORT_SYMBOL(filemap_fdatawait);
 
@@ -412,8 +412,8 @@ int filemap_write_and_wait_range(struct 
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO) {
 			int err2 = wait_on_page_writeback_range(mapping,
-						lstart >> PAGE_CACHE_SHIFT,
-						lend >> PAGE_CACHE_SHIFT);
+						lstart >> page_cache_shift(mapping),
+						lend >> page_cache_shift(mapping));
 			if (!err)
 				err = err2;
 		}
@@ -875,27 +875,28 @@ void do_generic_mapping_read(struct addr
 	struct file_ra_state ra = *_ra;
 
 	cached_page = NULL;
-	index = *ppos >> PAGE_CACHE_SHIFT;
+	index = *ppos >> page_cache_shift(mapping);
 	next_index = index;
 	prev_index = ra.prev_page;
-	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	offset = *ppos & ~PAGE_CACHE_MASK;
+	last_index = (*ppos + desc->count + page_cache_size(mapping)-1)
+				>> page_cache_shift(mapping);
+	offset = *ppos & ~page_cache_mask(mapping);
 
 	isize = i_size_read(inode);
 	if (!isize)
 		goto out;
 
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+	end_index = (isize - 1) >> page_cache_shift(mapping);
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = page_cache_size(mapping);
 		if (index >= end_index) {
 			if (index > end_index)
 				goto out;
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			nr = ((isize - 1) & ~page_cache_mask(mapping)) + 1;
 			if (nr <= offset) {
 				goto out;
 			}
@@ -922,7 +923,7 @@ page_ok:
 		 * before reading the page on the kernel side.
 		 */
 		if (mapping_writably_mapped(mapping))
-			flush_dcache_page(page);
+			flush_mapping_page(mapping, page);
 
 		/*
 		 * When (part of) the same page is read multiple times
@@ -944,8 +945,8 @@ page_ok:
 		 */
 		ret = actor(desc, page, offset, nr);
 		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
+		index += offset >> page_cache_shift(mapping);
+		offset &= ~page_cache_mask(mapping);
 
 		page_cache_release(page);
 		if (ret == nr && desc->count)
@@ -1009,16 +1010,16 @@ readpage:
 		 * another truncate extends the file - this is desired though).
 		 */
 		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		end_index = (isize - 1) >> page_cache_shift(mapping);
 		if (unlikely(!isize || index > end_index)) {
 			page_cache_release(page);
 			goto out;
 		}
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = page_cache_size(mapping);
 		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			nr = ((isize - 1) & ~page_cache_mask(mapping)) + 1;
 			if (nr <= offset) {
 				page_cache_release(page);
 				goto out;
@@ -1061,7 +1062,7 @@ no_cached_page:
 out:
 	*_ra = ra;
 
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	*ppos = ((loff_t) index << page_cache_shift(mapping)) + offset;
 	if (cached_page)
 		page_cache_release(cached_page);
 	if (filp)
@@ -1257,8 +1258,8 @@ asmlinkage ssize_t sys_readahead(int fd,
 	if (file) {
 		if (file->f_mode & FMODE_READ) {
 			struct address_space *mapping = file->f_mapping;
-			unsigned long start = offset >> PAGE_CACHE_SHIFT;
-			unsigned long end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			unsigned long start = offset >> page_cache_shift(mapping);
+			unsigned long end = (offset + count - 1) >> page_cache_shift(mapping);
 			unsigned long len = end - start + 1;
 			ret = do_readahead(mapping, file, start, len);
 		}
@@ -2073,9 +2074,9 @@ generic_file_buffered_write(struct kiocb
 		unsigned long offset;
 		size_t copied;
 
-		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = PAGE_CACHE_SIZE - offset;
+		offset = (pos & (page_cache_size(mapping) -1)); /* Within page */
+		index = pos >> page_cache_shift(mapping);
+		bytes = page_cache_size(mapping) - offset;
 
 		/* Limit the size of the copy to the caller's write size */
 		bytes = min(bytes, count);
@@ -2136,7 +2137,7 @@ generic_file_buffered_write(struct kiocb
 		else
 			copied = filemap_copy_from_user_iovec(page, offset,
 						cur_iov, iov_base, bytes);
-		flush_dcache_page(page);
+		flush_mapping_page(mapping, page);
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (status == AOP_TRUNCATED_PAGE) {
 			page_cache_release(page);
@@ -2302,8 +2303,8 @@ __generic_file_aio_write_nolock(struct k
 		if (err == 0) {
 			written = written_buffered;
 			invalidate_mapping_pages(mapping,
-						 pos >> PAGE_CACHE_SHIFT,
-						 endbyte >> PAGE_CACHE_SHIFT);
+						 pos >> page_cache_shift(mapping),
+						 endbyte >> page_cache_shift(mapping));
 		} else {
 			/*
 			 * We don't know how much we wrote, so just return
@@ -2390,7 +2391,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE) {
 		write_len = iov_length(iov, nr_segs);
-		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
+		end = (offset + write_len - 1) >> page_cache_shift(mapping);
 	       	if (mapping_mapped(mapping))
 			unmap_mapping_range(mapping, offset, write_len, 0);
 	}
@@ -2407,7 +2408,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE && mapping->nrpages) {
 		retval = invalidate_inode_pages2_range(mapping,
-					offset >> PAGE_CACHE_SHIFT, end);
+					offset >> page_cache_shift(mapping), end);
 		if (retval)
 			goto out;
 	}
@@ -2425,7 +2426,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE && mapping->nrpages) {
 		int err = invalidate_inode_pages2_range(mapping,
-					      offset >> PAGE_CACHE_SHIFT, end);
+					      offset >> page_cache_shift(mapping), end);
 		if (err && retval >= 0)
 			retval = err;
 	}
