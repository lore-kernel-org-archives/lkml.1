Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZAOUdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZAOUdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765926AbZAOUBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:3618 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbZAOUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BQ+Uyphookk7i2/NE9Oqs11POLd8MnqtxepyNZAD7JJCG/4Wcn2wUaLs8grfpW2ksn
         cM8YIyDOjZHHPkmMbKj1pcds6xQ5ymLR6R/53Ma/CE8Q9eYvIQUpk1c0VqtSm269lzR4
         fI+B2YX9FQq/eOr8y9b8wFYDL8an+zsXQ+Du0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:01:29 +0100
Message-Id: <20090115200129.17294.88619.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: move device settings code to ide-devsets.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move device settings code to ide-devsets.c

Remove stale comment from ide.c while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile      |    3 
 drivers/ide/ide-devsets.c |  190 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-io.c      |   37 --------
 drivers/ide/ide.c         |  154 -------------------------------------
 include/linux/ide.h       |    1 
 5 files changed, 193 insertions(+), 192 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,7 +5,8 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o ide-sysfs.o
+	      ide-taskfile.o ide-pm.o ide-park.o ide-pio-blacklist.o \
+	      ide-sysfs.o ide-devsets.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
Index: b/drivers/ide/ide-devsets.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-devsets.c
@@ -0,0 +1,190 @@
+
+#include <linux/kernel.h>
+#include <linux/ide.h>
+
+DEFINE_MUTEX(ide_setting_mtx);
+
+ide_devset_get(io_32bit, io_32bit);
+
+static int set_io_32bit(ide_drive_t *drive, int arg)
+{
+	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
+		return -EPERM;
+
+	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
+		return -EINVAL;
+
+	drive->io_32bit = arg;
+
+	return 0;
+}
+
+ide_devset_get_flag(ksettings, IDE_DFLAG_KEEP_SETTINGS);
+
+static int set_ksettings(ide_drive_t *drive, int arg)
+{
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_KEEP_SETTINGS;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_KEEP_SETTINGS;
+
+	return 0;
+}
+
+ide_devset_get_flag(using_dma, IDE_DFLAG_USING_DMA);
+
+static int set_using_dma(ide_drive_t *drive, int arg)
+{
+#ifdef CONFIG_BLK_DEV_IDEDMA
+	int err = -EPERM;
+
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (ata_id_has_dma(drive->id) == 0)
+		goto out;
+
+	if (drive->hwif->dma_ops == NULL)
+		goto out;
+
+	err = 0;
+
+	if (arg) {
+		if (ide_set_dma(drive))
+			err = -EIO;
+	} else
+		ide_dma_off(drive);
+
+out:
+	return err;
+#else
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	return -EPERM;
+#endif
+}
+
+/*
+ * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
+ */
+static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
+{
+	switch (req_pio) {
+	case 202:
+	case 201:
+	case 200:
+	case 102:
+	case 101:
+	case 100:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
+	case 9:
+	case 8:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
+	case 7:
+	case 6:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
+	default:
+		return 0;
+	}
+}
+
+static int set_pio_mode(ide_drive_t *drive, int arg)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	const struct ide_port_ops *port_ops = hwif->port_ops;
+
+	if (arg < 0 || arg > 255)
+		return -EINVAL;
+
+	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
+		return -ENOSYS;
+
+	if (set_pio_mode_abuse(drive->hwif, arg)) {
+		if (arg == 8 || arg == 9) {
+			unsigned long flags;
+
+			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
+			spin_lock_irqsave(&hwif->lock, flags);
+			port_ops->set_pio_mode(drive, arg);
+			spin_unlock_irqrestore(&hwif->lock, flags);
+		} else
+			port_ops->set_pio_mode(drive, arg);
+	} else {
+		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+
+		ide_set_pio(drive, arg);
+
+		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
+			if (keep_dma)
+				ide_dma_on(drive);
+		}
+	}
+
+	return 0;
+}
+
+ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
+
+static int set_unmaskirq(ide_drive_t *drive, int arg)
+{
+	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
+		return -EPERM;
+
+	if (arg < 0 || arg > 1)
+		return -EINVAL;
+
+	if (arg)
+		drive->dev_flags |= IDE_DFLAG_UNMASK;
+	else
+		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
+
+	return 0;
+}
+
+ide_ext_devset_rw_sync(io_32bit, io_32bit);
+ide_ext_devset_rw_sync(keepsettings, ksettings);
+ide_ext_devset_rw_sync(unmaskirq, unmaskirq);
+ide_ext_devset_rw_sync(using_dma, using_dma);
+__IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
+
+int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
+		       int arg)
+{
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+	int ret = 0;
+
+	if (!(setting->flags & DS_SYNC))
+		return setting->set(drive, arg);
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 5;
+	rq->cmd[0] = REQ_DEVSET_EXEC;
+	*(int *)&rq->cmd[1] = arg;
+	rq->special = setting->set;
+
+	if (blk_execute_rq(q, NULL, rq, 0))
+		ret = rq->errors;
+	blk_put_request(rq);
+
+	return ret;
+}
+
+ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
+{
+	int err, (*setfunc)(ide_drive_t *, int) = rq->special;
+
+	err = setfunc(drive, *(int *)&rq->cmd[1]);
+	if (err)
+		rq->errors = err;
+	else
+		err = 1;
+	ide_end_request(drive, err, 0);
+	return ide_stopped;
+}
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -487,43 +487,6 @@ static ide_startstop_t execute_drive_cmd
  	return ide_stopped;
 }
 
-int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
-		       int arg)
-{
-	struct request_queue *q = drive->queue;
-	struct request *rq;
-	int ret = 0;
-
-	if (!(setting->flags & DS_SYNC))
-		return setting->set(drive, arg);
-
-	rq = blk_get_request(q, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_len = 5;
-	rq->cmd[0] = REQ_DEVSET_EXEC;
-	*(int *)&rq->cmd[1] = arg;
-	rq->special = setting->set;
-
-	if (blk_execute_rq(q, NULL, rq, 0))
-		ret = rq->errors;
-	blk_put_request(rq);
-
-	return ret;
-}
-
-static ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
-{
-	int err, (*setfunc)(ide_drive_t *, int) = rq->special;
-
-	err = setfunc(drive, *(int *)&rq->cmd[1]);
-	if (err)
-		rq->errors = err;
-	else
-		err = 1;
-	ide_end_request(drive, err, 0);
-	return ide_stopped;
-}
-
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
 	u8 cmd = rq->cmd[0];
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -62,160 +62,6 @@
 
 struct class *ide_port_class;
 
-/*
- *	Locks for IDE setting functionality
- */
-
-DEFINE_MUTEX(ide_setting_mtx);
-
-ide_devset_get(io_32bit, io_32bit);
-
-static int set_io_32bit(ide_drive_t *drive, int arg)
-{
-	if (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT)
-		return -EPERM;
-
-	if (arg < 0 || arg > 1 + (SUPPORT_VLB_SYNC << 1))
-		return -EINVAL;
-
-	drive->io_32bit = arg;
-
-	return 0;
-}
-
-ide_devset_get_flag(ksettings, IDE_DFLAG_KEEP_SETTINGS);
-
-static int set_ksettings(ide_drive_t *drive, int arg)
-{
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	if (arg)
-		drive->dev_flags |= IDE_DFLAG_KEEP_SETTINGS;
-	else
-		drive->dev_flags &= ~IDE_DFLAG_KEEP_SETTINGS;
-
-	return 0;
-}
-
-ide_devset_get_flag(using_dma, IDE_DFLAG_USING_DMA);
-
-static int set_using_dma(ide_drive_t *drive, int arg)
-{
-#ifdef CONFIG_BLK_DEV_IDEDMA
-	int err = -EPERM;
-
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	if (ata_id_has_dma(drive->id) == 0)
-		goto out;
-
-	if (drive->hwif->dma_ops == NULL)
-		goto out;
-
-	err = 0;
-
-	if (arg) {
-		if (ide_set_dma(drive))
-			err = -EIO;
-	} else
-		ide_dma_off(drive);
-
-out:
-	return err;
-#else
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	return -EPERM;
-#endif
-}
-
-/*
- * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
- */
-static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
-{
-	switch (req_pio) {
-	case 202:
-	case 201:
-	case 200:
-	case 102:
-	case 101:
-	case 100:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
-	case 9:
-	case 8:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
-	case 7:
-	case 6:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
-	default:
-		return 0;
-	}
-}
-
-static int set_pio_mode(ide_drive_t *drive, int arg)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_port_ops *port_ops = hwif->port_ops;
-
-	if (arg < 0 || arg > 255)
-		return -EINVAL;
-
-	if (port_ops == NULL || port_ops->set_pio_mode == NULL ||
-	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
-		return -ENOSYS;
-
-	if (set_pio_mode_abuse(drive->hwif, arg)) {
-		if (arg == 8 || arg == 9) {
-			unsigned long flags;
-
-			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
-			spin_lock_irqsave(&hwif->lock, flags);
-			port_ops->set_pio_mode(drive, arg);
-			spin_unlock_irqrestore(&hwif->lock, flags);
-		} else
-			port_ops->set_pio_mode(drive, arg);
-	} else {
-		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-
-		ide_set_pio(drive, arg);
-
-		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
-			if (keep_dma)
-				ide_dma_on(drive);
-		}
-	}
-
-	return 0;
-}
-
-ide_devset_get_flag(unmaskirq, IDE_DFLAG_UNMASK);
-
-static int set_unmaskirq(ide_drive_t *drive, int arg)
-{
-	if (drive->dev_flags & IDE_DFLAG_NO_UNMASK)
-		return -EPERM;
-
-	if (arg < 0 || arg > 1)
-		return -EINVAL;
-
-	if (arg)
-		drive->dev_flags |= IDE_DFLAG_UNMASK;
-	else
-		drive->dev_flags &= ~IDE_DFLAG_UNMASK;
-
-	return 0;
-}
-
-ide_ext_devset_rw_sync(io_32bit, io_32bit);
-ide_ext_devset_rw_sync(keepsettings, ksettings);
-ide_ext_devset_rw_sync(unmaskirq, unmaskirq);
-ide_ext_devset_rw_sync(using_dma, using_dma);
-__IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
-
 /**
  * ide_device_get	-	get an additional reference to a ide_drive_t
  * @drive:	device to get a reference to
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1168,6 +1168,7 @@ int ide_busy_sleep(ide_hwif_t *, unsigne
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
 ide_startstop_t ide_do_park_unpark(ide_drive_t *, struct request *);
+ide_startstop_t ide_do_devset(ide_drive_t *, struct request *);
 
 extern ide_startstop_t ide_do_reset (ide_drive_t *);
 
