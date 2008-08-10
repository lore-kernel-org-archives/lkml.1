Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYHJPln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYHJPln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYHJPix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:13064 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbYHJPiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pE6w4wNVgCqWRUCvmcGsRyece56M/SNBPv4j8KIWkc9v6ysXMEAj2SlPrW21iFpocT
         b64SwJCfOVaGAcfvQFlbM1iDigRQ2IFupTD/cKPYOuX2QbByN9SJTRSmFRa3O3zpznGW
         qlvptduYocQxwhf3Q9EESzPGwLbPgjd7OO1/A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:38 +0200
Message-Id: <20080810153638.16255.87650.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/22] ide-floppy: move floppy ioctls handling to ide-floppy_ioctl.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

- idefloppy_create_read_capacity_cmd() -> ide_floppy_create_read_capacity_cmd()
- idefloppy_create_mode_sense_cmd() -> ide_floppy_create_mode_sense_cmd()
- idefloppy_create_request_sense_cmd() -> ide_floppy_create_request_sense_cmd()
- idefloppy_create_format_unit_cmd() -> ide_floppy_create_format_unit_cmd()
- idefloppy_get_sfrp_bit() -> ide_floppy_get_sfrp_bit()

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile           |    3 
 drivers/ide/ide-floppy.c       |  296 +----------------------------------------
 drivers/ide/ide-floppy.h       |   63 ++++++++
 drivers/ide/ide-floppy_ioctl.c |  243 +++++++++++++++++++++++++++++++++
 4 files changed, 317 insertions(+), 288 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -37,11 +37,12 @@ obj-$(CONFIG_IDE_GENERIC)		+= ide-generi
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
+ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
+obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy_mod.o
 obj-$(CONFIG_BLK_DEV_IDETAPE)		+= ide-tape.o
-obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy.o
 
 ifeq ($(CONFIG_BLK_DEV_IDECS), y)
 	ide-cs-core-y += legacy/ide-cs.o
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -45,6 +45,8 @@
 #include <linux/io.h>
 #include <asm/unaligned.h>
 
+#include "ide-floppy.h"
+
 /* define to see debug info */
 #define IDEFLOPPY_DEBUG_LOG		0
 
@@ -74,61 +76,11 @@
 #define CAPACITY_CURRENT	0x02
 #define CAPACITY_NO_CARTRIDGE	0x03
 
-/*
- * Most of our global data which we need to save even as we leave the driver
- * due to an interrupt or a timer event is stored in a variable of type
- * idefloppy_floppy_t, defined below.
- */
-typedef struct ide_floppy_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
-
-	/* Current packet command */
-	struct ide_atapi_pc *pc;
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
-	/* used for blk_{fs,pc}_request() requests */
-	struct ide_atapi_pc queued_pc;
-
-	struct ide_atapi_pc request_sense_pc;
-	struct request request_sense_rq;
-
-	/* Last error information */
-	u8 sense_key, asc, ascq;
-	/* delay this long before sending packet command */
-	u8 ticks;
-	int progress_indication;
-
-	/* Device information */
-	/* Current format */
-	int blocks, block_size, bs_factor;
-	/* Last format capacity descriptor */
-	u8 cap_desc[8];
-	/* Copy of the flexible disk page */
-	u8 flexible_disk_page[32];
-} idefloppy_floppy_t;
-
 #define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
 
-/* IOCTLs used in low-level formatting. */
-#define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
-#define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
-#define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
-#define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
-
 /* Error code returned in rq->errors to the higher part of the driver. */
 #define	IDEFLOPPY_ERROR_GENERAL		101
 
-/*
- * Pages of the SELECT SENSE / MODE SENSE packet commands.
- * See SFF-8070i spec.
- */
-#define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
-#define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
-
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
 #define to_ide_floppy(obj) container_of(obj, struct ide_floppy_obj, kref)
@@ -244,7 +196,7 @@ static void ide_floppy_callback(ide_driv
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
+void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
 {
 	ide_init_pc(pc);
 	pc->c[0] = GPCMD_REQUEST_SENSE;
@@ -263,7 +215,7 @@ static void idefloppy_retry_pc(ide_drive
 	struct ide_atapi_pc *pc = &floppy->request_sense_pc;
 
 	(void)ide_read_error(drive);
-	idefloppy_create_request_sense_cmd(pc);
+	ide_floppy_create_request_sense_cmd(pc);
 	ide_queue_pc_head(drive, floppy->disk, pc, rq);
 }
 
@@ -381,7 +333,7 @@ static void idefloppy_create_prevent_cmd
 	pc->c[4] = prevent;
 }
 
-static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
+void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
 {
 	ide_init_pc(pc);
 	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
@@ -390,30 +342,8 @@ static void idefloppy_create_read_capaci
 	pc->req_xfer = 255;
 }
 
-static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
-		int l, int flags)
-{
-	ide_init_pc(pc);
-	pc->c[0] = GPCMD_FORMAT_UNIT;
-	pc->c[1] = 0x17;
-
-	memset(pc->buf, 0, 12);
-	pc->buf[1] = 0xA2;
-	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
-
-	if (flags & 1)				/* Verify bit on... */
-		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
-	pc->buf[3] = 8;
-
-	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
-	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
-	pc->buf_size = 12;
-	pc->flags |= PC_FLAG_WRITING;
-}
-
 /* A mode sense command is used to "sense" floppy parameters. */
-static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
-					    u8 page_code)
+void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *pc, u8 page_code)
 {
 	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 
@@ -562,7 +492,7 @@ static int ide_floppy_get_flexible_disk_
 	u16 transfer_rate, sector_size, cyls, rpm;
 	u8 heads, sectors;
 
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
+	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE);
 
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
@@ -610,25 +540,6 @@ static int ide_floppy_get_flexible_disk_
 	return 0;
 }
 
-static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
-
-	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
-
-	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE);
-	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
-
-	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
-		return 1;
-
-	if (pc.buf[8 + 2] & 0x40)
-		drive->atapi_flags |= IDE_AFLAG_SRFP;
-
-	return 0;
-}
-
 /*
  * Determine if a media is present in the floppy drive, and if so, its LBA
  * capacity.
@@ -648,7 +559,7 @@ static int ide_floppy_get_capacity(ide_d
 	floppy->bs_factor = 1;
 	set_capacity(floppy->disk, 0);
 
-	idefloppy_create_read_capacity_cmd(&pc);
+	ide_floppy_create_read_capacity_cmd(&pc);
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return 1;
@@ -729,129 +640,6 @@ static int ide_floppy_get_capacity(ide_d
 	return rc;
 }
 
-/*
- * Obtain the list of formattable capacities.
- * Very similar to ide_floppy_get_capacity, except that we push the capacity
- * descriptors to userland, instead of our own structures.
- *
- * Userland gives us the following structure:
- *
- * struct idefloppy_format_capacities {
- *	int nformats;
- *	struct {
- *		int nblocks;
- *		int blocksize;
- *	} formats[];
- * };
- *
- * userland initializes nformats to the number of allocated formats[] records.
- * On exit we set nformats to the number of records we've actually initialized.
- */
-
-static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
-{
-	struct ide_floppy_obj *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
-	u8 header_len, desc_cnt;
-	int i, blocks, length, u_array_size, u_index;
-	int __user *argp;
-
-	if (get_user(u_array_size, arg))
-		return -EFAULT;
-
-	if (u_array_size <= 0)
-		return -EINVAL;
-
-	idefloppy_create_read_capacity_cmd(&pc);
-	if (ide_queue_pc_tail(drive, floppy->disk, &pc)) {
-		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
-		return -EIO;
-	}
-
-	header_len = pc.buf[3];
-	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
-
-	u_index = 0;
-	argp = arg + 1;
-
-	/*
-	 * We always skip the first capacity descriptor.  That's the current
-	 * capacity.  We are interested in the remaining descriptors, the
-	 * formattable capacities.
-	 */
-	for (i = 1; i < desc_cnt; i++) {
-		unsigned int desc_start = 4 + i*8;
-
-		if (u_index >= u_array_size)
-			break;	/* User-supplied buffer too small */
-
-		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
-		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
-
-		if (put_user(blocks, argp))
-			return -EFAULT;
-
-		++argp;
-
-		if (put_user(length, argp))
-			return -EFAULT;
-
-		++argp;
-
-		++u_index;
-	}
-
-	if (put_user(u_index, arg))
-		return -EFAULT;
-
-	return 0;
-}
-
-/*
- * Get ATAPI_FORMAT_UNIT progress indication.
- *
- * Userland gives a pointer to an int.  The int is set to a progress
- * indicator 0-65536, with 65536=100%.
- *
- * If the drive does not support format progress indication, we just check
- * the dsc bit, and return either 0 or 65536.
- */
-
-static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
-	int progress_indication = 0x10000;
-
-	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
-		idefloppy_create_request_sense_cmd(&pc);
-		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
-			return -EIO;
-
-		if (floppy->sense_key == 2 &&
-		    floppy->asc == 4 &&
-		    floppy->ascq == 4)
-			progress_indication = floppy->progress_indication;
-
-		/* Else assume format_unit has finished, and we're at 0x10000 */
-	} else {
-		ide_hwif_t *hwif = drive->hwif;
-		unsigned long flags;
-		u8 stat;
-
-		local_irq_save(flags);
-		stat = hwif->tp_ops->read_status(hwif);
-		local_irq_restore(flags);
-
-		progress_indication = ((stat & ATA_DSC) == 0) ? 0 : 0x10000;
-	}
-
-	if (put_user(progress_indication, arg))
-		return -EFAULT;
-
-	return 0;
-}
-
 static sector_t idefloppy_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
@@ -1117,73 +905,6 @@ static int ide_floppy_lockdoor(ide_drive
 	return 0;
 }
 
-static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	struct ide_atapi_pc pc;
-	int blocks, length, flags, err = 0;
-
-	if (floppy->openers > 1) {
-		/* Don't format if someone is using the disk */
-		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
-		return -EBUSY;
-	}
-
-	drive->atapi_flags |= IDE_AFLAG_FORMAT_IN_PROGRESS;
-
-	/*
-	 * Send ATAPI_FORMAT_UNIT to the drive.
-	 *
-	 * Userland gives us the following structure:
-	 *
-	 * struct idefloppy_format_command {
-	 *        int nblocks;
-	 *        int blocksize;
-	 *        int flags;
-	 *        } ;
-	 *
-	 * flags is a bitmask, currently, the only defined flag is:
-	 *
-	 *        0x01 - verify media after format.
-	 */
-	if (get_user(blocks, arg) ||
-			get_user(length, arg+1) ||
-			get_user(flags, arg+2)) {
-		err = -EFAULT;
-		goto out;
-	}
-
-	(void) idefloppy_get_sfrp_bit(drive);
-	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
-
-	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
-		err = -EIO;
-
-out:
-	if (err)
-		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
-	return err;
-}
-
-static int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
-				   unsigned int cmd, void __user *argp)
-{
-	switch (cmd) {
-	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
-		return 0;
-	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
-		return ide_floppy_get_format_capacities(drive, argp);
-	case IDEFLOPPY_IOCTL_FORMAT_START:
-		if (!(file->f_mode & 2))
-			return -EPERM;
-		return ide_floppy_format_unit(drive, (int __user *)argp);
-	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
-		return ide_floppy_get_format_progress(drive, argp);
-	default:
-		return -ENOTTY;
-	}
-}
-
 static int idefloppy_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
@@ -1315,6 +1036,7 @@ static int __init idefloppy_init(void)
 }
 
 MODULE_ALIAS("ide:*m-floppy*");
+MODULE_ALIAS("ide-floppy");
 module_init(idefloppy_init);
 module_exit(idefloppy_exit);
 MODULE_LICENSE("GPL");
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-floppy.h
@@ -0,0 +1,63 @@
+#ifndef __IDE_FLOPPY_H
+#define __IDE_FLOPPY_H
+
+/*
+ * Most of our global data which we need to save even as we leave the driver
+ * due to an interrupt or a timer event is stored in a variable of type
+ * idefloppy_floppy_t, defined below.
+ */
+typedef struct ide_floppy_obj {
+	ide_drive_t	*drive;
+	ide_driver_t	*driver;
+	struct gendisk	*disk;
+	struct kref	kref;
+	unsigned int	openers;	/* protected by BKL for now */
+
+	/* Current packet command */
+	struct ide_atapi_pc *pc;
+	/* Last failed packet command */
+	struct ide_atapi_pc *failed_pc;
+	/* used for blk_{fs,pc}_request() requests */
+	struct ide_atapi_pc queued_pc;
+
+	struct ide_atapi_pc request_sense_pc;
+	struct request request_sense_rq;
+
+	/* Last error information */
+	u8 sense_key, asc, ascq;
+	/* delay this long before sending packet command */
+	u8 ticks;
+	int progress_indication;
+
+	/* Device information */
+	/* Current format */
+	int blocks, block_size, bs_factor;
+	/* Last format capacity descriptor */
+	u8 cap_desc[8];
+	/* Copy of the flexible disk page */
+	u8 flexible_disk_page[32];
+} idefloppy_floppy_t;
+
+/*
+ * Pages of the SELECT SENSE / MODE SENSE packet commands.
+ * See SFF-8070i spec.
+ */
+#define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
+#define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
+
+/* IOCTLs used in low-level formatting. */
+#define	IDEFLOPPY_IOCTL_FORMAT_SUPPORTED	0x4600
+#define	IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY	0x4601
+#define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
+#define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
+
+/* ide-floppy.c */
+void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
+void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
+void ide_floppy_create_request_sense_cmd(struct ide_atapi_pc *);
+
+/* ide-floppy_ioctl.c */
+int ide_floppy_format_ioctl(ide_drive_t *, struct file *, unsigned int,
+			    void __user *);
+
+#endif /*__IDE_FLOPPY_H */
Index: b/drivers/ide/ide-floppy_ioctl.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -0,0 +1,243 @@
+/*
+ * ide-floppy IOCTLs handling.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/cdrom.h>
+
+#include <asm/unaligned.h>
+
+#include <scsi/scsi_ioctl.h>
+
+#include "ide-floppy.h"
+
+/*
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
+
+static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
+{
+	struct ide_floppy_obj *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+	u8 header_len, desc_cnt;
+	int i, blocks, length, u_array_size, u_index;
+	int __user *argp;
+
+	if (get_user(u_array_size, arg))
+		return -EFAULT;
+
+	if (u_array_size <= 0)
+		return -EINVAL;
+
+	ide_floppy_create_read_capacity_cmd(&pc);
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc)) {
+		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
+		return -EIO;
+	}
+
+	header_len = pc.buf[3];
+	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
+
+	u_index = 0;
+	argp = arg + 1;
+
+	/*
+	 * We always skip the first capacity descriptor.  That's the current
+	 * capacity.  We are interested in the remaining descriptors, the
+	 * formattable capacities.
+	 */
+	for (i = 1; i < desc_cnt; i++) {
+		unsigned int desc_start = 4 + i*8;
+
+		if (u_index >= u_array_size)
+			break;	/* User-supplied buffer too small */
+
+		blocks = be32_to_cpup((__be32 *)&pc.buf[desc_start]);
+		length = be16_to_cpup((__be16 *)&pc.buf[desc_start + 6]);
+
+		if (put_user(blocks, argp))
+			return -EFAULT;
+
+		++argp;
+
+		if (put_user(length, argp))
+			return -EFAULT;
+
+		++argp;
+
+		++u_index;
+	}
+
+	if (put_user(u_index, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
+static void ide_floppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
+		int l, int flags)
+{
+	ide_init_pc(pc);
+	pc->c[0] = GPCMD_FORMAT_UNIT;
+	pc->c[1] = 0x17;
+
+	memset(pc->buf, 0, 12);
+	pc->buf[1] = 0xA2;
+	/* Default format list header, u8 1: FOV/DCRT/IMM bits set */
+
+	if (flags & 1)				/* Verify bit on... */
+		pc->buf[1] ^= 0x20;		/* ... turn off DCRT bit */
+	pc->buf[3] = 8;
+
+	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buf[4]));
+	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buf[8]));
+	pc->buf_size = 12;
+	pc->flags |= PC_FLAG_WRITING;
+}
+
+static int ide_floppy_get_sfrp_bit(ide_drive_t *drive)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+
+	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
+
+	ide_floppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE);
+	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
+
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+		return 1;
+
+	if (pc.buf[8 + 2] & 0x40)
+		drive->atapi_flags |= IDE_AFLAG_SRFP;
+
+	return 0;
+}
+
+static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+	int blocks, length, flags, err = 0;
+
+	if (floppy->openers > 1) {
+		/* Don't format if someone is using the disk */
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
+		return -EBUSY;
+	}
+
+	drive->atapi_flags |= IDE_AFLAG_FORMAT_IN_PROGRESS;
+
+	/*
+	 * Send ATAPI_FORMAT_UNIT to the drive.
+	 *
+	 * Userland gives us the following structure:
+	 *
+	 * struct idefloppy_format_command {
+	 *        int nblocks;
+	 *        int blocksize;
+	 *        int flags;
+	 *        } ;
+	 *
+	 * flags is a bitmask, currently, the only defined flag is:
+	 *
+	 *        0x01 - verify media after format.
+	 */
+	if (get_user(blocks, arg) ||
+			get_user(length, arg+1) ||
+			get_user(flags, arg+2)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	(void)ide_floppy_get_sfrp_bit(drive);
+	ide_floppy_create_format_unit_cmd(&pc, blocks, length, flags);
+
+	if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+		err = -EIO;
+
+out:
+	if (err)
+		drive->atapi_flags &= ~IDE_AFLAG_FORMAT_IN_PROGRESS;
+	return err;
+}
+
+/*
+ * Get ATAPI_FORMAT_UNIT progress indication.
+ *
+ * Userland gives a pointer to an int.  The int is set to a progress
+ * indicator 0-65536, with 65536=100%.
+ *
+ * If the drive does not support format progress indication, we just check
+ * the dsc bit, and return either 0 or 65536.
+ */
+
+static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc pc;
+	int progress_indication = 0x10000;
+
+	if (drive->atapi_flags & IDE_AFLAG_SRFP) {
+		ide_floppy_create_request_sense_cmd(&pc);
+		if (ide_queue_pc_tail(drive, floppy->disk, &pc))
+			return -EIO;
+
+		if (floppy->sense_key == 2 &&
+		    floppy->asc == 4 &&
+		    floppy->ascq == 4)
+			progress_indication = floppy->progress_indication;
+
+		/* Else assume format_unit has finished, and we're at 0x10000 */
+	} else {
+		ide_hwif_t *hwif = drive->hwif;
+		unsigned long flags;
+		u8 stat;
+
+		local_irq_save(flags);
+		stat = hwif->tp_ops->read_status(hwif);
+		local_irq_restore(flags);
+
+		progress_indication = ((stat & ATA_DSC) == 0) ? 0 : 0x10000;
+	}
+
+	if (put_user(progress_indication, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
+int ide_floppy_format_ioctl(ide_drive_t *drive, struct file *file,
+			    unsigned int cmd, void __user *argp)
+{
+	switch (cmd) {
+	case IDEFLOPPY_IOCTL_FORMAT_SUPPORTED:
+		return 0;
+	case IDEFLOPPY_IOCTL_FORMAT_GET_CAPACITY:
+		return ide_floppy_get_format_capacities(drive, argp);
+	case IDEFLOPPY_IOCTL_FORMAT_START:
+		if (!(file->f_mode & 2))
+			return -EPERM;
+		return ide_floppy_format_unit(drive, (int __user *)argp);
+	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
+		return ide_floppy_get_format_progress(drive, argp);
+	default:
+		return -ENOTTY;
+	}
+}
