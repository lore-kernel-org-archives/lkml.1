Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYERSku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYERSku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYERSiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:38:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:25716 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbYERSiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=DEDcfjRyLQGnpqrB9hD/uVdzg/rP3Y3hWK6ffraDeC1LEw1WxJ7CTPEePVidbJUiXNWhf0bJQAQvYesfrCvemlzZ8KdbYFBtG0w62q8i2sfmYLTzyTs0r1TQiu3Gk8D2Hm50DjnJCSwGrAjR5iLJqD6XdPvTV/jeJIFpi/DLdTo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:31 +0200
Message-Id: <20080518185531.5636.28627.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/40] ide-scsi: add debug_log() macro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add debug_log() macro and convert the driver to use it.

[ This makes debug messages to be always prefixed with "ide-scsi: "
  and use KERN_INFO level. ]

While at it:

* Change "DMA complete" debug message to "DMA finished" to match
  other ATAPI device drivers.

* Use __func__.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |   51 +++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -60,6 +60,13 @@
 
 #define IDESCSI_DEBUG_LOG		0
 
+#if IDESCSI_DEBUG_LOG
+#define debug_log(fmt, args...) \
+	printk(KERN_INFO "ide-scsi: " fmt, ## args)
+#else
+#define debug_log(fmt, args...) do {} while (0)
+#endif
+
 /*
  *	SCSI command transformation layer
  */
@@ -237,10 +244,9 @@ idescsi_atapi_error(ide_drive_t *drive, 
 static ide_startstop_t
 idescsi_atapi_abort(ide_drive_t *drive, struct request *rq)
 {
-#if IDESCSI_DEBUG_LOG
-	printk(KERN_WARNING "idescsi_atapi_abort called for %lu\n",
+	debug_log("%s called for %lu\n", __func__,
 		((struct ide_atapi_pc *) rq->special)->scsi_cmd->serial_number);
-#endif
+
 	rq->errors |= ERROR_MAX;
 
 	idescsi_end_request(drive, 0, 0);
@@ -319,9 +325,9 @@ static int idescsi_expiry(ide_drive_t *d
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 	struct ide_atapi_pc   *pc   = scsi->pc;
 
-#if IDESCSI_DEBUG_LOG
-	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
-#endif
+	debug_log("%s called for %lu at %lu\n", __func__,
+		  pc->scsi_cmd->serial_number, jiffies);
+
 	pc->flags |= PC_FLAG_TIMEDOUT;
 
 	return 0;					/* we do not want the ide subsystem to retry */
@@ -341,15 +347,11 @@ static ide_startstop_t idescsi_pc_intr (
 	u16 bcount;
 	u8 stat, ireason;
 
-#if IDESCSI_DEBUG_LOG
-	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
-#endif /* IDESCSI_DEBUG_LOG */
+	debug_log("Reached %s interrupt handler\n", __func__);
 
 	if (pc->flags & PC_FLAG_TIMEDOUT) {
-#if IDESCSI_DEBUG_LOG
-		printk(KERN_WARNING "idescsi_pc_intr: got timed out packet  %lu at %lu\n",
-				pc->scsi_cmd->serial_number, jiffies);
-#endif
+		debug_log("%s: got timed out packet %lu at %lu\n", __func__,
+			  pc->scsi_cmd->serial_number, jiffies);
 		/* end this request now - scsi should retry it*/
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
@@ -359,9 +361,7 @@ static ide_startstop_t idescsi_pc_intr (
 			pc->flags |= PC_FLAG_DMA_ERROR;
 		else
 			pc->xferred = pc->req_xfer;
-#if IDESCSI_DEBUG_LOG
-		printk ("ide-scsi: %s: DMA complete\n", drive->name);
-#endif /* IDESCSI_DEBUG_LOG */
+		debug_log("%s: DMA finished\n", drive->name);
 	}
 
 	/* Clear the interrupt */
@@ -427,9 +427,8 @@ static ide_startstop_t idescsi_pc_intr (
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
-#if IDESCSI_DEBUG_LOG
-			printk (KERN_NOTICE "ide-scsi: The scsi wants to send us more data than expected - allowing transfer\n");
-#endif /* IDESCSI_DEBUG_LOG */
+			debug_log("The scsi wants to send us more data than "
+				  "expected - allowing transfer\n");
 		}
 		xferfunc = hwif->input_data;
 	} else
@@ -566,10 +565,10 @@ static ide_startstop_t idescsi_issue_pc(
  */
 static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *rq, sector_t block)
 {
-#if IDESCSI_DEBUG_LOG
-	printk (KERN_INFO "dev: %s, cmd: %x, errors: %d\n", rq->rq_disk->disk_name,rq->cmd[0],rq->errors);
-	printk (KERN_INFO "sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",rq->sector,rq->nr_sectors,rq->current_nr_sectors);
-#endif /* IDESCSI_DEBUG_LOG */
+	debug_log("dev: %s, cmd: %x, errors: %d\n", rq->rq_disk->disk_name,
+		  rq->cmd[0], rq->errors);
+	debug_log("sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",
+		  rq->sector, rq->nr_sectors, rq->current_nr_sectors);
 
 	if (blk_sense_request(rq) || blk_special_request(rq)) {
 		return idescsi_issue_pc(drive,
@@ -976,10 +975,10 @@ static int ide_scsi_probe(ide_drive_t *d
 
 	host->max_id = 1;
 
-#if IDESCSI_DEBUG_LOG
 	if (drive->id->last_lun)
-		printk(KERN_NOTICE "%s: id->last_lun=%u\n", drive->name, drive->id->last_lun);
-#endif
+		debug_log("%s: id->last_lun=%u\n", drive->name,
+			  drive->id->last_lun);
+
 	if ((drive->id->last_lun & 0x7) != 7)
 		host->max_lun = (drive->id->last_lun & 0x7) + 1;
 	else
