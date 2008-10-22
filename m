Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYJVHlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYJVHlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYJVHke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:40:34 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57905 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbYJVHka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:40:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jeff@garzik.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/2] libata: switch to using block layer tagging support
Date: Wed, 22 Oct 2008 09:40:43 +0200
Message-Id: <1224661243-7929-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.0.2.588.g3102
In-Reply-To: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libata currently has a pretty dumb ATA_MAX_QUEUE loop for finding
a free tag to use. Instead of fixing that up, convert libata to
using block layer tagging - gets rid of code in libata, and is also
much faster.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-core.c |   66 ++++----------------------------------------
 drivers/ata/libata-scsi.c |   10 +++++-
 drivers/ata/libata.h      |   19 +++++++++++-
 include/linux/libata.h    |    1 -
 4 files changed, 31 insertions(+), 65 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c3c53e7..3d5da01 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1713,8 +1713,6 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	else
 		tag = 0;
 
-	if (test_and_set_bit(tag, &ap->qc_allocated))
-		BUG();
 	qc = __ata_qc_from_tag(ap, tag);
 
 	qc->tag = tag;
@@ -4553,37 +4551,6 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 }
 
 /**
- *	ata_qc_new - Request an available ATA command, for queueing
- *	@ap: Port associated with device @dev
- *	@dev: Device from whom we request an available command structure
- *
- *	LOCKING:
- *	None.
- */
-
-static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
-{
-	struct ata_queued_cmd *qc = NULL;
-	unsigned int i;
-
-	/* no command while frozen */
-	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
-		return NULL;
-
-	/* the last tag is reserved for internal command. */
-	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
-		if (!test_and_set_bit(i, &ap->qc_allocated)) {
-			qc = __ata_qc_from_tag(ap, i);
-			break;
-		}
-
-	if (qc)
-		qc->tag = i;
-
-	return qc;
-}
-
-/**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
  *
@@ -4591,16 +4558,20 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
  *	None.
  */
 
-struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
+struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
 {
 	struct ata_port *ap = dev->link->ap;
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new(ap);
+	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
+		return NULL;
+
+	qc = __ata_qc_from_tag(ap, tag);
 	if (qc) {
 		qc->scsicmd = NULL;
 		qc->ap = ap;
 		qc->dev = dev;
+		qc->tag = tag;
 
 		ata_qc_reinit(qc);
 	}
@@ -4608,31 +4579,6 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
 	return qc;
 }
 
-/**
- *	ata_qc_free - free unused ata_queued_cmd
- *	@qc: Command to complete
- *
- *	Designed to free unused ata_queued_cmd object
- *	in case something prevents using it.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_qc_free(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned int tag;
-
-	WARN_ON(qc == NULL);	/* ata_qc_from_tag _might_ return NULL */
-
-	qc->flags = 0;
-	tag = qc->tag;
-	if (likely(ata_tag_valid(tag))) {
-		qc->tag = ATA_TAG_POISON;
-		clear_bit(tag, &ap->qc_allocated);
-	}
-}
-
 void __ata_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5d312dc..d5b9b72 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -708,7 +708,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new_init(dev);
+	qc = ata_qc_new_init(dev, cmd->request->tag);
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
@@ -1103,7 +1103,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
 		depth = min(ATA_MAX_QUEUE - 1, depth);
-		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
+		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
+		scsi_activate_tcq(sdev, depth);
 	}
 
 	return 0;
@@ -1943,6 +1944,11 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		hdr[1] |= (1 << 7);
 
 	memcpy(rbuf, hdr, sizeof(hdr));
+
+	/* if ncq, set tags supported */
+	if (ata_id_has_ncq(args->id))
+		rbuf[7] |= (1 << 1);
+
 	memcpy(&rbuf[8], "ATA     ", 8);
 	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
 	ata_id_string(args->id, &rbuf[32], ATA_ID_FW_REV, 4);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index fe2839e..d3831d3 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -74,7 +74,7 @@ extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
 extern void ata_force_cbl(struct ata_port *ap);
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
 extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
-extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
+extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
 			   unsigned int tag);
@@ -103,7 +103,6 @@ extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
-extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
 extern int atapi_check_dma(struct ata_queued_cmd *qc);
@@ -119,6 +118,22 @@ extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
 extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
 
+/**
+ *	ata_qc_free - free unused ata_queued_cmd
+ *	@qc: Command to complete
+ *
+ *	Designed to free unused ata_queued_cmd object
+ *	in case something prevents using it.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+static inline void ata_qc_free(struct ata_queued_cmd *qc)
+{
+	qc->flags = 0;
+	qc->tag = ATA_TAG_POISON;
+}
+
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
 extern void ata_acpi_associate_sata_port(struct ata_port *ap);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 947cf84..53ad28f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -692,7 +692,6 @@ struct ata_port {
 	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
 
 	struct ata_queued_cmd	qcmd[ATA_MAX_QUEUE];
-	unsigned long		qc_allocated;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
-- 
1.6.0.2.588.g3102

