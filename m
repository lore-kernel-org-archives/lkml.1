Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbXHPLVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbXHPLVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbXHPLVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:21:04 -0400
Received: from ns.suse.de ([195.135.220.2]:47843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765510AbXHPLVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:21:03 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:20:54 +1000
Message-Id: <1070816112054.12167@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 001 of 6] Merge blk_recount_segments into blk_recalc_rq_segments
References: <20070816211551.11839.patches@notabene>
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
stores just the bio.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |  102 ++++++++++++++++++++++------------------------------
 1 file changed, 44 insertions(+), 58 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 17:37:43.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 17:43:27.000000000 +1000
@@ -42,6 +42,7 @@ static void drive_stat_acct(struct reque
 static void init_request_from_bio(struct request *req, struct bio *bio);
 static int __make_request(struct request_queue *q, struct bio *bio);
 static struct io_context *current_io_context(gfp_t gfp_flags, int node);
+static void blk_recalc_rq_segments(struct request *rq);
 
 /*
  * For the allocated request tables
@@ -1209,16 +1210,42 @@ EXPORT_SYMBOL(blk_dump_rq_flags);
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
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
 	struct bio_vec *bv, *bvprv = NULL;
-	int i, nr_phys_segs, nr_hw_segs, seg_size, hw_seg_size, cluster;
+	int seg_size;
+	int hw_seg_size;
+	int cluster;
+	struct bio *bio;
+	int i;
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
+	rq_for_each_bio(bio, rq)
+	    bio_for_each_segment(bv, bio, i) {
 		/*
 		 * the trick here is making sure that a high page is never
 		 * considered part of another segment, since that might
@@ -1244,12 +1271,13 @@ void blk_recount_segments(struct request
 		}
 new_segment:
 		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
-		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len)) {
+		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
 			hw_seg_size += bv->bv_len;
-		} else {
+		else {
 new_hw_segment:
-			if (hw_seg_size > bio->bi_hw_front_size)
-				bio->bi_hw_front_size = hw_seg_size;
+			if (nr_hw_segs == 1 &&
+			    hw_seg_size > rq->bio->bi_hw_front_size)
+				rq->bio->bi_hw_front_size = hw_seg_size;
 			hw_seg_size = BIOVEC_VIRT_START_SIZE(bv) + bv->bv_len;
 			nr_hw_segs++;
 		}
@@ -1259,15 +1287,15 @@ new_hw_segment:
 		seg_size = bv->bv_len;
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
@@ -3316,48 +3344,6 @@ void submit_bio(int rw, struct bio *bio)
 
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
