Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYICUZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYICUZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYICUZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:25:28 -0400
Received: from nebensachen.de ([195.34.83.29]:33089 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbYICUZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:25:26 -0400
X-Hashcash: 1:20:080903:htejun@gmail.com::aeoP3oduk7/Krvcr:011cc
X-Hashcash: 1:20:080903:alan@lxorguk.ukuu.org.uk::du6rvlh5xMjPqT9A:000000000000000000000000000000000000052DJ
X-Hashcash: 1:20:080903:akpm@linux-foundation.org::McY0R6VI5/+psHs0:0000000000000000000000000000000000001snf
X-Hashcash: 1:20:080903:bzolnier@gmail.com::w2wqI+kG2iJMKLan:00000000000000000000000000000000000000000003FDJ
X-Hashcash: 1:20:080903:jeff@garzik.org::9E8oC9gjDJqFJEfZ:0045tq
X-Hashcash: 1:20:080903:randy.dunlap@oracle.com::ui8VKtf1h1cNBP3V:000000000000000000000000000000000000000Dic
X-Hashcash: 1:20:080903:linux-ide@vger.kernel.org::+HtcNTjHlcsZ7BJi:0000000000000000000000000000000000001iHR
X-Hashcash: 1:20:080903:linux-kernel@vger.kernel.org::6NZyshHME4msSHWZ:00000000000000000000000000000000001P6
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>
	<20080829211345.4355.89284.stgit@denkblock.local>
	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>
	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>
	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>
	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>
	<48BC1BB8.2030007@gmail.com>
Date: Wed, 03 Sep 2008 22:23:30 +0200
In-Reply-To: <48BC1BB8.2030007@gmail.com> (Tejun Heo's message of "Mon, 01 Sep
	2008 18:43:36 +0200")
Message-ID: <87fxoh0yil.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Elias Oltmanns wrote:
[...]
>> With regard to the pm_notifiers, I'll try to figure out exactly what
>> the problem was without them (I thought it was related to timers not
>> firing anymore after process freezing, but Pavel doubts that and I'm
>> not too sure anymore).
>
> Hmm... I don't think pm notifiers would be necessary to prevent things
> like that.  Anyways, please investigate and let us know.

As yet, I haven't been able to reproduce the problems with an
implementation without a dedicated park_timer. So, I'm fine with
dropping the pm_notifiers after all.

>
>>> Really, it doesn't matter at all.  That's just an over optimization.
>>> The whole EH machinery pretty much expects spurious EH events and
>>> schedules and deals with them quite well.  No need to add extra
>>> protection.
>> 
>> ... because of its complexity it is hard for me to estimate timing
>> impacts and constraints. The questions I'm concerned about are: What is
>> the average and worst case time it takes to get the heads parked and
>> what can I do if not to improve either of them, then at least not to make
>> things worse. In particular, I don't really have a clue about how much
>> time it takes to go through EH if no action is requested in comparison
>> to, say, the average read / write command. Obviously, I don't want to
>> schedule EH unnecessarily if that would mean that I won't be able to
>> issue another head unload for considerably longer than during normal I/O
>> or, indeed, on an idle system. Arguably, I don't even want to do
>> anything that causes more logging than absolutely necessary because this
>> will ultimately result in the disk spinning up from standby. But then I
>> believe that I only came across this logging issue when I was still
>> playing around with eh_revalidate and the like. So, can you set my mind
>> at rest that timing is no issue with spurious EH sequences? Now that I
>> come to think of it, I suppose it would harm performance anyway, so
>> everybody would care about such a delay, right?
>
> I can't tell you the exact delays, but sans times for actual actions,
> there is no real delay.  It just involves scheduling a few times and
> jumps through various functions in EH.  I don't think that would be
> anything measureable.
>
> Also, generating duplicate events.  Events would be duplicate only
> when those events occur during EH is in progress, right?

Yes, but that will be the rule rather than the exception because the
daemon will hardly ever let the timeout expire. Eitehr it decides that
it needs to extend the timeout, or it recons that everything's going to
be alright and issues a 0 timeout in order to resume normal operation
immediately.

> In that case, as EH finishes it would see that there's another EH
> action requested and re-enter EH. The second invocation of EH would go
> through the diagnostic steps (doesn't involve issuing any command,
> just checks data structures) and find out that there's nothing to do
> and just exit. For those bogus runs, EH won't print out anything
> either. So, really, nothing to worry about there.
>
> If that's not enough assurance, even ATAPI CHECK SENSE is done via EH.
> That is, many ATAPI commands invoke EH after completion but nobody
> really notices or pays attention to it.

Right then. Here is another patch where, hopefully, most of your
concerns have been addressed. Please tell me what you make of it
(applies to next-20080903).

Regards,

Elias

---

 drivers/ata/ahci.c        |    1 +
 drivers/ata/ata_piix.c    |    6 +++
 drivers/ata/libata-eh.c   |   48 ++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |   84 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h      |    1 +
 include/linux/libata.h    |    4 ++
 6 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c729e69..9539050 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -316,6 +316,7 @@ static struct device_attribute *ahci_shost_attrs[] = {
 
 static struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
+	&dev_attr_unload_heads,
 	NULL
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b1d08a8..1b470ad 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -298,8 +298,14 @@ static struct pci_driver piix_pci_driver = {
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
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bd0b2bc..7754f32 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2447,6 +2447,40 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	goto retry;
 }
 
+static void ata_eh_park_devs(struct ata_port *ap, int park)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	ata_port_for_each_link(link, ap) {
+		ata_link_for_each_dev(dev, link) {
+			if (dev->class != ATA_DEV_ATA ||
+			    dev->flags & ATA_DFLAG_NO_UNLOAD)
+				continue;
+
+			ata_tf_init(dev, &tf);
+			if (park) {
+				tf.command = ATA_CMD_IDLEIMMEDIATE;
+				tf.feature = 0x44;
+				tf.lbal = 0x4c;
+				tf.lbam = 0x4e;
+				tf.lbah = 0x55;
+			} else
+				tf.command = ATA_CMD_CHK_POWER;
+			tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+			tf.protocol |= ATA_PROT_NODATA;
+
+			err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE,
+						     NULL, 0, 0);
+			if ((err_mask || tf.lbal != 0xc4) && park)
+				ata_dev_printk(dev, KERN_ERR,
+					       "head unload failed!\n");
+		}
+	}
+}
+
 static int ata_eh_revalidate_and_attach(struct ata_link *link,
 					struct ata_device **r_failed_dev)
 {
@@ -2830,6 +2864,20 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		}
 	}
 
+	if (ap->link.eh_context.i.action & ATA_EH_PARK &&
+	    time_after(ap->unpark_deadline, jiffies)) {
+		DEFINE_WAIT(wait);
+
+		ata_eh_park_devs(ap, 1);
+		do
+			prepare_to_wait(&ata_scsi_park_wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+		while (schedule_timeout_uninterruptible(ap->unpark_deadline -
+							jiffies));
+		finish_wait(&ata_scsi_park_wq, &wait);
+		ata_eh_park_devs(ap, 0);
+	}
+
 	/* the rest */
 	ata_port_for_each_link(link, ap) {
 		struct ata_eh_context *ehc = &link->eh_context;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4d066ad..c9ac314 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -55,6 +55,8 @@
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
 static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
+DECLARE_WAIT_QUEUE_HEAD(ata_scsi_park_wq);
+
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
 static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
@@ -183,6 +185,85 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
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
+	if (time_after(ap->unpark_deadline, jiffies))
+		/*
+		 * Adding 1 in order to guarantee nonzero value until timer
+		 * has actually expired.
+		 */
+		seconds = jiffies_to_msecs(ap->unpark_deadline - jiffies)
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
+	long int input;
+	int rc;
+
+	rc = strict_strtol(buf, 10, &input);
+	if (rc || input < -2 || input > MAX_PARK_TIMEOUT)
+		return -EINVAL;
+
+	ap = ata_shost_to_port(sdev->host);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev))
+		return -ENODEV;
+
+	spin_lock_irq(ap->lock);
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
+		ap->link.eh_info.action |= ATA_EH_PARK;
+		ata_port_schedule_eh(ap);
+		ap->unpark_deadline = ata_deadline(jiffies, input * 1000);
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
+	spin_unlock_irq(ap->lock);
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
@@ -954,6 +1035,9 @@ static int atapi_drain_needed(struct request *rq)
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
index 225bfc5..b3a04a4 100644
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
 
@@ -452,6 +454,7 @@ enum link_pm {
 	MEDIUM_POWER,
 };
 extern struct device_attribute dev_attr_link_power_management_policy;
+extern struct device_attribute dev_attr_unload_heads;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -716,6 +719,7 @@ struct ata_port {
 
 	struct timer_list	fastdrain_timer;
 	unsigned long		fastdrain_cnt;
+	unsigned long		unpark_deadline;
 
 	int			em_message_type;
 	void			*private_data;
