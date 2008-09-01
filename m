Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYIAIeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYIAIeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYIAIed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:34:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:56808 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYIAIeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZCG09biXf7aWG3/5Q3wuIvQbanFu1dQJPGu3pTab5w3QcKVEgtBygXo9Hr0yf4+IFm
         Uq0zOK4kvXvuVqS7bZv8KAgMeExaPVNgB/NydvaEPuI/UOWUzxiV4PLldP7oZbxmx/DQ
         2+EXT6Op24/XKhm1jVyIed4uPW4zwFy8iy+KU=
Message-ID: <48BBA8D1.8020604@gmail.com>
Date: Mon, 01 Sep 2008 10:33:21 +0200
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
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>
In-Reply-To: <87abetmaap.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Elias Oltmanns wrote:
>> Is it really worth protecting against that?  What if the machine
>> started to fall after the userland tasks have been frozen?  And how
>> long the usual timeout would be?  If the machine has been falling for
>> 10 secs, there really isn't much point in trying to protect anything
>> unless there also is ATA DEPLOY PARACHUTE command somewhere in the new
>> revision.
> 
> We are not just protecting against free fall. Think of a series of minor
> shocks in close succession as it might occasionally happen on the train.

Right...

>> In libata, as with any other exceptions, suspend/resume are handled by
>> EH so while emergency head unload is in progress, suspend won't
>> commence which is about the same effect as the posted code sans the
>> timeout extension part.  I don't really think there's any significant
>> danger in not being able to extend timeout while suspend is in
>> progress.  It's not a very big window after all.  If you're really
>> worried about it, you can also let libata reject suspend if head
>> unload is in progress.
> 
> Personaaly, I'm very much against plain rejection because of the odd
> head unload. A delay in the suspend procedure, on the other hand, is
> perfectly acceptable to me.
> 
>> Also, the suspend operation is unloading the head and spin down the
>> drive which sound like a good thing to do before crashing.  Maybe we
>> can modify the suspend sequence such that it always unload the head
>> first and then issue spindown.  That will ensure the head is in safe
>> position as soon as possible.  If it's done this way, it'll be
>> probably a good idea to split unloading and loading operations and do
>> loading only when EH is being finished and the disk is not spun down.
> 
> Well, scsi midlayer will also issue a flush cache command. Besides, with
> previous implementations I have observed occasional lock ups when
> suspending while the unload timer was running. Once we have settled the
> timer vs deadline issue, I'm willing to do some more investigation in
> this area if you really insist that pm_notifiers should be avoided. But
> then I am still not too sure about your reasoning and do feel happier
> with these notifiers anyway.

I'm not particularly against pm_notifiers.  I just can't see what
advantages it have given the added complexity.  The only race window
it closes is the one between suspend start and userland task freeze,
which is a relatively short one and there are other much larger gaping
holes there, so I don't really see much benefit in the particular
pm_notifiers usage.  Maybe we need to keep the task running till the
power is pulled?  If we can do that in sane manner which is no easy
feat I agree, that can also solve the problem with hibernation.

>> To me, much more serious problem seems to be during hibernation. The
>> kernel is actively writing memory image to userland and it takes quite
>> a while and there's no protection whatsoever during that time.
> 
> That's right. The first requirement to protect against this problem is
> to have the policy all in kernel space which isn't going to happen for
> some time yet. This really is a *best effort* solution rather than a
> perfect one.

Yeap, it is.  I just thought pm_notifiers bit didn't really contribute
any noticeable amount to the best effort.

>>> In particular, I don't want to reschedule EH in response to the second
>>> write to the unload_heads file. Also, we have to consider the case where
>>> the daemon signals to resume I/O prematurely by writing a timeout of 0.
>>> In this case, the EH thread should be woken up immediately.
>> Whether EH is scheduled multiple times or not doesn't matter at all.
>> EH can be happily scheduled without any actual action to do and that
>> does happen from time to time due to asynchronous nature of events.
>> libata EH doesn't have any problem with that.  The only thing that's
>> required is there's at least one ata_schedule_eh() after the latest
>> EH-worthy event.  So, the simpler code might enter EH one more time
>> once in the blue moon, but it won't do any harm.  EH will just look
>> around and realize that there's nothing much to do and just exit.
> 
> The whole EH machinery is a very complex beast.

The logic is quite complex due to the wonderful ATA but for users
requesting actions, it really is quite simple.  Well, at least I think
so.  (but I would say that, wouldn't I? :-)

> Any user of the
> emergency head park facility has a particular interest that the system
> spends as little time as possible in the EH code even if it's real error
> recovery that matters most. Perhaps we could agree on the following
> compromise:
> 
>     spin_lock_irq(ap->lock);
>     old_deadline = ap->deadline;
>     ap->deadline = jiffies + timeout;
>     if (old_deadline < jiffies) {
>         ap->link.eh_info.action |= ATA_EH_PARK;
>         ata_port_schedule_eh(ap);
>     }
>     spin_unlock_irq(ap->lock);

Really, it doesn't matter at all.  That's just an over optimization.
The whole EH machinery pretty much expects spurious EH events and
schedules and deals with them quite well.  No need to add extra
protection.

> There is still a race but it is very unlikely to trigger.
> 
> Still, you have dismissed my point about the equivalent of stopping a
> running timer by specifying a 0 timeout. In fact, whenever the new
> deadline is *before* the old deadline, we have to signal the sleeping EH
> thread to wake up in time. This way we end up with something like
> wait_event().

Yes, right, reducing the timeout.  How about doing the following?

	wait_event(ata_scsi_part_wq,
		   time_before(jiffies, ap->unload_deadline));

Heh... then again, it's not much different from your original code.  I
won't object strongly to the original code but I still prefer just
setting deadline and kicking EH from the userside instead of directly
manipulating the timer.  That way, implementation is more separate
from the interface and to me it seems easier to follow the code.

Thanks.

-- 
tejun
