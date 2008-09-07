Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYIGWRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYIGWRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYIGWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:16:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:2411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYIGWQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=h0YZpo+EDWxncOfzOG0/MIyxdTW2PpLMpq7x/74/M9wqJo3joNugdz/DysCICBaEbO
         CeKkaYfxS1eFVfQNnGjrGpQZTJ5RXzihtl/P9c87dhSy+bZGEVPnWYwWzhvbByYZ21FA
         7lDJBMfOE0/rUnWfW+EPqZGAsgfwtQYYiD51Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:14:30 +0200
Message-Id: <20080907221430.24285.1307.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/18] ide-disk: fix IDE_DFLAG_LBA48 handling on resume
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code in idedisk_setup() should be in idedisk_capacity() instead.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -397,6 +397,26 @@ static void init_idedisk_capacity(ide_dr
 		if (ata_id_hpa_enabled(id))
 			idedisk_check_hpa(drive);
 	}
+
+	/* limit drive capacity to 137GB if LBA48 cannot be used */
+	if ((drive->dev_flags & IDE_DFLAG_LBA48) == 0 &&
+	    drive->capacity64 > 1ULL << 28) {
+		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
+		       "%llu sectors (%llu MB)\n",
+		       drive->name, (unsigned long long)drive->capacity64,
+		       sectors_to_MB(drive->capacity64));
+		drive->capacity64 = 1ULL << 28;
+	}
+
+	if ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
+	    (drive->dev_flags & IDE_DFLAG_LBA48)) {
+		if (drive->capacity64 > 1ULL << 28) {
+			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
+					 " will be used for accessing sectors "
+					 "> %u\n", drive->name, 1 << 28);
+		} else
+			drive->dev_flags &= ~IDE_DFLAG_LBA48;
+	}
 }
 
 sector_t ide_disk_capacity(ide_drive_t *drive)
@@ -648,26 +668,6 @@ static void idedisk_setup(ide_drive_t *d
 	/* calculate drive capacity, and select LBA if possible */
 	init_idedisk_capacity(drive);
 
-	/* limit drive capacity to 137GB if LBA48 cannot be used */
-	if ((drive->dev_flags & IDE_DFLAG_LBA48) == 0 &&
-	    drive->capacity64 > 1ULL << 28) {
-		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
-		       "%llu sectors (%llu MB)\n",
-		       drive->name, (unsigned long long)drive->capacity64,
-		       sectors_to_MB(drive->capacity64));
-		drive->capacity64 = 1ULL << 28;
-	}
-
-	if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
-	    (drive->dev_flags & IDE_DFLAG_LBA48)) {
-		if (drive->capacity64 > 1ULL << 28) {
-			printk(KERN_INFO "%s: cannot use LBA48 DMA - PIO mode"
-					 " will be used for accessing sectors "
-					 "> %u\n", drive->name, 1 << 28);
-		} else
-			drive->dev_flags &= ~IDE_DFLAG_LBA48;
-	}
-
 	/*
 	 * if possible, give fdisk access to more of the drive,
 	 * by correcting bios_cyls:
