Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZEYHgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZEYHgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZEYHd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:33:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38688 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZEYHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:13 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/13] block: unlocked completion test patch
Date: Mon, 25 May 2009 09:31:08 +0200
Message-Id: <1243236668-3398-26-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-softirq.c       |   24 ++++++++++++++++++++----
 block/blk-timeout.c       |    2 +-
 block/blk.h               |    2 ++
 drivers/ata/libata-scsi.c |    1 +
 drivers/scsi/scsi.c       |    5 ++++-
 include/linux/blkdev.h    |    2 +-
 include/scsi/scsi_cmnd.h  |    1 +
 7 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index ee9c216..ebe3e1c 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -101,7 +101,7 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
-void __blk_complete_request(struct request *req)
+void __blk_complete_request(struct request *req, int locked)
 {
 	struct request_queue *q = req->q;
 	unsigned long flags;
@@ -133,8 +133,15 @@ do_local:
 		 * entries there, someone already raised the irq but it
 		 * hasn't run yet.
 		 */
-		if (list->next == &req->csd.list)
-			raise_softirq_irqoff(BLOCK_SOFTIRQ);
+		if (list->next == &req->csd.list) {
+			if (locked)
+				raise_softirq_irqoff(BLOCK_SOFTIRQ);
+			else {
+				local_irq_restore(flags);
+				q->softirq_done_fn(req);
+				return;
+			}
+		}
 	} else if (raise_blk_irq(ccpu, req))
 		goto do_local;
 
@@ -157,10 +164,19 @@ void blk_complete_request(struct request *req)
 	if (unlikely(blk_should_fake_timeout(req->q)))
 		return;
 	if (!blk_mark_rq_complete(req))
-		__blk_complete_request(req);
+		__blk_complete_request(req, 1);
 }
 EXPORT_SYMBOL(blk_complete_request);
 
+void blk_complete_request_nolock(struct request *req)
+{
+	if (unlikely(blk_should_fake_timeout(req->q)))
+		return;
+	if (!blk_mark_rq_complete(req))
+		__blk_complete_request(req, 0);
+}
+EXPORT_SYMBOL(blk_complete_request_nolock);
+
 static __init int blk_softirq_init(void)
 {
 	int i;
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1ec0d50..1744d87 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -84,7 +84,7 @@ static void blk_rq_timed_out(struct request *req)
 	ret = q->rq_timed_out_fn(req);
 	switch (ret) {
 	case BLK_EH_HANDLED:
-		__blk_complete_request(req);
+		__blk_complete_request(req, 0);
 		break;
 	case BLK_EH_RESET_TIMER:
 		blk_clear_rq_complete(req);
diff --git a/block/blk.h b/block/blk.h
index 79c85f7..41f2f70 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -43,6 +43,8 @@ static inline void blk_clear_rq_complete(struct request *rq)
 	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
+extern void __blk_complete_request(struct request *, int);
+
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 int blk_should_fake_timeout(struct request_queue *);
 ssize_t part_timeout_show(struct device *, struct device_attribute *, char *);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b0179c1..de185b0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2621,6 +2621,7 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		cmd->result = SAM_STAT_GOOD;
 	}
 
+	cmd->unlocked = 1;
 	qc->scsidone(cmd);
 	ata_qc_free(qc);
 }
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index da33b7a..d0d2afe 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -754,7 +754,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
-	blk_complete_request(cmd->request);
+	if (cmd->unlocked)
+		blk_complete_request_nolock(cmd->request);
+	else
+		blk_complete_request(cmd->request);
 }
 
 /* Move this to a header if it becomes more generally useful */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f2b6b92..9aac81e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,7 +865,7 @@ extern int blk_end_request_callback(struct request *rq, int error,
 				unsigned int nr_bytes,
 				int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
-extern void __blk_complete_request(struct request *);
+extern void blk_complete_request_nolock(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_abort_queue(struct request_queue *);
 extern void blk_update_request(struct request *rq, int error,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 649ad36..c0f06a3 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -75,6 +75,7 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	int unlocked;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
-- 
1.6.3.rc0.1.gf800

