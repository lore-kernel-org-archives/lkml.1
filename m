Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZBOMIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZBOMIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZBOMIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:19 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:29313 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZBOMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eySj78jc2rA+b4z4/+76IcPJNv3g4sy2ysvhNprZOKypBe9FLlLDRpA+DcNzXXACRo
         OqBZRkerEokGbFMEpV1M6gQxx/RcvP/tADQ6ElYHdaaiSlV25x8pvA5bH5y6jc9eakGl
         d+yvg1keR0ZR084vTuqxZl0CKENqic53DndD8=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 03/10] ide-floppy: use flags query macros
Date: Sun, 15 Feb 2009 13:08:05 +0100
Message-Id: <1234699692-9452-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c       |    6 +++---
 drivers/ide/ide-floppy_ioctl.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b7f0206..8aa21d1 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -336,7 +336,7 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
 	else
 		drive->dev_flags &= ~IDE_DFLAG_WP;
 
-	set_disk_ro(disk, !!(drive->dev_flags & IDE_DFLAG_WP));
+	set_disk_ro(disk, !!ide_drv_write_protected(drive));
 
 	page = &pc->buf[8];
 
@@ -421,7 +421,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 		switch (pc.buf[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
+			if (!ide_drv_clik(drive))
 				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -471,7 +471,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
+	if (!ide_drv_clik(drive))
 		(void) ide_floppy_get_flexible_disk_page(drive, &pc);
 
 	return rc;
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 8f8be85..672202d 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -195,7 +195,7 @@ static int ide_floppy_get_format_progress(ide_drive_t *drive,
 	struct ide_disk_obj *floppy = drive->driver_data;
 	int progress_indication = 0x10000;
 
-	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
+	if (ide_drv_srfp(drive)) {
 		ide_create_request_sense_cmd(drive, pc);
 		if (ide_queue_pc_tail(drive, floppy->disk, pc))
 			return -EIO;
-- 
1.6.0.4

