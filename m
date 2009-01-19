Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbZASND0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbZASND0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbZASNCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:02:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46333 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128AbZASNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Vc1G/NjoLBC620tjcMa9KSLnRguP5YaHfZswTbUPwj5xFKRNzbDXUeBdfBF6RUNP4N
         wGN+5fpjwWbToXIlD8/GmSsTtMiYv/ciq2CS1BKYrFlGatnDNuCz8qilo0lYc0tYNNl7
         jUR9FGZVbeHpmsDJMZK+ri8iLFeOjJjIcXcjg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 14:03:16 +0100
Message-Id: <20090119130316.24745.95023.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/6] ide: move ide_read_bcount_and_ireason() to ide-atapi.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ide_read_bcount_and_ireason() to ide-atapi.c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |   15 +++++++++++++++
 drivers/ide/ide-iops.c  |   15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -288,6 +288,21 @@ int ide_cd_get_xferlen(struct request *r
 }
 EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
 
+void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
+			IDE_TFLAG_IN_NSECT;
+
+	drive->hwif->tp_ops->tf_read(drive, &task);
+
+	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
+	*ireason = task.tf.nsect & 3;
+}
+EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
+
 /*
  * This is the usual interrupt handler which will be called during a packet
  * command.  We will transfer some of the data (as requested by the drive)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -360,21 +360,6 @@ u8 ide_read_error(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
-void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
-{
-	ide_task_t task;
-
-	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
-			IDE_TFLAG_IN_NSECT;
-
-	drive->hwif->tp_ops->tf_read(drive, &task);
-
-	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
-	*ireason = task.tf.nsect & 3;
-}
-EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
-
 const struct ide_tp_ops default_tp_ops = {
 	.exec_command		= ide_exec_command,
 	.read_status		= ide_read_status,
