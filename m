Return-Path: <linux-kernel-owner+w=401wt.eu-S1764034AbXHPFQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764034AbXHPFQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbXHPFOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:14:09 -0400
Received: from mail.suse.de ([195.135.220.2]:46461 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450AbXHPFOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:14:07 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 15:13:58 +1000
Message-Id: <1070816051358.31404@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 005 of 5] Merge blk_recount_segments into blk_recalc_rq_segments
References: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


blk_recalc_rq_segments calls blk_recount_segments on each bio,
then does some extra calculations to handle segments that overlap
two bios.

If we merge the code from blk_recount_segments into
blk_recalc_rq_segments, we can process the whole request one bio_vec
at a time, and not need the messy cross-bio calculations.

Then blk_recount_segments can be implemented by calling
blk_recalc_rq_segments, passing it a simple on-stack request which
stores just the bio.  This function is only temporary and will go away
completely by the end of this patch series.

This allows us to remove rq_for_each_bio


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |  125 ++++++++++++++++++++---------------------------
 ./include/linux/blkdev.h |    3 -
 2 files changed, 55 insertions(+), 73 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 15:02:31.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 15:02:31.000000000 +1000
@@ -42,6 +42,7 @@ static void drive_stat_acct(struct reque
 static void init_request_from_bio(struct request *req, struct bio *bio);
 static int __make_request(struct request_queue *q, struct bio *bio);
 static struct io_context *current_io_context(gfp_t gfp_flags, int node);
+static void blk_recalc_rq_segments(struct request *rq);
 
 /*
  * For the allocated request tables
@@ -1209,65 +1210,91 @@ EXPORT_SYMBOL(blk_dump_rq_flags);
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
-	struct bio_vec *bv, *bvprv = NULL;
-	int i, nr_phys_segs, nr_hw_segs, seg_size, hw_seg_size, cluster;
+	struct request rq;
+	struct bio *nxt = bio->bi_next;
+	rq.q = q;
+	rq.bio = rq.biotail = bio;
+	bio->bi_next = NULL;
+	blk_recalc_rq_segments(&rq);
+	bio->bi_next = nxt;
+	bio->bi_phys_segments = rq.nr_phys_segments;
+	bio->bi_hw_segments = rq.nr_hw_segments;
+	bio->bi_flags |= (1 << BIO_SEG_VALID);
+}
+EXPORT_SYMBOL(blk_recount_segments);
+
+static void blk_recalc_rq_segments(struct request *rq)
+{
+	int nr_phys_segs;
+	int nr_hw_segs;
+	unsigned int phys_size;
+	unsigned int hw_size;
+	struct bio_vec bv;
+	struct bio_vec bvprv = {0};
+	int seg_size;
+	int hw_seg_size;
+	int cluster;
+	struct req_iterator i;
 	int high, highprv = 1;
+	struct request_queue *q = rq->q;
 
-	if (unlikely(!bio->bi_io_vec))
+	if (!rq->bio)
 		return;
 
 	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
-	hw_seg_size = seg_size = nr_phys_segs = nr_hw_segs = 0;
-	bio_for_each_segment(bv, bio, i) {
+	hw_seg_size = seg_size = 0;
+	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
+	rq_for_each_segment(rq, i, bv) {
 		/*
 		 * the trick here is making sure that a high page is never
 		 * considered part of another segment, since that might
 		 * change with the bounce page.
 		 */
-		high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
+		high = page_to_pfn(bv.bv_page) > q->bounce_pfn;
 		if (high || highprv)
 			goto new_hw_segment;
 		if (cluster) {
-			if (seg_size + bv->bv_len > q->max_segment_size)
+			if (seg_size + bv.bv_len > q->max_segment_size)
 				goto new_segment;
-			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
+			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
 				goto new_segment;
-			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
+			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
 				goto new_segment;
-			if (BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
+			if (BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv.bv_len))
 				goto new_hw_segment;
 
-			seg_size += bv->bv_len;
-			hw_seg_size += bv->bv_len;
+			seg_size += bv.bv_len;
+			hw_seg_size += bv.bv_len;
 			bvprv = bv;
 			continue;
 		}
 new_segment:
-		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
-		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len)) {
-			hw_seg_size += bv->bv_len;
-		} else {
+		if (BIOVEC_VIRT_MERGEABLE(&bvprv, &bv) &&
+		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv.bv_len))
+			hw_seg_size += bv.bv_len;
+		else {
 new_hw_segment:
-			if (hw_seg_size > bio->bi_hw_front_size)
-				bio->bi_hw_front_size = hw_seg_size;
-			hw_seg_size = BIOVEC_VIRT_START_SIZE(bv) + bv->bv_len;
+			if (nr_hw_segs == 1 &&
+			    hw_seg_size > rq->bio->bi_hw_front_size)
+				rq->bio->bi_hw_front_size = hw_seg_size;
+			hw_seg_size = BIOVEC_VIRT_START_SIZE(&bv) + bv.bv_len;
 			nr_hw_segs++;
 		}
 
 		nr_phys_segs++;
 		bvprv = bv;
-		seg_size = bv->bv_len;
+		seg_size = bv.bv_len;
 		highprv = high;
 	}
-	if (hw_seg_size > bio->bi_hw_back_size)
-		bio->bi_hw_back_size = hw_seg_size;
-	if (nr_hw_segs == 1 && hw_seg_size > bio->bi_hw_front_size)
-		bio->bi_hw_front_size = hw_seg_size;
-	bio->bi_phys_segments = nr_phys_segs;
-	bio->bi_hw_segments = nr_hw_segs;
-	bio->bi_flags |= (1 << BIO_SEG_VALID);
+
+	if (nr_hw_segs == 1 &&
+	    hw_seg_size > rq->bio->bi_hw_front_size)
+		rq->bio->bi_hw_front_size = hw_seg_size;
+	if (hw_seg_size > rq->biotail->bi_hw_back_size)
+		rq->biotail->bi_hw_back_size = hw_seg_size;
+	rq->nr_phys_segments = nr_phys_segs;
+	rq->nr_hw_segments = nr_hw_segs;
 }
-EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
@@ -3313,48 +3340,6 @@ void submit_bio(int rw, struct bio *bio)
 
 EXPORT_SYMBOL(submit_bio);
 
-static void blk_recalc_rq_segments(struct request *rq)
-{
-	struct bio *bio, *prevbio = NULL;
-	int nr_phys_segs, nr_hw_segs;
-	unsigned int phys_size, hw_size;
-	struct request_queue *q = rq->q;
-
-	if (!rq->bio)
-		return;
-
-	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
-	rq_for_each_bio(bio, rq) {
-		/* Force bio hw/phys segs to be recalculated. */
-		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
-
-		nr_phys_segs += bio_phys_segments(q, bio);
-		nr_hw_segs += bio_hw_segments(q, bio);
-		if (prevbio) {
-			int pseg = phys_size + prevbio->bi_size + bio->bi_size;
-			int hseg = hw_size + prevbio->bi_size + bio->bi_size;
-
-			if (blk_phys_contig_segment(q, prevbio, bio) &&
-			    pseg <= q->max_segment_size) {
-				nr_phys_segs--;
-				phys_size += prevbio->bi_size + bio->bi_size;
-			} else
-				phys_size = 0;
-
-			if (blk_hw_contig_segment(q, prevbio, bio) &&
-			    hseg <= q->max_segment_size) {
-				nr_hw_segs--;
-				hw_size += prevbio->bi_size + bio->bi_size;
-			} else
-				hw_size = 0;
-		}
-		prevbio = bio;
-	}
-
-	rq->nr_phys_segments = nr_phys_segs;
-	rq->nr_hw_segments = nr_hw_segs;
-}
-
 static void blk_recalc_rq_sectors(struct request *rq, int nsect)
 {
 	if (blk_fs_request(rq)) {

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 15:02:31.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 15:02:31.000000000 +1000
@@ -655,9 +655,6 @@ struct req_iterator {
 
 #define rq_iter_last(rq, _iter) (_iter.bio->bi_next == NULL && 	\
 				 _iter.i == _iter.bio->bi_vcnt - 1)
-#define rq_for_each_bio(_bio, rq)	\
-	if ((rq->bio))			\
-		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
