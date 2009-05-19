Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZESVE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZESVE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZESVEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:04:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbZESVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:04:50 -0400
Date: Tue, 19 May 2009 17:03:54 -0400
Message-Id: <336ca1a08b25afab0a23d469adb94d0d2a672954.1242763826.git.jbaron@redhat.com>
In-Reply-To: <cover.1242763826.git.jbaron@redhat.com>
References: <cover.1242763826.git.jbaron@redhat.com>
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: [PATCH 3/3] tracepoints: convert block tracepoints to 'tracepoint_call' api
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert the block trace tracepoints to the new 'tracepoint_call' api.


Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 block/blk-core.c |   27 ++++++++++++++-------------
 block/elevator.c |    6 +++---
 drivers/md/dm.c  |    7 ++++---
 fs/bio.c         |    2 +-
 mm/bounce.c      |    2 +-
 5 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1306de9..1e10e0b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -223,7 +223,7 @@ void blk_plug_device(struct request_queue *q)
 
 	if (!queue_flag_test_and_set(QUEUE_FLAG_PLUGGED, q)) {
 		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
-		trace_block_plug(q);
+		tracepoint_call(block_plug, q);
 	}
 }
 EXPORT_SYMBOL(blk_plug_device);
@@ -309,7 +309,7 @@ void blk_unplug_work(struct work_struct *work)
 	struct request_queue *q =
 		container_of(work, struct request_queue, unplug_work);
 
-	trace_block_unplug_io(q);
+	tracepoint_call(block_unplug_io, q);
 	q->unplug_fn(q);
 }
 
@@ -317,7 +317,7 @@ void blk_unplug_timeout(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *)data;
 
-	trace_block_unplug_timer(q);
+	tracepoint_call(block_unplug_timer, q);
 	kblockd_schedule_work(q, &q->unplug_work);
 }
 
@@ -327,7 +327,7 @@ void blk_unplug(struct request_queue *q)
 	 * devices don't necessarily have an ->unplug_fn defined
 	 */
 	if (q->unplug_fn) {
-		trace_block_unplug_io(q);
+		tracepoint_call(block_unplug_io, q);
 		q->unplug_fn(q);
 	}
 }
@@ -831,7 +831,7 @@ rq_starved:
 	if (ioc_batching(q, ioc))
 		ioc->nr_batch_requests--;
 
-	trace_block_getrq(q, bio, rw_flags & 1);
+	tracepoint_call(block_getrq, q, bio, rw_flags & 1);
 out:
 	return rq;
 }
@@ -857,7 +857,7 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 		prepare_to_wait_exclusive(&rl->wait[is_sync], &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		trace_block_sleeprq(q, bio, rw_flags & 1);
+		tracepoint_call(block_sleeprq, q, bio, rw_flags & 1);
 
 		__generic_unplug_device(q);
 		spin_unlock_irq(q->queue_lock);
@@ -937,7 +937,7 @@ void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
 	blk_delete_timer(rq);
 	blk_clear_rq_complete(rq);
-	trace_block_rq_requeue(q, rq);
+	tracepoint_call(block_rq_requeue, q, rq);
 
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
@@ -1178,7 +1178,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		if (!ll_back_merge_fn(q, req, bio))
 			break;
 
-		trace_block_bio_backmerge(q, bio);
+		tracepoint_call(block_bio_backmerge, q, bio);
 
 		req->biotail->bi_next = bio;
 		req->biotail = bio;
@@ -1197,7 +1197,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		if (!ll_front_merge_fn(q, req, bio))
 			break;
 
-		trace_block_bio_frontmerge(q, bio);
+		tracepoint_call(block_bio_frontmerge, q, bio);
 
 		bio->bi_next = req->bio;
 		req->bio = bio;
@@ -1276,7 +1276,7 @@ static inline void blk_partition_remap(struct bio *bio)
 		bio->bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;
 
-		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
+		tracepoint_call(block_remap, bdev_get_queue(bio->bi_bdev), bio,
 				    bdev->bd_dev,
 				    bio->bi_sector - p->start_sect);
 	}
@@ -1446,9 +1446,10 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 
 		if (old_sector != -1)
-			trace_block_remap(q, bio, old_dev, old_sector);
+			tracepoint_call(block_remap, q, bio,
+						old_dev, old_sector);
 
-		trace_block_bio_queue(q, bio);
+		tracepoint_call(block_bio_queue, q, bio);
 
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
@@ -1737,7 +1738,7 @@ static int __end_that_request_first(struct request *req, int error,
 	int total_bytes, bio_nbytes, next_idx = 0;
 	struct bio *bio;
 
-	trace_block_rq_complete(req->q, req);
+	tracepoint_call(block_rq_complete, req->q, req);
 
 	/*
 	 * for a REQ_TYPE_BLOCK_PC request, we want to carry any eventual
diff --git a/block/elevator.c b/block/elevator.c
index 7073a90..0aa6cdb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -618,7 +618,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 	unsigned ordseq;
 	int unplug_it = 1;
 
-	trace_block_rq_insert(q, rq);
+	tracepoint_call(block_rq_insert, q, rq);
 
 	rq->q = q;
 
@@ -796,7 +796,7 @@ struct request *elv_next_request(struct request_queue *q)
 			 * not be passed by new incoming requests
 			 */
 			rq->cmd_flags |= REQ_STARTED;
-			trace_block_rq_issue(q, rq);
+			tracepoint_call(block_rq_issue, q, rq);
 		}
 
 		if (!q->boundary_rq || q->boundary_rq == rq) {
@@ -938,7 +938,7 @@ void elv_abort_queue(struct request_queue *q)
 	while (!list_empty(&q->queue_head)) {
 		rq = list_entry_rq(q->queue_head.next);
 		rq->cmd_flags |= REQ_QUIET;
-		trace_block_rq_abort(q, rq);
+		tracepoint_call(block_rq_abort, q, rq);
 		__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
 	}
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e2ee4a7..106a73d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -561,7 +561,8 @@ static void dec_pending(struct dm_io *io, int error)
 			end_io_acct(io);
 
 			if (io_error != DM_ENDIO_REQUEUE) {
-				trace_block_bio_complete(md->queue, bio);
+				tracepoint_call(block_bio_complete,
+							md->queue, bio);
 
 				bio_endio(bio, io_error);
 			}
@@ -655,8 +656,8 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
-		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
-				    tio->io->bio->bi_bdev->bd_dev, sector);
+		tracepoint_call(block_remap, bdev_get_queue(clone->bi_bdev),
+				clone, tio->io->bio->bi_bdev->bd_dev, sector);
 
 		generic_make_request(clone);
 	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
diff --git a/fs/bio.c b/fs/bio.c
index 9871164..5cda18a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1440,7 +1440,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	if (!bp)
 		return bp;
 
-	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
+	tracepoint_call(block_split, bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
 
 	BUG_ON(bi->bi_vcnt != 1);
diff --git a/mm/bounce.c b/mm/bounce.c
index e590272..c160109 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -230,7 +230,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	if (!bio)
 		return;
 
-	trace_block_bio_bounce(q, *bio_orig);
+	tracepoint_call(block_bio_bounce, q, *bio_orig);
 
 	/*
 	 * at least one page was bounced, fill in possible non-highmem
-- 
1.6.0.6

