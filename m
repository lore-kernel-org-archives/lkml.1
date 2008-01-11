Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYAKNR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYAKNR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 08:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYAKNRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 08:17:49 -0500
Received: from smtp105.plus.mail.re1.yahoo.com ([69.147.102.68]:29528 "HELO
	smtp105.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758265AbYAKNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 08:17:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=5DBjmRNALVswG01SmnRbGVsaC1jZ2113nii4TZvm5DDNrmbCfumBP0SyCieJQedhnmwruf9k89DGj9WdgCLQBo/foDwEBC9hYTd+IBqUb6A8O3X7Sxjxt4V1cYsrZ3WNToJM1gLzvI4PaPDOx0y1tZ3Lu4j+PJ7bK0UKyKYrqxY=  ;
X-YMail-OSG: 9wc4u3IVM1kDIlaxueeeiv4mLwsief7OgXuQ5_Nyenzv8z4NkgHqB0WMg7oSsYF8Scfq2JnoXA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 16/21] ide-floppy: use an xfer_func_t and io_buf_t typedefs in order to unify rw
Date: Fri, 11 Jan 2008 14:14:28 +0100
Message-Id: <1200057268-29169-1-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: 1200052699-28420-16-git-send-email-bbpetkov@yahoo.de
References: 1200052699-28420-16-git-send-email-bbpetkov@yahoo.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, move xfer_func_t typedef to the ide.h since it is used by two drivers
now (more coming).

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-cd.c     |    2 --
 drivers/ide/ide-floppy.c |   37 ++++++++++++++++++-------------------
 include/linux/ide.h      |    3 +++
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3b3e6c1..7e53a03 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -604,8 +604,6 @@ static ide_startstop_t cdrom_transfer_packet_command (ide_drive_t *drive,
  * Block read functions.
  */
 
-typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
-
 static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
 {
 	while (len > 0) {
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 6e8926a..c889c16 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -491,19 +491,22 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
 	idefloppy_queue_pc_head(drive, pc, rq);
 }
 
-/*
- * The usual interrupt handler called during a packet command.
- */
+typedef void (io_buf_t)(ide_drive_t *, idefloppy_pc_t *, unsigned int);
+
+/*  The usual interrupt handler called during a packet command. */
 static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	idefloppy_pc_t *pc = floppy->pc;
 	struct request *rq = pc->rq;
+	xfer_func_t *xferfunc;
+	io_buf_t *iobuf_func;
 	unsigned int temp;
 	u16 bcount;
 	u8 stat, ireason;
 	int dma_error = 0;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
 
 	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
@@ -511,9 +514,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		dma_error = HWIF(drive)->ide_dma_end(drive);
 		if (dma_error) {
 			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
-					rq_data_dir(rq) == WRITE ?
-					"write" :
-					"read");
+					write ?	"write" : "read");
 			set_bit(PC_DMA_ERROR, &pc->flags);
 		} else {
 			pc->actually_transferred = pc->request_transfer;
@@ -568,7 +569,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	ireason = hwif->INB(IDE_IREASON_REG);
 
 	if (ireason & CD) {
-		printk(KERN_ERR "ide-floppy: CoD != 0 in idefloppy_pc_intr\n");
+		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __FUNCTION__);
 		return ide_do_reset(drive);
 	}
 	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
@@ -600,20 +601,18 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		}
 	}
 	if (test_bit(PC_WRITING, &pc->flags)) {
-		if (pc->buffer != NULL)
-			/* Write the current buffer */
-			hwif->atapi_output_bytes(drive, pc->current_position,
-						 bcount);
-		else
-			idefloppy_output_buffers(drive, pc, bcount);
+		xferfunc = hwif->atapi_output_bytes;
+		iobuf_func = &idefloppy_output_buffers;
 	} else {
-		if (pc->buffer != NULL)
-			/* Read the current buffer */
-			hwif->atapi_input_bytes(drive, pc->current_position,
-						bcount);
-		else
-			idefloppy_input_buffers(drive, pc, bcount);
+		xferfunc = hwif->atapi_input_bytes;
+		iobuf_func = &idefloppy_input_buffers;
 	}
+
+	if (pc->buffer != NULL)
+		xferfunc(drive, pc->current_position, bcount);
+	else
+		iobuf_func(drive, pc, bcount);
+
 	/* Update the current position */
 	pc->actually_transferred += bcount;
 	pc->current_position += bcount;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index bfbc975..a6cf280 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -626,6 +626,9 @@ typedef struct hwif_s {
 typedef ide_startstop_t (ide_handler_t)(ide_drive_t *);
 typedef int (ide_expiry_t)(ide_drive_t *);
 
+/* used by ide-cd, ide-floppy, etc. */
+typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
+
 typedef struct hwgroup_s {
 		/* irq handler, if active */
 	ide_startstop_t	(*handler)(ide_drive_t *);
-- 
1.5.3.7

