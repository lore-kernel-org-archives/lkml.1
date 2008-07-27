Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYG0S6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYG0S6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbYG0S6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:58:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:45802 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014AbYG0S6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HmjAGj274WnPXsMC/tDA52AQGt71vY+vmuxd7sFhyuUcotLcDHtIQrYgFulzrzsemW
         9vkRbWhNjsST0/cSEA3MN+FiePU1djCgH2E8pIAmS4WRDxdOhEYkWOQtkozaA/8isHt8
         9EObZqApU/I3uRu9Q0O79UKK8hNkQhTbYhOZA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>
Date: Sun, 27 Jul 2008 20:56:10 +0200
Message-Id: <20080727185610.4660.825.sendpatchset@localhost.localdomain>
In-Reply-To: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
References: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/3] ide: call ide_proc_register_driver() later
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call ide_proc_register_driver() in ide*_setup() (just before
ide*_add_settings() call) instead of in ->probe method.

Despite being basically a preparation for /proc/ide/hd*/settings
rework this is a nice cleanup in itself.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against pata tree

 drivers/ide/ide-cd.c     |    5 ++---
 drivers/ide/ide-disk.c   |    4 ++--
 drivers/ide/ide-floppy.c |    4 ++--
 drivers/ide/ide-tape.c   |    3 +--
 drivers/scsi/ide-scsi.c  |    2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1916,6 +1916,8 @@ static int ide_cdrom_setup(ide_drive_t *
 		cd->devinfo.handle = NULL;
 		return 1;
 	}
+
+	ide_proc_register_driver(drive, cd->driver);
 	ide_cdrom_add_settings(drive);
 	return 0;
 }
@@ -2126,8 +2128,6 @@ static int ide_cd_probe(ide_drive_t *dri
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &ide_cdrom_driver);
-
 	kref_init(&info->kref);
 
 	info->drive = drive;
@@ -2142,7 +2142,6 @@ static int ide_cd_probe(ide_drive_t *dri
 	g->driverfs_dev = &drive->gendev;
 	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
-		ide_proc_unregister_driver(drive, &ide_cdrom_driver);
 		ide_cd_release(&info->kref);
 		goto failed;
 	}
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -789,11 +789,13 @@ static inline void idedisk_add_settings(
 
 static void idedisk_setup(ide_drive_t *drive)
 {
+	struct ide_disk_obj *idkp = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long long capacity;
 
+	ide_proc_register_driver(drive, idkp->driver);
 	idedisk_add_settings(drive);
 
 	if (drive->id_read == 0)
@@ -1159,8 +1161,6 @@ static int ide_disk_probe(ide_drive_t *d
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &idedisk_driver);
-
 	kref_init(&idkp->kref);
 
 	idkp->drive = drive;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1060,6 +1060,8 @@ static void idefloppy_setup(ide_drive_t 
 	}
 
 	(void) ide_floppy_get_capacity(drive);
+
+	ide_proc_register_driver(drive, floppy->driver);
 	idefloppy_add_settings(drive);
 }
 
@@ -1412,8 +1414,6 @@ static int ide_floppy_probe(ide_drive_t 
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &idefloppy_driver);
-
 	kref_init(&floppy->kref);
 
 	floppy->drive = drive;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2512,6 +2512,7 @@ static void idetape_setup(ide_drive_t *d
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
+	ide_proc_register_driver(drive, tape->driver);
 	idetape_add_settings(drive);
 }
 
@@ -2667,8 +2668,6 @@ static int ide_tape_probe(ide_drive_t *d
 
 	ide_init_disk(g, drive);
 
-	ide_proc_register_driver(drive, &idetape_driver);
-
 	kref_init(&tape->kref);
 
 	tape->drive = drive;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -459,6 +459,7 @@ static void idescsi_setup (ide_drive_t *
 
 	drive->pc_callback = ide_scsi_callback;
 
+	ide_proc_register_driver(drive, scsi->driver);
 	idescsi_add_settings(drive);
 }
 
@@ -850,7 +851,6 @@ static int ide_scsi_probe(ide_drive_t *d
 	idescsi->host = host;
 	idescsi->disk = g;
 	g->private_data = &idescsi->driver;
-	ide_proc_register_driver(drive, &idescsi_driver);
 	err = 0;
 	idescsi_setup(drive, idescsi);
 	g->fops = &idescsi_ops;
