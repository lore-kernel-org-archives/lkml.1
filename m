Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbXCSShp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbXCSShp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXCSShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:37:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40535 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030490AbXCSShn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:37:43 -0400
Date: Mon, 19 Mar 2007 14:37:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070319183741.GA17068@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig          |    2 +-
 drivers/ata/libata-core.c    |    2 +-
 drivers/ata/libata-eh.c      |    8 +++++++-
 drivers/ata/pata_ixp4xx_cf.c |    3 +--
 drivers/ata/sata_inic162x.c  |    4 ----
 drivers/ata/sata_sil24.c     |    1 +
 6 files changed, 11 insertions(+), 9 deletions(-)

Akira Iguchi (1):
      drivers/ata/Kconfig: PATA_SCC depends on wrong platform

Alessandro Zummo (1):
      pata_ixp4xx_cf: fix interrupt

Jamie Clark (1):
      sata_sil24: Add Adaptec 1220SA PCI ID

Randy Dunlap (1):
      libata: kernel-doc fix

Tejun Heo (3):
      libata: don't whine if ->prereset() returns -ENOENT
      sata_inic162x: kill double region requests
      pata_ixp4xx_cf: fix oops on detach

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index d16b5b0..7bdbe5a 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -564,7 +564,7 @@ config PATA_IXP4XX_CF
 
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
-	depends on PCI && PPC_IBM_CELL_BLADE
+	depends on PCI && PPC_CELLEB
 	help
 	  This option enables support for the built-in IDE controller on
 	  Toshiba Cell Reference Board.
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3c1f883..bf327d4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -826,7 +826,7 @@ static u64 ata_id_n_sectors(const u16 *id)
 /**
  *	ata_id_to_dma_mode	-	Identify DMA mode from id block
  *	@dev: device to identify
- *	@mode: mode to assume if we cannot tell
+ *	@unknown: mode to assume if we cannot tell
  *
  *	Set up the timing values for the device based upon the identify
  *	reported values for the DMA mode. This function is used by drivers
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7349c3d..361953a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1625,8 +1625,14 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 		rc = prereset(ap);
 		if (rc) {
 			if (rc == -ENOENT) {
-				ata_port_printk(ap, KERN_DEBUG, "port disabled. ignoring.\n");
+				ata_port_printk(ap, KERN_DEBUG,
+						"port disabled. ignoring.\n");
 				ap->eh_context.i.action &= ~ATA_EH_RESET_MASK;
+
+				for (i = 0; i < ATA_MAX_DEVICES; i++)
+					classes[i] = ATA_DEV_NONE;
+
+				rc = 0;
 			} else
 				ata_port_printk(ap, KERN_ERR,
 					"prereset failed (errno=%d)\n", rc);
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 9a0523b..c6f0e19 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -193,7 +193,7 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
-		set_irq_type(irq, IRQT_HIGH);
+		set_irq_type(irq, IRQT_RISING);
 
 	/* Setup expansion bus chip selects */
 	*data->cs0_cfg = data->cs0_bits;
@@ -232,7 +232,6 @@ static __devexit int ixp4xx_pata_remove(struct platform_device *dev)
 	struct ata_host *host = platform_get_drvdata(dev);
 
 	ata_host_detach(host);
-	platform_set_drvdata(dev, NULL);
 
 	return 0;
 }
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 3193a60..1e21688 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -672,10 +672,6 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = pci_request_regions(pdev, DRV_NAME);
-	if (rc)
-		return rc;
-
 	rc = pcim_iomap_regions(pdev, 0x3f, DRV_NAME);
 	if (rc)
 		return rc;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 75d9615..5614df8 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -346,6 +346,7 @@ static const struct pci_device_id sil24_pci_tbl[] = {
 	{ PCI_VDEVICE(CMD, 0x3124), BID_SIL3124 },
 	{ PCI_VDEVICE(INTEL, 0x3124), BID_SIL3124 },
 	{ PCI_VDEVICE(CMD, 0x3132), BID_SIL3132 },
+	{ PCI_VDEVICE(CMD, 0x0242), BID_SIL3132 },
 	{ PCI_VDEVICE(CMD, 0x3131), BID_SIL3131 },
 	{ PCI_VDEVICE(CMD, 0x3531), BID_SIL3131 },
 
