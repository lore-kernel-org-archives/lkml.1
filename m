Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYIBTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYIBTwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYIBTuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:50:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:11982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbYIBTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=avLiht508S7DpQSHn9aGx0MqD7iz6bWt28dlmNKwBpgqcdKgbgJXSSHKoph4UGIo5T
         IoZYpi3yc08Tb7omymB9FIdiFU6s+vdPh/54knHyJfz3TAiEm3pVLn2/VJ0M5paMrf6L
         oUXQcEcCmvagCVpyxU5IFA3seZZvDSeSGE2iA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:48:02 +0200
Message-Id: <20080902194802.14564.73503.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] ide: move SFF DMA code to ide-dma-sff.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile      |    1 
 drivers/ide/ide-dma-sff.c |  356 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-dma.c     |  363 ----------------------------------------------
 include/linux/ide.h       |    4 
 4 files changed, 362 insertions(+), 362 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -12,6 +12,7 @@ ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-t
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
+ide-core-$(CONFIG_BLK_DEV_IDEDMA_SFF)	+= ide-dma-sff.o
 ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
 ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
 
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-dma-sff.c
@@ -0,0 +1,356 @@
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+
+/**
+ *	config_drive_for_dma	-	attempt to activate IDE DMA
+ *	@drive: the drive to place in DMA mode
+ *
+ *	If the drive supports at least mode 2 DMA or UDMA of any kind
+ *	then attempt to place it into DMA mode. Drives that are known to
+ *	support DMA but predate the DMA properties or that are known
+ *	to have DMA handling bugs are also set up appropriately based
+ *	on the good/bad drive lists.
+ */
+
+int config_drive_for_dma(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u16 *id = drive->id;
+
+	if (drive->media != ide_disk) {
+		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
+			return 0;
+	}
+
+	/*
+	 * Enable DMA on any drive that has
+	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
+	 */
+	if ((id[ATA_ID_FIELD_VALID] & 4) &&
+	    ((id[ATA_ID_UDMA_MODES] >> 8) & 0x7f))
+		return 1;
+
+	/*
+	 * Enable DMA on any drive that has mode2 DMA
+	 * (multi or single) enabled
+	 */
+	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
+		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
+		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
+			return 1;
+
+	/* Consult the list of known "good" drives */
+	if (ide_dma_good_drive(drive))
+		return 1;
+
+	return 0;
+}
+
+/**
+ *	ide_dma_host_set	-	Enable/disable DMA on a host
+ *	@drive: drive to control
+ *
+ *	Enable/disable DMA on an IDE controller following generic
+ *	bus-mastering IDE controller behaviour.
+ */
+
+void ide_dma_host_set(ide_drive_t *drive, int on)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 unit = drive->dn & 1;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	if (on)
+		dma_stat |= (1 << (5 + unit));
+	else
+		dma_stat &= ~(1 << (5 + unit));
+
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writeb(dma_stat,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
+}
+EXPORT_SYMBOL_GPL(ide_dma_host_set);
+
+/**
+ *	ide_build_dmatable	-	build IDE DMA table
+ *
+ *	ide_build_dmatable() prepares a dma request. We map the command
+ *	to get the pci bus addresses of the buffers and then build up
+ *	the PRD table that the IDE layer wants to be fed.
+ *
+ *	Most chipsets correctly interpret a length of 0x0000 as 64KB,
+ *	but at least one (e.g. CS5530) misinterprets it as zero (!).
+ *	So we break the 64KB entry into two 32KB entries instead.
+ *
+ *	Returns the number of built PRD entries if all went okay,
+ *	returns 0 otherwise.
+ *
+ *	May also be invoked from trm290.c
+ */
+
+int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	__le32 *table = (__le32 *)hwif->dmatable_cpu;
+	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
+	unsigned int count = 0;
+	int i;
+	struct scatterlist *sg;
+
+	hwif->sg_nents = ide_build_sglist(drive, rq);
+	if (hwif->sg_nents == 0)
+		return 0;
+
+	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+		u32 cur_addr, cur_len, xcount, bcount;
+
+		cur_addr = sg_dma_address(sg);
+		cur_len = sg_dma_len(sg);
+
+		/*
+		 * Fill in the dma table, without crossing any 64kB boundaries.
+		 * Most hardware requires 16-bit alignment of all blocks,
+		 * but the trm290 requires 32-bit alignment.
+		 */
+
+		while (cur_len) {
+			if (count++ >= PRD_ENTRIES)
+				goto use_pio_instead;
+
+			bcount = 0x10000 - (cur_addr & 0xffff);
+			if (bcount > cur_len)
+				bcount = cur_len;
+			*table++ = cpu_to_le32(cur_addr);
+			xcount = bcount & 0xffff;
+			if (is_trm290)
+				xcount = ((xcount >> 2) - 1) << 16;
+			if (xcount == 0x0000) {
+				if (count++ >= PRD_ENTRIES)
+					goto use_pio_instead;
+				*table++ = cpu_to_le32(0x8000);
+				*table++ = cpu_to_le32(cur_addr + 0x8000);
+				xcount = 0x8000;
+			}
+			*table++ = cpu_to_le32(xcount);
+			cur_addr += bcount;
+			cur_len -= bcount;
+		}
+	}
+
+	if (count) {
+		if (!is_trm290)
+			*--table |= cpu_to_le32(0x80000000);
+		return count;
+	}
+
+use_pio_instead:
+	printk(KERN_ERR "%s: %s\n", drive->name,
+		count ? "DMA table too small" : "empty DMA table?");
+
+	ide_destroy_dmatable(drive);
+
+	return 0; /* revert to PIO for this request */
+}
+EXPORT_SYMBOL_GPL(ide_build_dmatable);
+
+/**
+ *	ide_dma_setup	-	begin a DMA phase
+ *	@drive: target device
+ *
+ *	Build an IDE DMA PRD (IDE speak for scatter gather table)
+ *	and then set up the DMA transfer registers for a device
+ *	that follows generic IDE PCI DMA behaviour. Controllers can
+ *	override this function if they need to
+ *
+ *	Returns 0 on success. If a PIO fallback is required then 1
+ *	is returned.
+ */
+
+int ide_dma_setup(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->hwgroup->rq;
+	unsigned int reading;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 dma_stat;
+
+	if (rq_data_dir(rq))
+		reading = 0;
+	else
+		reading = 1 << 3;
+
+	/* fall back to pio! */
+	if (!ide_build_dmatable(drive, rq)) {
+		ide_map_sg(drive, rq);
+		return 1;
+	}
+
+	/* PRD table */
+	if (hwif->host_flags & IDE_HFLAG_MMIO)
+		writel(hwif->dmatable_dma,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
+	else
+		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
+
+	/* specify r/w */
+	if (mmio)
+		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	else
+		outb(reading, hwif->dma_base + ATA_DMA_CMD);
+
+	/* read DMA status for INTR & ERROR flags */
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	/* clear INTR & ERROR flags */
+	if (mmio)
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+
+	drive->waiting_for_dma = 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_dma_setup);
+
+/**
+ *	dma_timer_expiry	-	handle a DMA timeout
+ *	@drive: Drive that timed out
+ *
+ *	An IDE DMA transfer timed out. In the event of an error we ask
+ *	the driver to resolve the problem, if a DMA transfer is still
+ *	in progress we continue to wait (arguably we need to add a
+ *	secondary 'I don't care what the drive thinks' timeout here)
+ *	Finally if we have an interrupt we let it complete the I/O.
+ *	But only one time - we clear expiry and if it's still not
+ *	completed after WAIT_CMD, we error and retry in PIO.
+ *	This can occur if an interrupt is lost or due to hang or bugs.
+ */
+
+static int dma_timer_expiry(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
+		drive->name, __func__, dma_stat);
+
+	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
+		return WAIT_CMD;
+
+	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
+
+	/* 1 dmaing, 2 error, 4 intr */
+	if (dma_stat & 2)	/* ERROR */
+		return -1;
+
+	if (dma_stat & 1)	/* DMAing */
+		return WAIT_CMD;
+
+	if (dma_stat & 4)	/* Got an Interrupt */
+		return WAIT_CMD;
+
+	return 0;	/* Status is unknown -- reset the bus */
+}
+
+void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
+{
+	/* issue cmd to drive */
+	ide_execute_command(drive, command, &ide_dma_intr, 2 * WAIT_CMD,
+			    dma_timer_expiry);
+}
+EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
+
+void ide_dma_start(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_cmd;
+
+	/* Note that this is done *after* the cmd has
+	 * been issued to the drive, as per the BM-IDE spec.
+	 * The Promise Ultra33 doesn't work correctly when
+	 * we do this part before issuing the drive cmd.
+	 */
+	if (hwif->host_flags & IDE_HFLAG_MMIO) {
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		/* start DMA */
+		writeb(dma_cmd | 1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	} else {
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
+	}
+
+	wmb();
+}
+EXPORT_SYMBOL_GPL(ide_dma_start);
+
+/* returns 1 on error, 0 otherwise */
+int ide_dma_end(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
+	u8 dma_stat = 0, dma_cmd = 0;
+
+	drive->waiting_for_dma = 0;
+
+	if (mmio) {
+		/* get DMA command mode */
+		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+		/* stop DMA */
+		writeb(dma_cmd & ~1,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
+	} else {
+		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
+		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
+	}
+
+	/* get DMA status */
+	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	if (mmio)
+		/* clear the INTR & ERROR bits */
+		writeb(dma_stat | 6,
+		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
+	else
+		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
+
+	/* purge DMA mappings */
+	ide_destroy_dmatable(drive);
+	/* verify good DMA status */
+	wmb();
+	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
+}
+EXPORT_SYMBOL_GPL(ide_dma_end);
+
+/* returns 1 if dma irq issued, 0 otherwise */
+int ide_dma_test_irq(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
+
+	/* return 1 if INTR asserted */
+	if ((dma_stat & 4) == 4)
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_dma_test_irq);
+
+const struct ide_dma_ops sff_dma_ops = {
+	.dma_host_set		= ide_dma_host_set,
+	.dma_setup		= ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= ide_dma_end,
+	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timeout		= ide_dma_timeout,
+	.dma_lost_irq		= ide_dma_lost_irq,
+};
+EXPORT_SYMBOL_GPL(sff_dma_ops);
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -33,7 +33,6 @@
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#include <linux/io.h>
 
 static const struct drive_list_entry drive_whitelist[] = {
 	{ "Micropolis 2112A"	,       NULL		},
@@ -109,7 +108,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 }
 EXPORT_SYMBOL_GPL(ide_dma_intr);
 
-static int ide_dma_good_drive(ide_drive_t *drive)
+int ide_dma_good_drive(ide_drive_t *drive)
 {
 	return ide_in_drive_list(drive->id, drive_whitelist);
 }
@@ -142,90 +141,6 @@ int ide_build_sglist(ide_drive_t *drive,
 }
 EXPORT_SYMBOL_GPL(ide_build_sglist);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-/**
- *	ide_build_dmatable	-	build IDE DMA table
- *
- *	ide_build_dmatable() prepares a dma request. We map the command
- *	to get the pci bus addresses of the buffers and then build up
- *	the PRD table that the IDE layer wants to be fed.
- *
- *	Most chipsets correctly interpret a length of 0x0000 as 64KB,
- *	but at least one (e.g. CS5530) misinterprets it as zero (!).
- *	So we break the 64KB entry into two 32KB entries instead.
- *
- *	Returns the number of built PRD entries if all went okay,
- *	returns 0 otherwise.
- *
- *	May also be invoked from trm290.c
- */
-
-int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	__le32 *table = (__le32 *)hwif->dmatable_cpu;
-	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
-	unsigned int count = 0;
-	int i;
-	struct scatterlist *sg;
-
-	hwif->sg_nents = ide_build_sglist(drive, rq);
-	if (hwif->sg_nents == 0)
-		return 0;
-
-	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
-		u32 cur_addr, cur_len, xcount, bcount;
-
-		cur_addr = sg_dma_address(sg);
-		cur_len = sg_dma_len(sg);
-
-		/*
-		 * Fill in the dma table, without crossing any 64kB boundaries.
-		 * Most hardware requires 16-bit alignment of all blocks,
-		 * but the trm290 requires 32-bit alignment.
-		 */
-
-		while (cur_len) {
-			if (count++ >= PRD_ENTRIES)
-				goto use_pio_instead;
-
-			bcount = 0x10000 - (cur_addr & 0xffff);
-			if (bcount > cur_len)
-				bcount = cur_len;
-			*table++ = cpu_to_le32(cur_addr);
-			xcount = bcount & 0xffff;
-			if (is_trm290)
-				xcount = ((xcount >> 2) - 1) << 16;
-			if (xcount == 0x0000) {
-				if (count++ >= PRD_ENTRIES)
-					goto use_pio_instead;
-				*table++ = cpu_to_le32(0x8000);
-				*table++ = cpu_to_le32(cur_addr + 0x8000);
-				xcount = 0x8000;
-			}
-			*table++ = cpu_to_le32(xcount);
-			cur_addr += bcount;
-			cur_len -= bcount;
-		}
-	}
-
-	if (count) {
-		if (!is_trm290)
-			*--table |= cpu_to_le32(0x80000000);
-		return count;
-	}
-
-use_pio_instead:
-	printk(KERN_ERR "%s: %s\n", drive->name,
-		count ? "DMA table too small" : "empty DMA table?");
-
-	ide_destroy_dmatable(drive);
-
-	return 0; /* revert to PIO for this request */
-}
-EXPORT_SYMBOL_GPL(ide_build_dmatable);
-#endif
-
 /**
  *	ide_destroy_dmatable	-	clean up DMA mapping
  *	@drive: The drive to unmap
@@ -246,120 +161,6 @@ void ide_destroy_dmatable(ide_drive_t *d
 }
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-/**
- *	config_drive_for_dma	-	attempt to activate IDE DMA
- *	@drive: the drive to place in DMA mode
- *
- *	If the drive supports at least mode 2 DMA or UDMA of any kind
- *	then attempt to place it into DMA mode. Drives that are known to
- *	support DMA but predate the DMA properties or that are known
- *	to have DMA handling bugs are also set up appropriately based
- *	on the good/bad drive lists.
- */
-
-static int config_drive_for_dma(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u16 *id = drive->id;
-
-	if (drive->media != ide_disk) {
-		if (hwif->host_flags & IDE_HFLAG_NO_ATAPI_DMA)
-			return 0;
-	}
-
-	/*
-	 * Enable DMA on any drive that has
-	 * UltraDMA (mode 0/1/2/3/4/5/6) enabled
-	 */
-	if ((id[ATA_ID_FIELD_VALID] & 4) &&
-	    ((id[ATA_ID_UDMA_MODES] >> 8) & 0x7f))
-		return 1;
-
-	/*
-	 * Enable DMA on any drive that has mode2 DMA
-	 * (multi or single) enabled
-	 */
-	if (id[ATA_ID_FIELD_VALID] & 2)	/* regular DMA */
-		if ((id[ATA_ID_MWDMA_MODES] & 0x404) == 0x404 ||
-		    (id[ATA_ID_SWDMA_MODES] & 0x404) == 0x404)
-			return 1;
-
-	/* Consult the list of known "good" drives */
-	if (ide_dma_good_drive(drive))
-		return 1;
-
-	return 0;
-}
-
-/**
- *	dma_timer_expiry	-	handle a DMA timeout
- *	@drive: Drive that timed out
- *
- *	An IDE DMA transfer timed out. In the event of an error we ask
- *	the driver to resolve the problem, if a DMA transfer is still
- *	in progress we continue to wait (arguably we need to add a
- *	secondary 'I don't care what the drive thinks' timeout here)
- *	Finally if we have an interrupt we let it complete the I/O.
- *	But only one time - we clear expiry and if it's still not
- *	completed after WAIT_CMD, we error and retry in PIO.
- *	This can occur if an interrupt is lost or due to hang or bugs.
- */
-
-static int dma_timer_expiry(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
-		drive->name, __func__, dma_stat);
-
-	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
-		return WAIT_CMD;
-
-	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
-
-	/* 1 dmaing, 2 error, 4 intr */
-	if (dma_stat & 2)	/* ERROR */
-		return -1;
-
-	if (dma_stat & 1)	/* DMAing */
-		return WAIT_CMD;
-
-	if (dma_stat & 4)	/* Got an Interrupt */
-		return WAIT_CMD;
-
-	return 0;	/* Status is unknown -- reset the bus */
-}
-
-/**
- *	ide_dma_host_set	-	Enable/disable DMA on a host
- *	@drive: drive to control
- *
- *	Enable/disable DMA on an IDE controller following generic
- *	bus-mastering IDE controller behaviour.
- */
-
-void ide_dma_host_set(ide_drive_t *drive, int on)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 unit = drive->dn & 1;
-	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	if (on)
-		dma_stat |= (1 << (5 + unit));
-	else
-		dma_stat &= ~(1 << (5 + unit));
-
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writeb(dma_stat,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
-}
-EXPORT_SYMBOL_GPL(ide_dma_host_set);
-#endif /* CONFIG_BLK_DEV_IDEDMA_SFF  */
-
 /**
  *	ide_dma_off_quietly	-	Generic DMA kill
  *	@drive: drive to control
@@ -406,154 +207,6 @@ void ide_dma_on(ide_drive_t *drive)
 	drive->hwif->dma_ops->dma_host_set(drive, 1);
 }
 
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-/**
- *	ide_dma_setup	-	begin a DMA phase
- *	@drive: target device
- *
- *	Build an IDE DMA PRD (IDE speak for scatter gather table)
- *	and then set up the DMA transfer registers for a device
- *	that follows generic IDE PCI DMA behaviour. Controllers can
- *	override this function if they need to
- *
- *	Returns 0 on success. If a PIO fallback is required then 1
- *	is returned.
- */
-
-int ide_dma_setup(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
-	unsigned int reading;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 dma_stat;
-
-	if (rq_data_dir(rq))
-		reading = 0;
-	else
-		reading = 1 << 3;
-
-	/* fall back to pio! */
-	if (!ide_build_dmatable(drive, rq)) {
-		ide_map_sg(drive, rq);
-		return 1;
-	}
-
-	/* PRD table */
-	if (hwif->host_flags & IDE_HFLAG_MMIO)
-		writel(hwif->dmatable_dma,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_TABLE_OFS));
-	else
-		outl(hwif->dmatable_dma, hwif->dma_base + ATA_DMA_TABLE_OFS);
-
-	/* specify r/w */
-	if (mmio)
-		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-	else
-		outb(reading, hwif->dma_base + ATA_DMA_CMD);
-
-	/* read DMA status for INTR & ERROR flags */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	/* clear INTR & ERROR flags */
-	if (mmio)
-		writeb(dma_stat | 6,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
-
-	drive->waiting_for_dma = 1;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ide_dma_setup);
-
-void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2 * WAIT_CMD,
-			    dma_timer_expiry);
-}
-EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
-
-void ide_dma_start(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_cmd;
-
-	/* Note that this is done *after* the cmd has
-	 * been issued to the drive, as per the BM-IDE spec.
-	 * The Promise Ultra33 doesn't work correctly when
-	 * we do this part before issuing the drive cmd.
-	 */
-	if (hwif->host_flags & IDE_HFLAG_MMIO) {
-		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-		/* start DMA */
-		writeb(dma_cmd | 1,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-	} else {
-		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
-		outb(dma_cmd | 1, hwif->dma_base + ATA_DMA_CMD);
-	}
-
-	wmb();
-}
-EXPORT_SYMBOL_GPL(ide_dma_start);
-
-/* returns 1 on error, 0 otherwise */
-int ide_dma_end(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
-	u8 dma_stat = 0, dma_cmd = 0;
-
-	drive->waiting_for_dma = 0;
-
-	if (mmio) {
-		/* get DMA command mode */
-		dma_cmd = readb((void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-		/* stop DMA */
-		writeb(dma_cmd & ~1,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
-	} else {
-		dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
-		outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
-	}
-
-	/* get DMA status */
-	dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	if (mmio)
-		/* clear the INTR & ERROR bits */
-		writeb(dma_stat | 6,
-		       (void __iomem *)(hwif->dma_base + ATA_DMA_STATUS));
-	else
-		outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
-
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
-	wmb();
-	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
-}
-EXPORT_SYMBOL_GPL(ide_dma_end);
-
-/* returns 1 if dma irq issued, 0 otherwise */
-int ide_dma_test_irq(ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
-
-	/* return 1 if INTR asserted */
-	if ((dma_stat & 4) == 4)
-		return 1;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ide_dma_test_irq);
-#else
-static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
-#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
-
 int __ide_dma_bad_drive(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
@@ -846,17 +499,3 @@ int ide_allocate_dma_engine(ide_hwif_t *
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_allocate_dma_engine);
-
-#ifdef CONFIG_BLK_DEV_IDEDMA_SFF
-const struct ide_dma_ops sff_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
-	.dma_start		= ide_dma_start,
-	.dma_end		= ide_dma_end,
-	.dma_test_irq		= ide_dma_test_irq,
-	.dma_timeout		= ide_dma_timeout,
-	.dma_lost_irq		= ide_dma_lost_irq,
-};
-EXPORT_SYMBOL_GPL(sff_dma_ops);
-#endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1407,6 +1407,7 @@ struct drive_list_entry {
 int ide_in_drive_list(u16 *, const struct drive_list_entry *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
+int ide_dma_good_drive(ide_drive_t *);
 int __ide_dma_bad_drive(ide_drive_t *);
 int ide_id_dma_bug(ide_drive_t *);
 
@@ -1431,6 +1432,7 @@ int ide_build_sglist(ide_drive_t *, stru
 void ide_destroy_dmatable(ide_drive_t *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
+int config_drive_for_dma(ide_drive_t *);
 extern int ide_build_dmatable(ide_drive_t *, struct request *);
 void ide_dma_host_set(ide_drive_t *, int);
 extern int ide_dma_setup(ide_drive_t *);
@@ -1439,6 +1441,8 @@ extern void ide_dma_start(ide_drive_t *)
 int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
 extern const struct ide_dma_ops sff_dma_ops;
+#else
+static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
 void ide_dma_lost_irq(ide_drive_t *);
