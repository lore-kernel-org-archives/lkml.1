Return-Path: <linux-kernel-owner+w=401wt.eu-S934861AbXHPLXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934861AbXHPLXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933951AbXHPLV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:21:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:47889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933846AbXHPLV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:21:28 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:21:21 +1000
Message-Id: <1070816112121.12230@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 005 of 6] Stop exporting blk_rq_bio_prep
References: <20070816211551.11839.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


blk_rq_bio_prep is exported for use in exactly
one place.  That place can benefit from using
the new blk_rq_append_bio instead. 
So
  - change dm-emc to call blk_rq_append_bio
  - stop exporting blk_rq_bio_prep, and
  - initialise rq_disk in blk_rq_bio_prep,
       as dm-emc needs it.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   11 +++++++----
 ./drivers/md/dm-emc.c    |   10 +---------
 ./include/linux/blkdev.h |    1 -
 3 files changed, 8 insertions(+), 14 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 21:10:16.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 21:10:55.000000000 +1000
@@ -43,6 +43,8 @@ static void init_request_from_bio(struct
 static int __make_request(struct request_queue *q, struct bio *bio);
 static struct io_context *current_io_context(gfp_t gfp_flags, int node);
 static void blk_recalc_rq_segments(struct request *rq);
+static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
+			    struct bio *bio);
 
 /*
  * For the allocated request tables
@@ -3652,8 +3654,8 @@ void end_request(struct request *req, in
 
 EXPORT_SYMBOL(end_request);
 
-void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
-		     struct bio *bio)
+static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
+			    struct bio *bio)
 {
 	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
 	rq->cmd_flags |= (bio->bi_rw & 3);
@@ -3667,9 +3669,10 @@ void blk_rq_bio_prep(struct request_queu
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
-}
 
-EXPORT_SYMBOL(blk_rq_bio_prep);
+	if (bio->bi_bdev)
+		rq->rq_disk = bio->bi_bdev->bd_disk;
+}
 
 int kblockd_schedule_work(struct work_struct *work)
 {

diff .prev/drivers/md/dm-emc.c ./drivers/md/dm-emc.c
--- .prev/drivers/md/dm-emc.c	2007-08-16 17:37:43.000000000 +1000
+++ ./drivers/md/dm-emc.c	2007-08-16 21:10:30.000000000 +1000
@@ -109,15 +109,7 @@ static struct request *get_failover_req(
 		return NULL;
 	}
 
-	rq->bio = rq->biotail = bio;
-	blk_rq_bio_prep(q, rq, bio);
-
-	rq->rq_disk = bdev->bd_contains->bd_disk;
-
-	/* bio backed don't set data */
-	rq->buffer = rq->data = NULL;
-	/* rq data_len used for pc cmd's request_bufflen */
-	rq->data_len = bio->bi_size;
+	blk_rq_append_bio(q, rq, bio);
 
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 21:10:16.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 21:10:30.000000000 +1000
@@ -823,7 +823,6 @@ static inline struct request *blk_map_qu
 	return bqt->tag_index[tag];
 }
 
-extern void blk_rq_bio_prep(struct request_queue *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
 
 #define MAX_PHYS_SEGMENTS 128
