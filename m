Return-Path: <linux-kernel-owner+w=401wt.eu-S966560AbXGaCWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966560AbXGaCWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939721AbXGaCRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:36042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938564AbXGaCRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:13 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:00 +1000
Message-Id: <1070731021700.25285@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 014 of 35] Change blk_phys/hw_contig_segment to take requests, not bios.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These functions are always passed the last bio of one request
and the first of the next.  So it can work to just pass the
two requests and let them pick off the bios.  This makes life
easier for a future patch.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:58.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:59.000000000 +1000
@@ -1271,38 +1271,42 @@ new_hw_segment:
 	rq->nr_hw_segments = nr_hw_segs;
 }
 
-static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
-				   struct bio *nxt)
+static int blk_phys_contig_segment(struct request_queue *q, struct request *req,
+				   struct request *nxt)
 {
 	if (!(q->queue_flags & (1 << QUEUE_FLAG_CLUSTER)))
 		return 0;
 
-	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)))
+	if (!BIOVEC_PHYS_MERGEABLE(__BVEC_END(req->biotail),
+				   __BVEC_START(nxt->bio)))
 		return 0;
-	if (bio->bi_size + nxt->bi_size > q->max_segment_size)
+	if (req->biotail->bi_size + nxt->bio->bi_size > q->max_segment_size)
 		return 0;
 
 	/*
 	 * bio and nxt are contigous in memory, check if the queue allows
 	 * these two to be merged into one
 	 */
-	if (BIO_SEG_BOUNDARY(q, bio, nxt))
+	if (BIO_SEG_BOUNDARY(q, req->biotail, nxt->bio))
 		return 1;
 
 	return 0;
 }
 
-static int blk_hw_contig_segment(struct request_queue *q, struct bio *bio,
-				 struct bio *nxt)
+static int blk_hw_contig_segment(struct request_queue *q, struct request *req,
+				 struct request *nxt)
 {
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, bio);
-	if (unlikely(!bio_flagged(nxt, BIO_SEG_VALID)))
-		blk_recount_segments(q, nxt);
-	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)) ||
-	    BIOVEC_VIRT_OVERSIZE(bio->bi_hw_back_size + nxt->bi_hw_front_size))
+	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
+		blk_recount_segments(q, req->biotail);
+	if (unlikely(!bio_flagged(nxt->bio, BIO_SEG_VALID)))
+		blk_recount_segments(q, nxt->bio);
+	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
+				   __BVEC_START(nxt->bio)) ||
+	    BIOVEC_VIRT_OVERSIZE(req->biotail->bi_hw_back_size +
+				 nxt->bio->bi_hw_front_size))
 		return 0;
-	if (bio->bi_hw_back_size + nxt->bi_hw_front_size > q->max_segment_size)
+	if (req->biotail->bi_hw_back_size + nxt->bio->bi_hw_front_size
+	    > q->max_segment_size)
 		return 0;
 
 	return 1;
@@ -1504,14 +1508,14 @@ static int ll_merge_requests_fn(struct r
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (blk_phys_contig_segment(q, req->biotail, next->bio))
+	if (blk_phys_contig_segment(q, req, next))
 		total_phys_segments--;
 
 	if (total_phys_segments > q->max_phys_segments)
 		return 0;
 
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
-	if (blk_hw_contig_segment(q, req->biotail, next->bio)) {
+	if (blk_hw_contig_segment(q, req, next)) {
 		int len = req->biotail->bi_hw_back_size + next->bio->bi_hw_front_size;
 		/*
 		 * propagate the combined length to the end of the requests
