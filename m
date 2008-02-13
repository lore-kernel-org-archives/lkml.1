Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbYBMQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbYBMQYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760365AbYBMQX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:23:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:8027 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929AbYBMQXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:23:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=Ed+gTD9teEoCeIgSnf4cXafFDS6DbkcLJ9sPwzA6ddd2wrbRa4SKeN0w9ccNuy0zHCAoL86WFX5kkeZsPkz4uRT4Tv/+cW93QD4bSdMwDYt7wgQKppSiTUQp/M/rilM2ima3jyCRq9dfZdjQRHP5km8k1THnkHGJN8Hn9XYekH4=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/2] ide: use generic ATAPI packet command flags in ide-{floppy,tape,scsi}
Date: Wed, 13 Feb 2008 17:18:50 +0100
Message-Id: <1202919531-17798-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is done in one single patch in order not to cause git breakage.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |   14 --------------
 drivers/ide/ide-tape.c   |   16 ----------------
 drivers/scsi/ide-scsi.c  |   36 +++++++++++++++---------------------
 include/linux/ide.h      |   15 +++++++++++++++
 4 files changed, 30 insertions(+), 51 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index bf1ef60..5f133df 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -78,20 +78,6 @@
  */
 #define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
 
-/* Packet command flag bits. */
-enum {
-	/* 1 when we prefer to use DMA if possible */
-	PC_FLAG_DMA_RECOMMENDED	= (1 << 0),
-	/* 1 while DMA in progress */
-	PC_FLAG_DMA_IN_PROGRESS	= (1 << 1),
-	/* 1 when encountered problem during DMA */
-	PC_FLAG_DMA_ERROR	= (1 << 2),
-	/* Data direction */
-	PC_FLAG_WRITING		= (1 << 3),
-	/* Suppress error reporting */
-	PC_FLAG_SUPPRESS_ERROR	= (1 << 4),
-};
-
 /* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 3a10208..3f9fbd8 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -181,22 +181,6 @@ struct idetape_bh {
 	char *b_data;
 };
 
-/* Packet command flag bits. */
-enum {
-	/* Set when an error is considered normal - We won't retry */
-	PC_FLAG_ABORT		= (1 << 0),
-	/* 1 When polling for DSC on a media access command */
-	PC_FLAG_WAIT_FOR_DSC	= (1 << 1),
-	/* 1 when we prefer to use DMA if possible */
-	PC_FLAG_DMA_RECOMMENDED	= (1 << 2),
-	/* 1 while DMA in progress */
-	PC_FLAG_DMA_IN_PROGRESS	= (1 << 3),
-	/* 1 when encountered problem during DMA */
-	PC_FLAG_DMA_ERROR	= (1 << 4),
-	/* Data direction */
-	PC_FLAG_WRITING		= (1 <<	5),
-};
-
 /* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 5ec421c..d46c81c 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -61,14 +61,6 @@
 #define IDESCSI_DEBUG_LOG		0
 
 /*
- *	Packet command status bits.
- */
-#define PC_DMA_IN_PROGRESS		0	/* 1 while DMA in progress */
-#define PC_WRITING			1	/* Data direction */
-#define PC_TIMEDOUT			3	/* command timed out */
-#define PC_DMA_OK			4	/* Use DMA */
-
-/*
  *	SCSI command transformation layer
  */
 #define IDESCSI_SG_TRANSFORM		1	/* /dev/sg transformation */
@@ -319,8 +311,10 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 		pc = opc;
 		rq = pc->rq;
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
-					((test_bit(PC_TIMEDOUT, &pc->flags)?DID_TIME_OUT:DID_OK) << 16);
-	} else if (test_bit(PC_TIMEDOUT, &pc->flags)) {
+				((test_bit(PC_FLAG_TIMEDOUT, &pc->flags) ?
+				  DID_TIME_OUT :
+				  DID_OK) << 16);
+	} else if (test_bit(PC_FLAG_TIMEDOUT, &pc->flags)) {
 		if (log)
 			printk (KERN_WARNING "ide-scsi: %s: timed out for %lu\n",
 					drive->name, pc->scsi_cmd->serial_number);
@@ -362,7 +356,7 @@ static int idescsi_expiry(ide_drive_t *drive)
 #if IDESCSI_DEBUG_LOG
 	printk(KERN_WARNING "idescsi_expiry called for %lu at %lu\n", pc->scsi_cmd->serial_number, jiffies);
 #endif
-	set_bit(PC_TIMEDOUT, &pc->flags);
+	set_bit(PC_FLAG_TIMEDOUT, &pc->flags);
 
 	return 0;					/* we do not want the ide subsystem to retry */
 }
@@ -384,7 +378,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 	printk (KERN_INFO "ide-scsi: Reached idescsi_pc_intr interrupt handler\n");
 #endif /* IDESCSI_DEBUG_LOG */
 
-	if (test_bit(PC_TIMEDOUT, &pc->flags)){
+	if (test_bit(PC_FLAG_TIMEDOUT, &pc->flags)) {
 #if IDESCSI_DEBUG_LOG
 		printk(KERN_WARNING "idescsi_pc_intr: got timed out packet  %lu at %lu\n",
 				pc->scsi_cmd->serial_number, jiffies);
@@ -393,7 +387,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
-	if (test_and_clear_bit (PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (test_and_clear_bit(PC_FLAG_DMA_IN_PROGRESS, &pc->flags)) {
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
@@ -432,7 +426,7 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 					"- discarding data\n");
 				temp = pc->buf_size - pc->xferred;
 				if (temp) {
-					clear_bit(PC_WRITING, &pc->flags);
+					clear_bit(PC_FLAG_WRITING, &pc->flags);
 					if (pc->sg)
 						idescsi_input_buffers(drive, pc,
 									temp);
@@ -454,14 +448,14 @@ static ide_startstop_t idescsi_pc_intr (ide_drive_t *drive)
 		}
 	}
 	if (ireason & IO) {
-		clear_bit(PC_WRITING, &pc->flags);
+		clear_bit(PC_FLAG_WRITING, &pc->flags);
 		if (pc->sg)
 			idescsi_input_buffers(drive, pc, bcount);
 		else
 			hwif->atapi_input_bytes(drive, pc->cur_pos,
 						bcount);
 	} else {
-		set_bit(PC_WRITING, &pc->flags);
+		set_bit(PC_FLAG_WRITING, &pc->flags);
 		if (pc->sg)
 			idescsi_output_buffers(drive, pc, bcount);
 		else
@@ -501,8 +495,8 @@ static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 	/* Send the actual packet */
 	drive->hwif->atapi_output_bytes(drive, scsi->pc->c, 12);
-	if (test_bit (PC_DMA_OK, &pc->flags)) {
-		set_bit (PC_DMA_IN_PROGRESS, &pc->flags);
+	if (test_bit(PC_FLAG_DMA_OK, &pc->flags)) {
+		set_bit(PC_FLAG_DMA_IN_PROGRESS, &pc->flags);
 		hwif->dma_start(drive);
 	}
 	return ide_started;
@@ -512,10 +506,10 @@ static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
 		case READ_6: case READ_10: case READ_12:
-			clear_bit(PC_WRITING, &pc->flags);
+			clear_bit(PC_FLAG_WRITING, &pc->flags);
 			return 0;
 		case WRITE_6: case WRITE_10: case WRITE_12:
-			set_bit(PC_WRITING, &pc->flags);
+			set_bit(PC_FLAG_WRITING, &pc->flags);
 			return 0;
 		default:
 			return 1;
@@ -572,7 +566,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK, bcount, dma);
 
 	if (dma)
-		set_bit(PC_DMA_OK, &pc->flags);
+		set_bit(PC_FLAG_DMA_OK, &pc->flags);
 
 	if (test_bit(IDESCSI_DRQ_INTERRUPT, &scsi->flags)) {
 		ide_execute_command(drive, WIN_PACKETCMD, &idescsi_transfer_pc,
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 509d806..0e5f09b 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -629,6 +629,21 @@ typedef struct ide_settings_s {
 
 int ide_add_setting(ide_drive_t *, const char *, int, int, int, int, int, int, void *, ide_procset_t *set);
 
+/* ATAPI packet command flags */
+enum {
+	/* set when an error is considered normal - no retry (ide-tape) */
+	PC_FLAG_ABORT			= (1 << 0),
+	PC_FLAG_SUPPRESS_ERROR		= (1 << 1),
+	PC_FLAG_WAIT_FOR_DSC		= (1 << 2),
+	PC_FLAG_DMA_OK			= (1 << 3),
+	PC_FLAG_DMA_RECOMMENDED		= (1 << 4),
+	PC_FLAG_DMA_IN_PROGRESS		= (1 << 5),
+	PC_FLAG_DMA_ERROR		= (1 << 6),
+	PC_FLAG_WRITING			= (1 << 7),
+	/* command timed out */
+	PC_FLAG_TIMEDOUT		= (1 << 8),
+};
+
 struct ide_atapi_pc {
 	/* actual packet bytes */
 	u8 c[12];
-- 
1.5.3.7

