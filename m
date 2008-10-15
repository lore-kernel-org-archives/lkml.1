Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYJOT6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYJOT6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYJOT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:58:09 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:62046 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYJOT6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=v/EPJydDxfTbOTK1PiCUveQbIpQY2m6riiDdl6gQ04Hv0/qpjMvR9V4Dn0L+H+3sWT
         E1gq71Vu35T0uk21IYAfoQG8DddgHnDJgmcFeRe0lfQBDwz/UEVP7AyRLQUKsXqFd37D
         /vqx5tV2iE5Qd24qoc5PFrlHl9IWUf8tDeYC4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove broken hpt34x driver
Date: Wed, 15 Oct 2008 21:56:25 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152156.25754.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No big loss since HPT343/363 controllers are properly supported
by pata_hpt3x3 driver from Alan Cox.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig      |   24 -----
 drivers/ide/pci/Makefile |    1 
 drivers/ide/pci/hpt34x.c |  193 -----------------------------------------------
 3 files changed, 1 insertion(+), 217 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -328,7 +328,7 @@ config IDEPCI_PCIBUS_ORDER
 # TODO: split it on per host driver config options (or module parameters)
 config BLK_DEV_OFFBOARD
 	bool "Boot off-board chipsets first support (DEPRECATED)"
-	depends on BLK_DEV_IDEPCI && (BLK_DEV_AEC62XX || BLK_DEV_GENERIC || BLK_DEV_HPT34X || BLK_DEV_HPT366 || BLK_DEV_PDC202XX_NEW || BLK_DEV_PDC202XX_OLD || BLK_DEV_TC86C001)
+	depends on BLK_DEV_IDEPCI && (BLK_DEV_AEC62XX || BLK_DEV_GENERIC || BLK_DEV_HPT366 || BLK_DEV_PDC202XX_NEW || BLK_DEV_PDC202XX_OLD || BLK_DEV_TC86C001)
 	help
 	  Normally, IDE controllers built into the motherboard (on-board
 	  controllers) are assigned to ide0 and ide1 while those on add-in PCI
@@ -478,28 +478,6 @@ config BLK_DEV_CS5535
 
 	  It is safe to say Y to this question.
 
-config BLK_DEV_HPT34X
-	tristate "HPT34X chipset support"
-	depends on BROKEN
-	select BLK_DEV_IDEDMA_PCI
-	help
-	  This driver adds up to 4 more EIDE devices sharing a single
-	  interrupt. The HPT343 chipset in its current form is a non-bootable
-	  controller; the HPT345/HPT363 chipset is a bootable (needs BIOS FIX)
-	  PCI UDMA controllers. This driver requires dynamic tuning of the
-	  chipset during the ide-probe at boot time. It is reported to support
-	  DVD II drives, by the manufacturer.
-
-config HPT34X_AUTODMA
-	bool "HPT34X AUTODMA support (EXPERIMENTAL)"
-	depends on BLK_DEV_HPT34X && EXPERIMENTAL
-	help
-	  This is a dangerous thing to attempt currently! Please read the
-	  comments at the top of <file:drivers/ide/pci/hpt34x.c>.  If you say Y
-	  here, then say Y to "Use DMA by default when available" as well.
-
-	  If unsure, say N.
-
 config BLK_DEV_HPT366
 	tristate "HPT36X/37X chipset support"
 	select BLK_DEV_IDEDMA_PCI
Index: b/drivers/ide/pci/Makefile
===================================================================
--- a/drivers/ide/pci/Makefile
+++ b/drivers/ide/pci/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_BLK_DEV_CS5535)		+= cs5535.
 obj-$(CONFIG_BLK_DEV_SC1200)		+= sc1200.o
 obj-$(CONFIG_BLK_DEV_CY82C693)		+= cy82c693.o
 obj-$(CONFIG_BLK_DEV_DELKIN)		+= delkin_cb.o
-obj-$(CONFIG_BLK_DEV_HPT34X)		+= hpt34x.o
 obj-$(CONFIG_BLK_DEV_HPT366)		+= hpt366.o
 obj-$(CONFIG_BLK_DEV_IT8213)		+= it8213.o
 obj-$(CONFIG_BLK_DEV_IT821X)		+= it821x.o
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ /dev/null
@@ -1,193 +0,0 @@
-/*
- * Copyright (C) 1998-2000	Andre Hedrick <andre@linux-ide.org>
- *
- * May be copied or modified under the terms of the GNU General Public License
- *
- *
- * 00:12.0 Unknown mass storage controller:
- * Triones Technologies, Inc.
- * Unknown device 0003 (rev 01)
- *
- * hde: UDMA 2 (0x0000 0x0002) (0x0000 0x0010)
- * hdf: UDMA 2 (0x0002 0x0012) (0x0010 0x0030)
- * hde: DMA 2  (0x0000 0x0002) (0x0000 0x0010)
- * hdf: DMA 2  (0x0002 0x0012) (0x0010 0x0030)
- * hdg: DMA 1  (0x0012 0x0052) (0x0030 0x0070)
- * hdh: DMA 1  (0x0052 0x0252) (0x0070 0x00f0)
- *
- * ide-pci.c reference
- *
- * Since there are two cards that report almost identically,
- * the only discernable difference is the values reported in pcicmd.
- * Booting-BIOS card or HPT363 :: pcicmd == 0x07
- * Non-bootable card or HPT343 :: pcicmd == 0x05
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/ioport.h>
-#include <linux/interrupt.h>
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/ide.h>
-
-#define DRV_NAME "hpt34x"
-
-#define HPT343_DEBUG_DRIVE_INFO		0
-
-static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
-{
-	struct pci_dev *dev = to_pci_dev(drive->hwif->dev);
-	u32 reg1= 0, tmp1 = 0, reg2 = 0, tmp2 = 0;
-	u8			hi_speed, lo_speed;
-
-	hi_speed = speed >> 4;
-	lo_speed = speed & 0x0f;
-
-	if (hi_speed & 7) {
-		hi_speed = (hi_speed & 4) ? 0x01 : 0x10;
-	} else {
-		lo_speed <<= 5;
-		lo_speed >>= 5;
-	}
-
-	pci_read_config_dword(dev, 0x44, &reg1);
-	pci_read_config_dword(dev, 0x48, &reg2);
-	tmp1 = ((lo_speed << (3*drive->dn)) | (reg1 & ~(7 << (3*drive->dn))));
-	tmp2 = ((hi_speed << drive->dn) | (reg2 & ~(0x11 << drive->dn)));
-	pci_write_config_dword(dev, 0x44, tmp1);
-	pci_write_config_dword(dev, 0x48, tmp2);
-
-#if HPT343_DEBUG_DRIVE_INFO
-	printk("%s: %s drive%d (0x%04x 0x%04x) (0x%04x 0x%04x)" \
-		" (0x%02x 0x%02x)\n",
-		drive->name, ide_xfer_verbose(speed),
-		drive->dn, reg1, tmp1, reg2, tmp2,
-		hi_speed, lo_speed);
-#endif /* HPT343_DEBUG_DRIVE_INFO */
-}
-
-static void hpt34x_set_pio_mode(ide_drive_t *drive, const u8 pio)
-{
-	hpt34x_set_mode(drive, XFER_PIO_0 + pio);
-}
-
-/*
- * If the BIOS does not set the IO base addaress to XX00, 343 will fail.
- */
-#define	HPT34X_PCI_INIT_REG		0x80
-
-static unsigned int init_chipset_hpt34x(struct pci_dev *dev)
-{
-	int i = 0;
-	unsigned long hpt34xIoBase = pci_resource_start(dev, 4);
-	unsigned long hpt_addr[4] = { 0x20, 0x34, 0x28, 0x3c };
-	unsigned long hpt_addr_len[4] = { 7, 3, 7, 3 };
-	u16 cmd;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	pci_write_config_byte(dev, HPT34X_PCI_INIT_REG, 0x00);
-	pci_read_config_word(dev, PCI_COMMAND, &cmd);
-
-	if (cmd & PCI_COMMAND_MEMORY)
-		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0xF0);
-	else
-		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
-
-	/*
-	 * Since 20-23 can be assigned and are R/W, we correct them.
-	 */
-	pci_write_config_word(dev, PCI_COMMAND, cmd & ~PCI_COMMAND_IO);
-	for(i=0; i<4; i++) {
-		dev->resource[i].start = (hpt34xIoBase + hpt_addr[i]);
-		dev->resource[i].end = dev->resource[i].start + hpt_addr_len[i];
-		dev->resource[i].flags = IORESOURCE_IO;
-		pci_write_config_dword(dev,
-				(PCI_BASE_ADDRESS_0 + (i * 4)),
-				dev->resource[i].start);
-	}
-	pci_write_config_word(dev, PCI_COMMAND, cmd);
-
-	local_irq_restore(flags);
-
-	return dev->irq;
-}
-
-static const struct ide_port_ops hpt34x_port_ops = {
-	.set_pio_mode		= hpt34x_set_pio_mode,
-	.set_dma_mode		= hpt34x_set_mode,
-};
-
-#define IDE_HFLAGS_HPT34X \
-	(IDE_HFLAG_NO_ATAPI_DMA | \
-	 IDE_HFLAG_NO_DSC | \
-	 IDE_HFLAG_NO_AUTODMA)
-
-static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
-	{ /* 0: HPT343 */
-		.name		= DRV_NAME,
-		.init_chipset	= init_chipset_hpt34x,
-		.port_ops	= &hpt34x_port_ops,
-		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_NON_BOOTABLE,
-		.pio_mask	= ATA_PIO5,
-	},
-	{ /* 1: HPT345 */
-		.name		= DRV_NAME,
-		.init_chipset	= init_chipset_hpt34x,
-		.port_ops	= &hpt34x_port_ops,
-		.host_flags	= IDE_HFLAGS_HPT34X | IDE_HFLAG_OFF_BOARD,
-		.pio_mask	= ATA_PIO5,
-#ifdef CONFIG_HPT34X_AUTODMA
-		.swdma_mask	= ATA_SWDMA2,
-		.mwdma_mask	= ATA_MWDMA2,
-		.udma_mask	= ATA_UDMA2,
-#endif
-	}
-};
-
-static int __devinit hpt34x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	const struct ide_port_info *d;
-	u16 pcicmd = 0;
-
-	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
-
-	d = &hpt34x_chipsets[(pcicmd & PCI_COMMAND_MEMORY) ? 1 : 0];
-
-	return ide_pci_init_one(dev, d, NULL);
-}
-
-static const struct pci_device_id hpt34x_pci_tbl[] = {
-	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT343), 0 },
-	{ 0, },
-};
-MODULE_DEVICE_TABLE(pci, hpt34x_pci_tbl);
-
-static struct pci_driver hpt34x_pci_driver = {
-	.name		= "HPT34x_IDE",
-	.id_table	= hpt34x_pci_tbl,
-	.probe		= hpt34x_init_one,
-	.remove		= ide_pci_remove,
-	.suspend	= ide_pci_suspend,
-	.resume		= ide_pci_resume,
-};
-
-static int __init hpt34x_ide_init(void)
-{
-	return ide_pci_register_driver(&hpt34x_pci_driver);
-}
-
-static void __exit hpt34x_ide_exit(void)
-{
-	pci_unregister_driver(&hpt34x_pci_driver);
-}
-
-module_init(hpt34x_ide_init);
-module_exit(hpt34x_ide_exit);
-
-MODULE_AUTHOR("Andre Hedrick");
-MODULE_DESCRIPTION("PCI driver module for Highpoint 34x IDE");
-MODULE_LICENSE("GPL");
