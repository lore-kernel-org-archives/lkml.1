Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYIQQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYIQQh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYIQQht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:37:49 -0400
Received: from nebensachen.de ([195.34.83.29]:54420 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYIQQhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:37:48 -0400
X-Hashcash: 1:20:080917:bzolnier@gmail.com::r8myjJmRF0wQE7ap:00000000000000000000000000000000000000000000GL7
X-Hashcash: 1:20:080917:jeff@garzik.org::bx+/L+YaTqTK0rIF:00D8/O
X-Hashcash: 1:20:080917:randy.dunlap@oracle.com::4BfpO/9QUDt12dex:0000000000000000000000000000000000000019Tx
X-Hashcash: 1:20:080917:htejun@gmail.com::eISyV2rCN3/QP8Zt:016NN
X-Hashcash: 1:20:080917:linux-ide@vger.kernel.org::OaL2q0LnWpXgtcfq:00000000000000000000000000000000000037Nj
X-Hashcash: 1:20:080917:linux-kernel@vger.kernel.org::p8c2bzODL3re8Q1E:0000000000000000000000000000000005jCL
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4 v2] libata: Implement disk shock protection support
In-Reply-To: <87d4j2n3dn.fsf@denkblock.local>
Message-ID: <20080917163144.9870.97008.stgit@denkblock.local>
References: <87d4j2n3dn.fsf@denkblock.local>
User-Agent: StGIT/0.14.2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 18:37:28 +0200
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
FEATURE as specified in ATA-7 is issued to the device and processing of
the request queue is stopped thereafter until the specified timeout
expires or user space asks to resume normal operation. This is supposed
to prevent the heads of a hard drive from accidentally crashing onto the
platter when a heavy shock is anticipated (like a falling laptop
expected to hit the floor). In fact, the whole port stops processing
commands until the timeout has expired in order to avoid any resets due
to failed commands on another device.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ata/ahci.c        |    1 
 drivers/ata/libata-eh.c   |  120 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |  110 +++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h      |    1 
 include/linux/libata.h    |   12 ++++-
 5 files changed, 241 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 2e1a7cb..fd813fa 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -316,6 +316,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 
 static struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
 	NULL
 };
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bd0b2bc..5930613 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1211,6 +1211,50 @@ void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 }
 
 /**
+ *	ata_eh_pull_action - pull eh_action into eh_context on-the-fly
+ *	@link: target ATA link
+ *	@dev: target ATA dev for per-dev action (can be NULL)
+ *	@action: action to be pulled in from eh_info
+ *
+ *	Called when we are ready to perform EH actions.  When this
+ *	function is called, we don't know yet whether the specified
+ *	actions are actually going to be performed.
+ *	ata_eh_about_to_do(), on the other hand, is only called when
+ *	the EH actions have been specified in eh_context anyway and
+ *	therefore definitely will be performed subsequently.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void ata_eh_pull_action(struct ata_link *link, struct ata_device *dev,
+			unsigned int action)
+{
+	struct ata_port *ap = link->ap;
+	struct ata_eh_info *ehi = &link->eh_info, *ehci = &link->eh_context.i;
+	struct ata_device *tdev;
+	unsigned int taction;
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
+
+	if (dev) {
+		taction = action & (ehi->action | ehi->dev_action[dev->devno]);
+		ehci->dev_action[dev->devno] |= taction & ATA_EH_PERDEV_MASK;
+		ehci->action |= taction & ~ATA_EH_PERDEV_MASK;
+	} else {
+		if (WARN_ON(action & ATA_EH_PERDEV_MASK))
+			action &= ~ATA_EH_PERDEV_MASK;
+		ata_link_for_each_dev(tdev, link)
+			taction |= ehi->dev_action[tdev->devno] & action;
+		ehci->action |= (ehi->action & action) | taction;
+	}
+
+	ata_eh_clear_action(link, dev, ehi, action);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+}
+
+/**
  *	ata_eh_done - EH action complete
 *	@ap: target ATA port
  *	@dev: target ATA dev for per-dev action (can be NULL)
@@ -2447,6 +2491,40 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	goto retry;
 }
 
+static void ata_eh_park_issue_cmd(struct ata_device *dev, int park)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_tf_init(dev, &tf);
+	if (park) {
+		if (ehc->unloaded_mask & (1 << dev->devno))
+			return;
+
+		ehc->unloaded_mask |= 1 << dev->devno;
+		tf.command = ATA_CMD_IDLEIMMEDIATE;
+		tf.feature = 0x44;
+		tf.lbal = 0x4c;
+		tf.lbam = 0x4e;
+		tf.lbah = 0x55;
+	} else {
+		if (!(ehc->unloaded_mask & (1 << dev->devno)))
+			return;
+
+		ehc->unloaded_mask &= ~(1 << dev->devno);
+		tf.command = ATA_CMD_CHK_POWER;
+	}
+
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
+	if (park && (err_mask || tf.lbal != 0xc4)) {
+		ata_dev_printk(dev, KERN_ERR, "head unload failed!\n");
+		ehc->unloaded_mask &= ~(1 << dev->devno);
+	}
+}
+
 static int ata_eh_revalidate_and_attach(struct ata_link *link,
 					struct ata_device **r_failed_dev)
 {
@@ -2754,9 +2832,10 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 {
 	struct ata_link *link;
 	struct ata_device *dev;
+	DEFINE_WAIT(wait);
 	int nr_failed_devs;
 	int rc;
-	unsigned long flags;
+	unsigned long flags, deadline;
 
 	DPRINTK("ENTER\n");
 
@@ -2830,6 +2909,45 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		}
 	}
 
+	do {
+		unsigned long now;
+
+		deadline = jiffies;
+		ata_port_for_each_link(link, ap) {
+			ata_link_for_each_dev(dev, link) {
+				struct ata_eh_info *ehi = &link->eh_context.i;
+
+				if (dev->class != ATA_DEV_ATA)
+					continue;
+
+				ata_eh_pull_action(link, dev, ATA_EH_PARK);
+				if (ehi->dev_action[dev->devno] & ATA_EH_PARK) {
+					unsigned long tmp =
+						dev->unpark_deadline;
+
+					if (time_before(deadline, tmp))
+						deadline = tmp;
+					else if (time_before_eq(tmp, jiffies))
+						continue;
+				}
+
+				ata_eh_park_issue_cmd(dev, 1);
+			}
+		}
+		now = jiffies;
+		if (time_before_eq(deadline, now))
+			break;
+		prepare_to_wait(&ata_scsi_park_wq, &wait, TASK_UNINTERRUPTIBLE);
+		deadline = schedule_timeout_uninterruptible(deadline - now);
+	} while (deadline);
+	finish_wait(&ata_scsi_park_wq, &wait);
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			ata_eh_park_issue_cmd(dev, 0);
+			ata_eh_done(link, dev, ATA_EH_PARK);
+		}
+	}
+
 	/* the rest */
 	ata_port_for_each_link(link, ap) {
 		struct ata_eh_context *ehc = &link->eh_context;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4d066ad..ba3a490 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -55,6 +55,8 @@
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
 static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
+DECLARE_WAIT_QUEUE_HEAD(ata_scsi_park_wq);
+
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
@@ -183,6 +185,105 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static ssize_t ata_scsi_park_show(struct device *device,
+				  struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_link *link;
+	struct ata_device *dev;
+	unsigned long flags;
+	unsigned int uninitialized_var(msecs);
+	int rc = 0;
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	link = dev->link;
+	if (ap->pflags & ATA_PFLAG_EH_IN_PROGRESS &&
+	    link->eh_context.unloaded_mask & (1 << dev->devno) &&
+	    time_after(dev->unpark_deadline, jiffies))
+		msecs = jiffies_to_msecs(dev->unpark_deadline - jiffies);
+	else
+		msecs = 0;
+
+unlock:
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : snprintf(buf, 20, "%u\n", msecs);
+}
+
+static ssize_t ata_scsi_park_store(struct device *device,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	long int input;
+	unsigned long flags;
+	int rc;
+
+	rc = strict_strtol(buf, 10, &input);
+	if (rc || input < -2)
+		return -EINVAL;
+	if (input > ATA_TMOUT_MAX_PARK) {
+		rc = -EOVERFLOW;
+		input = ATA_TMOUT_MAX_PARK;
+	}
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev)) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+	if (dev->class != ATA_DEV_ATA) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (input >= 0) {
+		if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
+			rc = -EOPNOTSUPP;
+			goto unlock;
+		}
+
+		dev->unpark_deadline = ata_deadline(jiffies, input);
+		dev->link->eh_info.dev_action[dev->devno] |= ATA_EH_PARK;
+		ata_port_schedule_eh(ap);
+		wake_up_all(&ata_scsi_park_wq);
+	} else {
+		switch (input) {
+		case -1:
+			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
+			break;
+		case -2:
+			dev->flags |= ATA_DFLAG_NO_UNLOAD;
+			break;
+		}
+	}
+unlock:
+	spin_unlock_irqrestore(ap->lock, flags);
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
@@ -269,6 +370,12 @@ DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
+struct device_attribute *ata_common_sdev_attrs[] = {
+	&dev_attr_unload_heads,
+	NULL
+};
+EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
@@ -954,6 +1061,9 @@ static int atapi_drain_needed(struct request *rq)
 static int ata_scsi_dev_config(struct scsi_device *sdev,
 			       struct ata_device *dev)
 {
+	if (!ata_id_has_unload(dev->id))
+		dev->flags |= ATA_DFLAG_NO_UNLOAD;
+
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 24f5005..3869e6a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -148,6 +148,7 @@ extern void ata_scsi_hotplug(struct work_struct *work);
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
+extern wait_queue_head_t ata_scsi_park_wq;
 
 /* libata-eh.c */
 extern unsigned long ata_internal_cmd_timeout(struct ata_device *dev, u8 cmd);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 225bfc5..ffd7cea 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -146,6 +146,7 @@ enum {
 	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
+	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -244,6 +245,7 @@ enum {
 	ATA_TMOUT_BOOT		= 30000,	/* heuristic */
 	ATA_TMOUT_BOOT_QUICK	=  7000,	/* heuristic */
 	ATA_TMOUT_INTERNAL_QUICK = 5000,
+	ATA_TMOUT_MAX_PARK	= 30000,
 
 	/* FIXME: GoVault needs 2s but we can't afford that without
 	 * parallel probing.  800ms is enough for iVDR disk
@@ -319,8 +321,9 @@ enum {
 	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
 	ATA_EH_ENABLE_LINK	= (1 << 3),
 	ATA_EH_LPM		= (1 << 4),  /* link power management action */
+	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
 
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
@@ -452,6 +455,7 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -564,6 +568,7 @@ struct ata_device {
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
 	unsigned int		class;		/* ATA_DEV_xxx */
+	unsigned long		unpark_deadline;
 
 	u8			pio_mode;
 	u8			dma_mode;
@@ -621,6 +626,7 @@ struct ata_eh_context {
 					       [ATA_EH_CMD_TIMEOUT_TABLE_SIZE];
 	unsigned int		classes[ATA_MAX_DEVICES];
 	unsigned int		did_probe_mask;
+	unsigned int		unloaded_mask;
 	unsigned int		saved_ncq_enabled;
 	u8			saved_xfer_mode[ATA_MAX_DEVICES];
 	/* timestamp for the last reset attempt or success */
@@ -1098,6 +1104,7 @@ extern void ata_std_error_handler(struct ata_port *ap);
  */
 extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
+extern struct device_attribute *ata_common_sdev_attrs[];
 
 #define ATA_BASE_SHT(drv_name)					\
 	.module			= THIS_MODULE,			\
@@ -1112,7 +1119,8 @@ extern const struct ata_port_operations sata_port_ops;
 	.proc_name		= drv_name,			\
 	.slave_configure	= ata_scsi_slave_config,	\
 	.slave_destroy		= ata_scsi_slave_destroy,	\
-	.bios_param		= ata_std_bios_param
+	.bios_param		= ata_std_bios_param,		\
+	.sdev_attrs		= ata_common_sdev_attrs
 
 #define ATA_NCQ_SHT(drv_name)					\
 	ATA_BASE_SHT(drv_name),					\


