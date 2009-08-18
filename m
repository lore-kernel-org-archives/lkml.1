Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZHRAUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZHRAUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758446AbZHRAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:20:32 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:21058 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758397AbZHRAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:20:31 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/buffer.c: cleaup EXPORT* macros
Date: Mon, 17 Aug 2009 17:20:39 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171720.39444.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/CodingStyle the EXPORT* macro should follow
immediately after the closing function brace line.

Also, mark_buffer_async_write_endio() and do_thaw_all() are not exported
so they should be marked  as static.

In addition, file_fsync() is actually in fs/sync.c so move the EXPORT* to that
file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/buffer.c b/fs/buffer.c
index a3ef091..37fdd06 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -52,6 +52,7 @@ init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 	bh->b_end_io = handler;
 	bh->b_private = private;
 }
+EXPORT_SYMBOL(init_buffer);
 
 static int sync_buffer(void *word)
 {
@@ -80,6 +81,7 @@ void unlock_buffer(struct buffer_head *bh)
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
 }
+EXPORT_SYMBOL(unlock_buffer);
 
 /*
  * Block until a buffer comes unlocked.  This doesn't stop it
@@ -90,6 +92,7 @@ void __wait_on_buffer(struct buffer_head * bh)
 {
 	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
 }
+EXPORT_SYMBOL(__wait_on_buffer);
 
 static void
 __clear_page_buffers(struct page *page)
@@ -144,6 +147,7 @@ void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 	__end_buffer_read_notouch(bh, uptodate);
 	put_bh(bh);
 }
+EXPORT_SYMBOL(end_buffer_read_sync);
 
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
@@ -164,6 +168,7 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	unlock_buffer(bh);
 	put_bh(bh);
 }
+EXPORT_SYMBOL(end_buffer_write_sync);
 
 /*
  * Various filesystems appear to want __find_get_block to be non-blocking.
@@ -272,6 +277,7 @@ void invalidate_bdev(struct block_device *bdev)
 	invalidate_bh_lrus();
 	invalidate_mapping_pages(mapping, 0, -1);
 }
+EXPORT_SYMBOL(invalidate_bdev);
 
 /*
  * Kick pdflush then try to free up some ZONE_NORMAL memory.
@@ -410,6 +416,7 @@ still_busy:
 	local_irq_restore(flags);
 	return;
 }
+EXPORT_SYMBOL(end_buffer_async_write);
 
 /*
  * If a page's buffers are under async readin (end_buffer_async_read
@@ -438,8 +445,8 @@ static void mark_buffer_async_read(struct buffer_head *bh)
 	set_buffer_async_read(bh);
 }
 
-void mark_buffer_async_write_endio(struct buffer_head *bh,
-				   bh_end_io_t *handler)
+static void mark_buffer_async_write_endio(struct buffer_head *bh,
+					  bh_end_io_t *handler)
 {
 	bh->b_end_io = handler;
 	set_buffer_async_write(bh);
@@ -553,7 +560,7 @@ repeat:
 	return err;
 }
 
-void do_thaw_all(struct work_struct *work)
+static void do_thaw_all(struct work_struct *work)
 {
 	struct super_block *sb;
 	char b[BDEVNAME_SIZE];
@@ -1169,6 +1176,7 @@ void mark_buffer_dirty(struct buffer_head *bh)
 			__set_page_dirty(page, page_mapping(page), 0);
 	}
 }
+EXPORT_SYMBOL(mark_buffer_dirty);
 
 /*
  * Decrement a buffer_head's reference count.  If all buffers against a page
@@ -1185,6 +1193,7 @@ void __brelse(struct buffer_head * buf)
 	}
 	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
 }
+EXPORT_SYMBOL(__brelse);
 
 /*
  * bforget() is like brelse(), except it discards any
@@ -1203,6 +1212,7 @@ void __bforget(struct buffer_head *bh)
 	}
 	__brelse(bh);
 }
+EXPORT_SYMBOL(__bforget);
 
 static struct buffer_head *__bread_slow(struct buffer_head *bh)
 {
@@ -2215,6 +2225,7 @@ int block_read_full_page(struct page *page, get_block_t *get_block)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(block_read_full_page);
 
 /* utility function for filesystems that need to do work on expanding
  * truncates.  Uses filesystem pagecache writes to allow the filesystem to
@@ -2249,6 +2260,7 @@ int generic_cont_expand_simple(struct inode *inode, loff_t size)
 out:
 	return err;
 }
+EXPORT_SYMBOL(generic_cont_expand_simple);
 
 static int cont_expand_zero(struct file *file, struct address_space *mapping,
 			    loff_t pos, loff_t *bytes)
@@ -2349,6 +2361,7 @@ int cont_write_begin(struct file *file, struct address_space *mapping,
 out:
 	return err;
 }
+EXPORT_SYMBOL(cont_write_begin);
 
 int block_prepare_write(struct page *page, unsigned from, unsigned to,
 			get_block_t *get_block)
@@ -2359,6 +2372,7 @@ int block_prepare_write(struct page *page, unsigned from, unsigned to,
 		ClearPageUptodate(page);
 	return err;
 }
+EXPORT_SYMBOL(block_prepare_write);
 
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
@@ -2366,6 +2380,7 @@ int block_commit_write(struct page *page, unsigned from, unsigned to)
 	__block_commit_write(inode,page,from,to);
 	return 0;
 }
+EXPORT_SYMBOL(block_commit_write);
 
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
@@ -2423,6 +2438,7 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 out:
 	return ret;
 }
+EXPORT_SYMBOL(block_page_mkwrite);
 
 /*
  * nobh_write_begin()'s prereads are special: the buffer_heads are freed
@@ -2846,6 +2862,7 @@ unlock:
 out:
 	return err;
 }
+EXPORT_SYMBOL(block_truncate_page);
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
@@ -2887,6 +2904,7 @@ int block_write_full_page_endio(struct page *page, get_block_t *get_block,
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	return __block_write_full_page(inode, page, get_block, wbc, handler);
 }
+EXPORT_SYMBOL(block_write_full_page_endio);
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
@@ -2897,7 +2915,7 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 	return block_write_full_page_endio(page, get_block, wbc,
 					   end_buffer_async_write);
 }
-
+EXPORT_SYMBOL(block_write_full_page);
 
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 			    get_block_t *get_block)
@@ -2910,6 +2928,7 @@ sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 	get_block(inode, block, &tmp, 0);
 	return tmp.b_blocknr;
 }
+EXPORT_SYMBOL(generic_block_bmap);
 
 static void end_bio_bh_io_sync(struct bio *bio, int err)
 {
@@ -2979,6 +2998,7 @@ int submit_bh(int rw, struct buffer_head * bh)
 	bio_put(bio);
 	return ret;
 }
+EXPORT_SYMBOL(submit_bh);
 
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
@@ -3040,6 +3060,7 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 		unlock_buffer(bh);
 	}
 }
+EXPORT_SYMBOL(ll_rw_block);
 
 /*
  * For a data-integrity writeout, we need to wait upon any in-progress I/O
@@ -3068,6 +3089,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(sync_dirty_buffer);
 
 /*
  * try_to_free_buffers() checks if all the buffers on this particular page
@@ -3182,6 +3204,7 @@ void block_sync_page(struct page *page)
 	if (mapping)
 		blk_run_backing_dev(mapping->backing_dev_info, page);
 }
+EXPORT_SYMBOL(block_sync_page);
 
 /*
  * There are no bdflush tunables left.  But distributions are
@@ -3358,29 +3381,3 @@ void __init buffer_init(void)
 	max_buffer_heads = nrpages * (PAGE_SIZE / sizeof(struct buffer_head));
 	hotcpu_notifier(buffer_cpu_notify, 0);
 }
-
-EXPORT_SYMBOL(__bforget);
-EXPORT_SYMBOL(__brelse);
-EXPORT_SYMBOL(__wait_on_buffer);
-EXPORT_SYMBOL(block_commit_write);
-EXPORT_SYMBOL(block_prepare_write);
-EXPORT_SYMBOL(block_page_mkwrite);
-EXPORT_SYMBOL(block_read_full_page);
-EXPORT_SYMBOL(block_sync_page);
-EXPORT_SYMBOL(block_truncate_page);
-EXPORT_SYMBOL(block_write_full_page);
-EXPORT_SYMBOL(block_write_full_page_endio);
-EXPORT_SYMBOL(cont_write_begin);
-EXPORT_SYMBOL(end_buffer_read_sync);
-EXPORT_SYMBOL(end_buffer_write_sync);
-EXPORT_SYMBOL(end_buffer_async_write);
-EXPORT_SYMBOL(file_fsync);
-EXPORT_SYMBOL(generic_block_bmap);
-EXPORT_SYMBOL(generic_cont_expand_simple);
-EXPORT_SYMBOL(init_buffer);
-EXPORT_SYMBOL(invalidate_bdev);
-EXPORT_SYMBOL(ll_rw_block);
-EXPORT_SYMBOL(mark_buffer_dirty);
-EXPORT_SYMBOL(submit_bh);
-EXPORT_SYMBOL(sync_dirty_buffer);
-EXPORT_SYMBOL(unlock_buffer);
diff --git a/fs/sync.c b/fs/sync.c
index 3422ba6..fd72561 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -174,6 +174,7 @@ int file_fsync(struct file *filp, struct dentry *dentry, int datasync)
 		ret = err;
 	return ret;
 }
+EXPORT_SYMBOL(file_fsync);
 
 /**
  * vfs_fsync - perform a fsync or fdatasync on a file
