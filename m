Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbXFTScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbXFTScT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbXFTSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46726 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754675AbXFTSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:09 -0400
Message-Id: <20070620183006.425435064@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:10 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [03/37] Use page_cache_xxx function in mm/filemap.c
Content-Disposition: inline; filename=vps_mm_filemap
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/filemap.c |   76 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

Index: vps/mm/filemap.c
===================================================================
--- vps.orig/mm/filemap.c	2007-06-08 10:57:37.000000000 -0700
+++ vps/mm/filemap.c	2007-06-09 21:15:04.000000000 -0700
@@ -304,8 +304,8 @@ EXPORT_SYMBOL(add_to_page_cache_lru);
 int sync_page_range(struct inode *inode, struct address_space *mapping,
 			loff_t pos, loff_t count)
 {
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t start = page_cache_index(mapping, pos);
+	pgoff_t end = page_cache_index(mapping, pos + count - 1);
 	int ret;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
@@ -336,8 +336,8 @@ EXPORT_SYMBOL(sync_page_range);
 int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
 			   loff_t pos, loff_t count)
 {
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t start = page_cache_index(mapping, pos);
+	pgoff_t end = page_cache_index(mapping, pos + count - 1);
 	int ret;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
@@ -366,7 +366,7 @@ int filemap_fdatawait(struct address_spa
 		return 0;
 
 	return wait_on_page_writeback_range(mapping, 0,
-				(i_size - 1) >> PAGE_CACHE_SHIFT);
+				page_cache_index(mapping, i_size - 1));
 }
 EXPORT_SYMBOL(filemap_fdatawait);
 
@@ -414,8 +414,8 @@ int filemap_write_and_wait_range(struct 
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO) {
 			int err2 = wait_on_page_writeback_range(mapping,
-						lstart >> PAGE_CACHE_SHIFT,
-						lend >> PAGE_CACHE_SHIFT);
+					page_cache_index(mapping, lstart),
+					page_cache_index(mapping, lend));
 			if (!err)
 				err = err2;
 		}
@@ -881,28 +881,28 @@ void do_generic_mapping_read(struct addr
 	int error;
 	struct file_ra_state ra = *_ra;
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
 	next_index = index;
 	prev_index = ra.prev_index;
 	prev_offset = ra.prev_offset;
-	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	offset = *ppos & ~PAGE_CACHE_MASK;
+	last_index = page_cache_next(mapping, *ppos + desc->count);
+	offset = page_cache_offset(mapping, *ppos);
 
 	isize = i_size_read(inode);
 	if (!isize)
 		goto out;
 
-	end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+	end_index = page_cache_index(mapping, isize - 1);
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
+			nr = page_cache_offset(mapping, isize - 1) + 1;
 			if (nr <= offset) {
 				goto out;
 			}
@@ -956,8 +956,8 @@ page_ok:
 		 */
 		ret = actor(desc, page, offset, nr);
 		offset += ret;
-		index += offset >> PAGE_CACHE_SHIFT;
-		offset &= ~PAGE_CACHE_MASK;
+		index += page_cache_index(mapping, offset);
+		offset = page_cache_offset(mapping, offset);
 		prev_offset = offset;
 		ra.prev_offset = offset;
 
@@ -1023,16 +1023,16 @@ readpage:
 		 * another truncate extends the file - this is desired though).
 		 */
 		isize = i_size_read(inode);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		end_index = page_cache_index(mapping, isize - 1);
 		if (unlikely(!isize || index > end_index)) {
 			page_cache_release(page);
 			goto out;
 		}
 
 		/* nr is the maximum number of bytes to copy from this page */
-		nr = PAGE_CACHE_SIZE;
+		nr = page_cache_size(mapping);
 		if (index == end_index) {
-			nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			nr = page_cache_offset(mapping, isize - 1) + 1;
 			if (nr <= offset) {
 				page_cache_release(page);
 				goto out;
@@ -1073,7 +1073,7 @@ out:
 	*_ra = ra;
 	_ra->prev_index = prev_index;
 
-	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
+	*ppos = page_cache_pos(mapping, index, offset);
 	if (filp)
 		file_accessed(filp);
 }
@@ -1291,8 +1291,8 @@ asmlinkage ssize_t sys_readahead(int fd,
 	if (file) {
 		if (file->f_mode & FMODE_READ) {
 			struct address_space *mapping = file->f_mapping;
-			unsigned long start = offset >> PAGE_CACHE_SHIFT;
-			unsigned long end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			unsigned long start = page_cache_index(mapping, offset);
+			unsigned long end = page_cache_index(mapping, offset + count - 1);
 			unsigned long len = end - start + 1;
 			ret = do_readahead(mapping, file, start, len);
 		}
@@ -1364,7 +1364,7 @@ struct page *filemap_fault(struct vm_are
 
 	BUG_ON(!(vma->vm_flags & VM_CAN_INVALIDATE));
 
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = page_cache_next(mapping, i_size_read(inode));
 	if (fdata->pgoff >= size)
 		goto outside_data_content;
 
@@ -1439,7 +1439,7 @@ retry_find:
 		goto page_not_uptodate;
 
 	/* Must recheck i_size under page lock */
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = page_cache_next(mapping, i_size_read(inode));
 	if (unlikely(fdata->pgoff >= size)) {
 		unlock_page(page);
 		goto outside_data_content;
@@ -1930,8 +1930,8 @@ int pagecache_write_begin(struct file *f
 							pagep, fsdata);
 	} else {
 		int ret;
-		pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+		pgoff_t index = page_cache_index(mapping, pos);
+		unsigned offset = page_cache_offset(mapping, pos);
 		struct inode *inode = mapping->host;
 		struct page *page;
 again:
@@ -1984,7 +1984,7 @@ int pagecache_write_end(struct file *fil
 		ret = aops->write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	} else {
-		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+		unsigned offset = page_cache_offset(mapping, pos);
 		struct inode *inode = mapping->host;
 
 		flush_dcache_page(page);
@@ -2089,9 +2089,9 @@ static ssize_t generic_perform_write_2co
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 
-		offset = (pos & (PAGE_CACHE_SIZE - 1));
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
+		offset = page_cache_offset(mapping, pos );
+		index = page_cache_index(mapping, pos);
+		bytes = min_t(unsigned long, page_cache_size(mapping) - offset,
 						iov_iter_count(i));
 
 		/*
@@ -2267,9 +2267,9 @@ static ssize_t generic_perform_write(str
 		size_t copied;		/* Bytes copied from user */
 		void *fsdata;
 
-		offset = (pos & (PAGE_CACHE_SIZE - 1));
-		index = pos >> PAGE_CACHE_SHIFT;
-		bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
+		offset = page_cache_offset(mapping, pos);
+		index = page_cache_index(mapping, pos);
+		bytes = min_t(unsigned long, page_cache_size(mapping)  - offset,
 						iov_iter_count(i));
 
 again:
@@ -2316,7 +2316,7 @@ again:
 			 * because not all segments in the iov can be copied at
 			 * once without a pagefault.
 			 */
-			bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
+			bytes = min_t(unsigned long, page_cache_size(mapping) - offset,
 						iov_iter_single_seg_count(i));
 			goto again;
 		}
@@ -2459,8 +2459,8 @@ __generic_file_aio_write_nolock(struct k
 		if (err == 0) {
 			written = written_buffered;
 			invalidate_mapping_pages(mapping,
-						 pos >> PAGE_CACHE_SHIFT,
-						 endbyte >> PAGE_CACHE_SHIFT);
+						 page_cache_index(mapping, pos),
+						 page_cache_index(mapping, endbyte));
 		} else {
 			/*
 			 * We don't know how much we wrote, so just return
@@ -2547,7 +2547,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE) {
 		write_len = iov_length(iov, nr_segs);
-		end = (offset + write_len - 1) >> PAGE_CACHE_SHIFT;
+		end = page_cache_index(mapping, offset + write_len - 1);
 	       	if (mapping_mapped(mapping))
 			unmap_mapping_range(mapping, offset, write_len, 0);
 	}
@@ -2564,7 +2564,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE && mapping->nrpages) {
 		retval = invalidate_inode_pages2_range(mapping,
-					offset >> PAGE_CACHE_SHIFT, end);
+					page_cache_index(mapping, offset), end);
 		if (retval)
 			goto out;
 	}
@@ -2582,7 +2582,7 @@ generic_file_direct_IO(int rw, struct ki
 	 */
 	if (rw == WRITE && mapping->nrpages) {
 		int err = invalidate_inode_pages2_range(mapping,
-					      offset >> PAGE_CACHE_SHIFT, end);
+					      page_cache_index(mapping, offset), end);
 		if (err && retval >= 0)
 			retval = err;
 	}

-- 
