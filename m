Return-Path: <linux-kernel-owner+w=401wt.eu-S932193AbXGXBIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbXGXBIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbXGXBHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:07:55 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33704 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439AbXGXBHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:07:54 -0400
Date: Mon, 23 Jul 2007 21:07:53 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, mlord@pobox.com
Subject: [PATCH] sata_mv: non-working NCQ support
Message-ID: <20070724010753.GA13866@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds NCQ support to the sata_mv driver.  Currently it does
not work:  FPDMA commands time out, and eventually EH falls back to
non-NCQ, which works.

My attention has turned to other things for moment.  Anybody interested
in sata_mv NCQ is encouraged to pick up where this left off, as this
patch, buggy or not, includes the changes that will be required to
enable command queueing in sata_mv.


commit 6bef64243c68bf637b5594a0a363d8105efedfa6
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Jul 11 18:56:46 2007 -0400

    [libata mv-ncq] sata_mv: Add NCQ support
    
    Currently not working.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/sata_mv.c |   70 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 8ec5208..228f71a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -29,8 +29,6 @@
   I distinctly remember a couple workarounds (one related to PCI-X)
   are still needed.
 
-  4) Add NCQ support (easy to intermediate, once new-EH support appears)
-
   5) Investigate problems with PCI Message Signalled Interrupts (MSI).
 
   6) Add port multiplier support (intermediate)
@@ -417,6 +415,7 @@ static void mv_error_handler(struct ata_port *ap);
 static void mv_post_int_cmd(struct ata_queued_cmd *qc);
 static void mv_eh_freeze(struct ata_port *ap);
 static void mv_eh_thaw(struct ata_port *ap);
+static void mv6_dev_config(struct ata_device *dev);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -440,6 +439,8 @@ static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio);
 static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio);
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
+static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
+			void __iomem *port_mmio);
 
 static struct scsi_host_template mv5_sht = {
 	.module			= THIS_MODULE,
@@ -464,7 +465,8 @@ static struct scsi_host_template mv6_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.can_queue		= ATA_DEF_QUEUE,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
+	.can_queue		= MV_MAX_Q_DEPTH - 1,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= MV_MAX_SG_CT,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
@@ -510,6 +512,7 @@ static const struct ata_port_operations mv5_ops = {
 
 static const struct ata_port_operations mv6_ops = {
 	.port_disable		= ata_port_disable,
+	.dev_config		= mv6_dev_config,
 
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -590,26 +593,29 @@ static const struct ata_port_info mv_port_info[] = {
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  MV_FLAG_DUAL_HC,
+				  MV_FLAG_DUAL_HC | ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
@@ -808,18 +814,23 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_start_dma(void __iomem *base, struct mv_host_priv *hpriv,
+static void mv_start_dma(struct ata_port *ap, void __iomem *base,
 			 struct mv_port_priv *pp)
 {
 	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
+		struct mv_host_priv *hpriv = ap->host->private_data;
+
 		/* clear EDMA event indicators, if any */
 		writelfl(0, base + EDMA_ERR_IRQ_CAUSE_OFS);
 
+		mv_edma_cfg(ap, hpriv, base);
+
 		mv_set_edma_ptrs(base, hpriv, pp);
 
 		writelfl(EDMA_EN, base + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
 	}
+
 	WARN_ON(!(EDMA_EN & readl(base + EDMA_CMD_OFS)));
 }
 
@@ -996,9 +1007,20 @@ static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 		return -EINVAL;
 }
 
+static void mv6_dev_config(struct ata_device *adev)
+{
+	/*
+	 * We don't have hob_nsect when doing NCQ commands, on Gen-II.
+	 * See mv_qc_prep() for more info.
+	 */
+	if (adev->flags & ATA_DFLAG_NCQ)
+		adev->max_sectors = ATA_MAX_SECTORS;
+}
+
 static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
 			void __iomem *port_mmio)
 {
+	struct ata_device *adev = &ap->device[0];	/* hardcode dev 0 */
 	u32 cfg = readl(port_mmio + EDMA_CFG_OFS);
 
 	/* set up non-NCQ EDMA configuration */
@@ -1013,6 +1035,14 @@ static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
 		cfg &= ~0x1f;		/* clear queue depth */
 		cfg |= EDMA_CFG_RD_BRST_EXT | EDMA_CFG_WR_BUFF_LEN;
 		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
+
+		if (adev->flags & ATA_DFLAG_NCQ) {
+			unsigned int dev_depth =
+				ata_id_queue_depth(adev->id) - 1;
+
+			cfg |= EDMA_CFG_NCQ;
+			cfg |= (dev_depth & 0x1f);
+		}
 	}
 
 	else if (IS_GEN_IIE(hpriv)) {
@@ -1023,6 +1053,9 @@ static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
 		cfg |= (1 << 17);	/* enab cut-through (dis stor&forwrd) */
 		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
 		cfg &= ~(EDMA_CFG_NCQ);	/* clear NCQ */
+
+		if (adev->flags & ATA_DFLAG_NCQ)
+			cfg |= EDMA_CFG_NCQ;
 	}
 
 	writelfl(cfg, port_mmio + EDMA_CFG_OFS);
@@ -1178,7 +1211,8 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	u16 flags = 0;
 	unsigned in_index;
 
- 	if (qc->tf.protocol != ATA_PROT_DMA)
+ 	if ((qc->tf.protocol != ATA_PROT_DMA) &&
+	    (qc->tf.protocol != ATA_PROT_NCQ))
 		return;
 
 	/* Fill in command request block
@@ -1215,13 +1249,11 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	case ATA_CMD_WRITE_FUA_EXT:
 		mv_crqb_pack_cmd(cw++, tf->hob_nsect, ATA_REG_NSECT, 0);
 		break;
-#ifdef LIBATA_NCQ		/* FIXME: remove this line when NCQ added */
 	case ATA_CMD_FPDMA_READ:
 	case ATA_CMD_FPDMA_WRITE:
 		mv_crqb_pack_cmd(cw++, tf->hob_feature, ATA_REG_FEATURE, 0);
 		mv_crqb_pack_cmd(cw++, tf->feature, ATA_REG_FEATURE, 0);
 		break;
-#endif				/* FIXME: remove this line when NCQ added */
 	default:
 		/* The only other commands EDMA supports in non-queued and
 		 * non-NCQ mode are: [RW] STREAM DMA and W DMA FUA EXT, none
@@ -1270,7 +1302,8 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	unsigned in_index;
 	u32 flags = 0;
 
- 	if (qc->tf.protocol != ATA_PROT_DMA)
+ 	if ((qc->tf.protocol != ATA_PROT_DMA) &&
+	    (qc->tf.protocol != ATA_PROT_NCQ))
 		return;
 
 	/* Fill in Gen IIE command request block
@@ -1282,6 +1315,7 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	flags |= qc->tag << CRQB_TAG_SHIFT;
 	flags |= qc->tag << CRQB_IOID_SHIFT;	/* "I/O Id" is -really-
 						   what we use as our tag */
+	flags |= qc->tag << CRQB_HOSTQ_SHIFT;
 
 	/* get current queue index from software */
 	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
@@ -1335,10 +1369,10 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp = ap->private_data;
-	struct mv_host_priv *hpriv = ap->host->private_data;
 	u32 in_index;
 
-	if (qc->tf.protocol != ATA_PROT_DMA) {
+ 	if ((qc->tf.protocol != ATA_PROT_DMA) &&
+	    (qc->tf.protocol != ATA_PROT_NCQ)) {
 		/* We're about to send a non-EDMA capable command to the
 		 * port.  Turn off EDMA so there won't be problems accessing
 		 * shadow block, etc registers.
@@ -1347,13 +1381,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		return ata_qc_issue_prot(qc);
 	}
 
-	mv_start_dma(port_mmio, hpriv, pp);
-
-	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
-
-	/* until we do queuing, the queue should be empty at this point */
-	WARN_ON(in_index != ((readl(port_mmio + EDMA_REQ_Q_OUT_PTR_OFS)
-		>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK));
+	mv_start_dma(ap, port_mmio, pp);
 
 	pp->req_idx++;
 
