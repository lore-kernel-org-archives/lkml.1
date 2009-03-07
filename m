Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZCGI7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZCGI7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 03:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZCGI7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 03:59:36 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:33910 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbZCGI7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 03:59:36 -0500
Subject: Re: Process accounting in interrupt diabled cases
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <49B1CD54.8070805@goop.org>
References: <1236380615.4637.67.camel@alok-dev1> <49B1C1D1.4070603@goop.org>
	 <1236387583.4558.22.camel@alok-dev1>  <49B1CD54.8070805@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Sat, 07 Mar 2009 00:59:33 -0800
Message-Id: <1236416374.23222.52.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 17:26 -0800, Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
> > I don't know if their are instances when interrupts are actually
> > disabled for such a long time in the kernel , but I don't see a reason
> > why this might not be happening currently, i.e. do we have a way to
> > detect such cases. 
> > I noticed this problem ( with process accounting) only when testing my
> > stolen time theory below, in which i had intentionally disabled
> > interrupts for long. 
> >
> > So, in case of buggy code which disables interrupt for long, this could
> > affect process accounting and could result in the stolen time being
> > reported incorrectly ( considering the stolen time idea mentioned below
> > is okay).
> >   
> 
> Does it matter how long interrupts are actually disabled.  Tickless is 
> definitely the preferred mode of operation for any virtual guest, so 
> time accounting is independent from when the actual timer interrupts 
> occur; its quite possible we'll see no interrupts for a long time 
> indeed.

Yes that's alright, all that time when vcpu was idle and scheduled out
will anyways be accounted as idle time, as mentioned in my earlier mail
( and if my understanding is not wrong) this is handled by
tick_nohz_restart_sched_tick.

But i was talking about a case, where we have this code
	local_irq_disable()
	some_work()
	local_irq_enable()

If this some_work() executed for say 2 ticks, shouldn't the process
executing this be accounted 2 ticks of system time ? According to my
understanding, we will account a single tick for this, right ? 

I agree that this "some_work" is wrong to start with and it shouldn't
keep interrupts disabled for so long, but i am considering this case
just to understand if process_accounting needs any changes for this
case.

>   If we accrue unstolen time to a task when we actually context 
> switch then the accounting will all work out, no?

But getting the unstolen time is a problem, and I want to try and see if
this unstolen time can be calculated without querying the hypervisor.

> 
> >>> I stumbled across this while trying to find a solution to figure out the
> >>> amount of stolen time from Linux, when it is running under a hypervisor.
> >>> One of the solutions could be to ask the hypervisor directly for this
> >>> info, but in my quest to find a generic solution I think the below would
> >>> work too.
> >>> The total process time accounted by the system on a cpu ( system, idle,
> >>> wait and etc) when deducted from the amount TSC counter has advanced
> >>> since boot, should give us this info about the cputime stolen from the
> >>> kernel
> >>>       
> >> You're assuming that the tsc is always going to be advancing at a 
> >> constant rate in wallclock time?  Is that a good assumption?  Does 
> >> VMWare virtualize the tsc to make this valid?  If something's going to 
> >> the effort of virtualizing tsc, how do you know they're not also 
> >> excluding stolen time?
> >>     
> >
> >
> > Yes, TSC is the correct thing atleast for VMware over here. But my idea
> > is not to advocate using TSC here, if it doesn't work for Xen we could
> > use something else which gives a notion of Total_time there, a parvirt
> > call to read that can be done. I don't know what that would be for XEN,
> > but you would know better, please suggest if there is already a paravirt
> > call which gets that value for XEN ? 
> >   
> 
> Yes, Xen already accounts stolen time in its timer interrupt handler.

Yep I did look at that code earlier, and that's how we can do it for VMI
too, (actually it was there in VMI in 2.6.21 but we removed it during
the NO_HZ merge). I am trying to see if we could do this for the non-VMI
case i.e for the native kernel case. 
> 
> But more significantly it uses unstolen time as the timebase for 
> sched_clock() so that the scheduler will only credit a task for the 
> actual amount of time it spends executing, rather than a full wallclock 
> timeslice.

That's a good point, that means we might have to change the
native_sched_clock definition too to return this (rdtsc - stolen time)
value.

> 
> >> What timebase is the kernel using to measure idle, system, wait, ...?  
> >> Presumably something that doesn't include stolen time.  In that case 
> >> this just comes down to "PCPU_STOLEN = TOTAL_TIME - PCPU_UNSTOLEN_TIME", 
> >> where you're proposing that TOTAL_TIME is the tsc.
> >>     
> >
> > Again not proposing to use tsc, please suggest what works for Xen. 
> > And about the PCU_UNSTOLEN_TIME, i am proposing it could be a summation
> > of all the fields in kstat_cpu.cpustat except the steal value.
> >   
> 
> No, I'm not advocating anything in particular; I'm trying to understand 
> your proposal.
> 
> You're positing two timebases: one which measures wallclock time (that 
> could be the tsc in VMWare's case), and another which measures unstolen 
> time, so you can tell how long a cpu has spent actually running 
> something.  What's your proposal for the unstolen clock?  How does the 
> kernel measure unstolen time?  It can't measure it with the tsc, because 
> that would include any stolen time in the measurement.
> 
I am saying that we should have just one timebase, one which measures
wallclock time. I am thinking that we can calculate the unstolen time
rather than asking the hypervisor. 
As mentioned earlier

UNSTOLEN time on a cpu  = summation of kstat_cpu().cpustat variables
                          (except the steal time variable)

So we can easily get the stolen_time as...
stolen_time from a cpu = wallclock_time - Unstolen_time.

> Also, I'm not sure it makes sense to distinguish between vcpu idle time 
> and stolen time.  If a vcpu is idle/blocked, how can you steal time from 
> it?  It's only stolen time if it wants to run but can't.

The vcpu idle time will be accounted correctly as idle time with
tick_nohz_restart_sched_tick. So I don't think we would be confusing it
ever as stolen time atleast in the NO_HZ case.

Thanks,
Alok

