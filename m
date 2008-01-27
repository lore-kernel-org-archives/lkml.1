Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYA0Juz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYA0Juz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYA0JtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:06 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58586 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753495AbYA0Js7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:48:59 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 08/32] ide-tape: remove struct idetape_capabilities_page_t
Date: Sun, 27 Jan 2008 10:47:56 +0100
Message-Id: <1201427300-3954-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

All those 2-byte values denoting the different capabilities are being written to
the local copy of the caps buffer without being converted to big endian for
simplicity of usage and shorter code later.  Also, we add some comments stating
which are the fields of the caps page in question in order to alleviate the
cryptic pointer casting exercises as in e.g. idetape_get_mode_sense_results().

There should be no functional changes resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |  143 +++++++++++++++++++-----------------------------
 1 files changed, 57 insertions(+), 86 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a2e7df0..0f846bc 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -264,47 +264,6 @@ typedef struct idetape_packet_command_s {
 #define	PC_WRITING			5
 
 /*
- *	Capabilities and Mechanical Status Page
- */
-typedef struct {
-	unsigned	page_code	:6;	/* Page code - Should be 0x2a */
-	__u8		reserved0_6	:1;
-	__u8		ps		:1;	/* parameters saveable */
-	__u8		page_length;		/* Page Length - Should be 0x12 */
-	__u8		reserved2, reserved3;
-	unsigned	ro		:1;	/* Read Only Mode */
-	unsigned	reserved4_1234	:4;
-	unsigned	sprev		:1;	/* Supports SPACE in the reverse direction */
-	unsigned	reserved4_67	:2;
-	unsigned	reserved5_012	:3;
-	unsigned	efmt		:1;	/* Supports ERASE command initiated formatting */
-	unsigned	reserved5_4	:1;
-	unsigned	qfa		:1;	/* Supports the QFA two partition formats */
-	unsigned	reserved5_67	:2;
-	unsigned	lock		:1;	/* Supports locking the volume */
-	unsigned	locked		:1;	/* The volume is locked */
-	unsigned	prevent		:1;	/* The device defaults in the prevent state after power up */	
-	unsigned	eject		:1;	/* The device can eject the volume */
-	__u8		disconnect	:1;	/* The device can break request > ctl */	
-	__u8		reserved6_5	:1;
-	unsigned	ecc		:1;	/* Supports error correction */
-	unsigned	cmprs		:1;	/* Supports data compression */
-	unsigned	reserved7_0	:1;
-	unsigned	blk512		:1;	/* Supports 512 bytes block size */
-	unsigned	blk1024		:1;	/* Supports 1024 bytes block size */
-	unsigned	reserved7_3_6	:4;
-	unsigned	blk32768	:1;	/* slowb - the device restricts the byte count for PIO */
-						/* transfers for slow buffer memory ??? */
-						/* Also 32768 block size in some cases */
-	__u16		max_speed;		/* Maximum speed supported in KBps */
-	__u8		reserved10, reserved11;
-	__u16		ctl;			/* Continuous Transfer Limit in blocks */
-	__u16		speed;			/* Current Speed, in KBps */
-	__u16		buffer_size;		/* Buffer Size, in 512 bytes */
-	__u8		reserved18, reserved19;
-} idetape_capabilities_page_t;
-
-/*
  *	Block Size Page
  */
 typedef struct {
@@ -421,8 +380,9 @@ typedef struct ide_tape_obj {
 	/* Usually 512 or 1024 bytes */
 	unsigned short tape_block_size;
 	int user_bs_factor;
+
 	/* Copy of the tape's Capabilities and Mechanical Page */
-	idetape_capabilities_page_t capabilities;
+	u8 caps[20];
 
 	/*
 	 *	Active data transfer request parameters.
@@ -2401,7 +2361,8 @@ static int idetape_create_prevent_cmd (ide_drive_t *drive, idetape_pc_t *pc, int
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	if (!tape->capabilities.lock)
+	/* device supports locking according to capabilities page */
+	if (!(tape->caps[6] & 0x01))
 		return 0;
 
 	idetape_init_pc(pc);
@@ -2783,7 +2744,7 @@ static int idetape_initiate_read (ide_drive_t *drive, int max_stages)
 	idetape_stage_t *new_stage;
 	struct request rq;
 	int bytes_read;
-	int blocks = tape->capabilities.ctl;
+	u16 blocks = *(u16 *)&tape->caps[12];
 
 	/* Initialize read operation */
 	if (tape->chrdev_direction != idetape_direction_read) {
@@ -3017,11 +2978,12 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 	idetape_pc_t pc;
 	unsigned long flags;
 	int retval,count=0;
+	int sprev = !!(tape->caps[4] & 0x20);
 
 	if (mt_count == 0)
 		return 0;
 	if (MTBSF == mt_op || MTBSFM == mt_op) {
-		if (!tape->capabilities.sprev)
+		if (!sprev)
 			return -EIO;
 		mt_count = - mt_count;
 	}
@@ -3075,7 +3037,7 @@ static int idetape_space_over_filemarks (ide_drive_t *drive,short mt_op,int mt_c
 			return (idetape_queue_pc_tail(drive, &pc));
 		case MTFSFM:
 		case MTBSFM:
-			if (!tape->capabilities.sprev)
+			if (!sprev)
 				return (-EIO);
 			retval = idetape_space_over_filemarks(drive, MTFSF, mt_count-count);
 			if (retval) return (retval);
@@ -3112,6 +3074,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 	ide_drive_t *drive = tape->drive;
 	ssize_t bytes_read,temp, actually_read = 0, rc;
 	ssize_t ret = 0;
+	u16 ctl = *(u16 *)&tape->caps[12];
 
 	debug_log(DBG_CHRDEV, "Enter %s, count %Zd\n", __func__, count);
 
@@ -3134,7 +3097,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		count -= actually_read;
 	}
 	while (count >= tape->stage_size) {
-		bytes_read = idetape_add_chrdev_read_request(drive, tape->capabilities.ctl);
+		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
 		if (idetape_copy_stage_to_user(tape, buf, tape->merge_stage, bytes_read))
@@ -3144,7 +3107,7 @@ static ssize_t idetape_chrdev_read (struct file *file, char __user *buf,
 		actually_read += bytes_read;
 	}
 	if (count) {
-		bytes_read = idetape_add_chrdev_read_request(drive, tape->capabilities.ctl);
+		bytes_read = idetape_add_chrdev_read_request(drive, ctl);
 		if (bytes_read <= 0)
 			goto finish;
 		temp = min((unsigned long)count, (unsigned long)bytes_read);
@@ -3171,6 +3134,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 	ide_drive_t *drive = tape->drive;
 	ssize_t actually_written = 0;
 	ssize_t ret = 0;
+	u16 ctl = *(u16 *)&tape->caps[12];
 
 	/* The drive is write protected. */
 	if (tape->write_prot)
@@ -3228,7 +3192,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 		if (tape->merge_stage_size == tape->stage_size) {
 			ssize_t retval;
 			tape->merge_stage_size = 0;
-			retval = idetape_add_chrdev_write_request(drive, tape->capabilities.ctl);
+			retval = idetape_add_chrdev_write_request(drive, ctl);
 			if (retval <= 0)
 				return (retval);
 		}
@@ -3239,7 +3203,7 @@ static ssize_t idetape_chrdev_write (struct file *file, const char __user *buf,
 			ret = -EFAULT;
 		buf += tape->stage_size;
 		count -= tape->stage_size;
-		retval = idetape_add_chrdev_write_request(drive, tape->capabilities.ctl);
+		retval = idetape_add_chrdev_write_request(drive, ctl);
 		actually_written += tape->stage_size;
 		if (retval <= 0)
 			return (retval);
@@ -3727,47 +3691,54 @@ static void idetape_get_inquiry_results (ide_drive_t *drive)
 }
 
 /*
- *	idetape_get_mode_sense_results asks the tape about its various
- *	parameters. In particular, we will adjust our data transfer buffer
- *	size to the recommended value as returned by the tape.
+ * Ask the tape about its various parameters. In particular, we will adjust our
+ * data transfer buffer	size to the recommended value as returned by the tape.
  */
 static void idetape_get_mode_sense_results (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	idetape_capabilities_page_t *capabilities;
+	u8 *caps;
+	u8 speed, max_speed;
 
 	idetape_create_mode_sense_cmd(&pc, IDETAPE_CAPABILITIES_PAGE);
 	if (idetape_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming some default values\n");
+		printk(KERN_ERR "ide-tape: Can't get tape parameters - assuming"
+				" some default values\n");
 		tape->tape_block_size = 512;
-		tape->capabilities.ctl = 52;
-		tape->capabilities.speed = 450;
-		tape->capabilities.buffer_size = 6 * 52;
+		put_unaligned(52,   (u16 *)&tape->caps[12]);
+		put_unaligned(540,  (u16 *)&tape->caps[14]);
+		put_unaligned(6*52, (u16 *)&tape->caps[16]);
 		return;
 	}
-	capabilities = (idetape_capabilities_page_t *)
-		(pc.buffer + 4 + pc.buffer[3]);
+	caps = pc.buffer + 4 + pc.buffer[3];
 
-	capabilities->max_speed = ntohs(capabilities->max_speed);
-	capabilities->ctl = ntohs(capabilities->ctl);
-	capabilities->speed = ntohs(capabilities->speed);
-	capabilities->buffer_size = ntohs(capabilities->buffer_size);
+	/* convert to host order and save for later use */
+	speed = be16_to_cpu(*(u16 *)&caps[14]);
+	max_speed = be16_to_cpu(*(u16 *)&caps[8]);
 
-	if (!capabilities->speed) {
-		printk(KERN_INFO "ide-tape: %s: overriding capabilities->speed (assuming 650KB/sec)\n", drive->name);
-		capabilities->speed = 650;
+	put_unaligned(max_speed, (u16 *)&caps[8]);
+	put_unaligned(be16_to_cpu(*(u16 *)&caps[12]), (u16 *)&caps[12]);
+	put_unaligned(speed, (u16 *)&caps[14]);
+	put_unaligned(be16_to_cpu(*(u16 *)&caps[16]), (u16 *)&caps[16]);
+
+	if (!speed) {
+		printk(KERN_INFO "ide-tape: %s: invalid tape speed "
+				"(assuming 650KB/sec)\n", drive->name);
+		put_unaligned(650, (u16 *)&caps[14]);
 	}
-	if (!capabilities->max_speed) {
-		printk(KERN_INFO "ide-tape: %s: overriding capabilities->max_speed (assuming 650KB/sec)\n", drive->name);
-		capabilities->max_speed = 650;
+	if (!max_speed) {
+		printk(KERN_INFO "ide-tape: %s: invalid max_speed "
+				"(assuming 650KB/sec)\n", drive->name);
+		put_unaligned(650, (u16 *)&caps[8]);
 	}
 
-	tape->capabilities = *capabilities;		/* Save us a copy */
-	if (capabilities->blk512)
+	memcpy(&tape->caps, caps, 20);
+	if (!!(caps[7] & 0x02))
 		tape->tape_block_size = 512;
-	else if (capabilities->blk1024)
+	else if (!!(caps[7] & 0x04))
 		tape->tape_block_size = 1024;
+
 }
 
 /*
@@ -3803,13 +3774,15 @@ static void idetape_add_settings (ide_drive_t *drive)
 /*
  *			drive	setting name		read/write	data type	min			max			mul_factor			div_factor	data pointer				set function
  */
-	ide_add_setting(drive,	"buffer",		SETTING_READ,	TYPE_SHORT,	0,			0xffff,			1,				2,		&tape->capabilities.buffer_size,	NULL);
+	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
+			1, 2, (u16 *)&tape->caps[16], NULL);
 	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
 	ide_add_setting(drive,	"pipeline",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_stages,			NULL);
 	ide_add_setting(drive,	"pipeline_max",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_pipeline,			NULL);
 	ide_add_setting(drive,	"pipeline_used",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_stages,			NULL);
 	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
-	ide_add_setting(drive,	"speed",		SETTING_READ,	TYPE_SHORT,	0,			0xffff,			1,				1,		&tape->capabilities.speed,		NULL);
+	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
+			1, 1, (u16 *)&tape->caps[14], NULL);
 	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
 	ide_add_setting(drive,	"tdsc",			SETTING_RW,	TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,		&tape->best_dsc_rw_frequency,		NULL);
 	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
@@ -3841,6 +3814,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	struct idetape_id_gcw gcw;
 	int stage_size;
 	struct sysinfo si;
+	u16 *ctl = (u16 *)&tape->caps[12];
 
 	spin_lock_init(&tape->spinlock);
 	drive->dsc_overlap = 1;
@@ -3870,11 +3844,11 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	idetape_get_mode_sense_results(drive);
 	idetape_get_blocksize_from_block_descriptor(drive);
 	tape->user_bs_factor = 1;
-	tape->stage_size = tape->capabilities.ctl * tape->tape_block_size;
+	tape->stage_size = *ctl * tape->tape_block_size;
 	while (tape->stage_size > 0xffff) {
 		printk(KERN_NOTICE "ide-tape: decreasing stage size\n");
-		tape->capabilities.ctl /= 2;
-		tape->stage_size = tape->capabilities.ctl * tape->tape_block_size;
+		*ctl /= 2;
+		tape->stage_size = *ctl * tape->tape_block_size;
 	}
 	stage_size = tape->stage_size;
 	tape->pages_per_stage = stage_size / PAGE_SIZE;
@@ -3883,11 +3857,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->excess_bh_size = PAGE_SIZE - stage_size % PAGE_SIZE;
 	}
 
-	/*
-	 *	Select the "best" DSC read/write polling frequency
-	 *	and pipeline size.
-	 */
-	speed = max(tape->capabilities.speed, tape->capabilities.max_speed);
+	/* Select the "best" DSC read/write polling freq and pipeline size. */
+	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
 
 	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
 
@@ -3904,7 +3875,7 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->max_stages = tape->min_pipeline = tape->max_pipeline = 1;
 
 	t1 = (tape->stage_size * HZ) / (speed * 1000);
-	tmid = (tape->capabilities.buffer_size * 32 * HZ) / (speed * 125);
+	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
 	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
 
 	if (tape->max_stages)
@@ -3919,8 +3890,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->best_dsc_rw_frequency = max_t(unsigned long, min_t(unsigned long, t, IDETAPE_DSC_RW_MAX), IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
-		drive->name, tape->name, tape->capabilities.speed,
-		(tape->capabilities.buffer_size * 512) / tape->stage_size,
+		drive->name, tape->name, *(u16 *)&tape->caps[14],
+		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
 		tape->stage_size / 1024,
 		tape->max_stages * tape->stage_size / 1024,
 		tape->best_dsc_rw_frequency * 1000 / HZ,
-- 
1.5.3.7

