Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbZDALIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbZDALIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZDALFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:05:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:35216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407AbZDALFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:05:12 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Tejun Heo <tj@kenel.org>
Subject: [PATCH 8/8] blk-map: reimplement blk_rq_map_user() using blk_rq_map_user_iov()
Date: Wed,  1 Apr 2009 20:04:44 +0900
Message-Id: <1238583884-13517-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238583884-13517-1-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: subtle bugs fixed, cleanup

blk_rq_map_user() supported multi-bio mapping by calling
bio_map/copy_user() multiple times and linking the resulting bios into
rq; however, this had subtle bugs.

* Because each call to bio_map/copy_user() is independent, segment
  limit check was done only per each bio, so it was possible to create
  requests which are larger than the driver and hardware limits, which
  could lead to disastrous outcome.

* Layers under FS may call blk_rq_map*() functions during request
  processing.  Under severe memory pressure and with enough bad luck,
  this can lead to deadlock.  As fs bvec pool is quite small, the
  possibility isn't completely theoretical.

This patch reimplement blk_rq_map_user() in terms of
blk_rq_map_user_iov() which doesn't support multi-bio mappping and
drop multi bio handling from blk_rq_unmap_user().  Note that with the
previous patch to remove bio max size limit and to add null mapping
support to blk_rq_map_user_iov(), this change doesn't remove any
functionality.

Signed-off-by: Tejun Heo <tj@kenel.org>
---
 block/blk-map.c |  118 +++++--------------------------------------------------
 1 files changed, 10 insertions(+), 108 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index ac1961d..a43c93c 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -40,49 +40,6 @@ static int __blk_rq_unmap_user(struct bio *bio)
 	return ret;
 }
 
-static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
-			     struct rq_map_data *map_data, void __user *ubuf,
-			     unsigned int len, gfp_t gfp_mask)
-{
-	unsigned long uaddr;
-	struct bio *bio, *orig_bio;
-	int reading, ret;
-
-	reading = rq_data_dir(rq) == READ;
-
-	/*
-	 * if alignment requirement is satisfied, map in user pages for
-	 * direct dma. else, set up kernel bounce buffers
-	 */
-	uaddr = (unsigned long) ubuf;
-	if (blk_rq_aligned(q, ubuf, len) && !map_data)
-		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
-	else
-		bio = bio_copy_user(q, map_data, uaddr, len, reading, gfp_mask);
-
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
-
-	orig_bio = bio;
-	blk_queue_bounce(q, &bio);
-
-	/*
-	 * We link the bounce buffer in and could have to traverse it
-	 * later so we have to get a ref to prevent it from being freed
-	 */
-	bio_get(bio);
-
-	ret = blk_rq_append_bio(q, rq, bio);
-	if (!ret)
-		return bio->bi_size;
-
-	/* if it was boucned we must call the end io function */
-	bio_endio(bio, 0);
-	__blk_rq_unmap_user(orig_bio);
-	bio_put(bio);
-	return ret;
-}
-
 /**
  * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
@@ -109,58 +66,12 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		    struct rq_map_data *map_data, void __user *ubuf,
 		    unsigned long len, gfp_t gfp_mask)
 {
-	unsigned long bytes_read = 0;
-	struct bio *bio = NULL;
-	int ret;
+	struct sg_iovec iov;
 
-	if (len > (q->max_hw_sectors << 9))
-		return -EINVAL;
-	if (!len)
-		return -EINVAL;
+	iov.iov_base = ubuf;
+	iov.iov_len = len;
 
-	if (!ubuf && (!map_data || !map_data->null_mapped))
-		return -EINVAL;
-
-	while (bytes_read != len) {
-		unsigned long map_len, end, start;
-
-		map_len = min_t(unsigned long, len - bytes_read,
-				BIO_GUARANTEED_SIZE);
-		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-		start = (unsigned long)ubuf >> PAGE_SHIFT;
-
-		/*
-		 * A bad offset could cause us to require
-		 * BIO_GUARANTEED_PAGES + 1 pages. If this happens we
-		 * just lower the requested mapping len by a page so
-		 * that we can fit
-		 */
-		if (end - start > BIO_GUARANTEED_PAGES)
-			map_len -= PAGE_SIZE;
-
-		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
-					gfp_mask);
-		if (ret < 0)
-			goto unmap_rq;
-		if (!bio)
-			bio = rq->bio;
-		bytes_read += ret;
-		ubuf += ret;
-
-		if (map_data)
-			map_data->offset += ret;
-	}
-
-	if (!bio_flagged(bio, BIO_USER_MAPPED))
-		rq->cmd_flags |= REQ_COPY_USER;
-
-	rq->buffer = rq->data = NULL;
-	return 0;
-unmap_rq:
-	blk_rq_unmap_user(bio);
-	rq->bio = NULL;
-	return ret;
+	return blk_rq_map_user_iov(q, rq, map_data, &iov, 1, len, gfp_mask);
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
@@ -250,23 +161,14 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
  */
 int blk_rq_unmap_user(struct bio *bio)
 {
-	struct bio *mapped_bio;
-	int ret = 0, ret2;
-
-	while (bio) {
-		mapped_bio = bio;
-		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
-			mapped_bio = bio->bi_private;
+	struct bio *mapped_bio = bio;
+	int ret;
 
-		ret2 = __blk_rq_unmap_user(mapped_bio);
-		if (ret2 && !ret)
-			ret = ret2;
-
-		mapped_bio = bio;
-		bio = bio->bi_next;
-		bio_put(mapped_bio);
-	}
+	if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
+		mapped_bio = bio->bi_private;
 
+	ret = __blk_rq_unmap_user(mapped_bio);
+	bio_put(bio);
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_unmap_user);
-- 
1.6.0.2

