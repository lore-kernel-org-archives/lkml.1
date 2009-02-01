Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZBAT3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZBAT3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZBAT1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:27:47 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:21944 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbZBAT1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Fs0hCVO3MmAY1FetM9H0GAFzHLiOS27pmdz0SN13JZCWusBd1ZGA3iELvtjBULSx1T
         jq097Ppr6INqPR14NnER8DTcXj/duiQSuz0VuYFIl7bswiS2eDIKDMJepfrZBEd+yHH0
         h50/y+V1Lb5Jsdt3Vk1ZnoLepawGNVEtqN8gU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:28:38 +0100
Message-Id: <20090201192838.1592.16234.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
References: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] ide: return request status from ->pc_callback method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: return request status from ->pc_callback method

Make ->pc_callback method return request status and then move
the request completion from ->pc_callback to ide_pc_intr().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   12 +++++++++++-
 drivers/ide/ide-floppy.c |   12 ++++--------
 drivers/ide/ide-tape.c   |   10 ++--------
 include/linux/ide.h      |    2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -345,6 +345,8 @@ static ide_startstop_t ide_pc_intr(ide_d
 
 	/* No more interrupts */
 	if ((stat & ATA_DRQ) == 0) {
+		int uptodate;
+
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
 
@@ -383,7 +385,15 @@ static ide_startstop_t ide_pc_intr(ide_d
 			dsc = 1;
 
 		/* Command finished - Call the callback function */
-		drive->pc_callback(drive, dsc);
+		uptodate = drive->pc_callback(drive, dsc);
+
+		if (uptodate == 0)
+			drive->failed_pc = NULL;
+
+		if (blk_special_request(rq))
+			ide_complete_rq(drive, 0);
+		else
+			ide_end_request(drive, uptodate, 0);
 
 		return ide_stopped;
 	}
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -71,7 +71,7 @@ static void idefloppy_update_buffers(ide
 		ide_end_request(drive, 1, 0);
 }
 
-static void ide_floppy_callback(ide_drive_t *drive, int dsc)
+static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
@@ -108,14 +108,10 @@ static void ide_floppy_callback(ide_driv
 			       "Aborting request!\n");
 	}
 
-	if (uptodate == 0)
-		drive->failed_pc = NULL;
-
-	if (blk_special_request(rq)) {
+	if (blk_special_request(rq))
 		rq->errors = uptodate ? 0 : IDE_DRV_ERROR_GENERAL;
-		ide_complete_rq(drive, 0);
-	} else
-		ide_end_request(drive, uptodate, 0);
+
+	return uptodate;
 }
 
 static void ide_floppy_report_error(struct ide_disk_obj *floppy,
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -463,7 +463,7 @@ static void ide_tape_kfree_buffer(idetap
 
 static void ide_tape_handle_dsc(ide_drive_t *);
 
-static void ide_tape_callback(ide_drive_t *drive, int dsc)
+static int ide_tape_callback(ide_drive_t *drive, int dsc)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
@@ -530,13 +530,7 @@ static void ide_tape_callback(ide_drive_
 
 	rq->errors = err;
 
-	if (uptodate == 0)
-		drive->failed_pc = NULL;
-
-	if (blk_special_request(rq))
-		ide_complete_rq(drive, 0);
-	else
-		ide_end_request(drive, uptodate, 0);
+	return uptodate;
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -619,7 +619,7 @@ struct ide_drive_s {
 	struct ide_atapi_pc *failed_pc;
 
 	/* callback for packet commands */
-	void (*pc_callback)(struct ide_drive_s *, int);
+	int  (*pc_callback)(struct ide_drive_s *, int);
 
 	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
 	int  (*pc_io_buffers)(struct ide_drive_s *, struct ide_atapi_pc *,
