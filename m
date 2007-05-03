Return-Path: <linux-kernel-owner+w=401wt.eu-S1162114AbXECPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162114AbXECPCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162115AbXECPCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:02:44 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:63046 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162114AbXECPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:02:42 -0400
Message-ID: <4639F985.4070306@cs.umass.edu>
Date: Thu, 03 May 2007 11:02:29 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070503085015.GA20516@elte.hu>
In-Reply-To: <20070503085015.GA20516@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Ting Yang <tingy@cs.umass.edu> wrote:
>
>   
>> Authors of this paper proposed a scheduler: Earlist Eligible Virtual 
>> Deadline First (EEVDF). EEVDF uses exactly the same method as CFS to 
>> track the execution of each running task. The only difference between 
>> EEVDF and CFS is that EEVDF tries to _deadline_ fair while CFS is 
>> _start-time_ fair. [...]
>>     
>
> Well, this is a difference but note that it's far from being the 'only 
> difference' between CFS and EEVDF:
>
>   
I re-ordered comments a little bit to make my discussion easier:
> - in CFS you have to "earn" your right to be on the CPU, while EEVDF 
>   gives out timeslices (quanta)
>
> - thus in CFS there's no concept of "deadline" either (the 'D' from 
>   EEVDF).
>   
These two are needed to implement the deadline fair policy, therefore 
are cover in the difference I mentioned. Due to the way that authors 
using different terms, the paper may leads to certain confusion, here 3 
important concepts needed:
     - the scheduling quanta *q* in the paper: it refers to the minimum 
unit that a scheduler can
       schedules tasks. For system ticks 1000 per second, q is 1ms. For 
system ticks 100 per second
       (old linux), q is 10ms.
     - the length of a request submitted by a task: it refers to the 
amount of work needed to process a
        request. EEVDF _does_ not need this information for scheduling 
at all.
     - the timesliced used to process requests, which denoted as *r* in 
the paper: it refers to the unit that
       scheduler uses to process a request.  If the length of a request 
is larger than timeslice r, the request is
       effectively divided into pieces of length r. 

The scheduler can use a suitable timeslice at will to handle a process. 
Using the timeslice, it can estimate the deadline based on the weight of 
a task, which tells how urgent the task is. and therefore remove the 
potential O(n). (but it comes with a cost: more context switches)
> - EEVDF concentrates on real-time (SCHED_RR-alike) workloads where they
>   know the length of work units 
That is _not_ really the case, although authors of this paper used a 
quite aggressive title and reclaimed so.
Look carefully at the Theorem 3 and its Corollary on pg 16, it says
    If not request of client k is larger than a time quanta, then at any 
time t the lag is bounded by
                    -q < lag_k(t) < q
    It gives three facts:
    1. For the system to be hard real-time, the length of request (note, 
not the quanta q, timeslice r)
        of any task at any time, must be less than the quanta of 
schedule, which in modern Linux is 1ms.
        This make EEVDF effectively useless for hard real-time system, 
where application can not miss
        deadline
    2. For the system to be soft real-time:  EEVDF needs to first fixed 
the bandwidth of a task, so that
        it does not varies when tasks join and leave. Then EEVDF can 
give a soft real-time guarantee with
        bounded delay of max(timeslice r). Authors mentioned this, but 
unfortunately this feature was
        never actually implemented.
    3. EEVDF does gives a proportional time-share system that any task 
running on it will has not delay
        longer than max(timeslice t) w.r.t the ideal fluid-flow system.

Authors of this paper only developed framework that can possibly used by 
real-time system (either hard or soft), their main attempt was to glue 
real-time and proportional time-share together. I think the real-time 
part of this paper does not actually ring the bell to me. However, isn't 
the fact 3 listed above really what we needed ?
> - while CFS does not need any knowledge
>   about 'future work', it measures 'past behavior' and makes its
>   decisions based on that. So CFS is purely 'history-based'.
>   
As I explained about, EEVDF does not need any future knowledge, instead 
it uses a unit (timeslice) to process request from tasks, by predicting 
the deadline of when this unit has to be finished.

There is a firm theoretic base behind this "guess":, which did not 
appear in the paper: as long as the total bandwidth needed by all active 
tasks does not exceeds the bandwidth of CPU, the predicted virtual 
deadline vt, if mapped back to real time t in system, then that t is 
exactly the deadline for the chosen unit in the ideal system. Since 
EEVDF is proportionally share, the bandwidth for each task is scaled 
based on the weight, the sum of them does not exceeds cpu capacity. 
Therefore the "guess" of EEVDF is always right :-)

Predicting future taking weight into account, makes it choose better 
tasks to execute. Smaller timeslice make it stick to the ideal system 
closer in the cost of more context switches.
> - EEVDF seems to be calculating timeslices in units of milliseconds, 
>   while CFS follows a very strict 'precise' accounting scheme on the 
>   nanoseconds scale.
>   
This is just an implementation issue, right? It is possible to implement 
EEVDF in finer granularity.
> - the EEVDF paper is also silent on SMP issues.
>   
Yes, you are right. I do not have much knowledge about load balancing
> - it seems EEVDF never existed as a kernel scheduler, it was a
>   user-space prototype under FreeBSD with simulated workloads. (have
>   they released that code at all?).
>   
They never released the code, (quite typical behavior of system 
researchers :-)), and that is why I asked if it worth a try.
> The main common ground seems to be that both CFS and EEVDF share the 
> view that the central metric is 'virtual time' proportional to the load 
> of the CPU (called the 'fair clock' in CFS) - but even for this the 
> details of the actual mechanism differ: EEVDF uses 1/N while CFS (since 
> -v8) uses a precise, smoothed and weighted load average that is close to 
> (and reuses portions of) Peter Williams's load metric used in smp-nice. 
>
>   
Thanks a lot for giving your opinions, very nice discussing with you.

Ting
