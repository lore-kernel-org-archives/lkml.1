Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYERSit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYERSit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYERShj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbYERShi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pEp3Kk2MoQWfEIrfkUIQmZ4hCrp7pz4hs21kY17p2S7ew6GYTCqIPpqXuY6619s6f9bJJn8plAq10jBp3V2rid7xXVYxAthTzJ5p8m/HhufR7ztTYQhawuAnVN0HvqoZILtN1fAKjYB6d0tST6sfON18TJbBGpgGas8Ms/agkng=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:03 +0200
Message-Id: <20080518185503.5636.98141.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/40] ide-scsi: fix Interrupt Reason checking in idescsi_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set PC_FLAG_WRITING pc flag in idescsi_queue() (if needed)
and then fix Interrupt Reason checking in idescsi_pc_intr().

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -427,7 +427,15 @@ static ide_startstop_t idescsi_pc_intr (
 		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
 		return ide_do_reset (drive);
 	}
-	if (ireason & IO) {
+	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
+		/* Hopefully, we will never get here */
+		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
+				"to %s!\n", drive->name,
+				(ireason & IO) ? "Write" : "Read",
+				(ireason & IO) ? "Read" : "Write");
+		return ide_do_reset(drive);
+	}
+	if (!(pc->flags & PC_FLAG_WRITING)) {
 		temp = pc->xferred + bcount;
 		if (temp > pc->req_xfer) {
 			if (temp > pc->buf_size) {
@@ -436,7 +444,6 @@ static ide_startstop_t idescsi_pc_intr (
 					"- discarding data\n");
 				temp = pc->buf_size - pc->xferred;
 				if (temp) {
-					pc->flags &= ~PC_FLAG_WRITING;
 					if (pc->sg)
 						idescsi_input_buffers(drive, pc,
 									temp);
@@ -457,15 +464,11 @@ static ide_startstop_t idescsi_pc_intr (
 			printk (KERN_NOTICE "ide-scsi: The scsi wants to send us more data than expected - allowing transfer\n");
 #endif /* IDESCSI_DEBUG_LOG */
 		}
-	}
-	if (ireason & IO) {
-		pc->flags &= ~PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
 			hwif->input_data(drive, NULL, pc->cur_pos, bcount);
 	} else {
-		pc->flags |= PC_FLAG_WRITING;
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
@@ -777,6 +780,8 @@ static int idescsi_queue (struct scsi_cm
 
 	memset (pc->c, 0, 12);
 	pc->flags = 0;
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		pc->flags |= PC_FLAG_WRITING;
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
 	pc->buf = NULL;
