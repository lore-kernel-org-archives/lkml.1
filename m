Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYLCTCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYLCTCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYLCTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:01:58 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:55250 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYLCTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wfCpUT6LzGs8n0vGyHXpMaEXEBmi+c6U9Rdni5dj4V4SWAUu8blLlv5ODLjjQVbewq
         lrHAtnpOxHhjRtx/TcRoOWrU10XCTfwUy420ClZutqo5/YRwdLOFQHDNU7dTQa0z3CwT
         +e0TDAcr7KQA8In34oDELKx/CtF3U7qpMehDQ=
Subject: [PATCH-mm] usb: use unaligned endian helpers in storage drivers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 11:01:53 -0800
Message-Id: <1228330913.5412.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the unaligned access work in -mm.

 drivers/usb/storage/datafab.c       |   32 +++++++++---------------------
 drivers/usb/storage/jumpshot.c      |   32 +++++++++---------------------
 drivers/usb/storage/shuttle_usbat.c |   36 ++++++++++------------------------
 3 files changed, 31 insertions(+), 69 deletions(-)

diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 17f1ae2..81d882c 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -50,6 +50,7 @@
 
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -373,10 +374,7 @@ static int datafab_id_device(struct us_data *us,
 	if (rc == USB_STOR_XFER_GOOD) {
 		// capacity is at word offset 57-58
 		//
-		info->sectors = ((u32)(reply[117]) << 24) | 
-				((u32)(reply[116]) << 16) |
-				((u32)(reply[115]) <<  8) | 
-				((u32)(reply[114])      );
+		info->sectors = load_le32_noalign((__le32 *)&reply[114]);
 		rc = USB_STOR_TRANSPORT_GOOD;
 		goto leave;
 	}
@@ -556,10 +554,8 @@ int datafab_transport(struct scsi_cmnd * srb, struct us_data *us)
 	// don't bother implementing READ_6 or WRITE_6.
 	//
 	if (srb->cmnd[0] == READ_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("datafab_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_read_data(us, info, block, blocks);
@@ -568,21 +564,16 @@ int datafab_transport(struct scsi_cmnd * srb, struct us_data *us)
 	if (srb->cmnd[0] == READ_12) {
 		// we'll probably never see a READ_12 but we'll do it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("datafab_transport:  READ_12: read block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_read_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == WRITE_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("datafab_transport:  WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_write_data(us, info, block, blocks);
@@ -591,11 +582,8 @@ int datafab_transport(struct scsi_cmnd * srb, struct us_data *us)
 	if (srb->cmnd[0] == WRITE_12) {
 		// we'll probably never see a WRITE_12 but we'll do it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("datafab_transport:  WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
 		return datafab_write_data(us, info, block, blocks);
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index df67f13..6cbe6bd 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -47,6 +47,7 @@
 
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -309,10 +310,7 @@ static int jumpshot_id_device(struct us_data *us,
 		goto leave;
 	}
 
-	info->sectors = ((u32)(reply[117]) << 24) |
-			((u32)(reply[116]) << 16) |
-			((u32)(reply[115]) <<  8) |
-			((u32)(reply[114])      );
+	info->sectors = load_le32_noalign((__le32 *)&reply[114]);
 
 	rc = USB_STOR_TRANSPORT_GOOD;
 
@@ -486,10 +484,8 @@ int jumpshot_transport(struct scsi_cmnd * srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == READ_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("jumpshot_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_read_data(us, info, block, blocks);
@@ -498,21 +494,16 @@ int jumpshot_transport(struct scsi_cmnd * srb, struct us_data *us)
 	if (srb->cmnd[0] == READ_12) {
 		// I don't think we'll ever see a READ_12 but support it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("jumpshot_transport:  READ_12: read block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_read_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == WRITE_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("jumpshot_transport:  WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_write_data(us, info, block, blocks);
@@ -521,11 +512,8 @@ int jumpshot_transport(struct scsi_cmnd * srb, struct us_data *us)
 	if (srb->cmnd[0] == WRITE_12) {
 		// I don't think we'll ever see a WRITE_12 but support it anyway...
 		//
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-			((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-			 ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("jumpshot_transport:  WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
 		return jumpshot_write_data(us, info, block, blocks);
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index ae6d648..023dee7 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -44,6 +44,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/cdrom.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -957,10 +958,7 @@ static int usbat_flash_get_sector_count(struct us_data *us,
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		goto leave;
 
-	info->sectors = ((u32)(reply[117]) << 24) |
-		((u32)(reply[116]) << 16) |
-		((u32)(reply[115]) <<  8) |
-		((u32)(reply[114])      );
+	info->sectors = load_le32_noalign((__le32 *)&reply[114]);
 
 	rc = USB_STOR_TRANSPORT_GOOD;
 
@@ -1215,9 +1213,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL) /* bloody hell! */
 		return USB_STOR_TRANSPORT_FAILED;
-	sector = short_pack(data[7+3], data[7+2]);
-	sector <<= 16;
-	sector |= short_pack(data[7+5], data[7+4]);
+	sector = load_be32_noalign((__be32 *)&data[7 + 2]);
 	transferred = 0;
 
 	while (transferred != scsi_bufflen(srb)) {
@@ -1596,10 +1592,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 	}
 
 	if (srb->cmnd[0] == READ_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-				((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("usbat_flash_transport:  READ_10: read block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_read_data(us, info, block, blocks);
@@ -1609,21 +1603,16 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 		/*
 		 * I don't think we'll ever see a READ_12 but support it anyway
 		 */
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-		        ((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-		         ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be32_noalign((__be32 *)&srb->cmnd[6]);
 
 		US_DEBUGP("usbat_flash_transport: READ_12: read block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_read_data(us, info, block, blocks);
 	}
 
 	if (srb->cmnd[0] == WRITE_10) {
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-		        ((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[7]) << 8) | ((u32)(srb->cmnd[8]));
+		block = load_be32_noalign((__be32 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[7]);
 
 		US_DEBUGP("usbat_flash_transport: WRITE_10: write block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_write_data(us, info, block, blocks);
@@ -1633,11 +1622,8 @@ static int usbat_flash_transport(struct scsi_cmnd * srb, struct us_data *us)
 		/*
 		 * I don't think we'll ever see a WRITE_12 but support it anyway
 		 */
-		block = ((u32)(srb->cmnd[2]) << 24) | ((u32)(srb->cmnd[3]) << 16) |
-		        ((u32)(srb->cmnd[4]) <<  8) | ((u32)(srb->cmnd[5]));
-
-		blocks = ((u32)(srb->cmnd[6]) << 24) | ((u32)(srb->cmnd[7]) << 16) |
-		         ((u32)(srb->cmnd[8]) <<  8) | ((u32)(srb->cmnd[9]));
+		block = load_be16_noalign((__be16 *)&srb->cmnd[2]);
+		blocks = load_be16_noalign((__be16 *)&srb->cmnd[6]);
 
 		US_DEBUGP("usbat_flash_transport: WRITE_12: write block 0x%04lx  count %ld\n", block, blocks);
 		return usbat_flash_write_data(us, info, block, blocks);
-- 
1.6.1.rc1.262.gb6810



