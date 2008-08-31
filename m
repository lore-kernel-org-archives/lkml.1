Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYHaQPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYHaQPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYHaQOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:14:51 -0400
Received: from nebensachen.de ([195.34.83.29]:38890 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbYHaQOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:14:50 -0400
X-Hashcash: 1:20:080831:htejun@gmail.com::0wfjqef2BcV0gd1o:0A2eb
X-Hashcash: 1:20:080831:alan@lxorguk.ukuu.org.uk::cZEDC/kKRyR0G9UL:000000000000000000000000000000000000005X3
X-Hashcash: 1:20:080831:akpm@linux-foundation.org::pjOrBRQvL3bw5KPv:0000000000000000000000000000000000002AJX
X-Hashcash: 1:20:080831:bzolnier@gmail.com::zWruxAOwXLP1sdqf:00000000000000000000000000000000000000000004nZ8
X-Hashcash: 1:20:080831:jeff@garzik.org::HR3+gXbIv6iWl+OG:000xXg
X-Hashcash: 1:20:080831:randy.dunlap@oracle.com::eAph++2Mns7UK8Ag:000000000000000000000000000000000000003Xuc
X-Hashcash: 1:20:080831:linux-ide@vger.kernel.org::JKyc/Q+rz0nx8NOJ:0000000000000000000000000000000000000Gz/
X-Hashcash: 1:20:080831:linux-kernel@vger.kernel.org::PlmS1scG4ShQHlvB:00000000000000000000000000000000053qe
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
	<48BA969C.4060207@gmail.com>
Date: Sun, 31 Aug 2008 18:14:22 +0200
In-Reply-To: <48BA969C.4060207@gmail.com> (Tejun Heo's message of "Sun, 31 Aug
	2008 15:03:24 +0200")
Message-ID: <87abetmaap.fsf@denkblock.local>
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
[...]
>> Sorry, I haven't expressed myself very clearly there, it seems. The user
>> space process detects some acceleration and starts writing timeouts to
>> the sysfs file. This causes the unload command to be issued to the
>> device and stops all I/O until the user space daemon decides that the
>> danger has passed, writes 0 to the sysfs file and leaves it alone
>> afterwards. Now, if the daemon happens to request head parking right at
>> the beginning of a suspend sequence, this means that we are in danger of
>> falling, i.e. we have to make sure that I/O is stopped until that user
>> space daemon gives the all-clear. However, suspending implies freezing
>> all processes which means that the daemon can't keep checking and
>> signalling to the kernel. The last timeout received before the daemon
>> has been frozen will expire and the suspend procedure goes ahead. By
>> means of the notifiers we can make sure that suspend is blocked until
>> the daemon says that everything is alright.
>
> Is it really worth protecting against that?  What if the machine
> started to fall after the userland tasks have been frozen?  And how
> long the usual timeout would be?  If the machine has been falling for
> 10 secs, there really isn't much point in trying to protect anything
> unless there also is ATA DEPLOY PARACHUTE command somewhere in the new
> revision.

We are not just protecting against free fall. Think of a series of minor
shocks in close succession as it might occasionally happen on the train.

>
> In libata, as with any other exceptions, suspend/resume are handled by
> EH so while emergency head unload is in progress, suspend won't
> commence which is about the same effect as the posted code sans the
> timeout extension part.  I don't really think there's any significant
> danger in not being able to extend timeout while suspend is in
> progress.  It's not a very big window after all.  If you're really
> worried about it, you can also let libata reject suspend if head
> unload is in progress.

Personaaly, I'm very much against plain rejection because of the odd
head unload. A delay in the suspend procedure, on the other hand, is
perfectly acceptable to me.

>
> Also, the suspend operation is unloading the head and spin down the
> drive which sound like a good thing to do before crashing.  Maybe we
> can modify the suspend sequence such that it always unload the head
> first and then issue spindown.  That will ensure the head is in safe
> position as soon as possible.  If it's done this way, it'll be
> probably a good idea to split unloading and loading operations and do
> loading only when EH is being finished and the disk is not spun down.

Well, scsi midlayer will also issue a flush cache command. Besides, with
previous implementations I have observed occasional lock ups when
suspending while the unload timer was running. Once we have settled the
timer vs deadline issue, I'm willing to do some more investigation in
this area if you really insist that pm_notifiers should be avoided. But
then I am still not too sure about your reasoning and do feel happier
with these notifiers anyway.

>
> To me, much more serious problem seems to be during hibernation. The
> kernel is actively writing memory image to userland and it takes quite
> a while and there's no protection whatsoever during that time.

That's right. The first requirement to protect against this problem is
to have the policy all in kernel space which isn't going to happen for
some time yet. This really is a *best effort* solution rather than a
perfect one.

>
>>>     spin_lock_irq(ap->lock);
>>>     ap->deadline = jiffies + timeout;
>>>     ap->link.eh_info.action |= ATA_EH_PARK;
>>>     ata_port_schedule_eh(ap);
>>>     spin_unlock_irq(ap->lock);
>> 
>> Please note that I want to schedule EH (and thus the head unload -
>> check power command sequence) only once in the event of overlapping
>> timeouts. For instance, when the daemon sets a timeout of 2 seconds and
>> does so again after one second has elapsed, I want the following to
>> happen:
>> 
>> [ Daemon writes 2 to the unload_heads file ]
>> 1. Set timer / deadline;
>> 2. eh_info.action |= ATA_EH_PARK;
>> 3. schedule EH;
>> 4. execute EH and sleep, waiting for the timeout to expire;
>> 
>> [ Daemon writes 2 to the unload_heads file before the previous timeout
>> has expired. ]
>> 
>> 5. update timer / deadline;
>> 6. the EH thread keeps blocking until the new timeout has expired.
>> 
>> In particular, I don't want to reschedule EH in response to the second
>> write to the unload_heads file. Also, we have to consider the case where
>> the daemon signals to resume I/O prematurely by writing a timeout of 0.
>> In this case, the EH thread should be woken up immediately.
>
> Whether EH is scheduled multiple times or not doesn't matter at all.
> EH can be happily scheduled without any actual action to do and that
> does happen from time to time due to asynchronous nature of events.
> libata EH doesn't have any problem with that.  The only thing that's
> required is there's at least one ata_schedule_eh() after the latest
> EH-worthy event.  So, the simpler code might enter EH one more time
> once in the blue moon, but it won't do any harm.  EH will just look
> around and realize that there's nothing much to do and just exit.

The whole EH machinery is a very complex beast. Any user of the
emergency head park facility has a particular interest that the system
spends as little time as possible in the EH code even if it's real error
recovery that matters most. Perhaps we could agree on the following
compromise:

    spin_lock_irq(ap->lock);
    old_deadline = ap->deadline;
    ap->deadline = jiffies + timeout;
    if (old_deadline < jiffies) {
        ap->link.eh_info.action |= ATA_EH_PARK;
        ata_port_schedule_eh(ap);
    }
    spin_unlock_irq(ap->lock);

There is still a race but it is very unlikely to trigger.

Still, you have dismissed my point about the equivalent of stopping a
running timer by specifying a 0 timeout. In fact, whenever the new
deadline is *before* the old deadline, we have to signal the sleeping EH
thread to wake up in time. This way we end up with something like
wait_event().

Regards,

Elias
