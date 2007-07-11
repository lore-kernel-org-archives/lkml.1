Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbXGKHmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbXGKHmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXGKHmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:42:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36953 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXGKHmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:42:19 -0400
Date: Wed, 11 Jul 2007 03:42:16 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, dave@thedillows.org, dean@arctic.org
Subject: [RFT][PATCH v6] sata_mv: convert to new EH
Message-ID: <20070711074216.GA7393@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is diff'd against virgin 2.6.22 kernel, and does not require
any other patches (and indeed no other sata_mv patches should be applied
alongside this one).

Thanks to dean's feedback (and similar feedback from Dave), I think I
killed two key sata_mv bugs, either of which could cause the WARNING
spew being reported.  In sum, sata_mv was not doing a good job of
managing the software-managed request and response queue pointers.

Testing feedback with 2.6.22 + this patch would be appreciated.  It
works on my 6041 (Gen-II) and 5081 (Gen-I).  Haven't yet tried a Gen-IIE
chip (6042/7042-compatible).

 drivers/ata/sata_mv.c |  645 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 428 insertions(+), 217 deletions(-)

diff -ur linux-2.6.22/drivers/ata/sata_mv.c linux-2.6.22-mv/drivers/ata/sata_mv.c
--- linux-2.6.22/drivers/ata/sata_mv.c	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22-mv/drivers/ata/sata_mv.c	2007-07-11 03:26:55.000000000 -0400
@@ -79,7 +79,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"0.81"
+#define DRV_VERSION	"0.81hack6"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
@@ -236,8 +236,10 @@
 	EDMA_ERR_DEV_DCON	= (1 << 3),
 	EDMA_ERR_DEV_CON	= (1 << 4),
 	EDMA_ERR_SERR		= (1 << 5),
-	EDMA_ERR_SELF_DIS	= (1 << 7),
+	EDMA_ERR_SELF_DIS	= (1 << 7),	/* Gen II/IIE self-disable */
+	EDMA_ERR_SELF_DIS_5	= (1 << 8),	/* Gen I self-disable */
 	EDMA_ERR_BIST_ASYNC	= (1 << 8),
+	EDMA_ERR_TRANS_IRQ_7	= (1 << 8),	/* Gen IIE transprt layer irq */
 	EDMA_ERR_CRBQ_PAR	= (1 << 9),
 	EDMA_ERR_CRPB_PAR	= (1 << 10),
 	EDMA_ERR_INTRL_PAR	= (1 << 11),
@@ -248,13 +250,33 @@
 	EDMA_ERR_LNK_CTRL_TX	= (0x1f << 21),
 	EDMA_ERR_LNK_DATA_TX	= (0x1f << 26),
 	EDMA_ERR_TRANS_PROTO	= (1 << 31),
-	EDMA_ERR_FATAL		= (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
-				   EDMA_ERR_DEV_DCON | EDMA_ERR_CRBQ_PAR |
-				   EDMA_ERR_CRPB_PAR | EDMA_ERR_INTRL_PAR |
-				   EDMA_ERR_IORDY | EDMA_ERR_LNK_CTRL_RX_2 |
-				   EDMA_ERR_LNK_DATA_RX |
-				   EDMA_ERR_LNK_DATA_TX |
-				   EDMA_ERR_TRANS_PROTO),
+	EDMA_ERR_OVERRUN_5	= (1 << 5),
+	EDMA_ERR_UNDERRUN_5	= (1 << 6),
+	EDMA_EH_FREEZE		= EDMA_ERR_D_PAR |
+				  EDMA_ERR_PRD_PAR |
+				  EDMA_ERR_DEV_DCON |
+				  EDMA_ERR_DEV_CON |
+				  EDMA_ERR_SERR |
+				  EDMA_ERR_SELF_DIS |
+				  EDMA_ERR_CRBQ_PAR |
+				  EDMA_ERR_CRPB_PAR |
+				  EDMA_ERR_INTRL_PAR |
+				  EDMA_ERR_IORDY |
+				  EDMA_ERR_LNK_CTRL_RX_2 |
+				  EDMA_ERR_LNK_DATA_RX |
+				  EDMA_ERR_LNK_DATA_TX |
+				  EDMA_ERR_TRANS_PROTO,
+	EDMA_EH_FREEZE_5	= EDMA_ERR_D_PAR |
+				  EDMA_ERR_PRD_PAR |
+				  EDMA_ERR_DEV_DCON |
+				  EDMA_ERR_DEV_CON |
+				  EDMA_ERR_OVERRUN_5 |
+				  EDMA_ERR_UNDERRUN_5 |
+				  EDMA_ERR_SELF_DIS_5 |
+				  EDMA_ERR_CRBQ_PAR |
+				  EDMA_ERR_CRPB_PAR |
+				  EDMA_ERR_INTRL_PAR |
+				  EDMA_ERR_IORDY,
 
 	EDMA_REQ_Q_BASE_HI_OFS	= 0x10,
 	EDMA_REQ_Q_IN_PTR_OFS	= 0x14,		/* also contains BASE_LO */
@@ -288,6 +310,7 @@
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),
 	MV_PP_FLAG_EDMA_DS_ACT	= (1 << 1),
+	MV_PP_FLAG_HAD_A_RESET	= (1 << 2),
 };
 
 #define IS_50XX(hpriv) ((hpriv)->hp_flags & MV_HP_50XX)
@@ -352,6 +375,10 @@
 	dma_addr_t		crpb_dma;
 	struct mv_sg		*sg_tbl;
 	dma_addr_t		sg_tbl_dma;
+
+	unsigned int		req_idx;
+	unsigned int		resp_idx;
+
 	u32			pp_flags;
 };
 
@@ -384,14 +411,14 @@
 static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
 static u32 mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
 static void mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
-static void mv_phy_reset(struct ata_port *ap);
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
 static void mv_qc_prep(struct ata_queued_cmd *qc);
 static void mv_qc_prep_iie(struct ata_queued_cmd *qc);
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc);
-static void mv_eng_timeout(struct ata_port *ap);
+static void mv_error_handler(struct ata_port *ap);
+static void mv_eh_freeze(struct ata_port *ap);
+static void mv_eh_thaw(struct ata_port *ap);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -415,7 +442,6 @@
 static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio);
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
-static void mv_stop_and_reset(struct ata_port *ap);
 
 static struct scsi_host_template mv_sht = {
 	.module			= THIS_MODULE,
@@ -444,19 +470,20 @@
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
 	.cable_detect		= ata_cable_sata,
 
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
 
@@ -473,19 +500,20 @@
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
 	.cable_detect		= ata_cable_sata,
 
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -502,19 +530,20 @@
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
 	.cable_detect		= ata_cable_sata,
 
 	.qc_prep		= mv_qc_prep_iie,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -526,44 +555,44 @@
 	{  /* chip_504x */
 		.flags		= MV_COMMON_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
 		.flags		= (MV_COMMON_FLAGS | MV_FLAG_DUAL_HC),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
 		.flags		= (MV_COMMON_FLAGS | MV_FLAG_DUAL_HC),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS |
 				   MV_FLAG_DUAL_HC),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
 		.flags		= (MV_COMMON_FLAGS | MV_6XXX_FLAGS),
 		.pio_mask	= 0x1f,	/* pio0-4 */
-		.udma_mask	= 0x7f,	/* udma0-6 */
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 };
@@ -709,6 +738,46 @@
 {
 }
 
+static void mv_set_edma_ptrs(void __iomem *port_mmio,
+			     struct mv_host_priv *hpriv,
+			     struct mv_port_priv *pp)
+{
+	u32 index;
+
+	/*
+	 * initialize request queue
+	 */
+	index = (pp->req_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_REQ_Q_PTR_SHIFT;
+
+	WARN_ON(pp->crqb_dma & 0x3ff);
+	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
+	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | index,
+		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+
+	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
+		writelfl((pp->crqb_dma & 0xffffffff) | index,
+			 port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
+	else
+		writelfl(index, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
+
+	/*
+	 * initialize response queue
+	 */
+	index = (pp->resp_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_RSP_Q_PTR_SHIFT;
+
+	WARN_ON(pp->crpb_dma & 0xff);
+	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
+
+	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
+		writelfl((pp->crpb_dma & 0xffffffff) | index,
+			 port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
+	else
+		writelfl(index, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
+
+	writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) | index,
+		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+}
+
 /**
  *      mv_start_dma - Enable eDMA engine
  *      @base: port base address
@@ -720,9 +789,12 @@
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_start_dma(void __iomem *base, struct mv_port_priv *pp)
+static void mv_start_dma(void __iomem *base, struct mv_host_priv *hpriv,
+			 struct mv_port_priv *pp)
 {
-	if (!(MV_PP_FLAG_EDMA_EN & pp->pp_flags)) {
+	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
+		mv_set_edma_ptrs(base, hpriv, pp);
+
 		writelfl(EDMA_EN, base + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
 	}
@@ -739,12 +811,12 @@
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_stop_dma(struct ata_port *ap)
+static int mv_stop_dma(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp	= ap->private_data;
 	u32 reg;
-	int i;
+	int i, err = 0;
 
 	if (MV_PP_FLAG_EDMA_EN & pp->pp_flags) {
 		/* Disable EDMA if active.   The disable bit auto clears.
@@ -764,10 +836,12 @@
 		udelay(100);
 	}
 
-	if (EDMA_EN & reg) {
+	if (reg & EDMA_EN) {
 		ata_port_printk(ap, KERN_ERR, "Unable to stop eDMA\n");
-		/* FIXME: Consider doing a reset here to recover */
+		err = -EIO;
 	}
+
+	return err;
 }
 
 #ifdef ATA_DEBUG
@@ -973,26 +1047,7 @@
 
 	mv_edma_cfg(hpriv, port_mmio);
 
-	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
-	writelfl(pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK,
-		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
-
-	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
-		writelfl(pp->crqb_dma & 0xffffffff,
-			 port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
-	else
-		writelfl(0, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
-
-	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
-
-	if (hpriv->hp_flags & MV_HP_ERRATA_XX42A0)
-		writelfl(pp->crpb_dma & 0xffffffff,
-			 port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
-	else
-		writelfl(0, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
-
-	writelfl(pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK,
-		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+	mv_set_edma_ptrs(port_mmio, hpriv, pp);
 
 	/* Don't turn on EDMA here...do it before DMA commands only.  Else
 	 * we'll be unable to send non-data, PIO, etc due to restricted access
@@ -1055,11 +1110,6 @@
 	return n_sg;
 }
 
-static inline unsigned mv_inc_q_index(unsigned index)
-{
-	return (index + 1) & MV_MAX_Q_DEPTH_MASK;
-}
-
 static inline void mv_crqb_pack_cmd(__le16 *cmdw, u8 data, u8 addr, unsigned last)
 {
 	u16 tmp = data | (addr << CRQB_CMD_ADDR_SHIFT) | CRQB_CMD_CS |
@@ -1088,7 +1138,7 @@
 	u16 flags = 0;
 	unsigned in_index;
 
- 	if (ATA_PROT_DMA != qc->tf.protocol)
+ 	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
 
 	/* Fill in command request block
@@ -1098,9 +1148,8 @@
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
 
-	/* get current queue index from hardware */
-	in_index = (readl(mv_ap_base(ap) + EDMA_REQ_Q_IN_PTR_OFS)
-			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	/* get current queue index from software */
+	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	pp->crqb[in_index].sg_addr =
 		cpu_to_le32(pp->sg_tbl_dma & 0xffffffff);
@@ -1180,7 +1229,7 @@
 	unsigned in_index;
 	u32 flags = 0;
 
- 	if (ATA_PROT_DMA != qc->tf.protocol)
+ 	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
 
 	/* Fill in Gen IIE command request block
@@ -1191,9 +1240,8 @@
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
 
-	/* get current queue index from hardware */
-	in_index = (readl(mv_ap_base(ap) + EDMA_REQ_Q_IN_PTR_OFS)
-			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	/* get current queue index from software */
+	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	crqb = (struct mv_crqb_iie *) &pp->crqb[in_index];
 	crqb->addr = cpu_to_le32(pp->sg_tbl_dma & 0xffffffff);
@@ -1241,35 +1289,35 @@
  */
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 {
-	void __iomem *port_mmio = mv_ap_base(qc->ap);
-	struct mv_port_priv *pp = qc->ap->private_data;
-	unsigned in_index;
-	u32 in_ptr;
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = mv_ap_base(ap);
+	struct mv_port_priv *pp = ap->private_data;
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	u32 in_index;
 
-	if (ATA_PROT_DMA != qc->tf.protocol) {
+ 	if (qc->tf.protocol != ATA_PROT_DMA) {
 		/* We're about to send a non-EDMA capable command to the
 		 * port.  Turn off EDMA so there won't be problems accessing
 		 * shadow block, etc registers.
 		 */
-		mv_stop_dma(qc->ap);
+		mv_stop_dma(ap);
 		return ata_qc_issue_prot(qc);
 	}
 
-	in_ptr   = readl(port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
-	in_index = (in_ptr >> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	mv_start_dma(port_mmio, hpriv, pp);
+
+	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	/* until we do queuing, the queue should be empty at this point */
 	WARN_ON(in_index != ((readl(port_mmio + EDMA_REQ_Q_OUT_PTR_OFS)
 		>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK));
 
-	in_index = mv_inc_q_index(in_index);	/* now incr producer index */
+	pp->req_idx++;
 
-	mv_start_dma(port_mmio, pp);
+	in_index = (pp->req_idx & MV_MAX_Q_DEPTH_MASK) << EDMA_REQ_Q_PTR_SHIFT;
 
-	/* and write the request in pointer to kick the EDMA to life */
-	in_ptr &= EDMA_REQ_Q_BASE_LO_MASK;
-	in_ptr |= in_index << EDMA_REQ_Q_PTR_SHIFT;
-	writelfl(in_ptr, port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | in_index,
+		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
 
 	return 0;
 }
@@ -1291,27 +1339,26 @@
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp = ap->private_data;
-	unsigned out_index;
-	u32 out_ptr;
+	u32 out_index;
 	u8 ata_status;
 
-	out_ptr   = readl(port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
-	out_index = (out_ptr >> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
+	out_index = pp->resp_idx & MV_MAX_Q_DEPTH_MASK;
 
 	ata_status = le16_to_cpu(pp->crpb[out_index].flags)
 					>> CRPB_FLAG_STATUS_SHIFT;
 
 	/* increment our consumer index... */
-	out_index = mv_inc_q_index(out_index);
+	pp->resp_idx++;
+	out_index = pp->resp_idx & MV_MAX_Q_DEPTH_MASK;
 
 	/* and, until we do NCQ, there should only be 1 CRPB waiting */
 	WARN_ON(out_index != ((readl(port_mmio + EDMA_RSP_Q_IN_PTR_OFS)
 		>> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK));
 
 	/* write out our inc'd consumer index so EDMA knows we're caught up */
-	out_ptr &= EDMA_RSP_Q_BASE_LO_MASK;
-	out_ptr |= out_index << EDMA_RSP_Q_PTR_SHIFT;
-	writelfl(out_ptr, port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+	writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
+		 (out_index << EDMA_RSP_Q_PTR_SHIFT),
+		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 
 	/* Return ATA status register for completed CRPB */
 	return ata_status;
@@ -1331,30 +1378,95 @@
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_err_intr(struct ata_port *ap, int reset_allowed)
+static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
+			unsigned int err_mask)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
-	u32 edma_err_cause, serr = 0;
-
-	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
-
-	if (EDMA_ERR_SERR & edma_err_cause) {
+	u32 edma_err_cause, eh_freeze_mask, serr = 0;
+	struct mv_port_priv *pp = ap->private_data;
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	unsigned int edma_enabled = (pp->pp_flags & MV_PP_FLAG_EDMA_EN);
+	unsigned int action = 0;
+	struct ata_eh_info *ehi = &ap->eh_info;
+
+	ata_ehi_clear_desc(ehi);
+
+	if (!edma_enabled) {
+		/* just a guess: do we need to do this? should we
+		 * expand this, and do it in all cases?
+		 */
 		sata_scr_read(ap, SCR_ERROR, &serr);
 		sata_scr_write_flush(ap, SCR_ERROR, serr);
 	}
-	if (EDMA_ERR_SELF_DIS & edma_err_cause) {
-		struct mv_port_priv *pp	= ap->private_data;
-		pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+
+	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+
+	ata_ehi_push_desc(ehi, "edma_err 0x%08x", edma_err_cause);
+
+	/*
+	 * all generations share these EDMA error cause bits
+	 */
+
+	if (edma_err_cause & EDMA_ERR_DEV)
+		err_mask |= AC_ERR_DEV;
+	if (edma_err_cause & (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
+			EDMA_ERR_CRBQ_PAR | EDMA_ERR_CRPB_PAR |
+			EDMA_ERR_INTRL_PAR)) {
+		err_mask |= AC_ERR_ATA_BUS;
+		action |= ATA_EH_HARDRESET;
+		ata_ehi_push_desc(ehi, ", parity error");
+	}
+	if (edma_err_cause & (EDMA_ERR_DEV_DCON | EDMA_ERR_DEV_CON)) {
+		ata_ehi_hotplugged(ehi);
+		ata_ehi_push_desc(ehi, edma_err_cause & EDMA_ERR_DEV_DCON ?
+			", dev disconnect" : ", dev connect");
+	}
+
+	if (IS_50XX(hpriv)) {
+		eh_freeze_mask = EDMA_EH_FREEZE_5;
+
+		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
+			struct mv_port_priv *pp	= ap->private_data;
+			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+			ata_ehi_push_desc(ehi, ", EDMA self-disable");
+		}
+	} else {
+		eh_freeze_mask = EDMA_EH_FREEZE;
+
+		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
+			struct mv_port_priv *pp	= ap->private_data;
+			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+			ata_ehi_push_desc(ehi, ", EDMA self-disable");
+		}
+
+		if (edma_err_cause & EDMA_ERR_SERR) {
+			sata_scr_read(ap, SCR_ERROR, &serr);
+			sata_scr_write_flush(ap, SCR_ERROR, serr);
+			err_mask = AC_ERR_ATA_BUS;
+			action |= ATA_EH_HARDRESET;
+		}
 	}
-	DPRINTK(KERN_ERR "ata%u: port error; EDMA err cause: 0x%08x "
-		"SERR: 0x%08x\n", ap->print_id, edma_err_cause, serr);
 
 	/* Clear EDMA now that SERR cleanup done */
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	/* check for fatal here and recover if needed */
-	if (reset_allowed && (EDMA_ERR_FATAL & edma_err_cause))
-		mv_stop_and_reset(ap);
+	if (!err_mask) {
+		err_mask = AC_ERR_OTHER;
+		action |= ATA_EH_HARDRESET;
+	}
+
+	ehi->serror |= serr;
+	ehi->action |= action;
+
+	if (qc)
+		qc->err_mask |= err_mask;
+	else
+		ehi->err_mask |= err_mask;
+
+	if (edma_err_cause & eh_freeze_mask)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
 }
 
 /**
@@ -1389,8 +1501,10 @@
 
 	/* we'll need the HC success int register in most cases */
 	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-	if (hc_irq_cause)
-		writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+	if (!hc_irq_cause)
+		return;
+
+	writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
 		hc,relevant,hc_irq_cause);
@@ -1399,9 +1513,11 @@
 		u8 ata_status = 0;
 		struct ata_port *ap = host->ports[port];
 		struct mv_port_priv *pp = ap->private_data;
+		int have_err_bits;
 
 		hard_port = mv_hardport_from_port(port); /* range 0..3 */
 		handled = 0;	/* ensure ata_status is set if handled++ */
+		err_mask = 0;
 
 		/* Note that DEV_IRQ might happen spuriously during EDMA,
 		 * and should be ignored in such cases.
@@ -1429,32 +1545,66 @@
 		if (ap && (ap->flags & ATA_FLAG_DISABLED))
 			continue;
 
-		err_mask = ac_err_mask(ata_status);
+		if (handled)
+			err_mask = ac_err_mask(ata_status);
 
 		shift = port << 1;		/* (port * 2) */
 		if (port >= MV_PORTS_PER_HC) {
 			shift++;	/* skip bit 8 in the HC Main IRQ reg */
 		}
-		if ((PORT0_ERR << shift) & relevant) {
-			mv_err_intr(ap, 1);
-			err_mask |= AC_ERR_OTHER;
-			handled = 1;
+		have_err_bits = ((PORT0_ERR << shift) & relevant);
+
+		qc = ata_qc_from_tag(ap, ap->active_tag);
+
+		if ((qc) && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
+			if (have_err_bits || err_mask)
+				mv_err_intr(ap, qc, err_mask);
+			else
+				ata_qc_complete(qc);
 		}
+		else if ((!qc) && (have_err_bits || err_mask))
+			mv_err_intr(ap, qc, err_mask);
+	}
+	VPRINTK("EXIT\n");
+}
+
+static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
+{
+	struct ata_port *ap;
+	struct ata_queued_cmd *qc;
+	struct ata_eh_info *ehi;
+	unsigned int i, err_mask, printed = 0;
+	u32 err_cause;
+
+	err_cause = readl(mmio + PCI_IRQ_CAUSE_OFS);
 
-		if (handled) {
+	dev_printk(KERN_ERR, host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n",
+		   err_cause);
+
+	DPRINTK("All regs @ PCI error\n");
+	mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
+
+	writelfl(0, mmio + PCI_IRQ_CAUSE_OFS);
+
+	for (i = 0; i < host->n_ports; i++) {
+		ap = host->ports[i];
+		if (!ata_port_offline(ap)) {
+			ehi = &ap->eh_info;
+			ata_ehi_clear_desc(ehi);
+			if (!printed++)
+				ata_ehi_push_desc(ehi,
+					"PCI err cause 0x%08x", err_cause);
+			err_mask = AC_ERR_HOST_BUS;
+			ehi->action = ATA_EH_HARDRESET;
 			qc = ata_qc_from_tag(ap, ap->active_tag);
-			if (qc && (qc->flags & ATA_QCFLAG_ACTIVE)) {
-				VPRINTK("port %u IRQ found for qc, "
-					"ata_status 0x%x\n", port,ata_status);
-				/* mark qc status appropriately */
-				if (!(qc->tf.flags & ATA_TFLAG_POLLING)) {
-					qc->err_mask |= err_mask;
-					ata_qc_complete(qc);
-				}
-			}
+			if (qc)
+				qc->err_mask |= err_mask;
+			else
+				ehi->err_mask |= err_mask;
+
+			ata_port_freeze(ap);
 		}
 	}
-	VPRINTK("EXIT\n");
 }
 
 /**
@@ -1491,17 +1641,27 @@
 	n_hcs = mv_get_hc_count(host->ports[0]->flags);
 	spin_lock(&host->lock);
 
+	if (unlikely(irq_stat & PCI_ERR)) {
+		mv_pci_error(host, mmio);
+		handled = 1;
+		goto out_unlock;	/* skip all other HC irq handling */
+	}
+
 	for (hc = 0; hc < n_hcs; hc++) {
 		u32 relevant = irq_stat & (HC0_IRQ_PEND << (hc * HC_SHIFT));
 		if (relevant) {
 			mv_host_intr(host, relevant, hc);
-			handled++;
+			handled = 1;
 		}
 	}
 
 	hpriv = host->private_data;
 	if (IS_60XX(hpriv)) {
-		/* deal with the interrupt coalescing bits */
+		/*
+		 * deal with the interrupt coalescing bits; they
+		 * are masked via HC_MAIN_MASKED_IRQS, so we shouldn't
+		 * need to do this.
+		 */
 		if (irq_stat & (TRAN_LO_DONE | TRAN_HI_DONE | PORTS_0_7_COAL_DONE)) {
 			writelfl(0, mmio + MV_IRQ_COAL_CAUSE_LO);
 			writelfl(0, mmio + MV_IRQ_COAL_CAUSE_HI);
@@ -1509,16 +1669,7 @@
 		}
 	}
 
-	if (PCI_ERR & irq_stat) {
-		printk(KERN_ERR DRV_NAME ": PCI ERROR; PCI IRQ cause=0x%08x\n",
-		       readl(mmio + PCI_IRQ_CAUSE_OFS));
-
-		DPRINTK("All regs @ PCI error\n");
-		mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
-
-		writelfl(0, mmio + PCI_IRQ_CAUSE_OFS);
-		handled++;
-	}
+out_unlock:
 	spin_unlock(&host->lock);
 
 	return IRQ_RETVAL(handled);
@@ -1927,28 +2078,8 @@
 		mdelay(1);
 }
 
-static void mv_stop_and_reset(struct ata_port *ap)
-{
-	struct mv_host_priv *hpriv = ap->host->private_data;
-	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
-
-	mv_stop_dma(ap);
-
-	mv_channel_reset(hpriv, mmio, ap->port_no);
-
-	__mv_phy_reset(ap, 0);
-}
-
-static inline void __msleep(unsigned int msec, int can_sleep)
-{
-	if (can_sleep)
-		msleep(msec);
-	else
-		mdelay(msec);
-}
-
 /**
- *      __mv_phy_reset - Perform eDMA reset followed by COMRESET
+ *      mv_phy_reset - Perform eDMA reset followed by COMRESET
  *      @ap: ATA channel to manipulate
  *
  *      Part of this is taken from __sata_phy_reset and modified to
@@ -1958,14 +2089,12 @@
  *      Inherited from caller.  This is coded to safe to call at
  *      interrupt level, i.e. it does not sleep.
  */
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep)
+static void mv_phy_reset(struct ata_port *ap, unsigned int *class,
+			 unsigned long deadline)
 {
 	struct mv_port_priv *pp	= ap->private_data;
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	void __iomem *port_mmio = mv_ap_base(ap);
-	struct ata_taskfile tf;
-	struct ata_device *dev = &ap->device[0];
-	unsigned long timeout;
 	int retry = 5;
 	u32 sstatus;
 
@@ -1978,19 +2107,18 @@
 	/* Issue COMRESET via SControl */
 comreset_retry:
 	sata_scr_write_flush(ap, SCR_CONTROL, 0x301);
-	__msleep(1, can_sleep);
+	msleep(1);
 
 	sata_scr_write_flush(ap, SCR_CONTROL, 0x300);
-	__msleep(20, can_sleep);
+	msleep(20);
 
-	timeout = jiffies + msecs_to_jiffies(200);
 	do {
 		sata_scr_read(ap, SCR_STATUS, &sstatus);
 		if (((sstatus & 0x3) == 3) || ((sstatus & 0x3) == 0))
 			break;
 
-		__msleep(1, can_sleep);
-	} while (time_before(jiffies, timeout));
+		msleep(1);
+	} while (time_before(jiffies, deadline));
 
 	/* work around errata */
 	if (IS_60XX(hpriv) &&
@@ -2002,13 +2130,8 @@
 		"SCtrl 0x%08x\n", mv_scr_read(ap, SCR_STATUS),
 		mv_scr_read(ap, SCR_ERROR), mv_scr_read(ap, SCR_CONTROL));
 
-	if (ata_port_online(ap)) {
-		ata_port_probe(ap);
-	} else {
-		sata_scr_read(ap, SCR_STATUS, &sstatus);
-		ata_port_printk(ap, KERN_INFO,
-				"no device found (phy stat %08x)\n", sstatus);
-		ata_port_disable(ap);
+	if (ata_port_offline(ap)) {
+		*class = ATA_DEV_NONE;
 		return;
 	}
 
@@ -2022,68 +2145,147 @@
 		u8 drv_stat = ata_check_status(ap);
 		if ((drv_stat != 0x80) && (drv_stat != 0x7f))
 			break;
-		__msleep(500, can_sleep);
+		msleep(500);
 		if (retry-- <= 0)
 			break;
+		if (time_after(jiffies, deadline))
+			break;
 	}
 
-	tf.lbah = readb(ap->ioaddr.lbah_addr);
-	tf.lbam = readb(ap->ioaddr.lbam_addr);
-	tf.lbal = readb(ap->ioaddr.lbal_addr);
-	tf.nsect = readb(ap->ioaddr.nsect_addr);
-
-	dev->class = ata_dev_classify(&tf);
-	if (!ata_dev_enabled(dev)) {
-		VPRINTK("Port disabled post-sig: No device present.\n");
-		ata_port_disable(ap);
-	}
+	/* FIXME: if we passed the deadline, the following
+	 * code probably produces an invalid result
+	 */
+
+	/* finally, read device signature from TF registers */
+	*class = ata_dev_try_classify(ap, 0, NULL);
 
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+	WARN_ON(pp->pp_flags & MV_PP_FLAG_EDMA_EN);
 
 	VPRINTK("EXIT\n");
 }
 
-static void mv_phy_reset(struct ata_port *ap)
+static int mv_prereset(struct ata_port *ap, unsigned long deadline)
 {
-	__mv_phy_reset(ap, 1);
+	struct mv_port_priv *pp	= ap->private_data;
+	struct ata_eh_context *ehc = &ap->eh_context;
+	int rc;
+	
+	rc = mv_stop_dma(ap);
+	if (rc)
+		ehc->i.action |= ATA_EH_HARDRESET;
+
+	if (!(pp->pp_flags & MV_PP_FLAG_HAD_A_RESET)) {
+		pp->pp_flags |= MV_PP_FLAG_HAD_A_RESET;
+		ehc->i.action |= ATA_EH_HARDRESET;
+	}
+
+	/* if we're about to do hardreset, nothing more to do */
+	if (ehc->i.action & ATA_EH_HARDRESET)
+		return 0;
+
+	if (ata_port_online(ap))
+		rc = ata_wait_ready(ap, deadline);
+	else
+		rc = -ENODEV;
+
+	return rc;
 }
 
-/**
- *      mv_eng_timeout - Routine called by libata when SCSI times out I/O
- *      @ap: ATA channel to manipulate
- *
- *      Intent is to clear all pending error conditions, reset the
- *      chip/bus, fail the command, and move on.
- *
- *      LOCKING:
- *      This routine holds the host lock while failing the command.
- */
-static void mv_eng_timeout(struct ata_port *ap)
+static int mv_hardreset(struct ata_port *ap, unsigned int *class,
+			unsigned long deadline)
 {
+	struct mv_host_priv *hpriv = ap->host->private_data;
 	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
 
-	ata_port_printk(ap, KERN_ERR, "Entering mv_eng_timeout\n");
-	DPRINTK("All regs @ start of eng_timeout\n");
-	mv_dump_all_regs(mmio, ap->port_no, to_pci_dev(ap->host->dev));
-
-	qc = ata_qc_from_tag(ap, ap->active_tag);
-        printk(KERN_ERR "mmio_base %p ap %p qc %p scsi_cmnd %p &cmnd %p\n",
-	       mmio, ap, qc, qc->scsicmd, &qc->scsicmd->cmnd);
+	mv_stop_dma(ap);
 
-	spin_lock_irqsave(&ap->host->lock, flags);
-	mv_err_intr(ap, 0);
-	mv_stop_and_reset(ap);
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	mv_channel_reset(hpriv, mmio, ap->port_no);
+
+	mv_phy_reset(ap, class, deadline);
 
-	WARN_ON(!(qc->flags & ATA_QCFLAG_ACTIVE));
-	if (qc->flags & ATA_QCFLAG_ACTIVE) {
-		qc->err_mask |= AC_ERR_TIMEOUT;
-		ata_eh_qc_complete(qc);
+	return 0;
+}
+
+static void mv_postreset(struct ata_port *ap, unsigned int *classes)
+{
+	u32 serr;
+
+	/* print link status */
+	sata_print_link_status(ap);
+
+	/* clear SError */
+	sata_scr_read(ap, SCR_ERROR, &serr);
+	sata_scr_write_flush(ap, SCR_ERROR, serr);
+
+	/* bail out if no device is present */
+	if (classes[0] == ATA_DEV_NONE && classes[1] == ATA_DEV_NONE) {
+		DPRINTK("EXIT, no device\n");
+		return;
 	}
+
+	/* set up device control */
+	iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
+}
+
+static void mv_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, mv_prereset, ata_std_softreset,
+		  mv_hardreset, mv_postreset);
+}
+
+static void mv_eh_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
+	u32 tmp, mask;
+	unsigned int shift;
+
+	/* FIXME: handle coalescing completion events properly */
+
+	shift = ap->port_no * 2;
+	if (hc > 0)
+		shift++;
+
+	mask = 0x3 << shift;
+
+	/* disable assertion of portN err, done events */
+	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+	writelfl(tmp & ~mask, mmio + HC_MAIN_IRQ_MASK_OFS);
+}
+
+static void mv_eh_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
+	void __iomem *hc_mmio = mv_hc_base(mmio, hc);
+	void __iomem *port_mmio = mv_ap_base(ap);
+	u32 tmp, mask, hc_irq_cause;
+	unsigned int shift, hc_port_no = ap->port_no;
+
+	/* FIXME: handle coalescing completion events properly */
+
+	shift = ap->port_no * 2;
+	if (hc > 0) {
+		shift++;
+		hc_port_no -= 4;
+	}
+
+	mask = 0x3 << shift;
+
+	/* clear EDMA errors on this port */
+	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+
+	/* clear pending irq events */
+	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
+	hc_irq_cause &= ~(1 << hc_port_no);	/* clear CRPB-done */
+	hc_irq_cause &= ~(1 << (hc_port_no + 8)); /* clear Device int */
+	writel(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+
+	/* enable assertion of portN err, done events */
+	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+	writelfl(tmp | mask, mmio + HC_MAIN_IRQ_MASK_OFS);
 }
 
 /**
@@ -2338,7 +2540,7 @@
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct mv_host_priv *hpriv = host->private_data;
 	u8 rev_id, scc;
-	const char *scc_s;
+	const char *scc_s, *gen;
 
 	/* Use this to determine the HW stepping of the chip so we know
 	 * what errata to workaround
@@ -2351,11 +2553,20 @@
 	else if (scc == 0x01)
 		scc_s = "RAID";
 	else
-		scc_s = "unknown";
+		scc_s = "?";
+
+	if (IS_GEN_I(hpriv))
+		gen = "I";
+	else if (IS_GEN_II(hpriv))
+		gen = "II";
+	else if (IS_GEN_IIE(hpriv))
+		gen = "IIE";
+	else
+		gen = "?";
 
 	dev_printk(KERN_INFO, &pdev->dev,
-	       "%u slots %u ports %s mode IRQ via %s\n",
-	       (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
+	       "Gen-%s %u slots %u ports %s mode IRQ via %s\n",
+	       gen, (unsigned)MV_MAX_Q_DEPTH, host->n_ports,
 	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }
 
