Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXJVOEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXJVOEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXJVOEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:04:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXJVOD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:03:59 -0400
Message-ID: <471CACC3.7000007@redhat.com>
Date: Mon, 22 Oct 2007 15:59:31 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [PATCH] block layer: remove a unused argument of drive_stat_acct()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The nr_sector argument of drive_stat_acct() is not used anymore since the read and write sectors statistics are now updated in end_that_request_first(). This patch removes the useless argument.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 ll_rw_blk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3935469..c0612fe 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -39,7 +39,7 @@
 
 static void blk_unplug_work(struct work_struct *work);
 static void blk_unplug_timeout(unsigned long data);
-static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io);
+static void drive_stat_acct(struct request *rq, int new_io);
 static void init_request_from_bio(struct request *req, struct bio *bio);
 static int __make_request(struct request_queue *q, struct bio *bio);
 static struct io_context *current_io_context(gfp_t gfp_flags, int node);
@@ -2329,7 +2329,7 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 	if (blk_rq_tagged(rq))
 		blk_queue_end_tag(q, rq);
 
-	drive_stat_acct(rq, rq->nr_sectors, 1);
+	drive_stat_acct(rq, 1);
 	__elv_add_request(q, rq, where, 0);
 	blk_start_queueing(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -2724,7 +2724,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io)
+static void drive_stat_acct(struct request *rq, int new_io)
 {
 	int rw = rq_data_dir(rq);
 
@@ -2746,7 +2746,7 @@ static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io)
  */
 static inline void add_request(struct request_queue * q, struct request * req)
 {
-	drive_stat_acct(req, req->nr_sectors, 1);
+	drive_stat_acct(req, 1);
 
 	/*
 	 * elevator indicated where it wants this request to be
@@ -3003,7 +3003,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 			req->biotail = bio;
 			req->nr_sectors = req->hard_nr_sectors += nr_sectors;
 			req->ioprio = ioprio_best(req->ioprio, prio);
-			drive_stat_acct(req, nr_sectors, 0);
+			drive_stat_acct(req, 0);
 			if (!attempt_back_merge(q, req))
 				elv_merged_request(q, req, el_ret);
 			goto out;
@@ -3030,7 +3030,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 			req->sector = req->hard_sector = bio->bi_sector;
 			req->nr_sectors = req->hard_nr_sectors += nr_sectors;
 			req->ioprio = ioprio_best(req->ioprio, prio);
-			drive_stat_acct(req, nr_sectors, 0);
+			drive_stat_acct(req, 0);
 			if (!attempt_front_merge(q, req))
 				elv_merged_request(q, req, el_ret);
 			goto out;
