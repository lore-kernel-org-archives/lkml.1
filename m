Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbZHTKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbZHTKTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZHTKT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:19:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbZHTKRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:54 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/5] loop: support O_DIRECT transfer mode
Date: Thu, 20 Aug 2009 12:17:43 +0200
Message-Id: <1250763466-24282-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-8-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-6-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-7-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-8-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the (now) page array backed O_DIRECT with a special
transfer mode for loop.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/loop.c |  139 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/loop.h |    1 +
 2 files changed, 139 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5757188..cf8cf20 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -82,6 +82,9 @@ static DEFINE_MUTEX(loop_devices_mutex);
 
 static int max_part;
 static int part_shift;
+static int odirect = 1;
+
+#define LOOP_MAX_DIRECT_SEGMENTS	32
 
 /*
  * Transfer functions
@@ -201,6 +204,124 @@ lo_do_transfer(struct loop_device *lo, int cmd,
 	return lo->transfer(lo, cmd, rpage, roffs, lpage, loffs, size, rblock);
 }
 
+static int direct_fill_pages(struct bio *bio, struct page **pages)
+{
+	unsigned int i, pidx = 0;
+	struct bio_vec *bvec;
+
+	bio_for_each_segment(bvec, bio, i)
+		pages[pidx++] = bvec->bv_page;
+
+	return pidx;
+}
+
+/*
+ * Use the O_DIRECT IO path for this read
+ */
+static int lo_direct_read(struct loop_device *lo, struct bio *bio, loff_t pos)
+{
+	struct file *file = lo->lo_backing_file;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	struct page *pages[LOOP_MAX_DIRECT_SEGMENTS];
+	struct kiocb iocb;
+	loff_t size;
+	int ret = 0;
+	struct dio_args args = {
+		.rw		= READ,
+		.pages		= pages,
+		.length		= bio->bi_size,
+		.user_addr	= 0,
+		.offset		= pos,
+	};
+
+	init_sync_kiocb(&iocb, file);
+	iocb.ki_pos = pos;
+	iocb.ki_left = bio->bi_size;
+	kiocbSetKernel(&iocb);
+
+	args.nr_segs = direct_fill_pages(bio, pages);
+	args.first_page_off = bio->bi_io_vec[0].bv_offset;
+
+	size = i_size_read(inode);
+	if (pos >= size)
+		return 0;
+
+	ret = filemap_write_and_wait_range(mapping, pos, pos + bio->bi_size-1);
+	if (ret)
+		return ret;
+
+	ret = mapping->a_ops->direct_IO(&iocb, &args);
+	if (ret > 0) {
+		file_accessed(file);
+		ret = 0;
+	}
+
+	return ret;
+}
+
+/*
+ * Use the O_DIRECT IO path for this write
+ */
+static int lo_direct_write(struct loop_device *lo, struct bio *bio, loff_t pos)
+{
+	struct file *file = lo->lo_backing_file;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	struct page *pages[LOOP_MAX_DIRECT_SEGMENTS];
+	struct kiocb iocb;
+	int ret = 0;
+	pgoff_t end;
+	struct dio_args args = {
+		.rw		= WRITE,
+		.pages		= pages,
+		.length		= bio->bi_size,
+		.user_addr	= 0,
+		.offset		= pos,
+	};
+
+	ret = filemap_write_and_wait_range(mapping, pos, pos + bio->bi_size-1);
+	if (ret)
+		goto out;
+
+	end = (pos + bio->bi_size - 1) >> PAGE_CACHE_SHIFT;
+	if (mapping->nrpages) {
+		ret = invalidate_inode_pages2_range(mapping,
+						pos >> PAGE_CACHE_SHIFT, end);
+		if (ret) {
+			if (ret == -EBUSY)
+				ret = 0;
+			goto out;
+		}
+	}
+
+	init_sync_kiocb(&iocb, file);
+	iocb.ki_pos = pos;
+	iocb.ki_left = bio->bi_size;
+	kiocbSetKernel(&iocb);
+
+	args.nr_segs = direct_fill_pages(bio, pages);
+	args.first_page_off = bio->bi_io_vec[0].bv_offset;
+
+	ret = mapping->a_ops->direct_IO(&iocb, &args);
+
+	if (mapping->nrpages) {
+		invalidate_inode_pages2_range(mapping,
+					pos >> PAGE_CACHE_SHIFT, end);
+	}
+
+	if (ret > 0) {
+		loff_t end = pos + ret;
+		if (end > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
+			i_size_write(inode, end);
+			mark_inode_dirty(inode);
+		}
+		ret = 0;
+	}
+out:
+	return ret;
+}
+
 /**
  * do_lo_send_aops - helper for writing data to a loop device
  *
@@ -347,6 +468,9 @@ static int lo_send(struct loop_device *lo, struct bio *bio, loff_t pos)
 	struct page *page = NULL;
 	int i, ret = 0;
 
+	if (lo->lo_flags & LO_FLAGS_ODIRECT)
+		return lo_direct_write(lo, bio, pos);
+
 	do_lo_send = do_lo_send_aops;
 	if (!(lo->lo_flags & LO_FLAGS_USE_AOPS)) {
 		do_lo_send = do_lo_send_direct_write;
@@ -458,6 +582,9 @@ lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
 	struct bio_vec *bvec;
 	int i, ret = 0;
 
+	if (lo->lo_flags & LO_FLAGS_ODIRECT)
+		return lo_direct_read(lo, bio, pos);
+
 	bio_for_each_segment(bvec, bio, i) {
 		ret = do_lo_receive(lo, bvec, bsize, pos);
 		if (ret < 0)
@@ -784,7 +911,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (S_ISREG(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		const struct address_space_operations *aops = mapping->a_ops;
 
-		if (aops->write_begin)
+		if (odirect) {
+			if (!aops->direct_IO)
+				goto out_putf;
+			lo_flags |= LO_FLAGS_ODIRECT;
+		} else if (aops->write_begin)
 			lo_flags |= LO_FLAGS_USE_AOPS;
 		if (!(lo_flags & LO_FLAGS_USE_AOPS) && !file->f_op->write)
 			lo_flags |= LO_FLAGS_READ_ONLY;
@@ -831,6 +962,10 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+	if (odirect) {
+		blk_queue_max_phys_segments(lo->lo_queue, LOOP_MAX_DIRECT_SEGMENTS);
+		blk_queue_max_hw_segments(lo->lo_queue, LOOP_MAX_DIRECT_SEGMENTS);
+	}
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
@@ -1456,6 +1591,8 @@ module_param(max_loop, int, 0);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, 0);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
+module_param(odirect, int, 0);
+MODULE_PARM_DESC(odirect, "Use O_DIRECT for IO");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 66c194e..a7433c0 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -76,6 +76,7 @@ enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_USE_AOPS	= 2,
 	LO_FLAGS_AUTOCLEAR	= 4,
+	LO_FLAGS_ODIRECT	= 8,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-- 
1.6.4.53.g3f55e

