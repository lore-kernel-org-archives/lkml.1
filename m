Return-Path: <linux-kernel-owner+w=401wt.eu-S1030718AbXCFXrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030718AbXCFXrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030724AbXCFXrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:47:00 -0500
Received: from www.osadl.org ([213.239.205.134]:50634 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030718AbXCFXq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:46:58 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EDD82F.90204@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 00:53:02 +0100
Message-Id: <1173225182.24738.507.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Tue, 2007-03-06 at 13:07 -0800, Dan Hecht wrote:
> > Why is this so non-trivial ? All you have to do is _NOT_ register
> > PIT/HPET/APIC timers and register a per CPU hyper-CE-device instead,
> > which uses the hypervisor timer emulation instead of real hardware.
> > 
> > clockevents breaks the hardwired assumptions of the old timer code and
> > allows you to remove _ALL_ the hardwired hackery in vmitimer.c, i.e.
> > stuff like
> > 
> >        /* Disable PIT. */
> >         outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
> > 
> 
> Hmm, I think that the (virtual) bios still will set up the PIT ch 0, and 
> we still need to stop it.

I guess you have access to the source code of this virtual BIOS. So this
is a real cute technical solution.

ROTFL. The number of lame excuses in this whole virtualization
discussion is amazing.

> In any case, clockevents doesn't really make it easier nor harder as far 
> as init goes.  In the pre-clockevent days, we replace setup_pit_timer, 
> setup_boot_clock, setup_secondary_clock.  With clockevents, I think the 
> hook points are the same.  Mostly just need to allow the per-cpu 
> lapic_event to be generalized to local_clock_events that can be set to 
> whatever device we want.  The other thing on i386 is just some minor 
> annoyances due initially setting up only the PIT on cpu0 on irq 0 and 
> then later setting up per-cpu timer on lvtt, and making this all place 
> nice with paravirt timers.  But these are just details and just require 
> some minor changes and will be working, but it just takes some massaging.

Nothing forces you to follow that low level hardware scheme. That's
_WHY_ clockevents are there. Create a per cpu clock event source, which
uses whatever interrupt you want (you just need to be able to pin it to
the cpu)

> So, that is not the real reason to move over the clockevents. 

It is partially, because clockevents remove the hardcoded hardware
assumptions.

> The real 
> reason is to use the generic interrupt handlers.  We understand that, 
> and will get to that point.  In the mean time, we are harming no one. 
> Our code has zero effect when you booting natively or on a non-VMI 
> hypervisor.

The "we are harming no one" argument is a great excuse to push random
hackery into the kernel. Once it is there, there is no rush to fix it
because it works (for you).

That's exactly the point which is discussed in the "Xen & VMI" thread.
We open up a can of worms and within no time we have 5 or more different
solutions for the same problem. If we do not look careful at this, we
have no way to do any changes in the core code w/o breaking one of those
hypervisor interfaces. The in tree / FOSS hypervisor interfaces might be
fixable, but those which throw a binary blob to the kernel are not.

I completely agree with Ingo, that this whole paravirt business starts
to crawl across the kernel spreading paralyis all over the place.

We have already enough trouble with real hardware, so we want to
carefully avoid that we get broken virtual hardware as an extra workload
via paravirt ops.

> >> We worked around this by keeping NO_IDLE_HZ support, which now 
> >> you deprecated.  So now we are using NO_HZ without a hyper-CE device, 
> >> and it is working fine.  We understand the benefits of moving to the CE 
> >> model - but it cannot be done overnight.
> > 
> > This is ugly as hell. NO_HZ enables the dyntick functions in idle(),
> > irq_enter() and irq_exit() so the clockevents code is actually invoked.
> > I have not looked close enough why this does work at all.
> > 
> 
> I believe this was just a quick fix in response to Ingo breaking the VMI 
> build yesterday by disabling NO_IDLE_HZ on us.  There is no technical 
> reason why NO_IDLE_HZ=y can't coexist with NO_HZ.
>
> (The two work okay together because when using NO_IDLE_HZ, the hooks are 
> deeper in a custom safe_halt routine which isn't registered when using 
> nohz mode at runtime, and conversely, the nohz code is guarded at 
> runtime by the ts->nohz_mode.  So, the two really can co-exist at 
> compile time).

It is guarded by the fact, that you are not registering clockevent
devices. It's not guarded by design. It happens to work.

> Again, no one is arguing that we shouldn't move to clockevents, it's 
> just a matter of time (sorry, no pun intended).

clockevents have been around for quite a time - pun intended :). They
did not surface surprisingly with 2.6.21-rc1.

> The vmi-time code was introduced to solve some shortcomings of the old 
> (pre-clocksource/clockevents/hrtimer/NO_HZ) i386 timer code that was 
> especially painful for virtualization.  Certainly, 
> clocksource/clockevents/NO_HZ solves many of the problems (basically, 
> moving away from counting interrupts to using time sources).  e.g. xtime 
> updating is no longer a worry with the new timeofday/clocksource stuff. 
>   But there are some that may not quite be solved, listed below.  (I 
> know I'm not telling you anything new, but I might as well flesh it out 
> for the other paravirt folks while the code is fresh in my mind):
> 
> 1) Stolen time (virtual cpu is ready to run but not running): this is 
> handled inconsistently between the various clockevent handlers / 
> CLOCK_EVT_MODE_ONESHOT combinations:
> 
>   a) tick_handle_periodic / CLOCK_EVT_MODE_PERIODIC: depends on how you 
> define "periodic" timer in a paravirtual world.  If you do something 
...
>   b) tick_handle_periodic / CLOCK_EVT_MODE_ONESHOT:
...
>    - Same problem about jiffies only updated by one vcpu.

The periodic mode is only used during boot time, when you have NO_HZ
and/or HIGH_RES_TIMERS enabled. Once you switch over to NO_HZ and / or
HIGH_RES_TIMERS the periodic mode is gone for ever.

All paravirt users probably want to have NO_HZ, so PARAVIRT might simply
depend on NO_HZ. Of course I might be wrong :)

OTOH the stolen time accounting should be fixed in general and not rely
on it happens to work now assumptions. And it should be done for _ALL_
hypervisors in the same way, i.e. in the generic code.

The vcpu binding of jiffies update is a nobrainer to fix.

>   c) tick_nohz_handler (implies CLOCK_EVT_MODE_ONESHOT):
>    - jiffies updated according to monotonic time. this is good.
>    - Process time effectively does not count stolen time since 
> update_process_times is called once per callback but oneshot expiry is 
> advanced into the future.  This is probably the right thing for 
> paravirt, but, inconsistent with (b).

See above.

>    - jiffies updated by all vcpus, which is good.
> 
>   d) hrtimer_interrupt (really tick_sched_timer):
>    - w.r.t. stolen time, will be similar to (c).  We'll advance the 
> sched_timer to the next period in the future, skipping stolen time for 
> process accounting.

See above.

>    - jiffies will be kept up to date with monotonic time.
>    - jiffies updated by all vcpus, which is good.
> 
> Summary: Cases (c) and (d) should be relatively well behaved for 
> paravirt.  So, if we can depend on NO_HZ=y and not being disabled at 
> runtime, we should be okay.  We may want to have some knowledge of 
> stolen time passed from the hypervisor (if we wanted more accurate 
> process time accounting), but this can be put back in later, and isn't 
> too important with sample based accounting system like Linux. But, we 
> still need to QA all four cases, and all four cases will likely expose 
> different bugs due to second order effects.

bugs in the hypervisor ? :)

> 2) Virtual interrupts have a relatively high overhead as compared with 
> native interrupts.  So, in vmitime, we wanted to be able to lower the 
> timer interrupt rate at runtime, even if HZ is a compile time constant 
> (and set to something high, like 1000hz).  While we could hack this in 
> by using evt->min_delta_ns, it wouldn't really work since process time 
> accounting would be wrong.  Instead, we should allow the 
> tick_sched_timer in cases (c) and (d) to have runtime configurable 
> period, and then scale the time value accordingly before passing to 
> account_system_time.  This is probably something the Xen folks will want 
> also, since I think Xen itself only gets 100hz hard timer, and so it can 
> implement at best a oneshot virtual timer with 100hz resolution.  Any 
> objections to us doing something like this?

Yes. It's gross hackery. 

1) We want to have a cleanup of the tick assumptions _all_ over the
place and this is going to be real hard work.

2) As I said above. The time accounting for virtualization needs to be
fixed in a generic way.

I'm not going to accept some weird hackery for virtualization, which is
of exactly ZERO value for the kernel itself. Quite the contrary it will
make the cleanup harder and introduce another hard to remove thing,
which will in the worst case last for ever.

> 3) clockevent set_next_event interface is suboptimal for paravirt (and 
> probably realtime-ish uses).  The problem is that the expiry is passed 
> as a relative time.  On paravirt, an arbitrary amount of (stolen) time 
> may have passed since the delta was computed and when the timer device 
> is programmed, causing that next interrupt to be too far out in the 
> future.  It seems a better interface for set_next_event would be to pass 
> the current time and the absolute expiry.  Actually, I sent email to 
> Thomas and Ingo about this (and some other clockevents/hrtimer feedback) 
> in July 2006, but never heard back.  Thoughts?

There is no problem for realtime uses, as the reprogramming path is
running with local interrupts disabled. I can see the point for paravirt
and I'm not opposed to change / expand the interface for that. It might
be done by an extra clockevents feature flag, which requests absolute
time instead of relative time.

Sorry for not replying back then, your mail got into the huge pile of "I
take care of those, when I have some time" mails.

> I think all the other important points that the vmitime code addressed 
> are also addressed by clocksource/clockevents/NO_HZ.
> 
> Finally, while I agree that writing the clockevent callback code is 
> trivial, we will hit bugs when moving over.  It is something we need to 
> do, but just takes some time for us to test and shake out the bugs.

Dave Miller did a conversion of SPARC64 to clock sources and clock
events within a couple of days. He hit _AND_ fixed a couple of bugs in
the go. But he simply did it.

So your "it takes time" prayer wheel is not impressing me at all. 

clockevents have been there long enough to shake out the problems. It
would have been certainly more helpful for everybody if you had started
to use them early and to provide bugreports and/or patches instead of
insisting on the "our hackery works" approach.

> For 
> example, we are seeing this bug.  It seems to me that tick_sched_timer 
> should not be running in softirq context, but only from the 
> hrtimer_interrupt.  Is that right?  I'm not sure how we get into this case.

Fix is already in Linus tree.

	tglx


