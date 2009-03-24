Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbZCXQIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbZCXQIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbZCXQGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:41799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbZCXQGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:30 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/14] block: implement blk_rq_map_kern_prealloc()
Date: Wed, 25 Mar 2009 01:06:05 +0900
Message-Id: <1237910776-10983-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: implement new API

There still are a few places where request is allocated statically and
manually initialized.  Till now, those sites used their own custom
mechanisms to pass data buffer through request queue.  This patch
implements blk_rq_map_kern_prealloc() which initializes rq with
pre-allocated bio and bvec so that those code paths can be converted
to bio.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-map.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/bio.c               |   23 ++++++++++++++++++++++
 include/linux/bio.h    |    3 ++
 include/linux/blkdev.h |    4 +++
 4 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index f103729..c50aac2 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -317,3 +317,53 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
+
+/**
+ * blk_rq_map_kern_prealloc - map kernel data using preallocated structures
+ * @q:		request queue where request should be inserted
+ * @rq:		request to fill
+ * @bio:	bio to use
+ * @bvec:	bio_vec array to use
+ * @bvec_len:	the number of available bvecs in @bvec
+ * @kbuf:	the kernel buffer to map
+ * @len:	length of @kbuf
+ * @force:	bypass @kbuf alignment and on stack check
+ *
+ * Description:
+ *    @len bytes at @kbuf will be mapped into @rq using @bio and
+ *    @bvec.  The buffer must be suitable for direct mapping and
+ *    should not require more than @bvec_len elements to map.  This
+ *    function doesn't do any allocation and can be called from atomic
+ *    context.  0 is returned on success, -errno on failure.  Note
+ *    that this function does not handle bouncing.
+ *
+ *    WARNING: Using this function is strongly discouraged.  Use
+ *    blk_rq_map_kern() if at all possible.
+ */
+int blk_rq_map_kern_prealloc(struct request_queue *q,
+			     struct request *rq, struct bio *bio,
+			     struct bio_vec *bvec, unsigned short bvec_len,
+			     void *kbuf, unsigned int len, bool force)
+{
+	int error;
+
+	if (len > (q->max_hw_sectors << 9))
+		return -EINVAL;
+	if (!len || !kbuf)
+		return -EINVAL;
+	if (!force &&
+	    (!blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf)))
+		return -EINVAL;
+
+	error = bio_map_kern_prealloc(q, bio, bvec, bvec_len, kbuf, len);
+	if (error)
+		return error;
+
+	if (rq_data_dir(rq) == WRITE)
+		bio->bi_rw |= (1 << BIO_RW);
+
+	blk_rq_bio_prep(q, rq, bio);
+	rq->buffer = rq->data = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_map_kern_prealloc);
diff --git a/fs/bio.c b/fs/bio.c
index 746b566..ab3c9c9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1165,6 +1165,29 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 	return bio;
 }
 
+/**
+ *	bio_map_kern_prealloc - map kernel address into preallocated bio/bvec
+ *	@q: the struct request_queue for the bio
+ *	@bio: bio to initialize
+ *	@bvec: bio_vec array to initialize
+ *	@bvec_len: how many elements are available in @bvec
+ *	@data: pointer to buffer to map
+ *	@len: length in bytes
+ *
+ *	Map @data into @bvec and initialize @bio with it.  If there
+ *	aren't enough @bvec entries, -EINVAL is returned.
+ */
+int bio_map_kern_prealloc(struct request_queue *q, struct bio *bio,
+			  struct bio_vec *bvec, unsigned short bvec_len,
+			  void *data, unsigned int len)
+{
+	bio_init(bio);
+	bio->bi_io_vec = bvec;
+	bio->bi_max_vecs = bvec_len;
+
+	return __bio_map_kern(q, bio, data, len);
+}
+
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_vec *bvec;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d8bd43b..39619eb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -388,6 +388,9 @@ extern struct bio *bio_map_user_iov(struct request_queue *,
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				gfp_t);
+extern int bio_map_kern_prealloc(struct request_queue *q, struct bio *bio,
+				 struct bio_vec *bvec, unsigned short bvec_len,
+				 void *data, unsigned int len);
 extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..e322e94 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -781,6 +781,10 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   gfp_t);
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
+extern int blk_rq_map_kern_prealloc(struct request_queue *q,
+			struct request *rq, struct bio *bio,
+			struct bio_vec *bvec, unsigned short bvec_len,
+			void *kbuf, unsigned int len, bool force);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, struct sg_iovec *, int,
 			       unsigned int, gfp_t);
-- 
1.6.0.2

