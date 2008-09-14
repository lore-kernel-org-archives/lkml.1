Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYINLh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYINLh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYINLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:14 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:21069 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYINLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=tM9IysmOpj3dGnjOzEwbCDWtQvzrQpLJWnWX9qdXlAn3nFVwOtjv4VgXZP5ukRRzBY
         2Ns5X8RrWq+xqyFGj6g1SE7jwMgl59taw+GVEoy2oHZnN3QPc8U5XbpBLqeWHqhRkCR6
         qjcb7CpNaF2EmPZYXEq/hrc+e852rYFo29tDw=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 03/10] ide-atapi: teach ide atapi about drive->waiting_for_dma
Date: Sun, 14 Sep 2008 13:35:51 +0200
Message-Id: <1221392158-3848-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for converting ide-cd to generic code. The actual
rewiring will be done later after the issue_pc/transfer_pc code knows all about
ide-cd.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index d557841..763acd7 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -487,7 +487,13 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
+	if ((drive->media == ide_cdrom || drive->media == ide_optical) &&
+	    (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT)) {
+		if (drive->dma)
+			drive->waiting_for_dma = 1;
+	}
+	else if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY,
+			       WAIT_READY)) {
 		printk(KERN_ERR "%s: Strange, packet command initiated yet "
 				"DRQ isn't asserted\n", drive->name);
 		return startstop;
@@ -562,8 +568,10 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 		ide_dma_off(drive);
 	}
 
-	if ((pc->flags & PC_FLAG_DMA_OK) &&
-	    (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+	if (((pc->flags & PC_FLAG_DMA_OK) &&
+		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
+	    ((drive->media == ide_cdrom || drive->media == ide_optical) &&
+	         drive->dma)) {
 		if (scsi)
 			hwif->sg_mapped = 1;
 		drive->dma = !hwif->dma_ops->dma_setup(drive);
@@ -579,6 +587,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+		if (drive->dma)
+			drive->waiting_for_dma = 0;
 		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
 				    timeout, NULL);
 		return ide_started;
-- 
1.5.5.1

