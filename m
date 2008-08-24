Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYHXHBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYHXHBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 03:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYHXHBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 03:01:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:44935 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbYHXHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 03:01:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:user-agent:from;
        b=rtJosLvKit9FQnA4FO7X5mVWof/+W6+jR7Vf3ixpJzLxjKJ0YiFu5ELynXrl2JEw7f
         WD29Ov1Ci61ob1h0wMTz5ZUuvCHmYmMvdT/Xp19ZE8oYUFZAONee18c6HHPdnkL5eDML
         0x0BYHw8rkeMkHfYX+BCj/nXvtaG3d2SN2oy0=
Date: Sun, 24 Aug 2008 09:01:19 +0200
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ide-atapi: use drive->waiting_for_dma
Message-ID: <20080824070119.GA18284@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 24 Aug 2008 08:57:57 +0200
Subject: [PATCH] ide-atapi: use drive->waiting_for_dma

.. and remove PC_FLAG_DMA_IN_PROGRESS. There should
be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   10 +++++-----
 include/linux/ide.h     |    7 +++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index a1d8c35..09ac062 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -282,7 +282,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = tp_ops->read_status(hwif);
 
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+	if (drive->waiting_for_dma) {
 		if (hwif->dma_ops->dma_end(drive) ||
 		    (drive->media == ide_tape && !scsi && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy && !scsi)
@@ -303,7 +303,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		debug_log("Packet command completed, %d bytes transferred\n",
 			  pc->xferred);
 
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+		drive->waiting_for_dma = 0;
 
 		local_irq_enable_in_hardirq();
 
@@ -347,8 +347,8 @@ cmd_finished:
 		return ide_stopped;
 	}
 
-	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+	if (drive->waiting_for_dma) {
+		drive->waiting_for_dma = 0;
 		printk(KERN_ERR "%s: The device wants to issue more interrupts "
 				"in DMA mode\n", drive->name);
 		ide_dma_off(drive);
@@ -528,7 +528,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 	/* Begin DMA, if necessary */
 	if (pc->flags & PC_FLAG_DMA_OK) {
-		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
+		drive->waiting_for_dma = 1;
 		hwif->dma_ops->dma_start(drive);
 	}
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e3ccec2..1268e71 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -393,11 +393,10 @@ enum {
 	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
 	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
 	PC_FLAG_DMA_OK			= (1 << 3),
-	PC_FLAG_DMA_IN_PROGRESS		= (1 << 4),
-	PC_FLAG_DMA_ERROR		= (1 << 5),
-	PC_FLAG_WRITING			= (1 << 6),
+	PC_FLAG_DMA_ERROR		= (1 << 4),
+	PC_FLAG_WRITING			= (1 << 5),
 	/* command timed out */
-	PC_FLAG_TIMEDOUT		= (1 << 7),
+	PC_FLAG_TIMEDOUT		= (1 << 6),
 };
 
 /*
-- 
1.5.5.4

-- 
Regards/Gruss,
    Boris.
