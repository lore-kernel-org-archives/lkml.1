Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYACNZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYACNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYACNXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:31 -0500
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:21519 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752918AbYACNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=vbJHE3kKS6t1xKRq41iK4X7GlPhasZ//jcUvT9aEqOygxha8e7ZQB2wkuBFtdQWWd1OMznDZkcuC9KfKGLkuP4ZYzgHF3JWJItVBmCi2txJ695pJcTkq6UbSknYpXPHaoK78ukOyiJur6zjqp6krPvE/EaSG77PUImqaMMNkgx8=  ;
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 09/10] ide-floppy: use test_bit wrappers for testing flags
Date: Thu,  3 Jan 2008 14:20:08 +0100
Message-Id: <1199366409-26016-10-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-8-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-9-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also, fix header comments and remove superfluous ones. There should be no
functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   45 ++++++++---------
 drivers/ide/ide-floppy.h |  127 +++++++++++++++++++++-------------------------
 2 files changed, 79 insertions(+), 93 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index fd5fe7b..6c29b5f 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -337,7 +337,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 
 	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
-	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
+	if (idefl_dma_ongoing(pc)) {
 
 		dma_error = HWIF(drive)->ide_dma_end(drive);
 		if (dma_error) {
@@ -365,7 +365,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 
 		local_irq_enable_in_hardirq();
 
-		if (status.b.check || test_bit(PC_DMA_ERROR, &pc->flags)) {
+		if (status.b.check || idefl_dma_err(pc)) {
 			/* Error detected */
 			debug_log("%s: I/O error\n", drive->name);
 			rq->errors++;
@@ -404,7 +404,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: CoD != 0 in idefloppy_pc_intr\n");
 		return ide_do_reset(drive);
 	}
-	if (ireason.b.io == test_bit(PC_WRITING, &pc->flags)) {
+	if (ireason.b.io == idefl_data_dir(pc)) {
 		/* Hopefully, we will never get here */
 		printk(KERN_ERR "ide-floppy: We wanted to %s, ",
 			ireason.b.io ? "Write":"Read");
@@ -412,7 +412,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 			ireason.b.io ? "Read":"Write");
 		return ide_do_reset(drive);
 	}
-	if (!test_bit(PC_WRITING, &pc->flags)) {
+	if (!idefl_data_dir(pc)) {
 		/* Reading - Check that we have enough space */
 		temp = pc->actually_transferred + bcount.all;
 		if (temp > pc->request_transfer) {
@@ -432,7 +432,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 					"expected - allowing transfer\n");
 		}
 	}
-	if (test_bit(PC_WRITING, &pc->flags)) {
+	if (idefl_data_dir(pc)) {
 		if (pc->buffer != NULL)
 			/* Write the current buffer */
 			HWIF(drive)->atapi_output_bytes(drive,
@@ -579,14 +579,13 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc
 	/* Set the current packet command */
 	floppy->pc = pc;
 
-	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES ||
-	    test_bit(PC_ABORT, &pc->flags)) {
+	if (pc->retries > IDEFLOPPY_MAX_PC_RETRIES || idefl_abort(pc)) {
 		/*
-		 *	We will "abort" retrying a packet command in case
-		 *	a legitimate error code was received.
+		 * We will "abort" retrying a packet command in case a
+		 * legitimate error code was received.
 		 */
-		if (!test_bit(PC_ABORT, &pc->flags)) {
-			if (!test_bit(PC_SUPPRESS_ERROR, &pc->flags)) {
+		if (!idefl_abort(pc)) {
+			if (!idefl_supp_err(pc)) {
 				if (idefloppy_report_error(floppy))
 					printk(KERN_ERR "ide-floppy: %s: I/O error, "
 					       "pc = %2x, key = %2x, "
@@ -616,7 +615,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc
 
 	feature.all = 0;
 
-	if (test_bit(PC_DMA_RECOMMENDED, &pc->flags) && drive->using_dma)
+	if (idefl_dma_prefd(pc) && drive->using_dma)
 		feature.b.dma = !hwif->dma_setup(drive);
 
 	if (IDE_CONTROL_REG)
@@ -633,7 +632,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc
 	}
 
 	/* Can we transfer the packet when we get the interrupt or wait? */
-	if (test_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags)) {
+	if (idefl_zip_drive(floppy)) {
 		/* wait */
 		pkt_xfer_routine = &idefloppy_transfer_pc1;
 	} else {
@@ -641,7 +640,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
 
-	if (test_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
+	if (idefl_drq_intr(floppy)) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
 				pkt_xfer_routine,
@@ -749,11 +748,10 @@ static void idefloppy_create_rw_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc,
 	int cmd = rq_data_dir(rq);
 
 	debug_log("create_rw1%d_cmd: block == %d, blocks == %d\n",
-		2 * test_bit(IDEFLOPPY_USE_READ12, &floppy->flags),
-		block, blocks);
+		2 * idefl_use_rw(floppy), block, blocks);
 
 	idefloppy_init_pc(pc);
-	if (test_bit(IDEFLOPPY_USE_READ12, &floppy->flags)) {
+	if (idefl_use_rw(floppy)) {
 		pc->c[0] = cmd == READ ? GPCMD_READ_12 : GPCMD_WRITE_12;
 		put_unaligned(htonl(blocks), (unsigned int *) &pc->c[6]);
 	} else {
@@ -982,7 +980,7 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 		switch (descriptor->dc) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
-			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
+			if (!idefl_clik_drive(floppy))
                                 /*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
@@ -1033,9 +1031,8 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-        if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+	if (!idefl_clik_drive(floppy))
 		(void) idefloppy_get_flexible_disk_page(drive);
-	}
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
 	return rc;
@@ -1515,12 +1512,12 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		}
 		set_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!idefl_clik_drive(floppy)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 		check_disk_change(inode->i_bdev);
-	} else if (test_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags)) {
+	} else if (idefl_format_in_progress(floppy)) {
 		ret = -EBUSY;
 		goto out_put_floppy;
 	}
@@ -1543,7 +1540,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!idefl_clik_drive(floppy)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
@@ -1581,7 +1578,7 @@ static int idefloppy_lockdoor(struct inode *inode, idefloppy_pc_t *pc,
 
 	/* The IOMEGA Clik! Drive doesn't support this command -
 	 * no room for an eject mechanism */
-	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+	if (!idefl_clik_drive(floppy)) {
 		idefloppy_create_prevent_cmd(pc, event);
 		(void) idefloppy_queue_pc_tail(drive, pc);
 	}
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
index fb55d32..053a8c8 100644
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -1,9 +1,7 @@
 #ifndef _IDE_FLOPPY_H
 #define _IDE_FLOPPY_H
 
-/*
- *	The following are used to debug the driver.
- */
+/* The following are used to debug the driver. */
 #define IDEFLOPPY_DEBUG_LOG		0
 #define IDEFLOPPY_DEBUG_INFO		0
 #define IDEFLOPPY_DEBUG_BUGS		1
@@ -18,33 +16,28 @@
 #define debug_log(fmt, args... ) do {} while(0)
 #endif
 
-/*
- *	Some drives require a longer irq timeout.
- */
+/* Some drives require a longer irq timeout. */
 #define IDEFLOPPY_WAIT_CMD		(5 * WAIT_CMD)
 
 /*
- *	After each failed packet command we issue a request sense command
- *	and retry the packet command IDEFLOPPY_MAX_PC_RETRIES times.
+ * After each failed packet command we issue a request sense command and retry
+ * the packet command IDEFLOPPY_MAX_PC_RETRIES times.
  */
 #define IDEFLOPPY_MAX_PC_RETRIES	3
 
 /*
- *	With each packet command, we allocate a buffer of
- *	IDEFLOPPY_PC_BUFFER_SIZE bytes.
+ * With each packet command, we allocate a buffer of IDEFLOPPY_PC_BUFFER_SIZE
+ * bytes.
  */
 #define IDEFLOPPY_PC_BUFFER_SIZE	256
 
 /*
- *	In various places in the driver, we need to allocate storage
- *	for packet commands and requests, which will remain valid while
- *	we leave the driver to wait for an interrupt or a timeout event.
+ * In various places in the driver, we need to allocate storage for packet
+ * commands and requests, which will remain valid while we leave the driver to
+ * wait for an interrupt or a timeout event.
  */
 #define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
 
-/*
- *	Our view of a packet command.
- */
 typedef struct idefloppy_packet_command_s {
 	u8 c[12];				/* Actual packet bytes */
 	int retries;				/* On each retry, we increment
@@ -65,27 +58,30 @@ typedef struct idefloppy_packet_command_s {
 						   for set_bit */
 } idefloppy_pc_t;
 
-/*
- *	Packet command flag bits.
- */
-#define	PC_ABORT			0	/* Set when an error is considered \
-						   normal - We won't retry */
+/* Packet command flag bits. */
+#define	PC_ABORT		0	/* Set when an error is considered \
+					   normal - We won't retry */
+#define PC_DMA_RECOMMENDED	2	/* 1 when we prefer to use DMA if \
+					   possible */
+#define	PC_DMA_IN_PROGRESS	3	/* 1 while DMA in progress */
 
-#define PC_DMA_RECOMMENDED		2	/* 1 when we prefer to use DMA \
-						   if possible */
+#define	PC_DMA_ERROR		4	/* 1 when encountered problem \
+					   during DMA */
 
-#define	PC_DMA_IN_PROGRESS		3	/* 1 while DMA in progress */
+#define	PC_WRITING		5	/* Data direction */
 
-#define	PC_DMA_ERROR			4	/* 1 when encountered problem \
-						   during DMA */
+#define	PC_SUPPRESS_ERROR	6	/* Suppress error reporting */
 
-#define	PC_WRITING			5	/* Data direction */
+#define idefl_abort(pc)		test_bit(PC_ABORT, &(pc)->flags)
+#define idefl_dma_prefd(pc)	test_bit(PC_DMA_RECOMMENDED, &(pc)->flags)
+#define idefl_dma_ongoing(pc)	test_bit(PC_DMA_IN_PROGRESS, &(pc)->flags)
+#define idefl_dma_err(pc)	test_bit(PC_DMA_ERROR, &(pc)->flags)
+#define idefl_data_dir(pc)	test_bit(PC_WRITING, &(pc)->flags)
+#define idefl_supp_err(pc)	test_bit(PC_SUPPRESS_ERROR, &(pc)->flags)
 
-#define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
 
-/*
- *	Removable Block Access Capabilities Page
- */
+
+/* Removable Block Access Capabilities Page */
 typedef struct {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
@@ -125,9 +121,7 @@ typedef struct {
 	u8		reserved[8];
 } idefloppy_cap_page_t;
 
-/*
- *	Flexible disk page.
- */
+/* Flexible disk page */
 typedef struct {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
@@ -155,9 +149,7 @@ typedef struct {
 	u8		reserved30[2];
 } idefloppy_flex_disk_page_t;
 
-/*
- *	Format capacity
- */
+/* Format capacity */
 typedef struct {
 	u8		reserved[3];
 	u8		length;			/* Length of the following
@@ -185,9 +177,9 @@ typedef struct {
 #define CAPACITY_NO_CARTRIDGE	0x03
 
 /*
- *	Most of our global data which we need to save even as we leave the
- *	driver due to an interrupt or a timer event is stored in a variable
- *	of type idefloppy_t, defined below.
+ * Most of our global data which we need to save even as we leave the driver
+ * due to an interrupt or a timer event is stored in a variable	of type
+ * idefloppy_t, defined below.
  */
 typedef struct ide_floppy_obj {
 	ide_drive_t	*drive;
@@ -208,17 +200,13 @@ typedef struct ide_floppy_obj {
 	/* We implement a circular array */
 	int rq_stack_index;
 
-	/*
-	 *	Last error information
-	 */
+	/* Last error information */
 	u8 sense_key, asc, ascq;
 	/* delay this long before sending packet command */
 	u8 ticks;
 	int progress_indication;
 
-	/*
-	 *	Device information
-	 */
+	/* Device information */
 	/* Current format */
 	int blocks, block_size, bs_factor;
 	/* Last format capacity */
@@ -235,9 +223,7 @@ typedef struct ide_floppy_obj {
 
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/*
- *	Floppy flag bits values.
- */
+/* Floppy flag bits values. */
 #define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
 #define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
 #define IDEFLOPPY_USE_READ12		2	/* Use READ12/WRITE12 or \
@@ -249,32 +235,41 @@ typedef struct ide_floppy_obj {
 
 #define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for \
 						   packets */
-/*
- *	Defines for the mode sense command
- */
+
+#define idefl_drq_intr(f)		test_bit(IDEFLOPPY_DRQ_INTERRUPT,\
+						&(f)->flags)
+#define idefl_media_changed(f)		test_bit(IDEFLOPPY_MEDIA_CHANGED, \
+						&(f)->flags)
+#define idefl_use_rw(f)			test_bit(IDEFLOPPY_USE_READ12, \
+						&(f)->flags)
+#define idefl_format_in_progress(f)	test_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, \
+						&(f)->flags)
+#define idefl_clik_drive(f)		test_bit(IDEFLOPPY_CLIK_DRIVE, \
+						&(f)->flags)
+#define idefl_zip_drive(f)		test_bit(IDEFLOPPY_ZIP_DRIVE,\
+						&(f)->flags)
+
+/* Defines for the mode sense command */
 #define MODE_SENSE_CURRENT		0x00
 #define MODE_SENSE_CHANGEABLE		0x01
 #define MODE_SENSE_DEFAULT		0x02
 #define MODE_SENSE_SAVED		0x03
 
-/*
- *	IOCTLs used in low-level formatting.
- */
-
+/* IOCTLs used in low-level formatting. */
 #define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
 #define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
 #define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
 #define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
 
 /*
- *	Error codes which are returned in rq->errors to the higher part
- *	of the driver.
+ * Error codes which are returned in rq->errors to the higher part
+ * of the driver.
  */
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
 /*
- *	The following is used to format the general configuration word of
- *	the ATAPI IDENTIFY DEVICE command.
+ * The following is used to format the general configuration word of the ATAPI
+ * IDENTIFY DEVICE command.
  */
 struct idefloppy_id_gcw {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
@@ -298,9 +293,7 @@ struct idefloppy_id_gcw {
 #endif
 };
 
-/*
- *	REQUEST SENSE packet command result - Data Format.
- */
+/* REQUEST SENSE packet command result - Data Format. */
 typedef struct {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned	error_code	:7;	/* Current error (0x70) */
@@ -334,15 +327,11 @@ typedef struct {
 	u8		pad[2];			/* Padding to 20 bytes */
 } rq_sense_res_t;
 
-/*
- *	Pages of the SELECT SENSE / MODE SENSE packet commands.
- */
+/* Pages of the SELECT SENSE / MODE SENSE packet commands. */
 #define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
 #define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
 
-/*
- *	Mode Parameter Header for the MODE SENSE packet command
- */
+/* Mode Parameter Header for the MODE SENSE packet command */
 typedef struct {
 	u16		mode_data_length;	/* Length of the following data
 						   transfer */
-- 
1.5.3.7

