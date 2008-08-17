Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYHQT5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYHQT5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYHQT4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYHQT4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GfW0LVtVVhLHOXWdNlUFvyLht5p5MmFymHPuQZlC2XNMBWJnEkNENl/lRheWth/GQg
         bLsoNPrNkEY7yYBJSd6ACjp6J96xfeIikOSmNVQMpQgO4rgL2OUcM0idHvXRth/C3Mjy
         mo8MwhrBJYCBLnwlWdhWFyif4xc4EPhsCef/s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:54:11 +0200
Message-Id: <20080817195411.13393.22229.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/9] ide: remove [ata_]select_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use 'drive->dn & 1' in ide_init_disk().

* remove [ata_]select_t.

While at it:

* Use ATA_DEVICE_OBS define in ide_port_init_devices_data().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c    |    2 +-
 drivers/ide/ide-io.c             |    2 +-
 drivers/ide/ide-iops.c           |    2 +-
 drivers/ide/ide-probe.c          |    4 ++--
 drivers/ide/ide.c                |    2 +-
 drivers/ide/legacy/ide-4drives.c |    2 +-
 drivers/ide/pci/scc_pata.c       |    2 +-
 include/linux/ide.h              |   32 +-------------------------------
 8 files changed, 9 insertions(+), 39 deletions(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -80,7 +80,7 @@ static void h8300_tf_load(ide_drive_t *d
 		outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		outb((tf->device & HIHI) | drive->select.all,
+		outb((tf->device & HIHI) | drive->select,
 		     io_ports->device_addr);
 }
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -495,7 +495,7 @@ static void ide_tf_set_specify_cmd(ide_d
 	tf->lbal    = drive->sect;
 	tf->lbam    = drive->cyl;
 	tf->lbah    = drive->cyl >> 8;
-	tf->device  = (drive->head - 1) | drive->select.all;
+	tf->device  = (drive->head - 1) | drive->select;
 	tf->command = ATA_CMD_INIT_DEV_PARAMS;
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -181,7 +181,7 @@ void ide_tf_load(ide_drive_t *drive, ide
 		tf_outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		tf_outb((tf->device & HIHI) | drive->select.all,
+		tf_outb((tf->device & HIHI) | drive->select,
 			 io_ports->device_addr);
 }
 EXPORT_SYMBOL_GPL(ide_tf_load);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -446,7 +446,7 @@ static int do_probe (ide_drive_t *drive,
 	SELECT_DRIVE(drive);
 	msleep(50);
 
-	if (ide_read_device(drive) != drive->select.all && present == 0) {
+	if (ide_read_device(drive) != drive->select && present == 0) {
 		if (drive->dn & 1) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
@@ -1211,7 +1211,7 @@ EXPORT_SYMBOL_GPL(ide_unregister_region)
 void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	unsigned int unit = (drive->select.all >> 4) & 1;
+	unsigned int unit = drive->dn & 1;
 
 	disk->major = hwif->major;
 	disk->first_minor = unit << PARTN_BITS;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -114,7 +114,7 @@ static void ide_port_init_devices_data(i
 		memset(drive, 0, sizeof(*drive));
 
 		drive->media			= ide_disk;
-		drive->select.all		= (unit<<4)|0xa0;
+		drive->select			= (unit << 4) | ATA_DEVICE_OBS;
 		drive->hwif			= hwif;
 		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -14,7 +14,7 @@ MODULE_PARM_DESC(probe, "probe for gener
 static void ide_4drives_init_dev(ide_drive_t *drive)
 {
 	if (drive->hwif->channel)
-		drive->select.all ^= 0x20;
+		drive->select ^= 0x20;
 }
 
 static const struct ide_port_ops ide_4drives_port_ops = {
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -705,7 +705,7 @@ static void scc_tf_load(ide_drive_t *dri
 		scc_ide_outb(tf->lbah, io_ports->lbah_addr);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
-		scc_ide_outb((tf->device & HIHI) | drive->select.all,
+		scc_ide_outb((tf->device & HIHI) | drive->select,
 			     io_ports->device_addr);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -279,36 +279,6 @@ typedef union {
 } special_t;
 
 /*
- * ATA-IDE Select Register, aka Device-Head
- *
- * head		: always zeros here
- * unit		: drive select number: 0/1
- * bit5		: always 1
- * lba		: using LBA instead of CHS
- * bit7		: always 1
- */
-typedef union {
-	unsigned all			: 8;
-	struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-		unsigned head		: 4;
-		unsigned unit		: 1;
-		unsigned bit5		: 1;
-		unsigned lba		: 1;
-		unsigned bit7		: 1;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-		unsigned bit7		: 1;
-		unsigned lba		: 1;
-		unsigned bit5		: 1;
-		unsigned unit		: 1;
-		unsigned head		: 4;
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-	} b;
-} select_t, ata_select_t;
-
-/*
  * Status returned from various ide_ functions
  */
 typedef enum {
@@ -527,8 +497,8 @@ struct ide_drive_s {
 	unsigned long timeout;		/* max time to wait for irq */
 
 	special_t	special;	/* special action flags */
-	select_t	select;		/* basic drive/head select reg value */
 
+	u8	select;			/* basic drive/head select reg value */
 	u8	retry_pio;		/* retrying dma capable host in pio */
 	u8	waiting_for_dma;	/* dma currently in progress */
 
