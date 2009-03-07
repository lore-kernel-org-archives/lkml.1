Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZCGB06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZCGB06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 20:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZCGB0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 20:26:49 -0500
Received: from gw.goop.org ([64.81.55.164]:43392 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbZCGB0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 20:26:48 -0500
Message-ID: <49B1CD54.8070805@goop.org>
Date: Fri, 06 Mar 2009 17:26:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Process accounting in interrupt diabled cases
References: <1236380615.4637.67.camel@alok-dev1> <49B1C1D1.4070603@goop.org> <1236387583.4558.22.camel@alok-dev1>
In-Reply-To: <1236387583.4558.22.camel@alok-dev1>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> I don't know if their are instances when interrupts are actually
> disabled for such a long time in the kernel , but I don't see a reason
> why this might not be happening currently, i.e. do we have a way to
> detect such cases. 
> I noticed this problem ( with process accounting) only when testing my
> stolen time theory below, in which i had intentionally disabled
> interrupts for long. 
>
> So, in case of buggy code which disables interrupt for long, this could
> affect process accounting and could result in the stolen time being
> reported incorrectly ( considering the stolen time idea mentioned below
> is okay).
>   

Does it matter how long interrupts are actually disabled.  Tickless is 
definitely the preferred mode of operation for any virtual guest, so 
time accounting is independent from when the actual timer interrupts 
occur; its quite possible we'll see no interrupts for a long time 
indeed.  If we accrue unstolen time to a task when we actually context 
switch then the accounting will all work out, no?

>>> I stumbled across this while trying to find a solution to figure out the
>>> amount of stolen time from Linux, when it is running under a hypervisor.
>>> One of the solutions could be to ask the hypervisor directly for this
>>> info, but in my quest to find a generic solution I think the below would
>>> work too.
>>> The total process time accounted by the system on a cpu ( system, idle,
>>> wait and etc) when deducted from the amount TSC counter has advanced
>>> since boot, should give us this info about the cputime stolen from the
>>> kernel
>>>       
>> You're assuming that the tsc is always going to be advancing at a 
>> constant rate in wallclock time?  Is that a good assumption?  Does 
>> VMWare virtualize the tsc to make this valid?  If something's going to 
>> the effort of virtualizing tsc, how do you know they're not also 
>> excluding stolen time?
>>     
>
>
> Yes, TSC is the correct thing atleast for VMware over here. But my idea
> is not to advocate using TSC here, if it doesn't work for Xen we could
> use something else which gives a notion of Total_time there, a parvirt
> call to read that can be done. I don't know what that would be for XEN,
> but you would know better, please suggest if there is already a paravirt
> call which gets that value for XEN ? 
>   

Yes, Xen already accounts stolen time in its timer interrupt handler.

But more significantly it uses unstolen time as the timebase for 
sched_clock() so that the scheduler will only credit a task for the 
actual amount of time it spends executing, rather than a full wallclock 
timeslice.

>> What timebase is the kernel using to measure idle, system, wait, ...?  
>> Presumably something that doesn't include stolen time.  In that case 
>> this just comes down to "PCPU_STOLEN = TOTAL_TIME - PCPU_UNSTOLEN_TIME", 
>> where you're proposing that TOTAL_TIME is the tsc.
>>     
>
> Again not proposing to use tsc, please suggest what works for Xen. 
> And about the PCU_UNSTOLEN_TIME, i am proposing it could be a summation
> of all the fields in kstat_cpu.cpustat except the steal value.
>   

No, I'm not advocating anything in particular; I'm trying to understand 
your proposal.

You're positing two timebases: one which measures wallclock time (that 
could be the tsc in VMWare's case), and another which measures unstolen 
time, so you can tell how long a cpu has spent actually running 
something.  What's your proposal for the unstolen clock?  How does the 
kernel measure unstolen time?  It can't measure it with the tsc, because 
that would include any stolen time in the measurement.

Also, I'm not sure it makes sense to distinguish between vcpu idle time 
and stolen time.  If a vcpu is idle/blocked, how can you steal time from 
it?  It's only stolen time if it wants to run but can't.

>> Direct use of the tsc definitely doesn't work in a Xen PV guest because 
>> the tsc is the raw physical cpu tsc; but Xen also provides everything 
>> you need to derive a globally-meaningful timebase from the tsc.  Xen 
>> also provides per-vcpu info on time spent blocked, runnable (ie, could 
>> run but no pcpu available), running and offline.
>>
>>     
> That means it should be easy to get the TOTAL_Time value then ? 
>   

Yes, Xen exposes all the necessary accounting information directly.  It 
also guarantees that if you add up blocked+runnable+running+offline == 
wallclock time.

See xen/time.c: do_stolen_accounting(), and how it accumulates stolen 
time with account_steal_ticks().

    J
