Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZDUQmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZDUQmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZDUQiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:38:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZDUQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:38:21 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 14/14] block-kill-data
Date: Wed, 22 Apr 2009 01:38:01 +0900
Message-Id: <1240331881-28218-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240331881-28218-1-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:38:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all block request data transfer is done via bio, rq->data
isn't used.  Kill it.

While at it, make the roles of rq->special and buffer clear.

[ Impact: drop now unncessary field from struct request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c        |    5 ++---
 block/blk-map.c         |    6 +++---
 block/scsi_ioctl.c      |    1 -
 drivers/scsi/scsi_lib.c |    1 -
 include/linux/blkdev.h  |    5 ++---
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b7c9464..339e5e9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -189,10 +189,9 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 						(unsigned long long)rq->sector,
 						rq->nr_sectors,
 						rq->current_nr_sectors);
-	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, data %p, len %u\n",
+	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, len %u\n",
 						rq->bio, rq->biotail,
-						rq->buffer, rq->data,
-						rq->data_len);
+						rq->buffer, rq->data_len);
 
 	if (blk_pc_request(rq)) {
 		printk(KERN_INFO "  cdb: ");
diff --git a/block/blk-map.c b/block/blk-map.c
index f103729..694fefa 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -156,7 +156,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	if (!bio_flagged(bio, BIO_USER_MAPPED))
 		rq->cmd_flags |= REQ_COPY_USER;
 
-	rq->buffer = rq->data = NULL;
+	rq->buffer = NULL;
 	return 0;
 unmap_rq:
 	blk_rq_unmap_user(bio);
@@ -235,7 +235,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	blk_queue_bounce(q, &bio);
 	bio_get(bio);
 	blk_rq_bio_prep(q, rq, bio);
-	rq->buffer = rq->data = NULL;
+	rq->buffer = NULL;
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_map_user_iov);
@@ -313,7 +313,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 
 	blk_rq_bio_prep(q, rq, bio);
 	blk_queue_bounce(q, &rq->bio);
-	rq->buffer = rq->data = NULL;
+	rq->buffer = NULL;
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 82a0ca2..bb9aa43 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -500,7 +500,6 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->data = NULL;
 	rq->data_len = 0;
 	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 756ac7c..aa9fc57 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1088,7 +1088,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 			return ret;
 	} else {
 		BUG_ON(req->data_len);
-		BUG_ON(req->data);
 
 		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 		req->buffer = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0bb3ed4..b1de769 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -209,8 +209,8 @@ struct request {
 
 	unsigned short ioprio;
 
-	void *special;
-	char *buffer;
+	void *special;		/* opaque pointer available for LLD use */
+	char *buffer;		/* kaddr of the current segment if available */
 
 	int tag;
 	int errors;
@@ -227,7 +227,6 @@ struct request {
 	unsigned int data_len;
 	unsigned int extra_len;	/* length of alignment and padding */
 	unsigned int sense_len;
-	void *data;
 	void *sense;
 
 	unsigned long deadline;
-- 
1.6.0.2

