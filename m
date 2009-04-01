Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbZDANvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbZDANvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765065AbZDANpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:45:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:44742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765482AbZDANo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:56 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/17] blk-map: implement blk_rq_map_kern_sgl()
Date: Wed,  1 Apr 2009 22:44:28 +0900
Message-Id: <1238593472-30360-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new API

Implement blk_rq_map_kern_sgl() using bio_copy_{map|kern}_sgl() and
reimplement blk_rq_map_kern() in terms of it.  As the bio helpers
already have all the necessary checks, all blk_rq_map_kern_sgl() has
to do is wrap them and initialize rq accordingly.  The implementation
closely resembles blk_rq_msp_user_iov().

This is an exported API and will be used to replace hack in scsi ioctl
implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c        |   54 ++++++++++++++++++++++++++++++-----------------
 include/linux/blkdev.h |    2 +
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index eb206df..0474c09 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -161,47 +161,61 @@ int blk_rq_unmap_user(struct bio *bio)
 EXPORT_SYMBOL(blk_rq_unmap_user);
 
 /**
- * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
+ * blk_rq_map_kern_sg - map kernel data to a request, for REQ_TYPE_BLOCK_PC
  * @q:		request queue where request should be inserted
  * @rq:		request to fill
- * @kbuf:	the kernel buffer
- * @len:	length of user data
+ * @sgl:	area to map
+ * @nents:	number of elements in @sgl
  * @gfp:	memory allocation flags
  *
  * Description:
  *    Data will be mapped directly if possible. Otherwise a bounce
  *    buffer is used.
  */
-int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
-		    unsigned int len, gfp_t gfp)
+int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
+		       struct scatterlist *sgl, int nents, gfp_t gfp)
 {
 	int rw = rq_data_dir(rq);
-	int do_copy = 0;
 	struct bio *bio;
 
-	if (len > (q->max_hw_sectors << 9))
-		return -EINVAL;
-	if (!len || !kbuf)
+	if (!sgl || nents <= 0)
 		return -EINVAL;
 
-	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
-	if (do_copy)
-		bio = bio_copy_kern(q, kbuf, len, gfp, rw);
-	else
-		bio = bio_map_kern(q, kbuf, len, gfp);
-
+	bio = bio_map_kern_sg(q, sgl, nents, rw, gfp);
+	if (IS_ERR(bio))
+		bio = bio_copy_kern_sg(q, sgl, nents, rw, gfp);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (rq_data_dir(rq) == WRITE)
-		bio->bi_rw |= (1 << BIO_RW);
-
-	if (do_copy)
+	if (!bio_flagged(bio, BIO_USER_MAPPED))
 		rq->cmd_flags |= REQ_COPY_USER;
 
+	blk_queue_bounce(q, &bio);
 	blk_rq_bio_prep(q, rq, bio);
-	blk_queue_bounce(q, &rq->bio);
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
+EXPORT_SYMBOL(blk_rq_map_kern_sg);
+
+/**
+ * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rq:		request to fill
+ * @kbuf:	the kernel buffer
+ * @len:	length of user data
+ * @gfp:	memory allocation flags
+ *
+ * Description:
+ *    Data will be mapped directly if possible. Otherwise a bounce
+ *    buffer is used.
+ */
+int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
+		    unsigned int len, gfp_t gfp)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, kbuf, len);
+
+	return blk_rq_map_kern_sg(q, rq, &sg, 1, gfp);
+}
 EXPORT_SYMBOL(blk_rq_map_kern);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d04e118..58b41da 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -784,6 +784,8 @@ extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, uns
 extern int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			       struct rq_map_data *md, struct iovec *iov,
 			       int count, unsigned int len, gfp_t gfp);
+extern int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
+			      struct scatterlist *sgl, int nents, gfp_t gfp);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.6.0.2

