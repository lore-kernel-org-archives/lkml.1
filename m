Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbXKOLcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbXKOLcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXKOLb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:31:58 -0500
Received: from ozlabs.org ([203.10.76.45]:57875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXKOLb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:31:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Attempt to get eject failures back to ioctl(CDROMEJECT)
Date: Thu, 15 Nov 2007 22:32:02 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200711141739.46960.rusty@rustcorp.com.au> <200711151335.53053.rusty@rustcorp.com.au> <20071115084705.GE638@kernel.dk>
In-Reply-To: <20071115084705.GE638@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152232.02522.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 19:47:05 Jens Axboe wrote:
> On Thu, Nov 15 2007, Rusty Russell wrote:
> > If blk_rq_map_sg returns more than was allocated, it's a bug, and
> > something's already been overwritten.  BUG_ON() is probably the right
> > thing here.
>
> It really just means that it mapped more segments than the block layer
> said it would. Usually that wont overwrite memory here since scsi rounds
> up on allocating the sg list, but it indeed can. Similar code has been
> in scsi_lib.c for ages, I'd suggest covering that in the same patch.

Good point.  I assume that you've not seen these printks in recent memory?

This covers both cases:

Subject: [PATCH] scsi: BUG_ON() impossible condition.

If blk_rq_map_sg wrote more than was allocated in the scatterlist,
BUG_ON() is probably the right thing to do.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/scsi/scsi_tgt_lib.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1102,7 +1102,6 @@ void scsi_io_completion(struct scsi_cmnd
  *
  * Returns:     0 on success
  *		BLKPREP_DEFER if the failure is retryable
- *		BLKPREP_KILL if the failure is fatal
  */
 static int scsi_init_io(struct scsi_cmnd *cmd)
 {
@@ -1136,17 +1135,9 @@ static int scsi_init_io(struct scsi_cmnd
 	 * each segment.
 	 */
 	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
-		return BLKPREP_OK;
-	}
-
-	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
-	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
-			req->current_nr_sectors);
-
-	return BLKPREP_KILL;
+	BUG_ON(count > cmd->use_sg);
+	cmd->use_sg = count;
+	return BLKPREP_OK;
 }
 
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -367,14 +367,9 @@ static int scsi_tgt_init_cmd(struct scsi
 
 	dprintk("cmd %p cnt %d %lu\n", cmd, cmd->use_sg, rq_data_dir(rq));
 	count = blk_rq_map_sg(rq->q, rq, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
-		return 0;
-	}
-
-	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
-	scsi_free_sgtable(cmd);
-	return -EINVAL;
+	BUG_ON(count > cmd->use_sg);
+	cmd->use_sg = count;
+	return 0;
 }
 
 /* TODO: test this crap and replace bio_map_user with new interface maybe */
