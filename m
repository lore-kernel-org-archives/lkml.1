Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYHaJ04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYHaJ04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbYHaJ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:26:46 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:25664 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbYHaJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qXJnJSj5E23fm4u0eysvXhvNGJKnverElWZvBk19YrZBBR+YORW+/7H0ZxyFYgMKa/
         5k5wxsP0VfDjW/P5kAA/9DQaHZpEfcePQX0NslL5z+QuS2NsHRt3JkRLCG+W8gOdEQ9q
         yDO/gf1ezbl/GzWUyyuD/Uqzi+g9p+fJ8fOt0=
Message-ID: <48BA638B.2030001@gmail.com>
Date: Sun, 31 Aug 2008 11:25:31 +0200
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
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>
In-Reply-To: <87k5dym5t9.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Elias Oltmanns wrote:
> Tejun Heo <htejun@gmail.com> wrote:
>>> +	ata_port_for_each_link(link, ap) {
>>> +		ata_link_for_each_dev(dev, link) {
>>> +			if (!dev->sdev)
>>> +				continue;
>> You probably want to do if (dev->class != ATA_DEV_ATA) here.
> 
> Well, I really am concerned about dev->sdev. So far, I haven't quite
> figured out yet whether under which circumstances I can safely assume
> that the scsi counter part of dev including the block layer request
> queue has been completely set up and configured so there won't be any
> null pointer dereferences. However, if you think that I needn't bother
> with stopping the request queue anyway, checking for ATA_DEV_ATA (what
> about ATA_DEV_ATAPI?) should definitely be enough.

Ah.. you need to part ATAPI too?  If so, just test for
ata_dev_enabled().  One way or the other, there's no need to care
about SCSI or block layer when you're in EH.

>>> +			ata_tf_init(dev, &tf);
>>> +			q = dev->sdev->request_queue;
>>> +			spin_lock_irq(q->queue_lock);
>>> +			if (park) {
>>> +				blk_stop_queue(q);
>> Queue is already plugged when EH is entered.  No need for this.
> 
> Quite right. It's just that it will be un- and replugged every
> (3 * HZ) / 1000, so I thought it might be worthwhile to stop the queue
> anyway. Perhaps it really isn't worth bothering and the code would
> certainly be nicer to look at.

While the EH is running, nothing gets through other than commands
issued by EH itself, so no need to worry about how upper layers would
behave.

>>> +			spin_unlock(q->queue_lock);
>>> +			spin_lock(ap->lock);
>> And no need to play with locks at all.
> 
> Just to be sure, are you just referring to the queue lock, or to the host
> lock as well? Am I wrong in thinking that we have to protect all access
> to dev->flags because bit operations are performed non atomically
> virtually at any time?

Yes, when modifying the flags.  You don't need to when testing a
feature.

>>> +		ata_eh_park_devs(ap, 0);
>> And does the device need this explicit wake up?  It will wake up when
>> it's necessary.
> 
> Probably, I should insert a comment somewhere. The problem is that
> device internal power management will be disabled until the next command
> is received. If you have laptop mode enabled and the device has received
> the unload command while spinning with no more commands in the queue to
> follow, the device may keep spinning for quite a while and won't go into
> standby which rather defeats the purpose of laptop mode. This behaviour
> is compliant with the specs and I can observe it on my system.

Ah.. Okay.  I somehow thought the command would spin down the disk.
It's just unloading the head.  Please cross this one.

>>> +int ata_scsi_register_pm_notifier(void)
>>> +{
>>> +	return register_pm_notifier(&ata_scsi_pm_notifier_block);
>>> +}
>>> +
>>> +int ata_scsi_unregister_pm_notifier(void)
>>> +{
>>> +	return unregister_pm_notifier(&ata_scsi_pm_notifier_block);
>>> +}
>> Why are these PM notifiers necessary?
> 
> Since it's a user process that controls when we have to keep the heads
> off the platter, a suspend operation has to be blocked *before* process
> freezing when we happen to be in a precarious situation.

Can you please elaborate a bit?  The reloading is done by the kernel
after a timeout, right?  What kind of precarious situation can the
kernel get into regarding suspend?

>> And these all can go.  If you're worried about recurring events you
>> can just update timestamp from the sysfs write function and do...
>>
>>     deadline = last_timestamp + delay;
>>     while ((now = jiffies) < deadline) {
>>         set_current_state(TASK_UNINTERRUPTIBLE);
>> 	schedule_timeout(deadline - now);
>> 	set_current_state(TASK_RUNNING);
>>     }
> 
> Ah, I can see that this while loop can replace my call to wait_event() in
> the eh sequence earlier on. However, I wonder how I am to replace the
> call to mod_timer(). As you can see, we perform different actions
> depending on whether the timer has merely been updated, or a new timer
> has been started. Only in the latter case we want to schedule eh. In
> order to achieve the equivalent in your setting while preventing any
> races, I'd have to protect the deadline field in struct ata_port by the
> host lock, i.e. something like:
> 
>     spin_lock_irq(ap->lock);
>     now = jiffies;
>     rc = now > ap->deadline;
>     ap->deadline = now + timeout;
>     if (rc) {
>         ap->link.eh_info.action |= ATA_EH_PARK;
>         ata_port_schedule_eh(ap);
>     }
>     ...
>     spin_unlock_irq(ap->lock);

You can just do

    spin_lock_irq(ap->lock);
    ap->deadline = jiffies + timeout;
    ap->link.eh_info.action |= ATA_EH_PARK;
    ata_port_schedule_eh(ap);
    spin_unlock_irq(ap->lock);

> and in the eh code a modified version of your loop:
> 
>     spin_lock_irq(ap->lock);
>     while ((now = jiffies) < deadline) {
>         spin_unlock_irq(ap->lock);
>         set_current_state(TASK_UNINTERRUPTIBLE);
>         schedule_timeout(deadline - now);
>         set_current_state(TASK_RUNNING);
>         spin_lock_irq(ap->lock);
>     }
>     spin_unlock_irq(ap->lock);

Yeah, this looks about right, but you can make it a bit simpler...

    while (time_before((now = jiffies), ap->deadline))
	schedule_timeout_uninterruptible(ap->deadline - now);

As locking on reader side doesn't mean much in cases like this.  The
deadline update which triggered EH is guaranteed to be visible and the
the window between waking up from schedule_timeout and ap->deadline
dereference is way too small to be any meaningful.

> Is it worth all that or am I missing something? On the other hand, a
> deadline field would occupy less space in the ata_port structure than a
> timer_list field. What are your thoughts?

Is the above code more complex?  I think it's simpler, no?

>>> +DEVICE_ATTR(unload_feature, S_IRUGO | S_IWUSR,
>>> +	    ata_scsi_unload_feature_show, ata_scsi_unload_feature_store);
>>> +EXPORT_SYMBOL_GPL(dev_attr_unload_feature);
>> Hmmm.... Maybe you can just disable it by echoing -1 to the unload file?
> 
> Even though disabling it may be desirable in some cases, it's typically
> *enabling* it that users will care about. Still, we can always accept -1
> and -2 and I have to say I rather like the idea. Thanks for the
> suggestion. Indeed, thank you very much for the thorough review.

Oh.. what I meant was whether we need a separate sysfs node to
indicate whether unload feature is enabled or not but now I come to
think about it, that is per-device and the timer is per-port.  :-)

Thanks.

-- 
tejun
