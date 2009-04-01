Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbZDALHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbZDALHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZDALFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:05:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:35199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbZDALFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:05:00 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] bio: fix bio_kmalloc()
Date: Wed,  1 Apr 2009 20:04:41 +0900
Message-Id: <1238583884-13517-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238583884-13517-1-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix bio_kmalloc() and its destruction path

bio_kmalloc() was broken in two ways.

* bvec_alloc_bs() first allocates bvec using kmalloc() and then
  ignores it and allocates again like non-kmalloc bvecs.

* bio_kmalloc_destructor() didn't check for and free bio integrity
  data.

This patch fixes the above problems.  kmalloc bvec allocation is moved
to bio_alloc_bioset().  While at it, also make the following changes.

* define and use BIO_POOL_NONE so that pool index check in
  bvec_free_bs() triggers if inline or kmalloc allocated bvec gets
  there.

* relocate destructors on top of each allocation function so that how
  they're used is more clear.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c            |   74 +++++++++++++++++++++++++++++----------------------
 include/linux/bio.h |    1 +
 2 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 7574839..e15e457 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -169,14 +169,6 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
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
@@ -254,21 +246,6 @@ void bio_free(struct bio *bio, struct bio_set *bs)
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
@@ -297,7 +274,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
 	struct bio_vec *bvl = NULL;
 	struct bio *bio = NULL;
-	unsigned long idx = 0;
+	unsigned long idx = BIO_POOL_NONE;
 	void *p = NULL;
 
 	if (bs) {
@@ -319,12 +296,15 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 	if (nr_iovecs <= BIO_INLINE_VECS) {
 		bvl = bio->bi_inline_vecs;
 		nr_iovecs = BIO_INLINE_VECS;
-	} else {
+	} else if (bs) {
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
 			goto err_free;
-
 		nr_iovecs = bvec_nr_vecs(idx);
+	} else {
+		bvl = kmalloc(nr_iovecs * sizeof(struct bio_vec), gfp_mask);
+		if (unlikely(!bvl))
+			goto err_free;
 	}
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
@@ -342,6 +322,22 @@ err:
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
@@ -352,12 +348,26 @@ struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
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
+	if (bio_has_allocated_vec(bio))
+		kfree(bio->bi_io_vec);
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
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 14e5f42..e01e41d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -133,6 +133,7 @@ struct bio {
  * top 4 bits of bio flags indicate the pool this bio came from
  */
 #define BIO_POOL_BITS		(4)
+#define BIO_POOL_NONE		((1 << BIO_POOL_BITS) - 1)
 #define BIO_POOL_OFFSET		(BITS_PER_LONG - BIO_POOL_BITS)
 #define BIO_POOL_MASK		(1UL << BIO_POOL_OFFSET)
 #define BIO_POOL_IDX(bio)	((bio)->bi_flags >> BIO_POOL_OFFSET)	
-- 
1.6.0.2

