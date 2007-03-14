Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXCNTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXCNTCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932687AbXCNTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:02:15 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52802 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932572AbXCNTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:02:14 -0400
Message-ID: <45F846AB.6060200@vmware.com>
Date: Wed, 14 Mar 2007 12:02:03 -0700
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Dan Hecht <dhecht@vmware.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org>
In-Reply-To: <45F77C27.8090604@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2007 19:02:01.0510 (UTC) FILETIME=[3F6EAC60:01C7666B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2007 09:37 PM, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>> With your previous definition of work time, would it be that:
>>
>> monotonic_time == work_time + stolen_time ??
> 
> (By monotonic time, I presume you mean monotonic real time.)  

Yes, I was just trying to use some consistent terminology, so I picked 
linux (hrtimer.c) terms: CLOCK_REALTIME == wallclock, CLOCK_MONOTONIC == 
"real" time counter.

> Yes, I
> suppose you could, but I don't think that's terribly useful.   I think
> work_time is probably most naturally measured in cpu clock cycles rather
> than an actual time unit.  You could convert it to ns, but I don't see
> the point.
> 

Even cpu clock cycles doesn't really tell you how much "work" a cpu was 
able to get done.  Different cpus have different throughputs per cycle 
per instruction sequence.


> I know its a term in general use, but I don't think the term "stolen
> time" is all that useful, particularly when we're talking about a more
> general notion of cpu work contributing to the progress of process
> execution.  In the cpufreq case, time isn't "stolen" per se.
> 

Right, and that's why I'm not sure I'm convinced the two should be 
confused.  In the case of cpufreq you are talking about the cpu not 
doing as much work due to a choice the kernel made.  In the case of 
stolen time, the choice wasn't made by the kernel, but instead the 
hypervisor.  I understand they are somewhat similar from the perspective 
of the scheduler, but a bit different.

Also, I'm not sure this is the right thing for cpufreq because:
1) when the load is high, which is when this all matters, presumably the 
kernel will ramp up the cpu to full speed.
2) in the case where there are two different machines with two different 
process speeds (well, really processor throughputs), today the scheduler 
doesn't care about trying to adjust the timing due to one machine being 
faster than the other.  I think this is might be design; i.e. the 
scheduler was intended to work in terms of real time units rather than 
work units.  I guess you are arguing that this is incorrect, and the 
scheduler should be scheduling based on how much work it was able to get 
done.  I'm not sure this makes sense because it was the kernel that 
decided slow the cpus and cause less work to be done.

In the case of stolen time, however, the kernel was even running at all 
on any pcpu, and it wasn't even up to the kernel to decide that.


> (I guess I don't like the term stolen time because you don't refer to
> time spent on other processes as being stolen from your process: its
> just processor time being distributed.)
> 

Okay. I think maybe it comes from the fact that most moder processes 
expect to time share the cpu, whereas most kernels do not expect this, 
and it has already been adopted by the kernel (cpustat->steal).  But, I 
don't really care what we call it.

>> i.e. would you be defining stolen_time to include the time lost to
>> processes due to the cpu running at a lower frequency?  How does this
>> play into the other potential users, besides sched_clock(), of stolen
>> time?  We should make sure that the abstraction introduced here makes
>> sense in those places too.
> 
> Be specific.  What other uses are there?
> 

I listed them below.  To summarize, there are (at least) three:

1) sched_clock, the main topic of this thread.
2) p->time_slice
3) cpustat->steal

>> For example, the stuff that happens in update_process_times().  I
>> think we'd want to account the stolen time to cpustat->steal.
> 
> I guess we could do something for that.  Would we account non-full-speed
> cpus to it?  Maybe?
> 
> How is cpustat->steal used?  How does it get out to usermode?
> 

Via /proc/stat, used by modern 'top', maybe other utilities.  It is 
useful to users who want to see where the time is really going from 
inside a guest when running on a (para)virtual machine.

I believe previous set of xen paravirt-ops patches already handled cases 
#2 and #3 (but no longer do since switching to clockevents), and the old 
vmitime code did also.  Obviously, we need revamp this stuff to make it 
fit in with the new clockevents/hrtimer way of doing things.

Also, s390 and powerpc arch's already account steal time, as another 
reference point.  (the old xen time code and vmi time code worked much 
in the same way as those).  We should bring the s390 and powerpc folks 
into the discussion.

> 
>>   Also we'd probably want account for stolen time with regards to
>> task_running_tick().  (Though, in the latter case, maybe we first have
>> to move the scheduler away from assuming HZ rate decrementing of
>> p->time_slice to get this right. i.e. remove the tick based assumption
>> from the scheduler, and then maybe stolen time falls in more naturally
>> when accounting time slices).
> 
> I think the important part is that sched_clock() be used to actually
> compute how much time each process gets.  The fact that a time quantum
> gets stolen is less important.  Or do you mean something else?
> 

How is time quantum getting stolen less important?  Time quantum getting 
stolen results directly in more unnecessary context switches since we 
might steal the entire timeslice before the process even ran.

I actually think #2 and #3 might be more important than #1 (at least 
they are as important).  And, the earlier Xen patches seem to agree with 
this, since they addressed 2 & 3 only.

>> I guess taking your cpufreq as an example of work_time progressing
>> slower than monotonic_time (and assuming that the remaining time is
>> what you would call stolen), then e.g. top would report 50% of your
>> cpu stolen when you cpu is running at 1/2 max rate.
> 
> Yes.  In the same way that clock modulation gates the cpu clock, the
> hypervisor effectively gates the clock by giving time to other vcpus.
> 

Yes, except in one case it was a choice of the kernel, and in the other 
it was up to the hypervisor.

>> And p->time_slice would decrement at 1/2 the rate it normally did when
>> running at 1/2 speed.  Is this the right thing to do?  If so, then I
>> agree it makes sense to model hypervisor stolen time in terms of your
>> "work time".
> 
> Yes, that's my thought.
> 

Since it was the kernel that decided to slow down the processor, I don't 
know if this makes sense.

Dan
