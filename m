Return-Path: <linux-kernel-owner+w=401wt.eu-S940987AbXGaCYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940987AbXGaCYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940117AbXGaCRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:52806 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940489AbXGaCRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:47 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:33 +1000
Message-Id: <1070731021733.25386@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 020 of 35] Add bi_offset and allow a bio to reference only part of a bi_io_vec
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


To allow bi_io_vec sharing, a bio now can reference just part of the
io_vec.  In particular, the first bi_offset bytes are not included,
and exactly bi_size bytes are included, even if the bi_io_vec goes
beyond there.

bi_offset must be less than bv_len of the first bvec.

This patch only handles the ll_rw_blk usage of bios.  More
changes are need (e.g. in md, dm, umem,...) before it is safe to
set bi_offset non-zero, or bi_size less than sum of bv_len.

To make segment merging easier, we also store the actual length
of the bio_vec in the request:  last_idx, last_len.  These are
calculated in blk_recalc_rq_segments.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   36 +++++++++++++++++++++------
 ./drivers/md/raid10.c    |    1 
 ./fs/bio.c               |    7 +++--
 ./include/linux/bio.h    |   62 ++++++++++++++++++++++++++++++++++++++++-------
 ./include/linux/blkdev.h |   25 ++++++++----------
 ./mm/bounce.c            |    1 
 6 files changed, 98 insertions(+), 34 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:06.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:07.000000000 +1000
@@ -481,6 +481,16 @@ static inline struct request *start_orde
 	return rq;
 }
 
+static inline int rq_virt_mergeable(struct request *req,
+				    struct request *nxt)
+{
+	return BLK_VIRT_MERGEABLE(
+		req->biotail->bi_io_vec[req->last_idx].bv_page,
+		   req->last_len,
+		nxt->bio->bi_io_vec[0].bv_page,
+		   nxt->bio->bi_io_vec[0].bv_offset + nxt->bio->bi_offset);
+}
+
 int blk_do_ordered(struct request_queue *q, struct request **rqp)
 {
 	struct request *rq = *rqp;
@@ -1207,6 +1217,7 @@ static void blk_recalc_rq_segments(struc
 	unsigned int hw_size;
 	struct bio_vec bv;
 	struct bio_vec bvprv = {0};
+	int prvidx = 0;
 	int seg_size;
 	int hw_seg_size;
 	int cluster;
@@ -1242,6 +1253,7 @@ static void blk_recalc_rq_segments(struc
 			seg_size += bv.bv_len;
 			hw_seg_size += bv.bv_len;
 			bvprv = bv;
+			prvidx = i.i.i;
 			continue;
 		}
 new_segment:
@@ -1259,9 +1271,12 @@ new_hw_segment:
 
 		nr_phys_segs++;
 		bvprv = bv;
+		prvidx = i.i.i;
 		seg_size = bv.bv_len;
 		highprv = high;
 	}
+	rq->last_len = bvprv.bv_offset + bvprv.bv_len;
+	rq->last_idx = prvidx;
 
 	if (nr_hw_segs == 1 &&
 	    hw_seg_size > rq->hw_front_size)
@@ -1278,8 +1293,11 @@ static int blk_phys_contig_segment(struc
 	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
 		return 0;
 
-	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(req->biotail),
-				   __BVEC_START(nxt->bio)))
+	if (!BLK_PHYS_MERGEABLE(
+		    req->biotail->bi_io_vec[req->last_idx].bv_page,
+		       req->last_len,
+		    nxt->bio->bi_io_vec[0].bv_page,
+		       nxt->bio->bi_io_vec[0].bv_offset + nxt->bio->bi_offset))
 		return 0;
 	if (req->biotail->bi_size + nxt->bio->bi_size > q->max_segment_size)
 		return 0;
@@ -1301,8 +1319,8 @@ static int blk_hw_contig_segment(struct 
 		blk_recount_segments(q, req->biotail);
 	if (unlikely(!bio_flagged(nxt->bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, nxt->bio);
-	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
-				   __BVEC_START(nxt->bio)) ||
+
+	if (!rq_virt_mergeable(req, nxt) ||
 	    BIOVEC_VIRT_OVERSIZE(req->hw_back_size +
 				 nxt->hw_front_size))
 		return 0;
@@ -1419,8 +1437,7 @@ static int ll_back_merge_fn(struct reque
 
 	len = req->hw_back_size + nreq->hw_front_size;
 	if (nreq->first_offset == 0 &&
-	    BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
-				  __BVEC_START(nreq->bio)) &&
+	    rq_virt_mergeable(req, nreq) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
 		int mergeable = ll_new_mergeable(q, req, nreq);
 
@@ -1453,8 +1470,7 @@ static int ll_front_merge_fn(struct requ
 
 	len = nreq->hw_back_size + req->hw_front_size;
 
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(nreq->biotail),
-				  __BVEC_START(req->bio)) &&
+	if (rq_virt_mergeable(nreq, req) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
 		int mergeable = ll_new_mergeable(q, req, nreq);
 
@@ -2842,6 +2858,8 @@ static int attempt_merge(struct request_
 
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
+	req->last_idx = next->last_idx;
+	req->last_len = next->last_len;
 
 	req->nr_sectors = req->hard_nr_sectors += next->hard_nr_sectors;
 
@@ -2958,6 +2976,8 @@ static int __make_request(struct request
 			req->biotail->bi_next = bio;
 			req->biotail = bio;
 			req->hw_back_size = nreq.hw_back_size;
+			req->last_idx = nreq.last_idx;
+			req->last_len = nreq.last_len;
 			req->nr_sectors = req->hard_nr_sectors += nr_sectors;
 			req->ioprio = ioprio_best(req->ioprio, prio);
 			drive_stat_acct(req, nr_sectors, 0);

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:07.000000000 +1000
@@ -1285,6 +1285,7 @@ static void sync_request_write(mddev_t *
 		tbio->bi_rw = WRITE;
 		tbio->bi_private = r10_bio;
 		tbio->bi_sector = r10_bio->devs[i].addr;
+		tbio->bi_offset = 0;
 
 		for (j=0; j < vcnt ; j++) {
 			tbio->bi_io_vec[j].bv_offset = 0;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:06.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:07.000000000 +1000
@@ -134,6 +134,7 @@ void bio_init(struct bio *bio)
 	bio->bi_vcnt = 0;
 	bio->bi_phys_segments = 0;
 	bio->bi_hw_segments = 0;
+	bio->bi_offset = 0;
 	bio->bi_size = 0;
 	bio->bi_max_vecs = 0;
 	bio->bi_end_io = NULL;
@@ -266,6 +267,7 @@ void __bio_clone(struct bio *bio, struct
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
+	bio->bi_offset = bio_src->bi_offset;
 	bio_phys_segments(q, bio);
 	bio_hw_segments(q, bio);
 }
@@ -396,9 +398,8 @@ static int __bio_add_page(struct request
 	}
 
 	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec) ||
-	    BIOVEC_VIRT_MERGEABLE(bvec-1, bvec)))
-		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+	/* NOTE: This looks inefficient, but will go away */
+	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:06.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:07.000000000 +1000
@@ -91,7 +91,13 @@ struct bio {
 	 */
 	unsigned short		bi_hw_segments;
 
-	unsigned int		bi_size;	/* residual I/O count */
+	/* This bio only refers to part of the data in bi_io_vec.
+	 * The first bi_offset bytes are not included, and anything after
+	 * the bi_size bytes beyond there are also ignored.
+	 * bi_offset must be less than bi_io_vec[0].bv_len;
+	 */
+	unsigned int		bi_offset;
+	unsigned int		bi_size;
 
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
@@ -184,13 +190,21 @@ struct bio {
 /*
  * allow arch override, for eg virtualized architectures (put in asm/io.h)
  */
-#ifndef BIOVEC_PHYS_MERGEABLE
-#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
-	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
+#ifndef BLK_PHYS_MERGEABLE
+#define BLK_PHYS_MERGEABLE(p1, end, p2, start)	\
+	((page_to_phys(p1)+end) == (page_to_phys(p2)+start))
 #endif
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
+	BLK_PHYS_MERGEABLE((vec1)->bv_page, (vec1)->bv_offset + (vec1)->bv_len, \
+			    (vec2)->bv_page, (vec2)->bv_offset)
 
+#define BLK_VIRT_MERGEABLE(p1, end, p2, start)	\
+	((((page_to_phys(p1)+end) | (page_to_phys(p2)+start)) 	\
+		& (BIO_VMERGE_BOUNDARY - 1)) == 0)
 #define BIOVEC_VIRT_MERGEABLE(vec1, vec2)	\
-	((((bvec_to_phys((vec1)) + (vec1)->bv_len) | bvec_to_phys((vec2))) & (BIO_VMERGE_BOUNDARY - 1)) == 0)
+	BLK_VIRT_MERGEABLE((vec1)->bv_page, (vec1)->bv_offset + (vec1)->bv_len,\
+			    (vec2)->bv_page, (vec2)->bv_offset)
+
 #define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
@@ -202,12 +216,42 @@ struct bio {
 
 struct bio_iterator {
 	int i;
+	int offset;
+	int size;
 };
-#define bio_for_each_segment(bvl, bio, i)				\
-	for (i.i = 0, bvl = *bio_iovec_idx((bio), i.i);			\
-	     i.i < (bio)->bi_vcnt;					\
-	     i.i++, bvl = *bio_iovec_idx((bio), i.i))
 
+/* This macro probably need some explanation...
+ * Its purpose is to find all the effective segments in a bio
+ * missing the first 'offs' bytes.  We need to be sure to honour
+ * bi_offset which can cause us to skip part of the firs segment,
+ * and bi_size which may cause us to stop before the end of bi_io_vec.
+ * The 'for' loop iterates through the segments in bi_io_vec until
+ * we have returned 'bi_size - offs' bytes.
+ * The 'if' sets up the 'bv' to return, adjusts the start if there
+ * is still some 'offset' to deal with, adjusts the length if
+ * we have come to the end, and avoids the call of the body (which
+ * follows this macro) if the size would be zero.
+ * It also keeps 'offset' and 'size' (in the iterator) up to date.
+ */
+#define bio_for_each_segment_offset(bv, bio, _i, offs)			\
+	for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,		\
+		 _i.size = (bio)->bi_size - offs;			\
+	     _i.i < (bio)->bi_vcnt && _i.size > 0;			\
+	     _i.i++)							\
+		if (bv = *bio_iovec_idx((bio), _i.i),			\
+		    bv.bv_offset += _i.offset,				\
+		    bv.bv_len <= _i.offset				\
+		    ? (_i.offset -= bv.bv_len, 0)			\
+		    : (bv.bv_len -= _i.offset,				\
+		       _i.offset = 0,					\
+		       bv.bv_len < _i.size				\
+		       ? (_i.size -= bv.bv_len, 1)			\
+		       : (bv.bv_len = _i.size,				\
+			  _i.size = 0,					\
+			  bv.bv_len > 0)))
+
+#define bio_for_each_segment(bv, bio, __i)				\
+		bio_for_each_segment_offset(bv, bio, __i, 0)
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:03.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:07.000000000 +1000
@@ -255,6 +255,13 @@ struct request {
 	struct bio *bio;
 	struct bio *biotail;
 	int first_offset;	/* offset into first bio in list */
+	int last_idx, last_len; /* idx and effective len of last
+				 * bio_vec in biotail.  last_len
+				 * is actually an offset in the page
+				 * of the end of the segment.
+				 * so it matches bv_offset+bv_len in
+				 * the simple case.
+				 */
 
 	struct hlist_node hash;	/* merge hash */
 	/*
@@ -647,7 +654,7 @@ static inline void blk_queue_bounce(stru
 #endif /* CONFIG_MMU */
 
 struct req_iterator {
-	int i;
+	struct bio_iterator i;
 	struct bio *bio;
 	int offset;
 };
@@ -655,21 +662,11 @@ struct req_iterator {
 	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset;	       \
 	     _iter.bio;							       \
 	     _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 		       \
-		for (_iter.i = 0;		 			       \
-		     _iter.i < _iter.bio->bi_vcnt;			       \
-		     _iter.i++						       \
-		)							       \
-			if (bvec = *bio_iovec_idx(_iter.bio, _iter.i),	       \
-			    bvec.bv_offset += _iter.offset,		       \
-			    bvec.bv_len <= _iter.offset			       \
-				? (_iter.offset -= bvec.bv_len, 0)	       \
-				: (bvec.bv_len -= _iter.offset,		       \
-				   _iter.offset = 0,			       \
-				   1))
-
+		bio_for_each_segment_offset(bvec, _iter.bio, _iter.i,	       \
+			_iter.offset)
 
 #define rq_iter_last(rq, _iter) (_iter.bio->bi_next == NULL && 	\
-				 _iter.i == _iter.bio->bi_vcnt - 1)
+				 _iter.i.i == _iter.bio->bi_vcnt - 1)
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);

diff .prev/mm/bounce.c ./mm/bounce.c
--- .prev/mm/bounce.c	2007-07-31 11:21:06.000000000 +1000
+++ ./mm/bounce.c	2007-07-31 11:21:07.000000000 +1000
@@ -245,6 +245,7 @@ static void __blk_queue_bounce(struct re
 
 	bio->bi_vcnt = (*bio_orig)->bi_vcnt;
 	bio->bi_size = (*bio_orig)->bi_size;
+	bio->bi_offset = (*bio_orig)->bi_offset;
 
 	if (pool == page_pool) {
 		bio->bi_end_io = bounce_end_io_write;
