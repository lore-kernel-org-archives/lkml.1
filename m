Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYIGWTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYIGWTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbYIGWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbYIGWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:17:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YFWoVjR1qADi8yyFAVXn1WI0BHR3kFjC85ZjyViVU4aPf2ahr9ofqdszbG7TTGxfAe
         eQ44Jxfnf1qjRDNkTgQXnOejq/E3u7hBMDiO12F2J8Y1xiC18W8WPCXhrwW72jRKMwkh
         gYdi6ACOOOkUaSCDMj/TC4TuvNOiqAJSzeLC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:15:05 +0200
Message-Id: <20080907221505.24285.68294.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/18] ide-{disk,floppy}: set IDE_DFLAG_ATTACH in *_setup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c   |   18 ++++++++++--------
 drivers/ide/ide-floppy.c |    3 ++-
 2 files changed, 12 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -710,6 +710,14 @@ static void idedisk_setup(ide_drive_t *d
 		drive->dev_flags |= IDE_DFLAG_WCACHE;
 
 	set_wcache(drive, 1);
+
+	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
+	    (drive->head == 0 || drive->head > 16)) {
+		printk(KERN_ERR "%s: invalid geometry: %d physical heads?\n",
+			drive->name, drive->head);
+		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
+	} else
+		drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
 
 static void ide_cacheflush_p(ide_drive_t *drive)
@@ -952,19 +960,13 @@ static int ide_disk_probe(ide_drive_t *d
 	drive->driver_data = idkp;
 
 	idedisk_setup(drive);
-	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
-	    (drive->head == 0 || drive->head > 16)) {
-		printk(KERN_ERR "%s: INVALID GEOMETRY: %d PHYSICAL HEADS?\n",
-			drive->name, drive->head);
-		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
-	} else
-		drive->dev_flags |= IDE_DFLAG_ATTACH;
+
+	set_capacity(g, ide_disk_capacity(drive));
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
-	set_capacity(g, ide_disk_capacity(drive));
 	g->fops = &idedisk_ops;
 	add_disk(g);
 	return 0;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -598,6 +598,8 @@ static void idefloppy_setup(ide_drive_t 
 	(void) ide_floppy_get_capacity(drive);
 
 	ide_proc_register_driver(drive, floppy->driver);
+
+	drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
 
 static void ide_floppy_remove(ide_drive_t *drive)
@@ -807,7 +809,6 @@ static int ide_floppy_probe(ide_drive_t 
 	drive->debug_mask = debug_mask;
 
 	idefloppy_setup(drive, floppy);
-	drive->dev_flags |= IDE_DFLAG_ATTACH;
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
