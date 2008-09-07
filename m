Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYIGWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYIGWWw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYIGWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:18:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33498 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbYIGWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gF+NMj2P/3vkF0qL2jzPZaSRfmWwMra5KzRxHsvPbKR2CDxqFImvpYAzzFVSwJgXbd
         q3mJgFIZxtKccqbbt73xsgwYzVRD3QhCx9nXFztOc5R/MYVD57mPXe2AJSakrcS0RJss
         yn3LHnxH/vYnNYiXiOFEublG2+C/WFv5Kll7k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:16:22 +0200
Message-Id: <20080907221622.24285.80762.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/18] ide: allow device drivers to specify per-device type /proc settings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn ide_driver_t's 'proc' field into ->proc_entries method
(and also 'settings' field into ->proc_devsets method).  Then
update all device drivers accordingly.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c        |   14 ++++++++++++--
 drivers/ide/ide-gd-floppy.c |   16 ++++++++++++++--
 drivers/ide/ide-gd.c        |   16 ++++++++++++++--
 drivers/ide/ide-proc.c      |    6 +++---
 drivers/ide/ide-tape.c      |   14 ++++++++++++--
 drivers/scsi/ide-scsi.c     |   26 +++++++++++++++++---------
 include/linux/ide.h         |    4 ++--
 7 files changed, 74 insertions(+), 22 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1904,6 +1904,16 @@ static const struct ide_proc_devset idec
 	IDE_PROC_DEVSET(dsc_overlap, 0, 1),
 	{ 0 },
 };
+
+static ide_proc_entry_t *ide_cd_proc_entries(ide_drive_t *drive)
+{
+	return idecd_proc;
+}
+
+static const struct ide_proc_devset *ide_cd_proc_devsets(ide_drive_t *drive)
+{
+	return idecd_settings;
+}
 #endif
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
@@ -2064,8 +2074,8 @@ static ide_driver_t ide_cdrom_driver = {
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idecd_proc,
-	.settings		= idecd_settings,
+	.proc_entries		= ide_cd_proc_entries,
+	.proc_devsets		= ide_cd_proc_devsets,
 #endif
 };
 
Index: b/drivers/ide/ide-gd-floppy.c
===================================================================
--- a/drivers/ide/ide-gd-floppy.c
+++ b/drivers/ide/ide-gd-floppy.c
@@ -77,6 +77,18 @@ static void ide_disk_release(struct kref
 	kfree(idkp);
 }
 
+#ifdef CONFIG_IDE_PROC_FS
+static ide_proc_entry_t *ide_floppy_proc_entries(ide_drive_t *drive)
+{
+	return ide_floppy_proc;
+}
+
+static const struct ide_proc_devset *ide_floppy_proc_devsets(ide_drive_t *drive)
+{
+	return ide_floppy_settings;
+}
+#endif
+
 static ide_driver_t ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
@@ -90,8 +102,8 @@ static ide_driver_t ide_gd_driver = {
 	.end_request		= ide_floppy_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= ide_floppy_proc,
-	.settings		= ide_floppy_settings,
+	.proc_entries		= ide_floppy_proc_entries,
+	.proc_devsets		= ide_floppy_proc_devsets,
 #endif
 };
 
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -113,6 +113,18 @@ static void ide_gd_shutdown(ide_drive_t 
 	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
 }
 
+#ifdef CONFIG_IDE_PROC_FS
+static ide_proc_entry_t *ide_disk_proc_entries(ide_drive_t *drive)
+{
+	return ide_disk_proc;
+}
+
+static const struct ide_proc_devset *ide_disk_proc_devsets(ide_drive_t *drive)
+{
+	return ide_disk_settings;
+}
+#endif
+
 static ide_driver_t ide_gd_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
@@ -128,8 +140,8 @@ static ide_driver_t ide_gd_driver = {
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= ide_disk_proc,
-	.settings		= ide_disk_settings,
+	.proc_entries		= ide_disk_proc_entries,
+	.proc_devsets		= ide_disk_proc_devsets,
 #endif
 };
 
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -567,10 +567,10 @@ static void ide_remove_proc_entries(stru
 void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
 {
 	mutex_lock(&ide_setting_mtx);
-	drive->settings = driver->settings;
+	drive->settings = driver->proc_devsets(drive);
 	mutex_unlock(&ide_setting_mtx);
 
-	ide_add_proc_entries(drive->proc, driver->proc, drive);
+	ide_add_proc_entries(drive->proc, driver->proc_entries(drive), drive);
 }
 
 EXPORT_SYMBOL(ide_proc_register_driver);
@@ -591,7 +591,7 @@ void ide_proc_unregister_driver(ide_driv
 {
 	unsigned long flags;
 
-	ide_remove_proc_entries(drive->proc, driver->proc);
+	ide_remove_proc_entries(drive->proc, driver->proc_entries(drive));
 
 	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2297,6 +2297,16 @@ static ide_proc_entry_t idetape_proc[] =
 	{ "name",	S_IFREG|S_IRUGO,	proc_idetape_read_name,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
+
+static ide_proc_entry_t *ide_tape_proc_entries(ide_drive_t *drive)
+{
+	return idetape_proc;
+}
+
+static const struct ide_proc_devset *ide_tape_proc_devsets(ide_drive_t *drive)
+{
+	return idetape_settings;
+}
 #endif
 
 static int ide_tape_probe(ide_drive_t *);
@@ -2314,8 +2324,8 @@ static ide_driver_t idetape_driver = {
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idetape_proc,
-	.settings		= idetape_settings,
+	.proc_entries		= ide_tape_proc_entries,
+	.proc_devsets		= ide_tape_proc_devsets,
 #endif
 };
 
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -343,6 +343,11 @@ static ide_startstop_t idescsi_do_reques
 }
 
 #ifdef CONFIG_IDE_PROC_FS
+static ide_proc_entry_t idescsi_proc[] = {
+	{ "capacity", S_IFREG|S_IRUGO, proc_ide_read_capacity, NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
 #define ide_scsi_devset_get(name, field) \
 static int get_##name(ide_drive_t *drive) \
 { \
@@ -378,6 +383,16 @@ static const struct ide_proc_devset ides
 	IDE_PROC_DEVSET(transform, 0,	 3),
 	{ 0 },
 };
+
+static ide_proc_entry_t *ide_scsi_proc_entries(ide_drive_t *drive)
+{
+	return idescsi_proc;
+}
+
+static const struct ide_proc_devset *ide_scsi_proc_devsets(ide_drive_t *drive)
+{
+	return idescsi_settings;
+}
 #endif
 
 /*
@@ -419,13 +434,6 @@ static void ide_scsi_remove(ide_drive_t 
 
 static int ide_scsi_probe(ide_drive_t *);
 
-#ifdef CONFIG_IDE_PROC_FS
-static ide_proc_entry_t idescsi_proc[] = {
-	{ "capacity", S_IFREG|S_IRUGO, proc_ide_read_capacity, NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif
-
 static ide_driver_t idescsi_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
@@ -439,8 +447,8 @@ static ide_driver_t idescsi_driver = {
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
 #ifdef CONFIG_IDE_PROC_FS
-	.proc			= idescsi_proc,
-	.settings		= idescsi_settings,
+	.proc_entries		= ide_scsi_proc_entries,
+	.proc_devsets		= ide_scsi_proc_devsets,
 #endif
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1111,8 +1111,8 @@ struct ide_driver_s {
 	void		(*resume)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
-	ide_proc_entry_t		*proc;
-	const struct ide_proc_devset	*settings;
+	ide_proc_entry_t *		(*proc_entries)(ide_drive_t *);
+	const struct ide_proc_devset *	(*proc_devsets)(ide_drive_t *);
 #endif
 };
 
