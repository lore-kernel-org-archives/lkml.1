Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbYA0J67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbYA0J67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbYA0JuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:50:19 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59292 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756770AbYA0JuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:50:02 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 32/32] ide-tape: cleanup the remaining codestyle issues
Date: Sun, 27 Jan 2008 10:48:20 +0100
Message-Id: <1201427300-3954-27-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Which is, in particular:
- reorganize #defines at the top
- whitespace cleanup
- remove the "!= NULL" chuck from the pointer validity tests since the short
	version "if (ptr)" is more intuitive
- fix comments
- remove unused "length" arg from idetape_create_read_buffer_cmd()
- shorten some vars in order to fit lines into 80 columns.
- include proper headers
- finally, bump driver version

thus decreasing checkpatch errors to 0.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c | 1525 ++++++++++++++++++++++++------------------------
 1 files changed, 758 insertions(+), 767 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 424879d..f51712c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -15,7 +15,7 @@
  * Documentation/ide/ChangeLog.ide-tape.1995-2002
  */
 
-#define IDETAPE_VERSION "1.19"
+#define IDETAPE_VERSION "1.20"
 
 #include <linux/module.h>
 #include <linux/types.h>
@@ -39,34 +39,12 @@
 #include <scsi/scsi.h>
 
 #include <asm/byteorder.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/irq.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <asm/unaligned.h>
 #include <linux/mtio.h>
 
-/**************************** Tunable parameters *****************************/
-
-
-/*
- *	Pipelined mode parameters.
- *
- *	We try to use the minimum number of stages which is enough to
- *	keep the tape constantly streaming. To accomplish that, we implement
- *	a feedback loop around the maximum number of stages:
- *
- *	We start from MIN maximum stages (we will not even use MIN stages
- *      if we don't need them), increment it by RATE*(MAX-MIN)
- *	whenever we sense that the pipeline is empty, until we reach
- *	the optimum value or until we reach MAX.
- *
- *	Setting the following parameter to 0 is illegal: the pipelined mode
- *	cannot be disabled (idetape_calculate_speeds() divides by
- *	tape->max_stages.)
- */
-#define IDETAPE_MIN_PIPELINE_STAGES	  1
-#define IDETAPE_MAX_PIPELINE_STAGES	400
-#define IDETAPE_INCREASE_STAGES_RATE	 20
 
 enum {
 	DBG_ERR =		(1 << 0),
@@ -90,17 +68,34 @@ enum {
 #endif
 
 /*
- *	After each failed packet command we issue a request sense command
- *	and retry the packet command IDETAPE_MAX_PC_RETRIES times.
+ * Tunable parameters:
+ *
+ * Pipelined mode parameters.
+ *
+ * We try to use the minimum number of stages which is enough to keep the tape
+ * constantly streaming. To accomplish that, we implement a feedback loop around
+ * the maximum number of stages:
+ *
+ * We start from MIN maximum stages (we will not even use MIN stages if we don't
+ * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
+ * pipeline is empty, until we reach the optimum value or until we reach MAX.
  *
- *	Setting IDETAPE_MAX_PC_RETRIES to 0 will disable retries.
+ * Setting the following parameter to 0 is illegal: the pipelined mode cannot be
+ * disabled (idetape_calculate_speeds() divides by tape->max_stages.)
+ */
+#define IDETAPE_MIN_PPL_STAGES	  1
+#define IDETAPE_MAX_PPL_STAGES	400
+#define IDETAPE_INCREASE_STAGES_RATE	 20
+
+/*
+ * After each failed packet command we issue a request sense command and retry
+ * the packet command IDETAPE_MAX_PC_RETRIES times. Set it to 0 to disable.
  */
 #define IDETAPE_MAX_PC_RETRIES		3
 
 /*
- *	With each packet command, we allocate a buffer of
- *	IDETAPE_PC_BUFFER_SIZE bytes. This is used for several packet
- *	commands (Not for READ/WRITE commands).
+ * With each packet command, we allocate a buffer of IDETAPE_PC_BUFFER_SIZE
+ * bytes. (Used for several packet commands but not for READ/WRITE commands).
  */
 #define IDETAPE_PC_BUFFER_SIZE		256
 
@@ -112,48 +107,40 @@ enum {
 #define IDETAPE_WAIT_CMD		(900*HZ)
 
 /*
- *	The following parameter is used to select the point in the internal
- *	tape fifo in which we will start to refill the buffer. Decreasing
- *	the following parameter will improve the system's latency and
- *	interactive response, while using a high value might improve system
- *	throughput.
+ * The following parameter is used to select the point in the internal tape fifo
+ * in which we will start to refill the buffer. Decreasing the following
+ * parameter will improve the system's latency and interactive response, while
+ * using a high value might improve system throughput.
  */
-#define IDETAPE_FIFO_THRESHOLD 		2
+#define IDETAPE_FIFO_THRESHOLD		2
 
 /*
- *	DSC polling parameters.
- *
- *	Polling for DSC (a single bit in the status register) is a very
- *	important function in ide-tape. There are two cases in which we
- *	poll for DSC:
+ * DSC polling parameters.
  *
- *	1.	Before a read/write packet command, to ensure that we
- *		can transfer data from/to the tape's data buffers, without
- *		causing an actual media access. In case the tape is not
- *		ready yet, we take out our request from the device
- *		request queue, so that ide.c will service requests from
- *		the other device on the same interface meanwhile.
+ * Polling for DSC (a single bit in the status register) is a very important
+ * function in ide-tape. There are two cases in which we poll for DSC:
  *
- *	2.	After the successful initialization of a "media access
- *		packet command", which is a command which can take a long
- *		time to complete (it can be several seconds or even an hour).
+ * 1. Before a read/write packet command, to ensure that we can transfer data
+ *    from/to the tape's data buffers, without causing an actual media access.
+ *    In case the tape is not ready yet, we take out our request from the device
+ *    request queue, so that ide.c could service requests from the other device
+ *    on the same interface in the meantime.
  *
- *		Again, we postpone our request in the middle to free the bus
- *		for the other device. The polling frequency here should be
- *		lower than the read/write frequency since those media access
- *		commands are slow. We start from a "fast" frequency -
- *		IDETAPE_DSC_MA_FAST (one second), and if we don't receive DSC
- *		after IDETAPE_DSC_MA_THRESHOLD (5 minutes), we switch it to a
- *		lower frequency - IDETAPE_DSC_MA_SLOW (1 minute).
+ * 2. After the successful initialization of a "media access packet command",
+ *    which is a command that can take a long time to complete (the interval can
+ *    range from several seconds to even an hour).
  *
- *	We also set a timeout for the timer, in case something goes wrong.
- *	The timeout should be longer then the maximum execution time of a
- *	tape operation.
- */
- 
-/*
- *	DSC timings.
+ * Again, we postpone our request in the middle to free the bus	for the other
+ * device. The polling frequency here should be	lower than the read/write
+ * frequency since those media access commands are slow. We start from a "fast"
+ * frequency - IDETAPE_DSC_MA_FAST (one second), and if we don't receive DSC
+ * after IDETAPE_DSC_MA_THRESHOLD (5 minutes), we switch it to a lower frequency
+ * - IDETAPE_DSC_MA_SLOW (1 minute). We also set a timeout for the timer, in
+ * case something goes wrong. The timeout should be longer then the maximum
+ * execution time of a tape operation.
  */
+
+/* DSC timings. */
 #define IDETAPE_DSC_RW_MIN		5*HZ/100	/* 50 msec */
 #define IDETAPE_DSC_RW_MAX		40*HZ/100	/* 400 msec */
 #define IDETAPE_DSC_RW_TIMEOUT		2*60*HZ		/* 2 minutes */
@@ -162,17 +149,12 @@ enum {
 #define IDETAPE_DSC_MA_SLOW		30*HZ		/* 30 seconds */
 #define IDETAPE_DSC_MA_TIMEOUT		2*60*60*HZ	/* 2 hours */
 
-/*************************** End of tunable parameters ***********************/
+/* End of tunable parameters */
 
-/*
- *	Read/Write error simulation
- */
+/* Read/Write error simulation */
 #define SIMULATE_ERRORS			0
 
-/*
- *	For general magnetic tape device compatibility.
- */
-
+/* For general magnetic tape device compatibility. */
 /* tape directions */
 typedef enum {
 	idetape_dir_none,
@@ -223,9 +205,7 @@ enum {
 	PC_FL_WRITING		= (1 <<	5),
 };
 
-/*
- *	A pipeline stage.
- */
+/* A pipeline stage. */
 typedef struct idetape_stage_s {
 	struct request rq;			/* The corresponding request */
 	struct idetape_bh *bh;			/* The data buffers */
@@ -320,7 +300,7 @@ typedef struct ide_tape_obj {
 	/* active data request */
 	struct request *act_data_rq;
 	/* Data buffer size chosen based on the tape's recommendation */
-	int stage_size;
+	int stage_sz;
 	idetape_stage_t *merge_stage;
 	int merge_stage_sz;
 	struct idetape_bh *bh;
@@ -418,7 +398,7 @@ typedef struct ide_tape_obj {
 	/* restart speed control req */
 	int rs_speed_ctl_rq;
 
-         u32 debug_level;
+	u32 debug_level;
 } idetape_tape_t;
 
 static DEFINE_MUTEX(idetape_ref_mutex);
@@ -451,9 +431,7 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	mutex_unlock(&idetape_ref_mutex);
 }
 
-/*
- *	Tape door status
- */
+/* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
 #define DOOR_EXPLICITLY_LOCKED		2
@@ -479,32 +457,24 @@ enum {
 	IDETAPE_FL_MEDIUM_PRESENT	= (1 << 8),
 };
 
-/*
- *	Some defines for the READ BUFFER command
- */
+/* define for the READ BUFFER command */
 #define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
 
-/*
- *	Some defines for the SPACE command
- */
+/* defines for the SPACE command */
 #define IDETAPE_SPACE_OVER_FILEMARK	1
 #define IDETAPE_SPACE_TO_EOD		3
 
-/*
- *	Some defines for the LOAD UNLOAD command
- */
+/* defines for the LOAD UNLOAD command */
 #define IDETAPE_LU_LOAD_MASK		1
 #define IDETAPE_LU_RETENSION_MASK	2
 #define IDETAPE_LU_EOT_MASK		4
 
 /*
- *	Special requests for our block device strategy routine.
+ * Special requests for our block device strategy routine.
  *
- *	In order to service a character device command, we add special
- *	requests to the tail of our block device request queue and wait
- *	for their completion.
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
  */
-
 enum {
 	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
 	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
@@ -513,19 +483,16 @@ enum {
 	REQ_IDETAPE_READ_BUFFER	= (1 << 4),
 };
 
-/*
- *	Error codes which are returned in rq->errors to the higher part
- *	of the driver.
- */
+/* Error codes returned in rq->errors to the higher part of the driver. */
 #define	IDETAPE_ERROR_GENERAL		101
 #define	IDETAPE_ERROR_FILEMARK		102
 #define	IDETAPE_ERROR_EOD		103
 
 /*
- *	The following is used to format the general configuration word of
- *	the ATAPI IDENTIFY DEVICE command.
+ * Used to format the general configuration word of the ATAPI IDENTIFY DEVICE
+ * command.
  */
-struct idetape_id_gcw {	
+struct idetape_id_gcw {
 	unsigned packet_size		:2;	/* Packet Size */
 	unsigned reserved234		:3;	/* Reserved */
 	unsigned drq_type		:2;	/* Command packet DRQ type */
@@ -540,10 +507,10 @@ struct idetape_id_gcw {
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
 
 /*
- *	The variables below are used for the character device interface.
- *	Additional state variables are defined in our ide_drive_t structure.
+ * The variables below are used for the character device interface. Additional
+ * state variables are defined in our ide_drive_t structure.
  */
-static struct ide_tape_obj * idetape_devs[MAX_HWIFS * MAX_DRIVES];
+static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
 #define ide_tape_f(file) ((file)->private_data)
 
@@ -559,37 +526,36 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-/*
- *      Function declarations
- *
- */
-static int idetape_chrdev_release (struct inode *inode, struct file *filp);
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor);
+static int idetape_chrdev_release(struct inode *inode, struct file *filp);
+static void idetape_write_release(ide_drive_t *drive, unsigned int minor);
 
 /*
  * Too bad. The drive wants to send us data which we are not ready to accept.
  * Just throw it away.
  */
-static void idetape_discard_data (ide_drive_t *drive, unsigned int bcount)
+static void idetape_discard_data(ide_drive_t *drive, unsigned int bcount)
 {
 	while (bcount--)
 		(void) HWIF(drive)->INB(IDE_DATA_REG);
 }
 
-static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+		uint bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_input_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			idetape_discard_data(drive, bcount);
 			return;
 		}
-		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), bcount);
-		HWIF(drive)->atapi_input_bytes(drive, bh->b_data + atomic_read(&bh->b_count), count);
+		count = min((uint)(bh->b_size - atomic_read(&bh->b_count)),
+				bcount);
+		HWIF(drive)->atapi_input_bytes(drive,
+				bh->b_data + atomic_read(&bh->b_count), count);
 		bcount -= count;
 		atomic_add(count, &bh->b_count);
 		if (atomic_read(&bh->b_count) == bh->b_size) {
@@ -601,24 +567,26 @@ static void idetape_input_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigne
 	pc->bh = bh;
 }
 
-static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsigned int bcount)
+static void idetape_output_buffers(ide_drive_t *drive, idetape_pc_t *pc,
+		uint bcount)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
 
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_output_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return;
 		}
-		count = min((unsigned int)pc->b_count, (unsigned int)bcount);
+		count = min((uint)pc->b_count, (uint)bcount);
 		HWIF(drive)->atapi_output_bytes(drive, pc->b_data, count);
 		bcount -= count;
 		pc->b_data += count;
 		pc->b_count -= count;
 		if (!pc->b_count) {
-			pc->bh = bh = bh->b_reqnext;
+			bh	 = bh->b_reqnext;
+			pc->bh	 = bh->b_reqnext;
 			if (bh) {
 				pc->b_data = bh->b_data;
 				pc->b_count = atomic_read(&bh->b_count);
@@ -627,7 +595,7 @@ static void idetape_output_buffers (ide_drive_t *drive, idetape_pc_t *pc, unsign
 	}
 }
 
-static void idetape_update_buffers (idetape_pc_t *pc)
+static void idetape_update_buffers(idetape_pc_t *pc)
 {
 	struct idetape_bh *bh = pc->bh;
 	int count;
@@ -637,11 +605,11 @@ static void idetape_update_buffers (idetape_pc_t *pc)
 		return;
 	while (bcount) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_update_buffers\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return;
 		}
-		count = min((unsigned int)bh->b_size, (unsigned int)bcount);
+		count = min((uint)bh->b_size, (uint)bcount);
 		atomic_set(&bh->b_count, count);
 		if (atomic_read(&bh->b_count) == bh->b_size)
 			bh = bh->b_reqnext;
@@ -658,7 +626,6 @@ static idetape_pc_t *ide_tape_alloc_pc(void)
 	if (!pc)
 		printk(KERN_ERR "ide-tape: %s: memory allocation error.",
 				__func__);
-
 	return pc;
 }
 
@@ -674,14 +641,10 @@ static struct request *ide_tape_alloc_rq(void)
 	if (!rq)
 		printk(KERN_ERR "ide-tape: %s: memory allocation error.",
 				__func__);
-
 	return rq;
 }
 
-/*
- *	idetape_init_pc initializes a packet command.
- */
-static void idetape_init_pc (idetape_pc_t *pc)
+static void idetape_init_pc(idetape_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
 	pc->retries = 0;
@@ -777,17 +740,14 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 	tape->next_stage = stage->next;
 }
 
-/*
- *	idetape_kfree_stage calls kfree to completely free a stage, along with
- *	its related buffers.
- */
-static void __idetape_kfree_stage (idetape_stage_t *stage)
+/* kfree a stage completely, along with its related buffers. */
+static void __idetape_kfree_stage(idetape_stage_t *stage)
 {
 	struct idetape_bh *prev_bh, *bh = stage->bh;
 	int size;
 
-	while (bh != NULL) {
-		if (bh->b_data != NULL) {
+	while (bh) {
+		if (bh->b_data) {
 			size = (int) bh->b_size;
 			while (size > 0) {
 				free_page((unsigned long) bh->b_data);
@@ -802,16 +762,16 @@ static void __idetape_kfree_stage (idetape_stage_t *stage)
 	kfree(stage);
 }
 
-static void idetape_kfree_stage (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_kfree_stage(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	__idetape_kfree_stage(stage);
 }
 
 /*
- *	idetape_remove_stage_head removes tape->first_stage from the pipeline.
- *	The caller should avoid race conditions.
+ * remove tape->first_stage from the pipeline. The caller should avoid race
+ * conditions.
  */
-static void idetape_remove_stage_head (ide_drive_t *drive)
+static void idetape_remove_stage_head(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -833,10 +793,12 @@ static void idetape_remove_stage_head (ide_drive_t *drive)
 	tape->nr_stages--;
 	if (tape->first_stage == NULL) {
 		tape->last_stage = NULL;
-		if (tape->next_stage != NULL)
-			printk(KERN_ERR "ide-tape: bug: tape->next_stage != NULL\n");
+		if (tape->next_stage)
+			printk(KERN_ERR
+				"ide-tape: bug: tape->next_stage != NULL\n");
 		if (tape->nr_stages)
-			printk(KERN_ERR "ide-tape: bug: nr_stages should be 0 now\n");
+			printk(KERN_ERR
+				"ide-tape: bug: nr_stages should be 0 now\n");
 	}
 }
 
@@ -867,8 +829,8 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
 }
 
 /*
- *	idetape_end_request is used to finish servicing a request, and to
- *	insert a pending pipeline request into the main device queue.
+ * finish servicing a request and insert a pending pipeline request into
+ * the main device queue.
  */
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
@@ -882,10 +844,11 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (uptodate) {
-		case 0:	error = IDETAPE_ERROR_GENERAL; break;
-		case 1: error = 0; break;
-		default: error = uptodate;
+	case 0:	error = IDETAPE_ERROR_GENERAL; break;
+	case 1: error = 0; break;
+	default: error = uptodate;
 	}
+
 	rq->errors = error;
 	if (error)
 		tape->failed_pc = NULL;
@@ -908,7 +871,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 			if (error) {
 				tape->flags |= IDETAPE_FL_PIPELINE_ERR;
 				if (error == IDETAPE_ERROR_EOD)
-					idetape_abort_pipeline(drive, active_stage);
+					idetape_abort_pipeline(drive,
+							active_stage);
 			}
 		} else if (rq->cmd[0] & REQ_IDETAPE_READ) {
 			if (error == IDETAPE_ERROR_EOD) {
@@ -916,12 +880,10 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 				idetape_abort_pipeline(drive, active_stage);
 			}
 		}
-		if (tape->next_stage != NULL) {
+		if (tape->next_stage) {
 			idetape_activate_next_stage(drive);
 
-			/*
-			 * Insert the next request into the request queue.
-			 */
+			/* Insert the next request into the request queue. */
 			(void) ide_do_drive_cmd(drive, tape->act_data_rq,
 					ide_end);
 		} else if (!error) {
@@ -955,7 +917,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 	return 0;
 }
 
-static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_request_sense_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -965,15 +927,16 @@ static ide_startstop_t idetape_request_sense_callback (ide_drive_t *drive)
 		idetape_analyze_error(drive, tape->pc->buffer);
 		idetape_end_request(drive, 1, 0);
 	} else {
-		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself - Aborting request!\n");
+		printk(KERN_ERR "ide-tape: Error in REQUEST SENSE itself"
+				" - Aborting request!\n");
 		idetape_end_request(drive, 0, 0);
 	}
 	return ide_stopped;
 }
 
-static void idetape_create_request_sense_cmd (idetape_pc_t *pc)
+static void idetape_create_request_sense_cmd(idetape_pc_t *pc)
 {
-	idetape_init_pc(pc);	
+	idetape_init_pc(pc);
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = 20;
 	pc->rq_xfer = 20;
@@ -988,21 +951,21 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
 }
 
 /*
- *	idetape_queue_pc_head generates a new packet command request in front
- *	of the request queue, before the current request, so that it will be
- *	processed immediately, on the next pass through the driver.
+ * generate a new packet command request in front of the request queue, before
+ * the current request, so that it will be processed immediately, on the next
+ * pass through the driver.
  *
- *	idetape_queue_pc_head is called from the request handling part of
- *	the driver (the "bottom" part). Safe storage for the request should
- *	be allocated with ide_tape_alloc_pc and ide_tape_alloc_rq
- *	before calling idetape_queue_pc_head.
+ * idetape_queue_pc_head() is called from the request handling part of the
+ * driver (the "bottom" part). Safe storage for the request should be allocated
+ * with ide_tape_alloc_pc and ide_tape_alloc_rq before calling the function
+ * below.
  *
- *	The higher level of the driver - The ioctl handler and the character
- *	device handling functions should queue request to the lower level part
- *	and wait for their completion using idetape_queue_pc_tail or
- *	idetape_queue_rw_tail.
+ * The higher level of the driver - The ioctl handler and the character device
+ * handling functions should queue request to the lower level part and wait for
+ * their completion using idetape_queue_pc_tail() or idetape_queue_rw_tail().
  */
-static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct request *rq)
+static void idetape_queue_pc_head(ide_drive_t *drive, idetape_pc_t *pc,
+		struct request *rq)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 
@@ -1041,11 +1004,10 @@ static ide_startstop_t idetape_retry_pc(ide_drive_t *drive)
 }
 
 /*
- *	idetape_postpone_request postpones the current request so that
- *	ide.c will be able to service requests from another device on
- *	the same hwgroup while we are polling for DSC.
+ * postpone the current request so that	ide.c will be able to service requests
+ * from another device on the same hwgroup while we are polling for DSC.
  */
-static void idetape_postpone_request (ide_drive_t *drive)
+static void idetape_postpone_request(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -1074,7 +1036,7 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	idetape_io_buf *iobuf;
 	unsigned int temp;
 #if SIMULATE_ERRORS
-	static int error_sim_count = 0;
+	static int error_sim_count;
 #endif
 	u16 bcount;
 	u8 stat, ireason;
@@ -1235,46 +1197,39 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 }
 
 /*
- *	Packet Command Interface
- *
- *	The current Packet Command is available in tape->pc, and will not
- *	change until we finish handling it. Each packet command is associated
- *	with a callback function that will be called when the command is
- *	finished.
+ * Packet Command Interface
  *
- *	The handling will be done in three stages:
+ * The current Packet Command is available in tape->pc, and will not change
+ * until we finish handling it. Each packet command is associated with a
+ * callback function that will be called when the command is finished.
  *
- *	1.	idetape_issue_pc will send the packet command to the
- *		drive, and will set the interrupt handler to idetape_pc_intr.
+ * The handling will be done in three stages:
  *
- *	2.	On each interrupt, idetape_pc_intr will be called. This step
- *		will be repeated until the device signals us that no more
- *		interrupts will be issued.
+ * 1. idetape_issue_pc() will send the packet command to the drive, and will set
+ * the interrupt handler to idetape_pc_intr().
  *
- *	3.	ATAPI Tape media access commands have immediate status with a
- *		delayed process. In case of a successful initiation of a
- *		media access packet command, the DSC bit will be set when the
- *		actual execution of the command is finished. 
- *		Since the tape drive will not issue an interrupt, we have to
- *		poll for this event. In this case, we define the request as
- *		"low priority request" by setting rq_status to
- *		IDETAPE_RQ_POSTPONED, 	set a timer to poll for DSC and exit
- *		the driver.
+ * 2. On each interrupt, idetape_pc_intr() will be called. This step will be
+ * repeated until the device signals us that no more interrupts will be issued.
  *
- *		ide.c will then give higher priority to requests which
- *		originate from the other device, until will change rq_status
- *		to RQ_ACTIVE.
+ * 3. ATAPI Tape media access commands have immediate status with a delayed
+ * process. In case of a successful initiation of a media access packet command,
+ * the DSC bit will be set when the actual execution of the command is finished.
+ * Since the tape drive will not issue an interrupt, we have to	poll for this
+ * event. In this case, we define the request as "low priority request" by
+ * setting rq_status to	IDETAPE_RQ_POSTPONED, set a timer to poll for DSC and
+ * exit the driver.
+ * ide.c will then give higher priority to requests which originate from the
+ * other device, until we change rq_status to RQ_ACTIVE.
  *
- *	4.	When the packet command is finished, it will be checked for errors.
+ * 4.When the packet command is finished, it will be checked for errors.
  *
- *	5.	In case an error was found, we queue a request sense packet
- *		command in front of the request queue and retry the operation
- *		up to IDETAPE_MAX_PC_RETRIES times.
- *
- *	6.	In case no error was found, or we decided to give up and not
- *		to retry again, the callback function will be called and then
- *		we will handle the next request.
+ * 5. In case an error was found, we queue a request sense packet command in
+ * front of the request queue and retry the operation up to
+ * IDETAPE_MAX_PC_RETRIES times.
  *
+ * 6. In case no error was found, or we decided to give up and not to retry
+ * again, the callback function will be called and then	we will handle the next
+ * request.
  */
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
@@ -1285,8 +1240,9 @@ static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 	ide_startstop_t startstop;
 	u8 ireason;
 
-	if (ide_wait_stat(&startstop,drive,DRQ_STAT,BUSY_STAT,WAIT_READY)) {
-		printk(KERN_ERR "ide-tape: Strange, packet command initiated yet DRQ isn't asserted\n");
+	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
+		printk(KERN_ERR "ide-tape: Strange, packet command initiated"
+				" yet DRQ isn't asserted\n");
 		return startstop;
 	}
 	ireason = hwif->INB(IDE_IREASON_REG);
@@ -1329,7 +1285,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	if (tape->pc->c[0] == REQUEST_SENSE &&
 	    pc->c[0] == REQUEST_SENSE) {
 		printk(KERN_ERR "ide-tape: possible ide-tape.c bug - "
-			"Two request sense in serial were issued\n");
+			"two request sense in serial were issued\n");
 	}
 
 	if (tape->failed_pc == NULL && pc->c[0] != REQUEST_SENSE)
@@ -1384,7 +1340,8 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	if (dma_ok)			/* Will begin DMA later */
 		pc->flags |= PC_FL_DMA_IN_PROGRESS;
 	if (tape->flags & IDETAPE_FL_DRQ_INTERRUPT) {
-		ide_set_handler(drive, &idetape_transfer_pc, IDETAPE_WAIT_CMD, NULL);
+		ide_set_handler(drive, &idetape_transfer_pc, IDETAPE_WAIT_CMD,
+				NULL);
 		hwif->OUTB(WIN_PACKETCMD, IDE_COMMAND_REG);
 		return ide_started;
 	} else {
@@ -1393,10 +1350,8 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	}
 }
 
-/*
- *	General packet command callback function.
- */
-static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
+/* General packet command callback function. */
+static ide_startstop_t idetape_pc_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -1406,25 +1361,25 @@ static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-/*
- *	A mode sense command is used to "sense" tape parameters.
- */
-static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
+/* A mode sense command is used to "sense" tape parameters. */
+static void idetape_create_mode_sense_cmd(idetape_pc_t *pc, u8 page_code)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = MODE_SENSE;
 	if (page_code != IDETAPE_BLOCK_DESCRIPTOR)
-		pc->c[1] = 8;	/* DBD = 1 - Don't return block descriptors */
+		/* DBD = 1 - Don't return block descriptors */
+		pc->c[1] = 8;
 	pc->c[2] = page_code;
 	/*
 	 * Changed pc->c[3] to 0 (255 will at best return unused info).
 	 *
-	 * For SCSI this byte is defined as subpage instead of high byte
-	 * of length and some IDE drives seem to interpret it this way
-	 * and return an error when 255 is used.
+	 * For SCSI this byte is defined as subpage instead of high byte of
+	 * length and some IDE drives seem to interpret it this way and return
+	 * an error when 255 is used.
 	 */
 	pc->c[3] = 0;
-	pc->c[4] = 255;		/* (We will just discard data in that case) */
+	/* We will just discard data in that case */
+	pc->c[4] = 255;
 	if (page_code == IDETAPE_BLOCK_DESCRIPTOR)
 		pc->rq_xfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
@@ -1453,7 +1408,7 @@ static void idetape_calculate_speeds(ide_drive_t *drive)
 			(tape->pipeline_head - tape->ctl_prev_pipe_h) * 32 *
 			HZ / (jiffies - tape->ctl_prev_htime);
 
-	if (tape->nr_pending_stages < tape->max_stages /*- 1 */) {
+	if (tape->nr_pending_stages < tape->max_stages/*- 1 */) {
 		/* -1 for read mode error recovery */
 		if (time_after(jiffies, tape->unctl_prev_htime + 10 * HZ)) {
 			tape->unctl_pipe_htime = jiffies;
@@ -1487,7 +1442,7 @@ static void idetape_calculate_speeds(ide_drive_t *drive)
 	tape->max_ins_speed = max(tape->max_ins_speed, 500);
 }
 
-static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
+static ide_startstop_t idetape_media_access_finished(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t *pc = tape->pc;
@@ -1513,7 +1468,7 @@ static ide_startstop_t idetape_media_access_finished (ide_drive_t *drive)
 	return pc->callback(drive);
 }
 
-static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
+static ide_startstop_t idetape_rw_callback(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -1549,23 +1504,25 @@ static ide_startstop_t idetape_rw_callback (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		uint len, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_6;
-	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
+	put_unaligned(cpu_to_be32(len), (uint *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
 	pc->bh = bh;
 	atomic_set(&bh->b_count, 0);
 	pc->buffer = NULL;
-	pc->buf_size = length * tape->blk_sz;
+	pc->buf_size = len * tape->blk_sz;
 	pc->rq_xfer = pc->buf_size;
-	if (pc->rq_xfer == tape->stage_size)
+	if (pc->rq_xfer == tape->stage_sz)
 		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
-static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_read_buffer_cmd(idetape_tape_t *tape,
+		idetape_pc_t *pc, struct idetape_bh *bh)
 {
 	int size = 32768;
 	struct idetape_bh *p = bh;
@@ -1583,14 +1540,16 @@ static void idetape_create_read_buffer_cmd(idetape_tape_t *tape, idetape_pc_t *p
 		atomic_set(&p->b_count, 0);
 		p = p->b_reqnext;
 	}
-	pc->rq_xfer = pc->buf_size = size;
+	pc->rq_xfer  = size;
+	pc->buf_size = size;
 }
 
-static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsigned int length, struct idetape_bh *bh)
+static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc,
+		uint len, struct idetape_bh *bh)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_6;
-	put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
+	put_unaligned(cpu_to_be32(len), (uint *) &pc->c[1]);
 	pc->c[1] = 1;
 	pc->callback = &idetape_rw_callback;
 	pc->flags |= PC_FL_WRITING;
@@ -1598,14 +1557,13 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 	pc->b_data = bh->b_data;
 	pc->b_count = atomic_read(&bh->b_count);
 	pc->buffer = NULL;
-	pc->rq_xfer = pc->buf_size = length * tape->blk_sz;
-	if (pc->rq_xfer == tape->stage_size)
+	pc->rq_xfer  = len * tape->blk_sz;
+	pc->buf_size = len * tape->blk_sz;
+	if (pc->rq_xfer == tape->stage_sz)
 		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
-/*
- * idetape_do_request is our request handling function.	
- */
+/* our request handler */
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
@@ -1619,23 +1577,18 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
 
 	if (!blk_special_request(rq)) {
-		/*
-		 * We do not support buffer cache originated requests.
-		 */
+		/* We do not support buffer cache originated requests. */
 		printk(KERN_NOTICE "ide-tape: %s: Unsupported request in "
 			"request queue (%d)\n", drive->name, rq->cmd_type);
 		ide_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 
-	/*
-	 *	Retry a failed packet command
-	 */
-	if (tape->failed_pc != NULL &&
-	    tape->pc->c[0] == REQUEST_SENSE) {
+	/* Retry a failed packet command */
+	if (tape->failed_pc && tape->pc->c[0] == REQUEST_SENSE)
 		return idetape_issue_pc(drive, tape->failed_pc);
-	}
-	if (postponed_rq != NULL)
+
+	if (postponed_rq)
 		if (rq != postponed_rq) {
 			printk(KERN_ERR "ide-tape: ide-tape.c bug - "
 					"Two DSC requests were queued\n");
@@ -1678,7 +1631,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			} else {
 				return ide_do_reset(drive);
 			}
-		} else if (time_after(jiffies, tape->dsc_polling_start + IDETAPE_DSC_MA_THRESHOLD))
+		} else if (time_after(jiffies, tape->dsc_polling_start +
+					IDETAPE_DSC_MA_THRESHOLD))
 			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
@@ -1711,7 +1665,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 		if (!pc)
 			goto err;
 
-		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors,
+		idetape_create_read_buffer_cmd(tape, pc,
 				(struct idetape_bh *)rq->special);
 		goto out;
 	}
@@ -1735,10 +1689,8 @@ err:
 	return ide_stopped;
 }
 
-/*
- *	Pipeline related functions
- */
-static inline int idetape_pipeline_active (idetape_tape_t *tape)
+/* Pipeline related functions */
+static inline int idetape_pipeline_active(idetape_tape_t *tape)
 {
 	int rc1, rc2;
 
@@ -1748,25 +1700,26 @@ static inline int idetape_pipeline_active (idetape_tape_t *tape)
 }
 
 /*
- *	idetape_kmalloc_stage uses __get_free_page to allocate a pipeline
- *	stage, along with all the necessary small buffers which together make
- *	a buffer of size tape->stage_size (or a bit more). We attempt to
- *	combine sequential pages as much as possible.
+ * use __get_free_page() to allocate a pipeline	stage, along with all the
+ * necessary small buffers which together make a buffer of size tape->stage_sz
+ * (or a bit more). We attempt to combine sequential pages as much as possible.
  *
- *	Returns a pointer to the new allocated stage, or NULL if we
- *	can't (or don't want to) allocate a stage.
+ * we return a pointer to the new allocated stage, or NULL if we can't (or don't
+ * want to) allocate a stage.
  *
- *	Pipeline stages are optional and are used to increase performance.
- *	If we can't allocate them, we'll manage without them.
+ * pipeline stages are optional and are used to increase performance. If we
+ * can't allocate them, we'll manage without them.
  */
-static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full, int clear)
+static idetape_stage_t *__idetape_kmalloc_stage(idetape_tape_t *tape, int full,
+		int clear)
 {
 	idetape_stage_t *stage;
 	struct idetape_bh *prev_bh, *bh;
 	int pages = tape->pages_per_stage;
 	char *b_data = NULL;
 
-	if ((stage = kmalloc(sizeof (idetape_stage_t),GFP_KERNEL)) == NULL)
+	stage = kmalloc(sizeof(idetape_stage_t), GFP_KERNEL);
+	if (!stage)
 		return NULL;
 	stage->next = NULL;
 
@@ -1774,16 +1727,21 @@ static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full,
 	if (bh == NULL)
 		goto abort;
 	bh->b_reqnext = NULL;
-	if ((bh->b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+
+	bh->b_data = (char *) __get_free_page(GFP_KERNEL);
+	if (!bh->b_data)
 		goto abort;
+
 	if (clear)
 		memset(bh->b_data, 0, PAGE_SIZE);
 	bh->b_size = PAGE_SIZE;
 	atomic_set(&bh->b_count, full ? bh->b_size : 0);
 
 	while (--pages) {
-		if ((b_data = (char *) __get_free_page (GFP_KERNEL)) == NULL)
+		b_data = (char *) __get_free_page(GFP_KERNEL);
+		 if (!b_data)
 			goto abort;
+
 		if (clear)
 			memset(b_data, 0, PAGE_SIZE);
 		if (bh->b_data == b_data + PAGE_SIZE) {
@@ -1800,8 +1758,9 @@ static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full,
 			continue;
 		}
 		prev_bh = bh;
-		if ((bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL)) == NULL) {
-			free_page((unsigned long) b_data);
+		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
+		if (!bh) {
+			free_page((ulong) b_data);
 			goto abort;
 		}
 		bh->b_reqnext = NULL;
@@ -1819,7 +1778,7 @@ abort:
 	return NULL;
 }
 
-static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
+static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
 {
 	idetape_stage_t *cache_stage = tape->cache_stage;
 
@@ -1827,14 +1786,15 @@ static idetape_stage_t *idetape_kmalloc_stage (idetape_tape_t *tape)
 
 	if (tape->nr_stages >= tape->max_stages)
 		return NULL;
-	if (cache_stage != NULL) {
+	if (cache_stage) {
 		tape->cache_stage = NULL;
 		return cache_stage;
 	}
 	return __idetape_kmalloc_stage(tape, 0, 0);
 }
 
-static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *stage, const char __user *buf, int n)
+static int idetape_copy_stage_from_user(idetape_tape_t *tape,
+		idetape_stage_t *stage, const char __user *buf, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1842,13 +1802,16 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_from_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
-		count = min((unsigned int)(bh->b_size - atomic_read(&bh->b_count)), (unsigned int)n);
-		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf, count))
+		count = min((uint)(bh->b_size - atomic_read(&bh->b_count)),
+				(uint)n);
+		if (copy_from_user(bh->b_data + atomic_read(&bh->b_count), buf,
+				count))
 			ret = 1;
+
 		n -= count;
 		atomic_add(count, &bh->b_count);
 		buf += count;
@@ -1862,7 +1825,8 @@ static int idetape_copy_stage_from_user (idetape_tape_t *tape, idetape_stage_t *
 	return ret;
 }
 
-static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, idetape_stage_t *stage, int n)
+static int idetape_copy_stage_to_user(idetape_tape_t *tape, char __user *buf,
+		idetape_stage_t *stage, int n)
 {
 	struct idetape_bh *bh = tape->bh;
 	int count;
@@ -1870,8 +1834,8 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 
 	while (n) {
 		if (bh == NULL) {
-			printk(KERN_ERR "ide-tape: bh == NULL in "
-				"idetape_copy_stage_to_user\n");
+			printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
+					__func__);
 			return 1;
 		}
 		count = min(tape->b_count, n);
@@ -1882,7 +1846,8 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 		tape->b_count -= count;
 		buf += count;
 		if (!tape->b_count) {
-			tape->bh = bh = bh->b_reqnext;
+			tape->bh = bh->b_reqnext;
+			bh	 = bh->b_reqnext;
 			if (bh) {
 				tape->b_data = bh->b_data;
 				tape->b_count = atomic_read(&bh->b_count);
@@ -1892,10 +1857,10 @@ static int idetape_copy_stage_to_user (idetape_tape_t *tape, char __user *buf, i
 	return ret;
 }
 
-static void idetape_init_merge_stage (idetape_tape_t *tape)
+static void idetape_init_merge_stage(idetape_tape_t *tape)
 {
 	struct idetape_bh *bh = tape->merge_stage->bh;
-	
+
 	tape->bh = bh;
 	if (tape->chrdev_dir == idetape_dir_write)
 		atomic_set(&bh->b_count, 0);
@@ -1905,7 +1870,7 @@ static void idetape_init_merge_stage (idetape_tape_t *tape)
 	}
 }
 
-static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage)
+static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
 {
 	struct idetape_bh *tmp;
 
@@ -1915,10 +1880,8 @@ static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage
 	idetape_init_merge_stage(tape);
 }
 
-/*
- *	idetape_add_stage_tail adds a new stage at the end of the pipeline.
- */
-static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
+/* add a new stage at the end of the pipeline. */
+static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -1927,10 +1890,11 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 
 	spin_lock_irqsave(&tape->que_lock, flags);
 	stage->next = NULL;
-	if (tape->last_stage != NULL)
-		tape->last_stage->next=stage;
+	if (tape->last_stage)
+		tape->last_stage->next = stage;
 	else
-		tape->first_stage = tape->next_stage=stage;
+		tape->first_stage = stage;
+		tape->next_stage  = stage;
 	tape->last_stage = stage;
 	if (tape->next_stage == NULL)
 		tape->next_stage = tape->last_stage;
@@ -1940,19 +1904,18 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 }
 
 /*
- *	idetape_wait_for_request installs a completion in a pending request
- *	and sleeps until it is serviced.
- *
- *	The caller should ensure that the request will not be serviced
- *	before we install the completion (usually by disabling interrupts).
+ * install a completion in a pending request and sleep until it is serviced. The
+ * caller should ensure that the request will not be serviced before we install
+ * the completion (usually by disabling interrupts).
  */
-static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
+static void idetape_wait_for_request(ide_drive_t *drive, struct request *rq)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	idetape_tape_t *tape = drive->driver_data;
 
 	if (rq == NULL || !blk_special_request(rq)) {
-		printk (KERN_ERR "ide-tape: bug: Trying to sleep on non-valid request\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to sleep on non-valid"
+				" request\n");
 		return;
 	}
 	rq->end_io_data = &wait;
@@ -2000,14 +1963,11 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 }
 
 /*
- *	idetape_create_write_filemark_cmd will:
- *
- *		1.	Write a filemark if write_filemark=1.
- *		2.	Flush the device buffers without writing a filemark
- *			if write_filemark=0.
- *
+ * Write a filemark if write_filemark=1. Then, flush the device buffers without
+ * writing a filemark if write_filemark=0. *
  */
-static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
+static void idetape_create_write_filemark_cmd(ide_drive_t *drive,
+		idetape_pc_t *pc, int write_filemark)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = WRITE_FILEMARKS;
@@ -2024,26 +1984,25 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
 }
 
 /*
- *	idetape_queue_pc_tail is based on the following functions:
+ * The function below is based on the following functions:
  *
- *	ide_do_drive_cmd from ide.c
- *	cdrom_queue_request and cdrom_queue_packet_command from ide-cd.c
+ * ide_do_drive_cmd() from ide.c
+ * cdrom_queue_request() and cdrom_queue_packet_command() from ide-cd.c
  *
- *	We add a special packet command request to the tail of the request
- *	queue, and wait for it to be serviced.
+ * We add a special packet command request to the tail of the request queue, and
+ * wait for it to be serviced.
  *
- *	This is not to be called from within the request handling part
- *	of the driver ! We allocate here data in the stack, and it is valid
- *	until the request is finished. This is not the case for the bottom
- *	part of the driver, where we are always leaving the functions to wait
- *	for an interrupt or a timer event.
+ * This is not to be called from within the request handling part of the driver!
+ * We allocate here data on the stack, and it is valid until the request is
+ * finished. This is not the case for the bottom part of the driver, where we
+ * are always leaving the functions to wait for an interrupt or a timer event.
  *
- *	From the bottom part of the driver, we should allocate safe memory
- *	using ide_tape_alloc_pc and ide_tape_alloc_rq, and add
- *	the request to the request list without waiting for it to be serviced !
- *	In that case, we usually use idetape_queue_pc_head.
+ * From the bottom part of the driver, we should allocate safe memory using
+ * ide_tape_alloc_pc() and ide_tape_alloc_rq() and add the request to the
+ * request list without waiting for it to be serviced! In that case, we usually
+ * use idetape_queue_pc_head().
  */
-static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
+static int __idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 	struct request rq;
@@ -2054,7 +2013,8 @@ static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
 
-static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc,int cmd)
+static void idetape_create_load_unload_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		int cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = START_STOP;
@@ -2063,15 +2023,13 @@ static void idetape_create_load_unload_cmd (ide_drive_t *drive, idetape_pc_t *pc
 	pc->callback = &idetape_pc_callback;
 }
 
-static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
+/* Wait for the tape to become ready */
+static int idetape_wait_ready(ide_drive_t *drive, ulong timeout)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
 	int load_attempted = 0;
 
-	/*
-	 * Wait for the tape to become ready
-	 */
 	tape->flags |= IDETAPE_FL_MEDIUM_PRESENT;
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
@@ -2079,10 +2037,12 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 		if (!__idetape_queue_pc_tail(drive, &pc))
 			return 0;
 		if ((tape->sense_key == 2 && tape->asc == 4 && tape->ascq == 2)
-		    || (tape->asc == 0x3A)) {	/* no media */
+		    || (tape->asc == 0x3A)) {
+			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
+			idetape_create_load_unload_cmd(drive, &pc,
+					IDETAPE_LU_LOAD_MASK);
 			__idetape_queue_pc_tail(drive, &pc);
 			load_attempted = 1;
 		/* not about to be ready */
@@ -2094,24 +2054,25 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	return -EIO;
 }
 
-static int idetape_queue_pc_tail (ide_drive_t *drive,idetape_pc_t *pc)
+static int idetape_queue_pc_tail(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	return __idetape_queue_pc_tail(drive, pc);
 }
 
-static int idetape_flush_tape_buffers (ide_drive_t *drive)
+static int idetape_flush_tape_buffers(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 	int rc;
 
 	idetape_create_write_filemark_cmd(drive, &pc, 0);
-	if ((rc = idetape_queue_pc_tail(drive, &pc)))
+	rc = idetape_queue_pc_tail(drive, &pc);
+	if (rc)
 		return rc;
 	idetape_wait_ready(drive, 60 * 5 * HZ);
 	return 0;
 }
 
-static void idetape_create_read_position_cmd (idetape_pc_t *pc)
+static void idetape_create_read_position_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = READ_POSITION;
@@ -2119,7 +2080,7 @@ static void idetape_create_read_position_cmd (idetape_pc_t *pc)
 	pc->callback = &idetape_read_position_callback;
 }
 
-static int idetape_read_position (ide_drive_t *drive)
+static int idetape_read_position(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -2134,18 +2095,20 @@ static int idetape_read_position (ide_drive_t *drive)
 	return position;
 }
 
-static void idetape_create_locate_cmd (ide_drive_t *drive, idetape_pc_t *pc, unsigned int block, u8 partition, int skip)
+static void idetape_create_locate_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		uint block, u8 partition, int skip)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = POSITION_TO_ELEMENT;
 	pc->c[1] = 2;
-	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[3]);
+	put_unaligned(cpu_to_be32(block), (uint *) &pc->c[3]);
 	pc->c[8] = partition;
 	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
-static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int prevent)
+static int idetape_create_prevent_cmd(ide_drive_t *drive, idetape_pc_t *pc,
+		int prevent)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2160,7 +2123,7 @@ static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int
 	return 1;
 }
 
-static int __idetape_discard_read_pipeline (ide_drive_t *drive)
+static int __idetape_discard_read_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2173,10 +2136,11 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 	cnt = tape->merge_stage_sz / tape->blk_sz;
 	if (tape->flags & IDETAPE_FL_FILEMARK) {
 		tape->flags &= ~IDETAPE_FL_FILEMARK;
-		++cnt;		/* Filemarks count as 1 sector */
+		/* Filemarks count as 1 sector */
+		++cnt;
 	}
 	tape->merge_stage_sz = 0;
-	if (tape->merge_stage != NULL) {
+	if (tape->merge_stage) {
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
@@ -2195,10 +2159,10 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 		idetape_wait_for_request(drive, tape->act_data_rq);
 	spin_unlock_irqrestore(&tape->que_lock, flags);
 
-	while (tape->first_stage != NULL) {
+	while (tape->first_stage) {
 		struct request *rq_ptr = &tape->first_stage->rq;
 
-		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors; 
+		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
 		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
 			++cnt;
 		idetape_remove_stage_head(drive);
@@ -2209,15 +2173,14 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 }
 
 /*
- *	idetape_position_tape positions the tape to the requested block
- *	using the LOCATE packet command. A READ POSITION command is then
- *	issued to check where we are positioned.
+ * position the tape to the requested block using the LOCATE packet command. A
+ * READ POSITION command is then issued to check where we are positioned.
  *
- *	Like all higher level operations, we queue the commands at the tail
- *	of the request queue and wait for their completion.
- *	
+ * Like all higher level operations, we queue the commands at the tail of the
+ * request queue and wait for their completion.
  */
-static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 partition, int skip)
+static int idetape_position_tape(ide_drive_t *drive, uint block, u8 partition,
+		int skip)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int retval;
@@ -2235,28 +2198,30 @@ static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 par
 	return (idetape_queue_pc_tail(drive, &pc));
 }
 
-static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_position)
+static void idetape_discard_read_pipeline(ide_drive_t *drive, int restore_pos)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int cnt;
 	int seek, position;
 
 	cnt = __idetape_discard_read_pipeline(drive);
-	if (restore_position) {
+	if (restore_pos) {
 		position = idetape_read_position(drive);
 		seek = position > cnt ? position - cnt : 0;
 		if (idetape_position_tape(drive, seek, 0, 0)) {
-			printk(KERN_INFO "ide-tape: %s: position_tape failed in discard_pipeline()\n", tape->name);
+			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
+					" %s\n", tape->name, __func__);
 			return;
 		}
 	}
 }
 
 /*
- * idetape_queue_rw_tail generates a read/write request for the block
- * device interface and wait for it to be serviced.
+ * generate a read/write request for the block device interface and wait for it
+ * to be serviced.
  */
-static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct idetape_bh *bh)
+static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
+		struct idetape_bh *bh)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct request rq;
@@ -2273,7 +2238,8 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	rq.rq_disk = tape->disk;
 	rq.special = (void *)bh;
 	rq.sector = tape->first_frm_pos;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.nr_sectors		= blocks;
+	rq.current_nr_sectors	= blocks;
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 
 	if ((cmd & (REQ_IDETAPE_READ | REQ_IDETAPE_WRITE)) == 0)
@@ -2286,10 +2252,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct
 	return (tape->blk_sz * (blocks-rq.current_nr_sectors));
 }
 
-/*
- *	idetape_ins_ppl_into_queue is used to start servicing the
- *	pipeline stages, starting from tape->next_stage.
- */
+/* start servicing the pipeline stages, starting from tape->next_stage. */
 static void idetape_ins_ppl_into_queue(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -2303,15 +2266,16 @@ static void idetape_ins_ppl_into_queue(ide_drive_t *drive)
 	}
 }
 
-static void idetape_create_inquiry_cmd (idetape_pc_t *pc)
+static void idetape_create_inquiry_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = INQUIRY;
-	pc->c[4] = pc->rq_xfer = 254;
+	pc->c[4]    = 254;
+	pc->rq_xfer = 254;
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
+static void idetape_create_rewind_cmd(ide_drive_t *drive, idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = REZERO_UNIT;
@@ -2319,7 +2283,7 @@ static void idetape_create_rewind_cmd (ide_drive_t *drive, idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_erase_cmd (idetape_pc_t *pc)
+static void idetape_create_erase_cmd(idetape_pc_t *pc)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = ERASE;
@@ -2328,17 +2292,17 @@ static void idetape_create_erase_cmd (idetape_pc_t *pc)
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_create_space_cmd (idetape_pc_t *pc,int count, u8 cmd)
+static void idetape_create_space_cmd(idetape_pc_t *pc, int count, u8 cmd)
 {
 	idetape_init_pc(pc);
 	pc->c[0] = SPACE;
-	put_unaligned(cpu_to_be32(count), (unsigned int *) &pc->c[1]);
+	put_unaligned(cpu_to_be32(count), (uint *) &pc->c[1]);
 	pc->c[1] = cmd;
 	pc->flags |= PC_FL_WAIT_FOR_DSC;
 	pc->callback = &idetape_pc_callback;
 }
 
-static void idetape_wait_first_stage (ide_drive_t *drive)
+static void idetape_wait_first_stage(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2352,17 +2316,16 @@ static void idetape_wait_first_stage (ide_drive_t *drive)
 }
 
 /*
- *	idetape_add_chrdev_write_request tries to add a character device
- *	originated write request to our pipeline. In case we don't succeed,
- *	we revert to non-pipelined operation mode for this request.
+ * Try to add a character device originated write request to our pipeline. This
+ * is done in three steps:
  *
- *	1.	Try to allocate a new pipeline stage.
- *	2.	If we can't, wait for more and more requests to be serviced
- *		and try again each time.
- *	3.	If we still can't allocate a stage, fallback to
- *		non-pipelined operation mode for this request.
+ * 1. Try to allocate a new pipeline stage.
+ * 2. If we can't, wait for more and more requests to be serviced and try again
+ * each time.
+ * 3. If we still can't allocate a stage, fallback to non-pipelined operation
+ * mode for this request.
  */
-static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
+static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *new_stage;
@@ -2371,9 +2334,9 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-     	/*
-     	 *	Attempt to allocate a new stage.
-	 *	Pay special attention to possible race conditions.
+	/*
+	 * Attempt to allocate a new stage. Pay special attention to possible
+	 * race conditions.
 	 */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
 		spin_lock_irqsave(&tape->que_lock, flags);
@@ -2386,17 +2349,19 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			if (idetape_pipeline_active(tape))
 				continue;
 			/*
-			 *	Linux is short on memory. Fallback to
-			 *	non-pipelined operation mode for this request.
+			 * Machine is short on memory. Fallback to non-pipelined
+			 * operation mode for this request.
 			 */
-			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE,
+					blocks, tape->merge_stage->bh);
 		}
 	}
 	rq = &new_stage->rq;
 	idetape_init_rq(rq, REQ_IDETAPE_WRITE);
 	/* Doesn't actually matter - We always assume sequential access */
 	rq->sector = tape->first_frm_pos;
-	rq->nr_sectors = rq->current_nr_sectors = blocks;
+	rq->nr_sectors		= blocks;
+	rq->current_nr_sectors  = blocks;
 
 	idetape_switch_buffers(tape, new_stage);
 	idetape_add_stage_tail(drive, new_stage);
@@ -2404,11 +2369,11 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	idetape_calculate_speeds(drive);
 
 	/*
-	 *	Estimate whether the tape has stopped writing by checking
-	 *	if our write pipeline is currently empty. If we are not
-	 *	writing anymore, wait for the pipeline to be full enough
-	 *	(90%) before starting to service requests, so that we will
-	 *	be able to keep up with the higher speeds of the tape.
+	 * Estimate whether the tape has stopped writing by checking if our
+	 * write pipeline is currently empty. If we are not writing anymore,
+	 * wait for the pipeline to be almost full (90%) before starting to
+	 * service requests, so that we will be able to keep up with the higher
+	 * speeds of the tape.
 	 */
 	if (!idetape_pipeline_active(tape)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
@@ -2430,10 +2395,10 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 }
 
 /*
- *	idetape_wait_for_pipeline will wait until all pending pipeline
- *	requests are serviced. Typically called on device close.
+ * wait until all pending pipeline requests are serviced. Typically called on
+ * device close.
  */
-static void idetape_wait_for_pipeline (ide_drive_t *drive)
+static void idetape_wait_for_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2447,19 +2412,20 @@ static void idetape_wait_for_pipeline (ide_drive_t *drive)
 	}
 }
 
-static void idetape_empty_write_pipeline (ide_drive_t *drive)
+static void idetape_empty_write_pipeline(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
 	struct idetape_bh *bh;
 
 	if (tape->chrdev_dir != idetape_dir_write) {
-		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline, but we are not writing.\n");
+		printk(KERN_ERR "ide-tape: bug: Trying to empty write pipeline,"
+				" but we are not writing.\n");
 		return;
 	}
-	if (tape->merge_stage_sz > tape->stage_size) {
+	if (tape->merge_stage_sz > tape->stage_sz) {
 		printk(KERN_ERR "ide-tape: bug: merge_buffer too big\n");
-		tape->merge_stage_sz = tape->stage_size;
+		tape->merge_stage_sz = tape->stage_sz;
 	}
 	if (tape->merge_stage_sz) {
 		blocks = tape->merge_stage_sz / tape->blk_sz;
@@ -2476,12 +2442,14 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 			bh = tape->bh;
 			while (i) {
 				if (bh == NULL) {
-
-					printk(KERN_INFO "ide-tape: bug, bh NULL\n");
+					printk(KERN_INFO "ide-tape: bug,"
+							" bh NULL\n");
 					break;
 				}
-				min = min(i, (unsigned int)(bh->b_size - atomic_read(&bh->b_count)));
-				memset(bh->b_data + atomic_read(&bh->b_count), 0, min);
+				min = min(i, (uint)(bh->b_size -
+						atomic_read(&bh->b_count)));
+				memset(bh->b_data + atomic_read(&bh->b_count),
+						0, min);
 				atomic_add(min, &bh->b_count);
 				i -= min;
 				bh = bh->b_reqnext;
@@ -2491,7 +2459,7 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 		tape->merge_stage_sz = 0;
 	}
 	idetape_wait_for_pipeline(drive);
-	if (tape->merge_stage != NULL) {
+	if (tape->merge_stage) {
 		__idetape_kfree_stage(tape->merge_stage);
 		tape->merge_stage = NULL;
 	}
@@ -2499,17 +2467,15 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	tape->chrdev_dir = idetape_dir_none;
 
 	/*
-	 *	On the next backup, perform the feedback loop again.
-	 *	(I don't want to keep sense information between backups,
-	 *	 as some systems are constantly on, and the system load
-	 *	 can be totally different on the next backup).
+	 * on the next backup, perform the feedback loop again. (I don't want to
+	 * keep sense information between backups, as some systems are
+	 * constantly on, and the system load can be totally different on the
+	 * next backup).
 	 */
 	tape->max_stages = tape->min_pipeline;
-	if (tape->first_stage != NULL ||
-	    tape->next_stage != NULL ||
-	    tape->last_stage != NULL ||
-	    tape->nr_stages != 0) {
-		printk(KERN_ERR "ide-tape: ide-tape pipeline bug, "
+	if (tape->first_stage || tape->next_stage || tape->last_stage ||
+			tape->nr_stages) {
+		printk(KERN_ERR "ide-tape: ide-tape pipeline bug,"
 			"first_stage %p, next_stage %p, "
 			"last_stage %p, nr_stages %d\n",
 			tape->first_stage, tape->next_stage,
@@ -2517,15 +2483,17 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	}
 }
 
-static void idetape_restart_speed_control (ide_drive_t *drive)
+static void idetape_restart_speed_control(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	tape->rs_speed_ctl_rq = 0;
 	tape->pipeline_head = 0;
 	tape->ctl_last_pipe_h = 0;
-	tape->ctl_prev_pipe_h = tape->unctl_prev_pipe_h = 0;
-	tape->pipe_hspeed = tape->pipe_ctl_hspeed = 5000;
+	tape->ctl_prev_pipe_h   = 0;
+	tape->unctl_prev_pipe_h = 0;
+	tape->pipe_hspeed	= 5000;
+	tape->pipe_ctl_hspeed	= 5000;
 	tape->unctl_pipe_hspeed = 0;
 	tape->ctl_pipe_htime = tape->unctl_pipe_htime = jiffies;
 	tape->ctl_prev_htime = tape->unctl_prev_htime = jiffies;
@@ -2546,22 +2514,25 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 			idetape_flush_tape_buffers(drive);
 		}
 		if (tape->merge_stage || tape->merge_stage_sz) {
-			printk (KERN_ERR "ide-tape: merge_stage_size should be 0 now\n");
+			printk(KERN_ERR "ide-tape: merge_stage_sz should be"
+					" 0 now\n");
 			tape->merge_stage_sz = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
 		tape->chrdev_dir = idetape_dir_read;
 
 		/*
-		 *	Issue a read 0 command to ensure that DSC handshake
-		 *	is switched from completion mode to buffer available
-		 *	mode.
-		 *	No point in issuing this if DSC overlap isn't supported,
-		 *	some drives (Seagate STT3401A) will return an error.
+		 * Issue a read 0 command to ensure that DSC handshake is
+		 * switched from completion mode to buffer available mode.
+		 *
+		 * No point in issuing this if DSC overlap isn't supported, some
+		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
-			bytes_read = idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, 0, tape->merge_stage->bh);
+			bytes_read = idetape_queue_rw_tail(drive,
+				REQ_IDETAPE_READ, 0, tape->merge_stage->bh);
 			if (bytes_read < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
@@ -2574,11 +2545,13 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		idetape_restart_speed_control(drive);
 	idetape_init_rq(&rq, REQ_IDETAPE_READ);
 	rq.sector = tape->first_frm_pos;
-	rq.nr_sectors = rq.current_nr_sectors = blocks;
+	rq.nr_sectors		= blocks;
+	rq.current_nr_sectors	= blocks;
 	if (!(tape->flags & IDETAPE_FL_PIPELINE_ERR) &&
 			tape->nr_stages < max_stages) {
 		new_stage = idetape_kmalloc_stage(tape);
-		while (new_stage != NULL) {
+
+		while (new_stage) {
 			new_stage->rq = rq;
 			idetape_add_stage_tail(drive, new_stage);
 			if (tape->nr_stages >= max_stages)
@@ -2599,11 +2572,10 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 }
 
 /*
- *	idetape_add_chrdev_read_request is called from idetape_chrdev_read
- *	to service a character device read request and add read-ahead
- *	requests to our pipeline.
+ * called from idetape_chrdev_read() to service a chrdev read request and add
+ * read-ahead requests to our pipeline.
  */
-static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
+static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
@@ -2612,27 +2584,24 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 
 	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
 
-	/*
-	 * If we are at a filemark, return a read length of 0
-	 */
+	/* If we are at a filemark, return a read length of 0 */
 	if (tape->flags & IDETAPE_FL_FILEMARK)
 		return 0;
 
-	/*
-	 * Wait for the next block to be available at the head
-	 * of the pipeline
-	 */
+	/* Wait for the next block to be available at the head of the pipeline*/
 	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
 		if (tape->flags & IDETAPE_FL_PIPELINE_ERR)
 			return 0;
-		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks, tape->merge_stage->bh);
+		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
+				tape->merge_stage->bh);
 	}
 	idetape_wait_first_stage(drive);
 	rq_ptr = &tape->first_stage->rq;
 	bytes_read = tape->blk_sz *
 		(rq_ptr->nr_sectors - rq_ptr->current_nr_sectors);
-	rq_ptr->nr_sectors = rq_ptr->current_nr_sectors = 0;
+	rq_ptr->nr_sectors	   = 0;
+	rq_ptr->current_nr_sectors = 0;
 
 
 	if (rq_ptr->errors == IDETAPE_ERROR_EOD)
@@ -2648,36 +2617,38 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 		idetape_calculate_speeds(drive);
 	}
 	if (bytes_read > blocks * tape->blk_sz) {
-		printk(KERN_ERR "ide-tape: bug: trying to return more bytes than requested\n");
+		printk(KERN_ERR "ide-tape: bug: trying to return more bytes"
+				" than requested\n");
 		bytes_read = blocks * tape->blk_sz;
 	}
 	return (bytes_read);
 }
 
-static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
+static void idetape_pad_zeros(ide_drive_t *drive, int bcount)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct idetape_bh *bh;
 	int blocks;
-	
+
 	while (bcount) {
 		unsigned int count;
 
 		bh = tape->merge_stage->bh;
-		count = min(tape->stage_size, bcount);
+		count = min(tape->stage_sz, bcount);
 		bcount -= count;
 		blocks = count / tape->blk_sz;
 		while (count) {
-			atomic_set(&bh->b_count, min(count, (unsigned int)bh->b_size));
+			atomic_set(&bh->b_count, min(count, (uint)bh->b_size));
 			memset(bh->b_data, 0, atomic_read(&bh->b_count));
 			count -= atomic_read(&bh->b_count);
 			bh = bh->b_reqnext;
 		}
-		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
+		idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks,
+				tape->merge_stage->bh);
 	}
 }
 
-static int idetape_pipeline_size (ide_drive_t *drive)
+static int idetape_pipeline_size(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_stage_t *stage;
@@ -2686,7 +2657,7 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 
 	idetape_wait_for_pipeline(drive);
 	stage = tape->first_stage;
-	while (stage != NULL) {
+	while (stage) {
 		rq = &stage->rq;
 		size += tape->blk_sz * (rq->nr_sectors-rq->current_nr_sectors);
 		if (rq->errors == IDETAPE_ERROR_FILEMARK)
@@ -2698,11 +2669,10 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 }
 
 /*
- *	Rewinds the tape to the Beginning Of the current Partition (BOP).
- *
- *	We currently support only one partition.
- */ 
-static int idetape_rewind_tape (ide_drive_t *drive)
+ * rewind the tape to the Beginning Of the current Partition (BOP). We currently
+ * support only one partition.
+ */
+static int idetape_rewind_tape(ide_drive_t *drive)
 {
 	int retval;
 	idetape_pc_t pc;
@@ -2724,13 +2694,12 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 }
 
 /*
- *	Our special ide-tape ioctl's.
+ * Our special ide-tape ioctl's.
  *
- *	Currently there aren't any ioctl's.
- *	mtio.h compatible commands should be issued to the character device
- *	interface.
+ * Currently there aren't any ioctl's, for mtio.h compatible commands should be
+ * issued to the character device interface.
  */
-static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
+static int idetape_blkdev_ioctl(ide_drive_t *drive, uint cmd, ulong arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
@@ -2745,41 +2714,42 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (cmd) {
-		case 0x0340:
-			if (copy_from_user(&config, argp,
-						sizeof(struct idetape_config)))
-				return -EFAULT;
-			tape->best_dsc_rw_freq = config.dsc_rw_frequency;
-			tape->max_stages = config.nr_stages;
-			break;
-		case 0x0350:
-			config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
-			config.nr_stages = tape->max_stages; 
-			if (copy_to_user(argp, &config,
-						sizeof(struct idetape_config)))
-				return -EFAULT;
-			break;
-		default:
-			return -EIO;
+	case 0x0340:
+		if (copy_from_user(&config, argp,
+					sizeof(struct idetape_config)))
+			return -EFAULT;
+		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
+		tape->max_stages = config.nr_stages;
+		break;
+	case 0x0350:
+		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
+		config.nr_stages = tape->max_stages;
+		if (copy_to_user(argp, &config,
+					sizeof(struct idetape_config)))
+			return -EFAULT;
+		break;
+	default:
+		return -EIO;
 	}
 	return 0;
 }
 
 /*
- *	idetape_space_over_filemarks is now a bit more complicated than just
- *	passing the command to the tape since we may have crossed some
- *	filemarks during our pipelined read-ahead mode.
+ * The function below is now a bit more complicated than just passing the
+ * command to the tape since we may have crossed some filemarks during our
+ * pipelined read-ahead mode.
  *
- *	As a minor side effect, the pipeline enables us to support MTFSFM when
- *	the filemark is in our internal pipeline even if the tape doesn't
- *	support spacing over filemarks in the reverse direction.
+ * As a minor side effect, the pipeline enables us to support MTFSFM when the
+ * filemark is in our internal pipeline even if the tape doesn't support spacing
+ * over filemarks in the reverse direction.
  */
-static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_count)
+static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
+		int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
 	unsigned long flags;
-	int retval,count=0;
+	int retval, count = 0;
 	int sprev = !!(tape->caps[4] & 0x20);
 
 	if (mt_count == 0)
@@ -2787,14 +2757,11 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
 		if (!sprev)
 			return -EIO;
-		mt_count = - mt_count;
+		mt_count = -mt_count;
 	}
 
 	if (tape->chrdev_dir == idetape_dir_read) {
-		/*
-		 *	We have a read-ahead buffer. Scan it for crossed
-		 *	filemarks.
-		 */
+		/* Scan the read-ahead buffer for crossed filemarks. */
 		tape->merge_stage_sz = 0;
 		if (tape->flags & IDETAPE_FL_FILEMARK) {
 			tape->flags &= ~IDETAPE_FL_FILEMARK;
@@ -2809,13 +2776,10 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 			spin_lock_irqsave(&tape->que_lock, flags);
 			if (tape->first_stage == tape->active_stage) {
 				/*
-				 *	We have reached the active stage in the read pipeline.
-				 *	There is no point in allowing the drive to continue
-				 *	reading any farther, so we stop the pipeline.
-				 *
-				 *	This section should be moved to a separate subroutine,
-				 *	because a similar function is performed in
-				 *	__idetape_discard_read_pipeline(), for example.
+				 * We have reached the active stage in the read
+				 * pipeline. There is no point in allowing the
+				 * drive to continue reading any farther, so we
+				 * stop the pipeline.
 				 */
 				tape->next_stage = NULL;
 				spin_unlock_irqrestore(&tape->que_lock, flags);
@@ -2823,7 +2787,8 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 				tape->next_stage = tape->first_stage->next;
 			} else
 				spin_unlock_irqrestore(&tape->que_lock, flags);
-			if (tape->first_stage->rq.errors == IDETAPE_ERROR_FILEMARK)
+			if (tape->first_stage->rq.errors ==
+					IDETAPE_ERROR_FILEMARK)
 				++count;
 			idetape_remove_stage_head(drive);
 		}
@@ -2831,52 +2796,53 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	}
 
 	/*
-	 *	The filemark was not found in our internal pipeline.
-	 *	Now we can issue the space command.
+	 * The filemark was not found in our internal pipeline; now we can issue
+	 * the space command.
 	 */
 	switch (mt_op) {
-		case MTFSF:
-		case MTBSF:
-			idetape_create_space_cmd(&pc,mt_count-count,IDETAPE_SPACE_OVER_FILEMARK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTFSFM:
-		case MTBSFM:
-			if (!sprev)
-				return (-EIO);
-			retval = idetape_space_over_filemarks(drive, MTFSF, mt_count-count);
-			if (retval) return (retval);
-			count = (MTBSFM == mt_op ? 1 : -1);
-			return (idetape_space_over_filemarks(drive, MTFSF, count));
-		default:
-			printk(KERN_ERR "ide-tape: MTIO operation %d not supported\n",mt_op);
+	case MTFSF:
+	case MTBSF:
+		idetape_create_space_cmd(&pc, mt_count-count,
+				IDETAPE_SPACE_OVER_FILEMARK);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTFSFM:
+	case MTBSFM:
+		if (!sprev)
 			return (-EIO);
+		retval = idetape_space_over_filemarks(drive, MTFSF,
+				mt_count-count);
+		if (retval)
+			return (retval);
+		count = (MTBSFM == mt_op ? 1 : -1);
+		return (idetape_space_over_filemarks(drive, MTFSF, count));
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not"
+				" supported\n", mt_op);
+		return (-EIO);
 	}
 }
 
-
 /*
- *	Our character device read / write functions.
+ * Our character device read / write functions.
  *
- *	The tape is optimized to maximize throughput when it is transferring
- *	an integral number of the "continuous transfer limit", which is
- *	a parameter of the specific tape (26 KB on my particular tape).
- *      (32 kB for Onstream)
+ * The tape is optimized to maximize throughput when it is transferring	an
+ * integral number of the "continuous transfer limit", which is a parameter of
+ * the specific tape (26 KB on my particular tape/32 kB for Onstream).
  *
- *	As of version 1.3 of the driver, the character device provides an
- *	abstract continuous view of the media - any mix of block sizes (even 1
- *	byte) on the same backup/restore procedure is supported. The driver
- *	will internally convert the requests to the recommended transfer unit,
- *	so that an unmatch between the user's block size to the recommended
- *	size will only result in a (slightly) increased driver overhead, but
- *	will no longer hit performance.
- *      This is not applicable to Onstream.
+ * As of version 1.3 of the driver, the character device provides an abstract
+ * continuous view of the media - any mix of block sizes (even 1 byte) on the
+ * same backup/restore procedure is supported. The driver will internally
+ * convert the requests to the recommended transfer unit, so that an unmatch
+ * between the user's block size to the recommended size will only result in a
+ * (slightly) increased driver overhead, but will no longer hit performance.
+ * This is not applicable to Onstream.
  */
-static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
+static ssize_t idetape_chrdev_read(struct file *file, char __user *buf,
 				    size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
 	ide_drive_t *drive = tape->drive;
-	ssize_t bytes_read,temp, actually_read = 0, rc;
+	ssize_t bytes_read, temp, actually_read = 0, rc;
 	ssize_t ret = 0;
 	u16 ctl = *(u16 *)&tape->caps[12];
 
@@ -2895,17 +2861,19 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		return (0);
 	if (tape->merge_stage_sz) {
 		actually_read = min((uint)(tape->merge_stage_sz), (uint)count);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, actually_read))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					actually_read))
 			ret = -EFAULT;
 		buf += actually_read;
 		tape->merge_stage_sz -= actually_read;
 		count -= actually_read;
 	}
-	while (count >= tape->stage_size) {
+	while (count >= tape->stage_sz) {
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, bytes_read))
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+					bytes_read))
 			ret = -EFAULT;
 		buf += bytes_read;
 		count -= bytes_read;
@@ -2915,8 +2883,9 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
-		temp = min((unsigned long)count, (unsigned long)bytes_read);
-		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, temp))
+		temp = min((ulong)count, (ulong)bytes_read);
+		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage,
+						temp))
 			ret = -EFAULT;
 		actually_read += temp;
 		tape->merge_stage_sz = bytes_read-temp;
@@ -2932,7 +2901,7 @@ finish:
 	return (ret) ? ret : actually_read;
 }
 
-static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
+static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct ide_tape_obj *tape = ide_tape_f(file);
@@ -2956,20 +2925,22 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 				"should be 0 now\n");
 			tape->merge_stage_sz = 0;
 		}
-		if ((tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0)) == NULL)
+		tape->merge_stage = __idetape_kmalloc_stage(tape, 0, 0);
+		if (!tape->merge_stage)
 			return -ENOMEM;
+
 		tape->chrdev_dir = idetape_dir_write;
 		idetape_init_merge_stage(tape);
 
 		/*
-		 *	Issue a write 0 command to ensure that DSC handshake
-		 *	is switched from completion mode to buffer available
-		 *	mode.
-		 *	No point in issuing this if DSC overlap isn't supported,
-		 *	some drives (Seagate STT3401A) will return an error.
+		 * Issue a write 0 command to ensure that DSC handshake is
+		 * switched from completion mode to buffer available mode. No
+		 * point in issuing this if DSC overlap isn't supported, some
+		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
-			ssize_t retval = idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, 0, tape->merge_stage->bh);
+			ssize_t retval = idetape_queue_rw_tail(drive,
+				REQ_IDETAPE_WRITE, 0, tape->merge_stage->bh);
 			if (retval < 0) {
 				__idetape_kfree_stage(tape->merge_stage);
 				tape->merge_stage = NULL;
@@ -2983,19 +2954,20 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	if (tape->rs_speed_ctl_rq)
 		idetape_restart_speed_control(drive);
 	if (tape->merge_stage_sz) {
-		if (tape->merge_stage_sz >= tape->stage_size) {
-			printk(KERN_ERR "ide-tape: bug: merge buffer too big\n");
+		if (tape->merge_stage_sz >= tape->stage_sz) {
+			printk(KERN_ERR "ide-tape: bug: merge buf too big\n");
 			tape->merge_stage_sz = 0;
 		}
-		actually_written = min((uint)(tape->stage_size -
+		actually_written = min((uint)(tape->stage_sz -
 					tape->merge_stage_sz), (uint)count);
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, actually_written))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						actually_written))
 				ret = -EFAULT;
 		buf += actually_written;
 		tape->merge_stage_sz += actually_written;
 		count -= actually_written;
 
-		if (tape->merge_stage_sz == tape->stage_size) {
+		if (tape->merge_stage_sz == tape->stage_sz) {
 			ssize_t retval;
 			tape->merge_stage_sz = 0;
 			retval = idetape_add_chrdev_write_request(drive, ctl);
@@ -3003,27 +2975,29 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 				return (retval);
 		}
 	}
-	while (count >= tape->stage_size) {
+	while (count >= tape->stage_sz) {
 		ssize_t retval;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, tape->stage_size))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						tape->stage_sz))
 			ret = -EFAULT;
-		buf += tape->stage_size;
-		count -= tape->stage_size;
+		buf += tape->stage_sz;
+		count -= tape->stage_sz;
 		retval = idetape_add_chrdev_write_request(drive, ctl);
-		actually_written += tape->stage_size;
+		actually_written += tape->stage_sz;
 		if (retval <= 0)
 			return (retval);
 	}
 	if (count) {
 		actually_written += count;
-		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf, count))
+		if (idetape_copy_stage_from_user(tape, tape->merge_stage, buf,
+						count))
 			ret = -EFAULT;
 		tape->merge_stage_sz += count;
 	}
 	return (ret) ? ret : actually_written;
 }
 
-static int idetape_write_filemark (ide_drive_t *drive)
+static int idetape_write_filemark(ide_drive_t *drive)
 {
 	idetape_pc_t pc;
 
@@ -3054,111 +3028,116 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	int i,retval;
+	int i, retval;
 
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
 			mt_op, mt_count);
-	/*
-	 *	Commands which need our pipelined read-ahead stages.
-	 */
+
+	/* Commands which need our pipelined read-ahead stages.	 */
 	switch (mt_op) {
-		case MTFSF:
-		case MTFSFM:
-		case MTBSF:
-		case MTBSFM:
-			if (!mt_count)
-				return (0);
-			return (idetape_space_over_filemarks(drive,mt_op,mt_count));
-		default:
-			break;
+	case MTFSF:
+	case MTFSFM:
+	case MTBSF:
+	case MTBSFM:
+		if (!mt_count)
+			return (0);
+		return (idetape_space_over_filemarks(drive, mt_op, mt_count));
+	default:
+		break;
 	}
 	switch (mt_op) {
-		case MTWEOF:
-			if (tape->write_prot)
-				return -EACCES;
-			idetape_discard_read_pipeline(drive, 1);
-			for (i = 0; i < mt_count; i++) {
-				retval = idetape_write_filemark(drive);
-				if (retval)
-					return retval;
-			}
-			return (0);
-		case MTREW:
-			idetape_discard_read_pipeline(drive, 0);
-			if (idetape_rewind_tape(drive))
+	case MTWEOF:
+		if (tape->write_prot)
+			return -EACCES;
+		idetape_discard_read_pipeline(drive, 1);
+		for (i = 0; i < mt_count; i++) {
+			retval = idetape_write_filemark(drive);
+			if (retval)
+				return retval;
+		}
+		return (0);
+	case MTREW:
+		idetape_discard_read_pipeline(drive, 0);
+		if (idetape_rewind_tape(drive))
+			return -EIO;
+		return 0;
+	case MTLOAD:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+				IDETAPE_LU_LOAD_MASK);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTUNLOAD:
+	case MTOFFL:
+		/*
+		 * If door is locked, attempt to unlock before
+		 * attempting to eject.
+		 */
+		if (tape->door_locked) {
+			if (idetape_create_prevent_cmd(drive, &pc, 0))
+				if (!idetape_queue_pc_tail(drive, &pc))
+					tape->door_locked = DOOR_UNLOCKED;
+		}
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+				!IDETAPE_LU_LOAD_MASK);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (!retval)
+			tape->flags &= ~IDETAPE_FL_MEDIUM_PRESENT;
+		return retval;
+	case MTNOP:
+		idetape_discard_read_pipeline(drive, 0);
+		return (idetape_flush_tape_buffers(drive));
+	case MTRETEN:
+		idetape_discard_read_pipeline(drive, 0);
+		idetape_create_load_unload_cmd(drive, &pc,
+			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTEOM:
+		idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTERASE:
+		(void) idetape_rewind_tape(drive);
+		idetape_create_erase_cmd(&pc);
+		return (idetape_queue_pc_tail(drive, &pc));
+	case MTSETBLK:
+		if (mt_count) {
+			if (mt_count < tape->blk_sz ||
+					mt_count % tape->blk_sz)
 				return -EIO;
+			tape->user_bs_factor = mt_count / tape->blk_sz;
+			tape->flags &= ~IDETAPE_FL_DETECT_BS;
+		} else
+			tape->flags |= IDETAPE_FL_DETECT_BS;
+		return 0;
+	case MTSEEK:
+		idetape_discard_read_pipeline(drive, 0);
+		return idetape_position_tape(drive,
+			mt_count * tape->user_bs_factor, tape->partition, 0);
+	case MTSETPART:
+		idetape_discard_read_pipeline(drive, 0);
+		return (idetape_position_tape(drive, 0, mt_count, 0));
+	case MTFSR:
+	case MTBSR:
+	case MTLOCK:
+		if (!idetape_create_prevent_cmd(drive, &pc, 1))
 			return 0;
-		case MTLOAD:
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTUNLOAD:
-		case MTOFFL:
-			/*
-			 * If door is locked, attempt to unlock before
-			 * attempting to eject.
-			 */
-			if (tape->door_locked) {
-				if (idetape_create_prevent_cmd(drive, &pc, 0))
-					if (!idetape_queue_pc_tail(drive, &pc))
-						tape->door_locked = DOOR_UNLOCKED;
-			}
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc,!IDETAPE_LU_LOAD_MASK);
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (!retval)
-				tape->flags &= ~IDETAPE_FL_MEDIUM_PRESENT;
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (retval)
 			return retval;
-		case MTNOP:
-			idetape_discard_read_pipeline(drive, 0);
-			return (idetape_flush_tape_buffers(drive));
-		case MTRETEN:
-			idetape_discard_read_pipeline(drive, 0);
-			idetape_create_load_unload_cmd(drive, &pc,IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTEOM:
-			idetape_create_space_cmd(&pc, 0, IDETAPE_SPACE_TO_EOD);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTERASE:
-			(void) idetape_rewind_tape(drive);
-			idetape_create_erase_cmd(&pc);
-			return (idetape_queue_pc_tail(drive, &pc));
-		case MTSETBLK:
-			if (mt_count) {
-				if (mt_count < tape->blk_sz ||
-						mt_count % tape->blk_sz)
-					return -EIO;
-				tape->user_bs_factor = mt_count / tape->blk_sz;
-				tape->flags &= ~IDETAPE_FL_DETECT_BS;
-			} else
-				tape->flags |= IDETAPE_FL_DETECT_BS;
-			return 0;
-		case MTSEEK:
-			idetape_discard_read_pipeline(drive, 0);
-			return idetape_position_tape(drive, mt_count * tape->user_bs_factor, tape->partition, 0);
-		case MTSETPART:
-			idetape_discard_read_pipeline(drive, 0);
-			return (idetape_position_tape(drive, 0, mt_count, 0));
-		case MTFSR:
-		case MTBSR:
-		case MTLOCK:
-			if (!idetape_create_prevent_cmd(drive, &pc, 1))
-				return 0;
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (retval) return retval;
-			tape->door_locked = DOOR_EXPLICITLY_LOCKED;
-			return 0;
-		case MTUNLOCK:
-			if (!idetape_create_prevent_cmd(drive, &pc, 0))
-				return 0;
-			retval = idetape_queue_pc_tail(drive, &pc);
-			if (retval) return retval;
-			tape->door_locked = DOOR_UNLOCKED;
+		tape->door_locked = DOOR_EXPLICITLY_LOCKED;
+		return 0;
+	case MTUNLOCK:
+		if (!idetape_create_prevent_cmd(drive, &pc, 0))
 			return 0;
-		default:
-			printk(KERN_ERR "ide-tape: MTIO operation %d not "
-				"supported\n", mt_op);
-			return (-EIO);
+		retval = idetape_queue_pc_tail(drive, &pc);
+		if (retval)
+			return retval;
+		tape->door_locked = DOOR_UNLOCKED;
+		return 0;
+	default:
+		printk(KERN_ERR "ide-tape: MTIO operation %d not "
+			"supported\n", mt_op);
+		return (-EIO);
 	}
 }
 
@@ -3188,36 +3167,40 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
 		block_offset = idetape_pipeline_size(drive) /
 			(tape->blk_sz * tape->user_bs_factor);
-		if ((position = idetape_read_position(drive)) < 0)
+		position = idetape_read_position(drive);
+		if (position < 0)
 			return -EIO;
 	}
 	switch (cmd) {
-		case MTIOCTOP:
-			if (copy_from_user(&mtop, argp, sizeof (struct mtop)))
-				return -EFAULT;
-			return (idetape_mtioctop(drive,mtop.mt_op,mtop.mt_count));
-		case MTIOCGET:
-			memset(&mtget, 0, sizeof (struct mtget));
-			mtget.mt_type = MT_ISSCSI2;
-			mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
-			mtget.mt_dsreg = ((tape->blk_sz * tape->user_bs_factor)
-					<< MT_ST_BLKSIZE_SHIFT)
-				& MT_ST_BLKSIZE_MASK;
-			if (tape->drv_write_prot) {
-				mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
-			}
-			if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
-				return -EFAULT;
-			return 0;
-		case MTIOCPOS:
-			mtpos.mt_blkno = position / tape->user_bs_factor - block_offset;
-			if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
-				return -EFAULT;
-			return 0;
-		default:
-			if (tape->chrdev_dir == idetape_dir_read)
-				idetape_discard_read_pipeline(drive, 1);
-			return idetape_blkdev_ioctl(drive, cmd, arg);
+	case MTIOCTOP:
+		if (copy_from_user(&mtop, argp, sizeof(struct mtop)))
+			return -EFAULT;
+		return (idetape_mtioctop(drive, mtop.mt_op,
+					mtop.mt_count));
+	case MTIOCGET:
+		memset(&mtget, 0, sizeof(struct mtget));
+		mtget.mt_type = MT_ISSCSI2;
+		mtget.mt_blkno = position /
+			tape->user_bs_factor - block_offset;
+		mtget.mt_dsreg = ((tape->blk_sz * tape->user_bs_factor)
+				<< MT_ST_BLKSIZE_SHIFT)
+			& MT_ST_BLKSIZE_MASK;
+		if (tape->drv_write_prot)
+			mtget.mt_gstat |= GMT_WR_PROT(0xffffffff);
+
+		if (copy_to_user(argp, &mtget, sizeof(struct mtget)))
+			return -EFAULT;
+		return 0;
+	case MTIOCPOS:
+		mtpos.mt_blkno = position /
+			tape->user_bs_factor - block_offset;
+		if (copy_to_user(argp, &mtpos, sizeof(struct mtpos)))
+			return -EFAULT;
+		return 0;
+	default:
+		if (tape->chrdev_dir == idetape_dir_read)
+			idetape_discard_read_pipeline(drive, 1);
+		return idetape_blkdev_ioctl(drive, cmd, arg);
 	}
 }
 
@@ -3241,17 +3224,14 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 		}
 		return;
 	}
-	tape->blk_sz = (pc.buffer[4 + 5] << 16) +
-				(pc.buffer[4 + 6] << 8)  +
-				pc.buffer[4 + 7];
+	tape->blk_sz =  (pc.buffer[4 + 5] << 16) +
+			(pc.buffer[4 + 6] << 8)  +
+			 pc.buffer[4 + 7];
 
 	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
 }
 
-/*
- *	Our character device open function.
- */
-static int idetape_chrdev_open (struct inode *inode, struct file *filp)
+static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 {
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
@@ -3271,7 +3251,8 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 	if (i >= MAX_HWIFS * MAX_DRIVES)
 		return -ENXIO;
 
-	if (!(tape = ide_tape_chrdev_get(i)))
+	tape = ide_tape_chrdev_get(i);
+	if (!tape)
 		return -ENXIO;
 
 	drive = tape->drive;
@@ -3318,9 +3299,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 		}
 	}
 
-	/*
-	 * Lock the tape drive door so user can't eject.
-	 */
+	/* Lock the tape drive door so user can't eject. */
 	if (tape->chrdev_dir == idetape_dir_none) {
 		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
 			if (!idetape_queue_pc_tail(drive, &pc)) {
@@ -3338,13 +3317,13 @@ out_put_tape:
 	return retval;
 }
 
-static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
+static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 	idetape_empty_write_pipeline(drive);
 	tape->merge_stage = __idetape_kmalloc_stage(tape, 1, 0);
-	if (tape->merge_stage != NULL) {
+	if (tape->merge_stage) {
 		idetape_pad_zeros(drive, tape->blk_sz *
 				(tape->user_bs_factor - 1));
 		__idetape_kfree_stage(tape->merge_stage);
@@ -3355,10 +3334,7 @@ static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
 	idetape_flush_tape_buffers(drive);
 }
 
-/*
- *	Our character device release function.
- */
-static int idetape_chrdev_release (struct inode *inode, struct file *filp)
+static int idetape_chrdev_release(struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
@@ -3378,7 +3354,7 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 		else
 			idetape_wait_for_pipeline(drive);
 	}
-	if (tape->cache_stage != NULL) {
+	if (tape->cache_stage) {
 		__idetape_kfree_stage(tape->cache_stage);
 		tape->cache_stage = NULL;
 	}
@@ -3399,15 +3375,13 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 }
 
 /*
- *	idetape_identify_device is called to check the contents of the
- *	ATAPI IDENTIFY command results. We return:
+ * called to check the contents of the ATAPI IDENTIFY command results.
+ * We return:
  *
- *	1	If the tape can be supported by us, based on the information
- *		we have so far.
- *
- *	0 	If this tape driver is not currently supported by us.
+ * 1. If the tape is supported by us based on the information we have so far.
+ * 0. If this tape driver is not currently supported by us.
  */
-static int idetape_identify_device (ide_drive_t *drive)
+static int idetape_identify_device(ide_drive_t *drive)
 {
 	struct idetape_id_gcw gcw;
 	struct hd_driveid *id = drive->id;
@@ -3417,18 +3391,20 @@ static int idetape_identify_device (ide_drive_t *drive)
 
 	*((unsigned short *) &gcw) = id->config;
 
-	/* Check that we can support this device */
-
-	if (gcw.protocol !=2 )
-		printk(KERN_ERR "ide-tape: Protocol is not ATAPI\n");
+	if (gcw.protocol != 2)
+		printk(KERN_ERR "ide-tape: Protocol %d is not ATAPI\n",
+				gcw.protocol);
 	else if (gcw.device_type != 1)
-		printk(KERN_ERR "ide-tape: Device type is not set to tape\n");
+		printk(KERN_ERR "ide-tape: Device type %d is not set to tape\n",
+				gcw.device_type);
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
 	else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-tape: Packet size is not 12 bytes long\n");
+		printk(KERN_ERR "ide-tape: Packet size of %d is not 12 bytes"
+				" long\n", gcw.packet_size);
 		if (gcw.packet_size == 1)
-			printk(KERN_ERR "ide-tape: Sorry, padding to 16 bytes is still not supported\n");
+			printk(KERN_ERR "ide-tape: Sorry, padding to 16 bytes"
+					" is still not supported\n");
 	} else
 		return 1;
 	return 0;
@@ -3463,7 +3439,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
  * Ask the tape about its various parameters. In particular, we will adjust our
  * data transfer buffer	size to the recommended value as returned by the tape.
  */
-static void idetape_get_mode_sense_results (ide_drive_t *drive)
+static void idetape_get_mode_sense_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
@@ -3511,51 +3487,61 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idetape_add_settings (ide_drive_t *drive)
+static void idetape_add_settings(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-/*
- *			drive	setting name		read/write	data type	min			max			mul_factor			div_factor	data pointer				set function
- */
 	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_max",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline_used",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
+	ide_add_setting(drive, "pipeline_min", SETTING_RW, TYPE_INT, 1,	0xffff,
+			tape->stage_sz / 1024, 1, &tape->min_pipeline, NULL);
+	ide_add_setting(drive, "pipeline", SETTING_RW, TYPE_INT, 1, 0xffff,
+			tape->stage_sz / 1024, 1, &tape->max_stages, NULL);
+	ide_add_setting(drive, "pipeline_max", SETTING_RW, TYPE_INT, 1,	0xffff,
+			tape->stage_sz / 1024, 1, &tape->max_pipeline, NULL);
+
+	ide_add_setting(drive, "pipeline_used",	SETTING_READ, TYPE_INT,	0,
+			0xffff,	tape->stage_sz / 1024, 1, &tape->nr_stages,
+			NULL);
+
+	ide_add_setting(drive, "pipeline_pending", SETTING_READ, TYPE_INT, 0,
+			0xffff,	tape->stage_sz / 1024, 1,
+			&tape->nr_pending_stages, NULL);
+
 	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
+	ide_add_setting(drive, "stage",	SETTING_READ, TYPE_INT,	0, 0xffff,
+			1, 1024, &tape->stage_sz, NULL);
 	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
 			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
 			NULL);
-	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
+	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0,	1,
+			1, 1, &drive->dsc_overlap, NULL);
 	ide_add_setting(drive, "pipeline_head_speed_c", SETTING_READ, TYPE_INT,
 			0, 0xffff, 1, 1, &tape->pipe_ctl_hspeed, NULL);
 	ide_add_setting(drive, "pipeline_head_speed_u", SETTING_READ, TYPE_INT,
 			0, 0xffff, 1, 1, &tape->unctl_pipe_hspeed, NULL);
-	ide_add_setting(drive,	"avg_speed",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->avg_speed,			NULL);
-	ide_add_setting(drive,	"debug_level",		SETTING_RW,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->debug_level,			NULL);
+	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
+			1, 1, &tape->avg_speed, NULL);
+	ide_add_setting(drive, "debug_level", SETTING_RW, TYPE_INT, 0, 0xffff,
+			1, 1, &tape->debug_level, NULL);
 }
 #else
 static inline void idetape_add_settings(ide_drive_t *drive) { ; }
 #endif
 
 /*
- *	ide_setup is called to:
+ * The function below is called to:
  *
- *		1.	Initialize our various state variables.
- *		2.	Ask the tape for its capabilities.
- *		3.	Allocate a buffer which will be used for data
- *			transfer. The buffer size is chosen based on
- *			the recommendation which we received in step (2).
+ * - Initialize our various state variables.
+ * - Ask the tape for its capabilities.
+ * - Allocate a buffer which will be used for data transfer. The buffer size is
+ *   chosen based on the recommendation which we received in the previous step.
  *
- *	Note that at this point ide.c already assigned us an irq, so that
- *	we can queue requests here and wait for their completion.
+ * Note that at this point ide.c already assigned us an irq, so that we can
+ * queue requests here and wait for their completion.
  */
-static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
+static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
 	unsigned long t1, tmid, tn, t;
 	int speed;
@@ -3586,18 +3572,18 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->flags |= IDETAPE_FL_DRQ_INTERRUPT;
 
 	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
-	
+
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = *ctl * tape->blk_sz;
-	while (tape->stage_size > 0xffff) {
+	tape->stage_sz = *ctl * tape->blk_sz;
+	while (tape->stage_sz > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
 		*ctl /= 2;
-		tape->stage_size = *ctl * tape->blk_sz;
+		tape->stage_sz = *ctl * tape->blk_sz;
 	}
-	stage_size = tape->stage_size;
+	stage_size = tape->stage_sz;
 	tape->pages_per_stage = stage_size / PAGE_SIZE;
 	if (stage_size % PAGE_SIZE) {
 		tape->pages_per_stage++;
@@ -3607,23 +3593,22 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	/* Select the "best" DSC read/write polling freq and pipeline size. */
 	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
 
-	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
+	tape->max_stages = speed * 1000 * 10 / tape->stage_sz;
 
-	/*
-	 * 	Limit memory use for pipeline to 10% of physical memory
-	 */
+	/* Limit memory use for pipeline to 10% of physical memory */
 	si_meminfo(&si);
-	if (tape->max_stages * tape->stage_size > si.totalram * si.mem_unit / 10)
-		tape->max_stages = si.totalram * si.mem_unit / (10 * tape->stage_size);
-	tape->max_stages   = min(tape->max_stages, IDETAPE_MAX_PIPELINE_STAGES);
-	tape->min_pipeline = min(tape->max_stages, IDETAPE_MIN_PIPELINE_STAGES);
-	tape->max_pipeline = min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
+	if (tape->max_stages * tape->stage_sz > si.totalram * si.mem_unit / 10)
+		tape->max_stages = si.totalram * si.mem_unit /
+			(10 * tape->stage_sz);
+	tape->max_stages   = min(tape->max_stages, IDETAPE_MAX_PPL_STAGES);
+	tape->min_pipeline = min(tape->max_stages, IDETAPE_MIN_PPL_STAGES);
+	tape->max_pipeline = min(tape->max_stages * 2, IDETAPE_MAX_PPL_STAGES);
 	if (tape->max_stages == 0)
 		tape->max_stages = tape->min_pipeline = tape->max_pipeline = 1;
 
-	t1 = (tape->stage_size * HZ) / (speed * 1000);
+	t1 = (tape->stage_sz * HZ) / (speed * 1000);
 	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
-	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
+	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_sz * HZ) / (speed * 1000);
 
 	if (tape->max_stages)
 		t = tn;
@@ -3631,8 +3616,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		t = t1;
 
 	/*
-	 *	Ensure that the number we got makes sense; limit
-	 *	it within IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
+	 * Ensure that the number we got makes sense; limit it within
+	 * IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
 	tape->best_dsc_rw_freq = max_t(ulong,
 			min_t(ulong, t, IDETAPE_DSC_RW_MAX),
@@ -3640,9 +3625,9 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
-		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
-		tape->stage_size / 1024,
-		tape->max_stages * tape->stage_size / 1024,
+		(*(u16 *)&tape->caps[16] * 512) / tape->stage_sz,
+		tape->stage_sz / 1024,
+		tape->max_stages * tape->stage_sz / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
@@ -3712,7 +3697,7 @@ static ide_driver_t idetape_driver = {
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
 	.media			= ide_tape,
-	.supports_dsc_overlap 	= 1,
+	.supports_dsc_overlap	= 1,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
@@ -3722,9 +3707,7 @@ static ide_driver_t idetape_driver = {
 #endif
 };
 
-/*
- *	Our character device supporting functions, passed to register_chrdev.
- */
+/* Our character device supporting functions, passed to register_chrdev. */
 static const struct file_operations idetape_fops = {
 	.owner		= THIS_MODULE,
 	.read		= idetape_chrdev_read,
@@ -3739,7 +3722,8 @@ static int idetape_open(struct inode *inode, struct file *filp)
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_tape_obj *tape;
 
-	if (!(tape = ide_tape_get(disk)))
+	tape = ide_tape_get(disk);
+	if (!tape)
 		return -ENXIO;
 
 	return 0;
@@ -3786,21 +3770,26 @@ static int ide_tape_probe(ide_drive_t *drive)
 		goto failed;
 	if (drive->media != ide_tape)
 		goto failed;
-	if (!idetape_identify_device (drive)) {
-		printk(KERN_ERR "ide-tape: %s: not supported by this version of ide-tape\n", drive->name);
+	if (!idetape_identify_device(drive)) {
+		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
+				" the driver\n", drive->name);
 		goto failed;
 	}
 	if (drive->scsi) {
-		printk("ide-tape: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk("ide-tape: passing drive %s to ide-scsi emulation.\n",
+				drive->name);
 		goto failed;
 	}
 	if (strstr(drive->id->model, "OnStream DI-")) {
-		printk(KERN_WARNING "ide-tape: Use drive %s with ide-scsi emulation and osst.\n", drive->name);
-		printk(KERN_WARNING "ide-tape: OnStream support will be removed soon from ide-tape!\n");
-	}
-	tape = kzalloc(sizeof (idetape_tape_t), GFP_KERNEL);
-	if (tape == NULL) {
-		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape structure\n", drive->name);
+		printk(KERN_WARNING "ide-tape: Use drive %s with ide-scsi"
+				" emulation and osst.\n", drive->name);
+		printk(KERN_WARNING "ide-tape: OnStream support will be removed"
+				" soon from ide-tape!\n");
+	}
+	tape = kzalloc(sizeof(idetape_tape_t), GFP_KERNEL);
+	if (!tape) {
+		printk(KERN_ERR "ide-tape: %s: Can't allocate a tape struct\n",
+				drive->name);
 		goto failed;
 	}
 
@@ -3831,9 +3820,11 @@ static int ide_tape_probe(ide_drive_t *drive)
 	idetape_setup(drive, tape, minor);
 
 	class_device_create(idetape_sysfs_class, NULL,
-			MKDEV(IDETAPE_MAJOR, minor), &drive->gendev, "%s", tape->name);
+			MKDEV(IDETAPE_MAJOR, minor), &drive->gendev,
+			"%s", tape->name);
 	class_device_create(idetape_sysfs_class, NULL,
-			MKDEV(IDETAPE_MAJOR, minor + 128), &drive->gendev, "n%s", tape->name);
+			MKDEV(IDETAPE_MAJOR, minor + 128), &drive->gendev,
+			"n%s", tape->name);
 
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
@@ -3846,10 +3837,7 @@ failed:
 	return -ENODEV;
 }
 
-MODULE_DESCRIPTION("ATAPI Streaming TAPE Driver");
-MODULE_LICENSE("GPL");
-
-static void __exit idetape_exit (void)
+static void __exit idetape_exit(void)
 {
 	driver_unregister(&idetape_driver.gen_driver);
 	class_destroy(idetape_sysfs_class);
@@ -3868,7 +3856,8 @@ static int __init idetape_init(void)
 	}
 
 	if (register_chrdev(IDETAPE_MAJOR, "ht", &idetape_fops)) {
-		printk(KERN_ERR "ide-tape: Failed to register character device interface\n");
+		printk(KERN_ERR "ide-tape: Failed to register character device"
+				" interface\n");
 		error = -EBUSY;
 		goto out_free_class;
 	}
@@ -3891,3 +3880,5 @@ MODULE_ALIAS("ide:*m-tape*");
 module_init(idetape_init);
 module_exit(idetape_exit);
 MODULE_ALIAS_CHARDEV_MAJOR(IDETAPE_MAJOR);
+MODULE_DESCRIPTION("ATAPI Streaming TAPE Driver");
+MODULE_LICENSE("GPL");
-- 
1.5.3.7

