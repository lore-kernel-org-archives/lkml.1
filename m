Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYACNYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYACNYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYACNXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:23:19 -0500
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:26812 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752729AbYACNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:23:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=P2uW/iJ5JiRVFckIS+SkdDU0VssbpXfXeb1RmrSx1ODr90B31Xv2QA7ui0TAO4LlwYco680eh5uBL2aPgRdOvX+tE81JumMKNWdxuGG4JHcO864xaWRb+pWZXdLqP9+OLA3vIH/h7tzL59u74rneWWXpzp54fCa1mE4feFiocyM=  ;
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bzolnier@gmail.com, Borislav Petkov <bbpetkov@yahoo.de>
Subject: [RESEND PATCH 02/10] ide-floppy: move ide-floppy struct and macro defs into its own header. While at it
Date: Thu,  3 Jan 2008 14:20:01 +0100
Message-Id: <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de>
 <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- do a white-space cleanup
- remove old crufty code untouched since at least 2005
- shorten lines longer than 80ish columns
- shorten some LAAARGE typenames.

There should be no functional changes resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  763 ++++++++++++----------------------------------
 drivers/ide/ide-floppy.h |  382 +++++++++++++++++++++++
 2 files changed, 581 insertions(+), 564 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 785fbde..52d09c1 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -44,418 +44,7 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
-/*
- *	The following are used to debug the driver.
- */
-#define IDEFLOPPY_DEBUG_LOG		0
-#define IDEFLOPPY_DEBUG_INFO		0
-#define IDEFLOPPY_DEBUG_BUGS		1
-
-/* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
-#define IDEFLOPPY_DEBUG( fmt, args... )
-
-#if IDEFLOPPY_DEBUG_LOG
-#define debug_log printk
-#else
-#define debug_log(fmt, args... ) do {} while(0)
-#endif
-
-
-/*
- *	Some drives require a longer irq timeout.
- */
-#define IDEFLOPPY_WAIT_CMD		(5 * WAIT_CMD)
-
-/*
- *	After each failed packet command we issue a request sense command
- *	and retry the packet command IDEFLOPPY_MAX_PC_RETRIES times.
- */
-#define IDEFLOPPY_MAX_PC_RETRIES	3
-
-/*
- *	With each packet command, we allocate a buffer of
- *	IDEFLOPPY_PC_BUFFER_SIZE bytes.
- */
-#define IDEFLOPPY_PC_BUFFER_SIZE	256
-
-/*
- *	In various places in the driver, we need to allocate storage
- *	for packet commands and requests, which will remain valid while
- *	we leave the driver to wait for an interrupt or a timeout event.
- */
-#define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
-
-/*
- *	Our view of a packet command.
- */
-typedef struct idefloppy_packet_command_s {
-	u8 c[12];				/* Actual packet bytes */
-	int retries;				/* On each retry, we increment retries */
-	int error;				/* Error code */
-	int request_transfer;			/* Bytes to transfer */
-	int actually_transferred;		/* Bytes actually transferred */
-	int buffer_size;			/* Size of our data buffer */
-	int b_count;				/* Missing/Available data on the current buffer */
-	struct request *rq;			/* The corresponding request */
-	u8 *buffer;				/* Data buffer */
-	u8 *current_position;			/* Pointer into the above buffer */
-	void (*callback) (ide_drive_t *);	/* Called when this packet command is completed */
-	u8 pc_buffer[IDEFLOPPY_PC_BUFFER_SIZE];	/* Temporary buffer */
-	unsigned long flags;			/* Status/Action bit flags: long for set_bit */
-} idefloppy_pc_t;
-
-/*
- *	Packet command flag bits.
- */
-#define	PC_ABORT			0	/* Set when an error is considered normal - We won't retry */
-#define PC_DMA_RECOMMENDED		2	/* 1 when we prefer to use DMA if possible */
-#define	PC_DMA_IN_PROGRESS		3	/* 1 while DMA in progress */
-#define	PC_DMA_ERROR			4	/* 1 when encountered problem during DMA */
-#define	PC_WRITING			5	/* Data direction */
-
-#define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
-
-/*
- *	Removable Block Access Capabilities Page
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;	/* Should be 0 */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	ps		:1;	/* Should be 0 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		page_length;		/* Page Length - Should be 0xa */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	reserved2	:6;
-	unsigned	srfp		:1;	/* Supports reporting progress of format */
-	unsigned	sflp		:1;	/* System floppy type device */
-	unsigned	tlun		:3;	/* Total logical units supported by the device */
-	unsigned	reserved3	:3;
-	unsigned	sml		:1;	/* Single / Multiple lun supported */
-	unsigned	ncd		:1;	/* Non cd optical device */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	sflp		:1;	/* System floppy type device */
-	unsigned	srfp		:1;	/* Supports reporting progress of format */
-	unsigned	reserved2	:6;
-	unsigned	ncd		:1;	/* Non cd optical device */
-	unsigned	sml		:1;	/* Single / Multiple lun supported */
-	unsigned	reserved3	:3;
-	unsigned	tlun		:3;	/* Total logical units supported by the device */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		reserved[8];
-} idefloppy_capabilities_page_t;
-
-/*
- *	Flexible disk page.
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;	/* The device is capable of saving the page */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	ps		:1;	/* The device is capable of saving the page */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		page_length;		/* Page Length - Should be 0x1e */
-	u16		transfer_rate;		/* In kilobits per second */
-	u8		heads, sectors;		/* Number of heads, Number of sectors per track */
-	u16		sector_size;		/* Byes per sector */
-	u16		cyls;			/* Number of cylinders */
-	u8		reserved10[10];
-	u8		motor_delay;		/* Motor off delay */
-	u8		reserved21[7];
-	u16		rpm;			/* Rotations per minute */
-	u8		reserved30[2];
-} idefloppy_flexible_disk_page_t;
- 
-/*
- *	Format capacity
- */
-typedef struct {
-	u8		reserved[3];
-	u8		length;			/* Length of the following descriptors in bytes */
-} idefloppy_capacity_header_t;
-
-typedef struct {
-	u32		blocks;			/* Number of blocks */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	dc		:2;	/* Descriptor Code */
-	unsigned	reserved	:6;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	reserved	:6;
-	unsigned	dc		:2;	/* Descriptor Code */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		length_msb;		/* Block Length (MSB)*/
-	u16		length;			/* Block Length */
-} idefloppy_capacity_descriptor_t;
-
-#define CAPACITY_INVALID	0x00
-#define CAPACITY_UNFORMATTED	0x01
-#define CAPACITY_CURRENT	0x02
-#define CAPACITY_NO_CARTRIDGE	0x03
-
-/*
- *	Most of our global data which we need to save even as we leave the
- *	driver due to an interrupt or a timer event is stored in a variable
- *	of type idefloppy_floppy_t, defined below.
- */
-typedef struct ide_floppy_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
-
-	/* Current packet command */
-	idefloppy_pc_t *pc;
-	/* Last failed packet command */
-	idefloppy_pc_t *failed_pc;
-	/* Packet command stack */
-	idefloppy_pc_t pc_stack[IDEFLOPPY_PC_STACK];
-	/* Next free packet command storage space */
-	int pc_stack_index;
-	struct request rq_stack[IDEFLOPPY_PC_STACK];
-	/* We implement a circular array */
-	int rq_stack_index;
-
-	/*
-	 *	Last error information
-	 */
-	u8 sense_key, asc, ascq;
-	/* delay this long before sending packet command */
-	u8 ticks;
-	int progress_indication;
-
-	/*
-	 *	Device information
-	 */
-	/* Current format */
-	int blocks, block_size, bs_factor;
-	/* Last format capacity */
-	idefloppy_capacity_descriptor_t capacity;
-	/* Copy of the flexible disk page */
-	idefloppy_flexible_disk_page_t flexible_disk_page;
-	/* Write protect */
-	int wp;
-	/* Supports format progress report */
-	int srfp;
-	/* Status/Action flags */
-	unsigned long flags;
-} idefloppy_floppy_t;
-
-#define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
-
-/*
- *	Floppy flag bits values.
- */
-#define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
-#define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
-#define IDEFLOPPY_USE_READ12		2	/* Use READ12/WRITE12 or READ10/WRITE10 */
-#define	IDEFLOPPY_FORMAT_IN_PROGRESS	3	/* Format in progress */
-#define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported in Clik drive */
-#define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for packets */
-
-/*
- *	ATAPI floppy drive packet commands
- */
-#define IDEFLOPPY_FORMAT_UNIT_CMD	0x04
-#define IDEFLOPPY_INQUIRY_CMD		0x12
-#define IDEFLOPPY_MODE_SELECT_CMD	0x55
-#define IDEFLOPPY_MODE_SENSE_CMD	0x5a
-#define IDEFLOPPY_READ10_CMD		0x28
-#define IDEFLOPPY_READ12_CMD		0xa8
-#define IDEFLOPPY_READ_CAPACITY_CMD	0x23
-#define IDEFLOPPY_REQUEST_SENSE_CMD	0x03
-#define IDEFLOPPY_PREVENT_REMOVAL_CMD	0x1e
-#define IDEFLOPPY_SEEK_CMD		0x2b
-#define IDEFLOPPY_START_STOP_CMD	0x1b
-#define IDEFLOPPY_TEST_UNIT_READY_CMD	0x00
-#define IDEFLOPPY_VERIFY_CMD		0x2f
-#define IDEFLOPPY_WRITE10_CMD		0x2a
-#define IDEFLOPPY_WRITE12_CMD		0xaa
-#define IDEFLOPPY_WRITE_VERIFY_CMD	0x2e
-
-/*
- *	Defines for the mode sense command
- */
-#define MODE_SENSE_CURRENT		0x00
-#define MODE_SENSE_CHANGEABLE		0x01
-#define MODE_SENSE_DEFAULT		0x02 
-#define MODE_SENSE_SAVED		0x03
-
-/*
- *	IOCTLs used in low-level formatting.
- */
-
-#define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
-#define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
-#define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
-#define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
-
-#if 0
-/*
- *	Special requests for our block device strategy routine.
- */
-#define	IDEFLOPPY_FIRST_RQ	90
-
-/*
- * 	IDEFLOPPY_PC_RQ is used to queue a packet command in the request queue.
- */
-#define	IDEFLOPPY_PC_RQ		90
-
-#define IDEFLOPPY_LAST_RQ	90
-
-/*
- *	A macro which can be used to check if a given request command
- *	originated in the driver or in the buffer cache layer.
- */
-#define IDEFLOPPY_RQ_CMD(cmd) 	((cmd >= IDEFLOPPY_FIRST_RQ) && (cmd <= IDEFLOPPY_LAST_RQ))
-
-#endif
-
-/*
- *	Error codes which are returned in rq->errors to the higher part
- *	of the driver.
- */
-#define	IDEFLOPPY_ERROR_GENERAL		101
-
-/*
- *	The following is used to format the general configuration word of
- *	the ATAPI IDENTIFY DEVICE command.
- */
-struct idefloppy_id_gcw {	
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned packet_size		:2;	/* Packet Size */
-	unsigned reserved234		:3;	/* Reserved */
-	unsigned drq_type		:2;	/* Command packet DRQ type */
-	unsigned removable		:1;	/* Removable media */
-	unsigned device_type		:5;	/* Device type */
-	unsigned reserved13		:1;	/* Reserved */
-	unsigned protocol		:2;	/* Protocol type */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned protocol		:2;	/* Protocol type */
-	unsigned reserved13		:1;	/* Reserved */
-	unsigned device_type		:5;	/* Device type */
-	unsigned removable		:1;	/* Removable media */
-	unsigned drq_type		:2;	/* Command packet DRQ type */
-	unsigned reserved234		:3;	/* Reserved */
-	unsigned packet_size		:2;	/* Packet Size */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-};
-
-/*
- *	INQUIRY packet command - Data Format
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	response_format :4;	/* Response Data Format */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	response_format :4;	/* Response Data Format */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		additional_length;	/* Additional Length (total_length-4) */
-	u8		rsv5, rsv6, rsv7;	/* Reserved */
-	u8		vendor_id[8];		/* Vendor Identification */
-	u8		product_id[16];		/* Product Identification */
-	u8		revision_level[4];	/* Revision Level */
-	u8		vendor_specific[20];	/* Vendor Specific - Optional */
-	u8		reserved56t95[40];	/* Reserved - Optional */
-						/* Additional information may be returned */
-} idefloppy_inquiry_result_t;
-
-/*
- *	REQUEST SENSE packet command result - Data Format.
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	error_code	:7;	/* Current error (0x70) */
-	unsigned	valid		:1;	/* The information field conforms to SFF-8070i */
-	u8		reserved1	:8;	/* Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	reserved2_67	:2;
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	valid		:1;	/* The information field conforms to SFF-8070i */
-	unsigned	error_code	:7;	/* Current error (0x70) */
-	u8		reserved1	:8;	/* Reserved */
-	unsigned	reserved2_67	:2;
-	unsigned	ili		:1;	/* Incorrect Length Indicator */
-	unsigned	reserved2_4	:1;	/* Reserved */
-	unsigned	sense_key	:4;	/* Sense Key */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u32		information __attribute__ ((packed));
-	u8		asl;			/* Additional sense length (n-7) */
-	u32		command_specific;	/* Additional command specific information */
-	u8		asc;			/* Additional Sense Code */
-	u8		ascq;			/* Additional Sense Code Qualifier */
-	u8		replaceable_unit_code;	/* Field Replaceable Unit Code */
-	u8		sksv[3];
-	u8		pad[2];			/* Padding to 20 bytes */
-} idefloppy_request_sense_result_t;
-
-/*
- *	Pages of the SELECT SENSE / MODE SENSE packet commands.
- */
-#define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
-#define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
-
-/*
- *	Mode Parameter Header for the MODE SENSE packet command
- */
-typedef struct {
-	u16		mode_data_length;	/* Length of the following data transfer */
-	u8		medium_type;		/* Medium Type */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	reserved3	:7;
-	unsigned	wp		:1;	/* Write protect */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	wp		:1;	/* Write protect */
-	unsigned	reserved3	:7;
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		reserved[4];
-} idefloppy_mode_parameter_header_t;
+#include "ide-floppy.h"
 
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
@@ -512,7 +101,7 @@ static void idefloppy_write_zeros (ide_drive_t *drive, unsigned int bcount)
  */
 static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
@@ -539,7 +128,8 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
+static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc,
+		unsigned int bcount)
 {
 	struct request *rq = pc->rq;
 	struct bio_vec *bvec;
@@ -566,12 +156,14 @@ static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, uns
 	idefloppy_do_end_request(drive, 1, done >> 9);
 
 	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in idefloppy_input_buffers, bcount == %d\n", drive->name, bcount);
+		printk(KERN_ERR "%s: leftover data in idefloppy_input_buffers,"
+				" bcount == %d\n", drive->name, bcount);
 		idefloppy_discard_data(drive, bcount);
 	}
 }
 
-static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
+static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc,
+		unsigned int bcount)
 {
 	struct request *rq = pc->rq;
 	struct req_iterator iter;
@@ -599,7 +191,8 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, un
 
 #if IDEFLOPPY_DEBUG_BUGS
 	if (bcount) {
-		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers, bcount == %d\n", drive->name, bcount);
+		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers,"
+				" bcount == %d\n", drive->name, bcount);
 		idefloppy_write_zeros(drive, bcount);
 	}
 #endif
@@ -619,7 +212,8 @@ static void idefloppy_update_buffers (ide_drive_t *drive, idefloppy_pc_t *pc)
  *	of the request queue, before the current request, so that it will be
  *	processed immediately, on the next pass through the driver.
  */
-static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,struct request *rq)
+static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,
+		struct request *rq)
 {
 	struct ide_floppy_obj *floppy = drive->driver_data;
 
@@ -632,7 +226,7 @@ static void idefloppy_queue_pc_head (ide_drive_t *drive,idefloppy_pc_t *pc,struc
 
 static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 
 	if (floppy->pc_stack_index == IDEFLOPPY_PC_STACK)
 		floppy->pc_stack_index=0;
@@ -641,7 +235,7 @@ static idefloppy_pc_t *idefloppy_next_pc_storage (ide_drive_t *drive)
 
 static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 
 	if (floppy->rq_stack_index == IDEFLOPPY_PC_STACK)
 		floppy->rq_stack_index = 0;
@@ -652,9 +246,10 @@ static struct request *idefloppy_next_rq_storage (ide_drive_t *drive)
  *	idefloppy_analyze_error is called on each failed packet command retry
  *	to analyze the request sense.
  */
-static void idefloppy_analyze_error (ide_drive_t *drive,idefloppy_request_sense_result_t *result)
+static void idefloppy_analyze_error (ide_drive_t *drive,
+		rq_sense_res_t *result)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 
 	floppy->sense_key = result->sense_key;
 	floppy->asc = result->asc;
@@ -673,15 +268,18 @@ static void idefloppy_analyze_error (ide_drive_t *drive,idefloppy_request_sense_
 
 static void idefloppy_request_sense_callback (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
+	u8 *buf = floppy->pc->buffer;
 
 	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
-	
+
 	if (!floppy->pc->error) {
-		idefloppy_analyze_error(drive,(idefloppy_request_sense_result_t *) floppy->pc->buffer);
+		idefloppy_analyze_error(drive, (rq_sense_res_t *) buf);
 		idefloppy_do_end_request(drive, 1, 0);
 	} else {
-		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting request!\n");
+		printk(KERN_ERR "Error in REQUEST SENSE itself - "
+				"Aborting request!\n");
+
 		idefloppy_do_end_request(drive, 0, 0);
 	}
 }
@@ -691,8 +289,8 @@ static void idefloppy_request_sense_callback (ide_drive_t *drive)
  */
 static void idefloppy_pc_callback (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	
+	idefloppy_t *floppy = drive->driver_data;
+
 	debug_log(KERN_INFO "ide-floppy: Reached %s\n", __FUNCTION__);
 
 	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
@@ -714,7 +312,7 @@ static void idefloppy_init_pc (idefloppy_pc_t *pc)
 
 static void idefloppy_create_request_sense_cmd (idefloppy_pc_t *pc)
 {
-	idefloppy_init_pc(pc);	
+	idefloppy_init_pc(pc);
 	pc->c[0] = IDEFLOPPY_REQUEST_SENSE_CMD;
 	pc->c[4] = 255;
 	pc->request_transfer = 18;
@@ -745,7 +343,7 @@ static void idefloppy_retry_pc (ide_drive_t *drive)
  */
 static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	atapi_status_t status;
 	atapi_bcount_t bcount;
 	atapi_ireason_t ireason;
@@ -867,7 +465,9 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 	pc->current_position += bcount.all;
 
 	BUG_ON(HWGROUP(drive)->handler != NULL);
-	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);		/* And set the interrupt handler again */
+
+	/* And set the interrupt handler again */
+	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
 	return ide_started;
 }
 
@@ -879,7 +479,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
 static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
 {
 	ide_startstop_t startstop;
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	atapi_ireason_t ireason;
 
 	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
@@ -910,13 +510,13 @@ static ide_startstop_t idefloppy_transfer_pc (ide_drive_t *drive)
  * gets in trouble.
  *
  * So, follow carefully. transfer_pc1 is called as an interrupt (or
- * directly). In either case, when the device says it's ready for a 
+ * directly). In either case, when the device says it's ready for a
  * packet, we schedule the packet transfer to occur about 2-3 ticks
  * later in transfer_pc2.
  */
 static int idefloppy_transfer_pc2 (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 
 	/* Send the actual packet */
 	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
@@ -926,7 +526,7 @@ static int idefloppy_transfer_pc2 (ide_drive_t *drive)
 
 static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	ide_startstop_t startstop;
 	atapi_ireason_t ireason;
 
@@ -941,7 +541,7 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 				"while issuing a packet command\n");
 		return ide_do_reset(drive);
 	}
-	/* 
+	/*
 	 * The following delay solves a problem with ATAPI Zip 100 drives
 	 * where the Busy flag was apparently being deasserted before the
 	 * unit was ready to receive data. This was happening on a
@@ -950,8 +550,8 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
 	 * used until after the packet is moved in about 50 msec.
 	 */
 	BUG_ON(HWGROUP(drive)->handler != NULL);
-	ide_set_handler(drive, 
-	  &idefloppy_pc_intr, 		/* service routine for packet command */
+	ide_set_handler(drive,
+	  &idefloppy_pc_intr,		/* service routine for packet command */
 	  floppy->ticks,		/* wait this long before "failing" */
 	  &idefloppy_transfer_pc2);	/* fail == transfer_pc2 */
 	return ide_started;
@@ -962,7 +562,7 @@ static ide_startstop_t idefloppy_transfer_pc1 (ide_drive_t *drive)
  *
  * Supresses error messages resulting from Medium not present
  */
-static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
+static inline int idefloppy_should_report_error(idefloppy_t *floppy)
 {
 	if (floppy->sense_key == 0x02 &&
 	    floppy->asc       == 0x3a &&
@@ -976,7 +576,7 @@ static inline int idefloppy_should_report_error(idefloppy_floppy_t *floppy)
  */
 static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *pc)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	atapi_feature_t feature;
 	atapi_bcount_t bcount;
@@ -1061,7 +661,7 @@ static ide_startstop_t idefloppy_issue_pc (ide_drive_t *drive, idefloppy_pc_t *p
 		/* immediate */
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
-	
+
 	if (test_bit (IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
@@ -1127,10 +727,11 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
 /*
  *	A mode sense command is used to "sense" floppy parameters.
  */
-static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code, u8 type)
+static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code,
+		u8 type)
 {
-	u16 length = sizeof(idefloppy_mode_parameter_header_t);
-	
+	u16 length = sizeof(idefloppy_mode_par_hdr_t);
+
 	idefloppy_init_pc(pc);
 	pc->c[0] = IDEFLOPPY_MODE_SENSE_CMD;
 	pc->c[1] = 0;
@@ -1164,7 +765,8 @@ static void idefloppy_create_test_unit_ready_cmd(idefloppy_pc_t *pc)
 	pc->c[0] = IDEFLOPPY_TEST_UNIT_READY_CMD;
 }
 
-static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq, unsigned long sector)
+static void idefloppy_create_rw_cmd (idefloppy_t *floppy, idefloppy_pc_t *pc,
+		struct request *rq, unsigned long sector)
 {
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
@@ -1194,7 +796,7 @@ static void idefloppy_create_rw_cmd (idefloppy_floppy_t *floppy, idefloppy_pc_t
 }
 
 static void
-idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
+idefloppy_blockpc_cmd(idefloppy_t *floppy, idefloppy_pc_t *pc, struct request *rq)
 {
 	idefloppy_init_pc(pc);
 	pc->callback = &idefloppy_rw_callback;
@@ -1206,7 +808,7 @@ idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct req
 	pc->buffer = rq->data;
 	if (rq->bio)
 		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
-		
+
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
 	 * handled scattered requests if dma fails...
@@ -1215,11 +817,12 @@ idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy, idefloppy_pc_t *pc, struct req
 }
 
 /*
- *	idefloppy_do_request is our request handling function.	
+ *	idefloppy_do_request is our request handling function.
  */
-static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request *rq, sector_t block_s)
+static ide_startstop_t idefloppy_do_request (ide_drive_t *drive,
+		struct request *rq, sector_t block_s)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t *pc;
 	unsigned long block = (unsigned long)block_s;
 
@@ -1233,10 +836,14 @@ static ide_startstop_t idefloppy_do_request (ide_drive_t *drive, struct request
 	if (rq->errors >= ERROR_MAX) {
 		if (floppy->failed_pc != NULL) {
 			if (idefloppy_should_report_error(floppy))
-				printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x,"
-				       " key = %2x, asc = %2x, ascq = %2x\n",
-				       drive->name, floppy->failed_pc->c[0],
-				       floppy->sense_key, floppy->asc, floppy->ascq);
+				printk(KERN_ERR "ide-floppy: %s: I/O error,"
+					" pc = %2x, key = %2x, asc = %2x,"
+					" ascq = %2x\n",
+				       drive->name,
+				       floppy->failed_pc->c[0],
+				       floppy->sense_key,
+				       floppy->asc,
+				       floppy->ascq);
 		}
 		else
 			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
@@ -1293,55 +900,62 @@ static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
  */
 static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
-	idefloppy_flexible_disk_page_t *page;
+	idefloppy_mode_par_hdr_t *header;
+	idefloppy_flex_disk_page_t *page;
 	int capacity, lba_capacity;
 
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE, MODE_SENSE_CURRENT);
+	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
+			MODE_SENSE_CURRENT);
 	if (idefloppy_queue_pc_tail(drive,&pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get flexible disk "
 			"page parameters\n");
 		return 1;
 	}
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
+	header = (idefloppy_mode_par_hdr_t *) pc.buffer;
 	floppy->wp = header->wp;
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = (idefloppy_flexible_disk_page_t *) (header + 1);
+	page = (idefloppy_flex_disk_page_t *) (header + 1);
 
 	page->transfer_rate = ntohs(page->transfer_rate);
 	page->sector_size = ntohs(page->sector_size);
 	page->cyls = ntohs(page->cyls);
 	page->rpm = ntohs(page->rpm);
 	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
-	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
+
+	if (memcmp (page, &floppy->flex_disk_page,
+				sizeof (idefloppy_flex_disk_page_t)))
+
 		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
 				"%d sector size, %d rpm\n",
 			drive->name, capacity / 1024, page->cyls,
 			page->heads, page->sectors,
 			page->transfer_rate / 8, page->sector_size, page->rpm);
 
-	floppy->flexible_disk_page = *page;
+	floppy->flex_disk_page = *page;
 	drive->bios_cyl = page->cyls;
 	drive->bios_head = page->heads;
 	drive->bios_sect = page->sectors;
 	lba_capacity = floppy->blocks * floppy->block_size;
+
 	if (capacity < lba_capacity) {
 		printk(KERN_NOTICE "%s: The disk reports a capacity of %d "
 			"bytes, but the drive only handles %d\n",
 			drive->name, lba_capacity, capacity);
-		floppy->blocks = floppy->block_size ? capacity / floppy->block_size : 0;
+		floppy->blocks = floppy->block_size ?
+			capacity / floppy->block_size : 0;
 	}
+
 	return 0;
 }
 
 static int idefloppy_get_capability_page(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
-	idefloppy_capabilities_page_t *page;
+	idefloppy_mode_par_hdr_t *header;
+	idefloppy_cap_page_t *page;
 
 	floppy->srfp = 0;
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
@@ -1352,8 +966,8 @@ static int idefloppy_get_capability_page(ide_drive_t *drive)
 		return 1;
 	}
 
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
-	page= (idefloppy_capabilities_page_t *)(header+1);
+	header = (idefloppy_mode_par_hdr_t *) pc.buffer;
+	page= (idefloppy_cap_page_t *)(header+1);
 	floppy->srfp = page->srfp;
 	return (0);
 }
@@ -1364,12 +978,12 @@ static int idefloppy_get_capability_page(ide_drive_t *drive)
  */
 static int idefloppy_get_capacity (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
 	idefloppy_capacity_header_t *header;
-	idefloppy_capacity_descriptor_t *descriptor;
+	idefloppy_cap_desc_t *descriptor;
 	int i, descriptors, rc = 1, blocks, length;
-	
+
 	drive->bios_cyl = 0;
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
@@ -1382,14 +996,14 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 		return 1;
 	}
 	header = (idefloppy_capacity_header_t *) pc.buffer;
-	descriptors = header->length / sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+	descriptors = header->length / sizeof(idefloppy_cap_desc_t);
+	descriptor = (idefloppy_cap_desc_t *) (header + 1);
 
 	for (i = 0; i < descriptors; i++, descriptor++) {
 		blocks = descriptor->blocks = ntohl(descriptor->blocks);
 		length = descriptor->length = ntohs(descriptor->length);
 
-		if (!i) 
+		if (!i)
 		{
 		switch (descriptor->dc) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
@@ -1402,7 +1016,8 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 				break;
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
-			if (memcmp(descriptor, &floppy->capacity, sizeof (idefloppy_capacity_descriptor_t)))
+			if (memcmp(descriptor, &floppy->capacity,
+						sizeof (idefloppy_cap_desc_t)))
 				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
 					"sector size\n", drive->name,
 					blocks * length / 1024, blocks, length);
@@ -1453,31 +1068,31 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 }
 
 /*
-** Obtain the list of formattable capacities.
-** Very similar to idefloppy_get_capacity, except that we push the capacity
-** descriptors to userland, instead of our own structures.
-**
-** Userland gives us the following structure:
-**
-** struct idefloppy_format_capacities {
-**        int nformats;
-**        struct {
-**                int nblocks;
-**                int blocksize;
-**                } formats[];
-**        } ;
-**
-** userland initializes nformats to the number of allocated formats[]
-** records.  On exit we set nformats to the number of records we've
-** actually initialized.
-**
-*/
+ * Obtain the list of formattable capacities.
+ * Very similar to idefloppy_get_capacity, except that we push the capacity
+ * descriptors to userland, instead of our own structures.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_capacities {
+ *        int nformats;
+ *        struct {
+ *                int nblocks;
+ *                int blocksize;
+ *                } formats[];
+ *        } ;
+ *
+ * userland initializes nformats to the number of allocated formats[]
+ * records.  On exit we set nformats to the number of records we've
+ * actually initialized.
+ *
+ */
 
 static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
         idefloppy_pc_t pc;
 	idefloppy_capacity_header_t *header;
-        idefloppy_capacity_descriptor_t *descriptor;
+        idefloppy_cap_desc_t *descriptor;
 	int i, descriptors, blocks, length;
 	int u_array_size;
 	int u_index;
@@ -1496,17 +1111,17 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
         }
         header = (idefloppy_capacity_header_t *) pc.buffer;
         descriptors = header->length /
-		sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+		sizeof(idefloppy_cap_desc_t);
+	descriptor = (idefloppy_cap_desc_t *) (header + 1);
 
 	u_index = 0;
 	argp = arg + 1;
 
 	/*
-	** We always skip the first capacity descriptor.  That's the
-	** current capacity.  We are interested in the remaining descriptors,
-	** the formattable capacities.
-	*/
+	 * We always skip the first capacity descriptor.  That's the
+	 * current capacity.  We are interested in the remaining descriptors,
+	 * the formattable capacities.
+	 */
 
 	for (i=0; i<descriptors; i++, descriptor++) {
 		if (u_index >= u_array_size)
@@ -1534,20 +1149,20 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 }
 
 /*
-** Send ATAPI_FORMAT_UNIT to the drive.
-**
-** Userland gives us the following structure:
-**
-** struct idefloppy_format_command {
-**        int nblocks;
-**        int blocksize;
-**        int flags;
-**        } ;
-**
-** flags is a bitmask, currently, the only defined flag is:
-**
-**        0x01 - verify media after format.
-*/
+ * Send ATAPI_FORMAT_UNIT to the drive.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_command {
+ *        int nblocks;
+ *        int blocksize;
+ *        int flags;
+ *        } ;
+ *
+ * flags is a bitmask, currently, the only defined flag is:
+ *
+ *        0x01 - verify media after format.
+ */
 
 static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
 {
@@ -1573,18 +1188,18 @@ static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
 }
 
 /*
-** Get ATAPI_FORMAT_UNIT progress indication.
-**
-** Userland gives a pointer to an int.  The int is set to a progress
-** indicator 0-65536, with 65536=100%.
-**
-** If the drive does not support format progress indication, we just check
-** the dsc bit, and return either 0 or 65536.
-*/
+ * Get ATAPI_FORMAT_UNIT progress indication.
+ *
+ * Userland gives a pointer to an int.  The int is set to a progress
+ * indicator 0-65536, with 65536=100%.
+ *
+ * If the drive does not support format progress indication, we just check
+ * the dsc bit, and return either 0 or 65536.
+ */
 
 static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
 	int progress_indication = 0x10000;
 
@@ -1622,7 +1237,7 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
  */
 static sector_t idefloppy_capacity (ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	unsigned long capacity = floppy->blocks * floppy->bs_factor;
 
 	return capacity;
@@ -1647,7 +1262,7 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	if ((gcw.device_type == 5) &&
 	    !strstr(id->model, "CD-ROM") &&
 	    strstr(id->model, "ZIP"))
-		gcw.device_type = 0;			
+		gcw.device_type = 0;
 #endif
 
 #if IDEFLOPPY_DEBUG_INFO
@@ -1669,7 +1284,7 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 		default: sprintf(buffer, "Reserved");
 	}
 	printk(KERN_INFO "Device Type: %x - %s\n", gcw.device_type, buffer);
-	printk(KERN_INFO "Removable: %s\n",gcw.removable ? "Yes":"No");	
+	printk(KERN_INFO "Removable: %s\n",gcw.removable ? "Yes":"No");
 	switch (gcw.drq_type) {
 		case 0: sprintf(buffer, "Microprocessor DRQ");break;
 		case 1: sprintf(buffer, "Interrupt DRQ");break;
@@ -1689,9 +1304,12 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	printk(KERN_INFO "Write buffer size(?): %d bytes\n",id->buf_size*512);
 	printk(KERN_INFO "DMA: %s",id->capability & 0x01 ? "Yes\n":"No\n");
 	printk(KERN_INFO "LBA: %s",id->capability & 0x02 ? "Yes\n":"No\n");
-	printk(KERN_INFO "IORDY can be disabled: %s",id->capability & 0x04 ? "Yes\n":"No\n");
-	printk(KERN_INFO "IORDY supported: %s",id->capability & 0x08 ? "Yes\n":"Unknown\n");
-	printk(KERN_INFO "ATAPI overlap supported: %s",id->capability & 0x20 ? "Yes\n":"No\n");
+	printk(KERN_INFO "IORDY can be disabled: %s",
+			id->capability & 0x04 ? "Yes\n":"No\n");
+	printk(KERN_INFO "IORDY supported: %s",
+			id->capability & 0x08 ? "Yes\n":"Unknown\n");
+	printk(KERN_INFO "ATAPI overlap supported: %s",
+			id->capability & 0x20 ? "Yes\n":"No\n");
 	printk(KERN_INFO "PIO Cycle Timing Category: %d\n",id->tPIO);
 	printk(KERN_INFO "DMA Cycle Timing Category: %d\n",id->tDMA);
 	printk(KERN_INFO "Single Word DMA supported modes:\n");
@@ -1713,12 +1331,16 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 			sprintf(buffer, "Not supported");
 		else
 			sprintf(buffer, "%d ns",id->eide_dma_min);
-		printk(KERN_INFO "Minimum Multi-word DMA cycle per word: %s\n", buffer);
+		printk(KERN_INFO "Minimum Multi-word DMA cycle per word: %s\n",
+				buffer);
+
 		if (id->eide_dma_time == 0)
 			sprintf(buffer, "Not supported");
 		else
 			sprintf(buffer, "%d ns",id->eide_dma_time);
-		printk(KERN_INFO "Manufacturer\'s Recommended Multi-word cycle: %s\n", buffer);
+		printk(KERN_INFO "Manufacturer\'s Recommended Multi-word"
+				" cycle: %s\n", buffer);
+
 		if (id->eide_pio == 0)
 			sprintf(buffer, "Not supported");
 		else
@@ -1731,7 +1353,8 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 			sprintf(buffer, "%d ns",id->eide_pio_iordy);
 		printk(KERN_INFO "Minimum PIO cycle with IORDY: %s\n", buffer);
 	} else
-		printk(KERN_INFO "According to the device, fields 64-70 are not valid.\n");
+		printk(KERN_INFO "According to the device, fields 64-70 are not"
+				" valid.\n");
 #endif /* IDEFLOPPY_DEBUG_INFO */
 
 	if (gcw.protocol != 2)
@@ -1741,7 +1364,8 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
 	else if (gcw.drq_type == 3) {
-		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not supported\n", gcw.drq_type);
+		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not supported\n",
+				gcw.drq_type);
 	} else if (gcw.packet_size != 0) {
 		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes long\n");
 	} else
@@ -1752,15 +1376,23 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 #ifdef CONFIG_IDE_PROC_FS
 static void idefloppy_add_settings(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 
-/*
- *			drive	setting name	read/write	data type	min	max	mul_factor	div_factor	data pointer		set function
- */
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	1023,		1,		1,	&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,		1,		1,	&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,		1,		1,	&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"ticks",	SETTING_RW,	TYPE_BYTE,	0,	255,		1,		1,	&floppy->ticks,		NULL);
+	/*
+	 * drive setting name read/write data_type min max mul_factor div_factor
+	 *		data_pointer set_function
+	 */
+	ide_add_setting(drive, "bios_cyl",  SETTING_RW, TYPE_INT, 0, 1023, 1, 1,
+			&drive->bios_cyl, NULL);
+
+	ide_add_setting(drive, "bios_head", SETTING_RW,	TYPE_BYTE,0,  255, 1, 1,
+			&drive->bios_head,NULL);
+
+	ide_add_setting(drive, "bios_sect", SETTING_RW,	TYPE_BYTE,0,   63, 1, 1,
+			&drive->bios_sect,NULL);
+
+	ide_add_setting(drive, "ticks",     SETTING_RW,	TYPE_BYTE,0,  255, 1, 1,
+			&floppy->ticks,   NULL);
 }
 #else
 static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
@@ -1769,7 +1401,7 @@ static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
 /*
  *	Driver initialization.
  */
-static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
+static void idefloppy_setup (ide_drive_t *drive, idefloppy_t *floppy)
 {
 	struct idefloppy_id_gcw gcw;
 
@@ -1805,14 +1437,13 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
 	}
 
-
 	(void) idefloppy_get_capacity(drive);
 	idefloppy_add_settings(drive);
 }
 
 static void ide_floppy_remove(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	idefloppy_t *floppy = drive->driver_data;
 	struct gendisk *g = floppy->disk;
 
 	ide_proc_unregister_driver(drive, floppy->driver);
@@ -1846,8 +1477,8 @@ static int proc_idefloppy_read_capacity
 }
 
 static ide_proc_entry_t idefloppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO,	proc_idefloppy_read_capacity, NULL },
-	{ "geometry",	S_IFREG|S_IRUGO,	proc_ide_read_geometry,	NULL },
+	{ "capacity", S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
+	{ "geometry", S_IFREG|S_IRUGO, proc_ide_read_geometry,		NULL },
 	{ NULL, 0, NULL, NULL }
 };
 #endif	/* CONFIG_IDE_PROC_FS */
@@ -1904,10 +1535,10 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		if (idefloppy_get_capacity (drive)
 		   && (filp->f_flags & O_NDELAY) == 0
 		    /*
-		    ** Allow O_NDELAY to open a drive without a disk, or with
-		    ** an unreadable disk, so that we can get the format
-		    ** capacity of the drive or begin the format - Sam
-		    */
+		     * Allow O_NDELAY to open a drive without a disk, or with
+		     * an unreadable disk, so that we can get the format
+		     * capacity of the drive or begin the format - Sam
+		     */
 		    ) {
 			ret = -EIO;
 			goto out_put_floppy;
@@ -1942,7 +1573,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
 	ide_drive_t *drive = floppy->drive;
 	idefloppy_pc_t pc;
-	
+
 	debug_log(KERN_INFO "Reached idefloppy_release\n");
 
 	if (floppy->openers == 1) {
@@ -1992,7 +1623,8 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 		if (floppy->openers > 1)
 			return -EBUSY;
 
-		/* The IOMEGA Clik! Drive doesn't support this command - no room for an eject mechanism */
+		/* The IOMEGA Clik! Drive doesn't support this command -
+		 * no room for an eject mechanism */
                 if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
 			idefloppy_create_prevent_cmd(&pc, prevent);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
@@ -2012,8 +1644,8 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			return -EPERM;
 
 		if (floppy->openers > 1) {
-			/* Don't format if someone is using the disk */
 
+			/* Don't format if someone is using the disk */
 			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS,
 				  &floppy->flags);
 			return -EBUSY;
@@ -2026,11 +1658,11 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
 		return err;
 		/*
-		** Note, the bit will be cleared when the device is
-		** closed.  This is the cleanest way to handle the
-		** situation where the drive does not support
-		** format progress reporting.
-		*/
+		 * Note, the bit will be cleared when the device is
+		 * closed.  This is the cleanest way to handle the
+		 * situation where the drive does not support
+		 * format progress reporting.
+		 */
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
 		return idefloppy_get_format_progress(drive, argp);
 	}
@@ -2083,7 +1715,7 @@ static struct block_device_operations idefloppy_ops = {
 
 static int ide_floppy_probe(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy;
+	idefloppy_t *floppy;
 	struct gendisk *g;
 
 	if (!strstr("ide-floppy", drive->driver_req))
@@ -2093,15 +1725,18 @@ static int ide_floppy_probe(ide_drive_t *drive)
 	if (drive->media != ide_floppy)
 		goto failed;
 	if (!idefloppy_identify_device (drive, drive->id)) {
-		printk (KERN_ERR "ide-floppy: %s: not supported by this version of ide-floppy\n", drive->name);
+		printk (KERN_ERR "ide-floppy: %s: not supported by this version"
+				" of ide-floppy\n", drive->name);
 		goto failed;
 	}
 	if (drive->scsi) {
-		printk("ide-floppy: passing drive %s to ide-scsi emulation.\n", drive->name);
+		printk("ide-floppy: passing drive %s to ide-scsi emulation.\n",
+				drive->name);
 		goto failed;
 	}
-	if ((floppy = kzalloc(sizeof (idefloppy_floppy_t), GFP_KERNEL)) == NULL) {
-		printk (KERN_ERR "ide-floppy: %s: Can't allocate a floppy structure\n", drive->name);
+	if ((floppy = kzalloc(sizeof (idefloppy_t), GFP_KERNEL)) == NULL) {
+		printk (KERN_ERR "ide-floppy: %s: Can't allocate a floppy"
+				" structure\n", drive->name);
 		goto failed;
 	}
 
diff --git a/drivers/ide/ide-floppy.h b/drivers/ide/ide-floppy.h
new file mode 100644
index 0000000..ecfafa6
--- /dev/null
+++ b/drivers/ide/ide-floppy.h
@@ -0,0 +1,382 @@
+#ifndef _IDE_FLOPPY_H
+#define _IDE_FLOPPY_H
+
+/*
+ *	The following are used to debug the driver.
+ */
+#define IDEFLOPPY_DEBUG_LOG		0
+#define IDEFLOPPY_DEBUG_INFO		0
+#define IDEFLOPPY_DEBUG_BUGS		1
+
+/* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
+#define IDEFLOPPY_DEBUG( fmt, args... )
+
+#if IDEFLOPPY_DEBUG_LOG
+#define debug_log printk
+#else
+#define debug_log(fmt, args... ) do {} while(0)
+#endif
+
+/*
+ *	Some drives require a longer irq timeout.
+ */
+#define IDEFLOPPY_WAIT_CMD		(5 * WAIT_CMD)
+
+/*
+ *	After each failed packet command we issue a request sense command
+ *	and retry the packet command IDEFLOPPY_MAX_PC_RETRIES times.
+ */
+#define IDEFLOPPY_MAX_PC_RETRIES	3
+
+/*
+ *	With each packet command, we allocate a buffer of
+ *	IDEFLOPPY_PC_BUFFER_SIZE bytes.
+ */
+#define IDEFLOPPY_PC_BUFFER_SIZE	256
+
+/*
+ *	In various places in the driver, we need to allocate storage
+ *	for packet commands and requests, which will remain valid while
+ *	we leave the driver to wait for an interrupt or a timeout event.
+ */
+#define IDEFLOPPY_PC_STACK		(10 + IDEFLOPPY_MAX_PC_RETRIES)
+
+/*
+ *	Our view of a packet command.
+ */
+typedef struct idefloppy_packet_command_s {
+	u8 c[12];				/* Actual packet bytes */
+	int retries;				/* On each retry, we increment
+						   retries */
+	int error;				/* Error code */
+	int request_transfer;			/* Bytes to transfer */
+	int actually_transferred;		/* Bytes actually transferred */
+	int buffer_size;			/* Size of our data buffer */
+	int b_count;				/* Missing/Available data on the
+						   current buffer */
+	struct request *rq;			/* The corresponding request */
+	u8 *buffer;				/* Data buffer */
+	u8 *current_position;			/* Pointer into the above buffer */
+	void (*callback) (ide_drive_t *);	/* Called when this packet
+						   command is completed */
+	u8 pc_buffer[IDEFLOPPY_PC_BUFFER_SIZE];	/* Temporary buffer */
+	unsigned long flags;			/* Status/Action bit flags: long
+						   for set_bit */
+} idefloppy_pc_t;
+
+/*
+ *	Packet command flag bits.
+ */
+#define	PC_ABORT			0	/* Set when an error is considered \
+						   normal - We won't retry */
+
+#define PC_DMA_RECOMMENDED		2	/* 1 when we prefer to use DMA \
+						   if possible */
+
+#define	PC_DMA_IN_PROGRESS		3	/* 1 while DMA in progress */
+
+#define	PC_DMA_ERROR			4	/* 1 when encountered problem \
+						   during DMA */
+
+#define	PC_WRITING			5	/* Data direction */
+
+#define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
+
+/*
+ *	Removable Block Access Capabilities Page
+ */
+typedef struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
+	unsigned	reserved1_6	:1;	/* Reserved */
+	unsigned	ps		:1;	/* Should be 0 */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned	ps		:1;	/* Should be 0 */
+	unsigned	reserved1_6	:1;	/* Reserved */
+	unsigned	page_code	:6;	/* Page code - Should be 0x1b */
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+	u8		page_length;		/* Page Length - Should be 0xa */
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned	reserved2	:6;
+	unsigned	srfp		:1;	/* Supports reporting progress
+						   of format */
+	unsigned	sflp		:1;	/* System floppy type device */
+	unsigned	tlun		:3;	/* Total logical units supported
+						   by the device */
+	unsigned	reserved3	:3;
+	unsigned	sml		:1;	/* Single / Multiple lun supported */
+	unsigned	ncd		:1;	/* Non cd optical device */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned	sflp		:1;	/* System floppy type device */
+	unsigned	srfp		:1;	/* Supports reporting progress
+						   of format */
+	unsigned	reserved2	:6;
+	unsigned	ncd		:1;	/* Non cd optical device */
+	unsigned	sml		:1;	/* Single / Multiple lun supported */
+	unsigned	reserved3	:3;
+	unsigned	tlun		:3;	/* Total logical units supported
+						   by the device */
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+	u8		reserved[8];
+} idefloppy_cap_page_t;
+
+/*
+ *	Flexible disk page.
+ */
+typedef struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
+	unsigned	reserved1_6	:1;	/* Reserved */
+	unsigned	ps		:1;	/* The device is capable of
+						   saving the page */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned	ps		:1;	/* The device is capable of
+						   saving the page */
+	unsigned	reserved1_6	:1;	/* Reserved */
+	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+	u8		page_length;		/* Page Length - Should be 0x1e */
+	u16		transfer_rate;		/* In kilobits per second */
+	u8		heads, sectors;		/* Number of heads, Number of
+						   sectors per track */
+	u16		sector_size;		/* Byes per sector */
+	u16		cyls;			/* Number of cylinders */
+	u8		reserved10[10];
+	u8		motor_delay;		/* Motor off delay */
+	u8		reserved21[7];
+	u16		rpm;			/* Rotations per minute */
+	u8		reserved30[2];
+} idefloppy_flex_disk_page_t;
+
+/*
+ *	Format capacity
+ */
+typedef struct {
+	u8		reserved[3];
+	u8		length;			/* Length of the following
+						   descriptors in bytes */
+} idefloppy_capacity_header_t;
+
+typedef struct {
+	u32		blocks;			/* Number of blocks */
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned	dc		:2;	/* Descriptor Code */
+	unsigned	reserved	:6;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned	reserved	:6;
+	unsigned	dc		:2;	/* Descriptor Code */
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+	u8		length_msb;		/* Block Length (MSB)*/
+	u16		length;			/* Block Length */
+} idefloppy_cap_desc_t;
+
+#define CAPACITY_INVALID	0x00
+#define CAPACITY_UNFORMATTED	0x01
+#define CAPACITY_CURRENT	0x02
+#define CAPACITY_NO_CARTRIDGE	0x03
+
+/*
+ *	Most of our global data which we need to save even as we leave the
+ *	driver due to an interrupt or a timer event is stored in a variable
+ *	of type idefloppy_t, defined below.
+ */
+typedef struct ide_floppy_obj {
+	ide_drive_t	*drive;
+	ide_driver_t	*driver;
+	struct gendisk	*disk;
+	struct kref	kref;
+	unsigned int	openers;	/* protected by BKL for now */
+
+	/* Current packet command */
+	idefloppy_pc_t *pc;
+	/* Last failed packet command */
+	idefloppy_pc_t *failed_pc;
+	/* Packet command stack */
+	idefloppy_pc_t pc_stack[IDEFLOPPY_PC_STACK];
+	/* Next free packet command storage space */
+	int pc_stack_index;
+	struct request rq_stack[IDEFLOPPY_PC_STACK];
+	/* We implement a circular array */
+	int rq_stack_index;
+
+	/*
+	 *	Last error information
+	 */
+	u8 sense_key, asc, ascq;
+	/* delay this long before sending packet command */
+	u8 ticks;
+	int progress_indication;
+
+	/*
+	 *	Device information
+	 */
+	/* Current format */
+	int blocks, block_size, bs_factor;
+	/* Last format capacity */
+	idefloppy_cap_desc_t capacity;
+	/* Copy of the flexible disk page */
+	idefloppy_flex_disk_page_t flex_disk_page;
+	/* Write protect */
+	int wp;
+	/* Supports format progress report */
+	int srfp;
+	/* Status/Action flags */
+	unsigned long flags;
+} idefloppy_t;
+
+#define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
+
+/*
+ *	Floppy flag bits values.
+ */
+#define IDEFLOPPY_DRQ_INTERRUPT		0	/* DRQ interrupt device */
+#define IDEFLOPPY_MEDIA_CHANGED		1	/* Media may have changed */
+#define IDEFLOPPY_USE_READ12		2	/* Use READ12/WRITE12 or \
+						   READ10/WRITE10 */
+
+#define	IDEFLOPPY_FORMAT_IN_PROGRESS	3	/* Format in progress */
+#define IDEFLOPPY_CLIK_DRIVE	        4       /* Avoid commands not supported \
+						   in Clik drive */
+
+#define IDEFLOPPY_ZIP_DRIVE		5	/* Requires BH algorithm for \
+						   packets */
+
+/*
+ *	ATAPI floppy drive packet commands
+ */
+#define IDEFLOPPY_FORMAT_UNIT_CMD	0x04
+#define IDEFLOPPY_INQUIRY_CMD		0x12
+#define IDEFLOPPY_MODE_SELECT_CMD	0x55
+#define IDEFLOPPY_MODE_SENSE_CMD	0x5a
+#define IDEFLOPPY_READ10_CMD		0x28
+#define IDEFLOPPY_READ12_CMD		0xa8
+#define IDEFLOPPY_READ_CAPACITY_CMD	0x23
+#define IDEFLOPPY_REQUEST_SENSE_CMD	0x03
+#define IDEFLOPPY_PREVENT_REMOVAL_CMD	0x1e
+#define IDEFLOPPY_SEEK_CMD		0x2b
+#define IDEFLOPPY_START_STOP_CMD	0x1b
+#define IDEFLOPPY_TEST_UNIT_READY_CMD	0x00
+#define IDEFLOPPY_VERIFY_CMD		0x2f
+#define IDEFLOPPY_WRITE10_CMD		0x2a
+#define IDEFLOPPY_WRITE12_CMD		0xaa
+#define IDEFLOPPY_WRITE_VERIFY_CMD	0x2e
+
+/*
+ *	Defines for the mode sense command
+ */
+#define MODE_SENSE_CURRENT		0x00
+#define MODE_SENSE_CHANGEABLE		0x01
+#define MODE_SENSE_DEFAULT		0x02
+#define MODE_SENSE_SAVED		0x03
+
+/*
+ *	IOCTLs used in low-level formatting.
+ */
+
+#define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
+#define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
+#define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
+#define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
+
+/*
+ *	Error codes which are returned in rq->errors to the higher part
+ *	of the driver.
+ */
+#define	IDEFLOPPY_ERROR_GENERAL		101
+
+/*
+ *	The following is used to format the general configuration word of
+ *	the ATAPI IDENTIFY DEVICE command.
+ */
+struct idefloppy_id_gcw {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned packet_size		:2;	/* Packet Size */
+	unsigned reserved234		:3;	/* Reserved */
+	unsigned drq_type		:2;	/* Command packet DRQ type */
+	unsigned removable		:1;	/* Removable media */
+	unsigned device_type		:5;	/* Device type */
+	unsigned reserved13		:1;	/* Reserved */
+	unsigned protocol		:2;	/* Protocol type */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned protocol		:2;	/* Protocol type */
+	unsigned reserved13		:1;	/* Reserved */
+	unsigned device_type		:5;	/* Device type */
+	unsigned removable		:1;	/* Removable media */
+	unsigned drq_type		:2;	/* Command packet DRQ type */
+	unsigned reserved234		:3;	/* Reserved */
+	unsigned packet_size		:2;	/* Packet Size */
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+};
+
+/*
+ *	REQUEST SENSE packet command result - Data Format.
+ */
+typedef struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned	error_code	:7;	/* Current error (0x70) */
+	unsigned	valid		:1;	/* The information field conforms
+						   to SFF-8070i */
+	u8		reserved1	:8;	/* Reserved */
+	unsigned	sense_key	:4;	/* Sense Key */
+	unsigned	reserved2_4	:1;	/* Reserved */
+	unsigned	ili		:1;	/* Incorrect Length Indicator */
+	unsigned	reserved2_67	:2;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned	valid		:1;	/* The information field conforms
+						   to SFF-8070i */
+	unsigned	error_code	:7;	/* Current error (0x70) */
+	u8		reserved1	:8;	/* Reserved */
+	unsigned	reserved2_67	:2;
+	unsigned	ili		:1;	/* Incorrect Length Indicator */
+	unsigned	reserved2_4	:1;	/* Reserved */
+	unsigned	sense_key	:4;	/* Sense Key */
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+	u32		information __attribute__ ((packed));
+	u8		asl;			/* Additional sense length (n-7) */
+	u32		command_specific;	/* Additional command specific
+						   information */
+	u8		asc;			/* Additional Sense Code */
+	u8		ascq;			/* Additional Sense Code Qualifier */
+	u8		replaceable_unit_code;	/* Field Replaceable Unit Code */
+	u8		sksv[3];
+	u8		pad[2];			/* Padding to 20 bytes */
+} rq_sense_res_t;
+
+/*
+ *	Pages of the SELECT SENSE / MODE SENSE packet commands.
+ */
+#define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
+#define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
+
+/*
+ *	Mode Parameter Header for the MODE SENSE packet command
+ */
+typedef struct {
+	u16		mode_data_length;	/* Length of the following data
+						   transfer */
+	u8		medium_type;		/* Medium Type */
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	unsigned	reserved3	:7;
+	unsigned	wp		:1;	/* Write protect */
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	unsigned	wp		:1;	/* Write protect */
+	unsigned	reserved3	:7;
+#else
+#error "Bitfield endianness not defined! Check your byteorder.h"
+#endif
+	u8		reserved[4];
+} idefloppy_mode_par_hdr_t;
+
+#endif /* _IDE_FLOPPY_H */
-- 
1.5.3.7

