Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYHDOTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYHDOTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYHDOT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:19:26 -0400
Received: from nebensachen.de ([195.34.83.29]:53767 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbYHDOTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:19:24 -0400
X-Hashcash: 1:20:080804:pavel@suse.cz::HI56jV5JaSH8SUO2:00004RBD
X-Hashcash: 1:20:080804:alan@lxorguk.ukuu.org.uk::4vnh+aO48BVD/qzS:00000000000000000000000000000000000004qWC
X-Hashcash: 1:20:080804:jeff@garzik.org::50aENf4Hn1AHtvtM:002B4m
X-Hashcash: 1:20:080804:bzolnier@gmail.com::cwotIjpT7mjwjVz+:00000000000000000000000000000000000000000000w54
X-Hashcash: 1:20:080804:james.bottomley@hansenpartnership.com::Dszr54A29JBO/zfQ:0000000000000000000000005Pzw
X-Hashcash: 1:20:080804:linux-ide@vger.kernel.org::HWmJ0r2WFsdEJQjj:0000000000000000000000000000000000008Dfz
X-Hashcash: 1:20:080804:linux-kernel@vger.kernel.org::cZZSIoqoBdbTXWXW:0000000000000000000000000000000000Lo0
X-Hashcash: 1:20:080804:rjw@sisk.pl::LOnCXqqanSN1p0Ke:0000001wfL
From: Elias Oltmanns <eo@nebensachen.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/5] ide: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.7339.stgit@denkblock.local>
	<20080804063901.GA23933@atrey.karlin.mff.cuni.cz>
Date: Mon, 04 Aug 2008 16:15:35 +0200
In-Reply-To: <20080804063901.GA23933@atrey.karlin.mff.cuni.cz> (Pavel Machek's
	message of "Mon, 4 Aug 2008 08:39:01 +0200")
Message-ID: <87hca0oohk.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>>  #include <linux/ide.h>
>>  #include <linux/completion.h>
>>  #include <linux/device.h>
>> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
>> +# include <linux/suspend.h>
>> +#endif
>
> This ifdef should be unneccessary.

Right.

>
>
>> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_HIBERNATION)
>> +static int ide_park_count = 1;
>> +DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
>> +
>> +static inline int suspend_parking(void)
>> +{
>> +	spin_lock_irq(&ide_lock);
>> +	if (ide_park_count == 1)
>> +		ide_park_count = 0;
>> +	spin_unlock_irq(&ide_lock);
>> +	return !ide_park_count;
>> +}
>> +
>> +static int ide_pm_notifier(struct notifier_block *nb, unsigned long val,
>> +			   void *null)
>> +{
>> +	switch (val) {
>> +	case PM_SUSPEND_PREPARE:
>> +		wait_event(ide_park_wq, suspend_parking());
>> +		break;
>> +	case PM_POST_SUSPEND:
>> +		ide_park_count = 1;
>> +		break;
>> +	default:
>> +		return NOTIFY_DONE;
>> +	}
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block ide_pm_notifier_block = {
>> +	.notifier_call = ide_pm_notifier,
>> +};
>> +
>> +static inline int ide_register_pm_notifier(void)
>> +{
>> +	return register_pm_notifier(&ide_pm_notifier_block);
>> +}
>> +
>> +static inline int ide_unregister_pm_notifier(void)
>> +{
>> +	return unregister_pm_notifier(&ide_pm_notifier_block);
>> +}
>
> Any reason this does not use normal driver model suspend/resume
> callbacks?

Yes, two in fact. Firstly, it would appear that after freeze_processes()
has completed, timers don't fire anymore. That's why we have to call the
unpark hook manually. The ATA suspend callback would be the place to do
that but the scsi ULD's suspend callback issues a cache sync and a disk
start_stop command before and waits indefinitely for completion.

Secondly and more importantly, using pm_notifiers is the right thing to
do as long as user processes control when to park and unpark the disks.
This way we can hold back from suspending until user space gives the all
clear.

Regards,

Elias
