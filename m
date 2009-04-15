Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbZDONMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbZDONMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbZDONKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:10:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759601AbZDONKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:10:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/5] bio: fix bio_kmalloc()
Date: Wed, 15 Apr 2009 22:10:26 +0900
Message-Id: <1239801027-9201-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239801027-9201-1-git-send-email-tj@kernel.org>
References: <1239801027-9201-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 13:10:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix bio_kmalloc() and its destruction path

bio_kmalloc() was broken in two ways.

* bvec_alloc_bs() first allocates bvec using kmalloc() and then
  ignores it and allocates again like non-kmalloc bvecs.

* bio_kmalloc_destructor() didn't check for and free bio integrity
  data.

This patch fixes the above problems.  kmalloc patch is separated out
from bio_alloc_bioset() and allocates the requested number of bvecs as
inline bvecs.

* bio_alloc_bioset() no longer takes NULL @bs.  None other than
  bio_kmalloc() used it and outside users can't know how it was
  allocated anyway.

* Define and use BIO_POOL_NONE so that pool index check in
  bvec_free_bs() triggers if inline or kmalloc allocated bvec gets
  there.

* Relocate destructors on top of each allocation function so that how
  they're used is more clear.

Jens Axboe suggested allocating bvecs inline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 fs/bio.c            |  108 ++++++++++++++++++++++++++-------------------------
 include/linux/bio.h |    1 +
 2 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e0c9e54..6c2aef6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -175,14 +175,6 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
 	struct bio_vec *bvl;
 
 	/*
-	 * If 'bs' is given, lookup the pool and do the mempool alloc.
-	 * If not, this is a bio_kmalloc() allocation and just do a
-	 * kzalloc() for the exact number of vecs right away.
-	 */
-	if (!bs)
-		bvl = kmalloc(nr * sizeof(struct bio_vec), gfp_mask);
-
-	/*
 	 * see comment near bvec_array define!
 	 */
 	switch (nr) {
@@ -260,21 +252,6 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 	mempool_free(p, bs->bio_pool);
 }
 
-/*
- * default destructor for a bio allocated with bio_alloc_bioset()
- */
-static void bio_fs_destructor(struct bio *bio)
-{
-	bio_free(bio, fs_bio_set);
-}
-
-static void bio_kmalloc_destructor(struct bio *bio)
-{
-	if (bio_has_allocated_vec(bio))
-		kfree(bio->bi_io_vec);
-	kfree(bio);
-}
-
 void bio_init(struct bio *bio)
 {
 	memset(bio, 0, sizeof(*bio));
@@ -301,21 +278,15 @@ void bio_init(struct bio *bio)
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	unsigned long idx = BIO_POOL_NONE;
 	struct bio_vec *bvl = NULL;
-	struct bio *bio = NULL;
-	unsigned long idx = 0;
-	void *p = NULL;
-
-	if (bs) {
-		p = mempool_alloc(bs->bio_pool, gfp_mask);
-		if (!p)
-			goto err;
-		bio = p + bs->front_pad;
-	} else {
-		bio = kmalloc(sizeof(*bio), gfp_mask);
-		if (!bio)
-			goto err;
-	}
+	struct bio *bio;
+	void *p;
+
+	p = mempool_alloc(bs->bio_pool, gfp_mask);
+	if (unlikely(!p))
+		return NULL;
+	bio = p + bs->front_pad;
 
 	bio_init(bio);
 
@@ -332,22 +303,33 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 		nr_iovecs = bvec_nr_vecs(idx);
 	}
+out_set:
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
-out_set:
 	bio->bi_io_vec = bvl;
-
 	return bio;
 
 err_free:
-	if (bs)
-		mempool_free(p, bs->bio_pool);
-	else
-		kfree(bio);
-err:
+	mempool_free(p, bs->bio_pool);
 	return NULL;
 }
 
+static void bio_fs_destructor(struct bio *bio)
+{
+	bio_free(bio, fs_bio_set);
+}
+
+/**
+ *	bio_alloc - allocate a new bio, memory pool backed
+ *	@gfp_mask: allocation mask to use
+ *	@nr_iovecs: number of iovecs
+ *
+ *	Allocate a new bio with @nr_iovecs bvecs.  If @gfp_mask
+ *	contains __GFP_WAIT, the allocation is guaranteed to succeed.
+ *
+ *	RETURNS:
+ *	Pointer to new bio on success, NULL on failure.
+ */
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
@@ -358,19 +340,39 @@ struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 	return bio;
 }
 
-/*
- * Like bio_alloc(), but doesn't use a mempool backing. This means that
- * it CAN fail, but while bio_alloc() can only be used for allocations
- * that have a short (finite) life span, bio_kmalloc() should be used
- * for more permanent bio allocations (like allocating some bio's for
- * initalization or setup purposes).
+static void bio_kmalloc_destructor(struct bio *bio)
+{
+	if (bio_integrity(bio))
+		bio_integrity_free(bio);
+	kfree(bio);
+}
+
+/**
+ *	bio_kmalloc - allocate a new bio
+ *	@gfp_mask: allocation mask to use
+ *	@nr_iovecs: number of iovecs
+ *
+ *	Similar to bio_alloc() but uses regular kmalloc for allocation
+ *	and can fail unless __GFP_NOFAIL is set in @gfp_mask.  This is
+ *	useful for more permanant or over-sized bio allocations.
+ *
+ *	RETURNS:
+ *	Poitner to new bio on success, NULL on failure.
  */
 struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
 {
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
+	struct bio *bio;
 
-	if (bio)
-		bio->bi_destructor = bio_kmalloc_destructor;
+	bio = kmalloc(sizeof(struct bio) + nr_iovecs * sizeof(struct bio_vec),
+		      gfp_mask);
+	if (unlikely(!bio))
+		return NULL;
+
+	bio_init(bio);
+	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
+	bio->bi_max_vecs = nr_iovecs;
+	bio->bi_io_vec = bio->bi_inline_vecs;
+	bio->bi_destructor = bio_kmalloc_destructor;
 
 	return bio;
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b89cf2d..7b214fd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -132,6 +132,7 @@ struct bio {
  * top 4 bits of bio flags indicate the pool this bio came from
  */
 #define BIO_POOL_BITS		(4)
+#define BIO_POOL_NONE		((1UL << BIO_POOL_BITS) - 1)
 #define BIO_POOL_OFFSET		(BITS_PER_LONG - BIO_POOL_BITS)
 #define BIO_POOL_MASK		(1UL << BIO_POOL_OFFSET)
 #define BIO_POOL_IDX(bio)	((bio)->bi_flags >> BIO_POOL_OFFSET)	
-- 
1.6.0.2

