Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYFTVfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYFTVfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761603AbYFTVco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:32:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22730 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761581AbYFTVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YFWPqDJPF9fPjaFVzwhyDtUGD+K06epqunZC+7zV2A48CRoZVr36aLWz3YJgunjTkt
         wty4/Y+7+hQNr4jP2qyQO+yEc7lcpleWQZfDm1V3DOZvv/gL4mUqOSEAr5nzmH4v8ulV
         K5aWnbpiWl5qEPm29/9E57WHqaL/2G0yhRMGE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:34:38 +0200
Message-Id: <20080620213438.13202.76315.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/18] ide: use ->tf_load in ide_config_drive_speed()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ide_config_drive_speed() to use ->tf_load instead of ->OUTB.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -792,9 +792,9 @@ int ide_driveid_update(ide_drive_t *driv
 int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int error = 0;
 	u8 stat;
+	ide_task_t task;
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->dma_ops)	/* check if host supports DMA */
@@ -828,9 +828,16 @@ int ide_config_drive_speed(ide_drive_t *
 	SELECT_MASK(drive, 0);
 	udelay(1);
 	hwif->set_irq(hwif, 0);
-	hwif->OUTB(SETFEATURES_XFER, io_ports->feature_addr);
-	hwif->OUTB(speed, io_ports->nsect_addr);
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_OUT_FEATURE | IDE_TFLAG_OUT_NSECT;
+	task.tf.feature = SETFEATURES_XFER;
+	task.tf.nsect   = speed;
+
+	hwif->tf_load(drive, &task);
+
 	hwif->exec_command(hwif, WIN_SETFEATURES);
+
 	if (drive->quirk_list == 2)
 		hwif->set_irq(hwif, 1);
 
