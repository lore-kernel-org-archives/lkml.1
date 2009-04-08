Return-Path: <linux-kernel-owner+w=401wt.eu-S1763167AbZDHUFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167AbZDHUFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbZDHUFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:05:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52479 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236AbZDHUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:05:13 -0400
Date: Wed, 8 Apr 2009 16:05:11 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_sx4: refresh and convert to new EH
Message-ID: <20090408200511.GA24071@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I reviewed and refreshed libata-dev.git#new-eh, now renamed to #sx4.

Several bugs and missing pieces in the new-EH conversion were addressed
(often by copying highly similar code from sata_promise, a highly
similar chip)

The only thing left is some "it still works" testing...  any takers?




commit 51aca756268d405fb7cbfc887c55c92185e03b53
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Apr 8 16:02:18 2009 -0400

    [libata] sata_sx4: convert to new exception handling methods
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index dce3dcc..1ce98af 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -213,8 +213,9 @@ struct pdc_host_priv {
 
 
 static int pdc_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static void pdc_eng_timeout(struct ata_port *ap);
-static void pdc_20621_phy_reset(struct ata_port *ap);
+static void pdc_error_handler(struct ata_port *ap);
+static void pdc_freeze(struct ata_port *ap);
+static void pdc_thaw(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
 static void pdc20621_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -233,6 +234,10 @@ static void pdc20621_put_to_dimm(struct ata_host *host,
 				 void *psource, u32 offset, u32 size);
 static void pdc20621_irq_clear(struct ata_port *ap);
 static unsigned int pdc20621_qc_issue(struct ata_queued_cmd *qc);
+static int pdc_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline);
+static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
+static int pdc_check_atapi_dma(struct ata_queued_cmd *qc);
 
 
 static struct scsi_host_template pdc_sata_sht = {
@@ -243,20 +248,24 @@ static struct scsi_host_template pdc_sata_sht = {
 
 /* TODO: inherit from base port_ops after converting to new EH */
 static struct ata_port_operations pdc_20621_ops = {
-	.sff_tf_load		= pdc_tf_load_mmio,
-	.sff_tf_read		= ata_sff_tf_read,
-	.sff_check_status	= ata_sff_check_status,
-	.sff_exec_command	= pdc_exec_command_mmio,
-	.sff_dev_select		= ata_sff_dev_select,
-	.phy_reset		= pdc_20621_phy_reset,
+	.inherits		= &ata_sff_port_ops,
+
+	.check_atapi_dma	= pdc_check_atapi_dma,
 	.qc_prep		= pdc20621_qc_prep,
 	.qc_issue		= pdc20621_qc_issue,
-	.qc_fill_rtf		= ata_sff_qc_fill_rtf,
-	.sff_data_xfer		= ata_sff_data_xfer,
-	.eng_timeout		= pdc_eng_timeout,
-	.sff_irq_clear		= pdc20621_irq_clear,
-	.sff_irq_on		= ata_sff_irq_on,
+
+	.freeze			= pdc_freeze,
+	.thaw			= pdc_thaw,
+	.softreset		= pdc_softreset,
+	.error_handler		= pdc_error_handler,
+	.lost_interrupt		= ATA_OP_NULL,
+	.post_internal_cmd	= pdc_post_internal_cmd,
+
 	.port_start		= pdc_port_start,
+
+	.sff_tf_load		= pdc_tf_load_mmio,
+	.sff_exec_command	= pdc_exec_command_mmio,
+	.sff_irq_clear		= pdc20621_irq_clear,
 };
 
 static const struct ata_port_info pdc_port_info[] = {
@@ -310,14 +319,6 @@ static int pdc_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static void pdc_20621_phy_reset(struct ata_port *ap)
-{
-	VPRINTK("ENTER\n");
-	ap->cbl = ATA_CBL_SATA;
-	ata_port_probe(ap);
-	ata_bus_reset(ap);
-}
-
 static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 				   unsigned int portno,
 					   unsigned int total_len)
@@ -859,40 +860,115 @@ static irqreturn_t pdc20621_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static void pdc_eng_timeout(struct ata_port *ap)
+static void pdc_freeze(struct ata_port *ap)
 {
-	u8 drv_stat;
-	struct ata_host *host = ap->host;
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	u32 tmp;
 
-	DPRINTK("ENTER\n");
+	/* FIXME: if all 4 ATA engines are stopped, also stop HDMA engine */
 
-	spin_lock_irqsave(&host->lock, flags);
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp |= PDC_MASK_INT;
+	tmp &= ~PDC_DMA_ENABLE;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+static void pdc_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	void __iomem *mmio_base;
+	u32 tmp;
 
-	switch (qc->tf.protocol) {
-	case ATA_PROT_DMA:
-	case ATA_PROT_NODATA:
-		ata_port_printk(ap, KERN_ERR, "command timeout\n");
-		qc->err_mask |= __ac_err_mask(ata_wait_idle(ap));
-		break;
+	/* FIXME: start HDMA engine, if zero ATA engines running */
 
-	default:
-		drv_stat = ata_sff_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
+	/* reading SEQ mask register clears IRQ */
+	mmio_base = ap->host->iomap[PDC_MMIO_BAR] + PDC_CHIP0_OFS;
+	readl(mmio_base + PDC_20621_SEQMASK);
 
-		ata_port_printk(ap, KERN_ERR,
-				"unknown timeout, cmd 0x%x stat 0x%x\n",
-				qc->tf.command, drv_stat);
+	/* turn IRQ back on */
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp &= ~PDC_MASK_INT;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-		qc->err_mask |= ac_err_mask(drv_stat);
-		break;
+static void pdc_reset_port(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT;
+	unsigned int i;
+	u32 tmp;
+
+	/* FIXME: handle HDMA copy engine */
+
+	for (i = 11; i > 0; i--) {
+		tmp = readl(mmio);
+		if (tmp & PDC_RESET)
+			break;
+
+		udelay(100);
+
+		tmp |= PDC_RESET;
+		writel(tmp, mmio);
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-	ata_eh_qc_complete(qc);
-	DPRINTK("EXIT\n");
+	tmp &= ~PDC_RESET;
+	writel(tmp, mmio);
+	readl(mmio);	/* flush */
+}
+
+static int pdc_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static void pdc_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		pdc_reset_port(ap);
+
+	ata_std_error_handler(ap);
+}
+
+static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	/* make DMA engine forget about the failed command */
+	if (qc->flags & ATA_QCFLAG_FAILED)
+		pdc_reset_port(ap);
+}
+
+static int pdc_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	u8 *scsicmd = qc->scsicmd->cmnd;
+	int pio = 1; /* atapi dma off by default */
+
+	/* Whitelist commands that may use DMA. */
+	switch (scsicmd[0]) {
+	case WRITE_12:
+	case WRITE_10:
+	case WRITE_6:
+	case READ_12:
+	case READ_10:
+	case READ_6:
+	case 0xad: /* READ_DVD_STRUCTURE */
+	case 0xbe: /* READ_CD */
+		pio = 0;
+	}
+	/* -45150 (FFFF4FA2) to -1 (FFFFFFFF) shall use PIO mode */
+	if (scsicmd[0] == WRITE_10) {
+		unsigned int lba =
+			(scsicmd[2] << 24) |
+			(scsicmd[3] << 16) |
+			(scsicmd[4] << 8) |
+			scsicmd[5];
+		if (lba >= 0xFFFF4FA2)
+			pio = 1;
+	}
+	return pio;
 }
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
