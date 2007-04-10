Return-Path: <linux-kernel-owner+w=401wt.eu-S1030339AbXDJEdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbXDJEdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 00:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXDJEdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 00:33:13 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:55967 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030339AbXDJEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 00:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:date:message-id:subject;
        b=WPicc4/dUQJiwltAo3gxAGHwpVmLka+fEi5g6nulU5JPqXnCgR+NtTf+79GMJaVxuEzGzDMpNv8AvBcRQAY+7d+m7HPnwmgy40+xBi1dauml6K3gsA6MIbCKGSo25Nl3T/Po/ONPlctdd2PWEg5xwWEfJqTJ5PeKHN8j45nFME0=
From: Nate Diller <nate.diller@gmail.com>
To: Andrew Morton <akpm@osdl.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Mon, 09 Apr 2007 21:31:37 -0700
Message-Id: <20070410043137.19370.2295.patchbomb.py@localhost>
Subject: [PATCH 1/2] fs: use memclear_highpage_flush to zero page data
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's very common for file systems to need to zero part or all of a page, the
simplist way is just to use kmap_atomic() and memset().  There's actually a
library function in include/linux/highmem.h that does exactly that, but it's
confusingly named memclear_highpage_flush(), which is descriptive of *how*
it does the work rather than what the *purpose* is.  So this patch renames
the function to zero_page_data(), and calls it from the various places that
currently open code it.

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
 fs/ntfs/aops.c                           |   32 +++---------------
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
 include/linux/highmem.h                  |    2 -
 mm/filemap_xip.c                         |    7 ----
 mm/truncate.c                            |    2 -
 26 files changed, 78 insertions(+), 281 deletions(-)

---

diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/drivers/block/loop.c linux-2.6.21-rc6-mm1-test/drivers/block/loop.c
--- linux-2.6.21-rc6-mm1/drivers/block/loop.c	2007-04-09 17:24:00.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/drivers/block/loop.c	2007-04-09 18:18:23.000000000 -0700
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
+			zero_page_data(page, offset, size);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/affs/file.c linux-2.6.21-rc6-mm1-test/fs/affs/file.c
--- linux-2.6.21-rc6-mm1/fs/affs/file.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/affs/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -628,11 +628,7 @@ static int affs_prepare_write_ofs(struct
 			return err;
 	}
 	if (to < PAGE_CACHE_SIZE) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-
-		memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(page, to, PAGE_CACHE_SIZE - to);
 		if (size > offset + to) {
 			if (size < offset + PAGE_CACHE_SIZE)
 				tmp = size & ~PAGE_CACHE_MASK;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/buffer.c linux-2.6.21-rc6-mm1-test/fs/buffer.c
--- linux-2.6.21-rc6-mm1/fs/buffer.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/buffer.c	2007-04-09 18:18:23.000000000 -0700
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
+			zero_page_data(page, block_start, bh->b_size);
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
+				zero_page_data(page, i * blocksize, blocksize);
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
+		zero_page_data(page, zerofrom, PAGE_CACHE_SIZE-zerofrom);
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
+		zero_page_data(page, zerofrom, offset-zerofrom);
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
+	zero_page_data(page, 0, PAGE_CACHE_SIZE);
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
+	zero_page_data(page, offset, PAGE_CACHE_SIZE - offset);
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
+		zero_page_data(page, offset, PAGE_CACHE_SIZE - offset);
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
+	zero_page_data(page, offset, length);
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
+	zero_page_data(page, offset, PAGE_CACHE_SIZE - offset);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/direct-io.c linux-2.6.21-rc6-mm1-test/fs/direct-io.c
--- linux-2.6.21-rc6-mm1/fs/direct-io.c	2007-04-09 10:41:47.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/direct-io.c	2007-04-09 18:18:23.000000000 -0700
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
+				zero_page_data(page, block_in_page << blkbits,
+						1 << blkbits);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ecryptfs/mmap.c linux-2.6.21-rc6-mm1-test/fs/ecryptfs/mmap.c
--- linux-2.6.21-rc6-mm1/fs/ecryptfs/mmap.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ecryptfs/mmap.c	2007-04-09 18:19:34.000000000 -0700
@@ -364,18 +364,14 @@ static int fill_zeros_to_end_of_page(str
 {
 	struct inode *inode = page->mapping->host;
 	int end_byte_in_page;
-	char *page_virt;
 
 	if ((i_size_read(inode) / PAGE_CACHE_SIZE) != page->index)
 		goto out;
 	end_byte_in_page = i_size_read(inode) % PAGE_CACHE_SIZE;
 	if (to > end_byte_in_page)
 		end_byte_in_page = to;
-	page_virt = kmap_atomic(page, KM_USER0);
-	memset((page_virt + end_byte_in_page), 0,
-	       (PAGE_CACHE_SIZE - end_byte_in_page));
-	kunmap_atomic(page_virt, KM_USER0);
-	flush_dcache_page(page);
+	zero_page_data(page, end_byte_in_page,
+		PAGE_CACHE_SIZE - end_byte_in_page);
 out:
 	return 0;
 }
@@ -740,7 +736,6 @@ int write_zeros(struct file *file, pgoff
 {
 	int rc = 0;
 	struct page *tmp_page;
-	char *tmp_page_virt;
 
 	tmp_page = ecryptfs_get1page(file, index);
 	if (IS_ERR(tmp_page)) {
@@ -757,10 +752,7 @@ int write_zeros(struct file *file, pgoff
 		page_cache_release(tmp_page);
 		goto out;
 	}
-	tmp_page_virt = kmap_atomic(tmp_page, KM_USER0);
-	memset(((char *)tmp_page_virt + start), 0, num_zeros);
-	kunmap_atomic(tmp_page_virt, KM_USER0);
-	flush_dcache_page(tmp_page);
+	zero_page_data(tmp_page, start, num_zeros);
 	rc = ecryptfs_commit_write(file, tmp_page, start, start + num_zeros);
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to write zero's "
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext3/inode.c linux-2.6.21-rc6-mm1-test/fs/ext3/inode.c
--- linux-2.6.21-rc6-mm1/fs/ext3/inode.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext3/inode.c	2007-04-09 18:18:23.000000000 -0700
@@ -1767,7 +1767,6 @@ static int ext3_block_truncate_page(hand
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
@@ -1779,10 +1778,7 @@ static int ext3_block_truncate_page(hand
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1835,11 +1831,7 @@ static int ext3_block_truncate_page(hand
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_page_data(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext4/inode.c linux-2.6.21-rc6-mm1-test/fs/ext4/inode.c
--- linux-2.6.21-rc6-mm1/fs/ext4/inode.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext4/inode.c	2007-04-09 18:18:23.000000000 -0700
@@ -1791,7 +1791,6 @@ int ext4_block_truncate_page(handle_t *h
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 			test_opt(inode->i_sb, EXTENTS) &&
@@ -1808,10 +1807,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1864,11 +1860,7 @@ int ext4_block_truncate_page(handle_t *h
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_page_data(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ext4/writeback.c linux-2.6.21-rc6-mm1-test/fs/ext4/writeback.c
--- linux-2.6.21-rc6-mm1/fs/ext4/writeback.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ext4/writeback.c	2007-04-09 18:18:23.000000000 -0700
@@ -976,7 +976,6 @@ int ext4_wb_writepage(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	wb_debug("writepage %lu from inode %lu\n", page->index, inode->i_ino);
 
@@ -1026,10 +1025,7 @@ int ext4_wb_writepage(struct page *page,
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_page_data(page, offset, PAGE_CACHE_SIZE - offset);
 	return ext4_wb_write_single_page(page, wbc);
 }
 
@@ -1080,7 +1076,6 @@ int ext4_wb_block_truncate_page(handle_t
 	struct inode *inode = mapping->host;
 	struct buffer_head bh, *bhw = &bh;
 	unsigned blocksize, length;
-	void *kaddr;
 	int err = 0;
 
 	wb_debug("partial truncate from %lu on page %lu from inode %lu\n",
@@ -1119,10 +1114,7 @@ int ext4_wb_block_truncate_page(handle_t
 		}
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_page_data(page, offset, length);
 	SetPageUptodate(page);
 	__set_page_dirty_nobuffers(page);
 
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/gfs2/bmap.c linux-2.6.21-rc6-mm1-test/fs/gfs2/bmap.c
--- linux-2.6.21-rc6-mm1/fs/gfs2/bmap.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/gfs2/bmap.c	2007-04-09 18:18:23.000000000 -0700
@@ -885,7 +885,6 @@ static int gfs2_block_truncate_page(stru
 	unsigned blocksize, iblock, length, pos;
 	struct buffer_head *bh;
 	struct page *page;
-	void *kaddr;
 	int err;
 
 	page = grab_cache_page(mapping, index);
@@ -933,10 +932,7 @@ static int gfs2_block_truncate_page(stru
 	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_page_data(page, offset, length);
 
 unlock:
 	unlock_page(page);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/mpage.c linux-2.6.21-rc6-mm1-test/fs/mpage.c
--- linux-2.6.21-rc6-mm1/fs/mpage.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/mpage.c	2007-04-09 18:18:23.000000000 -0700
@@ -284,11 +284,8 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + (first_hole << blkbits), 0,
+		zero_page_data(page, first_hole << blkbits,
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
+		zero_page_data(page, offset, PAGE_CACHE_SIZE - offset);
 	}
 
 	/*
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/nfs/read.c linux-2.6.21-rc6-mm1-test/fs/nfs/read.c
--- linux-2.6.21-rc6-mm1/fs/nfs/read.c	2007-04-09 17:23:48.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/nfs/read.c	2007-04-09 18:18:23.000000000 -0700
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	memclear_highpage_flush(page, 0, PAGE_CACHE_SIZE);
+	zero_page_data(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninit
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			memclear_highpage_flush(*pages, base, remainder);
+			zero_page_data(*pages, base, remainder);
 			break;
 		}
-		memclear_highpage_flush(*pages, base, pglen);
+		zero_page_data(*pages, base, pglen);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_page_data(page, len, PAGE_CACHE_SIZE - len);
 
 	nfs_list_add_request(new, &one_request);
 	nfs_pagein_one(&one_request, inode);
@@ -561,7 +561,7 @@ readpage_async_filler(void *data, struct
 			return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, len, PAGE_CACHE_SIZE - len);
+		zero_page_data(page, len, PAGE_CACHE_SIZE - len);
 	nfs_list_add_request(new, desc->head);
 	return 0;
 }
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/nfs/write.c linux-2.6.21-rc6-mm1-test/fs/nfs/write.c
--- linux-2.6.21-rc6-mm1/fs/nfs/write.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/nfs/write.c	2007-04-09 18:18:23.000000000 -0700
@@ -169,7 +169,7 @@ static void nfs_mark_uptodate(struct pag
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		memclear_highpage_flush(page, count, PAGE_CACHE_SIZE - count);
+		zero_page_data(page, count, PAGE_CACHE_SIZE - count);
 	SetPageUptodate(page);
 }
 
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ntfs/aops.c linux-2.6.21-rc6-mm1-test/fs/ntfs/aops.c
--- linux-2.6.21-rc6-mm1/fs/ntfs/aops.c	2007-04-09 10:41:47.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ntfs/aops.c	2007-04-09 18:18:23.000000000 -0700
@@ -86,19 +86,15 @@ static void ntfs_end_buffer_async_read(s
 		}
 		/* Check for the current buffer head overflowing. */
 		if (unlikely(file_ofs + bh->b_size > init_size)) {
-			u8 *kaddr;
 			int ofs;
 
 			ofs = 0;
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
-			memset(kaddr + bh_offset(bh) + ofs, 0,
+			zero_page_data(page, bh_offset(bh) + ofs,
 					bh->b_size - ofs);
-			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
 			local_irq_restore(flags);
-			flush_dcache_page(page);
 		}
 	} else {
 		clear_buffer_uptodate(bh);
@@ -245,8 +241,7 @@ static int ntfs_read_block(struct page *
 	rl = NULL;
 	nr = i = 0;
 	do {
-		u8 *kaddr;
-		int err;
+		int err = 0;
 
 		if (unlikely(buffer_uptodate(bh)))
 			continue;
@@ -254,7 +249,6 @@ static int ntfs_read_block(struct page *
 			arr[nr++] = bh;
 			continue;
 		}
-		err = 0;
 		bh->b_bdev = vol->sb->s_bdev;
 		/* Is the block within the allowed limits? */
 		if (iblock < lblock) {
@@ -340,10 +334,7 @@ handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + i * blocksize, 0, blocksize);
-		kunmap_atomic(kaddr, KM_USER0);
-		flush_dcache_page(page);
+		zero_page_data(page, i * blocksize, blocksize);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -460,10 +451,7 @@ retry_readpage:
 	 * ok to ignore the compressed flag here.
 	 */
 	if (unlikely(page->index > 0)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(page, 0, PAGE_CACHE_SIZE);
 		goto done;
 	}
 	if (!NInoAttr(ni))
@@ -790,14 +778,9 @@ lock_retry_remap:
 		 * uptodate so it can get discarded by the VM.
 		 */
 		if (err == -ENOENT || lcn == LCN_ENOENT) {
-			u8 *kaddr;
-
 			bh->b_blocknr = -1;
 			clear_buffer_dirty(bh);
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + bh_offset(bh), 0, blocksize);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page);
+			zero_page_data(page, bh_offset(bh), blocksize);
 			set_buffer_uptodate(bh);
 			err = 0;
 			continue;
@@ -1422,10 +1405,7 @@ retry_writepage:
 		if (page->index >= (i_size >> PAGE_CACHE_SHIFT)) {
 			/* The page straddles i_size. */
 			unsigned int ofs = i_size & ~PAGE_CACHE_MASK;
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + ofs, 0, PAGE_CACHE_SIZE - ofs);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(page);
+			zero_page_data(page, ofs, PAGE_CACHE_SIZE - ofs);
 		}
 		/* Handle mst protected attributes. */
 		if (NInoMstProtected(ni))
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ntfs/file.c linux-2.6.21-rc6-mm1-test/fs/ntfs/file.c
--- linux-2.6.21-rc6-mm1/fs/ntfs/file.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ntfs/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -606,11 +606,8 @@ do_next_page:
 					ntfs_submit_bh_for_read(bh);
 					*wait_bh++ = bh;
 				} else {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_page_data(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -685,12 +682,8 @@ map_buffer_cached:
 						ntfs_submit_bh_for_read(bh);
 						*wait_bh++ = bh;
 					} else {
-						u8 *kaddr = kmap_atomic(page,
-								KM_USER0);
-						memset(kaddr + bh_offset(bh),
-								0, blocksize);
-						kunmap_atomic(kaddr, KM_USER0);
-						flush_dcache_page(page);
+						zero_page_data(page, bh_offset(bh),
+								blocksize);
 						set_buffer_uptodate(bh);
 					}
 				}
@@ -708,11 +701,8 @@ map_buffer_cached:
 			 */
 			if (bh_end <= pos || bh_pos >= end) {
 				if (!buffer_uptodate(bh)) {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_page_data(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 				mark_buffer_dirty(bh);
@@ -751,10 +741,7 @@ map_buffer_cached:
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				u8 *kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + bh_offset(bh), 0, blocksize);
-				kunmap_atomic(kaddr, KM_USER0);
-				flush_dcache_page(page);
+				zero_page_data(page, bh_offset(bh), blocksize);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -878,11 +865,8 @@ rl_not_mapped_enoent:
 					if (!buffer_uptodate(bh))
 						set_buffer_uptodate(bh);
 				} else if (!buffer_uptodate(bh)) {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_page_data(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 				continue;
@@ -1137,16 +1121,12 @@ rl_not_mapped_enoent:
 			 * to zero the overflowing region.
 			 */
 			if (unlikely(bh_pos + blocksize > initialized_size)) {
-				u8 *kaddr;
 				int ofs = 0;
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				kaddr = kmap_atomic(page, KM_USER0);
-				memset(kaddr + bh_offset(bh) + ofs, 0,
+				zero_page_data(page, bh_offset(bh) + ofs,
 						blocksize - ofs);
-				kunmap_atomic(kaddr, KM_USER0);
-				flush_dcache_page(page);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
 			err = -EIO;
@@ -1286,11 +1266,8 @@ rl_not_mapped_enoent:
 				if (PageUptodate(page))
 					set_buffer_uptodate(bh);
 				else {
-					u8 *kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr + bh_offset(bh), 0,
+					zero_page_data(page, bh_offset(bh),
 							blocksize);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(page);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1350,9 +1327,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		memset(kaddr, 0, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(*pages, 0, len);
 	}
 	goto out;
 }
@@ -1473,9 +1448,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		kaddr = kmap_atomic(*pages, KM_USER0);
-		memset(kaddr, 0, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(*pages, 0, len);
 	}
 	goto out;
 }
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/ocfs2/aops.c linux-2.6.21-rc6-mm1-test/fs/ocfs2/aops.c
--- linux-2.6.21-rc6-mm1/fs/ocfs2/aops.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/ocfs2/aops.c	2007-04-09 18:18:23.000000000 -0700
@@ -234,10 +234,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		char *addr = kmap(page);
-		memset(addr, 0, PAGE_SIZE);
-		flush_dcache_page(page);
-		kunmap(page);
+		zero_page_data(page, 0, PAGE_SIZE);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/cryptcompress.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/cryptcompress.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/cryptcompress.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/cryptcompress.c	2007-04-09 18:18:23.000000000 -0700
@@ -1897,7 +1897,6 @@ static int
 write_hole(struct inode *inode, reiser4_cluster_t * clust, loff_t file_off,
 	   loff_t to_file)
 {
-	char *data;
 	int result = 0;
 	unsigned cl_off, cl_count = 0;
 	unsigned to_pg, pg_off;
@@ -1934,10 +1933,7 @@ write_hole(struct inode *inode, reiser4_
 
 		to_pg = min_count(PAGE_CACHE_SIZE - pg_off, cl_count);
 		lock_page(page);
-		data = kmap_atomic(page, KM_USER0);
-		memset(data + pg_off, 0, to_pg);
-		flush_dcache_page(page);
-		kunmap_atomic(data, KM_USER0);
+		zero_page_data(page, pg_off, to_pg);
 		SetPageUptodate(page);
 		unlock_page(page);
 
@@ -2167,7 +2163,6 @@ read_some_cluster_pages(struct inode *in
 
 		if (clust->nr_pages) {
 			int off;
-			char *data;
 			struct page * pg;
 			assert("edward-1419", clust->pages != NULL);
 			pg = clust->pages[clust->nr_pages - 1];
@@ -2175,10 +2170,7 @@ read_some_cluster_pages(struct inode *in
 			off = off_to_pgoff(win->off+win->count+win->delta);
 			if (off) {
 				lock_page(pg);
-				data = kmap_atomic(pg, KM_USER0);
-				memset(data + off, 0, PAGE_CACHE_SIZE - off);
-				flush_dcache_page(pg);
-				kunmap_atomic(data, KM_USER0);
+				zero_page_data(pg, off, PAGE_CACHE_SIZE - off);
 				unlock_page(pg);
 			}
 		}
@@ -2217,20 +2209,15 @@ read_some_cluster_pages(struct inode *in
 		    (count_to_nrpages(inode->i_size) <= pg->index)) {
 			/* .. and appended,
 			   so set zeroes to the rest */
-			char *data;
 			int offset;
 			lock_page(pg);
-			data = kmap_atomic(pg, KM_USER0);
-
 			assert("edward-1260",
 			       count_to_nrpages(win->off + win->count +
 						win->delta) - 1 == i);
 
 			offset =
 			    off_to_pgoff(win->off + win->count + win->delta);
-			memset(data + offset, 0, PAGE_CACHE_SIZE - offset);
-			flush_dcache_page(pg);
-			kunmap_atomic(data, KM_USER0);
+			zero_page_data(pg, offset, PAGE_CACHE_SIZE - offset);
 			unlock_page(pg);
 			/* still not uptodate */
 			break;
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/file.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/file.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/file/file.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/file/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -433,7 +433,6 @@ static int shorten_file(struct inode *in
 	struct page *page;
 	int padd_from;
 	unsigned long index;
-	char *kaddr;
 	unix_file_info_t *uf_info;
 
 	/*
@@ -523,10 +522,7 @@ static int shorten_file(struct inode *in
 
 	lock_page(page);
 	assert("vs-1066", PageLocked(page));
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + padd_from, 0, PAGE_CACHE_SIZE - padd_from);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_page_data(page, padd_from, PAGE_CACHE_SIZE - padd_from);
 	unlock_page(page);
 	page_cache_release(page);
 	/* the below does up(sbinfo->delete_mutex). Do not get confused */
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/ctail.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/ctail.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/ctail.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/ctail.c	2007-04-09 18:18:23.000000000 -0700
@@ -627,11 +627,7 @@ int do_readpage_ctail(struct inode * ino
 #endif
 	case FAKE_DISK_CLUSTER:
 		/* fill the page by zeroes */
-		data = kmap_atomic(page, KM_USER0);
-
-		memset(data, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(page);
-		kunmap_atomic(data, KM_USER0);
+		zero_page_data(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		break;
 	case PREP_DISK_CLUSTER:
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/extent_file_ops.c	2007-04-09 18:18:23.000000000 -0700
@@ -1090,17 +1090,6 @@ ssize_t reiser4_write_extent(struct file
 	return (count - left) ? (count - left) : -EFAULT;
 }
 
-static inline void zero_page(struct page *page)
-{
-	char *kaddr = kmap_atomic(page, KM_USER0);
-
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-	SetPageUptodate(page);
-	unlock_page(page);
-}
-
 int reiser4_do_readpage_extent(reiser4_extent * ext, reiser4_block_nr pos,
 			       struct page *page)
 {
@@ -1122,7 +1111,9 @@ int reiser4_do_readpage_extent(reiser4_e
 		 */
 		j = jfind(mapping, index);
 		if (j == NULL) {
-			zero_page(page);
+			zero_page_data(page, 0, PAGE_CACHE_SIZE);
+			SetPageUptodate(page);
+			unlock_page(page);
 			return 0;
 		}
 		spin_lock_jnode(j);
@@ -1135,7 +1126,9 @@ int reiser4_do_readpage_extent(reiser4_e
 		block = *jnode_get_io_block(j);
 		spin_unlock_jnode(j);
 		if (block == 0) {
-			zero_page(page);
+			zero_page_data(page, 0, PAGE_CACHE_SIZE);
+			SetPageUptodate(page);
+			unlock_page(page);
 			jput(j);
 			return 0;
 		}
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/tail.c linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/tail.c
--- linux-2.6.21-rc6-mm1/fs/reiser4/plugin/item/tail.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiser4/plugin/item/tail.c	2007-04-09 18:18:23.000000000 -0700
@@ -391,12 +391,8 @@ static int do_readpage_tail(uf_coord_t *
 	}
 
  done:
-	if (mapped != PAGE_CACHE_SIZE) {
-		pagedata = kmap_atomic(page, KM_USER0);
-		memset(pagedata + mapped, 0, PAGE_CACHE_SIZE - mapped);
-		flush_dcache_page(page);
-		kunmap_atomic(pagedata, KM_USER0);
-	}
+	if (mapped != PAGE_CACHE_SIZE)
+		zero_page_data(page, mapped, PAGE_CACHE_SIZE - mapped);
 	SetPageUptodate(page);
  out_unlock_page:
 	unlock_page(page);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiserfs/file.c linux-2.6.21-rc6-mm1-test/fs/reiserfs/file.c
--- linux-2.6.21-rc6-mm1/fs/reiserfs/file.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiserfs/file.c	2007-04-09 18:18:23.000000000 -0700
@@ -1059,20 +1059,12 @@ static int reiserfs_prepare_file_region_
 	   maping blocks, since there is none, so we just zero out remaining
 	   parts of first and last pages in write area (if needed) */
 	if ((pos & ~((loff_t) PAGE_CACHE_SIZE - 1)) > inode->i_size) {
-		if (from != 0) {	/* First page needs to be partially zeroed */
-			char *kaddr = kmap_atomic(prepared_pages[0], KM_USER0);
-			memset(kaddr, 0, from);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(prepared_pages[0]);
-		}
-		if (to != PAGE_CACHE_SIZE) {	/* Last page needs to be partially zeroed */
-			char *kaddr =
-			    kmap_atomic(prepared_pages[num_pages - 1],
-					KM_USER0);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(prepared_pages[num_pages - 1]);
-		}
+		if (from != 0)		/* First page needs to be partially zeroed */
+			zero_page_data(prepared_pages[0], 0, from);
+
+		if (to != PAGE_CACHE_SIZE)	/* Last page needs to be partially zeroed */
+			zero_page_data(prepared_pages[num_pages-1], to,
+					PAGE_CACHE_SIZE - to);
 
 		/* Since all blocks are new - use already calculated value */
 		return blocks;
@@ -1199,13 +1191,9 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					char *kaddr =
-					    kmap_atomic(prepared_pages[0],
-							KM_USER0);
-					memset(kaddr + block_start, 0,
-					       from - block_start);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(prepared_pages[0]);
+					zero_page_data(prepared_pages[0],
+						       block_start,
+						       from - block_start);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1237,13 +1225,8 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					char *kaddr =
-					    kmap_atomic(prepared_pages
-							[num_pages - 1],
-							KM_USER0);
-					memset(kaddr + to, 0, block_end - to);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(prepared_pages[num_pages - 1]);
+					zero_page_data(prepared_pages[num_pages-1],
+							to, block_end - to);
 					set_buffer_uptodate(bh);
 				}
 			}
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/reiserfs/inode.c linux-2.6.21-rc6-mm1-test/fs/reiserfs/inode.c
--- linux-2.6.21-rc6-mm1/fs/reiserfs/inode.c	2007-04-09 10:41:47.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/reiserfs/inode.c	2007-04-09 18:18:23.000000000 -0700
@@ -2148,13 +2148,8 @@ int reiserfs_truncate_file(struct inode 
 		length = offset & (blocksize - 1);
 		/* if we are not on a block boundary */
 		if (length) {
-			char *kaddr;
-
 			length = blocksize - length;
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + offset, 0, length);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_page_data(page, offset, length);
 			if (buffer_mapped(bh) && bh->b_blocknr != 0) {
 				mark_buffer_dirty(bh);
 			}
@@ -2370,7 +2365,6 @@ static int reiserfs_write_full_page(stru
 	 ** last byte in the file
 	 */
 	if (page->index >= end_index) {
-		char *kaddr;
 		unsigned last_offset;
 
 		last_offset = inode->i_size & (PAGE_CACHE_SIZE - 1);
@@ -2379,10 +2373,7 @@ static int reiserfs_write_full_page(stru
 			unlock_page(page);
 			return 0;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + last_offset, 0, PAGE_CACHE_SIZE - last_offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_page_data(page, last_offset, PAGE_CACHE_SIZE - last_offset);
 	}
 	bh = head;
 	block = page->index << (PAGE_CACHE_SHIFT - s->s_blocksize_bits);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/fs/xfs/linux-2.6/xfs_lrw.c linux-2.6.21-rc6-mm1-test/fs/xfs/linux-2.6/xfs_lrw.c
--- linux-2.6.21-rc6-mm1/fs/xfs/linux-2.6/xfs_lrw.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/fs/xfs/linux-2.6/xfs_lrw.c	2007-04-09 18:18:23.000000000 -0700
@@ -159,7 +159,7 @@ xfs_iozero(
 		if (status)
 			goto unlock;
 
-		memclear_highpage_flush(page, offset, bytes);
+		zero_page_data(page, offset, bytes);
 
 		status = mapping->a_ops->commit_write(NULL, page, offset,
 							offset + bytes);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/include/linux/highmem.h linux-2.6.21-rc6-mm1-test/include/linux/highmem.h
--- linux-2.6.21-rc6-mm1/include/linux/highmem.h	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/include/linux/highmem.h	2007-04-09 18:18:23.000000000 -0700
@@ -137,7 +137,7 @@ static inline void clear_highpage(struct
 /*
  * Same but also flushes aliased cache contents to RAM.
  */
-static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
+static inline void zero_page_data(struct page *page, unsigned int offset, unsigned int size)
 {
 	void *kaddr;
 
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/mm/filemap_xip.c linux-2.6.21-rc6-mm1-test/mm/filemap_xip.c
--- linux-2.6.21-rc6-mm1/mm/filemap_xip.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/mm/filemap_xip.c	2007-04-09 18:18:23.000000000 -0700
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
+	zero_page_data(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/mm/truncate.c linux-2.6.21-rc6-mm1-test/mm/truncate.c
--- linux-2.6.21-rc6-mm1/mm/truncate.c	2007-04-09 17:24:03.000000000 -0700
+++ linux-2.6.21-rc6-mm1-test/mm/truncate.c	2007-04-09 18:18:23.000000000 -0700
@@ -46,7 +46,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	memclear_highpage_flush(page, partial, PAGE_CACHE_SIZE-partial);
+	zero_page_data(page, partial, PAGE_CACHE_SIZE-partial);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
