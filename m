Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbXFTScg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbXFTScg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbXFTSa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46723 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754288AbXFTSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:09 -0400
Message-Id: <20070620183006.214969444@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:09 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [02/37] Pagecache zeroing: zero_user_segment, zero_user_segments and zero_user
Content-Disposition: inline; filename=zero_user_segments
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

2. The KM_USER0 macro is only defined for HIGHMEM.

   Having to treat this special case everywhere makes the
   code needlessly complex. The parameter for zeroing is always
   KM_USER0 except in one single case that we open code.

Avoiding KM_USER0 makes a lot of code not having to be dealing
with the special casing for HIGHMEM anymore. Dealing with
kmap is only necessary for HIGHMEM configurations. In those
configurations we use KM_USER0 like we do for a series of other
functions defined in highmem.h.

Since KM_USER0 is depends on HIGHMEM the existing zero_user_page
function could not be a macro. zero_user_* functions introduced
here can be because that constant is not used when these
functions are called.

Extract the flushing of the caches to be outside of the kmap.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/affs/file.c                           |    2 -
 fs/buffer.c                              |   47 +++++++++--------------------
 fs/direct-io.c                           |    4 +-
 fs/ecryptfs/mmap.c                       |    5 +--
 fs/ext3/inode.c                          |    4 +-
 fs/gfs2/bmap.c                           |    2 -
 fs/libfs.c                               |   19 +++---------
 fs/mpage.c                               |    7 +---
 fs/nfs/read.c                            |   10 +++---
 fs/nfs/write.c                           |    2 -
 fs/ntfs/aops.c                           |   18 ++++++-----
 fs/ntfs/file.c                           |   32 +++++++++-----------
 fs/ocfs2/aops.c                          |    2 -
 fs/reiser4/plugin/file/cryptcompress.c   |    8 +----
 fs/reiser4/plugin/file/file.c            |    2 -
 fs/reiser4/plugin/item/ctail.c           |    2 -
 fs/reiser4/plugin/item/extent_file_ops.c |    4 +-
 fs/reiser4/plugin/item/tail.c            |    3 -
 fs/reiserfs/inode.c                      |    4 +-
 fs/xfs/linux-2.6/xfs_lrw.c               |    2 -
 include/linux/highmem.h                  |   49 +++++++++++++++++++------------
 mm/filemap_xip.c                         |    2 -
 mm/truncate.c                            |    2 -
 23 files changed, 107 insertions(+), 125 deletions(-)

Index: vps/include/linux/highmem.h
===================================================================
--- vps.orig/include/linux/highmem.h	2007-06-11 22:33:01.000000000 -0700
+++ vps/include/linux/highmem.h	2007-06-11 22:33:07.000000000 -0700
@@ -124,28 +124,41 @@ static inline void clear_highpage(struct
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
+	kunmap_atomic(kaddr, KM_USER0);
+	flush_dcache_page(page);
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
--- vps.orig/fs/buffer.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/buffer.c	2007-06-11 22:49:08.000000000 -0700
@@ -1792,7 +1792,7 @@ void page_zero_new_buffers(struct page *
 					start = max(from, block_start);
 					size = min(to, block_end) - start;
 
-					zero_user_page(page, start, size, KM_USER0);
+					zero_user(page, start, size);
 					set_buffer_uptodate(bh);
 				}
 
@@ -1855,19 +1855,10 @@ static int __block_prepare_write(struct 
 					mark_buffer_dirty(bh);
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
@@ -2095,8 +2086,7 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user_page(page, i * blocksize, blocksize,
-						KM_USER0);
+				zero_user(page, i * blocksize, blocksize);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2209,7 +2199,7 @@ int cont_expand_zero(struct file *file, 
 						&page, &fsdata);
 		if (err)
 			goto out;
-		zero_user_page(page, zerofrom, len, KM_USER0);
+		zero_user(page, zerofrom, len);
 		err = pagecache_write_end(file, mapping, curpos, len, len,
 						page, fsdata);
 		if (err < 0)
@@ -2236,7 +2226,7 @@ int cont_expand_zero(struct file *file, 
 						&page, &fsdata);
 		if (err)
 			goto out;
-		zero_user_page(page, zerofrom, len, KM_USER0);
+		zero_user(page, zerofrom, len);
 		err = pagecache_write_end(file, mapping, curpos, len, len,
 						page, fsdata);
 		if (err < 0)
@@ -2350,7 +2340,6 @@ int nobh_prepare_write(struct page *page
 	unsigned block_in_page;
 	unsigned block_start;
 	sector_t block_in_file;
-	char *kaddr;
 	int nr_reads = 0;
 	int i;
 	int ret = 0;
@@ -2390,13 +2379,8 @@ int nobh_prepare_write(struct page *page
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
@@ -2462,7 +2446,7 @@ failed:
 	 * Error recovery is pretty slack.  Clear the page and mark it dirty
 	 * so we'll later zero out any blocks which _were_ allocated.
 	 */
-	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+	zero_user(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	set_page_dirty(page);
 	return ret;
@@ -2531,7 +2515,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2565,8 +2549,7 @@ int nobh_truncate_page(struct address_sp
 	to = (offset + blocksize) & ~(blocksize - 1);
 	ret = a_ops->prepare_write(NULL, page, offset, to);
 	if (ret == 0) {
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
+		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 		/*
 		 * It would be more correct to call aops->commit_write()
 		 * here, but this is more efficient.
@@ -2645,7 +2628,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2691,7 +2674,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
Index: vps/fs/libfs.c
===================================================================
--- vps.orig/fs/libfs.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/libfs.c	2007-06-11 22:49:09.000000000 -0700
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
@@ -396,12 +393,8 @@ int simple_write_end(struct file *file, 
 	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
 
 	/* zero the stale part of the page if we did a short copy */
-	if (copied < len) {
-		void *kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + from + copied, 0, len - copied);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
-	}
+	if (copied < len)
+		zero_user(page, from + copied, len);
 
 	simple_commit_write(file, page, from, from+copied);
 
Index: vps/fs/affs/file.c
===================================================================
--- vps.orig/fs/affs/file.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/affs/file.c	2007-06-11 22:33:07.000000000 -0700
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
--- vps.orig/fs/mpage.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/mpage.c	2007-06-11 22:49:08.000000000 -0700
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
@@ -579,8 +577,7 @@ page_is_mapped:
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
+		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	}
 
 	/*
Index: vps/fs/ntfs/aops.c
===================================================================
--- vps.orig/fs/ntfs/aops.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/ntfs/aops.c	2007-06-11 22:33:07.000000000 -0700
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
--- vps.orig/fs/reiserfs/inode.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/reiserfs/inode.c	2007-06-11 22:33:07.000000000 -0700
@@ -2151,7 +2151,7 @@ int reiserfs_truncate_file(struct inode 
 		/* if we are not on a block boundary */
 		if (length) {
 			length = blocksize - length;
-			zero_user_page(page, offset, length, KM_USER0);
+			zero_user(page, offset, length);
 			if (buffer_mapped(bh) && bh->b_blocknr != 0) {
 				mark_buffer_dirty(bh);
 			}
@@ -2375,7 +2375,7 @@ static int reiserfs_write_full_page(stru
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
--- vps.orig/mm/truncate.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/mm/truncate.c	2007-06-11 22:54:27.000000000 -0700
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
--- vps.orig/fs/direct-io.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/direct-io.c	2007-06-11 22:33:07.000000000 -0700
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
--- vps.orig/mm/filemap_xip.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/mm/filemap_xip.c	2007-06-11 22:54:27.000000000 -0700
@@ -461,7 +461,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
Index: vps/fs/ext3/inode.c
===================================================================
--- vps.orig/fs/ext3/inode.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/ext3/inode.c	2007-06-11 22:33:07.000000000 -0700
@@ -1818,7 +1818,7 @@ static int ext3_block_truncate_page(hand
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
-		zero_user_page(page, offset, length, KM_USER0);
+		zero_user(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1871,7 +1871,7 @@ static int ext3_block_truncate_page(hand
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
Index: vps/fs/ntfs/file.c
===================================================================
--- vps.orig/fs/ntfs/file.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/ntfs/file.c	2007-06-11 22:33:07.000000000 -0700
@@ -607,8 +607,8 @@ do_next_page:
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
@@ -683,9 +683,8 @@ map_buffer_cached:
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
@@ -703,8 +702,8 @@ map_buffer_cached:
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
@@ -743,8 +742,7 @@ map_buffer_cached:
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				zero_user_page(page, bh_offset(bh), blocksize,
-						KM_USER0);
+				zero_user(page, bh_offset(bh), blocksize);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -868,8 +866,8 @@ rl_not_mapped_enoent:
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
@@ -1128,8 +1126,8 @@ rl_not_mapped_enoent:
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				zero_user_page(page, bh_offset(bh) + ofs,
-						blocksize - ofs, KM_USER0);
+				zero_user_segment(page, bh_offset(bh) + ofs,
+						blocksize);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
 			err = -EIO;
@@ -1269,8 +1267,8 @@ rl_not_mapped_enoent:
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
@@ -1330,7 +1328,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		zero_user_page(*pages, 0, len, KM_USER0);
+		zero_user(*pages, 0, len);
 	}
 	goto out;
 }
@@ -1451,7 +1449,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		zero_user_page(*pages, 0, len, KM_USER0);
+		zero_user(*pages, 0, len);
 	}
 	goto out;
 }
Index: vps/fs/nfs/read.c
===================================================================
--- vps.orig/fs/nfs/read.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/nfs/read.c	2007-06-11 22:33:07.000000000 -0700
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+	zero_user(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninit
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			zero_user_page(*pages, base, remainder, KM_USER0);
+			zero_user(*pages, base, remainder);
 			break;
 		}
-		zero_user_page(*pages, base, pglen, KM_USER0);
+		zero_user(*pages, base, pglen);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
 
 	nfs_list_add_request(new, &one_request);
 	if (NFS_SERVER(inode)->rsize < PAGE_CACHE_SIZE)
@@ -538,7 +538,7 @@ readpage_async_filler(void *data, struct
 		goto out_error;
 
 	if (len < PAGE_CACHE_SIZE)
-		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
 	nfs_pageio_add_request(desc->pgio, new);
 	return 0;
 out_error:
Index: vps/fs/nfs/write.c
===================================================================
--- vps.orig/fs/nfs/write.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/nfs/write.c	2007-06-11 22:33:07.000000000 -0700
@@ -168,7 +168,7 @@ static void nfs_mark_uptodate(struct pag
 	if (count != nfs_page_length(page))
 		return;
 	if (count != PAGE_CACHE_SIZE)
-		zero_user_page(page, count, PAGE_CACHE_SIZE - count, KM_USER0);
+		zero_user_segment(page, count, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 }
 
Index: vps/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- vps.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/xfs/linux-2.6/xfs_lrw.c	2007-06-11 22:33:07.000000000 -0700
@@ -154,7 +154,7 @@ xfs_iozero(
 		if (status)
 			break;
 
-		zero_user_page(page, offset, bytes, KM_USER0);
+		zero_user(page, offset, bytes);
 
 		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
 					page, fsdata);
Index: vps/fs/ecryptfs/mmap.c
===================================================================
--- vps.orig/fs/ecryptfs/mmap.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/ecryptfs/mmap.c	2007-06-11 22:33:07.000000000 -0700
@@ -370,8 +370,7 @@ static int fill_zeros_to_end_of_page(str
 	end_byte_in_page = i_size_read(inode) % PAGE_CACHE_SIZE;
 	if (to > end_byte_in_page)
 		end_byte_in_page = to;
-	zero_user_page(page, end_byte_in_page,
-		PAGE_CACHE_SIZE - end_byte_in_page, KM_USER0);
+	zero_user_segment(page, end_byte_in_page, PAGE_CACHE_SIZE);
 out:
 	return 0;
 }
@@ -784,7 +783,7 @@ int write_zeros(struct file *file, pgoff
 		page_cache_release(tmp_page);
 		goto out;
 	}
-	zero_user_page(tmp_page, start, num_zeros, KM_USER0);
+	zero_user(tmp_page, start, num_zeros);
 	rc = ecryptfs_commit_write(file, tmp_page, start, start + num_zeros);
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to write zero's "
Index: vps/fs/gfs2/bmap.c
===================================================================
--- vps.orig/fs/gfs2/bmap.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/gfs2/bmap.c	2007-06-11 22:33:07.000000000 -0700
@@ -932,7 +932,7 @@ static int gfs2_block_truncate_page(stru
 	if (sdp->sd_args.ar_data == GFS2_DATA_ORDERED || gfs2_is_jdata(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 
 unlock:
 	unlock_page(page);
Index: vps/fs/ocfs2/aops.c
===================================================================
--- vps.orig/fs/ocfs2/aops.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/ocfs2/aops.c	2007-06-11 22:33:07.000000000 -0700
@@ -238,7 +238,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		zero_user_page(page, 0, PAGE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_SIZE);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
Index: vps/fs/reiser4/plugin/file/cryptcompress.c
===================================================================
--- vps.orig/fs/reiser4/plugin/file/cryptcompress.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/reiser4/plugin/file/cryptcompress.c	2007-06-11 22:33:07.000000000 -0700
@@ -1933,7 +1933,7 @@ static int write_hole(struct inode *inod
 
 		to_pg = min_count(PAGE_CACHE_SIZE - pg_off, cl_count);
 		lock_page(page);
-		zero_user_page(page, pg_off, to_pg, KM_USER0);
+		zero_user(page, pg_off, to_pg);
 		SetPageUptodate(page);
 		unlock_page(page);
 
@@ -2169,8 +2169,7 @@ static int read_some_cluster_pages(struc
 			off = off_to_pgoff(win->off+win->count+win->delta);
 			if (off) {
 				lock_page(pg);
-				zero_user_page(pg, off, PAGE_CACHE_SIZE - off,
-						KM_USER0);
+				zero_user_segment(pg, off, PAGE_CACHE_SIZE);
 				unlock_page(pg);
 			}
 		}
@@ -2217,8 +2216,7 @@ static int read_some_cluster_pages(struc
 
 			offset =
 			    off_to_pgoff(win->off + win->count + win->delta);
-			zero_user_page(pg, offset, PAGE_CACHE_SIZE - offset,
-					KM_USER0);
+			zero_user_segment(pg, offset, PAGE_CACHE_SIZE);
 			unlock_page(pg);
 			/* still not uptodate */
 			break;
Index: vps/fs/reiser4/plugin/file/file.c
===================================================================
--- vps.orig/fs/reiser4/plugin/file/file.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/reiser4/plugin/file/file.c	2007-06-11 22:33:07.000000000 -0700
@@ -538,7 +538,7 @@ static int shorten_file(struct inode *in
 
 	lock_page(page);
 	assert("vs-1066", PageLocked(page));
-	zero_user_page(page, padd_from, PAGE_CACHE_SIZE - padd_from, KM_USER0);
+	zero_user_segment(page, padd_from, PAGE_CACHE_SIZE);
 	unlock_page(page);
 	page_cache_release(page);
 	/* the below does up(sbinfo->delete_mutex). Do not get confused */
Index: vps/fs/reiser4/plugin/item/ctail.c
===================================================================
--- vps.orig/fs/reiser4/plugin/item/ctail.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/reiser4/plugin/item/ctail.c	2007-06-11 22:33:07.000000000 -0700
@@ -627,7 +627,7 @@ int do_readpage_ctail(struct inode * ino
 #endif
 	case FAKE_DISK_CLUSTER:
 		/* fill the page by zeroes */
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 		break;
 	case PREP_DISK_CLUSTER:
Index: vps/fs/reiser4/plugin/item/extent_file_ops.c
===================================================================
--- vps.orig/fs/reiser4/plugin/item/extent_file_ops.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/reiser4/plugin/item/extent_file_ops.c	2007-06-11 22:33:07.000000000 -0700
@@ -1112,7 +1112,7 @@ int reiser4_do_readpage_extent(reiser4_e
 		 */
 		j = jfind(mapping, index);
 		if (j == NULL) {
-			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			zero_user(page, 0, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 			unlock_page(page);
 			return 0;
@@ -1127,7 +1127,7 @@ int reiser4_do_readpage_extent(reiser4_e
 		block = *jnode_get_io_block(j);
 		spin_unlock_jnode(j);
 		if (block == 0) {
-			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			zero_user(page, 0, PAGE_CACHE_SIZE);
 			SetPageUptodate(page);
 			unlock_page(page);
 			jput(j);
Index: vps/fs/reiser4/plugin/item/tail.c
===================================================================
--- vps.orig/fs/reiser4/plugin/item/tail.c	2007-06-11 22:33:01.000000000 -0700
+++ vps/fs/reiser4/plugin/item/tail.c	2007-06-11 22:33:07.000000000 -0700
@@ -392,8 +392,7 @@ static int do_readpage_tail(uf_coord_t *
 
  done:
 	if (mapped != PAGE_CACHE_SIZE)
-		zero_user_page(page, mapped, PAGE_CACHE_SIZE - mapped,
-				KM_USER0);
+		zero_user_segment(page, mapped, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
  out_unlock_page:
 	unlock_page(page);

-- 
