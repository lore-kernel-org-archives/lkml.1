Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbYHEQnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbYHEQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761647AbYHEQml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:42:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:50079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761057AbYHEQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mPQXGVVCLjVpIZMSXzTC42K5tqd9shiGchxVIjvGmjSevbKkYQS8Bh741od6DSPUAN
         VmZHPP3V3+1oiosmHqGvJPE3R/Y1489bKZiRT2yMbNLoTc5gngOIuLhcClQsNBIc9aG3
         mIzlvch603Ekwaqn9dDxRuHztmCHsuSAo9hII=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 05 Aug 2008 18:40:28 +0200
Message-Id: <20080805164028.17094.92931.sendpatchset@localhost.localdomain>
In-Reply-To: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
References: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/4] ide: add ide_setting_ioctl() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add struct ide_ioctl_devset representing ioctl device setting.

* Add ide_setting_ioctl() helper for matching given ioctl
  and its parameters against table of ioctl device settings.

* Convert ide_setting_ioctl() and idedisk_ioctl() to use
  ide_setting_ioctl().

* Un-export ide_setting_mtx.

While at it:

* {get,set}_lba_addressing() -> {get,set}_addressing()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   57 ++++++++++++++-----------------------------------
 drivers/ide/ide.c      |   53 +++++++++++++++++++++++++++++----------------
 include/linux/ide.h    |   14 +++++++++++-
 3 files changed, 64 insertions(+), 60 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -682,7 +682,7 @@ static int set_acoustic(ide_drive_t *dri
 	return 0;
 }
 
-ide_devset_get(lba_addressing, addressing);
+ide_devset_get(addressing, addressing);
 
 /*
  * drive->addressing:
@@ -690,7 +690,7 @@ ide_devset_get(lba_addressing, addressin
  *	1: 48-bit
  *	2: 48-bit capable doing 28-bit
  */
-static int set_lba_addressing(ide_drive_t *drive, int arg)
+static int set_addressing(ide_drive_t *drive, int arg)
 {
 	if (arg < 0 || arg > 2)
 		return -EINVAL;
@@ -710,7 +710,7 @@ static int set_lba_addressing(ide_drive_
 
 #ifdef CONFIG_IDE_PROC_FS
 ide_devset_rw_nolock(acoustic,	0, 254, acoustic);
-ide_devset_rw_nolock(address,	0,   2, lba_addressing);
+ide_devset_rw_nolock(address,	0,   2, addressing);
 ide_devset_rw_nolock(multcount,	0,  16, multcount);
 ide_devset_rw_nolock(nowerr,	0,   1, nowerr);
 ide_devset_rw_nolock(wcache,	0,   1, wcache);
@@ -759,7 +759,7 @@ static void idedisk_setup(ide_drive_t *d
 			drive->doorlocking = 1;
 	}
 
-	(void)set_lba_addressing(drive, 1);
+	(void)set_addressing(drive, 1);
 
 	if (drive->addressing == 1) {
 		int max_s = 2048;
@@ -1006,51 +1006,28 @@ static int idedisk_getgeo(struct block_d
 	return 0;
 }
 
+static const struct ide_ioctl_devset ide_disk_ioctl_settings[] = {
+{ HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,   get_addressing, set_addressing },
+{ HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT, get_multcount,  set_multcount  },
+{ HDIO_GET_NOWERR,	HDIO_SET_NOWERR,    get_nowerr,	    set_nowerr	   },
+{ HDIO_GET_WCACHE,	HDIO_SET_WCACHE,    get_wcache,	    set_wcache	   },
+{ HDIO_GET_ACOUSTIC,	HDIO_SET_ACOUSTIC,  get_acoustic,   set_acoustic   },
+{ 0 }
+};
+
 static int idedisk_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
-	unsigned long flags;
 	struct block_device *bdev = inode->i_bdev;
 	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
 	ide_drive_t *drive = idkp->drive;
-	int err, (*getfunc)(ide_drive_t *), (*setfunc)(ide_drive_t *, int);
+	int err;
 
-	switch (cmd) {
-	case HDIO_GET_ADDRESS:	 getfunc = get_lba_addressing;	goto read_val;
-	case HDIO_GET_MULTCOUNT: getfunc = get_multcount;	goto read_val;
-	case HDIO_GET_NOWERR:	 getfunc = get_nowerr;		goto read_val;
-	case HDIO_GET_WCACHE:	 getfunc = get_wcache;		goto read_val;
-	case HDIO_GET_ACOUSTIC:	 getfunc = get_acoustic;	goto read_val;
-	case HDIO_SET_ADDRESS:	 setfunc = set_lba_addressing;	goto set_val;
-	case HDIO_SET_MULTCOUNT: setfunc = set_multcount;	goto set_val;
-	case HDIO_SET_NOWERR:	 setfunc = set_nowerr;		goto set_val;
-	case HDIO_SET_WCACHE:	 setfunc = set_wcache;		goto set_val;
-	case HDIO_SET_ACOUSTIC:	 setfunc = set_acoustic;	goto set_val;
-	}
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
 
 	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
-
-read_val:
-	mutex_lock(&ide_setting_mtx);
-	spin_lock_irqsave(&ide_lock, flags);
-	err = getfunc(drive);
-	spin_unlock_irqrestore(&ide_lock, flags);
-	mutex_unlock(&ide_setting_mtx);
-	return err >= 0 ? put_user(err, (long __user *)arg) : err;
-
-set_val:
-	if (bdev != bdev->bd_contains)
-		err = -EINVAL;
-	else {
-		if (!capable(CAP_SYS_ADMIN))
-			err = -EACCES;
-		else {
-			mutex_lock(&ide_setting_mtx);
-			err = setfunc(drive, arg);
-			mutex_unlock(&ide_setting_mtx);
-		}
-	}
-	return err;
 }
 
 static int idedisk_media_changed(struct gendisk *disk)
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -250,8 +250,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 
 DEFINE_MUTEX(ide_setting_mtx);
 
-EXPORT_SYMBOL_GPL(ide_setting_mtx);
-
 /**
  *	ide_spin_wait_hwgroup	-	wait for group
  *	@drive: drive in the group
@@ -558,23 +556,23 @@ static int ide_set_nice_ioctl(ide_drive_
 	return 0;
 }
 
+static const struct ide_ioctl_devset ide_ioctl_settings[] = {
+{ HDIO_GET_32BIT,	 HDIO_SET_32BIT,	get_io_32bit,  set_io_32bit  },
+{ HDIO_GET_KEEPSETTINGS, HDIO_SET_KEEPSETTINGS,	get_ksettings, set_ksettings },
+{ HDIO_GET_UNMASKINTR,	 HDIO_SET_UNMASKINTR,	get_unmaskirq, set_unmaskirq },
+{ HDIO_GET_DMA,		 HDIO_SET_DMA,		get_using_dma, set_using_dma },
+{ -1,			 HDIO_SET_PIO_MODE,	NULL,	       set_pio_mode  },
+{ 0 }
+};
+
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
 			unsigned int cmd, unsigned long arg)
 {
-	unsigned long flags;
-	int err = 0, (*getfunc)(ide_drive_t *), (*setfunc)(ide_drive_t *, int);
+	int err;
 
-	switch (cmd) {
-	case HDIO_GET_32BIT:	    getfunc = get_io_32bit;	 goto read_val;
-	case HDIO_GET_KEEPSETTINGS: getfunc = get_ksettings;	 goto read_val;
-	case HDIO_GET_UNMASKINTR:   getfunc = get_unmaskirq;	 goto read_val;
-	case HDIO_GET_DMA:	    getfunc = get_using_dma;	 goto read_val;
-	case HDIO_SET_32BIT:	    setfunc = set_io_32bit;	 goto set_val;
-	case HDIO_SET_KEEPSETTINGS: setfunc = set_ksettings;	 goto set_val;
-	case HDIO_SET_PIO_MODE:	    setfunc = set_pio_mode;	 goto set_val;
-	case HDIO_SET_UNMASKINTR:   setfunc = set_unmaskirq;	 goto set_val;
-	case HDIO_SET_DMA:	    setfunc = set_using_dma;	 goto set_val;
-	}
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
 
 	switch (cmd) {
 		case HDIO_OBSOLETE_IDENTITY:
@@ -629,11 +627,29 @@ int generic_ide_ioctl(ide_drive_t *drive
 		default:
 			return -EINVAL;
 	}
+}
+EXPORT_SYMBOL(generic_ide_ioctl);
+
+int ide_setting_ioctl(ide_drive_t *drive, struct block_device *bdev,
+		      unsigned int cmd, unsigned long arg,
+		      const struct ide_ioctl_devset *s)
+{
+	unsigned long flags;
+	int err = -EOPNOTSUPP;
+
+	for (; s->get_ioctl; s++) {
+		if (s->get && s->get_ioctl == cmd)
+			goto read_val;
+		else if (s->set && s->set_ioctl == cmd)
+			goto set_val;
+	}
+
+	return err;
 
 read_val:
 	mutex_lock(&ide_setting_mtx);
 	spin_lock_irqsave(&ide_lock, flags);
-	err = getfunc(drive);
+	err = s->get(drive);
 	spin_unlock_irqrestore(&ide_lock, flags);
 	mutex_unlock(&ide_setting_mtx);
 	return err >= 0 ? put_user(err, (long __user *)arg) : err;
@@ -646,14 +662,13 @@ set_val:
 			err = -EACCES;
 		else {
 			mutex_lock(&ide_setting_mtx);
-			err = setfunc(drive, arg);
+			err = s->set(drive, arg);
 			mutex_unlock(&ide_setting_mtx);
 		}
 	}
 	return err;
 }
-
-EXPORT_SYMBOL(generic_ide_ioctl);
+EXPORT_SYMBOL_GPL(ide_setting_ioctl);
 
 /**
  * ide_device_get	-	get an additional reference to a ide_drive_t
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -930,7 +930,19 @@ struct ide_driver_s {
 int ide_device_get(ide_drive_t *);
 void ide_device_put(ide_drive_t *);
 
-int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *, unsigned, unsigned long);
+struct ide_ioctl_devset {
+	unsigned int	get_ioctl;
+	unsigned int	set_ioctl;
+
+	int		(*get)(ide_drive_t *);
+	int		(*set)(ide_drive_t *, int);
+};
+
+int ide_setting_ioctl(ide_drive_t *, struct block_device *, unsigned int,
+		      unsigned long, const struct ide_ioctl_devset *);
+
+int generic_ide_ioctl(ide_drive_t *, struct file *, struct block_device *,
+		      unsigned, unsigned long);
 
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
