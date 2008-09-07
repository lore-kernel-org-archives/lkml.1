Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYIGWTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYIGWTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYIGWRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25685 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbYIGWR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=JplE0alivsC4f692LqP21fCv5NcjxdG7lqKrXWBatVpuRqU94jH3vW0FOVJAJ6UmIu
         mQ6ztKf01LjfH8D0hPIpEQy8+mKVmIwc3BVyOee/gmxKrwyeewIE4gyP8Ez9/H2bbxIf
         iPMtG/j0yCihKFyATgrDTeqqcPbqhd0PXiwK4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:15:19 +0200
Message-Id: <20080907221519.24285.44318.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/18] ide-floppy: use drive->capacity64 for caching current capacity
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use drive->capacity64 for caching current capacity.

* Switch ide_floppy_capacity() to use drive->capacity64.

* Call set_capacity() in idefloppy_open() and ide_floppy_probe()
  instead of ide_floppy_get_capacity().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -445,7 +445,9 @@ static int ide_floppy_get_flexible_disk_
 			drive->name, lba_capacity, capacity);
 		floppy->blocks = floppy->block_size ?
 			capacity / floppy->block_size : 0;
+		drive->capacity64 = floppy->blocks * floppy->bs_factor;
 	}
+
 	return 0;
 }
 
@@ -466,7 +468,7 @@ static int ide_floppy_get_capacity(ide_d
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
 	floppy->bs_factor = 1;
-	set_capacity(floppy->disk, 0);
+	drive->capacity64 = 0;
 
 	ide_floppy_create_read_capacity_cmd(&pc);
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
@@ -523,6 +525,8 @@ static int ide_floppy_get_capacity(ide_d
 					       "non 512 bytes block size not "
 					       "fully supported\n",
 					       drive->name);
+				drive->capacity64 =
+					floppy->blocks * floppy->bs_factor;
 				rc = 0;
 			}
 			break;
@@ -547,17 +551,12 @@ static int ide_floppy_get_capacity(ide_d
 	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
 		(void) ide_floppy_get_flexible_disk_page(drive);
 
-	set_capacity(disk, floppy->blocks * floppy->bs_factor);
-
 	return rc;
 }
 
 sector_t ide_floppy_capacity(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	unsigned long capacity = floppy->blocks * floppy->bs_factor;
-
-	return capacity;
+	return drive->capacity64;
 }
 
 static void idefloppy_setup(ide_drive_t *drive)
@@ -671,14 +670,16 @@ static int idefloppy_open(struct inode *
 		if (ide_do_test_unit_ready(drive, disk))
 			ide_do_start_stop(drive, disk, 1);
 
-		if (ide_floppy_get_capacity(drive)
-		   && (filp->f_flags & O_NDELAY) == 0
+		ret = ide_floppy_get_capacity(drive);
+
+		set_capacity(disk, ide_floppy_capacity(drive));
+
+		if (ret && (filp->f_flags & O_NDELAY) == 0) {
 		    /*
 		     * Allow O_NDELAY to open a drive without a disk, or with an
 		     * unreadable disk, so that we can get the format capacity
 		     * of the drive or begin the format - Sam
 		     */
-		    ) {
 			ret = -EIO;
 			goto out_put_floppy;
 		}
@@ -811,6 +812,8 @@ static int ide_floppy_probe(ide_drive_t 
 
 	idefloppy_setup(drive);
 
+	set_capacity(g, ide_floppy_capacity(drive));
+
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
