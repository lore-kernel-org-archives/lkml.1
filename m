Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYAMUXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYAMUXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYAMUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:12 -0500
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:23245 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753355AbYAMUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=uEmV20pm+P3uyBpSvBxfkqWXFsRjNcceAq9Fn676v4gSK1qkFprNJqIlAPk67Y4YYQQ3upOb3petg+WlYdDlji+21m4t63jpBjeMkpsdVwQo/jPH//oCarnYomb/54bYcsZPvPGBzqAv7cQiAZ7D7+QOVCBLGk7ZH7QbpFqhhgo=  ;
X-YMail-OSG: pB2oMskVM1n8Zmc.hCTl9dpdyhGHW69iTaIcH56HYW5NqWA8_7PVf8YFwZg4o06ZFrEo3BZ2obP3xFp5p71um.Z7kkOY6EIB6WwAAmRrYUr8tvjVVw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 3/12] ide-floppy: remove struct idefloppy_capacity_descriptor
Date: Sun, 13 Jan 2008 21:18:16 +0100
Message-Id: <1200255505-31418-4-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also,
- remove the accompanying 4 byte idefloppy_capacity_header.
- rename functions from idefloppy_... to ide_floppy_... after cleanup.
- simplify loop in ide_floppy_get_capacity() by reversing if-test condition
logically.
- finally, fix white space and checkpatch.pl issues

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  176 ++++++++++++++++++++--------------------------
 1 files changed, 76 insertions(+), 100 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 06d83cb..caeffb7 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -119,29 +119,7 @@ typedef struct idefloppy_packet_command_s {
 
 #define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
 
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
+/* format capacities descriptor codes */
 #define CAPACITY_INVALID	0x00
 #define CAPACITY_UNFORMATTED	0x01
 #define CAPACITY_CURRENT	0x02
@@ -184,8 +162,8 @@ typedef struct ide_floppy_obj {
 	 */
 	/* Current format */
 	int blocks, block_size, bs_factor;
-	/* Last format capacity */
-	idefloppy_capacity_descriptor_t capacity;
+	/* Last format capacity descriptor */
+	u8 cap_desc[8];
 	/* Copy of the flexible disk page */
 	u8 flexible_disk_page[32];
 	/* Write protect */
@@ -1216,17 +1194,17 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 }
 
 /*
- *	Determine if a media is present in the floppy drive, and if so,
- *	its LBA capacity.
+ * Determine if a media is present in the floppy drive, and if so, its LBA
+ * capacity.
  */
-static int idefloppy_get_capacity (ide_drive_t *drive)
+static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_capacity_header_t *header;
-	idefloppy_capacity_descriptor_t *descriptor;
-	int i, descriptors, rc = 1, blocks, length;
-	
+	u8 *cap_desc;
+	u8 header_len, desc_cnt;
+	int i, rc = 1, blocks, length;
+
 	drive->bios_cyl = 0;
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
@@ -1238,17 +1216,26 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
-	header = (idefloppy_capacity_header_t *) pc.buffer;
-	descriptors = header->length / sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+	header_len = pc.buffer[3];
+	cap_desc = &pc.buffer[4];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
+
+	for (i = 0; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
+
+		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
+
+		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
+				i, blocks * length / 1024, blocks, length);
 
-	for (i = 0; i < descriptors; i++, descriptor++) {
-		blocks = descriptor->blocks = be32_to_cpu(descriptor->blocks);
-		length = descriptor->length = be16_to_cpu(descriptor->length);
+		if (i)
+			continue;
+		/*
+		 * the code below is valid only for the 1st descriptor, ie i=0
+		 */
 
-		if (!i) 
-		{
-		switch (descriptor->dc) {
+		switch (pc.buffer[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
@@ -1259,23 +1246,25 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 				break;
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
-			if (memcmp(descriptor, &floppy->capacity, sizeof (idefloppy_capacity_descriptor_t)))
+			if (memcmp(cap_desc, &floppy->cap_desc, 8))
 				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
 					"sector size\n", drive->name,
 					blocks * length / 1024, blocks, length);
-			floppy->capacity = *descriptor;
+			memcpy(&floppy->cap_desc, cap_desc, 8);
+
 			if (!length || length % 512) {
 				printk(KERN_NOTICE "%s: %d bytes block size "
 					"not supported\n", drive->name, length);
 			} else {
-                                floppy->blocks = blocks;
-                                floppy->block_size = length;
-                                if ((floppy->bs_factor = length / 512) != 1)
-                                        printk(KERN_NOTICE "%s: warning: non "
+				floppy->blocks = blocks;
+				floppy->block_size = length;
+				floppy->bs_factor = length / 512;
+				if (floppy->bs_factor != 1)
+					printk(KERN_NOTICE "%s: warning: non "
 						"512 bytes block size not "
 						"fully supported\n",
 						drive->name);
-                                rc = 0;
+				rc = 0;
 			}
 			break;
 		case CAPACITY_NO_CARTRIDGE:
@@ -1290,52 +1279,42 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 				"in drive\n", drive->name);
 			break;
 		}
-		}
-		if (!i) {
-			debug_log("Descriptor 0 Code: %d\n", descriptor->dc);
-		}
-		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
-				i, blocks * length / 1024, blocks, length);
+		debug_log("Descriptor 0 Code: %d\n",
+			  pc.buffer[desc_start + 4] & 0x03);
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-        if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
 		(void) ide_floppy_get_flexible_disk_page(drive);
-	}
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
 	return rc;
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
+ * Very similar to ide_floppy_get_capacity, except that we push the capacity
+ * descriptors to userland, instead of our own structures.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_capacities {
+ *	int nformats;
+ *	struct {
+ *		int nblocks;
+ *		int blocksize;
+ *	} formats[];
+ * };
+ *
+ * userland initializes nformats to the number of allocated formats[] records.
+ * On exit we set nformats to the number of records we've actually initialized.
+ */
 
-static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
+static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
-        idefloppy_pc_t pc;
-	idefloppy_capacity_header_t *header;
-        idefloppy_capacity_descriptor_t *descriptor;
-	int i, descriptors, blocks, length;
-	int u_array_size;
-	int u_index;
+	idefloppy_pc_t pc;
+	u8 header_len, desc_cnt;
+	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
 
 	if (get_user(u_array_size, arg))
@@ -1347,30 +1326,27 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 	idefloppy_create_read_capacity_cmd(&pc);
 	if (idefloppy_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
-                return (-EIO);
-        }
-        header = (idefloppy_capacity_header_t *) pc.buffer;
-        descriptors = header->length /
-		sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+		return (-EIO);
+	}
+	header_len = pc.buffer[3];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
 	argp = arg + 1;
 
 	/*
-	** We always skip the first capacity descriptor.  That's the
-	** current capacity.  We are interested in the remaining descriptors,
-	** the formattable capacities.
-	*/
+	 * We always skip the first capacity descriptor.  That's the current
+	 * capacity.  We are interested in the remaining descriptors, the
+	 * formattable capacities.
+	 */
+	for (i = 1; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
 
-	for (i=0; i<descriptors; i++, descriptor++) {
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
-		if (i == 0)
-			continue;	/* Skip the first descriptor */
 
-		blocks = be32_to_cpu(descriptor->blocks);
-		length = be16_to_cpu(descriptor->length);
+		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return(-EFAULT);
@@ -1610,7 +1586,7 @@ static void idefloppy_setup (ide_drive_t *drive, idefloppy_floppy_t *floppy)
 	}
 
 
-	(void) idefloppy_get_capacity(drive);
+	(void) ide_floppy_get_capacity(drive);
 	idefloppy_add_settings(drive);
 }
 
@@ -1705,7 +1681,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		if (idefloppy_get_capacity (drive)
+		if (ide_floppy_get_capacity(drive)
 		   && (filp->f_flags & O_NDELAY) == 0
 		    /*
 		    ** Allow O_NDELAY to open a drive without a disk, or with
@@ -1809,7 +1785,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
-		return idefloppy_get_format_capacities(drive, argp);
+		return ide_floppy_get_format_capacities(drive, argp);
 	case IDEFLOPPY_IOCTL_FORMAT_START:
 
 		if (!(file->f_mode & 2))
-- 
1.5.3.7

