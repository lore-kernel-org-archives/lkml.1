Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZETPda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZETPda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbZETPcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:32:22 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60721 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbZETPcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ltzprRXDrIYnbwDx/QeJppcueLOas+sBTq3b1ysXRGrv509EVd+s5UjFiplUEruC2M
         Co2l0V73E6X+Hnlxoa81RBkQ1I2FXka4GlbrxnSTNp8FRdAlI2IO9CJCWg9CA7fQA+fQ
         IwIT3KnqLQvt2yR2vjGzMcgUogSumhQ2FEL1Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide: add IDE_DFLAG_NIEN_QUIRK device flag
Date: Wed, 20 May 2009 17:35:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201735.15489.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IDE_DFLAG_NIEN_QUIRK device flag and use it instead of
drive->quirk_list.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/hpt366.c   |    2 +-
 drivers/ide/ide-eh.c   |    5 +++--
 drivers/ide/ide-io.c   |    8 ++++++--
 drivers/ide/ide-iops.c |    6 ++----
 include/linux/ide.h    |    2 +-
 5 files changed, 13 insertions(+), 10 deletions(-)

Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -727,7 +727,7 @@ static void hpt3xx_maskproc(ide_drive_t 
 	struct pci_dev	*dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 
-	if (drive->quirk_list == 0)
+	if ((drive->dev_flags & IDE_DFLAG_NIEN_QUIRK) == 0)
 		return;
 
 	if (info->chip_type >= HPT370) {
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -408,8 +408,9 @@ static ide_startstop_t do_reset1(ide_dri
 	/* more than enough time */
 	udelay(10);
 	/* clear SRST, leave nIEN (unless device is on the quirk list) */
-	tp_ops->write_devctl(hwif, (drive->quirk_list == 2 ? 0 : ATA_NIEN) |
-			     ATA_DEVCTL_OBS);
+	tp_ops->write_devctl(hwif,
+		((drive->dev_flags & IDE_DFLAG_NIEN_QUIRK) ? 0 : ATA_NIEN) |
+		 ATA_DEVCTL_OBS);
 	/* more than enough time */
 	udelay(10);
 	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -503,11 +503,15 @@ repeat:
 
 		if ((hwif->host->host_flags & IDE_HFLAG_SERIALIZE) &&
 		    hwif != prev_port) {
+			ide_drive_t *cur_dev =
+				prev_port ? prev_port->cur_dev : NULL;
+
 			/*
 			 * set nIEN for previous port, drives in the
-			 * quirk_list may not like intr setups/cleanups
+			 * quirk list may not like intr setups/cleanups
 			 */
-			if (prev_port && prev_port->cur_dev->quirk_list == 0)
+			if (cur_dev &&
+			    (cur_dev->dev_flags & IDE_DFLAG_NIEN_QUIRK) == 0)
 				prev_port->tp_ops->write_devctl(prev_port,
 								ATA_NIEN |
 								ATA_DEVCTL_OBS);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -287,11 +287,9 @@ void ide_check_nien_quirk_list(ide_drive
 
 	for (list = nien_quirk_list; *list != NULL; list++)
 		if (strstr(m, *list) != NULL) {
-			drive->quirk_list = 2;
+			drive->dev_flags |= IDE_DFLAG_NIEN_QUIRK;
 			return;
 		}
-
-	drive->quirk_list = 0;
 }
 
 int ide_driveid_update(ide_drive_t *drive)
@@ -377,7 +375,7 @@ int ide_config_drive_speed(ide_drive_t *
 
 	tp_ops->exec_command(hwif, ATA_CMD_SET_FEATURES);
 
-	if (drive->quirk_list == 2)
+	if (drive->dev_flags & IDE_DFLAG_NIEN_QUIRK)
 		tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
 
 	error = __ide_wait_stat(drive, drive->ready_stat,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -474,6 +474,7 @@ enum {
 	IDE_DFLAG_NICE1			= (1 << 5),
 	/* device is physically present */
 	IDE_DFLAG_PRESENT		= (1 << 6),
+	IDE_DFLAG_NIEN_QUIRK		= (1 << 7),
 	/* id read from device (synthetic if not set) */
 	IDE_DFLAG_ID_READ		= (1 << 8),
 	IDE_DFLAG_NOPROBE		= (1 << 9),
@@ -543,7 +544,6 @@ struct ide_drive_s {
 	u8	waiting_for_dma;	/* dma currently in progress */
 	u8	dma;			/* atapi dma flag */
 
-        u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
         u8	current_speed;	/* current transfer rate set */
 	u8	desired_speed;	/* desired transfer rate set */
