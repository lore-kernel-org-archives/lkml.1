Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYCIP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYCIP0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYCIPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:24:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:15146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYCIPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=P2YeIX0yquOrL11ysQcksjHTb0ztdbipKa7N20P3iEE9QV6Th5U8YpD0JybdvaMx/a0S9QkdEEdvLyyIe/itUqP8Fuv2oImlTYxMQAGj4u1EQLM/GCe2bIxGvL6k66cnKjtAG+nmXRsUVleb7cf4++ADoW9dNCF2XjrYmp40AJg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/7] sgiioc4: use ->init_dma method
Date: Sun, 9 Mar 2008 16:31:48 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Higdon <jeremy@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091631.48968.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move dma_base check from sgiioc4_ide_setup_pci_device()
  to ide_dma_sgiioc4().

* Replace ide_dma_sgiioc4() 'unsigned long dma_base' argument
  by 'const struct ide_port_info *d'.

* Move hwif->INB setup from ide_init_sgiioc4() to
  sgiioc4_ide_setup_pci_device().

* Move ide_init_sgiioc4() call from sgiioc4_ide_setup_pci_device()
  to ide_dma_sgiioc4().

* Convert the driver to use ->init_dma method.

Cc: Jeremy Higdon <jeremy@sgi.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sgiioc4.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -327,15 +327,21 @@ sgiioc4_INB(unsigned long port)
 	return reg;
 }
 
+static void __devinit ide_init_sgiioc4(ide_hwif_t *);
+
 /* Creates a dma map for the scatter-gather list entries */
 static int __devinit
-ide_dma_sgiioc4(ide_hwif_t * hwif, unsigned long dma_base)
+ide_dma_sgiioc4(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
+	unsigned long dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
 	void __iomem *virt_dma_base;
 	int num_ports = sizeof (ioc4_dma_regs_t);
 	void *pad;
 
+	if (dma_base == 0)
+		return -1;
+
 	printk(KERN_INFO "%s: BM-DMA at 0x%04lx-0x%04lx\n", hwif->name,
 	       dma_base, dma_base + num_ports - 1);
 
@@ -371,6 +377,7 @@ ide_dma_sgiioc4(ide_hwif_t * hwif, unsig
 
 	if (pad) {
 		ide_set_hwifdata(hwif, pad);
+		ide_init_sgiioc4(hwif);
 		return 0;
 	}
 
@@ -551,11 +558,6 @@ static int sgiioc4_ide_dma_setup(ide_dri
 static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
-	hwif->INB = &sgiioc4_INB;
-
-	if (hwif->dma_base == 0)
-		return;
-
 	hwif->dma_host_set = &sgiioc4_dma_host_set;
 	hwif->dma_setup = &sgiioc4_ide_dma_setup;
 	hwif->dma_start = &sgiioc4_ide_dma_start;
@@ -575,16 +577,16 @@ static const struct ide_port_ops sgiioc4
 
 static const struct ide_port_info sgiioc4_port_info __devinitdata = {
 	.chipset		= ide_pci,
+	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
-				  IDE_HFLAG_NO_AUTOTUNE,
+	.host_flags		= IDE_HFLAG_NO_AUTOTUNE,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
 static int __devinit
 sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 {
-	unsigned long cmd_base, dma_base, irqport;
+	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
 	ide_hwif_t *hwif;
@@ -610,7 +612,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	cmd_base = (unsigned long) virt_base + IOC4_CMD_OFFSET;
 	ctl = (unsigned long) virt_base + IOC4_CTRL_OFFSET;
 	irqport = (unsigned long) virt_base + IOC4_INTR_OFFSET;
-	dma_base = pci_resource_start(dev, 0) + IOC4_DMA_OFFSET;
 
 	cmd_phys_base = bar0 + IOC4_CMD_OFFSET;
 	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
@@ -639,13 +640,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base)) {
-		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
-				 hwif->name, DRV_NAME);
-		d.mwdma_mask = 0;
-	}
-
-	ide_init_sgiioc4(hwif);
+	hwif->INB = &sgiioc4_INB;
 
 	idx[0] = hwif->index;
 
