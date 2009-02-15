Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZBOMKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZBOMKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZBOMIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:35 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:62146 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZBOMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Sbb2jQpsWKwjwtHAVC0jOi9u8dZ3wtOETyRynBCcxHiabrxNLFmiv4/3+it97x4kge
         AMY9Y/UG+xBDXxC9wZ+14zjvgJVbeckroYh8bILCHH9yPCa29UwOsYjVPEG3xznR+PSh
         NVOFnPZYGbtb2pbQ0w6DHIwc/HQEWWlZ+3b0k=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 05/10] ide-atapi: use flags query macros
Date: Sun, 15 Feb 2009 13:08:07 +0100
Message-Id: <1234699692-9452-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index c807515..4f0365f 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -202,7 +202,7 @@ int ide_set_media_lock(ide_drive_t *drive, struct gendisk *disk, int on)
 {
 	struct ide_atapi_pc pc;
 
-	if ((drive->dev_flags & IDE_DFLAG_DOORLOCKING) == 0)
+	if (!ide_drv_doorlocking(drive))
 		return 0;
 
 	ide_init_pc(&pc);
@@ -547,7 +547,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		return startstop;
 	}
 
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
+	if (ide_drv_drq_int(drive)) {
 		if (drive->dma)
 			drive->waiting_for_dma = 1;
 	}
@@ -570,7 +570,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		 * miliseconds later in ide_delayed_transfer_pc() after the
 		 * device says it's ready for a packet.
 		 */
-		if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
+		if (ide_drv_zip(drive)) {
 			timeout = drive->pc_delay;
 			expiry = &ide_delayed_transfer_pc;
 		} else {
@@ -611,7 +611,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	}
 
 	/* Send the actual packet */
-	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
+	if (!ide_drv_zip(drive))
 		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	return ide_started;
@@ -627,7 +627,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
-	u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
@@ -659,7 +658,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 		}
 
 		if ((pc->flags & PC_FLAG_DMA_OK) &&
-		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+		     ide_drv_using_dma(drive)) {
 			if (ide_build_sglist(drive, cmd))
 				drive->dma = !dma_ops->dma_setup(drive, cmd);
 			else
@@ -677,7 +676,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 	(void)do_rw_taskfile(drive, cmd);
 
-	if (drq_int) {
+	if (ide_drv_drq_int(drive)) {
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
 		hwif->expiry = expiry;
@@ -685,6 +684,6 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 	ide_execute_command(drive, cmd, ide_transfer_pc, timeout);
 
-	return drq_int ? ide_started : ide_transfer_pc(drive);
+	return ide_drv_drq_int(drive) ? ide_started : ide_transfer_pc(drive);
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
-- 
1.6.0.4

