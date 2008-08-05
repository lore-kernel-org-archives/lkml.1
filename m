Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbYHEQns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbYHEQns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 12:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760447AbYHEQnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 12:43:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:46473 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762647AbYHEQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 12:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YwWarFCNod356+EdQ8f6d7FWBq0oiN+vmohE2Vqcc3iTMXtebqXqTAYCHqZnjGu4SN
         v4vapuOYdAAkX/U4DjxMzRJlFF8LVemlnGOkiTx6cBvtROBWzVHZNiTPAJogjuO2AqIC
         PdBCbqBXLfqUa5yKWHbDyo/m1F/HylhVbKb0I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 05 Aug 2008 18:40:41 +0200
Message-Id: <20080805164041.17094.59318.sendpatchset@localhost.localdomain>
In-Reply-To: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
References: <20080805164022.17094.27615.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/4] ide: move ioctls handling to ide-ioctls.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move ioctls handling to ide-ioctls.c
  (except HDIO_DRIVE_TASKFILE for now).

* Make ide_{cmd,task}() static.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile       |    4 
 drivers/ide/ide-ioctls.c   |  289 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-taskfile.c |  109 ----------------
 drivers/ide/ide.c          |  174 ---------------------------
 include/linux/ide.h        |    2 
 5 files changed, 291 insertions(+), 287 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -4,8 +4,8 @@
 
 EXTRA_CFLAGS				+= -Idrivers/ide
 
-ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o \
-	      ide-pio-blacklist.o
+ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
+	      ide-taskfile.o ide-pio-blacklist.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
Index: b/drivers/ide/ide-ioctls.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-ioctls.c
@@ -0,0 +1,289 @@
+/*
+ * IDE ioctls handling.
+ */
+
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+
+static const struct ide_ioctl_devset ide_ioctl_settings[] = {
+{ HDIO_GET_32BIT,	 HDIO_SET_32BIT,	get_io_32bit,  set_io_32bit  },
+{ HDIO_GET_KEEPSETTINGS, HDIO_SET_KEEPSETTINGS,	get_ksettings, set_ksettings },
+{ HDIO_GET_UNMASKINTR,	 HDIO_SET_UNMASKINTR,	get_unmaskirq, set_unmaskirq },
+{ HDIO_GET_DMA,		 HDIO_SET_DMA,		get_using_dma, set_using_dma },
+{ -1,			 HDIO_SET_PIO_MODE,	NULL,	       set_pio_mode  },
+{ 0 }
+};
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
+
+read_val:
+	mutex_lock(&ide_setting_mtx);
+	spin_lock_irqsave(&ide_lock, flags);
+	err = s->get(drive);
+	spin_unlock_irqrestore(&ide_lock, flags);
+	mutex_unlock(&ide_setting_mtx);
+	return err >= 0 ? put_user(err, (long __user *)arg) : err;
+
+set_val:
+	if (bdev != bdev->bd_contains)
+		err = -EINVAL;
+	else {
+		if (!capable(CAP_SYS_ADMIN))
+			err = -EACCES;
+		else {
+			mutex_lock(&ide_setting_mtx);
+			err = s->set(drive, arg);
+			mutex_unlock(&ide_setting_mtx);
+		}
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(ide_setting_ioctl);
+
+static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
+				  unsigned long arg)
+{
+	u16 *id = NULL;
+	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
+	int rc = 0;
+
+	if (drive->id_read == 0) {
+		rc = -ENOMSG;
+		goto out;
+	}
+
+	id = kmalloc(size, GFP_KERNEL);
+	if (id == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(id, drive->id, size);
+	ata_id_to_hd_driveid(id);
+
+	if (copy_to_user((void __user *)arg, id, size))
+		rc = -EFAULT;
+
+	kfree(id);
+out:
+	return rc;
+}
+
+static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
+{
+	return put_user((drive->dsc_overlap << IDE_NICE_DSC_OVERLAP) |
+			(drive->nice1 << IDE_NICE_1), (long __user *)arg);
+}
+
+static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
+{
+	if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
+		return -EPERM;
+
+	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
+	    (drive->media == ide_disk || drive->media == ide_floppy ||
+	     drive->scsi))
+		return -EPERM;
+
+	drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
+	drive->nice1 = (arg >> IDE_NICE_1) & 1;
+
+	return 0;
+}
+
+static int ide_cmd_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+{
+	u8 *buf = NULL;
+	int bufsize = 0, err = 0;
+	u8 args[4], xfer_rate = 0;
+	ide_task_t tfargs;
+	struct ide_taskfile *tf = &tfargs.tf;
+	u16 *id = drive->id;
+
+	if (NULL == (void *) arg) {
+		struct request *rq;
+
+		rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+		err = blk_execute_rq(drive->queue, NULL, rq, 0);
+		blk_put_request(rq);
+
+		return err;
+	}
+
+	if (copy_from_user(args, (void __user *)arg, 4))
+		return -EFAULT;
+
+	memset(&tfargs, 0, sizeof(ide_task_t));
+	tf->feature = args[2];
+	if (args[0] == ATA_CMD_SMART) {
+		tf->nsect = args[3];
+		tf->lbal  = args[1];
+		tf->lbam  = 0x4f;
+		tf->lbah  = 0xc2;
+		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+	} else {
+		tf->nsect = args[1];
+		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
+				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
+	}
+	tf->command = args[0];
+	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
+
+	if (args[3]) {
+		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
+		bufsize = SECTOR_SIZE * args[3];
+		buf = kzalloc(bufsize, GFP_KERNEL);
+		if (buf == NULL)
+			return -ENOMEM;
+	}
+
+	if (tf->command == ATA_CMD_SET_FEATURES &&
+	    tf->feature == SETFEATURES_XFER &&
+	    tf->nsect >= XFER_SW_DMA_0 &&
+	    (id[ATA_ID_UDMA_MODES] ||
+	     id[ATA_ID_MWDMA_MODES] ||
+	     id[ATA_ID_SWDMA_MODES])) {
+		xfer_rate = args[1];
+		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
+			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
+					    "be set\n", drive->name);
+			goto abort;
+		}
+	}
+
+	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
+
+	args[0] = tf->status;
+	args[1] = tf->error;
+	args[2] = tf->nsect;
+
+	if (!err && xfer_rate) {
+		/* active-retuning-calls future */
+		ide_set_xfer_rate(drive, xfer_rate);
+		ide_driveid_update(drive);
+	}
+abort:
+	if (copy_to_user((void __user *)arg, &args, 4))
+		err = -EFAULT;
+	if (buf) {
+		if (copy_to_user((void __user *)(arg + 4), buf, bufsize))
+			err = -EFAULT;
+		kfree(buf);
+	}
+	return err;
+}
+
+static int ide_task_ioctl(ide_drive_t *drive, unsigned cmd, unsigned long arg)
+{
+	void __user *p = (void __user *)arg;
+	int err = 0;
+	u8 args[7];
+	ide_task_t task;
+
+	if (copy_from_user(args, p, 7))
+		return -EFAULT;
+
+	memset(&task, 0, sizeof(task));
+	memcpy(&task.tf_array[7], &args[1], 6);
+	task.tf.command = args[0];
+	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+	err = ide_no_data_taskfile(drive, &task);
+
+	args[0] = task.tf.command;
+	memcpy(&args[1], &task.tf_array[7], 6);
+
+	if (copy_to_user(p, args, 7))
+		err = -EFAULT;
+
+	return err;
+}
+
+static int generic_drive_reset(ide_drive_t *drive)
+{
+	struct request *rq;
+	int ret = 0;
+
+	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_len = 1;
+	rq->cmd[0] = REQ_DRIVE_RESET;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
+	if (blk_execute_rq(drive->queue, NULL, rq, 1))
+		ret = rq->errors;
+	blk_put_request(rq);
+	return ret;
+}
+
+int generic_ide_ioctl(ide_drive_t *drive, struct file *file,
+		      struct block_device *bdev,
+		      unsigned int cmd, unsigned long arg)
+{
+	int err;
+
+	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_ioctl_settings);
+	if (err != -EOPNOTSUPP)
+		return err;
+
+	switch (cmd) {
+	case HDIO_OBSOLETE_IDENTITY:
+	case HDIO_GET_IDENTITY:
+		if (bdev != bdev->bd_contains)
+			return -EINVAL;
+		return ide_get_identity_ioctl(drive, cmd, arg);
+	case HDIO_GET_NICE:
+		return ide_get_nice_ioctl(drive, arg);
+	case HDIO_SET_NICE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return ide_set_nice_ioctl(drive, arg);
+#ifdef CONFIG_IDE_TASK_IOCTL
+	case HDIO_DRIVE_TASKFILE:
+		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		if (drive->media == ide_disk)
+			return ide_taskfile_ioctl(drive, cmd, arg);
+		return -ENOMSG;
+#endif
+	case HDIO_DRIVE_CMD:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return ide_cmd_ioctl(drive, cmd, arg);
+	case HDIO_DRIVE_TASK:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EACCES;
+		return ide_task_ioctl(drive, cmd, arg);
+	case HDIO_DRIVE_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return generic_drive_reset(drive);
+	case HDIO_GET_BUSSTATE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		if (put_user(BUSSTATE_ON, (long __user *)arg))
+			return -EFAULT;
+		return 0;
+	case HDIO_SET_BUSSTATE:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		return -EOPNOTSUPP;
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL(generic_ide_ioctl);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -726,112 +726,3 @@ abort:
 	return err;
 }
 #endif
-
-int ide_cmd_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
-{
-	u8 *buf = NULL;
-	int bufsize = 0, err = 0;
-	u8 args[4], xfer_rate = 0;
-	ide_task_t tfargs;
-	struct ide_taskfile *tf = &tfargs.tf;
-	u16 *id = drive->id;
-
-	if (NULL == (void *) arg) {
-		struct request *rq;
-
-		rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-		rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-		err = blk_execute_rq(drive->queue, NULL, rq, 0);
-		blk_put_request(rq);
-
-		return err;
-	}
-
-	if (copy_from_user(args, (void __user *)arg, 4))
-		return -EFAULT;
-
-	memset(&tfargs, 0, sizeof(ide_task_t));
-	tf->feature = args[2];
-	if (args[0] == ATA_CMD_SMART) {
-		tf->nsect = args[3];
-		tf->lbal  = args[1];
-		tf->lbam  = 0x4f;
-		tf->lbah  = 0xc2;
-		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
-	} else {
-		tf->nsect = args[1];
-		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
-				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
-	}
-	tf->command = args[0];
-	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
-
-	if (args[3]) {
-		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
-		bufsize = SECTOR_SIZE * args[3];
-		buf = kzalloc(bufsize, GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
-	}
-
-	if (tf->command == ATA_CMD_SET_FEATURES &&
-	    tf->feature == SETFEATURES_XFER &&
-	    tf->nsect >= XFER_SW_DMA_0 &&
-	    (id[ATA_ID_UDMA_MODES] ||
-	     id[ATA_ID_MWDMA_MODES] ||
-	     id[ATA_ID_SWDMA_MODES])) {
-		xfer_rate = args[1];
-		if (tf->nsect > XFER_UDMA_2 && !eighty_ninty_three(drive)) {
-			printk(KERN_WARNING "%s: UDMA speeds >UDMA33 cannot "
-					    "be set\n", drive->name);
-			goto abort;
-		}
-	}
-
-	err = ide_raw_taskfile(drive, &tfargs, buf, args[3]);
-
-	args[0] = tf->status;
-	args[1] = tf->error;
-	args[2] = tf->nsect;
-
-	if (!err && xfer_rate) {
-		/* active-retuning-calls future */
-		ide_set_xfer_rate(drive, xfer_rate);
-		ide_driveid_update(drive);
-	}
-abort:
-	if (copy_to_user((void __user *)arg, &args, 4))
-		err = -EFAULT;
-	if (buf) {
-		if (copy_to_user((void __user *)(arg + 4), buf, bufsize))
-			err = -EFAULT;
-		kfree(buf);
-	}
-	return err;
-}
-
-int ide_task_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
-{
-	void __user *p = (void __user *)arg;
-	int err = 0;
-	u8 args[7];
-	ide_task_t task;
-
-	if (copy_from_user(args, p, 7))
-		return -EFAULT;
-
-	memset(&task, 0, sizeof(task));
-	memcpy(&task.tf_array[7], &args[1], 6);
-	task.tf.command = args[0];
-	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-
-	err = ide_no_data_taskfile(drive, &task);
-
-	args[0] = task.tf.command;
-	memcpy(&args[1], &task.tf_array[7], 6);
-
-	if (copy_to_user(p, args, 7))
-		err = -EFAULT;
-
-	return err;
-}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -489,180 +489,6 @@ static int generic_ide_resume(struct dev
 	return err;
 }
 
-static int generic_drive_reset(ide_drive_t *drive)
-{
-	struct request *rq;
-	int ret = 0;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_len = 1;
-	rq->cmd[0] = REQ_DRIVE_RESET;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
-	if (blk_execute_rq(drive->queue, NULL, rq, 1))
-		ret = rq->errors;
-	blk_put_request(rq);
-	return ret;
-}
-
-static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
-				  unsigned long arg)
-{
-	u16 *id = NULL;
-	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
-	int rc = 0;
-
-	if (drive->id_read == 0) {
-		rc = -ENOMSG;
-		goto out;
-	}
-
-	id = kmalloc(size, GFP_KERNEL);
-	if (id == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(id, drive->id, size);
-	ata_id_to_hd_driveid(id);
-
-	if (copy_to_user((void __user *)arg, id, size))
-		rc = -EFAULT;
-
-	kfree(id);
-out:
-	return rc;
-}
-
-static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
-{
-	return put_user((drive->dsc_overlap << IDE_NICE_DSC_OVERLAP) |
-			(drive->nice1 << IDE_NICE_1), (long __user *)arg);
-}
-
-static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
-{
-	if (arg != (arg & ((1 << IDE_NICE_DSC_OVERLAP) | (1 << IDE_NICE_1))))
-		return -EPERM;
-
-	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
-	    (drive->media == ide_disk || drive->media == ide_floppy ||
-	     drive->scsi))
-		return -EPERM;
-
-	drive->dsc_overlap = (arg >> IDE_NICE_DSC_OVERLAP) & 1;
-	drive->nice1 = (arg >> IDE_NICE_1) & 1;
-
-	return 0;
-}
-
-static const struct ide_ioctl_devset ide_ioctl_settings[] = {
-{ HDIO_GET_32BIT,	 HDIO_SET_32BIT,	get_io_32bit,  set_io_32bit  },
-{ HDIO_GET_KEEPSETTINGS, HDIO_SET_KEEPSETTINGS,	get_ksettings, set_ksettings },
-{ HDIO_GET_UNMASKINTR,	 HDIO_SET_UNMASKINTR,	get_unmaskirq, set_unmaskirq },
-{ HDIO_GET_DMA,		 HDIO_SET_DMA,		get_using_dma, set_using_dma },
-{ -1,			 HDIO_SET_PIO_MODE,	NULL,	       set_pio_mode  },
-{ 0 }
-};
-
-int generic_ide_ioctl(ide_drive_t *drive, struct file *file,
-		      struct block_device *bdev,
-		      unsigned int cmd, unsigned long arg)
-{
-	int err;
-
-	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_ioctl_settings);
-	if (err != -EOPNOTSUPP)
-		return err;
-
-	switch (cmd) {
-	case HDIO_OBSOLETE_IDENTITY:
-	case HDIO_GET_IDENTITY:
-		if (bdev != bdev->bd_contains)
-			return -EINVAL;
-		return ide_get_identity_ioctl(drive, cmd, arg);
-	case HDIO_GET_NICE:
-		return ide_get_nice_ioctl(drive, arg);
-	case HDIO_SET_NICE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		return ide_set_nice_ioctl(drive, arg);
-#ifdef CONFIG_IDE_TASK_IOCTL
-	case HDIO_DRIVE_TASKFILE:
-		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		if (drive->media == ide_disk)
-			return ide_taskfile_ioctl(drive, cmd, arg);
-		return -ENOMSG;
-#endif
-	case HDIO_DRIVE_CMD:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return ide_cmd_ioctl(drive, cmd, arg);
-	case HDIO_DRIVE_TASK:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EACCES;
-		return ide_task_ioctl(drive, cmd, arg);
-	case HDIO_DRIVE_RESET:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		return generic_drive_reset(drive);
-	case HDIO_GET_BUSSTATE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		if (put_user(BUSSTATE_ON, (long __user *)arg))
-			return -EFAULT;
-		return 0;
-	case HDIO_SET_BUSSTATE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		return -EOPNOTSUPP;
-	default:
-		return -EINVAL;
-	}
-}
-EXPORT_SYMBOL(generic_ide_ioctl);
-
-int ide_setting_ioctl(ide_drive_t *drive, struct block_device *bdev,
-		      unsigned int cmd, unsigned long arg,
-		      const struct ide_ioctl_devset *s)
-{
-	unsigned long flags;
-	int err = -EOPNOTSUPP;
-
-	for (; s->get_ioctl; s++) {
-		if (s->get && s->get_ioctl == cmd)
-			goto read_val;
-		else if (s->set && s->set_ioctl == cmd)
-			goto set_val;
-	}
-
-	return err;
-
-read_val:
-	mutex_lock(&ide_setting_mtx);
-	spin_lock_irqsave(&ide_lock, flags);
-	err = s->get(drive);
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
-			err = s->set(drive, arg);
-			mutex_unlock(&ide_setting_mtx);
-		}
-	}
-	return err;
-}
-EXPORT_SYMBOL_GPL(ide_setting_ioctl);
-
 /**
  * ide_device_get	-	get an additional reference to a ide_drive_t
  * @drive:	device to get a reference to
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1126,8 +1126,6 @@ int ide_raw_taskfile(ide_drive_t *, ide_
 int ide_no_data_taskfile(ide_drive_t *, ide_task_t *);
 
 int ide_taskfile_ioctl(ide_drive_t *, unsigned int, unsigned long);
-int ide_cmd_ioctl(ide_drive_t *, unsigned int, unsigned long);
-int ide_task_ioctl(ide_drive_t *, unsigned int, unsigned long);
 
 extern int ide_driveid_update(ide_drive_t *);
 extern int ide_config_drive_speed(ide_drive_t *, u8);
