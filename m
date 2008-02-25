Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYBYDgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYBYDgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 22:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYBYDgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 22:36:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:57003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752200AbYBYDgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 22:36:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Nm749gFyNuw7EZBD25DguzNwnVcfVbtWAjj/9U2
	ZfAaFFFxtRndl+
Subject: Re: [Regression in 2.6.25-rcX] CD/DVD writer no longer works
From: Mike Galbraith <efault@gmx.de>
To: zkopex <zkopex@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <211548.78349.qm@web45213.mail.sp1.yahoo.com>
References: <211548.78349.qm@web45213.mail.sp1.yahoo.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 04:36:27 +0100
Message-Id: <1203910587.12670.9.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-02-24 at 12:57 -0800, zkopex wrote:
> Hello,

Greetings,

> I am using Debian Sid on a Toshiba A100 laptop. My CD/DVD
> writer functions very well on 2.6.23.16 and 2.6.24.2.
> 
> I tried 2.6.25-rc2-git7, and I was very sad to notice that
> when I tried to write a CD, wodim started to output the
> following: "Warning: controller returns zero sized CD
> capabilities page."

Yeah, I saw that using k3b.

> Since I was able to use this CD/DVD writer successfully with
> previous versions of Linux, I believe that this is a regression
> in 2.6.25-rcX series.
> 
> I am willing to try patches and to do pretty much anything
> to debug/fix this problem.

Sounds like you're having the same problem I am.  In my case, reverting
all but one line of commit 6b00769fe1502b4ad97bb327ef7ac971b208bfb5
cures it, though I don't see why.

Revert patch below is against freshly hatched rc3 if you want to try it.

diff --git a/block/blk-core.c b/block/blk-core.c
index 775c851..c013ca2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,6 @@ void rq_init(struct request_queue *q, struct request *rq)
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -2016,7 +2015,6 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff --git a/block/blk-map.c b/block/blk-map.c
index 09f7fd0..ae4a0fc 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 7506c4f..a15d0ee 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -231,7 +231,6 @@ new_segment:
 			    ((unsigned long)q->dma_drain_buffer) &
 			    (PAGE_SIZE - 1));
 		nsegs++;
-		rq->data_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff --git a/block/bsg.c b/block/bsg.c
index 7f3c095..8917c51 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->raw_data_len;
-		hdr->din_resid = rq->next_rq->raw_data_len;
+		hdr->dout_resid = rq->data_len;
+		hdr->din_resid = rq->next_rq->data_len;
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->raw_data_len;
+		hdr->din_resid = rq->data_len;
 	else
-		hdr->dout_resid = rq->raw_data_len;
+		hdr->dout_resid = rq->data_len;
 
 	/*
 	 * If the request generated a negative error number, return it
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e993cac..9675b34 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = rq->data_len;
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,7 +528,6 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
-	rq->raw_data_len = 0;
 	rq->data_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..85daaaa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2539,7 +2539,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(qc->nbytes, (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6fe67d1..094eba2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,7 +216,6 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
 	unsigned int sense_len;
 	void *data;


