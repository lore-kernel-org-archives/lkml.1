Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbYF2LCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbYF2LCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759167AbYF2K7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56112 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbYF2K7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Zzyb87nGED7aWFG3GJTqKCQ2n0xxoQmV1yeV3MkzSnIA5fBh5CZROsEui7q+sMSu6W
         U6tUsdI4hIGq1Og5lsGe1IBnFz3eOPkaf/EP995oFfKiVe1/p0ClxECBg6OjK302DNIH
         0zAfxwtWnpOUIiEO2idIyPOmgNGYb2oJZ/yHU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 10/16] ide: use rq->cmd instead of pc->c in atapi common code
Date: Sun, 29 Jun 2008 12:59:13 +0200
Message-Id: <1214737159-1078-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 0e8b6f5..fa49344 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -22,6 +22,7 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	void (*io_buffers)(ide_drive_t *, struct ide_atapi_pc *, unsigned, int))
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
 	unsigned int temp;
 	u16 bcount;
@@ -63,8 +64,9 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		local_irq_enable_in_hardirq();
 
 		if (drive->media == ide_tape && !scsi &&
-		    (stat & ERR_STAT) && pc->c[0] == REQUEST_SENSE)
+		    (stat & ERR_STAT) && rq->cmd[0] == REQUEST_SENSE)
 			stat &= ~ERR_STAT;
+
 		if ((stat & ERR_STAT) || (pc->flags & PC_FLAG_DMA_ERROR)) {
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
@@ -75,16 +77,17 @@ ide_startstop_t ide_pc_intr(ide_drive_t *drive, struct ide_atapi_pc *pc,
 					goto cmd_finished;
 			}
 
-			if (pc->c[0] == REQUEST_SENSE) {
+			if (rq->cmd[0] == REQUEST_SENSE) {
 				printk(KERN_ERR "%s: I/O error in request sense"
 						" command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 
-			debug_log("[cmd %x]: check condition\n", pc->c[0]);
+			debug_log("[cmd %x]: check condition\n", rq->cmd[0]);
 
 			/* Retry operation */
 			retry_pc(drive);
+
 			/* queued, but not started */
 			return ide_stopped;
 		}
@@ -95,8 +98,10 @@ cmd_finished:
 			dsc_handle(drive);
 			return ide_stopped;
 		}
+
 		/* Command finished - Call the callback function */
 		drive->pc_callback(drive);
+
 		return ide_stopped;
 	}
 
@@ -117,6 +122,7 @@ cmd_finished:
 		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
 		return ide_do_reset(drive);
 	}
+
 	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
@@ -125,6 +131,7 @@ cmd_finished:
 				(ireason & IO) ? "Read" : "Write");
 		return ide_do_reset(drive);
 	}
+
 	if (!(pc->flags & PC_FLAG_WRITING)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->xferred + bcount;
@@ -175,7 +182,7 @@ cmd_finished:
 	pc->cur_pos += bcount;
 
 	debug_log("[cmd %x] transferred %d bytes on that intr.\n",
-		  pc->c[0], bcount);
+		  rq->cmd[0], bcount);
 
 	/* And set the interrupt handler again */
 	ide_set_handler(drive, handler, timeout, expiry);
@@ -210,6 +217,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 				ide_expiry_t *expiry)
 {
 	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = HWGROUP(drive)->rq;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -240,7 +248,7 @@ ide_startstop_t ide_transfer_pc(ide_drive_t *drive, struct ide_atapi_pc *pc,
 
 	/* Send the actual packet */
 	if ((pc->flags & PC_FLAG_ZIP_DRIVE) == 0)
-		hwif->output_data(drive, NULL, pc->c, 12);
+		hwif->output_data(drive, NULL, rq->cmd, 12);
 
 	return ide_started;
 }
-- 
1.5.5.4

