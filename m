Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZHTKSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZHTKSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZHTKSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:18:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60132 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZHTKRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/4] direct-io: make O_DIRECT IO path be page based
Date: Thu, 20 Aug 2009 12:17:38 +0200
Message-Id: <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
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
 fs/direct-io.c         |  304 ++++++++++++++++++++----------------------------
 fs/nfs/direct.c        |  161 +++++++++----------------
 fs/nfs/file.c          |    8 +-
 include/linux/fs.h     |   15 ++-
 include/linux/nfs_fs.h |    7 +-
 mm/filemap.c           |    6 +-
 6 files changed, 206 insertions(+), 295 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 181848c..22a945b 100644
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
@@ -933,13 +861,10 @@ direct_io_worker(struct kiocb *iocb, struct inode *inode,
 	struct dio_args *args, unsigned blkbits, get_block_t get_block,
 	dio_iodone_t end_io, struct dio *dio)
 {
-	const struct iovec *iov = args->iov;
-	unsigned long user_addr;
 	unsigned long flags;
-	int seg, rw = args->rw;
+	int rw = args->rw;
 	ssize_t ret = 0;
 	ssize_t ret2;
-	size_t bytes;
 
 	dio->inode = inode;
 	dio->rw = rw;
@@ -965,46 +890,25 @@ direct_io_worker(struct kiocb *iocb, struct inode *inode,
 	if (unlikely(dio->blkfactor))
 		dio->pages_in_io = 2;
 
-	for (seg = 0; seg < args->nr_segs; seg++) {
-		user_addr = (unsigned long) iov[seg].iov_base;
-		dio->pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
-				- user_addr/PAGE_SIZE);
-	}
+	dio->pages_in_io += args->nr_segs;
+	dio->size = args->length;
+	if (args->user_addr) {
+		dio->first_page_off = args->user_addr & ~PAGE_MASK;
+		dio->first_block_in_page = dio->first_page_off >> blkbits;
+		if (dio->first_block_in_page)
+			dio->first_page_off -= 1 << blkbits;
+	} else
+		dio->first_page_off = args->first_page_off;
 
-	for (seg = 0; seg < args->nr_segs; seg++) {
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
+	dio->total_pages = args->nr_segs;
 
-		dio->result += iov[seg].iov_len -
+	ret = do_direct_IO(dio);
+
+	dio->result += args->length -
 			((dio->final_block_in_request - dio->block_in_file) <<
 					blkbits);
-
-		if (ret) {
-			dio_cleanup(dio);
-			break;
-		}
-	} /* end iovec loop */
-
 	if (ret == -ENOTBLK && (rw & WRITE)) {
 		/*
 		 * The remaining part of the request will be
@@ -1110,9 +1014,6 @@ __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, struct dio_args *args, get_block_t get_block,
 	dio_iodone_t end_io, int dio_lock_type)
 {
-	int seg;
-	size_t size;
-	unsigned long addr;
 	unsigned blkbits = inode->i_blkbits;
 	unsigned bdev_blkbits = 0;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
@@ -1138,17 +1039,14 @@ __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	}
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < args->nr_segs; seg++) {
-		addr = (unsigned long) args->iov[seg].iov_base;
-		size = args->iov[seg].iov_len;
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
@@ -1156,6 +1054,8 @@ __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	if (!dio)
 		goto out;
 
+	dio->pages = args->pages;
+
 	/*
 	 * For block device access DIO_NO_LOCKING is used,
 	 *	neither readers nor writers do any locking at all
@@ -1232,20 +1132,70 @@ out:
 }
 EXPORT_SYMBOL(__blockdev_direct_IO);
 
-ssize_t generic_file_direct_IO(int rw, struct address_space *mapping,
-			       struct kiocb *iocb, const struct iovec *iov,
-			       loff_t offset, unsigned long nr_segs)
+static ssize_t __generic_file_direct_IO(int rw, struct address_space *mapping,
+					struct kiocb *iocb,
+					const struct iovec *iov, loff_t offset,
+					dio_io_actor *actor)
 {
+	struct page *stack_pages[UIO_FASTIOV];
+	unsigned long nr_pages, start, end;
 	struct dio_args args = {
-		.rw		= rw,
-		.iov		= iov,
-		.length		= iov_length(iov, nr_segs),
+		.pages		= stack_pages,
+		.length		= iov->iov_len,
+		.user_addr	= (unsigned long) iov->iov_base,
 		.offset		= offset,
-		.nr_segs	= nr_segs,
 	};
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
+		args.nr_segs = ret;
+		ret = actor(iocb, &args);
+	}
 
-	if (mapping->a_ops->direct_IO)
-		return mapping->a_ops->direct_IO(iocb, &args);
+	if (args.pages != stack_pages)
+		kfree(args.pages);
 
-	return -EINVAL;
+	return ret;
+}
+
+/*
+ * Transform the iov into a page based structure for passing into the lower
+ * parts of O_DIRECT handling
+ */
+ssize_t generic_file_direct_IO(int rw, struct address_space *mapping,
+			       struct kiocb *kiocb, const struct iovec *iov,
+			       loff_t offset, unsigned long nr_segs,
+			       dio_io_actor *actor)
+{
+	ssize_t ret = 0, ret2;
+	unsigned long i;
+
+	for (i = 0; i < nr_segs; i++) {
+		ret2 = __generic_file_direct_IO(rw, mapping, kiocb, iov, offset,
+							actor);
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
 }
+EXPORT_SYMBOL_GPL(generic_file_direct_IO);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 45d931b..d9da548 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -271,13 +271,12 @@ static const struct rpc_call_ops nfs_read_direct_ops = {
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
@@ -306,24 +305,8 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
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
+		data->npages = args->nr_segs;
 
 		get_dreq(dreq);
 
@@ -332,7 +315,7 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 		data->cred = msg.rpc_cred;
 		data->args.fh = NFS_FH(inode);
 		data->args.context = ctx;
-		data->args.offset = pos;
+		data->args.offset = args->offset;
 		data->args.pgbase = pgbase;
 		data->args.pages = data->pagevec;
 		data->args.count = bytes;
@@ -361,7 +344,7 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
 
 		started += bytes;
 		user_addr += bytes;
-		pos += bytes;
+		args->offset += bytes;
 		/* FIXME: Remove this unnecessary math from final patch */
 		pgbase += bytes;
 		pgbase &= ~PAGE_MASK;
@@ -376,26 +359,19 @@ static ssize_t nfs_direct_read_schedule_segment(struct nfs_direct_req *dreq,
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
@@ -403,13 +379,13 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
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
@@ -424,7 +400,7 @@ static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	result = nfs_direct_read_schedule_iovec(dreq, iov, nr_segs, pos);
+	result = nfs_direct_read_schedule_iovec(dreq, args);
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	nfs_direct_req_release(dreq);
@@ -691,13 +667,13 @@ static const struct rpc_call_ops nfs_write_direct_ops = {
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
@@ -726,24 +702,8 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
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
+		data->npages = args->nr_segs;
 
 		get_dreq(dreq);
 
@@ -754,7 +714,7 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 		data->cred = msg.rpc_cred;
 		data->args.fh = NFS_FH(inode);
 		data->args.context = ctx;
-		data->args.offset = pos;
+		data->args.offset = args->offset;
 		data->args.pgbase = pgbase;
 		data->args.pages = data->pagevec;
 		data->args.count = bytes;
@@ -784,7 +744,7 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
 
 		started += bytes;
 		user_addr += bytes;
-		pos += bytes;
+		args->offset += bytes;
 
 		/* FIXME: Remove this useless math from the final patch */
 		pgbase += bytes;
@@ -800,27 +760,19 @@ static ssize_t nfs_direct_write_schedule_segment(struct nfs_direct_req *dreq,
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
@@ -828,14 +780,13 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
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
@@ -848,7 +799,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		return -ENOMEM;
 	nfs_alloc_commit_data(dreq);
 
-	if (dreq->commit_data == NULL || count < wsize)
+	if (dreq->commit_data == NULL || args->length < wsize)
 		sync = NFS_FILE_SYNC;
 
 	dreq->inode = inode;
@@ -856,7 +807,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	result = nfs_direct_write_schedule_iovec(dreq, iov, nr_segs, pos, sync);
+	result = nfs_direct_write_schedule_iovec(dreq, args, sync);
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	nfs_direct_req_release(dreq);
@@ -867,9 +818,7 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
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
@@ -885,21 +834,20 @@ static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
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
@@ -909,9 +857,9 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, const struct iovec *iov,
 	if (retval)
 		goto out;
 
-	retval = nfs_direct_read(iocb, iov, nr_segs, pos);
+	retval = nfs_direct_read(iocb, args);
 	if (retval > 0)
-		iocb->ki_pos = pos + retval;
+		iocb->ki_pos = args->offset + retval;
 
 out:
 	return retval;
@@ -920,9 +868,7 @@ out:
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
@@ -942,23 +888,22 @@ out:
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
 
@@ -973,15 +918,23 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
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
 
+ssize_t nfs_file_direct_io(struct kiocb *kiocb, struct dio_args *args)
+{
+	if (args->rw == READ)
+		return nfs_file_direct_read(kiocb, args);
+
+	return nfs_file_direct_write(kiocb, args);
+}
+
 /**
  * nfs_init_directcache - create a slab cache for nfs_direct_req structures
  *
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 0506232..97d8cc7 100644
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
+		return generic_file_direct_IO(READ, mapping, iocb, iov, pos,
+						nr_segs, nfs_file_direct_io);
 
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
+		return generic_file_direct_IO(WRITE, mapping, iocb, iov, pos,
+						nr_segs, nfs_file_direct_io);
 
 	dprintk("NFS: write(%s/%s, %lu@%Ld)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5971116..539994a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2247,18 +2247,27 @@ static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
  */
 struct dio_args {
 	int rw;
-	const struct iovec *iov;
+	struct page **pages;
+	unsigned int first_page_off;
+	unsigned long nr_segs;
 	unsigned long length;
 	loff_t offset;
-	unsigned long nr_segs;
+
+	/*
+	 * Original user pointer, we'll get rid of this
+	 */
+	unsigned long user_addr;
 };
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, struct dio_args *args, get_block_t get_block,
 	dio_iodone_t end_io, int lock_type);
 
+typedef ssize_t (dio_io_actor)(struct kiocb *, struct dio_args *);
+
 ssize_t generic_file_direct_IO(int, struct address_space *, struct kiocb *,
-				const struct iovec *, loff_t, unsigned long);
+				const struct iovec *, loff_t, unsigned long,
+				dio_io_actor);
 
 enum {
 	DIO_LOCKING = 1, /* need locking between buffered and direct access */
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 97a2383..ded8337 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -409,12 +409,7 @@ extern int nfs3_removexattr (struct dentry *, const char *name);
  * linux/fs/nfs/direct.c
  */
 extern ssize_t nfs_direct_IO(struct kiocb *, struct dio_args *);
-extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
-			const struct iovec *iov, unsigned long nr_segs,
-			loff_t pos);
-extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
-			const struct iovec *iov, unsigned long nr_segs,
-			loff_t pos);
+extern ssize_t nfs_file_direct_io(struct kiocb *, struct dio_args *);
 
 /*
  * linux/fs/nfs/dir.c
diff --git a/mm/filemap.c b/mm/filemap.c
index cf85298..3e03021 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1346,8 +1346,8 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
 				retval = generic_file_direct_IO(READ, mapping,
-								iocb, iov,
-								pos, nr_segs);
+						iocb, iov, pos, nr_segs,
+						mapping->a_ops->direct_IO);
 			}
 			if (retval > 0)
 				*ppos = pos + retval;
@@ -2146,7 +2146,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	}
 
 	written = generic_file_direct_IO(WRITE, mapping, iocb, iov, pos,
-						*nr_segs);
+					*nr_segs, mapping->a_ops->direct_IO);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
-- 
1.6.4.53.g3f55e

