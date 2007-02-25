Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbXBYEO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbXBYEO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 23:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933649AbXBYEO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 23:14:28 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34734 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbXBYEO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 23:14:26 -0500
Date: Sat, 24 Feb 2007 23:14:24 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFT, v1] sata_mv: convert to new EH
Message-ID: <20070225041424.GA18533@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is my first cut at converting sata_mv over to the new 
libata EH stuff.  It is completely untested, so be warned :)

If you are brave enough to test this, the test is simple:  do your
disks appear, and work, the same as before (== without this patch)?



 drivers/ata/sata_mv.c |  365 +++++++++++++++++++++++++++++++------------------
 1 files changed, 232 insertions(+), 133 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index d689df5..cb1df0f 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -206,6 +206,8 @@ enum {
 				   EDMA_ERR_LNK_DATA_RX |
 				   EDMA_ERR_LNK_DATA_TX |
 				   EDMA_ERR_TRANS_PROTO),
+	EDMA_ERR_EH_FREEZE	= (EDMA_ERR_FATAL | EDMA_ERR_DEV_CON |
+				   EDMA_ERR_SERR | EDMA_ERR_SELF_DIS),
 
 	EDMA_REQ_Q_BASE_HI_OFS	= 0x10,
 	EDMA_REQ_Q_IN_PTR_OFS	= 0x14,		/* also contains BASE_LO */
@@ -338,15 +340,15 @@ static u32 mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in);
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
 static irqreturn_t mv_interrupt(int irq, void *dev_instance);
-static void mv_eng_timeout(struct ata_port *ap);
+static void mv_error_handler(struct ata_port *ap);
+static void mv_eh_freeze(struct ata_port *ap);
+static void mv_eh_thaw(struct ata_port *ap);
 static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -370,7 +372,6 @@ static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio);
 static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio);
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
-static void mv_stop_and_reset(struct ata_port *ap);
 
 static struct scsi_host_template mv_sht = {
 	.module			= THIS_MODULE,
@@ -399,19 +400,19 @@ static const struct ata_port_operations mv5_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
-
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_handler		= mv_interrupt,
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
 
@@ -428,19 +429,19 @@ static const struct ata_port_operations mv6_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
-
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_handler		= mv_interrupt,
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -457,19 +458,19 @@ static const struct ata_port_operations mv_iie_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 
-	.phy_reset		= mv_phy_reset,
-
 	.qc_prep		= mv_qc_prep_iie,
 	.qc_issue		= mv_qc_issue,
 	.data_xfer		= ata_data_xfer,
 
-	.eng_timeout		= mv_eng_timeout,
-
 	.irq_handler		= mv_interrupt,
 	.irq_clear		= mv_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
+	.error_handler		= mv_error_handler,
+	.freeze			= mv_eh_freeze,
+	.thaw			= mv_eh_thaw,
+
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
 
@@ -793,20 +794,18 @@ static u32 mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
-	if (0xffffffffU != ofs) {
+	if (0xffffffffU != ofs)
 		return readl(mv_ap_base(ap) + ofs);
-	} else {
+	else
 		return (u32) ofs;
-	}
 }
 
 static void mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 {
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
-	if (0xffffffffU != ofs) {
+	if (0xffffffffU != ofs)
 		writelfl(val, mv_ap_base(ap) + ofs);
-	}
 }
 
 static void mv_edma_cfg(struct mv_host_priv *hpriv, void __iomem *port_mmio)
@@ -1260,30 +1259,87 @@ static u8 mv_get_crpb_status(struct ata_port *ap)
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_err_intr(struct ata_port *ap, int reset_allowed)
+static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
+			unsigned int err_mask)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	u32 edma_err_cause, serr = 0;
+	struct mv_port_priv *pp = ap->private_data;
+	unsigned int edma_enabled = (pp->pp_flags & MV_PP_FLAG_EDMA_EN);
+	unsigned int action = 0;
+	struct ata_eh_info *ehi = &ap->eh_info;
+
+	ata_ehi_clear_desc(ehi);
+
+	if (!edma_enabled) {
+		if (!err_mask)
+			err_mask = AC_ERR_OTHER;
+
+		sata_scr_read(ap, SCR_ERROR, &serr);
+		sata_scr_write_flush(ap, SCR_ERROR, serr);
+
+		ehi->serror |= serr;
+		ehi->action |= action;	/* no-op; here for completeness */
+
+		if (qc)
+			qc->err_mask |= err_mask;
+		else
+			ehi->err_mask |= err_mask;
+
+		ata_port_abort(ap);
+		return;
+	}
 
 	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	if (EDMA_ERR_SERR & edma_err_cause) {
+	ata_ehi_push_desc(ehi, "edma_err 0x%08x", edma_err_cause);
+
+	if (edma_err_cause & EDMA_ERR_SERR) {
 		sata_scr_read(ap, SCR_ERROR, &serr);
 		sata_scr_write_flush(ap, SCR_ERROR, serr);
+		err_mask = AC_ERR_ATA_BUS;
+		action |= ATA_EH_HARDRESET;
 	}
-	if (EDMA_ERR_SELF_DIS & edma_err_cause) {
+	if (edma_err_cause & EDMA_ERR_SELF_DIS) {
 		struct mv_port_priv *pp	= ap->private_data;
 		pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+		ata_ehi_push_desc(ehi, ", EDMA self-disable");
+	}
+	if (edma_err_cause & EDMA_ERR_DEV)
+		err_mask |= AC_ERR_DEV;
+	if (edma_err_cause & (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
+			EDMA_ERR_CRBQ_PAR | EDMA_ERR_CRPB_PAR |
+			EDMA_ERR_INTRL_PAR)) {
+		err_mask = AC_ERR_ATA_BUS;
+		action |= ATA_EH_HARDRESET;
+		ata_ehi_push_desc(ehi, ", parity error");
+	}
+	if (edma_err_cause & (EDMA_ERR_DEV_DCON | EDMA_ERR_DEV_CON)) {
+		ata_ehi_hotplugged(ehi);
+		ata_ehi_push_desc(ehi, edma_err_cause & EDMA_ERR_DEV_DCON ?
+			", dev disconnect" : ", dev connect");
 	}
-	DPRINTK(KERN_ERR "ata%u: port error; EDMA err cause: 0x%08x "
-		"SERR: 0x%08x\n", ap->id, edma_err_cause, serr);
 
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
+	if (edma_err_cause & EDMA_ERR_EH_FREEZE)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
 }
 
 /**
@@ -1311,17 +1367,17 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 	int shift, port, port0, hard_port, handled;
 	unsigned int err_mask;
 
-	if (hc == 0) {
+	if (hc == 0)
 		port0 = 0;
-	} else {
+	else
 		port0 = MV_PORTS_PER_HC;
-	}
 
 	/* we'll need the HC success int register in most cases */
 	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-	if (hc_irq_cause) {
-		writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
-	}
+	if (!hc_irq_cause)
+		return;
+
+	writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	VPRINTK("ENTER, hc%u relevant=0x%08x HC IRQ cause=0x%08x\n",
 		hc,relevant,hc_irq_cause);
@@ -1330,9 +1386,11 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 		u8 ata_status = 0;
 		struct ata_port *ap = host->ports[port];
 		struct mv_port_priv *pp = ap->private_data;
+		int have_err_bits;
 
 		hard_port = mv_hardport_from_port(port); /* range 0..3 */
 		handled = 0;	/* ensure ata_status is set if handled++ */
+		err_mask = 0;
 
 		/* Note that DEV_IRQ might happen spuriously during EDMA,
 		 * and should be ignored in such cases.
@@ -1360,32 +1418,62 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
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
-		}
+		have_err_bits = ((PORT0_ERR << shift) & relevant);
+
+		qc = ata_qc_from_tag(ap, ap->active_tag);
+
+		if (have_err_bits || err_mask)
+			mv_err_intr(ap, qc, err_mask);
+		else if ((qc) && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
+			ata_qc_complete(qc);
+	}
+	VPRINTK("EXIT\n");
+}
 
-		if (handled) {
+static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
+{
+	struct ata_port *ap;
+	struct ata_queued_cmd *qc;
+	struct ata_eh_info *ehi;
+	unsigned int i, err_mask, printed = 0;
+	u32 err_cause;
+
+	err_cause = readl(mmio + PCI_IRQ_CAUSE_OFS);
+
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
@@ -1416,24 +1504,33 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	/* check the cases where we either have nothing pending or have read
 	 * a bogus register value which can indicate HW removal or PCI fault
 	 */
-	if (!irq_stat || (0xffffffffU == irq_stat)) {
+	if (!irq_stat || (0xffffffffU == irq_stat))
 		return IRQ_NONE;
-	}
 
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
@@ -1441,16 +1538,7 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
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
@@ -1859,26 +1947,6 @@ static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
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
  *      __mv_phy_reset - Perform eDMA reset followed by COMRESET
  *      @ap: ATA channel to manipulate
@@ -1890,7 +1958,7 @@ static inline void __msleep(unsigned int msec, int can_sleep)
  *      Inherited from caller.  This is coded to safe to call at
  *      interrupt level, i.e. it does not sleep.
  */
-static void __mv_phy_reset(struct ata_port *ap, int can_sleep)
+static void __mv_phy_reset(struct ata_port *ap, unsigned int *class)
 {
 	struct mv_port_priv *pp	= ap->private_data;
 	struct mv_host_priv *hpriv = ap->host->private_data;
@@ -1910,10 +1978,10 @@ static void __mv_phy_reset(struct ata_port *ap, int can_sleep)
 	/* Issue COMRESET via SControl */
 comreset_retry:
 	sata_scr_write_flush(ap, SCR_CONTROL, 0x301);
-	__msleep(1, can_sleep);
+	msleep(1);
 
 	sata_scr_write_flush(ap, SCR_CONTROL, 0x300);
-	__msleep(20, can_sleep);
+	msleep(20);
 
 	timeout = jiffies + msecs_to_jiffies(200);
 	do {
@@ -1921,7 +1989,7 @@ comreset_retry:
 		if (((sstatus & 0x3) == 3) || ((sstatus & 0x3) == 0))
 			break;
 
-		__msleep(1, can_sleep);
+		msleep(1);
 	} while (time_before(jiffies, timeout));
 
 	/* work around errata */
@@ -1934,16 +2002,13 @@ comreset_retry:
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
@@ -1955,21 +2020,24 @@ comreset_retry:
 		u8 drv_stat = ata_check_status(ap);
 		if ((drv_stat != 0x80) && (drv_stat != 0x7f))
 			break;
-		__msleep(500, can_sleep);
+		msleep(500);
 		if (retry-- <= 0)
 			break;
 	}
 
+	/* finally, read device signature from TF registers */
+
 	tf.lbah = readb(ap->ioaddr.lbah_addr);
 	tf.lbam = readb(ap->ioaddr.lbam_addr);
 	tf.lbal = readb(ap->ioaddr.lbal_addr);
 	tf.nsect = readb(ap->ioaddr.nsect_addr);
 
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
 
@@ -1978,45 +2046,76 @@ comreset_retry:
 	VPRINTK("EXIT\n");
 }
 
-static void mv_phy_reset(struct ata_port *ap)
+static int mv_hardreset(struct ata_port *ap, unsigned int *class)
 {
-	__mv_phy_reset(ap, 1);
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
+
+	mv_stop_dma(ap);
+
+	mv_channel_reset(hpriv, mmio, ap->port_no);
+
+	__mv_phy_reset(ap, class);
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
+{
+	ata_do_eh(ap, NULL, NULL, mv_hardreset, ata_std_postreset);
+}
+
+static void mv_eh_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
+	unsigned int hc = (ap->port_no > 3) ? 1 : 0;
+	u32 tmp, mask;
+	unsigned int shift;
 
-	ata_port_printk(ap, KERN_ERR, "Entering mv_eng_timeout\n");
-	DPRINTK("All regs @ start of eng_timeout\n");
-	mv_dump_all_regs(mmio, ap->port_no, to_pci_dev(ap->host->dev));
+	/* FIXME: handle coalescing completion events properly */
 
-	qc = ata_qc_from_tag(ap, ap->active_tag);
-        printk(KERN_ERR "mmio_base %p ap %p qc %p scsi_cmnd %p &cmnd %p\n",
-	       mmio, ap, qc, qc->scsicmd, &qc->scsicmd->cmnd);
+	shift = ap->port_no * 2;
+	if (hc > 0)
+		shift++;
 
-	spin_lock_irqsave(&ap->host->lock, flags);
-	mv_err_intr(ap, 0);
-	mv_stop_and_reset(ap);
-	spin_unlock_irqrestore(&ap->host->lock, flags);
+	mask = 0x3 << shift;
+
+	/* disable assertion of portN err, done events */
+	tmp = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
+	writelfl(tmp & ~mask, mmio + HC_MAIN_IRQ_MASK_OFS);
+}
 
-	WARN_ON(!(qc->flags & ATA_QCFLAG_ACTIVE));
-	if (qc->flags & ATA_QCFLAG_ACTIVE) {
-		qc->err_mask |= AC_ERR_TIMEOUT;
-		ata_eh_qc_complete(qc);
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
