Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYIBTwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYIBTwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYIBTuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:50:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:11808 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbYIBTuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:50:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aJ2CmIhVy7A0SgsOxmf0WewHIlmslsD+6VSArQkg4Jvd9JfGn3o9Hdn7RQEe6cv+8K
         I0AuS0GmrTn+oFmBFM6twZFSUCjMazyV5Abd90jVkyhpGAiLGqqXFcPJH0glh92BlpRI
         CdffavECMAVomhXDOoQBntxpN+DMUXdbkGDko=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:47:55 +0200
Message-Id: <20080902194755.14564.10356.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/8] ide: cleanup ide-dma.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- s/HWIF(drive)/drive->hwif/
- s/HWGROUP(drive)/[drive->]hwif->hwgroup/
- fixup error messages in ide_dma_intr() & dma_timer_expiry()
- fix checkpatch.pl errors/warnings

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   88 +++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -33,11 +33,9 @@
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
-
-static const struct drive_list_entry drive_whitelist [] = {
-
+static const struct drive_list_entry drive_whitelist[] = {
 	{ "Micropolis 2112A"	,       NULL		},
 	{ "CONNER CTMA 4000"	,       NULL		},
 	{ "CONNER CTT8000-A"	,       NULL		},
@@ -45,8 +43,7 @@ static const struct drive_list_entry dri
 	{ NULL			,	NULL		}
 };
 
-static const struct drive_list_entry drive_blacklist [] = {
-
+static const struct drive_list_entry drive_blacklist[] = {
 	{ "WDC AC11000H"	,	NULL 		},
 	{ "WDC AC22100H"	,	NULL 		},
 	{ "WDC AC32500H"	,	NULL 		},
@@ -86,11 +83,11 @@ static const struct drive_list_entry dri
  *	ide_dma_intr	-	IDE DMA interrupt handler
  *	@drive: the drive the interrupt is for
  *
- *	Handle an interrupt completing a read/write DMA transfer on an 
+ *	Handle an interrupt completing a read/write DMA transfer on an
  *	IDE device
  */
- 
-ide_startstop_t ide_dma_intr (ide_drive_t *drive)
+
+ide_startstop_t ide_dma_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 stat = 0, dma_stat = 0;
@@ -100,17 +97,16 @@ ide_startstop_t ide_dma_intr (ide_drive_
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct request *rq = HWGROUP(drive)->rq;
+			struct request *rq = hwif->hwgroup->rq;
 
 			task_end_request(drive, rq, stat);
 			return ide_stopped;
 		}
-		printk(KERN_ERR "%s: dma_intr: bad DMA status (dma_stat=%x)\n", 
-		       drive->name, dma_stat);
+		printk(KERN_ERR "%s: %s: bad DMA status (0x%02x)\n",
+			drive->name, __func__, dma_stat);
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
-
 EXPORT_SYMBOL_GPL(ide_dma_intr);
 
 static int ide_dma_good_drive(ide_drive_t *drive)
@@ -131,7 +127,7 @@ static int ide_dma_good_drive(ide_drive_
 
 int ide_build_sglist(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 
 	ide_map_sg(drive, rq);
@@ -144,7 +140,6 @@ int ide_build_sglist(ide_drive_t *drive,
 	return dma_map_sg(hwif->dev, sg, hwif->sg_nents,
 			  hwif->sg_dma_direction);
 }
-
 EXPORT_SYMBOL_GPL(ide_build_sglist);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
@@ -164,10 +159,10 @@ EXPORT_SYMBOL_GPL(ide_build_sglist);
  *
  *	May also be invoked from trm290.c
  */
- 
-int ide_build_dmatable (ide_drive_t *drive, struct request *rq)
+
+int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 	__le32 *table = (__le32 *)hwif->dmatable_cpu;
 	unsigned int is_trm290	= (hwif->chipset == ide_trm290) ? 1 : 0;
 	unsigned int count = 0;
@@ -241,15 +236,14 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
  *	an oops as only one mapping can be live for each target at a given
  *	time.
  */
- 
-void ide_destroy_dmatable (ide_drive_t *drive)
+
+void ide_destroy_dmatable(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
 	dma_unmap_sg(hwif->dev, hwif->sg_table, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 }
-
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_SFF
@@ -263,8 +257,8 @@ EXPORT_SYMBOL_GPL(ide_destroy_dmatable);
  *	to have DMA handling bugs are also set up appropriately based
  *	on the good/bad drive lists.
  */
- 
-static int config_drive_for_dma (ide_drive_t *drive)
+
+static int config_drive_for_dma(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
@@ -304,26 +298,26 @@ static int config_drive_for_dma (ide_dri
  *
  *	An IDE DMA transfer timed out. In the event of an error we ask
  *	the driver to resolve the problem, if a DMA transfer is still
- *	in progress we continue to wait (arguably we need to add a 
+ *	in progress we continue to wait (arguably we need to add a
  *	secondary 'I don't care what the drive thinks' timeout here)
  *	Finally if we have an interrupt we let it complete the I/O.
  *	But only one time - we clear expiry and if it's still not
  *	completed after WAIT_CMD, we error and retry in PIO.
  *	This can occur if an interrupt is lost or due to hang or bugs.
  */
- 
-static int dma_timer_expiry (ide_drive_t *drive)
+
+static int dma_timer_expiry(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
-	printk(KERN_WARNING "%s: dma_timer_expiry: dma status == 0x%02x\n",
-		drive->name, dma_stat);
+	printk(KERN_WARNING "%s: %s: DMA status (0x%02x)\n",
+		drive->name, __func__, dma_stat);
 
 	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
 		return WAIT_CMD;
 
-	HWGROUP(drive)->expiry = NULL;	/* one free ride for now */
+	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
 
 	/* 1 dmaing, 2 error, 4 intr */
 	if (dma_stat & 2)	/* ERROR */
@@ -348,9 +342,9 @@ static int dma_timer_expiry (ide_drive_t
 
 void ide_dma_host_set(ide_drive_t *drive, int on)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 unit			= drive->dn & 1;
-	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 unit = drive->dn & 1;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
 	if (on)
 		dma_stat |= (1 << (5 + unit));
@@ -363,7 +357,6 @@ void ide_dma_host_set(ide_drive_t *drive
 	else
 		outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
-
 EXPORT_SYMBOL_GPL(ide_dma_host_set);
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF  */
 
@@ -371,7 +364,7 @@ EXPORT_SYMBOL_GPL(ide_dma_host_set);
  *	ide_dma_off_quietly	-	Generic DMA kill
  *	@drive: drive to control
  *
- *	Turn off the current DMA on this IDE controller. 
+ *	Turn off the current DMA on this IDE controller.
  */
 
 void ide_dma_off_quietly(ide_drive_t *drive)
@@ -381,7 +374,6 @@ void ide_dma_off_quietly(ide_drive_t *dr
 
 	drive->hwif->dma_ops->dma_host_set(drive, 0);
 }
-
 EXPORT_SYMBOL(ide_dma_off_quietly);
 
 /**
@@ -397,7 +389,6 @@ void ide_dma_off(ide_drive_t *drive)
 	printk(KERN_INFO "%s: DMA disabled\n", drive->name);
 	ide_dma_off_quietly(drive);
 }
-
 EXPORT_SYMBOL(ide_dma_off);
 
 /**
@@ -426,13 +417,13 @@ void ide_dma_on(ide_drive_t *drive)
  *	override this function if they need to
  *
  *	Returns 0 on success. If a PIO fallback is required then 1
- *	is returned. 
+ *	is returned.
  */
 
 int ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->hwgroup->rq;
 	unsigned int reading;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat;
@@ -474,13 +465,13 @@ int ide_dma_setup(ide_drive_t *drive)
 	drive->waiting_for_dma = 1;
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ide_dma_setup);
 
 void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
 	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, dma_timer_expiry);
+	ide_execute_command(drive, command, &ide_dma_intr, 2 * WAIT_CMD,
+			    dma_timer_expiry);
 }
 EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
 
@@ -506,7 +497,6 @@ void ide_dma_start(ide_drive_t *drive)
 
 	wmb();
 }
-
 EXPORT_SYMBOL_GPL(ide_dma_start);
 
 /* returns 1 on error, 0 otherwise */
@@ -550,8 +540,8 @@ EXPORT_SYMBOL_GPL(ide_dma_end);
 /* returns 1 if dma irq issued, 0 otherwise */
 int ide_dma_test_irq(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 dma_stat		= hwif->tp_ops->read_sff_dma_status(hwif);
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat = hwif->tp_ops->read_sff_dma_status(hwif);
 
 	/* return 1 if INTR asserted */
 	if ((dma_stat & 4) == 4)
@@ -564,7 +554,7 @@ EXPORT_SYMBOL_GPL(ide_dma_test_irq);
 static inline int config_drive_for_dma(ide_drive_t *drive) { return 0; }
 #endif /* CONFIG_BLK_DEV_IDEDMA_SFF */
 
-int __ide_dma_bad_drive (ide_drive_t *drive)
+int __ide_dma_bad_drive(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 
@@ -576,7 +566,6 @@ int __ide_dma_bad_drive (ide_drive_t *dr
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(__ide_dma_bad_drive);
 
 static const u8 xfer_mode_bases[] = {
@@ -592,7 +581,7 @@ static unsigned int ide_get_mode_mask(id
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	unsigned int mask = 0;
 
-	switch(base) {
+	switch (base) {
 	case XFER_UDMA_0:
 		if ((id[ATA_ID_FIELD_VALID] & 4) == 0)
 			break;
@@ -693,7 +682,6 @@ u8 ide_find_dma_mode(ide_drive_t *drive,
 
 	return mode;
 }
-
 EXPORT_SYMBOL_GPL(ide_find_dma_mode);
 
 static int ide_tune_dma(ide_drive_t *drive)
@@ -810,7 +798,7 @@ EXPORT_SYMBOL_GPL(ide_dma_lost_irq);
 
 void ide_dma_timeout(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = HWIF(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
 	printk(KERN_ERR "%s: timeout waiting for DMA\n", drive->name);
 
