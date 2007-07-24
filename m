Return-Path: <linux-kernel-owner+w=401wt.eu-S933825AbXGXBOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbXGXBOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbXGXBOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:14:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53454 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbXGXBOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:14:07 -0400
Date: Mon, 23 Jul 2007 21:14:04 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, mlord@pobox.com
Subject: [PATCH] sata_qstor, pdc_adma, sata_sx4: convert to new EH
Message-ID: <20070724011404.GA14064@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is just a refresh of the existing libata-dev.git#new-eh patches
that convert all remaining old-EH drivers to new EH, against 2.6.23-rc1.

All three conversions are completely untested.  pdc_adma and sata_qstor
need reviewing by someone with docs, in addition to testing.

Even "it still works" or "this patch breaks stuff" feedback from users
is useful.

	Jeff




commit 99ad0b4cd2d73815db6370fa6f89d7053ca21016
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon May 28 06:21:45 2007 -0400

    [libata] sata_sx4: convert to new EH
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 9b105869fb953485ff7e7a8f9bb9f3dcae8aa502
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat May 26 19:48:07 2007 -0400

    [libata] sata_qstor: rough draft conversion to new libata EH
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 1a9161f86ef2ae955267c78f1c16273cad4fdbb4
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Jul 6 19:28:32 2007 -0400

    [libata] pdc_adma: rough draft conversion to new-EH
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/pdc_adma.c   |   82 ++++++++++++++++++++++++++++++++--------
 drivers/ata/sata_qstor.c |   65 +++++++++++++++++++++++--------
 drivers/ata/sata_sx4.c   |   96 +++++++++++++++++++++++++++++------------------
 3 files changed, 174 insertions(+), 69 deletions(-)

diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index bec1de5..bf4dba0 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -92,6 +92,8 @@ enum {
 
 	/* CPB bits */
 	cDONE			= (1 << 0),
+	cATERR			= (1 << 3),
+
 	cVLD			= (1 << 0),
 	cDAT			= (1 << 2),
 	cIEN			= (1 << 3),
@@ -131,14 +133,15 @@ static int adma_ata_init_one (struct pci_dev *pdev,
 static int adma_port_start(struct ata_port *ap);
 static void adma_host_stop(struct ata_host *host);
 static void adma_port_stop(struct ata_port *ap);
-static void adma_phy_reset(struct ata_port *ap);
 static void adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int adma_qc_issue(struct ata_queued_cmd *qc);
 static int adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void adma_bmdma_stop(struct ata_queued_cmd *qc);
 static u8 adma_bmdma_status(struct ata_port *ap);
 static void adma_irq_clear(struct ata_port *ap);
-static void adma_eng_timeout(struct ata_port *ap);
+static void adma_freeze(struct ata_port *ap);
+static void adma_thaw(struct ata_port *ap);
+static void adma_error_handler(struct ata_port *ap);
 
 static struct scsi_host_template adma_ata_sht = {
 	.module			= THIS_MODULE,
@@ -165,12 +168,13 @@ static const struct ata_port_operations adma_ata_ops = {
 	.exec_command		= ata_exec_command,
 	.check_status		= ata_check_status,
 	.dev_select		= ata_std_dev_select,
-	.phy_reset		= adma_phy_reset,
 	.check_atapi_dma	= adma_check_atapi_dma,
 	.data_xfer		= ata_data_xfer,
 	.qc_prep		= adma_qc_prep,
 	.qc_issue		= adma_qc_issue,
-	.eng_timeout		= adma_eng_timeout,
+	.freeze			= adma_freeze,
+	.thaw			= adma_thaw,
+	.error_handler		= adma_error_handler,
 	.irq_clear		= adma_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
@@ -184,7 +188,7 @@ static const struct ata_port_operations adma_ata_ops = {
 static struct ata_port_info adma_port_info[] = {
 	/* board_1841_idx */
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST |
+		.flags		= ATA_FLAG_SLAVE_POSS |
 				  ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
 				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
@@ -273,24 +277,41 @@ static inline void adma_enter_reg_mode(struct ata_port *ap)
 	readb(chan + ADMA_STATUS);	/* flush */
 }
 
-static void adma_phy_reset(struct ata_port *ap)
+static void adma_freeze(struct ata_port *ap)
 {
-	struct adma_port_priv *pp = ap->private_data;
+	void __iomem *chan = ADMA_PORT_REGS(ap);
+
+	/* mask/clear ATA interrupts */
+	writeb(ATA_NIEN, ap->ioaddr.ctl_addr);
+	ata_check_status(ap);
+
+	/* reset ADMA to idle state */
+	writew(aPIOMD4 | aNIEN | aRSTADM, chan + ADMA_CONTROL);
+	udelay(2);
+	writew(aPIOMD4 | aNIEN, chan + ADMA_CONTROL);
+	udelay(2);
+}
 
-	pp->state = adma_state_idle;
+static void adma_thaw(struct ata_port *ap)
+{
 	adma_reinit_engine(ap);
-	ata_port_probe(ap);
-	ata_bus_reset(ap);
 }
 
-static void adma_eng_timeout(struct ata_port *ap)
+static int adma_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct adma_port_priv *pp = ap->private_data;
 
 	if (pp->state != adma_state_idle) /* healthy paranoia */
 		pp->state = adma_state_mmio;
 	adma_reinit_engine(ap);
-	ata_eng_timeout(ap);
+
+	return ata_std_prereset(ap, deadline);
+}
+
+static void adma_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, adma_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
 }
 
 static int adma_fill_sg(struct ata_queued_cmd *qc)
@@ -466,12 +487,31 @@ static inline unsigned int adma_intr_pkt(struct ata_host *host)
 			continue;
 		qc = ata_qc_from_tag(ap, ap->active_tag);
 		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-			if ((status & (aPERR | aPSD | aUIRQ)))
+			if (status & aPERR)
+				qc->err_mask |= AC_ERR_HOST_BUS;
+			else if ((status & (aPSD | aUIRQ)))
 				qc->err_mask |= AC_ERR_OTHER;
+
+			if (pp->pkt[0] & cATERR)
+				qc->err_mask |= AC_ERR_DEV;
 			else if (pp->pkt[0] != cDONE)
 				qc->err_mask |= AC_ERR_OTHER;
 
-			ata_qc_complete(qc);
+			if (!qc->err_mask)
+				ata_qc_complete(qc);
+			else {
+				struct ata_eh_info *ehi = &ap->eh_info;
+				ata_ehi_clear_desc(ehi);
+				ata_ehi_push_desc(ehi,
+					"ADMA-status 0x%02X", status);
+				ata_ehi_push_desc(ehi,
+					"pkt[0] 0x%02X", pp->pkt[0]);
+
+				if (qc->err_mask == AC_ERR_DEV)
+					ata_port_abort(ap);
+				else
+					ata_port_freeze(ap);
+			}
 		}
 	}
 	return handled;
@@ -502,7 +542,19 @@ static inline unsigned int adma_intr_mmio(struct ata_host *host)
 				/* complete taskfile transaction */
 				pp->state = adma_state_idle;
 				qc->err_mask |= ac_err_mask(status);
-				ata_qc_complete(qc);
+				if (!qc->err_mask)
+					ata_qc_complete(qc);
+				else {
+					struct ata_eh_info *ehi = &ap->eh_info;
+					ata_ehi_clear_desc(ehi);
+					ata_ehi_push_desc(ehi,
+						"status 0x%02X", status);
+
+					if (qc->err_mask == AC_ERR_DEV)
+						ata_port_abort(ap);
+					else
+						ata_port_freeze(ap);
+				}
 				handled = 1;
 			}
 		}
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c8f9242..15ded71 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -116,14 +116,15 @@ static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int qs_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
-static void qs_phy_reset(struct ata_port *ap);
 static void qs_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int qs_qc_issue(struct ata_queued_cmd *qc);
 static int qs_check_atapi_dma(struct ata_queued_cmd *qc);
 static void qs_bmdma_stop(struct ata_queued_cmd *qc);
 static u8 qs_bmdma_status(struct ata_port *ap);
 static void qs_irq_clear(struct ata_port *ap);
-static void qs_eng_timeout(struct ata_port *ap);
+static void qs_freeze(struct ata_port *ap);
+static void qs_thaw(struct ata_port *ap);
+static void qs_error_handler(struct ata_port *ap);
 
 static struct scsi_host_template qs_ata_sht = {
 	.module			= THIS_MODULE,
@@ -152,11 +153,12 @@ static const struct ata_port_operations qs_ata_ops = {
 	.check_atapi_dma	= qs_check_atapi_dma,
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
-	.phy_reset		= qs_phy_reset,
 	.qc_prep		= qs_qc_prep,
 	.qc_issue		= qs_qc_issue,
 	.data_xfer		= ata_data_xfer,
-	.eng_timeout		= qs_eng_timeout,
+	.freeze			= qs_freeze,
+	.thaw			= qs_thaw,
+	.error_handler		= qs_error_handler,
 	.irq_clear		= qs_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
@@ -172,8 +174,6 @@ static const struct ata_port_info qs_port_info[] = {
 	/* board_2068_idx */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_SATA_RESET |
-				  //FIXME ATA_FLAG_SRST |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
 		.udma_mask	= ATA_UDMA6,
@@ -236,23 +236,35 @@ static inline void qs_reset_channel_logic(struct ata_port *ap)
 	qs_enter_reg_mode(ap);
 }
 
-static void qs_phy_reset(struct ata_port *ap)
+static void qs_freeze(struct ata_port *ap)
 {
-	struct qs_port_priv *pp = ap->private_data;
+	u8 __iomem *mmio_base = qs_mmio_base(ap->host);
 
-	pp->state = qs_state_idle;
-	qs_reset_channel_logic(ap);
-	sata_phy_reset(ap);
+	writeb(0, mmio_base + QS_HCT_CTRL); /* disable host interrupts */
+}
+
+static void qs_thaw(struct ata_port *ap)
+{
+	u8 __iomem *mmio_base = qs_mmio_base(ap->host);
+
+	writeb(1, mmio_base + QS_HCT_CTRL); /* enable host interrupts */
 }
 
-static void qs_eng_timeout(struct ata_port *ap)
+static int qs_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct qs_port_priv *pp = ap->private_data;
 
 	if (pp->state != qs_state_idle) /* healthy paranoia */
 		pp->state = qs_state_mmio;
 	qs_reset_channel_logic(ap);
-	ata_eng_timeout(ap);
+
+	return ata_std_prereset(ap, deadline);
+}
+
+static void qs_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, qs_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
 }
 
 static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
@@ -361,7 +373,6 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
-
 		pp->state = qs_state_pkt;
 		qs_packet_start(qc);
 		return 0;
@@ -378,6 +389,26 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 	return ata_qc_issue_prot(qc);
 }
 
+static void qs_do_or_die(struct ata_queued_cmd *qc, u8 status)
+{
+	qc->err_mask |= ac_err_mask(status);
+
+	if (!qc->err_mask)
+		ata_qc_complete(qc);
+	else {
+		struct ata_port *ap = qc->ap;
+		struct ata_eh_info *ehi = &ap->eh_info;
+
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "status 0x%02X", status);
+
+		if (qc->err_mask == AC_ERR_DEV)
+			ata_port_abort(ap);
+		else
+			ata_port_freeze(ap);
+	}
+}
+
 static inline unsigned int qs_intr_pkt(struct ata_host *host)
 {
 	unsigned int handled = 0;
@@ -411,8 +442,7 @@ static inline unsigned int qs_intr_pkt(struct ata_host *host)
 					case 3: /* device error */
 						pp->state = qs_state_idle;
 						qs_enter_reg_mode(qc->ap);
-						qc->err_mask |= ac_err_mask(sDST);
-						ata_qc_complete(qc);
+						qs_do_or_die(qc, sDST);
 						break;
 					default:
 						break;
@@ -449,8 +479,7 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 
 				/* complete taskfile transaction */
 				pp->state = qs_state_idle;
-				qc->err_mask |= ac_err_mask(status);
-				ata_qc_complete(qc);
+				qs_do_or_die(qc, status);
 				handled = 1;
 			}
 		}
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 5193bd8..c4cdf95 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -213,8 +213,9 @@ struct pdc_host_priv {
 
 
 static int pdc_sata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
-static void pdc_eng_timeout(struct ata_port *ap);
-static void pdc_20621_phy_reset (struct ata_port *ap);
+static void pdc_error_handler(struct ata_port *ap);
+static void pdc_freeze(struct ata_port *ap);
+static void pdc_thaw(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
 static void pdc20621_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -260,11 +261,12 @@ static const struct ata_port_operations pdc_20621_ops = {
 	.check_status		= ata_check_status,
 	.exec_command		= pdc_exec_command_mmio,
 	.dev_select		= ata_std_dev_select,
-	.phy_reset		= pdc_20621_phy_reset,
 	.qc_prep		= pdc20621_qc_prep,
 	.qc_issue		= pdc20621_qc_issue_prot,
 	.data_xfer		= ata_data_xfer,
-	.eng_timeout		= pdc_eng_timeout,
+	.freeze			= pdc_freeze,
+	.thaw			= pdc_thaw,
+	.error_handler		= pdc_error_handler,
 	.irq_clear		= pdc20621_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
@@ -322,14 +324,6 @@ static int pdc_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static void pdc_20621_phy_reset (struct ata_port *ap)
-{
-	VPRINTK("ENTER\n");
-        ap->cbl = ATA_CBL_SATA;
-        ata_port_probe(ap);
-        ata_bus_reset(ap);
-}
-
 static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 				    	   unsigned int portno,
 					   unsigned int total_len)
@@ -870,40 +864,70 @@ static irqreturn_t pdc20621_interrupt (int irq, void *dev_instance)
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
+	/* FIXME: this should handle HDMA copy engine freezing */
 
-	spin_lock_irqsave(&host->lock, flags);
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp |= PDC_MASK_INT;
+	tmp &= ~PDC_DMA_ENABLE;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-	qc = ata_qc_from_tag(ap, ap->active_tag);
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
+	/* FIXME: this should handle HDMA copy engine thawing */
 
-	default:
-		drv_stat = ata_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
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
+static void pdc_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		pdc_reset_port(ap);
+	
+	ata_do_eh(ap, ata_std_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
 }
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
