Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYIAOwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYIAOwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbYIAOwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:52:09 -0400
Received: from nebensachen.de ([195.34.83.29]:36019 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYIAOwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:52:07 -0400
X-Hashcash: 1:20:080901:htejun@gmail.com::5LgCqTpvQ6ud/yCp:00bmm
X-Hashcash: 1:20:080901:alan@lxorguk.ukuu.org.uk::F5Ao48lW8YXdW8cc:00000000000000000000000000000000000008w8t
X-Hashcash: 1:20:080901:akpm@linux-foundation.org::uC2CuczwSXFEkKrl:000000000000000000000000000000000000FBSr
X-Hashcash: 1:20:080901:bzolnier@gmail.com::GRnJJX6VEia1cKOl:00000000000000000000000000000000000000000001p+B
X-Hashcash: 1:20:080901:jeff@garzik.org::mHVLUxLtgzrhesEP:00ICnX
X-Hashcash: 1:20:080901:randy.dunlap@oracle.com::7veYEOJRe0FNOAil:0000000000000000000000000000000000000059rK
X-Hashcash: 1:20:080901:linux-ide@vger.kernel.org::N89eB85bl9Zjva8u:0000000000000000000000000000000000007yY1
X-Hashcash: 1:20:080901:linux-kernel@vger.kernel.org::/g4OXlt4AUR9coN7:00000000000000000000000000000000019bq
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
	<48BBA8D1.8020604@gmail.com>
Date: Mon, 01 Sep 2008 16:51:14 +0200
In-Reply-To: <48BBA8D1.8020604@gmail.com> (Tejun Heo's message of "Mon, 01 Sep
	2008 10:33:21 +0200")
Message-ID: <87myirly1p.fsf@denkblock.local>
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
>>> Also, the suspend operation is unloading the head and spin down the
>>> drive which sound like a good thing to do before crashing.  Maybe we
>>> can modify the suspend sequence such that it always unload the head
>>> first and then issue spindown.  That will ensure the head is in safe
>>> position as soon as possible.  If it's done this way, it'll be
>>> probably a good idea to split unloading and loading operations and do
>>> loading only when EH is being finished and the disk is not spun down.
>> 
>> Well, scsi midlayer will also issue a flush cache command. Besides, with
>> previous implementations I have observed occasional lock ups when
>> suspending while the unload timer was running. Once we have settled the
>> timer vs deadline issue, I'm willing to do some more investigation in
>> this area if you really insist that pm_notifiers should be avoided. But
>> then I am still not too sure about your reasoning and do feel happier
>> with these notifiers anyway.
>
> I'm not particularly against pm_notifiers.  I just can't see what
> advantages it have given the added complexity.  The only race window
> it closes is the one between suspend start and userland task freeze,
> which is a relatively short one and there are other much larger gaping
> holes there, so I don't really see much benefit in the particular
> pm_notifiers usage.  Maybe we need to keep the task running till the
> power is pulled?  If we can do that in sane manner which is no easy
> feat I agree, that can also solve the problem with hibernation.

I doubt that is feasible without substantial work especially as long as
part of it all is implemented in user space. With regard to the
pm_notifiers, I'll try to figure out exactly what the problem was
without them (I thought it was related to timers not firing anymore
after process freezing, but Pavel doubts that and I'm not too sure
anymore).

[...]
>>>> In particular, I don't want to reschedule EH in response to the second
>>>> write to the unload_heads file. Also, we have to consider the case where
>>>> the daemon signals to resume I/O prematurely by writing a timeout of 0.
>>>> In this case, the EH thread should be woken up immediately.
>>> Whether EH is scheduled multiple times or not doesn't matter at all.
>>> EH can be happily scheduled without any actual action to do and that
>>> does happen from time to time due to asynchronous nature of events.
>>> libata EH doesn't have any problem with that.  The only thing that's
>>> required is there's at least one ata_schedule_eh() after the latest
>>> EH-worthy event.  So, the simpler code might enter EH one more time
>>> once in the blue moon, but it won't do any harm.  EH will just look
>>> around and realize that there's nothing much to do and just exit.
>> 
>> The whole EH machinery is a very complex beast.
>
> The logic is quite complex due to the wonderful ATA but for users
> requesting actions, it really is quite simple.  Well, at least I think
> so.  (but I would say that, wouldn't I? :-)

Yes, you would ;-). Seriously though, I do agree that it is easy for
users to get the right message across to EH but ...

>
>> Any user of the
>> emergency head park facility has a particular interest that the system
>> spends as little time as possible in the EH code even if it's real error
>> recovery that matters most. Perhaps we could agree on the following
>> compromise:
>> 
>>     spin_lock_irq(ap->lock);
>>     old_deadline = ap->deadline;
>>     ap->deadline = jiffies + timeout;
>>     if (old_deadline < jiffies) {
>>         ap->link.eh_info.action |= ATA_EH_PARK;
>>         ata_port_schedule_eh(ap);
>>     }
>>     spin_unlock_irq(ap->lock);
>
> Really, it doesn't matter at all.  That's just an over optimization.
> The whole EH machinery pretty much expects spurious EH events and
> schedules and deals with them quite well.  No need to add extra
> protection.

... because of its complexity it is hard for me to estimate timing
impacts and constraints. The questions I'm concerned about are: What is
the average and worst case time it takes to get the heads parked and
what can I do if not to improve either of them, then at least not to make
things worse. In particular, I don't really have a clue about how much
time it takes to go through EH if no action is requested in comparison
to, say, the average read / write command. Obviously, I don't want to
schedule EH unnecessarily if that would mean that I won't be able to
issue another head unload for considerably longer than during normal I/O
or, indeed, on an idle system. Arguably, I don't even want to do
anything that causes more logging than absolutely necessary because this
will ultimately result in the disk spinning up from standby. But then I
believe that I only came across this logging issue when I was still
playing around with eh_revalidate and the like. So, can you set my mind
at rest that timing is no issue with spurious EH sequences? Now that I
come to think of it, I suppose it would harm performance anyway, so
everybody would care about such a delay, right?

>
>> There is still a race but it is very unlikely to trigger.
>> 
>> Still, you have dismissed my point about the equivalent of stopping a
>> running timer by specifying a 0 timeout. In fact, whenever the new
>> deadline is *before* the old deadline, we have to signal the sleeping EH
>> thread to wake up in time. This way we end up with something like
>> wait_event().
>
> Yes, right, reducing the timeout.  How about doing the following?
>
> 	wait_event(ata_scsi_part_wq,
> 		   time_before(jiffies, ap->unload_deadline));
>
> Heh... then again, it's not much different from your original code.  I
> won't object strongly to the original code but I still prefer just
> setting deadline and kicking EH from the userside instead of directly
> manipulating the timer.  That way, implementation is more separate
> from the interface and to me it seems easier to follow the code.

That's fine with me. All I want is that my code doesn't end up leaving
the system in an unresponsive state (to a head unload request, that is)
more often than before by spuriously scheduling EH. If that is not a
problem, I'm content.

Regards,

Elias
