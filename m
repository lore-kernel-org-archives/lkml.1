Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbYG0S7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbYG0S7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbYG0S6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:58:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:45617 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbYG0S62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ARZk7onOa1TB6SILp6GmDTSsKm/a38x79pvZSSLWDI1t+BvYP+BToKrHxHjc7XD+yY
         0/Gk05jrehUMMyRKk8EDFUoF/Sg2lwFmRqDQLB2A2doxn6FPingWshqxEi3ZXejekXGK
         iVI75csZfp2803AUckOTzylX6GkD2uZcNjQ0M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Elias Oltmanns <eo@nebensachen.de>
Date: Sun, 27 Jul 2008 20:56:25 +0200
Message-Id: <20080727185625.4660.30343.sendpatchset@localhost.localdomain>
In-Reply-To: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
References: <20080727185602.4660.66530.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/3] ide: /proc/ide/hd*/settings rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add struct ide_devset, S_* flags, *DEVSET() & ide*_devset_*() macros.

* Add 'const struct ide_devset **settings' to ide_driver_t.

* Use 'const struct ide_devset **settings' in ide_drive_t instead of
  'struct ide_settings_s *settings'.  Then convert core code and device
  drivers to use struct ide_devset and co.:

  - device settings are no longer allocated dynamically for each device
    but instead there is an unique struct ide_devset instance per setting

  - device driver keeps the pointer to the table of pointers to its
    settings in ide_driver_t.settings

  - generic settings are kept in ide_generic_setting[]

  - ide_proc_[un]register_driver(), ide_find_setting_by_name(),
    ide_{read,write}_setting() and proc_ide_{read,write}_settings()
    are updated accordingly

  - ide*_add_settings() are removed

* Remove no longer used __ide_add_setting(), ide_add_setting(),
  __ide_remove_setting() and auto_remove_settings().

* Remove no longer used TYPE_*, SETTING_*, ide_procset_t
  and ide_settings_t.

* ->keep_settings, ->using_dma, ->unmask, ->noflush, ->dsc_overlap,
  ->nice1, ->addressing, ->wcache and ->nowerr ide_drive_t fields
  can now be bitfield flags.

While at it:

* Rename ide_find_setting_by_name() to ide_find_setting().

* Rename write_wcache() to set_wcache().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |   15 +-
 drivers/ide/ide-disk.c   |   87 ++++++++------
 drivers/ide/ide-floppy.c |   35 +++--
 drivers/ide/ide-probe.c  |    2 
 drivers/ide/ide-proc.c   |  279 ++++++++++++++---------------------------------
 drivers/ide/ide-tape.c   |   74 ++++++++----
 drivers/ide/ide.c        |   21 ++-
 drivers/scsi/ide-scsi.c  |   52 ++++++--
 include/linux/ide.h      |  110 ++++++++++++------
 9 files changed, 340 insertions(+), 335 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1803,13 +1803,12 @@ static ide_proc_entry_t idecd_proc[] = {
 	{ NULL, 0, NULL, NULL }
 };
 
-static void ide_cdrom_add_settings(ide_drive_t *drive)
-{
-	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
-			&drive->dsc_overlap, NULL);
-}
-#else
-static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
+ide_devset_rw(dsc_overlap, 0, 1, dsc_overlap);
+
+static const struct ide_devset *idecd_settings[] = {
+	&ide_devset_dsc_overlap,
+	NULL
+};
 #endif
 
 static const struct cd_list_entry ide_cd_quirks_list[] = {
@@ -1918,7 +1917,6 @@ static int ide_cdrom_setup(ide_drive_t *
 	}
 
 	ide_proc_register_driver(drive, cd->driver);
-	ide_cdrom_add_settings(drive);
 	return 0;
 }
 
@@ -1969,6 +1967,7 @@ static ide_driver_t ide_cdrom_driver = {
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idecd_proc,
+	.settings		= idecd_settings,
 #endif
 };
 
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -606,6 +606,8 @@ static void idedisk_prepare_flush(struct
 	rq->special = task;
 }
 
+ide_devset_get(multcount, mult_count);
+
 /*
  * This is tightly woven into the driver->do_special can not touch.
  * DON'T do it again until a total personality rewrite is committed.
@@ -632,6 +634,8 @@ static int set_multcount(ide_drive_t *dr
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
 
+ide_devset_get(nowerr, nowerr);
+
 static int set_nowerr(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
@@ -680,7 +684,9 @@ static void update_ordered(ide_drive_t *
 	blk_queue_ordered(drive->queue, ordered, prep_fn);
 }
 
-static int write_cache(ide_drive_t *drive, int arg)
+ide_devset_get(wcache, wcache);
+
+static int set_wcache(ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
 	int err = 1;
@@ -717,6 +723,8 @@ static int do_idedisk_flushcache(ide_dri
 	return ide_no_data_taskfile(drive, &args);
 }
 
+ide_devset_get(acoustic, acoustic);
+
 static int set_acoustic(ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
@@ -734,6 +742,8 @@ static int set_acoustic(ide_drive_t *dri
 	return 0;
 }
 
+ide_devset_get(lba_addressing, addressing);
+
 /*
  * drive->addressing:
  *	0: 28-bit
@@ -757,33 +767,33 @@ static int set_lba_addressing(ide_drive_
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idedisk_add_settings(ide_drive_t *drive)
-{
-	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
-			&drive->bios_cyl, NULL);
-	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
-			&drive->bios_head, NULL);
-	ide_add_setting(drive, "bios_sect", SETTING_RW, TYPE_BYTE, 0, 63, 1, 1,
-			&drive->bios_sect, NULL);
-	ide_add_setting(drive, "address", SETTING_RW, TYPE_BYTE, 0, 2, 1, 1,
-			&drive->addressing, set_lba_addressing);
-	ide_add_setting(drive, "multcount", SETTING_RW, TYPE_BYTE, 0, 16, 1, 1,
-			&drive->mult_count, set_multcount);
-	ide_add_setting(drive, "nowerr", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
-			&drive->nowerr, set_nowerr);
-	ide_add_setting(drive, "lun", SETTING_RW, TYPE_INT, 0, 7, 1, 1,
-			&drive->lun, NULL);
-	ide_add_setting(drive, "wcache", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
-			&drive->wcache, write_cache);
-	ide_add_setting(drive, "acoustic", SETTING_RW, TYPE_BYTE, 0, 254, 1, 1,
-			&drive->acoustic, set_acoustic);
-	ide_add_setting(drive, "failures", SETTING_RW, TYPE_INT, 0, 65535, 1, 1,
-			&drive->failures, NULL);
-	ide_add_setting(drive, "max_failures", SETTING_RW, TYPE_INT, 0, 65535,
-			1, 1, &drive->max_failures, NULL);
-}
-#else
-static inline void idedisk_add_settings(ide_drive_t *drive) { ; }
+ide_devset_rw_nolock(acoustic,	0, 254, acoustic);
+ide_devset_rw_nolock(address,	0,   2, lba_addressing);
+ide_devset_rw_nolock(multcount,	0,  16, multcount);
+ide_devset_rw_nolock(nowerr,	0,   1, nowerr);
+ide_devset_rw_nolock(wcache,	0,   1, wcache);
+
+ide_devset_rw(bios_cyl,		0, 65535, bios_cyl);
+ide_devset_rw(bios_head,	0,   255, bios_head);
+ide_devset_rw(bios_sect,	0,    63, bios_sect);
+ide_devset_rw(failures,		0, 65535, failures);
+ide_devset_rw(lun,		0,     7, lun);
+ide_devset_rw(max_failures,	0, 65535, max_failures);
+
+static const struct ide_devset *idedisk_settings[] = {
+	&ide_devset_acoustic,
+	&ide_devset_address,
+	&ide_devset_bios_cyl,
+	&ide_devset_bios_head,
+	&ide_devset_bios_sect,
+	&ide_devset_failures,
+	&ide_devset_lun,
+	&ide_devset_max_failures,
+	&ide_devset_multcount,
+	&ide_devset_nowerr,
+	&ide_devset_wcache,
+	NULL
+};
 #endif
 
 static void idedisk_setup(ide_drive_t *drive)
@@ -795,7 +805,6 @@ static void idedisk_setup(ide_drive_t *d
 	unsigned long long capacity;
 
 	ide_proc_register_driver(drive, idkp->driver);
-	idedisk_add_settings(drive);
 
 	if (drive->id_read == 0)
 		return;
@@ -887,7 +896,7 @@ static void idedisk_setup(ide_drive_t *d
 	if ((id[ATA_ID_CSFO] & 1) || ata_id_wcache_enabled(id))
 		drive->wcache = 1;
 
-	write_cache(drive, 1);
+	set_wcache(drive, 1);
 }
 
 static void ide_cacheflush_p(ide_drive_t *drive)
@@ -983,6 +992,7 @@ static ide_driver_t idedisk_driver = {
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idedisk_proc,
+	.settings		= idedisk_settings,
 #endif
 };
 
@@ -1063,19 +1073,18 @@ static int idedisk_ioctl(struct inode *i
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
 	ide_drive_t *drive = idkp->drive;
-	int err, (*setfunc)(ide_drive_t *, int);
-	u8 *val;
+	int err, (*getfunc)(ide_drive_t *), (*setfunc)(ide_drive_t *, int);
 
 	switch (cmd) {
-	case HDIO_GET_ADDRESS:	 val = &drive->addressing;	goto read_val;
-	case HDIO_GET_MULTCOUNT: val = &drive->mult_count;	goto read_val;
-	case HDIO_GET_NOWERR:	 val = &drive->nowerr;		goto read_val;
-	case HDIO_GET_WCACHE:	 val = &drive->wcache;		goto read_val;
-	case HDIO_GET_ACOUSTIC:	 val = &drive->acoustic;	goto read_val;
+	case HDIO_GET_ADDRESS:	 getfunc = get_lba_addressing;	goto read_val;
+	case HDIO_GET_MULTCOUNT: getfunc = get_multcount;	goto read_val;
+	case HDIO_GET_NOWERR:	 getfunc = get_nowerr;		goto read_val;
+	case HDIO_GET_WCACHE:	 getfunc = get_wcache;		goto read_val;
+	case HDIO_GET_ACOUSTIC:	 getfunc = get_acoustic;	goto read_val;
 	case HDIO_SET_ADDRESS:	 setfunc = set_lba_addressing;	goto set_val;
 	case HDIO_SET_MULTCOUNT: setfunc = set_multcount;	goto set_val;
 	case HDIO_SET_NOWERR:	 setfunc = set_nowerr;		goto set_val;
-	case HDIO_SET_WCACHE:	 setfunc = write_cache;		goto set_val;
+	case HDIO_SET_WCACHE:	 setfunc = set_wcache;		goto set_val;
 	case HDIO_SET_ACOUSTIC:	 setfunc = set_acoustic;	goto set_val;
 	}
 
@@ -1084,7 +1093,7 @@ static int idedisk_ioctl(struct inode *i
 read_val:
 	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
-	err = *val;
+	err = getfunc(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1006,21 +1006,32 @@ static int idefloppy_identify_device(ide
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idefloppy_add_settings(ide_drive_t *drive)
+ide_devset_rw(bios_cyl,  0, 1023, bios_cyl);
+ide_devset_rw(bios_head, 0,  255, bios_head);
+ide_devset_rw(bios_sect, 0,   63, bios_sect);
+
+static int get_ticks(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	return floppy->ticks;
+}
 
-	ide_add_setting(drive, "bios_cyl", SETTING_RW, TYPE_INT, 0, 1023, 1, 1,
-			&drive->bios_cyl, NULL);
-	ide_add_setting(drive, "bios_head", SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
-			&drive->bios_head, NULL);
-	ide_add_setting(drive, "bios_sect", SETTING_RW,	TYPE_BYTE, 0,  63, 1, 1,
-			&drive->bios_sect, NULL);
-	ide_add_setting(drive, "ticks",	   SETTING_RW, TYPE_BYTE, 0, 255, 1, 1,
-			&floppy->ticks,	 NULL);
+static int set_ticks(ide_drive_t *drive, int arg)
+{
+	idefloppy_floppy_t *floppy = drive->driver_data;
+	floppy->ticks = arg;
+	return 0;
 }
-#else
-static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
+
+IDE_DEVSET(ticks, S_RW, 0, 255, get_ticks, set_ticks);
+
+static const struct ide_devset *idefloppy_settings[] = {
+	&ide_devset_bios_cyl,
+	&ide_devset_bios_head,
+	&ide_devset_bios_sect,
+	&ide_devset_ticks,
+	NULL
+};
 #endif
 
 static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
@@ -1062,7 +1073,6 @@ static void idefloppy_setup(ide_drive_t 
 	(void) ide_floppy_get_capacity(drive);
 
 	ide_proc_register_driver(drive, floppy->driver);
-	idefloppy_add_settings(drive);
 }
 
 static void ide_floppy_remove(ide_drive_t *drive)
@@ -1125,6 +1135,7 @@ static ide_driver_t idefloppy_driver = {
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idefloppy_proc,
+	.settings		= idefloppy_settings,
 #endif
 };
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1332,8 +1332,6 @@ static void hwif_register_devices(ide_hw
 		if (!drive->present)
 			continue;
 
-		ide_add_generic_settings(drive);
-
 		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
 		dev->parent = &hwif->gendev;
 		dev->bus = &ide_bus_type;
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -114,140 +114,24 @@ static int proc_ide_read_identify
 }
 
 /**
- *	__ide_add_setting	-	add an ide setting option
- *	@drive: drive to use
+ *	ide_find_setting	-	find a specific setting
+ *	@st: setting table pointer
  *	@name: setting name
- *	@rw: true if the function is read write
- *	@data_type: type of data
- *	@min: range minimum
- *	@max: range maximum
- *	@mul_factor: multiplication scale
- *	@div_factor: divison scale
- *	@data: private data field
- *	@set: setting
- *	@auto_remove: setting auto removal flag
  *
- *	Removes the setting named from the device if it is present.
- *	The function takes the settings_lock to protect against
- *	parallel changes. This function must not be called from IRQ
- *	context. Returns 0 on success or -1 on failure.
- *
- *	BUGS: This code is seriously over-engineered. There is also
- *	magic about how the driver specific features are setup. If
- *	a driver is attached we assume the driver settings are auto
- *	remove.
- */
-
-static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set, int auto_remove)
-{
-	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
-
-	mutex_lock(&ide_setting_mtx);
-	while ((*p) && strcmp((*p)->name, name) < 0)
-		p = &((*p)->next);
-	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
-		goto abort;
-	if ((setting->name = kmalloc(strlen(name) + 1, GFP_KERNEL)) == NULL)
-		goto abort;
-	strcpy(setting->name, name);
-	setting->rw = rw;
-	setting->data_type = data_type;
-	setting->min = min;
-	setting->max = max;
-	setting->mul_factor = mul_factor;
-	setting->div_factor = div_factor;
-	setting->data = data;
-	setting->set = set;
-
-	setting->next = *p;
-	if (auto_remove)
-		setting->auto_remove = 1;
-	*p = setting;
-	mutex_unlock(&ide_setting_mtx);
-	return 0;
-abort:
-	mutex_unlock(&ide_setting_mtx);
-	kfree(setting);
-	return -1;
-}
-
-int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set)
-{
-	return __ide_add_setting(drive, name, rw, data_type, min, max, mul_factor, div_factor, data, set, 1);
-}
-
-EXPORT_SYMBOL(ide_add_setting);
-
-/**
- *	__ide_remove_setting	-	remove an ide setting option
- *	@drive: drive to use
- *	@name: setting name
- *
- *	Removes the setting named from the device if it is present.
- *	The caller must hold the setting semaphore.
- */
-
-static void __ide_remove_setting(ide_drive_t *drive, char *name)
-{
-	ide_settings_t **p, *setting;
-
-	p = (ide_settings_t **) &drive->settings;
-
-	while ((*p) && strcmp((*p)->name, name))
-		p = &((*p)->next);
-	setting = (*p);
-	if (setting == NULL)
-		return;
-
-	(*p) = setting->next;
-
-	kfree(setting->name);
-	kfree(setting);
-}
-
-/**
- *	auto_remove_settings	-	remove driver specific settings
- *	@drive: drive
- *
- *	Automatically remove all the driver specific settings for this
- *	drive. This function may not be called from IRQ context. The
- *	caller must hold ide_setting_mtx.
- */
-
-static void auto_remove_settings(ide_drive_t *drive)
-{
-	ide_settings_t *setting;
-repeat:
-	setting = drive->settings;
-	while (setting) {
-		if (setting->auto_remove) {
-			__ide_remove_setting(drive, setting->name);
-			goto repeat;
-		}
-		setting = setting->next;
-	}
-}
-
-/**
- *	ide_find_setting_by_name	-	find a drive specific setting
- *	@drive: drive to scan
- *	@name: setting name
- *
- *	Scan's the device setting table for a matching entry and returns
+ *	Scan's the setting table for a matching entry and returns
  *	this or NULL if no entry is found. The caller must hold the
  *	setting semaphore
  */
 
-static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
+static const struct ide_devset *ide_find_setting(const struct ide_devset **st,
+						 char *name)
 {
-	ide_settings_t *setting = drive->settings;
-
-	while (setting) {
-		if (strcmp(setting->name, name) == 0)
+	while (*st) {
+		if (strcmp((*st)->name, name) == 0)
 			break;
-		setting = setting->next;
+		st++;
 	}
-	return setting;
+	return *st;
 }
 
 /**
@@ -263,26 +147,19 @@ static ide_settings_t *ide_find_setting_
  *	be told apart
  */
 
-static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
+static int ide_read_setting(ide_drive_t *drive,
+			    const struct ide_devset *setting)
 {
-	int		val = -EINVAL;
-	unsigned long	flags;
+	int val = -EINVAL;
+
+	if ((setting->flags & S_READ)) {
+		unsigned long flags;
 
-	if ((setting->rw & SETTING_READ)) {
 		spin_lock_irqsave(&ide_lock, flags);
-		switch (setting->data_type) {
-		case TYPE_BYTE:
-			val = *((u8 *) setting->data);
-			break;
-		case TYPE_SHORT:
-			val = *((u16 *) setting->data);
-			break;
-		case TYPE_INT:
-			val = *((u32 *) setting->data);
-			break;
-		}
+		val = setting->get(drive);
 		spin_unlock_irqrestore(&ide_lock, flags);
 	}
+
 	return val;
 }
 
@@ -304,33 +181,26 @@ static int ide_read_setting(ide_drive_t 
  *	The current scheme of polling is kludgy, though safe enough.
  */
 
-static int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int val)
+static int ide_write_setting(ide_drive_t *drive,
+			     const struct ide_devset *setting, int val)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (setting->set)
+	if (setting->set && (setting->flags & S_NOLOCK))
 		return setting->set(drive, val);
-	if (!(setting->rw & SETTING_WRITE))
+	if (!(setting->flags & S_WRITE))
 		return -EPERM;
 	if (val < setting->min || val > setting->max)
 		return -EINVAL;
 	if (ide_spin_wait_hwgroup(drive))
 		return -EBUSY;
-	switch (setting->data_type) {
-	case TYPE_BYTE:
-		*((u8 *) setting->data) = val;
-		break;
-	case TYPE_SHORT:
-		*((u16 *) setting->data) = val;
-		break;
-	case TYPE_INT:
-		*((u32 *) setting->data) = val;
-		break;
-	}
+	setting->set(drive, val);
 	spin_unlock_irq(&ide_lock);
 	return 0;
 }
 
+static ide_devset_get(xfer_rate, current_speed);
+
 static int set_xfer_rate (ide_drive_t *drive, int arg)
 {
 	ide_task_t task;
@@ -355,29 +225,30 @@ static int set_xfer_rate (ide_drive_t *d
 	return err;
 }
 
-/**
- *	ide_add_generic_settings	-	generic ide settings
- *	@drive: drive being configured
- *
- *	Add the generic parts of the system settings to the /proc files.
- *	The caller must not be holding the ide_setting_mtx.
- */
-
-void ide_add_generic_settings (ide_drive_t *drive)
-{
-/*
- *			  drive		setting name		read/write access				data type	min	max				mul_factor	div_factor	data pointer			set function
- */
-	__ide_add_setting(drive,	"io_32bit",		SETTING_RW,					TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
-	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		set_ksettings,	0);
-	__ide_add_setting(drive,	"nice1",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->nice1,			NULL,		0);
-	__ide_add_setting(drive,	"pio_mode",		SETTING_WRITE,					TYPE_BYTE,	0,	255,				1,		1,		NULL,				set_pio_mode,	0);
-	__ide_add_setting(drive,	"unmaskirq",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			set_unmaskirq,	0);
-	__ide_add_setting(drive,	"using_dma",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->using_dma,		set_using_dma,	0);
-	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
-	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
-	__ide_add_setting(drive,	"number",		SETTING_RW,					TYPE_BYTE,	0,	3,				1,		1,		&drive->dn,			NULL,		0);
-}
+ide_devset_rw_nolock(current_speed, 0, 70, xfer_rate);
+ide_devset_rw_nolock(io_32bit, 0, 1 + (SUPPORT_VLB_SYNC << 1), io_32bit);
+ide_devset_rw_nolock(keepsettings, 0, 1, ksettings);
+ide_devset_rw_nolock(unmaskirq, 0, 1, unmaskirq);
+ide_devset_rw_nolock(using_dma, 0, 1, using_dma);
+
+ide_devset_w_nolock(pio_mode, 0, 255, pio_mode);
+
+ide_devset_rw(init_speed, 0, 70, init_speed);
+ide_devset_rw(nice1, 0, 1, nice1);
+ide_devset_rw(number, 0, 3, dn);
+
+static const struct ide_devset *ide_generic_settings[] = {
+	&ide_devset_current_speed,
+	&ide_devset_init_speed,
+	&ide_devset_io_32bit,
+	&ide_devset_keepsettings,
+	&ide_devset_nice1,
+	&ide_devset_number,
+	&ide_devset_pio_mode,
+	&ide_devset_unmaskirq,
+	&ide_devset_using_dma,
+	NULL
+};
 
 static void proc_ide_settings_warn(void)
 {
@@ -394,19 +265,31 @@ static void proc_ide_settings_warn(void)
 static int proc_ide_read_settings
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
+	const struct ide_devset *setting, **g, **d;
 	ide_drive_t	*drive = (ide_drive_t *) data;
-	ide_settings_t	*setting = (ide_settings_t *) drive->settings;
 	char		*out = page;
 	int		len, rc, mul_factor, div_factor;
 
 	proc_ide_settings_warn();
 
 	mutex_lock(&ide_setting_mtx);
+	g = ide_generic_settings;
+	d = drive->settings;
 	out += sprintf(out, "name\t\t\tvalue\t\tmin\t\tmax\t\tmode\n");
 	out += sprintf(out, "----\t\t\t-----\t\t---\t\t---\t\t----\n");
-	while (setting) {
-		mul_factor = setting->mul_factor;
-		div_factor = setting->div_factor;
+	while (*g || (d && *d)) {
+		/* read settings in the alphabetical order */
+		if (*g && d && *d) {
+			if (strcmp((*d)->name, (*g)->name) < 0)
+				setting = *d++;
+			else
+				setting = *g++;
+		} else if (d && *d) {
+			setting = *d++;
+		} else
+			setting = *g++;
+		mul_factor = setting->mulf ? setting->mulf(drive) : 1;
+		div_factor = setting->divf ? setting->divf(drive) : 1;
 		out += sprintf(out, "%-24s", setting->name);
 		rc = ide_read_setting(drive, setting);
 		if (rc >= 0)
@@ -414,12 +297,11 @@ static int proc_ide_read_settings
 		else
 			out += sprintf(out, "%-16s", "write-only");
 		out += sprintf(out, "%-16d%-16d", (setting->min * mul_factor + div_factor - 1) / div_factor, setting->max * mul_factor / div_factor);
-		if (setting->rw & SETTING_READ)
+		if (setting->flags & S_READ)
 			out += sprintf(out, "r");
-		if (setting->rw & SETTING_WRITE)
+		if (setting->flags & S_WRITE)
 			out += sprintf(out, "w");
 		out += sprintf(out, "\n");
-		setting = setting->next;
 	}
 	len = out - page;
 	mutex_unlock(&ide_setting_mtx);
@@ -433,9 +315,10 @@ static int proc_ide_write_settings(struc
 {
 	ide_drive_t	*drive = (ide_drive_t *) data;
 	char		name[MAX_LEN + 1];
-	int		for_real = 0;
+	int		for_real = 0, mul_factor, div_factor;
 	unsigned long	n;
-	ide_settings_t	*setting;
+
+	const struct ide_devset *setting;
 	char *buf, *s;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -503,13 +386,21 @@ static int proc_ide_write_settings(struc
 			}
 
 			mutex_lock(&ide_setting_mtx);
-			setting = ide_find_setting_by_name(drive, name);
+			/* generic settings first, then driver specific ones */
+			setting = ide_find_setting(ide_generic_settings, name);
 			if (!setting) {
-				mutex_unlock(&ide_setting_mtx);
-				goto parse_error;
+				if (drive->settings)
+					setting = ide_find_setting(drive->settings, name);
+				if (!setting) {
+					mutex_unlock(&ide_setting_mtx);
+					goto parse_error;
+				}
+			}
+			if (for_real) {
+				mul_factor = setting->mulf ? setting->mulf(drive) : 1;
+				div_factor = setting->divf ? setting->divf(drive) : 1;
+				ide_write_setting(drive, setting, val * div_factor / mul_factor);
 			}
-			if (for_real)
-				ide_write_setting(drive, setting, val * setting->div_factor / setting->mul_factor);
 			mutex_unlock(&ide_setting_mtx);
 		}
 	} while (!for_real++);
@@ -680,6 +571,10 @@ static void ide_remove_proc_entries(stru
 
 void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
 {
+	mutex_lock(&ide_setting_mtx);
+	drive->settings = driver->settings;
+	mutex_unlock(&ide_setting_mtx);
+
 	ide_add_proc_entries(drive->proc, driver->proc, drive);
 }
 
@@ -716,7 +611,7 @@ void ide_proc_unregister_driver(ide_driv
 	 * OTOH both ide_{read,write}_setting are only ever used under
 	 * ide_setting_mtx.
 	 */
-	auto_remove_settings(drive);
+	drive->settings = NULL;
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 }
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2408,28 +2408,56 @@ static void idetape_get_mode_sense_resul
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idetape_add_settings(ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-
-	ide_add_setting(drive, "buffer", SETTING_READ, TYPE_SHORT, 0, 0xffff,
-			1, 2, (u16 *)&tape->caps[16], NULL);
-	ide_add_setting(drive, "speed", SETTING_READ, TYPE_SHORT, 0, 0xffff,
-			1, 1, (u16 *)&tape->caps[14], NULL);
-	ide_add_setting(drive, "buffer_size", SETTING_READ, TYPE_INT, 0, 0xffff,
-			1, 1024, &tape->buffer_size, NULL);
-	ide_add_setting(drive, "tdsc", SETTING_RW, TYPE_INT, IDETAPE_DSC_RW_MIN,
-			IDETAPE_DSC_RW_MAX, 1000, HZ, &tape->best_dsc_rw_freq,
-			NULL);
-	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1,
-			1, &drive->dsc_overlap, NULL);
-	ide_add_setting(drive, "avg_speed", SETTING_READ, TYPE_INT, 0, 0xffff,
-			1, 1, &tape->avg_speed, NULL);
-	ide_add_setting(drive, "debug_mask", SETTING_RW, TYPE_INT, 0, 0xffff, 1,
-			1, &tape->debug_mask, NULL);
-}
-#else
-static inline void idetape_add_settings(ide_drive_t *drive) { ; }
+#define ide_tape_devset_get(name, field) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	idetape_tape_t *tape = drive->driver_data; \
+	return tape->field; \
+}
+
+#define ide_tape_devset_set(name, field) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	idetape_tape_t *tape = drive->driver_data; \
+	tape->field = arg; \
+	return 0; \
+}
+
+#define ide_tape_devset_rw(_name, _min, _max, _field, _mulf, _divf) \
+ide_tape_devset_get(_name, _field) \
+ide_tape_devset_set(_name, _field) \
+__IDE_DEVSET(_name, S_RW, _min, _max, get_##_name, set_##_name, _mulf, _divf)
+
+#define ide_tape_devset_r(_name, _min, _max, _field, _mulf, _divf) \
+ide_tape_devset_get(_name, _field) \
+__IDE_DEVSET(_name, S_READ, _min, _max, get_##_name, NULL, _mulf, _divf)
+
+static int mulf_tdsc(ide_drive_t *drive)	{ return 1000; }
+static int divf_tdsc(ide_drive_t *drive)	{ return   HZ; }
+static int divf_buffer(ide_drive_t *drive)	{ return    2; }
+static int divf_buffer_size(ide_drive_t *drive)	{ return 1024; }
+
+ide_devset_rw(dsc_overlap,	0,	1, dsc_overlap);
+
+ide_tape_devset_rw(debug_mask,	0, 0xffff, debug_mask,  NULL, NULL);
+ide_tape_devset_rw(tdsc, IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
+		   best_dsc_rw_freq, mulf_tdsc, divf_tdsc);
+
+ide_tape_devset_r(avg_speed,	0, 0xffff, avg_speed,   NULL, NULL);
+ide_tape_devset_r(speed,	0, 0xffff, caps[14],    NULL, NULL);
+ide_tape_devset_r(buffer,	0, 0xffff, caps[16],    NULL, divf_buffer);
+ide_tape_devset_r(buffer_size,	0, 0xffff, buffer_size, NULL, divf_buffer_size);
+
+static const struct ide_devset *idetape_settings[] = {
+	&ide_devset_avg_speed,
+	&ide_devset_buffer,
+	&ide_devset_buffer_size,
+	&ide_devset_debug_mask,
+	&ide_devset_dsc_overlap,
+	&ide_devset_speed,
+	&ide_devset_tdsc,
+	NULL
+};
 #endif
 
 /*
@@ -2513,7 +2541,6 @@ static void idetape_setup(ide_drive_t *d
 		drive->using_dma ? ", DMA":"");
 
 	ide_proc_register_driver(drive, tape->driver);
-	idetape_add_settings(drive);
 }
 
 static void ide_tape_remove(ide_drive_t *drive)
@@ -2584,6 +2611,7 @@ static ide_driver_t idetape_driver = {
 	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idetape_proc,
+	.settings		= idetape_settings,
 #endif
 };
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -287,6 +287,8 @@ int ide_spin_wait_hwgroup (ide_drive_t *
 
 EXPORT_SYMBOL(ide_spin_wait_hwgroup);
 
+ide_devset_get(io_32bit, io_32bit);
+
 int set_io_32bit(ide_drive_t *drive, int arg)
 {
 	if (drive->no_io_32bit)
@@ -305,6 +307,8 @@ int set_io_32bit(ide_drive_t *drive, int
 	return 0;
 }
 
+ide_devset_get(ksettings, keep_settings);
+
 int set_ksettings(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 1)
@@ -318,6 +322,8 @@ int set_ksettings(ide_drive_t *drive, in
 	return 0;
 }
 
+ide_devset_get(using_dma, using_dma);
+
 int set_using_dma(ide_drive_t *drive, int arg)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
@@ -394,6 +400,8 @@ int set_pio_mode(ide_drive_t *drive, int
 	return 0;
 }
 
+ide_devset_get(unmaskirq, unmask);
+
 int set_unmaskirq(ide_drive_t *drive, int arg)
 {
 	if (drive->no_unmask)
@@ -555,14 +563,13 @@ int generic_ide_ioctl(ide_drive_t *drive
 {
 	unsigned long flags;
 	ide_driver_t *drv;
-	int err = 0, (*setfunc)(ide_drive_t *, int);
-	u8 *val;
+	int err = 0, (*getfunc)(ide_drive_t *), (*setfunc)(ide_drive_t *, int);
 
 	switch (cmd) {
-	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
-	case HDIO_GET_KEEPSETTINGS: val = &drive->keep_settings; goto read_val;
-	case HDIO_GET_UNMASKINTR:   val = &drive->unmask;	 goto read_val;
-	case HDIO_GET_DMA:	    val = &drive->using_dma;	 goto read_val;
+	case HDIO_GET_32BIT:	    getfunc = get_io_32bit;	 goto read_val;
+	case HDIO_GET_KEEPSETTINGS: getfunc = get_ksettings;	 goto read_val;
+	case HDIO_GET_UNMASKINTR:   getfunc = get_unmaskirq;	 goto read_val;
+	case HDIO_GET_DMA:	    getfunc = get_using_dma;	 goto read_val;
 	case HDIO_SET_32BIT:	    setfunc = set_io_32bit;	 goto set_val;
 	case HDIO_SET_KEEPSETTINGS: setfunc = set_ksettings;	 goto set_val;
 	case HDIO_SET_PIO_MODE:	    setfunc = set_pio_mode;	 goto set_val;
@@ -638,7 +645,7 @@ int generic_ide_ioctl(ide_drive_t *drive
 read_val:
 	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
-	err = *val;
+	err = getfunc(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -428,21 +428,41 @@ static ide_startstop_t idescsi_do_reques
 }
 
 #ifdef CONFIG_IDE_PROC_FS
-static void idescsi_add_settings(ide_drive_t *drive)
-{
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
-/*
- *			drive	setting name	read/write	data type	min	max	mul_factor	div_factor	data pointer		set function
- */
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	1023,	1,		1,		&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,	1,		1,		&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,	1,		1,		&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"transform",	SETTING_RW,	TYPE_INT,	0,	3,	1,		1,		&scsi->transform,	NULL);
-	ide_add_setting(drive,	"log",		SETTING_RW,	TYPE_INT,	0,	1,	1,		1,		&scsi->log,		NULL);
-}
-#else
-static inline void idescsi_add_settings(ide_drive_t *drive) { ; }
+#define ide_scsi_devset_get(name, field) \
+static int get_##name(ide_drive_t *drive) \
+{ \
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive); \
+	return scsi->field; \
+}
+
+#define ide_scsi_devset_set(name, field) \
+static int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	idescsi_scsi_t *scsi = drive_to_idescsi(drive); \
+	scsi->field = arg; \
+	return 0; \
+}
+
+#define ide_scsi_devset_rw(_name, _min, _max, _field) \
+ide_scsi_devset_get(_name, _field); \
+ide_scsi_devset_set(_name, _field); \
+IDE_DEVSET(_name, S_RW, _min, _max, get_##_name, set_##_name)
+
+ide_devset_rw(bios_cyl,		0, 1023, bios_cyl);
+ide_devset_rw(bios_head,	0,  255, bios_head);
+ide_devset_rw(bios_sect,	0,   63, bios_sect);
+
+ide_scsi_devset_rw(transform,	0,    3, transform);
+ide_scsi_devset_rw(log,		0,    1, log);
+
+static const struct ide_devset *idescsi_settings[] = {
+	&ide_devset_bios_cyl,
+	&ide_devset_bios_head,
+	&ide_devset_bios_sect,
+	&ide_devset_log,
+	&ide_devset_transform,
+	NULL
+};
 #endif
 
 /*
@@ -460,7 +480,6 @@ static void idescsi_setup (ide_drive_t *
 	drive->pc_callback = ide_scsi_callback;
 
 	ide_proc_register_driver(drive, scsi->driver);
-	idescsi_add_settings(drive);
 }
 
 static void ide_scsi_remove(ide_drive_t *drive)
@@ -508,6 +527,7 @@ static ide_driver_t idescsi_driver = {
 	.error                  = idescsi_atapi_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idescsi_proc,
+	.settings		= idescsi_settings,
 #endif
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -315,8 +315,8 @@ typedef enum {
 	ide_started,	/* a drive operation was started, handler was set */
 } ide_startstop_t;
 
+struct ide_devset;
 struct ide_driver_s;
-struct ide_settings_s;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 struct ide_acpi_drive_link;
@@ -393,7 +393,7 @@ struct ide_drive_s {
 	u16			*id;	/* identification info */
 #ifdef CONFIG_IDE_PROC_FS
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
-	struct ide_settings_s *settings;/* /proc/ide/ drive settings */
+	const struct ide_devset **settings; /* /proc/ide/ drive settings */
 #endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
@@ -405,16 +405,16 @@ struct ide_drive_s {
 	special_t	special;	/* special action flags */
 	select_t	select;		/* basic drive/head select reg value */
 
-	u8	keep_settings;		/* restore settings after drive reset */
-	u8	using_dma;		/* disk is using dma for read/write */
 	u8	retry_pio;		/* retrying dma capable host in pio */
 	u8	state;			/* retry state */
 	u8	waiting_for_dma;	/* dma currently in progress */
-	u8	unmask;			/* okay to unmask other irqs */
-	u8	noflush;		/* don't attempt flushes */
-	u8	dsc_overlap;		/* DSC overlap */
-	u8	nice1;			/* give potential excess bandwidth */
 
+	unsigned keep_settings	: 1;	/* restore settings after drive reset */
+	unsigned using_dma	: 1;	/* disk is using dma for read/write */
+	unsigned unmask		: 1;	/* okay to unmask other irqs */
+	unsigned noflush	: 1;	/* don't attempt flushes */
+	unsigned dsc_overlap	: 1;	/* DSC overlap */
+	unsigned nice1		: 1;	/* give potential excess bandwidth */
 	unsigned present	: 1;	/* drive is physically present */
 	unsigned dead		: 1;	/* device ejected hint */
 	unsigned id_read	: 1;	/* 1=id read from disk 0 = synthetic */
@@ -432,14 +432,15 @@ struct ide_drive_s {
 	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
 	unsigned post_reset	: 1;
 	unsigned udma33_warned	: 1;
+	unsigned addressing	: 2;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
+	unsigned wcache		: 1;	/* status of write cache */
+	unsigned nowerr		: 1;	/* used for ignoring ATA_DF */
 
-	u8	addressing;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
         u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
         u8	current_speed;	/* current transfer rate set */
 	u8	desired_speed;	/* desired transfer rate set */
         u8	dn;		/* now wide spread use */
-        u8	wcache;		/* status of write cache */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
 	u8	ready_stat;	/* min status value for drive ready */
@@ -448,7 +449,6 @@ struct ide_drive_s {
 	u8	tune_req;	/* requested drive tuning setting */
 	u8	io_32bit;	/* 0=16-bit, 1=32-bit, 2/3=32bit+sync */
 	u8	bad_wstat;	/* used for ignoring ATA_DF */
-	u8	nowerr;		/* used for ignoring ATA_DF */
 	u8	head;		/* "real" number of heads */
 	u8	sect;		/* "real" sectors per track */
 	u8	bios_head;	/* BIOS/fdisk/LILO number of heads */
@@ -696,12 +696,29 @@ typedef struct ide_driver_s ide_driver_t
 
 extern struct mutex ide_setting_mtx;
 
+int get_io_32bit(ide_drive_t *);
 int set_io_32bit(ide_drive_t *, int);
+int get_ksettings(ide_drive_t *);
 int set_ksettings(ide_drive_t *, int);
 int set_pio_mode(ide_drive_t *, int);
+int get_unmaskirq(ide_drive_t *);
 int set_unmaskirq(ide_drive_t *, int);
+int get_using_dma(ide_drive_t *);
 int set_using_dma(ide_drive_t *, int);
 
+#define ide_devset_get(name, field) \
+int get_##name(ide_drive_t *drive) \
+{ \
+	return drive->field; \
+}
+
+#define ide_devset_set(name, field) \
+int set_##name(ide_drive_t *drive, int arg) \
+{ \
+	drive->field = arg; \
+	return 0; \
+}
+
 /* ATAPI packet command flags */
 enum {
 	/* set when an error is considered normal - no retry (ide-tape) */
@@ -766,30 +783,53 @@ struct ide_atapi_pc {
  * configurable drive settings
  */
 
-#define TYPE_INT	0
-#define TYPE_BYTE	1
-#define TYPE_SHORT	2
-
-#define SETTING_READ	(1 << 0)
-#define SETTING_WRITE	(1 << 1)
-#define SETTING_RW	(SETTING_READ | SETTING_WRITE)
+#define S_READ		(1 << 0)
+#define S_WRITE		(1 << 1)
+#define S_RW		(S_READ | S_WRITE)
+#define S_NOLOCK	(1 << 2)
 
-typedef int (ide_procset_t)(ide_drive_t *, int);
-typedef struct ide_settings_s {
-	char			*name;
-	int			rw;
-	int			data_type;
-	int			min;
-	int			max;
-	int			mul_factor;
-	int			div_factor;
-	void			*data;
-	ide_procset_t		*set;
-	int			auto_remove;
-	struct ide_settings_s	*next;
-} ide_settings_t;
+struct ide_devset {
+	const char	*name;
+	unsigned int	flags;
+	int		min, max;
+	int		(*get)(ide_drive_t *);
+	int		(*set)(ide_drive_t *, int);
+	int		(*mulf)(ide_drive_t *);
+	int		(*divf)(ide_drive_t *);
+};
 
-int ide_add_setting(ide_drive_t *, const char *, int, int, int, int, int, int, void *, ide_procset_t *set);
+#define __DEVSET(_name, _flags, _min, _max, _get, _set, _mulf, _divf) { \
+	.name	= __stringify(_name), \
+	.flags	= _flags, \
+	.min	= _min, \
+	.max	= _max, \
+	.get	= _get, \
+	.set	= _set, \
+	.mulf	= _mulf, \
+	.divf	= _divf, \
+}
+
+#define __IDE_DEVSET(_name, _flags, _min, _max, _get, _set, _mulf, _divf) \
+static const struct ide_devset ide_devset_##_name = \
+	__DEVSET(_name, _flags, _min, _max, _get, _set, _mulf, _divf)
+
+#define IDE_DEVSET(_name, _flags, _min, _max, _get, _set) \
+__IDE_DEVSET(_name, _flags, _min, _max, _get, _set, NULL, NULL)
+
+#define ide_devset_rw_nolock(_name, _min, _max, _func) \
+IDE_DEVSET(_name, S_RW | S_NOLOCK, _min, _max, get_##_func, set_##_func)
+
+#define ide_devset_w_nolock(_name, _min, _max, _func) \
+IDE_DEVSET(_name, S_WRITE | S_NOLOCK, _min, _max, NULL, set_##_func)
+
+#define ide_devset_rw(_name, _min, _max, _field) \
+static ide_devset_get(_name, _field); \
+static ide_devset_set(_name, _field); \
+IDE_DEVSET(_name, S_RW, _min, _max, get_##_name, set_##_name)
+
+#define ide_devset_r(_name, _min, _max, _field) \
+ide_devset_get(_name, _field) \
+IDE_DEVSET(_name, S_READ, _min, _max, get_##_name, NULL)
 
 /*
  * /proc/ide interface
@@ -810,8 +850,6 @@ void ide_proc_unregister_port(ide_hwif_t
 void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
 void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
 
-void ide_add_generic_settings(ide_drive_t *);
-
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
 
@@ -839,7 +877,6 @@ static inline void ide_proc_unregister_d
 static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
 static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
 static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
-static inline void ide_add_generic_settings(ide_drive_t *drive) { ; }
 #define PROC_IDE_READ_RETURN(page,start,off,count,eof,len) return 0;
 #endif
 
@@ -896,6 +933,7 @@ struct ide_driver_s {
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
 	ide_proc_entry_t	*proc;
+	const struct ide_devset	**settings;
 #endif
 };
 
