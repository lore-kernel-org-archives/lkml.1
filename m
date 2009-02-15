Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZBOMLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZBOMLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZBOMIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:42 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:46201 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZBOMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uN25KSp1DOkd4zGPzx707oXry5v4aBbKeWOFPUwlop5yURs/2pNERa1nr8GxF+iupI
         7qqZvZEwjkusxBpIWnvKOtMvR3au8Jc1tdKoPgN29ahUiAz2KmfctnVZkhBXcrour6+a
         5LXBGx2cdXV04xRWYIshZGh0Zfw/Ma6vHqfXU=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 10/10] ide: use flags query macros in the remaining ide code
Date: Sun, 15 Feb 2009 13:08:12 +0100
Message-Id: <1234699692-9452-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, remove some commented out sneaked in printk's.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/cmd640.c       |    2 +-
 drivers/ide/ht6560b.c      |    3 +--
 drivers/ide/ide-disk.c     |    4 ++--
 drivers/ide/ide-dma.c      |    3 +--
 drivers/ide/ide-gd.c       |   14 +++++++-------
 drivers/ide/ide-io.c       |    9 ++++-----
 drivers/ide/ide-ioctls.c   |    6 +++---
 drivers/ide/ide-iops.c     |    6 +++---
 drivers/ide/ide-lib.c      |    2 +-
 drivers/ide/ide-park.c     |   11 +++++------
 drivers/ide/ide-pm.c       |    2 +-
 drivers/ide/ide-probe.c    |    2 +-
 drivers/ide/ide-proc.c     |    2 +-
 drivers/ide/ide-taskfile.c |   16 ++++++----------
 drivers/ide/ns87415.c      |    5 ++---
 drivers/ide/pdc202xx_old.c |    4 ++--
 drivers/ide/sc1200.c       |    2 +-
 drivers/ide/trm290.c       |    4 ++--
 18 files changed, 44 insertions(+), 53 deletions(-)

diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
index 8890276..f2d550f 100644
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -625,7 +625,7 @@ static void cmd640_init_dev(ide_drive_t *drive)
 	 */
 	check_prefetch(drive, i);
 	printk(KERN_INFO DRV_NAME ": drive%d timings/prefetch(%s) preserved\n",
-		i, (drive->dev_flags & IDE_DFLAG_NO_IO_32BIT) ? "off" : "on");
+		i, ide_drv_no_32bit_io(drive) ? "off" : "on");
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 }
 
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
index c7e5c22..08caa4d 100644
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -120,8 +120,7 @@ static void ht6560b_selectproc (ide_drive_t *drive)
 	 * Need to enforce prefetch sometimes because otherwise
 	 * it'll hang (hard).
 	 */
-	if (drive->media != ide_disk ||
-	    (drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if (drive->media != ide_disk || !ide_drv_present(drive))
 		select |= HT_PREFETCH_MODE;
 
 	if (select != current_select || timing != current_timing) {
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 011cdb3..a4a5ad0 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -83,8 +83,8 @@ static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 {
 	ide_hwif_t *hwif	= drive->hwif;
 	u16 nsectors		= (u16)rq->nr_sectors;
-	u8 lba48		= !!(drive->dev_flags & IDE_DFLAG_LBA48);
-	u8 dma			= !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+	u8 lba48		= !!ide_drv_lba48(drive);
+	u8 dma			= !!ide_drv_using_dma(drive);
 	struct ide_cmd		cmd;
 	struct ide_taskfile	*tf = &cmd.tf;
 	ide_startstop_t		rc;
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index b4fa861..c7beaa0 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -349,8 +349,7 @@ static int ide_tune_dma(ide_drive_t *drive)
 	ide_hwif_t *hwif = drive->hwif;
 	u8 speed;
 
-	if (ata_id_has_dma(drive->id) == 0 ||
-	    (drive->dev_flags & IDE_DFLAG_NODMA))
+	if (ata_id_has_dma(drive->id) == 0 || ide_drv_nodma(drive))
 		return 0;
 
 	/* consult the list of known "bad" drives */
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index d0573aa..c9a22fe 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -179,7 +179,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 
 	idkp->openers++;
 
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+	if (ide_drv_removable(drive) && idkp->openers == 1) {
 		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
 		/* Just in case */
 
@@ -195,7 +195,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 			goto out_put_idkp;
 		}
 
-		if ((drive->dev_flags & IDE_DFLAG_WP) && (mode & FMODE_WRITE)) {
+		if (ide_drv_write_protected(drive) && (mode & FMODE_WRITE)) {
 			ret = -EROFS;
 			goto out_put_idkp;
 		}
@@ -208,7 +208,7 @@ static int ide_gd_open(struct block_device *bdev, fmode_t mode)
 		drive->disk_ops->set_doorlock(drive, disk, 1);
 		drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 		check_disk_change(bdev);
-	} else if (drive->dev_flags & IDE_DFLAG_FORMAT_IN_PROGRESS) {
+	} else if (ide_drv_format_in_progress(drive)) {
 		ret = -EBUSY;
 		goto out_put_idkp;
 	}
@@ -230,7 +230,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 	if (idkp->openers == 1)
 		drive->disk_ops->flush(drive);
 
-	if ((drive->dev_flags & IDE_DFLAG_REMOVABLE) && idkp->openers == 1) {
+	if (ide_drv_removable(drive) && idkp->openers == 1) {
 		drive->disk_ops->set_doorlock(drive, disk, 0);
 		drive->dev_flags &= ~IDE_DFLAG_FORMAT_IN_PROGRESS;
 	}
@@ -260,12 +260,12 @@ static int ide_gd_media_changed(struct gendisk *disk)
 	int ret;
 
 	/* do not scan partitions twice if this is a removable device */
-	if (drive->dev_flags & IDE_DFLAG_ATTACH) {
+	if (ide_drv_attach(drive)) {
 		drive->dev_flags &= ~IDE_DFLAG_ATTACH;
 		return 0;
 	}
 
-	ret = !!(drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED);
+	ret = !!ide_drv_media_changed(drive);
 	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 
 	return ret;
@@ -361,7 +361,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 	g->minors = IDE_DISK_MINORS;
 	g->driverfs_dev = &drive->gendev;
 	g->flags |= GENHD_FL_EXT_DEVT;
-	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
+	if (ide_drv_removable(drive))
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
 	add_disk(g);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 481fb1b..14c26f3 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -61,8 +61,7 @@ int ide_end_rq(ide_drive_t *drive, struct request *rq, int error,
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
 	 * if we DMA timeout more than 3 times, just stay in PIO
 	 */
-	if ((drive->dev_flags & IDE_DFLAG_DMA_PIO_RETRY) &&
-	    drive->retry_pio <= 3) {
+	if (ide_drv_dma_retry_pio(drive) && drive->retry_pio <= 3) {
 		drive->dev_flags &= ~IDE_DFLAG_DMA_PIO_RETRY;
 		ide_dma_on(drive);
 	}
@@ -481,7 +480,7 @@ repeat:
 		prev_port = hwif->host->cur_port;
 		hwif->rq = NULL;
 
-		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
+		if (ide_drv_sleeping(drive)) {
 			if (time_before(drive->sleep, jiffies)) {
 				ide_unlock_port(hwif);
 				goto plug_device;
@@ -530,7 +529,7 @@ repeat:
 		 * unless the subdriver triggers such a thing in its own PM
 		 * state machine.
 		 */
-		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
+		if (ide_drv_blocked(drive) &&
 		    blk_pm_request(rq) == 0 &&
 		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			/* there should be no pending command at this point */
@@ -839,7 +838,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	if (hwif->port_ops && hwif->port_ops->clear_irq)
 		hwif->port_ops->clear_irq(drive);
 
-	if (drive->dev_flags & IDE_DFLAG_UNMASK)
+	if (ide_drv_unmask_irqs(drive))
 		local_irq_enable_in_hardirq();
 
 	/* service this interrupt, may set handler for next interrupt */
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 7701427..741dd44 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -59,7 +59,7 @@ static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
 	int size = (cmd == HDIO_GET_IDENTITY) ? (ATA_ID_WORDS * 2) : 142;
 	int rc = 0;
 
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
+	if (!ide_drv_id_read(drive)) {
 		rc = -ENOMSG;
 		goto out;
 	}
@@ -83,9 +83,9 @@ out:
 
 static int ide_get_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 {
-	return put_user((!!(drive->dev_flags & IDE_DFLAG_DSC_OVERLAP)
+	return put_user((!!ide_drv_dsc_overlap(drive)
 			 << IDE_NICE_DSC_OVERLAP) |
-			(!!(drive->dev_flags & IDE_DFLAG_NICE1)
+			(!!ide_drv_nice1(drive)
 			 << IDE_NICE_1), (long __user *)arg);
 }
 
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index bdfd78d..dc9f456 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -274,7 +274,7 @@ u8 eighty_ninty_three(ide_drive_t *drive)
 		return 1;
 
 no_80w:
-	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
+	if (ide_drv_udma33_warned(drive))
 		return 0;
 
 	printk(KERN_WARNING "%s: %s side 80-wire cable detection failed, "
@@ -310,7 +310,7 @@ int ide_driveid_update(ide_drive_t *drive)
 
 	kfree(id);
 
-	if ((drive->dev_flags & IDE_DFLAG_USING_DMA) && ide_id_dma_bug(drive))
+	if (ide_drv_using_dma(drive) && ide_id_dma_bug(drive))
 		ide_dma_off(drive);
 
 	return 1;
@@ -392,7 +392,7 @@ int ide_config_drive_speed(ide_drive_t *drive, u8 speed)
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (speed >= XFER_SW_DMA_0 && (drive->dev_flags & IDE_DFLAG_USING_DMA))
+	if (speed >= XFER_SW_DMA_0 && ide_drv_using_dma(drive))
 		hwif->dma_ops->dma_host_set(drive, 1);
 	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 217b7fd..349ef5e 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -68,7 +68,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 {
 	struct ide_cmd cmd;
 	struct ide_taskfile *tf = &cmd.tf;
-	u8 lba48 = !!(drive->dev_flags & IDE_DFLAG_LBA48);
+	u8 lba48 = !!ide_drv_lba48(drive);
 
 	memset(&cmd, 0, sizeof(cmd));
 	if (lba48)
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 9490b44..15d8ce3 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -14,7 +14,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 
 	timeout += jiffies;
 	spin_lock_irq(&hwif->lock);
-	if (drive->dev_flags & IDE_DFLAG_PARKED) {
+	if (ide_drv_heads_parked(drive)) {
 		int reset_timer = time_before(timeout, drive->sleep);
 		int start_queue = 0;
 
@@ -94,13 +94,12 @@ ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
 	unsigned long now;
 	unsigned int msecs;
 
-	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+	if (ide_drv_no_unload_feature(drive))
 		return -EOPNOTSUPP;
 
 	spin_lock_irq(&hwif->lock);
 	now = jiffies;
-	if (drive->dev_flags & IDE_DFLAG_PARKED &&
-	    time_after(drive->sleep, now))
+	if (ide_drv_heads_parked(drive) && time_after(drive->sleep, now))
 		msecs = jiffies_to_msecs(drive->sleep - now);
 	else
 		msecs = 0;
@@ -127,9 +126,9 @@ ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&ide_setting_mtx);
 	if (input >= 0) {
-		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+		if (ide_drv_no_unload_feature(drive))
 			rc = -EOPNOTSUPP;
-		else if (input || drive->dev_flags & IDE_DFLAG_PARKED)
+		else if (input || ide_drv_heads_parked(drive))
 			issue_park_cmd(drive, msecs_to_jiffies(input));
 	} else {
 		if (drive->media == ide_disk)
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index ebf2d21..1aad932 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -118,7 +118,7 @@ ide_startstop_t ide_start_power_step(ide_drive_t *drive, struct request *rq)
 			break;
 		/* Not supported? Switch to next step now. */
 		if (ata_id_flush_enabled(drive->id) == 0 ||
-		    (drive->dev_flags & IDE_DFLAG_WCACHE) == 0) {
+		    !ide_drv_wcache_enabled(drive)) {
 			ide_complete_power_step(drive, rq);
 			return ide_stopped;
 		}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 5e8c6be..8af9e7f 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -374,7 +374,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u16 *id = drive->id;
 	int rc;
-	u8 present = !!(drive->dev_flags & IDE_DFLAG_PRESENT), stat;
+	u8 present = !!ide_drv_present(drive), stat;
 
 	/* avoid waiting for inappropriate probes */
 	if (present && drive->media != ide_disk && cmd == ATA_CMD_ID_ATA)
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 0ee8887..f172243 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -600,7 +600,7 @@ void ide_proc_port_register_devices(ide_hwif_t *hwif)
 	int i;
 
 	ide_port_for_each_dev(i, drive, hwif) {
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+		if (!ide_drv_present(drive))
 			continue;
 
 		drive->proc = proc_mkdir(drive->name, parent);
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 629df3d..9bb933c 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -100,7 +100,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 		ide_execute_command(drive, cmd, handler, WAIT_WORSTCASE);
 		return ide_started;
 	case ATA_PROT_DMA:
-		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
+		if (!ide_drv_using_dma(drive) ||
 		    ide_build_sglist(drive, cmd) == 0 ||
 		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
@@ -370,11 +370,11 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 			drive->name,
 			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
-			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
+			ide_drv_lba48(drive) ? "_EXT" : "");
 		return startstop;
 	}
 
-	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
+	if (!ide_drv_unmask_irqs(drive))
 		local_irq_disable();
 
 	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
@@ -440,8 +440,6 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	u16 nsect		= 0;
 	char __user *buf = (char __user *)arg;
 
-//	printk("IDE Taskfile ...\n");
-
 	req_task = kzalloc(tasksize, GFP_KERNEL);
 	if (req_task == NULL) return -ENOMEM;
 	if (copy_from_user(req_task, buf, tasksize)) {
@@ -451,7 +449,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	taskout = req_task->out_size;
 	taskin  = req_task->in_size;
-	
+
 	if (taskin > 65536 || taskout > 65536) {
 		err = -EINVAL;
 		goto abort;
@@ -493,7 +491,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	cmd.tf_flags   = IDE_TFLAG_IO_16BIT | IDE_TFLAG_DEVICE |
 			 IDE_TFLAG_IN_TF;
 
-	if (drive->dev_flags & IDE_DFLAG_LBA48)
+	if (ide_drv_lba48(drive))
 		cmd.tf_flags |= (IDE_TFLAG_LBA48 | IDE_TFLAG_IN_HOB);
 
 	if (req_task->out_flags.all) {
@@ -610,7 +608,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	if ((cmd.ftf_flags & IDE_FTFLAG_SET_IN_FLAGS) &&
 	    req_task->in_flags.all == 0) {
 		req_task->in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
-		if (drive->dev_flags & IDE_DFLAG_LBA48)
+		if (ide_drv_lba48(drive))
 			req_task->in_flags.all |= (IDE_HOB_STD_IN_FLAGS << 8);
 	}
 
@@ -637,8 +635,6 @@ abort:
 	kfree(outbuf);
 	kfree(inbuf);
 
-//	printk("IDE Taskfile ioctl ended. rc = %i\n", err);
-
 	return err;
 }
 #endif
diff --git a/drivers/ide/ns87415.c b/drivers/ide/ns87415.c
index 4077d2d..bebb646 100644
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -155,7 +155,7 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	/* Adjust IRQ enable bit */
 	bit = 1 << (8 + hwif->channel);
 
-	if (drive->dev_flags & IDE_DFLAG_PRESENT)
+	if (ide_drv_present(drive))
 		new &= ~bit;
 	else
 		new |= bit;
@@ -192,8 +192,7 @@ static void ns87415_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 static void ns87415_selectproc (ide_drive_t *drive)
 {
-	ns87415_prepare_drive(drive,
-			      !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
+	ns87415_prepare_drive(drive, !!ide_drv_using_dma(drive));
 }
 
 static int ns87415_dma_end(ide_drive_t *drive)
diff --git a/drivers/ide/pdc202xx_old.c b/drivers/ide/pdc202xx_old.c
index 2fd037b..cd82464 100644
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -168,7 +168,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 {
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
-	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
+	if (drive->media != ide_disk || ide_drv_lba48(drive)) {
 		ide_hwif_t *hwif	= drive->hwif;
 		struct request *rq	= hwif->rq;
 		unsigned long high_16	= hwif->extra_base - 16;
@@ -188,7 +188,7 @@ static void pdc202xx_dma_start(ide_drive_t *drive)
 
 static int pdc202xx_dma_end(ide_drive_t *drive)
 {
-	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
+	if (drive->media != ide_disk || ide_drv_lba48(drive)) {
 		ide_hwif_t *hwif	= drive->hwif;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
diff --git a/drivers/ide/sc1200.c b/drivers/ide/sc1200.c
index 9a43e91..83b1131 100644
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -217,7 +217,7 @@ static void sc1200_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		printk("SC1200: %s: changing (U)DMA mode\n", drive->name);
 		ide_dma_off_quietly(drive);
 		if (ide_set_dma_mode(drive, mode) == 0 &&
-		    (drive->dev_flags & IDE_DFLAG_USING_DMA))
+		    ide_drv_using_dma(drive))
 			hwif->dma_ops->dma_host_set(drive, 1);
 		return;
 	}
diff --git a/drivers/ide/trm290.c b/drivers/ide/trm290.c
index ed14968..90425a9 100644
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -161,7 +161,7 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 	}
 
 	/* enable IRQ if not probing */
-	if (drive->dev_flags & IDE_DFLAG_PRESENT) {
+	if (ide_drv_present(drive)) {
 		reg = inw(hwif->config_data + 3);
 		reg &= 0x13;
 		reg &= ~(1 << hwif->channel);
@@ -173,7 +173,7 @@ static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 
 static void trm290_selectproc (ide_drive_t *drive)
 {
-	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
+	trm290_prepare_drive(drive, !!ide_drv_using_dma(drive));
 }
 
 static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
-- 
1.6.0.4

