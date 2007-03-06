Return-Path: <linux-kernel-owner+w=401wt.eu-S934003AbXCFJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934003AbXCFJR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXCFJR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:17:28 -0500
Received: from havoc.gtf.org ([69.61.125.42]:48531 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934003AbXCFJRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:17:25 -0500
Date: Tue, 6 Mar 2007 04:17:24 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070306091724.GA17523@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There were some bumps, but I'm surprised at the lack of ACPI problem
reports.  It did live in -mm for many months, but nonetheless...  we'll
see how 2.6.21 release goes.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c              |    1 +
 drivers/ata/pata_legacy.c       |    2 +-
 drivers/ata/pata_pdc202xx_old.c |   22 ++++++++++++++--------
 3 files changed, 16 insertions(+), 9 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_pdc202xx_old: fix data corruption and other problems

Jason Gaston (1):
      ahci: RAID mode SATA patch for Intel ICH9M

Mikael Pettersson (1):
      pata_legacy: fix io/irq mismatch

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 43cc43d..dc7b562 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -389,6 +389,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x2929), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x292a), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x292b), board_ahci_pi }, /* ICH9M */
+	{ PCI_VDEVICE(INTEL, 0x292c), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index fc5b73d..86fbcd6 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -69,7 +69,7 @@
 #define NR_HOST 6
 
 static int legacy_port[NR_HOST] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
-static int legacy_irq[NR_HOST] = { 15, 14, 11, 10, 8, 12 };
+static int legacy_irq[NR_HOST] = { 14, 15, 11, 10, 8, 12 };
 
 struct legacy_data {
 	unsigned long timing;
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 3fb4177..acdc52c 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,13 +2,14 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
+ *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
  * First cut with LBA48/ATAPI
  *
  * TODO:
- *	Channel interlock/reset on both required ?
+ *	Channel interlock/reset on both required
  */
 
 #include <linux/kernel.h>
@@ -21,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_pdc202xx_old"
-#define DRV_VERSION "0.3.0"
+#define DRV_VERSION "0.4.0"
 
 /**
  *	pdc2024x_pre_reset		-	probe begin
@@ -76,7 +77,7 @@ static void pdc2026x_error_handler(struct ata_port *ap)
 static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *adev, int pio)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 4 * ap->port_no + 2 * adev->devno;
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u16 pio_timing[5] = {
 		0x0913, 0x050C , 0x0308, 0x0206, 0x0104
 	};
@@ -85,7 +86,7 @@ static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *a
 	pci_read_config_byte(pdev, port, &r_ap);
 	pci_read_config_byte(pdev, port + 1, &r_bp);
 	r_ap &= ~0x3F;	/* Preserve ERRDY_EN, SYNC_IN */
-	r_bp &= ~0x07;
+	r_bp &= ~0x1F;
 	r_ap |= (pio_timing[pio] >> 8);
 	r_bp |= (pio_timing[pio] & 0xFF);
 
@@ -123,7 +124,7 @@ static void pdc202xx_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 4 * ap->port_no + 2 * adev->devno;
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u8 udma_timing[6][2] = {
 		{ 0x60, 0x03 },	/* 33 Mhz Clock */
 		{ 0x40, 0x02 },
@@ -132,12 +133,17 @@ static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		{ 0x20, 0x01 },
 		{ 0x20, 0x01 }
 	};
+	static u8 mdma_timing[3][2] = {
+		{ 0x60, 0x03 },
+		{ 0x60, 0x04 },
+		{ 0xe0, 0x0f },
+	};
 	u8 r_bp, r_cp;
 
 	pci_read_config_byte(pdev, port + 1, &r_bp);
 	pci_read_config_byte(pdev, port + 2, &r_cp);
 
-	r_bp &= ~0xF0;
+	r_bp &= ~0xE0;
 	r_cp &= ~0x0F;
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
@@ -147,8 +153,8 @@ static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	} else {
 		int speed = adev->dma_mode - XFER_MW_DMA_0;
-		r_bp |= 0x60;
-		r_cp |= (5 - speed);
+		r_bp |= mdma_timing[speed][0];
+		r_cp |= mdma_timing[speed][1];
 	}
 	pci_write_config_byte(pdev, port + 1, r_bp);
 	pci_write_config_byte(pdev, port + 2, r_cp);
