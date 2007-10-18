Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbXJRUYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbXJRUYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXJRUYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:24:35 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38915 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbXJRUYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:24:34 -0400
Date: Thu, 18 Oct 2007 16:24:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] another libata fix
Message-ID: <20071018202432.GA16160@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


NOTE:  This is appended to the previous libata fixes, in a linear
history.  If you pull this, and have not pulled yesterday's submission,
you will get -both-.  If you pulled yesterday's fixes, you will only get
the single changeset below.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pdc_adma.c   |    9 +-
 drivers/ata/sata_mv.c    |   26 +-
 drivers/ata/sata_sil24.c |   11 +-
 drivers/scsi/ipr.c       |   11 +-
 include/linux/libata.h   |   12 -
 11 files changed, 1567 insertions(+), 90 deletions(-)
 create mode 100644 drivers/ata/sata_fsl.c


[libata] kill ata_sg_is_last()

Short term, this works around a bug introduced by early sg-chaining
work.

Long term, removing this function eliminates a branch from a hot
path loop in each scatter/gather table build.  Also, as this code
demonstrates, we don't need to _track_ the end of the s/g list, as
long as we mark it in some way.  And doing so programatically is nice.
So its a useful cleanup, regardless of its short term effects.

Based conceptually on a quick patch by Jens Axboe.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>



diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 8d1b03d..199f7e1 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -318,7 +318,7 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	struct ata_port *ap = qc->ap;
 	struct adma_port_priv *pp = ap->private_data;
-	u8  *buf = pp->pkt;
+	u8  *buf = pp->pkt, *last_buf = NULL;
 	int i = (2 + buf[3]) * 8;
 	u8 pFLAGS = pORD | ((qc->tf.flags & ATA_TFLAG_WRITE) ? pDIRO : 0);
 
@@ -334,8 +334,7 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		*(__le32 *)(buf + i) = cpu_to_le32(len);
 		i += 4;
 
-		if (ata_sg_is_last(sg, qc))
-			pFLAGS |= pEND;
+		last_buf = &buf[i];
 		buf[i++] = pFLAGS;
 		buf[i++] = qc->dev->dma_mode & 0xf;
 		buf[i++] = 0;	/* pPKLW */
@@ -348,6 +347,10 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 		VPRINTK("PRD[%u] = (0x%lX, 0x%X)\n", i/4,
 					(unsigned long)addr, len);
 	}
+
+	if (likely(last_buf))
+		*last_buf |= pEND;
+
 	return i;
 }
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 4df8311..7f1b13e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -421,7 +421,6 @@ static void mv_error_handler(struct ata_port *ap);
 static void mv_post_int_cmd(struct ata_queued_cmd *qc);
 static void mv_eh_freeze(struct ata_port *ap);
 static void mv_eh_thaw(struct ata_port *ap);
-static int mv_slave_config(struct scsi_device *sdev);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -459,7 +458,7 @@ static struct scsi_host_template mv5_sht = {
 	.use_clustering		= 1,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= MV_DMA_BOUNDARY,
-	.slave_configure	= mv_slave_config,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -477,7 +476,7 @@ static struct scsi_host_template mv6_sht = {
 	.use_clustering		= 1,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= MV_DMA_BOUNDARY,
-	.slave_configure	= mv_slave_config,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -756,17 +755,6 @@ static void mv_irq_clear(struct ata_port *ap)
 {
 }
 
-static int mv_slave_config(struct scsi_device *sdev)
-{
-	int rc = ata_scsi_slave_config(sdev);
-	if (rc)
-		return rc;
-
-	blk_queue_max_phys_segments(sdev->request_queue, MV_MAX_SG_CT / 2);
-
-	return 0;	/* scsi layer doesn't check return value, sigh */
-}
-
 static void mv_set_edma_ptrs(void __iomem *port_mmio,
 			     struct mv_host_priv *hpriv,
 			     struct mv_port_priv *pp)
@@ -1138,7 +1126,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct mv_port_priv *pp = qc->ap->private_data;
 	struct scatterlist *sg;
-	struct mv_sg *mv_sg;
+	struct mv_sg *mv_sg, *last_sg = NULL;
 
 	mv_sg = pp->sg_tbl;
 	ata_for_each_sg(sg, qc) {
@@ -1159,13 +1147,13 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 			sg_len -= len;
 			addr += len;
 
-			if (!sg_len && ata_sg_is_last(sg, qc))
-				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
-
+			last_sg = mv_sg;
 			mv_sg++;
 		}
-
 	}
+
+	if (likely(last_sg))
+		last_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
 }
 
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index b061927..26ebffc 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -796,16 +796,19 @@ static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 				 struct sil24_sge *sge)
 {
 	struct scatterlist *sg;
+	struct sil24_sge *last_sge = NULL;
 
 	ata_for_each_sg(sg, qc) {
 		sge->addr = cpu_to_le64(sg_dma_address(sg));
 		sge->cnt = cpu_to_le32(sg_dma_len(sg));
-		if (ata_sg_is_last(sg, qc))
-			sge->flags = cpu_to_le32(SGE_TRM);
-		else
-			sge->flags = 0;
+		sge->flags = 0;
+
+		last_sge = sge;
 		sge++;
 	}
+
+	if (likely(last_sge))
+		last_sge->flags = cpu_to_le32(SGE_TRM);
 }
 
 static int sil24_qc_defer(struct ata_queued_cmd *qc)
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b41dfb5..c316a0b 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5134,6 +5134,7 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	u32 ioadl_flags = 0;
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
+	struct ipr_ioadl_desc *last_ioadl = NULL;
 	int len = qc->nbytes + qc->pad_len;
 	struct scatterlist *sg;
 
@@ -5156,11 +5157,13 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	ata_for_each_sg(sg, qc) {
 		ioadl->flags_and_data_len = cpu_to_be32(ioadl_flags | sg_dma_len(sg));
 		ioadl->address = cpu_to_be32(sg_dma_address(sg));
-		if (ata_sg_is_last(sg, qc))
-			ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
-		else
-			ioadl++;
+
+		last_ioadl = ioadl;
+		ioadl++;
 	}
+
+	if (likely(last_ioadl))
+		last_ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
 }
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 377e6d4..bc3b6fc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1037,18 +1037,6 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 /*
  * qc helpers
  */
-static inline int
-ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
-{
-	if (sg == &qc->pad_sgent)
-		return 1;
-	if (qc->pad_len)
-		return 0;
-	if (qc->n_iter == qc->n_elem)
-		return 1;
-	return 0;
-}
-
 static inline struct scatterlist *
 ata_qc_first_sg(struct ata_queued_cmd *qc)
 {
