Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZAVOUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZAVOUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbZAVOS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:18:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6453 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343AbZAVOSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qtIKCXq4qVN2pZdGFp5iEd2FNVWThpRRq71n3OdQKg+Icc1z4Bi//nEHuJSeF6krZh
         6CMN5IOPYuir/rHaw1BiZsgmojp0iGWR+y0BmnGSrpp1Puwzgo7atBXfuHZMFXY6CbZc
         oKaCS7I4bL/DiiODk2fyawBO8IAEVZ8mvz9r8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2009 15:18:55 +0100
Message-Id: <20090122141855.25516.29455.sendpatchset@localhost.localdomain>
In-Reply-To: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
References: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] ide: use try_to_identify() in ide_driveid_update()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use try_to_identify() in ide_driveid_update()

* Pass pointer to buffer for IDENTIFY data to do_identify()
  and try_to_identify().

* Un-static try_to_identify() and use it in ide_driveid_update().

* Rename try_to_identify() to ide_dev_read_id().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c  |   54 +++---------------------------------------------
 drivers/ide/ide-probe.c |   24 ++++++++++-----------
 include/linux/ide.h     |    2 +
 3 files changed, 18 insertions(+), 62 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -289,65 +289,19 @@ no_80w:
 
 int ide_driveid_update(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u16 *id;
-	unsigned long flags;
-	int use_altstatus = 0, rc;
-	u8 a, uninitialized_var(s);
+	int rc;
 
 	id = kmalloc(SECTOR_SIZE, GFP_ATOMIC);
 	if (id == NULL)
 		return 0;
 
-	/*
-	 * Re-read drive->id for possible DMA mode
-	 * change (copied from ide-probe.c)
-	 */
-
 	SELECT_MASK(drive, 1);
-	tp_ops->set_irq(hwif, 0);
-	msleep(50);
-
-	if (hwif->io_ports.ctl_addr &&
-	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0) {
-		a = tp_ops->read_altstatus(hwif);
-		s = tp_ops->read_status(hwif);
-		if ((a ^ s) & ~ATA_IDX)
-			/* ancient Seagate drives, broken interfaces */
-			printk(KERN_INFO "%s: probing with STATUS(0x%02x) "
-					 "instead of ALTSTATUS(0x%02x)\n",
-					 drive->name, s, a);
-		else
-			/* use non-intrusive polling */
-			use_altstatus = 1;
-	}
-
-	tp_ops->exec_command(hwif, ATA_CMD_ID_ATA);
-
-	if (ide_busy_sleep(hwif, WAIT_WORSTCASE / 2, use_altstatus)) {
-		rc = 1;
-		goto out_err;
-	}
-
-	msleep(50);	/* wait for IRQ and ATA_DRQ */
-
-	s = tp_ops->read_status(hwif);
+	rc = ide_dev_read_id(drive, ATA_CMD_ID_ATA, id);
+	SELECT_MASK(drive, 0);
 
-	if (!OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
-		rc = 2;
+	if (rc)
 		goto out_err;
-	}
-
-	local_irq_save(flags);
-	tp_ops->input_data(drive, NULL, id, SECTOR_SIZE);
-	local_irq_restore(flags);
-
-	(void)tp_ops->read_status(hwif); /* clear drive IRQ */
-
-	ide_fix_driveid(id);
-
-	SELECT_MASK(drive, 0);
 
 	drive->id[ATA_ID_UDMA_MODES]  = id[ATA_ID_UDMA_MODES];
 	drive->id[ATA_ID_MWDMA_MODES] = id[ATA_ID_MWDMA_MODES];
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -181,16 +181,16 @@ static void ide_classify_atapi_dev(ide_d
  *	do_identify	-	identify a drive
  *	@drive: drive to identify 
  *	@cmd: command used
+ *	@id: buffer for IDENTIFY data
  *
  *	Called when we have issued a drive identify command to
  *	read and parse the results. This function is run with
  *	interrupts disabled. 
  */
 
-static void do_identify(ide_drive_t *drive, u8 cmd)
+static void do_identify(ide_drive_t *drive, u8 cmd, u16 *id)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long flags;
 	int bswap = 1;
@@ -240,19 +240,19 @@ err_misc:
 }
 
 /**
- *	try_to_identify	-	send ATA/ATAPI identify
+ *	ide_dev_read_id	-	send ATA/ATAPI IDENTIFY command
  *	@drive: drive to identify
  *	@cmd: command to use
+ *	@id: buffer for IDENTIFY data
  *
- *	try_to_identify() sends an ATA(PI) IDENTIFY request to a drive
- *	and waits for a response.
+ *	Sends an ATA(PI) IDENTIFY request to a drive and waits for a response.
  *
  *	Returns:	0  device was identified
  *			1  device timed-out (no response to identify request)
  *			2  device aborted the command (refused to identify itself)
  */
 
-static int try_to_identify(ide_drive_t *drive, u8 cmd)
+int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
@@ -312,7 +312,7 @@ static int try_to_identify(ide_drive_t *
 
 	if (OK_STAT(s, ATA_DRQ, BAD_R_STAT)) {
 		/* drive returned ID */
-		do_identify(drive, cmd);
+		do_identify(drive, cmd, id);
 		/* drive responded with ID */
 		rc = 0;
 		/* clear drive IRQ */
@@ -378,6 +378,7 @@ static int do_probe (ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
+	u16 *id = drive->id;
 	int rc;
 	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
 
@@ -413,11 +414,10 @@ static int do_probe (ide_drive_t *drive,
 
 	if (OK_STAT(stat, ATA_DRDY, ATA_BUSY) ||
 	    present || cmd == ATA_CMD_ID_ATAPI) {
-		/* send cmd and wait */
-		if ((rc = try_to_identify(drive, cmd))) {
+		rc = ide_dev_read_id(drive, cmd, id);
+		if (rc)
 			/* failed: try again */
-			rc = try_to_identify(drive,cmd);
-		}
+			rc = ide_dev_read_id(drive, cmd, id);
 
 		stat = tp_ops->read_status(hwif);
 
@@ -432,7 +432,7 @@ static int do_probe (ide_drive_t *drive,
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
-			rc = try_to_identify(drive, cmd);
+			rc = ide_dev_read_id(drive, cmd, id);
 		}
 
 		/* ensure drive IRQ is clear */
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1233,6 +1233,8 @@ int ide_no_data_taskfile(ide_drive_t *, 
 
 int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
 
+int ide_dev_read_id(ide_drive_t *, u8, u16 *);
+
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
