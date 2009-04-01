Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZDANva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZDANva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765508AbZDANpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:45:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:44744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765458AbZDANo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:56 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/17] bio/blk-map: kill unused stuff and un-export internal functions
Date: Wed,  1 Apr 2009 22:44:30 +0900
Message-Id: <1238593472-30360-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, removal of unused / undesirable API

With recent changes, the following functions aren't used anymore.

* bio_{map|copy}_{user|kern}()
* blk_rq_append_bio()

The following functions aren't used outside of block layer.

* bio_add_pc_page()
* bio_un{map|copy}_user()

Kill the first group and unexport the second.  As bio_add_pc_page() is
used only inside fs/bio.c, it's made static.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c        |   17 --------
 fs/bio.c               |  102 +----------------------------------------------
 include/linux/bio.h    |   12 ------
 include/linux/blkdev.h |    6 ---
 4 files changed, 3 insertions(+), 134 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0474c09..dc4097c 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -8,23 +8,6 @@
 
 #include "blk.h"
 
-int blk_rq_append_bio(struct request_queue *q, struct request *rq,
-		      struct bio *bio)
-{
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio))
-		return -EINVAL;
-	else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
-
-		rq->data_len += bio->bi_size;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(blk_rq_append_bio);
-
 static int __blk_rq_unmap_user(struct bio *bio)
 {
 	int ret = 0;
diff --git a/fs/bio.c b/fs/bio.c
index 9c921f9..fe796dc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -627,8 +627,9 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
  *      smaller than PAGE_SIZE, so it is always possible to add a single
  *      page to an empty bio. This should only be used by REQ_PC bios.
  */
-int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
-		    unsigned int len, unsigned int offset)
+static int bio_add_pc_page(struct request_queue *q, struct bio *bio,
+			   struct page *page, unsigned int len,
+			   unsigned int offset)
 {
 	return __bio_add_page(q, bio, page, len, offset, q->max_hw_sectors);
 }
@@ -1085,31 +1086,6 @@ err_bci:
 }
 
 /**
- *	bio_copy_user	-	copy user data to bio
- *	@q: destination block queue
- *	@md: pointer to the rq_map_data holding pages (if necessary)
- *	@uaddr: start of user address
- *	@len: length in bytes
- *	@rw: READ or WRITE
- *	@gfp: memory allocation flags
- *
- *	Prepares and returns a bio for indirect user io, bouncing data
- *	to/from kernel pages as necessary. Must be paired with
- *	call bio_uncopy_user() on io completion.
- */
-struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *md,
-			  unsigned long uaddr, unsigned int len, int rw,
-			  gfp_t gfp)
-{
-	struct iovec iov;
-
-	iov.iov_base = (void __user *)uaddr;
-	iov.iov_len = len;
-
-	return bio_copy_user_iov(q, md, &iov, 1, rw, gfp);
-}
-
-/**
  *	bio_map_user_iov - map user iovec table into bio
  *	@q: the struct request_queue for the bio
  *	@bdev: destination block device
@@ -1227,30 +1203,6 @@ err_sgl:
 }
 
 /**
- *	bio_map_user	-	map user address into bio
- *	@q: the struct request_queue for the bio
- *	@bdev: destination block device
- *	@uaddr: start of user address
- *	@len: length in bytes
- *	@rw: READ or WRITE
- *	@gfp: memory allocation flags
- *
- *	Map the user space address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int rw,
-			 gfp_t gfp)
-{
-	struct iovec iov;
-
-	iov.iov_base = (void __user *)uaddr;
-	iov.iov_len = len;
-
-	return bio_map_user_iov(q, bdev, &iov, 1, rw, gfp);
-}
-
-/**
  *	bio_unmap_user	-	unmap a bio
  *	@bio:		the bio being unmapped
  *
@@ -1341,26 +1293,6 @@ struct bio *bio_map_kern_sg(struct request_queue *q, struct scatterlist *sgl,
 	return bio;
 }
 
-/**
- *	bio_map_kern	-	map kernel address into bio
- *	@q: the struct request_queue for the bio
- *	@data: pointer to buffer to map
- *	@len: length in bytes
- *	@gfp: allocation flags for bio allocation
- *
- *	Map the kernel address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp)
-{
-	struct scatterlist sg;
-
-	sg_init_one(&sg, data, len);
-
-	return bio_map_kern_sg(q, &sg, 1, READ, gfp);
-}
-
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_copy_info *bci = bio->bi_private;
@@ -1427,27 +1359,6 @@ err_bci:
 	return ERR_PTR(ret);
 }
 
-/**
- *	bio_copy_kern	-	copy kernel address into bio
- *	@q: the struct request_queue for the bio
- *	@data: pointer to buffer to copy
- *	@len: length in bytes
- *	@gfp: allocation flags for bio and page allocation
- *	@rw: READ or WRITE
- *
- *	copy the kernel address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
-			  gfp_t gfp, int rw)
-{
-	struct scatterlist sg;
-
-	sg_init_one(&sg, data, len);
-
-	return bio_copy_kern_sg(q, &sg, 1, rw, gfp);
-}
-
 /*
  * bio_set_pages_dirty() and bio_check_pages_dirty() are support functions
  * for performing direct-IO in BIOs.
@@ -1840,16 +1751,9 @@ EXPORT_SYMBOL(__bio_clone);
 EXPORT_SYMBOL(bio_clone);
 EXPORT_SYMBOL(bio_phys_segments);
 EXPORT_SYMBOL(bio_add_page);
-EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
-EXPORT_SYMBOL(bio_map_user);
-EXPORT_SYMBOL(bio_unmap_user);
-EXPORT_SYMBOL(bio_map_kern);
-EXPORT_SYMBOL(bio_copy_kern);
 EXPORT_SYMBOL(bio_pair_release);
 EXPORT_SYMBOL(bio_split);
-EXPORT_SYMBOL(bio_copy_user);
-EXPORT_SYMBOL(bio_uncopy_user);
 EXPORT_SYMBOL(bioset_create);
 EXPORT_SYMBOL(bioset_free);
 EXPORT_SYMBOL(bio_alloc_bioset);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1c28c5c..e662da9 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -382,29 +382,17 @@ void bio_init(struct bio *bio);
 
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset);
-int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
-		    unsigned int len, unsigned int offset);
 int bio_get_nr_vecs(struct block_device *bdev);
 sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 			   unsigned int offset);
-struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int rw,
-			 gfp_t gfp);
 struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
 			     struct iovec *iov, int count, int rw, gfp_t gfp);
 void bio_unmap_user(struct bio *bio);
-struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *md,
-			  unsigned long uaddr, unsigned int len, int rw,
-			  gfp_t gfp);
 struct bio *bio_copy_user_iov(struct request_queue *q, struct rq_map_data *md,
 			      struct iovec *iov, int count, int rw, gfp_t gfp);
 int bio_uncopy_user(struct bio *bio);
-struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp);
 struct bio *bio_map_kern_sg(struct request_queue *q, struct scatterlist *sgl,
 			    int nents, int rw, gfp_t gfp);
-struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
-			  gfp_t gfp, int rw);
 struct bio *bio_copy_kern_sg(struct request_queue *q, struct scatterlist *sgl,
 			     int nents, int rw, gfp_t gfp_mask);
 void bio_set_pages_dirty(struct bio *bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 58b41da..40bec76 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -745,12 +745,6 @@ extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
 /*
- * Temporary export, until SCSI gets fixed up.
- */
-extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
-			     struct bio *bio);
-
-/*
  * A queue has just exitted congestion.  Note this in the global counter of
  * congested queues, and wake up anyone who was waiting for requests to be
  * put back.
-- 
1.6.0.2

