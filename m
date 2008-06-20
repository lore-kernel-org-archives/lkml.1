Return-Path: <linux-kernel-owner+w=401wt.eu-S1763357AbYFTVhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763357AbYFTVhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761835AbYFTVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:33:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbYFTVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wzYhsjZ7MzoCWL7/3uXsvIynL4wapQLrgBjuTFGO5c1CoX7VCtVOcD/XSZ7adUinIG
         8BrCN9BmK9+m8i2JgNbN/U/qxxyu4kBdlu0JgAcDqGAFQmXR/zr2mUAIHqEkxU0hjwoW
         caWsvT3bSOXREj0DlzWulPP71rpLcvXdS1tek=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:35:05 +0200
Message-Id: <20080620213505.13202.27589.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/18] ide: add ide_read_device() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_read_device() helper and convert do_probe() to use it
instead of ->INB.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -410,6 +410,18 @@ static int ide_busy_sleep(ide_hwif_t *hw
 	return 1;
 }
 
+static u8 ide_read_device(ide_drive_t *drive)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_DEVICE;
+
+	drive->hwif->tf_read(drive, &task);
+
+	return task.tf.device;
+}
+
 /**
  *	do_probe		-	probe an IDE device
  *	@drive: drive to probe
@@ -434,7 +446,6 @@ static int ide_busy_sleep(ide_hwif_t *hw
 static int do_probe (ide_drive_t *drive, u8 cmd)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int rc;
 	u8 stat;
 
@@ -455,8 +466,8 @@ static int do_probe (ide_drive_t *drive,
 	msleep(50);
 	SELECT_DRIVE(drive);
 	msleep(50);
-	if (hwif->INB(io_ports->device_addr) != drive->select.all &&
-	    !drive->present) {
+
+	if (ide_read_device(drive) != drive->select.all && !drive->present) {
 		if (drive->select.b.unit != 0) {
 			/* exit with drive0 selected */
 			SELECT_DRIVE(&hwif->drives[0]);
