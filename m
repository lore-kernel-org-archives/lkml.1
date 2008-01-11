Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbYAKMIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbYAKMIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbYAKMEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:04:10 -0500
Received: from smtp106.plus.mail.re1.yahoo.com ([69.147.102.69]:26926 "HELO
	smtp106.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759942AbYAKMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=r+LhgxDF/nY5hJPQFdC/vhGxTfQCz8yv4YfyOkoS6M5PkvXtlN4zdkGFxVlnPbXDhUZLKx5dIo34Y2ibNpsSWgPYEMvoXm+sdsnNjKMB3bwW+KCYAjjRjyE12FFNQHo4tnvoGZrxDalaqzrsMp/um8Kqv1C0mSbpspiaGU3olwc=  ;
X-YMail-OSG: BK_ZI38VM1kQRHEx3phv.jguw_MZlMXE_WaY1VMv9yFFEImHU8K9o7NkN79z2FYM_K4xGnZMEA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 06/21] ide-floppy: remove struct idefloppy_flexible_disk_page
Date: Fri, 11 Jan 2008 12:58:04 +0100
Message-Id: <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver used to test whether the flexible disk page has changed by memcmp-ing
it with a cached copy of a previous version of the page from a different remo-
vable medium. Since, according to the SFF-8070i spec, the flexible disk page
"specifies parameters relating to the currently installed medium type," this
comparison is now done by simply checking whether the medium has changed.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   89 ++++++++++++++++-----------------------------
 1 files changed, 32 insertions(+), 57 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2b9885f..679d48e 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -120,33 +120,6 @@ typedef struct idefloppy_packet_command_s {
 #define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
 
 /*
- *	Flexible disk page.
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	ps		:1;	/* The device is capable of saving the page */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	ps		:1;	/* The device is capable of saving the page */
-	unsigned	reserved1_6	:1;	/* Reserved */
-	unsigned	page_code	:6;	/* Page code - Should be 0x5 */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		page_length;		/* Page Length - Should be 0x1e */
-	u16		transfer_rate;		/* In kilobits per second */
-	u8		heads, sectors;		/* Number of heads, Number of sectors per track */
-	u16		sector_size;		/* Byes per sector */
-	u16		cyls;			/* Number of cylinders */
-	u8		reserved10[10];
-	u8		motor_delay;		/* Motor off delay */
-	u8		reserved21[7];
-	u16		rpm;			/* Rotations per minute */
-	u8		reserved30[2];
-} idefloppy_flexible_disk_page_t;
- 
-/*
  *	Format capacity
  */
 typedef struct {
@@ -213,8 +186,6 @@ typedef struct ide_floppy_obj {
 	int blocks, block_size, bs_factor;
 	/* Last format capacity */
 	idefloppy_capacity_descriptor_t capacity;
-	/* Copy of the flexible disk page */
-	idefloppy_flexible_disk_page_t flexible_disk_page;
 	/* Write protect */
 	int wp;
 	/* Supports format progress report */
@@ -1188,50 +1159,54 @@ static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
 }
 
 /*
- *	Look at the flexible disk page parameters. We will ignore the CHS
- *	capacity parameters and use the LBA parameters instead.
+ * Look at the flexible disk page parameters. We will ignore the CHS capacity
+ * parameters and use the LBA parameters instead.
  */
-static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
+static int idefloppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
-	idefloppy_flexible_disk_page_t *page;
 	int capacity, lba_capacity;
+	u8 heads, sectors;
+	u16 transfer_rate, sector_size, cyls, rpm;
 
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE, MODE_SENSE_CURRENT);
-	if (idefloppy_queue_pc_tail(drive,&pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get flexible disk "
-			"page parameters\n");
+	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
+			MODE_SENSE_CURRENT);
+
+	if (idefloppy_queue_pc_tail(drive, &pc)) {
+		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
+				" parameters\n");
 		return 1;
 	}
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
-	floppy->wp = header->wp;
+	floppy->wp = pc.buffer[3] & 0x80;
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = (idefloppy_flexible_disk_page_t *) (header + 1);
-
-	page->transfer_rate = be16_to_cpu(page->transfer_rate);
-	page->sector_size = be16_to_cpu(page->sector_size);
-	page->cyls = be16_to_cpu(page->cyls);
-	page->rpm = be16_to_cpu(page->rpm);
-	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
-	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
+
+	transfer_rate = be16_to_cpu(*(u16 *)&pc.buffer[8 + 2]);
+	sector_size   = be16_to_cpu(*(u16 *)&pc.buffer[8 + 6]);
+	cyls          = be16_to_cpu(*(u16 *)&pc.buffer[8 + 8]);
+	rpm           = be16_to_cpu(*(u16 *)&pc.buffer[8 + 28]);
+	heads         = pc.buffer[8 + 4];
+	sectors       = pc.buffer[8 + 5];
+
+	capacity = cyls * heads * sectors * sector_size;
+
+	if ((1UL << IDEFLOPPY_MEDIA_CHANGED) & floppy->flags)
 		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
 				"%d sector size, %d rpm\n",
-			drive->name, capacity / 1024, page->cyls,
-			page->heads, page->sectors,
-			page->transfer_rate / 8, page->sector_size, page->rpm);
-
-	floppy->flexible_disk_page = *page;
-	drive->bios_cyl = page->cyls;
-	drive->bios_head = page->heads;
-	drive->bios_sect = page->sectors;
+			drive->name, capacity / 1024, cyls, heads, sectors,
+			transfer_rate / 8, sector_size, rpm);
+
+	drive->bios_cyl = cyls;
+	drive->bios_head = heads;
+	drive->bios_sect = sectors;
 	lba_capacity = floppy->blocks * floppy->block_size;
+
 	if (capacity < lba_capacity) {
 		printk(KERN_NOTICE "%s: The disk reports a capacity of %d "
 			"bytes, but the drive only handles %d\n",
 			drive->name, lba_capacity, capacity);
-		floppy->blocks = floppy->block_size ? capacity / floppy->block_size : 0;
+		floppy->blocks = floppy->block_size ?
+			capacity / floppy->block_size : 0;
 	}
 	return 0;
 }
-- 
1.5.3.7

