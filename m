Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZLTUpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZLTUpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZLTUpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:45:49 -0500
Received: from havoc.gtf.org ([69.61.125.42]:54072 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZLTUpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:45:49 -0500
Date: Sun, 20 Dec 2009 15:45:48 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20091220204548.GA28746@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/pata_cmd64x.c |  118 ++++-----------------------------------------
 1 files changed, 9 insertions(+), 109 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_cmd64x: fix overclocking of UDMA0-2 modes

Jeff Garzik (1):
      Revert "pata_cmd64x: implement serialization as per notes"

diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index dadfc35..0efb1f5 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.3.1"
+#define DRV_VERSION "0.2.5"
 
 /*
  * CMD64x specific registers definition.
@@ -219,7 +219,7 @@ static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
 		/* Merge the control bits */
 		regU |= 1 << adev->devno; /* UDMA on */
-		if (adev->dma_mode > 2)	/* 15nS timing */
+		if (adev->dma_mode > XFER_UDMA_2) /* 15nS timing */
 			regU |= 4 << adev->devno;
 	} else {
 		regU &= ~ (1 << adev->devno);	/* UDMA off */
@@ -254,109 +254,17 @@ static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
 }
 
 /**
- *	cmd64x_bmdma_stop	-	DMA stop callback
+ *	cmd646r1_dma_stop	-	DMA stop callback
  *	@qc: Command in progress
  *
- *	Track the completion of live DMA commands and clear the
- *	host->private_data DMA tracking flag as we do.
+ *	Stub for now while investigating the r1 quirk in the old driver.
  */
 
-static void cmd64x_bmdma_stop(struct ata_queued_cmd *qc)
+static void cmd646r1_bmdma_stop(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
 	ata_bmdma_stop(qc);
-	WARN_ON(ap->host->private_data != ap);
-	ap->host->private_data = NULL;
-}
-
-/**
- *	cmd64x_qc_defer		-	Defer logic for chip limits
- *	@qc: queued command
- *
- *	Decide whether we can issue the command. Called under the host lock.
- */
-
-static int cmd64x_qc_defer(struct ata_queued_cmd *qc)
-{
-	struct ata_host *host = qc->ap->host;
-	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
-	int rc;
-	int dma = 0;
-
-	/* Apply the ATA rules first */
-	rc = ata_std_qc_defer(qc);
-	if (rc)
-		return rc;
-
-	if (qc->tf.protocol == ATAPI_PROT_DMA ||
-			qc->tf.protocol == ATA_PROT_DMA)
-		dma = 1;
-
-	/* If the other port is not live then issue the command */
-	if (alt == NULL || !alt->qc_active) {
-		if (dma)
-			host->private_data = qc->ap;
-		return 0;
-	}
-	/* If there is a live DMA command then wait */
-	if (host->private_data != NULL)
-		return 	ATA_DEFER_PORT;
-	if (dma)
-		/* Cannot overlap our DMA command */
-		return ATA_DEFER_PORT;
-	return 0;
 }
 
-/**
- *	cmd64x_interrupt - ATA host interrupt handler
- *	@irq: irq line (unused)
- *	@dev_instance: pointer to our ata_host information structure
- *
- *	Our interrupt handler for PCI IDE devices.  Calls
- *	ata_sff_host_intr() for each port that is flagging an IRQ. We cannot
- *	use the defaults as we need to avoid touching status/altstatus during
- *	a DMA.
- *
- *	LOCKING:
- *	Obtains host lock during operation.
- *
- *	RETURNS:
- *	IRQ_NONE or IRQ_HANDLED.
- */
-irqreturn_t cmd64x_interrupt(int irq, void *dev_instance)
-{
-	struct ata_host *host = dev_instance;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
-	unsigned int i;
-	unsigned int handled = 0;
-	unsigned long flags;
-	static const u8 irq_reg[2] = { CFR, ARTTIM23 };
-	static const u8 irq_mask[2] = { 1 << 2, 1 << 4 };
-
-	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
-	spin_lock_irqsave(&host->lock, flags);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-		u8 reg;
-
-		pci_read_config_byte(pdev, irq_reg[i], &reg);
-		ap = host->ports[i];
-		if (ap && (reg & irq_mask[i]) &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
-
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-			    (qc->flags & ATA_QCFLAG_ACTIVE))
-				handled |= ata_sff_host_intr(ap, qc);
-		}
-	}
-
-	spin_unlock_irqrestore(&host->lock, flags);
-
-	return IRQ_RETVAL(handled);
-}
 static struct scsi_host_template cmd64x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -365,8 +273,6 @@ static const struct ata_port_operations cmd64x_base_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 	.set_piomode	= cmd64x_set_piomode,
 	.set_dmamode	= cmd64x_set_dmamode,
-	.bmdma_stop	= cmd64x_bmdma_stop,
-	.qc_defer	= cmd64x_qc_defer,
 };
 
 static struct ata_port_operations cmd64x_port_ops = {
@@ -376,6 +282,7 @@ static struct ata_port_operations cmd64x_port_ops = {
 
 static struct ata_port_operations cmd646r1_port_ops = {
 	.inherits	= &cmd64x_base_ops,
+	.bmdma_stop	= cmd646r1_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
 };
 
@@ -383,7 +290,6 @@ static struct ata_port_operations cmd648_port_ops = {
 	.inherits	= &cmd64x_base_ops,
 	.bmdma_stop	= cmd648_bmdma_stop,
 	.cable_detect	= cmd648_cable_detect,
-	.qc_defer	= ata_std_qc_defer
 };
 
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -432,7 +338,6 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
 	u8 mrdmode;
 	int rc;
-	struct ata_host *host;
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -450,25 +355,20 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			ppi[0] = &cmd_info[3];
 	}
 
-
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
 	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
 	mrdmode &= ~ 0x30;	/* IRQ set up */
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
+	/* Force PIO 0 here.. */
+
 	/* PPC specific fixup copied from old driver */
 #ifdef CONFIG_PPC
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
-	if (rc)
-		return rc;
-	/* We use this pointer to track the AP which has DMA running */
-	host->private_data = NULL;
 
-	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, cmd64x_interrupt, &cmd64x_sht);
+	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
 }
 
 #ifdef CONFIG_PM
