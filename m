Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYKJFsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYKJFsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 00:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYKJFsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 00:48:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:44126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYKJFsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 00:48:39 -0500
Message-ID: <4917CB25.7050909@kernel.org>
Date: Mon, 10 Nov 2008 14:48:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: revert convert-to-block-tagging patches
References: <4917C449.2080504@kernel.org> <4917C6DD.4010500@kernel.org>
In-Reply-To: <4917C6DD.4010500@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Nov 2008 05:48:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts the following three commits which convert libata to
use block layer tagging.

 43a49cbdf31e812c0d8f553d433b09b421f5d52c
 e013e13bf605b9e6b702adffbe2853cfc60e7806
 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e

Although using block layer tagging is the right direction, due to the
tight coupling among tag number, data structure allocation and
hardware command slot allocation, libata doesn't work correctly with
the current conversion.

The biggest problem is guaranteeing that tag 0 is always used for
non-NCQ commands.  Due to the way blk-tag is implemented and how SCSI
starts and finishes requests, such guarantee can't be made.  I'm not
sure whether this would actually break any low level driver but it
doesn't look like a good idea to break such assumption given the
frailty of ATA controllers.

So, for the time being, keep using the old dumb in-libata qc
allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axobe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
---
 drivers/ata/libata-core.c |   66 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata-scsi.c |   23 +---------------
 drivers/ata/libata.h      |   19 +------------
 include/linux/libata.h    |    1 
 4 files changed, 65 insertions(+), 44 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 622350d..0cd3ad4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1712,6 +1712,8 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	else
 		tag = 0;
 
+	if (test_and_set_bit(tag, &ap->qc_allocated))
+		BUG();
 	qc = __ata_qc_from_tag(ap, tag);
 
 	qc->tag = tag;
@@ -4563,6 +4565,37 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 }
 
 /**
+ *	ata_qc_new - Request an available ATA command, for queueing
+ *	@ap: Port associated with device @dev
+ *	@dev: Device from whom we request an available command structure
+ *
+ *	LOCKING:
+ *	None.
+ */
+
+static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc = NULL;
+	unsigned int i;
+
+	/* no command while frozen */
+	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
+		return NULL;
+
+	/* the last tag is reserved for internal command. */
+	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
+		if (!test_and_set_bit(i, &ap->qc_allocated)) {
+			qc = __ata_qc_from_tag(ap, i);
+			break;
+		}
+
+	if (qc)
+		qc->tag = i;
+
+	return qc;
+}
+
+/**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
  *	@tag: command tag
@@ -4571,20 +4604,16 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
  *	None.
  */
 
-struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
+struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
 	struct ata_queued_cmd *qc;
 
-	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
-		return NULL;
-
-	qc = __ata_qc_from_tag(ap, tag);
+	qc = ata_qc_new(ap);
 	if (qc) {
 		qc->scsicmd = NULL;
 		qc->ap = ap;
 		qc->dev = dev;
-		qc->tag = tag;
 
 		ata_qc_reinit(qc);
 	}
@@ -4592,6 +4621,31 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag)
 	return qc;
 }
 
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
+void ata_qc_free(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	unsigned int tag;
+
+	WARN_ON(qc == NULL);	/* ata_qc_from_tag _might_ return NULL */
+
+	qc->flags = 0;
+	tag = qc->tag;
+	if (likely(ata_tag_valid(tag))) {
+		qc->tag = ATA_TAG_POISON;
+		clear_bit(tag, &ap->qc_allocated);
+	}
+}
+
 void __ata_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3fa75ea..47c7afc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -709,11 +709,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 {
 	struct ata_queued_cmd *qc;
 
-	if (cmd->request->tag != -1)
-		qc = ata_qc_new_init(dev, cmd->request->tag);
-	else
-		qc = ata_qc_new_init(dev, 0);
-
+	qc = ata_qc_new_init(dev);
 	if (qc) {
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
@@ -1108,17 +1104,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
 		depth = min(ATA_MAX_QUEUE - 1, depth);
-
-		/*
-		 * If this device is behind a port multiplier, we have
-		 * to share the tag map between all devices on that PMP.
-		 * Set up the shared tag map here and we get automatic.
-		 */
-		if (dev->link->ap->pmp_link)
-			scsi_init_shared_tag_map(sdev->host, ATA_MAX_QUEUE - 1);
-
-		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
-		scsi_activate_tcq(sdev, depth);
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
 
 	return 0;
@@ -1958,11 +1944,6 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		hdr[1] |= (1 << 7);
 
 	memcpy(rbuf, hdr, sizeof(hdr));
-
-	/* if ncq, set tags supported */
-	if (ata_id_has_ncq(args->id))
-		rbuf[7] |= (1 << 1);
-
 	memcpy(&rbuf[8], "ATA     ", 8);
 	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
 	ata_id_string(args->id, &rbuf[32], ATA_ID_FW_REV, 4);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index d3831d3..fe2839e 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -74,7 +74,7 @@ extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
 extern void ata_force_cbl(struct ata_port *ap);
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
 extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
-extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev, int tag);
+extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
 			   unsigned int tag);
@@ -103,6 +103,7 @@ extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
+extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
 extern int atapi_check_dma(struct ata_queued_cmd *qc);
@@ -118,22 +119,6 @@ extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
 extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
 
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
-static inline void ata_qc_free(struct ata_queued_cmd *qc)
-{
-	qc->flags = 0;
-	qc->tag = ATA_TAG_POISON;
-}
-
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
 extern void ata_acpi_associate_sata_port(struct ata_port *ap);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c7665a4..59b0f1c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -698,6 +698,7 @@ struct ata_port {
 	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
 
 	struct ata_queued_cmd	qcmd[ATA_MAX_QUEUE];
+	unsigned long		qc_allocated;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
