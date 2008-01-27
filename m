Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYA0Jx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYA0Jx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYA0Jt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:29 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58941 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755813AbYA0JtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:19 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 13/32] ide-tape: remove struct idetape_parameter_block_descriptor_t
Date: Sun, 27 Jan 2008 10:48:01 +0100
Message-Id: <1201427300-3954-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Also, shorten function name idetape_get_blocksize_from_block_descriptor() and
move its definition up thereby getting rid of its forward declaration.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   68 +++++++++++++++++++----------------------------
 1 files changed, 28 insertions(+), 40 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ed53e7f..ea69183 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -664,18 +664,6 @@ struct idetape_id_gcw {
 #define IDETAPE_BUFFER_FILLING_PAGE	0x33
 
 /*
- *	Mode Parameter Block Descriptor the MODE SENSE packet command
- *
- *	Support for block descriptors is optional.
- */
-typedef struct {
-	__u8		density_code;		/* Medium density code */
-	__u8		blocks[3];		/* Number of blocks */
-	__u8		reserved4;		/* Reserved */
-	__u8		length[3];		/* Block Length */
-} idetape_parameter_block_descriptor_t;
-
-/*
  *	Run time configurable parameters.
  */
 typedef struct {
@@ -3401,7 +3389,32 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
 	}
 }
 
-static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive);
+/*
+ * Do a mode sense page 0 with block descriptor	and if it succeeds set the tape
+ * block size with the reported value
+ */
+static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
+{
+
+	idetape_tape_t *tape = drive->driver_data;
+	idetape_pc_t pc;
+
+	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
+	if (idetape_queue_pc_tail(drive, &pc)) {
+		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
+		if (tape->tape_block_size == 0) {
+			printk(KERN_WARNING "ide-tape: Cannot deal with zero "
+					"block size, assuming 32k\n");
+			tape->tape_block_size =  32768;
+		}
+		return;
+	}
+	tape->tape_block_size = (pc.buffer[4 + 5] << 16) +
+				(pc.buffer[4 + 6] << 8)  +
+				pc.buffer[4 + 7];
+
+	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
+}
 
 /*
  *	Our character device open function.
@@ -3453,7 +3466,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 		clear_bit(IDETAPE_PIPELINE_ERROR, &tape->flags);
 
 	/* Read block size and write protect status from drive. */
-	idetape_get_blocksize_from_block_descriptor(drive);
+	ide_tape_get_bsize_from_bdesc(drive);
 
 	/* Set write protect flag if device is opened as read-only. */
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY)
@@ -3665,31 +3678,6 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 
 }
 
-/*
- *	ide_get_blocksize_from_block_descriptor does a mode sense page 0 with block descriptor
- *	and if it succeeds sets the tape block size with the reported value
- */
-static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive)
-{
-
-	idetape_tape_t *tape = drive->driver_data;
-	idetape_pc_t pc;
-	idetape_parameter_block_descriptor_t *block_descrp;
-
-	idetape_create_mode_sense_cmd(&pc, IDETAPE_BLOCK_DESCRIPTOR);
-	if (idetape_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-tape: Can't get block descriptor\n");
-		if (tape->tape_block_size == 0) {
-			printk(KERN_WARNING "ide-tape: Cannot deal with zero block size, assume 32k\n");
-			tape->tape_block_size =  32768;
-		}
-		return;
-	}
-	block_descrp = (idetape_parameter_block_descriptor_t *) pc.buffer + 4;
-	tape->tape_block_size =( block_descrp->length[0]<<16) + (block_descrp->length[1]<<8) + block_descrp->length[2];
-	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
-}
-
 #ifdef CONFIG_IDE_PROC_FS
 static void idetape_add_settings (ide_drive_t *drive)
 {
@@ -3766,7 +3754,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
-	idetape_get_blocksize_from_block_descriptor(drive);
+	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
 	tape->stage_size = *ctl * tape->tape_block_size;
 	while (tape->stage_size > 0xffff) {
-- 
1.5.3.7

