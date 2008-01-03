Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYACN05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYACN05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYACNXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:39 -0500
Received: from smtp105.plus.mail.re1.yahoo.com ([69.147.102.68]:40674 "HELO
	smtp105.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753334AbYACNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=uFiP77B5zr1ggHCIjrqxzOL/QBKybOElznu0yTzpvmw6aRiVtcE545rRi+oINvgnPtQ+2MgKBExxdB2Prks2PJ7uxOKhJAV7fum+uczXEB9a+aidAEvQm2qKyox6nn8hYc1Z/8PSoOjKVMQ/qyWAo3vMfbFqZ38M5W3IeHdhz00=  ;
X-YMail-OSG: Ieu8_w0VM1lVKsLYl8Uy4_o47SXyj2I8RAfMEXOdVQacCzi1i_2TgBZBsWEcUpFyjokwoY5MWO785XfIbyZLMCTmPxdHW3laIXywSdyxXDv7rGpoFg--
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 06/10] ide-floppy: report DMA handling in idefloppy_pc_intr() properly
Date: Thu,  3 Jan 2008 14:20:05 +0100
Message-Id: <1199366409-26016-7-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while at it:
-cleanup small issues raised by scripts/checkpatch.pl
-remove redundant and shorten some comments

There should be no functionality change resulting from this patch

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  195 ++++++++++++++++++++--------------------------
 1 files changed, 83 insertions(+), 112 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 7823447..5d0fd1f 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -5,9 +5,7 @@
  * Copyright (C) 2000 - 2002 Paul Bristow <paul@paulbristow.net>
  *
  * The driver currently doesn't have any fancy features, just the bare
- * minimum read/write support.
- *
- * This driver supports the following IDE floppy drives:
+ * minimum read/write support. It supports the following IDE floppy drives:
  *
  * LS-120/240 SuperDisk
  * Iomega Zip 100/250
@@ -75,8 +73,8 @@ static void ide_floppy_put(struct ide_floppy_obj *floppy)
 }
 
 /*
- *	Too bad. The drive wants to send us data which we are not ready to accept.
- *	Just throw it away.
+ * Too bad. The drive wants to send us data which we are not ready to accept.
+ * Just throw it away.
  */
 static void idefloppy_discard_data (ide_drive_t *drive, unsigned int bcount)
 {
@@ -94,10 +92,8 @@ static void idefloppy_write_zeros (ide_drive_t *drive, unsigned int bcount)
 
 
 /*
- *	idefloppy_do_end_request is used to finish servicing a request.
- *
- *	For read/write requests, we will call ide_end_request to pass to the
- *	next buffer.
+ * Used to finish servicing a request. For read/write requests, we will call
+ * ide_end_request to pass to the next buffer.
  */
 static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
@@ -128,7 +124,7 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc,
+static void idefloppy_input_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
 		unsigned int bcount)
 {
 	struct request *rq = pc->rq;
@@ -162,7 +158,7 @@ static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc,
 	}
 }
 
-static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc,
+static void idefloppy_output_buffers(ide_drive_t *drive, idefloppy_pc_t *pc,
 		unsigned int bcount)
 {
 	struct request *rq = pc->rq;
@@ -198,7 +194,7 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc,
 #endif
 }
 
-static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
+static void idefloppy_update_buffers(ide_drive_t *drive, idefloppy_pc_t *pc)
 {
 	struct request *rq = pc->rq;
 	struct bio *bio = rq->bio;
@@ -208,11 +204,11 @@ static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
 }
 
 /*
- *	idefloppy_queue_pc_head generates a new packet command request in front
- *	of the request queue, before the current request, so that it will be
- *	processed immediately, on the next pass through the driver.
+ * Generates a new packet command request in front
+ * of the request queue, before the current request, so that it will be
+ * processed immediately, on the next pass through the driver.
  */
-static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,
+static void idefloppy_queue_pc_head(ide_drive_t *drive, idefloppy_pc_t *pc,
 		struct request *rq)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
@@ -224,7 +220,7 @@ static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
 
-static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
+static idefloppy_pc_t *idefloppy_next_pc_storage(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 
@@ -233,7 +229,7 @@ static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
 	return (&floppy->pc_stack[floppy->pc_stack_index++]);
 }
 
-static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
+static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 
@@ -242,11 +238,8 @@ static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
 	return (&floppy->rq_stack[floppy->rq_stack_index++]);
 }
 
-/*
- *	idefloppy_analyze_error is called on each failed packet command retry
- *	to analyze the request sense.
- */
-static void idefloppy_analyze_error (ide_drive_t *drive,
+/* Called on each failed packet command retry to analyze the request sense. */
+static void idefloppy_analyze_error(ide_drive_t *drive,
 		rq_sense_res_t *result)
 {
 	idefloppy_t *floppy = drive->driver_data;
@@ -265,7 +258,7 @@ static void idefloppy_analyze_error (ide_drive_t *drive,
 				result->sense_key, result->asc, result->ascq);
 }
 
-static void idefloppy_request_sense_callback (ide_drive_t *drive)
+static void idefloppy_request_sense_callback(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	u8 *buf = floppy->pc->buffer;
@@ -283,10 +276,8 @@ static void idefloppy_request_sense_callback (ide_drive_t *drive)
 	}
 }
 
-/*
- *	General packet command callback function.
- */
-static void idefloppy_pc_callback (ide_drive_t *drive)
+/* General packet command callback function. */
+static void idefloppy_pc_callback(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 
@@ -295,10 +286,7 @@ static void idefloppy_pc_callback (ide_drive_t *drive)
 	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
 
-/*
- *	idefloppy_init_pc initializes a packet command.
- */
-static void idefloppy_init_pc (idefloppy_pc_t *pc)
+static void idefloppy_init_pc(idefloppy_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
@@ -309,7 +297,7 @@ static void idefloppy_init_pc (idefloppy_pc_t *pc)
 	pc->callback = &idefloppy_pc_callback;
 }
 
-static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
+static void idefloppy_create_request_sense_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
@@ -319,11 +307,10 @@ static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
 }
 
 /*
- *	idefloppy_retry_pc is called when an error was detected during the
- *	last packet command. We queue a request sense packet command in
- *	the head of the request list.
+ * Called when an error was detected during the last packet command. We queue a
+ * request sense packet command in the head of the request list.
  */
-static void idefloppy_retry_pc (ide_drive_t *drive)
+static void idefloppy_retry_pc(ide_drive_t *drive)
 {
 	idefloppy_pc_t *pc;
 	struct request *rq;
@@ -336,11 +323,8 @@ static void idefloppy_retry_pc (ide_drive_t *drive)
 	idefloppy_queue_pc_head(drive, pc, rq);
 }
 
-/*
- *	idefloppy_pc_intr is the usual interrupt handler which will be called
- *	during a packet command.
- */
-static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
+/* The usual interrupt handler which will be called during a packet command. */
+static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	atapi_status_t status;
@@ -349,17 +333,25 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	idefloppy_pc_t *pc = floppy->pc;
 	struct request *rq = pc->rq;
 	unsigned int temp;
+	int dma_error = 0;
 
 	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
 
 	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
-		if (HWIF(drive)->ide_dma_end(drive)) {
+
+		dma_error = HWIF(drive)->ide_dma_end(drive);
+		if (dma_error) {
+			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
+					rq_data_dir(rq) == WRITE ?
+					"write" :
+					"read");
 			set_bit(PC_DMA_ERROR, &pc->flags);
 		} else {
 			pc->actually_transferred = pc->request_transfer;
 			idefloppy_update_buffers(drive, pc);
+
+			debug_log("%s: DMA finished\n", __FUNCTION__);
 		}
-		debug_log("%s: DMA finished\n", __FUNCTION__);
 	}
 
 	/* Clear the interrupt */
@@ -473,7 +465,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
  * It fails at high speeds on the Iomega ZIP drive, so there's a slower version
  * for that drive below. The algorithm is chosen based on drive type
  */
-static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
+static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
 {
 	ide_startstop_t startstop;
 	idefloppy_t *floppy = drive->driver_data;
@@ -498,7 +490,6 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
 	return ide_started;
 }
 
-
 /*
  * What we have here is a classic case of a top half / bottom half
  * interrupt service routine. In interrupt mode, the device sends
@@ -511,7 +502,7 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
  * packet, we schedule the packet transfer to occur about 2-3 ticks
  * later in transfer_pc2.
  */
-static int idefloppy_transfer_pc2 (ide_drive_t *drive)
+static int idefloppy_transfer_pc2(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 
@@ -521,7 +512,7 @@ static int idefloppy_transfer_pc2 (ide_drive_t *drive)
 	return IDEFLOPPY_WAIT_CMD;
 }
 
-static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
+static ide_startstop_t idefloppy_transfer_pc1(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
@@ -554,11 +545,7 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 	return ide_started;
 }
 
-/**
- * idefloppy_should_report_error()
- *
- * Supresses error messages resulting from Medium not present
- */
+/* Supresses error messages resulting from Medium not present */
 static inline int idefloppy_should_report_error(idefloppy_t *floppy)
 {
 	if (floppy->sense_key == 0x02 &&
@@ -568,10 +555,7 @@ static inline int idefloppy_should_report_error(idefloppy_t *floppy)
 	return 1;
 }
 
-/*
- *	Issue a packet command
- */
-static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *pc)
+static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive, idefloppy_pc_t *pc)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -591,9 +575,9 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 #endif /* IDEFLOPPY_DEBUG_BUGS */
 #endif
 
-	if (floppy->failed_pc == NULL &&
-	    pc->c[0] != GPCMD_REQUEST_SENSE)
+	if (floppy->failed_pc == NULL && pc->c[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
+
 	/* Set the current packet command */
 	floppy->pc = pc;
 
@@ -659,7 +643,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
 
-	if (test_bit (IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
+	if (test_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
 				pkt_xfer_routine,
@@ -681,7 +665,7 @@ static void idefloppy_rw_callback(ide_drive_t *drive)
 	return;
 }
 
-static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
+static void idefloppy_create_prevent_cmd(idefloppy_pc_t *pc, int prevent)
 {
 	debug_log("creating prevent removal command, prevent = %d\n", prevent);
 
@@ -690,7 +674,7 @@ static void idefloppy_create_prevent_cmd (idefloppy_pc_t *pc, int prevent)
 	pc->c[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd (idefloppy_pc_t *pc)
+static void idefloppy_create_read_capacity_cmd(idefloppy_pc_t *pc)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
@@ -699,7 +683,7 @@ static void idefloppy_create_read_capacity_cmd (idefloppy_pc_t *pc)
 	pc->request_transfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
+static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
 					      int flags)
 {
 	idefloppy_init_pc(pc);
@@ -720,10 +704,8 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 	set_bit(PC_WRITING, &pc->flags);
 }
 
-/*
- *	A mode sense command is used to "sense" floppy parameters.
- */
-static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code,
+/* A mode sense command is used to "sense" floppy parameters. */
+static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 		u8 type)
 {
 	u16 length = sizeof(idefloppy_mode_par_hdr_t);
@@ -748,7 +730,7 @@ static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code,
 	pc->request_transfer = length;
 }
 
-static void idefloppy_create_start_stop_cmd (idefloppy_pc_t *pc, int start)
+static void idefloppy_create_start_stop_cmd(idefloppy_pc_t *pc, int start)
 {
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_START_STOP_UNIT;
@@ -761,7 +743,7 @@ static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
 	pc->c[0] = GPCMD_TEST_UNIT_READY;
 }
 
-static void idefloppy_create_rw_cmd (idefloppy_t *floppy, idefloppy_pc_t *pc,
+static void idefloppy_create_rw_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc,
 		struct request *rq, unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
@@ -792,7 +774,8 @@ static void idefloppy_create_rw_cmd (idefloppy_t *floppy, idefloppy_pc_t *pc,
 }
 
 static void
-idefloppy_blockpc_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
+idefloppy_blockpc_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc,
+		struct request *rq)
 {
 	idefloppy_init_pc(pc);
 	pc->callback = &idefloppy_rw_callback;
@@ -812,10 +795,7 @@ idefloppy_blockpc_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc, struct request *r
 	pc->request_transfer = pc->buffer_size = rq->data_len;
 }
 
-/*
- *	idefloppy_do_request is our request handling function.
- */
-static ide_startstop_t idefloppy_do_request (ide_drive_t *drive,
+static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		struct request *rq, sector_t block_s)
 {
 	idefloppy_t *floppy = drive->driver_data;
@@ -874,10 +854,10 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive,
 }
 
 /*
- *	idefloppy_queue_pc_tail adds a special packet command request to the
- *	tail of the request queue, and waits for it to be serviced.
+ * Add a special packet command request to the tail of the request queue,
+ * and wait for it to be serviced.
  */
-static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
+static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request rq;
@@ -891,10 +871,10 @@ static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
 }
 
 /*
- *	Look at the flexible disk page parameters. We will ignore the CHS
- *	capacity parameters and use the LBA parameters instead.
+ * Look at the flexible disk page parameters. We will ignore the CHS
+ * capacity parameters and use the LBA parameters instead.
  */
-static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
+static int idefloppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
@@ -969,10 +949,10 @@ static int idefloppy_get_capability_page(ide_drive_t *drive)
 }
 
 /*
- *	Determine if a media is present in the floppy drive, and if so,
- *	its LBA capacity.
+ * Determine if a media is present in the floppy drive, and if so,
+ * its LBA capacity.
  */
-static int idefloppy_get_capacity (ide_drive_t *drive)
+static int idefloppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
@@ -1192,7 +1172,6 @@ static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
  * If the drive does not support format progress indication, we just check
  * the dsc bit, and return either 0 or 65536.
  */
-
 static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
 	idefloppy_t *floppy = drive->driver_data;
@@ -1228,10 +1207,8 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 	return (0);
 }
 
-/*
- *	Return the current floppy capacity.
- */
-static sector_t idefloppy_capacity (ide_drive_t *drive)
+/* Return the current floppy capacity. */
+static sector_t idefloppy_capacity(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	unsigned long capacity = floppy->blocks * floppy->bs_factor;
@@ -1240,10 +1217,9 @@ static sector_t idefloppy_capacity (ide_drive_t *drive)
 }
 
 /*
- *	idefloppy_identify_device checks if we can support a drive,
- *	based on the ATAPI IDENTIFY command results.
+ * Check if we can support a drive, based on the ATAPI IDENTIFY command results.
  */
-static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
+static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
 {
 	struct idefloppy_id_gcw gcw;
 #if IDEFLOPPY_DEBUG_INFO
@@ -1394,10 +1370,7 @@ static void idefloppy_add_settings(ide_drive_t *drive)
 static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
 #endif
 
-/*
- *	Driver initialization.
- */
-static void idefloppy_setup (ide_drive_t *drive, idefloppy_t *floppy)
+static void idefloppy_setup(ide_drive_t *drive, idefloppy_t *floppy)
 {
 	struct idefloppy_id_gcw gcw;
 
@@ -1406,14 +1379,13 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_t *floppy)
 	if (gcw.drq_type == 1)
 		set_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags);
 	/*
-	 *	We used to check revisions here. At this point however
-	 *	I'm giving up. Just assume they are all broken, its easier.
+	 * We used to check revisions here. At this point however I'm giving up.
+	 * Just assume they are all broken, its easier.
 	 *
-	 *	The actual reason for the workarounds was likely
-	 *	a driver bug after all rather than a firmware bug,
-	 *	and the workaround below used to hide it. It should
-	 *	be fixed as of version 1.9, but to be on the safe side
-	 *	we'll leave the limitation below for the 2.2.x tree.
+	 * The actual reason for the workarounds was likely a driver bug after
+	 * all rather than a firmware bug, and the workaround below used to hide
+	 * it. It should be fixed as of version 1.9, but to be on the safe side
+	 * we'll leave the limitation below for the 2.2.x tree.
 	 */
 
 	if (!strncmp(drive->id->model, "IOMEGA ZIP 100 ATAPI", 20)) {
@@ -1424,10 +1396,9 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_t *floppy)
 	}
 
 	/*
-	*      Guess what?  The IOMEGA Clik! drive also needs the
-	*      above fix.  It makes nasty clicking noises without
-	*      it, so please don't remove this.
-	*/
+	 * Guess what? The IOMEGA Clik! drive also needs the above fix. It makes
+	 * nasty clicking noises without it, so please don't remove this.
+	 */
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
 		blk_queue_max_sectors(drive->queue, 64);
 		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
@@ -1437,7 +1408,7 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_t *floppy)
 	idefloppy_add_settings(drive);
 }
 
-static void ide_floppy_remove(ide_drive_t *drive)
+static void idefloppy_remove(ide_drive_t *drive)
 {
 	idefloppy_t *floppy = drive->driver_data;
 	struct gendisk *g = floppy->disk;
@@ -1479,7 +1450,7 @@ static ide_proc_entry_t idefloppy_proc[] = {
 };
 #endif	/* CONFIG_IDE_PROC_FS */
 
-static int ide_floppy_probe(ide_drive_t *);
+static int idefloppy_probe(ide_drive_t *);
 
 static ide_driver_t idefloppy_driver = {
 	.gen_driver = {
@@ -1487,8 +1458,8 @@ static ide_driver_t idefloppy_driver = {
 		.name		= "ide-floppy",
 		.bus		= &ide_bus_type,
 	},
-	.probe			= ide_floppy_probe,
-	.remove			= ide_floppy_remove,
+	.probe			= idefloppy_probe,
+	.remove			= idefloppy_remove,
 	.version		= IDEFLOPPY_VERSION,
 	.media			= ide_floppy,
 	.supports_dsc_overlap	= 0,
@@ -1733,7 +1704,7 @@ static struct block_device_operations idefloppy_ops = {
 	.revalidate_disk= idefloppy_revalidate_disk
 };
 
-static int ide_floppy_probe(ide_drive_t *drive)
+static int idefloppy_probe(ide_drive_t *drive)
 {
 	idefloppy_t *floppy;
 	struct gendisk *g;
@@ -1796,7 +1767,7 @@ failed:
 
 MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
 
-static void __exit idefloppy_exit (void)
+static void __exit idefloppy_exit(void)
 {
 	driver_unregister(&idefloppy_driver.gen_driver);
 }
-- 
1.5.3.7

