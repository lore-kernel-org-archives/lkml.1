Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYERSwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYERSwa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbYERSms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:42:48 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:29480 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623AbYERSmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wnfXlrwJZ1dBv8VohEaZ/MYyO6Xc/evthmXGm2LygzMpFGbV7vnDyllEDwARCqOCFN0/VPCfNAExfp5Uv1G/vGt5NfytDQ3Knrk/Q/5Vg65wGhJsj5w2iCSuO/R8TinXg+p4AQ7JBwQ/JZVN7Kc+m/MPBiWXigvF3iqRt3ONH5w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 21:00:10 +0200
Message-Id: <20080518190010.5636.62709.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 38/40] ide-scsi: add more debugging to idescsi_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more debugging to idescsi_pc_intr() to match ide-tape's
idetape_pc_intr().

While at it:

* Correct the first debug message.

This is a preparation for adding generic ide_pc_intr() helper.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -364,7 +364,7 @@ static ide_startstop_t idescsi_pc_intr (
 	u16 bcount;
 	u8 stat, ireason;
 
-	debug_log("Reached %s interrupt handler\n", __func__);
+	debug_log("Enter %s - interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
 		pc->callback(drive);
@@ -383,10 +383,16 @@ static ide_startstop_t idescsi_pc_intr (
 
 	if ((stat & DRQ_STAT) == 0) {
 		/* No more interrupts */
+		debug_log("Packet command completed, %d bytes transferred\n",
+			  pc->xferred);
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable_in_hardirq();
-		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR))
+		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
+			/* Error detected */
+			debug_log("%s: I/O error\n", drive->name);
+
 			rq->errors++;
+		}
 		pc->callback(drive);
 		return ide_stopped;
 	}
@@ -457,6 +463,9 @@ static ide_startstop_t idescsi_pc_intr (
 	pc->xferred += bcount;
 	pc->cur_pos += bcount;
 
+	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
+		  pc->c[0], bcount);
+
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 	return ide_started;
