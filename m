Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYLDGoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYLDGoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYLDGnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:39451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbYLDGni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=XtAflb+4deEpL912tMrzbUA6u0WQK1kqeo7MSVJHqrhMuVB5zsulLQ+NciX2Th098H
         YC3mEmswe2bnoqbMOeBSGGJSTIvdhsS0dK2654ghS1FFO8cUrUna2SZC8h19hGZ9Xy0s
         KH+TvGqAm2pfh0JvsN3EjFdYFv1TJZA1Tn6OE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/6] ide-atapi: combine drive-specific assignments
Date: Thu,  4 Dec 2008 07:43:25 +0100
Message-Id: <1228373010-20249-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 33a1534..b6e0aac 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -551,18 +551,24 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	u32 tf_flags;
-	u16 bcount;
+	u16 bcount = 0;
 	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
 	/* We haven't transferred any data yet */
 	pc->xferred = 0;
 	pc->cur_pos = pc->buf;
 
-	/* Request to transfer the entire buffer at once */
-	if (drive->media == ide_tape && scsi == 0)
-		bcount = pc->req_xfer;
-	else
+	if (dev_is_idecd(drive)) {
+		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
+	} else if (scsi) {
+		tf_flags = 0;
 		bcount = min(pc->req_xfer, 63 * 1024);
+	} else {
+		tf_flags = IDE_TFLAG_OUT_DEVICE;
+		bcount = ((drive->media == ide_tape) ?
+				pc->req_xfer :
+				min(pc->req_xfer, 63 * 1024));
+	}
 
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->flags &= ~PC_FLAG_DMA_ERROR;
@@ -581,13 +587,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	if (!drive->dma)
 		pc->flags &= ~PC_FLAG_DMA_OK;
 
-	if (scsi)
-		tf_flags = 0;
-	else if (dev_is_idecd(drive))
-		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
-	else
-		tf_flags = IDE_TFLAG_OUT_DEVICE;
-
 	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
 
 	/* Issue the packet command */
-- 
1.6.0.4

