Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYEPAdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYEPAdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 20:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYEPAdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 20:33:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:58389 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYEPAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 20:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p2D+EFVhu2dTRU/LKkaw9EPVu6o1KZLurWyc8P5wqjRLIkdXbWX28tM/ZOYN27iVeE1Jeor7KCcNYbgmoEWt1XGjF5EKszBVkUGOLgKkNXQ3rNAIm5Wh6dR5h97NBQV21cyiTh7SKpu1xY3R0eP199HGveNPvNHOX5I/vwONauE=
Subject: [PATCH] usb: file-storage.c use unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bryan Wu <cooloney@kernel.org>, Jie Zhang <jie.zhang@analog.com>,
       Oliver Neukum <oliver@neukum.org>, david-b@pacbell.net, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0805151022570.2107-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0805151022570.2107-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 15 May 2008 17:33:05 -0700
Message-Id: <1210897985.5915.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the put_be16/32 and get_be16/32 helpers with the
common unaligned access routines.  Note that these put_ helpers
had the pointer/value parameter in the opposite order from the
common version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/gadget/file_storage.c |   79 ++++++++++++-------------------------
 1 files changed, 25 insertions(+), 54 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 47bb9f0..9405961 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -242,6 +242,8 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 
+#include <asm/unaligned.h>
+
 #include "gadget_chips.h"
 
 
@@ -763,37 +765,6 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 	return usb_ep_set_halt(ep);
 }
 
-
-/*-------------------------------------------------------------------------*/
-
-/* Routines for unaligned data access */
-
-static u16 get_be16(u8 *buf)
-{
-	return ((u16) buf[0] << 8) | ((u16) buf[1]);
-}
-
-static u32 get_be32(u8 *buf)
-{
-	return ((u32) buf[0] << 24) | ((u32) buf[1] << 16) |
-			((u32) buf[2] << 8) | ((u32) buf[3]);
-}
-
-static void put_be16(u8 *buf, u16 val)
-{
-	buf[0] = val >> 8;
-	buf[1] = val;
-}
-
-static void put_be32(u8 *buf, u32 val)
-{
-	buf[0] = val >> 24;
-	buf[1] = val >> 16;
-	buf[2] = val >> 8;
-	buf[3] = val & 0xff;
-}
-
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -1551,9 +1522,9 @@ static int do_read(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_READ_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(fsg->cmnd) & 0x00ffffff;
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = don't read from the
@@ -1684,9 +1655,9 @@ static int do_write(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_WRITE_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(fsg->cmnd) & 0x00ffffff;
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = get_unaligned_be32(&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = write directly to the
@@ -1920,7 +1891,7 @@ static int do_verify(struct fsg_dev *fsg)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	lba = get_be32(&fsg->cmnd[2]);
+	lba = get_unaligned_be32(&fsg->cmnd[2]);
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
 		return -EINVAL;
@@ -1933,7 +1904,7 @@ static int do_verify(struct fsg_dev *fsg)
 		return -EINVAL;
 	}
 
-	verification_length = get_be16(&fsg->cmnd[7]);
+	verification_length = get_unaligned_be16(&fsg->cmnd[7]);
 	if (unlikely(verification_length == 0))
 		return -EIO;		// No default reply
 
@@ -2078,7 +2049,7 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	memset(buf, 0, 18);
 	buf[0] = valid | 0x70;			// Valid, current error
 	buf[2] = SK(sd);
-	put_be32(&buf[3], sdinfo);		// Sense information
+	put_unaligned_be32(sdinfo, &buf[3]);		// Sense information
 	buf[7] = 18 - 8;			// Additional sense length
 	buf[12] = ASC(sd);
 	buf[13] = ASCQ(sd);
@@ -2089,7 +2060,7 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 {
 	struct lun	*curlun = fsg->curlun;
-	u32		lba = get_be32(&fsg->cmnd[2]);
+	u32		lba = get_unaligned_be32(&fsg->cmnd[2]);
 	int		pmi = fsg->cmnd[8];
 	u8		*buf = (u8 *) bh->buf;
 
@@ -2099,8 +2070,8 @@ static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 		return -EINVAL;
 	}
 
-	put_be32(&buf[0], curlun->num_sectors - 1);	// Max logical block
-	put_be32(&buf[4], 512);				// Block length
+	put_unaligned_be32(curlun->num_sectors - 1, &buf[0]);	// Max logical block
+	put_unaligned_be32(512, &buf[4]);				// Block length
 	return 8;
 }
 
@@ -2158,10 +2129,10 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 			buf[2] = 0x04;	// Write cache enable,
 					// Read cache not disabled
 					// No cache retention priorities
-			put_be16(&buf[4], 0xffff);  // Don't disable prefetch
+			put_unaligned_be16(0xffff, &buf[4]);  // Don't disable prefetch
 					// Minimum prefetch = 0
-			put_be16(&buf[8], 0xffff);  // Maximum prefetch
-			put_be16(&buf[10], 0xffff); // Maximum prefetch ceiling
+			put_unaligned_be16(0xffff, &buf[8]);  // Maximum prefetch
+			put_unaligned_be16(0xffff, &buf[10]); // Maximum prefetch ceiling
 		}
 		buf += 12;
 	}
@@ -2178,7 +2149,7 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	if (mscmnd == SC_MODE_SENSE_6)
 		buf0[0] = len - 1;
 	else
-		put_be16(buf0, len - 2);
+		put_unaligned_be16(len - 2, buf0);
 	return len;
 }
 
@@ -2266,8 +2237,8 @@ static int do_read_format_capacities(struct fsg_dev *fsg,
 	buf[3] = 8;		// Only the Current/Maximum Capacity Descriptor
 	buf += 4;
 
-	put_be32(&buf[0], curlun->num_sectors);		// Number of blocks
-	put_be32(&buf[4], 512);				// Block length
+	put_unaligned_be32(curlun->num_sectors, &buf[0]);	// Number of blocks
+	put_unaligned_be32(512, &buf[4]);			// Block length
 	buf[4] = 0x02;					// Current capacity
 	return 12;
 }
@@ -2775,7 +2746,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_MODE_SELECT_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (3<<7), 0,
 				"MODE SELECT(10)")) == 0)
@@ -2791,7 +2762,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_MODE_SENSE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (1<<2) | (3<<7), 0,
 				"MODE SENSE(10)")) == 0)
@@ -2816,7 +2787,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"READ(10)")) == 0)
@@ -2824,7 +2795,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be32(&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"READ(12)")) == 0)
@@ -2840,7 +2811,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_FORMAT_CAPACITIES:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(3<<7), 1,
 				"READ FORMAT CAPACITIES")) == 0)
@@ -2898,7 +2869,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_WRITE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be16(&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"WRITE(10)")) == 0)
@@ -2906,7 +2877,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_WRITE_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = get_unaligned_be32(&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"WRITE(12)")) == 0)
-- 
1.5.5.1.482.g0f174



