Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbZEMUs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbZEMUs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761569AbZEMUrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:47:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57965 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761463AbZEMUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RWmjruwFLQAtnGeQCSHueaduG4skLhZGd1AEeJMwWA/VXMe2aZ21gfvFFqz6GWgIgG
         eaKA/VbsNpGKhwa4CUrDoCrDx5+NtOyn7AH+nlb3Q3kE0f+AOME85ZFWdnsX9Tt3BgjY
         TSXawekNbQgVJSLU0oT0F+AwwE6tCDdr1seOc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:52:15 +0200
Message-Id: <20090513205215.28638.80164.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/7] ide: remove chipset field from hw_regs_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Convert host drivers that still use hw_regs_t's chipset field to use
  the one in struct ide_port_info instead.

* Move special handling of ide_pci chipset type from ide_hw_configure()
  to ide_init_port().

* Remove chipset field from hw_regs_t.

While at it:
- remove stale comment in delkin_cb.c

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/at91_ide.c     |    2 +-
 drivers/ide/au1xxx-ide.c   |    2 +-
 drivers/ide/buddha.c       |    3 +--
 drivers/ide/cmd640.c       |    2 --
 drivers/ide/delkin_cb.c    |    2 +-
 drivers/ide/falconide.c    |    3 +--
 drivers/ide/gayle.c        |    3 +--
 drivers/ide/icside.c       |    3 ++-
 drivers/ide/ide-4drives.c  |    2 +-
 drivers/ide/ide-cs.c       |    2 +-
 drivers/ide/ide-generic.c  |    3 +--
 drivers/ide/ide-h8300.c    |    2 +-
 drivers/ide/ide-legacy.c   |    1 -
 drivers/ide/ide-pnp.c      |    2 +-
 drivers/ide/ide-probe.c    |    4 +---
 drivers/ide/ide_platform.c |    3 +--
 drivers/ide/macide.c       |    3 +--
 drivers/ide/palm_bk3710.c  |    2 +-
 drivers/ide/q40ide.c       |    3 +--
 drivers/ide/rapide.c       |    2 +-
 drivers/ide/scc_pata.c     |    2 +-
 drivers/ide/setup-pci.c    |    1 -
 drivers/ide/sgiioc4.c      |    1 -
 include/linux/ide.h        |    1 -
 24 files changed, 20 insertions(+), 34 deletions(-)

Index: b/drivers/ide/at91_ide.c
===================================================================
--- a/drivers/ide/at91_ide.c
+++ b/drivers/ide/at91_ide.c
@@ -216,6 +216,7 @@ static const struct ide_port_info at91_i
 	.host_flags 	= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA | IDE_HFLAG_SINGLE |
 			  IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_UNMASK_IRQS,
 	.pio_mask 	= ATA_PIO6,
+	.chipset	= ide_generic,
 };
 
 /*
@@ -304,7 +305,6 @@ static int __init at91_ide_probe(struct 
 		ide_std_init_ports(&hw, tf_base, ctl_base + 6);
 
 	hw.irq = board->irq_pin;
-	hw.chipset = ide_generic;
 	hw.dev = &pdev->dev;
 
 	host = ide_host_alloc(&at91_ide_port_info, hws);
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -499,6 +499,7 @@ static const struct ide_port_info au1xxx
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 	.mwdma_mask		= ATA_MWDMA2,
 #endif
+	.chipset		= ide_au1xxx,
 };
 
 static int au_ide_probe(struct platform_device *dev)
@@ -548,7 +549,6 @@ static int au_ide_probe(struct platform_
 	auide_setup_ports(&hw, ahwif);
 	hw.irq = ahwif->irq;
 	hw.dev = &dev->dev;
-	hw.chipset = ide_au1xxx;
 
 	ret = ide_host_add(&au1xxx_port_info, hws, &host);
 	if (ret)
Index: b/drivers/ide/buddha.c
===================================================================
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -139,13 +139,12 @@ static void __init buddha_setup_ports(hw
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info buddha_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
     /*
Index: b/drivers/ide/cmd640.c
===================================================================
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -762,11 +762,9 @@ static int __init cmd640x_init(void)
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
 	hw[0].irq = 14;
-	hw[0].chipset = ide_cmd640;
 
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
-	hw[1].chipset = ide_cmd640;
 
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
Index: b/drivers/ide/delkin_cb.c
===================================================================
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -68,6 +68,7 @@ static const struct ide_port_info delkin
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
 	.init_chipset		= delkin_cb_init_chipset,
+	.chipset		= ide_pci,
 };
 
 static int __devinit
@@ -97,7 +98,6 @@ delkin_cb_probe (struct pci_dev *dev, co
 	ide_std_init_ports(&hw, base + 0x10, base + 0x1e);
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
-	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
 	rc = ide_host_add(&delkin_cb_port_info, hws, &host);
 	if (rc)
Index: b/drivers/ide/falconide.c
===================================================================
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -111,6 +111,7 @@ static const struct ide_port_info falcon
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
 static void __init falconide_setup_ports(hw_regs_t *hw)
@@ -128,8 +129,6 @@ static void __init falconide_setup_ports
 
 	hw->irq = IRQ_MFP_IDE;
 	hw->ack_intr = NULL;
-
-	hw->chipset = ide_generic;
 }
 
     /*
Index: b/drivers/ide/gayle.c
===================================================================
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -106,14 +106,13 @@ static void __init gayle_setup_ports(hw_
 
 	hw->irq = IRQ_AMIGA_PORTS;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info gayle_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
     /*
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -398,11 +398,11 @@ static void icside_setup_ports(hw_regs_t
 
 	hw->irq = ec->irq;
 	hw->dev = &ec->dev;
-	hw->chipset = ide_acorn;
 }
 
 static const struct ide_port_info icside_v5_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_acorn,
 };
 
 static int __devinit
@@ -457,6 +457,7 @@ static const struct ide_port_info icside
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
+	.chipset		= ide_acorn,
 };
 
 static int __devinit
Index: b/drivers/ide/ide-4drives.c
===================================================================
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -25,6 +25,7 @@ static const struct ide_port_info ide_4d
 	.port_ops		= &ide_4drives_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_NO_DMA |
 				  IDE_HFLAG_4DRIVES,
+	.chipset		= ide_4drives,
 };
 
 static int __init ide_4drives_init(void)
@@ -52,7 +53,6 @@ static int __init ide_4drives_init(void)
 
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = 14;
-	hw.chipset = ide_4drives;
 
 	return ide_host_add(&ide_4drives_port_info, hws, NULL);
 }
Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -155,6 +155,7 @@ static const struct ide_port_info idecs_
 	.port_ops		= &idecs_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_pci,
 };
 
 static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
@@ -181,7 +182,6 @@ static struct ide_host *idecs_register(u
     memset(&hw, 0, sizeof(hw));
     ide_std_init_ports(&hw, io, ctl);
     hw.irq = irq;
-    hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
     rc = ide_host_add(&idecs_port_info, hws, &host);
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -29,6 +29,7 @@ MODULE_PARM_DESC(probe_mask, "probe mask
 
 static const struct ide_port_info ide_generic_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 #ifdef CONFIG_ARM
@@ -132,8 +133,6 @@ static int __init ide_generic_init(void)
 #else
 			hw.irq = legacy_irqs[i];
 #endif
-			hw.chipset = ide_generic;
-
 			rc = ide_host_add(&ide_generic_port_info, hws, NULL);
 			if (rc) {
 				release_region(io_addr + 0x206, 1);
Index: b/drivers/ide/ide-h8300.c
===================================================================
--- a/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -73,12 +73,12 @@ static inline void hw_setup(hw_regs_t *h
 		hw->io_ports_array[i] = CONFIG_H8300_IDE_BASE + H8300_IDE_GAP*i;
 	hw->io_ports.ctl_addr = CONFIG_H8300_IDE_ALT;
 	hw->irq = EXT_IRQ0 + CONFIG_H8300_IDE_IRQ;
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info h8300_port_info = {
 	.tp_ops			= &h8300_tp_ops,
 	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static int __init h8300_ide_init(void)
Index: b/drivers/ide/ide-legacy.c
===================================================================
--- a/drivers/ide/ide-legacy.c
+++ b/drivers/ide/ide-legacy.c
@@ -33,7 +33,6 @@ static void ide_legacy_init_one(hw_regs_
 
 	ide_std_init_ports(hw, base, ctl);
 	hw->irq = irq;
-	hw->chipset = d->chipset;
 	hw->config = config;
 
 	hws[port_no] = hw;
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -29,6 +29,7 @@ static struct pnp_device_id idepnp_devic
 
 static const struct ide_port_info ide_pnp_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
@@ -62,7 +63,6 @@ static int idepnp_probe(struct pnp_dev *
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
-	hw.chipset = ide_generic;
 
 	rc = ide_host_add(&ide_pnp_port_info, hws, &host);
 	if (rc)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1039,8 +1039,7 @@ static void ide_init_port(ide_hwif_t *hw
 {
 	hwif->channel = port;
 
-	if (d->chipset)
-		hwif->chipset = d->chipset;
+	hwif->chipset = d->chipset ? d->chipset : ide_pci;
 
 	if (d->init_iops)
 		d->init_iops(hwif);
@@ -1169,7 +1168,6 @@ static void ide_init_port_hw(ide_hwif_t 
 {
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
 	hwif->irq = hw->irq;
-	hwif->chipset = hw->chipset;
 	hwif->dev = hw->dev;
 	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
Index: b/drivers/ide/ide_platform.c
===================================================================
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -40,12 +40,11 @@ static void __devinit plat_ide_setup_por
 	hw->io_ports.ctl_addr = (unsigned long)ctrl;
 
 	hw->irq = irq;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info platform_ide_port_info = {
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static int __devinit plat_ide_probe(struct platform_device *pdev)
Index: b/drivers/ide/macide.c
===================================================================
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -76,13 +76,12 @@ static void __init macide_setup_ports(hw
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static const struct ide_port_info macide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
 static const char *mac_ide_name[] =
Index: b/drivers/ide/palm_bk3710.c
===================================================================
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -306,6 +306,7 @@ static struct ide_port_info __devinitdat
 	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
+	.chipset		= ide_palm3710,
 };
 
 static int __init palm_bk3710_probe(struct platform_device *pdev)
@@ -363,7 +364,6 @@ static int __init palm_bk3710_probe(stru
 			(base + IDE_PALM_ATA_PRI_CTL_OFFSET);
 	hw.irq = irq->start;
 	hw.dev = &pdev->dev;
-	hw.chipset = ide_palm3710;
 
 	palm_bk3710_port_info.udma_mask = rate < 100000000 ? ATA_UDMA4 :
 							     ATA_UDMA5;
Index: b/drivers/ide/q40ide.c
===================================================================
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -70,8 +70,6 @@ static void q40_ide_setup_ports(hw_regs_
 
 	hw->irq = irq;
 	hw->ack_intr = ack_intr;
-
-	hw->chipset = ide_generic;
 }
 
 static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
@@ -119,6 +117,7 @@ static const struct ide_port_info q40ide
 	.tp_ops			= &q40ide_tp_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.irq_flags		= IRQF_SHARED,
+	.chipset		= ide_generic,
 };
 
 /* 
Index: b/drivers/ide/rapide.c
===================================================================
--- a/drivers/ide/rapide.c
+++ b/drivers/ide/rapide.c
@@ -13,6 +13,7 @@
 
 static const struct ide_port_info rapide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.chipset		= ide_generic,
 };
 
 static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
@@ -49,7 +50,6 @@ rapide_probe(struct expansion_card *ec, 
 
 	memset(&hw, 0, sizeof(hw));
 	rapide_setup_ports(&hw, base, base + 0x818, 1 << 6, ec->irq);
-	hw.chipset = ide_generic;
 	hw.dev = &ec->dev;
 
 	ret = ide_host_add(&rapide_port_info, hws, &host);
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -567,7 +567,6 @@ static int scc_ide_setup_pci_device(stru
 		hw.io_ports_array[i] = ports->dma + 0x20 + i * 4;
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
-	hw.chipset = ide_pci;
 
 	rc = ide_host_add(d, hws, &host);
 	if (rc)
@@ -823,6 +822,7 @@ static const struct ide_port_info scc_ch
 	.host_flags	= IDE_HFLAG_SINGLE,
 	.irq_flags	= IRQF_SHARED,
 	.pio_mask	= ATA_PIO4,
+	.chipset	= ide_pci,
 };
 
 /**
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -344,7 +344,6 @@ static int ide_hw_configure(struct pci_d
 
 	memset(hw, 0, sizeof(*hw));
 	hw->dev = &dev->dev;
-	hw->chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(hw, base, ctl | 2);
 
 	return 0;
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -575,7 +575,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	memset(&hw, 0, sizeof(hw));
 	sgiioc4_init_hwif_ports(&hw, cmd_base, ctl, irqport);
 	hw.irq = dev->irq;
-	hw.chipset = ide_pci;
 	hw.dev = &dev->dev;
 
 	/* Initializing chipset IRQ Registers */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -186,7 +186,6 @@ typedef struct hw_regs_s {
 
 	int		irq;			/* our irq number */
 	ide_ack_intr_t	*ack_intr;		/* acknowledge interrupt */
-	hwif_chipset_t  chipset;
 	struct device	*dev, *parent;
 	unsigned long	config;
 } hw_regs_t;
