Return-Path: <linux-kernel-owner+w=401wt.eu-S1762864AbYCGS0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864AbYCGS0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761576AbYCGSZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:25:52 -0500
Received: from nebensachen.de ([195.34.83.29]:40775 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761378AbYCGSZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:25:49 -0500
X-Hashcash: 1:20:080307:alan@lxorguk.ukuu.org.uk::bTCVg+WCTZLx4Q+x:00000000000000000000000000000000000004myv
X-Hashcash: 1:20:080307:linux-ide@vger.kernel.org::3NhUFxDyy63pPKZe:0000000000000000000000000000000000001PWq
X-Hashcash: 1:20:080307:linux-kernel@vger.kernel.org::TFWxxrnLG7UZ8aN8:0000000000000000000000000000000007nXY
X-Hashcash: 1:20:080307:jens.axboe@oracle.com::thxkf5wrof0+oOlO:000000000000000000000000000000000000000052lV
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/4] disk-protect: SCSI support for REQ_TYPE_LINUX_BLOCK
	requests
Message-ID: <20080307181750.9981.73383.stgit@denkblock.local>
References: <87skzgd1zk.fsf@denkblock.local> <20080226123946.75dbe3d2@core>
	<87mypl8p49.fsf@denkblock.local> <20080228111349.6831925c@core>
	<87bq5qfm2v.fsf@denkblock.local>
User-Agent: StGIT/0.12.1
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Mail-Copies-To: nobody
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
	<jens.axboe@oracle.com>
Date: Fri, 07 Mar 2008 19:25:48 +0100
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary infrastructure to the SCSI midlayer so it can handle
REQ_TYPE_LINUX_BLOCK requests. It is rather simple at this stage and may
have to be adapted as new REQ_LB_OP* commands are introduced.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/scsi/scsi_lib.c  |   56 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/sd.c        |    9 +++++++
 include/linux/blkdev.h   |    1 +
 include/scsi/scsi_host.h |   22 ++++++++++++++++++
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a9ac5b1..c25201b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1448,12 +1448,30 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	__scsi_done(cmd);
 }
 
+static void scsi_finish_lb_req(struct request *req)
+{
+	struct request_queue *q = req->q;
+	struct scsi_device *sdev = q->queuedata;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	end_that_request_last(req, 1);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+	put_device(&sdev->sdev_gendev);
+}
+
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
+	unsigned long wait_for;
 	int disposition;
 
+	if (blk_lb_request(rq)) {
+		scsi_finish_lb_req(rq);
+		return;
+	}
+
+	wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	disposition = scsi_decide_disposition(cmd);
@@ -1483,6 +1501,24 @@ static void scsi_softirq_done(struct request *rq)
 	}
 }
 
+static void scsi_exec_lb_req(struct request *req)
+{
+	struct scsi_device *sdev = req->q->queuedata;
+	struct scsi_host_template *shostt = sdev->host->hostt;
+	int rc;
+
+	if (shostt->lb_request_fn)
+		rc = shostt->lb_request_fn(req);
+	else
+		rc = FAILED;
+
+	if (rc == FAILED)
+		req->errors = -EIO;
+	else if (rc == QUEUED)
+		return;
+	blk_complete_request(req);
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1525,7 +1561,23 @@ static void scsi_request_fn(struct request_queue *q)
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
+			break;
+
+		/*
+		 * We do not account for linux blk req in the device
+		 * or host busy accounting because it is not necessarily
+		 * a scsi command that is sent to some object. The lower
+		 * level can translate it into a request/scsi_cmnd, if
+		 * necessary, and then queue that up using REQ_TYPE_BLOCK_PC.
+		 */
+		if (blk_lb_request(req)) {
+			blkdev_dequeue_request(req);
+			scsi_exec_lb_req(req);
+			continue;
+		}
+
+		if (!scsi_dev_queue_ready(q, sdev))
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cfd859a..1be9821 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -357,6 +357,15 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_type == REQ_TYPE_LINUX_BLOCK) {
+		get_device(&sdp->sdev_gendev);
+		/*
+		 * Since these requests don't need preparation, we'll
+		 * basically just accept them unconditionally at this
+		 * point.
+		 */
+		ret = BLKPREP_OK;
+		goto out;
 	} else if (rq->cmd_type != REQ_TYPE_FS) {
 		ret = BLKPREP_KILL;
 		goto out;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d18ee67..5955b57 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -521,6 +521,7 @@ enum {
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
+#define blk_lb_request(rq)	((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK)
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..c2946d0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -8,6 +8,7 @@
 #include <linux/mutex.h>
 
 struct request_queue;
+struct request;
 struct block_device;
 struct completion;
 struct module;
@@ -152,6 +153,27 @@ struct scsi_host_template {
 				  void (*done)(struct scsi_cmnd *));
 
 	/*
+	 * The lb_request_fn function is used to pass
+	 * REQ_TYPE_LINUX_BLOCK requests to the LLDD. The return value
+	 * FAILED indicates that the command opcode has not been known
+	 * by lb_request_fn. In contrast, the return value SUCCESS
+	 * means that the opcode has been recognised and the request
+	 * has been processed accordingly. Note, however, that SUCCESS
+	 * does not necessarily mean that all actions have been
+	 * performed successfully; errors are recorded in req->errors.
+	 * lb_request_fn can also return QUEUED in order to prevent
+	 * midlayer from enqueueng the request for completion.
+	 * Obviously, the LLDD must take care that the request will be
+	 * completed by means of blk_complete_request eventually.
+	 *
+	 * Status: OPTIONAL
+	 */
+	/* TODO: We might need to accept a return value NEEDS_RETRY some
+	 * time.
+	 */
+	int (* lb_request_fn)(struct request *req);
+
+	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
 	 * routine that is present that should work in most cases.  For those


