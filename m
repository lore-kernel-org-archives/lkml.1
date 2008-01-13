Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYAMUW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYAMUW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYAMUWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:05 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:49069 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753355AbYAMUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=D1PwNvSeuZwGi7G35+iUFf48/y/6dpp5tjWZLLXWralSkaB+H5fvNS+xTS861v74U9WzM9Ys4H/B9SX8keTjzUiOyNOcv/FFvjggBWTs83mSpf9COazXKpVHN/wEnHWJoryFxkHatZgZH7YMiUgxzyN2mi06c/P3pZFCjNQDPEA=  ;
X-YMail-OSG: pgTPA5YVM1liYB8h8FXaHkPsqmlKO9VvMgAkXMAIhAGzMDrh_8BcdZ4yGC44Ad_SbOQtaEex.A--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 2/12] ide-floppy: remove struct idefloppy_flexible_disk_page
Date: Sun, 13 Jan 2008 21:18:15 +0100
Message-Id: <1200255505-31418-3-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
 <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   90 ++++++++++++++++++---------------------------
 1 files changed, 36 insertions(+), 54 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 7648684..06d83cb 100644
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
@@ -214,7 +187,7 @@ typedef struct ide_floppy_obj {
 	/* Last format capacity */
 	idefloppy_capacity_descriptor_t capacity;
 	/* Copy of the flexible disk page */
-	idefloppy_flexible_disk_page_t flexible_disk_page;
+	u8 flexible_disk_page[32];
 	/* Write protect */
 	int wp;
 	/* Supports format progress report */
@@ -1170,48 +1143,57 @@ static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
 }
 
 /*
- *	Look at the flexible disk page parameters. We will ignore the CHS
- *	capacity parameters and use the LBA parameters instead.
+ * Look at the flexible disk page parameters. We ignore the CHS capacity
+ * parameters and use the LBA parameters instead.
  */
-static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
+static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_flexible_disk_page_t *page;
+	u8 *page;
 	int capacity, lba_capacity;
+	u16 transfer_rate, sector_size, cyls, rpm;
+	u8 heads, sectors;
 
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE, MODE_SENSE_CURRENT);
-	if (idefloppy_queue_pc_tail(drive,&pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get flexible disk "
-			"page parameters\n");
+	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
+					MODE_SENSE_CURRENT);
+
+	if (idefloppy_queue_pc_tail(drive, &pc)) {
+		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
+				" parameters\n");
 		return 1;
 	}
 	floppy->wp = !!(pc.buffer[3] & 0x80);
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = (idefloppy_flexible_disk_page_t *) &pc.buffer[8];
-
-	page->transfer_rate = be16_to_cpu(page->transfer_rate);
-	page->sector_size = be16_to_cpu(page->sector_size);
-	page->cyls = be16_to_cpu(page->cyls);
-	page->rpm = be16_to_cpu(page->rpm);
-	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
-	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
+	page = &pc.buffer[8];
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
+	if (memcmp(page, &floppy->flexible_disk_page, 32))
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
+				drive->name, capacity / 1024, cyls, heads,
+				sectors, transfer_rate / 8, sector_size, rpm);
+
+	memcpy(&floppy->flexible_disk_page, page, 32);
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
@@ -1318,7 +1300,7 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
 
 	/* Clik! disk does not support get_flexible_disk_page */
         if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
-		(void) idefloppy_get_flexible_disk_page(drive);
+		(void) ide_floppy_get_flexible_disk_page(drive);
 	}
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
-- 
1.5.3.7

