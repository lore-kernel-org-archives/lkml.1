Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYIGWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYIGWVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYIGWR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:58901 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbYIGWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vTD7bPdRFA5HoHJJp8E6UIrXg2lXY3QuqbezBFYE1wk/ZtEhqJmna2w2bn33hpPIDw
         2GZynbdeMxmaxU/qBZe/h1q7GMutwwW9vaW93M1Q7k63YvYP2qNfU47pbC3G70smAlz4
         W03CUHNwW0IX/U0iMlJIZdmk6BKR5Z7/J4DFM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:15:47 +0200
Message-Id: <20080907221547.24285.6098.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/18] ide: remove IDE_AFLAG_NO_DOORLOCKING
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use IDE_DFLAG_DOORLOCKING instead.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |    2 +-
 drivers/ide/ide-cd.c       |    2 +-
 drivers/ide/ide-cd_ioctl.c |    4 ++--
 drivers/ide/ide-floppy.c   |    2 +-
 drivers/ide/ide-probe.c    |    1 +
 drivers/ide/ide-tape.c     |    2 +-
 include/linux/ide.h        |    2 --
 7 files changed, 7 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -191,7 +191,7 @@ int ide_set_media_lock(ide_drive_t *driv
 {
 	struct ide_atapi_pc pc;
 
-	if (drive->atapi_flags & IDE_AFLAG_NO_DOORLOCK)
+	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
 		return 0;
 
 	ide_init_pc(&pc);
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1635,7 +1635,7 @@ static int ide_cdrom_probe_capabilities(
 		return 0;
 
 	if ((buf[8 + 6] & 0x01) == 0)
-		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
+		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 	if (buf[8 + 6] & 0x08)
 		drive->atapi_flags &= ~IDE_AFLAG_NO_EJECT;
 	if (buf[8 + 3] & 0x01)
Index: b/drivers/ide/ide-cd_ioctl.c
===================================================================
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -136,7 +136,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, 
 		sense = &my_sense;
 
 	/* If the drive cannot lock the door, just pretend. */
-	if (drive->atapi_flags & IDE_AFLAG_NO_DOORLOCK) {
+	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0) {
 		stat = 0;
 	} else {
 		unsigned char cmd[BLK_MAX_CDB];
@@ -157,7 +157,7 @@ int ide_cd_lockdoor(ide_drive_t *drive, 
 	    (sense->asc == 0x24 || sense->asc == 0x20)) {
 		printk(KERN_ERR "%s: door locking not supported\n",
 			drive->name);
-		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
+		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 		stat = 0;
 	}
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -592,7 +592,7 @@ static void idefloppy_setup(ide_drive_t 
 		blk_queue_max_sectors(drive->queue, 64);
 		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
+		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 	}
 
 	(void) ide_floppy_get_capacity(drive);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -208,6 +208,7 @@ static inline void do_identify (ide_driv
 		drive->ready_stat = 0;
 		if (ata_id_cdb_intr(id))
 			drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
+		drive->dev_flags |= IDE_DFLAG_DOORLOCKING;
 		return;
 	}
 
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2107,7 +2107,7 @@ static void idetape_get_mode_sense_resul
 
 	/* device lacks locking support according to capabilities page */
 	if ((caps[6] & 1) == 0)
-		drive->atapi_flags |= IDE_AFLAG_NO_DOORLOCK;
+		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
 
 	if (caps[7] & 0x02)
 		tape->blk_size = 512;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -462,8 +462,6 @@ struct ide_acpi_hwif_link;
 /* ATAPI device flags */
 enum {
 	IDE_AFLAG_DRQ_INTERRUPT		= (1 << 0),
-	/* Drive cannot lock the door. */
-	IDE_AFLAG_NO_DOORLOCK		= (1 << 2),
 
 	/* ide-cd */
 	/* Drive cannot eject the disc. */
