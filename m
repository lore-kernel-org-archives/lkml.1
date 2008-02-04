Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYBDNpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYBDNpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbYBDNmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbYBDNme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=smrXzZenelfe9v31BP1/BZPASr/qcW7H0tgSWxELO3rzcdmECVZ4p0XJqwX/deH4lyto2njFWqS3qR1Qkcok/PGc0Uyou4RoC2zHhCDQNWGiu3KR/FKDFZyzjQbAggvB3HUIDuKZ6t/i1iR9zIM++VpUdJffZlj3Uo+yM9PmaGg=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 13/22] ide-tape: remove struct idetape_id_gcw
Date: Mon,  4 Feb 2008 14:40:31 +0100
Message-Id: <1202132440-26648-14-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   58 ++++++++++++++++++++---------------------------
 1 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 712c5df..175d507 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -520,20 +520,6 @@ enum {
 #define	IDETAPE_ERROR_FILEMARK		102
 #define	IDETAPE_ERROR_EOD		103
 
-/*
- *	The following is used to format the general configuration word of
- *	the ATAPI IDENTIFY DEVICE command.
- */
-struct idetape_id_gcw {	
-	unsigned packet_size		:2;	/* Packet Size */
-	unsigned reserved234		:3;	/* Reserved */
-	unsigned drq_type		:2;	/* Command packet DRQ type */
-	unsigned removable		:1;	/* Removable media */
-	unsigned device_type		:5;	/* Device type */
-	unsigned reserved13		:1;	/* Reserved */
-	unsigned protocol		:2;	/* Protocol type */
-};
-
 /* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
 #define IDETAPE_BLOCK_DESCRIPTOR	0
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
@@ -3382,37 +3368,41 @@ static int idetape_chrdev_release (struct inode *inode, struct file *filp)
 }
 
 /*
- *	idetape_identify_device is called to check the contents of the
- *	ATAPI IDENTIFY command results. We return:
+ * check the contents of the ATAPI IDENTIFY command results. We return:
  *
- *	1	If the tape can be supported by us, based on the information
- *		we have so far.
+ * 1 - If the tape can be supported by us, based on the information we have so
+ * far.
  *
- *	0 	If this tape driver is not currently supported by us.
+ * 0 - If this tape driver is not currently supported by us.
  */
-static int idetape_identify_device (ide_drive_t *drive)
+static int idetape_identify_device(ide_drive_t *drive)
 {
-	struct idetape_id_gcw gcw;
-	struct hd_driveid *id = drive->id;
+
+	u8 gcw[2];
+	u8 protocol, device_type, removable, packet_size;
 
 	if (drive->id_read == 0)
 		return 1;
 
-	*((unsigned short *) &gcw) = id->config;
+	*((unsigned short *) &gcw) = drive->id->config;
 
-	/* Check that we can support this device */
+	protocol	=   (gcw[1] & 0xC0) >> 6;
+	device_type	=    gcw[1] & 0x1F;
+	removable	= !!(gcw[0] & 0x80);
+	packet_size	=    gcw[0] & 0x3;
 
-	if (gcw.protocol != 2)
+	/* Check that we can support this device */
+	if (protocol != 2)
 		printk(KERN_ERR "ide-tape: Protocol (0x%02x) is not ATAPI\n",
-				gcw.protocol);
-	else if (gcw.device_type != 1)
+			protocol);
+	else if (device_type != 1)
 		printk(KERN_ERR "ide-tape: Device type (0x%02x) is not set "
-				"to tape\n", gcw.device_type);
-	else if (!gcw.removable)
+				"to tape\n", device_type);
+	else if (!removable)
 		printk(KERN_ERR "ide-tape: The removable flag is not set\n");
-	else if (gcw.packet_size != 0) {
+	else if (packet_size != 0) {
 		printk(KERN_ERR "ide-tape: Packet size (0x%02x) is not 12 "
-				"bytes long\n", gcw.packet_size);
+				"bytes long\n", packet_size);
 	} else
 		return 1;
 	return 0;
@@ -3541,8 +3531,8 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
 	unsigned long t1, tmid, tn, t;
 	int speed;
-	struct idetape_id_gcw gcw;
 	int stage_size;
+	u8 gcw[2];
 	struct sysinfo si;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
@@ -3564,7 +3554,9 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	tape->max_insert_speed = 10000;
 	tape->speed_control = 1;
 	*((unsigned short *) &gcw) = drive->id->config;
-	if (gcw.drq_type == 1)
+
+	/* Command packet DRQ type */
+	if (((gcw[0] & 0x60) >> 5) == 1)
 		tape->flags |= IDETAPE_FL_DRQ_INTERRUPT;
 
 	tape->min_pipeline = tape->max_pipeline = tape->max_stages = 10;
-- 
1.5.3.7

