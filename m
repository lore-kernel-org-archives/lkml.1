Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXL0R3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXL0R3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 12:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXL0R2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 12:28:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:1399 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbXL0R20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 12:28:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=m4CQcDzGDagBEN5mLF5o0eFd9cgQiHvpKnu9sJWt7dr1OEHYDHbbt/tqAMLzrGuySj3BEQM6/XG5u6DeOA/x6AzfOcZZBmqKHGRNHnLy0qinxjfn+9DXBG/GAghkzzmbt4yzQrWwtyWYzoj1czSdYkmf5A0QoQPUN2h/KL9uBMA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: add IDE_HFLAG_CLEAR_SIMPLEX host flag
Date: Thu, 27 Dec 2007 18:37:08 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271837.08893.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rename 'simplex_stat' variable to 'dma_stat' in ide_get_or_set_dma_base().

* Factor out code for forcing host out of "simplex" mode from
  ide_get_or_set_dma_base() to ide_pci_clear_simplex() helper.

* Add IDE_HFLAG_CLEAR_SIMPLEX host flag and set it in alim15x3 (for M5229),
  amd74xx (for AMD 7409), cmd64x (for CMD643), generic (for Netcell) and
  serverworks (for CSB5) host drivers.

* Make ide_get_or_set_dma_base() test for IDE_HFLAG_CLEAR_SIMPLEX host flag
  instead of checking dev->device (BTW the code was buggy because it didn't
  check for dev->vendor, luckily none of these PCI Device IDs was used by
  some other vendor for PCI IDE controller).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c    |    7 ++-
 drivers/ide/pci/amd74xx.c     |    1 
 drivers/ide/pci/cmd64x.c      |    4 +-
 drivers/ide/pci/generic.c     |    3 +
 drivers/ide/pci/serverworks.c |    4 +-
 drivers/ide/setup-pci.c       |   77 ++++++++++++++++++------------------------
 include/linux/ide.h           |    2 +
 7 files changed, 49 insertions(+), 49 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -775,7 +775,7 @@ static int __devinit alim15x3_init_one(s
 	};
 
 	struct ide_port_info d = ali15x3_chipset;
-	u8 rev = dev->revision;
+	u8 rev = dev->revision, idx = id->driver_data;
 
 	if (pci_dev_present(ati_rs100))
 		printk(KERN_WARNING "alim15x3: ATI Radeon IGP Northbridge is not yet fully tested.\n");
@@ -798,6 +798,9 @@ static int __devinit alim15x3_init_one(s
 			d.udma_mask = ATA_UDMA6;
 	}
 
+	if (idx == 0)
+		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
+
 #if defined(CONFIG_SPARC64)
 	d.init_hwif = init_hwif_common_ali15x3;
 #endif /* CONFIG_SPARC64 */
@@ -807,7 +810,7 @@ static int __devinit alim15x3_init_one(s
 
 static const struct pci_device_id alim15x3_pci_tbl[] = {
 	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5229), 0 },
-	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5228), 0 },
+	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5228), 1 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, alim15x3_pci_tbl);
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -295,6 +295,7 @@ static int __devinit amd74xx_probe(struc
 	if (idx == 1) {
 		if (dev->revision <= 7)
 			d.swdma_mask = 0;
+		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
 	} else if (idx == 4) {
 		if (dev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
 		    dev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -443,7 +443,9 @@ static const struct ide_port_info cmd64x
 		.init_chipset	= init_chipset_cmd64x,
 		.init_hwif	= init_hwif_cmd64x,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
-		.host_flags	= IDE_HFLAG_ABUSE_PREFETCH | IDE_HFLAG_BOOTABLE,
+		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
+				  IDE_HFLAG_ABUSE_PREFETCH |
+				  IDE_HFLAG_BOOTABLE,
 		.pio_mask	= ATA_PIO5,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= 0x00, /* no udma */
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -104,7 +104,8 @@ static const struct ide_port_info generi
 
 	{	/* 14 */
 		.name		= "Revolution",
-		.host_flags	= IDE_HFLAG_TRUST_BIOS_FOR_DMA |
+		.host_flags	= IDE_HFLAG_CLEAR_SIMPLEX |
+				  IDE_HFLAG_TRUST_BIOS_FOR_DMA |
 				  IDE_HFLAG_OFF_BOARD,
 		.swdma_mask	= ATA_SWDMA2,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -418,7 +418,9 @@ static int __devinit svwks_init_one(stru
 
 	d = serverworks_chipsets[idx];
 
-	if (idx == 2 || idx == 3) {
+	if (idx == 1)
+		d.host_flags |= IDE_HFLAG_CLEAR_SIMPLEX;
+	else if (idx == 2 || idx == 3) {
 		if ((PCI_FUNC(dev->devfn) & 1) == 0) {
 			if (pci_resource_start(dev, 0) != 0x01f1)
 				d.host_flags &= ~IDE_HFLAG_BOOTABLE;
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -140,6 +140,16 @@ static int ide_setup_pci_baseregs (struc
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+static void ide_pci_clear_simplex(unsigned long dma_base, const char *name)
+{
+	u8 dma_stat = inb(dma_base + 2);
+
+	outb(dma_stat & 0x60, dma_base + 2);
+	dma_stat = inb(dma_base + 2);
+	if (dma_stat & 0x80)
+		printk(KERN_INFO "%s: simplex device: DMA forced\n", name);
+}
+
 /**
  *	ide_get_or_set_dma_base		-	setup BMIBA
  *	@d: IDE port info
@@ -154,6 +164,7 @@ static unsigned long ide_get_or_set_dma_
 {
 	unsigned long	dma_base = 0;
 	struct pci_dev	*dev = hwif->pci_dev;
+	u8 dma_stat = 0;
 
 	if (hwif->mmio)
 		return hwif->dma_base;
@@ -174,52 +185,30 @@ static unsigned long ide_get_or_set_dma_
 	if (hwif->channel)
 		dma_base += 8;
 
-	if ((d->host_flags & IDE_HFLAG_CS5520) == 0) {
-		u8 simplex_stat = 0;
+	if (d->host_flags & IDE_HFLAG_CS5520)
+		goto out;
 
-		switch(dev->device) {
-			case PCI_DEVICE_ID_AL_M5219:
-			case PCI_DEVICE_ID_AL_M5229:
-			case PCI_DEVICE_ID_AMD_VIPER_7409:
-			case PCI_DEVICE_ID_CMD_643:
-			case PCI_DEVICE_ID_SERVERWORKS_CSB5IDE:
-			case PCI_DEVICE_ID_REVOLUTION:
-				simplex_stat = inb(dma_base + 2);
-				outb(simplex_stat & 0x60, dma_base + 2);
-				simplex_stat = inb(dma_base + 2);
-				if (simplex_stat & 0x80) {
-					printk(KERN_INFO "%s: simplex device: "
-							 "DMA forced\n",
-							 d->name);
-				}
-				break;
-			default:
-				/*
-				 * If the device claims "simplex" DMA,
-				 * this means only one of the two interfaces
-				 * can be trusted with DMA at any point in time.
-				 * So we should enable DMA only on one of the
-				 * two interfaces.
-				 */
-				simplex_stat = hwif->INB(dma_base + 2);
-				if (simplex_stat & 0x80) {
-					/* simplex device? */
-/*
- *	At this point we haven't probed the drives so we can't make the
- *	appropriate decision. Really we should defer this problem
- *	until we tune the drive then try to grab DMA ownership if we want
- *	to be the DMA end. This has to be become dynamic to handle hot
- *	plug.
- */
-					if (hwif->mate && hwif->mate->dma_base) {
-						printk(KERN_INFO "%s: simplex device: "
-								 "DMA disabled\n",
-								 d->name);
-						dma_base = 0;
-					}
-				}
-		}
+	if (d->host_flags & IDE_HFLAG_CLEAR_SIMPLEX) {
+		ide_pci_clear_simplex(dma_base, d->name);
+		goto out;
 	}
+
+	/*
+	 * If the device claims "simplex" DMA, this means that only one of
+	 * the two interfaces can be trusted with DMA at any point in time
+	 * (so we should enable DMA only on one of the two interfaces).
+	 *
+	 * FIXME: At this point we haven't probed the drives so we can't make
+	 * the appropriate decision.  Really we should defer this problem until
+	 * we tune the drive then try to grab DMA ownership if we want to be
+	 * the DMA end.  This has to be become dynamic to handle hot-plug.
+	 */
+	dma_stat = hwif->INB(dma_base + 2);
+	if ((dma_stat & 0x80) && hwif->mate && hwif->mate->dma_base) {
+		printk(KERN_INFO "%s: simplex device: DMA disabled\n", d->name);
+		dma_base = 0;
+	}
+out:
 	return dma_base;
 }
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1096,6 +1096,8 @@ enum {
 	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
 	/* host is CY82C693 */
 	IDE_HFLAG_CY82C693		= (1 << 27),
+	/* force host out of "simplex" mode */
+	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
