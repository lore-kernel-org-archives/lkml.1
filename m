Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbXGCPwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbXGCPwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXGCPwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:52:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52864 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbXGCPwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:52:41 -0400
Date: Tue, 3 Jul 2007 11:52:38 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070703155238.GA7344@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_generic.c       |    2 +-
 drivers/ata/libata-core.c       |    6 +++---
 drivers/ata/libata-sff.c        |    5 +++--
 drivers/ata/pata_ali.c          |    8 ++++----
 drivers/ata/pata_cs5520.c       |    5 +++++
 drivers/ata/pata_pcmcia.c       |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    4 ++--
 drivers/ata/sata_mv.c           |    3 +++
 8 files changed, 22 insertions(+), 13 deletions(-)

Alan Cox (3):
      ata_generic: Check the right register for the DMA enabled flags
      pata_pdc202xx_old: Correct cable detect logic
      pata_pcmcia: Switch to ata_sff_port_start

Chuck Ebbert (1):
      pata_ali: fix UDMA settings

Florian Attenberger (1):
      sata_mv: PCI-ID for Adaptec 1430SA SATA Controller

Tejun Heo (1):
      libata: fix assigned IRQ reporting

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 7565f02..4c6e95c 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -50,7 +50,7 @@ static int generic_set_mode(struct ata_port *ap, struct ata_device **unused)
 
 	/* Bits 5 and 6 indicate if DMA is active on master/slave */
 	if (ap->ioaddr.bmdma_addr)
-		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2407f84..981b397 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6423,14 +6423,14 @@ int ata_host_activate(struct ata_host *host, int irq,
 	if (rc)
 		return rc;
 
+	/* Used to print device info at probe */
+	host->irq = irq;
+
 	rc = ata_host_register(host, sht);
 	/* if failed, just free the IRQ and leave ports alone */
 	if (rc)
 		devm_free_irq(host->dev, irq, host);
 
-	/* Used to print device info at probe */
-	host->irq = irq;
-
 	return rc;
 }
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index ce84805..fa1c22c 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1065,10 +1065,11 @@ int ata_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto err_out;
 
-	if (!legacy_mode)
+	if (!legacy_mode) {
 		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
 				      IRQF_SHARED, DRV_NAME, host);
-	else {
+		host->irq = pdev->irq;
+	} else {
 		irq_handler_t handler[2] = { host->ops->irq_handler,
 					     host->ops->irq_handler };
 		unsigned int irq_flags[2] = { IRQF_SHARED, IRQF_SHARED };
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 3c55a5f..75e95bd 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -550,22 +550,22 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = 0x1f,
 		.port_ops = &ali_c2_port_ops
 	};
-	/* Revision 0xC3 is UDMA100 */
+	/* Revision 0xC3 is UDMA66 for now */
 	static const struct ata_port_info info_c3 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
+		.udma_mask = 0x1f,
 		.port_ops = &ali_c2_port_ops
 	};
-	/* Revision 0xC4 is UDMA133 */
+	/* Revision 0xC4 is UDMA100 */
 	static const struct ata_port_info info_c4 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = 0x3f,
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 1aabe15..00cf013 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -284,6 +284,11 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 				      ata_interrupt, 0, DRV_NAME, host);
 		if (rc)
 			return rc;
+
+		if (i == 0)
+			host->irq = irq[0];
+		else
+			host->irq2 = irq[1];
 	}
 
 	return ata_host_register(host, &cs5520_sht);
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 4d44c75..a56257c 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -129,7 +129,7 @@ static struct ata_port_operations pcmcia_port_ops = {
 	.irq_on		= ata_irq_on,
 	.irq_ack	= ata_irq_ack,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 #define CS_CHECK(fn, ret) \
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index edbaf9d..d277246 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -31,8 +31,8 @@ static int pdc2026x_cable_detect(struct ata_port *ap)
 
 	pci_read_config_word(pdev, 0x50, &cis);
 	if (cis & (1 << (10 + ap->port_no)))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
 /**
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index c957e6e..590f2f9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -582,6 +582,9 @@ static const struct pci_device_id mv_pci_tbl[] = {
 
 	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
 
+	/* Adaptec 1430SA */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
+
 	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
 
 	/* add Marvell 7042 support */
