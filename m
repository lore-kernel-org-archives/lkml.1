Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYCQBEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYCQBEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYCQBEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:04:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbYCQBEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:04:23 -0400
Date: Sun, 16 Mar 2008 17:59:55 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       <fujita.tomonori@lab.ntt.co.jp>, zaitcev@redhat.com
Subject: Re: USB oops with mainline (post 2.6.25-rc5)
Message-Id: <20080316175955.3ace8f4d.zaitcev@redhat.com>
In-Reply-To: <20080316230256.GA3977@puku.stupidest.org>
References: <20080312093045.GA24017@xi.wantstofly.org>
	<200803120313.23568.david-b@pacbell.net>
	<20080316223257.GA4095@puku.stupidest.org>
	<200803161543.37993.david-b@pacbell.net>
	<20080316230256.GA3977@puku.stupidest.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 16:02:56 -0700, Chris Wedgwood <cw@f00f.org> wrote:

> > Does that happen with usb-storage too, or just "ub"?  ISTR hearing
> > about similar issues specific to "ub".
> 
> It's ub specific and reproducable.  With usb-storage everything works
> as expected.
> 
> I'll post the UB oops in a few minutes.

It's the BUG() which the new s/g API change added.

I don't know exactly what caused it. It's possible that block layer
is buggy by itself. Or perhaps hald sens a packet command and the
conversion to the new API is not complete. In the old API drivers
had to adjust the request, but in the new one the right way seems
to pass the byte count into the __blk_end_request. I don't have
a specific guidance regarding it, and the conversion of ub was
hurried apparently.

Try this, please:

--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -359,7 +360,8 @@ static void ub_cmd_build_block(struct ub_dev *sc, struct ub_lun *lun,
 static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_scsi_cmd *cmd, struct ub_request *urq);
 static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
-static void ub_end_rq(struct request *rq, unsigned int status);
+static void ub_end_rq(struct request *rq, unsigned int status,
+    unsigned int act_len, unsigned int length);
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_request *urq, struct ub_scsi_cmd *cmd);
 static int ub_submit_scsi(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
@@ -642,13 +644,13 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 
 	if (atomic_read(&sc->poison)) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, DID_NO_CONNECT << 16);
+		ub_end_rq(rq, DID_NO_CONNECT << 16, 0, 1);
 		return 0;
 	}
 
 	if (lun->changed && !blk_pc_request(rq)) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION);
+		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION, 0, 1);
 		return 0;
 	}
 
@@ -701,7 +703,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 
 drop:
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, DID_ERROR << 16);
+	ub_end_rq(rq, DID_ERROR << 16, 0, 3);
 	return 0;
 }
 
@@ -775,12 +777,30 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 
 	if (cmd->error == 0) {
 		if (blk_pc_request(rq)) {
+#if 0
+/*
+ * This was required for cdrecord to work before the Tomo's __blk_end_request.
+ * Now, doing so causes __blk_end_request to end with a nonzero.
+ */
 			if (cmd->act_len >= rq->data_len)
 				rq->data_len = 0;
 			else
 				rq->data_len -= cmd->act_len;
+#endif
+			scsi_status = 0;
+		} else {
+			if (cmd->act_len != rq->nr_sectors * 512) {
+				/*
+				 * XXX Not sure if this is worth retrying.
+				 * Maybe it's some kind of end-of-device?
+				 */
+				if (ub_rw_cmd_retry(sc, lun, urq, cmd) == 0)
+					return;
+				scsi_status = SAM_STAT_CHECK_CONDITION;
+			} else {
+				scsi_status = 0;
+			}
 		}
-		scsi_status = 0;
 	} else {
 		if (blk_pc_request(rq)) {
 			/* UB_SENSE_SIZE is smaller than SCSI_SENSE_BUFFERSIZE */
@@ -802,13 +822,15 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 	urq->rq = NULL;
 
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, scsi_status);
+	ub_end_rq(rq, scsi_status, cmd->act_len, cmd->len);
 	blk_start_queue(lun->disk->queue);
 }
 
-static void ub_end_rq(struct request *rq, unsigned int scsi_status)
+static void ub_end_rq(struct request *rq, unsigned int scsi_status,
+    unsigned int act_len, unsigned int length)
 {
 	int error;
+	long rqlen;
 
 	if (scsi_status == 0) {
 		error = 0;
@@ -816,8 +838,13 @@ static void ub_end_rq(struct request *rq, unsigned int scsi_status)
 		error = -EIO;
 		rq->errors = scsi_status;
 	}
-	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
-		BUG();
+	rqlen = blk_rq_bytes(rq);  /* in case __blk_end_request recalculates */
+	if (__blk_end_request(rq, error, act_len)) {
+		printk(KERN_WARNING DRV_NAME ": "
+		    "__blk_end_request blew, cmd %s len %u rqlen %ld act %u\n",
+		    blk_pc_request(rq)? "pc": "fs",
+		    length, rqlen, act_len);
+	}
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,

If ub prints anything, I'd like to see the unedited dmesg.

-- Pete
