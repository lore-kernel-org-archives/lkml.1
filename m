Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0BAOJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:09:14 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58995 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0BAOJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bzTQ53QBiKCBJ8CR2m1ds10PnZr0IMDJFxqd7YF9iTVRBcERGDPhV9a2yHw/K5M1Vl
         1n2syqDrkqxSZj5zb7shq6GxEd8flbwAhUFFRb0TEaSb9oIBcGrrZhJR0pzIXVT/wZb9
         LTTE7clpWP+EHMTZoueeTlRkAcMCvYThdekCc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 01 Feb 2010 15:08:57 +0100
Message-Id: <20100201140857.15716.98386.sendpatchset@localhost>
In-Reply-To: <20100201140832.15716.393.sendpatchset@localhost>
References: <20100201140832.15716.393.sendpatchset@localhost>
Subject: [PATCH 4/4] ide: remove obsolete /proc/ide/ interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove obsolete /proc/ide/ interface

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig           |   11 
 drivers/ide/Makefile          |    7 
 drivers/ide/ide-cd.c          |   48 ----
 drivers/ide/ide-disk.c        |    3 
 drivers/ide/ide-disk.h        |    7 
 drivers/ide/ide-disk_proc.c   |  152 -------------
 drivers/ide/ide-floppy.c      |    3 
 drivers/ide/ide-floppy.h      |    7 
 drivers/ide/ide-floppy_proc.c |   32 --
 drivers/ide/ide-gd.c          |   11 
 drivers/ide/ide-probe.c       |    9 
 drivers/ide/ide-proc.c        |  481 ------------------------------------------
 drivers/ide/ide-tape.c        |   41 ---
 drivers/ide/ide.c             |    4 
 include/linux/ide.h           |   41 ---
 15 files changed, 857 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -208,17 +208,6 @@ config IDE_TASK_IOCTL
 
 	  If you are unsure, say N here.
 
-config IDE_PROC_FS
-	bool "legacy /proc/ide/ support"
-	depends on IDE && PROC_FS
-	default y
-	help
-	  This option enables support for the various files in
-	  /proc/ide.  In Linux 2.6 this has been superseded by
-	  files in sysfs but many legacy applications rely on this.
-
-	  If unsure say Y.
-
 comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -14,7 +14,6 @@ ide-core-$(CONFIG_IDE_ATAPI)		+= ide-ata
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA_SFF)	+= ide-dma-sff.o
-ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
 ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
 ide-core-$(CONFIG_IDE_LEGACY)		+= ide-legacy.o
 
@@ -87,16 +86,10 @@ ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o
 
 ifeq ($(CONFIG_IDE_GD_ATA), y)
 	ide-gd_mod-y += ide-disk.o ide-disk_ioctl.o
-ifeq ($(CONFIG_IDE_PROC_FS), y)
-	ide-gd_mod-y += ide-disk_proc.o
-endif
 endif
 
 ifeq ($(CONFIG_IDE_GD_ATAPI), y)
 	ide-gd_mod-y += ide-floppy.o ide-floppy_ioctl.o
-ifeq ($(CONFIG_IDE_PROC_FS), y)
-	ide-gd_mod-y += ide-floppy_proc.o
-endif
 endif
 
 obj-$(CONFIG_IDE_GD)			+= ide-gd_mod.o
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1379,49 +1379,6 @@ struct cd_list_entry {
 	unsigned int	cd_flags;
 };
 
-#ifdef CONFIG_IDE_PROC_FS
-static sector_t ide_cdrom_capacity(ide_drive_t *drive)
-{
-	unsigned long capacity, sectors_per_frame;
-
-	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
-		return 0;
-
-	return capacity * sectors_per_frame;
-}
-
-static int idecd_capacity_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t *drive = m->private;
-
-	seq_printf(m, "%llu\n", (long long)ide_cdrom_capacity(drive));
-	return 0;
-}
-
-static int idecd_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idecd_capacity_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idecd_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idecd_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static ide_proc_entry_t idecd_proc[] = {
-	{ "capacity", S_IFREG|S_IRUGO, &idecd_capacity_proc_fops },
-	{}
-};
-
-static ide_proc_entry_t *ide_cd_proc_entries(ide_drive_t *drive)
-{
-	return idecd_proc;
-}
-#endif
-
 static const struct cd_list_entry ide_cd_quirks_list[] = {
 	/* SCR-3231 doesn't support the SET_CD_SPEED command. */
 	{ "SAMSUNG CD-ROM SCR-3231", NULL,   IDE_AFLAG_NO_SPEED_SELECT	     },
@@ -1521,7 +1478,6 @@ static int ide_cdrom_setup(ide_drive_t *
 		return 1;
 	}
 
-	ide_proc_register_driver(drive, cd->driver);
 	return 0;
 }
 
@@ -1531,7 +1487,6 @@ static void ide_cd_remove(ide_drive_t *d
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
-	ide_proc_unregister_driver(drive, info->driver);
 	device_del(&info->dev);
 	del_gendisk(info->disk);
 
@@ -1571,9 +1526,6 @@ static struct ide_driver ide_cdrom_drive
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
 	.do_request		= ide_cd_do_request,
-#ifdef CONFIG_IDE_PROC_FS
-	.proc_entries		= ide_cd_proc_entries,
-#endif
 };
 
 static int idecd_open(struct block_device *bdev, fmode_t mode)
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -651,15 +651,12 @@ static int ide_disk_check(ide_drive_t *d
 
 static void ide_disk_setup(ide_drive_t *drive)
 {
-	struct ide_disk_obj *idkp = drive->driver_data;
 	struct request_queue *q = drive->queue;
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
 	unsigned long long capacity;
 
-	ide_proc_register_driver(drive, idkp->driver);
-
 	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0)
 		return;
 
Index: b/drivers/ide/ide-disk.h
===================================================================
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -15,13 +15,6 @@ ide_decl_devset(acoustic);
 /* ide-disk_ioctl.c */
 int ide_disk_ioctl(ide_drive_t *, struct block_device *, fmode_t, unsigned int,
 		   unsigned long);
-
-#ifdef CONFIG_IDE_PROC_FS
-/* ide-disk_proc.c */
-extern ide_proc_entry_t ide_disk_proc[];
-#endif
-#else
-#define ide_disk_proc		NULL
 #endif
 
 #endif /* __IDE_DISK_H */
Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- a/drivers/ide/ide-disk_proc.c
+++ /dev/null
@@ -1,152 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/ide.h>
-#include <linux/seq_file.h>
-
-#include "ide-disk.h"
-
-static int smart_enable(ide_drive_t *drive)
-{
-	struct ide_cmd cmd;
-	struct ide_taskfile *tf = &cmd.tf;
-
-	memset(&cmd, 0, sizeof(cmd));
-	tf->feature = ATA_SMART_ENABLE;
-	tf->lbam    = ATA_SMART_LBAM_PASS;
-	tf->lbah    = ATA_SMART_LBAH_PASS;
-	tf->command = ATA_CMD_SMART;
-	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
-	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
-
-	return ide_no_data_taskfile(drive, &cmd);
-}
-
-static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
-{
-	struct ide_cmd cmd;
-	struct ide_taskfile *tf = &cmd.tf;
-
-	memset(&cmd, 0, sizeof(cmd));
-	tf->feature = sub_cmd;
-	tf->nsect   = 0x01;
-	tf->lbam    = ATA_SMART_LBAM_PASS;
-	tf->lbah    = ATA_SMART_LBAH_PASS;
-	tf->command = ATA_CMD_SMART;
-	cmd.valid.out.tf = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
-	cmd.valid.in.tf  = IDE_VALID_IN_TF  | IDE_VALID_DEVICE;
-	cmd.protocol = ATA_PROT_PIO;
-
-	return ide_raw_taskfile(drive, &cmd, buf, 1);
-}
-
-static int idedisk_cache_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t	*drive = (ide_drive_t *) m->private;
-
-	if (drive->dev_flags & IDE_DFLAG_ID_READ)
-		seq_printf(m, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
-	else
-		seq_printf(m, "(none)\n");
-	return 0;
-}
-
-static int idedisk_cache_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_cache_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idedisk_cache_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_cache_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int idedisk_capacity_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t*drive = (ide_drive_t *)m->private;
-
-	seq_printf(m, "%llu\n", (long long)ide_gd_capacity(drive));
-	return 0;
-}
-
-static int idedisk_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_capacity_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idedisk_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __idedisk_proc_show(struct seq_file *m, ide_drive_t *drive, u8 sub_cmd)
-{
-	u8 *buf;
-
-	buf = kmalloc(SECTOR_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	(void)smart_enable(drive);
-
-	if (get_smart_data(drive, buf, sub_cmd) == 0) {
-		__le16 *val = (__le16 *)buf;
-		int i;
-
-		for (i = 0; i < SECTOR_SIZE / 2; i++) {
-			seq_printf(m, "%04x%c", le16_to_cpu(val[i]),
-					(i % 8) == 7 ? '\n' : ' ');
-		}
-	}
-	kfree(buf);
-	return 0;
-}
-
-static int idedisk_sv_proc_show(struct seq_file *m, void *v)
-{
-	return __idedisk_proc_show(m, m->private, ATA_SMART_READ_VALUES);
-}
-
-static int idedisk_sv_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_sv_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idedisk_sv_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_sv_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int idedisk_st_proc_show(struct seq_file *m, void *v)
-{
-	return __idedisk_proc_show(m, m->private, ATA_SMART_READ_THRESHOLDS);
-}
-
-static int idedisk_st_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idedisk_st_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idedisk_st_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idedisk_st_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-ide_proc_entry_t ide_disk_proc[] = {
-	{ "cache",	  S_IFREG|S_IRUGO, &idedisk_cache_proc_fops	},
-	{ "capacity",	  S_IFREG|S_IRUGO, &idedisk_capacity_proc_fops	},
-	{ "geometry",	  S_IFREG|S_IRUGO, &ide_geometry_proc_fops	},
-	{ "smart_values", S_IFREG|S_IRUSR, &idedisk_sv_proc_fops	},
-	{ "smart_thresholds", S_IFREG|S_IRUSR, &idedisk_st_proc_fops	},
-	{}
-};
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -468,7 +468,6 @@ static int ide_floppy_get_capacity(ide_d
 
 static void ide_floppy_setup(ide_drive_t *drive)
 {
-	struct ide_disk_obj *floppy = drive->driver_data;
 	u16 *id = drive->id;
 
 	drive->pc_callback	 = ide_floppy_callback;
@@ -502,8 +501,6 @@ static void ide_floppy_setup(ide_drive_t
 
 	(void) ide_floppy_get_capacity(drive);
 
-	ide_proc_register_driver(drive, floppy->driver);
-
 	drive->dev_flags |= IDE_DFLAG_ATTACH;
 }
 
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -25,13 +25,6 @@ void ide_floppy_create_read_capacity_cmd
 /* ide-floppy_ioctl.c */
 int ide_floppy_ioctl(ide_drive_t *, struct block_device *, fmode_t,
 		     unsigned int, unsigned long);
-
-#ifdef CONFIG_IDE_PROC_FS
-/* ide-floppy_proc.c */
-extern ide_proc_entry_t ide_floppy_proc[];
-#endif
-#else
-#define ide_floppy_proc		NULL
 #endif
 
 #endif /*__IDE_FLOPPY_H */
Index: b/drivers/ide/ide-floppy_proc.c
===================================================================
--- a/drivers/ide/ide-floppy_proc.c
+++ /dev/null
@@ -1,32 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/ide.h>
-#include <linux/seq_file.h>
-
-#include "ide-floppy.h"
-
-static int idefloppy_capacity_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t*drive = (ide_drive_t *)m->private;
-
-	seq_printf(m, "%llu\n", (long long)ide_gd_capacity(drive));
-	return 0;
-}
-
-static int idefloppy_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idefloppy_capacity_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idefloppy_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idefloppy_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-ide_proc_entry_t ide_floppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO, &idefloppy_capacity_proc_fops	},
-	{ "geometry",	S_IFREG|S_IRUGO, &ide_geometry_proc_fops	},
-	{}
-};
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -66,7 +66,6 @@ static void ide_gd_remove(ide_drive_t *d
 	struct ide_disk_obj *idkp = drive->driver_data;
 	struct gendisk *g = idkp->disk;
 
-	ide_proc_unregister_driver(drive, idkp->driver);
 	device_del(&idkp->dev);
 	del_gendisk(g);
 	drive->disk_ops->flush(drive);
@@ -141,13 +140,6 @@ static void ide_gd_shutdown(ide_drive_t
 	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static ide_proc_entry_t *ide_disk_proc_entries(ide_drive_t *drive)
-{
-	return (drive->media == ide_disk) ? ide_disk_proc : ide_floppy_proc;
-}
-#endif
-
 static ide_startstop_t ide_gd_do_request(ide_drive_t *drive,
 					 struct request *rq, sector_t sector)
 {
@@ -166,9 +158,6 @@ static struct ide_driver ide_gd_driver =
 	.shutdown		= ide_gd_shutdown,
 	.version		= IDE_GD_VERSION,
 	.do_request		= ide_gd_do_request,
-#ifdef CONFIG_IDE_PROC_FS
-	.proc_entries		= ide_disk_proc_entries,
-#endif
 };
 
 static int ide_gd_open(struct block_device *bdev, fmode_t mode)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -956,8 +956,6 @@ static void drive_release_dev (struct de
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
 
-	ide_proc_unregister_device(drive);
-
 	blk_cleanup_queue(drive->queue);
 	drive->queue = NULL;
 
@@ -1465,10 +1463,6 @@ int ide_host_register(struct ide_host *h
 			continue;
 
 		ide_sysfs_register_port(hwif);
-		ide_proc_register_port(hwif);
-
-		if (hwif->present)
-			ide_proc_port_register_devices(hwif);
 	}
 
 	return j ? 0 : -1;
@@ -1545,8 +1539,6 @@ static void ide_unregister(ide_hwif_t *h
 		hwif->present = 0;
 	}
 
-	ide_proc_unregister_port(hwif);
-
 	free_irq(hwif->irq, hwif);
 
 	device_unregister(hwif->portdev);
@@ -1617,6 +1609,5 @@ void ide_port_scan(ide_hwif_t *hwif)
 	ide_port_setup_devices(hwif);
 	ide_acpi_port_init_devices(hwif);
 	hwif_register_devices(hwif);
-	ide_proc_port_register_devices(hwif);
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ /dev/null
@@ -1,481 +0,0 @@
-/*
- *  Copyright (C) 1997-1998	Mark Lord
- *  Copyright (C) 2003		Red Hat
- *
- *  Some code was moved here from ide.c, see it for original copyrights.
- */
-
-/*
- * This is the /proc/ide/ filesystem implementation.
- */
-
-#include <linux/module.h>
-
-#include <asm/uaccess.h>
-#include <linux/errno.h>
-#include <linux/proc_fs.h>
-#include <linux/stat.h>
-#include <linux/mm.h>
-#include <linux/pci.h>
-#include <linux/ctype.h>
-#include <linux/ide.h>
-#include <linux/seq_file.h>
-
-#include <asm/io.h>
-
-static struct proc_dir_entry *proc_ide_root;
-
-static int ide_imodel_proc_show(struct seq_file *m, void *v)
-{
-	ide_hwif_t	*hwif = (ide_hwif_t *) m->private;
-	const char	*name;
-
-	switch (hwif->chipset) {
-	case ide_generic:	name = "generic";	break;
-	case ide_pci:		name = "pci";		break;
-	case ide_cmd640:	name = "cmd640";	break;
-	case ide_dtc2278:	name = "dtc2278";	break;
-	case ide_ali14xx:	name = "ali14xx";	break;
-	case ide_qd65xx:	name = "qd65xx";	break;
-	case ide_umc8672:	name = "umc8672";	break;
-	case ide_ht6560b:	name = "ht6560b";	break;
-	case ide_4drives:	name = "4drives";	break;
-	case ide_pmac:		name = "mac-io";	break;
-	case ide_au1xxx:	name = "au1xxx";	break;
-	case ide_palm3710:      name = "palm3710";      break;
-	case ide_acorn:		name = "acorn";		break;
-	default:		name = "(unknown)";	break;
-	}
-	seq_printf(m, "%s\n", name);
-	return 0;
-}
-
-static int ide_imodel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_imodel_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations ide_imodel_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_imodel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ide_mate_proc_show(struct seq_file *m, void *v)
-{
-	ide_hwif_t	*hwif = (ide_hwif_t *) m->private;
-
-	if (hwif && hwif->mate)
-		seq_printf(m, "%s\n", hwif->mate->name);
-	else
-		seq_printf(m, "(none)\n");
-	return 0;
-}
-
-static int ide_mate_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_mate_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations ide_mate_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_mate_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ide_channel_proc_show(struct seq_file *m, void *v)
-{
-	ide_hwif_t	*hwif = (ide_hwif_t *) m->private;
-
-	seq_printf(m, "%c\n", hwif->channel ? '1' : '0');
-	return 0;
-}
-
-static int ide_channel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_channel_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations ide_channel_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_channel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ide_identify_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t *drive = (ide_drive_t *)m->private;
-	u8 *buf;
-
-	if (!drive) {
-		seq_putc(m, '\n');
-		return 0;
-	}
-
-	buf = kmalloc(SECTOR_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-	if (taskfile_lib_get_identify(drive, buf) == 0) {
-		__le16 *val = (__le16 *)buf;
-		int i;
-
-		for (i = 0; i < SECTOR_SIZE / 2; i++) {
-			seq_printf(m, "%04x%c", le16_to_cpu(val[i]),
-					(i % 8) == 7 ? '\n' : ' ');
-		}
-	} else
-		seq_putc(m, buf[0]);
-	kfree(buf);
-	return 0;
-}
-
-static int ide_identify_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_identify_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations ide_identify_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_identify_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ide_capacity_proc_show(struct seq_file *m, void *v)
-{
-	seq_printf(m, "%llu\n", (long long)0x7fffffff);
-	return 0;
-}
-
-static int ide_capacity_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_capacity_proc_show, NULL);
-}
-
-const struct file_operations ide_capacity_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_capacity_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-EXPORT_SYMBOL_GPL(ide_capacity_proc_fops);
-
-static int ide_geometry_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t	*drive = (ide_drive_t *) m->private;
-
-	seq_printf(m, "physical     %d/%d/%d\n",
-			drive->cyl, drive->head, drive->sect);
-	seq_printf(m, "logical      %d/%d/%d\n",
-			drive->bios_cyl, drive->bios_head, drive->bios_sect);
-	return 0;
-}
-
-static int ide_geometry_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_geometry_proc_show, PDE(inode)->data);
-}
-
-const struct file_operations ide_geometry_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_geometry_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-EXPORT_SYMBOL(ide_geometry_proc_fops);
-
-static int ide_dmodel_proc_show(struct seq_file *seq, void *v)
-{
-	ide_drive_t	*drive = (ide_drive_t *) seq->private;
-	char		*m = (char *)&drive->id[ATA_ID_PROD];
-
-	seq_printf(seq, "%.40s\n", m[0] ? m : "(none)");
-	return 0;
-}
-
-static int ide_dmodel_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_dmodel_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations ide_dmodel_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_dmodel_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ide_driver_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t		*drive = (ide_drive_t *)m->private;
-	struct device		*dev = &drive->gendev;
-	struct ide_driver	*ide_drv;
-
-	if (dev->driver) {
-		ide_drv = to_ide_driver(dev->driver);
-		seq_printf(m, "%s version %s\n",
-				dev->driver->name, ide_drv->version);
-	} else
-		seq_printf(m, "ide-default version 0.9.newide\n");
-	return 0;
-}
-
-static int ide_driver_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_driver_proc_show, PDE(inode)->data);
-}
-
-static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
-{
-	struct device *dev = &drive->gendev;
-	int ret = 1;
-	int err;
-
-	device_release_driver(dev);
-	/* FIXME: device can still be in use by previous driver */
-	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
-	err = device_attach(dev);
-	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__func__, err);
-	drive->driver_req[0] = 0;
-	if (dev->driver == NULL) {
-		err = device_attach(dev);
-		if (err < 0)
-			printk(KERN_WARNING
-				"IDE: %s: device_attach(2) error: %d\n",
-				__func__, err);
-	}
-	if (dev->driver && !strcmp(dev->driver->name, driver))
-		ret = 0;
-
-	return ret;
-}
-
-static ssize_t ide_driver_proc_write(struct file *file, const char __user *buffer,
-				     size_t count, loff_t *pos)
-{
-	ide_drive_t	*drive = (ide_drive_t *) PDE(file->f_path.dentry->d_inode)->data;
-	char name[32];
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (count > 31)
-		count = 31;
-	if (copy_from_user(name, buffer, count))
-		return -EFAULT;
-	name[count] = '\0';
-	if (ide_replace_subdriver(drive, name))
-		return -EINVAL;
-	return count;
-}
-
-static const struct file_operations ide_driver_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_driver_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-	.write		= ide_driver_proc_write,
-};
-
-static int ide_media_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t	*drive = (ide_drive_t *) m->private;
-	const char	*media;
-
-	switch (drive->media) {
-	case ide_disk:		media = "disk\n";	break;
-	case ide_cdrom:		media = "cdrom\n";	break;
-	case ide_tape:		media = "tape\n";	break;
-	case ide_floppy:	media = "floppy\n";	break;
-	case ide_optical:	media = "optical\n";	break;
-	default:		media = "UNKNOWN\n";	break;
-	}
-	seq_puts(m, media);
-	return 0;
-}
-
-static int ide_media_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ide_media_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations ide_media_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ide_media_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static ide_proc_entry_t generic_drive_entries[] = {
-	{ "driver",	S_IFREG|S_IRUGO,	 &ide_driver_proc_fops	},
-	{ "identify",	S_IFREG|S_IRUSR,	 &ide_identify_proc_fops},
-	{ "media",	S_IFREG|S_IRUGO,	 &ide_media_proc_fops	},
-	{ "model",	S_IFREG|S_IRUGO,	 &ide_dmodel_proc_fops	},
-	{}
-};
-
-static void ide_add_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p, void *data)
-{
-	struct proc_dir_entry *ent;
-
-	if (!dir || !p)
-		return;
-	while (p->name != NULL) {
-		ent = proc_create_data(p->name, p->mode, dir, p->proc_fops, data);
-		if (!ent) return;
-		p++;
-	}
-}
-
-static void ide_remove_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p)
-{
-	if (!dir || !p)
-		return;
-	while (p->name != NULL) {
-		remove_proc_entry(p->name, dir);
-		p++;
-	}
-}
-
-void ide_proc_register_driver(ide_drive_t *drive, struct ide_driver *driver)
-{
-	ide_add_proc_entries(drive->proc, driver->proc_entries(drive), drive);
-}
-
-EXPORT_SYMBOL(ide_proc_register_driver);
-
-/**
- *	ide_proc_unregister_driver	-	remove driver specific data
- *	@drive: drive
- *	@driver: driver
- *
- *	Clean up the driver specific /proc files for a given drive.
- */
-
-void ide_proc_unregister_driver(ide_drive_t *drive, struct ide_driver *driver)
-{
-	ide_remove_proc_entries(drive->proc, driver->proc_entries(drive));
-}
-EXPORT_SYMBOL(ide_proc_unregister_driver);
-
-void ide_proc_port_register_devices(ide_hwif_t *hwif)
-{
-	struct proc_dir_entry *ent;
-	struct proc_dir_entry *parent = hwif->proc;
-	ide_drive_t *drive;
-	char name[64];
-	int i;
-
-	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-			continue;
-
-		drive->proc = proc_mkdir(drive->name, parent);
-		if (drive->proc)
-			ide_add_proc_entries(drive->proc, generic_drive_entries, drive);
-		sprintf(name, "ide%d/%s", (drive->name[2]-'a')/2, drive->name);
-		ent = proc_symlink(drive->name, proc_ide_root, name);
-		if (!ent) return;
-	}
-}
-
-void ide_proc_unregister_device(ide_drive_t *drive)
-{
-	if (drive->proc) {
-		ide_remove_proc_entries(drive->proc, generic_drive_entries);
-		remove_proc_entry(drive->name, proc_ide_root);
-		remove_proc_entry(drive->name, drive->hwif->proc);
-		drive->proc = NULL;
-	}
-}
-
-static ide_proc_entry_t hwif_entries[] = {
-	{ "channel",	S_IFREG|S_IRUGO,	&ide_channel_proc_fops	},
-	{ "mate",	S_IFREG|S_IRUGO,	&ide_mate_proc_fops	},
-	{ "model",	S_IFREG|S_IRUGO,	&ide_imodel_proc_fops	},
-	{}
-};
-
-void ide_proc_register_port(ide_hwif_t *hwif)
-{
-	if (!hwif->proc) {
-		hwif->proc = proc_mkdir(hwif->name, proc_ide_root);
-
-		if (!hwif->proc)
-			return;
-
-		ide_add_proc_entries(hwif->proc, hwif_entries, hwif);
-	}
-}
-
-void ide_proc_unregister_port(ide_hwif_t *hwif)
-{
-	if (hwif->proc) {
-		ide_remove_proc_entries(hwif->proc, hwif_entries);
-		remove_proc_entry(hwif->name, proc_ide_root);
-		hwif->proc = NULL;
-	}
-}
-
-static int proc_print_driver(struct device_driver *drv, void *data)
-{
-	struct ide_driver *ide_drv = to_ide_driver(drv);
-	struct seq_file *s = data;
-
-	seq_printf(s, "%s version %s\n", drv->name, ide_drv->version);
-
-	return 0;
-}
-
-static int ide_drivers_show(struct seq_file *s, void *p)
-{
-	int err;
-
-	err = bus_for_each_drv(&ide_bus_type, NULL, s, proc_print_driver);
-	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: bus_for_each_drv error: %d\n",
-			__func__, err);
-	return 0;
-}
-
-static int ide_drivers_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, &ide_drivers_show, NULL);
-}
-
-static const struct file_operations ide_drivers_operations = {
-	.owner		= THIS_MODULE,
-	.open		= ide_drivers_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-void proc_ide_create(void)
-{
-	proc_ide_root = proc_mkdir("ide", NULL);
-
-	if (!proc_ide_root)
-		return;
-
-	proc_create("drivers", 0, proc_ide_root, &ide_drivers_operations);
-}
-
-void proc_ide_destroy(void)
-{
-	remove_proc_entry("drivers", proc_ide_root);
-	remove_proc_entry("ide", NULL);
-}
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1729,15 +1729,12 @@ static void idetape_setup(ide_drive_t *d
 		tape->buffer_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		(drive->dev_flags & IDE_DFLAG_USING_DMA) ? ", DMA" : "");
-
-	ide_proc_register_driver(drive, tape->driver);
 }
 
 static void ide_tape_remove(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	ide_proc_unregister_driver(drive, tape->driver);
 	device_del(&tape->dev);
 	ide_unregister_region(tape->disk);
 
@@ -1765,41 +1762,6 @@ static void ide_tape_release(struct devi
 	kfree(tape);
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static int idetape_name_proc_show(struct seq_file *m, void *v)
-{
-	ide_drive_t	*drive = (ide_drive_t *) m->private;
-	idetape_tape_t	*tape = drive->driver_data;
-
-	seq_printf(m, "%s\n", tape->name);
-	return 0;
-}
-
-static int idetape_name_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, idetape_name_proc_show, PDE(inode)->data);
-}
-
-static const struct file_operations idetape_name_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= idetape_name_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static ide_proc_entry_t idetape_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO,	&ide_capacity_proc_fops	},
-	{ "name",	S_IFREG|S_IRUGO,	&idetape_name_proc_fops	},
-	{}
-};
-
-static ide_proc_entry_t *ide_tape_proc_entries(ide_drive_t *drive)
-{
-	return idetape_proc;
-}
-#endif
-
 static int ide_tape_probe(ide_drive_t *);
 
 static struct ide_driver idetape_driver = {
@@ -1812,9 +1774,6 @@ static struct ide_driver idetape_driver
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
 	.do_request		= idetape_do_request,
-#ifdef CONFIG_IDE_PROC_FS
-	.proc_entries		= ide_tape_proc_entries,
-#endif
 };
 
 /* Our character device supporting functions, passed to register_chrdev. */
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -385,8 +385,6 @@ static int __init ide_init(void)
 
 	ide_acpi_init();
 
-	proc_ide_create();
-
 	return 0;
 
 out_port_class:
@@ -397,8 +395,6 @@ out_port_class:
 
 static void __exit ide_exit(void)
 {
-	proc_ide_destroy();
-
 	class_destroy(ide_port_class);
 
 	bus_unregister(&ide_bus_type);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -492,9 +492,6 @@ struct ide_drive_s {
 	struct request		*rq;	/* current request */
 	void		*driver_data;	/* extra driver data */
 	u16			*id;	/* identification info */
-#ifdef CONFIG_IDE_PROC_FS
-	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
-#endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
 	const struct ide_disk_ops *disk_ops;
@@ -901,41 +898,6 @@ ide_decl_devset(pio_mode);
 ide_decl_devset(unmaskirq);
 ide_decl_devset(using_dma);
 
-#ifdef CONFIG_IDE_PROC_FS
-/*
- * /proc/ide interface
- */
-
-typedef struct {
-	const char	*name;
-	mode_t		mode;
-	const struct file_operations *proc_fops;
-} ide_proc_entry_t;
-
-void proc_ide_create(void);
-void proc_ide_destroy(void);
-void ide_proc_register_port(ide_hwif_t *);
-void ide_proc_port_register_devices(ide_hwif_t *);
-void ide_proc_unregister_device(ide_drive_t *);
-void ide_proc_unregister_port(ide_hwif_t *);
-void ide_proc_register_driver(ide_drive_t *, struct ide_driver *);
-void ide_proc_unregister_driver(ide_drive_t *, struct ide_driver *);
-
-extern const struct file_operations ide_capacity_proc_fops;
-extern const struct file_operations ide_geometry_proc_fops;
-#else
-static inline void proc_ide_create(void) { ; }
-static inline void proc_ide_destroy(void) { ; }
-static inline void ide_proc_register_port(ide_hwif_t *hwif) { ; }
-static inline void ide_proc_port_register_devices(ide_hwif_t *hwif) { ; }
-static inline void ide_proc_unregister_device(ide_drive_t *drive) { ; }
-static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
-static inline void ide_proc_register_driver(ide_drive_t *drive,
-					    struct ide_driver *driver) { ; }
-static inline void ide_proc_unregister_driver(ide_drive_t *drive,
-					      struct ide_driver *driver) { ; }
-#endif
-
 enum {
 	/* enter/exit functions */
 	IDE_DBG_FUNC =			(1 << 0),
@@ -1010,9 +972,6 @@ struct ide_driver {
 	void		(*remove)(ide_drive_t *);
 	void		(*resume)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
-#ifdef CONFIG_IDE_PROC_FS
-	ide_proc_entry_t *		(*proc_entries)(ide_drive_t *);
-#endif
 };
 
 #define to_ide_driver(drv) container_of(drv, struct ide_driver, gen_driver)
