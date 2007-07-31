Return-Path: <linux-kernel-owner+w=401wt.eu-S940538AbXGaCSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940538AbXGaCSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938242AbXGaCQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:35969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937482AbXGaCQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:25 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:12 +1000
Message-Id: <1070731021612.25144@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 005 of 35] Stop updating bi_idx, bv_len, bv_offset when a request completes
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some requests signal partial completion.  We currently record this
by updating bi_idx, bv_len, and bv_offset.
This is bad if the bi_io_vec is to be shared.
So instead keep in "struct request" the amount of the first bio
that has completed.  This is "first_offset" (i.e. offset in to 
first bio).  Update and use that instead.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   38 ++++++++++++++++++++++++++++++--------
 ./drivers/ide/ide-io.c   |    2 +-
 ./include/linux/blkdev.h |   22 +++++++++++++++++-----
 3 files changed, 48 insertions(+), 14 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:46.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:46.000000000 +1000
@@ -243,6 +243,7 @@ static void rq_init(struct request_queue
 
 	rq->errors = 0;
 	rq->bio = rq->biotail = NULL;
+	rq->first_offset = 0;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->ioprio = 0;
@@ -447,6 +448,7 @@ static inline struct request *start_orde
 	rq->cmd_flags |= q->ordered & QUEUE_ORDERED_FUA ? REQ_FUA : 0;
 	rq->elevator_private = NULL;
 	rq->elevator_private2 = NULL;
+	BUG_ON(rq->first_offset);
 	init_request_from_bio(rq, q->orig_bar_rq->bio);
 	rq->end_io = bar_end_io;
 
@@ -1214,6 +1216,7 @@ void blk_recount_segments(struct request
 	struct bio *nxt = bio->bi_next;
 	rq.q = q;
 	rq.bio = rq.biotail = bio;
+	rq.first_offset = 0;
 	bio->bi_next = NULL;
 	blk_recalc_rq_segments(&rq);
 	bio->bi_next = nxt;
@@ -2926,6 +2929,7 @@ static void init_request_from_bio(struct
 	req->hard_sector = req->sector = bio->bi_sector;
 	req->hard_nr_sectors = req->nr_sectors = bio_sectors(bio);
 	req->bio = req->biotail = bio;
+	req->first_offset = 0;
 	req->current_nr_sectors = req->hard_cur_sectors =
 		blk_rq_cur_sectors(req);
 	req->nr_phys_segments = bio_phys_segments(req->q, bio);
@@ -3411,22 +3415,30 @@ static int __end_that_request_first(stru
 			nbytes = bio->bi_size;
 			if (!ordered_bio_endio(req, bio, nbytes, error))
 				bio_endio(bio, nbytes, error);
+			req->first_offset = 0;
 			next_idx = 0;
 			bio_nbytes = 0;
 		} else {
 			int idx = bio->bi_idx + next_idx;
 
-			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+			if (unlikely(idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");
 				printk("%s: bio idx %d >= vcnt %d\n",
 						__FUNCTION__,
-						bio->bi_idx, bio->bi_vcnt);
+						idx, bio->bi_vcnt);
 				break;
 			}
 
 			nbytes = bio_iovec_idx(bio, idx)->bv_len;
 			BIO_BUG_ON(nbytes > bio->bi_size);
 
+			if (req->first_offset > bio_nbytes + nbytes) {
+				bio_nbytes += nbytes;
+				nbytes = 0;
+			} else if (req->first_offset > bio_nbytes) {
+				nbytes -= req->first_offset - bio_nbytes;
+				bio_nbytes = req->first_offset;
+			}
 			/*
 			 * not a complete bvec done
 			 */
@@ -3467,9 +3479,7 @@ static int __end_that_request_first(stru
 	if (bio_nbytes) {
 		if (!ordered_bio_endio(req, bio, bio_nbytes, error))
 			bio_endio(bio, bio_nbytes, error);
-		bio->bi_idx += next_idx;
-		bio_iovec(bio)->bv_offset += nr_bytes;
-		bio_iovec(bio)->bv_len -= nr_bytes;
+		req->first_offset = bio_nbytes;
 	}
 
 	blk_recalc_rq_sectors(req, total_bytes >> 9);
@@ -3658,6 +3668,7 @@ void blk_rq_bio_prep(struct request_queu
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->data_len = bio->bi_size;
 
+	rq->first_offset = 0;
 	rq->bio = rq->biotail = bio;
 	rq->buffer = blk_rq_data(rq);
 	rq->current_nr_sectors = blk_rq_cur_sectors(rq);
@@ -3668,14 +3679,25 @@ EXPORT_SYMBOL(blk_rq_bio_prep);
 
 void *blk_rq_data(struct request *rq)
 {
-	return page_address(bio_page(rq->bio)) +
-		bio_offset(rq->bio);
+	struct bio_vec bvec;
+	struct req_iterator i;
+
+	rq_for_each_segment(rq, i, bvec)
+		return page_address(bvec.bv_page) + bvec.bv_offset;
+
+	return NULL;
 }
 EXPORT_SYMBOL(blk_rq_data);
 
 int blk_rq_cur_bytes(struct request *rq)
 {
-	return bio_iovec(rq->bio)->bv_len;
+	struct bio_vec bvec;
+	struct req_iterator i;
+
+	rq_for_each_segment(rq, i, bvec)
+		return bvec.bv_len;
+
+	return 0;
 }
 EXPORT_SYMBOL(blk_rq_cur_bytes);
 

diff .prev/drivers/ide/ide-io.c ./drivers/ide/ide-io.c
--- .prev/drivers/ide/ide-io.c	2007-07-31 11:20:43.000000000 +1000
+++ ./drivers/ide/ide-io.c	2007-07-31 11:20:46.000000000 +1000
@@ -1415,7 +1415,7 @@ static ide_startstop_t ide_dma_timeout_r
 	if (!rq->bio)
 		goto out;
 
-	rq->sector = rq->bio->bi_sector;
+	rq->sector = rq->bio->bi_sector + (rq->first_offset >> 9);
 	rq->current_nr_sectors = blk_rq_cur_sectors(rq);
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->buffer = blk_rq_data(rq);

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:20:46.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:20:46.000000000 +1000
@@ -254,6 +254,7 @@ struct request {
 
 	struct bio *bio;
 	struct bio *biotail;
+	int first_offset;	/* offset into first bio in list */
 
 	struct hlist_node hash;	/* merge hash */
 	/*
@@ -640,14 +641,25 @@ static inline void blk_queue_bounce(stru
 struct req_iterator {
 	int i;
 	struct bio *bio;
+	int offset;
 };
 #define rq_for_each_segment(rq, _iter, bvec)	\
-	for (_iter.bio = (rq)->bio; _iter.bio; _iter.bio = _iter.bio->bi_next) \
-		for (_iter.i = _iter.bio->bi_idx, 			       \
-			bvec = *bio_iovec_idx(_iter.bio, _iter.i);	       \
+	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset;	       \
+	     _iter.bio;							       \
+	     _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 		       \
+		for (_iter.i = _iter.bio->bi_idx; 			       \
 		     _iter.i < _iter.bio->bi_vcnt;			       \
-		     _iter.i++, bvec = *bio_iovec_idx(_iter.bio, _iter.i)      \
-		)
+		     _iter.i++						       \
+		)							       \
+			if (bvec = *bio_iovec_idx(_iter.bio, _iter.i),	       \
+			    bvec.bv_offset += _iter.offset,		       \
+			    bvec.bv_len <= _iter.offset			       \
+				? (_iter.offset -= bvec.bv_len, 0)	       \
+				: (bvec.bv_len -= _iter.offset,		       \
+				   _iter.offset = 0,			       \
+				   1))
+
+
 #define rq_iter_last(rq, _iter) (_iter.bio->bi_next == NULL && 	\
 				 _iter.i == _iter.bio->bi_vcnt - 1)
 
