Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYIDReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYIDReR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYIDReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:34:00 -0400
Received: from nebensachen.de ([195.34.83.29]:44228 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYIDRd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:33:59 -0400
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
	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>
	<48BFA528.2040305@gmail.com>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:080904:htejun@gmail.com::HdmbcJtcC+ASPgEH:01e/w
X-Hashcash: 1:20:080904:alan@lxorguk.ukuu.org.uk::8h2qhwY0bxtanmbW:00000000000000000000000000000000000003BYo
X-Hashcash: 1:20:080904:akpm@linux-foundation.org::IXGqAP1Y1Saq5v8Y:0000000000000000000000000000000000000GdT
X-Hashcash: 1:20:080904:bzolnier@gmail.com::0gFnHsqoR96u2Bym:00000000000000000000000000000000000000000004Jv8
X-Hashcash: 1:20:080904:jeff@garzik.org::+veE2M8z1a1Jx5Te:0087+M
X-Hashcash: 1:20:080904:randy.dunlap@oracle.com::/U1iTgBj7emn4//N:000000000000000000000000000000000000001Ltw
X-Hashcash: 1:20:080904:linux-ide@vger.kernel.org::e8x9Bu7TfveyMI2B:0000000000000000000000000000000000001Wwu
X-Hashcash: 1:20:080904:linux-kernel@vger.kernel.org::MbM7EErvV6ez+XIe:000000000000000000000000000000000Ds9D
Date: Thu, 04 Sep 2008 19:32:59 +0200
Message-ID: <87ej3zrf3o.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Elias Oltmanns wrote:
>> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
>> index b1d08a8..1b470ad 100644
>> --- a/drivers/ata/ata_piix.c
>> +++ b/drivers/ata/ata_piix.c
>> @@ -298,8 +298,14 @@ static struct pci_driver piix_pci_driver = {
>>  #endif
>>  };
>>  
>> +static struct device_attribute *piix_sdev_attrs[] = {
>> +	&dev_attr_unload_heads,
>> +	NULL
>> +};
>> +
>>  static struct scsi_host_template piix_sht = {
>>  	ATA_BMDMA_SHT(DRV_NAME),
>> +	.sdev_attrs		= piix_sdev_attrs,
>>  };
>
> Hmm... I meant more like
>
>
>  extern struct device_attribute **libata_sdev_attrs;
>
>  #define ATA_BASE_SHT(name)				\
>  ....
> 	.sdev_attrs		= libata_sdev_attrs;	\
>  ....
>
> Which will give unload_heads to all libata drivers.  As ahci needs its
> own node it would need to define its own sdev_attrs tho.

Dear me, I totally forgot about that, didn't I. Anyway, I meant to ask
you about that when you mentioned it the last time round, so thanks for
explaining in more detail. I'll do it this way then.

>
>> @@ -2830,6 +2864,20 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>>  		}
>>  	}
>>  
>> +	if (ap->link.eh_context.i.action & ATA_EH_PARK &&
>> +	    time_after(ap->unpark_deadline, jiffies)) {
>> +		DEFINE_WAIT(wait);
>> +
>> +		ata_eh_park_devs(ap, 1);
>> +		do
>> +			prepare_to_wait(&ata_scsi_park_wq, &wait,
>> +					TASK_UNINTERRUPTIBLE);
>> +		while (schedule_timeout_uninterruptible(ap->unpark_deadline -
>> +							jiffies));
>
> Nitpicking: Do you mind taking the schedule_timeout out of the while
> condition?  It's just not very customary to put a statement with that
> level of side effect into a condition clause.  Also, it would force
> the not-so-common do/while w/o braces to go away.

Right.

>
>> +static ssize_t ata_scsi_park_show(struct device *device,
>> +				  struct device_attribute *attr, char *buf)
>> +{
>> +	struct scsi_device *sdev = to_scsi_device(device);
>> +	struct ata_port *ap;
>> +	unsigned int seconds;
>> +
>> +	ap = ata_shost_to_port(sdev->host);
>> +
>> +	spin_lock_irq(ap->lock);
>> +	if (time_after(ap->unpark_deadline, jiffies))
>> +		/*
>> +		 * Adding 1 in order to guarantee nonzero value until timer
>> +		 * has actually expired.
>> +		 */
>> +		seconds = jiffies_to_msecs(ap->unpark_deadline - jiffies)
>> +			  / 1000 + 1;
>> +	else
>> +		seconds = 0;
>> +	spin_unlock_irq(ap->lock);
>> +
>> +	return snprintf(buf, 20, "%u\n", seconds);
>
> Isn't seconds a bit too crude? Or it just doesn't matter as it's
> usually adjusted before expiring?  For most time interval values
> (except for transfer timings of course) in ATA land, millisecs seem to
> be good enough and I've been trying to unify things that direction.

Well, I can see your point. Technically, we are talking about magnitudes
in the order of seconds rather than milliseconds here because the specs
only guarantee command completion for head unload in 300 or even 500
msecs. This means that the daemon should always schedule timeouts well
above this limit. That's the reason why we have only accepted timeouts
in seconds rather than milliseconds at the user's request. When reading
from sysfs, we have returned seconds for consistency. I'm a bit torn
between the options now:

1. Switch the interface completely to msecs: consistent with the rest of
   libata but slightly misleading because it may promise more accuracy
   than we can actually provide for;
2. keep it the way it was (i.e. seconds on read and write): we don't
   promise too much as far as accuracy is concerned, but it is
   inconsistent with the rest of libata. Besides, user space can still
   issue a 0 and another nonzero timeout within a very short time and we
   don't protect against that anyway;
3. only switch to msecs on read: probably the worst of all options.

What do you think?

>
>> +}
>> +
>> +static ssize_t ata_scsi_park_store(struct device *device,
>> +				   struct device_attribute *attr,
>> +				   const char *buf, size_t len)
>> +{
>> +#define MAX_PARK_TIMEOUT 30
>
> Please move this to the enum list in include/linux/libata.h.

Will do.

>
>> +	struct scsi_device *sdev = to_scsi_device(device);
>> +	struct ata_port *ap;
>> +	struct ata_device *dev;
>> +	long int input;
>> +	int rc;
>> +
>> +	rc = strict_strtol(buf, 10, &input);
>> +	if (rc || input < -2 || input > MAX_PARK_TIMEOUT)
>> +		return -EINVAL;
>> +
>> +	ap = ata_shost_to_port(sdev->host);
>> +	dev = ata_scsi_find_dev(ap, sdev);
>
> ata_scsi_find_dev() should be inside ap->lock.

Right.

> Looking through the code... Aiee, We also need to fix slave_config.
>
>> +	if (unlikely(!dev))
>> +		return -ENODEV;
>> +
>> +	spin_lock_irq(ap->lock);
>
> You'll probably want to use spin_lock_irqsave and restore.  It's a
> Jeff thing.

No problem.

>
>> +	if (dev->class != ATA_DEV_ATA) {
>> +		rc = -EOPNOTSUPP;
>> +		goto unlock;
>> +	}
>> +
>> +	if (input >= 0) {
>> +		if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
>> +			rc = -EOPNOTSUPP;
>> +			goto unlock;
>> +		}
>> +
>> +		ap->link.eh_info.action |= ATA_EH_PARK;
>> +		ata_port_schedule_eh(ap);
>> +		ap->unpark_deadline = ata_deadline(jiffies, input * 1000);
>> +		wake_up_all(&ata_scsi_park_wq);
>
> It doesn't really matter as all these are under the lock but maybe
> moving ata_port_schedule_eh() below unpark_deadline is a good idea
> just for clarification - you know, set the state and trigger the
> event?

I see, of course.

>
>> +	} else {
>> +		switch (input) {
>> +		case -1:
>> +			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
>> +			break;
>> +		case -2:
>> +			dev->flags |= ATA_DFLAG_NO_UNLOAD;
>> +			break;
>
> Hmmm... Sorry to bring another issue with it but I think the interface
> is a bit convoluted.  The unpark node is per-dev but the action is
> per-port but devices can opt out by writing -2.  Also, although the
> sysfs nodes are per-dev, writing to a node changes the value of park
> node in the device sharing the port except when the value is -1 or -2.
> That's strange, right?

Well, it is strange, but it pretty much reflects reality as close as it
can get. Devices can only opt in / out of actually issuing the unload
command but they will always stop I/O and thus be affected by the
timeout (intentionally).

>
> How about something like the following?
>
> * In park_store: set dev->unpark_timeout, kick and wake up EH.
>
> * In park EH action: until the latest of all unpark_timeout are
>   passed, park all drives whose unpark_timeout is in future.  When
>   none of the drives needs to be parked (all timers expired), the
>   action completes.
>
> * There probably needs to be a flag to indicate that the timeout is
>   valid; otherwise, we could get spurious head unparking after jiffies
>   wraps (or maybe just use jiffies_64?).
>
> With something like the above, the interface is cleanly per-dev and we
> wouldn't need -1/-2 special cases.  The implementation is still
> per-port but we can change that later without modifying userland
> interface.

First of all, we cannot do a proper per-dev implementation internally.
Admittedly, we could do it per-link rather than per-port, but the point
I'm making is this: there really is just *one* grobal timeout (per-port
now or perhaps per-link in the long run). The confusing thing right now
is that you can read the current timeout on any device, but you can only
set a timeout on a device that actually supports head unloading. Perhaps
we should return something like "n/a" when reading the sysfs attribute
for a device that doesn't support head unloads, even though a timer on
that port may be running because the other device has just received an
unload request. This way, both devices will be affected by the timeout,
but you can only read it on the device where you can change it as well.
Would that suit you?

>
> Thanks for your patience. :-)

As long as you keep reviewing, that's alright ;-).

Regards,

Elias
