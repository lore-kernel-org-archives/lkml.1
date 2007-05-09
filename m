Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbXEIXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbXEIXLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbXEIXLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:11:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:15956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbXEIXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dflxUUPNoLD7eXStuSPRs6gygyFdT4Y0aBrU2Xt+UWdVRu6CCdJ+hJeEsX0CM79TclLl6k12RSeH80QhGnh0asczJmcJSNbYtKfjEnhpN4BC2jreP+f6WCR/d0v0HC6RmKT7ik8AQM0wHF0Yc27EdRpRQryNK0F5XmNLROT7c28=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] IDE update
Date: Thu, 10 May 2007 01:23:13 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200705100046.05280.bzolnier@gmail.com> <46424F38.7010405@garzik.org>
In-Reply-To: <46424F38.7010405@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705100123.14209.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2007, Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Bartlomiej Zolnierkiewicz (11):
> >       ide: fix UDMA/MWDMA/SWDMA masks (v3)
> >       ide: rework the code for selecting the best DMA transfer mode (v3)
> >       ide: add ide_tune_dma() helper
> >       ide: make /proc/ide/ optional
> >       ide: split off ioctl handling from IDE settings (v2)
> >       ide: move IDE settings handling to ide-proc.c
> >       ide: cable detection fixes (take 2)
> >       ide: add "initializing" argument to ide_register_hw()
> >       ide: add ide_proc_register_port()
> >       ide: legacy PCI bus order probing fixes
> >       ide: fix PIO setup on resume for ATAPI devices
> > 
> > 
> > [ sorry but the patch is too big to be included ]
> 
> 
> The limit was raised to 400K IIRC.

That's (good) news to me, here goes the actual 150K patch:

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5bdf64b..1d06b41 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -291,6 +291,17 @@ config IDE_TASK_IOCTL
 
 	  If you are unsure, say N here.
 
+config IDE_PROC_FS
+	bool "legacy /proc/ide/ support"
+	depends on IDE && PROC_FS
+	default y
+	help
+	  This option enables support for the various files in
+	  /proc/ide.  In Linux 2.6 this has been superseded by
+	  files in sysfs but many legacy applications rely on this.
+
+	  If unsure say Y.
+
 comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
@@ -360,6 +371,9 @@ config IDEPCI_SHARE_IRQ
 	  It is safe to say Y to this question, in most cases.
 	  If unsure, say N.
 
+config IDEPCI_PCIBUS_ORDER
+	def_bool PCI && BLK_DEV_IDE=y && BLK_DEV_IDEPCI
+
 config BLK_DEV_OFFBOARD
 	bool "Boot off-board chipsets first support"
 	depends on PCI && BLK_DEV_IDEPCI
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index d9f029e..75dc696 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -20,7 +20,7 @@ ide-core-$(CONFIG_BLK_DEV_CMD640)	+= pci/cmd640.o
 # Core IDE code - must come before legacy
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
-ide-core-$(CONFIG_PROC_FS)		+= ide-proc.o
+ide-core-$(CONFIG_IDE_PROC_FS)		+= ide-proc.o
 ide-core-$(CONFIG_BLK_DEV_IDEPNP)	+= ide-pnp.o
 ide-core-$(CONFIG_BLK_DEV_IDEACPI)	+= ide-acpi.o
 
diff --git a/drivers/ide/arm/bast-ide.c b/drivers/ide/arm/bast-ide.c
index 9d474e5..f7449d0 100644
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -45,7 +45,7 @@ bastide_register(unsigned int base, unsigned int aux, int irq,
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	ide_register_hw(&hw, hwif);
+	ide_register_hw(&hw, 0, hwif);
 
 	return 0;
 }
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index e2953fc..1fe0457 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -342,7 +342,7 @@ static int icside_dma_check(ide_drive_t *drive)
 	 * Enable DMA on any drive that has multiword DMA
 	 */
 	if (id->field_valid & 2) {
-		xfer_mode = ide_dma_speed(drive, 0);
+		xfer_mode = ide_max_dma_mode(drive);
 		goto out;
 	}
 
@@ -591,7 +591,8 @@ icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 	state->hwif[0] = hwif;
 
 	probe_hwif_init(hwif);
-	create_proc_ide_interfaces();
+
+	ide_proc_register_port(hwif);
 
 	return 0;
 }
@@ -679,7 +680,9 @@ icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 
 	probe_hwif_init(hwif);
 	probe_hwif_init(mate);
-	create_proc_ide_interfaces();
+
+	ide_proc_register_port(hwif);
+	ide_proc_register_port(mate);
 
 	return 0;
 
diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 23488c4..a3d6744 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -38,6 +38,6 @@ void __init ide_arm_init(void)
 		memset(&hw, 0, sizeof(hw));
 		ide_std_init_ports(&hw, IDE_ARM_IO, IDE_ARM_IO + 0x206);
 		hw.irq = IDE_ARM_IRQ;
-		ide_register_hw(&hw, NULL);
+		ide_register_hw(&hw, 1, NULL);
 	}
 }
diff --git a/drivers/ide/arm/rapide.c b/drivers/ide/arm/rapide.c
index 9c6c49f..890ea3f 100644
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -76,7 +76,7 @@ rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 		hwif->gendev.parent = &ec->dev;
 		hwif->noprobe = 0;
 		probe_hwif_init(hwif);
-		create_proc_ide_interfaces();
+		ide_proc_register_port(hwif);
 		ecard_set_drvdata(ec, hwif);
 		goto out;
 	}
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 5e8efc8..c04cb25 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -796,7 +796,7 @@ init_e100_ide (void)
 		                ide_offsets,
 		                0, 0, cris_ide_ack_intr,
 		                ide_default_irq(0));
-		ide_register_hw(&hw, &hwif);
+		ide_register_hw(&hw, 1, &hwif);
 		hwif->mmio = 1;
 		hwif->chipset = ide_etrax100;
 		hwif->tuneproc = &tune_cris_ide;
@@ -1004,7 +1004,7 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 
 static int cris_config_drive_for_dma (ide_drive_t *drive)
 {
-	u8 speed = ide_dma_speed(drive, 1);
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (!speed)
 		return 0;
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 88750a3..6d26ad7 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -101,7 +101,7 @@ void __init h8300_ide_init(void)
 	hw_setup(&hw);
 
 	/* register if */
-	idx = ide_register_hw(&hw, &hwif);
+	idx = ide_register_hw(&hw, 1, &hwif);
 	if (idx == -1) {
 		printk(KERN_ERR "ide-h8300: IDE I/F register failed\n");
 		return;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 638becd..252ab82 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -3059,10 +3059,14 @@ int ide_cdrom_probe_capabilities (ide_drive_t *drive)
 	return nslots;
 }
 
+#ifdef CONFIG_IDE_PROC_FS
 static void ide_cdrom_add_settings(ide_drive_t *drive)
 {
-	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW, -1, -1, TYPE_BYTE, 0, 1, 1,	1, &drive->dsc_overlap, NULL);
+	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1, &drive->dsc_overlap, NULL);
 }
+#else
+static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
+#endif
 
 /*
  * standard prep_rq_fn that builds 10 byte cmds
@@ -3274,7 +3278,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	return 0;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_IDE_PROC_FS
 static
 sector_t ide_cdrom_capacity (ide_drive_t *drive)
 {
@@ -3291,7 +3295,7 @@ static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
-	ide_unregister_subdriver(drive, info->driver);
+	ide_proc_unregister_driver(drive, info->driver);
 
 	del_gendisk(info->disk);
 
@@ -3321,7 +3325,7 @@ static void ide_cd_release(struct kref *kref)
 
 static int ide_cd_probe(ide_drive_t *);
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_IDE_PROC_FS
 static int proc_idecd_read_capacity
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
@@ -3336,8 +3340,6 @@ static ide_proc_entry_t idecd_proc[] = {
 	{ "capacity", S_IFREG|S_IRUGO, proc_idecd_read_capacity, NULL },
 	{ NULL, 0, NULL, NULL }
 };
-#else
-# define idecd_proc	NULL
 #endif
 
 static ide_driver_t ide_cdrom_driver = {
@@ -3355,7 +3357,9 @@ static ide_driver_t ide_cdrom_driver = {
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
+#ifdef CONFIG_IDE_PROC_FS
 	.proc			= idecd_proc,
+#endif
 };
 
 static int idecd_open(struct inode * inode, struct file * file)
@@ -3517,7 +3521,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_register_subdriver(drive, &ide_cdrom_driver);
+	ide_proc_register_driver(drive, &ide_cdrom_driver);
 
 	kref_init(&info->kref);
 
@@ -3534,7 +3538,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
 		struct cdrom_device_info *devinfo = &info->devinfo;
-		ide_unregister_subdriver(drive, &ide_cdrom_driver);
+		ide_proc_unregister_driver(drive, &ide_cdrom_driver);
 		kfree(info->buffer);
 		kfree(info->toc);
 		kfree(info->changer_info);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 37aa6dd..7fff773 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -559,8 +559,7 @@ static sector_t idedisk_capacity (ide_drive_t *drive)
 	return drive->capacity64 - drive->sect0;
 }
 
-#ifdef CONFIG_PROC_FS
-
+#ifdef CONFIG_IDE_PROC_FS
 static int smart_enable(ide_drive_t *drive)
 {
 	ide_task_t args;
@@ -678,12 +677,7 @@ static ide_proc_entry_t idedisk_proc[] = {
 	{ "smart_thresholds",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_thresholds,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
-
-#else
-
-#define	idedisk_proc	NULL
-
-#endif	/* CONFIG_PROC_FS */
+#endif	/* CONFIG_IDE_PROC_FS */
 
 static void idedisk_prepare_flush(request_queue_t *q, struct request *rq)
 {
@@ -737,6 +731,9 @@ static int set_multcount(ide_drive_t *drive, int arg)
 {
 	struct request rq;
 
+	if (arg < 0 || arg > drive->id->max_multsect)
+		return -EINVAL;
+
 	if (drive->special.b.set_multmode)
 		return -EBUSY;
 	ide_init_drive_cmd (&rq);
@@ -749,6 +746,9 @@ static int set_multcount(ide_drive_t *drive, int arg)
 
 static int set_nowerr(ide_drive_t *drive, int arg)
 {
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
 	if (ide_spin_wait_hwgroup(drive))
 		return -EBUSY;
 	drive->nowerr = arg;
@@ -800,6 +800,9 @@ static int write_cache(ide_drive_t *drive, int arg)
 	ide_task_t args;
 	int err = 1;
 
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
 	if (ide_id_has_flush_cache(drive->id)) {
 		memset(&args, 0, sizeof(ide_task_t));
 		args.tfRegister[IDE_FEATURE_OFFSET]	= (arg) ?
@@ -835,6 +838,9 @@ static int set_acoustic (ide_drive_t *drive, int arg)
 {
 	ide_task_t args;
 
+	if (arg < 0 || arg > 254)
+		return -EINVAL;
+
 	memset(&args, 0, sizeof(ide_task_t));
 	args.tfRegister[IDE_FEATURE_OFFSET]	= (arg) ? SETFEATURES_EN_AAM :
 							  SETFEATURES_DIS_AAM;
@@ -855,6 +861,9 @@ static int set_acoustic (ide_drive_t *drive, int arg)
  */
 static int set_lba_addressing(ide_drive_t *drive, int arg)
 {
+	if (arg < 0 || arg > 2)
+		return -EINVAL;
+
 	drive->addressing =  0;
 
 	if (HWIF(drive)->no_lba48)
@@ -866,23 +875,27 @@ static int set_lba_addressing(ide_drive_t *drive, int arg)
 	return 0;
 }
 
+#ifdef CONFIG_IDE_PROC_FS
 static void idedisk_add_settings(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 
-	ide_add_setting(drive,	"bios_cyl",		SETTING_RW,					-1,			-1,			TYPE_INT,	0,	65535,				1,	1,	&drive->bios_cyl,		NULL);
-	ide_add_setting(drive,	"bios_head",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	255,				1,	1,	&drive->bios_head,		NULL);
-	ide_add_setting(drive,	"bios_sect",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	63,				1,	1,	&drive->bios_sect,		NULL);
-	ide_add_setting(drive,	"address",		SETTING_RW,					HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,	TYPE_INTA,	0,	2,				1,	1,	&drive->addressing,	set_lba_addressing);
-	ide_add_setting(drive,	"bswap",		SETTING_READ,					-1,			-1,			TYPE_BYTE,	0,	1,				1,	1,	&drive->bswap,			NULL);
-	ide_add_setting(drive,	"multcount",		id ? SETTING_RW : SETTING_READ,			HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT,	TYPE_BYTE,	0,	id ? id->max_multsect : 0,	1,	1,	&drive->mult_count,		set_multcount);
-	ide_add_setting(drive,	"nowerr",		SETTING_RW,					HDIO_GET_NOWERR,	HDIO_SET_NOWERR,	TYPE_BYTE,	0,	1,				1,	1,	&drive->nowerr,			set_nowerr);
-	ide_add_setting(drive,	"lun",			SETTING_RW,					-1,			-1,			TYPE_INT,	0,	7,				1,	1,	&drive->lun,			NULL);
-	ide_add_setting(drive,	"wcache",		SETTING_RW,					HDIO_GET_WCACHE,	HDIO_SET_WCACHE,	TYPE_BYTE,	0,	1,				1,	1,	&drive->wcache,			write_cache);
-	ide_add_setting(drive,	"acoustic",		SETTING_RW,					HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,	TYPE_BYTE,	0,	254,				1,	1,	&drive->acoustic,		set_acoustic);
- 	ide_add_setting(drive,	"failures",		SETTING_RW,					-1,			-1,			TYPE_INT,	0,	65535,				1,	1,	&drive->failures,		NULL);
- 	ide_add_setting(drive,	"max_failures",		SETTING_RW,					-1,			-1,			TYPE_INT,	0,	65535,				1,	1,	&drive->max_failures,		NULL);
+	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->bios_cyl,	NULL);
+	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,			1,	1,	&drive->bios_head,	NULL);
+	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,			1,	1,	&drive->bios_sect,	NULL);
+	ide_add_setting(drive,	"address",	SETTING_RW,	TYPE_BYTE,	0,	2,			1,	1,	&drive->addressing,	set_lba_addressing);
+	ide_add_setting(drive,	"bswap",	SETTING_READ,	TYPE_BYTE,	0,	1,			1,	1,	&drive->bswap,		NULL);
+	ide_add_setting(drive,	"multcount",	SETTING_RW,	TYPE_BYTE,	0,	id->max_multsect,	1,	1,	&drive->mult_count,	set_multcount);
+	ide_add_setting(drive,	"nowerr",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->nowerr,		set_nowerr);
+	ide_add_setting(drive,	"lun",		SETTING_RW,	TYPE_INT,	0,	7,			1,	1,	&drive->lun,		NULL);
+	ide_add_setting(drive,	"wcache",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->wcache,		write_cache);
+	ide_add_setting(drive,	"acoustic",	SETTING_RW,	TYPE_BYTE,	0,	254,			1,	1,	&drive->acoustic,	set_acoustic);
+ 	ide_add_setting(drive,	"failures",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->failures,	NULL);
+ 	ide_add_setting(drive,	"max_failures",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->max_failures,	NULL);
 }
+#else
+static inline void idedisk_add_settings(ide_drive_t *drive) { ; }
+#endif
 
 static void idedisk_setup (ide_drive_t *drive)
 {
@@ -1001,7 +1014,7 @@ static void ide_disk_remove(ide_drive_t *drive)
 	struct ide_disk_obj *idkp = drive->driver_data;
 	struct gendisk *g = idkp->disk;
 
-	ide_unregister_subdriver(drive, idkp->driver);
+	ide_proc_unregister_driver(drive, idkp->driver);
 
 	del_gendisk(g);
 
@@ -1066,7 +1079,9 @@ static ide_driver_t idedisk_driver = {
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
+#ifdef CONFIG_IDE_PROC_FS
 	.proc			= idedisk_proc,
+#endif
 };
 
 static int idedisk_open(struct inode *inode, struct file *filp)
@@ -1140,9 +1155,49 @@ static int idedisk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int idedisk_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
+	unsigned long flags;
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
-	return generic_ide_ioctl(idkp->drive, file, bdev, cmd, arg);
+	ide_drive_t *drive = idkp->drive;
+	int err, (*setfunc)(ide_drive_t *, int);
+	u8 *val;
+
+	switch (cmd) {
+	case HDIO_GET_ADDRESS:	 val = &drive->addressing;	goto read_val;
+	case HDIO_GET_MULTCOUNT: val = &drive->mult_count;	goto read_val;
+	case HDIO_GET_NOWERR:	 val = &drive->nowerr;		goto read_val;
+	case HDIO_GET_WCACHE:	 val = &drive->wcache;		goto read_val;
+	case HDIO_GET_ACOUSTIC:	 val = &drive->acoustic;	goto read_val;
+	case HDIO_SET_ADDRESS:	 setfunc = set_lba_addressing;	goto set_val;
+	case HDIO_SET_MULTCOUNT: setfunc = set_multcount;	goto set_val;
+	case HDIO_SET_NOWERR:	 setfunc = set_nowerr;		goto set_val;
+	case HDIO_SET_WCACHE:	 setfunc = write_cache;		goto set_val;
+	case HDIO_SET_ACOUSTIC:	 setfunc = set_acoustic;	goto set_val;
+	}
+
+	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+read_val:
+	down(&ide_setting_sem);
+	spin_lock_irqsave(&ide_lock, flags);
+	err = *val;
+	spin_unlock_irqrestore(&ide_lock, flags);
+	up(&ide_setting_sem);
+	return err >= 0 ? put_user(err, (long __user *)arg) : err;
+
+set_val:
+	if (bdev != bdev->bd_contains)
+		err = -EINVAL;
+	else {
+		if (!capable(CAP_SYS_ADMIN))
+			err = -EACCES;
+		else {
+			down(&ide_setting_sem);
+			err = setfunc(drive, arg);
+			up(&ide_setting_sem);
+		}
+	}
+	return err;
 }
 
 static int idedisk_media_changed(struct gendisk *disk)
@@ -1202,7 +1257,7 @@ static int ide_disk_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_register_subdriver(drive, &idedisk_driver);
+	ide_proc_register_driver(drive, &idedisk_driver);
 
 	kref_init(&idkp->kref);
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index fd21308..5fe8519 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -705,6 +705,100 @@ int ide_use_dma(ide_drive_t *drive)
 
 EXPORT_SYMBOL_GPL(ide_use_dma);
 
+static const u8 xfer_mode_bases[] = {
+	XFER_UDMA_0,
+	XFER_MW_DMA_0,
+	XFER_SW_DMA_0,
+};
+
+static unsigned int ide_get_mode_mask(ide_drive_t *drive, u8 base)
+{
+	struct hd_driveid *id = drive->id;
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned int mask = 0;
+
+	switch(base) {
+	case XFER_UDMA_0:
+		if ((id->field_valid & 4) == 0)
+			break;
+
+		mask = id->dma_ultra & hwif->ultra_mask;
+
+		if (hwif->udma_filter)
+			mask &= hwif->udma_filter(drive);
+
+		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
+			mask &= 0x07;
+		break;
+	case XFER_MW_DMA_0:
+		mask = id->dma_mword & hwif->mwdma_mask;
+		break;
+	case XFER_SW_DMA_0:
+		mask = id->dma_1word & hwif->swdma_mask;
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	return mask;
+}
+
+/**
+ *	ide_max_dma_mode	-	compute DMA speed
+ *	@drive: IDE device
+ *
+ *	Checks the drive capabilities and returns the speed to use
+ *	for the DMA transfer.  Returns 0 if the drive is incapable
+ *	of DMA transfers.
+ */
+
+u8 ide_max_dma_mode(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned int mask;
+	int x, i;
+	u8 mode = 0;
+
+	if (drive->media != ide_disk && hwif->atapi_dma == 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(xfer_mode_bases); i++) {
+		mask = ide_get_mode_mask(drive, xfer_mode_bases[i]);
+		x = fls(mask) - 1;
+		if (x >= 0) {
+			mode = xfer_mode_bases[i] + x;
+			break;
+		}
+	}
+
+	printk(KERN_DEBUG "%s: selected mode 0x%x\n", drive->name, mode);
+
+	return mode;
+}
+
+EXPORT_SYMBOL_GPL(ide_max_dma_mode);
+
+int ide_tune_dma(ide_drive_t *drive)
+{
+	u8 speed;
+
+	/* TODO: use only ide_max_dma_mode() */
+	if (!ide_use_dma(drive))
+		return 0;
+
+	speed = ide_max_dma_mode(drive);
+
+	if (!speed)
+		return 0;
+
+	drive->hwif->speedproc(drive, speed);
+
+	return ide_dma_enable(drive);
+}
+
+EXPORT_SYMBOL_GPL(ide_tune_dma);
+
 void ide_dma_verbose(ide_drive_t *drive)
 {
 	struct hd_driveid *id	= drive->id;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 57cd21c..f429be8 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1811,18 +1811,22 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	return 0;
 }
 
+#ifdef CONFIG_IDE_PROC_FS
 static void idefloppy_add_settings(ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 /*
- *			drive	setting name	read/write	ioctl	ioctl		data type	min	max	mul_factor	div_factor	data pointer		set function
+ *			drive	setting name	read/write	data type	min	max	mul_factor	div_factor	data pointer		set function
  */
-	ide_add_setting(drive,	"bios_cyl",		SETTING_RW,					-1,			-1,			TYPE_INT,	0,	1023,				1,	1,	&drive->bios_cyl,		NULL);
-	ide_add_setting(drive,	"bios_head",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	255,				1,	1,	&drive->bios_head,		NULL);
-	ide_add_setting(drive,	"bios_sect",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	63,				1,	1,	&drive->bios_sect,		NULL);
-	ide_add_setting(drive,	"ticks",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	255,				1,	1,	&floppy->ticks,		NULL);
+	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	1023,		1,		1,	&drive->bios_cyl,	NULL);
+	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,		1,		1,	&drive->bios_head,	NULL);
+	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,		1,		1,	&drive->bios_sect,	NULL);
+	ide_add_setting(drive,	"ticks",	SETTING_RW,	TYPE_BYTE,	0,	255,		1,		1,	&floppy->ticks,		NULL);
 }
+#else
+static inline void idefloppy_add_settings(ide_drive_t *drive) { ; }
+#endif
 
 /*
  *	Driver initialization.
@@ -1873,7 +1877,7 @@ static void ide_floppy_remove(ide_drive_t *drive)
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct gendisk *g = floppy->disk;
 
-	ide_unregister_subdriver(drive, floppy->driver);
+	ide_proc_unregister_driver(drive, floppy->driver);
 
 	del_gendisk(g);
 
@@ -1892,8 +1896,7 @@ static void ide_floppy_release(struct kref *kref)
 	kfree(floppy);
 }
 
-#ifdef CONFIG_PROC_FS
-
+#ifdef CONFIG_IDE_PROC_FS
 static int proc_idefloppy_read_capacity
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
@@ -1909,12 +1912,7 @@ static ide_proc_entry_t idefloppy_proc[] = {
 	{ "geometry",	S_IFREG|S_IRUGO,	proc_ide_read_geometry,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
-
-#else
-
-#define	idefloppy_proc	NULL
-
-#endif	/* CONFIG_PROC_FS */
+#endif	/* CONFIG_IDE_PROC_FS */
 
 static int ide_floppy_probe(ide_drive_t *);
 
@@ -1933,7 +1931,9 @@ static ide_driver_t idefloppy_driver = {
 	.end_request		= idefloppy_do_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
+#ifdef CONFIG_IDE_PROC_FS
 	.proc			= idefloppy_proc,
+#endif
 };
 
 static int idefloppy_open(struct inode *inode, struct file *filp)
@@ -2159,7 +2159,7 @@ static int ide_floppy_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_register_subdriver(drive, &idefloppy_driver);
+	ide_proc_register_driver(drive, &idefloppy_driver);
 
 	kref_init(&floppy->kref);
 
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 99fd561..0f72b98 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -22,8 +22,6 @@ static int __init ide_generic_init(void)
 	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
 		ide_release_lock();	/* for atari only */
 
-	create_proc_ide_interfaces();
-
 	return 0;
 }
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 8670112..8e56814 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -172,15 +172,6 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 
 	memset(args, 0, sizeof(*args));
 
-	if (drive->media != ide_disk) {
-		/*
-		 * skip idedisk_pm_restore_pio and idedisk_pm_idle for ATAPI
-		 * devices
-		 */
-		if (pm->pm_step == idedisk_pm_restore_pio)
-			pm->pm_step = ide_pm_restore_dma;
-	}
-
 	switch (pm->pm_step) {
 	case ide_pm_flush_cache:	/* Suspend step 1 (flush cache) */
 		if (drive->media != ide_disk)
@@ -207,7 +198,13 @@ static ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *
 	case idedisk_pm_restore_pio:	/* Resume step 1 (restore PIO) */
 		if (drive->hwif->tuneproc != NULL)
 			drive->hwif->tuneproc(drive, 255);
-		ide_complete_power_step(drive, rq, 0, 0);
+		/*
+		 * skip idedisk_pm_idle for ATAPI devices
+		 */
+		if (drive->media != ide_disk)
+			pm->pm_step = ide_pm_restore_dma;
+		else
+			ide_complete_power_step(drive, rq, 0, 0);
 		return ide_stopped;
 
 	case idedisk_pm_idle:		/* Resume step 2 (idle) */
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 3caa176..f0be5f6 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -571,51 +571,54 @@ EXPORT_SYMBOL(ide_wait_stat);
  */
 u8 eighty_ninty_three (ide_drive_t *drive)
 {
-	if(HWIF(drive)->udma_four == 0)
-		return 0;
+	ide_hwif_t *hwif = drive->hwif;
+	struct hd_driveid *id = drive->id;
+
+	if (hwif->udma_four == 0)
+		goto no_80w;
 
 	/* Check for SATA but only if we are ATA5 or higher */
-	if (drive->id->hw_config == 0 && (drive->id->major_rev_num & 0x7FE0))
+	if (id->hw_config == 0 && (id->major_rev_num & 0x7FE0))
 		return 1;
-	if (!(drive->id->hw_config & 0x6000))
-		return 0;
-#ifndef CONFIG_IDEDMA_IVB
-	if(!(drive->id->hw_config & 0x4000))
-		return 0;
-#endif /* CONFIG_IDEDMA_IVB */
+
 	/*
 	 * FIXME:
 	 * - change master/slave IDENTIFY order
 	 * - force bit13 (80c cable present) check
 	 *   (unless the slave device is pre-ATA3)
 	 */
-	return 1;
-}
+#ifndef CONFIG_IDEDMA_IVB
+	if (id->hw_config & 0x4000)
+#else
+	if (id->hw_config & 0x6000)
+#endif
+		return 1;
+
+no_80w:
+	if (drive->udma33_warned == 1)
+		return 0;
 
-EXPORT_SYMBOL(eighty_ninty_three);
+	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
+			    "limiting max speed to UDMA33\n",
+			    drive->name, hwif->udma_four ? "drive" : "host");
+
+	drive->udma33_warned = 1;
+
+	return 0;
+}
 
 int ide_ata66_check (ide_drive_t *drive, ide_task_t *args)
 {
 	if ((args->tfRegister[IDE_COMMAND_OFFSET] == WIN_SETFEATURES) &&
 	    (args->tfRegister[IDE_SECTOR_OFFSET] > XFER_UDMA_2) &&
 	    (args->tfRegister[IDE_FEATURE_OFFSET] == SETFEATURES_XFER)) {
-#ifndef CONFIG_IDEDMA_IVB
-		if ((drive->id->hw_config & 0x6000) == 0) {
-#else /* !CONFIG_IDEDMA_IVB */
-		if (((drive->id->hw_config & 0x2000) == 0) ||
-		    ((drive->id->hw_config & 0x4000) == 0)) {
-#endif /* CONFIG_IDEDMA_IVB */
-			printk("%s: Speed warnings UDMA 3/4/5 is not "
-				"functional.\n", drive->name);
-			return 1;
-		}
-		if (!HWIF(drive)->udma_four) {
-			printk("%s: Speed warnings UDMA 3/4/5 is not "
-				"functional.\n",
-				HWIF(drive)->name);
+		if (eighty_ninty_three(drive) == 0) {
+			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
+					    "be set\n", drive->name);
 			return 1;
 		}
 	}
+
 	return 0;
 }
 
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 6871931..3be3c69 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -69,123 +69,41 @@ char *ide_xfer_verbose (u8 xfer_rate)
 EXPORT_SYMBOL(ide_xfer_verbose);
 
 /**
- *	ide_dma_speed	-	compute DMA speed
- *	@drive: drive
- *	@mode:	modes available
- *
- *	Checks the drive capabilities and returns the speed to use
- *	for the DMA transfer.  Returns 0 if the drive is incapable
- *	of DMA transfers.
- */
- 
-u8 ide_dma_speed(ide_drive_t *drive, u8 mode)
-{
-	struct hd_driveid *id   = drive->id;
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 ultra_mask, mwdma_mask, swdma_mask;
-	u8 speed = 0;
-
-	if (drive->media != ide_disk && hwif->atapi_dma == 0)
-		return 0;
-
-	/* Capable of UltraDMA modes? */
-	ultra_mask = id->dma_ultra & hwif->ultra_mask;
-
-	if (!(id->field_valid & 4))
-		mode = 0;	/* fallback to MW/SW DMA if no UltraDMA */
-
-	switch (mode) {
-	case 4:
-		if (ultra_mask & 0x40) {
-			speed = XFER_UDMA_6;
-			break;
-		}
-	case 3:
-		if (ultra_mask & 0x20) {
-			speed = XFER_UDMA_5;
-			break;
-		}
-	case 2:
-		if (ultra_mask & 0x10) {
-			speed = XFER_UDMA_4;
-			break;
-		}
-		if (ultra_mask & 0x08) {
-			speed = XFER_UDMA_3;
-			break;
-		}
-	case 1:
-		if (ultra_mask & 0x04) {
-			speed = XFER_UDMA_2;
-			break;
-		}
-		if (ultra_mask & 0x02) {
-			speed = XFER_UDMA_1;
-			break;
-		}
-		if (ultra_mask & 0x01) {
-			speed = XFER_UDMA_0;
-			break;
-		}
-	case 0:
-		mwdma_mask = id->dma_mword & hwif->mwdma_mask;
-
-		if (mwdma_mask & 0x04) {
-			speed = XFER_MW_DMA_2;
-			break;
-		}
-		if (mwdma_mask & 0x02) {
-			speed = XFER_MW_DMA_1;
-			break;
-		}
-		if (mwdma_mask & 0x01) {
-			speed = XFER_MW_DMA_0;
-			break;
-		}
-
-		swdma_mask = id->dma_1word & hwif->swdma_mask;
-
-		if (swdma_mask & 0x04) {
-			speed = XFER_SW_DMA_2;
-			break;
-		}
-		if (swdma_mask & 0x02) {
-			speed = XFER_SW_DMA_1;
-			break;
-		}
-		if (swdma_mask & 0x01) {
-			speed = XFER_SW_DMA_0;
-			break;
-		}
-	}
-
-	return speed;
-}
-EXPORT_SYMBOL(ide_dma_speed);
-
-
-/**
- *	ide_rate_filter		-	return best speed for mode
- *	@mode: modes available
+ *	ide_rate_filter		-	filter transfer mode
+ *	@drive: IDE device
  *	@speed: desired speed
  *
- *	Given the available DMA/UDMA mode this function returns
+ *	Given the available transfer modes this function returns
  *	the best available speed at or below the speed requested.
+ *
+ *	FIXME: filter also PIO/SWDMA/MWDMA modes
  */
 
-u8 ide_rate_filter (u8 mode, u8 speed) 
+u8 ide_rate_filter(ide_drive_t *drive, u8 speed)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	static u8 speed_max[] = {
-		XFER_MW_DMA_2, XFER_UDMA_2, XFER_UDMA_4,
-		XFER_UDMA_5, XFER_UDMA_6
-	};
+	ide_hwif_t *hwif = drive->hwif;
+	u8 mask = hwif->ultra_mask, mode = XFER_MW_DMA_2;
+
+	if (hwif->udma_filter)
+		mask = hwif->udma_filter(drive);
+
+	/*
+	 * TODO: speed > XFER_UDMA_2 extra check is needed to avoid false
+	 * cable warning from eighty_ninty_three(), moving ide_rate_filter()
+	 * calls from ->speedproc to core code will make this hack go away
+	 */
+	if (speed > XFER_UDMA_2) {
+		if ((mask & 0x78) && (eighty_ninty_three(drive) == 0))
+			mask &= 0x07;
+	}
+
+	if (mask)
+		mode = fls(mask) - 1 + XFER_UDMA_0;
 
 //	printk("%s: mode 0x%02x, speed 0x%02x\n", __FUNCTION__, mode, speed);
 
-	/* So that we remember to update this if new modes appear */
-	BUG_ON(mode > 4);
-	return min(speed, speed_max[mode]);
+	return min(speed, mode);
 #else /* !CONFIG_BLK_DEV_IDEDMA */
 	return min(speed, (u8)XFER_PIO_4);
 #endif /* CONFIG_BLK_DEV_IDEDMA */
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index 98410ca..2b8009c 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -42,7 +42,7 @@ static int idepnp_probe(struct pnp_dev * dev, const struct pnp_device_id *dev_id
 	hw.irq = pnp_irq(dev, 0);
 	hw.dma = NO_DMA;
 
-	index = ide_register_hw(&hw, &hwif);
+	index = ide_register_hw(&hw, 1, &hwif);
 
 	if (index != -1) {
 	    	printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 8f15c23..3cebed7 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1427,6 +1427,9 @@ int ideprobe_init (void)
 				}
 		}
 	}
+	for (index = 0; index < MAX_HWIFS; ++index)
+		if (probe[index])
+			ide_proc_register_port(&ide_hwifs[index]);
 	return 0;
 }
 
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index a9e0b30..d50bd99 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -3,6 +3,8 @@
  *
  *  Copyright (C) 1997-1998	Mark Lord
  *  Copyright (C) 2003		Red Hat <alan@redhat.com>
+ *
+ *  Some code was moved here from ide.c, see it for original copyrights.
  */
 
 /*
@@ -37,6 +39,8 @@
 
 #include <asm/io.h>
 
+static struct proc_dir_entry *proc_ide_root;
+
 static int proc_ide_read_imodel
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
@@ -121,6 +125,265 @@ static int proc_ide_read_identify
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
+/**
+ *	__ide_add_setting	-	add an ide setting option
+ *	@drive: drive to use
+ *	@name: setting name
+ *	@rw: true if the function is read write
+ *	@data_type: type of data
+ *	@min: range minimum
+ *	@max: range maximum
+ *	@mul_factor: multiplication scale
+ *	@div_factor: divison scale
+ *	@data: private data field
+ *	@set: setting
+ *	@auto_remove: setting auto removal flag
+ *
+ *	Removes the setting named from the device if it is present.
+ *	The function takes the settings_lock to protect against
+ *	parallel changes. This function must not be called from IRQ
+ *	context. Returns 0 on success or -1 on failure.
+ *
+ *	BUGS: This code is seriously over-engineered. There is also
+ *	magic about how the driver specific features are setup. If
+ *	a driver is attached we assume the driver settings are auto
+ *	remove.
+ */
+
+static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set, int auto_remove)
+{
+	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
+
+	down(&ide_setting_sem);
+	while ((*p) && strcmp((*p)->name, name) < 0)
+		p = &((*p)->next);
+	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
+		goto abort;
+	if ((setting->name = kmalloc(strlen(name) + 1, GFP_KERNEL)) == NULL)
+		goto abort;
+	strcpy(setting->name, name);
+	setting->rw = rw;
+	setting->data_type = data_type;
+	setting->min = min;
+	setting->max = max;
+	setting->mul_factor = mul_factor;
+	setting->div_factor = div_factor;
+	setting->data = data;
+	setting->set = set;
+
+	setting->next = *p;
+	if (auto_remove)
+		setting->auto_remove = 1;
+	*p = setting;
+	up(&ide_setting_sem);
+	return 0;
+abort:
+	up(&ide_setting_sem);
+	kfree(setting);
+	return -1;
+}
+
+int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set)
+{
+	return __ide_add_setting(drive, name, rw, data_type, min, max, mul_factor, div_factor, data, set, 1);
+}
+
+EXPORT_SYMBOL(ide_add_setting);
+
+/**
+ *	__ide_remove_setting	-	remove an ide setting option
+ *	@drive: drive to use
+ *	@name: setting name
+ *
+ *	Removes the setting named from the device if it is present.
+ *	The caller must hold the setting semaphore.
+ */
+
+static void __ide_remove_setting (ide_drive_t *drive, char *name)
+{
+	ide_settings_t **p, *setting;
+
+	p = (ide_settings_t **) &drive->settings;
+
+	while ((*p) && strcmp((*p)->name, name))
+		p = &((*p)->next);
+	if ((setting = (*p)) == NULL)
+		return;
+
+	(*p) = setting->next;
+
+	kfree(setting->name);
+	kfree(setting);
+}
+
+/**
+ *	auto_remove_settings	-	remove driver specific settings
+ *	@drive: drive
+ *
+ *	Automatically remove all the driver specific settings for this
+ *	drive. This function may not be called from IRQ context. The
+ *	caller must hold ide_setting_sem.
+ */
+
+static void auto_remove_settings (ide_drive_t *drive)
+{
+	ide_settings_t *setting;
+repeat:
+	setting = drive->settings;
+	while (setting) {
+		if (setting->auto_remove) {
+			__ide_remove_setting(drive, setting->name);
+			goto repeat;
+		}
+		setting = setting->next;
+	}
+}
+
+/**
+ *	ide_find_setting_by_name	-	find a drive specific setting
+ *	@drive: drive to scan
+ *	@name: setting name
+ *
+ *	Scan's the device setting table for a matching entry and returns
+ *	this or NULL if no entry is found. The caller must hold the
+ *	setting semaphore
+ */
+
+static ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name)
+{
+	ide_settings_t *setting = drive->settings;
+
+	while (setting) {
+		if (strcmp(setting->name, name) == 0)
+			break;
+		setting = setting->next;
+	}
+	return setting;
+}
+
+/**
+ *	ide_read_setting	-	read an IDE setting
+ *	@drive: drive to read from
+ *	@setting: drive setting
+ *
+ *	Read a drive setting and return the value. The caller
+ *	must hold the ide_setting_sem when making this call.
+ *
+ *	BUGS: the data return and error are the same return value
+ *	so an error -EINVAL and true return of the same value cannot
+ *	be told apart
+ */
+
+static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
+{
+	int		val = -EINVAL;
+	unsigned long	flags;
+
+	if ((setting->rw & SETTING_READ)) {
+		spin_lock_irqsave(&ide_lock, flags);
+		switch(setting->data_type) {
+			case TYPE_BYTE:
+				val = *((u8 *) setting->data);
+				break;
+			case TYPE_SHORT:
+				val = *((u16 *) setting->data);
+				break;
+			case TYPE_INT:
+				val = *((u32 *) setting->data);
+				break;
+		}
+		spin_unlock_irqrestore(&ide_lock, flags);
+	}
+	return val;
+}
+
+/**
+ *	ide_write_setting	-	read an IDE setting
+ *	@drive: drive to read from
+ *	@setting: drive setting
+ *	@val: value
+ *
+ *	Write a drive setting if it is possible. The caller
+ *	must hold the ide_setting_sem when making this call.
+ *
+ *	BUGS: the data return and error are the same return value
+ *	so an error -EINVAL and true return of the same value cannot
+ *	be told apart
+ *
+ *	FIXME:  This should be changed to enqueue a special request
+ *	to the driver to change settings, and then wait on a sema for completion.
+ *	The current scheme of polling is kludgy, though safe enough.
+ */
+
+static int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int val)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+	if (setting->set)
+		return setting->set(drive, val);
+	if (!(setting->rw & SETTING_WRITE))
+		return -EPERM;
+	if (val < setting->min || val > setting->max)
+		return -EINVAL;
+	if (ide_spin_wait_hwgroup(drive))
+		return -EBUSY;
+	switch (setting->data_type) {
+		case TYPE_BYTE:
+			*((u8 *) setting->data) = val;
+			break;
+		case TYPE_SHORT:
+			*((u16 *) setting->data) = val;
+			break;
+		case TYPE_INT:
+			*((u32 *) setting->data) = val;
+			break;
+	}
+	spin_unlock_irq(&ide_lock);
+	return 0;
+}
+
+static int set_xfer_rate (ide_drive_t *drive, int arg)
+{
+	int err;
+
+	if (arg < 0 || arg > 70)
+		return -EINVAL;
+
+	err = ide_wait_cmd(drive,
+			WIN_SETFEATURES, (u8) arg,
+			SETFEATURES_XFER, 0, NULL);
+
+	if (!err && arg) {
+		ide_set_xfer_rate(drive, (u8) arg);
+		ide_driveid_update(drive);
+	}
+	return err;
+}
+
+/**
+ *	ide_add_generic_settings	-	generic ide settings
+ *	@drive: drive being configured
+ *
+ *	Add the generic parts of the system settings to the /proc files.
+ *	The caller must not be holding the ide_setting_sem.
+ */
+
+void ide_add_generic_settings (ide_drive_t *drive)
+{
+/*
+ *			  drive		setting name		read/write access				data type	min	max				mul_factor	div_factor	data pointer			set function
+ */
+	__ide_add_setting(drive,	"io_32bit",		drive->no_io_32bit ? SETTING_READ : SETTING_RW,	TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
+	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		NULL,		0);
+	__ide_add_setting(drive,	"nice1",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->nice1,			NULL,		0);
+	__ide_add_setting(drive,	"pio_mode",		SETTING_WRITE,					TYPE_BYTE,	0,	255,				1,		1,		NULL,				set_pio_mode,	0);
+	__ide_add_setting(drive,	"unmaskirq",		drive->no_unmask ? SETTING_READ : SETTING_RW,	TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			NULL,		0);
+	__ide_add_setting(drive,	"using_dma",		SETTING_RW,					TYPE_BYTE,	0,	1,				1,		1,		&drive->using_dma,		set_using_dma,	0);
+	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
+	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
+	__ide_add_setting(drive,	"number",		SETTING_RW,					TYPE_BYTE,	0,	3,				1,		1,		&drive->dn,			NULL,		0);
+}
+
 static void proc_ide_settings_warn(void)
 {
 	static int warned = 0;
@@ -399,7 +662,7 @@ static ide_proc_entry_t generic_drive_entries[] = {
 	{ NULL,	0, NULL, NULL }
 };
 
-void ide_add_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p, void *data)
+static void ide_add_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p, void *data)
 {
 	struct proc_dir_entry *ent;
 
@@ -415,7 +678,7 @@ void ide_add_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p, void
 	}
 }
 
-void ide_remove_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p)
+static void ide_remove_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p)
 {
 	if (!dir || !p)
 		return;
@@ -425,6 +688,51 @@ void ide_remove_proc_entries(struct proc_dir_entry *dir, ide_proc_entry_t *p)
 	}
 }
 
+void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver)
+{
+	ide_add_proc_entries(drive->proc, driver->proc, drive);
+}
+
+EXPORT_SYMBOL(ide_proc_register_driver);
+
+/**
+ *	ide_proc_unregister_driver	-	remove driver specific data
+ *	@drive: drive
+ *	@driver: driver
+ *
+ *	Clean up the driver specific /proc files and IDE settings
+ *	for a given drive.
+ *
+ *	Takes ide_setting_sem and ide_lock.
+ *	Caller must hold none of the locks.
+ */
+
+void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver)
+{
+	unsigned long flags;
+
+	ide_remove_proc_entries(drive->proc, driver->proc);
+
+	down(&ide_setting_sem);
+	spin_lock_irqsave(&ide_lock, flags);
+	/*
+	 * ide_setting_sem protects the settings list
+	 * ide_lock protects the use of settings
+	 *
+	 * so we need to hold both, ide_settings_sem because we want to
+	 * modify the settings list, and ide_lock because we cannot take
+	 * a setting out that is being used.
+	 *
+	 * OTOH both ide_{read,write}_setting are only ever used under
+	 * ide_setting_sem.
+	 */
+	auto_remove_settings(drive);
+	spin_unlock_irqrestore(&ide_lock, flags);
+	up(&ide_setting_sem);
+}
+
+EXPORT_SYMBOL(ide_proc_unregister_driver);
+
 static void create_proc_ide_drives(ide_hwif_t *hwif)
 {
 	int	d;
@@ -477,26 +785,24 @@ static ide_proc_entry_t hwif_entries[] = {
 	{ NULL,	0, NULL, NULL }
 };
 
-void create_proc_ide_interfaces(void)
+void ide_proc_register_port(ide_hwif_t *hwif)
 {
-	int	h;
+	if (!hwif->present)
+		return;
 
-	for (h = 0; h < MAX_HWIFS; h++) {
-		ide_hwif_t *hwif = &ide_hwifs[h];
+	if (!hwif->proc) {
+		hwif->proc = proc_mkdir(hwif->name, proc_ide_root);
 
-		if (!hwif->present)
-			continue;
-		if (!hwif->proc) {
-			hwif->proc = proc_mkdir(hwif->name, proc_ide_root);
-			if (!hwif->proc)
-				return;
-			ide_add_proc_entries(hwif->proc, hwif_entries, hwif);
-		}
-		create_proc_ide_drives(hwif);
+		if (!hwif->proc)
+			return;
+
+		ide_add_proc_entries(hwif->proc, hwif_entries, hwif);
 	}
+
+	create_proc_ide_drives(hwif);
 }
 
-EXPORT_SYMBOL(create_proc_ide_interfaces);
+EXPORT_SYMBOL_GPL(ide_proc_register_port);
 
 #ifdef CONFIG_BLK_DEV_IDEPCI
 void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
@@ -507,7 +813,7 @@ void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
 EXPORT_SYMBOL_GPL(ide_pci_create_host_proc);
 #endif
 
-void destroy_proc_ide_interface(ide_hwif_t *hwif)
+void ide_proc_unregister_port(ide_hwif_t *hwif)
 {
 	if (hwif->proc) {
 		destroy_proc_ide_drives(hwif);
@@ -554,11 +860,11 @@ void proc_ide_create(void)
 {
 	struct proc_dir_entry *entry;
 
+	proc_ide_root = proc_mkdir("ide", NULL);
+
 	if (!proc_ide_root)
 		return;
 
-	create_proc_ide_interfaces();
-
 	entry = create_proc_entry("drivers", 0, proc_ide_root);
 	if (entry)
 		entry->proc_fops = &ide_drivers_operations;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 4e59239..e82bfa5 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -4561,28 +4561,33 @@ static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive)
 	printk(KERN_INFO "ide-tape: Adjusted block size - %d\n", tape->tape_block_size);
 #endif /* IDETAPE_DEBUG_INFO */
 }
+
+#ifdef CONFIG_IDE_PROC_FS
 static void idetape_add_settings (ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
 /*
- *			drive	setting name	read/write	ioctl	ioctl		data type	min			max			mul_factor			div_factor			data pointer				set function
+ *			drive	setting name		read/write	data type	min			max			mul_factor			div_factor	data pointer				set function
  */
-	ide_add_setting(drive,	"buffer",	SETTING_READ,	-1,	-1,		TYPE_SHORT,	0,			0xffff,			1,				2,				&tape->capabilities.buffer_size,	NULL);
-	ide_add_setting(drive,	"pipeline_min",	SETTING_RW,	-1,	-1,		TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,				&tape->min_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline",	SETTING_RW,	-1,	-1,		TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,				&tape->max_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_max",	SETTING_RW,	-1,	-1,		TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,				&tape->max_pipeline,			NULL);
-	ide_add_setting(drive,	"pipeline_used",SETTING_READ,	-1,	-1,		TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,				&tape->nr_stages,			NULL);
-	ide_add_setting(drive,	"pipeline_pending",SETTING_READ,-1,	-1,		TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,				&tape->nr_pending_stages,		NULL);
-	ide_add_setting(drive,	"speed",	SETTING_READ,	-1,	-1,		TYPE_SHORT,	0,			0xffff,			1,				1,				&tape->capabilities.speed,		NULL);
-	ide_add_setting(drive,	"stage",	SETTING_READ,	-1,	-1,		TYPE_INT,	0,			0xffff,			1,				1024,				&tape->stage_size,			NULL);
-	ide_add_setting(drive,	"tdsc",		SETTING_RW,	-1,	-1,		TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,				&tape->best_dsc_rw_frequency,		NULL);
-	ide_add_setting(drive,	"dsc_overlap",	SETTING_RW,	-1,	-1,		TYPE_BYTE,	0,			1,			1,				1,				&drive->dsc_overlap,			NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	-1,	-1,	TYPE_INT,	0,			0xffff,			1,				1,				&tape->controlled_pipeline_head_speed,	NULL);
-	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	-1,	-1,	TYPE_INT,	0,			0xffff,			1,				1,				&tape->uncontrolled_pipeline_head_speed,	NULL);
-	ide_add_setting(drive,	"avg_speed",	SETTING_READ,	-1,	-1,		TYPE_INT,	0,			0xffff,			1,				1,				&tape->avg_speed,		NULL);
-	ide_add_setting(drive,	"debug_level",SETTING_RW,	-1,	-1,		TYPE_INT,	0,			0xffff,			1,				1,				&tape->debug_level,		NULL);
+	ide_add_setting(drive,	"buffer",		SETTING_READ,	TYPE_SHORT,	0,			0xffff,			1,				2,		&tape->capabilities.buffer_size,	NULL);
+	ide_add_setting(drive,	"pipeline_min",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->min_pipeline,			NULL);
+	ide_add_setting(drive,	"pipeline",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_stages,			NULL);
+	ide_add_setting(drive,	"pipeline_max",		SETTING_RW,	TYPE_INT,	1,			0xffff,			tape->stage_size / 1024,	1,		&tape->max_pipeline,			NULL);
+	ide_add_setting(drive,	"pipeline_used",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_stages,			NULL);
+	ide_add_setting(drive,	"pipeline_pending",	SETTING_READ,	TYPE_INT,	0,			0xffff,			tape->stage_size / 1024,	1,		&tape->nr_pending_stages,		NULL);
+	ide_add_setting(drive,	"speed",		SETTING_READ,	TYPE_SHORT,	0,			0xffff,			1,				1,		&tape->capabilities.speed,		NULL);
+	ide_add_setting(drive,	"stage",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1024,		&tape->stage_size,			NULL);
+	ide_add_setting(drive,	"tdsc",			SETTING_RW,	TYPE_INT,	IDETAPE_DSC_RW_MIN,	IDETAPE_DSC_RW_MAX,	1000,				HZ,		&tape->best_dsc_rw_frequency,		NULL);
+	ide_add_setting(drive,	"dsc_overlap",		SETTING_RW,	TYPE_BYTE,	0,			1,			1,				1,		&drive->dsc_overlap,			NULL);
+	ide_add_setting(drive,	"pipeline_head_speed_c",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->controlled_pipeline_head_speed,	NULL);
+	ide_add_setting(drive,	"pipeline_head_speed_u",SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->uncontrolled_pipeline_head_speed,NULL);
+	ide_add_setting(drive,	"avg_speed",		SETTING_READ,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->avg_speed,			NULL);
+	ide_add_setting(drive,	"debug_level",		SETTING_RW,	TYPE_INT,	0,			0xffff,			1,				1,		&tape->debug_level,			NULL);
 }
+#else
+static inline void idetape_add_settings(ide_drive_t *drive) { ; }
+#endif
 
 /*
  *	ide_setup is called to:
@@ -4703,7 +4708,7 @@ static void ide_tape_remove(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	ide_unregister_subdriver(drive, tape->driver);
+	ide_proc_unregister_driver(drive, tape->driver);
 
 	ide_unregister_region(tape->disk);
 
@@ -4730,8 +4735,7 @@ static void ide_tape_release(struct kref *kref)
 	kfree(tape);
 }
 
-#ifdef CONFIG_PROC_FS
-
+#ifdef CONFIG_IDE_PROC_FS
 static int proc_idetape_read_name
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
@@ -4749,11 +4753,6 @@ static ide_proc_entry_t idetape_proc[] = {
 	{ "name",	S_IFREG|S_IRUGO,	proc_idetape_read_name,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
-
-#else
-
-#define	idetape_proc	NULL
-
 #endif
 
 static int ide_tape_probe(ide_drive_t *);
@@ -4773,7 +4772,9 @@ static ide_driver_t idetape_driver = {
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
+#ifdef CONFIG_IDE_PROC_FS
 	.proc			= idetape_proc,
+#endif
 };
 
 /*
@@ -4864,7 +4865,7 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	ide_init_disk(g, drive);
 
-	ide_register_subdriver(drive, &idetape_driver);
+	ide_proc_register_driver(drive, &idetape_driver);
 
 	kref_init(&tape->kref);
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index ae5bf2b..f2b547f 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -168,12 +168,11 @@ static const u8 ide_hwif_to_major[] = { IDE0_MAJOR, IDE1_MAJOR,
 
 static int idebus_parameter;	/* holds the "idebus=" parameter */
 static int system_bus_speed;	/* holds what we think is VESA/PCI bus speed */
-static int initializing;	/* set while initializing built-in drivers */
 
 DECLARE_MUTEX(ide_cfg_sem);
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
-#ifdef CONFIG_BLK_DEV_IDEPCI
+#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
 static int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
 #endif
 
@@ -216,9 +215,6 @@ static void init_hwif_data(ide_hwif_t *hwif, unsigned int index)
 	hwif->bus_state	= BUSSTATE_ON;
 
 	hwif->atapi_dma = 0;		/* disable all atapi dma */ 
-	hwif->ultra_mask = 0x80;	/* disable all ultra */
-	hwif->mwdma_mask = 0x80;	/* disable all mwdma */
-	hwif->swdma_mask = 0x80;	/* disable all swdma */
 
 	init_completion(&hwif->gendev_rel_comp);
 
@@ -305,9 +301,7 @@ static void __init init_ide_data (void)
 #endif
 	}
 #ifdef CONFIG_IDE_ARM
-	initializing = 1;
 	ide_arm_init();
-	initializing = 0;
 #endif
 }
 
@@ -353,10 +347,6 @@ static int ide_system_bus_speed(void)
 	return system_bus_speed;
 }
 
-#ifdef CONFIG_PROC_FS
-struct proc_dir_entry *proc_ide_root;
-#endif
-
 static struct resource* hwif_request_region(ide_hwif_t *hwif,
 					    unsigned long addr, int num)
 {
@@ -480,6 +470,7 @@ static void ide_hwif_restore(ide_hwif_t *hwif, ide_hwif_t *tmp_hwif)
 
 	hwif->tuneproc			= tmp_hwif->tuneproc;
 	hwif->speedproc			= tmp_hwif->speedproc;
+	hwif->udma_filter		= tmp_hwif->udma_filter;
 	hwif->selectproc		= tmp_hwif->selectproc;
 	hwif->reset_poll		= tmp_hwif->reset_poll;
 	hwif->pre_reset			= tmp_hwif->pre_reset;
@@ -599,7 +590,7 @@ void ide_unregister(unsigned int index)
 
 	spin_unlock_irq(&ide_lock);
 
-	destroy_proc_ide_interface(hwif);
+	ide_proc_unregister_port(hwif);
 
 	hwgroup = hwif->hwgroup;
 	/*
@@ -751,6 +742,7 @@ void ide_setup_ports (	hw_regs_t *hw,
 /**
  *	ide_register_hw_with_fixup	-	register IDE interface
  *	@hw: hardware registers
+ *	@initializing: set while initializing built-in drivers
  *	@hwifp: pointer to returned hwif
  *	@fixup: fixup function
  *
@@ -760,7 +752,9 @@ void ide_setup_ports (	hw_regs_t *hw,
  *	Returns -1 on error.
  */
 
-int ide_register_hw_with_fixup(hw_regs_t *hw, ide_hwif_t **hwifp, void(*fixup)(ide_hwif_t *hwif))
+int ide_register_hw_with_fixup(hw_regs_t *hw, int initializing,
+			       ide_hwif_t **hwifp,
+			       void(*fixup)(ide_hwif_t *hwif))
 {
 	int index, retry = 1;
 	ide_hwif_t *hwif;
@@ -801,7 +795,7 @@ found:
 
 	if (!initializing) {
 		probe_hwif_init_with_fixup(hwif, fixup);
-		create_proc_ide_interfaces();
+		ide_proc_register_port(hwif);
 	}
 
 	if (hwifp)
@@ -812,9 +806,9 @@ found:
 
 EXPORT_SYMBOL(ide_register_hw_with_fixup);
 
-int ide_register_hw(hw_regs_t *hw, ide_hwif_t **hwifp)
+int ide_register_hw(hw_regs_t *hw, int initializing, ide_hwif_t **hwifp)
 {
-	return ide_register_hw_with_fixup(hw, hwifp, NULL);
+	return ide_register_hw_with_fixup(hw, initializing, hwifp, NULL);
 }
 
 EXPORT_SYMBOL(ide_register_hw);
@@ -825,205 +819,7 @@ EXPORT_SYMBOL(ide_register_hw);
 
 DECLARE_MUTEX(ide_setting_sem);
 
-/**
- *	__ide_add_setting	-	add an ide setting option
- *	@drive: drive to use
- *	@name: setting name
- *	@rw: true if the function is read write
- *	@read_ioctl: function to call on read
- *	@write_ioctl: function to call on write
- *	@data_type: type of data
- *	@min: range minimum
- *	@max: range maximum
- *	@mul_factor: multiplication scale
- *	@div_factor: divison scale
- *	@data: private data field
- *	@set: setting
- *	@auto_remove: setting auto removal flag
- *
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
-static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int read_ioctl, int write_ioctl, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set, int auto_remove)
-{
-	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
-
-	down(&ide_setting_sem);
-	while ((*p) && strcmp((*p)->name, name) < 0)
-		p = &((*p)->next);
-	if ((setting = kzalloc(sizeof(*setting), GFP_KERNEL)) == NULL)
-		goto abort;
-	if ((setting->name = kmalloc(strlen(name) + 1, GFP_KERNEL)) == NULL)
-		goto abort;
-	strcpy(setting->name, name);
-	setting->rw = rw;
-	setting->read_ioctl = read_ioctl;
-	setting->write_ioctl = write_ioctl;
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
-	up(&ide_setting_sem);
-	return 0;
-abort:
-	up(&ide_setting_sem);
-	kfree(setting);
-	return -1;
-}
-
-int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int read_ioctl, int write_ioctl, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set)
-{
-	return __ide_add_setting(drive, name, rw, read_ioctl, write_ioctl, data_type, min, max, mul_factor, div_factor, data, set, 1);
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
-static void __ide_remove_setting (ide_drive_t *drive, char *name)
-{
-	ide_settings_t **p, *setting;
-
-	p = (ide_settings_t **) &drive->settings;
-
-	while ((*p) && strcmp((*p)->name, name))
-		p = &((*p)->next);
-	if ((setting = (*p)) == NULL)
-		return;
-
-	(*p) = setting->next;
-	
-	kfree(setting->name);
-	kfree(setting);
-}
-
-/**
- *	ide_find_setting_by_ioctl	-	find a drive specific ioctl
- *	@drive: drive to scan
- *	@cmd: ioctl command to handle
- *
- *	Scan's the device setting table for a matching entry and returns
- *	this or NULL if no entry is found. The caller must hold the
- *	setting semaphore
- */
- 
-static ide_settings_t *ide_find_setting_by_ioctl (ide_drive_t *drive, int cmd)
-{
-	ide_settings_t *setting = drive->settings;
-
-	while (setting) {
-		if (setting->read_ioctl == cmd || setting->write_ioctl == cmd)
-			break;
-		setting = setting->next;
-	}
-	
-	return setting;
-}
-
-/**
- *	ide_find_setting_by_name	-	find a drive specific setting
- *	@drive: drive to scan
- *	@name: setting name
- *
- *	Scan's the device setting table for a matching entry and returns
- *	this or NULL if no entry is found. The caller must hold the
- *	setting semaphore
- */
- 
-ide_settings_t *ide_find_setting_by_name (ide_drive_t *drive, char *name)
-{
-	ide_settings_t *setting = drive->settings;
-
-	while (setting) {
-		if (strcmp(setting->name, name) == 0)
-			break;
-		setting = setting->next;
-	}
-	return setting;
-}
-
-/**
- *	auto_remove_settings	-	remove driver specific settings
- *	@drive: drive
- *
- *	Automatically remove all the driver specific settings for this
- *	drive. This function may not be called from IRQ context. The
- *	caller must hold ide_setting_sem.
- */
- 
-static void auto_remove_settings (ide_drive_t *drive)
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
- *	ide_read_setting	-	read an IDE setting
- *	@drive: drive to read from
- *	@setting: drive setting
- *
- *	Read a drive setting and return the value. The caller
- *	must hold the ide_setting_sem when making this call.
- *
- *	BUGS: the data return and error are the same return value
- *	so an error -EINVAL and true return of the same value cannot
- *	be told apart
- */
- 
-int ide_read_setting (ide_drive_t *drive, ide_settings_t *setting)
-{
-	int		val = -EINVAL;
-	unsigned long	flags;
-
-	if ((setting->rw & SETTING_READ)) {
-		spin_lock_irqsave(&ide_lock, flags);
-		switch(setting->data_type) {
-			case TYPE_BYTE:
-				val = *((u8 *) setting->data);
-				break;
-			case TYPE_SHORT:
-				val = *((u16 *) setting->data);
-				break;
-			case TYPE_INT:
-			case TYPE_INTA:
-				val = *((u32 *) setting->data);
-				break;
-		}
-		spin_unlock_irqrestore(&ide_lock, flags);
-	}
-	return val;
-}
+EXPORT_SYMBOL_GPL(ide_setting_sem);
 
 /**
  *	ide_spin_wait_hwgroup	-	wait for group
@@ -1058,61 +854,14 @@ int ide_spin_wait_hwgroup (ide_drive_t *drive)
 
 EXPORT_SYMBOL(ide_spin_wait_hwgroup);
 
-/**
- *	ide_write_setting	-	read an IDE setting
- *	@drive: drive to read from
- *	@setting: drive setting
- *	@val: value
- *
- *	Write a drive setting if it is possible. The caller
- *	must hold the ide_setting_sem when making this call.
- *
- *	BUGS: the data return and error are the same return value
- *	so an error -EINVAL and true return of the same value cannot
- *	be told apart
- *
- *	FIXME:  This should be changed to enqueue a special request
- *	to the driver to change settings, and then wait on a sema for completion.
- *	The current scheme of polling is kludgy, though safe enough.
- */
-
-int ide_write_setting (ide_drive_t *drive, ide_settings_t *setting, int val)
+int set_io_32bit(ide_drive_t *drive, int arg)
 {
-	int i;
-	u32 *p;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (!(setting->rw & SETTING_WRITE))
+	if (drive->no_io_32bit)
 		return -EPERM;
-	if (val < setting->min || val > setting->max)
+
+	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
 		return -EINVAL;
-	if (setting->set)
-		return setting->set(drive, val);
-	if (ide_spin_wait_hwgroup(drive))
-		return -EBUSY;
-	switch (setting->data_type) {
-		case TYPE_BYTE:
-			*((u8 *) setting->data) = val;
-			break;
-		case TYPE_SHORT:
-			*((u16 *) setting->data) = val;
-			break;
-		case TYPE_INT:
-			*((u32 *) setting->data) = val;
-			break;
-		case TYPE_INTA:
-			p = (u32 *) setting->data;
-			for (i = 0; i < 1 << PARTN_BITS; i++, p++)
-				*p = val;
-			break;
-	}
-	spin_unlock_irq(&ide_lock);
-	return 0;
-}
 
-static int set_io_32bit(ide_drive_t *drive, int arg)
-{
 	drive->io_32bit = arg;
 #ifdef CONFIG_BLK_DEV_DTC2278
 	if (HWIF(drive)->chipset == ide_dtc2278)
@@ -1121,12 +870,28 @@ static int set_io_32bit(ide_drive_t *drive, int arg)
 	return 0;
 }
 
-static int set_using_dma (ide_drive_t *drive, int arg)
+static int set_ksettings(ide_drive_t *drive, int arg)
+{
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (ide_spin_wait_hwgroup(drive))
+		return -EBUSY;
+	drive->keep_settings = arg;
+	spin_unlock_irq(&ide_lock);
+
+	return 0;
+}
+
+int set_using_dma(ide_drive_t *drive, int arg)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	ide_hwif_t *hwif = drive->hwif;
 	int err = -EPERM;
 
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
 	if (!drive->id || !(drive->id->capability & 1))
 		goto out;
 
@@ -1159,14 +924,20 @@ static int set_using_dma (ide_drive_t *drive, int arg)
 out:
 	return err;
 #else
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
 	return -EPERM;
 #endif
 }
 
-static int set_pio_mode (ide_drive_t *drive, int arg)
+int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	struct request rq;
 
+	if (arg < 0 || arg > 255)
+		return -EINVAL;
+
 	if (!HWIF(drive)->tuneproc)
 		return -ENOSYS;
 	if (drive->special.b.set_tune)
@@ -1178,42 +949,20 @@ static int set_pio_mode (ide_drive_t *drive, int arg)
 	return 0;
 }
 
-static int set_xfer_rate (ide_drive_t *drive, int arg)
+static int set_unmaskirq(ide_drive_t *drive, int arg)
 {
-	int err = ide_wait_cmd(drive,
-			WIN_SETFEATURES, (u8) arg,
-			SETFEATURES_XFER, 0, NULL);
+	if (drive->no_unmask)
+		return -EPERM;
 
-	if (!err && arg) {
-		ide_set_xfer_rate(drive, (u8) arg);
-		ide_driveid_update(drive);
-	}
-	return err;
-}
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
 
-/**
- *	ide_add_generic_settings	-	generic ide settings
- *	@drive: drive being configured
- *
- *	Add the generic parts of the system settings to the /proc files and
- *	ioctls for this IDE device. The caller must not be holding the
- *	ide_setting_sem.
- */
+	if (ide_spin_wait_hwgroup(drive))
+		return -EBUSY;
+	drive->unmask = arg;
+	spin_unlock_irq(&ide_lock);
 
-void ide_add_generic_settings (ide_drive_t *drive)
-{
-/*
- *			  drive		setting name		read/write access				read ioctl		write ioctl		data type	min	max				mul_factor	div_factor	data pointer			set function
- */
-	__ide_add_setting(drive,	"io_32bit",		drive->no_io_32bit ? SETTING_READ : SETTING_RW,	HDIO_GET_32BIT,		HDIO_SET_32BIT,		TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
-	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					HDIO_GET_KEEPSETTINGS,	HDIO_SET_KEEPSETTINGS,	TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		NULL,		0);
-	__ide_add_setting(drive,	"nice1",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	1,				1,		1,		&drive->nice1,			NULL,		0);
-	__ide_add_setting(drive,	"pio_mode",		SETTING_WRITE,					-1,			HDIO_SET_PIO_MODE,	TYPE_BYTE,	0,	255,				1,		1,		NULL,				set_pio_mode,	0);
-	__ide_add_setting(drive,	"unmaskirq",		drive->no_unmask ? SETTING_READ : SETTING_RW,	HDIO_GET_UNMASKINTR,	HDIO_SET_UNMASKINTR,	TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			NULL,		0);
-	__ide_add_setting(drive,	"using_dma",		SETTING_RW,					HDIO_GET_DMA,		HDIO_SET_DMA,		TYPE_BYTE,	0,	1,				1,		1,		&drive->using_dma,		set_using_dma,	0);
-	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
-	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
-	__ide_add_setting(drive,	"number",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	3,				1,		1,		&drive->dn,			NULL,		0);
+	return 0;
 }
 
 /**
@@ -1285,27 +1034,23 @@ static int generic_ide_resume(struct device *dev)
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
 			unsigned int cmd, unsigned long arg)
 {
-	ide_settings_t *setting;
+	unsigned long flags;
 	ide_driver_t *drv;
-	int err = 0;
 	void __user *p = (void __user *)arg;
+	int err = 0, (*setfunc)(ide_drive_t *, int);
+	u8 *val;
 
-	down(&ide_setting_sem);
-	if ((setting = ide_find_setting_by_ioctl(drive, cmd)) != NULL) {
-		if (cmd == setting->read_ioctl) {
-			err = ide_read_setting(drive, setting);
-			up(&ide_setting_sem);
-			return err >= 0 ? put_user(err, (long __user *)arg) : err;
-		} else {
-			if (bdev != bdev->bd_contains)
-				err = -EINVAL;
-			else
-				err = ide_write_setting(drive, setting, arg);
-			up(&ide_setting_sem);
-			return err;
-		}
+	switch (cmd) {
+	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
+	case HDIO_GET_KEEPSETTINGS: val = &drive->keep_settings; goto read_val;
+	case HDIO_GET_UNMASKINTR:   val = &drive->unmask;	 goto read_val;
+	case HDIO_GET_DMA:	    val = &drive->using_dma;	 goto read_val;
+	case HDIO_SET_32BIT:	    setfunc = set_io_32bit;	 goto set_val;
+	case HDIO_SET_KEEPSETTINGS: setfunc = set_ksettings;	 goto set_val;
+	case HDIO_SET_PIO_MODE:	    setfunc = set_pio_mode;	 goto set_val;
+	case HDIO_SET_UNMASKINTR:   setfunc = set_unmaskirq;	 goto set_val;
+	case HDIO_SET_DMA:	    setfunc = set_using_dma;	 goto set_val;
 	}
-	up(&ide_setting_sem);
 
 	switch (cmd) {
 		case HDIO_OBSOLETE_IDENTITY:
@@ -1359,7 +1104,7 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 			ide_init_hwif_ports(&hw, (unsigned long) args[0],
 					    (unsigned long) args[1], NULL);
 			hw.irq = args[2];
-			if (ide_register_hw(&hw, NULL) == -1)
+			if (ide_register_hw(&hw, 0, NULL) == -1)
 				return -EIO;
 			return 0;
 		}
@@ -1434,6 +1179,28 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
 		default:
 			return -EINVAL;
 	}
+
+read_val:
+	down(&ide_setting_sem);
+	spin_lock_irqsave(&ide_lock, flags);
+	err = *val;
+	spin_unlock_irqrestore(&ide_lock, flags);
+	up(&ide_setting_sem);
+	return err >= 0 ? put_user(err, (long __user *)arg) : err;
+
+set_val:
+	if (bdev != bdev->bd_contains)
+		err = -EINVAL;
+	else {
+		if (!capable(CAP_SYS_ADMIN))
+			err = -EACCES;
+		else {
+			down(&ide_setting_sem);
+			err = setfunc(drive, arg);
+			up(&ide_setting_sem);
+		}
+	}
+	return err;
 }
 
 EXPORT_SYMBOL(generic_ide_ioctl);
@@ -1566,13 +1333,13 @@ static int __init ide_setup(char *s)
 		return 1;
 	}
 
-#ifdef CONFIG_BLK_DEV_IDEPCI
+#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
 	if (!strcmp(s, "ide=reverse")) {
 		ide_scan_direction = 1;
 		printk(" : Enabled support for IDE inverse scan order.\n");
 		return 1;
 	}
-#endif /* CONFIG_BLK_DEV_IDEPCI */
+#endif
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	if (!strcmp(s, "ide=noacpi")) {
@@ -1832,9 +1599,9 @@ extern void __init h8300_ide_init(void);
  */
 static void __init probe_for_hwifs (void)
 {
-#ifdef CONFIG_BLK_DEV_IDEPCI
+#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
 	ide_scan_pcibus(ide_scan_direction);
-#endif /* CONFIG_BLK_DEV_IDEPCI */
+#endif
 
 #ifdef CONFIG_ETRAX_IDE
 	{
@@ -1892,54 +1659,6 @@ static void __init probe_for_hwifs (void)
 #endif
 }
 
-void ide_register_subdriver(ide_drive_t *drive, ide_driver_t *driver)
-{
-#ifdef CONFIG_PROC_FS
-	ide_add_proc_entries(drive->proc, driver->proc, drive);
-#endif
-}
-
-EXPORT_SYMBOL(ide_register_subdriver);
-
-/**
- *	ide_unregister_subdriver	-	disconnect drive from driver
- *	@drive: drive to unplug
- *	@driver: driver
- *
- *	Disconnect a drive from the driver it was attached to and then
- *	clean up the various proc files and other objects attached to it.
- *
- *	Takes ide_setting_sem and ide_lock.
- *	Caller must hold none of the locks.
- */
-
-void ide_unregister_subdriver(ide_drive_t *drive, ide_driver_t *driver)
-{
-	unsigned long flags;
-	
-#ifdef CONFIG_PROC_FS
-	ide_remove_proc_entries(drive->proc, driver->proc);
-#endif
-	down(&ide_setting_sem);
-	spin_lock_irqsave(&ide_lock, flags);
-	/*
-	 * ide_setting_sem protects the settings list
-	 * ide_lock protects the use of settings
-	 *
-	 * so we need to hold both, ide_settings_sem because we want to
-	 * modify the settings list, and ide_lock because we cannot take
-	 * a setting out that is being used.
-	 *
-	 * OTOH both ide_{read,write}_setting are only ever used under
-	 * ide_setting_sem.
-	 */
-	auto_remove_settings(drive);
-	spin_unlock_irqrestore(&ide_lock, flags);
-	up(&ide_setting_sem);
-}
-
-EXPORT_SYMBOL(ide_unregister_subdriver);
-
 /*
  * Probe module
  */
@@ -2071,9 +1790,7 @@ static int __init ide_init(void)
 
 	init_ide_data();
 
-#ifdef CONFIG_PROC_FS
-	proc_ide_root = proc_mkdir("ide", NULL);
-#endif
+	proc_ide_create();
 
 #ifdef CONFIG_BLK_DEV_ALI14XX
 	if (probe_ali14xx)
@@ -2096,14 +1813,9 @@ static int __init ide_init(void)
 		(void)qd65xx_init();
 #endif
 
-	initializing = 1;
 	/* Probe for special PCI and other "known" interface chipsets. */
 	probe_for_hwifs();
-	initializing = 0;
 
-#ifdef CONFIG_PROC_FS
-	proc_ide_create();
-#endif
 	return 0;
 }
 
@@ -2143,9 +1855,7 @@ void __exit cleanup_module (void)
 	pnpide_exit();
 #endif
 
-#ifdef CONFIG_PROC_FS
 	proc_ide_destroy();
-#endif
 
 	bus_unregister(&ide_bus_type);
 }
diff --git a/drivers/ide/legacy/ali14xx.c b/drivers/ide/legacy/ali14xx.c
index 91961aa..df17ed6 100644
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -223,7 +223,8 @@ static int __init ali14xx_probe(void)
 	probe_hwif_init(hwif);
 	probe_hwif_init(mate);
 
-	create_proc_ide_interfaces();
+	ide_proc_register_port(hwif);
+	ide_proc_register_port(mate);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 1ed224a..101aee1 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -213,7 +213,7 @@ fail_base2:
 						IRQ_AMIGA_PORTS);
 			}	
 			
-			index = ide_register_hw(&hw, &hwif);
+			index = ide_register_hw(&hw, 1, &hwif);
 			if (index != -1) {
 				hwif->mmio = 1;
 				printk("ide%d: ", index);
diff --git a/drivers/ide/legacy/dtc2278.c b/drivers/ide/legacy/dtc2278.c
index 0219ffa..36a3f0a 100644
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -138,7 +138,8 @@ static int __init dtc2278_probe(void)
 	probe_hwif_init(hwif);
 	probe_hwif_init(mate);
 
-	create_proc_ide_interfaces();
+	ide_proc_register_port(hwif);
+	ide_proc_register_port(mate);
 
 	return 0;
 }
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index a9f2cd5..e1e9d9d 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -70,7 +70,7 @@ void __init falconide_init(void)
 			0, 0, NULL,
 //			falconide_iops,
 			IRQ_MFP_IDE);
-	index = ide_register_hw(&hw, NULL);
+	index = ide_register_hw(&hw, 1, NULL);
 
 	if (index != -1)
 	    printk("ide%d: Falcon IDE interface\n", index);
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index dcfadbb..0830a02 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -165,7 +165,7 @@ found:
 //			&gayle_iops,
 			IRQ_AMIGA_PORTS);
 
-	index = ide_register_hw(&hw, &hwif);
+	index = ide_register_hw(&hw, 1, &hwif);
 	if (index != -1) {
 	    hwif->mmio = 1;
 	    switch (i) {
diff --git a/drivers/ide/legacy/ht6560b.c b/drivers/ide/legacy/ht6560b.c
index a283264..c8f353b 100644
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -357,7 +357,8 @@ int __init ht6560b_init(void)
 	probe_hwif_init(hwif);
 	probe_hwif_init(mate);
 
-	create_proc_ide_interfaces();
+	ide_proc_register_port(hwif);
+	ide_proc_register_port(mate);
 
 	return 0;
 
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index c6522a6..2f3977f 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -153,7 +153,7 @@ static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq
     hw.irq = irq;
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
-    return ide_register_hw_with_fixup(&hw, NULL, ide_undecoded_slave);
+    return ide_register_hw_with_fixup(&hw, 0, NULL, ide_undecoded_slave);
 }
 
 /*======================================================================
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 4c0079a..c211fc7 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -102,21 +102,21 @@ void macide_init(void)
 				0, 0, macide_ack_intr,
 //				quadra_ide_iops,
 				IRQ_NUBUS_F);
-		index = ide_register_hw(&hw, &hwif);
+		index = ide_register_hw(&hw, 1, &hwif);
 		break;
 	case MAC_IDE_PB:
 		ide_setup_ports(&hw, IDE_BASE, macide_offsets,
 				0, 0, macide_ack_intr,
 //				macide_pb_iops,
 				IRQ_NUBUS_C);
-		index = ide_register_hw(&hw, &hwif);
+		index = ide_register_hw(&hw, 1, &hwif);
 		break;
 	case MAC_IDE_BABOON:
 		ide_setup_ports(&hw, BABOON_BASE, macide_offsets,
 				0, 0, NULL,
 //				macide_baboon_iops,
 				IRQ_BABOON_1);
-		index = ide_register_hw(&hw, &hwif);
+		index = ide_register_hw(&hw, 1, &hwif);
 		if (index == -1) break;
 		if (macintosh_config->ident == MAC_MODEL_PB190) {
 
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 74f0812..e628a98 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -142,7 +142,7 @@ void q40ide_init(void)
 			0, NULL,
 //			m68kide_iops,
 			q40ide_default_irq(pcide_bases[i]));
-	index = ide_register_hw(&hw, &hwif);
+	index = ide_register_hw(&hw, 1, &hwif);
 	// **FIXME**
 	if (index != -1)
 		hwif->mmio = 1;
diff --git a/drivers/ide/legacy/qd65xx.c b/drivers/ide/legacy/qd65xx.c
index 2fb8f50..d1414a7 100644
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -427,7 +427,7 @@ static int __init qd_probe(int base)
 		qd_setup(hwif, base, config, QD6500_DEF_DATA, QD6500_DEF_DATA,
 			 &qd6500_tune_drive);
 
-		create_proc_ide_interfaces();
+		ide_proc_register_port(hwif);
 
 		return 1;
 	}
@@ -459,7 +459,7 @@ static int __init qd_probe(int base)
 				 &qd6580_tune_drive);
 			qd_write_reg(QD_DEF_CONTR,QD_CONTROL_PORT);
 
-			create_proc_ide_interfaces();
+			ide_proc_register_port(hwif);
 
 			return 1;
 		} else {
@@ -479,7 +479,8 @@ static int __init qd_probe(int base)
 				 &qd6580_tune_drive);
 			qd_write_reg(QD_DEF_CONTR,QD_CONTROL_PORT);
 
-			create_proc_ide_interfaces();
+			ide_proc_register_port(hwif);
+			ide_proc_register_port(mate);
 
 			return 0; /* no other qd65xx possible */
 		}
diff --git a/drivers/ide/legacy/umc8672.c b/drivers/ide/legacy/umc8672.c
index ca79744..ddc403a 100644
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -160,7 +160,8 @@ static int __init umc8672_probe(void)
 	probe_hwif_init(hwif);
 	probe_hwif_init(mate);
 
-	create_proc_ide_interfaces();
+	ide_proc_register_port(hwif);
+	ide_proc_register_port(mate);
 
 	return 0;
 }
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index d54d9fe..ca95e99 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -760,6 +760,9 @@ static int au_ide_probe(struct device *dev)
 #endif
 
 	probe_hwif_init(hwif);
+
+	ide_proc_register_port(hwif);
+
 	dev_set_drvdata(dev, hwif);
 
 	printk(KERN_INFO "Au1xxx IDE(builtin) configured for %s\n", mode );
diff --git a/drivers/ide/mips/swarm.c b/drivers/ide/mips/swarm.c
index 81fa068..6e935d7 100644
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -129,6 +129,9 @@ static int __devinit swarm_ide_probe(struct device *dev)
 	hwif->irq = hwif->hw.irq;
 
 	probe_hwif_init(hwif);
+
+	ide_proc_register_port(hwif);
+
 	dev_set_drvdata(dev, hwif);
 
 	return 0;
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 73bdf64..b173bc6 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -87,38 +87,12 @@ static u8 pci_bus_clock_list_ultra (u8 speed, struct chipset_bus_clock_list_entr
 	return chipset_table->ultra_settings;
 }
 
-static u8 aec62xx_ratemask (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 mode;
-
-	switch(hwif->pci_dev->device) {
-		case PCI_DEVICE_ID_ARTOP_ATP865:
-		case PCI_DEVICE_ID_ARTOP_ATP865R:
-			mode = (inb(hwif->channel ?
-				    hwif->mate->dma_status :
-				    hwif->dma_status) & 0x10) ? 4 : 3;
-			break;
-		case PCI_DEVICE_ID_ARTOP_ATP860:
-		case PCI_DEVICE_ID_ARTOP_ATP860R:
-			mode = 2;
-			break;
-		case PCI_DEVICE_ID_ARTOP_ATP850UF:
-		default:
-			return 1;
-	}
-
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
 static int aec6210_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u16 d_conf		= 0;
-	u8 speed	= ide_rate_filter(aec62xx_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 	u8 ultra = 0, ultra_conf = 0;
 	u8 tmp0 = 0, tmp1 = 0, tmp2 = 0;
 	unsigned long flags;
@@ -145,7 +119,7 @@ static int aec6260_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 speed	= ide_rate_filter(aec62xx_ratemask(drive), xferspeed);
+	u8 speed	= ide_rate_filter(drive, xferspeed);
 	u8 unit		= (drive->select.b.unit & 0x01);
 	u8 tmp1 = 0, tmp2 = 0;
 	u8 ultra = 0, drive_conf = 0, ultra_conf = 0;
@@ -181,17 +155,6 @@ static int aec62xx_tune_chipset (ide_drive_t *drive, u8 speed)
 	}
 }
 
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, aec62xx_ratemask(drive));	
-
-	if (!(speed))
-		return 0;
-
-	(void) aec62xx_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
 {
 	pio = ide_get_best_pio_mode(drive, pio, 4, NULL);
@@ -200,7 +163,7 @@ static void aec62xx_tune_drive (ide_drive_t *drive, u8 pio)
 
 static int aec62xx_config_drive_xfer_rate (ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
@@ -261,11 +224,13 @@ static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const ch
 
 static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 {
+	struct pci_dev *dev = hwif->pci_dev;
+
 	hwif->autodma = 0;
 	hwif->tuneproc = &aec62xx_tune_drive;
 	hwif->speedproc = &aec62xx_tune_chipset;
 
-	if (hwif->pci_dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
+	if (dev->device == PCI_DEVICE_ID_ARTOP_ATP850UF)
 		hwif->serialized = hwif->channel;
 
 	if (hwif->mate)
@@ -277,7 +242,15 @@ static void __devinit init_hwif_aec62xx(ide_hwif_t *hwif)
 		return;
 	}
 
-	hwif->ultra_mask = 0x7f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
+
+	/* atp865 and atp865r */
+	if (hwif->ultra_mask == 0x3f) {
+		/* check bit 0x10 of DMA status register */
+		if (inb(pci_resource_start(dev, 4) + 2) & 0x10)
+ 			hwif->ultra_mask = 0x7f; /* udma0-6 */
+	}
+
 	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check	= &aec62xx_config_drive_xfer_rate;
@@ -344,6 +317,7 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 1 */
 		.name		= "AEC6260",
 		.init_setup	= init_setup_aec62xx,
@@ -353,6 +327,7 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= NOAUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 2 */
 		.name		= "AEC6260R",
 		.init_setup	= init_setup_aec62xx,
@@ -363,6 +338,7 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= NEVER_BOARD,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "AEC6X80",
 		.init_setup	= init_setup_aec6x80,
@@ -372,6 +348,7 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
 		.name		= "AEC6X80R",
 		.init_setup	= init_setup_aec6x80,
@@ -382,6 +359,7 @@ static ide_pci_device_t aec62xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
 
diff --git a/drivers/ide/pci/alim15x3.c b/drivers/ide/pci/alim15x3.c
index 946a127..428efda 100644
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -50,7 +50,7 @@ static u8 m5229_revision;
 static u8 chip_is_1543c_e;
 static struct pci_dev *isa_dev;
 
-#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 
@@ -278,7 +278,7 @@ static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
 
 	return p-buffer; /* => must be less than 4k! */
 }
-#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_PROC_FS) */
+#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 /**
  *	ali15x3_tune_pio	-	set up chipset for PIO mode
@@ -378,74 +378,31 @@ static void ali15x3_tune_drive (ide_drive_t *drive, u8 pio)
 }
 
 /**
- *	ali15x3_can_ultra	-	check for ultra DMA support
- *	@drive: drive to do the check
+ *	ali_udma_filter		-	compute UDMA mask
+ *	@drive: IDE device
  *
- *	Check the drive and controller revisions. Return 0 if UDMA is
- *	not available, or 1 if UDMA can be used. The actual rules for
- *	the ALi are
+ *	Return available UDMA modes.
+ *
+ *	The actual rules for the ALi are:
  *		No UDMA on revisions <= 0x20
  *		Disk only for revisions < 0xC2
  *		Not WDC drives for revisions < 0xC2
  *
  *	FIXME: WDC ifdef needs to die
  */
- 
-static u8 ali15x3_can_ultra (ide_drive_t *drive)
-{
-#ifndef CONFIG_WDC_ALI15X3
-	struct hd_driveid *id	= drive->id;
-#endif /* CONFIG_WDC_ALI15X3 */
 
-	if (m5229_revision <= 0x20) {
-		return 0;
-	} else if ((m5229_revision < 0xC2) &&
-#ifndef CONFIG_WDC_ALI15X3
-		   ((chip_is_1543c_e && strstr(id->model, "WDC ")) ||
-		    (drive->media!=ide_disk))) {
-#else /* CONFIG_WDC_ALI15X3 */
-		   (drive->media!=ide_disk)) {
-#endif /* CONFIG_WDC_ALI15X3 */
-		return 0;
-	} else {
-		return 1;
-	}
-}
-
-/**
- *	ali15x3_ratemask	-	generate DMA mode list
- *	@drive: drive to compute against
- *
- *	Generate a list of the available DMA modes for the drive. 
- *	FIXME: this function contains lots of bogus masking we can dump
- *
- *	Return the highest available mode (UDMA33, UDMA66, UDMA100,..)
- */
- 
-static u8 ali15x3_ratemask (ide_drive_t *drive)
+static u8 ali_udma_filter(ide_drive_t *drive)
 {
-	u8 mode = 0, can_ultra	= ali15x3_can_ultra(drive);
-
-	if (m5229_revision > 0xC4 && can_ultra) {
-		mode = 4;
-	} else if (m5229_revision == 0xC4 && can_ultra) {
-		mode = 3;
-	} else if (m5229_revision >= 0xC2 && can_ultra) {
-		mode = 2;
-	} else if (can_ultra) {
-		return 1;
-	} else {
-		return 0;
+	if (m5229_revision > 0x20 && m5229_revision < 0xC2) {
+		if (drive->media != ide_disk)
+			return 0;
+#ifndef CONFIG_WDC_ALI15X3
+		if (chip_is_1543c_e && strstr(drive->id->model, "WDC "))
+			return 0;
+#endif
 	}
 
-	/*
-	 *	If the drive sees no suitable cable then UDMA 33
-	 *	is the highest permitted mode
-	 */
-	 
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
+	return drive->hwif->ultra_mask;
 }
 
 /**
@@ -461,7 +418,7 @@ static int ali15x3_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
-	u8 speed		= ide_rate_filter(ali15x3_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 	u8 speed1		= speed;
 	u8 unit			= (drive->select.b.unit & 0x01);
 	u8 tmpbyte		= 0x00;
@@ -511,7 +468,7 @@ static int ali15x3_tune_chipset (ide_drive_t *drive, u8 xferspeed)
  
 static int config_chipset_for_dma (ide_drive_t *drive)
 {
-	u8 speed = ide_dma_speed(drive, ali15x3_ratemask(drive));
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (!(speed))
 		return 0;
@@ -609,13 +566,13 @@ static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const c
 
 	isa_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
-#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 	if (!ali_proc) {
 		ali_proc = 1;
 		bmide_dev = dev;
 		ide_pci_create_host_proc("ali", ali_get_info);
 	}
-#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_PROC_FS) */
+#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 	local_irq_save(flags);
 
@@ -771,6 +728,7 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 	hwif->autodma = 0;
 	hwif->tuneproc = &ali15x3_tune_drive;
 	hwif->speedproc = &ali15x3_tune_chipset;
+	hwif->udma_filter = &ali_udma_filter;
 
 	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
 	hwif->no_lba48_dma = (m5229_revision <= 0xC4) ? 1 : 0;
@@ -783,8 +741,17 @@ static void __devinit init_hwif_common_ali15x3 (ide_hwif_t *hwif)
 
 	hwif->atapi_dma = 1;
 
-	if (m5229_revision > 0x20)
-		hwif->ultra_mask = 0x7f;
+	if (m5229_revision <= 0x20)
+		hwif->ultra_mask = 0x00; /* no udma */
+	else if (m5229_revision < 0xC2)
+		hwif->ultra_mask = 0x07; /* udma0-2 */
+	else if (m5229_revision == 0xC2 || m5229_revision == 0xC3)
+		hwif->ultra_mask = 0x1f; /* udma0-4 */
+	else if (m5229_revision == 0xC4)
+		hwif->ultra_mask = 0x3f; /* udma0-5 */
+	else
+		hwif->ultra_mask = 0x7f; /* udma0-6 */
+
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
diff --git a/drivers/ide/pci/amd74xx.c b/drivers/ide/pci/amd74xx.c
index 7989bdd..becb1a5 100644
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -92,7 +92,7 @@ static unsigned char amd_cyc2udma[] = { 6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3
  * AMD /proc entry.
  */
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_IDE_PROC_FS
 
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
@@ -402,14 +402,14 @@ static unsigned int __devinit init_chipset_amd74xx(struct pci_dev *dev, const ch
  * Register /proc/ide/amd74xx entry
  */
 
-#if defined(DISPLAY_AMD_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_AMD_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
         if (!amd74xx_proc) {
                 amd_base = pci_resource_start(dev, 4);
                 bmide_dev = dev;
 		ide_pci_create_host_proc("amd74xx", amd74xx_get_info);
                 amd74xx_proc = 1;
         }
-#endif /* DISPLAY_AMD_TIMINGS && CONFIG_PROC_FS */
+#endif /* DISPLAY_AMD_TIMINGS && CONFIG_IDE_PROC_FS */
 
 	return dev->irq;
 }
diff --git a/drivers/ide/pci/atiixp.c b/drivers/ide/pci/atiixp.c
index 2d48af3..0e52ad7 100644
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -49,22 +49,6 @@ static int save_mdma_mode[4];
 static DEFINE_SPINLOCK(atiixp_lock);
 
 /**
- *	atiixp_ratemask		-	compute rate mask for ATIIXP IDE
- *	@drive: IDE drive to compute for
- *
- *	Returns the available modes for the ATIIXP IDE controller.
- */
-
-static u8 atiixp_ratemask(ide_drive_t *drive)
-{
-	u8 mode = 3;
-
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
-/**
  *	atiixp_dma_2_pio		-	return the PIO mode matching DMA
  *	@xfer_rate: transfer speed
  *
@@ -189,7 +173,7 @@ static int atiixp_speedproc(ide_drive_t *drive, u8 xferspeed)
 	u16 tmp16;
 	u8 speed, pio;
 
-	speed = ide_rate_filter(atiixp_ratemask(drive), xferspeed);
+	speed = ide_rate_filter(drive, xferspeed);
 
 	spin_lock_irqsave(&atiixp_lock, flags);
 
@@ -223,26 +207,6 @@ static int atiixp_speedproc(ide_drive_t *drive, u8 xferspeed)
 }
 
 /**
- *	atiixp_config_drive_for_dma	-	configure drive for DMA
- *	@drive: IDE drive to configure
- *
- *	Set up a ATIIXP interface channel for the best available speed.
- *	We prefer UDMA if it is available and then MWDMA. If DMA is
- *	not available we switch to PIO and return 0.
- */
-
-static int atiixp_config_drive_for_dma(ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, atiixp_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	(void) atiixp_speedproc(drive, speed);
-	return ide_dma_enable(drive);
-}
-
-/**
  *	atiixp_dma_check	-	set up an IDE device
  *	@drive: IDE drive to configure
  *
@@ -256,7 +220,7 @@ static int atiixp_dma_check(ide_drive_t *drive)
 
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && atiixp_config_drive_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive)) {
diff --git a/drivers/ide/pci/cmd64x.c b/drivers/ide/pci/cmd64x.c
index 77f51ab..61ea96b 100644
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -74,7 +74,7 @@
 #define UDIDETCR1	0x7B
 #define DTPR1		0x7C
 
-#if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 
@@ -165,7 +165,7 @@ static int cmd64x_get_info (char *buffer, char **addr, off_t offset, int count)
 	return p-buffer;	/* => must be less than 4k! */
 }
 
-#endif	/* defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS) */
+#endif	/* defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 static u8 quantize_timing(int timing, int quant)
 {
@@ -292,55 +292,6 @@ static void cmd64x_tune_drive (ide_drive_t *drive, u8 pio)
 	(void) ide_config_drive_speed(drive, XFER_PIO_0 + pio);
 }
 
-static u8 cmd64x_ratemask (ide_drive_t *drive)
-{
-	struct pci_dev *dev	= HWIF(drive)->pci_dev;
-	u8 mode = 0;
-
-	switch(dev->device) {
-		case PCI_DEVICE_ID_CMD_649:
-			mode = 3;
-			break;
-		case PCI_DEVICE_ID_CMD_648:
-			mode = 2;
-			break;
-		case PCI_DEVICE_ID_CMD_643:
-			return 0;
-
-		case PCI_DEVICE_ID_CMD_646:
-		{
-			unsigned int class_rev	= 0;
-			pci_read_config_dword(dev,
-				PCI_CLASS_REVISION, &class_rev);
-			class_rev &= 0xff;
-		/*
-		 * UltraDMA only supported on PCI646U and PCI646U2, which
-		 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
-		 * Actually, although the CMD tech support people won't
-		 * tell me the details, the 0x03 revision cannot support
-		 * UDMA correctly without hardware modifications, and even
-		 * then it only works with Quantum disks due to some
-		 * hold time assumptions in the 646U part which are fixed
-		 * in the 646U2.
-		 *
-		 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
-		 */
-			switch(class_rev) {
-				case 0x07:
-				case 0x05:
-					return 1;
-				case 0x03:
-				case 0x01:
-				default:
-					return 0;
-			}
-		}
-	}
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
 static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -348,7 +299,7 @@ static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
 	u8 unit			= drive->dn & 0x01;
 	u8 regU = 0, pciU	= hwif->channel ? UDIDETCR1 : UDIDETCR0;
 
-	speed = ide_rate_filter(cmd64x_ratemask(drive), speed);
+	speed = ide_rate_filter(drive, speed);
 
 	if (speed >= XFER_SW_DMA_0) {
 		(void) pci_read_config_byte(dev, pciU, &regU);
@@ -403,7 +354,7 @@ static int cmd64x_tune_chipset (ide_drive_t *drive, u8 speed)
 
 static int config_chipset_for_dma (ide_drive_t *drive)
 {
-	u8 speed	= ide_dma_speed(drive, cmd64x_ratemask(drive));
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (!speed)
 		return 0;
@@ -597,7 +548,7 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 	(void) pci_write_config_byte(dev, UDIDETCR0, 0xf0);
 #endif /* CONFIG_PPC */
 
-#if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_CMD64X_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 
 	cmd_devs[n_cmd_devs++] = dev;
 
@@ -605,7 +556,7 @@ static unsigned int __devinit init_chipset_cmd64x(struct pci_dev *dev, const cha
 		cmd64x_proc = 1;
 		ide_pci_create_host_proc("cmd64x", cmd64x_get_info);
 	}
-#endif /* DISPLAY_CMD64X_TIMINGS && CONFIG_PROC_FS */
+#endif /* DISPLAY_CMD64X_TIMINGS && CONFIG_IDE_PROC_FS */
 
 	return 0;
 }
@@ -644,15 +595,24 @@ static void __devinit init_hwif_cmd64x(ide_hwif_t *hwif)
 
 	hwif->atapi_dma = 1;
 
-	hwif->ultra_mask = 0x3f;
-	hwif->mwdma_mask = 0x07;
+	hwif->ultra_mask = hwif->cds->udma_mask;
+
+	/*
+	 * UltraDMA only supported on PCI646U and PCI646U2, which
+	 * correspond to revisions 0x03, 0x05 and 0x07 respectively.
+	 * Actually, although the CMD tech support people won't
+	 * tell me the details, the 0x03 revision cannot support
+	 * UDMA correctly without hardware modifications, and even
+	 * then it only works with Quantum disks due to some
+	 * hold time assumptions in the 646U part which are fixed
+	 * in the 646U2.
+	 *
+	 * So we only do UltraDMA on revision 0x05 and 0x07 chipsets.
+	 */
+	if (dev->device == PCI_DEVICE_ID_CMD_646 && class_rev < 5)
+		hwif->ultra_mask = 0x00;
 
-	if (dev->device == PCI_DEVICE_ID_CMD_643)
-		hwif->ultra_mask = 0x80;
-	if (dev->device == PCI_DEVICE_ID_CMD_646)
-		hwif->ultra_mask = (class_rev > 0x04) ? 0x07 : 0x80;
-	if (dev->device == PCI_DEVICE_ID_CMD_648)
-		hwif->ultra_mask = 0x1f;
+	hwif->mwdma_mask = 0x07;
 
 	hwif->ide_dma_check = &cmd64x_config_drive_for_dma;
 	if (!(hwif->udma_four))
@@ -716,6 +676,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x00,0x00,0x00}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x00, /* no udma */
 	},{	/* 1 */
 		.name		= "CMD646",
 		.init_setup	= init_setup_cmd646,
@@ -725,6 +686,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 2 */
 		.name		= "CMD648",
 		.init_setup	= init_setup_cmd64x,
@@ -734,6 +696,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "CMD649",
 		.init_setup	= init_setup_cmd64x,
@@ -743,6 +706,7 @@ static ide_pci_device_t cmd64x_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.enablebits	= {{0x51,0x04,0x04}, {0x51,0x08,0x08}},
 		.bootable	= ON_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
 
diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
index 400859a..3b88a3a 100644
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -213,6 +213,7 @@ static ide_pci_device_t cyrix_chipsets[] __devinitdata = {
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	ide_hwif_t *hwif = NULL, *mate = NULL;
 	ata_index_t index;
 	ide_pci_device_t *d = &cyrix_chipsets[id->driver_data];
 
@@ -239,10 +240,21 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
 
 	ide_pci_setup_ports(dev, d, 14, &index);
 
-	if((index.b.low & 0xf0) != 0xf0)
-		probe_hwif_init(&ide_hwifs[index.b.low]);
-	if((index.b.high & 0xf0) != 0xf0)
-		probe_hwif_init(&ide_hwifs[index.b.high]);
+	if ((index.b.low & 0xf0) != 0xf0)
+		hwif = &ide_hwifs[index.b.low];
+	if ((index.b.high & 0xf0) != 0xf0)
+		mate = &ide_hwifs[index.b.high];
+
+	if (hwif)
+		probe_hwif_init(hwif);
+	if (mate)
+		probe_hwif_init(mate);
+
+	if (hwif)
+		ide_proc_register_port(hwif);
+	if (mate)
+		ide_proc_register_port(mate);
+
 	return 0;
 }
 
diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index 45f43ef..41925c4 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -127,20 +127,6 @@ static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
 	}
 }
 
-static u8 cs5535_ratemask(ide_drive_t *drive)
-{
-	/* eighty93 will return 1 if it's 80core and capable of
-	exceeding udma2, 0 otherwise. we need ratemask to set
-	the max speed and if we can > udma2 then we return 2
-	which selects speed_max as udma4 which is the 5535's max
-	speed, and 1 selects udma2 which is the max for 40c */
-	if (!eighty_ninty_three(drive))
-		return 1;
-
-	return 2;
-}
-
-
 /****
  *	cs5535_set_drive         -     Configure the drive to the new speed
  *	@drive: Drive to set up
@@ -151,7 +137,7 @@ static u8 cs5535_ratemask(ide_drive_t *drive)
  */
 static int cs5535_set_drive(ide_drive_t *drive, u8 speed)
 {
-	speed = ide_rate_filter(cs5535_ratemask(drive), speed);
+	speed = ide_rate_filter(drive, speed);
 	ide_config_drive_speed(drive, speed);
 	cs5535_set_speed(drive, speed);
 
@@ -178,28 +164,13 @@ static void cs5535_tuneproc(ide_drive_t *drive, u8 xferspeed)
 	cs5535_set_speed(drive, xferspeed);
 }
 
-static int cs5535_config_drive_for_dma(ide_drive_t *drive)
-{
-	u8 speed;
-
-	speed = ide_dma_speed(drive, cs5535_ratemask(drive));
-
-	/* If no DMA speed was available then let dma_check hit pio */
-	if (!speed) {
-		return 0;
-	}
-
-	cs5535_set_drive(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int cs5535_dma_check(ide_drive_t *drive)
 {
 	u8 speed;
 
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && cs5535_config_drive_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive)) {
diff --git a/drivers/ide/pci/delkin_cb.c b/drivers/ide/pci/delkin_cb.c
index dd7ec37..46f4a88 100644
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -80,7 +80,7 @@ delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	rc = ide_register_hw_with_fixup(&hw, &hwif, ide_undecoded_slave);
+	rc = ide_register_hw_with_fixup(&hw, 0, &hwif, ide_undecoded_slave);
 	if (rc < 0) {
 		printk(KERN_ERR "delkin_cb: ide_register_hw failed (%d)\n", rc);
 		pci_disable_device(dev);
diff --git a/drivers/ide/pci/hpt34x.c b/drivers/ide/pci/hpt34x.c
index 924eaa3..2c24c3d 100644
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -43,15 +43,10 @@
 
 #define HPT343_DEBUG_DRIVE_INFO		0
 
-static u8 hpt34x_ratemask (ide_drive_t *drive)
-{
-	return 1;
-}
-
 static int hpt34x_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	struct pci_dev *dev	= HWIF(drive)->pci_dev;
-	u8 speed	= ide_rate_filter(hpt34x_ratemask(drive), xferspeed);
+	u8 speed = ide_rate_filter(drive, xferspeed);
 	u32 reg1= 0, tmp1 = 0, reg2 = 0, tmp2 = 0;
 	u8			hi_speed, lo_speed;
 
@@ -89,29 +84,11 @@ static void hpt34x_tune_drive (ide_drive_t *drive, u8 pio)
 	(void) hpt34x_tune_chipset(drive, (XFER_PIO_0 + pio));
 }
 
-/*
- * This allows the configuration of ide_pci chipset registers
- * for cards that learn about the drive's UDMA, DMA, PIO capabilities
- * after the drive is reported by the OS.  Initially for designed for
- * HPT343 UDMA chipset by HighPoint|Triones Technologies, Inc.
- */
-
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, hpt34x_ratemask(drive));
-
-	if (!(speed))
-		return 0;
-
-	(void) hpt34x_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int hpt34x_config_drive_xfer_rate (ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 #ifndef CONFIG_HPT34X_AUTODMA
 		return -1;
 #else
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index cf9d344..fcbc560 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -514,43 +514,31 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
 	return 0;
 }
 
-static u8 hpt3xx_ratemask(ide_drive_t *drive)
-{
-	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
-	u8 mode			= info->max_mode;
-
-	if (!eighty_ninty_three(drive) && mode)
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
 /*
  *	Note for the future; the SATA hpt37x we must set
  *	either PIO or UDMA modes 0,4,5
  */
- 
-static u8 hpt3xx_ratefilter(ide_drive_t *drive, u8 speed)
+
+static u8 hpt3xx_udma_filter(ide_drive_t *drive)
 {
 	struct hpt_info *info	= pci_get_drvdata(HWIF(drive)->pci_dev);
 	u8 chip_type		= info->chip_type;
-	u8 mode			= hpt3xx_ratemask(drive);
-
-	if (drive->media != ide_disk)
-		return min(speed, (u8)XFER_PIO_4);
+	u8 mode			= info->max_mode;
+	u8 mask;
 
 	switch (mode) {
 		case 0x04:
-			speed = min_t(u8, speed, XFER_UDMA_6);
+			mask = 0x7f;
 			break;
 		case 0x03:
-			speed = min_t(u8, speed, XFER_UDMA_5);
+			mask = 0x3f;
 			if (chip_type >= HPT374)
 				break;
 			if (!check_in_drive_list(drive, bad_ata100_5))
 				goto check_bad_ata33;
 			/* fall thru */
 		case 0x02:
-			speed = min_t(u8, speed, XFER_UDMA_4);
+			mask = 0x1f;
 
 			/*
 			 * CHECK ME, Does this need to be changed to HPT374 ??
@@ -561,13 +549,13 @@ static u8 hpt3xx_ratefilter(ide_drive_t *drive, u8 speed)
 			    !check_in_drive_list(drive, bad_ata66_4))
 				goto check_bad_ata33;
 
-			speed = min_t(u8, speed, XFER_UDMA_3);
+			mask = 0x0f;
 			if (HPT366_ALLOW_ATA66_3 &&
 			    !check_in_drive_list(drive, bad_ata66_3))
 				goto check_bad_ata33;
 			/* fall thru */
 		case 0x01:
-			speed = min_t(u8, speed, XFER_UDMA_2);
+			mask = 0x07;
 
 		check_bad_ata33:
 			if (chip_type >= HPT370A)
@@ -577,10 +565,10 @@ static u8 hpt3xx_ratefilter(ide_drive_t *drive, u8 speed)
 			/* fall thru */
 		case 0x00:
 		default:
-			speed = min_t(u8, speed, XFER_MW_DMA_2);
+			mask = 0x00;
 			break;
 	}
-	return speed;
+	return mask;
 }
 
 static u32 get_speed_setting(u8 speed, struct hpt_info *info)
@@ -608,12 +596,19 @@ static int hpt36x_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev  *dev	= hwif->pci_dev;
 	struct hpt_info	*info	= pci_get_drvdata(dev);
-	u8  speed		= hpt3xx_ratefilter(drive, xferspeed);
+	u8  speed		= ide_rate_filter(drive, xferspeed);
 	u8  itr_addr		= drive->dn ? 0x44 : 0x40;
-	u32 itr_mask		= speed < XFER_MW_DMA_0 ? 0x30070000 :
-				 (speed < XFER_UDMA_0   ? 0xc0070000 : 0xc03800ff);
-	u32 new_itr		= get_speed_setting(speed, info);
 	u32 old_itr		= 0;
+	u32 itr_mask, new_itr;
+
+	/* TODO: move this to ide_rate_filter() [ check ->atapi_dma ] */
+	if (drive->media != ide_disk)
+		speed = min_t(u8, speed, XFER_PIO_4);
+
+	itr_mask = speed < XFER_MW_DMA_0 ? 0x30070000 :
+		  (speed < XFER_UDMA_0   ? 0xc0070000 : 0xc03800ff);
+
+	new_itr = get_speed_setting(speed, info);
 
 	/*
 	 * Disable on-chip PIO FIFO/buffer (and PIO MST mode as well)
@@ -633,12 +628,19 @@ static int hpt37x_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev  *dev	= hwif->pci_dev;
 	struct hpt_info	*info	= pci_get_drvdata(dev);
-	u8  speed		= hpt3xx_ratefilter(drive, xferspeed);
+	u8  speed		= ide_rate_filter(drive, xferspeed);
 	u8  itr_addr		= 0x40 + (drive->dn * 4);
-	u32 itr_mask		= speed < XFER_MW_DMA_0 ? 0x303c0000 :
-				 (speed < XFER_UDMA_0   ? 0xc03c0000 : 0xc1c001ff);
-	u32 new_itr		= get_speed_setting(speed, info);
 	u32 old_itr		= 0;
+	u32 itr_mask, new_itr;
+
+	/* TODO: move this to ide_rate_filter() [ check ->atapi_dma ] */
+	if (drive->media != ide_disk)
+		speed = min_t(u8, speed, XFER_PIO_4);
+
+	itr_mask = speed < XFER_MW_DMA_0 ? 0x303c0000 :
+		  (speed < XFER_UDMA_0   ? 0xc03c0000 : 0xc1c001ff);
+
+	new_itr = get_speed_setting(speed, info);
 
 	pci_read_config_dword(dev, itr_addr, &old_itr);
 	new_itr = (new_itr & ~itr_mask) | (old_itr & itr_mask);
@@ -667,24 +669,6 @@ static void hpt3xx_tune_drive(ide_drive_t *drive, u8 pio)
 	(void) hpt3xx_tune_chipset (drive, XFER_PIO_0 + pio);
 }
 
-/*
- * This allows the configuration of ide_pci chipset registers
- * for cards that learn about the drive's UDMA, DMA, PIO capabilities
- * after the drive is reported by the OS.  Initially designed for
- * HPT366 UDMA chipset by HighPoint|Triones Technologies, Inc.
- *
- */
-static int config_chipset_for_dma(ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, hpt3xx_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	(void) hpt3xx_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int hpt3xx_quirkproc(ide_drive_t *drive)
 {
 	struct hd_driveid *id	= drive->id;
@@ -739,7 +723,7 @@ static int hpt366_config_drive_xfer_rate(ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
@@ -1271,6 +1255,7 @@ static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 	hwif->intrproc			= &hpt3xx_intrproc;
 	hwif->maskproc			= &hpt3xx_maskproc;
 	hwif->busproc			= &hpt3xx_busproc;
+	hwif->udma_filter		= &hpt3xx_udma_filter;
 
 	/*
 	 * HPT3xxN chips have some complications:
diff --git a/drivers/ide/pci/it8213.c b/drivers/ide/pci/it8213.c
index 424f00b..c04a026 100644
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -17,22 +17,6 @@
 
 #include <asm/io.h>
 
-/*
- *	it8213_ratemask	-	Compute available modes
- *	@drive: IDE drive
- *
- *	Compute the available speeds for the devices on the interface. This
- *	is all modes to ATA133 clipped by drive cable setup.
- */
-
-static u8 it8213_ratemask (ide_drive_t *drive)
-{
-	u8 mode	= 4;
-	if (!eighty_ninty_three(drive))
-		mode = min_t(u8, mode, 1);
-	return mode;
-}
-
 /**
  *	it8213_dma_2_pio		-	return the PIO mode matching DMA
  *	@xfer_rate: transfer speed
@@ -145,7 +129,7 @@ static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 maslave		= 0x40;
-	u8 speed		= ide_rate_filter(it8213_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
 	int v_flag		= 0x01 << drive->dn;
@@ -213,25 +197,6 @@ static int it8213_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return ide_config_drive_speed(drive, speed);
 }
 
-/*
- *	config_chipset_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	Called by the IDE layer when it wants the timings set up.
- */
-
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, it8213_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	it8213_tune_chipset(drive, speed);
-
-	return ide_dma_enable(drive);
-}
-
 /**
  *	it8213_configure_drive_for_dma	-	set up for DMA transfers
  *	@drive: drive we are going to set up
@@ -246,7 +211,7 @@ static int it8213_config_drive_for_dma (ide_drive_t *drive)
 {
 	u8 pio;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	pio = ide_get_best_pio_mode(drive, 255, 4, NULL);
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index 4e12548..442f658 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -229,22 +229,6 @@ static void it821x_clock_strategy(ide_drive_t *drive)
 }
 
 /**
- *	it821x_ratemask	-	Compute available modes
- *	@drive: IDE drive
- *
- *	Compute the available speeds for the devices on the interface. This
- *	is all modes to ATA133 clipped by drive cable setup.
- */
-
-static u8 it821x_ratemask (ide_drive_t *drive)
-{
-	u8 mode	= 4;
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
-/**
  *	it821x_tunepio	-	tune a drive
  *	@drive: drive to tune
  *	@pio: the desired PIO mode
@@ -438,7 +422,7 @@ static int it821x_tune_chipset (ide_drive_t *drive, byte xferspeed)
 
 	ide_hwif_t *hwif	= drive->hwif;
 	struct it821x_dev *itdev = ide_get_hwifdata(hwif);
-	u8 speed		= ide_rate_filter(it821x_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 
 	switch (speed) {
 	case XFER_PIO_4:
@@ -488,7 +472,7 @@ static int it821x_tune_chipset (ide_drive_t *drive, byte xferspeed)
 
 static int config_chipset_for_dma (ide_drive_t *drive)
 {
-	u8 speed	= ide_dma_speed(drive, it821x_ratemask(drive));
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (speed == 0)
 		return 0;
diff --git a/drivers/ide/pci/jmicron.c b/drivers/ide/pci/jmicron.c
index be4fc96..76ed251 100644
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -22,22 +22,6 @@ typedef enum {
 } port_type;
 
 /**
- *	jmicron_ratemask	-	Compute available modes
- *	@drive: IDE drive
- *
- *	Compute the available speeds for the devices on the interface. This
- *	is all modes to ATA133 clipped by drive cable setup.
- */
-
-static u8 jmicron_ratemask(ide_drive_t *drive)
-{
-	u8 mode	= 4;
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
-/**
  *	ata66_jmicron		-	Cable check
  *	@hwif: IDE port
  *
@@ -129,32 +113,12 @@ static void config_jmicron_chipset_for_pio (ide_drive_t *drive, byte set_speed)
 
 static int jmicron_tune_chipset (ide_drive_t *drive, byte xferspeed)
 {
-
-	u8 speed		= ide_rate_filter(jmicron_ratemask(drive), xferspeed);
+	u8 speed = ide_rate_filter(drive, xferspeed);
 
 	return ide_config_drive_speed(drive, speed);
 }
 
 /**
- *	config_chipset_for_dma	-	configure for DMA
- *	@drive: drive to configure
- *
- *	As the JMicron snoops for timings all we actually need to do is
- *	make sure we don't set an invalid mode.
- */
-
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed	= ide_dma_speed(drive, jmicron_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	jmicron_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
-/**
  *	jmicron_configure_drive_for_dma	-	set up for DMA transfers
  *	@drive: drive we are going to set up
  *
@@ -164,7 +128,7 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 
 static int jmicron_config_drive_for_dma (ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	config_jmicron_chipset_for_pio(drive, 1);
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 2cdd629..65b1e12 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -37,8 +37,6 @@
 #include <asm/pci-bridge.h>
 #endif
 
-#define PDC202_DEBUG_CABLE	0
-
 #undef DEBUG
 
 #ifdef DEBUG
@@ -82,16 +80,6 @@ static u8 max_dma_rate(struct pci_dev *pdev)
 	return mode;
 }
 
-static u8 pdcnew_ratemask(ide_drive_t *drive)
-{
-	u8 mode = max_dma_rate(HWIF(drive)->pci_dev);
-
-	if (!eighty_ninty_three(drive))
-		mode = min_t(u8, mode, 1);
-
-	return	mode;
-}
-
 /**
  * get_indexed_reg - Get indexed register
  * @hwif: for the port address
@@ -164,7 +152,7 @@ static int pdcnew_tune_chipset(ide_drive_t *drive, u8 speed)
 	u8 adj			= (drive->dn & 1) ? 0x08 : 0x00;
 	int			err;
 
-	speed = ide_rate_filter(pdcnew_ratemask(drive), speed);
+	speed = ide_rate_filter(drive, speed);
 
 	/*
 	 * Issue SETFEATURES_XFER to the drive first. PDC202xx hardware will
@@ -244,17 +232,8 @@ static int config_chipset_for_dma(ide_drive_t *drive)
 {
 	struct hd_driveid *id	= drive->id;
 	ide_hwif_t *hwif	= HWIF(drive);
-	u8 ultra_66		= (id->dma_ultra & 0x0078) ? 1 : 0;
-	u8 cable		= pdcnew_cable_detect(hwif);
 	u8 speed;
 
-	if (ultra_66 && cable) {
-		printk(KERN_WARNING "Warning: %s channel "
-		       "requires an 80-pin cable for operation.\n",
-		       hwif->channel ? "Secondary" : "Primary");
-		printk(KERN_WARNING "%s reduced to Ultra33 mode.\n", drive->name);
-	}
-
 	if (id->capability & 4) {
 		/*
 		 * Set IORDY_EN & PREFETCH_EN (this seems to have
@@ -267,7 +246,7 @@ static int config_chipset_for_dma(ide_drive_t *drive)
 		set_indexed_reg(hwif, 0x13 + adj, tmp | 0x03);
 	}
 
-	speed = ide_dma_speed(drive, pdcnew_ratemask(drive));
+	speed = ide_max_dma_mode(drive);
 
 	if (!speed)
 		return 0;
@@ -543,7 +522,8 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
 	hwif->atapi_dma  = 1;
-	hwif->ultra_mask = 0x7f;
+
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 
 	hwif->err_stops_fifo = 1;
@@ -556,11 +536,6 @@ static void __devinit init_hwif_pdc202new(ide_hwif_t *hwif)
 	if (!noautodma)
 		hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
-
-#if PDC202_DEBUG_CABLE
-	printk(KERN_DEBUG "%s: %s-pin cable\n",
-		hwif->name, hwif->udma_four ? "80" : "40");
-#endif /* PDC202_DEBUG_CABLE */
 }
 
 static int __devinit init_setup_pdcnew(struct pci_dev *dev, ide_pci_device_t *d)
@@ -619,6 +594,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 1 */
 		.name		= "PDC20269",
 		.init_setup	= init_setup_pdcnew,
@@ -627,6 +603,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 2 */
 		.name		= "PDC20270",
 		.init_setup	= init_setup_pdc20270,
@@ -635,6 +612,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 3 */
 		.name		= "PDC20271",
 		.init_setup	= init_setup_pdcnew,
@@ -643,6 +621,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 4 */
 		.name		= "PDC20275",
 		.init_setup	= init_setup_pdcnew,
@@ -651,6 +630,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 5 */
 		.name		= "PDC20276",
 		.init_setup	= init_setup_pdc20276,
@@ -659,6 +639,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	},{	/* 6 */
 		.name		= "PDC20277",
 		.init_setup	= init_setup_pdcnew,
@@ -667,6 +648,7 @@ static ide_pci_device_t pdcnew_chipsets[] __devinitdata = {
 		.channels	= 2,
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
+		.udma_mask	= 0x7f, /* udma0-6*/
 	}
 };
 
diff --git a/drivers/ide/pci/pdc202xx_old.c b/drivers/ide/pci/pdc202xx_old.c
index a7a639f..7146fe3 100644
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -46,7 +46,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#define PDC202_DEBUG_CABLE		0
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
 static const char *pdc_quirk_drives[] = {
@@ -101,35 +100,12 @@ static const char *pdc_quirk_drives[] = {
 #define	MC1		0x02	/* DMA"C" timing */
 #define	MC0		0x01	/* DMA"C" timing */
 
-static u8 pdc202xx_ratemask (ide_drive_t *drive)
-{
-	u8 mode;
-
-	switch(HWIF(drive)->pci_dev->device) {
-		case PCI_DEVICE_ID_PROMISE_20267:
-		case PCI_DEVICE_ID_PROMISE_20265:
-			mode = 3;
-			break;
-		case PCI_DEVICE_ID_PROMISE_20263:
-		case PCI_DEVICE_ID_PROMISE_20262:
-			mode = 2;
-			break;
-		case PCI_DEVICE_ID_PROMISE_20246:
-			return 1;
-		default:
-			return 0;
-	}
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
 static int pdc202xx_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
-	u8 speed	= ide_rate_filter(pdc202xx_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 
 	u32			drive_conf;
 	u8			AP, BP, CP, DP;
@@ -261,20 +237,7 @@ static int config_chipset_for_dma (ide_drive_t *drive)
 	u32 drive_conf		= 0;
 	u8 drive_pci		= 0x60 + (drive->dn << 2);
 	u8 test1 = 0, test2 = 0, speed = -1;
-	u8 AP = 0, cable = 0;
-
-	u8 ultra_66		= ((id->dma_ultra & 0x0010) ||
-				   (id->dma_ultra & 0x0008)) ? 1 : 0;
-
-	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
-		cable = pdc202xx_old_cable_detect(hwif);
-	else
-		ultra_66 = 0;
-
-	if (ultra_66 && cable) {
-		printk(KERN_WARNING "Warning: %s channel requires an 80-pin cable for operation.\n", hwif->channel ? "Secondary":"Primary");
-		printk(KERN_WARNING "%s reduced to Ultra33 mode.\n", drive->name);
-	}
+	u8 AP = 0;
 
 	if (dev->device != PCI_DEVICE_ID_PROMISE_20246)
 		pdc_old_disable_66MHz_clock(drive->hwif);
@@ -308,7 +271,7 @@ chipset_is_set:
 	if (drive->media == ide_disk)	/* PREFETCH_EN */
 		pci_write_config_byte(dev, (drive_pci), AP|PREFETCH_EN);
 
-	speed = ide_dma_speed(drive, pdc202xx_ratemask(drive));
+	speed = ide_max_dma_mode(drive);
 
 	if (!(speed)) {
 		/* restore original pci-config space */
@@ -478,7 +441,7 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 
 	hwif->drives[0].autotune = hwif->drives[1].autotune = 1;
 
-	hwif->ultra_mask = 0x3f;
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 	hwif->atapi_dma = 1;
@@ -500,10 +463,6 @@ static void __devinit init_hwif_pdc202xx(ide_hwif_t *hwif)
 	if (!noautodma)
 		hwif->autodma = 1;
 	hwif->drives[0].autodma = hwif->drives[1].autodma = hwif->autodma;
-#if PDC202_DEBUG_CABLE
-	printk(KERN_DEBUG "%s: %s-pin cable\n",
-		hwif->name, hwif->udma_four ? "80" : "40");
-#endif /* PDC202_DEBUG_CABLE */	
 }
 
 static void __devinit init_dma_pdc202xx(ide_hwif_t *hwif, unsigned long dmabase)
@@ -587,6 +546,7 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 16,
+		.udma_mask	= 0x07, /* udma0-2 */
 	},{	/* 1 */
 		.name		= "PDC20262",
 		.init_setup	= init_setup_pdc202ata4,
@@ -597,6 +557,7 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 2 */
 		.name		= "PDC20263",
 		.init_setup	= init_setup_pdc202ata4,
@@ -607,6 +568,7 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x1f, /* udma0-4 */
 	},{	/* 3 */
 		.name		= "PDC20265",
 		.init_setup	= init_setup_pdc20265,
@@ -617,6 +579,7 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	},{	/* 4 */
 		.name		= "PDC20267",
 		.init_setup	= init_setup_pdc202xx,
@@ -627,6 +590,7 @@ static ide_pci_device_t pdc202xx_chipsets[] __devinitdata = {
 		.autodma	= AUTODMA,
 		.bootable	= OFF_BOARD,
 		.extra		= 48,
+		.udma_mask	= 0x3f, /* udma0-5 */
 	}
 };
 
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index 061d300..8b219dd 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -106,68 +106,6 @@
 static int no_piix_dma;
 
 /**
- *	piix_ratemask		-	compute rate mask for PIIX IDE
- *	@drive: IDE drive to compute for
- *
- *	Returns the available modes for the PIIX IDE controller.
- */
- 
-static u8 piix_ratemask (ide_drive_t *drive)
-{
-	struct pci_dev *dev	= HWIF(drive)->pci_dev;
-	u8 mode;
-
-	switch(dev->device) {
-		case PCI_DEVICE_ID_INTEL_82801EB_1:
-			mode = 3;
-			break;
-		/* UDMA 100 capable */
-		case PCI_DEVICE_ID_INTEL_82801BA_8:
-		case PCI_DEVICE_ID_INTEL_82801BA_9:
-		case PCI_DEVICE_ID_INTEL_82801CA_10:
-		case PCI_DEVICE_ID_INTEL_82801CA_11:
-		case PCI_DEVICE_ID_INTEL_82801E_11:
-		case PCI_DEVICE_ID_INTEL_82801DB_1:
-		case PCI_DEVICE_ID_INTEL_82801DB_10:
-		case PCI_DEVICE_ID_INTEL_82801DB_11:
-		case PCI_DEVICE_ID_INTEL_82801EB_11:
-		case PCI_DEVICE_ID_INTEL_ESB_2:
-		case PCI_DEVICE_ID_INTEL_ICH6_19:
-		case PCI_DEVICE_ID_INTEL_ICH7_21:
-		case PCI_DEVICE_ID_INTEL_ESB2_18:
-		case PCI_DEVICE_ID_INTEL_ICH8_6:
-			mode = 3;
-			break;
-		/* UDMA 66 capable */
-		case PCI_DEVICE_ID_INTEL_82801AA_1:
-		case PCI_DEVICE_ID_INTEL_82372FB_1:
-			mode = 2;
-			break;
-		/* UDMA 33 capable */
-		case PCI_DEVICE_ID_INTEL_82371AB:
-		case PCI_DEVICE_ID_INTEL_82443MX_1:
-		case PCI_DEVICE_ID_INTEL_82451NX:
-		case PCI_DEVICE_ID_INTEL_82801AB_1:
-			return 1;
-		/* Non UDMA capable (MWDMA2) */
-		case PCI_DEVICE_ID_INTEL_82371SB_1:
-		case PCI_DEVICE_ID_INTEL_82371FB_1:
-		case PCI_DEVICE_ID_INTEL_82371FB_0:
-		case PCI_DEVICE_ID_INTEL_82371MX:
-		default:
-			return 0;
-	}
-	
-	/*
-	 *	If we are UDMA66 capable fall back to UDMA33 
-	 *	if the drive cannot see an 80pin cable.
-	 */
-	if (!eighty_ninty_three(drive))
-		mode = min_t(u8, mode, 1);
-	return mode;
-}
-
-/**
  *	piix_dma_2_pio		-	return the PIO mode matching DMA
  *	@xfer_rate: transfer speed
  *
@@ -301,7 +239,7 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
-	u8 speed		= ide_rate_filter(piix_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 	int a_speed		= 3 << (drive->dn * 4);
 	int u_flag		= 1 << drive->dn;
 	int v_flag		= 0x01 << drive->dn;
@@ -366,30 +304,6 @@ static int piix_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 }
 
 /**
- *	piix_config_drive_for_dma	-	configure drive for DMA
- *	@drive: IDE drive to configure
- *
- *	Set up a PIIX interface channel for the best available speed.
- *	We prefer UDMA if it is available and then MWDMA.  If DMA is
- *	not available we switch to PIO and return 0.
- */
- 
-static int piix_config_drive_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, piix_ratemask(drive));
-
-	/*
-	 * If no DMA speed was available or the chipset has DMA bugs
-	 * then disable DMA and use PIO
-	 */
-	if (!speed)
-		return 0;
-
-	(void) piix_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
-/**
  *	piix_config_drive_xfer_rate	-	set up an IDE device
  *	@drive: IDE drive to configure
  *
@@ -401,7 +315,7 @@ static int piix_config_drive_xfer_rate (ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && piix_config_drive_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
@@ -524,26 +438,14 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 		hwif->ide_dma_clear_irq = &piix_dma_clear_irq;
 
 	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x3f;
+
+	hwif->ultra_mask = hwif->cds->udma_mask;
 	hwif->mwdma_mask = 0x06;
 	hwif->swdma_mask = 0x04;
 
-	switch(hwif->pci_dev->device) {
-		case PCI_DEVICE_ID_INTEL_82371FB_0:
-		case PCI_DEVICE_ID_INTEL_82371FB_1:
-		case PCI_DEVICE_ID_INTEL_82371SB_1:
-			hwif->ultra_mask = 0x80;
-			break;
-		case PCI_DEVICE_ID_INTEL_82371AB:
-		case PCI_DEVICE_ID_INTEL_82443MX_1:
-		case PCI_DEVICE_ID_INTEL_82451NX:
-		case PCI_DEVICE_ID_INTEL_82801AB_1:
-			hwif->ultra_mask = 0x07;
-			break;
-		default:
-			if (!hwif->udma_four)
-				hwif->udma_four = piix_cable_detect(hwif);
-			break;
+	if (hwif->ultra_mask & 0x78) {
+		if (!hwif->udma_four)
+			hwif->udma_four = piix_cable_detect(hwif);
 	}
 
 	if (no_piix_dma)
@@ -557,7 +459,7 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 	hwif->drives[0].autodma = hwif->autodma;
 }
 
-#define DECLARE_PIIX_DEV(name_str) \
+#define DECLARE_PIIX_DEV(name_str, udma) \
 	{						\
 		.name		= name_str,		\
 		.init_chipset	= init_chipset_piix,	\
@@ -566,11 +468,12 @@ static void __devinit init_hwif_piix(ide_hwif_t *hwif)
 		.autodma	= AUTODMA,		\
 		.enablebits	= {{0x41,0x80,0x80}, {0x43,0x80,0x80}}, \
 		.bootable	= ON_BOARD,		\
+		.udma_mask	= udma,			\
 	}
 
 static ide_pci_device_t piix_pci_info[] __devinitdata = {
-	/*  0 */ DECLARE_PIIX_DEV("PIIXa"),
-	/*  1 */ DECLARE_PIIX_DEV("PIIXb"),
+	/*  0 */ DECLARE_PIIX_DEV("PIIXa", 0x00),	/* no udma */
+	/*  1 */ DECLARE_PIIX_DEV("PIIXb", 0x00),	/* no udma */
 
 	/*  2 */
 	{	/*
@@ -587,28 +490,28 @@ static ide_pci_device_t piix_pci_info[] __devinitdata = {
 		.flags		= IDEPCI_FLAG_ISA_PORTS
 	},
 
-	/*  3 */ DECLARE_PIIX_DEV("PIIX3"),
-	/*  4 */ DECLARE_PIIX_DEV("PIIX4"),
-	/*  5 */ DECLARE_PIIX_DEV("ICH0"),
-	/*  6 */ DECLARE_PIIX_DEV("PIIX4"),
-	/*  7 */ DECLARE_PIIX_DEV("ICH"),
-	/*  8 */ DECLARE_PIIX_DEV("PIIX4"),
-	/*  9 */ DECLARE_PIIX_DEV("PIIX4"),
-	/* 10 */ DECLARE_PIIX_DEV("ICH2"),
-	/* 11 */ DECLARE_PIIX_DEV("ICH2M"),
-	/* 12 */ DECLARE_PIIX_DEV("ICH3M"),
-	/* 13 */ DECLARE_PIIX_DEV("ICH3"),
-	/* 14 */ DECLARE_PIIX_DEV("ICH4"),
-	/* 15 */ DECLARE_PIIX_DEV("ICH5"),
-	/* 16 */ DECLARE_PIIX_DEV("C-ICH"),
-	/* 17 */ DECLARE_PIIX_DEV("ICH4"),
-	/* 18 */ DECLARE_PIIX_DEV("ICH5-SATA"),
-	/* 19 */ DECLARE_PIIX_DEV("ICH5"),
-	/* 20 */ DECLARE_PIIX_DEV("ICH6"),
-	/* 21 */ DECLARE_PIIX_DEV("ICH7"),
-	/* 22 */ DECLARE_PIIX_DEV("ICH4"),
-	/* 23 */ DECLARE_PIIX_DEV("ESB2"),
-	/* 24 */ DECLARE_PIIX_DEV("ICH8M"),
+	/*  3 */ DECLARE_PIIX_DEV("PIIX3", 0x00),	/* no udma */
+	/*  4 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
+	/*  5 */ DECLARE_PIIX_DEV("ICH0",  0x07),	/* udma0-2 */
+	/*  6 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
+	/*  7 */ DECLARE_PIIX_DEV("ICH",   0x1f),	/* udma0-4 */
+	/*  8 */ DECLARE_PIIX_DEV("PIIX4", 0x1f),	/* udma0-4 */
+	/*  9 */ DECLARE_PIIX_DEV("PIIX4", 0x07),	/* udma0-2 */
+	/* 10 */ DECLARE_PIIX_DEV("ICH2",  0x3f),	/* udma0-5 */
+	/* 11 */ DECLARE_PIIX_DEV("ICH2M", 0x3f),	/* udma0-5 */
+	/* 12 */ DECLARE_PIIX_DEV("ICH3M", 0x3f),	/* udma0-5 */
+	/* 13 */ DECLARE_PIIX_DEV("ICH3",  0x3f),	/* udma0-5 */
+	/* 14 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
+	/* 15 */ DECLARE_PIIX_DEV("ICH5",  0x3f),	/* udma0-5 */
+	/* 16 */ DECLARE_PIIX_DEV("C-ICH", 0x3f),	/* udma0-5 */
+	/* 17 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
+	/* 18 */ DECLARE_PIIX_DEV("ICH5-SATA", 0x3f),	/* udma0-5 */
+	/* 19 */ DECLARE_PIIX_DEV("ICH5",  0x3f),	/* udma0-5 */
+	/* 20 */ DECLARE_PIIX_DEV("ICH6",  0x3f),	/* udma0-5 */
+	/* 21 */ DECLARE_PIIX_DEV("ICH7",  0x3f),	/* udma0-5 */
+	/* 22 */ DECLARE_PIIX_DEV("ICH4",  0x3f),	/* udma0-5 */
+	/* 23 */ DECLARE_PIIX_DEV("ESB2",  0x3f),	/* udma0-5 */
+	/* 24 */ DECLARE_PIIX_DEV("ICH8M", 0x3f),	/* udma0-5 */
 };
 
 /**
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index f84bf79..cbf9363 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -190,23 +190,6 @@ scc_ide_outsl(unsigned long port, void *addr, u32 count)
 }
 
 /**
- *	scc_ratemask	-	Compute available modes
- *	@drive: IDE drive
- *
- *	Compute the available speeds for the devices on the interface.
- *	Enforce UDMA33 as a limit if there is no 80pin cable present.
- */
-
-static u8 scc_ratemask(ide_drive_t *drive)
-{
-	u8 mode = 4;
-
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
-
-/**
  *	scc_tuneproc	-	tune a drive PIO mode
  *	@drive: drive to tune
  *	@mode_wanted: the target operating mode
@@ -273,7 +256,7 @@ static void scc_tuneproc(ide_drive_t *drive, byte mode_wanted)
 static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	u8 speed = ide_rate_filter(scc_ratemask(drive), xferspeed);
+	u8 speed = ide_rate_filter(drive, xferspeed);
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 	unsigned long ctl_base = ports->ctl;
 	unsigned long cckctrl_port = ctl_base + 0xff0;
@@ -347,7 +330,7 @@ static int scc_tune_chipset(ide_drive_t *drive, byte xferspeed)
 
 static int scc_config_chipset_for_dma(ide_drive_t *drive)
 {
-	u8 speed = ide_dma_speed(drive, scc_ratemask(drive));
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (!speed)
 		return 0;
diff --git a/drivers/ide/pci/serverworks.c b/drivers/ide/pci/serverworks.c
index dbcd37a..2fa6d92 100644
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -65,16 +65,16 @@ static int check_in_drive_lists (ide_drive_t *drive, const char **list)
 	return 0;
 }
 
-static u8 svwks_ratemask (ide_drive_t *drive)
+static u8 svwks_udma_filter(ide_drive_t *drive)
 {
 	struct pci_dev *dev     = HWIF(drive)->pci_dev;
-	u8 mode = 0;
+	u8 mask = 0;
 
 	if (!svwks_revision)
 		pci_read_config_byte(dev, PCI_REVISION_ID, &svwks_revision);
 
 	if (dev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
-		return 2;
+		return 0x1f;
 	if (dev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		u32 reg = 0;
 		if (isa_dev)
@@ -86,25 +86,31 @@ static u8 svwks_ratemask (ide_drive_t *drive)
 		if(drive->media == ide_disk)
 			return 0;
 		/* Check the OSB4 DMA33 enable bit */
-		return ((reg & 0x00004000) == 0x00004000) ? 1 : 0;
+		return ((reg & 0x00004000) == 0x00004000) ? 0x07 : 0;
 	} else if (svwks_revision < SVWKS_CSB5_REVISION_NEW) {
-		return 1;
+		return 0x07;
 	} else if (svwks_revision >= SVWKS_CSB5_REVISION_NEW) {
-		u8 btr = 0;
+		u8 btr = 0, mode;
 		pci_read_config_byte(dev, 0x5A, &btr);
 		mode = btr & 0x3;
-		if (!eighty_ninty_three(drive))
-			mode = min(mode, (u8)1);
+
 		/* If someone decides to do UDMA133 on CSB5 the same
 		   issue will bite so be inclusive */
 		if (mode > 2 && check_in_drive_lists(drive, svwks_bad_ata100))
 			mode = 2;
+
+		switch(mode) {
+		case 2:	 mask = 0x1f; break;
+		case 1:	 mask = 0x07; break;
+		default: mask = 0x00; break;
+		}
 	}
 	if (((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
 	     (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)) &&
 	    (!(PCI_FUNC(dev->devfn) & 1)))
-		mode = 2;
-	return mode;
+		mask = 0x1f;
+
+	return mask;
 }
 
 static u8 svwks_csb_check (struct pci_dev *dev)
@@ -141,7 +147,7 @@ static int svwks_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	if (xferspeed == 255)	/* PIO auto-tuning */
 		speed = XFER_PIO_0 + pio;
 	else
-		speed = ide_rate_filter(svwks_ratemask(drive), xferspeed);
+		speed = ide_rate_filter(drive, xferspeed);
 
 	/* If we are about to put a disk into UDMA mode we screwed up.
 	   Our code assumes we never _ever_ do this on an OSB4 */
@@ -304,7 +310,7 @@ static void svwks_tune_drive (ide_drive_t *drive, u8 pio)
 
 static int config_chipset_for_dma (ide_drive_t *drive)
 {
-	u8 speed = ide_dma_speed(drive, svwks_ratemask(drive));
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (!(speed))
 		speed = XFER_PIO_0 + ide_get_best_pio_mode(drive, 255, 5, NULL);
@@ -500,6 +506,7 @@ static void __devinit init_hwif_svwks (ide_hwif_t *hwif)
 
 	hwif->tuneproc = &svwks_tune_drive;
 	hwif->speedproc = &svwks_tune_chipset;
+	hwif->udma_filter = &svwks_udma_filter;
 
 	hwif->atapi_dma = 1;
 
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index fd09b29..d3185e2 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -692,7 +692,7 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t * d)
 		return -EIO;
 
 	/* Create /proc/ide entries */
-	create_proc_ide_interfaces();
+	ide_proc_register_port(hwif);
 
 	return 0;
 }
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index c0188de..5314ec9 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -122,45 +122,41 @@ static inline unsigned long siimage_seldev(ide_drive_t *drive, int r)
 }
 
 /**
- *	siimage_ratemask	-	Compute available modes
- *	@drive: IDE drive
+ *	sil_udma_filter		-	compute UDMA mask
+ *	@drive: IDE device
+ *
+ *	Compute the available UDMA speeds for the device on the interface.
  *
- *	Compute the available speeds for the devices on the interface.
  *	For the CMD680 this depends on the clocking mode (scsc), for the
- *	SI3312 SATA controller life is a bit simpler. Enforce UDMA33
- *	as a limit if there is no 80pin cable present.
+ *	SI3112 SATA controller life is a bit simpler.
  */
- 
-static byte siimage_ratemask (ide_drive_t *drive)
+
+static u8 sil_udma_filter(ide_drive_t *drive)
 {
-	ide_hwif_t *hwif	= HWIF(drive);
-	u8 mode	= 0, scsc = 0;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long base = (unsigned long) hwif->hwif_data;
+	u8 mask = 0, scsc = 0;
 
 	if (hwif->mmio)
 		scsc = hwif->INB(base + 0x4A);
 	else
 		pci_read_config_byte(hwif->pci_dev, 0x8A, &scsc);
 
-	if(is_sata(hwif))
-	{
-		if(strstr(drive->id->model, "Maxtor"))
-			return 3;
-		return 4;
+	if (is_sata(hwif)) {
+		mask = strstr(drive->id->model, "Maxtor") ? 0x3f : 0x7f;
+		goto out;
 	}
-	
+
 	if ((scsc & 0x30) == 0x10)	/* 133 */
-		mode = 4;
+		mask = 0x7f;
 	else if ((scsc & 0x30) == 0x20)	/* 2xPCI */
-		mode = 4;
+		mask = 0x7f;
 	else if ((scsc & 0x30) == 0x00)	/* 100 */
-		mode = 3;
+		mask = 0x3f;
 	else 	/* Disabled ? */
 		BUG();
-
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
+out:
+	return mask;
 }
 
 /**
@@ -306,7 +302,7 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	u16 ultra = 0, multi	= 0;
 	u8 mode = 0, unit	= drive->select.b.unit;
-	u8 speed		= ide_rate_filter(siimage_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 	unsigned long base	= (unsigned long)hwif->hwif_data;
 	u8 scsc = 0, addr_mask	= ((hwif->channel) ?
 				    ((hwif->mmio) ? 0xF4 : 0x84) :
@@ -389,7 +385,7 @@ static int siimage_tune_chipset (ide_drive_t *drive, byte xferspeed)
  
 static int config_chipset_for_dma (ide_drive_t *drive)
 {
-	u8 speed	= ide_dma_speed(drive, siimage_ratemask(drive));
+	u8 speed = ide_max_dma_mode(drive);
 
 	if (!speed)
 		return 0;
@@ -989,6 +985,7 @@ static void __devinit init_hwif_siimage(ide_hwif_t *hwif)
 	hwif->tuneproc	= &siimage_tuneproc;
 	hwif->reset_poll = &siimage_reset_poll;
 	hwif->pre_reset = &siimage_pre_reset;
+	hwif->udma_filter = &sil_udma_filter;
 
 	if(is_sata(hwif)) {
 		static int first = 1;
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index 2ba0669..2bde1b9 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -191,7 +191,7 @@ static char* chipset_capability[] = {
 	"ATA 133 (1st gen)", "ATA 133 (2nd gen)"
 };
 
-#if defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 
@@ -426,17 +426,7 @@ static int sis_get_info (char *buffer, char **addr, off_t offset, int count)
 
 	return len > count ? count : len;
 }
-#endif /* defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_PROC_FS) */
-
-static u8 sis5513_ratemask (ide_drive_t *drive)
-{
-	u8 rates[] = { 0, 0, 1, 2, 3, 3, 4, 4 };
-	u8 mode = rates[chipset_family];
-
-	if (!eighty_ninty_three(drive))
-		mode = min(mode, (u8)1);
-	return mode;
-}
+#endif /* defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 /*
  * Configuration functions
@@ -563,7 +553,7 @@ static int sis5513_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	u8 drive_pci, reg, speed;
 	u32 regdw;
 
-	speed = ide_rate_filter(sis5513_ratemask(drive), xferspeed);
+	speed = ide_rate_filter(drive, xferspeed);
 
 	/* See config_art_rwp_pio for drive pci config registers */
 	drive_pci = 0x40;
@@ -648,32 +638,13 @@ static void sis5513_tune_drive (ide_drive_t *drive, u8 pio)
 	(void) config_chipset_for_pio(drive, pio);
 }
 
-/*
- * ((id->hw_config & 0x4000|0x2000) && (HWIF(drive)->udma_four))
- */
-static int config_chipset_for_dma (ide_drive_t *drive)
-{
-	u8 speed	= ide_dma_speed(drive, sis5513_ratemask(drive));
-
-#ifdef DEBUG
-	printk("SIS5513: config_chipset_for_dma, drive %d, ultra %x\n",
-	       drive->dn, drive->id->dma_ultra);
-#endif
-
-	if (!(speed))
-		return 0;
-
-	sis5513_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int sis5513_config_xfer_rate(ide_drive_t *drive)
 {
 	config_art_rwp_pio(drive, 5);
 
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
@@ -826,7 +797,7 @@ static unsigned int __devinit init_chipset_sis5513 (struct pci_dev *dev, const c
 				break;
 		}
 
-#if defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_PROC_FS)
+#if defined(DISPLAY_SIS_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 		if (!sis_proc) {
 			sis_proc = 1;
 			bmide_dev = dev;
@@ -858,6 +829,8 @@ static unsigned int __devinit ata66_sis5513 (ide_hwif_t *hwif)
 
 static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 {
+	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
+
 	hwif->autodma = 0;
 
 	if (!hwif->irq)
@@ -873,7 +846,8 @@ static void __devinit init_hwif_sis5513 (ide_hwif_t *hwif)
 	}
 
 	hwif->atapi_dma = 1;
-	hwif->ultra_mask = 0x7f;
+
+	hwif->ultra_mask = udma_rates[chipset_family];
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
diff --git a/drivers/ide/pci/slc90e66.c b/drivers/ide/pci/slc90e66.c
index 852ccb3..c40f291 100644
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -21,15 +21,6 @@
 
 #include <asm/io.h>
 
-static u8 slc90e66_ratemask (ide_drive_t *drive)
-{
-	u8 mode	= 2;
-
-	if (!eighty_ninty_three(drive))
-		mode = min_t(u8, mode, 1);
-	return mode;
-}
-
 static u8 slc90e66_dma_2_pio (u8 xfer_rate) {
 	switch(xfer_rate) {
 		case XFER_UDMA_4:
@@ -122,7 +113,7 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= hwif->pci_dev;
 	u8 maslave		= hwif->channel ? 0x42 : 0x40;
-	u8 speed	= ide_rate_filter(slc90e66_ratemask(drive), xferspeed);
+	u8 speed		= ide_rate_filter(drive, xferspeed);
 	int sitre = 0, a_speed	= 7 << (drive->dn * 4);
 	int u_speed = 0, u_flag = 1 << drive->dn;
 	u16			reg4042, reg44, reg48, reg4a;
@@ -169,22 +160,11 @@ static int slc90e66_tune_chipset (ide_drive_t *drive, u8 xferspeed)
 	return ide_config_drive_speed(drive, speed);
 }
 
-static int slc90e66_config_drive_for_dma (ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, slc90e66_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	(void) slc90e66_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int slc90e66_config_drive_xfer_rate (ide_drive_t *drive)
 {
 	drive->init_speed = 0;
 
-	if (ide_use_dma(drive) && slc90e66_config_drive_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 0b6d81d..cee619b 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -13,18 +13,13 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
-static inline u8 tc86c001_ratemask(ide_drive_t *drive)
-{
-	return eighty_ninty_three(drive) ? 2 : 1;
-}
-
 static int tc86c001_tune_chipset(ide_drive_t *drive, u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned long scr_port	= hwif->config_data + (drive->dn ? 0x02 : 0x00);
 	u16 mode, scr		= hwif->INW(scr_port);
 
-	speed = ide_rate_filter(tc86c001_ratemask(drive), speed);
+	speed = ide_rate_filter(drive, speed);
 
 	switch (speed) {
 		case XFER_UDMA_4:	mode = 0x00c0; break;
@@ -172,20 +167,9 @@ static int tc86c001_busproc(ide_drive_t *drive, int state)
 	return 0;
 }
 
-static int config_chipset_for_dma(ide_drive_t *drive)
-{
-	u8 speed = ide_dma_speed(drive, tc86c001_ratemask(drive));
-
-	if (!speed)
-		return 0;
-
-	(void) tc86c001_tune_chipset(drive, speed);
-	return ide_dma_enable(drive);
-}
-
 static int tc86c001_config_drive_xfer_rate(ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && config_chipset_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	if (ide_use_fast_pio(drive))
diff --git a/drivers/ide/pci/triflex.c b/drivers/ide/pci/triflex.c
index 5e06179..35e8c61 100644
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -48,7 +48,7 @@ static int triflex_tune_chipset(ide_drive_t *drive, u8 xferspeed)
 	u16 timing = 0;
 	u32 triflex_timings = 0;
 	u8 unit = (drive->select.b.unit & 0x01);
-	u8 speed = ide_rate_filter(0, xferspeed);
+	u8 speed = ide_rate_filter(drive, xferspeed);
 	
 	pci_read_config_dword(dev, channel_offset, &triflex_timings);
 	
@@ -100,20 +100,9 @@ static void triflex_tune_drive(ide_drive_t *drive, u8 pio)
 	(void) triflex_tune_chipset(drive, (XFER_PIO_0 + use_pio));
 }
 
-static int triflex_config_drive_for_dma(ide_drive_t *drive)
-{
-	int speed = ide_dma_speed(drive, 0); /* No ultra speeds */
-
-	if (!speed)
-		return 0;
-
-	(void) triflex_tune_chipset(drive, speed);
-	 return ide_dma_enable(drive);
-}
-
 static int triflex_config_drive_xfer_rate(ide_drive_t *drive)
 {
-	if (ide_use_dma(drive) && triflex_config_drive_for_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	triflex_tune_drive(drive, 255);
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index a49ebe4..45fc36f 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1276,6 +1276,8 @@ pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 	/* We probe the hwif now */
 	probe_hwif_init(hwif);
 
+	ide_proc_register_port(hwif);
+
 	return 0;
 }
 
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 118fb32..67035ba 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -702,6 +702,7 @@ out:
 
 int ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d)
 {
+	ide_hwif_t *hwif = NULL, *mate = NULL;
 	ata_index_t index_list;
 	int ret;
 
@@ -710,11 +711,19 @@ int ide_setup_pci_device(struct pci_dev *dev, ide_pci_device_t *d)
 		goto out;
 
 	if ((index_list.b.low & 0xf0) != 0xf0)
-		probe_hwif_init_with_fixup(&ide_hwifs[index_list.b.low], d->fixup);
+		hwif = &ide_hwifs[index_list.b.low];
 	if ((index_list.b.high & 0xf0) != 0xf0)
-		probe_hwif_init_with_fixup(&ide_hwifs[index_list.b.high], d->fixup);
+		mate = &ide_hwifs[index_list.b.high];
 
-	create_proc_ide_interfaces();
+	if (hwif)
+		probe_hwif_init_with_fixup(hwif, d->fixup);
+	if (mate)
+		probe_hwif_init_with_fixup(mate, d->fixup);
+
+	if (hwif)
+		ide_proc_register_port(hwif);
+	if (mate)
+		ide_proc_register_port(mate);
 out:
 	return ret;
 }
@@ -748,13 +757,22 @@ int ide_setup_pci_devices(struct pci_dev *dev1, struct pci_dev *dev2,
 		}
 	}
 
-	create_proc_ide_interfaces();
+	for (i = 0; i < 2; i++) {
+		u8 idx[2] = { index_list[i].b.low, index_list[i].b.high };
+		int j;
+
+		for (j = 0; j < 2; j++) {
+			if ((idx[j] & 0xf0) != 0xf0)
+				ide_proc_register_port(ide_hwifs + idx[j]);
+		}
+	}
 out:
 	return ret;
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_pci_devices);
 
+#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
 /*
  *	Module interfaces
  */
@@ -861,3 +879,4 @@ void __init ide_scan_pcibus (int scan_direction)
 		__pci_register_driver(d, d->driver.owner, d->driver.mod_name);
 	}
 }
+#endif
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index 0acf2f7..c803d2b 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -563,7 +563,7 @@ static void media_bay_step(int i)
 				ide_init_hwif_ports(&hw, (unsigned long) bay->cd_base, (unsigned long) 0, NULL);
 				hw.irq = bay->cd_irq;
 				hw.chipset = ide_pmac;
-				bay->cd_index = ide_register_hw(&hw, NULL);
+				bay->cd_index = ide_register_hw(&hw, 0, NULL);
 				pmu_resume();
 			}
 			if (bay->cd_index == -1) {
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 2b5b8a9..8263f75 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -721,19 +721,23 @@ static ide_startstop_t idescsi_do_request (ide_drive_t *drive, struct request *r
 	return ide_stopped;
 }
 
+#ifdef CONFIG_IDE_PROC_FS
 static void idescsi_add_settings(ide_drive_t *drive)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 
 /*
- *			drive	setting name	read/write	ioctl	ioctl		data type	min	max	mul_factor	div_factor	data pointer		set function
+ *			drive	setting name	read/write	data type	min	max	mul_factor	div_factor	data pointer		set function
  */
-	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	-1,	-1,		TYPE_INT,	0,	1023,	1,		1,		&drive->bios_cyl,	NULL);
-	ide_add_setting(drive,	"bios_head",	SETTING_RW,	-1,	-1,		TYPE_BYTE,	0,	255,	1,		1,		&drive->bios_head,	NULL);
-	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	-1,	-1,		TYPE_BYTE,	0,	63,	1,		1,		&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"transform",	SETTING_RW,	-1,	-1,		TYPE_INT,	0,	3,	1,		1,		&scsi->transform,	NULL);
-	ide_add_setting(drive,	"log",		SETTING_RW,	-1,	-1,		TYPE_INT,	0,	1,	1,		1,		&scsi->log,		NULL);
+	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	1023,	1,		1,		&drive->bios_cyl,	NULL);
+	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,	1,		1,		&drive->bios_head,	NULL);
+	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,	1,		1,		&drive->bios_sect,	NULL);
+	ide_add_setting(drive,	"transform",	SETTING_RW,	TYPE_INT,	0,	3,	1,		1,		&scsi->transform,	NULL);
+	ide_add_setting(drive,	"log",		SETTING_RW,	TYPE_INT,	0,	1,	1,		1,		&scsi->log,		NULL);
 }
+#else
+static inline void idescsi_add_settings(ide_drive_t *drive) { ; }
+#endif
 
 /*
  *	Driver initialization.
@@ -756,7 +760,7 @@ static void ide_scsi_remove(ide_drive_t *drive)
 	struct ide_scsi_obj *scsi = scsihost_to_idescsi(scsihost);
 	struct gendisk *g = scsi->disk;
 
-	ide_unregister_subdriver(drive, scsi->driver);
+	ide_proc_unregister_driver(drive, scsi->driver);
 
 	ide_unregister_region(g);
 
@@ -770,13 +774,11 @@ static void ide_scsi_remove(ide_drive_t *drive)
 
 static int ide_scsi_probe(ide_drive_t *);
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_IDE_PROC_FS
 static ide_proc_entry_t idescsi_proc[] = {
 	{ "capacity", S_IFREG|S_IRUGO, proc_ide_read_capacity, NULL },
 	{ NULL, 0, NULL, NULL }
 };
-#else
-# define idescsi_proc	NULL
 #endif
 
 static ide_driver_t idescsi_driver = {
@@ -790,11 +792,13 @@ static ide_driver_t idescsi_driver = {
 	.version		= IDESCSI_VERSION,
 	.media			= ide_scsi,
 	.supports_dsc_overlap	= 0,
-	.proc			= idescsi_proc,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
 	.abort                  = idescsi_atapi_abort,
+#ifdef CONFIG_IDE_PROC_FS
+	.proc			= idescsi_proc,
+#endif
 };
 
 static int idescsi_ide_open(struct inode *inode, struct file *filp)
@@ -1153,7 +1157,7 @@ static int ide_scsi_probe(ide_drive_t *drive)
 	idescsi->host = host;
 	idescsi->disk = g;
 	g->private_data = &idescsi->driver;
-	ide_register_subdriver(drive, &idescsi_driver);
+	ide_proc_register_driver(drive, &idescsi_driver);
 	err = 0;
 	idescsi_setup(drive, idescsi);
 	g->fops = &idescsi_ops;
@@ -1165,7 +1169,7 @@ static int ide_scsi_probe(ide_drive_t *drive)
 	}
 	/* fall through on error */
 	ide_unregister_region(g);
-	ide_unregister_subdriver(drive, &idescsi_driver);
+	ide_proc_unregister_driver(drive, &idescsi_driver);
 
 	put_disk(g);
 out_host_put:
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 418dfb5..df4e6a5 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -223,8 +223,9 @@ typedef struct hw_regs_s {
 /*
  * Register new hardware with ide
  */
-int ide_register_hw(hw_regs_t *hw, struct hwif_s **hwifp);
-int ide_register_hw_with_fixup(hw_regs_t *, struct hwif_s **, void (*)(struct hwif_s *));
+int ide_register_hw(hw_regs_t *, int, struct hwif_s **);
+int ide_register_hw_with_fixup(hw_regs_t *, int, struct hwif_s **,
+			       void (*)(struct hwif_s *));
 
 /*
  * Set up hw_regs_t structure before calling ide_register_hw (optional)
@@ -559,9 +560,10 @@ typedef struct ide_drive_s {
 	struct ide_drive_s 	*next;	/* circular list of hwgroup drives */
 	void		*driver_data;	/* extra driver data */
 	struct hd_driveid	*id;	/* drive model identification info */
+#ifdef CONFIG_IDE_PROC_FS
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 	struct ide_settings_s *settings;/* /proc/ide/ drive settings */
-
+#endif
 	struct hwif_s		*hwif;	/* actually (ide_hwif_t *) */
 
 	unsigned long sleep;		/* sleep until this time */
@@ -601,16 +603,12 @@ typedef struct ide_drive_s {
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
 	unsigned vdma		: 1;	/* 1=doing PIO over DMA 0=doing normal DMA */
-	unsigned addressing;		/*      : 3;
-					 *  0=28-bit
-					 *  1=48-bit
-					 *  2=48-bit doing 28-bit
-					 *  3=64-bit
-					 */
 	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
 	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
 	unsigned post_reset	: 1;
+	unsigned udma33_warned	: 1;
 
+	u8	addressing;	/* 0=28-bit, 1=48-bit, 2=48-bit doing 28-bit */
         u8	quirk_list;	/* considered quirky, set for a specific host */
         u8	init_speed;	/* transfer rate set at boot */
         u8	current_speed;	/* current transfer rate set */
@@ -717,11 +715,8 @@ typedef struct hwif_s {
 	int	(*quirkproc)(ide_drive_t *);
 	/* driver soft-power interface */
 	int	(*busproc)(ide_drive_t *, int);
-//	/* host rate limiter */
-//	u8	(*ratemask)(ide_drive_t *);
-//	/* device rate limiter */
-//	u8	(*ratefilter)(ide_drive_t *, u8);
 #endif
+	u8 (*udma_filter)(ide_drive_t *);
 
 	void (*ata_input_data)(ide_drive_t *, void *, u32);
 	void (*ata_output_data)(ide_drive_t *, void *, u32);
@@ -866,16 +861,22 @@ typedef struct hwgroup_s {
 	unsigned char cmd_buf[4];
 } ide_hwgroup_t;
 
-/* structure attached to the request for IDE_TASK_CMDS */
+typedef struct ide_driver_s ide_driver_t;
+
+extern struct semaphore ide_setting_sem;
+
+int set_io_32bit(ide_drive_t *, int);
+int set_pio_mode(ide_drive_t *, int);
+int set_using_dma(ide_drive_t *, int);
 
+#ifdef CONFIG_IDE_PROC_FS
 /*
  * configurable drive settings
  */
 
 #define TYPE_INT	0
-#define TYPE_INTA	1
-#define TYPE_BYTE	2
-#define TYPE_SHORT	3
+#define TYPE_BYTE	1
+#define TYPE_SHORT	2
 
 #define SETTING_READ	(1 << 0)
 #define SETTING_WRITE	(1 << 1)
@@ -885,8 +886,6 @@ typedef int (ide_procset_t)(ide_drive_t *, int);
 typedef struct ide_settings_s {
 	char			*name;
 	int			rw;
-	int			read_ioctl;
-	int			write_ioctl;
 	int			data_type;
 	int			min;
 	int			max;
@@ -898,12 +897,7 @@ typedef struct ide_settings_s {
 	struct ide_settings_s	*next;
 } ide_settings_t;
 
-extern struct semaphore ide_setting_sem;
-extern int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int read_ioctl, int write_ioctl, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set);
-extern ide_settings_t *ide_find_setting_by_name(ide_drive_t *drive, char *name);
-extern int ide_read_setting(ide_drive_t *t, ide_settings_t *setting);
-extern int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int val);
-extern void ide_add_generic_settings(ide_drive_t *drive);
+int ide_add_setting(ide_drive_t *, const char *, int, int, int, int, int, int, void *, ide_procset_t *set);
 
 /*
  * /proc/ide interface
@@ -915,15 +909,15 @@ typedef struct {
 	write_proc_t	*write_proc;
 } ide_proc_entry_t;
 
-#ifdef CONFIG_PROC_FS
-extern struct proc_dir_entry *proc_ide_root;
+void proc_ide_create(void);
+void proc_ide_destroy(void);
+void ide_proc_register_port(ide_hwif_t *);
+void ide_proc_unregister_port(ide_hwif_t *);
+void ide_proc_register_driver(ide_drive_t *, ide_driver_t *);
+void ide_proc_unregister_driver(ide_drive_t *, ide_driver_t *);
+
+void ide_add_generic_settings(ide_drive_t *);
 
-extern void proc_ide_create(void);
-extern void proc_ide_destroy(void);
-extern void create_proc_ide_interfaces(void);
-void destroy_proc_ide_interface(ide_hwif_t *);
-extern void ide_add_proc_entries(struct proc_dir_entry *, ide_proc_entry_t *, void *);
-extern void ide_remove_proc_entries(struct proc_dir_entry *, ide_proc_entry_t *);
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
 
@@ -947,8 +941,13 @@ void ide_pci_create_host_proc(const char *, get_info_t *);
 	return len;			\
 }
 #else
-static inline void create_proc_ide_interfaces(void) { ; }
-static inline void destroy_proc_ide_interface(ide_hwif_t *hwif) { ; }
+static inline void proc_ide_create(void) { ; }
+static inline void proc_ide_destroy(void) { ; }
+static inline void ide_proc_register_port(ide_hwif_t *hwif) { ; }
+static inline void ide_proc_unregister_port(ide_hwif_t *hwif) { ; }
+static inline void ide_proc_register_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
+static inline void ide_proc_unregister_driver(ide_drive_t *drive, ide_driver_t *driver) { ; }
+static inline void ide_add_generic_settings(ide_drive_t *drive) { ; }
 #define PROC_IDE_READ_RETURN(page,start,off,count,eof,len) return 0;
 #endif
 
@@ -991,7 +990,7 @@ enum {
  * The gendriver.owner field should be set to the module owner of this driver.
  * The gendriver.name field should be set to the name of this driver
  */
-typedef struct ide_driver_s {
+struct ide_driver_s {
 	const char			*version;
 	u8				media;
 	unsigned supports_dsc_overlap	: 1;
@@ -999,12 +998,14 @@ typedef struct ide_driver_s {
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
 	ide_startstop_t	(*abort)(ide_drive_t *, struct request *rq);
-	ide_proc_entry_t	*proc;
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
-} ide_driver_t;
+#ifdef CONFIG_IDE_PROC_FS
+	ide_proc_entry_t	*proc;
+#endif
+};
 
 #define to_ide_driver(drv) container_of(drv, ide_driver_t, gen_driver)
 
@@ -1204,9 +1205,14 @@ void ide_init_disk(struct gendisk *, ide_drive_t *);
 
 extern int ideprobe_init(void);
 
+#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
 extern void ide_scan_pcibus(int scan_direction) __init;
 extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner, const char *mod_name);
 #define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE, KBUILD_MODNAME)
+#else
+#define ide_pci_register_driver(d) pci_register_driver(d)
+#endif
+
 void ide_pci_setup_ports(struct pci_dev *, struct ide_pci_device_s *, int, ata_index_t *);
 extern void ide_setup_pci_noise (struct pci_dev *dev, struct ide_pci_device_s *d);
 
@@ -1214,9 +1220,6 @@ extern void default_hwif_iops(ide_hwif_t *);
 extern void default_hwif_mmiops(ide_hwif_t *);
 extern void default_hwif_transport(ide_hwif_t *);
 
-void ide_register_subdriver(ide_drive_t *, ide_driver_t *);
-void ide_unregister_subdriver(ide_drive_t *, ide_driver_t *);
-
 #define ON_BOARD		1
 #define NEVER_BOARD		0
 
@@ -1257,6 +1260,7 @@ typedef struct ide_pci_device_s {
 	unsigned int		extra;
 	struct ide_pci_device_s	*next;
 	u8			flags;
+	u8			udma_mask;
 } ide_pci_device_t;
 
 extern int ide_setup_pci_device(struct pci_dev *, ide_pci_device_t *);
@@ -1278,6 +1282,8 @@ int ide_in_drive_list(struct hd_driveid *, const struct drive_list_entry *);
 int __ide_dma_bad_drive(ide_drive_t *);
 int __ide_dma_good_drive(ide_drive_t *);
 int ide_use_dma(ide_drive_t *);
+u8 ide_max_dma_mode(ide_drive_t *);
+int ide_tune_dma(ide_drive_t *);
 void ide_dma_off(ide_drive_t *);
 void ide_dma_verbose(ide_drive_t *);
 int ide_set_dma(ide_drive_t *);
@@ -1304,6 +1310,8 @@ extern int __ide_dma_timeout(ide_drive_t *);
 
 #else
 static inline int ide_use_dma(ide_drive_t *drive) { return 0; }
+static inline u8 ide_max_dma_mode(ide_drive_t *drive) { return 0; }
+static inline int ide_tune_dma(ide_drive_t *drive) { return 0; }
 static inline void ide_dma_off(ide_drive_t *drive) { ; }
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
@@ -1348,8 +1356,7 @@ static inline void ide_set_hwifdata (ide_hwif_t * hwif, void *data)
 }
 
 /* ide-lib.c */
-extern u8 ide_dma_speed(ide_drive_t *drive, u8 mode);
-extern u8 ide_rate_filter(u8 mode, u8 speed); 
+u8 ide_rate_filter(ide_drive_t *, u8);
 extern int ide_dma_enable(ide_drive_t *drive);
 extern char *ide_xfer_verbose(u8 xfer_rate);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);

