Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYHQT4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYHQT4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYHQTz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:55:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYHQTz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=TKsSjmEMPm6wQlxiBqzboXZpuVmVTO5/s98aMPJCbUTKUp/mhnZaPcTw4ox4+E3obo
         fwZOiXnEiZC7THdqt9QrRNhQs3V73caaQEZ8jksIPAwun0QDsKIdBnx0c4FWJfS+1QBW
         dDE1Ghh2y1Z3SsTfaJN0XEUHYNDNtgSGdiSh8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:53:36 +0200
Message-Id: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] ide: fix HDIO_DRIVE_TASK[FILE] ioctls for CHS commands on LBA devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IDE_DFLAG_LBA device flag and use it instead of ->select.b.lba.

Since ->tf_load uses ->select.all for ATA Device/Head register this
fixes HDIO_DRIVE_TASK[FILE] ioctls for CHS commands on LBA devices.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
moar patches (on top of pata tree + previous 9)

 drivers/ide/ide-disk.c |   33 ++++++++++++++++++++-------------
 drivers/ide/ide-io.c   |    4 ++--
 include/linux/ide.h    |    1 +
 3 files changed, 23 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -156,7 +156,7 @@ static ide_startstop_t __ide_do_rw_disk(
 	memset(&task, 0, sizeof(task));
 	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
-	if (drive->select.b.lba) {
+	if (drive->dev_flags & IDE_DFLAG_LBA) {
 		if (lba48) {
 			pr_debug("%s: LBA=0x%012llx\n", drive->name,
 					(unsigned long long)block);
@@ -181,6 +181,8 @@ static ide_startstop_t __ide_do_rw_disk(
 			tf->lbah   = block >>= 8;
 			tf->device = (block >> 8) & 0xf;
 		}
+
+		tf->device |= ATA_LBA;
 	} else {
 		unsigned int sect, head, cyl, track;
 
@@ -378,28 +380,32 @@ static void idedisk_check_hpa(ide_drive_
 static void init_idedisk_capacity(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
-	/*
-	 * If this drive supports the Host Protected Area feature set,
-	 * then we may need to change our opinion about the drive's capacity.
-	 */
-	int hpa = ata_id_hpa_enabled(id);
+	int lba;
 
 	if (ata_id_lba48_enabled(id)) {
 		/* drive speaks 48-bit LBA */
-		drive->select.b.lba = 1;
+		lba = 1;
 		drive->capacity64 = ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
-		if (hpa)
-			idedisk_check_hpa(drive);
 	} else if (ata_id_has_lba(id) && ata_id_is_lba_capacity_ok(id)) {
 		/* drive speaks 28-bit LBA */
-		drive->select.b.lba = 1;
+		lba = 1;
 		drive->capacity64 = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
-		if (hpa)
-			idedisk_check_hpa(drive);
 	} else {
 		/* drive speaks boring old 28-bit CHS */
+		lba = 0;
 		drive->capacity64 = drive->cyl * drive->head * drive->sect;
 	}
+
+	if (lba) {
+		drive->dev_flags |= IDE_DFLAG_LBA;
+
+		/*
+		* If this device supports the Host Protected Area feature set,
+		* then we may need to change our opinion about its capacity.
+		*/
+		if (ata_id_hpa_enabled(id))
+			idedisk_check_hpa(drive);
+	}
 }
 
 static sector_t idedisk_capacity(ide_drive_t *drive)
@@ -1105,7 +1111,8 @@ static int ide_disk_probe(ide_drive_t *d
 	drive->driver_data = idkp;
 
 	idedisk_setup(drive);
-	if ((!drive->head || drive->head > 16) && !drive->select.b.lba) {
+	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
+	    (drive->head == 0 || drive->head > 16)) {
 		printk(KERN_ERR "%s: INVALID GEOMETRY: %d PHYSICAL HEADS?\n",
 			drive->name, drive->head);
 		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -383,7 +383,7 @@ static ide_startstop_t ide_ata_error(ide
 	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
 		if (err == ATA_ABORTED) {
-			if (drive->select.b.lba &&
+			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
 			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
 			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
 				return ide_stopped;
@@ -513,7 +513,7 @@ static void ide_tf_set_specify_cmd(ide_d
 	tf->lbal    = drive->sect;
 	tf->lbam    = drive->cyl;
 	tf->lbah    = drive->cyl >> 8;
-	tf->device  = ((drive->head - 1) | drive->select.all) & ~ATA_LBA;
+	tf->device  = (drive->head - 1) | drive->select.all;
 	tf->command = ATA_CMD_INIT_DEV_PARAMS;
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -500,6 +500,7 @@ enum {
 	IDE_DFLAG_NOWERR		= (1 << 24),
 	/* retrying in PIO */
 	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 25),
+	IDE_DFLAG_LBA			= (1 << 26),
 };
 
 struct ide_drive_s {
