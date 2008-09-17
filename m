Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbYIQQjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbYIQQjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYIQQiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:38:54 -0400
Received: from nebensachen.de ([195.34.83.29]:54540 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYIQQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:38:53 -0400
X-Hashcash: 1:20:080917:bzolnier@gmail.com::4nQH3o3C8DAhwKsi:00000000000000000000000000000000000000000001T9n
X-Hashcash: 1:20:080917:jeff@garzik.org::quaRbUCm2vWWFxsg:008VSa
X-Hashcash: 1:20:080917:randy.dunlap@oracle.com::6xNa20hbdjbpodRb:000000000000000000000000000000000000001g01
X-Hashcash: 1:20:080917:htejun@gmail.com::NWJC6A9TNbGV7fa2:00HzI
X-Hashcash: 1:20:080917:linux-ide@vger.kernel.org::XQ1at5+PZue2mBvC:0000000000000000000000000000000000003EcF
X-Hashcash: 1:20:080917:linux-kernel@vger.kernel.org::o4NG8RRzCrKAICYk:0000000000000000000000000000000002p8o
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 v2] ide: Implement disk shock protection support
In-Reply-To: <87d4j2n3dn.fsf@denkblock.local>
Message-ID: <20080917163144.9870.59732.stgit@denkblock.local>
References: <87d4j2n3dn.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 18:38:37 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
FEATURE as specified in ATA-7 is issued to the device and processing of
the request queue is stopped thereafter until the specified timeout
expires or user space asks to resume normal operation. This is supposed
to prevent the heads of a hard drive from accidentally crashing onto the
platter when a heavy shock is anticipated (like a falling laptop expected
to hit the floor). Port resets are deferred whenever a device on that
port is in the parked state.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ide/Makefile       |    2 -
 drivers/ide/ide-io.c       |   24 +++++++++
 drivers/ide/ide-iops.c     |   29 ++++++++++-
 drivers/ide/ide-park.c     |  118 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-probe.c    |    5 ++
 drivers/ide/ide-taskfile.c |   11 ++++
 drivers/ide/ide.c          |    1 
 include/linux/ide.h        |   13 +++++
 8 files changed, 199 insertions(+), 4 deletions(-)
 create mode 100644 drivers/ide/ide-park.c

diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 0c30adb..ceaf779 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -5,7 +5,7 @@
 EXTRA_CFLAGS				+= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
-	      ide-taskfile.o ide-pio-blacklist.o
+	      ide-taskfile.o ide-park.o ide-pio-blacklist.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index e205f46..09d10a5 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -672,7 +672,25 @@ EXPORT_SYMBOL_GPL(ide_devset_execute);
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t task;
+	struct ide_taskfile *tf = &task.tf;
+
+	memset(&task, 0, sizeof(task));
 	switch (rq->cmd[0]) {
+	case REQ_PARK_HEADS:
+		drive->sleep = *(unsigned long *)rq->special;
+		drive->dev_flags |= IDE_DFLAG_SLEEPING;
+		tf->command = ATA_CMD_IDLEIMMEDIATE;
+		tf->feature = 0x44;
+		tf->lbal = 0x4c;
+		tf->lbam = 0x4e;
+		tf->lbah = 0x55;
+		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		break;
+	case REQ_UNPARK_HEADS:
+		tf->command = ATA_CMD_CHK_POWER;
+		break;
 	case REQ_DEVSET_EXEC:
 	{
 		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
@@ -692,6 +710,10 @@ static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 		ide_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
+	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	task.rq = rq;
+	hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, &task);
 }
 
 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
@@ -1008,7 +1030,7 @@ static void ide_do_request (ide_hwgroup_t *hwgroup, int masked_irq)
 		}
 		hwgroup->hwif = hwif;
 		hwgroup->drive = drive;
-		drive->dev_flags &= ~IDE_DFLAG_SLEEPING;
+		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 		drive->service_start = jiffies;
 
 		if (blk_queue_plugged(drive->queue)) {
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 91182eb..7e7a1f0 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -1079,12 +1079,13 @@ static void pre_reset(ide_drive_t *drive)
 static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 {
 	unsigned int unit;
-	unsigned long flags;
+	unsigned long flags, timeout;
 	ide_hwif_t *hwif;
 	ide_hwgroup_t *hwgroup;
 	struct ide_io_ports *io_ports;
 	const struct ide_tp_ops *tp_ops;
 	const struct ide_port_ops *port_ops;
+	DEFINE_WAIT(wait);
 
 	spin_lock_irqsave(&ide_lock, flags);
 	hwif = HWIF(drive);
@@ -1111,6 +1112,32 @@ static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 		return ide_started;
 	}
 
+	/* We must not disturb devices in the IDE_DFLAG_PARKED state. */
+	do {
+		unsigned long now;
+		int i;
+
+		timeout = jiffies;
+		for (i = 0; i < MAX_DRIVES; i++) {
+			ide_drive_t *tdrive = &hwif->drives[i];
+
+			if (tdrive->dev_flags & IDE_DFLAG_PRESENT &&
+			    tdrive->dev_flags & IDE_DFLAG_PARKED &&
+			    time_after(tdrive->sleep, timeout))
+				timeout = tdrive->sleep;
+		}
+
+		now = jiffies;
+		if (time_before_eq(timeout, now))
+			break;
+
+		spin_unlock_irqrestore(&ide_lock, flags);
+		prepare_to_wait(&ide_park_wq, &wait, TASK_UNINTERRUPTIBLE);
+		timeout = schedule_timeout_uninterruptible(timeout - now);
+		spin_lock_irqsave(&ide_lock, flags);
+	} while (timeout);
+	finish_wait(&ide_park_wq, &wait);
+
 	/*
 	 * First, reset any device state data we were maintaining
 	 * for any of the drives on this interface.
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
new file mode 100644
index 0000000..35fc3ee
--- /dev/null
+++ b/drivers/ide/ide-park.c
@@ -0,0 +1,118 @@
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/jiffies.h>
+#include <linux/blkdev.h>
+
+DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
+
+static int issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
+{
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+	int rc;
+
+	timeout += jiffies;
+	spin_lock_irq(&ide_lock);
+	if (drive->dev_flags & IDE_DFLAG_PARKED) {
+		ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+		int reset_timer;
+
+		reset_timer = time_before(timeout, drive->sleep);
+		drive->sleep = timeout;
+		wake_up_all(&ide_park_wq);
+		if (reset_timer && hwgroup->sleeping &&
+		    del_timer(&hwgroup->timer)) {
+			hwgroup->sleeping = 0;
+			hwgroup->busy = 0;
+			__blk_run_queue(q);
+		}
+		spin_unlock_irq(&ide_lock);
+		return 0;
+	}
+	spin_unlock_irq(&ide_lock);
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	rq->cmd[0] = REQ_PARK_HEADS;
+	rq->cmd_len = 1;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->special = &timeout;
+	rc = blk_execute_rq(q, NULL, rq, 1);
+	if (rc)
+		goto out;
+
+	/*
+	 * Make sure that *some* command is sent to the drive after the
+	 * timeout has expired, so power management will be reenabled.
+	 */
+	rq = blk_get_request(q, READ, GFP_NOWAIT);
+	if (unlikely(!rq))
+		goto out;
+
+	rq->cmd[0] = REQ_UNPARK_HEADS;
+	rq->cmd_len = 1;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
+
+out:
+	return rc;
+}
+
+ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	unsigned int msecs;
+
+	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+		return -EOPNOTSUPP;
+
+	spin_lock_irq(&ide_lock);
+	if (drive->dev_flags & IDE_DFLAG_PARKED &&
+	    time_after(drive->sleep, jiffies))
+		msecs = jiffies_to_msecs(drive->sleep - jiffies);
+	else
+		msecs = 0;
+	spin_unlock_irq(&ide_lock);
+
+	return snprintf(buf, 20, "%u\n", msecs);
+}
+
+ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t len)
+{
+#define MAX_PARK_TIMEOUT 30000
+	ide_drive_t *drive = to_ide_device(dev);
+	long int input;
+	int rc;
+
+	rc = strict_strtol(buf, 10, &input);
+	if (rc || input < -2)
+		return -EINVAL;
+	if (input > MAX_PARK_TIMEOUT) {
+		input = MAX_PARK_TIMEOUT;
+		rc = -EOVERFLOW;
+	}
+
+	mutex_lock(&ide_setting_mtx);
+	if (input >= 0) {
+		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
+			rc = -EOPNOTSUPP;
+		else if (input || drive->dev_flags & IDE_DFLAG_PARKED)
+			issue_park_cmd(drive, msecs_to_jiffies(input));
+	} else {
+		if (drive->media == ide_disk)
+			switch (input) {
+			case -1:
+				drive->dev_flags &= ~IDE_DFLAG_NO_UNLOAD;
+				break;
+			case -2:
+				drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
+				break;
+			}
+		else
+			rc = -EOPNOTSUPP;
+	}
+	mutex_unlock(&ide_setting_mtx);
+
+	return rc ? rc : len;
+}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index f5cb55b..e1e0b7d 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -208,6 +208,8 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 		drive->ready_stat = 0;
 		if (ata_id_cdb_intr(id))
 			drive->atapi_flags |= IDE_AFLAG_DRQ_INTERRUPT;
+		/* we don't do head unloading on ATAPI devices */
+		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
 		return;
 	}
 
@@ -223,6 +225,9 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 
 	drive->media = ide_disk;
 
+	if (!ata_id_has_unload(drive->id))
+		drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
+
 	printk(KERN_CONT "%s DISK drive\n", is_cfa ? "CFA" : "ATA");
 
 	return;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a4c2d91..480c97f 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -152,7 +152,16 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 
 	if (!custom)
 		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
-	else if (tf->command == ATA_CMD_SET_MULTI)
+	else if (tf->command == ATA_CMD_IDLEIMMEDIATE) {
+		drive->hwif->tp_ops->tf_read(drive, task);
+		if (tf->lbal != 0xc4) {
+			printk(KERN_ERR "%s: head unload failed!\n",
+			       drive->name);
+			ide_tf_dump(drive->name, tf);
+		} else
+			drive->dev_flags |= IDE_DFLAG_PARKED;
+		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
+	} else if (tf->command == ATA_CMD_SET_MULTI)
 		drive->mult_count = drive->mult_req;
 
 	return ide_stopped;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 083783e..04f8f13 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -587,6 +587,7 @@ static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(model),
 	__ATTR_RO(firmware),
 	__ATTR(serial, 0400, serial_show, NULL),
+	__ATTR(unload_heads, 0644, ide_park_show, ide_park_store),
 	__ATTR_NULL
 };
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 1b0bf02..ddd8975 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -156,6 +156,8 @@ enum {
  */
 #define REQ_DRIVE_RESET		0x20
 #define REQ_DEVSET_EXEC		0x21
+#define REQ_PARK_HEADS		0x22
+#define REQ_UNPARK_HEADS	0x23
 
 /*
  * Check for an interrupt and acknowledge the interrupt status
@@ -571,6 +573,10 @@ enum {
 	/* retrying in PIO */
 	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 25),
 	IDE_DFLAG_LBA			= (1 << 26),
+	/* don't unload heads */
+	IDE_DFLAG_NO_UNLOAD		= (1 << 27),
+	/* heads unloaded, please don't reset port */
+	IDE_DFLAG_PARKED		= (1 << 28)
 };
 
 struct ide_drive_s {
@@ -1203,6 +1209,13 @@ int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
 
+/* Disk head parking */
+extern wait_queue_head_t ide_park_wq;
+ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
+		      char *buf);
+ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t len);
+
 /*
  * Special requests for ide-tape block device strategy routine.
  *


