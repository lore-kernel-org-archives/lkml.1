Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYBDNrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYBDNrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbYBDNnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbYBDNm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=wYJrB79ukK/but5NdIeG2KQ7KbrtWwhrPxzV2hTtoJFlvunlE3mNoCpFuKbTHvWY/pttyYC+H3BoyE3TWFJ2pJeDAesQ3jQ99zjuQvixSwiA0RlCNEHtKRNOmFJmpfvZAlhDf4ntT4hvmJZDnIttoAV3Smudp4MjZKqHnpVfTBI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 14/22] ide-tape: cleanup and fix comments
Date: Mon,  4 Feb 2008 14:40:32 +0100
Message-Id: <1202132440-26648-15-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, remove redundant ones and cleanup whitespace.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |  725 +++++++++++++++++++----------------------------
 1 files changed, 293 insertions(+), 432 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 175d507..a80f8d9 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -73,37 +73,34 @@ enum {
 
 
 /*
- *	Pipelined mode parameters.
+ * Pipelined mode parameters.
  *
- *	We try to use the minimum number of stages which is enough to
- *	keep the tape constantly streaming. To accomplish that, we implement
- *	a feedback loop around the maximum number of stages:
+ * We try to use the minimum number of stages which is enough to keep the tape
+ * constantly streaming. To accomplish that, we implement a feedback loop around
+ * the maximum number of stages:
  *
- *	We start from MIN maximum stages (we will not even use MIN stages
- *      if we don't need them), increment it by RATE*(MAX-MIN)
- *	whenever we sense that the pipeline is empty, until we reach
- *	the optimum value or until we reach MAX.
+ * We start from MIN maximum stages (we will not even use MIN stages if we don't
+ * need them), increment it by RATE*(MAX-MIN) whenever we sense that the
+ * pipeline is empty, until we reach the optimum value or until we reach MAX.
  *
- *	Setting the following parameter to 0 is illegal: the pipelined mode
- *	cannot be disabled (idetape_calculate_speeds() divides by
- *	tape->max_stages.)
+ * Setting the following parameter to 0 is illegal: the pipelined mode cannot be
+ * disabled (idetape_calculate_speeds() divides by tape->max_stages.)
  */
 #define IDETAPE_MIN_PIPELINE_STAGES	  1
 #define IDETAPE_MAX_PIPELINE_STAGES	400
 #define IDETAPE_INCREASE_STAGES_RATE	 20
 
 /*
- *	After each failed packet command we issue a request sense command
- *	and retry the packet command IDETAPE_MAX_PC_RETRIES times.
+ * After each failed packet command we issue a request sense command and retry
+ * the packet command IDETAPE_MAX_PC_RETRIES times.
  *
- *	Setting IDETAPE_MAX_PC_RETRIES to 0 will disable retries.
+ * Setting IDETAPE_MAX_PC_RETRIES to 0 will disable retries.
  */
 #define IDETAPE_MAX_PC_RETRIES		3
 
 /*
- *	With each packet command, we allocate a buffer of
- *	IDETAPE_PC_BUFFER_SIZE bytes. This is used for several packet
- *	commands (Not for READ/WRITE commands).
+ * With each packet command, we allocate a buffer of IDETAPE_PC_BUFFER_SIZE
+ * bytes. This is used for several packet commands (Not for READ/WRITE commands)
  */
 #define IDETAPE_PC_BUFFER_SIZE		256
 
@@ -115,48 +112,41 @@ enum {
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
+ * DSC polling parameters.
  *
- *	Polling for DSC (a single bit in the status register) is a very
- *	important function in ide-tape. There are two cases in which we
- *	poll for DSC:
+ * Polling for DSC (a single bit in the status register) is a very important
+ * function in ide-tape. There are two cases in which we poll for DSC:
  *
- *	1.	Before a read/write packet command, to ensure that we
- *		can transfer data from/to the tape's data buffers, without
- *		causing an actual media access. In case the tape is not
- *		ready yet, we take out our request from the device
- *		request queue, so that ide.c will service requests from
- *		the other device on the same interface meanwhile.
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
+ * Again, we postpone our request in the middle to free the bus for the other
+ * device. The polling frequency here should be lower than the read/write
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
@@ -167,15 +157,9 @@ enum {
 
 /*************************** End of tunable parameters ***********************/
 
-/*
- *	Read/Write error simulation
- */
+/* Read/Write error simulation */
 #define SIMULATE_ERRORS			0
 
-/*
- *	For general magnetic tape device compatibility.
- */
-
 /* tape directions */
 enum {
 	IDETAPE_DIR_NONE  = (1 << 0),
@@ -190,23 +174,30 @@ struct idetape_bh {
 	char *b_data;
 };
 
-/*
- *	Our view of a packet command.
- */
 typedef struct idetape_packet_command_s {
-	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment retries */
-	int error;				/* Error code */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
+	/* Actual packet bytes */
+	u8 c[12];
+	/* On each retry, we increment retries */
+	int retries;
+	/* Error code */
+	int error;
+	/* Bytes to transfer */
+	int request_transfer;
+	/* Bytes actually transferred */
+	int actually_transferred;
+	/* Size of our data buffer */
+	int buffer_size;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	ide_startstop_t (*callback) (ide_drive_t *);	/* Called when this packet command is completed */
-	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];	/* Temporary buffer */
+	/* Data buffer */
+	u8 *buffer;
+	/* Pointer into the above buffer */
+	u8 *current_position;
+	/* Called when this packet command is completed */
+	ide_startstop_t (*callback) (ide_drive_t *);
+	/* Temporary buffer */
+	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];
 	unsigned int flags;
 } idetape_pc_t;
 
@@ -226,9 +217,7 @@ enum {
 	PC_FL_WRITING		= (1 <<	5),
 };
 
-/*
- *	A pipeline stage.
- */
+/* A pipeline stage. */
 typedef struct idetape_stage_s {
 	struct request rq;			/* The corresponding request */
 	struct idetape_bh *bh;			/* The data buffers */
@@ -236,9 +225,8 @@ typedef struct idetape_stage_s {
 } idetape_stage_t;
 
 /*
- *	Most of our global data which we need to save even as we leave the
- *	driver due to an interrupt or a timer event is stored in a variable
- *	of type idetape_tape_t, defined below.
+ * Most of our global data which we need to save even as we leave the driver due
+ * to an interrupt or a timer event is stored in the struct defined below.
  */
 typedef struct ide_tape_obj {
 	ide_drive_t	*drive;
@@ -257,15 +245,14 @@ typedef struct ide_tape_obj {
 	idetape_pc_t *failed_pc;
 
 	/*
-	 *	DSC polling variables.
+	 * DSC polling variables.
 	 *
-	 *	While polling for DSC we use postponed_rq to postpone the
-	 *	current request so that ide.c will be able to service
-	 *	pending requests on the other device. Note that at most
-	 *	we will have only one DSC (usually data transfer) request
-	 *	in the device request queue. Additional requests can be
-	 *	queued in our internal pipeline, but they will be visible
-	 *	to ide.c only one at a time.
+	 * While polling for DSC we use postponed_rq to postpone the current
+	 * request so that ide.c will be able to service pending requests on the
+	 * other device. Note that at most we will have only one DSC (usually
+	 * data transfer) request in the device request queue. Additional
+	 * requests can be queued in our internal pipeline, but they will be
+	 * visible to ide.c only one at a time.
 	 */
 	struct request *postponed_rq;
 	/* The time in which we started polling for DSC */
@@ -277,21 +264,15 @@ typedef struct ide_tape_obj {
 	unsigned long dsc_poll_freq;
 	unsigned long dsc_timeout;
 
-	/*
-	 *	Read position information
-	 */
+	/* Read position information */
 	u8 partition;
 	/* Current block */
 	unsigned int first_frame;
 
-	/*
-	 *	Last error information
-	 */
+	/* Last error information */
 	u8 sense_key, asc, ascq;
 
-	/*
-	 *	Character device operation
-	 */
+	/* Character device operation */
 	unsigned int minor;
 	/* device name */
 	char name[4];
@@ -306,33 +287,30 @@ typedef struct ide_tape_obj {
 	u8 caps[20];
 
 	/*
-	 *	Active data transfer request parameters.
+	 * Active data transfer request parameters.
 	 *
-	 *	At most, there is only one ide-tape originated data transfer
-	 *	request in the device request queue. This allows ide.c to
-	 *	easily service requests from the other device when we
-	 *	postpone our active request. In the pipelined operation
-	 *	mode, we use our internal pipeline structure to hold
-	 *	more data requests.
-	 *
-	 *	The data buffer size is chosen based on the tape's
-	 *	recommendation.
+	 * At most, there is only one ide-tape originated data transfer request
+	 * in the device request queue. This allows ide.c to easily service
+	 * requests from the other device when we postpone our active request.
+	 * In the pipelined operation mode, we use our internal pipeline
+	 * structure to hold more data requests. The data buffer size is chosen
+	 * based on the tape's recommendation.
 	 */
-	/* Ptr to the request which is waiting in the device request queue */
+	/* ptr to the request which is waiting in the device request queue */
 	struct request *active_data_rq;
-	/* Data buffer size (chosen based on the tape's recommendation */
+	/* Data buffer size chosen based on the tape's recommendation */
 	int stage_size;
 	idetape_stage_t *merge_stage;
 	int merge_stage_size;
 	struct idetape_bh *bh;
 	char *b_data;
 	int b_count;
-	
+
 	/*
-	 *	Pipeline parameters.
+	 * Pipeline parameters.
 	 *
-	 *	To accomplish non-pipelined mode, we simply set the following
-	 *	variables to zero (or NULL, where appropriate).
+	 * To accomplish non-pipelined mode, we simply set the following
+	 * variables to zero (or NULL, where appropriate).
 	 */
 	/* Number of currently used stages */
 	int nr_stages;
@@ -358,9 +336,7 @@ typedef struct ide_tape_obj {
 	/* protects the ide-tape queue */
 	spinlock_t lock;
 
-	/*
-	 * Measures average tape speed
-	 */
+	/* Measures average tape speed */
 	unsigned long avg_time;
 	int avg_size;
 	int avg_speed;
@@ -373,11 +349,9 @@ typedef struct ide_tape_obj {
 	char write_prot;
 
 	/*
-	 * Limit the number of times a request can
-	 * be postponed, to avoid an infinite postpone
-	 * deadlock.
+	 * Limit the number of times a request can be postponed, to avoid an
+	 * infinite postpone deadlock.
 	 */
-	/* request postpone count limit */
 	int postpone_cnt;
 
 	/*
@@ -392,18 +366,14 @@ typedef struct ide_tape_obj {
 	int tape_head;
 	int last_tape_head;
 
-	/*
-	 * Speed control at the tape buffers input/output
-	 */
+	/* Speed control at the tape buffers input/output */
 	unsigned long insert_time;
 	int insert_size;
 	int insert_speed;
 	int max_insert_speed;
 	int measure_insert_time;
 
-	/*
-	 * Speed regulation negative feedback loop
-	 */
+	/* Speed regulation negative feedback loop */
 	int speed_control;
 	int pipeline_head_speed;
 	int controlled_pipeline_head_speed;
@@ -450,9 +420,7 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	mutex_unlock(&idetape_ref_mutex);
 }
 
-/*
- *	Tape door status
- */
+/* Tape door status */
 #define DOOR_UNLOCKED			0
 #define DOOR_LOCKED			1
 #define DOOR_EXPLICITLY_LOCKED		2
@@ -478,30 +446,23 @@ enum {
 	IDETAPE_FL_MEDIUM_PRESENT	= (1 << 8),
 };
 
-/*
- *	Some defines for the READ BUFFER command
- */
+/* A define for the READ BUFFER command */
 #define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
 
-/*
- *	Some defines for the SPACE command
- */
+/* Some defines for the SPACE command */
 #define IDETAPE_SPACE_OVER_FILEMARK	1
 #define IDETAPE_SPACE_TO_EOD		3
 
-/*
- *	Some defines for the LOAD UNLOAD command
- */
+/* Some defines for the LOAD UNLOAD command */
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
 
 enum {
@@ -512,10 +473,7 @@ enum {
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
@@ -525,8 +483,8 @@ enum {
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
 
 /*
- *	The variables below are used for the character device interface.
- *	Additional state variables are defined in our ide_drive_t structure.
+ * The variables below are used for the character device interface. Additional
+ * state variables are defined in our ide_drive_t structure.
  */
 static struct ide_tape_obj * idetape_devs[MAX_HWIFS * MAX_DRIVES];
 
@@ -544,10 +502,6 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
 	return tape;
 }
 
-/*
- *      Function declarations
- *
- */
 static int idetape_chrdev_release (struct inode *inode, struct file *filp);
 static void idetape_write_release (ide_drive_t *drive, unsigned int minor);
 
@@ -663,9 +617,6 @@ static struct request *ide_tape_alloc_rq(void)
 	return rq;
 }
 
-/*
- *	idetape_init_pc initializes a packet command.
- */
 static void idetape_init_pc (idetape_pc_t *pc)
 {
 	memset(pc->c, 0, 12);
@@ -703,8 +654,8 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	}
 
 	/*
-	 * If error was the result of a zero-length read or write command,
-	 * with sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
+	 * If error was the result of a zero-length read or write command, with
+	 * sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
 	 * (i.e. Seagate STT3401A Travan) don't support 0-length read/writes.
 	 */
 	if ((pc->c[0] == READ_6 || pc->c[0] == WRITE_6)
@@ -760,10 +711,7 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 	tape->next_stage = stage->next;
 }
 
-/*
- *	idetape_kfree_stage calls kfree to completely free a stage, along with
- *	its related buffers.
- */
+/* Free a stage along with its related buffers completely. */
 static void __idetape_kfree_stage (idetape_stage_t *stage)
 {
 	struct idetape_bh *prev_bh, *bh = stage->bh;
@@ -791,8 +739,8 @@ static void idetape_kfree_stage (idetape_tape_t *tape, idetape_stage_t *stage)
 }
 
 /*
- *	idetape_remove_stage_head removes tape->first_stage from the pipeline.
- *	The caller should avoid race conditions.
+ * Remove tape->first_stage from the pipeline. The caller should avoid race
+ * conditions.
  */
 static void idetape_remove_stage_head (ide_drive_t *drive)
 {
@@ -850,8 +798,8 @@ static void idetape_abort_pipeline(ide_drive_t *drive,
 }
 
 /*
- *	idetape_end_request is used to finish servicing a request, and to
- *	insert a pending pipeline request into the main device queue.
+ * Finish servicing a request and insert a pending pipeline request into the
+ * main device queue.
  */
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
@@ -902,9 +850,7 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 		if (tape->next_stage != NULL) {
 			idetape_activate_next_stage(drive);
 
-			/*
-			 * Insert the next request into the request queue.
-			 */
+			/* Insert the next request into the request queue. */
 			(void)ide_do_drive_cmd(drive, tape->active_data_rq,
 						ide_end);
 		} else if (!error) {
@@ -971,19 +917,16 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
 }
 
 /*
- *	idetape_queue_pc_head generates a new packet command request in front
- *	of the request queue, before the current request, so that it will be
- *	processed immediately, on the next pass through the driver.
+ * Generate a new packet command request in front of the request queue, before
+ * the current request, so that it will be processed immediately, on the next
+ * pass through the driver. The function below is called from the request
+ * handling part of the driver (the "bottom" part). Safe storage for the request
+ * should be allocated with ide_tape_alloc_pc and ide_tape_alloc_rq prior to
+ * that.
  *
- *	idetape_queue_pc_head is called from the request handling part of
- *	the driver (the "bottom" part). Safe storage for the request should
- *	be allocated with ide_tape_alloc_pc and ide_tape_alloc_rq
- *	before calling idetape_queue_pc_head.
- *
- *	The higher level of the driver - The ioctl handler and the character
- *	device handling functions should queue request to the lower level part
- *	and wait for their completion using idetape_queue_pc_tail or
- *	idetape_queue_rw_tail.
+ * The higher level of the driver - The ioctl handler and the character device
+ * handling functions should queue request to the lower level part and wait for
+ * their completion using idetape_queue_pc_tail or idetape_queue_rw_tail.
  */
 static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct request *rq)
 {
@@ -1024,9 +967,8 @@ static ide_startstop_t idetape_retry_pc(ide_drive_t *drive)
 }
 
 /*
- *	idetape_postpone_request postpones the current request so that
- *	ide.c will be able to service requests from another device on
- *	the same hwgroup while we are polling for DSC.
+ * Postpone the current request so that ide.c will be able to service requests
+ * from another device on the same hwgroup while we are polling for DSC.
  */
 static void idetape_postpone_request (ide_drive_t *drive)
 {
@@ -1038,6 +980,9 @@ static void idetape_postpone_request (ide_drive_t *drive)
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
+
+typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
+
 /*
  * This is the usual interrupt handler which will be called during a packet
  * command. We will transfer some of the data (as requested by the drive) and
@@ -1045,9 +990,6 @@ static void idetape_postpone_request (ide_drive_t *drive)
  * will act according to the algorithm described before
  * idetape_issue_pc.
  */
-
-typedef void idetape_io_buf(ide_drive_t *, idetape_pc_t *, unsigned int);
-
 static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -1070,25 +1012,24 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
 	if (pc->flags & PC_FL_DMA_IN_PROGRESS) {
 		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
 			/*
-			 * A DMA error is sometimes expected. For example,
-			 * if the tape is crossing a filemark during a
-			 * READ command, it will issue an irq and position
-			 * itself before the filemark, so that only a partial
-			 * data transfer will occur (which causes the DMA
-			 * error). In that case, we will later ask the tape
-			 * how much bytes of the original request were
-			 * actually transferred (we can't receive that
-			 * information from the DMA engine on most chipsets).
+			 * A DMA error is sometimes expected. For example, if
+			 * the tape is crossing a filemark during a READ
+			 * command, it will issue an irq and position itself
+			 * before the filemark, so that only a partial data
+			 * transfer will occur (which causes the DMA error). In
+			 * that case, we will later ask the tape how much bytes
+			 * of the original request were actually transferred (we
+			 * can't receive that information from the DMA engine on
+			 * most chipsets).
 			 */
 
 			/*
-			 * On the contrary, a DMA error is never expected;
-			 * it usually indicates a hardware error or abort.
-			 * If the tape crosses a filemark during a READ
-			 * command, it will issue an irq and position itself
-			 * after the filemark (not before). Only a partial
-			 * data transfer will occur, but no DMA error.
-			 * (AS, 19 Apr 2001)
+			 * On the contrary, a DMA error is never expected; it
+			 * usually indicates a hardware error or abort. If the
+			 * tape crosses a filemark during a READ command, it
+			 * will issue an irq and position itself after the
+			 * filemark (not before). Only a partial data transfer
+			 * will occur, but no DMA error. (AS, 19 Apr 2001)
 			 */
 			pc->flags |= PC_FL_DMA_ERROR;
 		} else {
@@ -1215,46 +1156,40 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
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
+ * 1. idetape_issue_pc will send the packet command to the drive, and will set
+ * the interrupt handler to idetape_pc_intr.
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
+ * 2. On each interrupt, idetape_pc_intr will be called. This step will be
+ * repeated until the device signals us that no more interrupts will be issued.
  *
- *		ide.c will then give higher priority to requests which
- *		originate from the other device, until will change rq_status
- *		to RQ_ACTIVE.
+ * 3. ATAPI Tape media access commands have immediate status with a delayed
+ * process. In case of a successful initiation of a media access packet command,
+ * the DSC bit will be set when the actual execution of the command is finished.
+ * Since the tape drive will not issue an interrupt, we have to poll for this
+ * event. In this case, we define the request as "low priority request" by
+ * setting rq_status to	IDETAPE_RQ_POSTPONED, set a timer to poll for DSC and
+ * exit	the driver.
  *
- *	4.	When the packet command is finished, it will be checked for errors.
+ * ide.c will then give higher priority to requests which originate from the
+ * other device, until will change rq_status to RQ_ACTIVE.
  *
- *	5.	In case an error was found, we queue a request sense packet
- *		command in front of the request queue and retry the operation
- *		up to IDETAPE_MAX_PC_RETRIES times.
+ * 4. When the packet command is finished, it will be checked for errors.
  *
- *	6.	In case no error was found, or we decided to give up and not
- *		to retry again, the callback function will be called and then
- *		we will handle the next request.
+ * 5. In case an error was found, we queue a request sense packet command in
+ * front of the request queue and retry the operation up to
+ * IDETAPE_MAX_PC_RETRIES times.
  *
+ * 6. In case no error was found, or we decided to give up and not to retry
+ * again, the callback function will be called and then we will handle the next
+ * request.
  */
 static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
 {
@@ -1319,9 +1254,9 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 
 	if (pc->retries > IDETAPE_MAX_PC_RETRIES || (pc->flags & PC_FL_ABORT)) {
 		/*
-		 *	We will "abort" retrying a packet command in case
-		 *	a legitimate error code was received (crossing a
-		 *	filemark, or end of the media, for example).
+		 * We will "abort" retrying a packet command in case legitimate
+		 * error code was received (crossing a filemark, or end of the
+		 * media, for example).
 		 */
 		if (!(pc->flags & PC_FL_ABORT)) {
 			if (!(pc->c[0] == TEST_UNIT_READY &&
@@ -1373,9 +1308,6 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive, idetape_pc_t *pc)
 	}
 }
 
-/*
- *	General packet command callback function.
- */
 static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1386,25 +1318,25 @@ static ide_startstop_t idetape_pc_callback (ide_drive_t *drive)
 	return ide_stopped;
 }
 
-/*
- *	A mode sense command is used to "sense" tape parameters.
- */
+/* A mode sense command is used to "sense" tape parameters. */
 static void idetape_create_mode_sense_cmd (idetape_pc_t *pc, u8 page_code)
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
 		pc->request_transfer = 12;
 	else if (page_code == IDETAPE_CAPABILITIES_PAGE)
@@ -1575,9 +1507,6 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
 		pc->flags |= PC_FL_DMA_RECOMMENDED;
 }
 
-/*
- * idetape_do_request is our request handling function.	
- */
 static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 					  struct request *rq, sector_t block)
 {
@@ -1591,18 +1520,14 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
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
+	/* Retry a failed packet command */
 	if (tape->failed_pc != NULL &&
 	    tape->pc->c[0] == REQUEST_SENSE) {
 		return idetape_issue_pc(drive, tape->failed_pc);
@@ -1618,8 +1543,8 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	tape->postponed_rq = NULL;
 
 	/*
-	 * If the tape is still busy, postpone our request and service
-	 * the other device meanwhile.
+	 * If the tape is still busy, postpone our request and service the other
+	 * device meanwhile.
 	 */
 	stat = drive->hwif->INB(IDE_STATUS_REG);
 
@@ -1706,9 +1631,7 @@ err:
 	return ide_stopped;
 }
 
-/*
- *	Pipeline related functions
- */
+/* Pipeline related functions */
 static inline int idetape_pipeline_active (idetape_tape_t *tape)
 {
 	int rc1, rc2;
@@ -1719,16 +1642,16 @@ static inline int idetape_pipeline_active (idetape_tape_t *tape)
 }
 
 /*
- *	idetape_kmalloc_stage uses __get_free_page to allocate a pipeline
- *	stage, along with all the necessary small buffers which together make
- *	a buffer of size tape->stage_size (or a bit more). We attempt to
- *	combine sequential pages as much as possible.
+ * The function below uses __get_free_page to allocate a pipeline stage, along
+ * with all the necessary small buffers which together make a buffer of size
+ * tape->stage_size (or a bit more). We attempt to combine sequential pages as
+ * much as possible.
  *
- *	Returns a pointer to the new allocated stage, or NULL if we
- *	can't (or don't want to) allocate a stage.
+ * It returns a pointer to the new allocated stage, or NULL if we can't (or
+ * don't want to) allocate a stage.
  *
- *	Pipeline stages are optional and are used to increase performance.
- *	If we can't allocate them, we'll manage without them.
+ * Pipeline stages are optional and are used to increase performance. If we
+ * can't allocate them, we'll manage without them.
  */
 static idetape_stage_t *__idetape_kmalloc_stage (idetape_tape_t *tape, int full, int clear)
 {
@@ -1886,9 +1809,7 @@ static void idetape_switch_buffers (idetape_tape_t *tape, idetape_stage_t *stage
 	idetape_init_merge_stage(tape);
 }
 
-/*
- *	idetape_add_stage_tail adds a new stage at the end of the pipeline.
- */
+/* Add a new stage at the end of the pipeline. */
 static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1910,12 +1831,9 @@ static void idetape_add_stage_tail (ide_drive_t *drive,idetape_stage_t *stage)
 	spin_unlock_irqrestore(&tape->lock, flags);
 }
 
-/*
- *	idetape_wait_for_request installs a completion in a pending request
- *	and sleeps until it is serviced.
- *
- *	The caller should ensure that the request will not be serviced
- *	before we install the completion (usually by disabling interrupts).
+/* Install a completion in a pending request and sleep until it is serviced. The
+ * caller should ensure that the request will not be serviced before we install
+ * the completion (usually by disabling interrupts).
  */
 static void idetape_wait_for_request (ide_drive_t *drive, struct request *rq)
 {
@@ -1970,12 +1888,8 @@ static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
 }
 
 /*
- *	idetape_create_write_filemark_cmd will:
- *
- *		1.	Write a filemark if write_filemark=1.
- *		2.	Flush the device buffers without writing a filemark
- *			if write_filemark=0.
- *
+ * Write a filemark if write_filemark=1. Flush the device buffers without
+ * writing a filemark otherwise.
  */
 static void idetape_create_write_filemark_cmd (ide_drive_t *drive, idetape_pc_t *pc,int write_filemark)
 {
@@ -1994,24 +1908,17 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
 }
 
 /*
- *	idetape_queue_pc_tail is based on the following functions:
- *
- *	ide_do_drive_cmd from ide.c
- *	cdrom_queue_request and cdrom_queue_packet_command from ide-cd.c
- *
- *	We add a special packet command request to the tail of the request
- *	queue, and wait for it to be serviced.
- *
- *	This is not to be called from within the request handling part
- *	of the driver ! We allocate here data in the stack, and it is valid
- *	until the request is finished. This is not the case for the bottom
- *	part of the driver, where we are always leaving the functions to wait
- *	for an interrupt or a timer event.
+ * We add a special packet command request to the tail of the request queue, and
+ * wait for it to be serviced. This is not to be called from within the request
+ * handling part of the driver! We allocate here data on the stack and it is
+ * valid until the request is finished. This is not the case for the bottom part
+ * of the driver, where we are always leaving the functions to wait for an
+ * interrupt or a timer event.
  *
- *	From the bottom part of the driver, we should allocate safe memory
- *	using ide_tape_alloc_pc and ide_tape_alloc_rq, and add
- *	the request to the request list without waiting for it to be serviced !
- *	In that case, we usually use idetape_queue_pc_head.
+ * From the bottom part of the driver, we should allocate safe memory using
+ * ide_tape_alloc_pc() and ide_tape_alloc_rq(), and add the request to the
+ * request list without waiting for it to be serviced! In that case, we usually
+ * use idetape_queue_pc_head().
  */
 static int __idetape_queue_pc_tail (ide_drive_t *drive, idetape_pc_t *pc)
 {
@@ -2039,9 +1946,7 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 	idetape_pc_t pc;
 	int load_attempted = 0;
 
-	/*
-	 * Wait for the tape to become ready
-	 */
+	/* Wait for the tape to become ready */
 	tape->flags |= IDETAPE_FL_MEDIUM_PRESENT;
 	timeout += jiffies;
 	while (time_before(jiffies, timeout)) {
@@ -2049,7 +1954,8 @@ static int idetape_wait_ready(ide_drive_t *drive, unsigned long timeout)
 		if (!__idetape_queue_pc_tail(drive, &pc))
 			return 0;
 		if ((tape->sense_key == 2 && tape->asc == 4 && tape->ascq == 2)
-		    || (tape->asc == 0x3A)) {	/* no media */
+		    || (tape->asc == 0x3A)) {
+			/* no media */
 			if (load_attempted)
 				return -ENOMEDIUM;
 			idetape_create_load_unload_cmd(drive, &pc, IDETAPE_LU_LOAD_MASK);
@@ -2180,13 +2086,10 @@ static int __idetape_discard_read_pipeline (ide_drive_t *drive)
 }
 
 /*
- *	idetape_position_tape positions the tape to the requested block
- *	using the LOCATE packet command. A READ POSITION command is then
- *	issued to check where we are positioned.
- *
- *	Like all higher level operations, we queue the commands at the tail
- *	of the request queue and wait for their completion.
- *	
+ * Position the tape to the requested block using the LOCATE packet command.
+ * A READ POSITION command is then issued to check where we are positioned. Like
+ * all higher level operations, we queue the commands at the tail of the request
+ * queue and wait for their completion.
  */
 static int idetape_position_tape (ide_drive_t *drive, unsigned int block, u8 partition, int skip)
 {
@@ -2224,8 +2127,8 @@ static void idetape_discard_read_pipeline (ide_drive_t *drive, int restore_posit
 }
 
 /*
- * idetape_queue_rw_tail generates a read/write request for the block
- * device interface and wait for it to be serviced.
+ * Generate a read/write request for the block device interface and wait for it
+ * to be serviced.
  */
 static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks, struct idetape_bh *bh)
 {
@@ -2320,15 +2223,15 @@ static void idetape_wait_first_stage (ide_drive_t *drive)
 }
 
 /*
- *	idetape_add_chrdev_write_request tries to add a character device
- *	originated write request to our pipeline. In case we don't succeed,
- *	we revert to non-pipelined operation mode for this request.
+ * Try to add a character device originated write request to our pipeline. In
+ * case we don't succeed, we revert to non-pipelined operation mode for this
+ * request. In order to accomplish that, we
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
 static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 {
@@ -2339,10 +2242,7 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 
 	debug_log(DBG_CHRDEV, "Enter %s\n", __func__);
 
-     	/*
-     	 *	Attempt to allocate a new stage.
-	 *	Pay special attention to possible race conditions.
-	 */
+	/* Attempt to allocate a new stage. Beware possible race conditions. */
 	while ((new_stage = idetape_kmalloc_stage(tape)) == NULL) {
 		spin_lock_irqsave(&tape->lock, flags);
 		if (idetape_pipeline_active(tape)) {
@@ -2354,8 +2254,8 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 			if (idetape_pipeline_active(tape))
 				continue;
 			/*
-			 *	Linux is short on memory. Fallback to
-			 *	non-pipelined operation mode for this request.
+			 * The machine is short on memory. Fallback to non-
+			 * pipelined operation mode for this request.
 			 */
 			return idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, blocks, tape->merge_stage->bh);
 		}
@@ -2372,11 +2272,11 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 	idetape_calculate_speeds(drive);
 
 	/*
-	 *	Estimate whether the tape has stopped writing by checking
-	 *	if our write pipeline is currently empty. If we are not
-	 *	writing anymore, wait for the pipeline to be full enough
-	 *	(90%) before starting to service requests, so that we will
-	 *	be able to keep up with the higher speeds of the tape.
+	 * Estimate whether the tape has stopped writing by checking if our
+	 * write pipeline is currently empty. If we are not writing anymore,
+	 * wait for the pipeline to be almost completely full (90%) before
+	 * starting to service requests, so that we will be able to keep up with
+	 * the higher speeds of the tape.
 	 */
 	if (!idetape_pipeline_active(tape)) {
 		if (tape->nr_stages >= tape->max_stages * 9 / 10 ||
@@ -2399,8 +2299,8 @@ static int idetape_add_chrdev_write_request (ide_drive_t *drive, int blocks)
 }
 
 /*
- *	idetape_wait_for_pipeline will wait until all pending pipeline
- *	requests are serviced. Typically called on device close.
+ * Wait until all pending pipeline requests are serviced. Typically called on
+ * device close.
  */
 static void idetape_wait_for_pipeline (ide_drive_t *drive)
 {
@@ -2469,10 +2369,10 @@ static void idetape_empty_write_pipeline (ide_drive_t *drive)
 	tape->chrdev_dir = IDETAPE_DIR_NONE;
 
 	/*
-	 *	On the next backup, perform the feedback loop again.
-	 *	(I don't want to keep sense information between backups,
-	 *	 as some systems are constantly on, and the system load
-	 *	 can be totally different on the next backup).
+	 * On the next backup, perform the feedback loop again. (I don't want to
+	 * keep sense information between backups, as some systems are
+	 * constantly on, and the system load can be totally different on the
+	 * next backup).
 	 */
 	tape->max_stages = tape->min_pipeline;
 	if (tape->first_stage != NULL ||
@@ -2524,11 +2424,10 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 		tape->chrdev_dir = IDETAPE_DIR_READ;
 
 		/*
-		 *	Issue a read 0 command to ensure that DSC handshake
-		 *	is switched from completion mode to buffer available
-		 *	mode.
-		 *	No point in issuing this if DSC overlap isn't supported,
-		 *	some drives (Seagate STT3401A) will return an error.
+		 * Issue a read 0 command to ensure that DSC handshake is
+		 * switched from completion mode to buffer available mode.
+		 * No point in issuing this if DSC overlap isn't supported, some
+		 * drives (Seagate STT3401A) will return an error.
 		 */
 		if (drive->dsc_overlap) {
 			bytes_read = idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, 0, tape->merge_stage->bh);
@@ -2569,9 +2468,8 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
 }
 
 /*
- *	idetape_add_chrdev_read_request is called from idetape_chrdev_read
- *	to service a character device read request and add read-ahead
- *	requests to our pipeline.
+ * Called from idetape_chrdev_read() to service a character device read request
+ * and add read-ahead requests to our pipeline.
  */
 static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 {
@@ -2582,16 +2480,11 @@ static int idetape_add_chrdev_read_request (ide_drive_t *drive,int blocks)
 
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
+	/* Wait for the next block to reach the head of the pipeline. */
 	idetape_init_read(drive, tape->max_stages);
 	if (tape->first_stage == NULL) {
 		if (tape->flags & IDETAPE_FL_PIPELINE_ERR)
@@ -2630,7 +2523,7 @@ static void idetape_pad_zeros (ide_drive_t *drive, int bcount)
 	idetape_tape_t *tape = drive->driver_data;
 	struct idetape_bh *bh;
 	int blocks;
-	
+
 	while (bcount) {
 		unsigned int count;
 
@@ -2670,10 +2563,9 @@ static int idetape_pipeline_size (ide_drive_t *drive)
 }
 
 /*
- *	Rewinds the tape to the Beginning Of the current Partition (BOP).
- *
- *	We currently support only one partition.
- */ 
+ * Rewinds the tape to the Beginning Of the current Partition (BOP). We
+ * currently support only one partition.
+ */
 static int idetape_rewind_tape (ide_drive_t *drive)
 {
 	int retval;
@@ -2695,13 +2587,7 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 	return 0;
 }
 
-/*
- *	Our special ide-tape ioctl's.
- *
- *	Currently there aren't any ioctl's.
- *	mtio.h compatible commands should be issued to the character device
- *	interface.
- */
+/* mtio.h compatible commands should be issued to the chrdev interface. */
 static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -2735,13 +2621,11 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 }
 
 /*
- *	idetape_space_over_filemarks is now a bit more complicated than just
- *	passing the command to the tape since we may have crossed some
- *	filemarks during our pipelined read-ahead mode.
- *
- *	As a minor side effect, the pipeline enables us to support MTFSFM when
- *	the filemark is in our internal pipeline even if the tape doesn't
- *	support spacing over filemarks in the reverse direction.
+ * The function below is now a bit more complicated than just passing the
+ * command to the tape since we may have crossed some filemarks during our
+ * pipelined read-ahead mode. As a minor side effect, the pipeline enables us to
+ * support MTFSFM when the filemark is in our internal pipeline even if the tape
+ * doesn't support spacing over filemarks in the reverse direction.
  */
 static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_count)
 {
@@ -2760,10 +2644,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	}
 
 	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
-		/*
-		 *	We have a read-ahead buffer. Scan it for crossed
-		 *	filemarks.
-		 */
+		/* its a read-ahead buffer, scan it for crossed filemarks. */
 		tape->merge_stage_size = 0;
 		if (tape->flags & IDETAPE_FL_FILEMARK) {
 			tape->flags &= ~IDETAPE_FL_FILEMARK;
@@ -2778,13 +2659,15 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 			spin_lock_irqsave(&tape->lock, flags);
 			if (tape->first_stage == tape->active_stage) {
 				/*
-				 *	We have reached the active stage in the read pipeline.
-				 *	There is no point in allowing the drive to continue
-				 *	reading any farther, so we stop the pipeline.
+				 * We have reached the active stage in the read
+				 * pipeline. There is no point in allowing the
+				 * drive to continue reading any farther, so we
+				 * stop the pipeline.
 				 *
-				 *	This section should be moved to a separate subroutine,
-				 *	because a similar function is performed in
-				 *	__idetape_discard_read_pipeline(), for example.
+				 * This section should be moved to a separate
+				 * subroutine because similar operations are
+				 * done in __idetape_discard_read_pipeline(),
+				 * for example.
 				 */
 				tape->next_stage = NULL;
 				spin_unlock_irqrestore(&tape->lock, flags);
@@ -2800,8 +2683,8 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	}
 
 	/*
-	 *	The filemark was not found in our internal pipeline.
-	 *	Now we can issue the space command.
+	 * The filemark was not found in our internal pipeline;	now we can issue
+	 * the space command.
 	 */
 	switch (mt_op) {
 		case MTFSF:
@@ -2824,21 +2707,19 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 
 
 /*
- *	Our character device read / write functions.
+ * Our character device read / write functions.
  *
- *	The tape is optimized to maximize throughput when it is transferring
- *	an integral number of the "continuous transfer limit", which is
- *	a parameter of the specific tape (26 KB on my particular tape).
- *      (32 kB for Onstream)
+ * The tape is optimized to maximize throughput when it is transferring an
+ * integral number of the "continuous transfer limit", which is a parameter of
+ * the specific tape (26kB on my particular tape, 32kB for Onstream).
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
 static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 				    size_t count, loff_t *ppos)
@@ -2931,11 +2812,10 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
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
 			ssize_t retval = idetape_queue_rw_tail(drive, REQ_IDETAPE_WRITE, 0, tape->merge_stage->bh);
@@ -3026,9 +2906,7 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
 			mt_op, mt_count);
-	/*
-	 *	Commands which need our pipelined read-ahead stages.
-	 */
+	/* Commands which need our pipelined read-ahead stages. */
 	switch (mt_op) {
 		case MTFSF:
 		case MTFSFM:
@@ -3216,9 +3094,6 @@ static void ide_tape_get_bsize_from_bdesc(ide_drive_t *drive)
 	tape->drv_write_prot = (pc.buffer[2] & 0x80) >> 7;
 }
 
-/*
- *	Our character device open function.
- */
 static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 {
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
@@ -3287,9 +3162,7 @@ static int idetape_chrdev_open (struct inode *inode, struct file *filp)
 		}
 	}
 
-	/*
-	 * Lock the tape drive door so user can't eject.
-	 */
+	/* Lock the tape drive door so user can't eject. */
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
 			if (!idetape_queue_pc_tail(drive, &pc)) {
@@ -3324,9 +3197,6 @@ static void idetape_write_release (ide_drive_t *drive, unsigned int minor)
 	idetape_flush_tape_buffers(drive);
 }
 
-/*
- *	Our character device release function.
- */
 static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
@@ -3487,9 +3357,6 @@ static void idetape_add_settings (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-/*
- *			drive	setting name		read/write	data type	min			max			mul_factor			div_factor	data pointer				set function
- */
 	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
 			1, 2, (u16 *)&tape->caps[16], NULL);
 	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
@@ -3516,16 +3383,14 @@ static inline void idetape_add_settings(ide_drive_t *drive) { ; }
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
- *
- *	Note that at this point ide.c already assigned us an irq, so that
- *	we can queue requests here and wait for their completion.
+ * 1. Initialize our various state variables.
+ * 2. Ask the tape for its capabilities.
+ * 3. Allocate a buffer which will be used for data transfer. The buffer size is
+ * chosen based on the recommendation which we received in step 2. Note that at
+ * this point ide.c already assigned us an irq, so that we can queue requests
+ * here and wait for their completion.
  */
 static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
@@ -3560,7 +3425,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->flags |= IDETAPE_FL_DRQ_INTERRUPT;
 
 	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
-	
+
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -3583,9 +3448,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 
 	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
 
-	/*
-	 * 	Limit memory use for pipeline to 10% of physical memory
-	 */
+	/* Limit memory use for pipeline to 10% of physical memory */
 	si_meminfo(&si);
 	if (tape->max_stages * tape->stage_size > si.totalram * si.mem_unit / 10)
 		tape->max_stages = si.totalram * si.mem_unit / (10 * tape->stage_size);
@@ -3605,8 +3468,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		t = t1;
 
 	/*
-	 *	Ensure that the number we got makes sense; limit
-	 *	it within IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
+	 * Ensure that the number we got makes sense; limit it within
+	 * IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
 	tape->best_dsc_rw_freq = max_t(unsigned long,
 				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
@@ -3694,9 +3557,7 @@ static ide_driver_t idetape_driver = {
 #endif
 };
 
-/*
- *	Our character device supporting functions, passed to register_chrdev.
- */
+/* Our character device supporting functions, passed to register_chrdev. */
 static const struct file_operations idetape_fops = {
 	.owner		= THIS_MODULE,
 	.read		= idetape_chrdev_read,
-- 
1.5.3.7

