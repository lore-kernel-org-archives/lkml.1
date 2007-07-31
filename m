Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXGaCWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXGaCWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940067AbXGaCRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:36047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939941AbXGaCRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:19 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:04 +1000
Message-Id: <1070731021704.25303@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 015 of 35] Move hw_front_size and hw_back_size from bio to request.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Drivers that define their own make_request_fn have no need of
bi_hw_back_size and bi_hw_front_size, and the code that does
use it is only ever interested in bi_hw_back_size for
rq->bio and bi_hw_front_size for rq->biotail

So move these fields from the bio into the request.

This involves passing a 'struct request *' to a lot of functions
that previously expected a 'struct bio *'. This tends to have a
neutral or positive effect on the code.

In __make_request, we create a request on the stack to hold the bio
and the front/back values.  This request is never actually added to
a queue.

Code that wanted to get the hw_segments and phys_segments counts
from the bio now take them directly from the request.  We ensure that
the request created in __make_request has these values set properly.



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/as-iosched.c       |    8 +-
 ./block/cfq-iosched.c      |   26 ++++-----
 ./block/deadline-iosched.c |    9 +--
 ./block/elevator.c         |   31 +++++------
 ./block/ll_rw_blk.c        |  123 ++++++++++++++++++++++++---------------------
 ./drivers/md/raid1.c       |    2 
 ./drivers/md/raid10.c      |    2 
 ./fs/bio.c                 |    2 
 ./include/linux/bio.h      |    8 --
 ./include/linux/blkdev.h   |    9 +++
 ./include/linux/elevator.h |    9 +--
 11 files changed, 119 insertions(+), 110 deletions(-)

diff .prev/block/as-iosched.c ./block/as-iosched.c
--- .prev/block/as-iosched.c	2007-07-31 11:20:09.000000000 +1000
+++ ./block/as-iosched.c	2007-07-31 11:21:00.000000000 +1000
@@ -1199,17 +1199,17 @@ static int as_queue_empty(struct request
 }
 
 static int
-as_merge(struct request_queue *q, struct request **req, struct bio *bio)
+as_merge(struct request_queue *q, struct request **req, struct request *nreq)
 {
 	struct as_data *ad = q->elevator->elevator_data;
-	sector_t rb_key = bio->bi_sector + bio_sectors(bio);
+	sector_t rb_key = nreq->sector + nreq->nr_sectors;
 	struct request *__rq;
 
 	/*
 	 * check for front merge
 	 */
-	__rq = elv_rb_find(&ad->sort_list[bio_data_dir(bio)], rb_key);
-	if (__rq && elv_rq_merge_ok(__rq, bio)) {
+	__rq = elv_rb_find(&ad->sort_list[rq_data_dir(nreq)], rb_key);
+	if (__rq && elv_rq_merge_ok(__rq, nreq)) {
 		*req = __rq;
 		return ELEVATOR_FRONT_MERGE;
 	}

diff .prev/block/cfq-iosched.c ./block/cfq-iosched.c
--- .prev/block/cfq-iosched.c	2007-07-31 11:20:09.000000000 +1000
+++ ./block/cfq-iosched.c	2007-07-31 11:21:00.000000000 +1000
@@ -219,9 +219,9 @@ static inline void cic_set_cfqq(struct c
  * We regard a request as SYNC, if it's either a read or has the SYNC bit
  * set (in which case it could also be direct WRITE).
  */
-static inline int cfq_bio_sync(struct bio *bio)
+static inline int cfq_rq_sync(struct request *rq)
 {
-	if (bio_data_dir(bio) == READ || bio_sync(bio))
+	if (rq_data_dir(rq) == READ || rq_is_sync(rq))
 		return 1;
 
 	return 0;
@@ -603,7 +603,7 @@ cfq_reposition_rq_rb(struct cfq_queue *c
 }
 
 static struct request *
-cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
+cfq_find_rq_fmerge(struct cfq_data *cfqd, struct request *nreq)
 {
 	struct task_struct *tsk = current;
 	struct cfq_io_context *cic;
@@ -613,9 +613,9 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd
 	if (!cic)
 		return NULL;
 
-	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
+	cfqq = cic_to_cfqq(cic, cfq_rq_sync(nreq));
 	if (cfqq) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
+		sector_t sector = nreq->sector + nreq->nr_sectors;
 
 		return elv_rb_find(&cfqq->sort_list, sector);
 	}
@@ -666,13 +666,13 @@ static void cfq_remove_request(struct re
 }
 
 static int cfq_merge(struct request_queue *q, struct request **req,
-		     struct bio *bio)
+		     struct request *nreq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct request *__rq;
 
-	__rq = cfq_find_rq_fmerge(cfqd, bio);
-	if (__rq && elv_rq_merge_ok(__rq, bio)) {
+	__rq = cfq_find_rq_fmerge(cfqd, nreq);
+	if (__rq && elv_rq_merge_ok(__rq, nreq)) {
 		*req = __rq;
 		return ELEVATOR_FRONT_MERGE;
 	}
@@ -705,27 +705,27 @@ cfq_merged_requests(struct request_queue
 }
 
 static int cfq_allow_merge(struct request_queue *q, struct request *rq,
-			   struct bio *bio)
+			   struct request *nreq)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
 	/*
-	 * Disallow merge of a sync bio into an async request.
+	 * Disallow merge of a sync request into an async request.
 	 */
-	if (cfq_bio_sync(bio) && !rq_is_sync(rq))
+	if (cfq_rq_sync(nreq) && !rq_is_sync(rq))
 		return 0;
 
 	/*
-	 * Lookup the cfqq that this bio will be queued with. Allow
+	 * Lookup the cfqq that this nreq will be queued with. Allow
 	 * merge only if rq is queued there.
 	 */
 	cic = cfq_cic_rb_lookup(cfqd, current->io_context);
 	if (!cic)
 		return 0;
 
-	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
+	cfqq = cic_to_cfqq(cic, cfq_rq_sync(nreq));
 	if (cfqq == RQ_CFQQ(rq))
 		return 1;
 

diff .prev/block/deadline-iosched.c ./block/deadline-iosched.c
--- .prev/block/deadline-iosched.c	2007-07-31 11:20:09.000000000 +1000
+++ ./block/deadline-iosched.c	2007-07-31 11:21:00.000000000 +1000
@@ -115,7 +115,8 @@ static void deadline_remove_request(stru
 }
 
 static int
-deadline_merge(struct request_queue *q, struct request **req, struct bio *bio)
+deadline_merge(struct request_queue *q,
+	       struct request **req, struct request *nreq)
 {
 	struct deadline_data *dd = q->elevator->elevator_data;
 	struct request *__rq;
@@ -125,13 +126,13 @@ deadline_merge(struct request_queue *q, 
 	 * check for front merge
 	 */
 	if (dd->front_merges) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
+		sector_t sector = nreq->sector + nreq->nr_sectors;
 
-		__rq = elv_rb_find(&dd->sort_list[bio_data_dir(bio)], sector);
+		__rq = elv_rb_find(&dd->sort_list[rq_data_dir(nreq)], sector);
 		if (__rq) {
 			BUG_ON(sector != __rq->sector);
 
-			if (elv_rq_merge_ok(__rq, bio)) {
+			if (elv_rq_merge_ok(__rq, nreq)) {
 				ret = ELEVATOR_FRONT_MERGE;
 				goto out;
 			}

diff .prev/block/elevator.c ./block/elevator.c
--- .prev/block/elevator.c	2007-07-31 11:20:09.000000000 +1000
+++ ./block/elevator.c	2007-07-31 11:21:00.000000000 +1000
@@ -54,13 +54,13 @@ static const int elv_hash_shift = 6;
  * Query io scheduler to see if the current process issuing bio may be
  * merged with rq.
  */
-static int elv_iosched_allow_merge(struct request *rq, struct bio *bio)
+static int elv_iosched_allow_merge(struct request *rq, struct request *nreq)
 {
 	struct request_queue *q = rq->q;
 	elevator_t *e = q->elevator;
 
 	if (e->ops->elevator_allow_merge_fn)
-		return e->ops->elevator_allow_merge_fn(q, rq, bio);
+		return e->ops->elevator_allow_merge_fn(q, rq, nreq);
 
 	return 1;
 }
@@ -68,7 +68,7 @@ static int elv_iosched_allow_merge(struc
 /*
  * can we safely merge with this request?
  */
-inline int elv_rq_merge_ok(struct request *rq, struct bio *bio)
+inline int elv_rq_merge_ok(struct request *rq, struct request *nreq)
 {
 	if (!rq_mergeable(rq))
 		return 0;
@@ -76,33 +76,33 @@ inline int elv_rq_merge_ok(struct reques
 	/*
 	 * different data direction or already started, don't merge
 	 */
-	if (bio_data_dir(bio) != rq_data_dir(rq))
+	if (rq_data_dir(nreq) != rq_data_dir(rq))
 		return 0;
 
 	/*
 	 * must be same device and not a special request
 	 */
-	if (rq->rq_disk != bio->bi_bdev->bd_disk || rq->special)
+	if (rq->rq_disk != nreq->rq_disk || rq->special)
 		return 0;
 
-	if (!elv_iosched_allow_merge(rq, bio))
+	if (!elv_iosched_allow_merge(rq, nreq))
 		return 0;
 
 	return 1;
 }
 EXPORT_SYMBOL(elv_rq_merge_ok);
 
-static inline int elv_try_merge(struct request *__rq, struct bio *bio)
+static inline int elv_try_merge(struct request *__rq, struct request *nreq)
 {
 	int ret = ELEVATOR_NO_MERGE;
 
 	/*
 	 * we can merge and sequence is ok, check if it's possible
 	 */
-	if (elv_rq_merge_ok(__rq, bio)) {
-		if (__rq->sector + __rq->nr_sectors == bio->bi_sector)
+	if (elv_rq_merge_ok(__rq, nreq)) {
+		if (__rq->sector + __rq->nr_sectors == nreq->sector)
 			ret = ELEVATOR_BACK_MERGE;
-		else if (__rq->sector - bio_sectors(bio) == bio->bi_sector)
+		else if (__rq->sector - nreq->nr_sectors == nreq->sector)
 			ret = ELEVATOR_FRONT_MERGE;
 	}
 
@@ -451,7 +451,8 @@ void elv_dispatch_add_tail(struct reques
 
 EXPORT_SYMBOL(elv_dispatch_add_tail);
 
-int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
+int elv_merge(struct request_queue *q,
+	      struct request **req, struct request *nreq)
 {
 	elevator_t *e = q->elevator;
 	struct request *__rq;
@@ -461,7 +462,7 @@ int elv_merge(struct request_queue *q, s
 	 * First try one-hit cache.
 	 */
 	if (q->last_merge) {
-		ret = elv_try_merge(q->last_merge, bio);
+		ret = elv_try_merge(q->last_merge, nreq);
 		if (ret != ELEVATOR_NO_MERGE) {
 			*req = q->last_merge;
 			return ret;
@@ -471,14 +472,14 @@ int elv_merge(struct request_queue *q, s
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-	__rq = elv_rqhash_find(q, bio->bi_sector);
-	if (__rq && elv_rq_merge_ok(__rq, bio)) {
+	__rq = elv_rqhash_find(q, nreq->sector);
+	if (__rq && elv_rq_merge_ok(__rq, nreq)) {
 		*req = __rq;
 		return ELEVATOR_BACK_MERGE;
 	}
 
 	if (e->ops->elevator_merge_fn)
-		return e->ops->elevator_merge_fn(q, req, bio);
+		return e->ops->elevator_merge_fn(q, req, nreq);
 
 	return ELEVATOR_NO_MERGE;
 }

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:59.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:00.000000000 +1000
@@ -256,6 +256,7 @@ static void rq_init(struct request_queue
 	rq->data_len = 0;
 	rq->data = NULL;
 	rq->nr_phys_segments = 0;
+	rq->nr_hw_segments = 0;
 	rq->sense = NULL;
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
@@ -1250,8 +1251,8 @@ new_segment:
 		else {
 new_hw_segment:
 			if (nr_hw_segs == 1 &&
-			    hw_seg_size > rq->bio->bi_hw_front_size)
-				rq->bio->bi_hw_front_size = hw_seg_size;
+			    hw_seg_size > rq->hw_front_size)
+				rq->hw_front_size = hw_seg_size;
 			hw_seg_size = BIOVEC_VIRT_START_SIZE(&bv) + bv.bv_len;
 			nr_hw_segs++;
 		}
@@ -1263,10 +1264,10 @@ new_hw_segment:
 	}
 
 	if (nr_hw_segs == 1 &&
-	    hw_seg_size > rq->bio->bi_hw_front_size)
-		rq->bio->bi_hw_front_size = hw_seg_size;
-	if (hw_seg_size > rq->biotail->bi_hw_back_size)
-		rq->biotail->bi_hw_back_size = hw_seg_size;
+	    hw_seg_size > rq->hw_front_size)
+		rq->hw_front_size = hw_seg_size;
+	if (hw_seg_size > rq->hw_back_size)
+		rq->hw_back_size = hw_seg_size;
 	rq->nr_phys_segments = nr_phys_segs;
 	rq->nr_hw_segments = nr_hw_segs;
 }
@@ -1302,10 +1303,10 @@ static int blk_hw_contig_segment(struct 
 		blk_recount_segments(q, nxt->bio);
 	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
 				   __BVEC_START(nxt->bio)) ||
-	    BIOVEC_VIRT_OVERSIZE(req->biotail->bi_hw_back_size +
-				 nxt->bio->bi_hw_front_size))
+	    BIOVEC_VIRT_OVERSIZE(req->hw_back_size +
+				 nxt->hw_front_size))
 		return 0;
-	if (req->biotail->bi_hw_back_size + nxt->bio->bi_hw_front_size
+	if (req->hw_back_size + nxt->hw_front_size
 	    > q->max_segment_size)
 		return 0;
 
@@ -1368,11 +1369,11 @@ EXPORT_SYMBOL(blk_rq_map_sg);
 
 static inline int ll_new_mergeable(struct request_queue *q,
 				   struct request *req,
-				   struct bio *bio)
+				   struct request *nreq)
 {
-	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req->nr_phys_segments + nreq->nr_phys_segments
+	    > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -1383,19 +1384,18 @@ static inline int ll_new_mergeable(struc
 	 * A hw segment is just getting larger, bump just the phys
 	 * counter.
 	 */
-	req->nr_phys_segments += nr_phys_segs;
+	req->nr_phys_segments += nreq->nr_phys_segments;
 	return 1;
 }
 
 static inline int ll_new_hw_segment(struct request_queue *q,
 				    struct request *req,
-				    struct bio *bio)
+				    struct request *nreq)
 {
-	int nr_hw_segs = bio_hw_segments(q, bio);
-	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_hw_segments + nr_hw_segs > q->max_hw_segments
-	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req->nr_hw_segments + nreq->nr_hw_segments > q->max_hw_segments
+	    || (req->nr_phys_segments + nreq->nr_phys_segments
+		> q->max_phys_segments)) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -1406,13 +1406,13 @@ static inline int ll_new_hw_segment(stru
 	 * This will form the start of a new hw segment.  Bump both
 	 * counters.
 	 */
-	req->nr_hw_segments += nr_hw_segs;
-	req->nr_phys_segments += nr_phys_segs;
+	req->nr_hw_segments += nreq->nr_hw_segments;
+	req->nr_phys_segments += nreq->nr_phys_segments;
 	return 1;
 }
 
 static int ll_back_merge_fn(struct request_queue *q, struct request *req,
-			    struct bio *bio)
+			    struct request *nreq)
 {
 	unsigned short max_sectors;
 	int len;
@@ -1422,35 +1422,33 @@ static int ll_back_merge_fn(struct reque
 	else
 		max_sectors = q->max_sectors;
 
-	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
+	if (req->nr_sectors + nreq->nr_sectors > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
 	}
-	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
-		blk_recount_segments(q, req->biotail);
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, bio);
-	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio)) &&
+	len = req->hw_back_size + nreq->hw_front_size;
+	if (nreq->first_offset == 0 &&
+	    BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
+				  __BVEC_START(nreq->bio)) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
+		int mergeable = ll_new_mergeable(q, req, nreq);
 
 		if (mergeable) {
 			if (req->nr_hw_segments == 1)
-				req->bio->bi_hw_front_size = len;
-			if (bio->bi_hw_segments == 1)
-				bio->bi_hw_back_size = len;
+				req->hw_front_size = len;
+			if (nreq->nr_hw_segments == 1)
+				nreq->hw_back_size = len;
 		}
 		return mergeable;
 	}
 
-	return ll_new_hw_segment(q, req, bio);
+	return ll_new_hw_segment(q, req, nreq);
 }
 
 static int ll_front_merge_fn(struct request_queue *q, struct request *req, 
-			     struct bio *bio)
+			     struct request *nreq)
 {
 	unsigned short max_sectors;
 	int len;
@@ -1461,31 +1459,29 @@ static int ll_front_merge_fn(struct requ
 		max_sectors = q->max_sectors;
 
 
-	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
+	if (req->nr_sectors + nreq->nr_sectors > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
 	}
-	len = bio->bi_hw_back_size + req->bio->bi_hw_front_size;
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, bio);
-	if (unlikely(!bio_flagged(req->bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, req->bio);
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(req->bio)) &&
+	len = nreq->hw_back_size + req->hw_front_size;
+
+	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(nreq->biotail),
+				  __BVEC_START(req->bio)) &&
 	    !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
+		int mergeable = ll_new_mergeable(q, req, nreq);
 
 		if (mergeable) {
-			if (bio->bi_hw_segments == 1)
-				bio->bi_hw_front_size = len;
+			if (nreq->nr_hw_segments == 1)
+				nreq->hw_front_size = len;
 			if (req->nr_hw_segments == 1)
-				req->biotail->bi_hw_back_size = len;
+				req->hw_back_size = len;
 		}
 		return mergeable;
 	}
 
-	return ll_new_hw_segment(q, req, bio);
+	return ll_new_hw_segment(q, req, nreq);
 }
 
 static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
@@ -1515,8 +1511,9 @@ static int ll_merge_requests_fn(struct r
 		return 0;
 
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
-	if (blk_hw_contig_segment(q, req, next)) {
-		int len = req->biotail->bi_hw_back_size + next->bio->bi_hw_front_size;
+	if (next->first_offset == 0 &&
+	    blk_hw_contig_segment(q, req, next)) {
+		int len = req->hw_back_size + next->hw_front_size;
 		/*
 		 * propagate the combined length to the end of the requests
 		 */
@@ -1524,9 +1521,9 @@ static int ll_merge_requests_fn(struct r
 		if (total_hw_segments > q->max_hw_segments)
 			return 0;
 		if (req->nr_hw_segments == 1)
-			req->bio->bi_hw_front_size = len;
+			req->hw_front_size = len;
 		if (next->nr_hw_segments == 1)
-			next->biotail->bi_hw_back_size = len;
+			next->hw_back_size = len;
 	}
 
 	if (total_hw_segments > q->max_hw_segments)
@@ -2342,13 +2339,21 @@ static int __blk_rq_unmap_user(struct bi
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio)
 {
+	struct request nreq;
+
+	rq_init(q, &nreq);
+	nreq.cmd_flags = bio_data_dir(bio);
+	init_request_from_bio(&nreq, bio);
+
 	if (!rq->bio)
 		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio))
+	else if (!ll_back_merge_fn(q, rq, &nreq))
 		return -EINVAL;
 	else {
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
+		rq->hw_back_size = nreq.hw_back_size;
+		rq->nr_sectors += nreq.nr_sectors;
 
 		rq->data_len += bio->bi_size;
 	}
@@ -2920,6 +2925,7 @@ static void init_request_from_bio(struct
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
 	struct request *req;
+	struct request nreq;
 	int el_ret, nr_sectors, barrier, err;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
@@ -2939,24 +2945,28 @@ static int __make_request(struct request
 		err = -EOPNOTSUPP;
 		goto end_io;
 	}
+	nreq.cmd_flags = 0;
+	rq_init(q, &nreq);
+	init_request_from_bio(&nreq, bio);
 
 	spin_lock_irq(q->queue_lock);
 
 	if (unlikely(barrier) || elv_queue_empty(q))
 		goto get_rq;
 
-	el_ret = elv_merge(q, &req, bio);
+	el_ret = elv_merge(q, &req, &nreq);
 	switch (el_ret) {
 		case ELEVATOR_BACK_MERGE:
 			BUG_ON(!rq_mergeable(req));
 
-			if (!ll_back_merge_fn(q, req, bio))
+			if (!ll_back_merge_fn(q, req, &nreq))
 				break;
 
 			blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
 
 			req->biotail->bi_next = bio;
 			req->biotail = bio;
+			req->hw_back_size = nreq.hw_back_size;
 			req->nr_sectors = req->hard_nr_sectors += nr_sectors;
 			req->ioprio = ioprio_best(req->ioprio, prio);
 			drive_stat_acct(req, nr_sectors, 0);
@@ -2967,13 +2977,14 @@ static int __make_request(struct request
 		case ELEVATOR_FRONT_MERGE:
 			BUG_ON(!rq_mergeable(req));
 
-			if (!ll_front_merge_fn(q, req, bio))
+			if (!ll_front_merge_fn(q, req, &nreq))
 				break;
 
 			blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
 
 			bio->bi_next = req->bio;
 			req->bio = bio;
+			req->hw_front_size = nreq.hw_front_size;
 
 			/*
 			 * may not be valid. if the low level driver said
@@ -3635,16 +3646,16 @@ static void blk_rq_bio_prep(struct reque
 	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
 	rq->cmd_flags |= (bio->bi_rw & 3);
 
-	rq->nr_phys_segments = bio_phys_segments(q, bio);
-	rq->nr_hw_segments = bio_hw_segments(q, bio);
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->data_len = bio->bi_size;
 
 	rq->first_offset = 0;
 	rq->bio = rq->biotail = bio;
 	rq->buffer = blk_rq_data(rq);
+
 	rq->current_nr_sectors = blk_rq_cur_sectors(rq);
 	rq->hard_cur_sectors = rq->current_nr_sectors;
+	blk_recalc_rq_segments(rq);
 	if (bio->bi_bdev)
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:00.000000000 +1000
@@ -1281,8 +1281,6 @@ static void sync_request_write(mddev_t *
 		tbio->bi_idx = 0;
 		tbio->bi_phys_segments = 0;
 		tbio->bi_hw_segments = 0;
-		tbio->bi_hw_front_size = 0;
-		tbio->bi_hw_back_size = 0;
 		tbio->bi_flags &= ~(BIO_POOL_MASK - 1);
 		tbio->bi_flags |= 1 << BIO_UPTODATE;
 		tbio->bi_next = NULL;

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:00.000000000 +1000
@@ -1254,8 +1254,6 @@ static void sync_request_write(mddev_t *
 					sbio->bi_idx = 0;
 					sbio->bi_phys_segments = 0;
 					sbio->bi_hw_segments = 0;
-					sbio->bi_hw_front_size = 0;
-					sbio->bi_hw_back_size = 0;
 					sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
 					sbio->bi_flags |= 1 << BIO_UPTODATE;
 					sbio->bi_next = NULL;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:20:52.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:00.000000000 +1000
@@ -135,8 +135,6 @@ void bio_init(struct bio *bio)
 	bio->bi_idx = 0;
 	bio->bi_phys_segments = 0;
 	bio->bi_hw_segments = 0;
-	bio->bi_hw_front_size = 0;
-	bio->bi_hw_back_size = 0;
 	bio->bi_size = 0;
 	bio->bi_max_vecs = 0;
 	bio->bi_end_io = NULL;

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:20:52.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:00.000000000 +1000
@@ -94,14 +94,6 @@ struct bio {
 
 	unsigned int		bi_size;	/* residual I/O count */
 
-	/*
-	 * To keep track of the max hw size, we account for the
-	 * sizes of the first and last virtually mergeable segments
-	 * in this bio
-	 */
-	unsigned int		bi_hw_front_size;
-	unsigned int		bi_hw_back_size;
-
 	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
 
 	struct bio_vec		*bi_io_vec;	/* the actual vec list */

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:20:56.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:00.000000000 +1000
@@ -291,6 +291,15 @@ struct request {
 
 	unsigned short ioprio;
 
+	/*
+	 * To keep track of the max hw size, we account for the
+	 * sizes of the first and last virtually mergeable segments
+	 * in the first and last bio
+	 */
+	unsigned int  hw_front_size;
+	unsigned int  hw_back_size;
+
+
 	void *special;
 	char *buffer;
 

diff .prev/include/linux/elevator.h ./include/linux/elevator.h
--- .prev/include/linux/elevator.h	2007-07-31 11:20:10.000000000 +1000
+++ ./include/linux/elevator.h	2007-07-31 11:21:00.000000000 +1000
@@ -6,13 +6,14 @@
 #ifdef CONFIG_BLOCK
 
 typedef int (elevator_merge_fn) (struct request_queue *, struct request **,
-				 struct bio *);
+				 struct request *);
 
 typedef void (elevator_merge_req_fn) (struct request_queue *, struct request *, struct request *);
 
 typedef void (elevator_merged_fn) (struct request_queue *, struct request *, int);
 
-typedef int (elevator_allow_merge_fn) (struct request_queue *, struct request *, struct bio *);
+typedef int (elevator_allow_merge_fn) (struct request_queue *, struct request *,
+				       struct request *);
 
 typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
@@ -99,7 +100,7 @@ extern void elv_dispatch_add_tail(struct
 extern void elv_add_request(struct request_queue *, struct request *, int, int);
 extern void __elv_add_request(struct request_queue *, struct request *, int, int);
 extern void elv_insert(struct request_queue *, struct request *, int);
-extern int elv_merge(struct request_queue *, struct request **, struct bio *);
+extern int elv_merge(struct request_queue *, struct request **, struct request *);
 extern void elv_merge_requests(struct request_queue *, struct request *,
 			       struct request *);
 extern void elv_merged_request(struct request_queue *, struct request *, int);
@@ -130,7 +131,7 @@ extern ssize_t elv_iosched_store(struct 
 
 extern int elevator_init(struct request_queue *, char *);
 extern void elevator_exit(elevator_t *);
-extern int elv_rq_merge_ok(struct request *, struct bio *);
+extern int elv_rq_merge_ok(struct request *, struct request *);
 
 /*
  * Helper functions.
