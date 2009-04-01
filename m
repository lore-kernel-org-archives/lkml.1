Return-Path: <linux-kernel-owner+w=401wt.eu-S1765993AbZDANtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765993AbZDANtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765474AbZDANo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:44737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764378AbZDANoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:54 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/17] bio: collapse __bio_map_user_iov(), __bio_unmap_user() and __bio_map_kern()
Date: Wed,  1 Apr 2009 22:44:24 +0900
Message-Id: <1238593472-30360-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Collapse double underbar prefixed internal functions which have only
single user into their respective call sites.  This prepares for
reimplementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c |  129 +++++++++++++++++++++++--------------------------------------
 1 files changed, 49 insertions(+), 80 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index f13aef0..4540afc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1044,10 +1044,20 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *md,
 	return bio_copy_user_iov(q, md, &iov, 1, rw, gfp);
 }
 
-static struct bio *__bio_map_user_iov(struct request_queue *q,
-				      struct block_device *bdev,
-				      struct iovec *iov, int count, int rw,
-				      gfp_t gfp)
+/**
+ *	bio_map_user_iov - map user iovec table into bio
+ *	@q: the struct request_queue for the bio
+ *	@bdev: destination block device
+ *	@iov:	the iovec.
+ *	@count: number of elements in the iovec
+ *	@rw: READ or WRITE
+ *	@gfp: memory allocation flags
+ *
+ *	Map the user space address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
+			     struct iovec *iov, int count, int rw, gfp_t gfp)
 {
 	int i, j;
 	size_t tot_len = 0;
@@ -1141,6 +1151,15 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 
 	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
+
+	/*
+	 * subtle -- if __bio_map_user() ended up bouncing a bio,
+	 * it would normally disappear when its bi_end_io is run.
+	 * however, we need it for the unmap, so grab an extra
+	 * reference to it
+	 */
+	bio_get(bio);
+
 	return bio;
 
  out_unmap:
@@ -1180,38 +1199,15 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
 }
 
 /**
- *	bio_map_user_iov - map user iovec table into bio
- *	@q: the struct request_queue for the bio
- *	@bdev: destination block device
- *	@iov:	the iovec.
- *	@count: number of elements in the iovec
- *	@rw: READ or WRITE
- *	@gfp: memory allocation flags
+ *	bio_unmap_user	-	unmap a bio
+ *	@bio:		the bio being unmapped
  *
- *	Map the user space address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
+ *	Unmap a bio previously mapped by bio_map_user(). Must be called with
+ *	a process context.
+ *
+ *	bio_unmap_user() may sleep.
  */
-struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
-			     struct iovec *iov, int count, int rw, gfp_t gfp)
-{
-	struct bio *bio;
-
-	bio = __bio_map_user_iov(q, bdev, iov, count, rw, gfp);
-	if (IS_ERR(bio))
-		return bio;
-
-	/*
-	 * subtle -- if __bio_map_user() ended up bouncing a bio,
-	 * it would normally disappear when its bi_end_io is run.
-	 * however, we need it for the unmap, so grab an extra
-	 * reference to it
-	 */
-	bio_get(bio);
-
-	return bio;
-}
-
-static void __bio_unmap_user(struct bio *bio)
+void bio_unmap_user(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	int i;
@@ -1226,21 +1222,8 @@ static void __bio_unmap_user(struct bio *bio)
 		page_cache_release(bvec->bv_page);
 	}
 
+	/* see comment on the success return path of bio_map_user_iov() */
 	bio_put(bio);
-}
-
-/**
- *	bio_unmap_user	-	unmap a bio
- *	@bio:		the bio being unmapped
- *
- *	Unmap a bio previously mapped by bio_map_user(). Must be called with
- *	a process context.
- *
- *	bio_unmap_user() may sleep.
- */
-void bio_unmap_user(struct bio *bio)
-{
-	__bio_unmap_user(bio);
 	bio_put(bio);
 }
 
@@ -1249,9 +1232,18 @@ static void bio_map_kern_endio(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-
-static struct bio *__bio_map_kern(struct request_queue *q, void *data,
-				  unsigned int len, gfp_t gfp)
+/**
+ *	bio_map_kern	-	map kernel address into bio
+ *	@q: the struct request_queue for the bio
+ *	@data: pointer to buffer to map
+ *	@len: length in bytes
+ *	@gfp: allocation flags for bio allocation
+ *
+ *	Map the kernel address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+			 gfp_t gfp)
 {
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -1283,39 +1275,16 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 		offset = 0;
 	}
 
+	/* doesn't support partial mappings */
+	if (unlikely(bio->bi_size != len)) {
+		bio_put(bio);
+		return ERR_PTR(-EINVAL);
+	}
+
 	bio->bi_end_io = bio_map_kern_endio;
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
-	struct bio *bio;
-
-	bio = __bio_map_kern(q, data, len, gfp);
-	if (IS_ERR(bio))
-		return bio;
-
-	if (bio->bi_size == len)
-		return bio;
-
-	/*
-	 * Don't support partial mappings.
-	 */
-	bio_put(bio);
-	return ERR_PTR(-EINVAL);
-}
-
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_copy_info *bci = bio->bi_private;
-- 
1.6.0.2

