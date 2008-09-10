Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYIJTae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYIJTae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYIJTaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:30:25 -0400
Received: from nebensachen.de ([195.34.83.29]:52845 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYIJTaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:30:23 -0400
X-Hashcash: 1:20:080910:htejun@gmail.com::jkzgLvoZNes84Ru4:00YKI
X-Hashcash: 1:20:080910:alan@lxorguk.ukuu.org.uk::8g4RvZ9qm+uavYeI:000000000000000000000000000000000000083Wr
X-Hashcash: 1:20:080910:akpm@linux-foundation.org::jfzVL08TA8Aci6xZ:0000000000000000000000000000000000006STt
X-Hashcash: 1:20:080910:bzolnier@gmail.com::Y2B3GV+rdMUrOva4:00000000000000000000000000000000000000000009/zc
X-Hashcash: 1:20:080910:jeff@garzik.org::qcW3pzgaNSxsYSOL:006jDS
X-Hashcash: 1:20:080910:randy.dunlap@oracle.com::0daFqyIcBUulGP+2:000000000000000000000000000000000000000GWE
X-Hashcash: 1:20:080910:linux-ide@vger.kernel.org::Dm5V7M8rN/bUodjc:0000000000000000000000000000000000004HHS
X-Hashcash: 1:20:080910:linux-kernel@vger.kernel.org::UclFU55qXt8/wuNB:0000000000000000000000000000000000B24
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
	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>
	<48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local>
	<48C7DC55.30002@gmail.com>
Date: Wed, 10 Sep 2008 21:28:54 +0200
In-Reply-To: <48C7DC55.30002@gmail.com> (Tejun Heo's message of "Wed, 10 Sep
	2008 16:40:21 +0200")
Message-ID: <8763p3ol55.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Hello, Elias.
>
> Elias Oltmanns wrote:
[...]
>> +static unsigned long ata_eh_park_devs(struct ata_port *ap)
>> +{
>> +	struct ata_link *link;
>> +	struct ata_device *dev;
>> +	struct ata_taskfile tf;
>> +	unsigned int err_mask;
>> +	unsigned long deadline = jiffies;
>> +
>> +	ata_port_for_each_link(link, ap) {
>> +		ata_link_for_each_dev(dev, link) {
>> +			struct ata_eh_context *ehc = &link->eh_context;
>> +			struct ata_eh_info *ehi = &link->eh_info;
>> +
>> +			if (dev->class != ATA_DEV_ATA ||
>> +			    dev->flags & ATA_DFLAG_NO_UNLOAD)
>> +				continue;
>> +
>> +			if (ehc->i.dev_action[dev->devno] & ATA_EH_PARK ||
>> +			    ehi->dev_action[dev->devno] & ATA_EH_PARK) {
>> +				unsigned long tmp = dev->unpark_deadline;
>
> The correct way to do this is ata_eh_about_to_do().  After that, you
> can just look at ehc->i.dev_action[].  Also, you'll need to call
> ata_eh_done() later.

We have a problem here, I'm afraid, because we may keep looping in EH
context and still want to pick up ATA_EH_PARK requests. Imagine that
ATA_EH_PARK has been scheduled for device A and the EH thread has
reached the call to schedule_timeout_uninterruptible(). Now, ATA_EH_PARK
is scheduled for device B on the same port. This will wake up the EH
thread, but ATA_EH_PARK is only recorded in link->eh_info, not in
link->eh_context.i. ata_eh_about_to_do() will unconditionally clear the
flag in eh_info, but checking ehc->i.dev_action afterwards will only
tell us whether this flag was set when we entered EH, not whether it had
been set since.

Should I change ata_eh_about_to_do() so that it will record the action
in link->eh_context before clearing it in link->eh_info?

>
>> +				if (time_before(deadline, tmp))
>> +					deadline = tmp;
>> +				else if (time_before_eq(tmp, jiffies))
>> +					continue;
>> +			}
>> +
>> +			if (ehc->did_unload_mask & (1 << dev->devno))
>> +				continue;
>> +
>> +			ata_tf_init(dev, &tf);
>> +			tf.command = ATA_CMD_IDLEIMMEDIATE;
>> +			tf.feature = 0x44;
>> +			tf.lbal = 0x4c;
>> +			tf.lbam = 0x4e;
>> +			tf.lbah = 0x55;
>> +			tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
>> +			tf.protocol |= ATA_PROT_NODATA;
>> +			err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE,
>> +						     NULL, 0, 0);
>> +			if (err_mask || tf.lbal != 0xc4)
>> +				ata_dev_printk(dev, KERN_ERR,
>> +					       "head unload failed!\n");
>> +			else
>> +				ehc->did_unload_mask |= 1 << dev->devno;
> ...
>> +static void ata_eh_unpark_devs(struct ata_port *ap)
>> +{
>> +	struct ata_link *link;
>> +	struct ata_device *dev;
>> +	struct ata_taskfile tf;
>> +
>> +	ata_port_for_each_link(link, ap) {
>> +		ata_link_for_each_dev(dev, link) {
>> +			struct ata_eh_context *ehc = &link->eh_context;
>> +
>> +			if (!(ehc->did_unload_mask & (1 << dev->devno)))
>> +				continue;
>> +
>> +			ata_tf_init(dev, &tf);
>> +			tf.command = ATA_CMD_CHK_POWER;
>> +			tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
>> +			tf.protocol |= ATA_PROT_NODATA;
>> +			ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
>
> And it's probably better to have ehc->unloaded_mask instead of
> ehc->did_unload_mask and clear it here so that if unload is scheduled
> after this point but before EH completes, it does unloading again.
> ie. Something like the following.
>
> 	ata_eh_done(ATA_EH_UNLOAD);
> 	ehc->i.unloaded_mask &= ~(1 << dev->devno);

No need for that because link->eh_context is cleared in
ata_scsi_error().

>
>> @@ -2830,6 +2904,19 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>>  		}
>>  	}
>>  
>> +	do {
>> +		unsigned long now;
>> +
>> +		deadline = ata_eh_park_devs(ap);
>> +		now = jiffies;
>> +		if (time_before_eq(deadline, now))
>> +			break;
>> +		prepare_to_wait(&ata_scsi_park_wq, &wait, TASK_UNINTERRUPTIBLE);
>> +		deadline = schedule_timeout_uninterruptible(deadline - now);
>> +	} while (deadline);
>> +	finish_wait(&ata_scsi_park_wq, &wait);
>> +	ata_eh_unpark_devs(ap);
>
> I think it would be better to put timeout computation and handling out
> here instead of inside ata_eh_park_devs().  ata_eh_park_devs() just
> parks the heads if ATA_DEV_UNLOAD and the outer loop controls when it
> can continue.

Right.

>
>> +static ssize_t ata_scsi_park_store(struct device *device,
>> +				   struct device_attribute *attr,
>> +				   const char *buf, size_t len)
>> +{
> ...
>
>> +		switch (input) {
>> +		case -1:
>> +			dev->flags &= ~ATA_DFLAG_NO_UNLOAD;
>> +			break;
>> +		case -2:
>> +			dev->flags |= ATA_DFLAG_NO_UNLOAD;
>> +			break;
>
> Can't we just drop ATA_DFLAG_NO_UNLOAD?  It doesn't provide any real
> functionality anymore.

I was afraid you'd say something like that in the end ;-). Well, we
can't. We really should only issue the unload command if we know that
it's safe, i.e., the device supports that feature. We assume it to be
safe if ata_id_has_unload() returns true or if the user told us that the
device does support the command. ATA_DFLAG_NO_UNLOAD is initialised
during device setup by ata_id_has_unload(). For pre-ATA-7 devices (like
mine), the user can manually clear that flag afterwards.

Regards,

Elias
