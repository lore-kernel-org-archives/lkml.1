Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYA0Juc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYA0Juc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYA0JtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:03 -0500
Received: from [212.23.103.76] ([212.23.103.76]:58594 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754228AbYA0Js6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:48:58 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 09/32] ide-tape: remove struct idetape_inquiry_result_t
Date: Sun, 27 Jan 2008 10:47:57 +0100
Message-Id: <1201427300-3954-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

There should be no functional changes resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   51 ++++++++++++-----------------------------------
 1 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0f846bc..31c1a20 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -653,31 +653,6 @@ struct idetape_id_gcw {
 };
 
 /*
- *	INQUIRY packet command - Data Format (From Table 6-8 of QIC-157C)
- */
-typedef struct {
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
-	__u8		additional_length;	/* Additional Length (total_length-4) */
-	__u8		rsv5, rsv6, rsv7;	/* Reserved */
-	__u8		vendor_id[8];		/* Vendor Identification */
-	__u8		product_id[16];		/* Product Identification */
-	__u8		revision_level[4];	/* Revision Level */
-	__u8		vendor_specific[20];	/* Vendor Specific - Optional */
-	__u8		reserved56t95[40];	/* Reserved - Optional */
-						/* Additional information may be returned */
-} idetape_inquiry_result_t;
-
-/*
  *	READ POSITION packet command - Data Format (From Table 6-57)
  */
 typedef struct {
@@ -3662,32 +3637,32 @@ static int idetape_identify_device (ide_drive_t *drive)
 	return 0;
 }
 
-/*
- * Use INQUIRY to get the firmware revision
- */
-static void idetape_get_inquiry_results (ide_drive_t *drive)
+static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	char *r;
 	idetape_tape_t *tape = drive->driver_data;
 	idetape_pc_t pc;
-	idetape_inquiry_result_t *inquiry;
-	
+
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
-		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n", tape->name);
+		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
+				tape->name);
 		return;
 	}
-	inquiry = (idetape_inquiry_result_t *) pc.buffer;
-	memcpy(tape->vendor_id, inquiry->vendor_id, 8);
-	memcpy(tape->product_id, inquiry->product_id, 16);
-	memcpy(tape->firmware_revision, inquiry->revision_level, 4);
+	memcpy(tape->vendor_id, &pc.buffer[8], 8);
+	memcpy(tape->product_id, &pc.buffer[16], 16);
+	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
+
 	ide_fixstring(tape->vendor_id, 10, 0);
 	ide_fixstring(tape->product_id, 18, 0);
 	ide_fixstring(tape->firmware_revision, 6, 0);
 	r = tape->firmware_revision;
 	if (*(r + 1) == '.')
-		tape->firmware_revision_num = (*r - '0') * 100 + (*(r + 2) - '0') * 10 + *(r + 3) - '0';
-	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n", drive->name, tape->name, tape->vendor_id, tape->product_id, tape->firmware_revision);
+		tape->firmware_revision_num = (*r - '0') * 100 +
+			(*(r + 2) - '0') * 10 +	*(r + 3) - '0';
+	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
+			drive->name, tape->name, tape->vendor_id,
+			tape->product_id, tape->firmware_revision);
 }
 
 /*
-- 
1.5.3.7

