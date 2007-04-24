Return-Path: <linux-kernel-owner+w=401wt.eu-S1423190AbXDXW0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423190AbXDXW0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423170AbXDXWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56776 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423167AbXDXWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:06 -0400
Message-Id: <20070424222304.659670936@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:06 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [01/17] Remove open coded implementation of memclear_highpage flush
Content-Disposition: inline; filename=consolidate_partial_clear
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a series of open coded reimplementation of memclear_highpage_flush
all over the page cache code. Call memclear_highpage_flush in those locations.
Consolidates code and eases maintenance.

[There seems to be a better patch in mm. This patch here is just to make things
work against 2.6.21 until the rest of the patch is diffed against mm]

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c      |   77 ++++++++++++-------------------------------------------
 fs/direct-io.c   |    8 +----
 fs/libfs.c       |   10 +++----
 fs/mpage.c       |   12 ++------
 mm/filemap_xip.c |    6 ----
 5 files changed, 29 insertions(+), 84 deletions(-)

Index: linux-2.6.21-rc7/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-23 14:19:04.000000000 -0700
+++ linux-2.6.21-rc7/fs/buffer.c	2007-04-23 14:44:09.000000000 -0700
@@ -1803,17 +1803,12 @@ static int __block_prepare_write(struct 
 					continue;
 				}
 				if (block_end > to || block_start < from) {
-					void *kaddr;
-
-					kaddr = kmap_atomic(page, KM_USER0);
 					if (block_end > to)
-						memset(kaddr+to, 0,
-							block_end-to);
+						memclear_highpage_flush(page,
+							to, block_end - to);
 					if (block_start < from)
-						memset(kaddr+block_start,
-							0, from-block_start);
-					flush_dcache_page(page);
-					kunmap_atomic(kaddr, KM_USER0);
+						memclear_highpage_flush(page,
+						block_start, from - block_start);
 				}
 				continue;
 			}
@@ -1861,13 +1856,8 @@ static int __block_prepare_write(struct 
 		if (block_start >= to)
 			break;
 		if (buffer_new(bh)) {
-			void *kaddr;
-
 			clear_buffer_new(bh);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr+block_start, 0, bh->b_size);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			memclear_highpage_flush(page, block_start, bh->b_size);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1955,10 +1945,7 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				void *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + i * blocksize, 0, blocksize);
-				flush_dcache_page(page);
-				kunmap_atomic(kaddr, KM_USER0);
+				memclear_highpage_flush(page, i * blocksize, blocksize);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2101,7 +2088,6 @@ int cont_prepare_write(struct page *page
 	long status;
 	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
-	void *kaddr;
 
 	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
 		status = -ENOMEM;
@@ -2123,10 +2109,8 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		kaddr = kmap_atomic(new_page, KM_USER0);
-		memset(kaddr+zerofrom, 0, PAGE_CACHE_SIZE-zerofrom);
-		flush_dcache_page(new_page);
-		kunmap_atomic(kaddr, KM_USER0);
+		memclear_highpage_flush(new_page, zerofrom,
+					PAGE_CACHE_SIZE - zerofrom);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2153,10 +2137,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr+zerofrom, 0, offset-zerofrom);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		memclear_highpage_flush(page, zerofrom, offset - zerofrom);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2243,7 +2224,6 @@ int nobh_prepare_write(struct page *page
 	unsigned block_in_page;
 	unsigned block_start;
 	sector_t block_in_file;
-	char *kaddr;
 	int nr_reads = 0;
 	int i;
 	int ret = 0;
@@ -2283,13 +2263,12 @@ int nobh_prepare_write(struct page *page
 		if (PageUptodate(page))
 			continue;
 		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
-			kaddr = kmap_atomic(page, KM_USER0);
 			if (block_start < from)
-				memset(kaddr+block_start, 0, from-block_start);
+				memclear_highpage_flush(page,
+					block_start, from - block_start);
 			if (block_end > to)
-				memset(kaddr + to, 0, block_end - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+				memclear_highpage_flush(page,
+					to, block_end - to);
 			continue;
 		}
 		if (buffer_uptodate(&map_bh))
@@ -2355,10 +2334,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	memclear_highpage_flush(page, 0, PAGE_SIZE);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2397,7 +2373,6 @@ int nobh_writepage(struct page *page, ge
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 	int ret;
 
 	/* Is the page fully inside i_size? */
@@ -2428,10 +2403,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	memclear_highpage_flush(page, offset, PAGE_CACHE_SIZE - offset);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2452,7 +2424,6 @@ int nobh_truncate_page(struct address_sp
 	unsigned to;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
-	char *kaddr;
 	int ret = 0;
 
 	if ((offset & (blocksize - 1)) == 0)
@@ -2466,10 +2437,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		memclear_highpage_flush(page, offset, PAGE_CACHE_SIZE - offset);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2495,7 +2463,6 @@ int block_truncate_page(struct address_s
 	struct inode *inode = mapping->host;
 	struct page *page;
 	struct buffer_head *bh;
-	void *kaddr;
 	int err;
 
 	blocksize = 1 << inode->i_blkbits;
@@ -2549,11 +2516,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	memclear_highpage_flush(page, offset, length);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2574,7 +2537,6 @@ int block_write_full_page(struct page *p
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
@@ -2600,10 +2562,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	memclear_highpage_flush(page, offset, PAGE_CACHE_SIZE - offset);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
Index: linux-2.6.21-rc7/fs/direct-io.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/direct-io.c	2007-04-23 14:28:35.000000000 -0700
+++ linux-2.6.21-rc7/fs/direct-io.c	2007-04-23 14:29:21.000000000 -0700
@@ -867,7 +867,6 @@ static int do_direct_IO(struct dio *dio)
 do_holes:
 			/* Handle holes */
 			if (!buffer_mapped(map_bh)) {
-				char *kaddr;
 				loff_t i_size_aligned;
 
 				/* AKPM: eargh, -ENOTBLK is a hack */
@@ -888,11 +887,8 @@ do_holes:
 					page_cache_release(page);
 					goto out;
 				}
-				kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + (block_in_page << blkbits),
-						0, 1 << blkbits);
-				flush_dcache_page(page);
-				kunmap_atomic(kaddr, KM_USER0);
+				memclear_highpage_flush(page,
+					block_in_page << blkbits, 1 << blkbits);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
Index: linux-2.6.21-rc7/fs/libfs.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/libfs.c	2007-04-23 14:29:49.000000000 -0700
+++ linux-2.6.21-rc7/fs/libfs.c	2007-04-23 14:32:19.000000000 -0700
@@ -332,11 +332,11 @@ int simple_prepare_write(struct file *fi
 {
 	if (!PageUptodate(page)) {
 		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			if (from)
+				memclear_highpage_flush(page, 0, from);
+			if (to < PAGE_CACHE_SIZE)
+				memclear_highpage_flush(page, to,
+					PAGE_CACHE_SIZE - to);
 		}
 	}
 	return 0;
Index: linux-2.6.21-rc7/fs/mpage.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/mpage.c	2007-04-23 14:32:27.000000000 -0700
+++ linux-2.6.21-rc7/fs/mpage.c	2007-04-23 14:53:55.000000000 -0700
@@ -284,11 +284,8 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + (first_hole << blkbits), 0,
+		memclear_highpage_flush(page, first_hole << blkbits,
 				PAGE_CACHE_SIZE - (first_hole << blkbits));
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -576,14 +573,11 @@ page_is_mapped:
 		 * written out to the file."
 		 */
 		unsigned offset = i_size & (PAGE_CACHE_SIZE - 1);
-		char *kaddr;
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		memclear_highpage_flush(page, offset,
+			PAGE_CACHE_SIZE - offset);
 	}
 
 	/*
Index: linux-2.6.21-rc7/mm/filemap_xip.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap_xip.c	2007-04-23 14:34:41.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap_xip.c	2007-04-23 14:35:26.000000000 -0700
@@ -458,11 +458,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	kunmap_atomic(kaddr, KM_USER0);
-
-	flush_dcache_page(page);
+	memclear_highpage_flush(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);

--
