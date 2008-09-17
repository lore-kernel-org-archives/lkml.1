Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYIQP1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYIQP1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYIQP1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:27:31 -0400
Received: from nebensachen.de ([195.34.83.29]:45216 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYIQP1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:27:30 -0400
X-Hashcash: 1:20:080917:htejun@gmail.com::5ge3ZbPVYnbeJWIs:00jAa
X-Hashcash: 1:20:080917:alan@lxorguk.ukuu.org.uk::jJXO+/H19KrrbSYi:00000000000000000000000000000000000005j//
X-Hashcash: 1:20:080917:akpm@linux-foundation.org::V/OwbryVDZSz+1mz:0000000000000000000000000000000000009rbm
X-Hashcash: 1:20:080917:bzolnier@gmail.com::pVlSaL1vi0DW/Axz:0000000000000000000000000000000000000000000NJgM
X-Hashcash: 1:20:080917:jeff@garzik.org::WdSCvjspVBD5mId6:0058oe
X-Hashcash: 1:20:080917:randy.dunlap@oracle.com::MuKsAOu4I0ynaxGX:000000000000000000000000000000000000000ffq
X-Hashcash: 1:20:080917:linux-ide@vger.kernel.org::cXnEYLKK9tGnDxme:00000000000000000000000000000000000010oW
X-Hashcash: 1:20:080917:linux-kernel@vger.kernel.org::8go+DiCiHFuDVw6x:0000000000000000000000000000000000t/4
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local> <48B913E6.1000104@gmail.com>
	<87k5dym5t9.fsf@denkblock.local> <48BA638B.2030001@gmail.com>
	<87ej45mlp3.fsf@denkblock.local> <48BA969C.4060207@gmail.com>
	<87abetmaap.fsf@denkblock.local> <48BBA8D1.8020604@gmail.com>
	<87myirly1p.fsf@denkblock.local> <48BC1BB8.2030007@gmail.com>
	<87fxoh0yil.fsf@denkblock.local> <48BFA528.2040305@gmail.com>
	<87ej3zrf3o.fsf@denkblock.local> <48C0F2F8.1040308@gmail.com>
	<87ej3snm3s.fsf@denkblock.local> <48C7DC55.30002@gmail.com>
	<8763p3ol55.fsf@denkblock.local> <48C82CB1.2070308@gmail.com>
	<871vzrogpz.fsf@denkblock.local> <48C850AA.2030409@gmail.com>
	<87k5diq35g.fsf@denkblock.local>
Date: Wed, 17 Sep 2008 17:26:59 +0200
Message-ID: <874p4eoksc.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> What about the following patch?
>
> From: Elias Oltmanns <eo@nebensachen.de>
> Subject: [PATCH] libata: Implement disk shock protection support
>
> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> FEATURE as specified in ATA-7 is issued to the device and processing of
> the request queue is stopped thereafter until the specified timeout
> expires or user space asks to resume normal operation. This is supposed
> to prevent the heads of a hard drive from accidentally crashing onto the
> platter when a heavy shock is anticipated (like a falling laptop
> expected to hit the floor). In fact, the whole port stops processing
> commands until the timeout has expired in order to avoid any resets due
> to failed commands on another device.
>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> ---

Apart from addressing the issue with timeouts exceeding the limit of
30000 msec discussed lately, I have also simplified the crucial
if-clause in ata_scsi_park_show(). Both changes are given below.
Assuming that you don't have any objections, I'll just go ahead and
submit the updated patch series shortly.

Regards,

Elias

> +static ssize_t ata_scsi_park_show(struct device *device,
> +				  struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(device);
> +	struct ata_port *ap;
> +	struct ata_link *link;
> +	struct ata_device *dev;
> +	unsigned long flags;
> +	unsigned int uninitialized_var(msecs);
> +	int rc = 0;
> +
> +	ap = ata_shost_to_port(sdev->host);
> +
> +	spin_lock_irqsave(ap->lock, flags);
> +	dev = ata_scsi_find_dev(ap, sdev);
> +	if (!dev) {
> +		rc = -ENODEV;
> +		goto unlock;
> +	}
> +	if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
> +		rc = -EOPNOTSUPP;
> +		goto unlock;
> +	}
> +
> +	link = dev->link;
> +	if (((ap->pflags & ATA_PFLAG_EH_IN_PROGRESS &&
> +	      (link->eh_context.i.dev_action[dev->devno] & ATA_EH_PARK ||
> +	       link->eh_info.dev_action[dev->devno] & ATA_EH_PARK)) ||
> +	     (ap->pflags & ATA_PFLAG_EH_PENDING &&
> +	      link->eh_info.dev_action[dev->devno])) &&
> +	    time_after(dev->unpark_deadline, jiffies))

Changed to:

	if (ap->pflags & ATA_PFLAG_EH_IN_PROGRESS &&
	    link->eh_context.unloaded_mask & (1 << dev->devno) &&
	    time_after(dev->unpark_deadline, jiffies))

> +		msecs = jiffies_to_msecs(dev->unpark_deadline - jiffies);
> +	else
> +		msecs = 0;
> +
> +unlock:
> +	spin_unlock_irq(ap->lock);
> +
> +	return rc ? rc : snprintf(buf, 20, "%u\n", msecs);
> +}
> +
> +static ssize_t ata_scsi_park_store(struct device *device,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t len)
> +{
> +	struct scsi_device *sdev = to_scsi_device(device);
> +	struct ata_port *ap;
> +	struct ata_device *dev;
> +	long int input;
> +	unsigned long flags;
> +	int rc;
> +
> +	rc = strict_strtol(buf, 10, &input);
> +	if (rc || input < -2 || input > ATA_TMOUT_MAX_PARK)
> +		return -EINVAL;

Changed to:

	if (rc || input < -2)
		return -EINVAL;
	if (input > ATA_TMOUT_MAX_PARK) {
		rc = -EOVERFLOW;
		input = ATA_TMOUT_MAX_PARK;
	}

> +
> +	ap = ata_shost_to_port(sdev->host);
> +
> +	spin_lock_irqsave(ap->lock, flags);
> +	dev = ata_scsi_find_dev(ap, sdev);
> +	if (unlikely(!dev)) {
> +		rc = -ENODEV;
> +		goto unlock;
> +	}
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
> +		dev->unpark_deadline = ata_deadline(jiffies, input);
> +		dev->link->eh_info.dev_action[dev->devno] |= ATA_EH_PARK;
> +		ata_port_schedule_eh(ap);
> +		wake_up_all(&ata_scsi_park_wq);
> +	} else {
> +		switch (input) {
> +		case -1:
> +			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
> +			break;
> +		case -2:
> +			dev->flags |= ATA_DFLAG_NO_UNLOAD;
> +			break;
> +		}
> +	}
> +unlock:
> +	spin_unlock_irqrestore(ap->lock, flags);
> +
> +	return rc ? rc : len;
> +}
> +DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
> +	    ata_scsi_park_show, ata_scsi_park_store);
> +EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
> +
>  static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
>  {
>  	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
