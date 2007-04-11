Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbXDKDiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbXDKDiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXDKDiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:38:04 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15870 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXDKDiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=EOo/yQukdatNsyfJkmF9GzyprawBBZ7DhUtujowMCYikLYRK8YsIGOD0WIOxADnavuyI7Errihqd0L8YeOhkbxkKxPZPcW5ODdmGB7m1vJks9ROyFHYqh8QqICr1He2Cc4Om4AFtkLc3oPTgh8Li1XmLcjAec935AW77QFGI4Bw=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 10 Apr 2007 20:36:00 -0700
Message-Id: <20070411033600.11000.38285.patchbomb.py@localhost>
Subject: [PATCH 1/13] fs: convert core functions to zero_user_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's very common for file systems to need to zero part or all of a page, the
simplist way is just to use kmap_atomic() and memset().  There's actually a
library function in include/linux/highmem.h that does exactly that, but it's
confusingly named memclear_highpage_flush(), which is descriptive of *how*
it does the work rather than what the *purpose* is.  So this patchset
renames the function to zero_user_page(), and calls it from the various
places that currently open code it.

This first patch introduces the new function call, and converts all the core
kernel callsites, both the open-coded ones and the old
memclear_highpage_flush() ones.  Following this patch is a series of
conversions for each file system individually, per AKPM, and finally a patch
deprecating the old call.  The diffstat below shows the entire patchset.

Compile tested in x86_64.

signed-off-by: Nate Diller <nate.diller@gmail.com>

---

 drivers/block/loop.c                     |    6 ---
 fs/affs/file.c                           |    6 ---
 fs/buffer.c                              |   53 +++++--------------------------
 fs/direct-io.c                           |    8 +---
 fs/ecryptfs/mmap.c                       |   14 +-------
 fs/ext3/inode.c                          |   12 +------
 fs/ext4/inode.c                          |   12 +------
 fs/ext4/writeback.c                      |   12 +------
 fs/gfs2/bmap.c                           |    6 ---
 fs/mpage.c                               |   11 +-----
 fs/nfs/read.c                            |   10 ++---
 fs/nfs/write.c                           |    2 -
 fs/ntfs/aops.c                           |   26 ++-------------
 fs/ntfs/file.c                           |   47 +++++----------------------
 fs/ocfs2/aops.c                          |    5 --
 fs/reiser4/plugin/file/cryptcompress.c   |   19 +----------
 fs/reiser4/plugin/file/file.c            |    6 ---
 fs/reiser4/plugin/item/ctail.c           |    6 ---
 fs/reiser4/plugin/item/extent_file_ops.c |   19 +++--------
 fs/reiser4/plugin/item/tail.c            |    8 +---
 fs/reiserfs/file.c                       |   39 ++++++----------------
 fs/reiserfs/inode.c                      |   13 +------
 fs/xfs/linux-2.6/xfs_lrw.c               |    2 -
 include/linux/highmem.h                  |    7 +++-
 mm/filemap_xip.c                         |    7 ----
 mm/truncate.c                            |    2 -
 26 files changed, 82 insertions(+), 276 deletions(-)

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/drivers/block/loop.c linux-2.6.21-rc6-mm1-test/drivers/block/loop.c
--- linux-2.6.21-rc6-mm1/drivers/block/loop.c	2007-04-10 18:27:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/drivers/block/loop.c	2007-04-10 18:18:16.000000000 -0700
@@ -244,17 +244,13 @@ static int do_lo_send_aops(struct loop_d
 		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
 				bvec->bv_page, bv_offs, size, IV);
 		if (unlikely(transfer_result)) {
-			char *kaddr;
-
 			/*
 			 * The transfer failed, but we still write the data to
 			 * keep prepare/commit calls balanced.
 			 */
 			printk(KERN_ERR "loop: transfer error block %llu\n",
 			       (unsigned long long)index);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + offset, 0, size);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_page(page, offset, size);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/buffer.c linux-2.6.21-rc6-mm1-test/fs/buffer.c
--- linux-2.6.21-rc6-mm1/fs/buffer.c	2007-04-10 18:27:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/buffer.c	2007-04-10 18:18:16.000000000 -0700
@@ -1862,13 +1862,8 @@ static int __block_prepare_write(struct 
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
+			zero_user_page(page, block_start, bh->b_size);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1956,10 +1951,7 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				void *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + i * blocksize, 0, blocksize);
-				flush_dcache_page(page);
-				kunmap_atomic(kaddr, KM_USER0);
+				zero_user_page(page, i * blocksize, blocksize);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2102,7 +2094,6 @@ int cont_prepare_write(struct page *page
 	long status;
 	unsigned zerofrom;
 	unsigned blocksize = 1 << inode->i_blkbits;
-	void *kaddr;
 
 	while(page->index > (pgpos = *bytes>>PAGE_CACHE_SHIFT)) {
 		status = -ENOMEM;
@@ -2124,10 +2115,7 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		kaddr = kmap_atomic(new_page, KM_USER0);
-		memset(kaddr+zerofrom, 0, PAGE_CACHE_SIZE-zerofrom);
-		flush_dcache_page(new_page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE-zerofrom);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2154,10 +2142,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr+zerofrom, 0, offset-zerofrom);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, zerofrom, offset-zerofrom);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2356,10 +2341,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2398,7 +2380,6 @@ int nobh_writepage(struct page *page, ge
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 	int ret;
 
 	/* Is the page fully inside i_size? */
@@ -2429,10 +2410,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2453,7 +2431,6 @@ int nobh_truncate_page(struct address_sp
 	unsigned to;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
-	char *kaddr;
 	int ret = 0;
 
 	if ((offset & (blocksize - 1)) == 0)
@@ -2467,10 +2444,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2496,7 +2470,6 @@ int block_truncate_page(struct address_s
 	struct inode *inode = mapping->host;
 	struct page *page;
 	struct buffer_head *bh;
-	void *kaddr;
 	int err;
 
 	blocksize = 1 << inode->i_blkbits;
@@ -2550,11 +2523,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_user_page(page, offset, length);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2575,7 +2544,6 @@ int block_write_full_page(struct page *p
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
@@ -2601,10 +2569,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/direct-io.c linux-2.6.21-rc6-mm1-test/fs/direct-io.c
--- linux-2.6.21-rc6-mm1/fs/direct-io.c	2007-04-10 18:27:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/direct-io.c	2007-04-10 18:18:16.000000000 -0700
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
+				zero_user_page(page, block_in_page << blkbits,
+						1 << blkbits);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/mpage.c linux-2.6.21-rc6-mm1-test/fs/mpage.c
--- linux-2.6.21-rc6-mm1/fs/mpage.c	2007-04-10 18:27:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/mpage.c	2007-04-10 18:18:16.000000000 -0700
@@ -284,11 +284,8 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + (first_hole << blkbits), 0,
+		zero_user_page(page, first_hole << blkbits,
 				PAGE_CACHE_SIZE - (first_hole << blkbits));
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -586,14 +583,10 @@ page_is_mapped:
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
+		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset);
 	}
 
 	/*
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/include/linux/highmem.h linux-2.6.21-rc6-mm1-test/include/linux/highmem.h
--- linux-2.6.21-rc6-mm1/include/linux/highmem.h	2007-04-10 17:15:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/include/linux/highmem.h	2007-04-10 18:20:11.000000000 -0700
@@ -137,7 +137,7 @@ static inline void clear_highpage(struct
 /*
  * Same but also flushes aliased cache contents to RAM.
  */
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+static inline void zero_user_page(struct page *page, unsigned int offset, unsigned int size)
 {
 	void *kaddr;
 
@@ -149,6 +149,11 @@ static inline void memclear_highpage_flu
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
+static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+{
+	return zero_user_page(page, offset, size);
+}
+
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 static inline void copy_user_highpage(struct page *to, struct page *from,
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/mm/filemap_xip.c linux-2.6.21-rc6-mm1-test/mm/filemap_xip.c
--- linux-2.6.21-rc6-mm1/mm/filemap_xip.c	2007-04-10 18:27:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/mm/filemap_xip.c	2007-04-10 18:18:16.000000000 -0700
@@ -440,7 +440,6 @@ xip_truncate_page(struct address_space *
 	unsigned blocksize;
 	unsigned length;
 	struct page *page;
-	void *kaddr;
 
 	BUG_ON(!mapping->a_ops->get_xip_page);
 
@@ -464,11 +463,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	kunmap_atomic(kaddr, KM_USER0);
-
-	flush_dcache_page(page);
+	zero_user_page(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/mm/truncate.c linux-2.6.21-rc6-mm1-test/mm/truncate.c
--- linux-2.6.21-rc6-mm1/mm/truncate.c	2007-04-10 18:27:04.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/mm/truncate.c	2007-04-10 18:18:16.000000000 -0700
@@ -46,7 +46,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	memclear_highpage_flush(page, partial, PAGE_CACHE_SIZE-partial);
+	zero_user_page(page, partial, PAGE_CACHE_SIZE-partial);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
