Return-Path: <linux-kernel-owner+w=401wt.eu-S941154AbXGaC15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941154AbXGaC15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940459AbXGaCSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:36090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940447AbXGaCSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:18 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:04 +1000
Message-Id: <1070731021804.25499@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 026 of 35] Split any large bios that arrive at __make_request.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that bi_io_vec and bio can be shared, we can handle arbitrarily
large bios in __make_request by splitting them over multiple
requests.
If we do split a request, we mark both halves as "REQ_NOMERGE".
It is only really necessary to mark the first part as
 NO_BACK_MERGE
and the second part as
 NO_FRONT_MERGE
but that distinction isn't currently supported.

Note that we do not try to merge part of a large bio to
a neighbouring request.  That is a possible future enhancement.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |  122 +++++++++++++++++++++++++++++++++++++++--------
 ./include/linux/blkdev.h |    5 +
 2 files changed, 107 insertions(+), 20 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:15.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:20.000000000 +1000
@@ -1221,13 +1221,21 @@ static void blk_recalc_rq_segments(struc
 	struct req_iterator i;
 	int high, highprv = 1;
 	struct request_queue *q = rq->q;
+	int curr_size = 0;
+	unsigned short max_sectors;
 
 	if (!rq->bio)
 		return;
 
+	if (unlikely(blk_pc_request(rq)))
+		max_sectors = q->max_hw_sectors;
+	else
+		max_sectors = q->max_sectors;
+
 	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
 	hw_seg_size = seg_size = 0;
 	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
+	rq->max_allowed_size = 0;
 	rq_for_each_segment(rq, i, bv) {
 		/*
 		 * the trick here is making sure that a high page is never
@@ -1249,9 +1257,7 @@ static void blk_recalc_rq_segments(struc
 
 			seg_size += bv.bv_len;
 			hw_seg_size += bv.bv_len;
-			bvprv = bv;
-			prvidx = i.i.i;
-			continue;
+			goto same_seg;
 		}
 new_segment:
 		if (BIOVEC_VIRT_MERGEABLE(&bvprv, &bv) &&
@@ -1267,11 +1273,19 @@ new_hw_segment:
 		}
 
 		nr_phys_segs++;
+		seg_size = bv.bv_len;
+same_seg:
+		curr_size += bv.bv_len;
 		bvprv = bv;
 		prvidx = i.i.i;
-		seg_size = bv.bv_len;
 		highprv = high;
+
+		if (curr_size <= (max_sectors << 9) &&
+		    nr_phys_segs <= q->max_phys_segments &&
+		    nr_hw_segs <= q->max_hw_segments)
+			rq->max_allowed_size = curr_size;
 	}
+
 	rq->last_len = bvprv.bv_offset + bvprv.bv_len;
 	rq->last_idx = prvidx;
 
@@ -2924,6 +2938,70 @@ static void init_request_from_bio(struct
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
+static void rq_split(struct request *orig, struct request *new)
+{
+
+	/* 'orig' contains exactly one bio, and may refer to
+	 * some section in the middle of that bio.
+	 * Make 'new' refer to the beginning of that section, up
+	 * to orig->max_allowed_size.
+	 * Remove from 'orig' everything that went into 'new'.
+	 * If 'orig' becomes empty, release it's reference to the bio.
+	 */
+
+	new->cmd_type = orig->cmd_type;
+	new->cmd_flags |= orig->cmd_flags;
+	new->errors = 0;
+	new->hard_sector = new->sector = orig->hard_sector;
+	new->ioprio = orig->ioprio;
+	new->start_time = jiffies;
+	new->data_len = orig->data_len;
+	new->bio = orig->bio;
+	atomic_inc(&orig->bio->bi_iocnt);
+	new->biotail = orig->biotail;
+	new->current_nr_sectors = orig->current_nr_sectors;
+
+	new->buffer = orig->buffer;
+	new->rq_disk = orig->rq_disk;
+
+	if (orig->max_allowed_size == orig->hard_nr_sectors << 9) {
+		/* all of orig goes into new */
+		new->nr_sectors = new->hard_nr_sectors
+			= orig->hard_nr_sectors;
+		new->nr_phys_segments = orig->nr_phys_segments;
+		new->nr_hw_segments = orig->nr_hw_segments;
+		new->hw_front_size = orig->hw_front_size;
+		new->hw_back_size = orig->hw_back_size;
+		new->last_len = orig->last_len;
+		new->last_idx = orig->last_idx;
+
+		orig->nr_sectors = orig->hard_nr_sectors  = 0;
+		atomic_dec(&orig->bio->bi_iocnt);
+		orig->bio = NULL;
+	} else {
+		/* start of orig goes into new, rest stays in orig */
+		int offset;
+		new->nr_sectors = new->hard_nr_sectors
+			= (orig->max_allowed_size >> 9);
+		new->data_len = new->nr_sectors << 9;
+		new->biotail = NULL;
+		new->cmd_flags |= REQ_NOMERGE;
+
+		orig->nr_sectors = orig->hard_nr_sectors
+			-= orig->max_allowed_size >> 9;
+		orig->data_len = orig->nr_sectors << 9;
+		orig->sector = orig->hard_sector += orig->max_allowed_size >> 9;
+		offset = orig->first_offset + orig->max_allowed_size;
+		orig->first_offset = offset;
+		if (offset)
+			orig->cmd_flags |= REQ_NOMERGE;
+
+		blk_recalc_rq_segments(new);
+		BUG_ON(new->hard_nr_sectors != (new->max_allowed_size >> 9));
+		blk_recalc_rq_segments(orig);
+	}
+}
+
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
 	struct request *req;
@@ -3029,24 +3107,28 @@ get_rq:
 	if (sync)
 		rw_flags |= REQ_RW_SYNC;
 
-	/*
-	 * Grab a free request. This is might sleep but can not fail.
-	 * Returns with the queue unlocked.
-	 */
-	req = get_request_wait(q, rw_flags, bio);
+	while (nreq.hard_nr_sectors) {
+		/*
+		 * Grab a free request. This is might sleep but can
+		 * not fail.  Returns with the queue unlocked.
+		 */
+		req = get_request_wait(q, rw_flags, bio);
+		rq_split(&nreq, req);
 
-	/*
-	 * After dropping the lock and possibly sleeping here, our request
-	 * may now be mergeable after it had proven unmergeable (above).
-	 * We don't worry about that case for efficiency. It won't happen
-	 * often, and the elevators are able to handle it.
-	 */
-	init_request_from_bio(req, bio);
+		/*
+		 * After dropping the lock and possibly sleeping here,
+		 * our request may now be mergeable after it had
+		 * proven unmergeable (above).  We don't worry about
+		 * that case for efficiency. It won't happen often,
+		 * and the elevators are able to handle it.
+		 */
+
+		spin_lock_irq(q->queue_lock);
+		if (elv_queue_empty(q))
+			blk_plug_device(q);
+		add_request(q, req);
+	}
 
-	spin_lock_irq(q->queue_lock);
-	if (elv_queue_empty(q))
-		blk_plug_device(q);
-	add_request(q, req);
 out:
 	if (sync)
 		__generic_unplug_device(q);

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:15.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:20.000000000 +1000
@@ -262,6 +262,11 @@ struct request {
 				 * so it matches bv_offset+bv_len in
 				 * the simple case.
 				 */
+	int max_allowed_size;   /* If this number (in bytes) is less than
+				 * hard_nr_sectors  (in sectors), the request
+				 * is too big for the queue and must be
+				 * split.
+				 */
 
 	struct hlist_node hash;	/* merge hash */
 	/*
