Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZBARur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZBARur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZBARsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:48:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbZBARsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pH2FPQoWE4g2j/TuRu6sisjl7RT/tor4mnf2WO6AoLVnS3eQAXICBLDx5kiyWCXL3v
         6l/d/Yh+avSXhes/6AOUw/J9CRT89Eql1sFrJfzgKBDrxUCqbOwIcMiuiLzdAoV3j7Lb
         nrMOhSybAV+/TR/GKHwy23+um4QVM07pNGui0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:44 +0100
Message-Id: <20090201174944.19144.12065.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/15] ide: allow host drivers to specify IRQ flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: allow host drivers to specify IRQ flags

* Add ->irq_flags field to struct ide_port_info and struct ide_host.

* Update host drivers and IDE PCI code to use ->irq_flags field.

* Convert init_irq() and ide_intr() to use host->irq_flags.

This fixes handling of shared IRQs for non-PCI hosts
and removes ugly ifdeffery from core IDE code.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/buddha.c    |    1 +
 drivers/ide/delkin_cb.c |    1 +
 drivers/ide/falconide.c |    1 +
 drivers/ide/gayle.c     |    1 +
 drivers/ide/ide-cs.c    |    1 +
 drivers/ide/ide-io.c    |   15 ++++-----------
 drivers/ide/ide-probe.c |    9 +--------
 drivers/ide/macide.c    |    1 +
 drivers/ide/q40ide.c    |    1 +
 drivers/ide/scc_pata.c  |    1 +
 drivers/ide/setup-pci.c |    4 ++++
 drivers/ide/sgiioc4.c   |    1 +
 include/linux/ide.h     |    6 ++++++
 13 files changed, 24 insertions(+), 19 deletions(-)

Index: b/drivers/ide/buddha.c
===================================================================
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -145,6 +145,7 @@ static void __init buddha_setup_ports(hw
 
 static const struct ide_port_info buddha_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
     /*
Index: b/drivers/ide/delkin_cb.c
===================================================================
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -66,6 +66,7 @@ static const struct ide_port_info delkin
 	.port_ops		= &delkin_cb_port_ops,
 	.host_flags		= IDE_HFLAG_IO_32BIT | IDE_HFLAG_UNMASK_IRQS |
 				  IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 	.init_chipset		= delkin_cb_init_chipset,
 };
 
Index: b/drivers/ide/falconide.c
===================================================================
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -105,6 +105,7 @@ static const struct ide_port_info falcon
 	.tp_ops			= &falconide_tp_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 static void __init falconide_setup_ports(hw_regs_t *hw)
Index: b/drivers/ide/gayle.c
===================================================================
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -120,6 +120,7 @@ static void __init gayle_setup_ports(hw_
 static const struct ide_port_info gayle_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
     /*
Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -154,6 +154,7 @@ static const struct ide_port_ops idecs_p
 static const struct ide_port_info idecs_port_info = {
 	.port_ops		= &idecs_port_ops,
 	.host_flags		= IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -841,6 +841,7 @@ static void unexpected_intr(int irq, ide
 irqreturn_t ide_intr (int irq, void *dev_id)
 {
 	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
+	struct ide_host *host = hwif->host;
 	ide_drive_t *uninitialized_var(drive);
 	ide_handler_t *handler;
 	unsigned long flags;
@@ -848,8 +849,8 @@ irqreturn_t ide_intr (int irq, void *dev
 	irqreturn_t irq_ret = IRQ_NONE;
 	int plug_device = 0;
 
-	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
-		if (hwif != hwif->host->cur_port)
+	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
+		if (hwif != host->cur_port)
 			goto out_early;
 	}
 
@@ -872,27 +873,19 @@ irqreturn_t ide_intr (int irq, void *dev
 		 *
 		 * For PCI, we cannot tell the difference,
 		 * so in that case we just ignore it and hope it goes away.
-		 *
-		 * FIXME: unexpected_intr should be hwif-> then we can
-		 * remove all the ifdef PCI crap
 		 */
-#ifdef CONFIG_BLK_DEV_IDEPCI
-		if (hwif->chipset != ide_pci)
-#endif	/* CONFIG_BLK_DEV_IDEPCI */
-		{
+		if ((host->irq_flags & IRQF_SHARED) == 0) {
 			/*
 			 * Probably not a shared PCI interrupt,
 			 * so we can safely try to do something about it:
 			 */
 			unexpected_intr(irq, hwif);
-#ifdef CONFIG_BLK_DEV_IDEPCI
 		} else {
 			/*
 			 * Whack the status register, just in case
 			 * we have a leftover pending IRQ.
 			 */
 			(void)hwif->tp_ops->read_status(hwif);
-#endif /* CONFIG_BLK_DEV_IDEPCI */
 		}
 		goto out;
 	}
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -837,14 +837,7 @@ static int ide_port_setup_devices(ide_hw
 static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	int sa = 0;
-
-#if defined(__mc68000__)
-	sa = IRQF_SHARED;
-#endif /* __mc68000__ */
-
-	if (hwif->chipset == ide_pci)
-		sa = IRQF_SHARED;
+	int sa = hwif->host->irq_flags;
 
 	if (io_ports->ctl_addr)
 		hwif->tp_ops->set_irq(hwif, 1);
Index: b/drivers/ide/macide.c
===================================================================
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -82,6 +82,7 @@ static void __init macide_setup_ports(hw
 
 static const struct ide_port_info macide_port_info = {
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 static const char *mac_ide_name[] =
Index: b/drivers/ide/q40ide.c
===================================================================
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -112,6 +112,7 @@ static const struct ide_tp_ops q40ide_tp
 static const struct ide_port_info q40ide_port_info = {
 	.tp_ops			= &q40ide_tp_ops,
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.irq_flags		= IRQF_SHARED,
 };
 
 /* 
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -891,6 +891,7 @@ static const struct ide_port_info scc_ch
 	.port_ops	= &scc_port_ops,
 	.dma_ops	= &scc_dma_ops,
 	.host_flags	= IDE_HFLAG_SINGLE,
+	.irq_flags	= IRQF_SHARED,
 	.pio_mask	= ATA_PIO4,
 };
 
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -558,6 +558,8 @@ int ide_pci_init_one(struct pci_dev *dev
 
 	host->host_priv = priv;
 
+	host->irq_flags = IRQF_SHARED;
+
 	pci_set_drvdata(dev, host);
 
 	ret = do_ide_setup_pci_device(dev, d, 1);
@@ -606,6 +608,8 @@ int ide_pci_init_two(struct pci_dev *dev
 
 	host->host_priv = priv;
 
+	host->irq_flags = IRQF_SHARED;
+
 	pci_set_drvdata(pdev[0], host);
 	pci_set_drvdata(pdev[1], host);
 
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -557,6 +557,7 @@ static const struct ide_port_info sgiioc
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
 	.host_flags		= IDE_HFLAG_MMIO,
+	.irq_flags		= IRQF_SHARED,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -836,6 +836,9 @@ struct ide_host {
 	void		(*release_lock)(void);
 
 	unsigned long	host_flags;
+
+	int		irq_flags;
+
 	void		*host_priv;
 	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
 
@@ -1368,6 +1371,9 @@ struct ide_port_info {
 	u16			max_sectors;	/* if < than the default one */
 
 	u32			host_flags;
+
+	int			irq_flags;
+
 	u8			pio_mask;
 	u8			swdma_mask;
 	u8			mwdma_mask;
