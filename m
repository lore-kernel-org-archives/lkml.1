Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYIGWXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYIGWXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYIGWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:18:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64301 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbYIGWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=I0ceryWZ66sImt+LCWUcDkJ7Fn7HA/y07uSgZqasIsGMNkvgem0mc4fJkyCAzs6DnQ
         9HHLTV5HY+xQCyYMJHTDGw8czhbHOX+0wxMy4eyPW7RgFOSvCPVzAu/n0+dnZYqkKlAY
         lnLyycljFWSqLc2GywkRMHV8T80r4v8dm7FU0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:16:29 +0200
Message-Id: <20080907221629.24285.8506.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/18] ide: add generic ATA/ATAPI disk driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add struct ide_disk_ops containing protocol specific methods.

* Add 'struct ide_disk_ops *' to ide_drive_t.

* Convert ide-{disk,floppy} drivers to use struct ide_disk_ops.

* Merge ide-{disk,floppy} drivers into generic ide-gd driver.

While at it:
- ide_disk_init_capacity() -> ide_disk_get_capacity()

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig            |   64 +++-----
 drivers/ide/Makefile           |   19 +-
 drivers/ide/ide-disk.c         |   39 ++++-
 drivers/ide/ide-disk.h         |   24 +--
 drivers/ide/ide-disk_ioctl.c   |    4 
 drivers/ide/ide-floppy.c       |   45 ++++-
 drivers/ide/ide-floppy.h       |   58 +------
 drivers/ide/ide-floppy_ioctl.c |    9 -
 drivers/ide/ide-gd-floppy.c    |  309 -----------------------------------------
 drivers/ide/ide-gd.c           |  124 ++++++++++++++--
 drivers/ide/ide-gd.h           |   44 +++++
 drivers/leds/Kconfig           |    2 
 include/linux/ide.h            |   19 ++
 13 files changed, 305 insertions(+), 455 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -84,21 +84,40 @@ config BLK_DEV_IDE_SATA
 
 	  If unsure, say N.
 
-config BLK_DEV_IDEDISK
-	tristate "Include IDE/ATA-2 DISK support"
-	---help---
-	  This will include enhanced support for MFM/RLL/IDE hard disks.  If
-	  you have a MFM/RLL/IDE disk, and there is no special reason to use
-	  the old hard disk driver instead, say Y.  If you have an SCSI-only
-	  system, you can say N here.
+config IDE_GD
+	tristate "generic ATA/ATAPI disk support"
+	default y
+	help
+	  Support for ATA/ATAPI disks (including ATAPI floppy drives).
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called ide-disk.
-	  Do not compile this driver as a module if your root file system
-	  (the one containing the directory /) is located on the IDE disk.
+	  To compile this driver as a module, choose M here.
+	  The module will be called ide-gd_mod.
 
 	  If unsure, say Y.
 
+config IDE_GD_ATA
+	bool "ATA disk support"
+	depends on IDE_GD
+	default y
+	help
+	  This will include support for ATA hard disks.
+
+	  If unsure, say Y.
+
+config IDE_GD_ATAPI
+	bool "ATAPI floppy support"
+	depends on IDE_GD
+	select IDE_ATAPI
+	help
+	  This will include support for ATAPI floppy drives
+	  (i.e. Iomega ZIP or MKE LS-120).
+
+	  For information about jumper settings and the question
+	  of when a ZIP drive uses a partition table, see
+	  <http://www.win.tue.nl/~aeb/linux/zip/zip-1.html>.
+
+	  If unsure, say N.
+
 config BLK_DEV_IDECS
 	tristate "PCMCIA IDE support"
 	depends on PCMCIA
@@ -163,29 +182,6 @@ config BLK_DEV_IDETAPE
 	  To compile this driver as a module, choose M here: the
 	  module will be called ide-tape.
 
-config BLK_DEV_IDEFLOPPY
-	tristate "Include IDE/ATAPI FLOPPY support"
-	select IDE_ATAPI
-	---help---
-	  If you have an IDE floppy drive which uses the ATAPI protocol,
-	  answer Y.  ATAPI is a newer protocol used by IDE CD-ROM/tape/floppy
-	  drives, similar to the SCSI protocol.
-
-	  The LS-120 and the IDE/ATAPI Iomega ZIP drive are also supported by
-	  this driver. For information about jumper settings and the question
-	  of when a ZIP drive uses a partition table, see
-	  <http://www.win.tue.nl/~aeb/linux/zip/zip-1.html>.
-	  (ATAPI PD-CD/CDR drives are not supported by this driver; support
-	  for PD-CD/CDR drives is available if you answer Y to
-	  "SCSI emulation support", below).
-
-	  If you say Y here, the FLOPPY drive will be identified along with
-	  other IDE devices, as "hdb" or "hdc", or something similar (check
-	  the boot messages with dmesg).
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called ide-floppy.
-
 config BLK_DEV_IDESCSI
 	tristate "SCSI emulation support (DEPRECATED)"
 	depends on SCSI
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -37,18 +37,25 @@ obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
-ide-disk_mod-y += ide-gd.o ide-disk.o ide-disk_ioctl.o
+ide-gd_mod-y += ide-gd.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
-ide-floppy_mod-y += ide-gd-floppy.o ide-floppy.o ide-floppy_ioctl.o
 
+ifeq ($(CONFIG_IDE_GD_ATA), y)
+	ide-gd_mod-y += ide-disk.o ide-disk_ioctl.o
 ifeq ($(CONFIG_IDE_PROC_FS), y)
-	ide-disk_mod-y += ide-disk_proc.o
-	ide-floppy_mod-y += ide-floppy_proc.o
+	ide-gd_mod-y += ide-disk_proc.o
+endif
+endif
+
+ifeq ($(CONFIG_IDE_GD_ATAPI), y)
+	ide-gd_mod-y += ide-floppy.o ide-floppy_ioctl.o
+ifeq ($(CONFIG_IDE_PROC_FS), y)
+	ide-gd_mod-y += ide-floppy_proc.o
+endif
 endif
 
-obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk_mod.o
+obj-$(CONFIG_IDE_GD)			+= ide-gd_mod.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
-obj-$(CONFIG_BLK_DEV_IDEFLOPPY)		+= ide-floppy_mod.o
 obj-$(CONFIG_BLK_DEV_IDETAPE)		+= ide-tape.o
 
 ifeq ($(CONFIG_BLK_DEV_IDECS), y)
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -184,8 +184,8 @@ static ide_startstop_t __ide_do_rw_disk(
  * 1073741822 == 549756 MB or 48bit addressing fake drive
  */
 
-ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
-			       sector_t block)
+static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
+				      sector_t block)
 {
 	ide_hwif_t *hwif = HWIF(drive);
 
@@ -333,7 +333,7 @@ static void idedisk_check_hpa(ide_drive_
 	}
 }
 
-void ide_disk_init_capacity(ide_drive_t *drive)
+static int ide_disk_get_capacity(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
 	int lba;
@@ -382,6 +382,8 @@ void ide_disk_init_capacity(ide_drive_t 
 		} else
 			drive->dev_flags &= ~IDE_DFLAG_LBA48;
 	}
+
+	return 0;
 }
 
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
@@ -590,7 +592,12 @@ ide_ext_devset_rw(wcache, wcache);
 
 ide_ext_devset_rw_sync(nowerr, nowerr);
 
-void ide_disk_setup(ide_drive_t *drive)
+static int ide_disk_check(ide_drive_t *drive, const char *s)
+{
+	return 1;
+}
+
+static void ide_disk_setup(ide_drive_t *drive)
 {
 	struct ide_disk_obj *idkp = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
@@ -626,7 +633,7 @@ void ide_disk_setup(ide_drive_t *drive)
 			 drive->queue->max_sectors / 2);
 
 	/* calculate drive capacity, and select LBA if possible */
-	ide_disk_init_capacity(drive);
+	ide_disk_get_capacity(drive);
 
 	/*
 	 * if possible, give fdisk access to more of the drive,
@@ -682,7 +689,7 @@ void ide_disk_setup(ide_drive_t *drive)
 		drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
 
-void ide_disk_flush(ide_drive_t *drive)
+static void ide_disk_flush(ide_drive_t *drive)
 {
 	if (ata_id_flush_enabled(drive->id) == 0 ||
 	    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0)
@@ -692,7 +699,13 @@ void ide_disk_flush(ide_drive_t *drive)
 		printk(KERN_INFO "%s: wcache flush failed!\n", drive->name);
 }
 
-int ide_disk_set_doorlock(ide_drive_t *drive, int on)
+static int ide_disk_init_media(ide_drive_t *drive, struct gendisk *disk)
+{
+	return 0;
+}
+
+static int ide_disk_set_doorlock(ide_drive_t *drive, struct gendisk *disk,
+				 int on)
 {
 	ide_task_t task;
 	int ret;
@@ -711,3 +724,15 @@ int ide_disk_set_doorlock(ide_drive_t *d
 
 	return ret;
 }
+
+const struct ide_disk_ops ide_ata_disk_ops = {
+	.check		= ide_disk_check,
+	.get_capacity	= ide_disk_get_capacity,
+	.setup		= ide_disk_setup,
+	.flush		= ide_disk_flush,
+	.init_media	= ide_disk_init_media,
+	.set_doorlock	= ide_disk_set_doorlock,
+	.do_request	= ide_do_rw_disk,
+	.end_request	= ide_end_request,
+	.ioctl		= ide_disk_ioctl,
+};
Index: b/drivers/ide/ide-disk.h
===================================================================
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -1,22 +1,11 @@
 #ifndef __IDE_DISK_H
 #define __IDE_DISK_H
 
-struct ide_disk_obj {
-	ide_drive_t	*drive;
-	ide_driver_t	*driver;
-	struct gendisk	*disk;
-	struct kref	kref;
-	unsigned int	openers;	/* protected by BKL for now */
-};
-
-sector_t ide_gd_capacity(ide_drive_t *);
+#include "ide-gd.h"
 
+#ifdef CONFIG_IDE_GD_ATA
 /* ide-disk.c */
-void ide_disk_init_capacity(ide_drive_t *);
-void ide_disk_setup(ide_drive_t *);
-void ide_disk_flush(ide_drive_t *);
-int ide_disk_set_doorlock(ide_drive_t *, int);
-ide_startstop_t ide_do_rw_disk(ide_drive_t *, struct request *, sector_t);
+extern const struct ide_disk_ops ide_ata_disk_ops;
 ide_decl_devset(address);
 ide_decl_devset(multcount);
 ide_decl_devset(nowerr);
@@ -24,12 +13,17 @@ ide_decl_devset(wcache);
 ide_decl_devset(acoustic);
 
 /* ide-disk_ioctl.c */
-int ide_disk_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+int ide_disk_ioctl(ide_drive_t *, struct inode *, struct file *, unsigned int,
+		   unsigned long);
 
 #ifdef CONFIG_IDE_PROC_FS
 /* ide-disk_proc.c */
 extern ide_proc_entry_t ide_disk_proc[];
 extern const struct ide_proc_devset ide_disk_settings[];
 #endif
+#else
+#define ide_disk_proc		NULL
+#define ide_disk_settings	NULL
+#endif
 
 #endif /* __IDE_DISK_H */
Index: b/drivers/ide/ide-disk_ioctl.c
===================================================================
--- a/drivers/ide/ide-disk_ioctl.c
+++ b/drivers/ide/ide-disk_ioctl.c
@@ -13,12 +13,10 @@ static const struct ide_ioctl_devset ide
 { 0 }
 };
 
-int ide_disk_ioctl(struct inode *inode, struct file *file,
+int ide_disk_ioctl(ide_drive_t *drive, struct inode *inode, struct file *file,
 		   unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct ide_disk_obj *idkp = ide_drv_g(bdev->bd_disk, ide_disk_obj);
-	ide_drive_t *drive = idkp->drive;
 	int err;
 
 	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -68,7 +68,7 @@
  * Used to finish servicing a request. For read/write requests, we will call
  * ide_end_request to pass to the next buffer.
  */
-int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
+static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -280,13 +280,12 @@ static void idefloppy_blockpc_cmd(ideflo
 	pc->req_xfer = pc->buf_size = rq->data_len;
 }
 
-ide_startstop_t ide_floppy_do_request(ide_drive_t *drive, struct request *rq,
-				      sector_t block_s)
+static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
+					     struct request *rq, sector_t block)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc;
-	unsigned long block = (unsigned long)block_s;
 
 	ide_debug_log(IDE_DBG_FUNC, "%s: dev: %s, cmd: 0x%x, cmd_type: %x, "
 		      "errors: %d\n",
@@ -316,7 +315,7 @@ ide_startstop_t ide_floppy_do_request(id
 			return ide_stopped;
 		}
 		pc = &floppy->queued_pc;
-		idefloppy_create_rw_cmd(drive, pc, rq, block);
+		idefloppy_create_rw_cmd(drive, pc, rq, (unsigned long)block);
 	} else if (blk_special_request(rq)) {
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	} else if (blk_pc_request(rq)) {
@@ -406,7 +405,7 @@ static int ide_floppy_get_flexible_disk_
  * Determine if a media is present in the floppy drive, and if so, its LBA
  * capacity.
  */
-int ide_floppy_get_capacity(ide_drive_t *drive)
+static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
@@ -505,9 +504,9 @@ int ide_floppy_get_capacity(ide_drive_t 
 	return rc;
 }
 
-void ide_floppy_setup(ide_drive_t *drive)
+static void ide_floppy_setup(ide_drive_t *drive)
 {
-	struct ide_floppy_obj *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	u16 *id = drive->id;
 
 	drive->pc_callback	 = ide_floppy_callback;
@@ -547,3 +546,33 @@ void ide_floppy_setup(ide_drive_t *drive
 
 	drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
+
+static void ide_floppy_flush(ide_drive_t *drive)
+{
+}
+
+static int ide_floppy_init_media(ide_drive_t *drive, struct gendisk *disk)
+{
+	int ret = 0;
+
+	if (ide_do_test_unit_ready(drive, disk))
+		ide_do_start_stop(drive, disk, 1);
+
+	ret = ide_floppy_get_capacity(drive);
+
+	set_capacity(disk, ide_gd_capacity(drive));
+
+	return ret;
+}
+
+const struct ide_disk_ops ide_atapi_disk_ops = {
+	.check		= ide_check_atapi_device,
+	.get_capacity	= ide_floppy_get_capacity,
+	.setup		= ide_floppy_setup,
+	.flush		= ide_floppy_flush,
+	.init_media	= ide_floppy_init_media,
+	.set_doorlock	= ide_set_media_lock,
+	.do_request	= ide_floppy_do_request,
+	.end_request	= ide_floppy_end_request,
+	.ioctl		= ide_floppy_ioctl,
+};
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -1,48 +1,10 @@
 #ifndef __IDE_FLOPPY_H
 #define __IDE_FLOPPY_H
 
-#define DRV_NAME "ide-floppy"
-#define PFX DRV_NAME ": "
+#include "ide-gd.h"
 
-/* define to see debug info */
-#define IDEFLOPPY_DEBUG_LOG	0
-
-#if IDEFLOPPY_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
-#else
-#define ide_debug_log(lvl, fmt, args...) do {} while (0)
-#endif
-
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
-	/* Last failed packet command */
-	struct ide_atapi_pc *failed_pc;
-	/* used for blk_{fs,pc}_request() requests */
-	struct ide_atapi_pc queued_pc;
-
-	/* Last error information */
-	u8 sense_key, asc, ascq;
-
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
+#ifdef CONFIG_IDE_GD_ATAPI
+typedef struct ide_disk_obj idefloppy_floppy_t;
 
 /*
  * Pages of the SELECT SENSE / MODE SENSE packet commands.
@@ -57,23 +19,23 @@ typedef struct ide_floppy_obj {
 #define	IDEFLOPPY_IOCTL_FORMAT_START		0x4602
 #define IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS	0x4603
 
-sector_t ide_gd_capacity(ide_drive_t *);
-
 /* ide-floppy.c */
+extern const struct ide_disk_ops ide_atapi_disk_ops;
 void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
-int ide_floppy_get_capacity(ide_drive_t *);
-void ide_floppy_setup(ide_drive_t *);
-ide_startstop_t ide_floppy_do_request(ide_drive_t *, struct request *, sector_t);
-int ide_floppy_end_request(ide_drive_t *, int, int);
 
 /* ide-floppy_ioctl.c */
-int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
+int ide_floppy_ioctl(ide_drive_t *, struct inode *, struct file *, unsigned int,
+		     unsigned long);
 
 #ifdef CONFIG_IDE_PROC_FS
 /* ide-floppy_proc.c */
 extern ide_proc_entry_t ide_floppy_proc[];
 extern const struct ide_proc_devset ide_floppy_settings[];
 #endif
+#else
+#define ide_floppy_proc		NULL
+#define ide_floppy_settings	NULL
+#endif
 
 #endif /*__IDE_FLOPPY_H */
Index: b/drivers/ide/ide-floppy_ioctl.c
===================================================================
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -33,7 +33,7 @@
 
 static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
-	struct ide_floppy_obj *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
@@ -260,13 +260,10 @@ static int ide_floppy_format_ioctl(ide_d
 	}
 }
 
-int ide_floppy_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+int ide_floppy_ioctl(ide_drive_t *drive, struct inode *inode,
+		     struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = inode->i_bdev;
-	struct ide_floppy_obj *floppy = ide_drv_g(bdev->bd_disk,
-						     ide_floppy_obj);
-	ide_drive_t *drive = floppy->drive;
 	struct ide_atapi_pc pc;
 	void __user *argp = (void __user *)arg;
 	int err;
Index: b/drivers/ide/ide-gd-floppy.c
===================================================================
--- a/drivers/ide/ide-gd-floppy.c
+++ /dev/null
@@ -1,309 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/genhd.h>
-#include <linux/mutex.h>
-#include <linux/ide.h>
-#include <linux/hdreg.h>
-
-#include "ide-floppy.h"
-
-#define IDEFLOPPY_VERSION "1.00"
-
-/* module parameters */
-static unsigned long debug_mask;
-module_param(debug_mask, ulong, 0644);
-
-static DEFINE_MUTEX(ide_disk_ref_mutex);
-
-static void ide_disk_release(struct kref *);
-
-static struct ide_floppy_obj *ide_disk_get(struct gendisk *disk)
-{
-	struct ide_floppy_obj *idkp = NULL;
-
-	mutex_lock(&ide_disk_ref_mutex);
-	idkp = ide_drv_g(disk, ide_floppy_obj);
-	if (idkp) {
-		if (ide_device_get(idkp->drive))
-			idkp = NULL;
-		else
-			kref_get(&idkp->kref);
-	}
-	mutex_unlock(&ide_disk_ref_mutex);
-	return idkp;
-}
-
-static void ide_disk_put(struct ide_floppy_obj *idkp)
-{
-	ide_drive_t *drive = idkp->drive;
-
-	mutex_lock(&ide_disk_ref_mutex);
-	kref_put(&idkp->kref, ide_disk_release);
-	ide_device_put(drive);
-	mutex_unlock(&ide_disk_ref_mutex);
-}
-
-sector_t ide_gd_capacity(ide_drive_t *drive)
-{
-	return drive->capacity64;
-}
-
-static int ide_gd_probe(ide_drive_t *);
-
-static void ide_gd_remove(ide_drive_t *drive)
-{
-	struct ide_floppy_obj *idkp = drive->driver_data;
-	struct gendisk *g = idkp->disk;
-
-	ide_proc_unregister_driver(drive, idkp->driver);
-
-	del_gendisk(g);
-
-	ide_disk_put(idkp);
-}
-
-static void ide_disk_release(struct kref *kref)
-{
-	struct ide_floppy_obj *idkp = to_ide_drv(kref, ide_floppy_obj);
-	ide_drive_t *drive = idkp->drive;
-	struct gendisk *g = idkp->disk;
-
-	drive->driver_data = NULL;
-	g->private_data = NULL;
-	put_disk(g);
-	kfree(idkp);
-}
-
-#ifdef CONFIG_IDE_PROC_FS
-static ide_proc_entry_t *ide_floppy_proc_entries(ide_drive_t *drive)
-{
-	return ide_floppy_proc;
-}
-
-static const struct ide_proc_devset *ide_floppy_proc_devsets(ide_drive_t *drive)
-{
-	return ide_floppy_settings;
-}
-#endif
-
-static ide_driver_t ide_gd_driver = {
-	.gen_driver = {
-		.owner		= THIS_MODULE,
-		.name		= "ide-floppy",
-		.bus		= &ide_bus_type,
-	},
-	.probe			= ide_gd_probe,
-	.remove			= ide_gd_remove,
-	.version		= IDEFLOPPY_VERSION,
-	.do_request		= ide_floppy_do_request,
-	.end_request		= ide_floppy_end_request,
-	.error			= __ide_error,
-#ifdef CONFIG_IDE_PROC_FS
-	.proc_entries		= ide_floppy_proc_entries,
-	.proc_devsets		= ide_floppy_proc_devsets,
-#endif
-};
-
-static int ide_gd_open(struct inode *inode, struct file *filp)
-{
-	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *idkp;
-	ide_drive_t *drive;
-	int ret = 0;
-
-	idkp = ide_disk_get(disk);
-	if (idkp == NULL)
-		return -ENXIO;
-
-	drive = idkp->drive;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	idkp->openers++;
-
-	if (idkp->openers == 1) {
-		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
-		/* Just in case */
-
-		if (ide_do_test_unit_ready(drive, disk))
-			ide_do_start_stop(drive, disk, 1);
-
-		ret = ide_floppy_get_capacity(drive);
-
-		set_capacity(disk, ide_gd_capacity(drive));
-
-		if (ret && (filp->f_flags & O_NDELAY) == 0) {
-		    /*
-		     * Allow O_NDELAY to open a drive without a disk, or with an
-		     * unreadable disk, so that we can get the format capacity
-		     * of the drive or begin the format - Sam
-		     */
-			ret = -EIO;
-			goto out_put_idkp;
-		}
-
-		if ((drive->dev_flags & IDE_DFLAG_WP) && (filp->f_mode & 2)) {
-			ret = -EROFS;
-			goto out_put_idkp;
-		}
-
-		ide_set_media_lock(drive, disk, 1);
-		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
-		check_disk_change(inode->i_bdev);
-	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
-		ret = -EBUSY;
-		goto out_put_idkp;
-	}
-	return 0;
-
-out_put_idkp:
-	idkp->openers--;
-	ide_disk_put(idkp);
-	return ret;
-}
-
-static int ide_gd_release(struct inode *inode, struct file *filp)
-{
-	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct ide_floppy_obj *idkp = ide_drv_g(disk, ide_floppy_obj);
-	ide_drive_t *drive = idkp->drive;
-
-	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
-
-	if (idkp->openers == 1) {
-		ide_set_media_lock(drive, disk, 0);
-		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
-	}
-
-	idkp->openers--;
-
-	ide_disk_put(idkp);
-
-	return 0;
-}
-
-static int ide_gd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
-{
-	struct ide_floppy_obj *idkp = ide_drv_g(bdev->bd_disk, ide_floppy_obj);
-	ide_drive_t *drive = idkp->drive;
-
-	geo->heads = drive->bios_head;
-	geo->sectors = drive->bios_sect;
-	geo->cylinders = (u16)drive->bios_cyl; /* truncate */
-	return 0;
-}
-
-static int ide_gd_media_changed(struct gendisk *disk)
-{
-	struct ide_floppy_obj *idkp = ide_drv_g(disk, ide_floppy_obj);
-	ide_drive_t *drive = idkp->drive;
-	int ret;
-
-	/* do not scan partitions twice if this is a removable device */
-	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
-		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
-		return 0;
-	}
-
-	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
-	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
-
-	return ret;
-}
-
-static int ide_gd_revalidate_disk(struct gendisk *disk)
-{
-	struct ide_floppy_obj *idkp = ide_drv_g(disk, ide_floppy_obj);
-	set_capacity(disk, ide_gd_capacity(idkp->drive));
-	return 0;
-}
-
-static struct block_device_operations ide_gd_ops = {
-	.owner			= THIS_MODULE,
-	.open			= ide_gd_open,
-	.release		= ide_gd_release,
-	.ioctl			= ide_floppy_ioctl,
-	.getgeo			= ide_gd_getgeo,
-	.media_changed		= ide_gd_media_changed,
-	.revalidate_disk	= ide_gd_revalidate_disk
-};
-
-static int ide_gd_probe(ide_drive_t *drive)
-{
-	struct ide_floppy_obj *idkp;
-	struct gendisk *g;
-
-	if (!strstr("ide-floppy", drive->driver_req))
-		goto failed;
-
-	if (drive->media != ide_floppy)
-		goto failed;
-
-	if (!ide_check_atapi_device(drive, DRV_NAME)) {
-		printk(KERN_ERR PFX "%s: not supported by this version of "
-		       DRV_NAME "\n", drive->name);
-		goto failed;
-	}
-	idkp = kzalloc(sizeof(*idkp), GFP_KERNEL);
-	if (!idkp) {
-		printk(KERN_ERR PFX "%s: Can't allocate a floppy structure\n",
-		       drive->name);
-		goto failed;
-	}
-
-	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
-	if (!g)
-		goto out_free_idkp;
-
-	ide_init_disk(g, drive);
-
-	kref_init(&idkp->kref);
-
-	idkp->drive = drive;
-	idkp->driver = &ide_gd_driver;
-	idkp->disk = g;
-
-	g->private_data = &idkp->driver;
-
-	drive->driver_data = idkp;
-
-	drive->debug_mask = debug_mask;
-
-	ide_floppy_setup(drive);
-
-	set_capacity(g, ide_gd_capacity(drive));
-
-	g->minors = 1 << PARTN_BITS;
-	g->driverfs_dev = &drive->gendev;
-	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
-		g->flags = GENHD_FL_REMOVABLE;
-	g->fops = &ide_gd_ops;
-	add_disk(g);
-	return 0;
-
-out_free_idkp:
-	kfree(idkp);
-failed:
-	return -ENODEV;
-}
-
-static int __init ide_gd_init(void)
-{
-	printk(KERN_INFO DRV_NAME " driver " IDEFLOPPY_VERSION "\n");
-	return driver_register(&ide_gd_driver.gen_driver);
-}
-
-static void __exit ide_gd_exit(void)
-{
-	driver_unregister(&ide_gd_driver.gen_driver);
-}
-
-MODULE_ALIAS("ide:*m-floppy*");
-MODULE_ALIAS("ide-floppy");
-module_init(ide_gd_init);
-module_exit(ide_gd_exit);
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -9,9 +9,14 @@
 #include <linux/hdreg.h>
 
 #include "ide-disk.h"
+#include "ide-floppy.h"
 
 #define IDE_GD_VERSION	"1.18"
 
+/* module parameters */
+static unsigned long debug_mask;
+module_param(debug_mask, ulong, 0644);
+
 static DEFINE_MUTEX(ide_disk_ref_mutex);
 
 static void ide_disk_release(struct kref *);
@@ -58,7 +63,7 @@ static void ide_gd_remove(ide_drive_t *d
 
 	del_gendisk(g);
 
-	ide_disk_flush(drive);
+	drive->disk_ops->flush(drive);
 
 	ide_disk_put(idkp);
 }
@@ -69,6 +74,7 @@ static void ide_disk_release(struct kref
 	ide_drive_t *drive = idkp->drive;
 	struct gendisk *g = idkp->disk;
 
+	drive->disk_ops = NULL;
 	drive->driver_data = NULL;
 	g->private_data = NULL;
 	put_disk(g);
@@ -83,7 +89,7 @@ static void ide_disk_release(struct kref
 static void ide_gd_resume(ide_drive_t *drive)
 {
 	if (ata_id_hpa_enabled(drive->id))
-		ide_disk_init_capacity(drive);
+		(void)drive->disk_ops->get_capacity(drive);
 }
 
 static void ide_gd_shutdown(ide_drive_t *drive)
@@ -104,7 +110,7 @@ static void ide_gd_shutdown(ide_drive_t 
 #else
 	if (system_state == SYSTEM_RESTART) {
 #endif
-		ide_disk_flush(drive);
+		drive->disk_ops->flush(drive);
 		return;
 	}
 
@@ -116,19 +122,31 @@ static void ide_gd_shutdown(ide_drive_t 
 #ifdef CONFIG_IDE_PROC_FS
 static ide_proc_entry_t *ide_disk_proc_entries(ide_drive_t *drive)
 {
-	return ide_disk_proc;
+	return (drive->media == ide_disk) ? ide_disk_proc : ide_floppy_proc;
 }
 
 static const struct ide_proc_devset *ide_disk_proc_devsets(ide_drive_t *drive)
 {
-	return ide_disk_settings;
+	return (drive->media == ide_disk) ? ide_disk_settings
+					  : ide_floppy_settings;
 }
 #endif
 
+static ide_startstop_t ide_gd_do_request(ide_drive_t *drive,
+					 struct request *rq, sector_t sector)
+{
+	return drive->disk_ops->do_request(drive, rq, sector);
+}
+
+static int ide_gd_end_request(ide_drive_t *drive, int uptodate, int nrsecs)
+{
+	return drive->disk_ops->end_request(drive, uptodate, nrsecs);
+}
+
 static ide_driver_t ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
-		.name		= "ide-disk",
+		.name		= "ide-gd",
 		.bus		= &ide_bus_type,
 	},
 	.probe			= ide_gd_probe,
@@ -136,8 +154,8 @@ static ide_driver_t ide_gd_driver = {
 	.resume			= ide_gd_resume,
 	.shutdown		= ide_gd_shutdown,
 	.version		= IDE_GD_VERSION,
-	.do_request		= ide_do_rw_disk,
-	.end_request		= ide_end_request,
+	.do_request		= ide_gd_do_request,
+	.end_request		= ide_gd_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_disk_proc_entries,
@@ -150,6 +168,7 @@ static int ide_gd_open(struct inode *ino
 	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct ide_disk_obj *idkp;
 	ide_drive_t *drive;
+	int ret = 0;
 
 	idkp = ide_disk_get(disk);
 	if (idkp == NULL)
@@ -157,19 +176,49 @@ static int ide_gd_open(struct inode *ino
 
 	drive = idkp->drive;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	idkp->openers++;
 
 	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
+		/* Just in case */
+
+		ret = drive->disk_ops->init_media(drive, disk);
+
+		/*
+		 * Allow O_NDELAY to open a drive without a disk, or with an
+		 * unreadable disk, so that we can get the format capacity
+		 * of the drive or begin the format - Sam
+		 */
+		if (ret && (filp->f_flags & O_NDELAY) == 0) {
+			ret = -EIO;
+			goto out_put_idkp;
+		}
+
+		if ((drive->dev_flags & IDE_DFLAG_WP) && (filp->f_mode & 2)) {
+			ret = -EROFS;
+			goto out_put_idkp;
+		}
+
 		/*
 		 * Ignore the return code from door_lock,
 		 * since the open() has already succeeded,
 		 * and the door_lock is irrelevant at this point.
 		 */
-		ide_disk_set_doorlock(drive, 1);
+		drive->disk_ops->set_doorlock(drive, disk, 1);
 		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 		check_disk_change(inode->i_bdev);
+	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
+		ret = -EBUSY;
+		goto out_put_idkp;
 	}
 	return 0;
+
+out_put_idkp:
+	idkp->openers--;
+	ide_disk_put(idkp);
+	return ret;
 }
 
 static int ide_gd_release(struct inode *inode, struct file *filp)
@@ -178,11 +227,15 @@ static int ide_gd_release(struct inode *
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
 	ide_drive_t *drive = idkp->drive;
 
+	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
+
 	if (idkp->openers == 1)
-		ide_disk_flush(drive);
+		drive->disk_ops->flush(drive);
 
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1)
-		ide_disk_set_doorlock(drive, 0);
+	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+		drive->disk_ops->set_doorlock(drive, disk, 0);
+		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
+	}
 
 	idkp->openers--;
 
@@ -227,11 +280,21 @@ static int ide_gd_revalidate_disk(struct
 	return 0;
 }
 
+static int ide_gd_ioctl(struct inode *inode, struct file *file,
+			     unsigned int cmd, unsigned long arg)
+{
+	struct block_device *bdev = inode->i_bdev;
+	struct ide_disk_obj *idkp = ide_drv_g(bdev->bd_disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+
+	return drive->disk_ops->ioctl(drive, inode, file, cmd, arg);
+}
+
 static struct block_device_operations ide_gd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= ide_gd_open,
 	.release		= ide_gd_release,
-	.ioctl			= ide_disk_ioctl,
+	.ioctl			= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
 	.media_changed		= ide_gd_media_changed,
 	.revalidate_disk	= ide_gd_revalidate_disk
@@ -239,19 +302,37 @@ static struct block_device_operations id
 
 static int ide_gd_probe(ide_drive_t *drive)
 {
+	const struct ide_disk_ops *disk_ops = NULL;
 	struct ide_disk_obj *idkp;
 	struct gendisk *g;
 
 	/* strstr("foo", "") is non-NULL */
-	if (!strstr("ide-disk", drive->driver_req))
+	if (!strstr("ide-gd", drive->driver_req))
 		goto failed;
 
-	if (drive->media != ide_disk)
+#ifdef CONFIG_IDE_GD_ATA
+	if (drive->media == ide_disk)
+		disk_ops = &ide_ata_disk_ops;
+#endif
+#ifdef CONFIG_IDE_GD_ATAPI
+	if (drive->media == ide_floppy)
+		disk_ops = &ide_atapi_disk_ops;
+#endif
+	if (disk_ops == NULL)
+		goto failed;
+
+	if (disk_ops->check(drive, DRV_NAME) == 0) {
+		printk(KERN_ERR PFX "%s: not supported by this driver\n",
+			drive->name);
 		goto failed;
+	}
 
 	idkp = kzalloc(sizeof(*idkp), GFP_KERNEL);
-	if (!idkp)
+	if (!idkp) {
+		printk(KERN_ERR PFX "%s: can't allocate a disk structure\n",
+			drive->name);
 		goto failed;
+	}
 
 	g = alloc_disk_node(1 << PARTN_BITS, hwif_to_node(drive->hwif));
 	if (!g)
@@ -269,7 +350,11 @@ static int ide_gd_probe(ide_drive_t *dri
 
 	drive->driver_data = idkp;
 
-	ide_disk_setup(drive);
+	drive->debug_mask = debug_mask;
+
+	drive->disk_ops = disk_ops;
+
+	disk_ops->setup(drive);
 
 	set_capacity(g, ide_gd_capacity(drive));
 
@@ -289,6 +374,7 @@ failed:
 
 static int __init ide_gd_init(void)
 {
+	printk(KERN_INFO DRV_NAME " driver " IDE_GD_VERSION "\n");
 	return driver_register(&ide_gd_driver.gen_driver);
 }
 
@@ -299,7 +385,9 @@ static void __exit ide_gd_exit(void)
 
 MODULE_ALIAS("ide:*m-disk*");
 MODULE_ALIAS("ide-disk");
+MODULE_ALIAS("ide:*m-floppy*");
+MODULE_ALIAS("ide-floppy");
 module_init(ide_gd_init);
 module_exit(ide_gd_exit);
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("ATA DISK Driver");
+MODULE_DESCRIPTION("generic ATA/ATAPI disk driver");
Index: b/drivers/ide/ide-gd.h
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-gd.h
@@ -0,0 +1,44 @@
+#ifndef __IDE_GD_H
+#define __IDE_GD_H
+
+#define DRV_NAME "ide-gd"
+#define PFX DRV_NAME ": "
+
+/* define to see debug info */
+#define IDE_GD_DEBUG_LOG	0
+
+#if IDE_GD_DEBUG_LOG
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#else
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
+struct ide_disk_obj {
+	ide_drive_t	*drive;
+	ide_driver_t	*driver;
+	struct gendisk	*disk;
+	struct kref	kref;
+	unsigned int	openers;	/* protected by BKL for now */
+
+	/* Last failed packet command */
+	struct ide_atapi_pc *failed_pc;
+	/* used for blk_{fs,pc}_request() requests */
+	struct ide_atapi_pc queued_pc;
+
+	/* Last error information */
+	u8 sense_key, asc, ascq;
+
+	int progress_indication;
+
+	/* Device information */
+	/* Current format */
+	int blocks, block_size, bs_factor;
+	/* Last format capacity descriptor */
+	u8 cap_desc[8];
+	/* Copy of the flexible disk page */
+	u8 flexible_disk_page[32];
+};
+
+sector_t ide_gd_capacity(ide_drive_t *);
+
+#endif /* __IDE_GD_H */
Index: b/drivers/leds/Kconfig
===================================================================
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -185,7 +185,7 @@ config LEDS_TRIGGER_TIMER
 
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
-	depends on LEDS_TRIGGERS && BLK_DEV_IDEDISK
+	depends on LEDS_TRIGGERS && IDE_GD_ATA
 	help
 	  This allows LEDs to be controlled by IDE disk activity.
 	  If unsure, say Y.
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -459,6 +459,23 @@ struct ide_acpi_drive_link;
 struct ide_acpi_hwif_link;
 #endif
 
+struct ide_drive_s;
+
+struct ide_disk_ops {
+	int		(*check)(struct ide_drive_s *, const char *);
+	int		(*get_capacity)(struct ide_drive_s *);
+	void		(*setup)(struct ide_drive_s *);
+	void		(*flush)(struct ide_drive_s *);
+	int		(*init_media)(struct ide_drive_s *, struct gendisk *);
+	int		(*set_doorlock)(struct ide_drive_s *, struct gendisk *,
+					int);
+	ide_startstop_t	(*do_request)(struct ide_drive_s *, struct request *,
+				      sector_t);
+	int		(*end_request)(struct ide_drive_s *, int, int);
+	int		(*ioctl)(struct ide_drive_s *, struct inode *,
+				 struct file *, unsigned int, unsigned long);
+};
+
 /* ATAPI device flags */
 enum {
 	IDE_AFLAG_DRQ_INTERRUPT		= (1 << 0),
@@ -586,6 +603,8 @@ struct ide_drive_s {
 #endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
+	const struct ide_disk_ops *disk_ops;
+
 	unsigned long dev_flags;
 
 	unsigned long sleep;		/* sleep until this time */
