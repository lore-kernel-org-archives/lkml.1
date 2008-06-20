Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYFTVhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYFTVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761870AbYFTVdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:33:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:6668 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761858AbYFTVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jjrYpVC3+Kmx+L2b+dWv+c7odluOfns0LWRqrxODhuHIEInqq9qJZNPNrGGItujUH8
         wj8YQxsyVqW7pfO/5FOzw84niBxH4t/vdfEpSq7SAUpaKfSgagcMhr2kESNEA4g8CKAl
         H0doToP20gpeSZurgGu1NXg/x6JmT8iAxGjRY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:35:11 +0200
Message-Id: <20080620213511.13202.72125.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/18] ide: add ide_read_ireason() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_read_ireason() helper and use instead of ->INB for reading
ATAPI Interrupt Reason register.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |   17 ++++++++++++++---
 drivers/ide/ide-iops.c  |   13 +++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -183,16 +183,27 @@ cmd_finished:
 }
 EXPORT_SYMBOL_GPL(ide_pc_intr);
 
+static u8 ide_read_ireason(ide_drive_t *drive)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_NSECT;
+
+	drive->hwif->tf_read(drive, &task);
+
+	return task.tf.nsect & 3;
+}
+
 static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 {
-	ide_hwif_t *hwif = drive->hwif;
 	int retries = 100;
 
 	while (retries-- && ((ireason & CD) == 0 || (ireason & IO))) {
 		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
 		udelay(100);
-		ireason = hwif->INB(hwif->io_ports.nsect_addr);
+		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
 			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
 					"a packet command, ignoring\n",
@@ -219,7 +230,7 @@ ide_startstop_t ide_transfer_pc(ide_driv
 		return startstop;
 	}
 
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	ireason = ide_read_ireason(drive);
 	if (drive->media == ide_tape && !drive->scsi)
 		ireason = ide_wait_ireason(drive, ireason);
 
