Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZAOU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZAOU33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763212AbZAOUBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:31 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56109 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbZAOUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bRhG1LK0DIHHCB2IqrDAl+W8rFPewyyslEWSXvEiDhSln3SkjJDFc97cP8HQzsyaDz
         nHIDohm2arwjN5/EDPul1BEeoj8Zfm4WyN/G3++stSyeGb2X9gAUlEEA4KJYIiIVAsr4
         8IrqTb5geyYoBb/hPC0vHgZqETEqrRQ3t+PU0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:01:22 +0100
Message-Id: <20090115200122.17294.13465.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ide: move ide_do_park_unpark() to ide-park.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ide_do_park_unpark() to ide-park.c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c   |   24 ------------------------
 drivers/ide/ide-park.c |   25 +++++++++++++++++++++++++
 include/linux/ide.h    |    2 ++
 3 files changed, 27 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -524,30 +524,6 @@ static ide_startstop_t ide_do_devset(ide
 	return ide_stopped;
 }
 
-static ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
-{
-	ide_task_t task;
-	struct ide_taskfile *tf = &task.tf;
-
-	memset(&task, 0, sizeof(task));
-	if (rq->cmd[0] == REQ_PARK_HEADS) {
-		drive->sleep = *(unsigned long *)rq->special;
-		drive->dev_flags |= IDE_DFLAG_SLEEPING;
-		tf->command = ATA_CMD_IDLEIMMEDIATE;
-		tf->feature = 0x44;
-		tf->lbal = 0x4c;
-		tf->lbam = 0x4e;
-		tf->lbah = 0x55;
-		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
-	} else		/* cmd == REQ_UNPARK_HEADS */
-		tf->command = ATA_CMD_CHK_POWER;
-
-	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	task.rq = rq;
-	drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
-	return do_rw_taskfile(drive, &task);
-}
-
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
 	u8 cmd = rq->cmd[0];
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
+#include <linux/hdreg.h>
 #include <linux/jiffies.h>
 #include <linux/blkdev.h>
 
@@ -60,6 +61,30 @@ out:
 	return;
 }
 
+ide_startstop_t ide_do_park_unpark(ide_drive_t *drive, struct request *rq)
+{
+	ide_task_t task;
+	struct ide_taskfile *tf = &task.tf;
+
+	memset(&task, 0, sizeof(task));
+	if (rq->cmd[0] == REQ_PARK_HEADS) {
+		drive->sleep = *(unsigned long *)rq->special;
+		drive->dev_flags |= IDE_DFLAG_SLEEPING;
+		tf->command = ATA_CMD_IDLEIMMEDIATE;
+		tf->feature = 0x44;
+		tf->lbal = 0x4c;
+		tf->lbam = 0x4e;
+		tf->lbah = 0x55;
+		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+	} else		/* cmd == REQ_UNPARK_HEADS */
+		tf->command = ATA_CMD_CHK_POWER;
+
+	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	task.rq = rq;
+	drive->hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, &task);
+}
+
 ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1167,6 +1167,8 @@ int ide_busy_sleep(ide_hwif_t *, unsigne
 
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
+ide_startstop_t ide_do_park_unpark(ide_drive_t *, struct request *);
+
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
 
 extern int ide_devset_execute(ide_drive_t *drive,
