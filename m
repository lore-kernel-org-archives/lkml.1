Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYHSSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYHSSnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYHSSmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:42:16 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:25109 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYHSSmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mAheoqP2aoVzlW6WsyAPrkbneY9XnsGGnIchQCWnrYjVUKrJlNUDTmm8LrHnKGzNFE
         bSWu0nbAwBnO/OUqvDjjYH+cpIJ533HqycsTEJGsmoAXeFqtou6hEC1yKeLm9WFYw0Z4
         GOM8hiY9BWWKQpmBB1rVPCzOdUGvxUpABRQ3o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 20:39:56 +0200
Message-Id: <20080819183956.16469.8326.sendpatchset@localhost.localdomain>
In-Reply-To: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
References: <20080819183934.16469.69799.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/6] ide-floppy: move /proc handling to ide-floppy_proc.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- idefloppy_capacity() -> ide_floppy_capacity()
- idefloppy_proc[] -> ide_floppy_proc[]
- idefloppy_settings[] -> ide_floppy_settings[]

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile          |    2 +-
 drivers/ide/ide-floppy.c      |   41 ++++-------------------------------------
 drivers/ide/ide-floppy.h      |    5 +++++
 drivers/ide/ide-floppy_proc.c |   35 +++++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 38 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_IDE_GENERIC)		+= ide-generi
 obj-$(CONFIG_BLK_DEV_IDEPNP)		+= ide-pnp.o
 
 ide-cd_mod-y += ide-cd.o ide-cd_ioctl.o ide-cd_verbose.o
-ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o
+ide-floppy_mod-y += ide-floppy.o ide-floppy_ioctl.o ide-floppy_proc.o
 
 obj-$(CONFIG_BLK_DEV_IDEDISK)		+= ide-disk.o
 obj-$(CONFIG_BLK_DEV_IDECD)		+= ide-cd_mod.o
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -552,7 +552,7 @@ static int ide_floppy_get_capacity(ide_d
 	return rc;
 }
 
-static sector_t idefloppy_capacity(ide_drive_t *drive)
+sector_t ide_floppy_capacity(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	unsigned long capacity = floppy->blocks * floppy->bs_factor;
@@ -560,21 +560,6 @@ static sector_t idefloppy_capacity(ide_d
 	return capacity;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-ide_devset_rw_field(bios_cyl, bios_cyl);
-ide_devset_rw_field(bios_head, bios_head);
-ide_devset_rw_field(bios_sect, bios_sect);
-ide_devset_rw_field(ticks, pc_delay);
-
-static const struct ide_proc_devset idefloppy_settings[] = {
-	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
-	IDE_PROC_DEVSET(bios_head, 0,  255),
-	IDE_PROC_DEVSET(bios_sect, 0,   63),
-	IDE_PROC_DEVSET(ticks,	   0,  255),
-	{ 0 },
-};
-#endif
-
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
 {
 	u16 *id = drive->id;
@@ -639,24 +624,6 @@ static void idefloppy_cleanup_obj(struct
 	kfree(floppy);
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
-{
-	ide_drive_t*drive = (ide_drive_t *)data;
-	int len;
-
-	len = sprintf(page, "%llu\n", (long long)idefloppy_capacity(drive));
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static ide_proc_entry_t idefloppy_proc[] = {
-	{ "capacity",	S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
-	{ "geometry",	S_IFREG|S_IRUGO, proc_ide_read_geometry,	NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif	/* CONFIG_IDE_PROC_FS */
-
 static int ide_floppy_probe(ide_drive_t *);
 
 static ide_driver_t idefloppy_driver = {
@@ -672,8 +639,8 @@ static ide_driver_t idefloppy_driver = {
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idefloppy_proc,
-	.settings		= idefloppy_settings,
+	.proc			= ide_floppy_proc,
+	.settings		= ide_floppy_settings,
 #endif
 };
 
@@ -786,7 +753,7 @@ static int idefloppy_media_changed(struc
 static int idefloppy_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_floppy_obj *floppy = ide_drv_g(disk, ide_floppy_obj);
-	set_capacity(disk, idefloppy_capacity(floppy->drive));
+	set_capacity(disk, ide_floppy_capacity(floppy->drive));
 	return 0;
 }
 
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -48,8 +48,13 @@ typedef struct ide_floppy_obj {
 /* ide-floppy.c */
 void ide_floppy_create_mode_sense_cmd(struct ide_atapi_pc *, u8);
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *);
+sector_t ide_floppy_capacity(ide_drive_t *);
 
 /* ide-floppy_ioctl.c */
 int ide_floppy_ioctl(struct inode *, struct file *, unsigned, unsigned long);
 
+/* ide-floppy_proc.c */
+extern ide_proc_entry_t ide_floppy_proc[];
+extern const struct ide_proc_devset ide_floppy_settings[];
+
 #endif /*__IDE_FLOPPY_H */
Index: b/drivers/ide/ide-floppy_proc.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-floppy_proc.c
@@ -0,0 +1,35 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+#include "ide-floppy.h"
+
+#ifdef CONFIG_IDE_PROC_FS
+static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
+		int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int len;
+
+	len = sprintf(page, "%llu\n", (long long)ide_floppy_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+ide_proc_entry_t ide_floppy_proc[] = {
+	{ "capacity",	S_IFREG|S_IRUGO, proc_idefloppy_read_capacity,	NULL },
+	{ "geometry",	S_IFREG|S_IRUGO, proc_ide_read_geometry,	NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
+ide_devset_rw_field(bios_cyl, bios_cyl);
+ide_devset_rw_field(bios_head, bios_head);
+ide_devset_rw_field(bios_sect, bios_sect);
+ide_devset_rw_field(ticks, pc_delay);
+
+const struct ide_proc_devset ide_floppy_settings[] = {
+	IDE_PROC_DEVSET(bios_cyl,  0, 1023),
+	IDE_PROC_DEVSET(bios_head, 0,  255),
+	IDE_PROC_DEVSET(bios_sect, 0,   63),
+	IDE_PROC_DEVSET(ticks,	   0,  255),
+	{ 0 },
+};
+#endif	/* CONFIG_IDE_PROC_FS */
