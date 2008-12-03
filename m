Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYLCCX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYLCCX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYLCCXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:23:18 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:7867 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYLCCXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=WiC5YbfvJMpasaz2dXhmBxdZLhQqY7lJBaEkYO+SkLkmvG7nZFo6UTydvY8TKy4v9e
         n/pJVEft6GODKHw7WqYCeK1I+KbUvLX4qqDMLmdt3T2y/fcbUQ6PvpNCehf7560IVWKu
         AEPTW51EyJ5oZPgvVANiEvAM4YgdBEeAzUGLg=
Subject: [RFC PATCH-mm] usb: file_storage use unaligned endian helpers
 rather than private versions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 18:23:13 -0800
Message-Id: <1228270993.5412.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helpers for unaligned endian access.  Make some small changes
to reading 24-bit lba values, read the full 32 bit value and mask.  Produces
smaller and faster code on x86 and on powerpc.

Coalesce some byte-writes in 32bit writes to allow byteswapping to happen
at compile time and become a 32-bit write without swapping if possible (x86
especially)

This shrinks the size of file_storage.o by ~64 bytes on x86_32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Alan, what do you think?

 drivers/usb/gadget/file_storage.c |  103 +++++++++++++-----------------------
 1 files changed, 37 insertions(+), 66 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 1aee5b0..91b7466 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -795,37 +795,6 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
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
@@ -1583,9 +1552,9 @@ static int do_read(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_READ_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = load_be32_noalign((__be32 *)&fsg->cmnd[0]) & 0xffffff;
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = don't read from the
@@ -1716,9 +1685,9 @@ static int do_write(struct fsg_dev *fsg)
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
 	if (fsg->cmnd[0] == SC_WRITE_6)
-		lba = (fsg->cmnd[1] << 16) | get_be16(&fsg->cmnd[2]);
+		lba = load_be32_noalign((__be32 *)&fsg->cmnd[0]) & 0xffffff;
 	else {
-		lba = get_be32(&fsg->cmnd[2]);
+		lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
 
 		/* We allow DPO (Disable Page Out = don't save data in the
 		 * cache) and FUA (Force Unit Access = write directly to the
@@ -1952,7 +1921,7 @@ static int do_verify(struct fsg_dev *fsg)
 
 	/* Get the starting Logical Block Address and check that it's
 	 * not too big */
-	lba = get_be32(&fsg->cmnd[2]);
+	lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
 	if (lba >= curlun->num_sectors) {
 		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
 		return -EINVAL;
@@ -1965,7 +1934,7 @@ static int do_verify(struct fsg_dev *fsg)
 		return -EINVAL;
 	}
 
-	verification_length = get_be16(&fsg->cmnd[7]);
+	verification_length = load_be16_noalign((__be16 *)&fsg->cmnd[7]);
 	if (unlikely(verification_length == 0))
 		return -EIO;		// No default reply
 
@@ -2115,7 +2084,7 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	memset(buf, 0, 18);
 	buf[0] = valid | 0x70;			// Valid, current error
 	buf[2] = SK(sd);
-	put_be32(&buf[3], sdinfo);		// Sense information
+	store_be32_noalign((__be32 *)&buf[3], sdinfo);	// Sense information
 	buf[7] = 18 - 8;			// Additional sense length
 	buf[12] = ASC(sd);
 	buf[13] = ASCQ(sd);
@@ -2126,9 +2095,9 @@ static int do_request_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 {
 	struct lun	*curlun = fsg->curlun;
-	u32		lba = get_be32(&fsg->cmnd[2]);
+	u32		lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
 	int		pmi = fsg->cmnd[8];
-	u8		*buf = (u8 *) bh->buf;
+	__be32		*buf = (__be32 *)bh->buf;
 
 	/* Check the PMI and LBA fields */
 	if (pmi > 1 || (pmi == 0 && lba != 0)) {
@@ -2136,8 +2105,8 @@ static int do_read_capacity(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 		return -EINVAL;
 	}
 
-	put_be32(&buf[0], curlun->num_sectors - 1);	// Max logical block
-	put_be32(&buf[4], 512);				// Block length
+	store_be32_noalign(&buf[0], curlun->num_sectors - 1);	// Max logical block
+	store_be32_noalign(&buf[1], 512);			// Block length
 	return 8;
 }
 
@@ -2156,7 +2125,7 @@ static void store_cdrom_address(u8 *dest, int msf, u32 addr)
 		dest[0] = 0;		/* Reserved */
 	} else {
 		/* Absolute sector */
-		put_be32(dest, addr);
+		store_be32_noalign((__be32 *)dest, addr);
 	}
 }
 
@@ -2164,7 +2133,7 @@ static int do_read_header(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 {
 	struct lun	*curlun = fsg->curlun;
 	int		msf = fsg->cmnd[1] & 0x02;
-	u32		lba = get_be32(&fsg->cmnd[2]);
+	u32		lba = load_be32_noalign((__be32 *)&fsg->cmnd[2]);
 	u8		*buf = (u8 *) bh->buf;
 
 	if ((fsg->cmnd[1] & ~0x02) != 0) {		/* Mask away MSF */
@@ -2264,10 +2233,13 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 			buf[2] = 0x04;	// Write cache enable,
 					// Read cache not disabled
 					// No cache retention priorities
-			put_be16(&buf[4], 0xffff);  // Don't disable prefetch
+			// Don't disable prefetch
+			store_be16_noalign((__be16 *)&buf[4], 0xffff);
 					// Minimum prefetch = 0
-			put_be16(&buf[8], 0xffff);  // Maximum prefetch
-			put_be16(&buf[10], 0xffff); // Maximum prefetch ceiling
+			// Maximum prefetch
+			store_be16_noalign((__be16 *)&buf[8], 0xffff);
+			// Maximum prefetch ceiling
+			store_be16_noalign((__be16 *)&buf[10], 0xffff);
 		}
 		buf += 12;
 	}
@@ -2284,7 +2256,7 @@ static int do_mode_sense(struct fsg_dev *fsg, struct fsg_buffhd *bh)
 	if (mscmnd == SC_MODE_SENSE_6)
 		buf0[0] = len - 1;
 	else
-		put_be16(buf0, len - 2);
+		store_be16_noalign((__be16 *)buf0, len - 2);
 	return len;
 }
 
@@ -2366,15 +2338,14 @@ static int do_read_format_capacities(struct fsg_dev *fsg,
 			struct fsg_buffhd *bh)
 {
 	struct lun	*curlun = fsg->curlun;
-	u8		*buf = (u8 *) bh->buf;
-
-	buf[0] = buf[1] = buf[2] = 0;
-	buf[3] = 8;		// Only the Current/Maximum Capacity Descriptor
-	buf += 4;
-
-	put_be32(&buf[0], curlun->num_sectors);		// Number of blocks
-	put_be32(&buf[4], 512);				// Block length
-	buf[4] = 0x02;					// Current capacity
+	__be32		*buf = (__be32 *)bh->buf;
+
+	// Only the Current/Maximum Capacity Descriptor
+	store_be32_noalign(&buf[0], 8);
+	// Number of blocks
+	store_be32_noalign(&buf[1], curlun->num_sectors);
+	// Current capacity, Block length
+	store_be32_noalign(&buf[2], (0x02 << 24) | 512);
 	return 12;
 }
 
@@ -2894,7 +2865,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_MODE_SELECT_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (3<<7), 0,
 				"MODE SELECT(10)")) == 0)
@@ -2910,7 +2881,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_MODE_SENSE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (1<<2) | (3<<7), 0,
 				"MODE SENSE(10)")) == 0)
@@ -2935,7 +2906,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"READ(10)")) == 0)
@@ -2943,7 +2914,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = load_be32_noalign((__be32 *)&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_TO_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"READ(12)")) == 0)
@@ -2961,7 +2932,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 	case SC_READ_HEADER:
 		if (!mod_data.cdrom)
 			goto unknown_cmnd;
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(3<<7) | (0x1f<<1), 1,
 				"READ HEADER")) == 0)
@@ -2971,7 +2942,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 	case SC_READ_TOC:
 		if (!mod_data.cdrom)
 			goto unknown_cmnd;
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(7<<6) | (1<<1), 1,
 				"READ TOC")) == 0)
@@ -2979,7 +2950,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_READ_FORMAT_CAPACITIES:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]);
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]);
 		if ((reply = check_command(fsg, 10, DATA_DIR_TO_HOST,
 				(3<<7), 1,
 				"READ FORMAT CAPACITIES")) == 0)
@@ -3037,7 +3008,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_WRITE_10:
-		fsg->data_size_from_cmnd = get_be16(&fsg->cmnd[7]) << 9;
+		fsg->data_size_from_cmnd = load_be16_noalign((__be16 *)&fsg->cmnd[7]) << 9;
 		if ((reply = check_command(fsg, 10, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (3<<7), 1,
 				"WRITE(10)")) == 0)
@@ -3045,7 +3016,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		break;
 
 	case SC_WRITE_12:
-		fsg->data_size_from_cmnd = get_be32(&fsg->cmnd[6]) << 9;
+		fsg->data_size_from_cmnd = load_be32_noalign((__be32 *)&fsg->cmnd[6]) << 9;
 		if ((reply = check_command(fsg, 12, DATA_DIR_FROM_HOST,
 				(1<<1) | (0xf<<2) | (0xf<<6), 1,
 				"WRITE(12)")) == 0)
-- 
1.6.1.rc1.262.gb6810



