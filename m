Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbYBSAwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbYBSAwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbYBSAvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:51:07 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:23797 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYBSAvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xUEuC19OjiDlEvYvk4tJizx/MjVQqOzua2l6tG6RFtrBPoV5xqmnmjQji7QQrbT4Rz6uYcVcfTBYXs0AHw1I2A90rCpq6k/9UUC2s1AJVM3PmvMy72GYFbXa3gyVXa5nkucAQfBjfEnsKDDa7Kr4EYAxjfeled510wdbwjZ9Jok=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Tue, 19 Feb 2008 02:00:56 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802190200.57515.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This update fixes all known/open 2.6.25 IDE regressions + few other things:

- fix ide-cd cd/dvd burning regression (Kiyoshi Ueda)

- fix falconide/macide regressions (Geert Uytterhoeven)

- another device needs HPA workaround (Mikko Rapeli)

- ht6560b bugfixes (Jan Evert van Grootheest)

- new PCI id (used by Everex Cloudbook) for via82cxxx (Andrew Smith)


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 MAINTAINERS                    |    2 +-
 drivers/ata/libata-core.c      |    1 +
 drivers/ide/ide-cd.c           |    6 +++++-
 drivers/ide/ide-disk.c         |    1 +
 drivers/ide/ide-generic.c      |    6 ------
 drivers/ide/legacy/falconide.c |    4 +++-
 drivers/ide/legacy/ht6560b.c   |   25 +++++++++++++++++--------
 drivers/ide/legacy/macide.c    |    2 +-
 drivers/ide/pci/via82cxxx.c    |    1 +
 include/linux/Kbuild           |    2 +-
 include/linux/hdsmart.h        |    4 ++--
 include/linux/pci_ids.h        |    1 +
 12 files changed, 34 insertions(+), 21 deletions(-)


Andrew Smith (1):
      via82cxxx: add new PCI id for cx700

Bartlomiej Zolnierkiewicz (2):
      falconide: locking bugfix
      linux/hdsmart.h: fix goofups (take 2)

Borislav Petkov (1):
      MAINTAINERS: update ide-cd maintainer's email address

Geert Uytterhoeven (1):
      ide: Add missing base addresses for falconide and macide

Jan Evert van Grootheest (2):
      ht6560b can only do up to PIO mode 4
      ht6560b: force prefetch for some devices

Kiyoshi Ueda (1):
      ide-cd: fix missing residual count setting in DMA mode

Mikko Rapeli (1):
      ide/libata: ST310211A has buggy HPA too


diff --git a/MAINTAINERS b/MAINTAINERS
index 1d2edb4..082d1ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1924,7 +1924,7 @@ S:	Maintained
 
 IDE/ATAPI CDROM DRIVER
 P:	Borislav Petkov
-M:	bbpetkov@yahoo.de
+M:	petkovbb@gmail.com
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index beaa3a9..f46eb6f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4190,6 +4190,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices which report 1 sector over size HPA */
 	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
+	{ "ST310211A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 
 	/* Devices which get the IVB wrong */
 	{ "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 354c91d..310e497 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1207,9 +1207,13 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 end_request:
 	if (blk_pc_request(rq)) {
 		unsigned long flags;
+		unsigned int dlen = rq->data_len;
+
+		if (dma)
+			rq->data_len = 0;
 
 		spin_lock_irqsave(&ide_lock, flags);
-		if (__blk_end_request(rq, 0, rq->data_len))
+		if (__blk_end_request(rq, 0, dlen))
 			BUG();
 		HWGROUP(drive)->rq = NULL;
 		spin_unlock_irqrestore(&ide_lock, flags);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index aed8b31..8f5bed4 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -397,6 +397,7 @@ static inline int idedisk_supports_lba48(const struct hd_driveid *id)
 static const struct drive_list_entry hpa_list[] = {
 	{ "ST340823A",	NULL },
 	{ "ST320413A",	NULL },
+	{ "ST310211A",	NULL },
 	{ NULL,		NULL }
 };
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 709b9e4..9ebec08 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -17,9 +17,6 @@ static int __init ide_generic_init(void)
 	u8 idx[MAX_HWIFS];
 	int i;
 
-	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
-		ide_get_lock(NULL, NULL); /* for atari only */
-
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif = &ide_hwifs[i];
 
@@ -31,9 +28,6 @@ static int __init ide_generic_init(void)
 
 	ide_device_add_all(idx, NULL);
 
-	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
-		ide_release_lock();	/* for atari only */
-
 	return 0;
 }
 
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index f044048..8949ce7 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -54,7 +54,7 @@ static void __init falconide_setup_ports(hw_regs_t *hw)
 	for (i = 1; i < 8; i++)
 		hw->io_ports[i] = ATA_HD_BASE + 1 + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_CONTROL;
+	hw->io_ports[IDE_CONTROL_OFFSET] = ATA_HD_BASE + ATA_HD_CONTROL;
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
@@ -84,7 +84,9 @@ static int __init falconide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
+		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
+		ide_release_lock();
 	}
 
 	return 0;
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index 02d12c7..78ca68e 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -21,18 +21,21 @@
  *                      "Prefetch" mode bit OFF for ide disks and
  *                      ON for anything else.
  *
+ *  Version 0.08        Need to force prefetch for CDs and other non-disk
+ *                      devices. (not sure which devices exactly need
+ *                      prefetch)
  *
  *  HT-6560B EIDE-controller support
  *  To activate controller support use kernel parameter "ide0=ht6560b".
  *  Use hdparm utility to enable PIO mode support.
  *
  *  Author:    Mikko Ala-Fossi            <maf@iki.fi>
- *             Jan Evert van Grootheest   <janevert@iae.nl>
+ *             Jan Evert van Grootheest   <janevert@caiway.nl>
  *
  *  Try:  http://www.maf.iki.fi/~maf/ht6560b/
  */
 
-#define HT6560B_VERSION "v0.07"
+#define HT6560B_VERSION "v0.08"
 
 #include <linux/module.h>
 #include <linux/types.h>
@@ -130,15 +133,20 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 	u8 select, timing;
 	
 	local_irq_save(flags);
-	
+
 	select = HT_CONFIG(drive);
 	timing = HT_TIMING(drive);
-	
+
+	/*
+	 * Need to enforce prefetch sometimes because otherwise
+	 * it'll hang (hard).
+	 */
+	if (drive->media != ide_disk || !drive->present)
+		select |= HT_PREFETCH_MODE;
+
 	if (select != current_select || timing != current_timing) {
 		current_select = select;
 		current_timing = timing;
-		if (drive->media != ide_disk || !drive->present)
-			select |= HT_PREFETCH_MODE;
 		(void)inb(HT_CONFIG_PORT);
 		(void)inb(HT_CONFIG_PORT);
 		(void)inb(HT_CONFIG_PORT);
@@ -188,11 +196,12 @@ static int __init try_to_init_ht6560b(void)
 	outb(HT_TIMING_DEFAULT, 0x1f6);  /* IDE_SELECT_REG */
 	(void) inb(0x1f7);               /* IDE_STATUS_REG */
 	
-	printk("\nht6560b " HT6560B_VERSION
+	printk("ht6560b " HT6560B_VERSION
 	       ": chipset detected and initialized"
 #ifdef DEBUG
 	       " with debug enabled"
 #endif
+	       "\n"
 		);
 	return 1;
 }
@@ -323,7 +332,7 @@ static const struct ide_port_info ht6560b_port_info __initdata = {
 				  IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_NO_AUTOTUNE |
 				  IDE_HFLAG_ABUSE_PREFETCH,
-	.pio_mask		= ATA_PIO5,
+	.pio_mask		= ATA_PIO4,
 };
 
 static int __init ht6560b_init(void)
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index a61e607..9a79098 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -74,7 +74,7 @@ static void __init macide_setup_ports(hw_regs_t *hw, unsigned long base,
 	for (i = 0; i < 8; i++)
 		hw->io_ports[i] = base + i * 4;
 
-	hw->io_ports[IDE_CONTROL_OFFSET] = IDE_CONTROL;
+	hw->io_ports[IDE_CONTROL_OFFSET] = base + IDE_CONTROL;
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index f3f79f8..9004e75 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -479,6 +479,7 @@ static int __devinit via_init_one(struct pci_dev *dev, const struct pci_device_i
 static const struct pci_device_id via_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C576_1),  0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C586_1),  0 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_CX700_IDE), 0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6410),      1 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_SATA_EIDE), 1 },
 	{ 0, },
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 5cae9b5..aada32f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -70,7 +70,6 @@ header-y += fuse.h
 header-y += genetlink.h
 header-y += gen_stats.h
 header-y += gigaset_dev.h
-header-y += hdsmart.h
 header-y += hysdn_if.h
 header-y += i2o-dev.h
 header-y += i8k.h
@@ -211,6 +210,7 @@ unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
+unifdef-y += hdsmart.h
 unifdef-y += hiddev.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
diff --git a/include/linux/hdsmart.h b/include/linux/hdsmart.h
index e691921..4f4faf9 100644
--- a/include/linux/hdsmart.h
+++ b/include/linux/hdsmart.h
@@ -17,7 +17,7 @@
 #ifndef _LINUX_HDSMART_H
 #define _LINUX_HDSMART_H
 
-#ifndef __KERNEL
+#ifndef __KERNEL__
 #define OFFLINE_FULL_SCAN		0
 #define SHORT_SELF_TEST			1
 #define EXTEND_SELF_TEST		2
@@ -121,6 +121,6 @@ typedef struct ata_smart_selftestlog_s {
 	unsigned char			resevered[2];
 	unsigned char			chksum;
 } __attribute__ ((packed)) ata_smart_selftestlog_t;
-#endif /* __KERNEL__ *
+#endif /* __KERNEL__ */
 
 #endif	/* _LINUX_HDSMART_H */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index df6dd79..0519e53 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1351,6 +1351,7 @@
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
 #define PCI_DEVICE_ID_VIA_8365_1	0x8305
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
+#define PCI_DEVICE_ID_VIA_CX700_IDE	0x0581
 #define PCI_DEVICE_ID_VIA_VX800		0x8353
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
