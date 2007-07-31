Return-Path: <linux-kernel-owner+w=401wt.eu-S940805AbXGaCVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940805AbXGaCVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbXGaCRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:01 -0400
Received: from ns1.suse.de ([195.135.220.2]:52737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965367AbXGaCQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:58 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:45 +1000
Message-Id: <1070731021645.25240@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 011 of 35] Stop exporting blk_rq_bio_prep
References: <20070731112539.22428.patches@notabene>
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
 ./block/ll_rw_blk.c      |   10 ++++++----
 ./drivers/md/dm-emc.c    |   10 +---------
 ./include/linux/blkdev.h |    1 -
 3 files changed, 7 insertions(+), 14 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:55.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:56.000000000 +1000
@@ -43,6 +43,8 @@ static void init_request_from_bio(struct
 static int __make_request(struct request_queue *q, struct bio *bio);
 static struct io_context *current_io_context(gfp_t gfp_flags, int node);
 static void blk_recalc_rq_segments(struct request *rq);
+static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
+			    struct bio *bio);
 
 /*
  * For the allocated request tables
@@ -3628,8 +3630,8 @@ void end_request(struct request *req, in
 
 EXPORT_SYMBOL(end_request);
 
-void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
-		     struct bio *bio)
+static void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
+			    struct bio *bio)
 {
 	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
 	rq->cmd_flags |= (bio->bi_rw & 3);
@@ -3644,10 +3646,10 @@ void blk_rq_bio_prep(struct request_queu
 	rq->buffer = blk_rq_data(rq);
 	rq->current_nr_sectors = blk_rq_cur_sectors(rq);
 	rq->hard_cur_sectors = rq->current_nr_sectors;
+	if (bio->bi_bdev)
+		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
-EXPORT_SYMBOL(blk_rq_bio_prep);
-
 void *blk_rq_data(struct request *rq)
 {
 	struct bio_vec bvec;

diff .prev/drivers/md/dm-emc.c ./drivers/md/dm-emc.c
--- .prev/drivers/md/dm-emc.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/dm-emc.c	2007-07-31 11:20:56.000000000 +1000
@@ -106,15 +106,7 @@ static struct request *get_failover_req(
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
--- .prev/include/linux/blkdev.h	2007-07-31 11:20:55.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:20:56.000000000 +1000
@@ -837,7 +837,6 @@ static inline struct request *blk_map_qu
 	return bqt->tag_index[tag];
 }
 
-extern void blk_rq_bio_prep(struct request_queue *, struct request *, struct bio *);
 extern int blkdev_issue_flush(struct block_device *, sector_t *);
 
 #define MAX_PHYS_SEGMENTS 128
