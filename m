Return-Path: <linux-kernel-owner+w=401wt.eu-S1762397AbXEPDAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397AbXEPDAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbXEPDAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:00:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45321 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762301AbXEPDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:00:19 -0400
Date: Tue, 15 May 2007 20:00:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>
Subject: Pagecache zeroing: zero_user_segment, zero_user_segments and zero_user
Message-ID: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify page cache zeroing of segments of pages through 3 functions


zero_user_segments(page, start1, end1, start2, end2)

	Zeros two segments of the page. It takes the position where to
	start and end the zeroing which avoids length calculations.

zero_user_segment(page, start, end)

	Same for a single segment.

zero_user(page, start, length)

	Length variant for the case where we know the length.



We remove the zero_user_page macro. Issues:

1. Its a macro. Inline functions are preferable.

2. It has a useless parameter specifying the kmap slot.
   The functions above default to KM_USER0 which is also always used when
   zero_user_page was called except in one single case. We open code that
   single case to draw attention to the spot.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/block/loop.c    |    2 -
 fs/affs/file.c          |    2 -
 fs/buffer.c             |   48 ++++++++++++++---------------------------------
 fs/direct-io.c          |    4 +--
 fs/ext3/inode.c         |    4 +--
 fs/libfs.c              |   11 +++-------
 fs/mpage.c              |    7 +-----
 fs/ntfs/aops.c          |   18 +++++++++--------
 fs/ntfs/file.c          |   32 ++++++++++++++-----------------
 fs/reiserfs/file.c      |   17 ++++------------
 fs/reiserfs/inode.c     |    4 +--
 include/linux/highmem.h |   49 ++++++++++++++++++++++++++++++------------------
 mm/filemap_xip.c        |    2 -
 mm/truncate.c           |    2 -
 14 files changed, 92 insertions(+), 110 deletions(-)

Index: vps/include/linux/highmem.h
===================================================================
--- vps.orig/include/linux/highmem.h	2007-05-15 18:17:51.000000000 -0700
+++ vps/include/linux/highmem.h	2007-05-15 19:47:32.000000000 -0700
@@ -92,28 +92,41 @@ static inline void clear_highpage(struct
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
-/*
- * Same but also flushes aliased cache contents to RAM.
- *
- * This must be a macro because KM_USER0 and friends aren't defined if
- * !CONFIG_HIGHMEM
- */
-#define zero_user_page(page, offset, size, km_type)		\
-	do {							\
-		void *kaddr;					\
-								\
-		BUG_ON((offset) + (size) > PAGE_SIZE);		\
-								\
-		kaddr = kmap_atomic(page, km_type);		\
-		memset((char *)kaddr + (offset), 0, (size));	\
-		flush_dcache_page(page);			\
-		kunmap_atomic(kaddr, (km_type));		\
-	} while (0)
+static inline void zero_user_segments(struct page *page,
+	unsigned start1, unsigned end1,
+	unsigned start2, unsigned end2)
+{
+	void *kaddr = kmap_atomic(page, KM_USER0);
+
+	BUG_ON(end1 > PAGE_SIZE ||
+		end2 > PAGE_SIZE);
+
+	if (end1 > start1)
+		memset(kaddr + start1, 0, end1 - start1);
+
+	if (end2 > start2)
+		memset(kaddr + start2, 0, end2 - start2);
+
+	flush_dcache_page(page);
+	kunmap_atomic(kaddr, KM_USER0);
+}
+
+static inline void zero_user_segment(struct page *page,
+	unsigned start, unsigned end)
+{
+	zero_user_segments(page, start, end, 0, 0);
+}
+
+static inline void zero_user(struct page *page,
+	unsigned start, unsigned size)
+{
+	zero_user_segments(page, start, start + size, 0, 0);
+}
 
 static inline void __deprecated memclear_highpage_flush(struct page *page,
 			unsigned int offset, unsigned int size)
 {
-	zero_user_page(page, offset, size, KM_USER0);
+	zero_user(page, offset, size);
 }
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
Index: vps/fs/buffer.c
===================================================================
--- vps.orig/fs/buffer.c	2007-05-15 19:04:01.000000000 -0700
+++ vps/fs/buffer.c	2007-05-15 19:22:37.000000000 -0700
@@ -1787,19 +1787,10 @@ static int __block_prepare_write(struct 
 					set_buffer_uptodate(bh);
 					continue;
 				}
-				if (block_end > to || block_start < from) {
-					void *kaddr;
-
-					kaddr = kmap_atomic(page, KM_USER0);
-					if (block_end > to)
-						memset(kaddr+to, 0,
-							block_end-to);
-					if (block_start < from)
-						memset(kaddr+block_start,
-							0, from-block_start);
-					flush_dcache_page(page);
-					kunmap_atomic(kaddr, KM_USER0);
-				}
+				if (block_end > to || block_start < from)
+					zero_user_segments(page,
+							to, block_end,
+							block_start, from);
 				continue;
 			}
 		}
@@ -1847,7 +1838,7 @@ static int __block_prepare_write(struct 
 			break;
 		if (buffer_new(bh)) {
 			clear_buffer_new(bh);
-			zero_user_page(page, block_start, bh->b_size, KM_USER0);
+			zero_user(page, block_start, bh->b_size);
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
@@ -1935,8 +1926,7 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user_page(page, i * blocksize, blocksize,
-						KM_USER0);
+				zero_user(page, i * blocksize, blocksize);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2100,8 +2090,7 @@ int cont_prepare_write(struct page *page
 						PAGE_CACHE_SIZE, get_block);
 		if (status)
 			goto out_unmap;
-		zero_user_page(page, zerofrom, PAGE_CACHE_SIZE - zerofrom,
-				KM_USER0);
+		zero_user_segment(page, zerofrom, PAGE_CACHE_SIZE);
 		generic_commit_write(NULL, new_page, zerofrom, PAGE_CACHE_SIZE);
 		unlock_page(new_page);
 		page_cache_release(new_page);
@@ -2128,7 +2117,7 @@ int cont_prepare_write(struct page *page
 	if (status)
 		goto out1;
 	if (zerofrom < offset) {
-		zero_user_page(page, zerofrom, offset - zerofrom, KM_USER0);
+		zero_user_segment(page, zerofrom, offset);
 		__block_commit_write(inode, page, zerofrom, offset);
 	}
 	return 0;
@@ -2215,7 +2204,6 @@ int nobh_prepare_write(struct page *page
 	unsigned block_in_page;
 	unsigned block_start;
 	sector_t block_in_file;
-	char *kaddr;
 	int nr_reads = 0;
 	int i;
 	int ret = 0;
@@ -2255,13 +2243,8 @@ int nobh_prepare_write(struct page *page
 		if (PageUptodate(page))
 			continue;
 		if (buffer_new(&map_bh) || !buffer_mapped(&map_bh)) {
-			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_start < from)
-				memset(kaddr+block_start, 0, from-block_start);
-			if (block_end > to)
-				memset(kaddr + to, 0, block_end - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_segments(page, block_start, from,
+						to, block_end);
 			continue;
 		}
 		if (buffer_uptodate(&map_bh))
@@ -2327,7 +2310,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2396,7 +2379,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2430,8 +2413,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
+		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2510,7 +2492,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2556,7 +2538,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
Index: vps/fs/libfs.c
===================================================================
--- vps.orig/fs/libfs.c	2007-05-15 19:04:01.000000000 -0700
+++ vps/fs/libfs.c	2007-05-15 19:17:59.000000000 -0700
@@ -340,13 +340,10 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+		if (to - from != PAGE_CACHE_SIZE)
+			zero_user_segments(page,
+				0, from,
+				to, PAGE_CACHE_SIZE);
 	}
 	return 0;
 }
Index: vps/fs/reiserfs/file.c
===================================================================
--- vps.orig/fs/reiserfs/file.c	2007-05-15 19:04:01.000000000 -0700
+++ vps/fs/reiserfs/file.c	2007-05-15 19:17:59.000000000 -0700
@@ -1059,13 +1059,7 @@ static int reiserfs_prepare_file_region_
 	   maping blocks, since there is none, so we just zero out remaining
 	   parts of first and last pages in write area (if needed) */
 	if ((pos & ~((loff_t) PAGE_CACHE_SIZE - 1)) > inode->i_size) {
-		if (from != 0)		/* First page needs to be partially zeroed */
-			zero_user_page(prepared_pages[0], 0, from, KM_USER0);
-
-		if (to != PAGE_CACHE_SIZE)	/* Last page needs to be partially zeroed */
-			zero_user_page(prepared_pages[num_pages-1], to,
-					PAGE_CACHE_SIZE - to, KM_USER0);
-
+		zero_user_segments(prepared_pages[0], 0, from, to, PAGE_CACHE_SIZE);
 		/* Since all blocks are new - use already calculated value */
 		return blocks;
 	}
@@ -1191,9 +1185,8 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					zero_user_page(prepared_pages[0],
-						       block_start,
-						       from - block_start, KM_USER0);
+					zero_user_segment(prepared_pages[0],
+						       block_start, from);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1225,8 +1218,8 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					zero_user_page(prepared_pages[num_pages-1],
-							to, block_end - to, KM_USER0);
+					zero_user_segment(prepared_pages[num_pages-1],
+							to, block_end);
 					set_buffer_uptodate(bh);
 				}
 			}
Index: vps/fs/affs/file.c
===================================================================
--- vps.orig/fs/affs/file.c	2007-05-15 19:03:28.000000000 -0700
+++ vps/fs/affs/file.c	2007-05-15 19:20:36.000000000 -0700
@@ -628,7 +628,7 @@ static int affs_prepare_write_ofs(struct
 			return err;
 	}
 	if (to < PAGE_CACHE_SIZE) {
-		zero_user_page(page, to, PAGE_CACHE_SIZE - to, KM_USER0);
+		zero_user_segment(page, to, PAGE_CACHE_SIZE);
 		if (size > offset + to) {
 			if (size < offset + PAGE_CACHE_SIZE)
 				tmp = size & ~PAGE_CACHE_MASK;
Index: vps/fs/mpage.c
===================================================================
--- vps.orig/fs/mpage.c	2007-05-15 19:03:28.000000000 -0700
+++ vps/fs/mpage.c	2007-05-15 19:20:36.000000000 -0700
@@ -284,9 +284,7 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		zero_user_page(page, first_hole << blkbits,
-				PAGE_CACHE_SIZE - (first_hole << blkbits),
-				KM_USER0);
+		zero_user_segment(page, first_hole << blkbits, PAGE_CACHE_SIZE);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -585,8 +583,7 @@ page_is_mapped:
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
+		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	}
 
 	/*
Index: vps/fs/ntfs/aops.c
===================================================================
--- vps.orig/fs/ntfs/aops.c	2007-05-15 19:03:28.000000000 -0700
+++ vps/fs/ntfs/aops.c	2007-05-15 19:32:04.000000000 -0700
@@ -87,13 +87,17 @@ static void ntfs_end_buffer_async_read(s
 		/* Check for the current buffer head overflowing. */
 		if (unlikely(file_ofs + bh->b_size > init_size)) {
 			int ofs;
+			void *kaddr;
 
 			ofs = 0;
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			zero_user_page(page, bh_offset(bh) + ofs,
-					 bh->b_size - ofs, KM_BIO_SRC_IRQ);
+			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
+			memset(kaddr + bh_offset(bh) + ofs, 0,
+					bh->b_size - ofs);
+			flush_dcache_page(page);
+			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
 			local_irq_restore(flags);
 		}
 	} else {
@@ -334,7 +338,7 @@ handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		zero_user_page(page, i * blocksize, blocksize, KM_USER0);
+		zero_user(page, i * blocksize, blocksize);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -451,7 +455,7 @@ retry_readpage:
 	 * ok to ignore the compressed flag here.
 	 */
 	if (unlikely(page->index > 0)) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		goto done;
 	}
 	if (!NInoAttr(ni))
@@ -780,8 +784,7 @@ lock_retry_remap:
 		if (err == -ENOENT || lcn == LCN_ENOENT) {
 			bh->b_blocknr = -1;
 			clear_buffer_dirty(bh);
-			zero_user_page(page, bh_offset(bh), blocksize,
-					KM_USER0);
+			zero_user(page, bh_offset(bh), blocksize);
 			set_buffer_uptodate(bh);
 			err = 0;
 			continue;
@@ -1406,8 +1409,7 @@ retry_writepage:
 		if (page->index >= (i_size >> PAGE_CACHE_SHIFT)) {
 			/* The page straddles i_size. */
 			unsigned int ofs = i_size & ~PAGE_CACHE_MASK;
-			zero_user_page(page, ofs, PAGE_CACHE_SIZE - ofs,
-					KM_USER0);
+			zero_user_segment(page, ofs, PAGE_CACHE_SIZE);
 		}
 		/* Handle mst protected attributes. */
 		if (NInoMstProtected(ni))
Index: vps/fs/reiserfs/inode.c
===================================================================
--- vps.orig/fs/reiserfs/inode.c	2007-05-15 19:03:28.000000000 -0700
+++ vps/fs/reiserfs/inode.c	2007-05-15 19:29:14.000000000 -0700
@@ -2149,7 +2149,7 @@ int reiserfs_truncate_file(struct inode 
 		/* if we are not on a block boundary */
 		if (length) {
 			length = blocksize - length;
-			zero_user_page(page, offset, length, KM_USER0);
+			zero_user(page, offset, length);
 			if (buffer_mapped(bh) && bh->b_blocknr != 0) {
 				mark_buffer_dirty(bh);
 			}
@@ -2373,7 +2373,7 @@ static int reiserfs_write_full_page(stru
 			unlock_page(page);
 			return 0;
 		}
-		zero_user_page(page, last_offset, PAGE_CACHE_SIZE - last_offset, KM_USER0);
+		zero_user_segment(page, last_offset, PAGE_CACHE_SIZE);
 	}
 	bh = head;
 	block = page->index << (PAGE_CACHE_SHIFT - s->s_blocksize_bits);
Index: vps/mm/truncate.c
===================================================================
--- vps.orig/mm/truncate.c	2007-05-15 19:03:28.000000000 -0700
+++ vps/mm/truncate.c	2007-05-15 19:20:36.000000000 -0700
@@ -47,7 +47,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	zero_user_page(page, partial, PAGE_CACHE_SIZE - partial, KM_USER0);
+	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
Index: vps/fs/direct-io.c
===================================================================
--- vps.orig/fs/direct-io.c	2007-05-15 19:22:52.000000000 -0700
+++ vps/fs/direct-io.c	2007-05-15 19:23:07.000000000 -0700
@@ -887,8 +887,8 @@ do_holes:
 					page_cache_release(page);
 					goto out;
 				}
-				zero_user_page(page, block_in_page << blkbits,
-						1 << blkbits, KM_USER0);
+				zero_user(page, block_in_page << blkbits,
+						1 << blkbits);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
Index: vps/mm/filemap_xip.c
===================================================================
--- vps.orig/mm/filemap_xip.c	2007-05-15 19:23:32.000000000 -0700
+++ vps/mm/filemap_xip.c	2007-05-15 19:23:41.000000000 -0700
@@ -457,7 +457,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
Index: vps/drivers/block/loop.c
===================================================================
--- vps.orig/drivers/block/loop.c	2007-05-15 19:24:52.000000000 -0700
+++ vps/drivers/block/loop.c	2007-05-15 19:25:02.000000000 -0700
@@ -249,7 +249,7 @@ static int do_lo_send_aops(struct loop_d
 			 */
 			printk(KERN_ERR "loop: transfer error block %llu\n",
 			       (unsigned long long)index);
-			zero_user_page(page, offset, size, KM_USER0);
+			zero_user(page, offset, size);
 		}
 		flush_dcache_page(page);
 		ret = aops->commit_write(file, page, offset,
Index: vps/fs/ext3/inode.c
===================================================================
--- vps.orig/fs/ext3/inode.c	2007-05-15 19:25:07.000000000 -0700
+++ vps/fs/ext3/inode.c	2007-05-15 19:25:43.000000000 -0700
@@ -1778,7 +1778,7 @@ static int ext3_block_truncate_page(hand
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
-		zero_user_page(page, offset, length, KM_USER0);
+		zero_user(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1831,7 +1831,7 @@ static int ext3_block_truncate_page(hand
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
Index: vps/fs/ntfs/file.c
===================================================================
--- vps.orig/fs/ntfs/file.c	2007-05-15 19:26:53.000000000 -0700
+++ vps/fs/ntfs/file.c	2007-05-15 19:30:08.000000000 -0700
@@ -606,8 +606,8 @@ do_next_page:
 					ntfs_submit_bh_for_read(bh);
 					*wait_bh++ = bh;
 				} else {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+							blocksize);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -682,9 +682,8 @@ map_buffer_cached:
 						ntfs_submit_bh_for_read(bh);
 						*wait_bh++ = bh;
 					} else {
-						zero_user_page(page,
-							bh_offset(bh),
-							blocksize, KM_USER0);
+						zero_user(page, bh_offset(bh),
+								blocksize);
 						set_buffer_uptodate(bh);
 					}
 				}
@@ -702,8 +701,8 @@ map_buffer_cached:
 			 */
 			if (bh_end <= pos || bh_pos >= end) {
 				if (!buffer_uptodate(bh)) {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+							blocksize);
 					set_buffer_uptodate(bh);
 				}
 				mark_buffer_dirty(bh);
@@ -742,8 +741,7 @@ map_buffer_cached:
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				zero_user_page(page, bh_offset(bh), blocksize,
-						KM_USER0);
+				zero_user(page, bh_offset(bh), blocksize);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -867,8 +865,8 @@ rl_not_mapped_enoent:
 					if (!buffer_uptodate(bh))
 						set_buffer_uptodate(bh);
 				} else if (!buffer_uptodate(bh)) {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+						blocksize);
 					set_buffer_uptodate(bh);
 				}
 				continue;
@@ -1127,8 +1125,8 @@ rl_not_mapped_enoent:
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				zero_user_page(page, bh_offset(bh) + ofs,
-						blocksize - ofs, KM_USER0);
+				zero_user_segment(page, bh_offset(bh) + ofs,
+						blocksize);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
 			err = -EIO;
@@ -1268,8 +1266,8 @@ rl_not_mapped_enoent:
 				if (PageUptodate(page))
 					set_buffer_uptodate(bh);
 				else {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+							blocksize);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1329,7 +1327,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		zero_user_page(*pages, 0, len, KM_USER0);
+		zero_user(*pages, 0, len);
 	}
 	goto out;
 }
@@ -1450,7 +1448,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		zero_user_page(*pages, 0, len, KM_USER0);
+		zero_user(*pages, 0, len);
 	}
 	goto out;
 }
