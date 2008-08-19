Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYHSSmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYHSSmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYHSSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:41:55 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:25109 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYHSSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=Frl3fnI8I9OpZhvbU4IRXBiOjZZXvkOu2A3C54XX6Yzll1gkADyMJ7ud2u/nBhIg7m
         mPmo1YExtAxazYhFkpKRw+BJZ2ihNglHhMqd+jv3oheFfyyGd2Qb6spQTAvRNrRxjBsg
         XYdB/JZxPQuCxgQAdnl2r+09g8MDn6BC83Hk8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 20:39:34 +0200
Message-Id: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/6] ide: set IDE_AFLAG_DRQ_INTERRUPT in do_identify()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set IDE_AFLAG_DRQ_INTERRUPT in do_identify() instead of ATAPI
device drivers *_setup() methods.

While at it:
- use ata_id_cdb_intr()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    3 ---
 drivers/ide/ide-floppy.c |    5 -----
 drivers/ide/ide-probe.c  |    2 ++
 drivers/ide/ide-tape.c   |    7 -------
 drivers/scsi/ide-scsi.c  |    2 --
 5 files changed, 2 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1887,9 +1887,6 @@ static int ide_cdrom_setup(ide_drive_t *
 	drive->atapi_flags = IDE_AFLAG_MEDIA_CHANGED | IDE_AFLAG_NO_EJECT |
 		       ide_cd_flags(id);
 
-	if ((id[ATA_ID_CONFIG] & 0x0060) == 0x20)
-		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
-
 	if ((drive->atapi_flags & IDE_AFLAG_VERTOS_300_SSD) &&
 	    fw_rev[4] == '1' && fw_rev[6] <= '2')
 		drive->atapi_flags |= (IDE_AFLAG_TOCTRACKS_AS_BCD |
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -578,16 +578,11 @@ static const struct ide_proc_devset idef
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
 	u16 *id = drive->id;
-	u8 gcw[2];
-
-	*((u16 *)&gcw) = id[ATA_ID_CONFIG];
 
 	drive->pc_callback	 = ide_floppy_callback;
 	drive->pc_update_buffers = idefloppy_update_buffers;
 	drive->pc_io_buffers	 = ide_io_buffers;
 
-	if (((gcw[0] & 0x60) >> 5) == 1)
-		drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.
 	 * Just assume they are all broken, its easier.
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -206,6 +206,8 @@ static inline void do_identify (ide_driv
 		drive->media = type;
 		/* an ATAPI device ignores DRDY */
 		drive->ready_stat = 0;
+		if (ata_id_cdb_intr(id))
+			drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
 		return;
 	}
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2184,7 +2184,6 @@ static void idetape_setup(ide_drive_t *d
 	unsigned long t;
 	int speed;
 	int buffer_size;
-	u8 gcw[2];
 	u16 *ctl = (u16 *)&tape->caps[12];
 
 	drive->pc_callback	 = ide_tape_callback;
@@ -2211,12 +2210,6 @@ static void idetape_setup(ide_drive_t *d
 	tape->name[2] = '0' + minor;
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
-	*((u16 *)&gcw) = drive->id[ATA_ID_CONFIG];
-
-	/* Command packet DRQ type */
-	if (((gcw[0] & 0x60) >> 5) == 1)
-		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
-
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -385,8 +385,6 @@ static const struct ide_proc_devset ides
  */
 static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
-	if ((drive->id[ATA_ID_CONFIG] & 0x0060) == 0x20)
-		set_bit(IDE_AFLAG_DRQ_INTERRUPT, &drive->atapi_flags);
 	clear_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 #if IDESCSI_DEBUG_LOG
 	set_bit(IDESCSI_LOG_CMD, &scsi->log);
