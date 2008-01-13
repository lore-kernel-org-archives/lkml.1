Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYAMUYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYAMUYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYAMUWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:25 -0500
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:32316 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753680AbYAMUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=1BNDffWFgCPBzWm3kTvE9TtZhAwQw1WPR1wv2u3+899zn3Ca6aopv3p+NI6hOcvx0j2d+6/U6ef1Uc0M/R1mWYd/VqnfA3djdhojgPy5q5QMKHv0T1NIbGKexqtrGsSTYXXT4lhxX8+ZWmKT+YFgAwgHiGRLGsd9xy9jlrmsXUk=  ;
X-YMail-OSG: UsP86tAVM1mtptvWrqU6u8zx8nlIGDE.EKUSF2p_avzq22M67c7MaS5j2ANcZ0n_NlhcxGHLiQLJy5O.NXLD_juc
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 11/12] ide-floppy: remove IDEFLOPPY_DEBUG_INFO
Date: Sun, 13 Jan 2008 21:18:24 +0100
Message-Id: <1200255505-31418-12-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-5-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-6-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-7-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-8-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-9-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-10-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This info is already available through ioctl() and /proc

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   63 +++++++++------------------------------------
 1 files changed, 13 insertions(+), 50 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8e7714a..f9faf26 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -47,11 +47,8 @@
 #include <linux/io.h>
 #include <asm/unaligned.h>
 
-/*
- *	The following are used to debug the driver.
- */
+/* define to see debug info */
 #define IDEFLOPPY_DEBUG_LOG		0
-#define IDEFLOPPY_DEBUG_INFO		0
 
 /* #define IDEFLOPPY_DEBUG(fmt, args...) printk(KERN_INFO fmt, ## args) */
 #define IDEFLOPPY_DEBUG( fmt, args... )
@@ -1314,15 +1311,12 @@ static sector_t idefloppy_capacity (ide_drive_t *drive)
 }
 
 /*
- *	idefloppy_identify_device checks if we can support a drive,
- *	based on the ATAPI IDENTIFY command results.
+ * Check whether we can support a drive, based on the ATAPI IDENTIFY command
+ * results.
  */
-static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
+static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
 {
 	struct idefloppy_id_gcw gcw;
-#if IDEFLOPPY_DEBUG_INFO
-	char buffer[80];
-#endif /* IDEFLOPPY_DEBUG_INFO */
 
 	*((u16 *) &gcw) = id->config;
 
@@ -1331,54 +1325,23 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	if ((gcw.device_type == 5) &&
 	    !strstr(id->model, "CD-ROM") &&
 	    strstr(id->model, "ZIP"))
-		gcw.device_type = 0;			
+		gcw.device_type = 0;
 #endif
 
-#if IDEFLOPPY_DEBUG_INFO
-	printk(KERN_INFO "Dumping ATAPI Identify Device floppy parameters\n");
-	switch (gcw.protocol) {
-		case 0: case 1: sprintf(buffer, "ATA");break;
-		case 2:	sprintf(buffer, "ATAPI");break;
-		case 3: sprintf(buffer, "Reserved (Unknown to ide-floppy)");break;
-	}
-	printk(KERN_INFO "Protocol Type: %s\n", buffer);
-	switch (gcw.device_type) {
-		case 0: sprintf(buffer, "Direct-access Device");break;
-		case 1: sprintf(buffer, "Streaming Tape Device");break;
-		case 2: case 3: case 4: sprintf (buffer, "Reserved");break;
-		case 5: sprintf(buffer, "CD-ROM Device");break;
-		case 6: sprintf(buffer, "Reserved");
-		case 7: sprintf(buffer, "Optical memory Device");break;
-		case 0x1f: sprintf(buffer, "Unknown or no Device type");break;
-		default: sprintf(buffer, "Reserved");
-	}
-	printk(KERN_INFO "Device Type: %x - %s\n", gcw.device_type, buffer);
-	printk(KERN_INFO "Removable: %s\n",gcw.removable ? "Yes":"No");	
-	switch (gcw.drq_type) {
-		case 0: sprintf(buffer, "Microprocessor DRQ");break;
-		case 1: sprintf(buffer, "Interrupt DRQ");break;
-		case 2: sprintf(buffer, "Accelerated DRQ");break;
-		case 3: sprintf(buffer, "Reserved");break;
-	}
-	printk(KERN_INFO "Command Packet DRQ Type: %s\n", buffer);
-	switch (gcw.packet_size) {
-		case 0: sprintf(buffer, "12 bytes");break;
-		case 1: sprintf(buffer, "16 bytes");break;
-		default: sprintf(buffer, "Reserved");break;
-	}
-	printk(KERN_INFO "Command Packet Size: %s\n", buffer);
-#endif /* IDEFLOPPY_DEBUG_INFO */
-
 	if (gcw.protocol != 2)
-		printk(KERN_ERR "ide-floppy: Protocol is not ATAPI\n");
+		printk(KERN_ERR "ide-floppy: Protocol 0x%02x not ATAPI\n",
+			gcw.protocol);
 	else if (gcw.device_type != 0)
-		printk(KERN_ERR "ide-floppy: Device type is not set to floppy\n");
+		printk(KERN_ERR "ide-floppy: Device type 0x%02x is not set to "
+				"floppy\n", gcw.device_type);
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
 	else if (gcw.drq_type == 3) {
-		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not supported\n", gcw.drq_type);
+		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not "
+				"supported\n", gcw.drq_type);
 	} else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes long\n");
+		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes "
+				"long\n");
 	} else
 		return 1;
 	return 0;
-- 
1.5.3.7

