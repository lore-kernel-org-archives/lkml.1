Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbXAZHGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbXAZHGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 02:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXAZHGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 02:06:35 -0500
Received: from havoc.gtf.org ([69.61.125.42]:51918 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXAZHGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 02:06:33 -0500
Date: Fri, 26 Jan 2007 02:06:32 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] sata_mv: conversion to new EH
Message-ID: <20070126070632.GA17323@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first cut at converting sata_mv to new EH.

It builds, but is untested.

Done:
- freeze, thaw
- hardreset
- prereset, software: intentionally not implemented

Not yet done:
- initiate EH from interrupt handler.  Right now the "whack it"
  old error handling remains, when an error is seen in irq.

So, it should do probing via new EH framework, but any errors
encountered are handled manually.


diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index aae0b52..bfc468c 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -340,8 +340,8 @@ static u32 mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
 static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
 static u32 mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
 static void mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
-static void mv_phy_reset(struct ata_port *ap);
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep);
+static void __mv_phy_reset(struct ata_port *ap, int can_sleep,
+			   unsigned int *class);
 static void mv_host_stop(struct ata_host *host);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
@@ -349,7 +349,9 @@ static void mv_qc_prep(struct ata_queued_cmd *qc);
 static void mv_qc_prep_iie(struct ata_queued_cmd *qc);
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc);
 static irqreturn_t mv_interrupt(int irq, void *dev_instance);
-static void mv_eng_timeout(struct ata_port *ap);
+static void mv_error_handler(struct ata_port *ap);
+static void mv_eh_freeze(struct ata_port *ap);
+static void mv_eh_thaw(struct ata_port *ap);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -402,17 +404,17 @@ static const struct ata_port_operations mv5_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
-
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_mmio_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_handler		= mv_interrupt,
 	.irq_clear		= mv_irq_clear,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
 
@@ -430,17 +432,17 @@ static const struct ata_port_operations mv6_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
-
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_mmio_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_handler		= mv_interrupt,
 	.irq_clear		= mv_irq_clear,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -458,17 +460,17 @@ static const struct ata_port_operations mv_iie_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
-
 	.qc_prep		= mv_qc_prep_iie,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_mmio_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_handler		= mv_interrupt,
 	.irq_clear		= mv_irq_clear,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -1327,7 +1329,7 @@ static void mv_err_intr(struct ata_port *ap, int reset_allowed)
 
 	/* check for fatal here and recover if needed */
 	if (reset_allowed && (EDMA_ERR_FATAL & edma_err_cause))
-		mv_stop_and_reset(ap);
+		mv_stop_and_reset(ap);	/* FIXME: broken for new-EH */
 }
 
 /**
@@ -1911,7 +1913,7 @@ static void mv_stop_and_reset(struct ata_port *ap)
 
 	mv_channel_reset(hpriv, mmio, ap->port_no);
 
-	__mv_phy_reset(ap, 0);
+	__mv_phy_reset(ap, 0, NULL);
 }
 
 static inline void __msleep(unsigned int msec, int can_sleep)
@@ -1933,7 +1935,8 @@ static inline void __msleep(unsigned int msec, int can_sleep)
  *      Inherited from caller.  This is coded to safe to call at
  *      interrupt level, i.e. it does not sleep.
  */
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep)
+static void __mv_phy_reset(struct ata_port *ap, int can_sleep,
+			   unsigned int *class)
 {
 	struct mv_port_priv *pp	= ap->private_data;
 	struct mv_host_priv *hpriv = ap->host->private_data;
@@ -1977,16 +1980,13 @@ comreset_retry:
 		"SCtrl 0x%08x\n", mv_scr_read(ap, SCR_STATUS),
 		mv_scr_read(ap, SCR_ERROR), mv_scr_read(ap, SCR_CONTROL));
 
-	if (ata_port_online(ap)) {
-		ata_port_probe(ap);
-	} else {
-		sata_scr_read(ap, SCR_STATUS, &sstatus);
-		ata_port_printk(ap, KERN_INFO,
-				"no device found (phy stat %08x)\n", sstatus);
-		ata_port_disable(ap);
+	ap->cbl = ATA_CBL_SATA;
+
+	if (!ata_port_online(ap)) {
+		if (*class)
+			*class = ATA_DEV_NONE;
 		return;
 	}
-	ap->cbl = ATA_CBL_SATA;
 
 	/* even after SStatus reflects that device is ready,
 	 * it seems to take a while for link to be fully
@@ -2003,16 +2003,19 @@ comreset_retry:
 			break;
 	}
 
+	/* finally, read device signature from TF registers */
+
 	tf.lbah = readb((void __iomem *) ap->ioaddr.lbah_addr);
 	tf.lbam = readb((void __iomem *) ap->ioaddr.lbam_addr);
 	tf.lbal = readb((void __iomem *) ap->ioaddr.lbal_addr);
 	tf.nsect = readb((void __iomem *) ap->ioaddr.nsect_addr);
 
-	dev->class = ata_dev_classify(&tf);
-	if (!ata_dev_enabled(dev)) {
-		VPRINTK("Port disabled post-sig: No device present.\n");
-		ata_port_disable(ap);
-	}
+	if (class)
+		*class = ata_dev_classify(&tf);
+	else
+		dev->class = ata_dev_classify(&tf);
+	if ((!ata_dev_enabled(dev)) && (*class))
+		*class = ATA_DEV_NONE;
 
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
@@ -2021,45 +2024,76 @@ comreset_retry:
 	VPRINTK("EXIT\n");
 }
 
-static void mv_phy_reset(struct ata_port *ap)
+static int mv_hardreset(struct ata_port *ap, unsigned int *class)
 {
-	__mv_phy_reset(ap, 1);
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = ap->host->mmio_base;
+
+	mv_stop_dma(ap);
+
+	mv_channel_reset(hpriv, mmio, ap->port_no);
+
+	__mv_phy_reset(ap, 1, class);
+
+	return 0;
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
+static void mv_error_handler(struct ata_port *ap)
 {
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
+	ata_do_eh(ap, NULL, NULL, mv_hardreset, ata_std_postreset);
+}
+
+static void mv_eh_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->mmio_base;
+	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
+	u32 tmp, mask;
+	unsigned int shift;
 
-	ata_port_printk(ap, KERN_ERR, "Entering mv_eng_timeout\n");
-	DPRINTK("All regs @ start of eng_timeout\n");
-	mv_dump_all_regs(ap->host->mmio_base, ap->port_no,
-			 to_pci_dev(ap->host->dev));
+	/* FIXME: handle coalescing completion events properly */
 
-	qc = ata_qc_from_tag(ap, ap->active_tag);
-        printk(KERN_ERR "mmio_base %p ap %p qc %p scsi_cmnd %p &cmnd %p\n",
-	       ap->host->mmio_base, ap, qc, qc->scsicmd, &qc->scsicmd->cmnd);
+	shift = ap->port_no * 2;
+	if (hc > 0)
+		shift++;
 
-	spin_lock_irqsave(&ap->host->lock, flags);
-	mv_err_intr(ap, 0);
-	mv_stop_and_reset(ap);
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	mask = 0x3 << shift;
 
-	WARN_ON(!(qc->flags & ATA_QCFLAG_ACTIVE));
-	if (qc->flags & ATA_QCFLAG_ACTIVE) {
-		qc->err_mask |= AC_ERR_TIMEOUT;
-		ata_eh_qc_complete(qc);
+	/* disable assertion of portN err, done events */
+	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+	writelfl(tmp & ~mask, mmio + HC_MAIN_IRQ_MASK_OFS);
+}
+
+static void mv_eh_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->host->mmio_base;
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
 	}
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
