Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbYGZG13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbYGZG13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYGZG1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:27:20 -0400
Received: from nebensachen.de ([195.34.83.29]:52986 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbYGZG1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:27:19 -0400
X-Hashcash: 1:20:080726:alan@lxorguk.ukuu.org.uk::3c9Na3or1v4+VFMM:000000000000000000000000000000000000065Rz
X-Hashcash: 1:20:080726:jeff@garzik.org::VKQXS8P5YPjE3d5p:002d58
X-Hashcash: 1:20:080726:bzolnier@gmail.com::zpJKg7WAxaNO+LxI:000000000000000000000000000000000000000000004ob
X-Hashcash: 1:20:080726:james.bottomley@hansenpartnership.com::t6+iXcv3nsETz9OO:0000000000000000000000000HsB
X-Hashcash: 1:20:080726:pavel@ucw.cz::5ciHI/fLHisOV1mV:0000090NB
X-Hashcash: 1:20:080726:linux-ide@vger.kernel.org::Wt+cb7iWCvsqUPSA:0000000000000000000000000000000000002LN0
X-Hashcash: 1:20:080726:linux-kernel@vger.kernel.org::w4G9dv0wj+4uFYfS:0000000000000000000000000000000003KZ2
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ide: Implement disk shock protection support
In-Reply-To: <87prp1kvyy.fsf@denkblock.local>
Message-ID: <20080726062142.29070.7339.stgit@denkblock.local>
References: <87prp1kvyy.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 08:27:04 +0200
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
expected to hit the floor). This patch simply stops processing the
request queue. In particular, it does not yet, for instance, defer an
SRST issued in order to recover from an error on the other device on the
interface.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ide/ide-io.c |   26 ++++++
 drivers/ide/ide.c    |  223 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ide.h  |    5 +
 3 files changed, 254 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index ce9ecd1..888ed28 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -717,7 +717,28 @@ static ide_startstop_t execute_drive_cmd (ide_drive_t *drive,
 
 static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwif_t *hwif = drive->hwif;
+	ide_task_t task;
+	struct ide_taskfile *tf = &task.tf;
+
+	memset(&task, 0, sizeof(task));
 	switch (rq->cmd[0]) {
+	case REQ_PARK_HEADS:
+		if (unlikely(!timer_pending(&drive->park_timer))) {
+			ide_end_request(drive, 0, 0);
+			return ide_stopped;
+		}
+		drive->sleep = drive->park_timer.expires;
+		drive->sleeping = 1;
+		tf->command = WIN_IDLEIMMEDIATE;
+		tf->feature = 0x44;
+		tf->lbal = 0x4c;
+		tf->lbam = 0x4e;
+		tf->lbah = 0x55;
+		break;
+	case REQ_UNPARK_HEADS:
+		tf->command = WIN_CHECKPOWERMODE1;
+		break;
 	case REQ_DRIVE_RESET:
 		return ide_do_reset(drive);
 	default:
@@ -725,6 +746,11 @@ static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
 		ide_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
+	task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+	task.rq = rq;
+	rq->special = &task;
+	hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
+	return do_rw_taskfile(drive, &task);
 }
 
 static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 21b3a76..ecc9075 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -57,9 +57,13 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/ata.h>
 #include <linux/ide.h>
 #include <linux/completion.h>
 #include <linux/device.h>
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+# include <linux/suspend.h>
+#endif
 
 
 /* default maximum number of failures */
@@ -78,6 +82,134 @@ DEFINE_MUTEX(ide_cfg_mtx);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 EXPORT_SYMBOL(ide_lock);
 
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+static int ide_park_count = 1;
+DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
+
+static inline int suspend_parking(void)
+{
+	spin_lock_irq(&ide_lock);
+	if (ide_park_count == 1)
+		ide_park_count = 0;
+	spin_unlock_irq(&ide_lock);
+	return !ide_park_count;
+}
+
+static int ide_pm_notifier(struct notifier_block *nb, unsigned long val,
+			   void *null)
+{
+	switch (val) {
+	case PM_SUSPEND_PREPARE:
+		wait_event(ide_park_wq, suspend_parking());
+		break;
+	case PM_POST_SUSPEND:
+		ide_park_count = 1;
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
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
+	ide_park_count--;
+	wake_up_all(&ide_park_wq);
+}
+
+static inline int ide_mod_park_timer(struct timer_list *timer,
+				     unsigned long timeout)
+{
+	if (likely(ide_park_count)) {
+		if (!mod_timer(timer, timeout)) {
+			ide_park_count++;
+			return 0;
+		}
+		return 1;
+	}
+	return -EBUSY;
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
+static void issue_park_cmd(ide_drive_t *drive, struct request *rq, u8 op_code)
+{
+	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	struct request_queue *q = drive->queue;
+
+	rq->cmd[0] = op_code;
+	rq->cmd_len = 1;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
+	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
+	switch (op_code) {
+	case REQ_PARK_HEADS:
+		blk_stop_queue(q);
+		q->request_fn(q);
+		break;
+	case REQ_UNPARK_HEADS:
+		drive->sleeping = 0;
+		if (hwgroup->sleeping) {
+			del_timer(&hwgroup->timer);
+			hwgroup->sleeping = 0;
+			hwgroup->busy = 0;
+		}
+		blk_start_queue(q);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void unpark_work(struct work_struct *work)
+{
+	ide_drive_t *drive = container_of(work, ide_drive_t, unpark_work);
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	spin_lock_irq(&ide_lock);
+	if (likely(!timer_pending(&drive->park_timer)))
+		issue_park_cmd(drive, rq, REQ_UNPARK_HEADS);
+	else
+		__blk_put_request(q, rq);
+	signal_unpark();
+	spin_unlock_irq(&ide_lock);
+	ide_device_put(drive);
+}
+
+static void park_timeout(unsigned long data)
+{
+	ide_drive_t *drive = (ide_drive_t *)data;
+
+	schedule_work(&drive->unpark_work);
+}
+
 static void ide_port_init_devices_data(ide_hwif_t *);
 
 /*
@@ -130,6 +262,10 @@ static void ide_port_init_devices_data(ide_hwif_t *hwif)
 
 		INIT_LIST_HEAD(&drive->list);
 		init_completion(&drive->gendev_rel_comp);
+		INIT_WORK(&drive->unpark_work, unpark_work);
+		drive->park_timer.function = park_timeout;
+		drive->park_timer.data = (unsigned long)drive;
+		init_timer(&drive->park_timer);
 	}
 }
 
@@ -770,6 +906,84 @@ static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%s\n", (char *)&drive->id[ATA_ID_SERNO]);
 }
 
+static ssize_t park_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	ide_drive_t *drive = to_ide_device(dev);
+	unsigned int seconds;
+
+	if (!ata_id_has_unload(drive->id))
+		return -EOPNOTSUPP;
+
+	spin_lock_irq(&ide_lock);
+	if (timer_pending(&drive->park_timer))
+		/*
+		 * Adding 1 in order to guarantee nonzero value until timer
+		 * has actually expired.
+		 */
+		seconds = jiffies_to_msecs(drive->park_timer.expires - jiffies)
+			  / 1000 + 1;
+	else
+		seconds = 0;
+	spin_unlock_irq(&ide_lock);
+	return snprintf(buf, 20, "%u\n", seconds);
+}
+
+static ssize_t park_store(struct device *dev, struct device_attribute *attr, 
+			  const char *buf, size_t len)
+{
+#define MAX_PARK_TIMEOUT 30
+	ide_drive_t *drive = to_ide_device(dev);
+	struct request_queue *q = drive->queue;
+	struct request *rq;
+	unsigned long seconds;
+	char *p;
+	int skipped_cmd = 0, rc = 0;
+
+	seconds = simple_strtoul((char *)buf, &p, 0);
+	if (p == buf || (*p != '\0' && (*p != '\n' || *(p + 1) != '\0'))
+	    || seconds > MAX_PARK_TIMEOUT)
+		return -EINVAL;
+	if (!ata_id_has_unload(drive->id))
+		return -EOPNOTSUPP;
+
+	rq = blk_get_request(q, READ, __GFP_WAIT);
+	spin_lock_irq(&ide_lock);
+	if (seconds) {
+		if (unlikely(ide_device_get(drive))) {
+			skipped_cmd = 1;
+			rc = -ENXIO;
+			goto free_rq;
+		}
+		rc = ide_mod_park_timer(&drive->park_timer,
+					msecs_to_jiffies(seconds * 1000)
+					+ jiffies);
+		if (!rc)
+			issue_park_cmd(drive, rq, REQ_PARK_HEADS);
+		else {
+			if (likely(rc == 1)) {
+				drive->sleep = drive->park_timer.expires;
+				rc = 0;
+			}
+			ide_device_put(drive);
+			skipped_cmd = 1;
+		}
+	} else {
+		if (del_timer(&drive->park_timer)) {
+			issue_park_cmd(drive, rq, REQ_UNPARK_HEADS);
+			signal_unpark();
+			ide_device_put(drive);
+		} else
+			skipped_cmd = 1;
+	}
+free_rq:
+	if (skipped_cmd)
+		__blk_put_request(q, rq);
+	spin_unlock_irq(&ide_lock);
+
+	return rc ? rc : len;
+}
+
 static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(media),
 	__ATTR_RO(drivename),
@@ -777,6 +991,7 @@ static struct device_attribute ide_dev_attrs[] = {
 	__ATTR_RO(model),
 	__ATTR_RO(firmware),
 	__ATTR(serial, 0400, serial_show, NULL),
+	__ATTR(unload_heads, 0644, park_show, park_store),
 	__ATTR_NULL
 };
 
@@ -1032,6 +1247,12 @@ static int __init ide_init(void)
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
@@ -1046,6 +1267,8 @@ static void __exit ide_exit(void)
 {
 	proc_ide_destroy();
 
+	ide_unregister_pm_notifier();
+
 	class_destroy(ide_port_class);
 
 	bus_unregister(&ide_bus_type);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 2d8d21c..625db11 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -143,6 +143,8 @@ struct ide_io_ports {
  * Values should be in the range of 0x20 to 0x3f.
  */
 #define REQ_DRIVE_RESET		0x20
+#define REQ_PARK_HEADS		0x21
+#define REQ_UNPARK_HEADS	0x22
 
 /*
  * Check for an interrupt and acknowledge the interrupt status
@@ -477,6 +479,9 @@ struct ide_drive_s {
 	void (*pc_callback)(struct ide_drive_s *);
 
 	unsigned long atapi_flags;
+
+	struct timer_list	park_timer;	/* protected by queue_lock */
+	struct work_struct	unpark_work;
 };
 
 typedef struct ide_drive_s ide_drive_t;


