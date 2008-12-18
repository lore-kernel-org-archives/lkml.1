Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753729AbYLRHnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYLRHnX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYLRHlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:41:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49407 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYLRHlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:41:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=qJhAoZ/n79k1C8caZqpdibuR9U1gd5w/VHn4a2eyrhaakcIL7m92h6VZkDUN9SG+Pv
         W2nwMBnlRp1SkUaz0jEqj4oJ3rX32U2dedtgT8HaMKF61NRzlyJw2EECIL7KaA6NR9DK
         dI/U3ObjUmeP0I/PtC3guj/bkMxQq1V5UGpWc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 8/8] ide-atapi: start dma in a drive-specific way
Date: Thu, 18 Dec 2008 08:40:52 +0100
Message-Id: <1229586052-3542-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index f3dea66..5b92e0a 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -489,7 +489,7 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
 
 static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
-	struct ide_atapi_pc *pc = drive->pc;
+	struct ide_atapi_pc *uninitialized_var(pc);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
 	ide_expiry_t *expiry;
@@ -519,6 +519,8 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		expiry  = ide_cd_expiry;
 
 	} else {
+		pc = drive->pc;
+
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
 		/*
@@ -551,9 +553,14 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 
 	/* Begin DMA, if necessary */
-	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
-		hwif->dma_ops->dma_start(drive);
+	if (dev_is_idecd(drive)) {
+		if (drive->dma)
+			hwif->dma_ops->dma_start(drive);
+	} else {
+		if (pc->flags & PC_FLAG_DMA_OK) {
+			pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+			hwif->dma_ops->dma_start(drive);
+		}
 	}
 
 	/* Send the actual packet */
-- 
1.6.0.4

