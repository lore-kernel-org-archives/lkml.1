Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbYDDTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbYDDTxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYDDTxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:53:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbYDDTxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:53:02 -0400
Date: Fri, 4 Apr 2008 12:45:44 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, bharrosh@panasas.com,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com, jens.axboe@oracle.com, m-ikeda@ds.jp.nec.com,
       cw@f00f.org, zaitcev@redhat.com
Subject: Re: kernel BUG at drivers/block/ub.c:820!
Message-Id: <20080404124544.eac62bec.zaitcev@redhat.com>
In-Reply-To: <20080404.102902.74754100.k-ueda@ct.jp.nec.com>
References: <20080403093042.f20e38a2.zaitcev@redhat.com>
	<47F515A6.4040505@panasas.com>
	<20080403213010.94045431.akpm@linux-foundation.org>
	<20080404.102902.74754100.k-ueda@ct.jp.nec.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove BUG() after __blk_end_request and fix the condition causing it.

When __blk_end_request returns nonzero, it means that the request was
not completely processed and some BIOs are still attached. Since we
have dequeued it by that time, it means leaking requests and hanging
processes, which is why BUG() was in there. In ub this happens if
a packet request ends normally, but with residue (e.g. when scsi_id
issues INQUIRY).

The fix is to make sure that arguments passed to __blk_end_request
are correct: the full request length and not just transferred length.
The transferred length is indicated to applications by adjusting
rq->data_len with old, unchanged code outside of this patch.

Signed-Off-By: Pete Zaitcev <zaitcev@redhat.com>

---

> Date: Fri, 04 Apr 2008 10:29:02 -0500 (EST)
> From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

> The new patch you posted seems not having your sign-off.
> Could you follow it so that the new patch can be included instead of
> the old patch?

Done. Sorry for the delay, I was really sick yesterday and unable
to sit at the computer.

diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index c452e2d..12961f7 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -8,6 +8,7 @@
  * and is not licensed separately. See file COPYING for details.
  *
  * TODO (sorted by decreasing priority)
+ *  -- Return sense now that rq allows it (we always auto-sense anyway).
  *  -- set readonly flag for CDs, set removable flag for CF readers
  *  -- do inquiry and verify we got a disk and not a tape (for LUN mismatch)
  *  -- verify the 13 conditions and do bulk resets
@@ -359,7 +361,8 @@ static void ub_cmd_build_block(struct ub_dev *sc, struct ub_lun *lun,
 static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_scsi_cmd *cmd, struct ub_request *urq);
 static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
-static void ub_end_rq(struct request *rq, unsigned int status);
+static void ub_end_rq(struct request *rq, unsigned int status,
+    unsigned int cmd_len);
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_request *urq, struct ub_scsi_cmd *cmd);
 static int ub_submit_scsi(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
@@ -642,13 +645,13 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 
 	if (atomic_read(&sc->poison)) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, DID_NO_CONNECT << 16);
+		ub_end_rq(rq, DID_NO_CONNECT << 16, blk_rq_bytes(rq));
 		return 0;
 	}
 
 	if (lun->changed && !blk_pc_request(rq)) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION);
+		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION, blk_rq_bytes(rq));
 		return 0;
 	}
 
@@ -701,7 +704,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 
 drop:
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, DID_ERROR << 16);
+	ub_end_rq(rq, DID_ERROR << 16, blk_rq_bytes(rq));
 	return 0;
 }
 
@@ -770,6 +773,7 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 	struct ub_request *urq = cmd->back;
 	struct request *rq;
 	unsigned int scsi_status;
+	unsigned int cmd_len;
 
 	rq = urq->rq;
 
@@ -779,8 +783,18 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 				rq->data_len = 0;
 			else
 				rq->data_len -= cmd->act_len;
+			scsi_status = 0;
+		} else {
+			if (cmd->act_len != cmd->len) {
+				if ((cmd->key == MEDIUM_ERROR ||
+				     cmd->key == UNIT_ATTENTION) &&
+				    ub_rw_cmd_retry(sc, lun, urq, cmd) == 0)
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
@@ -801,14 +815,17 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 
 	urq->rq = NULL;
 
+	cmd_len = cmd->len;
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, scsi_status);
+	ub_end_rq(rq, scsi_status, cmd_len);
 	blk_start_queue(lun->disk->queue);
 }
 
-static void ub_end_rq(struct request *rq, unsigned int scsi_status)
+static void ub_end_rq(struct request *rq, unsigned int scsi_status,
+    unsigned int cmd_len)
 {
 	int error;
+	long rqlen;
 
 	if (scsi_status == 0) {
 		error = 0;
@@ -816,8 +833,12 @@ static void ub_end_rq(struct request *rq, unsigned int scsi_status)
 		error = -EIO;
 		rq->errors = scsi_status;
 	}
-	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
-		BUG();
+	rqlen = blk_rq_bytes(rq);    /* Oddly enough, this is the residue. */
+	if (__blk_end_request(rq, error, cmd_len)) {
+		printk(KERN_WARNING DRV_NAME
+		    ": __blk_end_request blew, %s-cmd total %u rqlen %ld\n",
+		    blk_pc_request(rq)? "pc": "fs", cmd_len, rqlen);
+	}
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,

