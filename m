Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbYAKMGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbYAKMGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbYAKMDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:49 -0500
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:33012 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758922AbYAKMDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=y2BdHBMCuDGCtOncH6CvFuODOvvZj73MsDav7D0xNlnJD0QUNyGCJ5zOoRaoKbeSCVEGah8UnbXxSgY8tmlZCgvEhh8kp+S/RYWke8BYiQwUOZyOO22VCeR7nJbTWFl5/VLC/e/5frJAKbGxh6HwX+YJ9lCVdDSXW7HLNg9rfNI=  ;
X-YMail-OSG: H7dBGbAVM1lZkwktkxHbnDN3Un5jcmAl8QtsbtQL8tq.yKkX4Mku.Cz51GpNuhsy8dtfL9gDYw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 05/21] ide-floppy: remove struct idefloppy_capabilities_page
Date: Fri, 11 Jan 2008 12:58:03 +0100
Message-Id: <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIG FAT WARNING: This patch has already been applied to Bart's quilt tree!

This change is rather temporary and is in preparation of using generic commands
as is the case with ide-cd and the uniform cdrom layer (i.e. init_cdrom_command())
However, before this happens, we'll have to remove all typedefs and teach
idefloppy_create_mode_sense_cmd() to work directly on u8 buffers.

Also, since idefloppy_get_capability_page() was used to read only the sfrp bit,
rename the latter so that the name reflects what it does.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   55 +++++-----------------------------------------
 1 files changed, 6 insertions(+), 49 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index e8fe8ef..2b9885f 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -120,44 +120,6 @@ typedef struct idefloppy_packet_command_s {
 #define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
 
 /*
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
  *	Flexible disk page.
  */
 typedef struct {
@@ -397,7 +359,8 @@ typedef struct {
 } idefloppy_request_sense_result_t;
 
 /*
- *	Pages of the SELECT SENSE / MODE SENSE packet commands.
+ * Pages of the SELECT SENSE / MODE SENSE packet commands.
+ * See SFF-8070i spec.
  */
 #define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
 #define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
@@ -1273,25 +1236,20 @@ static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
 	return 0;
 }
 
-static int idefloppy_get_capability_page(ide_drive_t *drive)
+static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
-	idefloppy_capabilities_page_t *page;
 
 	floppy->srfp = 0;
 	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
 						 MODE_SENSE_CURRENT);
 
 	set_bit(PC_SUPPRESS_ERROR, &pc.flags);
-	if (idefloppy_queue_pc_tail(drive,&pc)) {
+	if (idefloppy_queue_pc_tail(drive, &pc))
 		return 1;
-	}
 
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
-	page= (idefloppy_capabilities_page_t *)(header+1);
-	floppy->srfp = page->srfp;
+	floppy->srfp = pc.buffer[8 + 2] & 0x40;
 	return (0);
 }
 
@@ -1497,8 +1455,7 @@ static int idefloppy_begin_format(ide_drive_t *drive, int __user *arg)
 		return (-EFAULT);
 	}
 
-	/* Get the SFRP bit */
-	(void) idefloppy_get_capability_page(drive);
+	(void) idefloppy_get_sfrp_bit(drive);
 	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
 	if (idefloppy_queue_pc_tail(drive, &pc)) {
                 return (-EIO);
-- 
1.5.3.7

