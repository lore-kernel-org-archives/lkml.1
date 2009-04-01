Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbZDANuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbZDANuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765479AbZDANpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:45:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:44743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764757AbZDANo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:56 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/17] blk-map/bio: rename stuff
Date: Wed,  1 Apr 2009 22:44:22 +0900
Message-Id: <1238593472-30360-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

blk-map and bio are about to go through major update.  Make the
following renames to ease future changes.

* more concise/wieldy names: s/gfp_mask/gfp/, s/map_data/md/,
  s/iov_count/count/.  Note that count is and will continue to be used
  only for number of entries in iovec.  Similarly, nents will be used
  for number of entries in sgl.

* less confusing names: bio_map_data doesn't have much to do with
  mapping per-se but is aux info for copying.  Also, it's very
  confusing with rq_map_data which BTW is reserved pool of pages for
  copying.  Rename bio_map_data to bio_copy_info and everything
  related to bci_*().  This part of API is gonna receive major
  overhaul.  The names and semantics will get clearer with future
  changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c        |   37 ++++----
 fs/bio.c               |  231 +++++++++++++++++++++++------------------------
 include/linux/bio.h    |   37 ++++----
 include/linux/blkdev.h |    4 +-
 4 files changed, 150 insertions(+), 159 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 4f0221a..eb206df 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -43,11 +43,11 @@ static int __blk_rq_unmap_user(struct bio *bio)
  * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request to map data to
- * @map_data:   pointer to the rq_map_data holding pages (if necessary)
+ * @md:		pointer to the rq_map_data holding pages (if necessary)
  * @iov:	pointer to the iovec
- * @iov_count:	number of elements in the iovec
+ * @count:	number of elements in the iovec
  * @len:	I/O byte count
- * @gfp_mask:	memory allocation flags
+ * @gfp:	memory allocation flags
  *
  * Description:
  *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
@@ -63,20 +63,19 @@ static int __blk_rq_unmap_user(struct bio *bio)
  *    unmapping.
  */
 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
-			struct rq_map_data *map_data, struct iovec *iov,
-			int iov_count, unsigned int len, gfp_t gfp_mask)
+			struct rq_map_data *md, struct iovec *iov, int count,
+			unsigned int len, gfp_t gfp)
 {
 	struct bio *bio = ERR_PTR(-EINVAL);
 	int rw = rq_data_dir(rq);
 
-	if (!iov || iov_count <= 0)
+	if (!iov || count <= 0)
 		return -EINVAL;
 
-	if (!map_data)
-		bio = bio_map_user_iov(q, NULL, iov, iov_count, rw, gfp_mask);
+	if (!md)
+		bio = bio_map_user_iov(q, NULL, iov, count, rw, gfp);
 	if (bio == ERR_PTR(-EINVAL))
-		bio = bio_copy_user_iov(q, map_data, iov, iov_count, rw,
-					gfp_mask);
+		bio = bio_copy_user_iov(q, md, iov, count, rw, gfp);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
@@ -107,10 +106,10 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
  * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request structure to fill
- * @map_data:   pointer to the rq_map_data holding pages (if necessary)
+ * @md:		pointer to the rq_map_data holding pages (if necessary)
  * @ubuf:	the user buffer
  * @len:	length of user data
- * @gfp_mask:	memory allocation flags
+ * @gfp:	memory allocation flags
  *
  * Description:
  *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
@@ -126,15 +125,15 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
  *    unmapping.
  */
 int blk_rq_map_user(struct request_queue *q, struct request *rq,
-		    struct rq_map_data *map_data, void __user *ubuf,
-		    unsigned long len, gfp_t gfp_mask)
+		    struct rq_map_data *md, void __user *ubuf,
+		    unsigned long len, gfp_t gfp)
 {
 	struct iovec iov;
 
 	iov.iov_base = ubuf;
 	iov.iov_len = len;
 
-	return blk_rq_map_user_iov(q, rq, map_data, &iov, 1, len, gfp_mask);
+	return blk_rq_map_user_iov(q, rq, md, &iov, 1, len, gfp);
 }
 EXPORT_SYMBOL(blk_rq_map_user);
 
@@ -167,14 +166,14 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
  * @rq:		request to fill
  * @kbuf:	the kernel buffer
  * @len:	length of user data
- * @gfp_mask:	memory allocation flags
+ * @gfp:	memory allocation flags
  *
  * Description:
  *    Data will be mapped directly if possible. Otherwise a bounce
  *    buffer is used.
  */
 int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
-		    unsigned int len, gfp_t gfp_mask)
+		    unsigned int len, gfp_t gfp)
 {
 	int rw = rq_data_dir(rq);
 	int do_copy = 0;
@@ -187,9 +186,9 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 
 	do_copy = !blk_rq_aligned(q, kbuf, len) || object_is_on_stack(kbuf);
 	if (do_copy)
-		bio = bio_copy_kern(q, kbuf, len, gfp_mask, rw);
+		bio = bio_copy_kern(q, kbuf, len, gfp, rw);
 	else
-		bio = bio_map_kern(q, kbuf, len, gfp_mask);
+		bio = bio_map_kern(q, kbuf, len, gfp);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
diff --git a/fs/bio.c b/fs/bio.c
index 9d13f21..1cd97e3 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -163,7 +163,7 @@ void bvec_free_bs(struct bio_set *bs, struct bio_vec *bv, unsigned int idx)
 	}
 }
 
-struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
+struct bio_vec *bvec_alloc_bs(gfp_t gfp, int nr, unsigned long *idx,
 			      struct bio_set *bs)
 {
 	struct bio_vec *bvl;
@@ -200,24 +200,24 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
 	 */
 	if (*idx == BIOVEC_MAX_IDX) {
 fallback:
-		bvl = mempool_alloc(bs->bvec_pool, gfp_mask);
+		bvl = mempool_alloc(bs->bvec_pool, gfp);
 	} else {
 		struct biovec_slab *bvs = bvec_slabs + *idx;
-		gfp_t __gfp_mask = gfp_mask & ~(__GFP_WAIT | __GFP_IO);
+		gfp_t __gfp = gfp & ~(__GFP_WAIT | __GFP_IO);
 
 		/*
 		 * Make this allocation restricted and don't dump info on
 		 * allocation failures, since we'll fallback to the mempool
 		 * in case of failure.
 		 */
-		__gfp_mask |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+		__gfp |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 
 		/*
 		 * Try a slab allocation. If this fails and __GFP_WAIT
 		 * is set, retry with the 1-entry mempool
 		 */
-		bvl = kmem_cache_alloc(bvs->slab, __gfp_mask);
-		if (unlikely(!bvl && (gfp_mask & __GFP_WAIT))) {
+		bvl = kmem_cache_alloc(bvs->slab, __gfp);
+		if (unlikely(!bvl && (gfp & __GFP_WAIT))) {
 			*idx = BIOVEC_MAX_IDX;
 			goto fallback;
 		}
@@ -256,7 +256,7 @@ void bio_init(struct bio *bio)
 
 /**
  * bio_alloc_bioset - allocate a bio for I/O
- * @gfp_mask:   the GFP_ mask given to the slab allocator
+ * @gfp:	the GFP_ mask given to the slab allocator
  * @nr_iovecs:	number of iovecs to pre-allocate
  * @bs:		the bio_set to allocate from. If %NULL, just use kmalloc
  *
@@ -270,7 +270,7 @@ void bio_init(struct bio *bio)
  *   of a bio, to do the appropriate freeing of the bio once the reference
  *   count drops to zero.
  **/
-struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
+struct bio *bio_alloc_bioset(gfp_t gfp, int nr_iovecs, struct bio_set *bs)
 {
 	struct bio_vec *bvl = NULL;
 	struct bio *bio = NULL;
@@ -278,12 +278,12 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 	void *p = NULL;
 
 	if (bs) {
-		p = mempool_alloc(bs->bio_pool, gfp_mask);
+		p = mempool_alloc(bs->bio_pool, gfp);
 		if (!p)
 			goto err;
 		bio = p + bs->front_pad;
 	} else {
-		bio = kmalloc(sizeof(*bio), gfp_mask);
+		bio = kmalloc(sizeof(*bio), gfp);
 		if (!bio)
 			goto err;
 	}
@@ -297,12 +297,12 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		bvl = bio->bi_inline_vecs;
 		nr_iovecs = BIO_INLINE_VECS;
 	} else if (bs) {
-		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+		bvl = bvec_alloc_bs(gfp, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
 			goto err_free;
 		nr_iovecs = bvec_nr_vecs(idx);
 	} else {
-		bvl = kmalloc(nr_iovecs * sizeof(struct bio_vec), gfp_mask);
+		bvl = kmalloc(nr_iovecs * sizeof(struct bio_vec), gfp);
 		if (unlikely(!bvl))
 			goto err_free;
 	}
@@ -329,18 +329,18 @@ static void bio_fs_destructor(struct bio *bio)
 
 /**
  *	bio_alloc - allocate a new bio, memory pool backed
- *	@gfp_mask: allocation mask to use
+ *	@gfp: allocation mask to use
  *	@nr_iovecs: number of iovecs
  *
- *	Allocate a new bio with @nr_iovecs bvecs.  If @gfp_mask
+ *	Allocate a new bio with @nr_iovecs bvecs.  If @gfp
  *	contains __GFP_WAIT, the allocation is guaranteed to succeed.
  *
  *	RETURNS:
  *	Pointer to new bio on success, NULL on failure.
  */
-struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
+struct bio *bio_alloc(gfp_t gfp, int nr_iovecs)
 {
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
+	struct bio *bio = bio_alloc_bioset(gfp, nr_iovecs, fs_bio_set);
 
 	if (bio)
 		bio->bi_destructor = bio_fs_destructor;
@@ -359,19 +359,19 @@ static void bio_kmalloc_destructor(struct bio *bio)
 
 /**
  *	bio_kmalloc - allocate a new bio
- *	@gfp_mask: allocation mask to use
+ *	@gfp: allocation mask to use
  *	@nr_iovecs: number of iovecs
  *
  *	Similar to bio_alloc() but uses regular kmalloc for allocation
- *	and can fail unless __GFP_NOFAIL is set in @gfp_mask.  This is
+ *	and can fail unless __GFP_NOFAIL is set in @gfp.  This is
  *	useful for more permanant or over-sized bio allocations.
  *
  *	RETURNS:
  *	Poitner to new bio on success, NULL on failure.
  */
-struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
+struct bio *bio_kmalloc(gfp_t gfp, int nr_iovecs)
 {
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, NULL);
+	struct bio *bio = bio_alloc_bioset(gfp, nr_iovecs, NULL);
 
 	if (bio)
 		bio->bi_destructor = bio_kmalloc_destructor;
@@ -453,13 +453,13 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 /**
  *	bio_clone	-	clone a bio
  *	@bio: bio to clone
- *	@gfp_mask: allocation priority
+ *	@gfp: allocation priority
  *
  * 	Like __bio_clone, only also allocates the returned bio
  */
-struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
+struct bio *bio_clone(struct bio *bio, gfp_t gfp)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
+	struct bio *b = bio_alloc_bioset(gfp, bio->bi_max_vecs, fs_bio_set);
 
 	if (!b)
 		return NULL;
@@ -470,7 +470,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask);
+		ret = bio_integrity_clone(b, bio, gfp);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -653,56 +653,54 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
-struct bio_map_data {
-	struct bio_vec *iovecs;
-	struct iovec *sgvecs;
-	int nr_sgvecs;
-	int is_our_pages;
+struct bio_copy_info {
+	struct bio_vec		*iovecs;
+	struct iovec		*src_iov;
+	int			src_count;
+	int			is_our_pages;
 };
 
-static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
-			     struct iovec *iov, int iov_count,
-			     int is_our_pages)
+static void bci_set(struct bio_copy_info *bci, struct bio *bio,
+		    struct iovec *iov, int count, int is_our_pages)
 {
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
-	memcpy(bmd->sgvecs, iov, sizeof(struct iovec) * iov_count);
-	bmd->nr_sgvecs = iov_count;
-	bmd->is_our_pages = is_our_pages;
-	bio->bi_private = bmd;
+	memcpy(bci->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
+	memcpy(bci->src_iov, iov, sizeof(struct iovec) * count);
+	bci->src_count = count;
+	bci->is_our_pages = is_our_pages;
+	bio->bi_private = bci;
 }
 
-static void bio_free_map_data(struct bio_map_data *bmd)
+static void bci_free(struct bio_copy_info *bci)
 {
-	kfree(bmd->iovecs);
-	kfree(bmd->sgvecs);
-	kfree(bmd);
+	kfree(bci->iovecs);
+	kfree(bci->src_iov);
+	kfree(bci);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
-					       gfp_t gfp_mask)
+static struct bio_copy_info *bci_alloc(int nr_segs, int count, gfp_t gfp)
 {
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), gfp_mask);
+	struct bio_copy_info *bci = kmalloc(sizeof(*bci), gfp);
 
-	if (!bmd)
+	if (!bci)
 		return NULL;
 
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp_mask);
-	if (!bmd->iovecs) {
-		kfree(bmd);
+	bci->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp);
+	if (!bci->iovecs) {
+		kfree(bci);
 		return NULL;
 	}
 
-	bmd->sgvecs = kmalloc(sizeof(struct iovec) * iov_count, gfp_mask);
-	if (bmd->sgvecs)
-		return bmd;
+	bci->src_iov = kmalloc(sizeof(struct iovec) * count, gfp);
+	if (bci->src_count)
+		return bci;
 
-	kfree(bmd->iovecs);
-	kfree(bmd);
+	kfree(bci->iovecs);
+	kfree(bci);
 	return NULL;
 }
 
 static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct iovec *iov, int iov_count, int uncopy,
+			  struct iovec *iov, int count, int uncopy,
 			  int do_free_page)
 {
 	int ret = 0, i;
@@ -715,7 +713,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 		char *bv_addr = page_address(bvec->bv_page);
 		unsigned int bv_len = iovecs[i].bv_len;
 
-		while (bv_len && iov_idx < iov_count) {
+		while (bv_len && iov_idx < count) {
 			unsigned int bytes;
 			char *iov_addr;
 
@@ -762,13 +760,13 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
  */
 int bio_uncopy_user(struct bio *bio)
 {
-	struct bio_map_data *bmd = bio->bi_private;
+	struct bio_copy_info *bci = bio->bi_private;
 	int ret = 0;
 
 	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, 1, bmd->is_our_pages);
-	bio_free_map_data(bmd);
+		ret = __bio_copy_iov(bio, bci->iovecs, bci->src_iov,
+				     bci->src_count, 1, bci->is_our_pages);
+	bci_free(bci);
 	bio_put(bio);
 	return ret;
 }
@@ -776,31 +774,29 @@ int bio_uncopy_user(struct bio *bio)
 /**
  *	bio_copy_user_iov	-	copy user data to bio
  *	@q: destination block queue
- *	@map_data: pointer to the rq_map_data holding pages (if necessary)
- *	@iov:	the iovec.
- *	@iov_count: number of elements in the iovec
+ *	@md: pointer to the rq_map_data holding pages (if necessary)
+ *	@iov: the iovec.
+ *	@count: number of elements in the iovec
  *	@rw: READ or WRITE
- *	@gfp_mask: memory allocation flags
+ *	@gfp: memory allocation flags
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
-struct bio *bio_copy_user_iov(struct request_queue *q,
-			      struct rq_map_data *map_data,
-			      struct iovec *iov, int iov_count, int rw,
-			      gfp_t gfp_mask)
+struct bio *bio_copy_user_iov(struct request_queue *q, struct rq_map_data *md,
+			      struct iovec *iov, int count, int rw, gfp_t gfp)
 {
-	struct bio_map_data *bmd;
+	struct bio_copy_info *bci;
 	struct bio_vec *bvec;
 	struct page *page;
 	struct bio *bio;
 	int i, ret;
 	int nr_pages = 0;
 	unsigned int len = 0;
-	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK : 0;
+	unsigned int offset = md ? md->offset & ~PAGE_MASK : 0;
 
-	for (i = 0; i < iov_count; i++) {
+	for (i = 0; i < count; i++) {
 		unsigned long uaddr;
 		unsigned long end;
 		unsigned long start;
@@ -813,23 +809,23 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		len += iov[i].iov_len;
 	}
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
-	if (!bmd)
+	bci = bci_alloc(nr_pages, count, gfp);
+	if (!bci)
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	bio = bio_kmalloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp, nr_pages);
 	if (!bio)
-		goto out_bmd;
+		goto out_bci;
 
 	if (rw == WRITE)
 		bio->bi_rw |= 1 << BIO_RW;
 
 	ret = 0;
 
-	if (map_data) {
-		nr_pages = 1 << map_data->page_order;
-		i = map_data->offset / PAGE_SIZE;
+	if (md) {
+		nr_pages = 1 << md->page_order;
+		i = md->offset / PAGE_SIZE;
 	}
 	while (len) {
 		unsigned int bytes = PAGE_SIZE;
@@ -839,18 +835,18 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		if (bytes > len)
 			bytes = len;
 
-		if (map_data) {
-			if (i == map_data->nr_entries * nr_pages) {
+		if (md) {
+			if (i == md->nr_entries * nr_pages) {
 				ret = -ENOMEM;
 				break;
 			}
 
-			page = map_data->pages[i / nr_pages];
+			page = md->pages[i / nr_pages];
 			page += (i % nr_pages);
 
 			i++;
 		} else {
-			page = alloc_page(q->bounce_gfp | gfp_mask);
+			page = alloc_page(q->bounce_gfp | gfp);
 			if (!page) {
 				ret = -ENOMEM;
 				break;
@@ -870,56 +866,56 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	/*
 	 * success
 	 */
-	if (unlikely(map_data && map_data->null_mapped))
+	if (unlikely(md && md->null_mapped))
 		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
 	else if (rw == WRITE) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, count, 0, 0);
 		if (ret)
 			goto cleanup;
 	}
 
-	bio_set_map_data(bmd, bio, iov, iov_count, map_data ? 0 : 1);
+	bci_set(bci, bio, iov, count, md ? 0 : 1);
 	return bio;
 cleanup:
-	if (!map_data)
+	if (!md)
 		bio_for_each_segment(bvec, bio, i)
 			__free_page(bvec->bv_page);
 
 	bio_put(bio);
-out_bmd:
-	bio_free_map_data(bmd);
+out_bci:
+	bci_free(bci);
 	return ERR_PTR(ret);
 }
 
 /**
  *	bio_copy_user	-	copy user data to bio
  *	@q: destination block queue
- *	@map_data: pointer to the rq_map_data holding pages (if necessary)
+ *	@md: pointer to the rq_map_data holding pages (if necessary)
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@rw: READ or WRITE
- *	@gfp_mask: memory allocation flags
+ *	@gfp: memory allocation flags
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
-struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
+struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *md,
 			  unsigned long uaddr, unsigned int len, int rw,
-			  gfp_t gfp_mask)
+			  gfp_t gfp)
 {
 	struct iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_copy_user_iov(q, map_data, &iov, 1, rw, gfp_mask);
+	return bio_copy_user_iov(q, md, &iov, 1, rw, gfp);
 }
 
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
-				      struct iovec *iov, int iov_count,
-				      int rw, gfp_t gfp_mask)
+				      struct iovec *iov, int count, int rw,
+				      gfp_t gfp)
 {
 	int i, j;
 	size_t tot_len = 0;
@@ -929,7 +925,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	int cur_page = 0;
 	int ret, offset;
 
-	for (i = 0; i < iov_count; i++) {
+	for (i = 0; i < count; i++) {
 		unsigned long uaddr = (unsigned long)iov[i].iov_base;
 		unsigned long len = iov[i].iov_len;
 
@@ -950,16 +946,16 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages || tot_len & q->dma_pad_mask)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_kmalloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = kcalloc(nr_pages, sizeof(struct page *), gfp_mask);
+	pages = kcalloc(nr_pages, sizeof(struct page *), gfp);
 	if (!pages)
 		goto out;
 
-	for (i = 0; i < iov_count; i++) {
+	for (i = 0; i < count; i++) {
 		unsigned long uaddr = (unsigned long)iov[i].iov_base;
 		unsigned long len = iov[i].iov_len;
 		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -1034,21 +1030,21 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@rw: READ or WRITE
- *	@gfp_mask: memory allocation flags
+ *	@gfp: memory allocation flags
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
 			 unsigned long uaddr, unsigned int len, int rw,
-			 gfp_t gfp_mask)
+			 gfp_t gfp)
 {
 	struct iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, bdev, &iov, 1, rw, gfp_mask);
+	return bio_map_user_iov(q, bdev, &iov, 1, rw, gfp);
 }
 
 /**
@@ -1056,20 +1052,19 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
  *	@q: the struct request_queue for the bio
  *	@bdev: destination block device
  *	@iov:	the iovec.
- *	@iov_count: number of elements in the iovec
+ *	@count: number of elements in the iovec
  *	@rw: READ or WRITE
- *	@gfp_mask: memory allocation flags
+ *	@gfp: memory allocation flags
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
-			     struct iovec *iov, int iov_count, int rw,
-			     gfp_t gfp_mask)
+			     struct iovec *iov, int count, int rw, gfp_t gfp)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, bdev, iov, iov_count, rw, gfp_mask);
+	bio = __bio_map_user_iov(q, bdev, iov, count, rw, gfp);
 	if (IS_ERR(bio))
 		return bio;
 
@@ -1124,7 +1119,7 @@ static void bio_map_kern_endio(struct bio *bio, int err)
 
 
 static struct bio *__bio_map_kern(struct request_queue *q, void *data,
-				  unsigned int len, gfp_t gfp_mask)
+				  unsigned int len, gfp_t gfp)
 {
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -1133,7 +1128,7 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_kmalloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
@@ -1165,17 +1160,17 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
  *	@q: the struct request_queue for the bio
  *	@data: pointer to buffer to map
  *	@len: length in bytes
- *	@gfp_mask: allocation flags for bio allocation
+ *	@gfp: allocation flags for bio allocation
  *
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp_mask)
+			 gfp_t gfp)
 {
 	struct bio *bio;
 
-	bio = __bio_map_kern(q, data, len, gfp_mask);
+	bio = __bio_map_kern(q, data, len, gfp);
 	if (IS_ERR(bio))
 		return bio;
 
@@ -1193,13 +1188,13 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
-	struct bio_map_data *bmd = bio->bi_private;
+	struct bio_copy_info *bci = bio->bi_private;
 	int i;
-	char *p = bmd->sgvecs[0].iov_base;
+	char *p = bci->src_iov[0].iov_base;
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *addr = page_address(bvec->bv_page);
-		int len = bmd->iovecs[i].bv_len;
+		int len = bci->iovecs[i].bv_len;
 
 		if (read && !err)
 			memcpy(p, addr, len);
@@ -1208,7 +1203,7 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 		p += len;
 	}
 
-	bio_free_map_data(bmd);
+	bci_free(bci);
 	bio_put(bio);
 }
 
@@ -1217,20 +1212,20 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
  *	@q: the struct request_queue for the bio
  *	@data: pointer to buffer to copy
  *	@len: length in bytes
- *	@gfp_mask: allocation flags for bio and page allocation
+ *	@gfp: allocation flags for bio and page allocation
  *	@rw: READ or WRITE
  *
  *	copy the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
-			  gfp_t gfp_mask, int rw)
+			  gfp_t gfp, int rw)
 {
 	struct bio *bio;
 	struct bio_vec *bvec;
 	int i;
 
-	bio = bio_copy_user(q, NULL, (unsigned long)data, len, READ, gfp_mask);
+	bio = bio_copy_user(q, NULL, (unsigned long)data, len, READ, gfp);
 	if (IS_ERR(bio))
 		return bio;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8215ded..1c21e59 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -365,9 +365,9 @@ void bio_pair_release(struct bio_pair *dbio);
 struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad);
 void bioset_free(struct bio_set *bs);
 
-struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs);
-struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs);
-struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs);
+struct bio *bio_alloc(gfp_t gfp, int nr_iovecs);
+struct bio *bio_kmalloc(gfp_t gfp, int nr_iovecs);
+struct bio *bio_alloc_bioset(gfp_t gfp, int nr_iovecs, struct bio_set *bs);
 void bio_put(struct bio *bio);
 void bio_free(struct bio *bio, struct bio_set *bs);
 
@@ -375,7 +375,7 @@ void bio_endio(struct bio *bio, int error);
 int bio_phys_segments(struct request_queue *q, struct bio *bio);
 
 void __bio_clone(struct bio *bio, struct bio *bio_src);
-struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask);
+struct bio *bio_clone(struct bio *bio, gfp_t gfp);
 
 void bio_init(struct bio *bio);
 
@@ -388,27 +388,24 @@ sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 			   unsigned int offset);
 struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
 			 unsigned long uaddr, unsigned int len, int rw,
-			 gfp_t gfp_mask);
+			 gfp_t gfp);
 struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
-			     struct iovec *iov, int iov_count, int rw,
-			     gfp_t gfp_mask);
+			     struct iovec *iov, int count, int rw, gfp_t gfp);
 void bio_unmap_user(struct bio *bio);
-struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
+struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *md,
 			  unsigned long uaddr, unsigned int len, int rw,
-			  gfp_t gfp_mask);
-struct bio *bio_copy_user_iov(struct request_queue *q,
-			      struct rq_map_data *map_data,
-			      struct iovec *iov, int iov_count, int rw,
-			      gfp_t gfp_mask);
+			  gfp_t gfp);
+struct bio *bio_copy_user_iov(struct request_queue *q, struct rq_map_data *md,
+			      struct iovec *iov, int count, int rw, gfp_t gfp);
 int bio_uncopy_user(struct bio *bio);
 struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
-			 gfp_t gfp_mask);
+			 gfp_t gfp);
 struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
-			  gfp_t gfp_mask, int rw);
+			  gfp_t gfp, int rw);
 void bio_set_pages_dirty(struct bio *bio);
 void bio_check_pages_dirty(struct bio *bio);
 void zero_fill_bio(struct bio *bio);
-struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx,
+struct bio_vec *bvec_alloc_bs(gfp_t gfp, int nr, unsigned long *idx,
 			      struct bio_set *bs);
 void bvec_free_bs(struct bio_set *bs, struct bio_vec *bv, unsigned int idx);
 unsigned int bvec_nr_vecs(unsigned short idx);
@@ -530,7 +527,7 @@ static inline bool bio_integrity(struct bio *bio)
 }
 
 struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
-					gfp_t gfp_mask, unsigned int nr_vecs);
+					gfp_t gfp, unsigned int nr_vecs);
 void bio_integrity_free(struct bio *bio);
 int bio_integrity_add_page(struct bio *bio, struct page *page,
 			   unsigned int len, unsigned int offset);
@@ -543,14 +540,14 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
 void bio_integrity_trim(struct bio *bio, unsigned int offset,
 			unsigned int sectors);
 void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors);
-int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask);
+int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
 static inline bool bio_integrity(struct bio *bio)
 { return false; }
 static inline struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
-					gfp_t gfp_mask, unsigned int nr_vecs)
+					gfp_t gfp, unsigned int nr_vecs)
 { return NULL; }
 static inline void bio_integrity_free(struct bio *bio)
 { }
@@ -580,7 +577,7 @@ static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
 { }
 
 static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-				      gfp_t gfp_mask)
+				      gfp_t gfp)
 { return -EIO; }
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d7bb20c..d04e118 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -782,8 +782,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
-			       struct rq_map_data *map_data, struct iovec *iov,
-			       int iov_count, unsigned int len, gfp_t gfp_mask);
+			       struct rq_map_data *md, struct iovec *iov,
+			       int count, unsigned int len, gfp_t gfp);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.6.0.2

