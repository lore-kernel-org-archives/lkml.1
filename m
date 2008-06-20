Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYFTVbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYFTVbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYFTVb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:31:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYFTVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=d+asc/b0gQbRwLY0/wlDTrep4MvILPkJLDi2c6BXDKKDOvxdkFrBn8+FgWZHSsM6AC
         rqJGY2hYC/+ITy2DNKaEvosTCS6Q+X/k7DXO5QVPKtO/tjImNtjV4bRdCtcaWKOSACGP
         JQHw+FDH6nrZGen/Uw7nkWk6tZU6rUOzvQRgg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:33:23 +0200
Message-Id: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/18] ide: add ->read_sff_dma_status method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->read_sff_dma_status method for reading DMA Status register
and use it instead of ->INB.

While at it:

* Use inb() directly in ns87415.c::ns87415_dma_end().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c      |   12 ++++++------
 drivers/ide/ide-iops.c     |   10 ++++++++++
 drivers/ide/pci/ns87415.c  |   13 ++++++++++---
 drivers/ide/pci/scc_pata.c |    7 +++++++
 include/linux/ide.h        |    2 ++
 5 files changed, 35 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -334,7 +334,7 @@ static int config_drive_for_dma (ide_dri
 static int dma_timer_expiry (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= hwif->read_sff_dma_status(hwif);
 
 	printk(KERN_WARNING "%s: dma_timer_expiry: dma status == 0x%02x\n",
 		drive->name, dma_stat);
@@ -369,7 +369,7 @@ void ide_dma_host_set(ide_drive_t *drive
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	u8 unit			= (drive->select.b.unit & 0x01);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= hwif->read_sff_dma_status(hwif);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
@@ -472,8 +472,8 @@ int ide_dma_setup(ide_drive_t *drive)
 	/* specify r/w */
 	hwif->OUTB(reading, hwif->dma_command);
 
-	/* read dma_status for INTR & ERROR flags */
-	dma_stat = hwif->INB(hwif->dma_status);
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = hwif->read_sff_dma_status(hwif);
 
 	/* clear INTR & ERROR flags */
 	hwif->OUTB(dma_stat|6, hwif->dma_status);
@@ -520,7 +520,7 @@ int __ide_dma_end (ide_drive_t *drive)
 	/* stop DMA */
 	hwif->OUTB(dma_cmd&~1, hwif->dma_command);
 	/* get DMA status */
-	dma_stat = hwif->INB(hwif->dma_status);
+	dma_stat = hwif->read_sff_dma_status(hwif);
 	/* clear the INTR & ERROR bits */
 	hwif->OUTB(dma_stat|6, hwif->dma_status);
 	/* purge DMA mappings */
@@ -537,7 +537,7 @@ EXPORT_SYMBOL(__ide_dma_end);
 int ide_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->INB(hwif->dma_status);
+	u8 dma_stat		= hwif->read_sff_dma_status(hwif);
 
 	/* return 1 if INTR asserted */
 	if ((dma_stat & 4) == 4)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -103,6 +103,14 @@ void SELECT_MASK(ide_drive_t *drive, int
 		port_ops->maskproc(drive, mask);
 }
 
+static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		return readb((void __iomem *)hwif->dma_status);
+	else
+		return inb(hwif->dma_status);
+}
+
 static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -323,6 +331,8 @@ static void ata_output_data(ide_drive_t 
 
 void default_hwif_transport(ide_hwif_t *hwif)
 {
+	hwif->read_sff_dma_status = ide_read_sff_dma_status;
+
 	hwif->tf_load	  = ide_tf_load;
 	hwif->tf_read	  = ide_tf_read;
 
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -63,6 +63,11 @@ static u8 superio_ide_inb (unsigned long
 	return inb(port);
 }
 
+static u8 superio_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	return superio_ide_inb(hwif->dma_status);
+}
+
 static void superio_tf_read(ide_drive_t *drive, ide_task_t *task)
 {
 	struct ide_io_ports *io_ports = &drive->hwif->io_ports;
@@ -122,6 +127,8 @@ static void __devinit superio_ide_init_i
 	tmp = superio_ide_inb(superio_ide_dma_status[port]);
 	outb(tmp | 0x66, superio_ide_dma_status[port]);
 
+	hwif->read_sff_dma_status = superio_read_sff_dma_status;
+
 	hwif->tf_read = superio_tf_read;
 
 	/* We need to override inb to workaround a SuperIO errata */
@@ -200,13 +207,13 @@ static int ns87415_dma_end(ide_drive_t *
 	u8 dma_stat = 0, dma_cmd = 0;
 
 	drive->waiting_for_dma = 0;
-	dma_stat = hwif->INB(hwif->dma_status);
+	dma_stat = hwif->read_sff_dma_status(hwif);
 	/* get dma command mode */
-	dma_cmd = hwif->INB(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_command);
 	/* stop DMA */
 	outb(dma_cmd & ~1, hwif->dma_command);
 	/* from ERRATA: clear the INTR & ERROR bits */
-	dma_cmd = hwif->INB(hwif->dma_command);
+	dma_cmd = inb(hwif->dma_command);
 	outb(dma_cmd | 6, hwif->dma_command);
 	/* and free any DMA resources */
 	ide_destroy_dmatable(drive);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -126,6 +126,11 @@ static u8 scc_ide_inb(unsigned long port
 	return (u8)data;
 }
 
+static u8 scc_read_sff_dma_status(ide_hwif_t *hwif)
+{
+	return (u8)in_be32((void *)hwif->dma_status);
+}
+
 static void scc_ide_insw(unsigned long port, void *addr, u32 count)
 {
 	u16 *ptr = (u16 *)addr;
@@ -774,6 +779,8 @@ static void __devinit init_mmio_iops_scc
 
 	ide_set_hwifdata(hwif, ports);
 
+	hwif->read_sff_dma_status = scc_read_sff_dma_status;
+
 	hwif->tf_load = scc_tf_load;
 	hwif->tf_read = scc_tf_read;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -468,6 +468,8 @@ typedef struct hwif_s {
 	const struct ide_port_ops	*port_ops;
 	const struct ide_dma_ops	*dma_ops;
 
+	u8 (*read_sff_dma_status)(struct hwif_s *);
+
 	void (*tf_load)(ide_drive_t *, struct ide_task_s *);
 	void (*tf_read)(ide_drive_t *, struct ide_task_s *);
 
