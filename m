Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYGZG0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYGZG0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 02:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYGZG0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 02:26:08 -0400
Received: from nebensachen.de ([195.34.83.29]:37678 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYGZG0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 02:26:05 -0400
X-Hashcash: 1:20:080726:alan@lxorguk.ukuu.org.uk::3EJbSNlsB0+2uQsp:00000000000000000000000000000000000003Uk3
X-Hashcash: 1:20:080726:jeff@garzik.org::bVekJWbtRaooc50q:000QhU
X-Hashcash: 1:20:080726:bzolnier@gmail.com::PWcv7a/d/kc35zKn:00000000000000000000000000000000000000000001pgN
X-Hashcash: 1:20:080726:james.bottomley@hansenpartnership.com::R7wOiy3cBRu5dMQq:0000000000000000000000000A9X
X-Hashcash: 1:20:080726:pavel@ucw.cz::bOe9Ko08MmHSXUTb:000000MVA
X-Hashcash: 1:20:080726:linux-ide@vger.kernel.org::Q9RpaNchoRKg1jNb:0000000000000000000000000000000000006Isr
X-Hashcash: 1:20:080726:linux-kernel@vger.kernel.org::06a08mF+xsO+DBAO:0000000000000000000000000000000006U5x
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] libata: Implement disk shock protection support
In-Reply-To: <87prp1kvyy.fsf@denkblock.local>
Message-ID: <20080726062142.29070.10413.stgit@denkblock.local>
References: <87prp1kvyy.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 08:25:51 +0200
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

 drivers/ata/ahci.c        |    1 
 drivers/ata/ata_piix.c    |    6 +
 drivers/ata/libata-core.c |    6 +
 drivers/ata/libata-scsi.c |  343 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/ata/libata.h      |   11 +
 include/linux/libata.h    |    6 +
 6 files changed, 360 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index dc7596f..cbf86fa 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -316,6 +316,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 
 static struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
 	NULL
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a90ae03..e4cdd86 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -289,8 +289,14 @@ static struct pci_driver piix_pci_driver = {
 #endif
 };
 
+static struct device_attribute *piix_sdev_attrs[] = {
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
index 0a2f921..07737ec 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6094,6 +6094,11 @@ static int __init ata_init(void)
 	if (!ata_aux_wq)
 		goto free_wq;
 
+	if (ata_scsi_register_pm_notifier()) {
+		destroy_workqueue(ata_aux_wq);
+		goto free_wq;
+	}
+
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
 
@@ -6109,6 +6114,7 @@ static void __exit ata_exit(void)
 	kfree(ata_force_tbl);
 	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
+	ata_scsi_unregister_pm_notifier();
 }
 
 subsys_initcall(ata_init);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b5085cd..4bc0334 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -46,13 +46,16 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+# include <linux/suspend.h>
+#endif
 
 #include "libata.h"
 
 #define SECTOR_SIZE		512
 #define ATA_SCSI_RBUF_SIZE	4096
 
-static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
+static DEFINE_SPINLOCK(ata_scsi_lock);
 static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
@@ -113,6 +116,82 @@ static struct scsi_transport_template ata_scsi_transport_template = {
 	.user_scan		= ata_scsi_user_scan,
 };
 
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
+static int ata_scsi_park_count = 1;
+DECLARE_WAIT_QUEUE_HEAD(ata_scsi_park_wq);
+
+static inline int ata_scsi_suspend_parking(void)
+{
+	spin_lock_irq(&ata_scsi_lock);
+	if (ata_scsi_park_count == 1)
+		ata_scsi_park_count = 0;
+	spin_unlock_irq(&ata_scsi_lock);
+	return !ata_scsi_park_count;
+}
+
+static int ata_scsi_pm_notifier(struct notifier_block *nb, unsigned long val,
+				void *null)
+{
+	switch (val) {
+	case PM_SUSPEND_PREPARE:
+		wait_event(ata_scsi_park_wq, ata_scsi_suspend_parking());
+		break;
+	case PM_POST_SUSPEND:
+		ata_scsi_park_count = 1;
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
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
+	spin_lock(&ata_scsi_lock);
+	ata_scsi_park_count--;
+	spin_unlock(&ata_scsi_lock);
+	wake_up_all(&ata_scsi_park_wq);
+}
+
+static inline int ata_scsi_mod_park_timer(struct timer_list *timer,
+					  unsigned long timeout)
+{
+	int ret;
+
+	spin_lock(&ata_scsi_lock);
+	if (likely(ata_scsi_park_count)) {
+		ret = mod_timer(timer, timeout);
+		if (!ret)
+			ata_scsi_park_count++;
+	} else
+		ret = -EBUSY;
+	spin_unlock(&ata_scsi_lock);
+	return ret;
+}
+#else /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
+static inline void ata_scsi_signal_unpark(void) { }
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
@@ -183,6 +262,102 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static ssize_t ata_scsi_park_show(struct device *device,
+				  struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	struct request_queue *q = sdev->request_queue;
+	unsigned int seconds;
+
+	ap = ata_shost_to_port(sdev->host);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev)
+		return -ENODEV;
+	if (!ata_id_has_unload(dev->id))
+		return -EOPNOTSUPP;
+
+	spin_lock_irq(q->queue_lock);
+	if (timer_pending(&dev->park_timer))
+		/*
+		 * Adding 1 in order to guarantee nonzero value until timer
+		 * has actually expired.
+		 */
+		seconds = jiffies_to_msecs(dev->park_timer.expires - jiffies)
+			  / 1000 + 1;
+	else
+		seconds = 0;
+	spin_unlock_irq(q->queue_lock);
+	return snprintf(buf, 20, "%u\n", seconds);
+}
+
+static void ata_scsi_issue_park_cmd(struct ata_device *dev,
+				    struct request *rq, __be16 sa_op);
+
+static ssize_t ata_scsi_park_store(struct device *device,
+				   struct device_attribute *attr, 
+				   const char *buf, size_t len)
+{
+#define MAX_PARK_TIMEOUT 30
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	struct request_queue *q = sdev->request_queue;
+	struct request *rq;
+	unsigned long seconds;
+	char *p;
+	int skipped_cmd = 0, rc = 0;
+
+	seconds = simple_strtoul((char *)buf, &p, 0);
+	if (p == buf || (*p != '\0' && (*p != '\n' || *(p + 1) != '\0'))
+	    || seconds > MAX_PARK_TIMEOUT)
+		return -EINVAL;
+
+	ap = ata_shost_to_port(sdev->host);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev))
+		return -ENODEV;
+	if (!ata_id_has_unload(dev->id))
+		return -EOPNOTSUPP;
+
+	rq = blk_get_request(q, 0, __GFP_WAIT);
+	spin_lock_irq(q->queue_lock);
+	if (seconds) {
+		if (unlikely(scsi_device_get(sdev))) {
+			rc = -ENXIO;
+			skipped_cmd = 1;
+			goto free_rq;
+		}
+		rc = ata_scsi_mod_park_timer(&dev->park_timer,
+					     msecs_to_jiffies(seconds * 1000)
+					     + jiffies);
+		if (rc) {
+			scsi_device_put(sdev);
+			skipped_cmd = 1;
+			if (likely(rc == 1))
+				rc = 0;
+		} else
+			ata_scsi_issue_park_cmd(dev, rq, PARK_HEADS);
+	} else {
+		if (del_timer(&dev->park_timer)) {
+			ata_scsi_issue_park_cmd(dev, rq, UNPARK_HEADS);
+			ata_scsi_signal_unpark();
+			scsi_device_put(sdev);
+		} else
+			skipped_cmd = 1;
+	}
+free_rq:
+	if (skipped_cmd)
+		__blk_put_request(q, rq);
+	spin_unlock_irq(q->queue_lock);
+
+	return rc ? rc : len;
+}
+DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
+	    ata_scsi_park_show, ata_scsi_park_store);
+EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
+
 static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
@@ -912,6 +1087,62 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	desc[11] = block;
 }
 
+static void ata_scsi_issue_park_cmd(struct ata_device *dev,
+				    struct request *rq, __be16 sa_op)
+{
+	struct request_queue *q = dev->sdev->request_queue;
+	struct scsi_varlen_cdb_hdr *vl_cdb;
+
+	rq->cmd[0] = VARIABLE_LENGTH_CMD;
+	rq->cmd_len = 10;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->retries = 5;
+	rq->timeout = 10 * HZ;
+	vl_cdb = (struct scsi_varlen_cdb_hdr *)rq->cmd;
+	vl_cdb->additional_cdb_length = 2;
+	vl_cdb->service_action = sa_op;
+	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
+	switch (sa_op) {
+	case PARK_HEADS:
+		blk_stop_queue(q);
+		q->request_fn(q);
+		break;
+	case UNPARK_HEADS:
+		blk_start_queue(q);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void ata_scsi_unpark_work(struct work_struct *work)
+{
+	struct ata_device *dev = container_of(work, struct ata_device,
+					      unpark_work);
+	struct scsi_device *sdev = dev->sdev;
+	struct request_queue *q = sdev->request_queue;
+	struct request *rq;
+
+	rq = blk_get_request(q, 0, __GFP_WAIT);
+	spin_lock_irq(q->queue_lock);
+	if (likely(!timer_pending(&dev->park_timer)))
+		ata_scsi_issue_park_cmd(dev, rq, UNPARK_HEADS);
+	else
+		__blk_put_request(q, rq);
+	ata_scsi_signal_unpark();
+	spin_unlock_irq(q->queue_lock);
+	scsi_device_put(sdev);
+}
+
+static void ata_scsi_park_timeout(unsigned long data)
+{
+	struct ata_device *dev = (struct ata_device *)data;
+
+	queue_work(ata_aux_wq, &dev->unpark_work);
+	/* FIXME: Is that correct or should I use ata_wq instead? */
+}
+
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
@@ -994,6 +1225,12 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
 	}
 
+	/* configure disk head parking */
+	INIT_WORK(&dev->unpark_work, ata_scsi_unpark_work);
+	dev->park_timer.function = ata_scsi_park_timeout;
+	dev->park_timer.data = (unsigned long)dev;
+	init_timer(&dev->park_timer);
+
 	return 0;
 }
 
@@ -1227,6 +1464,65 @@ invalid_fld:
 	return 1;
 }
 
+/**
+ *	ata_scsi_park_xlat - Translate private PARK_HEADS command
+ *	@qc: Storage for translated ATA taskfile
+ *
+ *	Sets up an ATA taskfile to issue IDLE IMMEDIATE with UNLOAD
+ *	FEATURE.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+static unsigned int ata_scsi_park_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct ata_device *dev = qc->dev;
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_IDLEIMMEDIATE;
+	tf->feature = 0x44;
+	tf->lbal = 0x4c;
+	tf->lbam = 0x4e;
+	tf->lbah = 0x55;
+
+	dev->flags |= ATA_DFLAG_PARKED;
+	dev->sdev->max_device_blocked = 2;
+
+	return 0;
+}
+
+/**
+ *	ata_scsi_unpark_xlat - Translate private UNPARK_HEADS command
+ *	@qc: Storage for translated ATA taskfile
+ *
+ *	Issues a CHECK POWER CONDITION command indicating to the device
+ *	that it can resume normal operation.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, non-zero on error.
+ */
+static unsigned int ata_scsi_unpark_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct ata_device *dev = qc->dev;
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_CHK_POWER;
+
+	dev->flags &= ~ATA_DFLAG_PARKED;
+	dev->sdev->max_device_blocked = 1;
+
+	return 0;
+}
 
 /**
  *	ata_scsi_flush_xlat - Translate SCSI SYNCHRONIZE CACHE command
@@ -1658,6 +1954,15 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	VPRINTK("ENTER\n");
 
+	if (unlikely(dev->flags & ATA_DFLAG_PARKED)) {
+		struct scsi_varlen_cdb_hdr *vl_cdb;
+
+		vl_cdb = (struct scsi_varlen_cdb_hdr *) cmd->cmnd;
+		if (vl_cdb->opcode != VARIABLE_LENGTH_CMD
+		    || vl_cdb->service_action != UNPARK_HEADS)
+			return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
 	qc = ata_scsi_qc_new(dev, cmd, done);
 	if (!qc)
 		goto err_mem;
@@ -1724,7 +2029,7 @@ defer:
  *	Prepare buffer for simulated SCSI commands.
  *
  *	LOCKING:
- *	spin_lock_irqsave(ata_scsi_rbuf_lock) on success
+ *	spin_lock_irqsave(ata_scsi_lock) on success
  *
  *	RETURNS:
  *	Pointer to response buffer.
@@ -1732,7 +2037,7 @@ defer:
 static void *ata_scsi_rbuf_get(struct scsi_cmnd *cmd, bool copy_in,
 			       unsigned long *flags)
 {
-	spin_lock_irqsave(&ata_scsi_rbuf_lock, *flags);
+	spin_lock_irqsave(&ata_scsi_lock, *flags);
 
 	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
 	if (copy_in)
@@ -1751,7 +2056,7 @@ static void *ata_scsi_rbuf_get(struct scsi_cmnd *cmd, bool copy_in,
  *	@copy_back is true.
  *
  *	LOCKING:
- *	Unlocks ata_scsi_rbuf_lock.
+ *	Unlocks ata_scsi_lock.
  */
 static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, bool copy_out,
 				     unsigned long *flags)
@@ -1759,7 +2064,7 @@ static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, bool copy_out,
 	if (copy_out)
 		sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
 				    ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
-	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, *flags);
+	spin_unlock_irqrestore(&ata_scsi_lock, *flags);
 }
 
 /**
@@ -2814,9 +3119,10 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
  *	Pointer to translation function if possible, %NULL if not.
  */
 
-static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
+static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
+						struct scsi_cmnd *scmd)
 {
-	switch (cmd) {
+	switch (scmd->cmnd[0]) {
 	case READ_6:
 	case READ_10:
 	case READ_16:
@@ -2841,6 +3147,18 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
+
+	case VARIABLE_LENGTH_CMD:
+		if (scmd->cmd_len < 10)
+			break;
+		switch (((struct scsi_varlen_cdb_hdr *)
+			 scmd->cmnd)->service_action) {
+		case PARK_HEADS:
+			return ata_scsi_park_xlat;
+
+		case UNPARK_HEADS:
+			return ata_scsi_unpark_xlat;
+		}
 	}
 
 	return NULL;
@@ -2874,7 +3192,6 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 				      void (*done)(struct scsi_cmnd *),
 				      struct ata_device *dev)
 {
-	u8 scsi_op = scmd->cmnd[0];
 	ata_xlat_func_t xlat_func;
 	int rc = 0;
 
@@ -2882,15 +3199,15 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 		if (unlikely(!scmd->cmd_len || scmd->cmd_len > dev->cdb_len))
 			goto bad_cdb_len;
 
-		xlat_func = ata_get_xlat_func(dev, scsi_op);
+		xlat_func = ata_get_xlat_func(dev, scmd);
 	} else {
 		if (unlikely(!scmd->cmd_len))
 			goto bad_cdb_len;
 
 		xlat_func = NULL;
-		if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
+		if (likely((scmd->cmnd[0] != ATA_16) || !atapi_passthru16)) {
 			/* relay SCSI command to ATAPI device */
-			int len = COMMAND_SIZE(scsi_op);
+			int len = COMMAND_SIZE(scmd->cmnd[0]);
 			if (unlikely(len > scmd->cmd_len || len > dev->cdb_len))
 				goto bad_cdb_len;
 
@@ -2900,7 +3217,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 			if (unlikely(scmd->cmd_len > 16))
 				goto bad_cdb_len;
 
-			xlat_func = ata_get_xlat_func(dev, scsi_op);
+			xlat_func = ata_get_xlat_func(dev, scmd);
 		}
 	}
 
@@ -2913,7 +3230,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 
  bad_cdb_len:
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
-		scmd->cmd_len, scsi_op, dev->cdb_len);
+		scmd->cmd_len, scmd->cmnd[0], dev->cdb_len);
 	scmd->result = DID_ERROR << 16;
 	done(scmd);
 	return 0;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index f6f9c28..1a03efa 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -31,6 +31,10 @@
 #define DRV_NAME	"libata"
 #define DRV_VERSION	"3.00"	/* must be exactly four chars */
 
+/* private scsi opcodes */
+#define PARK_HEADS	0xf800
+#define UNPARK_HEADS	0xf801
+
 struct ata_scsi_args {
 	struct ata_device	*dev;
 	u16			*id;
@@ -149,6 +153,13 @@ extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
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
index 5b247b8..b40550d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -150,6 +150,7 @@ enum {
 
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
+	ATA_DFLAG_PARKED	= (1 << 26),
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -451,6 +452,7 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -592,6 +594,10 @@ struct ata_device {
 		u16		id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
 		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
 	};
+
+	/* protected by block layer queue lock */
+	struct timer_list park_timer;
+	struct work_struct unpark_work;
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained


