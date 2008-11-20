Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYKTFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYKTFmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYKTFl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:41:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:22877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYKTFlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:41:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=xWdwl0B18JkIH308T/HwygHC9jP+9zEg9hKrWh3hohMJGNxR8dOlKQiaSSVbQN4JQA
         JA5X5VsdxHuer4yrpxPq1Gp5a6f2uQG/24801spOe18nQqxgzeGkMKORqN/r1RTUpkcL
         X9ozseh2WE1ql7xd3JCaJ5hGTklmHzI6FPk7k=
To: <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/3] ide-floppy: allocate only toplevel packet commands
Date: Thu, 20 Nov 2008 06:41:23 +0100
Message-Id: <1227159683-2487-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
References: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the top-level function just allocate a single pc entry, and then
pass it down as a pointer to all the helper functions that also need one
of those "struct ide_atapi_pc" things. As far as I can tell, the use of
these things never overlaps each other, BUT I DID NOT CHECK VERY CLOSELY!

So I'm not guaranteeing this is correct, and I don't have the hardware. It
would be good for somebody who knows the code more, and has the hardware,
could please test this?

With this, ide-floppy still has fairly big stack usage, but instead of

	idefloppy_ioctl [vmlinux]:              1208
	ide_floppy_get_capacity [vmlinux]:      872
	idefloppy_release [vmlinux]:            408
	idefloppy_open [vmlinux]:               408

where those two first ones are at the very top of the list of stack users
for me, it's now

	ide_floppy_get_capacity [vmlinux]:           404
	ide_floppy_ioctl [vmlinux]:                  364

ie they are still high, but they are no longer at the top.

Borislav: Since ide_floppy_get_capacity is passed as a function pointer to other
parts of the kernel (e.g., block layer) we need that ide_atapi_pc to be created
on stack. Also, redid stack users numbers above. The two functions missing from
Linus' original 'make stackusage' output are due to ide being
rewritten/reorganized atm.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c       |   26 +++++++++---------
 drivers/ide/ide-floppy_ioctl.c |   58 ++++++++++++++++++++-------------------
 2 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index aeb1ad7..1f07f38 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -342,38 +342,38 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
  * Look at the flexible disk page parameters. We ignore the CHS capacity
  * parameters and use the LBA parameters instead.
  */
-static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
+static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive,
+					     struct ide_atapi_pc *pc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
-	struct ide_atapi_pc pc;
 	u8 *page;
 	int capacity, lba_capacity;
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
-	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
+	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
-	if (ide_queue_pc_tail(drive, disk, &pc)) {
+	if (ide_queue_pc_tail(drive, disk, pc)) {
 		printk(KERN_ERR PFX "Can't get flexible disk page params\n");
 		return 1;
 	}
 
-	if (pc.buf[3] & 0x80)
+	if (pc->buf[3] & 0x80)
 		drive->dev_flags |= IDE_DFLAG_WP;
 	else
 		drive->dev_flags &= ~IDE_DFLAG_WP;
 
 	set_disk_ro(disk, !!(drive->dev_flags & IDE_DFLAG_WP));
 
-	page = &pc.buf[8];
+	page = &pc->buf[8];
 
-	transfer_rate = be16_to_cpup((__be16 *)&pc.buf[8 + 2]);
-	sector_size   = be16_to_cpup((__be16 *)&pc.buf[8 + 6]);
-	cyls          = be16_to_cpup((__be16 *)&pc.buf[8 + 8]);
-	rpm           = be16_to_cpup((__be16 *)&pc.buf[8 + 28]);
-	heads         = pc.buf[8 + 4];
-	sectors       = pc.buf[8 + 5];
+	transfer_rate = be16_to_cpup((__be16 *)&pc->buf[8 + 2]);
+	sector_size   = be16_to_cpup((__be16 *)&pc->buf[8 + 6]);
+	cyls          = be16_to_cpup((__be16 *)&pc->buf[8 + 8]);
+	rpm           = be16_to_cpup((__be16 *)&pc->buf[8 + 28]);
+	heads         = pc->buf[8 + 4];
+	sectors       = pc->buf[8 + 5];
 
 	capacity = cyls * heads * sectors * sector_size;
 
@@ -499,7 +499,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
 
 	/* Clik! disk does not support get_flexible_disk_page */
 	if (!(drive->atapi_flags & IDE_AFLAG_CLIK_DRIVE))
-		(void) ide_floppy_get_flexible_disk_page(drive);
+		(void) ide_floppy_get_flexible_disk_page(drive, &pc);
 
 	return rc;
 }
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 2bc51ff..8f8be85 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -31,10 +31,11 @@
  * On exit we set nformats to the number of records we've actually initialized.
  */
 
-static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
+static int ide_floppy_get_format_capacities(ide_drive_t *drive,
+					    struct ide_atapi_pc *pc,
+					    int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
 	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
@@ -45,13 +46,13 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 	if (u_array_size <= 0)
 		return -EINVAL;
 
-	ide_floppy_create_read_capacity_cmd(&pc);
-	if (ide_queue_pc_tail(drive, floppy->disk, &pc)) {
+	ide_floppy_create_read_capacity_cmd(pc);
+	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
 	}
 
-	header_len = pc.buf[3];
+	header_len = pc->buf[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
 	u_index = 0;
@@ -68,8 +69,8 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 		if (u_index >= u_array_size)
 			break;	/* User-supplied buffer too small */
 
-		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
+		blocks = be32_to_cpup((__be32 *)&pc->buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc->buf[desc_start + 6]);
 
 		if (put_user(blocks, argp))
 			return -EFAULT;
@@ -111,29 +112,28 @@ static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
 	pc->flags |= PC_FLAG_WRITING;
 }
 
-static int ide_floppy_get_sfrp_bit(ide_drive_t *drive)
+static int ide_floppy_get_sfrp_bit(ide_drive_t *drive, struct ide_atapi_pc *pc)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
 
 	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
 
-	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE);
-	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
+	ide_floppy_create_mode_sense_cmd(pc, IDEFLOPPY_CAPABILITIES_PAGE);
+	pc->flags |= PC_FLAG_SUPPRESS_ERROR;
 
-	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc))
 		return 1;
 
-	if (pc.buf[8 + 2] & 0x40)
+	if (pc->buf[8 + 2] & 0x40)
 		drive->atapi_flags |= IDE_AFLAG_SRFP;
 
 	return 0;
 }
 
-static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
+static int ide_floppy_format_unit(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				  int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
 	int blocks, length, flags, err = 0;
 
 	if (floppy->openers > 1) {
@@ -166,10 +166,10 @@ static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
 		goto out;
 	}
 
-	(void)ide_floppy_get_sfrp_bit(drive);
-	ide_floppy_create_format_unit_cmd(&pc, blocks, length, flags);
+	ide_floppy_get_sfrp_bit(drive, pc);
+	ide_floppy_create_format_unit_cmd(pc, blocks, length, flags);
 
-	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+	if (ide_queue_pc_tail(drive, floppy->disk, pc))
 		err = -EIO;
 
 out:
@@ -188,15 +188,16 @@ out:
  * the dsc bit, and return either 0 or 65536.
  */
 
-static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
+static int ide_floppy_get_format_progress(ide_drive_t *drive,
+					  struct ide_atapi_pc *pc,
+					  int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
 	int progress_indication = 0x10000;
 
 	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
-		ide_create_request_sense_cmd(drive, &pc);
-		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+		ide_create_request_sense_cmd(drive, pc);
+		if (ide_queue_pc_tail(drive, floppy->disk, pc))
 			return -EIO;
 
 		if (floppy->sense_key == 2 &&
@@ -241,20 +242,21 @@ static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	return 0;
 }
 
-static int ide_floppy_format_ioctl(ide_drive_t *drive, fmode_t mode,
-				   unsigned int cmd, void __user *argp)
+static int ide_floppy_format_ioctl(ide_drive_t *drive, struct ide_atapi_pc *pc,
+				   fmode_t mode, unsigned int cmd,
+				   void __user *argp)
 {
 	switch (cmd) {
 	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
 		return 0;
 	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
-		return ide_floppy_get_format_capacities(drive, argp);
+		return ide_floppy_get_format_capacities(drive, pc, argp);
 	case IDEFLOPPY_IOCTL_FORMAT_START:
 		if (!(mode & FMODE_WRITE))
 			return -EPERM;
-		return ide_floppy_format_unit(drive, (int __user *)argp);
+		return ide_floppy_format_unit(drive, pc, (int __user *)argp);
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
-		return ide_floppy_get_format_progress(drive, argp);
+		return ide_floppy_get_format_progress(drive, pc, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -270,7 +272,7 @@ int ide_floppy_ioctl(ide_drive_t *drive, struct block_device *bdev,
 	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
 		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
 
-	err = ide_floppy_format_ioctl(drive, mode, cmd, argp);
+	err = ide_floppy_format_ioctl(drive, &pc, mode, cmd, argp);
 	if (err != -ENOTTY)
 		return err;
 
-- 
1.6.0.4

