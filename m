Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbXJ0Pzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbXJ0Pzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXJ0Py6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:54:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:19688 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbXJ0Py4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=LyxZdE1AeJfj6ZSJ83zsd1uWPIkxbZUVi0SpNkFyzPOFxo6ltzOjv1VDr6ryBuJoywjQW/5rmSBM2PAYeXcb2ghoJooJTfHvb0mlCHsrjqTuMGayY1henvke5y8FlWJrvbIs8YtHTl6YkaA//OvtMVbU3vtYcKXdcl1IqzGn/4w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] isd200: don't include <linux/ide.h>
Date: Sat, 27 Oct 2007 18:01:04 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@redhat.com>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710271801.04229.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that commit 3794ade5b286cbd4551009dd341dbe9aeead2bc3 removed
incorrect dependency on CONFIG_IDE we can fix the driver to not
include <linux/ide.h>:

* add ATA_REG_{ERROR,LCYL,HCYL,STATUS}_OFFSET defines and use them
  instead of IDE_{ERROR,LCYL,HCYL,STATUS}_OFFSET from <linux/ide.h>

* remove no longer needed <linux/ide.h> include

* remove incorrect comment added by the last commit:
  - isd200.c is not the only user of struct hd_driveid besides IDE
    (see drivers/block/xsysace.c and arch/um/drivers/ubd_kern.c)

Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/usb/storage/isd200.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

Index: b/drivers/usb/storage/isd200.c
===================================================================
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -48,7 +48,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/hdreg.h>
-#include <linux/ide.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -109,6 +108,12 @@
 #define REG_STATUS		0x80
 #define REG_COMMAND		0x80
 
+/* ATA registers offset definitions */
+#define ATA_REG_ERROR_OFFSET		1
+#define ATA_REG_LCYL_OFFSET		4
+#define ATA_REG_HCYL_OFFSET		5
+#define ATA_REG_STATUS_OFFSET		7
+
 /* ATA error definitions not in <linux/hdreg.h> */
 #define ATA_ERROR_MEDIA_CHANGE		0x20
 
@@ -358,7 +363,7 @@ static void isd200_build_sense(struct us
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
 	struct sense_data *buf = (struct sense_data *) &srb->sense_buffer[0];
-	unsigned char error = info->ATARegs[IDE_ERROR_OFFSET];
+	unsigned char error = info->ATARegs[ATA_REG_ERROR_OFFSET];
 
 	if(error & ATA_ERROR_MEDIA_CHANGE) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
@@ -525,8 +530,8 @@ static int isd200_read_regs( struct us_d
 		retStatus = ISD200_ERROR;
 	} else {
 		memcpy(info->ATARegs, info->RegsBuf, sizeof(info->ATARegs));
-		US_DEBUGP("   Got ATA Register[IDE_ERROR_OFFSET] = 0x%x\n", 
-			  info->ATARegs[IDE_ERROR_OFFSET]);
+		US_DEBUGP("   Got ATA Register[ATA_REG_ERROR_OFFSET] = 0x%x\n",
+			  info->ATARegs[ATA_REG_ERROR_OFFSET]);
 	}
 
 	return retStatus;
@@ -868,7 +873,7 @@ static int isd200_try_enum(struct us_dat
 			break;
 
 		if (!detect) {
-			if (regs[IDE_STATUS_OFFSET] & BUSY_STAT ) {
+			if (regs[ATA_REG_STATUS_OFFSET] & BUSY_STAT) {
 				US_DEBUGP("   %s status is still BSY, try again...\n",mstr);
 			} else {
 				US_DEBUGP("   %s status !BSY, continue with next operation\n",mstr);
@@ -878,12 +883,12 @@ static int isd200_try_enum(struct us_dat
 		/* check for BUSY_STAT and */
 		/* WRERR_STAT (workaround ATA Zip drive) and */ 
 		/* ERR_STAT (workaround for Archos CD-ROM) */
-		else if (regs[IDE_STATUS_OFFSET] & 
+		else if (regs[ATA_REG_STATUS_OFFSET] &
 			 (BUSY_STAT | WRERR_STAT | ERR_STAT )) {
 			US_DEBUGP("   Status indicates it is not ready, try again...\n");
 		}
 		/* check for DRDY, ATA devices set DRDY after SRST */
-		else if (regs[IDE_STATUS_OFFSET] & READY_STAT) {
+		else if (regs[ATA_REG_STATUS_OFFSET] & READY_STAT) {
 			US_DEBUGP("   Identified ATA device\n");
 			info->DeviceFlags |= DF_ATA_DEVICE;
 			info->DeviceHead = master_slave;
@@ -892,8 +897,8 @@ static int isd200_try_enum(struct us_dat
 		/* check Cylinder High/Low to
 		   determine if it is an ATAPI device
 		*/
-		else if ((regs[IDE_HCYL_OFFSET] == 0xEB) &&
-			 (regs[IDE_LCYL_OFFSET] == 0x14)) {
+		else if (regs[ATA_REG_HCYL_OFFSET] == 0xEB &&
+			 regs[ATA_REG_LCYL_OFFSET] == 0x14) {
 			/* It seems that the RICOH 
 			   MP6200A CD/RW drive will 
 			   report itself okay as a
@@ -977,12 +982,6 @@ static int isd200_manual_enum(struct us_
 	return(retStatus);
 }
 
-/*
- *	We are the last non IDE user of the legacy IDE ident structures
- *	and we thus want to keep a private copy of this function so the
- *	driver can be used without the obsolete drivers/ide layer
- */
-
 static void isd200_fix_driveid (struct hd_driveid *id)
 {
 #ifndef __LITTLE_ENDIAN
