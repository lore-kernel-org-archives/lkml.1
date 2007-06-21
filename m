Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXFUAGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXFUAGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 20:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbXFUAGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 20:06:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49452 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbXFUAGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 20:06:44 -0400
Date: Wed, 20 Jun 2007 20:06:42 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070621000642.GA28972@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    2 +-
 drivers/ata/libata-core.c |    4 +++-
 drivers/ata/pata_amd.c    |    2 ++
 drivers/ata/pata_it821x.c |   13 ++++---------
 4 files changed, 10 insertions(+), 11 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_it821x: (partially) fix DMA in RAID mode

Henrik Kretzschmar (1):
      kerneldoc fix in libata

Peer Chen (1):
      PATA: Add the MCP73/77 support to PATA driver

Stas Sergeev (1):
      fix module_param mistake in it821x

Tejun Heo (2):
      libata: more NONCQ devices
      ahci: fix PORTS_IMPL override

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 545f330..ca5229d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -527,7 +527,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 
 	/* fixup zero port_map */
 	if (!port_map) {
-		port_map = (1 << ahci_nr_ports(hpriv->cap)) - 1;
+		port_map = (1 << ahci_nr_ports(cap)) - 1;
 		dev_printk(KERN_WARNING, &pdev->dev,
 			   "PORTS_IMPL is zero, forcing 0x%x\n", port_map);
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 047eabd..adfae9d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3659,7 +3659,7 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 
 /**
  *	ata_dev_reread_id - Re-read IDENTIFY data
- *	@adev: target ATA device
+ *	@dev: target ATA device
  *	@readid_flags: read ID flags
  *
  *	Re-read IDENTIFY page and make sure @dev is still attached to
@@ -3802,6 +3802,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
 	/* Drives which do spurious command completion */
 	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
+	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
+	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index b439351..a16f629 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -693,6 +693,8 @@ static const struct pci_device_id amd[] = {
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	8 },
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	8 },
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	8 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		9 },
 
 	{ },
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index b3456d7..dab4e7c 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -2,6 +2,7 @@
  * pata_it821x.c 	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
+ *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * based upon
  *
@@ -79,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.6"
+#define DRV_VERSION "0.3.7"
 
 struct it821x_dev
 {
@@ -460,14 +461,8 @@ static unsigned int it821x_passthru_qc_issue_prot(struct ata_queued_cmd *qc)
 
 static int it821x_smart_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
-	int dma_enabled = 0;
 	int i;
 
-	/* Bits 5 and 6 indicate if DMA is active on master/slave */
-	/* It is possible that BMDMA isn't allocated */
-	if (ap->ioaddr.bmdma_addr)
-		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 		if (ata_dev_enabled(dev)) {
@@ -476,7 +471,7 @@ static int it821x_smart_set_mode(struct ata_port *ap, struct ata_device **unused
 			dev->dma_mode = XFER_MW_DMA_0;
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
-			if (dma_enabled & (1 << (5 + i))) {
+			if (ata_id_has_dma(dev->id)) {
 				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
 				dev->xfer_mode = XFER_MW_DMA_0;
 				dev->xfer_shift = ATA_SHIFT_MWDMA;
@@ -799,7 +794,7 @@ MODULE_VERSION(DRV_VERSION);
 
 
 module_param_named(noraid, it8212_noraid, int, S_IRUGO);
-MODULE_PARM_DESC(it8212_noraid, "Force card into bypass mode");
+MODULE_PARM_DESC(noraid, "Force card into bypass mode");
 
 module_init(it821x_init);
 module_exit(it821x_exit);
