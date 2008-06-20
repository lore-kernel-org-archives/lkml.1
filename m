Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbYFTVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbYFTVih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761980AbYFTVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:33:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6668 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761970AbYFTVdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=hpBMQd8nknF6hKcH5KsRkrO0e1/TQE/fpc349Y/jWFqL7FnfZ51Z3Q3mwfxQHl0ckV
         /1xv9ZryFZFInXNHnVzHkK4/YFdTKwRw+D1CdHIIek5IPKXCrxZNOd/ceBKK9X7ruepO
         DboxP4vFcOKQK7iH6jXCyMRNuKKVBUhjan19E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:35:25 +0200
Message-Id: <20080620213525.13202.493.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/18] ide: remove ->INB, ->OUTB and ->OUTBSYNC methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove no longer needed ->INB, ->OUTB and ->OUTBSYNC methods.

Then:

* Remove no longer used default_hwif_[mm]iops() and ide_[mm_]outbsync().

* Cleanup SuperIO handling in ns87415.c.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c          |    5 ----
 drivers/ide/arm/palm_bk3710.c     |    2 -
 drivers/ide/arm/rapide.c          |    2 -
 drivers/ide/h8300/ide-h8300.c     |    2 -
 drivers/ide/ide-iops.c            |   28 -----------------------
 drivers/ide/ide.c                 |    1 
 drivers/ide/legacy/ide_platform.c |    4 ---
 drivers/ide/mips/swarm.c          |    3 --
 drivers/ide/pci/ns87415.c         |   46 ++++++++++----------------------------
 drivers/ide/pci/scc_pata.c        |   12 ---------
 drivers/ide/pci/sgiioc4.c         |    3 --
 drivers/ide/pci/siimage.c         |    2 -
 drivers/ide/ppc/pmac.c            |   13 ----------
 include/linux/ide.h               |    7 -----
 14 files changed, 15 insertions(+), 115 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -469,8 +469,6 @@ icside_register_v5(struct icside_state *
 	if (!hwif)
 		return -ENODEV;
 
-	default_hwif_mmiops(hwif);
-
 	state->hwif[0] = hwif;
 
 	ecard_set_drvdata(ec, state);
@@ -547,14 +545,11 @@ icside_register_v6(struct icside_state *
 		return -ENODEV;
 
 	hwif->chipset = ide_acorn;
-	default_hwif_mmiops(hwif);
 
 	idx[0] = hwif->index;
 
 	mate = ide_find_port();
 	if (mate) {
-		default_hwif_mmiops(mate);
-
 		hws[1] = &hw[1];
 		idx[1] = mate->index;
 	}
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -401,8 +401,6 @@ static int __devinit palm_bk3710_probe(s
 
 	i = hwif->index;
 
-	default_hwif_mmiops(hwif);
-
 	idx[0] = i;
 
 	ide_device_add(idx, &palm_bk3710_port_info, hws);
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -59,8 +59,6 @@ rapide_probe(struct expansion_card *ec, 
 		goto release;
 	}
 
-	default_hwif_mmiops(hwif);
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &rapide_port_info, hws);
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -171,8 +171,6 @@ static inline void hw_setup(hw_regs_t *h
 
 static inline void hwif_setup(ide_hwif_t *hwif)
 {
-	default_hwif_iops(hwif);
-
 	hwif->tf_load = h8300_tf_load;
 	hwif->tf_read = h8300_tf_read;
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -42,18 +42,6 @@ static void ide_outb (u8 val, unsigned l
 	outb(val, port);
 }
 
-static void ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
-{
-	outb(addr, port);
-}
-
-void default_hwif_iops (ide_hwif_t *hwif)
-{
-	hwif->OUTB	= ide_outb;
-	hwif->OUTBSYNC	= ide_outbsync;
-	hwif->INB	= ide_inb;
-}
-
 /*
  *	MMIO operations, typically used for SATA controllers
  */
@@ -68,22 +56,6 @@ static void ide_mm_outb (u8 value, unsig
 	writeb(value, (void __iomem *) port);
 }
 
-static void ide_mm_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
-{
-	writeb(value, (void __iomem *) port);
-}
-
-void default_hwif_mmiops (ide_hwif_t *hwif)
-{
-	hwif->OUTB	= ide_mm_outb;
-	/* Most systems will need to override OUTBSYNC, alas however
-	   this one is controller specific! */
-	hwif->OUTBSYNC	= ide_mm_outbsync;
-	hwif->INB	= ide_mm_inb;
-}
-
-EXPORT_SYMBOL(default_hwif_mmiops);
-
 void SELECT_DRIVE (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -101,7 +101,6 @@ void ide_init_port_data(ide_hwif_t *hwif
 
 	init_completion(&hwif->gendev_rel_comp);
 
-	default_hwif_iops(hwif);
 	default_hwif_transport(hwif);
 
 	ide_port_init_devices_data(hwif);
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -103,10 +103,8 @@ static int __devinit plat_ide_probe(stru
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
 	hw.dev = &pdev->dev;
 
-	if (mmio) {
+	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
-		default_hwif_mmiops(hwif);
-	}
 
 	idx[0] = hwif->index;
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -120,9 +120,6 @@ static int __devinit swarm_ide_probe(str
 	if (hwif == NULL)
 		goto err;
 
-	/* Setup MMIO ops. */
-	default_hwif_mmiops(hwif);
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &swarm_port_info, hws);
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -28,10 +28,6 @@
  */
 #include <asm/superio.h>
 
-static unsigned long superio_ide_status[2];
-static unsigned long superio_ide_select[2];
-static unsigned long superio_ide_dma_status[2];
-
 #define SUPERIO_IDE_MAX_RETRIES 25
 
 /* Because of a defect in Super I/O, all reads of the PCI DMA status 
@@ -40,27 +36,18 @@ static unsigned long superio_ide_dma_sta
  */
 static u8 superio_ide_inb (unsigned long port)
 {
-	if (port == superio_ide_status[0] ||
-	    port == superio_ide_status[1] ||
-	    port == superio_ide_select[0] ||
-	    port == superio_ide_select[1] ||
-	    port == superio_ide_dma_status[0] ||
-	    port == superio_ide_dma_status[1]) {
-		u8 tmp;
-		int retries = SUPERIO_IDE_MAX_RETRIES;
-
-		/* printk(" [ reading port 0x%x with retry ] ", port); */
+	u8 tmp;
+	int retries = SUPERIO_IDE_MAX_RETRIES;
 
-		do {
-			tmp = inb(port);
-			if (tmp == 0)
-				udelay(50);
-		} while (tmp == 0 && retries-- > 0);
+	/* printk(" [ reading port 0x%x with retry ] ", port); */
 
-		return tmp;
-	}
+	do {
+		tmp = inb(port);
+		if (tmp == 0)
+			udelay(50);
+	} while (tmp == 0 && retries-- > 0);
 
-	return inb(port);
+	return tmp;
 }
 
 static u8 superio_read_status(ide_hwif_t *hwif)
@@ -120,27 +107,20 @@ static void superio_tf_read(ide_drive_t 
 static void __devinit superio_ide_init_iops (struct hwif_s *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	u32 base, dmabase;
+	u32 dma_stat;
 	u8 port = hwif->channel, tmp;
 
-	base = pci_resource_start(pdev, port * 2) & ~3;
-	dmabase = pci_resource_start(pdev, 4) & ~3;
-
-	superio_ide_status[port] = base + 7;
-	superio_ide_select[port] = base + 6;
-	superio_ide_dma_status[port] = dmabase + (!port ? 2 : 0xa);
+	dma_stat = (pci_resource_start(pdev, 4) & ~3) + (!port ? 2 : 0xa);
 
 	/* Clear error/interrupt, enable dma */
-	tmp = superio_ide_inb(superio_ide_dma_status[port]);
-	outb(tmp | 0x66, superio_ide_dma_status[port]);
+	tmp = superio_ide_inb(dma_stat);
+	outb(tmp | 0x66, dma_stat);
 
 	hwif->read_status	  = superio_read_status;
 	hwif->read_sff_dma_status = superio_read_sff_dma_status;
 
 	hwif->tf_read = superio_tf_read;
 
-	/* We need to override inb to workaround a SuperIO errata */
-	hwif->INB = superio_ide_inb;
 }
 
 static void __devinit init_iops_ns87415(ide_hwif_t *hwif)
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -188,14 +188,6 @@ static void scc_ide_outb(u8 addr, unsign
 	out_be32((void*)port, addr);
 }
 
-static void scc_ide_outbsync(ide_hwif_t *hwif, u8 addr, unsigned long port)
-{
-	out_be32((void*)port, addr);
-	eieio();
-	in_be32((void*)(hwif->dma_base + 0x01c));
-	eieio();
-}
-
 static void
 scc_ide_outsw(unsigned long port, void *addr, u32 count)
 {
@@ -830,10 +822,6 @@ static void __devinit init_mmio_iops_scc
 	hwif->input_data  = scc_input_data;
 	hwif->output_data = scc_output_data;
 
-	hwif->INB = scc_ide_inb;
-	hwif->OUTB = scc_ide_outb;
-	hwif->OUTBSYNC = scc_ide_outbsync;
-
 	hwif->dma_base = dma_base;
 	hwif->config_data = ports->ctl;
 }
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -623,9 +623,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	if (hwif == NULL)
 		goto err;
 
-	/* The IOC4 uses MMIO rather than Port IO. */
-	default_hwif_mmiops(hwif);
-
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -602,7 +602,7 @@ static void __devinit init_mmio_iops_sii
 	 *	Fill in the basic hwif bits
 	 */
 	hwif->host_flags |= IDE_HFLAG_MMIO;
-	default_hwif_mmiops(hwif);
+
 	hwif->hwif_data	= addr;
 
 	/*
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -486,15 +486,6 @@ pmac_ide_do_update_timings(ide_drive_t *
 		pmac_ide_selectproc(drive);
 }
 
-static void pmac_outbsync(ide_hwif_t *hwif, u8 value, unsigned long port)
-{
-	u32 tmp;
-	
-	writeb(value, (void __iomem *) port);
-	tmp = readl((void __iomem *)(hwif->io_ports.data_addr
-				     + IDE_TIMING_CONFIG));
-}
-
 static void pmac_exec_command(ide_hwif_t *hwif, u8 cmd)
 {
 	writeb(cmd, (void __iomem *)hwif->io_ports.command_addr);
@@ -1112,10 +1103,6 @@ static int __devinit pmac_ide_setup_devi
 	hwif->exec_command = pmac_exec_command;
 	hwif->set_irq	   = pmac_set_irq;
 
-	/* Setup MMIO ops */
-	default_hwif_mmiops(hwif);
-       	hwif->OUTBSYNC = pmac_outbsync;
-
 	idx[0] = hwif->index;
 
 	ide_device_add(idx, &d, hws);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -483,11 +483,6 @@ typedef struct hwif_s {
 
 	void (*ide_dma_clear_irq)(ide_drive_t *drive);
 
-	void (*OUTB)(u8 addr, unsigned long port);
-	void (*OUTBSYNC)(struct hwif_s *hwif, u8 addr, unsigned long port);
-
-	u8  (*INB)(unsigned long port);
-
 	/* dma physical region descriptor table (cpu view) */
 	unsigned int	*dmatable_cpu;
 	/* dma physical region descriptor table (dma view) */
@@ -1013,8 +1008,6 @@ static inline int ide_hwif_setup_dma(ide
 }
 #endif
 
-extern void default_hwif_iops(ide_hwif_t *);
-extern void default_hwif_mmiops(ide_hwif_t *);
 extern void default_hwif_transport(ide_hwif_t *);
 
 typedef struct ide_pci_enablebit_s {
