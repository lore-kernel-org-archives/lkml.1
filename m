Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZEIHuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZEIHuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZEIHqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:46:09 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43446 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZEIHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RiGIKfd87qzZWTIdq13GI/qz46dmO1wTNh1wG4mydiQoGlA1+Axw5+qmD65xkiiAOd
         h2gROsSzYQZW1SYE11GbIRJWiM6rew6/hgljObgMN5Ice3Vq/cPhZj/J3Iulwly9Dvjg
         wuUWLq1cdSCQM/Nb/V8j7En4QxPdJkGJ4wvtM=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] ide: unify interrupt reason checking
Date: Sat,  9 May 2009 09:45:34 +0200
Message-Id: <1241855134-4984-15-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_check_ireason() function that handles all ATAPI devices. Move
the ATAPI_COD check later in the if-else chain since the case for
ATAPI_COD to be set is rather unlikely in a normal operation. Also, add
a branch predictor hint for it. Generally, move all unlikely cases in
ireason checking further down in the code path.

In addition, add PFX for printks originating from ide-atapi. Finally,
remove ide_cd_check_ireason.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   94 ++++++++++++++++++++++++++++++++++-------------
 drivers/ide/ide-cd.c    |   48 +-----------------------
 include/linux/ide.h     |    2 +
 3 files changed, 71 insertions(+), 73 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 96aded6..2bbcfc4 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -10,6 +10,9 @@
 
 #include <scsi/scsi.h>
 
+#define DRV_NAME "ide-atapi"
+#define PFX DRV_NAME ": "
+
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
 	printk(KERN_INFO "ide: " fmt, ## args)
@@ -204,8 +207,8 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 			      GFP_NOIO);
 	if (unlikely(err)) {
 		if (printk_ratelimit())
-			printk(KERN_WARNING "%s: failed to map sense buffer\n",
-			       drive->name);
+			printk(KERN_WARNING PFX "%s: failed to map sense "
+					    "buffer\n", drive->name);
 		return;
 	}
 
@@ -226,7 +229,7 @@ int ide_queue_sense_rq(ide_drive_t *drive, void *special)
 {
 	/* deferred failure from ide_prep_sense() */
 	if (!drive->sense_rq_armed) {
-		printk(KERN_WARNING "%s: failed queue sense request\n",
+		printk(KERN_WARNING PFX "%s: error queuing a sense request\n",
 		       drive->name);
 		return -ENOMEM;
 	}
@@ -290,7 +293,7 @@ int ide_cd_expiry(ide_drive_t *drive)
 		break;
 	default:
 		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO "cmd 0x%x timed out\n",
+			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
 					 rq->cmd[0]);
 		wait = 0;
 		break;
@@ -324,6 +327,56 @@ void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
 EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
 
 /*
+ * Check the contents of the interrupt reason register and attempt to recover if
+ * there are problems.
+ *
+ * Returns:
+ * - 0 if everything's ok
+ * - 1 if the request has to be terminated.
+ */
+int ide_check_ireason(ide_drive_t *drive, struct request *rq, int len,
+		      int ireason, int rw)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	debug_log("ireason: 0x%x, rw: 0x%x\n", ireason, rw);
+
+	if (ireason == (!rw << 1))
+		return 0;
+	else if (ireason == (rw << 1)) {
+		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
+				drive->name, __func__);
+
+		if (dev_is_idecd(drive))
+			ide_pad_transfer(drive, rw, len);
+	}
+	else if (!rw && ireason == ATAPI_COD) {
+		if (dev_is_idecd(drive)) {
+			/*
+			 * some drives (ASUS) seem to tell us that status info
+			 * is available.  Just get it and ignore.
+			 */
+			(void)hwif->tp_ops->read_status(hwif);
+			return 0;
+		}
+	} else {
+		if (unlikely(ireason & ATAPI_COD))
+			printk(KERN_ERR PFX "%s: CoD != 0 in %s\n", drive->name,
+					__func__);
+
+		/* drive wants a command packet, or invalid ireason... */
+		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
+				drive->name, __func__, ireason);
+	}
+
+	if (dev_is_idecd(drive) && rq->cmd_type == REQ_TYPE_ATA_PC)
+		rq->cmd_flags |= REQ_FAILED;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ide_check_ireason);
+
+/*
  * This is the usual interrupt handler which will be called during a packet
  * command.  We will transfer some of the data (as requested by the drive)
  * and will re-point interrupt handler to us.
@@ -357,7 +410,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
-				printk(KERN_ERR "%s: DMA %s error\n",
+				printk(KERN_ERR PFX "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
 						     ? "write" : "read");
 			pc->flags |= PC_FLAG_DMA_ERROR;
@@ -389,8 +442,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 				pc->rq->errors++;
 
 			if (rq->cmd[0] == REQUEST_SENSE) {
-				printk(KERN_ERR "%s: I/O error in request sense"
-						" command\n", drive->name);
+				printk(KERN_ERR PFX "%s: I/O error in request "
+						"sense command\n", drive->name);
 				return ide_do_reset(drive);
 			}
 
@@ -432,8 +485,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
 		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
-		printk(KERN_ERR "%s: The device wants to issue more interrupts "
-				"in DMA mode\n", drive->name);
+		printk(KERN_ERR PFX "%s: The device wants to issue more "
+				"interrupts in DMA mode\n", drive->name);
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
@@ -441,19 +494,8 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 	/* Get the number of bytes to transfer on this interrupt. */
 	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
-	if (ireason & ATAPI_COD) {
-		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
+	if (ide_check_ireason(drive, rq, bcount, ireason, write))
 		return ide_do_reset(drive);
-	}
-
-	if (((ireason & ATAPI_IO) == ATAPI_IO) == write) {
-		/* Hopefully, we will never get here */
-		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
-				"to %s!\n", drive->name,
-				(ireason & ATAPI_IO) ? "Write" : "Read",
-				(ireason & ATAPI_IO) ? "Read" : "Write");
-		return ide_do_reset(drive);
-	}
 
 	done = min_t(unsigned int, bcount, cmd->nleft);
 	ide_pio_bytes(drive, cmd, write, done);
@@ -501,13 +543,13 @@ static u8 ide_wait_ireason(ide_drive_t *drive, u8 ireason)
 
 	while (retries-- && ((ireason & ATAPI_COD) == 0 ||
 		(ireason & ATAPI_IO))) {
-		printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
+		printk(KERN_ERR PFX "%s: (IO,CoD != (0,1) while issuing "
 				"a packet command, retrying\n", drive->name);
 		udelay(100);
 		ireason = ide_read_ireason(drive);
 		if (retries == 0) {
-			printk(KERN_ERR "%s: (IO,CoD != (0,1) while issuing "
-					"a packet command, ignoring\n",
+			printk(KERN_ERR PFX "%s: (IO,CoD != (0,1) while issuing"
+					" a packet command, ignoring\n",
 					drive->name);
 			ireason |= ATAPI_COD;
 			ireason &= ~ATAPI_IO;
@@ -538,7 +580,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	u8 ireason;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ, ATA_BUSY, WAIT_READY)) {
-		printk(KERN_ERR "%s: Strange, packet command initiated yet "
+		printk(KERN_ERR PFX "%s: Strange, packet command initiated yet "
 				"DRQ isn't asserted\n", drive->name);
 		return startstop;
 	}
@@ -580,7 +622,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			ireason = ide_wait_ireason(drive, ireason);
 
 		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
-			printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+			printk(KERN_ERR PFX "%s: (IO,CoD) != (0,1) while issuing "
 					"a packet command\n", drive->name);
 
 			return ide_do_reset(drive);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index f6fb29b..46c87a0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -417,50 +417,6 @@ end_request:
 		return 2;
 }
 
-/*
- * Check the contents of the interrupt reason register from the cdrom
- * and attempt to recover if there are problems.  Returns  0 if everything's
- * ok; nonzero if the request has been terminated.
- */
-static int ide_cd_check_ireason(ide_drive_t *drive, struct request *rq,
-				int len, int ireason, int rw)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	ide_debug_log(IDE_DBG_FUNC, "ireason: 0x%x, rw: 0x%x", ireason, rw);
-
-	/*
-	 * ireason == 0: the drive wants to receive data from us
-	 * ireason == 2: the drive is expecting to transfer data to us
-	 */
-	if (ireason == (!rw << 1))
-		return 0;
-	else if (ireason == (rw << 1)) {
-
-		/* whoops... */
-		printk(KERN_ERR PFX "%s: %s: wrong transfer direction!\n",
-				drive->name, __func__);
-
-		ide_pad_transfer(drive, rw, len);
-	} else  if (rw == 0 && ireason == 1) {
-		/*
-		 * Some drives (ASUS) seem to tell us that status info is
-		 * available.  Just get it and ignore.
-		 */
-		(void)hwif->tp_ops->read_status(hwif);
-		return 0;
-	} else {
-		/* drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR PFX "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __func__, ireason);
-	}
-
-	if (rq->cmd_type == REQ_TYPE_ATA_PC)
-		rq->cmd_flags |= REQ_FAILED;
-
-	return -1;
-}
-
 static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	struct request *rq = cmd->rq;
@@ -652,9 +608,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		goto out_end;
 	}
 
-	/* check which way to transfer data */
-	rc = ide_cd_check_ireason(drive, rq, len, ireason, write);
-	if (rc)
+	if (ide_check_ireason(drive, rq, len, ireason, write))
 		goto out_end;
 
 	cmd->last_xfer_len = 0;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 59aedcd..70a2c94 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1125,6 +1125,8 @@ void SELECT_MASK(ide_drive_t *, int);
 u8 ide_read_error(ide_drive_t *);
 void ide_read_bcount_and_ireason(ide_drive_t *, u16 *, u8 *);
 
+int ide_check_ireason(ide_drive_t *, struct request *, int, int, int);
+
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
-- 
1.6.2.4

