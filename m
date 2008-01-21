Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYAUXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYAUXXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759921AbYAUXTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:19:02 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761042AbYAUXTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bYuYw8g+blHYimgc0uiUAbK6H11A5bpV1GQuS6Ebru4ZL06wmkmBh6L6LQlD5djITYbz3hQuqhoNHg+MyH4iXuJI3CENM5JyzhJvZqWakI0jg/uxGQvKn+7OYn3pNXWLyVXxg2OBZXcPioD9fyOtzAdFqAiHwrRQSIAB52+EXk8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:32:05 +0100
Message-Id: <20080121233205.30311.62567.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/16] ide: remove ide_ata66_check()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c     |   15 ---------------
 drivers/ide/ide-taskfile.c |    5 ++++-
 include/linux/ide.h        |    1 -
 3 files changed, 4 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -612,21 +612,6 @@ no_80w:
 	return 0;
 }
 
-int ide_ata66_check (ide_drive_t *drive, ide_task_t *args)
-{
-	if (args->tf.command == WIN_SETFEATURES &&
-	    args->tf.nsect > XFER_UDMA_2 &&
-	    args->tf.feature == SETFEATURES_XFER) {
-		if (eighty_ninty_three(drive) == 0) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
-			return 1;
-		}
-	}
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
@@ -798,8 +798,11 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 	    tf->nsect >= XFER_SW_DMA_0 &&
 	    (id->dma_ultra || id->dma_mword || id->dma_1word)) {
 		xfer_rate = args[1];
-		if (ide_ata66_check(drive, &tfargs))
+		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
+			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
+					    "be set\n", drive->name);
 			goto abort;
+		}
 	}
 
 	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -990,7 +990,6 @@ int ide_task_ioctl(ide_drive_t *, unsign
 extern int system_bus_clock(void);
 
 extern int ide_driveid_update(ide_drive_t *);
-extern int ide_ata66_check(ide_drive_t *, ide_task_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
 extern u8 eighty_ninty_three (ide_drive_t *);
 extern int taskfile_lib_get_identify(ide_drive_t *drive, u8 *);
