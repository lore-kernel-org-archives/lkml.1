Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbZHTKSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbZHTKSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZHTKR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:17:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60118 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZHTKRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/4] direct-io: unify argument passing by adding a dio_args structure
Date: Thu, 20 Aug 2009 12:17:36 +0200
Message-Id: <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The O_DIRECT IO path is a mess of arguments. Clean that up by passing
those arguments in a dedicated dio_args structure.

This is in preparation for changing the internal implementation to be
page based instead of using iovecs.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/block_dev.c              |    7 ++--
 fs/btrfs/inode.c            |    4 +--
 fs/direct-io.c              |   70 +++++++++++++++++++++++++++----------------
 fs/ext2/inode.c             |    8 ++---
 fs/ext3/inode.c             |   15 ++++-----
 fs/ext4/inode.c             |   15 ++++-----
 fs/fat/inode.c              |   12 +++----
 fs/gfs2/aops.c              |   11 ++----
 fs/hfs/inode.c              |    7 ++--
 fs/hfsplus/inode.c          |    8 ++--
 fs/jfs/inode.c              |    7 ++--
 fs/nfs/direct.c             |    9 ++----
 fs/nilfs2/inode.c           |    9 ++---
 fs/ocfs2/aops.c             |   11 ++-----
 fs/reiserfs/inode.c         |    7 +---
 fs/xfs/linux-2.6/xfs_aops.c |   19 ++++--------
 include/linux/fs.h          |   59 +++++++++++++++++++++---------------
 include/linux/nfs_fs.h      |    3 +-
 mm/filemap.c                |    8 +++--
 19 files changed, 141 insertions(+), 148 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 94dfda2..2e494fa 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -166,14 +166,13 @@ blkdev_get_blocks(struct inode *inode, sector_t iblock,
 }
 
 static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+blkdev_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO_no_locking(rw, iocb, inode, I_BDEV(inode),
-				iov, offset, nr_segs, blkdev_get_blocks, NULL);
+	return blockdev_direct_IO_no_locking(iocb, inode, I_BDEV(inode),
+				args, blkdev_get_blocks, NULL);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272b9b2..094e3a7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4308,9 +4308,7 @@ out:
 	return em;
 }
 
-static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	return -EINVAL;
 }
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8b10b87..181848c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -929,14 +929,14 @@ out:
  * Releases both i_mutex and i_alloc_sem
  */
 static ssize_t
-direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
-	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
-	struct dio *dio)
+direct_io_worker(struct kiocb *iocb, struct inode *inode, 
+	struct dio_args *args, unsigned blkbits, get_block_t get_block,
+	dio_iodone_t end_io, struct dio *dio)
 {
-	unsigned long user_addr; 
+	const struct iovec *iov = args->iov;
+	unsigned long user_addr;
 	unsigned long flags;
-	int seg;
+	int seg, rw = args->rw;
 	ssize_t ret = 0;
 	ssize_t ret2;
 	size_t bytes;
@@ -945,7 +945,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->rw = rw;
 	dio->blkbits = blkbits;
 	dio->blkfactor = inode->i_blkbits - blkbits;
-	dio->block_in_file = offset >> blkbits;
+	dio->block_in_file = args->offset >> blkbits;
 
 	dio->get_block = get_block;
 	dio->end_io = end_io;
@@ -965,14 +965,14 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	if (unlikely(dio->blkfactor))
 		dio->pages_in_io = 2;
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
+	for (seg = 0; seg < args->nr_segs; seg++) {
+		user_addr = (unsigned long) iov[seg].iov_base;
 		dio->pages_in_io +=
 			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
 				- user_addr/PAGE_SIZE);
 	}
 
-	for (seg = 0; seg < nr_segs; seg++) {
+	for (seg = 0; seg < args->nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		dio->size += bytes = iov[seg].iov_len;
 
@@ -1076,7 +1076,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
 	if (ret2 == 0) {
-		ret = dio_complete(dio, offset, ret);
+		ret = dio_complete(dio, args->offset, ret);
 		kfree(dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
@@ -1106,10 +1106,9 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
  * Additional i_alloc_sem locking requirements described inline below.
  */
 ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	int dio_lock_type)
+__blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, struct dio_args *args, get_block_t get_block,
+	dio_iodone_t end_io, int dio_lock_type)
 {
 	int seg;
 	size_t size;
@@ -1118,10 +1117,11 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	unsigned bdev_blkbits = 0;
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
-	loff_t end = offset;
+	loff_t end = args->offset;
 	struct dio *dio;
 	int release_i_mutex = 0;
 	int acquire_i_mutex = 0;
+	int rw = args->rw;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1129,18 +1129,18 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
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
+	for (seg = 0; seg < args->nr_segs; seg++) {
+		addr = (unsigned long) args->iov[seg].iov_base;
+		size = args->iov[seg].iov_len;
 		end += size;
 		if ((addr & blocksize_mask) || (size & blocksize_mask))  {
 			if (bdev)
@@ -1168,7 +1168,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->lock_type = dio_lock_type;
 	if (dio_lock_type != DIO_NO_LOCKING) {
 		/* watch out for a 0 len io from a tricksy fs */
-		if (rw == READ && end > offset) {
+		if (rw == READ && end > args->offset) {
 			struct address_space *mapping;
 
 			mapping = iocb->ki_filp->f_mapping;
@@ -1177,8 +1177,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 				release_i_mutex = 1;
 			}
 
-			retval = filemap_write_and_wait_range(mapping, offset,
-							      end - 1);
+			retval = filemap_write_and_wait_range(mapping,
+							args->offset, end - 1);
 			if (retval) {
 				kfree(dio);
 				goto out;
@@ -1204,8 +1204,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
 		(end > i_size_read(inode)));
 
-	retval = direct_io_worker(rw, iocb, inode, iov, offset,
-				nr_segs, blkbits, get_block, end_io, dio);
+	retval = direct_io_worker(iocb, inode, args, blkbits, get_block, end_io,
+					dio);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -1231,3 +1231,21 @@ out:
 	return retval;
 }
 EXPORT_SYMBOL(__blockdev_direct_IO);
+
+ssize_t generic_file_direct_IO(int rw, struct address_space *mapping,
+			       struct kiocb *iocb, const struct iovec *iov,
+			       loff_t offset, unsigned long nr_segs)
+{
+	struct dio_args args = {
+		.rw		= rw,
+		.iov		= iov,
+		.length		= iov_length(iov, nr_segs),
+		.offset		= offset,
+		.nr_segs	= nr_segs,
+	};
+
+	if (mapping->a_ops->direct_IO)
+		return mapping->a_ops->direct_IO(iocb, &args);
+
+	return -EINVAL;
+}
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e271303..e813df7 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -790,15 +790,13 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping,block,ext2_get_block);
 }
 
-static ssize_t
-ext2_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+static ssize_t ext2_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				offset, nr_segs, ext2_get_block, NULL);
+	return blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
+					ext2_get_block, NULL);
 }
 
 static int
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b49908a..11dc0d1 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1713,9 +1713,7 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+static ssize_t ext3_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1723,10 +1721,10 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = args->length;
 
-	if (rw == WRITE) {
-		loff_t final_size = offset + count;
+	if (args->rw == WRITE) {
+		loff_t final_size = args->offset + count;
 
 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
@@ -1746,8 +1744,7 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 		}
 	}
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
+	ret = blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
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
index f9c642b..164fdb3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3267,9 +3267,7 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+static ssize_t ext4_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -3277,10 +3275,10 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = args->length;
 
-	if (rw == WRITE) {
-		loff_t final_size = offset + count;
+	if (args->rw == WRITE) {
+		loff_t final_size = args->offset + count;
 
 		if (final_size > inode->i_size) {
 			/* Credits for sb + inode write */
@@ -3300,8 +3298,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 		}
 	}
 
-	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
+	ret = blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
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
index 8970d8c..9d41851 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -167,14 +167,12 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 	return err;
 }
 
-static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+static ssize_t fat_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	if (rw == WRITE) {
+	if (args->rw == WRITE) {
 		/*
 		 * FIXME: blockdev_direct_IO() doesn't use ->write_begin(),
 		 * so we need to update the ->mmu_private to block boundary.
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
+	return blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
+				  fat_get_block, NULL);
 }
 
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 7ebae9a..a9422a2 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1021,9 +1021,7 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 
 
 
-static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+static ssize_t gfs2_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1043,13 +1041,12 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	rv = gfs2_glock_nq(&gh);
 	if (rv)
 		return rv;
-	rv = gfs2_ok_for_dio(ip, rw, offset);
+	rv = gfs2_ok_for_dio(ip, args->rw, args->offset);
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
-	rv = blockdev_direct_IO_no_locking(rw, iocb, inode, inode->i_sb->s_bdev,
-					   iov, offset, nr_segs,
-					   gfs2_get_block_direct, NULL);
+	rv = blockdev_direct_IO_no_locking(iocb, inode, inode->i_sb->s_bdev,
+					   args, gfs2_get_block_direct, NULL);
 out:
 	gfs2_glock_dq_m(1, &gh);
 	gfs2_holder_uninit(&gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a1cbff2..2998914 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -107,14 +107,13 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+static ssize_t hfs_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, hfs_get_block, NULL);
+	return blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
+				  hfs_get_block, NULL);
 }
 
 static int hfs_writepages(struct address_space *mapping,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1bcf597..dd7102b 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -100,14 +100,14 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+static ssize_t hfsplus_direct_IO(struct kiocb *iocb,
+				 struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, hfsplus_get_block, NULL);
+	return blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
+				  hfsplus_get_block, NULL);
 }
 
 static int hfsplus_writepages(struct address_space *mapping,
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index b2ae190..e1420de 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -306,14 +306,13 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, jfs_get_block);
 }
 
-static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+static ssize_t jfs_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				offset, nr_segs, jfs_get_block, NULL);
+	return blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
+					jfs_get_block, NULL);
 }
 
 const struct address_space_operations jfs_aops = {
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e4e089a..45d931b 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -103,21 +103,18 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
 /**
  * nfs_direct_IO - NFS address space operation for direct I/O
  * @rw: direction (read or write)
- * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
- * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
+ * @args: IO arguments
  *
  * The presence of this routine in the address space ops vector means
  * the NFS client supports direct I/O.  However, we shunt off direct
  * read and write requests before the VFS gets them, so this method
  * should never be called.
  */
-ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
+ssize_t nfs_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
-			(long long) pos, nr_segs);
+			(long long) args->offset, args->nr_segs);
 
 	return -EINVAL;
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index fe9d8f2..840c307 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -222,19 +222,18 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		loff_t offset, unsigned long nr_segs)
+nilfs_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t size;
 
-	if (rw == WRITE)
+	if (args->rw == WRITE)
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, nilfs_get_block, NULL);
+	size = blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
+				  nilfs_get_block, NULL);
 	return size;
 }
 
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b401654..56e61ba 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -668,11 +668,7 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 	return jbd2_journal_try_to_free_buffers(journal, page, wait);
 }
 
-static ssize_t ocfs2_direct_IO(int rw,
-			       struct kiocb *iocb,
-			       const struct iovec *iov,
-			       loff_t offset,
-			       unsigned long nr_segs)
+static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
@@ -687,9 +683,8 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
 		return 0;
 
-	ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-					    inode->i_sb->s_bdev, iov, offset,
-					    nr_segs, 
+	ret = blockdev_direct_IO_no_locking(iocb, inode,
+					    inode->i_sb->s_bdev, args,
 					    ocfs2_direct_IO_get_blocks,
 					    ocfs2_dio_end_io);
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index a14d6cd..201e6ca 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3025,15 +3025,12 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
 
 /* We thank Mingming Cao for helping us understand in great detail what
    to do in this section of the code. */
-static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
-				  const struct iovec *iov, loff_t offset,
-				  unsigned long nr_segs)
+static ssize_t reiserfs_direct_IO(struct kiocb *iocb, struct dio_args *args)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs,
+	return blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, args,
 				  reiserfs_get_blocks_direct_io, NULL);
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index aecf251..0faf1fe 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1532,11 +1532,8 @@ xfs_end_io_direct(
 
 STATIC ssize_t
 xfs_vm_direct_IO(
-	int			rw,
 	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	loff_t			offset,
-	unsigned long		nr_segs)
+	struct dio_args		*args)
 {
 	struct file	*file = iocb->ki_filp;
 	struct inode	*inode = file->f_mapping->host;
@@ -1545,18 +1542,14 @@ xfs_vm_direct_IO(
 
 	bdev = xfs_find_bdev_for_inode(XFS_I(inode));
 
-	if (rw == WRITE) {
+	if (args->rw == WRITE) {
 		iocb->private = xfs_alloc_ioend(inode, IOMAP_UNWRITTEN);
-		ret = blockdev_direct_IO_own_locking(rw, iocb, inode,
-			bdev, iov, offset, nr_segs,
-			xfs_get_blocks_direct,
-			xfs_end_io_direct);
+		ret = blockdev_direct_IO_own_locking(iocb, inode, bdev, args,
+				xfs_get_blocks_direct, xfs_end_io_direct);
 	} else {
 		iocb->private = xfs_alloc_ioend(inode, IOMAP_READ);
-		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-			bdev, iov, offset, nr_segs,
-			xfs_get_blocks_direct,
-			xfs_end_io_direct);
+		ret = blockdev_direct_IO_no_locking(iocb, inode,
+			bdev, args, xfs_get_blocks_direct, xfs_end_io_direct);
 	}
 
 	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 67888a9..5971116 100644
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
+	ssize_t (*direct_IO)(struct kiocb *, struct dio_args *);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/* migrate the contents of a page to the specified target */
@@ -2241,10 +2241,24 @@ static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 #endif
 
 #ifdef CONFIG_BLOCK
-ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	int lock_type);
+
+/*
+ * Arguments passwed to aops->direct_IO()
+ */
+struct dio_args {
+	int rw;
+	const struct iovec *iov;
+	unsigned long length;
+	loff_t offset;
+	unsigned long nr_segs;
+};
+
+ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, struct dio_args *args, get_block_t get_block,
+	dio_iodone_t end_io, int lock_type);
+
+ssize_t generic_file_direct_IO(int, struct address_space *, struct kiocb *,
+				const struct iovec *, loff_t, unsigned long);
 
 enum {
 	DIO_LOCKING = 1, /* need locking between buffered and direct access */
@@ -2252,31 +2266,28 @@ enum {
 	DIO_OWN_LOCKING, /* filesystem locks buffered and direct internally */
 };
 
-static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, struct dio_args *args,
+	get_block_t get_block, dio_iodone_t end_io)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_LOCKING);
+	return __blockdev_direct_IO(iocb, inode, bdev, args,
+					get_block, end_io, DIO_LOCKING);
 }
 
-static inline ssize_t blockdev_direct_IO_no_locking(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+static inline ssize_t blockdev_direct_IO_no_locking(struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, struct dio_args *args,
+	get_block_t get_block, dio_iodone_t end_io)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_NO_LOCKING);
+	return __blockdev_direct_IO(iocb, inode, bdev, args,
+					get_block, end_io, DIO_NO_LOCKING);
 }
 
-static inline ssize_t blockdev_direct_IO_own_locking(int rw, struct kiocb *iocb,
-	struct inode *inode, struct block_device *bdev, const struct iovec *iov,
-	loff_t offset, unsigned long nr_segs, get_block_t get_block,
-	dio_iodone_t end_io)
+static inline ssize_t blockdev_direct_IO_own_locking(struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, struct dio_args *args,
+	get_block_t get_block, dio_iodone_t end_io)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				nr_segs, get_block, end_io, DIO_OWN_LOCKING);
+	return __blockdev_direct_IO(iocb, inode, bdev, args,
+					get_block, end_io, DIO_OWN_LOCKING);
 }
 #endif
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f6b9024..97a2383 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -408,8 +408,7 @@ extern int nfs3_removexattr (struct dentry *, const char *name);
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(int, struct kiocb *, const struct iovec *, loff_t,
-			unsigned long);
+extern ssize_t nfs_direct_IO(struct kiocb *, struct dio_args *);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			const struct iovec *iov, unsigned long nr_segs,
 			loff_t pos);
diff --git a/mm/filemap.c b/mm/filemap.c
index ccea3b6..cf85298 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1345,8 +1345,9 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
-				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
+				retval = generic_file_direct_IO(READ, mapping,
+								iocb, iov,
+								pos, nr_segs);
 			}
 			if (retval > 0)
 				*ppos = pos + retval;
@@ -2144,7 +2145,8 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	written = generic_file_direct_IO(WRITE, mapping, iocb, iov, pos,
+						*nr_segs);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
-- 
1.6.4.53.g3f55e

