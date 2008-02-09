Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYBIIEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYBIIEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYBIIDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:03:54 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:46741 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYBIIDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from;
        b=hktngN8QoDBzjHFevSZa+CwrHD+uFO5a5+vfzDXh1/LF1jmNHUcsRj/VlmMVQePeNqSOFvUr6M/S6iwD7G3qg4TwC713TeWFmyWqNAlq9Mql3nVrlrBI7Jve4fBNzHDB8+tKqKLuf2dNm8JOlWnzS6eUG6GjZMEz81NUC1mDQs0=
Date: Sat, 9 Feb 2008 09:03:34 +0100
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-floppy: remove struct idefloppy_id_gcw
Message-ID: <20080209080334.GA23177@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a6aaf3dd3e88d1bd1e85fb4329042ecb9247e0eb
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Fri Feb 8 18:21:47 2008 +0100

    ide-floppy: remove struct idefloppy_id_gcw
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index faf22d7..5d5bde8 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -195,32 +195,6 @@ enum {
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
 /*
- * The following is used to format the general configuration word of the
- * ATAPI IDENTIFY DEVICE command.
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
  * Pages of the SELECT SENSE / MODE SENSE packet commands.
  * See SFF-8070i spec.
  */
@@ -1271,32 +1245,40 @@ static sector_t idefloppy_capacity(ide_drive_t *drive)
  */
 static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
 {
-	struct idefloppy_id_gcw gcw;
+	u8 gcw[2];
+	u8 device_type, protocol, removable, drq_type, packet_size;
 
 	*((u16 *) &gcw) = id->config;
 
+	device_type =  gcw[1] & 0x1F;
+	removable   = (gcw[0] & 0x80) >> 7;
+	protocol    = (gcw[1] & 0xC0) >> 6;
+	drq_type    = (gcw[0] & 0x60) >> 5;
+	packet_size =  gcw[0] & 0x03;
+
 #ifdef CONFIG_PPC
 	/* kludge for Apple PowerBook internal zip */
-	if ((gcw.device_type == 5) &&
-	    !strstr(id->model, "CD-ROM") &&
-	    strstr(id->model, "ZIP"))
-		gcw.device_type = 0;
+	if ((device_type == 5) &&
+		trstr(id->model, "CD-ROM") &&
+		strstr(id->model, "ZIP"))
+		device_type = 0;
 #endif
 
-	if (gcw.protocol != 2)
+	if (protocol != 2)
 		printk(KERN_ERR "ide-floppy: Protocol (0x%02x) is not ATAPI\n",
-				gcw.protocol);
-	else if (gcw.device_type != 0)
+			protocol);
+	else if (device_type != 0)
 		printk(KERN_ERR "ide-floppy: Device type (0x%02x) is not set "
-				"to floppy\n", gcw.device_type);
-	else if (!gcw.removable)
-		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
-	else if (gcw.drq_type == 3) {
+				"to floppy\n", device_type);
+	else if (!removable)
+		printk(KERN_ERR "ide-floppy: The removable flag (0x%02x) is not"
+				" set\n", removable);
+	else if (drq_type == 3) {
 		printk(KERN_ERR "ide-floppy: Sorry, DRQ type (0x%02x) not "
-				"supported\n", gcw.drq_type);
-	} else if (gcw.packet_size != 0) {
+				"supported\n", drq_type);
+	} else if (packet_size != 0) {
 		printk(KERN_ERR "ide-floppy: Packet size (0x%02x) is not 12 "
-				"bytes long\n", gcw.packet_size);
+				"bytes\n", packet_size);
 	} else
 		return 1;
 	return 0;
@@ -1322,11 +1304,12 @@ static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
 
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
-	struct idefloppy_id_gcw gcw;
+	u8 gcw[2];
 
 	*((u16 *) &gcw) = drive->id->config;
 	floppy->pc = floppy->pc_stack;
-	if (gcw.drq_type == 1)
+
+	if (((gcw[0] & 0x60) >> 5) == 1)
 		floppy->flags |= IDEFLOPPY_FLAG_DRQ_INTERRUPT;
 	/*
 	 * We used to check revisions here. At this point however I'm giving up.

-- 
Regards/Gruﬂ,
    Boris.
