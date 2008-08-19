Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYHSSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYHSSnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbYHSSmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:42:35 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:25109 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086AbYHSSmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jLZG6N47vyu9ZWjNrwbxFH4vYSPfTFN+tbhC/9q7gg62Ha44vXWfx2H3yXO6XyW0oi
         hFT9nNeJm1PnNKdZqlNCO/bXBm7Xl/BOak/VDiDiN/xeHcY7ZSkI7TYn179Rvs7RK/Y7
         GFn2ddQUp7J9p033VQyfkWQny78RjV5E5fdyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 20:40:13 +0200
Message-Id: <20080819184013.16469.94516.sendpatchset@localhost.localdomain>
In-Reply-To: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
References: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/6] ide-disk: move /proc handling to ide-disk_proc.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- idedisk_capacity() -> ide_disk_capacity()
- idedisk_proc[] -> ide_disk_proc[]
- idedisk_settings[] -> ide_disk_settings[]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile        |    2 
 drivers/ide/ide-disk.c      |  142 ++------------------------------------------
 drivers/ide/ide-disk.h      |    5 +
 drivers/ide/ide-disk_proc.c |  131 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 144 insertions(+), 136 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_IDE_H8300)			+= h8300/
 obj-$(CONFIG_IDE_GENERIC)		+= ide-generic.o
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
-ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o
+ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o ide-disk_proc.o
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
 ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o ide-floppy_proc.o
 
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -399,115 +399,11 @@ static void init_idedisk_capacity(ide_dr
 	}
 }
 
-static sector_t idedisk_capacity(ide_drive_t *drive)
+sector_t ide_disk_capacity(ide_drive_t *drive)
 {
 	return drive->capacity64;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static int smart_enable(ide_drive_t *drive)
-{
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
-
-	memset(&args, 0, sizeof(ide_task_t));
-	tf->feature = ATA_SMART_ENABLE;
-	tf->lbam    = ATA_SMART_LBAM_PASS;
-	tf->lbah    = ATA_SMART_LBAH_PASS;
-	tf->command = ATA_CMD_SMART;
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	return ide_no_data_taskfile(drive, &args);
-}
-
-static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
-{
-	ide_task_t args;
-	struct ide_taskfile *tf = &args.tf;
-
-	memset(&args, 0, sizeof(ide_task_t));
-	tf->feature = sub_cmd;
-	tf->nsect   = 0x01;
-	tf->lbam    = ATA_SMART_LBAM_PASS;
-	tf->lbah    = ATA_SMART_LBAH_PASS;
-	tf->command = ATA_CMD_SMART;
-	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-	args.data_phase	= TASKFILE_IN;
-	(void) smart_enable(drive);
-	return ide_raw_taskfile(drive, &args, buf, 1);
-}
-
-static int proc_idedisk_read_cache
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	ide_drive_t	*drive = (ide_drive_t *) data;
-	char		*out = page;
-	int		len;
-
-	if (drive->dev_flags & IDE_DFLAG_ID_READ)
-		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
-	else
-		len = sprintf(out, "(none)\n");
-
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static int proc_idedisk_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	ide_drive_t*drive = (ide_drive_t *)data;
-	int len;
-
-	len = sprintf(page, "%llu\n", (long long)idedisk_capacity(drive));
-
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static int proc_idedisk_read_smart(char *page, char **start, off_t off,
-				   int count, int *eof, void *data, u8 sub_cmd)
-{
-	ide_drive_t	*drive = (ide_drive_t *)data;
-	int		len = 0, i = 0;
-
-	if (get_smart_data(drive, page, sub_cmd) == 0) {
-		unsigned short *val = (unsigned short *) page;
-		char *out = (char *)val + SECTOR_SIZE;
-
-		page = out;
-		do {
-			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
-				       (++i & 7) ? ' ' : '\n');
-			val += 1;
-		} while (i < SECTOR_SIZE / 2);
-		len = out - page;
-	}
-
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static int proc_idedisk_read_sv
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       ATA_SMART_READ_VALUES);
-}
-
-static int proc_idedisk_read_st
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	return proc_idedisk_read_smart(page, start, off, count, eof, data,
-				       ATA_SMART_READ_THRESHOLDS);
-}
-
-static ide_proc_entry_t idedisk_proc[] = {
-	{ "cache",	  S_IFREG|S_IRUGO, proc_idedisk_read_cache,    NULL },
-	{ "capacity",	  S_IFREG|S_IRUGO, proc_idedisk_read_capacity, NULL },
-	{ "geometry",	  S_IFREG|S_IRUGO, proc_ide_read_geometry,     NULL },
-	{ "smart_values", S_IFREG|S_IRUSR, proc_idedisk_read_sv,       NULL },
-	{ "smart_thresholds", S_IFREG|S_IRUSR, proc_idedisk_read_st,   NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif	/* CONFIG_IDE_PROC_FS */
-
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
@@ -606,7 +502,7 @@ static void update_ordered(ide_drive_t *
 		 * time we have trimmed the drive capacity if LBA48 is
 		 * not available so we don't need to recheck that.
 		 */
-		capacity = idedisk_capacity(drive);
+		capacity = ide_disk_capacity(drive);
 		barrier = ata_id_flush_enabled(id) &&
 			(drive->dev_flags & IDE_DFLAG_NOFLUSH) == 0 &&
 			((drive->dev_flags & IDE_DFLAG_LBA48) == 0 ||
@@ -714,30 +610,6 @@ ide_ext_devset_rw(wcache, wcache);
 
 ide_ext_devset_rw_sync(nowerr, nowerr);
 
-#ifdef CONFIG_IDE_PROC_FS
-ide_devset_rw_field(bios_cyl, bios_cyl);
-ide_devset_rw_field(bios_head, bios_head);
-ide_devset_rw_field(bios_sect, bios_sect);
-ide_devset_rw_field(failures, failures);
-ide_devset_rw_field(lun, lun);
-ide_devset_rw_field(max_failures, max_failures);
-
-static const struct ide_proc_devset idedisk_settings[] = {
-	IDE_PROC_DEVSET(acoustic,	0,   254),
-	IDE_PROC_DEVSET(address,	0,     2),
-	IDE_PROC_DEVSET(bios_cyl,	0, 65535),
-	IDE_PROC_DEVSET(bios_head,	0,   255),
-	IDE_PROC_DEVSET(bios_sect,	0,    63),
-	IDE_PROC_DEVSET(failures,	0, 65535),
-	IDE_PROC_DEVSET(lun,		0,     7),
-	IDE_PROC_DEVSET(max_failures,	0, 65535),
-	IDE_PROC_DEVSET(multcount,	0,    16),
-	IDE_PROC_DEVSET(nowerr,		0,     1),
-	IDE_PROC_DEVSET(wcache,		0,     1),
-	{ 0 },
-};
-#endif
-
 static void idedisk_setup(ide_drive_t *drive)
 {
 	struct ide_disk_obj *idkp = drive->driver_data;
@@ -800,7 +672,7 @@ static void idedisk_setup(ide_drive_t *d
 	 * if possible, give fdisk access to more of the drive,
 	 * by correcting bios_cyls:
 	 */
-	capacity = idedisk_capacity(drive);
+	capacity = ide_disk_capacity(drive);
 
 	if ((drive->dev_flags & IDE_DFLAG_FORCED_GEOM) == 0) {
 		if (ata_id_lba48_enabled(drive->id)) {
@@ -933,8 +805,8 @@ static ide_driver_t idedisk_driver = {
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idedisk_proc,
-	.settings		= idedisk_settings,
+	.proc			= ide_disk_proc,
+	.settings		= ide_disk_settings,
 #endif
 };
 
@@ -1028,7 +900,7 @@ static int idedisk_media_changed(struct 
 static int idedisk_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_disk_g(disk);
-	set_capacity(disk, idedisk_capacity(idkp->drive));
+	set_capacity(disk, ide_disk_capacity(idkp->drive));
 	return 0;
 }
 
@@ -1090,7 +962,7 @@ static int ide_disk_probe(ide_drive_t *d
 	g->driverfs_dev = &drive->gendev;
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
-	set_capacity(g, idedisk_capacity(drive));
+	set_capacity(g, ide_disk_capacity(drive));
 	g->fops = &idedisk_ops;
 	add_disk(g);
 	return 0;
Index: b/drivers/ide/ide-disk.h
===================================================================
--- a/drivers/ide/ide-disk.h
+++ b/drivers/ide/ide-disk.h
@@ -13,6 +13,7 @@ struct ide_disk_obj {
 	container_of((disk)->private_data, struct ide_disk_obj, driver)
 
 /* ide-disk.c */
+sector_t ide_disk_capacity(ide_drive_t *);
 ide_decl_devset(address);
 ide_decl_devset(multcount);
 ide_decl_devset(nowerr);
@@ -22,4 +23,8 @@ ide_decl_devset(acoustic);
 /* ide-disk_ioctl.c */
 int ide_disk_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
 
+/* ide-disk_proc.c */
+extern ide_proc_entry_t ide_disk_proc[];
+extern const struct ide_proc_devset ide_disk_settings[];
+
 #endif /* __IDE_DISK_H */
Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-disk_proc.c
@@ -0,0 +1,131 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/hdreg.h>
+
+#include "ide-disk.h"
+
+#ifdef CONFIG_PROC_FS
+static int smart_enable(ide_drive_t *drive)
+{
+	ide_task_t args;
+	struct ide_taskfile *tf = &args.tf;
+
+	memset(&args, 0, sizeof(ide_task_t));
+	tf->feature = ATA_SMART_ENABLE;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
+	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	return ide_no_data_taskfile(drive, &args);
+}
+
+static int get_smart_data(ide_drive_t *drive, u8 *buf, u8 sub_cmd)
+{
+	ide_task_t args;
+	struct ide_taskfile *tf = &args.tf;
+
+	memset(&args, 0, sizeof(ide_task_t));
+	tf->feature = sub_cmd;
+	tf->nsect   = 0x01;
+	tf->lbam    = ATA_SMART_LBAM_PASS;
+	tf->lbah    = ATA_SMART_LBAH_PASS;
+	tf->command = ATA_CMD_SMART;
+	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	args.data_phase	= TASKFILE_IN;
+	(void) smart_enable(drive);
+	return ide_raw_taskfile(drive, &args, buf, 1);
+}
+
+static int proc_idedisk_read_cache
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t	*drive = (ide_drive_t *) data;
+	char		*out = page;
+	int		len;
+
+	if (drive->dev_flags & IDE_DFLAG_ID_READ)
+		len = sprintf(out, "%i\n", drive->id[ATA_ID_BUF_SIZE] / 2);
+	else
+		len = sprintf(out, "(none)\n");
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static int proc_idedisk_read_capacity
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int len;
+
+	len = sprintf(page, "%llu\n", (long long)ide_disk_capacity(drive));
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static int proc_idedisk_read_smart(char *page, char **start, off_t off,
+				   int count, int *eof, void *data, u8 sub_cmd)
+{
+	ide_drive_t	*drive = (ide_drive_t *)data;
+	int		len = 0, i = 0;
+
+	if (get_smart_data(drive, page, sub_cmd) == 0) {
+		unsigned short *val = (unsigned short *) page;
+		char *out = (char *)val + SECTOR_SIZE;
+
+		page = out;
+		do {
+			out += sprintf(out, "%04x%c", le16_to_cpu(*val),
+				       (++i & 7) ? ' ' : '\n');
+			val += 1;
+		} while (i < SECTOR_SIZE / 2);
+		len = out - page;
+	}
+
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static int proc_idedisk_read_sv
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       ATA_SMART_READ_VALUES);
+}
+
+static int proc_idedisk_read_st
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       ATA_SMART_READ_THRESHOLDS);
+}
+
+ide_proc_entry_t ide_disk_proc[] = {
+	{ "cache",	  S_IFREG|S_IRUGO, proc_idedisk_read_cache,    NULL },
+	{ "capacity",	  S_IFREG|S_IRUGO, proc_idedisk_read_capacity, NULL },
+	{ "geometry",	  S_IFREG|S_IRUGO, proc_ide_read_geometry,     NULL },
+	{ "smart_values", S_IFREG|S_IRUSR, proc_idedisk_read_sv,       NULL },
+	{ "smart_thresholds", S_IFREG|S_IRUSR, proc_idedisk_read_st,   NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
+ide_devset_rw_field(failures, failures);
+ide_devset_rw_field(lun, lun);
+ide_devset_rw_field(max_failures, max_failures);
+
+const struct ide_proc_devset ide_disk_settings[] = {
+	IDE_PROC_DEVSET(acoustic,	0,   254),
+	IDE_PROC_DEVSET(address,	0,     2),
+	IDE_PROC_DEVSET(bios_cyl,	0, 65535),
+	IDE_PROC_DEVSET(bios_head,	0,   255),
+	IDE_PROC_DEVSET(bios_sect,	0,    63),
+	IDE_PROC_DEVSET(failures,	0, 65535),
+	IDE_PROC_DEVSET(lun,		0,     7),
+	IDE_PROC_DEVSET(max_failures,	0, 65535),
+	IDE_PROC_DEVSET(multcount,	0,    16),
+	IDE_PROC_DEVSET(nowerr,		0,     1),
+	IDE_PROC_DEVSET(wcache,		0,     1),
+	{ 0 },
+};
+#endif /* CONFIG_PROC_FS */
