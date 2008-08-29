Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYH2V1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYH2V1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbYH2V1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:27:33 -0400
Received: from nebensachen.de ([195.34.83.29]:55067 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbYH2V1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:27:31 -0400
X-Hashcash: 1:20:080829:alan@lxorguk.ukuu.org.uk::Wa2Ja1HAO3kRBTj/:00000000000000000000000000000000000000kWu
X-Hashcash: 1:20:080829:akpm@linux-foundation.org::Y6riopH/0X60GLMg:0000000000000000000000000000000000000INK
X-Hashcash: 1:20:080829:bzolnier@gmail.com::zY9IuEikbwv0IHyD:00000000000000000000000000000000000000000002qXt
X-Hashcash: 1:20:080829:jeff@garzik.org::toVEfARhC0PHOwxO:00256x
X-Hashcash: 1:20:080829:randy.dunlap@oracle.com::HSohuyGQ2e7V+JLE:000000000000000000000000000000000000004ZGU
X-Hashcash: 1:20:080829:htejun@gmail.com::7UBEgLrfVh8s6Kaz:05odG
X-Hashcash: 1:20:080829:linux-ide@vger.kernel.org::VKwibEZ1o/kuIwrg:0000000000000000000000000000000000004nsI
X-Hashcash: 1:20:080829:linux-kernel@vger.kernel.org::zIOEnZM4DM/NPcfJ:0000000000000000000000000000000006Q52
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ide: Implement disk shock protection support
In-Reply-To: <87wshzplvk.fsf@denkblock.local>
Message-ID: <20080829211345.4355.93873.stgit@denkblock.local>
References: <87wshzplvk.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Aug 2008 23:26:42 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
FEATURE as specified in ATA-7 is issued to the device and processing of
the request queue is stopped thereafter until the speified timeout
expires or user space asks to resume normal operation. This is supposed
to prevent the heads of a hard drive from accidentally crashing onto the
platter when a heavy shock is anticipated (like a falling laptop
expected to hit the floor). In fact, the whole port stops processing
commands until the timeout has expired in order to avoid resets due to
failed commands on another device.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ide/ide-io.c       |   30 +++++
 drivers/ide/ide-probe.c    |    3 
 drivers/ide/ide-taskfile.c |   10 +-
 drivers/ide/ide.c          |  287 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ide.h        |   17 ++-
 5 files changed, 341 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index d0579f1..657c0d8 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -675,7 +675,33 @@ EXPORT_SYMBOL_GPL(ide_devset_execute);
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t task;
+	struct ide_taskfile *tf = &task.tf;
+
+	memset(&task, 0, sizeof(task));
 	switch (rq->cmd[0]) {
+	case REQ_PARK_HEADS: {
+		struct completion *waiting = rq->end_io_data;
+
+		drive->sleep = drive->hwif->park_timer.expires;
+		drive->dev_flags |= IDE_DFLAG_SLEEPING;
+		complete(waiting);
+		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD) {
+			ide_end_request(drive, 1, 0);
+			return ide_stopped;
+		}
+		tf->command = ATA_CMD_IDLEIMMEDIATE;
+		tf->feature = 0x44;
+		tf->lbal = 0x4c;
+		tf->lbam = 0x4e;
+		tf->lbah = 0x55;
+		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
+		break;
+	}
+	case REQ_UNPARK_HEADS:
+		tf->command = ATA_CMD_CHK_POWER;
+		break;
 	case REQ_DEVSET_EXEC:
 	{
 		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
@@ -695,6 +721,10 @@ static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 		ide_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
+	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	task.rq = rq;
+	hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, &task);
 }
 
 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index b5e54d2..789390b 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -842,6 +842,9 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 
 			if (hwif->dma_ops)
 				ide_set_dma(drive);
+
+			if (!ata_id_has_unload(drive->id))
+				drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
 		}
 	}
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index a4c2d91..7f89127 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -152,7 +152,15 @@ static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 
 	if (!custom)
 		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
-	else if (tf->command == ATA_CMD_SET_MULTI)
+	else if (tf->command == ATA_CMD_IDLEIMMEDIATE) {
+		drive->hwif->tp_ops->tf_read(drive, task);
+		if (tf->lbal != 0xc4) {
+			printk(KERN_ERR "%s: head unloading failed!\n",
+			       drive->name);
+			ide_tf_dump(drive->name, tf);
+		}
+		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
+	} else if (tf->command == ATA_CMD_SET_MULTI)
 		drive->mult_count = drive->mult_req;
 
 	return ide_stopped;
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index a498245..75914aa 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -59,6 +59,7 @@
 #include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/device.h>
+#include <linux/suspend.h>
 
 
 /* default maximum number of failures */
@@ -77,6 +78,165 @@ DEFINE_MUTEX(ide_cfg_mtx);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 EXPORT_SYMBOL(ide_lock);
 
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+static atomic_t ide_park_count = ATOMIC_INIT(0);
+DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
+
+static int ide_pm_notifier(struct notifier_block *nb, unsigned long val,
+			   void *null)
+{
+	switch (val) {
+	case PM_SUSPEND_PREPARE:
+		atomic_dec(&ide_park_count);
+		wait_event(ide_park_wq, atomic_read(&ide_park_count) == -1);
+		break;
+	case PM_POST_SUSPEND:
+		atomic_inc(&ide_park_count);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ide_pm_notifier_block = {
+	.notifier_call = ide_pm_notifier,
+};
+
+static inline int ide_register_pm_notifier(void)
+{
+	return register_pm_notifier(&ide_pm_notifier_block);
+}
+
+static inline int ide_unregister_pm_notifier(void)
+{
+	return unregister_pm_notifier(&ide_pm_notifier_block);
+}
+
+static inline void signal_unpark(void)
+{
+	atomic_dec(&ide_park_count);
+	wake_up_all(&ide_park_wq);
+}
+
+static inline int ide_mod_park_timer(struct timer_list *timer,
+				     unsigned long timeout)
+{
+	if (unlikely(atomic_inc_and_test(&ide_park_count))) {
+		signal_unpark();
+		return -EBUSY;
+	}
+	if (mod_timer(timer, timeout)) {
+		signal_unpark();
+		return 1;
+	}
+
+	return 0;
+}
+#else /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
+static inline int ide_register_pm_notifier(void) { return 0; }
+
+static inline int ide_unregister_pm_notifier(void) { return 0; }
+
+static inline void signal_unpark(void) { }
+
+static inline int ide_mod_park_timer(struct timer_list *timer,
+				     unsigned long timeout)
+{
+	return mod_timer(timer, timeout);
+}
+#endif /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
+
+static int issue_park_cmd(ide_drive_t *drive, struct completion *wait,
+			  u8 op_code)
+{
+	ide_drive_t *odrive = drive;
+	ide_hwif_t *hwif = drive->hwif;
+	ide_hwgroup_t *hwgroup = hwif->hwgroup;
+	struct request_queue *q;
+	struct request *rq;
+	gfp_t gfp_mask = (op_code == REQ_PARK_HEADS) ? __GFP_WAIT : GFP_NOWAIT;
+	int count = 0;
+
+	do {
+		q = drive->queue;
+		if (drive->dev_flags & IDE_DFLAG_SLEEPING
+		    && op_code == REQ_PARK_HEADS) {
+			drive->sleep = hwif->park_timer.expires;
+			goto next_step;
+		}
+
+		if (unlikely(drive->dev_flags & IDE_DFLAG_NO_UNLOAD
+			     && op_code == REQ_UNPARK_HEADS))
+			goto resume;
+
+		spin_unlock_irq(&ide_lock);
+		rq = blk_get_request(q, READ, gfp_mask);
+		spin_lock_irq(&ide_lock);
+		if (unlikely(!rq))
+			goto resume;
+
+		rq->cmd[0] = op_code;
+		rq->cmd_len = 1;
+		rq->cmd_type = REQ_TYPE_SPECIAL;
+		rq->cmd_flags |= REQ_SOFTBARRIER;
+		__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
+		if (op_code == REQ_PARK_HEADS) {
+			rq->end_io_data = wait;
+			blk_stop_queue(q);
+			q->request_fn(q);
+			count++;
+		} else {
+resume:
+			drive->dev_flags &= ~IDE_DFLAG_SLEEPING;
+			if (hwgroup->sleeping) {
+				del_timer(&hwgroup->timer);
+				hwgroup->sleeping = 0;
+				hwgroup->busy = 0;
+			}
+			blk_start_queue(q);
+		}
+
+next_step:
+		do {
+			drive = drive->next;
+		} while (drive->hwif != hwif);
+	} while (drive != odrive);
+
+	return count;
+}
+
+static void unpark_work(struct work_struct *work)
+{
+	ide_hwif_t *hwif = container_of(work, ide_hwif_t, unpark_work);
+	ide_drive_t *drive;
+
+	mutex_lock(&ide_setting_mtx);
+	spin_lock_irq(&ide_lock);
+	if (unlikely(!hwif->present || timer_pending(&hwif->park_timer)))
+		goto done;
+
+	drive = hwif->hwgroup->drive;
+	while (drive->hwif != hwif)
+		drive = drive->next;
+
+	issue_park_cmd(drive, NULL, REQ_UNPARK_HEADS);
+done:
+	signal_unpark();
+	spin_unlock_irq(&ide_lock);
+	mutex_unlock(&ide_setting_mtx);
+	put_device(&hwif->gendev);
+}
+
+static void park_timeout(unsigned long data)
+{
+	ide_hwif_t *hwif = (ide_hwif_t *)data;
+
+	/* FIXME: Which work queue would be the right one? */
+	kblockd_schedule_work(NULL, &hwif->unpark_work);
+}
+
 static void ide_port_init_devices_data(ide_hwif_t *);
 
 /*
@@ -100,6 +260,11 @@ void ide_init_port_data(ide_hwif_t *hwif, unsigned int index)
 
 	hwif->tp_ops = &default_tp_ops;
 
+	INIT_WORK(&hwif->unpark_work, unpark_work);
+	hwif->park_timer.function = park_timeout;
+	hwif->park_timer.data = (unsigned long)hwif;
+	init_timer(&hwif->park_timer);
+
 	ide_port_init_devices_data(hwif);
 }
 
@@ -581,6 +746,118 @@ static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_SERNO]);
 }
 
+static ssize_t park_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	ide_hwif_t *hwif = drive->hwif;
+	unsigned int seconds;
+
+	spin_lock_irq(&ide_lock);
+	if (!(drive->dev_flags & IDE_DFLAG_PRESENT)) {
+		spin_unlock_irq(&ide_lock);
+		return -ENODEV;
+	}
+
+	if (timer_pending(&hwif->park_timer))
+		/*
+		 * Adding 1 in order to guarantee nonzero value until timer
+		 * has actually expired.
+		 */
+		seconds = jiffies_to_msecs(hwif->park_timer.expires - jiffies)
+			  / 1000 + 1;
+	else
+		seconds = 0;
+	spin_unlock_irq(&ide_lock);
+
+	return snprintf(buf, 20, "%u\n", seconds);
+}
+
+static ssize_t park_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+#define MAX_PARK_TIMEOUT 30
+	ide_drive_t *drive = to_ide_device(dev);
+	ide_hwif_t *hwif = drive->hwif;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	unsigned long timeout;
+	int rc, count = 0;
+
+	rc = strict_strtoul(buf, 10, &timeout);
+	if (rc || timeout > MAX_PARK_TIMEOUT)
+		return -EINVAL;
+
+	mutex_lock(&ide_setting_mtx);
+	spin_lock_irq(&ide_lock);
+	if (unlikely(!(drive->dev_flags & IDE_DFLAG_PRESENT))) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (timeout) {
+		timeout = msecs_to_jiffies(timeout * 1000) + jiffies;
+		rc = ide_mod_park_timer(&hwif->park_timer, timeout);
+		if (unlikely(rc < 0))
+			goto unlock;
+		else if (rc)
+			rc = 0;
+		else
+			get_device(&hwif->gendev);
+		count = issue_park_cmd(drive, &wait, REQ_PARK_HEADS);
+	} else {
+		if (del_timer(&hwif->park_timer)) {
+			issue_park_cmd(drive, NULL, REQ_UNPARK_HEADS);
+			signal_unpark();
+			put_device(&hwif->gendev);
+		}
+	}
+
+unlock:
+	spin_unlock_irq(&ide_lock);
+
+	for (; count; count--)
+		wait_for_completion(&wait);
+	mutex_unlock(&ide_setting_mtx);
+
+	return rc ? rc : len;
+}
+
+ide_devset_rw_flag(no_unload, IDE_DFLAG_NO_UNLOAD);
+
+static ssize_t unload_feature_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	unsigned int val;
+
+	spin_lock_irq(&ide_lock);
+	val = !get_no_unload(drive);
+	spin_unlock_irq(&ide_lock);
+
+	return snprintf(buf, 4, "%u\n", val);
+}
+
+static ssize_t unload_feature_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t len)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	int val;
+
+	val = buf[0] - '0';
+	if ((val != 0 && val != 1)
+	    || (buf[1] != '\0' && buf[1] != '\n') || buf[2] != '\0')
+		return -EINVAL;
+
+	val = ide_devset_execute(drive, &ide_devset_no_unload, !val);
+
+	return val ? val : len;
+}
+
 static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(media),
 	__ATTR_RO(drivename),
@@ -588,6 +865,8 @@ static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(model),
 	__ATTR_RO(firmware),
 	__ATTR(serial, 0400, serial_show, NULL),
+	__ATTR(unload_feature, 0644, unload_feature_show, unload_feature_store),
+	__ATTR(unload_heads, 0644, park_show, park_store),
 	__ATTR_NULL
 };
 
@@ -844,6 +1123,12 @@ static int __init ide_init(void)
 		goto out_port_class;
 	}
 
+	ret = ide_register_pm_notifier();
+	if (ret) {
+		class_destroy(ide_port_class);
+		goto out_port_class;
+	}
+
 	proc_ide_create();
 
 	return 0;
@@ -858,6 +1143,8 @@ static void __exit ide_exit(void)
 {
 	proc_ide_destroy();
 
+	ide_unregister_pm_notifier();
+
 	class_destroy(ide_port_class);
 
 	bus_unregister(&ide_bus_type);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 3eece03..5e1ee98 100644
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
@@ -571,6 +573,8 @@ enum {
 	/* retrying in PIO */
 	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 25),
 	IDE_DFLAG_LBA			= (1 << 26),
+	/* don't unload heads */
+	IDE_DFLAG_NO_UNLOAD		= (1 << 27),
 };
 
 struct ide_drive_s {
@@ -818,6 +822,9 @@ typedef struct hwif_s {
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	sg_mapped  : 1;	/* sg_table and sg_nents are ready */
 
+	struct timer_list	park_timer;	/* protected by queue_lock */
+	struct work_struct	unpark_work;
+
 	struct device		gendev;
 	struct device		*portdev;
 
@@ -950,6 +957,11 @@ __IDE_DEVSET(_name, 0, get_##_func, set_##_func)
 #define ide_ext_devset_rw_sync(_name, _func) \
 __IDE_DEVSET(_name, DS_SYNC, get_##_func, set_##_func)
 
+#define ide_devset_rw_flag(_name, _field) \
+ide_devset_get_flag(_name, _field); \
+ide_devset_set_flag(_name, _field); \
+IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
+
 #define ide_decl_devset(_name) \
 extern const struct ide_devset ide_devset_##_name
 
@@ -969,11 +981,6 @@ ide_devset_get(_name, _field); \
 ide_devset_set(_name, _field); \
 IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
 
-#define ide_devset_rw_flag(_name, _field) \
-ide_devset_get_flag(_name, _field); \
-ide_devset_set_flag(_name, _field); \
-IDE_DEVSET(_name, DS_SYNC, get_##_name, set_##_name)
-
 struct ide_proc_devset {
 	const char		*name;
 	const struct ide_devset	*setting;


