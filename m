Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYH3Xk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYH3Xk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 19:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbYH3XkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 19:40:13 -0400
Received: from nebensachen.de ([195.34.83.29]:59041 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbYH3XkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 19:40:11 -0400
X-Hashcash: 1:20:080830:htejun@gmail.com::WTC+f22SPOy8RyoR:09MkQ
X-Hashcash: 1:20:080830:alan@lxorguk.ukuu.org.uk::zKeXDiyplMlIOjqT:00000000000000000000000000000000000001Rej
X-Hashcash: 1:20:080830:akpm@linux-foundation.org::dVn51OXZDTii+tFm:00000000000000000000000000000000000025Of
X-Hashcash: 1:20:080830:bzolnier@gmail.com::mIx33eNOJBn7zWtk:00000000000000000000000000000000000000000003B7w
X-Hashcash: 1:20:080830:jeff@garzik.org::j/Nql5ufhHkkagum:00CQ+N
X-Hashcash: 1:20:080830:randy.dunlap@oracle.com::A2Y7infW+YODRZju:00000000000000000000000000000000000000B573
X-Hashcash: 1:20:080830:linux-ide@vger.kernel.org::5XMXvmbDk4SUv/S5:0000000000000000000000000000000000000Hdj
X-Hashcash: 1:20:080830:linux-kernel@vger.kernel.org::vAWW6wVDn5BcA9Rq:0000000000000000000000000000000003sGs
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
	<48B913E6.1000104@gmail.com>
Date: Sun, 31 Aug 2008 01:38:58 +0200
Message-ID: <87k5dym5t9.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Elias Oltmanns wrote:
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index c729e69..78281af 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -316,6 +316,8 @@ static struct device_attribute *ahci_shost_attrs[] = {
>>  
>>  static struct device_attribute *ahci_sdev_attrs[] = {
>>  	&dev_attr_sw_activity,
>> +	&dev_attr_unload_feature,
>> +	&dev_attr_unload_heads,
>>  	NULL
>
> Ehhh... This really should be in libata core layer.  Please create the
> default attrs and let ahci define its own.

Right, will do.

[...]
>> @@ -5267,6 +5267,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>>  	init_timer_deferrable(&ap->fastdrain_timer);
>>  	ap->fastdrain_timer.function = ata_eh_fastdrain_timerfn;
>>  	ap->fastdrain_timer.data = (unsigned long)ap;
>> +	ap->park_timer.function = ata_scsi_park_timeout;
>> +	init_timer(&ap->park_timer);
>
> Why do you need a timeout when you can just msleep()?

Maybe I'm missing something but I don't see how I could use msleep()
here, see below.

>
>> +static void ata_eh_park_devs(struct ata_port *ap, int park)
>> +{
>> +	struct ata_link *link;
>> +	struct ata_device *dev;
>> +	struct ata_taskfile tf;
>> +	struct request_queue *q;
>> +	unsigned int err_mask;
>> +
>> +	ata_port_for_each_link(link, ap) {
>> +		ata_link_for_each_dev(dev, link) {
>> +			if (!dev->sdev)
>> +				continue;
>
> You probably want to do if (dev->class != ATA_DEV_ATA) here.

Well, I really am concerned about dev->sdev. So far, I haven't quite
figured out yet whether under which circumstances I can safely assume
that the scsi counter part of dev including the block layer request
queue has been completely set up and configured so there won't be any
null pointer dereferences. However, if you think that I needn't bother
with stopping the request queue anyway, checking for ATA_DEV_ATA (what
about ATA_DEV_ATAPI?) should definitely be enough.

>
>> +			ata_tf_init(dev, &tf);
>> +			q = dev->sdev->request_queue;
>> +			spin_lock_irq(q->queue_lock);
>> +			if (park) {
>> +				blk_stop_queue(q);
>
> Queue is already plugged when EH is entered.  No need for this.

Quite right. It's just that it will be un- and replugged every
(3 * HZ) / 1000, so I thought it might be worthwhile to stop the queue
anyway. Perhaps it really isn't worth bothering and the code would
certainly be nicer to look at.

>
>> +				tf.command = ATA_CMD_IDLEIMMEDIATE;
>> +				tf.feature = 0x44;
>> +				tf.lbal = 0x4c;
>> +				tf.lbam = 0x4e;
>> +				tf.lbah = 0x55;
> n> +			} else {
>> +				blk_start_queue(q);
>
> Neither this.
>
>> +				tf.command = ATA_CMD_CHK_POWER;
>> +			}
>> +			spin_unlock(q->queue_lock);
>> +			spin_lock(ap->lock);
>
> And no need to play with locks at all.

Just to be sure, are you just referring to the queue lock, or to the host
lock as well? Am I wrong in thinking that we have to protect all access
to dev->flags because bit operations are performed non atomically
virtually at any time?

>
>> +			if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
>> +				spin_unlock_irq(ap->lock);
>> +				continue;
>> +			}
>> +			spin_unlock_irq(ap->lock);
>> +
>> +			tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
>> +			tf.protocol |= ATA_PROT_NODATA;
>> +			err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE,
>> +						     NULL, 0, 0);
>> +			if ((err_mask || tf.lbal != 0xc4) && park)
>> +				ata_dev_printk(dev, KERN_ERR,
>> +					       "head unload failed\n");
>> +		}
>> +	}
>> +}
>> +
>>  static int ata_eh_revalidate_and_attach(struct ata_link *link,
>>  					struct ata_device **r_failed_dev)
>>  {
>> @@ -2829,6 +2874,12 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>>  		}
>>  	}
>>  
>> +	if (ap->link.eh_context.i.action & ATA_EH_PARK) {
>> +		ata_eh_park_devs(ap, 1);
>> +		wait_event(ata_scsi_park_wq, !timer_pending(&ap->park_timer));
>
> I would just msleep() here.

Again, see below.

>
>> +		ata_eh_park_devs(ap, 0);
>
> And does the device need this explicit wake up?  It will wake up when
> it's necessary.

Probably, I should insert a comment somewhere. The problem is that
device internal power management will be disabled until the next command
is received. If you have laptop mode enabled and the device has received
the unload command while spinning with no more commands in the queue to
follow, the device may keep spinning for quite a while and won't go into
standby which rather defeats the purpose of laptop mode. This behaviour
is compliant with the specs and I can observe it on my system.

>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 4d066ad..ffcc016 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -46,6 +46,7 @@
>>  #include <linux/libata.h>
>>  #include <linux/hdreg.h>
>>  #include <linux/uaccess.h>
>> +#include <linux/suspend.h>
>>  
>>  #include "libata.h"
>>  
>> @@ -113,6 +114,77 @@ static struct scsi_transport_template ata_scsi_transport_template = {
>>  	.user_scan		= ata_scsi_user_scan,
>>  };
>>  
>> +DECLARE_WAIT_QUEUE_HEAD(ata_scsi_park_wq);
>> +
>> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
>> +static atomic_t ata_scsi_park_count = ATOMIC_INIT(0);
>> +
>> +static int ata_scsi_pm_notifier(struct notifier_block *nb, unsigned long val,
>> +				void *null)
>> +{
>> +	switch (val) {
>> +	case PM_SUSPEND_PREPARE:
>> +		atomic_dec(&ata_scsi_park_count);
>> +		wait_event(ata_scsi_park_wq,
>> +			   atomic_read(&ata_scsi_park_count) == -1);
>> +		break;
>> +	case PM_POST_SUSPEND:
>> +		atomic_inc(&ata_scsi_park_count);
>> +		break;
>> +	default:
>> +		return NOTIFY_DONE;
>> +	}
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block ata_scsi_pm_notifier_block = {
>> +	.notifier_call = ata_scsi_pm_notifier,
>> +};
>> +
>> +int ata_scsi_register_pm_notifier(void)
>> +{
>> +	return register_pm_notifier(&ata_scsi_pm_notifier_block);
>> +}
>> +
>> +int ata_scsi_unregister_pm_notifier(void)
>> +{
>> +	return unregister_pm_notifier(&ata_scsi_pm_notifier_block);
>> +}
>
> Why are these PM notifiers necessary?

Since it's a user process that controls when we have to keep the heads
off the platter, a suspend operation has to be blocked *before* process
freezing when we happen to be in a precarious situation.

>
>> +static inline void ata_scsi_signal_unpark(void)
>> +{
>> +	atomic_dec(&ata_scsi_park_count);
>> +	wake_up_all(&ata_scsi_park_wq);
>> +}
>> +
>> +static inline int ata_scsi_mod_park_timer(struct timer_list *timer,
>> +					  unsigned long timeout)
>> +{
>> +	if (unlikely(atomic_inc_and_test(&ata_scsi_park_count))) {
>> +		ata_scsi_signal_unpark();
>> +		return -EBUSY;
>> +	}
>> +	if (mod_timer(timer, timeout)) {
>> +		atomic_dec(&ata_scsi_park_count);
>> +		return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>>
>> +#else /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
>> +static inline void ata_scsi_signal_unpark(void)
>> +{
>> +	wake_up_all(&ata_scsi_park_wq);
>> +}
>> +
>> +static inline int ata_scsi_mod_park_timer(struct timer_list *timer,
>> +					  unsigned long timeout)
>> +{
>> +	return mod_timer(timer, timeout);
>> +}
>> +#endif /* defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION) */
>
> And these all can go.  If you're worried about recurring events you
> can just update timestamp from the sysfs write function and do...
>
>     deadline = last_timestamp + delay;
>     while ((now = jiffies) < deadline) {
>         set_current_state(TASK_UNINTERRUPTIBLE);
> 	schedule_timeout(deadline - now);
> 	set_current_state(TASK_RUNNING);
>     }

Ah, I can see that this while loop can replace my call to wait_event() in
the eh sequence earlier on. However, I wonder how I am to replace the
call to mod_timer(). As you can see, we perform different actions
depending on whether the timer has merely been updated, or a new timer
has been started. Only in the latter case we want to schedule eh. In
order to achieve the equivalent in your setting while preventing any
races, I'd have to protect the deadline field in struct ata_port by the
host lock, i.e. something like:

    spin_lock_irq(ap->lock);
    now = jiffies;
    rc = now > ap->deadline;
    ap->deadline = now + timeout;
    if (rc) {
        ap->link.eh_info.action |= ATA_EH_PARK;
        ata_port_schedule_eh(ap);
    }
    ...
    spin_unlock_irq(ap->lock);

and in the eh code a modified version of your loop:

    spin_lock_irq(ap->lock);
    while ((now = jiffies) < deadline) {
        spin_unlock_irq(ap->lock);
        set_current_state(TASK_UNINTERRUPTIBLE);
        schedule_timeout(deadline - now);
        set_current_state(TASK_RUNNING);
        spin_lock_irq(ap->lock);
    }
    spin_unlock_irq(ap->lock);

Is it worth all that or am I missing something? On the other hand, a
deadline field would occupy less space in the ata_port structure than a
timer_list field. What are your thoughts?

>
>> +static ssize_t ata_scsi_unload_feature_store(struct device *device,
>> +					     struct device_attribute *attr,
>> +					     const char *buf, size_t len)
>> +{
>> +	struct scsi_device *sdev = to_scsi_device(device);
>> +	struct ata_port *ap;
>> +	struct ata_device *dev;
>> +	int val;
>> +
>> +	val = buf[0] - '0';
>> +	if ((val != 0 && val != 1) || (buf[1] != '\0' && buf[1] != '\n')
>> +	    || buf[2] != '\0')
>> +		return -EINVAL;
>> +	ap = ata_shost_to_port(sdev->host);
>> +	dev = ata_scsi_find_dev(ap, sdev);
>> +	if (!dev)
>> +		return -ENODEV;
>> +	if (dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ATAPI)
>> +		return -EOPNOTSUPP;
>> +
>> +	spin_lock_irq(ap->lock);
>> +	if (val == 1)
>> +		dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
>> +	else
>> +		dev->flags |= ATA_DFLAG_NO_UNLOAD;
>> +	spin_unlock_irq(ap->lock);
>> +
>> +	return len;
>> +}
>> +DEVICE_ATTR(unload_feature, S_IRUGO | S_IWUSR,
>> +	    ata_scsi_unload_feature_show, ata_scsi_unload_feature_store);
>> +EXPORT_SYMBOL_GPL(dev_attr_unload_feature);
>
> Hmmm.... Maybe you can just disable it by echoing -1 to the unload file?

Even though disabling it may be desirable in some cases, it's typically
*enabling* it that users will care about. Still, we can always accept -1
and -2 and I have to say I rather like the idea. Thanks for the
suggestion. Indeed, thank you very much for the thorough review.

Regards,

Elias
