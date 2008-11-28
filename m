Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYK1Ec2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYK1Ec2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYK1EcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:45250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYK1EcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:17 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] block: remove duplicate or unused barrier/discard error paths
Date: Fri, 28 Nov 2008 13:32:03 +0900
Message-Id: <1227846727-24980-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227846727-24980-1-git-send-email-tj@kernel.org>
References: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Because barrier mode can be changed dynamically, whether barrier is
  supported or not can be determined only when actually issuing the
  barrier and there is no point in checking it earlier.  Drop barrier
  support check in generic_make_request() and __make_request(), and
  update comment around the support check in blk_do_ordered().

* There is no reason to check discard support in both
  generic_make_request() and __make_request().  Drop the check in
  __make_request().  While at it, move error action block to the end
  of the function and add unlikely() to q existence test.

* Barrier request, be it empty or not, is never passed to low level
  driver and thus it's meaningless to try to copy back req->sector to
  bio->bi_sector on error.  In addition, the notion of failed sector
  doesn't make any sense for empty barrier to begin with.  Drop the
  code block from __end_that_request_first().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c |    4 ++--
 block/blk-core.c    |   44 +++++++++++---------------------------------
 2 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 1d7adc7..43d479a 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -216,8 +216,8 @@ int blk_do_ordered(struct request_queue *q, struct request **rqp)
 			return 1;
 		} else {
 			/*
-			 * This can happen when the queue switches to
-			 * ORDERED_NONE while this request is on it.
+			 * Queue ordering not supported.  Terminate
+			 * with prejudice.
 			 */
 			elv_dequeue_request(q, rq);
 			if (__blk_end_request(rq, -EOPNOTSUPP,
diff --git a/block/blk-core.c b/block/blk-core.c
index d472c4b..43ed62b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1131,7 +1131,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 static int __make_request(struct request_queue *q, struct bio *bio)
 {
 	struct request *req;
-	int el_ret, nr_sectors, barrier, discard, err;
+	int el_ret, nr_sectors;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
 	int rw_flags;
@@ -1145,22 +1145,9 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	 */
 	blk_queue_bounce(q, &bio);
 
-	barrier = bio_barrier(bio);
-	if (unlikely(barrier) && bio_has_data(bio) &&
-	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-		err = -EOPNOTSUPP;
-		goto end_io;
-	}
-
-	discard = bio_discard(bio);
-	if (unlikely(discard) && !q->prepare_discard_fn) {
-		err = -EOPNOTSUPP;
-		goto end_io;
-	}
-
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely(barrier) || elv_queue_empty(q))
+	if (unlikely(bio_barrier(bio)) || elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
@@ -1254,10 +1241,6 @@ out:
 		__generic_unplug_device(q);
 	spin_unlock_irq(q->queue_lock);
 	return 0;
-
-end_io:
-	bio_endio(bio, err);
-	return 0;
 }
 
 /*
@@ -1410,15 +1393,13 @@ static inline void __generic_make_request(struct bio *bio)
 		char b[BDEVNAME_SIZE];
 
 		q = bdev_get_queue(bio->bi_bdev);
-		if (!q) {
+		if (unlikely(!q)) {
 			printk(KERN_ERR
 			       "generic_make_request: Trying to access "
 				"nonexistent block-device %s (%Lu)\n",
 				bdevname(bio->bi_bdev, b),
 				(long long) bio->bi_sector);
-end_io:
-			bio_endio(bio, err);
-			break;
+			goto end_io;
 		}
 
 		if (unlikely(nr_sectors > q->max_hw_sectors)) {
@@ -1455,14 +1436,19 @@ end_io:
 
 		if (bio_check_eod(bio, nr_sectors))
 			goto end_io;
-		if ((bio_empty_barrier(bio) && !q->prepare_flush_fn) ||
-		    (bio_discard(bio) && !q->prepare_discard_fn)) {
+
+		if (bio_discard(bio) && !q->prepare_discard_fn) {
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
+
+	return;
+
+end_io:
+	bio_endio(bio, err);
 }
 
 /*
@@ -1712,14 +1698,6 @@ static int __end_that_request_first(struct request *req, int error,
 	while ((bio = req->bio) != NULL) {
 		int nbytes;
 
-		/*
-		 * For an empty barrier request, the low level driver must
-		 * store a potential error location in ->sector. We pass
-		 * that back up in ->bi_sector.
-		 */
-		if (blk_empty_barrier(req))
-			bio->bi_sector = req->sector;
-
 		if (nr_bytes >= bio->bi_size) {
 			req->bio = bio->bi_next;
 			nbytes = bio->bi_size;
-- 
1.5.6

