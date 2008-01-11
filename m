Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbYAKMIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbYAKMIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760766AbYAKMEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:04:07 -0500
Received: from smtp115.plus.mail.re1.yahoo.com ([69.147.102.78]:34577 "HELO
	smtp115.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759709AbYAKMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=mVBieThdjzE9Tjq708p+X2KUJz0rmkPQRf5VnUrHbOlJtHrcvfJYg5oV6sNwvoBpHf465A+32q3jKOY7x7URI9qO35amG39DwHhuBKaCrkAZ8ZCw1sj9W3YzedjIBH9mDnIXoh57JEY9bLOFZTumTkj9+OtW/g1s5gL2zADK6Go=  ;
X-YMail-OSG: r55GGvEVM1m3btd1A2l5Pxky_Kqst5SwidKLUDHU.kaFlZSsZvW1Y6M5FvJFiC4VqeN0PBE8Jw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 07/21] ide-floppy: remove struct idefloppy_capacity_descriptor
Date: Fri, 11 Jan 2008 12:58:05 +0100
Message-Id: <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We test here for updated capacity descriptors by checking whether the media
has changed instead of memcmp-ing with a cached copy of the capacity
descriptors.

Also:

- remove one of 2 consecutive if (!i)-tests.
- start loop at 1 in idefloppy_get_format_capacities() since userspace doesn't
need the current/maximum capacity descriptor. i.e the first one.
- fix comments formatting

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  132 +++++++++++++++++----------------------------
 1 files changed, 50 insertions(+), 82 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 679d48e..5c85833 100644
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
@@ -184,8 +162,6 @@ typedef struct ide_floppy_obj {
 	 */
 	/* Current format */
 	int blocks, block_size, bs_factor;
-	/* Last format capacity */
-	idefloppy_capacity_descriptor_t capacity;
 	/* Write protect */
 	int wp;
 	/* Supports format progress report */
@@ -1229,17 +1205,16 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
 }
 
 /*
- *	Determine if a media is present in the floppy drive, and if so,
- *	its LBA capacity.
+ * Determine if a media is present in the floppy drive, and if so, its LBA
+ * capacity.
  */
-static int idefloppy_get_capacity (ide_drive_t *drive)
+static int idefloppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_capacity_header_t *header;
-	idefloppy_capacity_descriptor_t *descriptor;
-	int i, descriptors, rc = 1, blocks, length;
-	
+	int i, desc_cnt, rc = 1, blocks, length;
+	u8 header_len;
+
 	drive->bios_cyl = 0;
 	drive->bios_head = drive->bios_sect = 0;
 	floppy->blocks = 0;
@@ -1251,17 +1226,17 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
 	}
-	header = (idefloppy_capacity_header_t *) pc.buffer;
-	descriptors = header->length / sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
+	header_len = pc.buffer[3];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
-	for (i = 0; i < descriptors; i++, descriptor++) {
-		blocks = descriptor->blocks = be32_to_cpu(descriptor->blocks);
-		length = descriptor->length = be16_to_cpu(descriptor->length);
+	for (i = 0; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
+		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
+		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);
 
-		if (!i) 
+		if (!i)
 		{
-		switch (descriptor->dc) {
+		switch (pc.buffer[desc_start + 4] & 0x03) {
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
@@ -1272,11 +1247,11 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 				break;
 		case CAPACITY_CURRENT:
 			/* Normal Zip/LS-120 disks */
-			if (memcmp(descriptor, &floppy->capacity, sizeof (idefloppy_capacity_descriptor_t)))
+			if ((1UL << IDEFLOPPY_MEDIA_CHANGED) & floppy->flags)
 				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
 					"sector size\n", drive->name,
 					blocks * length / 1024, blocks, length);
-			floppy->capacity = *descriptor;
+
 			if (!length || length % 512) {
 				printk(KERN_NOTICE "%s: %d bytes block size "
 					"not supported\n", drive->name, length);
@@ -1303,9 +1278,8 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 				"in drive\n", drive->name);
 			break;
 		}
-		}
-		if (!i) {
-			debug_log("Descriptor 0 Code: %d\n", descriptor->dc);
+		debug_log("Descriptor 0 Code: %d\n",
+				pc.buffer[desc_start + 4] & 0x03);
 		}
 		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
 				i, blocks * length / 1024, blocks, length);
@@ -1321,35 +1295,32 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
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
+ * Very similar to idefloppy_get_capacity, except that we push the capacity
+ * descriptors to userland, instead of our own structures.
+ *
+ * Userland gives us the following structure:
+ *
+ * struct idefloppy_format_capacities {
+ *        int nformats;
+ *        struct {
+ *                int nblocks;
+ *                int blocksize;
+ *                } formats[];
+ *        } ;
+ *
+ * userland initializes nformats to the number of allocated formats[]
+ * records.  On exit we set nformats to the number of records we've
+ * actually initialized.
+ *
+ */
 
 static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
         idefloppy_pc_t pc;
-	idefloppy_capacity_header_t *header;
-        idefloppy_capacity_descriptor_t *descriptor;
-	int i, descriptors, blocks, length;
-	int u_array_size;
-	int u_index;
+	int i, desc_cnt, blocks, length, u_array_size, u_index;
 	int __user *argp;
+	u8 header_len;
 
 	if (get_user(u_array_size, arg))
 		return (-EFAULT);
@@ -1362,28 +1333,25 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
                 return (-EIO);
         }
-        header = (idefloppy_capacity_header_t *) pc.buffer;
-        descriptors = header->length /
-		sizeof(idefloppy_capacity_descriptor_t);
-	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
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
-- 
1.5.3.7

