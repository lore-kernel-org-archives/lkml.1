Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbYH2VVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbYH2VVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbYH2VVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:21:35 -0400
Received: from nebensachen.de ([195.34.83.29]:37832 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbYH2VVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:21:33 -0400
X-Hashcash: 1:20:080829:alan@lxorguk.ukuu.org.uk::TcRK0DdlBNS4XFNd:00000000000000000000000000000000000004VFw
X-Hashcash: 1:20:080829:akpm@linux-foundation.org::h2tKEUO3IdPi7PxP:0000000000000000000000000000000000001LP6
X-Hashcash: 1:20:080829:bzolnier@gmail.com::+uHbflQyAZvvWOlH:00000000000000000000000000000000000000000000Eze
X-Hashcash: 1:20:080829:jeff@garzik.org::3t4dRr0o1yFLEFUo:003Hvp
X-Hashcash: 1:20:080829:randy.dunlap@oracle.com::qdSLEnje5ijVnM69:000000000000000000000000000000000000008ixI
X-Hashcash: 1:20:080829:htejun@gmail.com::jTjtwHljswlJUhn3:031z7
X-Hashcash: 1:20:080829:linux-ide@vger.kernel.org::8BzVGFU8hN2gkW3e:0000000000000000000000000000000000008foi
X-Hashcash: 1:20:080829:linux-kernel@vger.kernel.org::/FBTZeNotJhx+n3j:000000000000000000000000000000000EnVr
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] libata: Implement disk shock protection support
In-Reply-To: <87wshzplvk.fsf@denkblock.local>
Message-ID: <20080829211345.4355.89284.stgit@denkblock.local>
References: <87wshzplvk.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Fri, 29 Aug 2008 23:20:41 +0200
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
commands until the timeout has expired in order to avoid any resets due
to failed commands on another device.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ata/ahci.c        |    2 
 drivers/ata/ata_piix.c    |    7 ++
 drivers/ata/libata-core.c |    8 ++
 drivers/ata/libata-eh.c   |   51 +++++++++++
 drivers/ata/libata-scsi.c |  205 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h      |    9 ++
 include/linux/libata.h    |    5 +
 7 files changed, 287 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c729e69..78281af 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -316,6 +316,8 @@ static struct device_attribute *ahci_shost_attrs[] = {
 
 static struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
+	&dev_attr_unload_feature,
+	&dev_attr_unload_heads,
 	NULL
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b1d08a8..9b42f8d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -298,8 +298,15 @@ static struct pci_driver piix_pci_driver = {
 #endif
 };
 
+static struct device_attribute *piix_sdev_attrs[] = {
+	&dev_attr_unload_feature,
+	&dev_attr_unload_heads,
+	NULL
+};
+
 static struct scsi_host_template piix_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.sdev_attrs		= piix_sdev_attrs,
 };
 
 static struct ata_port_operations piix_pata_ops = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 79e3a8e..f1e036f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5267,6 +5267,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	init_timer_deferrable(&ap->fastdrain_timer);
 	ap->fastdrain_timer.function = ata_eh_fastdrain_timerfn;
 	ap->fastdrain_timer.data = (unsigned long)ap;
+	ap->park_timer.function = ata_scsi_park_timeout;
+	init_timer(&ap->park_timer);
 
 	ap->cbl = ATA_CBL_NONE;
 
@@ -6138,6 +6140,11 @@ static int __init ata_init(void)
 	if (!ata_aux_wq)
 		goto free_wq;
 
+	if (ata_scsi_register_pm_notifier()) {
+		destroy_workqueue(ata_aux_wq);
+		goto free_wq;
+	}
+
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
 
@@ -6153,6 +6160,7 @@ static void __exit ata_exit(void)
 	kfree(ata_force_tbl);
 	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
+	ata_scsi_unregister_pm_notifier();
 }
 
 subsys_initcall(ata_init);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c1db2f2..af75d59 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2446,6 +2446,51 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	goto retry;
 }
 
+static void ata_eh_park_devs(struct ata_port *ap, int park)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	struct ata_taskfile tf;
+	struct request_queue *q;
+	unsigned int err_mask;
+
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			if (!dev->sdev)
+				continue;
+			ata_tf_init(dev, &tf);
+			q = dev->sdev->request_queue;
+			spin_lock_irq(q->queue_lock);
+			if (park) {
+				blk_stop_queue(q);
+				tf.command = ATA_CMD_IDLEIMMEDIATE;
+				tf.feature = 0x44;
+				tf.lbal = 0x4c;
+				tf.lbam = 0x4e;
+				tf.lbah = 0x55;
+			} else {
+				blk_start_queue(q);
+				tf.command = ATA_CMD_CHK_POWER;
+			}
+			spin_unlock(q->queue_lock);
+			spin_lock(ap->lock);
+			if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+				spin_unlock_irq(ap->lock);
+				continue;
+			}
+			spin_unlock_irq(ap->lock);
+
+			tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+			tf.protocol |= ATA_PROT_NODATA;
+			err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE,
+						     NULL, 0, 0);
+			if ((err_mask || tf.lbal != 0xc4) && park)
+				ata_dev_printk(dev, KERN_ERR,
+					       "head unload failed\n");
+		}
+	}
+}
+
 static int ata_eh_revalidate_and_attach(struct ata_link *link,
 					struct ata_device **r_failed_dev)
 {
@@ -2829,6 +2874,12 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		}
 	}
 
+	if (ap->link.eh_context.i.action & ATA_EH_PARK) {
+		ata_eh_park_devs(ap, 1);
+		wait_event(ata_scsi_park_wq, !timer_pending(&ap->park_timer));
+		ata_eh_park_devs(ap, 0);
+	}
+
 	/* the rest */
 	ata_port_for_each_link(link, ap) {
 		struct ata_eh_context *ehc = &link->eh_context;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4d066ad..ffcc016 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -46,6 +46,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/suspend.h>
 
 #include "libata.h"
 
@@ -113,6 +114,77 @@ static struct scsi_transport_template ata_scsi_transport_template = {
 	.user_scan		= ata_scsi_user_scan,
 };
 
+DECLARE_WAIT_QUEUE_HEAD(ata_scsi_park_wq);
+
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+static atomic_t ata_scsi_park_count = ATOMIC_INIT(0);
+
+static int ata_scsi_pm_notifier(struct notifier_block *nb, unsigned long val,
+				void *null)
+{
+	switch (val) {
+	case PM_SUSPEND_PREPARE:
+		atomic_dec(&ata_scsi_park_count);
+		wait_event(ata_scsi_park_wq,
+			   atomic_read(&ata_scsi_park_count) == -1);
+		break;
+	case PM_POST_SUSPEND:
+		atomic_inc(&ata_scsi_park_count);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ata_scsi_pm_notifier_block = {
+	.notifier_call = ata_scsi_pm_notifier,
+};
+
+int ata_scsi_register_pm_notifier(void)
+{
+	return register_pm_notifier(&ata_scsi_pm_notifier_block);
+}
+
+int ata_scsi_unregister_pm_notifier(void)
+{
+	return unregister_pm_notifier(&ata_scsi_pm_notifier_block);
+}
+
+static inline void ata_scsi_signal_unpark(void)
+{
+	atomic_dec(&ata_scsi_park_count);
+	wake_up_all(&ata_scsi_park_wq);
+}
+
+static inline int ata_scsi_mod_park_timer(struct timer_list *timer,
+					  unsigned long timeout)
+{
+	if (unlikely(atomic_inc_and_test(&ata_scsi_park_count))) {
+		ata_scsi_signal_unpark();
+		return -EBUSY;
+	}
+	if (mod_timer(timer, timeout)) {
+		atomic_dec(&ata_scsi_park_count);
+		return 1;
+	}
+
+	return 0;
+}
+#else /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
+static inline void ata_scsi_signal_unpark(void)
+{
+	wake_up_all(&ata_scsi_park_wq);
+}
+
+static inline int ata_scsi_mod_park_timer(struct timer_list *timer,
+					  unsigned long timeout)
+{
+	return mod_timer(timer, timeout);
+}
+#endif /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
+
 
 static const struct {
 	enum link_pm	value;
@@ -183,6 +255,136 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static ssize_t ata_scsi_park_show(struct device *device,
+				  struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	unsigned int seconds;
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irq(ap->lock);
+	if (timer_pending(&ap->park_timer))
+		/*
+		 * Adding 1 in order to guarantee nonzero value until timer
+		 * has actually expired.
+		 */
+		seconds = jiffies_to_msecs(ap->park_timer.expires - jiffies)
+			  / 1000 + 1;
+	else
+		seconds = 0;
+	spin_unlock_irq(ap->lock);
+
+	return snprintf(buf, 20, "%u\n", seconds);
+}
+
+static ssize_t ata_scsi_park_store(struct device *device,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+#define MAX_PARK_TIMEOUT 30
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	unsigned long seconds;
+	int rc;
+
+	rc = strict_strtoul(buf, 10, &seconds);
+	if (rc || seconds > MAX_PARK_TIMEOUT)
+		return -EINVAL;
+
+	ap = ata_shost_to_port(sdev->host);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev))
+		return -ENODEV;
+
+	spin_lock_irq(ap->lock);
+	if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (seconds) {
+		rc = ata_scsi_mod_park_timer(&ap->park_timer,
+					     msecs_to_jiffies(seconds * 1000)
+					     + jiffies);
+		if (!rc) {
+			ap->link.eh_info.action |= ATA_EH_PARK;
+			ata_port_schedule_eh(ap);
+		} else if (rc == 1)
+			rc = 0;
+	} else {
+		if (del_timer(&ap->park_timer))
+			ata_scsi_signal_unpark();
+	}
+unlock:
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : len;
+}
+DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
+	    ata_scsi_park_show, ata_scsi_park_store);
+EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
+
+static ssize_t ata_scsi_unload_feature_show(struct device *device,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap = ata_shost_to_port(sdev->host);
+	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
+	int val;
+
+	if (!dev)
+		return -ENODEV;
+	if (dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ATAPI)
+		return -EOPNOTSUPP;
+	spin_lock_irq(ap->lock);
+	val = !(dev->flags & ATA_DFLAG_NO_UNLOAD);
+	spin_unlock_irq(ap->lock);
+
+	return snprintf(buf, 4, "%u\n", val);
+}
+
+static ssize_t ata_scsi_unload_feature_store(struct device *device,
+					     struct device_attribute *attr,
+					     const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	int val;
+
+	val = buf[0] - '0';
+	if ((val != 0 && val != 1) || (buf[1] != '\0' && buf[1] != '\n')
+	    || buf[2] != '\0')
+		return -EINVAL;
+	ap = ata_shost_to_port(sdev->host);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev)
+		return -ENODEV;
+	if (dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ATAPI)
+		return -EOPNOTSUPP;
+
+	spin_lock_irq(ap->lock);
+	if (val == 1)
+		dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
+	else
+		dev->flags |= ATA_DFLAG_NO_UNLOAD;
+	spin_unlock_irq(ap->lock);
+
+	return len;
+}
+DEVICE_ATTR(unload_feature, S_IRUGO | S_IWUSR,
+	    ata_scsi_unload_feature_show, ata_scsi_unload_feature_store);
+EXPORT_SYMBOL_GPL(dev_attr_unload_feature);
+
+void ata_scsi_park_timeout(unsigned long data)
+{
+	ata_scsi_signal_unpark();
+}
+
 static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
@@ -954,6 +1156,9 @@ static int atapi_drain_needed(struct request *rq)
 static int ata_scsi_dev_config(struct scsi_device *sdev,
 			       struct ata_device *dev)
 {
+	if (!ata_id_has_unload(dev->id))
+		dev->flags |= ATA_DFLAG_NO_UNLOAD;
+
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ade5c75..a486577 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -148,6 +148,15 @@ extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
+extern wait_queue_head_t ata_scsi_park_wq;
+void ata_scsi_park_timeout(unsigned long data);
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+extern int ata_scsi_register_pm_notifier(void);
+extern int ata_scsi_unregister_pm_notifier(void);
+#else
+static inline int ata_scsi_register_pm_notifier(void) { return 0; }
+static inline int ata_scsi_unregister_pm_notifier(void) { return 0; }
+#endif
 
 /* libata-eh.c */
 extern unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 225bfc5..4b5e073 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -146,6 +146,7 @@ enum {
 	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -319,6 +320,7 @@ enum {
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
 	ATA_EH_LPM		= (1 << 4),  /* link power management action */
+	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
 	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
 
@@ -452,6 +454,8 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_unload_heads;
+extern struct device_attribute dev_attr_unload_feature;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -714,6 +718,7 @@ struct ata_port {
 	int			*pm_result;
 	enum link_pm		pm_policy;
 
+	struct timer_list	park_timer;
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
 


