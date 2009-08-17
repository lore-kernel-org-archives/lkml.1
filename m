Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZHQKeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZHQKeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZHQKel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:34:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44343 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558AbZHQKee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:34:34 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: zach.brown@oracle.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/3] direct-io: make O_DIRECT IO path be page based
Date: Mon, 17 Aug 2009 12:34:32 +0200
Message-Id: <1250505274-17108-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.53.g3f55e
In-Reply-To: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
References: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we pass in the iovec array and let the O_DIRECT core
handle the get_user_pages() business. This work, but it means that
we can ever only use user pages for O_DIRECT.

Switch the aops->direct_IO() and below code to use page arrays
instead, so that it doesn't make any assumptions about who the pages
belong to. This works directly for all users but NFS, which just
uses the same helper that the generic mapping read/write functions
also call.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/block_dev.c              |    5 +-
 fs/btrfs/inode.c            |    3 +-
 fs/direct-io.c              |  335 +++++++++++++++++++------------------------
 fs/ext2/inode.c             |    8 +-
 fs/ext3/inode.c             |   13 +-
 fs/ext4/inode.c             |   13 +-
 fs/fat/inode.c              |   10 +-
 fs/gfs2/aops.c              |    9 +-
 fs/hfs/inode.c              |    7 +-
 fs/hfsplus/inode.c          |    6 +-
 fs/jfs/inode.c              |    7 +-
 fs/nfs/direct.c             |  171 ++++++++--------------
 fs/nfs/file.c               |    8 +-
 fs/nilfs2/inode.c           |    7 +-
 fs/ocfs2/aops.c             |    7 +-
 fs/reiserfs/inode.c         |    6 +-
 fs/xfs/linux-2.6/xfs_aops.c |   12 +--
 include/linux/fs.h          |   61 ++++++---
 include/linux/nfs_fs.h      |   10 +-
 mm/filemap.c                |    9 +-
 20 files changed, 309 insertions(+), 398 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 94dfda2..9fe4bd6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -166,14 +166,13 @@ blkdev_get_blocks(struct inode *inode, sector_t iblock,
 }
 
 static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+blkdev_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
 	return blockdev_direct_IO_no_locking(rw, iocb, inode, I_BDEV(inode),
-				iov, offset, nr_segs, blkdev_get_blocks, NULL);
+				args, blkdev_get_blocks, NULL);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272b9b2..827dad9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4309,8 +4309,7 @@ out:
 }
 
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+				struct dio_args *args)
 {
 	return -EINVAL;
 }
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8b10b87..b962a39 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -38,12 +38,6 @@
 #include <asm/atomic.h>
 
 /*
- * How many user pages to map in one call to get_user_pages().  This determines
- * the size of a structure on the stack.
- */
-#define DIO_PAGES	64
-
-/*
  * This code generally works in units of "dio_blocks".  A dio_block is
  * somewhere between the hard sector size and the filesystem block size.  it
  * is determined on a per-invocation basis.   When talking to the filesystem
@@ -105,20 +99,13 @@ struct dio {
 	sector_t cur_page_block;	/* Where it starts */
 
 	/*
-	 * Page fetching state. These variables belong to dio_refill_pages().
-	 */
-	int curr_page;			/* changes */
-	int total_pages;		/* doesn't change */
-	unsigned long curr_user_address;/* changes */
-
-	/*
 	 * Page queue.  These variables belong to dio_refill_pages() and
 	 * dio_get_page().
 	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */
-	unsigned head;			/* next page to process */
-	unsigned tail;			/* last valid page + 1 */
-	int page_errors;		/* errno from get_user_pages() */
+	struct page **pages;		/* page buffer */
+	unsigned int head_page;		/* next page to process */
+	unsigned int total_pages;	/* last valid page + 1 */
+	unsigned int first_page_off;	/* offset into first page in map */
 
 	/* BIO completion state */
 	spinlock_t bio_lock;		/* protects BIO fields below */
@@ -134,57 +121,6 @@ struct dio {
 };
 
 /*
- * How many pages are in the queue?
- */
-static inline unsigned dio_pages_present(struct dio *dio)
-{
-	return dio->tail - dio->head;
-}
-
-/*
- * Go grab and pin some userspace pages.   Typically we'll get 64 at a time.
- */
-static int dio_refill_pages(struct dio *dio)
-{
-	int ret;
-	int nr_pages;
-
-	nr_pages = min(dio->total_pages - dio->curr_page, DIO_PAGES);
-	ret = get_user_pages_fast(
-		dio->curr_user_address,		/* Where from? */
-		nr_pages,			/* How many pages? */
-		dio->rw == READ,		/* Write to memory? */
-		&dio->pages[0]);		/* Put results here */
-
-	if (ret < 0 && dio->blocks_available && (dio->rw & WRITE)) {
-		struct page *page = ZERO_PAGE(0);
-		/*
-		 * A memory fault, but the filesystem has some outstanding
-		 * mapped blocks.  We need to use those blocks up to avoid
-		 * leaking stale data in the file.
-		 */
-		if (dio->page_errors == 0)
-			dio->page_errors = ret;
-		page_cache_get(page);
-		dio->pages[0] = page;
-		dio->head = 0;
-		dio->tail = 1;
-		ret = 0;
-		goto out;
-	}
-
-	if (ret >= 0) {
-		dio->curr_user_address += ret * PAGE_SIZE;
-		dio->curr_page += ret;
-		dio->head = 0;
-		dio->tail = ret;
-		ret = 0;
-	}
-out:
-	return ret;	
-}
-
-/*
  * Get another userspace page.  Returns an ERR_PTR on error.  Pages are
  * buffered inside the dio so that we can call get_user_pages() against a
  * decent number of pages, less frequently.  To provide nicer use of the
@@ -192,15 +128,10 @@ out:
  */
 static struct page *dio_get_page(struct dio *dio)
 {
-	if (dio_pages_present(dio) == 0) {
-		int ret;
+	if (dio->head_page < dio->total_pages)
+		return dio->pages[dio->head_page++];
 
-		ret = dio_refill_pages(dio);
-		if (ret)
-			return ERR_PTR(ret);
-		BUG_ON(dio_pages_present(dio) == 0);
-	}
-	return dio->pages[dio->head++];
+	return NULL;
 }
 
 /**
@@ -245,8 +176,6 @@ static int dio_complete(struct dio *dio, loff_t offset, int ret)
 		up_read_non_owner(&dio->inode->i_alloc_sem);
 
 	if (ret == 0)
-		ret = dio->page_errors;
-	if (ret == 0)
 		ret = dio->io_error;
 	if (ret == 0)
 		ret = transferred;
@@ -351,8 +280,10 @@ static void dio_bio_submit(struct dio *dio)
  */
 static void dio_cleanup(struct dio *dio)
 {
-	while (dio_pages_present(dio))
-		page_cache_release(dio_get_page(dio));
+	struct page *page;
+
+	while ((page = dio_get_page(dio)) != NULL)
+		page_cache_release(page);
 }
 
 /*
@@ -490,7 +421,6 @@ static int dio_bio_reap(struct dio *dio)
  */
 static int get_more_blocks(struct dio *dio)
 {
-	int ret;
 	struct buffer_head *map_bh = &dio->map_bh;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
@@ -502,38 +432,33 @@ static int get_more_blocks(struct dio *dio)
 	 * If there was a memory error and we've overwritten all the
 	 * mapped blocks then we can now return that memory error
 	 */
-	ret = dio->page_errors;
-	if (ret == 0) {
-		BUG_ON(dio->block_in_file >= dio->final_block_in_request);
-		fs_startblk = dio->block_in_file >> dio->blkfactor;
-		dio_count = dio->final_block_in_request - dio->block_in_file;
-		fs_count = dio_count >> dio->blkfactor;
-		blkmask = (1 << dio->blkfactor) - 1;
-		if (dio_count & blkmask)	
-			fs_count++;
-
-		map_bh->b_state = 0;
-		map_bh->b_size = fs_count << dio->inode->i_blkbits;
-
-		create = dio->rw & WRITE;
-		if (dio->lock_type == DIO_LOCKING) {
-			if (dio->block_in_file < (i_size_read(dio->inode) >>
-							dio->blkbits))
-				create = 0;
-		} else if (dio->lock_type == DIO_NO_LOCKING) {
+	BUG_ON(dio->block_in_file >= dio->final_block_in_request);
+	fs_startblk = dio->block_in_file >> dio->blkfactor;
+	dio_count = dio->final_block_in_request - dio->block_in_file;
+	fs_count = dio_count >> dio->blkfactor;
+	blkmask = (1 << dio->blkfactor) - 1;
+	if (dio_count & blkmask)
+		fs_count++;
+
+	map_bh->b_state = 0;
+	map_bh->b_size = fs_count << dio->inode->i_blkbits;
+
+	create = dio->rw & WRITE;
+	if (dio->lock_type == DIO_LOCKING) {
+		if (dio->block_in_file < (i_size_read(dio->inode) >>
+						dio->blkbits))
 			create = 0;
-		}
-
-		/*
-		 * For writes inside i_size we forbid block creations: only
-		 * overwrites are permitted.  We fall back to buffered writes
-		 * at a higher level for inside-i_size block-instantiating
-		 * writes.
-		 */
-		ret = (*dio->get_block)(dio->inode, fs_startblk,
-						map_bh, create);
+	} else if (dio->lock_type == DIO_NO_LOCKING) {
+		create = 0;
 	}
-	return ret;
+
+	/*
+	 * For writes inside i_size we forbid block creations: only
+	 * overwrites are permitted.  We fall back to buffered writes
+	 * at a higher level for inside-i_size block-instantiating
+	 * writes.
+	 */
+	return dio->get_block(dio->inode, fs_startblk, map_bh, create);
 }
 
 /*
@@ -567,8 +492,8 @@ static int dio_bio_add_page(struct dio *dio)
 {
 	int ret;
 
-	ret = bio_add_page(dio->bio, dio->cur_page,
-			dio->cur_page_len, dio->cur_page_offset);
+	ret = bio_add_page(dio->bio, dio->cur_page, dio->cur_page_len,
+				dio->cur_page_offset);
 	if (ret == dio->cur_page_len) {
 		/*
 		 * Decrement count only, if we are done with this page
@@ -804,6 +729,9 @@ static int do_direct_IO(struct dio *dio)
 			unsigned this_chunk_blocks;	/* # of blocks */
 			unsigned u;
 
+			offset_in_page += dio->first_page_off;
+			dio->first_page_off = 0;
+
 			if (dio->blocks_available == 0) {
 				/*
 				 * Need to go and map some more disk
@@ -929,23 +857,19 @@ out:
  * Releases both i_mutex and i_alloc_sem
  */
 static ssize_t
-direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
-	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-	struct dio *dio)
+direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
+	struct dio_args *args, unsigned blkbits, get_block_t get_block,
+	dio_iodone_t end_io, struct dio *dio)
 {
-	unsigned long user_addr; 
 	unsigned long flags;
-	int seg;
 	ssize_t ret = 0;
 	ssize_t ret2;
-	size_t bytes;
 
 	dio->inode = inode;
 	dio->rw = rw;
 	dio->blkbits = blkbits;
 	dio->blkfactor = inode->i_blkbits - blkbits;
-	dio->block_in_file = offset >> blkbits;
+	dio->block_in_file = args->offset >> blkbits;
 
 	dio->get_block = get_block;
 	dio->end_io = end_io;
@@ -965,45 +889,28 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	if (unlikely(dio->blkfactor))
 		dio->pages_in_io = 2;
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		dio->pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
-				- user_addr/PAGE_SIZE);
-	}
+	dio->pages_in_io += args->nr_pages;
+	dio->size = args->length;
+	if (args->user_addr) {
+		dio->first_page_off = args->user_addr & ~PAGE_MASK;
+		dio->first_block_in_page = dio->first_page_off >> blkbits;
+		if (dio->first_block_in_page)
+			dio->first_page_off -= 1 << blkbits;
+	} else
+		dio->first_page_off = args->first_page_off;
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		dio->size += bytes = iov[seg].iov_len;
-
-		/* Index into the first page of the first block */
-		dio->first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
-		dio->final_block_in_request = dio->block_in_file +
-						(bytes >> blkbits);
-		/* Page fetching state */
-		dio->head = 0;
-		dio->tail = 0;
-		dio->curr_page = 0;
-
-		dio->total_pages = 0;
-		if (user_addr & (PAGE_SIZE-1)) {
-			dio->total_pages++;
-			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
-		}
-		dio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		dio->curr_user_address = user_addr;
-	
-		ret = do_direct_IO(dio);
+	dio->final_block_in_request = dio->block_in_file + (dio->size >> blkbits);
+	dio->head_page = 0;
+	dio->total_pages = args->nr_pages;
+
+	ret = do_direct_IO(dio);
 
-		dio->result += iov[seg].iov_len -
+	dio->result += args->length -
 			((dio->final_block_in_request - dio->block_in_file) <<
 					blkbits);
 
-		if (ret) {
-			dio_cleanup(dio);
-			break;
-		}
-	} /* end iovec loop */
+	if (ret)
+		dio_cleanup(dio);
 
 	if (ret == -ENOTBLK && (rw & WRITE)) {
 		/*
@@ -1076,7 +983,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (ret2 == 0) {
-		ret = dio_complete(dio, offset, ret);
+		ret = dio_complete(dio, args->offset, ret);
 		kfree(dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
@@ -1107,18 +1014,14 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
  */
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	int dio_lock_type)
+	struct block_device *bdev, struct dio_args *args, get_block_t get_block,
+	dio_iodone_t end_io, int dio_lock_type)
 {
-	int seg;
-	size_t size;
-	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
 	unsigned bdev_blkbits = 0;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
-	loff_t end = offset;
+	loff_t end = args->offset;
 	struct dio *dio;
 	int release_i_mutex = 0;
 	int acquire_i_mutex = 0;
@@ -1129,26 +1032,23 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (bdev)
 		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
 
-	if (offset & blocksize_mask) {
+	if (args->offset & blocksize_mask) {
 		if (bdev)
 			 blkbits = bdev_blkbits;
 		blocksize_mask = (1 << blkbits) - 1;
-		if (offset & blocksize_mask)
+		if (args->offset & blocksize_mask)
 			goto out;
 	}
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < nr_segs; seg++) {
-		addr = (unsigned long)iov[seg].iov_base;
-		size = iov[seg].iov_len;
-		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))  {
-			if (bdev)
-				 blkbits = bdev_blkbits;
-			blocksize_mask = (1 << blkbits) - 1;
-			if ((addr & blocksize_mask) || (size & blocksize_mask))  
-				goto out;
-		}
+	if ((args->user_addr & blocksize_mask) ||
+	    (args->length & blocksize_mask))  {
+		if (bdev)
+			 blkbits = bdev_blkbits;
+		blocksize_mask = (1 << blkbits) - 1;
+		if ((args->user_addr & blocksize_mask) ||
+		    (args->length & blocksize_mask))
+			goto out;
 	}
 
 	dio = kzalloc(sizeof(*dio), GFP_KERNEL);
@@ -1156,6 +1056,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (!dio)
 		goto out;
 
+	dio->pages = args->pages;
+
 	/*
 	 * For block device access DIO_NO_LOCKING is used,
 	 *	neither readers nor writers do any locking at all
@@ -1166,9 +1068,9 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 *	neither readers nor writers take any locks here
 	 */
 	dio->lock_type = dio_lock_type;
-	if (dio_lock_type != DIO_NO_LOCKING) {
+	if (dio->lock_type != DIO_NO_LOCKING) {
 		/* watch out for a 0 len io from a tricksy fs */
-		if (rw == READ && end > offset) {
+		if (rw == READ && end > args->offset) {
 			struct address_space *mapping;
 
 			mapping = iocb->ki_filp->f_mapping;
@@ -1177,8 +1079,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 				release_i_mutex = 1;
 			}
 
-			retval = filemap_write_and_wait_range(mapping, offset,
-							      end - 1);
+			retval = filemap_write_and_wait_range(mapping,
+							args->offset, end - 1);
 			if (retval) {
 				kfree(dio);
 				goto out;
@@ -1204,8 +1106,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
 		(end > i_size_read(inode)));
 
-	retval = direct_io_worker(rw, iocb, inode, iov, offset,
-				nr_segs, blkbits, get_block, end_io, dio);
+	retval = direct_io_worker(rw, iocb, inode, args, blkbits, get_block,
+					end_io, dio);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -1220,7 +1122,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 			vmtruncate(inode, isize);
 	}
 
-	if (rw == READ && dio_lock_type == DIO_LOCKING)
+	if (rw == READ && dio->lock_type == DIO_LOCKING)
 		release_i_mutex = 0;
 
 out:
@@ -1230,4 +1132,69 @@ out:
 		mutex_lock(&inode->i_mutex);
 	return retval;
 }
-EXPORT_SYMBOL(__blockdev_direct_IO);
+EXPORT_SYMBOL_GPL(__blockdev_direct_IO);
+
+static ssize_t __do_dio(int rw, struct address_space *mapping,
+			struct kiocb *kiocb, const struct iovec *iov,
+			loff_t offset, dio_io_actor actor)
+{
+	struct page *stack_pages[UIO_FASTIOV];
+	unsigned long nr_pages, start, end;
+	struct dio_args args = {
+		.pages		= stack_pages,
+		.length		= iov->iov_len,
+		.user_addr	= (unsigned long) iov->iov_base,
+		.offset		= offset,
+	};
+	ssize_t ret;
+
+	end = (args.user_addr + iov->iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = args.user_addr >> PAGE_SHIFT;
+	nr_pages = end - start;
+
+	if (nr_pages >= UIO_FASTIOV) {
+		args.pages = kzalloc(nr_pages * sizeof(struct page *),
+					GFP_KERNEL);
+		if (!args.pages)
+			return -ENOMEM;
+	}
+
+	ret = get_user_pages_fast(args.user_addr, nr_pages, rw == READ,
+					args.pages);
+	if (ret > 0) {
+		args.nr_pages = ret;
+		ret = actor(rw, kiocb, &args);
+	}
+
+	if (args.pages != stack_pages)
+		kfree(args.pages);
+
+	return ret;
+}
+
+/*
+ * Transform the iov into a page based structure for passing into the lower
+ * parts of O_DIRECT handling
+ */
+ssize_t do_dio(int rw, struct address_space *mapping, struct kiocb *kiocb,
+	       const struct iovec *iov, loff_t offset, unsigned long nr_segs,
+	       dio_io_actor actor)
+{
+	ssize_t ret = 0, ret2;
+	unsigned long i;
+
+	for (i = 0; i < nr_segs; i++) {
+		ret2 = __do_dio(rw, mapping, kiocb, iov, offset, actor);
+		if (ret2 < 0) {
+			if (!ret)
+				ret = ret2;
+			break;
+		}
+		iov++;
+		offset += ret2;
+		ret += ret2;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(do_dio);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e271303..577d2df 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -790,15 +790,13 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping,block,ext2_get_block);
 }
 
-static ssize_t
-ext2_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+static ssize_t ext2_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				offset, nr_segs, ext2_get_block, NULL);
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
+					ext2_get_block, NULL);
 }
 
 static int
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b49908a..40152fb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1713,9 +1713,7 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1723,10 +1721,10 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = args->length;
 
 	if (rw == WRITE) {
-		loff_t final_size = offset + count;
+		loff_t final_size = args->offset + count;
 
 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
@@ -1746,8 +1744,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 		}
 	}
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
 				 ext3_get_block, NULL);
 
 	if (orphan) {
@@ -1765,7 +1762,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 		if (inode->i_nlink)
 			ext3_orphan_del(handle, inode);
 		if (ret > 0) {
-			loff_t end = offset + ret;
+			loff_t end = args->offset + ret;
 			if (end > inode->i_size) {
 				ei->i_disksize = end;
 				i_size_write(inode, end);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9c642b..724142a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3267,9 +3267,7 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -3277,10 +3275,10 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = args->length;
 
 	if (rw == WRITE) {
-		loff_t final_size = offset + count;
+		loff_t final_size = args->offset + count;
 
 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
@@ -3300,8 +3298,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 		}
 	}
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
 				 ext4_get_block, NULL);
 
 	if (orphan) {
@@ -3319,7 +3316,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 		if (inode->i_nlink)
 			ext4_orphan_del(handle, inode);
 		if (ret > 0) {
-			loff_t end = offset + ret;
+			loff_t end = args->offset + ret;
 			if (end > inode->i_size) {
 				ei->i_disksize = end;
 				i_size_write(inode, end);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8970d8c..9b60d66 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -167,9 +167,7 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 	return err;
 }
 
-static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+static ssize_t fat_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -184,7 +182,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		 *
 		 * Return 0, and fallback to normal buffered write.
 		 */
-		loff_t size = offset + iov_length(iov, nr_segs);
+		loff_t size = args->offset + args->length;
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
 	}
@@ -193,8 +191,8 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, fat_get_block, NULL);
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
+				  fat_get_block, NULL);
 }
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 7ebae9a..cc3ce59 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1021,9 +1021,7 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 
 
 
-static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1043,13 +1041,12 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	rv = gfs2_glock_nq(&gh);
 	if (rv)
 		return rv;
-	rv = gfs2_ok_for_dio(ip, rw, offset);
+	rv = gfs2_ok_for_dio(ip, rw, args->offset);
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
 	rv = blockdev_direct_IO_no_locking(rw, iocb, inode, inode->i_sb->s_bdev,
-					   iov, offset, nr_segs,
-					   gfs2_get_block_direct, NULL);
+					   args, gfs2_get_block_direct, NULL);
 out:
 	gfs2_glock_dq_m(1, &gh);
 	gfs2_holder_uninit(&gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a1cbff2..9363fd6 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -107,14 +107,13 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, hfs_get_block, NULL);
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
+				  hfs_get_block, NULL);
 }
 
 static int hfs_writepages(struct address_space *mapping,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1bcf597..bb4a703 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -101,13 +101,13 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+				 struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, hfsplus_get_block, NULL);
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
+				  hfsplus_get_block, NULL);
 }
 
 static int hfsplus_writepages(struct address_space *mapping,
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index b2ae190..b83409a 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -306,14 +306,13 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, jfs_get_block);
 }
 
-static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				offset, nr_segs, jfs_get_block, NULL);
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
+					jfs_get_block, NULL);
 }
 
 const struct address_space_operations jfs_aops = {
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e4e089a..aff6169 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -104,20 +104,18 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
  * nfs_direct_IO - NFS address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
- * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
+ * @args: direct IO arguments
  *
  * The presence of this routine in the address space ops vector means
  * the NFS client supports direct I/O.  However, we shunt off direct
  * read and write requests before the VFS gets them, so this method
  * should never be called.
  */
-ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
+ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
-	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
+	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
-			(long long) pos, nr_segs);
+			(long long) args->offset);
 
 	return -EINVAL;
 }
@@ -274,13 +272,12 @@ static const struct rpc_call_ops nfs_read_direct_ops = {
  * no requests have been sent, just return an error.
  */
 static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
-						const struct iovec *iov,
-						loff_t pos)
+						struct dio_args *args)
 {
 	struct nfs_open_context *ctx = dreq->ctx;
 	struct inode *inode = ctx->path.dentry->d_inode;
-	unsigned long user_addr = (unsigned long)iov->iov_base;
-	size_t count = iov->iov_len;
+	unsigned long user_addr = args->user_addr;
+	size_t count = args->length;
 	size_t rsize = NFS_SERVER(inode)->rsize;
 	struct rpc_task *task;
 	struct rpc_message msg = {
@@ -309,24 +306,8 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 		if (unlikely(!data))
 			break;
 
-		down_read(&current->mm->mmap_sem);
-		result = get_user_pages(current, current->mm, user_addr,
-					data->npages, 1, 0, data->pagevec, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (result < 0) {
-			nfs_readdata_free(data);
-			break;
-		}
-		if ((unsigned)result < data->npages) {
-			bytes = result * PAGE_SIZE;
-			if (bytes <= pgbase) {
-				nfs_direct_release_pages(data->pagevec, result);
-				nfs_readdata_free(data);
-				break;
-			}
-			bytes -= pgbase;
-			data->npages = result;
-		}
+		data->pagevec = args->pages;
+		data->npages = args->nr_pages;
 
 		get_dreq(dreq);
 
@@ -335,7 +316,7 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 		data->cred = msg.rpc_cred;
 		data->args.fh = NFS_FH(inode);
 		data->args.context = ctx;
-		data->args.offset = pos;
+		data->args.offset = args->offset;
 		data->args.pgbase = pgbase;
 		data->args.pages = data->pagevec;
 		data->args.count = bytes;
@@ -364,7 +345,7 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 
 		started += bytes;
 		user_addr += bytes;
-		pos += bytes;
+		args->offset += bytes;
 		/* FIXME: Remove this unnecessary math from final patch */
 		pgbase += bytes;
 		pgbase &= ~PAGE_MASK;
@@ -379,26 +360,19 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 }
 
 static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
-					      const struct iovec *iov,
-					      unsigned long nr_segs,
-					      loff_t pos)
+					      struct dio_args *args)
 {
 	ssize_t result = -EINVAL;
 	size_t requested_bytes = 0;
-	unsigned long seg;
 
 	get_dreq(dreq);
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *vec = &iov[seg];
-		result = nfs_direct_read_schedule_segment(dreq, vec, pos);
-		if (result < 0)
-			break;
-		requested_bytes += result;
-		if ((size_t)result < vec->iov_len)
-			break;
-		pos += vec->iov_len;
-	}
+	result = nfs_direct_read_schedule_segment(dreq, args);
+	if (result < 0)
+		goto out;
+
+	requested_bytes += result;
+	args += result;
 
 	if (put_dreq(dreq))
 		nfs_direct_complete(dreq);
@@ -406,13 +380,13 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	if (requested_bytes != 0)
 		return 0;
 
+out:
 	if (result < 0)
 		return result;
 	return -EIO;
 }
 
-static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t pos)
+static ssize_t nfs_direct_read(struct kiocb *iocb, struct dio_args *args)
 {
 	ssize_t result = 0;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -427,7 +401,7 @@ static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	result = nfs_direct_read_schedule_iovec(dreq, iov, nr_segs, pos);
+	result = nfs_direct_read_schedule_iovec(dreq, args);
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	nfs_direct_req_release(dreq);
@@ -694,13 +668,13 @@ static const struct rpc_call_ops nfs_write_direct_ops = {
  * no requests have been sent, just return an error.
  */
 static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
-						 const struct iovec *iov,
-						 loff_t pos, int sync)
+						 struct dio_args *args,
+						 int sync)
 {
 	struct nfs_open_context *ctx = dreq->ctx;
 	struct inode *inode = ctx->path.dentry->d_inode;
-	unsigned long user_addr = (unsigned long)iov->iov_base;
-	size_t count = iov->iov_len;
+	unsigned long user_addr = args->user_addr;
+	size_t count = args->length;
 	struct rpc_task *task;
 	struct rpc_message msg = {
 		.rpc_cred = ctx->cred,
@@ -729,24 +703,8 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 		if (unlikely(!data))
 			break;
 
-		down_read(&current->mm->mmap_sem);
-		result = get_user_pages(current, current->mm, user_addr,
-					data->npages, 0, 0, data->pagevec, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (result < 0) {
-			nfs_writedata_free(data);
-			break;
-		}
-		if ((unsigned)result < data->npages) {
-			bytes = result * PAGE_SIZE;
-			if (bytes <= pgbase) {
-				nfs_direct_release_pages(data->pagevec, result);
-				nfs_writedata_free(data);
-				break;
-			}
-			bytes -= pgbase;
-			data->npages = result;
-		}
+		data->pagevec = args->pages;
+		data->npages = args->nr_pages;
 
 		get_dreq(dreq);
 
@@ -757,7 +715,7 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 		data->cred = msg.rpc_cred;
 		data->args.fh = NFS_FH(inode);
 		data->args.context = ctx;
-		data->args.offset = pos;
+		data->args.offset = args->offset;
 		data->args.pgbase = pgbase;
 		data->args.pages = data->pagevec;
 		data->args.count = bytes;
@@ -787,7 +745,7 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 
 		started += bytes;
 		user_addr += bytes;
-		pos += bytes;
+		args->offset += bytes;
 
 		/* FIXME: Remove this useless math from the final patch */
 		pgbase += bytes;
@@ -803,27 +761,19 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 }
 
 static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
-					       const struct iovec *iov,
-					       unsigned long nr_segs,
-					       loff_t pos, int sync)
+					       struct dio_args *args, int sync)
 {
 	ssize_t result = 0;
 	size_t requested_bytes = 0;
-	unsigned long seg;
 
 	get_dreq(dreq);
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		const struct iovec *vec = &iov[seg];
-		result = nfs_direct_write_schedule_segment(dreq, vec,
-							   pos, sync);
-		if (result < 0)
-			break;
-		requested_bytes += result;
-		if ((size_t)result < vec->iov_len)
-			break;
-		pos += vec->iov_len;
-	}
+	result = nfs_direct_write_schedule_segment(dreq, args, sync);
+	if (result < 0)
+		goto out;
+
+	requested_bytes += result;
+	args->offset += result;
 
 	if (put_dreq(dreq))
 		nfs_direct_write_complete(dreq, dreq->inode);
@@ -831,14 +781,13 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	if (requested_bytes != 0)
 		return 0;
 
+out:
 	if (result < 0)
 		return result;
 	return -EIO;
 }
 
-static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos,
-				size_t count)
+static ssize_t nfs_direct_write(struct kiocb *iocb, struct dio_args *args)
 {
 	ssize_t result = 0;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -851,7 +800,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		return -ENOMEM;
 	nfs_alloc_commit_data(dreq);
 
-	if (dreq->commit_data == NULL || count < wsize)
+	if (dreq->commit_data == NULL || args->length < wsize)
 		sync = NFS_FILE_SYNC;
 
 	dreq->inode = inode;
@@ -859,7 +808,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	result = nfs_direct_write_schedule_iovec(dreq, iov, nr_segs, pos, sync);
+	result = nfs_direct_write_schedule_iovec(dreq, args, sync);
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	nfs_direct_req_release(dreq);
@@ -870,9 +819,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
 /**
  * nfs_file_direct_read - file direct read operation for NFS files
  * @iocb: target I/O control block
- * @iov: vector of user buffers into which to read data
- * @nr_segs: size of iov vector
- * @pos: byte offset in file where reading starts
+ * @args: direct IO arguments
  *
  * We use this function for direct reads instead of calling
  * generic_file_aio_read() in order to avoid gfar's check to see if
@@ -888,21 +835,20 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
  * client must read the updated atime from the server back into its
  * cache.
  */
-ssize_t nfs_file_direct_read(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
+static ssize_t nfs_file_direct_read(struct kiocb *iocb, struct dio_args *args)
 {
 	ssize_t retval = -EINVAL;
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	size_t count;
 
-	count = iov_length(iov, nr_segs);
+	count = args->length;
 	nfs_add_stats(mapping->host, NFSIOS_DIRECTREADBYTES, count);
 
 	dfprintk(FILE, "NFS: direct read(%s/%s, %zd@%Ld)\n",
 		file->f_path.dentry->d_parent->d_name.name,
 		file->f_path.dentry->d_name.name,
-		count, (long long) pos);
+		count, (long long) args->offset);
 
 	retval = 0;
 	if (!count)
@@ -912,9 +858,9 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, const struct iovec *iov,
 	if (retval)
 		goto out;
 
-	retval = nfs_direct_read(iocb, iov, nr_segs, pos);
+	retval = nfs_direct_read(iocb, args);
 	if (retval > 0)
-		iocb->ki_pos = pos + retval;
+		iocb->ki_pos = args->offset + retval;
 
 out:
 	return retval;
@@ -923,9 +869,7 @@ out:
 /**
  * nfs_file_direct_write - file direct write operation for NFS files
  * @iocb: target I/O control block
- * @iov: vector of user buffers from which to write data
- * @nr_segs: size of iov vector
- * @pos: byte offset in file where writing starts
+ * @args: direct IO arguments
  *
  * We use this function for direct writes instead of calling
  * generic_file_aio_write() in order to avoid taking the inode
@@ -945,23 +889,22 @@ out:
  * Note that O_APPEND is not supported for NFS direct writes, as there
  * is no atomic O_APPEND write facility in the NFS protocol.
  */
-ssize_t nfs_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
+static ssize_t nfs_file_direct_write(struct kiocb *iocb, struct dio_args *args)
 {
 	ssize_t retval = -EINVAL;
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	size_t count;
 
-	count = iov_length(iov, nr_segs);
+	count = args->length;
 	nfs_add_stats(mapping->host, NFSIOS_DIRECTWRITTENBYTES, count);
 
 	dfprintk(FILE, "NFS: direct write(%s/%s, %zd@%Ld)\n",
 		file->f_path.dentry->d_parent->d_name.name,
 		file->f_path.dentry->d_name.name,
-		count, (long long) pos);
+		count, (long long) args->offset);
 
-	retval = generic_write_checks(file, &pos, &count, 0);
+	retval = generic_write_checks(file, &args->offset, &count, 0);
 	if (retval)
 		goto out;
 
@@ -976,15 +919,23 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	if (retval)
 		goto out;
 
-	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count);
+	retval = nfs_direct_write(iocb, args);
 
 	if (retval > 0)
-		iocb->ki_pos = pos + retval;
+		iocb->ki_pos = args->offset + retval;
 
 out:
 	return retval;
 }
 
+ssize_t nfs_file_direct_io(int rw, struct kiocb *kiocb, struct dio_args *args)
+{
+	if (rw == READ)
+		return nfs_file_direct_read(kiocb, args);
+
+	return nfs_file_direct_write(kiocb, args);
+}
+
 /**
  * nfs_init_directcache - create a slab cache for nfs_direct_req structures
  *
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 0506232..56827c4 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -249,13 +249,15 @@ static ssize_t
 nfs_file_read(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 	struct inode * inode = dentry->d_inode;
 	ssize_t result;
 	size_t count = iov_length(iov, nr_segs);
 
 	if (iocb->ki_filp->f_flags & O_DIRECT)
-		return nfs_file_direct_read(iocb, iov, nr_segs, pos);
+		return do_dio(READ, mapping, iocb, iov, pos, nr_segs,
+				nfs_file_direct_io);
 
 	dprintk("NFS: read(%s/%s, %lu@%lu)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
@@ -546,13 +548,15 @@ static int nfs_need_sync_write(struct file *filp, struct inode *inode)
 static ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct dentry * dentry = iocb->ki_filp->f_path.dentry;
 	struct inode * inode = dentry->d_inode;
 	ssize_t result;
 	size_t count = iov_length(iov, nr_segs);
 
 	if (iocb->ki_filp->f_flags & O_DIRECT)
-		return nfs_file_direct_write(iocb, iov, nr_segs, pos);
+		return do_dio(WRITE, mapping, iocb, iov, pos, nr_segs,
+				nfs_file_direct_io);
 
 	dprintk("NFS: write(%s/%s, %lu@%Ld)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index fe9d8f2..6bd9943 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -222,8 +222,7 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		loff_t offset, unsigned long nr_segs)
+nilfs_direct_IO(int rw, struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -233,8 +232,8 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, nilfs_get_block, NULL);
+	size = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
+				  nilfs_get_block, NULL);
 	return size;
 }
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b401654..d19cb3e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -670,9 +670,7 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
-			       const struct iovec *iov,
-			       loff_t offset,
-			       unsigned long nr_segs)
+			       struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
@@ -688,8 +686,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 		return 0;
 
 	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-					    inode->i_sb->s_bdev, iov, offset,
-					    nr_segs, 
+					    inode->i_sb->s_bdev, args,
 					    ocfs2_direct_IO_get_blocks,
 					    ocfs2_dio_end_io);
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a14d6cd..c901ba1 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3026,14 +3026,12 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
 /* We thank Mingming Cao for helping us understand in great detail what
    to do in this section of the code. */
 static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
-				  const struct iovec *iov, loff_t offset,
-				  unsigned long nr_segs)
+				  struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs,
+	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, args,
 				  reiserfs_get_blocks_direct_io, NULL);
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index aecf251..ed2f0f9 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1534,9 +1534,7 @@ STATIC ssize_t
 xfs_vm_direct_IO(
 	int			rw,
 	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	loff_t			offset,
-	unsigned long		nr_segs)
+	struct dio_args		*args)
 {
 	struct file	*file = iocb->ki_filp;
 	struct inode	*inode = file->f_mapping->host;
@@ -1548,15 +1546,11 @@ xfs_vm_direct_IO(
 	if (rw == WRITE) {
 		iocb->private = xfs_alloc_ioend(inode, IOMAP_UNWRITTEN);
 		ret = blockdev_direct_IO_own_locking(rw, iocb, inode,
-			bdev, iov, offset, nr_segs,
-			xfs_get_blocks_direct,
-			xfs_end_io_direct);
+			bdev, args, xfs_get_blocks_direct, xfs_end_io_direct);
 	} else {
 		iocb->private = xfs_alloc_ioend(inode, IOMAP_READ);
 		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-			bdev, iov, offset, nr_segs,
-			xfs_get_blocks_direct,
-			xfs_end_io_direct);
+			bdev, args, xfs_get_blocks_direct, xfs_end_io_direct);
 	}
 
 	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 67888a9..e2c43b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -560,6 +560,7 @@ typedef struct {
 typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
 		unsigned long, unsigned long);
 
+struct dio_args;
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
@@ -585,8 +586,7 @@ struct address_space_operations {
 	sector_t (*bmap)(struct address_space *, sector_t);
 	void (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, gfp_t);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct dio_args *);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/* migrate the contents of a page to the specified target */
@@ -2241,10 +2241,34 @@ static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 #endif
 
 #ifdef CONFIG_BLOCK
+struct dio_args {
+	/*
+	 * Data index. Page array, index into first page, and total length
+	 */
+	struct page **pages;
+	unsigned int first_page_off;
+	unsigned int nr_pages;
+	unsigned long length;
+
+	/*
+	 * Original user pointer
+	 */
+	unsigned long user_addr;
+
+	/*
+	 * Mapping offset
+	 */
+	loff_t offset;
+};
+
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	int lock_type);
+	struct block_device *bdev, struct dio_args *args, get_block_t get_block,
+	dio_iodone_t end_io, int lock_type);
+
+typedef ssize_t (dio_io_actor)(int, struct kiocb *, struct dio_args *);
+
+ssize_t do_dio(int, struct address_space *, struct kiocb *,
+		const struct iovec *, loff_t, unsigned long, dio_io_actor);
 
 enum {
 	DIO_LOCKING = 1, /* need locking between buffered and direct access */
@@ -2253,30 +2277,27 @@ enum {
 };
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+	struct inode *inode, struct block_device *bdev, struct dio_args *args,
+	get_block_t get_block, dio_iodone_t end_io)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_LOCKING);
+	return __blockdev_direct_IO(rw, iocb, inode, bdev, args, get_block,
+					end_io, DIO_LOCKING);
 }
 
 static inline ssize_t blockdev_direct_IO_no_locking(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+	struct inode *inode, struct block_device *bdev, struct dio_args *args,
+	get_block_t get_block, dio_iodone_t end_io)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_NO_LOCKING);
+	return __blockdev_direct_IO(rw, iocb, inode, bdev, args, get_block,
+					end_io, DIO_NO_LOCKING);
 }
 
 static inline ssize_t blockdev_direct_IO_own_locking(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+	struct inode *inode, struct block_device *bdev, struct dio_args *args,
+	get_block_t get_block, dio_iodone_t end_io)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_OWN_LOCKING);
+	return __blockdev_direct_IO(rw, iocb, inode, bdev, args, get_block,
+					end_io, DIO_OWN_LOCKING);
 }
 #endif
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f6b9024..dab9bf9 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -408,14 +408,8 @@ extern int nfs3_removexattr (struct dentry *, const char *name);
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(int, struct kiocb *, const struct iovec *, loff_t,
-			unsigned long);
-extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
-			const struct iovec *iov, unsigned long nr_segs,
-			loff_t pos);
-extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
-			const struct iovec *iov, unsigned long nr_segs,
-			loff_t pos);
+extern ssize_t nfs_direct_IO(int, struct kiocb *, struct dio_args *);
+extern ssize_t nfs_file_direct_io(int, struct kiocb *, struct dio_args *);
 
 /*
  * linux/fs/nfs/dir.c
diff --git a/mm/filemap.c b/mm/filemap.c
index ccea3b6..cd63536 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1345,8 +1345,10 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
-				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
+				dio_io_actor *fn = mapping->a_ops->direct_IO;
+
+				retval = do_dio(READ, mapping, iocb, iov, pos,
+						nr_segs, fn);
 			}
 			if (retval > 0)
 				*ppos = pos + retval;
@@ -2144,7 +2146,8 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	written = do_dio(WRITE, mapping, iocb, iov, pos, *nr_segs,
+				mapping->a_ops->direct_IO);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
-- 
1.6.4.53.g3f55e

