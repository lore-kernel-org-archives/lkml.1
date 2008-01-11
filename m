Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbYAKMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbYAKMEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbYAKMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:33 -0500
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:26900 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758078AbYAKMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=IhcD/uCzBkm8/u72KbdFv8LlOOJWc5Iy2K4WqUUyu6Pv+hhr20U9zbZ9xUoDf3zakg+sAzlXZtIxxo1l8kFARSDDeSWklNXSKq7Hflt47jVA787YGrkVcZqVGHZyiuy8LMAFAiWmuIGbRuTymWFv3tS6kty/YINnQTbdtZQ4YGg=  ;
X-YMail-OSG: _wIkPecVM1mjNcMwqR1q5a2T0gdPvVpiJ7gm5Vnk8RYULeFf1lS5dD4Plhfn1cl61wSsARdxiw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 04/21] ide-floppy: cleanup and unify debugging macro calls
Date: Fri, 11 Jan 2008 12:58:02 +0100
Message-Id: <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* some debug_log() calls were not using "ide-floppy: " prefix

* a few used printk levels different than KERN_INFO (KERN_NOTICE
  and KERN_ERR, which is the default one if no level is given)

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   66 +++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 66dfd18..e8fe8ef 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -58,7 +58,8 @@
 #define IDEFLOPPY_DEBUG( fmt, args... )
 
 #if IDEFLOPPY_DEBUG_LOG
-#define debug_log printk
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide-floppy: " fmt, ## args)
 #else
 #define debug_log(fmt, args... ) do {} while(0)
 #endif
@@ -478,7 +479,7 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
-	debug_log(KERN_INFO "Reached idefloppy_end_request\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	switch (uptodate) {
 		case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
@@ -624,21 +625,20 @@ static void idefloppy_analyze_error (ide_drive_t *drive,idefloppy_request_sense_
 	floppy->progress_indication = result->sksv[0] & 0x80 ?
 		(u16)get_unaligned((u16 *)(result->sksv+1)):0x10000;
 	if (floppy->failed_pc)
-		debug_log(KERN_INFO "ide-floppy: pc = %x, sense key = %x, "
-			"asc = %x, ascq = %x\n", floppy->failed_pc->c[0],
-			result->sense_key, result->asc, result->ascq);
+		debug_log("pc = %x, sense key = %x, asc = %x, ascq = %x\n",
+				floppy->failed_pc->c[0], result->sense_key,
+				result->asc, result->ascq);
 	else
-		debug_log(KERN_INFO "ide-floppy: sense key = %x, asc = %x, "
-			"ascq = %x\n", result->sense_key,
-			result->asc, result->ascq);
+		debug_log("sense key = %x, asc = %x, ascq = %x\n",
+				result->sense_key, result->asc, result->ascq);
 }
 
 static void idefloppy_request_sense_callback (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
-	
+	debug_log("Reached %s\n", __FUNCTION__);
+
 	if (!floppy->pc->error) {
 		idefloppy_analyze_error(drive,(idefloppy_request_sense_result_t *) floppy->pc->buffer);
 		idefloppy_do_end_request(drive, 1, 0);
@@ -654,8 +654,8 @@ static void idefloppy_request_sense_callback (ide_drive_t *drive)
 static void idefloppy_pc_callback (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
-	
-	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
+
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
@@ -714,8 +714,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	u16 bcount;
 	u8 stat, ireason;
 
-	debug_log(KERN_INFO "ide-floppy: Reached %s interrupt handler\n",
-		__FUNCTION__);
+	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
 		if (HWIF(drive)->ide_dma_end(drive)) {
@@ -724,23 +723,22 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 			pc->actually_transferred = pc->request_transfer;
 			idefloppy_update_buffers(drive, pc);
 		}
-		debug_log(KERN_INFO "ide-floppy: DMA finished\n");
+		debug_log("DMA finished\n");
 	}
 
 	/* Clear the interrupt */
 	stat = drive->hwif->INB(IDE_STATUS_REG);
 
 	if ((stat & DRQ_STAT) == 0) {		/* No more interrupts */
-		debug_log(KERN_INFO "Packet command completed, %d bytes "
-			"transferred\n", pc->actually_transferred);
+		debug_log("Packet command completed, %d bytes transferred\n",
+				pc->actually_transferred);
 		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 
 		local_irq_enable_in_hardirq();
 
 		if ((stat & ERR_STAT) || test_bit(PC_DMA_ERROR, &pc->flags)) {
 			/* Error detected */
-			debug_log(KERN_INFO "ide-floppy: %s: I/O error\n",
-				drive->name);
+			debug_log("I/O error\n", drive->name);
 			rq->errors++;
 			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
 				printk(KERN_ERR "ide-floppy: I/O error in "
@@ -801,9 +799,8 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 						NULL);
 				return ide_started;
 			}
-			debug_log(KERN_NOTICE "ide-floppy: The floppy wants to "
-				"send us more data than expected - "
-				"allowing transfer\n");
+			debug_log("The floppy wants to send us more data than"
+					" expected - allowing transfer\n");
 		}
 	}
 	if (test_bit(PC_WRITING, &pc->flags)) {
@@ -970,7 +967,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		return ide_stopped;
 	}
 
-	debug_log(KERN_INFO "Retry number - %d\n",pc->retries);
+	debug_log("Retry number - %d\n", pc->retries);
 
 	pc->retries++;
 	/* We haven't transferred any data yet */
@@ -1019,7 +1016,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 
 static void idefloppy_rw_callback (ide_drive_t *drive)
 {
-	debug_log(KERN_INFO "ide-floppy: Reached idefloppy_rw_callback\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	idefloppy_do_end_request(drive, 1, 0);
 	return;
@@ -1027,8 +1024,7 @@ static void idefloppy_rw_callback (ide_drive_t *drive)
 
 static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
 {
-	debug_log(KERN_INFO "ide-floppy: creating prevent removal command, "
-		"prevent = %d\n", prevent);
+	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
@@ -1164,10 +1160,10 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
 	idefloppy_pc_t *pc;
 	unsigned long block = (unsigned long)block_s;
 
-	debug_log(KERN_INFO "dev: %s, flags: %lx, errors: %d\n",
+	debug_log("dev: %s, flags: %lx, errors: %d\n",
 			rq->rq_disk ? rq->rq_disk->disk_name : "?",
 			rq->flags, rq->errors);
-	debug_log(KERN_INFO "sector: %ld, nr_sectors: %ld, "
+	debug_log("sector: %ld, nr_sectors: %ld, "
 			"current_nr_sectors: %d\n", (long)rq->sector,
 			rq->nr_sectors, rq->current_nr_sectors);
 
@@ -1376,12 +1372,10 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 		}
 		}
 		if (!i) {
-			debug_log( "Descriptor 0 Code: %d\n",
-				descriptor->dc);
+			debug_log("Descriptor 0 Code: %d\n", descriptor->dc);
 		}
-		debug_log( "Descriptor %d: %dkB, %d blocks, %d "
-			"sector size\n", i, blocks * length / 1024, blocks,
-			length);
+		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
+				i, blocks * length / 1024, blocks, length);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
@@ -1773,7 +1767,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 	idefloppy_pc_t pc;
 	int ret = 0;
 
-	debug_log(KERN_INFO "Reached idefloppy_open\n");
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	if (!(floppy = ide_floppy_get(disk)))
 		return -ENXIO;
@@ -1833,8 +1827,8 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
 	idefloppy_pc_t pc;
-	
-	debug_log(KERN_INFO "Reached idefloppy_release\n");
+
+	debug_log("Reached %s\n", __FUNCTION__);
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-- 
1.5.3.7

