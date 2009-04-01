Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZDANu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZDANu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765418AbZDANpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:45:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:44746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765499AbZDANo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:56 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/17] blk-map/bio: remove superflous @len parameter from blk_rq_map_user_iov()
Date: Wed,  1 Apr 2009 22:44:31 +0900
Message-Id: <1238593472-30360-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: API cleanup

blk_rq_map_user_iov() took @len parameter which contains duplicate
information as the total length is available as the sum of all iov
segments.  This doesn't save anything either as the mapping function
should walk the whole iov on entry to check for alignment anyway.
Remove the superflous parameter.

Removing the superflous parameter removes the pathological corner case
where the caller passes in shorter @len than @iov but @iov mappings
ends up capped due to queue limits and bio->bi_size ends up matching
@len thus resulting in successful map.  With the superflous parameter
gone, blk-map/bio can now simply fail partial mappings.

Move partial mapping detection to bio_create_from_sgl() which is
shared by all map/copy paths and remove partial mapping handling from
all other places.

This change removes one of the two users of __blk_rq_unmap_user() and
it gets collapsed into blk_rq_unmap_user().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c        |   47 +++++++++++++++--------------------------------
 block/scsi_ioctl.c     |   11 +++--------
 drivers/scsi/sg.c      |    2 +-
 fs/bio.c               |   43 +++++++++++++++++--------------------------
 include/linux/blkdev.h |    2 +-
 5 files changed, 37 insertions(+), 68 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index dc4097c..f60f439 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -8,20 +8,6 @@
 
 #include "blk.h"
 
-static int __blk_rq_unmap_user(struct bio *bio)
-{
-	int ret = 0;
-
-	if (bio) {
-		if (bio_flagged(bio, BIO_USER_MAPPED))
-			bio_unmap_user(bio);
-		else
-			ret = bio_uncopy_user(bio);
-	}
-
-	return ret;
-}
-
 /**
  * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
@@ -29,7 +15,6 @@ static int __blk_rq_unmap_user(struct bio *bio)
  * @md:		pointer to the rq_map_data holding pages (if necessary)
  * @iov:	pointer to the iovec
  * @count:	number of elements in the iovec
- * @len:	I/O byte count
  * @gfp:	memory allocation flags
  *
  * Description:
@@ -47,7 +32,7 @@ static int __blk_rq_unmap_user(struct bio *bio)
  */
 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct rq_map_data *md, struct iovec *iov, int count,
-			unsigned int len, gfp_t gfp)
+			gfp_t gfp)
 {
 	struct bio *bio = ERR_PTR(-EINVAL);
 	int rw = rq_data_dir(rq);
@@ -62,23 +47,17 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (bio->bi_size != len) {
-		/*
-		 * Grab an extra reference to this bio, as bio_unmap_user()
-		 * expects to be able to drop it twice as it happens on the
-		 * normal IO completion path
-		 */
-		bio_get(bio);
-		bio_endio(bio, 0);
-		__blk_rq_unmap_user(bio);
-		return -EINVAL;
-	}
-
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
 		rq->cmd_flags |= REQ_COPY_USER;
 
-	blk_queue_bounce(q, &bio);
+	/*
+	 * Grab an extra reference to this bio, as bio_unmap_user()
+	 * expects to be able to drop it twice as it happens on the
+	 * normal IO completion path.
+	 */
 	bio_get(bio);
+
+	blk_queue_bounce(q, &bio);
 	blk_rq_bio_prep(q, rq, bio);
 	rq->buffer = rq->data = NULL;
 	return 0;
@@ -116,7 +95,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	iov.iov_base = ubuf;
 	iov.iov_len = len;
 
-	return blk_rq_map_user_iov(q, rq, md, &iov, 1, len, gfp);
+	return blk_rq_map_user_iov(q, rq, md, &iov, 1, gfp);
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
@@ -132,12 +111,16 @@ EXPORT_SYMBOL(blk_rq_map_user);
 int blk_rq_unmap_user(struct bio *bio)
 {
 	struct bio *mapped_bio = bio;
-	int ret;
+	int ret = 0;
 
 	if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
 		mapped_bio = bio->bi_private;
 
-	ret = __blk_rq_unmap_user(mapped_bio);
+	if (bio_flagged(bio, BIO_USER_MAPPED))
+		bio_unmap_user(mapped_bio);
+	else
+		ret = bio_uncopy_user(mapped_bio);
+
 	bio_put(bio);
 	return ret;
 }
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 73cfd91..fd538f8 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -288,7 +288,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 
 	if (hdr->iovec_count) {
 		const int size = sizeof(struct sg_iovec) * hdr->iovec_count;
-		size_t iov_data_len;
 		struct iovec *iov;
 
 		iov = kmalloc(size, GFP_KERNEL);
@@ -304,15 +303,11 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		}
 
 		/* SG_IO howto says that the shorter of the two wins */
-		iov_data_len = iov_length(iov, hdr->iovec_count);
-		if (hdr->dxfer_len < iov_data_len) {
-			hdr->iovec_count = iov_shorten(iov, hdr->iovec_count,
-						       hdr->dxfer_len);
-			iov_data_len = hdr->dxfer_len;
-		}
+		hdr->iovec_count = iov_shorten(iov, hdr->iovec_count,
+					       hdr->dxfer_len);
 
 		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
-					  iov_data_len, GFP_KERNEL);
+					  GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b4ef2f8..5fcf436 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1673,7 +1673,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 
 	if (iov_count)
 		res = blk_rq_map_user_iov(q, rq, md, hp->dxferp, iov_count,
-					  hp->dxfer_len, GFP_ATOMIC);
+					  GFP_ATOMIC);
 	else
 		res = blk_rq_map_user(q, rq, md, hp->dxferp,
 				      hp->dxfer_len, GFP_ATOMIC);
diff --git a/fs/bio.c b/fs/bio.c
index fe796dc..9466b05 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -956,14 +956,14 @@ static void bio_memcpy_sgl_sgl(struct scatterlist *dsgl, int dnents,
  *	@nr_pages: number of pages in @sgl
  *	@rw: the data direction of new bio
  *
- *	Populate @bio with the data area described by @sgl.  Note that
- *	the resulting bio might not contain the whole @sgl area.  This
- *	can be checked by testing bio->bi_size against total area
- *	length.
+ *	Populate @bio with the data area described by @sgl.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
  */
-static void bio_init_from_sgl(struct bio *bio, struct request_queue *q,
-			      struct scatterlist *sgl, int nents,
-			      int nr_pages, int rw)
+static int bio_init_from_sgl(struct bio *bio, struct request_queue *q,
+			     struct scatterlist *sgl, int nents,
+			     int nr_pages, int rw)
 {
 	struct scatterlist *sg;
 	int i;
@@ -979,15 +979,18 @@ static void bio_init_from_sgl(struct bio *bio, struct request_queue *q,
 		while (len) {
 			size_t bytes = min_t(size_t, len, PAGE_SIZE - offset);
 
+			/* doesn't support partial mappings */
 			if (unlikely(bio_add_pc_page(q, bio, page,
 						     bytes, offset) < bytes))
-				break;
+				return -EINVAL;
 
 			offset = 0;
 			len -= bytes;
 			page = nth_page(page, 1);
 		}
 	}
+
+	return 0;
 }
 
 /**
@@ -1009,12 +1012,17 @@ static struct bio *bio_create_from_sgl(struct request_queue *q,
 				       int nr_pages, int rw, int gfp)
 {
 	struct bio *bio;
+	int ret;
 
 	bio = bio_kmalloc(gfp, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
-	bio_init_from_sgl(bio, q, sgl, nents, nr_pages, rw);
+	ret = bio_init_from_sgl(bio, q, sgl, nents, nr_pages, rw);
+	if (ret) {
+		bio_put(bio);
+		return ERR_PTR(ret);
+	}
 
 	return bio;
 }
@@ -1170,10 +1178,6 @@ struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
 		goto err_pages;
 	}
 
-	/* release the pages we didn't map into the bio, if any */
-	for (i = bio->bi_vcnt; i < nr_pages; i++)
-		page_cache_release(pages[i]);
-
 	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 
@@ -1283,12 +1287,6 @@ struct bio *bio_map_kern_sg(struct request_queue *q, struct scatterlist *sgl,
 	if (IS_ERR(bio))
 		return bio;
 
-	/* doesn't support partial mappings */
-	if (bio->bi_size != tot_len) {
-		bio_put(bio);
-		return ERR_PTR(-EINVAL);
-	}
-
 	bio->bi_end_io = bio_map_kern_endio;
 	return bio;
 }
@@ -1343,17 +1341,10 @@ struct bio *bio_copy_kern_sg(struct request_queue *q, struct scatterlist *sgl,
 		goto err_bci;
 	}
 
-	/* doesn't support partial mappings */
-	ret= -EINVAL;
-	if (bio->bi_size != bci->len)
-		goto err_bio;
-
 	bio->bi_end_io = bio_copy_kern_endio;
 	bio->bi_private = bci;
 	return bio;
 
-err_bio:
-	bio_put(bio);
 err_bci:
 	bci_destroy(bci);
 	return ERR_PTR(ret);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 40bec76..6876466 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -777,7 +777,7 @@ extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			       struct rq_map_data *md, struct iovec *iov,
-			       int count, unsigned int len, gfp_t gfp);
+			       int count, gfp_t gfp);
 extern int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
 			      struct scatterlist *sgl, int nents, gfp_t gfp);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
-- 
1.6.0.2

