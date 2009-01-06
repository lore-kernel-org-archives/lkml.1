Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZAFSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZAFSf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZAFSfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:35:09 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63672 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZAFSfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=s7swsP8KVWrnRGbAIxwfC/3sGwucYkejr8nEBgOZkv0U1yeO1AOzPsnXU4b9ZnUYJ9
         1SbsLKcI0SSG8vCnV+BCNlxFvi8jaNKsfXaGVRQWwN0K3/pGJ/QnzjxW4k526oXRD9K0
         3PGORK9rAELRh3mTgAa7d0yl732pgnRusofOA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:35:47 +0100
Message-Id: <20090106183547.21193.43620.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] ide: move ide_pktcmd_tf_load() to ide-atapi.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ide_pktcmd_tf_load() to ide-atapi.c

Then make it static and remove 'dma' argument.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |   21 ++++++++++++++++++++-
 drivers/ide/ide-io.c    |   20 --------------------
 include/linux/ide.h     |    2 --
 3 files changed, 20 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -444,6 +444,25 @@ next_irq:
 	return ide_started;
 }
 
+static void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t task;
+	u8 dma = drive->dma;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
+			IDE_TFLAG_OUT_FEATURE | tf_flags;
+	task.tf.feature = dma;		/* Use PIO/DMA */
+	task.tf.lbam    = bcount & 0xff;
+	task.tf.lbah    = (bcount >> 8) & 0xff;
+
+	ide_tf_dump(drive->name, &task.tf);
+	hwif->tp_ops->set_irq(hwif, 1);
+	SELECT_MASK(drive, 0);
+	hwif->tp_ops->tf_load(drive, &task);
+}
+
 static u8 ide_read_ireason(ide_drive_t *drive)
 {
 	ide_task_t task;
@@ -617,7 +636,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 						       : WAIT_TAPE_CMD;
 	}
 
-	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
+	ide_pktcmd_tf_load(drive, tf_flags, bcount);
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1188,26 +1188,6 @@ void ide_do_drive_cmd(ide_drive_t *drive
 }
 EXPORT_SYMBOL(ide_do_drive_cmd);
 
-void ide_pktcmd_tf_load(ide_drive_t *drive, u32 tf_flags, u16 bcount, u8 dma)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	ide_task_t task;
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
-			IDE_TFLAG_OUT_FEATURE | tf_flags;
-	task.tf.feature = dma;		/* Use PIO/DMA */
-	task.tf.lbam    = bcount & 0xff;
-	task.tf.lbah    = (bcount >> 8) & 0xff;
-
-	ide_tf_dump(drive->name, &task.tf);
-	hwif->tp_ops->set_irq(hwif, 1);
-	SELECT_MASK(drive, 0);
-	hwif->tp_ops->tf_load(drive, &task);
-}
-
-EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
-
 void ide_pad_transfer(ide_drive_t *drive, int write, int len)
 {
 	ide_hwif_t *hwif = drive->hwif;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1200,8 +1200,6 @@ void ide_read_bcount_and_ireason(ide_dri
 
 extern int drive_is_ready(ide_drive_t *);
 
-void ide_pktcmd_tf_load(ide_drive_t *, u32, u16, u8);
-
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
