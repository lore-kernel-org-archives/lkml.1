Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYAUXWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYAUXWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbYAUXS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:18:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760952AbYAUXSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:18:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ov/dzEREfQ4PKdiHRH1AR3R1wMvP0Qe6515IT5t8X8QxAmzDCnQ7IpnkrvqUI/bx3HmCYixA30/r8cg2ZbLTHBOF1sMqMapdu2T6j0PNZntMcCOCFImh52VQGAItywBu280N++aydoSE1eRYzfvQjpQYdk2oQbEZS5mhbBJZVO0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:31:57 +0100
Message-Id: <20080121233157.30311.41552.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/16] ide: remove set_transfer()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c     |   18 ------------------
 drivers/ide/ide-taskfile.c |    6 +++++-
 include/linux/ide.h        |    1 -
 3 files changed, 5 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -627,24 +627,6 @@ int ide_ata66_check (ide_drive_t *drive,
 	return 0;
 }
 
-/*
- * Backside of HDIO_DRIVE_CMD call of SETFEATURES_XFER.
- * 1 : Safe to update drive->id DMA registers.
- * 0 : OOPs not allowed.
- */
-int set_transfer (ide_drive_t *drive, ide_task_t *args)
-{
-	if (args->tf.command == WIN_SETFEATURES &&
-	    args->tf.nsect >= XFER_SW_DMA_0 &&
-	    args->tf.feature == SETFEATURES_XFER &&
-	    (drive->id->dma_ultra ||
-	     drive->id->dma_mword ||
-	     drive->id->dma_1word))
-		return 1;
-
-	return 0;
-}
-
 #ifdef CONFIG_BLK_DEV_IDEDMA
 static u8 ide_auto_reduce_xfer (ide_drive_t *drive)
 {
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -755,6 +755,7 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 	u8 args[4], xfer_rate = 0;
 	ide_task_t tfargs;
 	struct ide_taskfile *tf = &tfargs.tf;
+	struct hd_driveid *id = drive->id;
 
 	if (NULL == (void *) arg) {
 		struct request rq;
@@ -792,7 +793,10 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 			return -ENOMEM;
 	}
 
-	if (set_transfer(drive, &tfargs)) {
+	if (tf->command == WIN_SETFEATURES &&
+	    tf->feature == SETFEATURES_XFER &&
+	    tf->nsect >= XFER_SW_DMA_0 &&
+	    (id->dma_ultra || id->dma_mword || id->dma_1word)) {
 		xfer_rate = args[1];
 		if (ide_ata66_check(drive, &tfargs))
 			goto abort;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -993,7 +993,6 @@ extern int ide_driveid_update(ide_drive_
 extern int ide_ata66_check(ide_drive_t *, ide_task_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
-extern int set_transfer(ide_drive_t *, ide_task_t *);
 extern int taskfile_lib_get_identify(ide_drive_t *drive, u8 *);
 
 extern int ide_wait_not_busy(ide_hwif_t *hwif, unsigned long timeout);
