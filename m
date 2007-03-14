Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbXCNAnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbXCNAnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 20:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXCNAnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 20:43:04 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37066 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbXCNAnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 20:43:03 -0400
Message-ID: <45F74515.7010808@vmware.com>
Date: Tue, 13 Mar 2007 17:43:01 -0700
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org>
In-Reply-To: <45F71EA5.2090203@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2007 00:42:59.0015 (UTC) FILETIME=[B6A47570:01C765D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2007 02:59 PM, Jeremy Fitzhardinge wrote:
> Daniel Walker wrote:
>> The frequency tracking you mention is done to some extent inside the
>> timekeeping adjustment functions, but I'm not sure it's totally accurate
>> for non-timekeeping, and it also tracks things like interrupt latency.
>> Tracking frequency changes where it's important to get it right
>> shouldn't be done I think ..
>>
>> If you want accurate time accounting, don't use the TSC .
>>   
> 
> I'm not sure I follow you here.  Clocksources have the means to adjust
> the rate of time progression, mostly to warp the time for things like
> ntp.  The stability or otherwise of the tsc is irrelevant.
> 
> If you had a clocksource which was explicitly using the rate at which a
> CPU does work as a timebase, then using the same warping mechanism would
> allow you to model CPU speed changes.
> 
>> The sched_clock interface is basically a stripped down clocksource..
>> I've implemented sched_clock as a clocksource in the past ..
>>   
> 
> Yes, that works.  But a clocksource is strictly about measuring the
> progression of real time, and so doesn't generally measure how much work
> a CPU has done.
> 
>>> We currently have a sched_clock interface in paravirt_ops to deal with
>>> the hypervisor aspect.  It only occurred to me this morning that cpufreq
>>> presents exactly the same problem to the rest of the kernel, and so
>>> there's room for a more general solution.
>>>     
>> Are there other architecture which have this per-cpu clock frequency
>> changing issue? I worked with several other architectures beyond just
>> x86 and haven't seen this issue ..
> 
> Well, lots of cpus have dynamic frequencies.  Any scheduler which
> maintains history will suffer the same problem, even on UP.  If
> processes A and B are supposed to have the same priority and they both
> execute for 1ms of real time, did they make the same amount of
> progress?  Not if the cpu changed speed in between.
> 
> And any system which commonly runs virtualized (s390, power, etc) will
> need to deal with the notion of stolen time.
> 

With your previous definition of work time, would it be that:

monotonic_time == work_time + stolen_time ??

i.e. would you be defining stolen_time to include the time lost to 
processes due to the cpu running at a lower frequency?  How does this 
play into the other potential users, besides sched_clock(), of stolen 
time?  We should make sure that the abstraction introduced here makes 
sense in those places too.

For example, the stuff that happens in update_process_times().  I think 
we'd want to account the stolen time to cpustat->steal.  Also we'd 
probably want account for stolen time with regards to 
task_running_tick().  (Though, in the latter case, maybe we first have 
to move the scheduler away from assuming HZ rate decrementing of 
p->time_slice to get this right. i.e. remove the tick based assumption 
from the scheduler, and then maybe stolen time falls in more naturally 
when accounting time slices).

I guess taking your cpufreq as an example of work_time progressing 
slower than monotonic_time (and assuming that the remaining time is what 
you would call stolen), then e.g. top would report 50% of your cpu 
stolen when you cpu is running at 1/2 max rate.  And p->time_slice would 
decrement at 1/2 the rate it normally did when running at 1/2 speed.  Is 
this the right thing to do?  If so, then I agree it makes sense to model 
hypervisor stolen time in terms of your "work time".  But, if not, then 
maybe the amount of work you can get done during a period of time that 
is not stolen and the stolen time itself are really two different 
notions, and shouldn't be confused.  I can see arguments both ways.

Dan
