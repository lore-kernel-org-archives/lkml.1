Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZBOMLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZBOMLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZBOMIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:38 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36839 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZBOMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mcSKv3FIgQcwmgBfmdWBNLGhmi/cjAyk7jJxbaZUvwXOp6RlT4+IgGBw3q//ErpOAm
         R8W21KPZ3vXa+oANIsqnzRdYFH8c3pC/driI5ndKWiIpL6AXnJLPjqDGAddderJ+6pU8
         4B6UcLZz4Zy3/H3gm8FIzln1PR6pNh8n/OLVs=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 08/10] ide-eh: use flags query macros
Date: Sun, 15 Feb 2009 13:08:10 +0100
Message-Id: <1234699692-9452-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while at it, change compound if-statement in ide_disk_pre_reset() with a
logically equivalent and a bit more readable one.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-eh.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-eh.c b/drivers/ide/ide-eh.c
index 1166497..d0fd449 100644
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -9,13 +9,13 @@ static ide_startstop_t ide_ata_error(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+	    ((stat & ATA_DF) && !ide_drv_ignore_write_err(drive))) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else if (stat & ATA_ERR) {
 		/* err has different meaning on cdrom and tape */
 		if (err == ATA_ABORTED) {
-			if ((drive->dev_flags & IDE_DFLAG_LBA) &&
+			if (ide_drv_does_lba(drive) &&
 			    /* some newer drives don't support ATA_CMD_INIT_DEV_PARAMS */
 			    hwif->tp_ops->read_status(hwif) == ATA_CMD_INIT_DEV_PARAMS)
 				return ide_stopped;
@@ -65,7 +65,7 @@ static ide_startstop_t ide_atapi_error(ide_drive_t *drive, struct request *rq,
 	ide_hwif_t *hwif = drive->hwif;
 
 	if ((stat & ATA_BUSY) ||
-	    ((stat & ATA_DF) && (drive->dev_flags & IDE_DFLAG_NOWERR) == 0)) {
+	    ((stat & ATA_DF) && !ide_drv_ignore_write_err(drive))) {
 		/* other bits are useless when BUSY */
 		rq->errors |= ERROR_RESET;
 	} else {
@@ -274,8 +274,7 @@ static void ide_disk_pre_reset(ide_drive_t *drive)
 	drive->mult_count = 0;
 	drive->dev_flags &= ~IDE_DFLAG_PARKED;
 
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0 &&
-	    (drive->dev_flags & IDE_DFLAG_USING_DMA) == 0)
+	if (!(ide_drv_keep_settings(drive) || ide_drv_using_dma(drive)))
 		drive->mult_req = 0;
 
 	if (drive->mult_req != drive->mult_count)
@@ -291,15 +290,15 @@ static void pre_reset(ide_drive_t *drive)
 	else
 		drive->dev_flags |= IDE_DFLAG_POST_RESET;
 
-	if (drive->dev_flags & IDE_DFLAG_USING_DMA) {
+	if (ide_drv_using_dma(drive)) {
 		if (drive->crc_count)
 			ide_check_dma_crc(drive);
 		else
 			ide_dma_off(drive);
 	}
 
-	if ((drive->dev_flags & IDE_DFLAG_KEEP_SETTINGS) == 0) {
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0) {
+	if (!ide_drv_keep_settings(drive)) {
+		if (!ide_drv_using_dma(drive)) {
 			drive->dev_flags &= ~IDE_DFLAG_UNMASK;
 			drive->io_32bit = 0;
 		}
@@ -366,7 +365,7 @@ static ide_startstop_t do_reset1(ide_drive_t *drive, int do_not_try_atapi)
 		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
 		timeout = jiffies;
 		ide_port_for_each_present_dev(i, tdrive, hwif) {
-			if ((tdrive->dev_flags & IDE_DFLAG_PARKED) &&
+			if (ide_drv_heads_parked(tdrive) &&
 			    time_after(tdrive->sleep, timeout))
 				timeout = tdrive->sleep;
 		}
-- 
1.6.0.4

