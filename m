Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYHaMJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYHaMJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 08:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbYHaMIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 08:08:55 -0400
Received: from nebensachen.de ([195.34.83.29]:42856 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757738AbYHaMIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 08:08:53 -0400
X-Hashcash: 1:20:080831:htejun@gmail.com::W4Ch6WGFjZ980/Sw:03Fbi
X-Hashcash: 1:20:080831:alan@lxorguk.ukuu.org.uk::+D3xzVgl0J5yaijI:00000000000000000000000000000000000002V3Q
X-Hashcash: 1:20:080831:akpm@linux-foundation.org::FITNJuRUj2SiBoir:0000000000000000000000000000000000001KQA
X-Hashcash: 1:20:080831:bzolnier@gmail.com::KQuVCswmQvOTsjeO:00000000000000000000000000000000000000000008zFS
X-Hashcash: 1:20:080831:jeff@garzik.org::zS0v2AT9avhWC3Um:001+qL
X-Hashcash: 1:20:080831:randy.dunlap@oracle.com::W+j5c2JKnxf7p4PR:000000000000000000000000000000000000000QWA
X-Hashcash: 1:20:080831:linux-ide@vger.kernel.org::g+tC19ydgwV1/Ny4:0000000000000000000000000000000000000+JU
X-Hashcash: 1:20:080831:linux-kernel@vger.kernel.org::+hlItEwTVXfn0d3L:000000000000000000000000000000000K8wk
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
	<48BA638B.2030001@gmail.com>
Date: Sun, 31 Aug 2008 14:08:08 +0200
In-Reply-To: <48BA638B.2030001@gmail.com> (Tejun Heo's message of "Sun, 31 Aug
	2008 11:25:31 +0200")
Message-ID: <87ej45mlp3.fsf@denkblock.local>
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
>> Tejun Heo <htejun@gmail.com> wrote:
>>>> +	ata_port_for_each_link(link, ap) {
>>>> +		ata_link_for_each_dev(dev, link) {
>>>> +			if (!dev->sdev)
>>>> +				continue;
>>> You probably want to do if (dev->class != ATA_DEV_ATA) here.
>> 
>> Well, I really am concerned about dev->sdev. So far, I haven't quite
>> figured out yet whether under which circumstances I can safely assume
>> that the scsi counter part of dev including the block layer request
>> queue has been completely set up and configured so there won't be any
>> null pointer dereferences. However, if you think that I needn't bother
>> with stopping the request queue anyway, checking for ATA_DEV_ATA (what
>> about ATA_DEV_ATAPI?) should definitely be enough.
>
> Ah.. you need to part ATAPI too?  If so, just test for
> ata_dev_enabled().

Well, I'm not quite sure really. Perhaps you are right and I'd better
leave ATAPI alone, especially given the problem that the unload command
might mess up a CD/DVD write operation. As long as no laptop HDs are
identified as ATAPI devices, there should be no problem with that.

> One way or the other, there's no need to care about SCSI or block
> layer when you're in EH.
>
>>>> +			ata_tf_init(dev, &tf);
>>>> +			q = dev->sdev->request_queue;
>>>> +			spin_lock_irq(q->queue_lock);
>>>> +			if (park) {
>>>> +				blk_stop_queue(q);
>>> Queue is already plugged when EH is entered.  No need for this.
>> 
>> Quite right. It's just that it will be un- and replugged every
>> (3 * HZ) / 1000, so I thought it might be worthwhile to stop the queue
>> anyway. Perhaps it really isn't worth bothering and the code would
>> certainly be nicer to look at.
>
> While the EH is running, nothing gets through other than commands
> issued by EH itself, so no need to worry about how upper layers would
> behave.

Alright, I'll drop it.

>
>>>> +			spin_unlock(q->queue_lock);
>>>> +			spin_lock(ap->lock);
>>> And no need to play with locks at all.
>> 
>> Just to be sure, are you just referring to the queue lock, or to the host
>> lock as well? Am I wrong in thinking that we have to protect all access
>> to dev->flags because bit operations are performed non atomically
>> virtually at any time?
>
> Yes, when modifying the flags.  You don't need to when testing a
> feature.

Right.

[...]
>>>> +int ata_scsi_register_pm_notifier(void)
>>>> +{
>>>> +	return register_pm_notifier(&ata_scsi_pm_notifier_block);
>>>> +}
>>>> +
>>>> +int ata_scsi_unregister_pm_notifier(void)
>>>> +{
>>>> +	return unregister_pm_notifier(&ata_scsi_pm_notifier_block);
>>>> +}
>>> Why are these PM notifiers necessary?
>> 
>> Since it's a user process that controls when we have to keep the heads
>> off the platter, a suspend operation has to be blocked *before* process
>> freezing when we happen to be in a precarious situation.
>
> Can you please elaborate a bit?  The reloading is done by the kernel
> after a timeout, right?  What kind of precarious situation can the
> kernel get into regarding suspend?

Sorry, I haven't expressed myself very clearly there, it seems. The user
space process detects some acceleration and starts writing timeouts to
the sysfs file. This causes the unload command to be issued to the
device and stops all I/O until the user space daemon decides that the
danger has passed, writes 0 to the sysfs file and leaves it alone
afterwards. Now, if the daemon happens to request head parking right at
the beginning of a suspend sequence, this means that we are in danger of
falling, i.e. we have to make sure that I/O is stopped until that user
space daemon gives the all-clear. However, suspending implies freezing
all processes which means that the daemon can't keep checking and
signalling to the kernel. The last timeout received before the daemon
has been frozen will expire and the suspend procedure goes ahead. By
means of the notifiers we can make sure that suspend is blocked until
the daemon says that everything is alright.

>
>>> And these all can go.  If you're worried about recurring events you
>>> can just update timestamp from the sysfs write function and do...
>>>
>>>     deadline = last_timestamp + delay;
>>>     while ((now = jiffies) < deadline) {
>>>         set_current_state(TASK_UNINTERRUPTIBLE);
>>> 	schedule_timeout(deadline - now);
>>> 	set_current_state(TASK_RUNNING);
>>>     }
>> 
>> Ah, I can see that this while loop can replace my call to wait_event() in
>> the eh sequence earlier on. However, I wonder how I am to replace the
>> call to mod_timer(). As you can see, we perform different actions
>> depending on whether the timer has merely been updated, or a new timer
>> has been started. Only in the latter case we want to schedule eh. In
>> order to achieve the equivalent in your setting while preventing any
>> races, I'd have to protect the deadline field in struct ata_port by the
>> host lock, i.e. something like:
>> 
>>     spin_lock_irq(ap->lock);
>>     now = jiffies;
>>     rc = now > ap->deadline;
>>     ap->deadline = now + timeout;
>>     if (rc) {
>>         ap->link.eh_info.action |= ATA_EH_PARK;
>>         ata_port_schedule_eh(ap);
>>     }
>>     ...
>>     spin_unlock_irq(ap->lock);
>
> You can just do
>
>     spin_lock_irq(ap->lock);
>     ap->deadline = jiffies + timeout;
>     ap->link.eh_info.action |= ATA_EH_PARK;
>     ata_port_schedule_eh(ap);
>     spin_unlock_irq(ap->lock);

Please note that I want to schedule EH (and thus the head unload -
check power command sequence) only once in the event of overlapping
timeouts. For instance, when the daemon sets a timeout of 2 seconds and
does so again after one second has elapsed, I want the following to
happen:

[ Daemon writes 2 to the unload_heads file ]
1. Set timer / deadline;
2. eh_info.action |= ATA_EH_PARK;
3. schedule EH;
4. execute EH and sleep, waiting for the timeout to expire;

[ Daemon writes 2 to the unload_heads file before the previous timeout
has expired. ]

5. update timer / deadline;
6. the EH thread keeps blocking until the new timeout has expired.

In particular, I don't want to reschedule EH in response to the second
write to the unload_heads file. Also, we have to consider the case where
the daemon signals to resume I/O prematurely by writing a timeout of 0.
In this case, the EH thread should be woken up immediately.

>
>> and in the eh code a modified version of your loop:
>> 
>>     spin_lock_irq(ap->lock);
>>     while ((now = jiffies) < deadline) {
>>         spin_unlock_irq(ap->lock);
>>         set_current_state(TASK_UNINTERRUPTIBLE);
>>         schedule_timeout(deadline - now);
>>         set_current_state(TASK_RUNNING);
>>         spin_lock_irq(ap->lock);
>>     }
>>     spin_unlock_irq(ap->lock);
>
> Yeah, this looks about right, but you can make it a bit simpler...
>
>     while (time_before((now = jiffies), ap->deadline))
> 	schedule_timeout_uninterruptible(ap->deadline - now);
>
> As locking on reader side doesn't mean much in cases like this.  The
> deadline update which triggered EH is guaranteed to be visible and the
> the window between waking up from schedule_timeout and ap->deadline
> dereference is way too small to be any meaningful.

Well, I'm persuaded as far as locking is concerned. Still, the problems
described above remain.

[...]
>>>> +DEVICE_ATTR(unload_feature, S_IRUGO | S_IWUSR,
>>>> +	    ata_scsi_unload_feature_show, ata_scsi_unload_feature_store);
>>>> +EXPORT_SYMBOL_GPL(dev_attr_unload_feature);
>>> Hmmm.... Maybe you can just disable it by echoing -1 to the unload file?
>> 
>> Even though disabling it may be desirable in some cases, it's typically
>> *enabling* it that users will care about. Still, we can always accept -1
>> and -2 and I have to say I rather like the idea. Thanks for the
>> suggestion. Indeed, thank you very much for the thorough review.
>
> Oh.. what I meant was whether we need a separate sysfs node to
> indicate whether unload feature is enabled or not but now I come to
> think about it, that is per-device and the timer is per-port.  :-)

That's no problem. The unload_heads node is per-device too even though
the timer is per port. I really don't think we need the extra node.

Regards,

Elias
