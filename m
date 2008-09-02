Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYIBS2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYIBS2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYIBS2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:28:38 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:9922 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbYIBS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :content-type:content-transfer-encoding:message-id;
        b=OyOKum9DCIqmkUDjZ9eImqTm7WGf/0cYi5YyxoNorHwUGP3DKqElJD8vBsmQfbJ+p+
         uJG4ENSkPkfvmWPcoAkAdl58nxwQXttSr9lhyP957hcWsRwvmBzc9guVUU8BhOiCRBbp
         CbXHflLKbb/2L1RNEI+AELY04D2U0HeRGbn1I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 2 Sep 2008 20:24:13 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200809022024.14226.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/Kconfig           |   16 +---------------
 drivers/ide/arm/palm_bk3710.c |    8 +++-----
 drivers/ide/ide-disk.c        |   14 --------------
 include/linux/ide.h           |    5 ++---
 4 files changed, 6 insertions(+), 37 deletions(-)


Bartlomiej Zolnierkiewicz (3):
      ide: fix hwif_to_node()
      ide-disk: remove stale init_idedisk_capacity() documentation
      ide/Kconfig: mark ide-scsi as deprecated

David Brownell (1):
      palm_bk3710: improve IDE registration

Kevin Hilman (2):
      IDE: compile fix for sff_dma_ops
      IDE: palm_bk3710: fix compile warning for unused variable


diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index a34758d..fc735ab 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -242,7 +242,7 @@ config BLK_DEV_IDEFLOPPY
 	  module will be called ide-floppy.
 
 config BLK_DEV_IDESCSI
-	tristate "SCSI emulation support"
+	tristate "SCSI emulation support (DEPRECATED)"
 	depends on SCSI
 	select IDE_ATAPI
 	---help---
@@ -255,20 +255,6 @@ config BLK_DEV_IDESCSI
 	  and will allow you to use a SCSI device driver instead of a native
 	  ATAPI driver.
 
-	  This is useful if you have an ATAPI device for which no native
-	  driver has been written (for example, an ATAPI PD-CD drive);
-	  you can then use this emulation together with an appropriate SCSI
-	  device driver. In order to do this, say Y here and to "SCSI support"
-	  and "SCSI generic support", below. You must then provide the kernel
-	  command line "hdx=ide-scsi" (try "man bootparam" or see the
-	  documentation of your boot loader (lilo or loadlin) about how to
-	  pass options to the kernel at boot time) for devices if you want the
-	  native EIDE sub-drivers to skip over the native support, so that
-	  this SCSI emulation can be used instead.
-
-	  Note that this option does NOT allow you to attach SCSI devices to a
-	  box that doesn't have a SCSI host adapter installed.
-
 	  If both this SCSI emulation and native ATAPI support are compiled
 	  into the kernel, the native support will be used.
 
diff --git a/drivers/ide/arm/palm_bk3710.c b/drivers/ide/arm/palm_bk3710.c
index f788fa5..4fd91dc 100644
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -343,11 +343,10 @@ static struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.mwdma_mask		= ATA_MWDMA2,
 };
 
-static int __devinit palm_bk3710_probe(struct platform_device *pdev)
+static int __init palm_bk3710_probe(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct resource *mem, *irq;
-	struct ide_host *host;
 	unsigned long base, rate;
 	int i, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
@@ -390,6 +389,7 @@ static int __devinit palm_bk3710_probe(struct platform_device *pdev)
 		hw.io_ports_array[i] = base + IDE_PALM_ATA_PRI_REG_OFFSET + i;
 	hw.io_ports.ctl_addr = base + IDE_PALM_ATA_PRI_CTL_OFFSET;
 	hw.irq = irq->start;
+	hw.dev = &pdev->dev;
 	hw.chipset = ide_palm3710;
 
 	palm_bk3710_port_info.udma_mask = rate < 100000000 ? ATA_UDMA4 :
@@ -413,13 +413,11 @@ static struct platform_driver platform_bk_driver = {
 		.name = "palm_bk3710",
 		.owner = THIS_MODULE,
 	},
-	.probe = palm_bk3710_probe,
-	.remove = NULL,
 };
 
 static int __init palm_bk3710_init(void)
 {
-	return platform_driver_register(&platform_bk_driver);
+	return platform_driver_probe(&platform_bk_driver, palm_bk3710_probe);
 }
 
 module_init(palm_bk3710_init);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 68b9cf0..07ef88b 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -445,20 +445,6 @@ static void idedisk_check_hpa(ide_drive_t *drive)
 	}
 }
 
-/*
- * Compute drive->capacity, the full capacity of the drive
- * Called with drive->id != NULL.
- *
- * To compute capacity, this uses either of
- *
- *    1. CHS value set by user       (whatever user sets will be trusted)
- *    2. LBA value from target drive (require new ATA feature)
- *    3. LBA value from system BIOS  (new one is OK, old one may break)
- *    4. CHS value from system BIOS  (traditional style)
- *
- * in above order (i.e., if value of higher priority is available,
- * reset will be ignored).
- */
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 87c12ed..1524829 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1111,7 +1111,6 @@ void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 int ide_pci_set_master(struct pci_dev *, const char *);
 unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
-extern const struct ide_dma_ops sff_dma_ops;
 int ide_pci_check_simplex(ide_hwif_t *, const struct ide_port_info *);
 int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
@@ -1275,6 +1274,7 @@ extern int __ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
 extern void ide_dma_lost_irq(ide_drive_t *);
 extern void ide_dma_timeout(ide_drive_t *);
+extern const struct ide_dma_ops sff_dma_ops;
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
 #else
@@ -1448,8 +1448,7 @@ static inline void ide_dump_identify(u8 *id)
 
 static inline int hwif_to_node(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
+	return hwif->dev ? dev_to_node(hwif->dev) : -1;
 }
 
 static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
