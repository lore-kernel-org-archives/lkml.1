Return-Path: <linux-kernel-owner+w=401wt.eu-S1764682AbYEGRaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764682AbYEGRaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYEGR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:29:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:23927 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbYEGR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=m0dz7bWcc0nEcsqcJrX4mtqLj0UKi7gahMu65fV4Elic9b07e2IHhciv0ZFWzjknOl3gJ4bbB7UZW8l+1xL9OKCCrP9EcANiPAwTeTGPgA+bXCpoRnOMYUFd0n9DETyZR4/2aB6u3xtIRUrBpCBN12ld2rRqEwFjY988RQU/P5k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/6] ide: remove IDE_TFLAG_NO_SELECT_MASK taskfile flag
Date: Wed, 7 May 2008 19:43:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071943.24296.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always call SELECT_MASK(..., 0) in ide_tf_load() (needs to be done
to match ide_set_irq(..., 1)) and then remove IDE_TFLAG_NO_SELECT_MASK
taskfile flag.

This change should only affect hpt366 and icside host drivers since
->maskproc(..., 0) for sgiioc4 is equivalent to ide_set_irq(..., 1).

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    4 ++--
 drivers/ide/ide-disk.c   |    3 +--
 drivers/ide/ide-floppy.c |    3 +--
 drivers/ide/ide-iops.c   |    4 +---
 drivers/ide/ide-tape.c   |    3 +--
 drivers/scsi/ide-scsi.c  |    2 +-
 include/linux/ide.h      |    1 -
 7 files changed, 7 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -530,8 +530,8 @@ static ide_startstop_t cdrom_start_packe
 		info->dma = !hwif->dma_ops->dma_setup(drive);
 
 	/* set up the controller registers */
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL |
-			   IDE_TFLAG_NO_SELECT_MASK, xferlen, info->dma);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
+			   xferlen, info->dma);
 
 	if (info->cd_flags & IDE_CD_FLAG_DRQ_INTERRUPT) {
 		/* waiting for CDB interrupt, not DMA yet. */
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -198,8 +198,7 @@ static ide_startstop_t __ide_do_rw_disk(
 	}
 
 	memset(&task, 0, sizeof(task));
-	task.tf_flags = IDE_TFLAG_NO_SELECT_MASK;  /* FIXME? */
-	task.tf_flags |= (IDE_TFLAG_TF | IDE_TFLAG_DEVICE);
+	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 
 	if (drive->select.b.lba) {
 		if (lba48) {
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -667,8 +667,7 @@ static ide_startstop_t idefloppy_issue_p
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
 		dma = !hwif->dma_ops->dma_setup(drive);
 
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
-			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
 	if (dma) {
 		/* Begin DMA, if necessary */
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -121,9 +121,7 @@ static void ide_tf_load(ide_drive_t *dri
 		HIHI = 0xFF;
 
 	ide_set_irq(drive, 1);
-
-	if ((task->tf_flags & IDE_TFLAG_NO_SELECT_MASK) == 0)
-		SELECT_MASK(drive, 0);
+	SELECT_MASK(drive, 0);
 
 	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
 		u16 data = (tf->hob_data << 8) | tf->data;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1046,8 +1046,7 @@ static ide_startstop_t idetape_issue_pc(
 	if ((pc->flags & PC_FLAG_DMA_RECOMMENDED) && drive->using_dma)
 		dma_ok = !hwif->dma_ops->dma_setup(drive);
 
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
-			   IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
+	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_DEVICE, bcount, dma_ok);
 
 	if (dma_ok)
 		/* Will begin DMA later */
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -564,7 +564,7 @@ static ide_startstop_t idescsi_issue_pc(
 		hwif->sg_mapped = 0;
 	}
 
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
+	ide_pktcmd_tf_load(drive, 0, bcount, dma);
 
 	if (dma)
 		pc->flags |= PC_FLAG_DMA_OK;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -854,7 +854,6 @@ extern void ide_end_drive_cmd(ide_drive_
 
 enum {
 	IDE_TFLAG_LBA48			= (1 << 0),
-	IDE_TFLAG_NO_SELECT_MASK	= (1 << 1),
 	IDE_TFLAG_FLAGGED		= (1 << 2),
 	IDE_TFLAG_OUT_DATA		= (1 << 3),
 	IDE_TFLAG_OUT_HOB_FEATURE	= (1 << 4),
