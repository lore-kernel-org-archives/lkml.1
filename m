Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYINLjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYINLjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYINLgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:22225 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYINLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=q/vfnRJRbLl6dV2az4bx1uHLizLC+UhYUBtA6Cn7CLfrL0IFj4I4JOXH5OBpYOVs3i
         HT8FIACD4WncBu7g0Hm+Fe3gNKCdQTJKF/PJjKXnJJvEGRbbPoPVQcs11qwYAIkKu8lm
         4PocWr3yFFTRTVdbVs0m7VWnP86/iXdS403nI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 09/10] ide-atapi: protect ide_atapi_pc pointer from ide-cd code path
Date: Sun, 14 Sep 2008 13:35:57 +0200
Message-Id: <1221392158-3848-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... since it is undefined.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 733a75a..45e88a9 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -561,9 +561,16 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	u16 bcount;
 	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
-	/* We haven't transferred any data yet */
-	pc->xferred = 0;
-	pc->cur_pos = pc->buf;
+	if (!DEV_IS_IDECD(drive)) {
+		/* We haven't transferred any data yet */
+		pc->xferred = 0;
+		pc->cur_pos = pc->buf;
+
+		if (pc->flags & PC_FLAG_DMA_ERROR) {
+			pc->flags &= ~PC_FLAG_DMA_ERROR;
+			ide_dma_off(drive);
+		}
+	}
 
 	/* Request to transfer the entire buffer at once */
 	if (drive->media == ide_tape && scsi == 0)
@@ -573,14 +580,10 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	else
 		bcount = min(pc->req_xfer, 63 * 1024);
 
-	if (pc->flags & PC_FLAG_DMA_ERROR) {
-		pc->flags &= ~PC_FLAG_DMA_ERROR;
-		ide_dma_off(drive);
-	}
-
-	if (((pc->flags & PC_FLAG_DMA_OK) &&
-		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
-	    (DEV_IS_IDECD(drive) && drive->dma)) {
+	if (drive->dma ||
+	   (!DEV_IS_IDECD(drive) &&
+	     (pc->flags & PC_FLAG_DMA_OK) &&
+	     (drive->dev_flags & IDE_DFLAG_USING_DMA))) {
 		if (scsi)
 			hwif->sg_mapped = 1;
 		drive->dma = !hwif->dma_ops->dma_setup(drive);
@@ -588,7 +591,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 			hwif->sg_mapped = 0;
 	}
 
-	if (!drive->dma)
+	if (!drive->dma && !DEV_IS_IDECD(drive))
 		pc->flags &= ~PC_FLAG_DMA_OK;
 
 	if (scsi)
-- 
1.5.5.1

