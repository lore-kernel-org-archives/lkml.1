Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXCNTe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXCNTe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbXCNTe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:34:29 -0400
Received: from gw.goop.org ([64.81.55.164]:47448 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926AbXCNTe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:34:28 -0400
Message-ID: <45F84E39.7030507@goop.org>
Date: Wed, 14 Mar 2007 12:34:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com>
In-Reply-To: <45F846AB.6060200@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> Yes, I was just trying to use some consistent terminology, so I picked
> linux (hrtimer.c) terms: CLOCK_REALTIME == wallclock, CLOCK_MONOTONIC
> == "real" time counter.

OK.  I had used "monotonic" in its more general sense earlier in the
thread, and I wanted to be sure.

> Even cpu clock cycles doesn't really tell you how much "work" a cpu
> was able to get done.  Different cpus have different throughputs per
> cycle per instruction sequence.

Sure.  But on a given machine, the CPUs are likely to be closely enough
matched that a cycle on one CPU is more or less equivalent to a cycle on
another CPU.  The fact that a cycle represents a different amount of
work on an i486 compared to Core2 doesn't matter much.  The important
part is that when the scheduler is doling out CPU time is comparing
everyone's usages with a common unit.

> Right, and that's why I'm not sure I'm convinced the two should be
> confused.  In the case of cpufreq you are talking about the cpu not
> doing as much work due to a choice the kernel made.  In the case of
> stolen time, the choice wasn't made by the kernel, but instead the
> hypervisor.  I understand they are somewhat similar from the
> perspective of the scheduler, but a bit different.
Yes, but the question is whether it matters all that much?  Does it
matter enough to make them two separate concepts, when one seems to
cover all the important points?

> Also, I'm not sure this is the right thing for cpufreq because:
> 1) when the load is high, which is when this all matters, presumably
> the kernel will ramp up the cpu to full speed.

Not at all.  You might have an unimportant but cpu-bound process which
doesn't merit increasing the cpu speed, but should also be scheduled
properly compared to other processes.  I often nice my kernel builds
(which cpufreq takes as a hint to not ramp up the cpu speed) on my
laptop so to save power.

> 2) in the case where there are two different machines with two
> different process speeds (well, really processor throughputs), today
> the scheduler doesn't care about trying to adjust the timing due to
> one machine being faster than the other.

It doesn't matter.  The scheduler is only important when there's
contention for the cpu, and if there is, that it compare process CPU
usage with the same unit.  What that unit isn't inherently very
important, so long as its consistent.

> I'm not sure this makes sense because it was the kernel that decided
> slow the cpus and cause less work to be done.

That's true.  But this is a case of the left brain not talking to the
right brain: cpufreq might decide to slow a cpu down, but the scheduler
doesn't take that into account.  Making the timebase of sched_clock
reflect the current cpu speed (or more specifically, the integral of the
cpu speed over a time interval) is a good way of communicating between
the two subsystems.

> In the case of stolen time, however, the kernel was even running at
> all on any pcpu, and it wasn't even up to the kernel to decide that.

As things stand now, there's not much difference from the scheduler's
perspective, since the scheduler takes no action in either case.

> I listed them below.  To summarize, there are (at least) three:
>
> 1) sched_clock, the main topic of this thread.
> 2) p->time_slice

So, this is the target process timeslice, in units of sched_clock's
timebase?

> 3) cpustat->steal
>
>>> For example, the stuff that happens in update_process_times().  I
>>> think we'd want to account the stolen time to cpustat->steal.
>>
>> I guess we could do something for that.  Would we account non-full-speed
>> cpus to it?  Maybe?
>>
>> How is cpustat->steal used?  How does it get out to usermode?
>>
>
> Via /proc/stat, used by modern 'top', maybe other utilities.  It is
> useful to users who want to see where the time is really going from
> inside a guest when running on a (para)virtual machine.
>
> I believe previous set of xen paravirt-ops patches already handled
> cases #2 and #3 (but no longer do since switching to clockevents), and
> the old vmitime code did also.  Obviously, we need revamp this stuff
> to make it fit in with the new clockevents/hrtimer way of doing things.

I added stolen time accounting to xen-pv_ops last night.  For Xen, at
least, it wasn't hard to fit into the clockevent infrastructure.  I just
update the stolen time accounting for each cpu when it gets a timer
tick; they seem to get a tick every couple of seconds even when idle.

Similarly, implementing sched_clock as "number of ns the vcpu spent in
running state" is simple and direct (though this makes it an explicitly
per-cpu clock; comparing raw sched_clock values between cpus will be
meaningless; but that's likely true when using the tsc as a timebase too).

>> I think the important part is that sched_clock() be used to actually
>> compute how much time each process gets.  The fact that a time quantum
>> gets stolen is less important.  Or do you mean something else?
>>
>
> How is time quantum getting stolen less important?  Time quantum
> getting stolen results directly in more unnecessary context switches
> since we might steal the entire timeslice before the process even ran.

It doesn't matter why you didn't get the time; the important part is
that you know that time went missing.  Its true that you may end up with
some spurious rescheds, but that seems like the kind of thing you'd want
to measure as being a problem before getting clever in fixing.

> I actually think #2 and #3 might be more important than #1 (at least
> they are as important).  And, the earlier Xen patches seem to agree
> with this, since they addressed 2 & 3 only.

I'd call that an oversight.  Xen has everything needed to implement
sched_clock in terms of non-stolen time.

>> Yes.  In the same way that clock modulation gates the cpu clock, the
>> hypervisor effectively gates the clock by giving time to other vcpus.
>>
>
> Yes, except in one case it was a choice of the kernel, and in the
> other it was up to the hypervisor.

Not necessarily.  The cpu might drop into thermal protection clock
modulation.

    J
