Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYIDJI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYIDJI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYIDJIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:08:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:65285 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYIDJIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rMDRKCHkjpMwLWpiep6HrKghfVdxcvTxA7pxT2IhvZ+R3bk7TsoymA6Bl4Dg5oYvSe
         u+Q4bBKH4cMp7aDWCF01qZJ+NL4wSkfvpt8vTnxjytOa3zH2g3XlfFwPpi9FmO16uarz
         gQSbnpoauiOBMLit1xq6mp9kRBLgcbJt8pxNQ=
Message-ID: <48BFA528.2040305@gmail.com>
Date: Thu, 04 Sep 2008 11:06:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>
In-Reply-To: <87fxoh0yil.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
>> Also, generating duplicate events.  Events would be duplicate only
>> when those events occur during EH is in progress, right?
> 
> Yes, but that will be the rule rather than the exception because the
> daemon will hardly ever let the timeout expire. Eitehr it decides that
> it needs to extend the timeout, or it recons that everything's going to
> be alright and issues a 0 timeout in order to resume normal operation
> immediately.

Oh.. I see.  Either way, it should be fine.  There is no reason to
worry scheduling EH for the second (or n'th) time.

> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index b1d08a8..1b470ad 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -298,8 +298,14 @@ static struct pci_driver piix_pci_driver = {
>  #endif
>  };
>  
> +static struct device_attribute *piix_sdev_attrs[] = {
> +	&dev_attr_unload_heads,
> +	NULL
> +};
> +
>  static struct scsi_host_template piix_sht = {
>  	ATA_BMDMA_SHT(DRV_NAME),
> +	.sdev_attrs		= piix_sdev_attrs,
>  };

Hmm... I meant more like


 extern struct device_attribute **libata_sdev_attrs;

 #define ATA_BASE_SHT(name)				\
 ....
	.sdev_attrs		= libata_sdev_attrs;	\
 ....

Which will give unload_heads to all libata drivers.  As ahci needs its
own node it would need to define its own sdev_attrs tho.

> @@ -2830,6 +2864,20 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>  		}
>  	}
>  
> +	if (ap->link.eh_context.i.action & ATA_EH_PARK &&
> +	    time_after(ap->unpark_deadline, jiffies)) {
> +		DEFINE_WAIT(wait);
> +
> +		ata_eh_park_devs(ap, 1);
> +		do
> +			prepare_to_wait(&ata_scsi_park_wq, &wait,
> +					TASK_UNINTERRUPTIBLE);
> +		while (schedule_timeout_uninterruptible(ap->unpark_deadline -
> +							jiffies));

Nitpicking: Do you mind taking the schedule_timeout out of the while
condition?  It's just not very customary to put a statement with that
level of side effect into a condition clause.  Also, it would force
the not-so-common do/while w/o braces to go away.

> +static ssize_t ata_scsi_park_show(struct device *device,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(device);
> +	struct ata_port *ap;
> +	unsigned int seconds;
> +
> +	ap = ata_shost_to_port(sdev->host);
> +
> +	spin_lock_irq(ap->lock);
> +	if (time_after(ap->unpark_deadline, jiffies))
> +		/*
> +		 * Adding 1 in order to guarantee nonzero value until timer
> +		 * has actually expired.
> +		 */
> +		seconds = jiffies_to_msecs(ap->unpark_deadline - jiffies)
> +			  / 1000 + 1;
> +	else
> +		seconds = 0;
> +	spin_unlock_irq(ap->lock);
> +
> +	return snprintf(buf, 20, "%u\n", seconds);

Isn't seconds a bit too crude? Or it just doesn't matter as it's
usually adjusted before expiring?  For most time interval values
(except for transfer timings of course) in ATA land, millisecs seem to
be good enough and I've been trying to unify things that direction.

> +}
> +
> +static ssize_t ata_scsi_park_store(struct device *device,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t len)
> +{
> +#define MAX_PARK_TIMEOUT 30

Please move this to the enum list in include/linux/libata.h.

> +	struct scsi_device *sdev = to_scsi_device(device);
> +	struct ata_port *ap;
> +	struct ata_device *dev;
> +	long int input;
> +	int rc;
> +
> +	rc = strict_strtol(buf, 10, &input);
> +	if (rc || input < -2 || input > MAX_PARK_TIMEOUT)
> +		return -EINVAL;
> +
> +	ap = ata_shost_to_port(sdev->host);
> +	dev = ata_scsi_find_dev(ap, sdev);

ata_scsi_find_dev() should be inside ap->lock.  Looking through the
code...  Aiee, We also need to fix slave_config.

> +	if (unlikely(!dev))
> +		return -ENODEV;
> +
> +	spin_lock_irq(ap->lock);

You'll probably want to use spin_lock_irqsave and restore.  It's a
Jeff thing.

> +	if (dev->class != ATA_DEV_ATA) {
> +		rc = -EOPNOTSUPP;
> +		goto unlock;
> +	}
> +
> +	if (input >= 0) {
> +		if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
> +			rc = -EOPNOTSUPP;
> +			goto unlock;
> +		}
> +
> +		ap->link.eh_info.action |= ATA_EH_PARK;
> +		ata_port_schedule_eh(ap);
> +		ap->unpark_deadline = ata_deadline(jiffies, input * 1000);
> +		wake_up_all(&ata_scsi_park_wq);

It doesn't really matter as all these are under the lock but maybe
moving ata_port_schedule_eh() below unpark_deadline is a good idea
just for clarification - you know, set the state and trigger the
event?

> +	} else {
> +		switch (input) {
> +		case -1:
> +			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
> +			break;
> +		case -2:
> +			dev->flags |= ATA_DFLAG_NO_UNLOAD;
> +			break;

Hmmm... Sorry to bring another issue with it but I think the interface
is a bit convoluted.  The unpark node is per-dev but the action is
per-port but devices can opt out by writing -2.  Also, although the
sysfs nodes are per-dev, writing to a node changes the value of park
node in the device sharing the port except when the value is -1 or -2.
That's strange, right?

How about something like the following?

* In park_store: set dev->unpark_timeout, kick and wake up EH.

* In park EH action: until the latest of all unpark_timeout are
  passed, park all drives whose unpark_timeout is in future.  When
  none of the drives needs to be parked (all timers expired), the
  action completes.

* There probably needs to be a flag to indicate that the timeout is
  valid; otherwise, we could get spurious head unparking after jiffies
  wraps (or maybe just use jiffies_64?).

With something like the above, the interface is cleanly per-dev and we
wouldn't need -1/-2 special cases.  The implementation is still
per-port but we can change that later without modifying userland
interface.

Thanks for your patience.  :-)

-- 
tejun
