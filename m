Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbXEJTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbXEJTz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXEJTzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:55:22 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:37453 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXEJTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:55:20 -0400
Message-ID: <4643788D.8040205@cs.umass.edu>
Date: Thu, 10 May 2007 15:54:53 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, tong.n.li@intel.com
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
References: <20070508150431.GA26977@elte.hu> <20070509180205.GA27462@in.ibm.com>
In-Reply-To: <20070509180205.GA27462@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Srivatsa

    I would say in this case, your specifications of these tasks do not 
actually give a base for evaluating the fairness. Imagine, when you want 
to check if the generated schedule is _fair_ or not, you first have set 
up a base which indicates the behavior tasks should have, and then 
compare the generated schedule against the "should" case for fairness. 
In fact, the results you get (in the following) all make perfect sense, 
based on the "should" defined by each different model adopted by 
different schedulers.

    Now I will try to explain all these in my creepy English:
> Ex: consider two equally important tasks T1 and T2 running on same CPU and 
> whose execution nature is:
>
> 	T1 = 100% cpu hog
> 	T2 = 60% cpu hog (run for 600ms, sleep for 400ms)
>   
First, these specification does not give any idea of the amount real 
work should be done by each task during any time period. Now suppose you 
have 4 T1 running, what do you expect, in 10 sec, each task should 
consume: 2.5 sec. Hmmm, what if one of them is processing something I 
need to be 3 time faster than others? then your expectation will be 5, 
5/3, 5/3, 5/3. Now what if the 3x faster process is not actually 
"important" than others?
The same thing happens to T2, which is a little more complicated. When 
T2 is active and at the same time there are other tasks running, what is 
the amount work it should be done during its active period? and then 
when T2 is sleeping, how does it affects other tasks still running, 
especially when T2 goes back active again? Should scheduler remembers 
the history to be long term "fair", or it should forget about the history?

All these questions require a complete model (different approaches uses 
different models), and there are 3 critical things needed for each task 
in the system, which currently more or less entangled together in all 
existing schedulers.

For each task you need:
               _B_ (CPU bandwidth), _T_ (response window), _P_ (priority 
or importance)

Here, B is the amount of bandwidth needed, and T is the time period that 
B must be ensured. For example, if a task need 20ms to process a 
request, and the request has to be processed within 50ms, then B is 40% 
and T is 50ms. B captures the throughput need of the task, while T 
captures its response requirement. For the above task, if you give (50%, 
100ms), then some requests of that task may miss their deadlines, even 
though throughput is guaranteed.  The combination (B, T) describes the 
requirement of a task to run at least "good" enough, however, it not 
necessarily related to the task's importance, therefore P is needed, so 
that scheduler can make choices when CPU is overload, specifically sum 
of Bs goes beyond CPU capacity.

In the Real-Time work, we have pretty good knowledge about a task's 
requirement (B,T), therefore usually strict admission control or 
bandwidth control is applied to ensure admitted tasks are always 
satisfied. When CPU overload does happen, either B or T serves as static 
priorities, such as Rate monotonic, or dynamic priorities are 
calculated, such as EDF (earliest deadline first). Various strategies 
based on capacity reservation and bandwidth reservation are proposed (in 
late 80's and mid 90's) to enforce protection between tasks when 
workload in the system fluctuates.

However, on a general purpose machine, everything is dynamic. We do not 
have any knowledge about (B, T) for any task. Tens of daemons, kernel 
threads wake up at arbitrary intervals with arbitrary amount of work. 
each may or may not have a specific response deadline, and deadlines may 
be soft or hard, etc. The required pre-knowledge and the scalability 
issue make capacity/bandwidth reservation based approaches not suitable 
for a general purpose scheduler.

The solution here used is to dynamically figure out the (B, T) based on 
the workload in the system (so that the sum(Bi) never goes beyond the 
CPU capacity), which leads to either _Fair Share_ scheduling or 
_Proportional Share_ scheduling (the distinction between them is vague 
though), which uses different model for fairness as I will explain later.

In Linux, we have only one parameter for each task, that is _NICE_ 
value, which has to serve the purpose of giving (B, T, P). Usually small 
nice value indicates higher priority, higher bandwidth (larger time 
quanta), and may or may not say anything about T. Now let's see how 
_Fair share_ model affects vanilla scheduler, and how _Proportional 
share_ model affects CFS and RSDL/SD scheduler. (Note: the specification 
you give above only indicate when task is runnable, and does not give 
information about (B, T))

> 2.6.21.1:
>
>  5444 vatsa     16   0  2468  460  388 R   59  0.0   0:19.76 3 T1
>  5443 vatsa     25   0  2468  460  388 R   40  0.0   0:15.36 3 T2
>
>   
The _Fair Share_ (FS) model which vanilla scheduler adopts, says give a 
long enough time window, the amount work done by each task should be 
proportional to its weight (which comes from the nice value). Therefore 
B_i of each task is given by w_i/sum(w), and in your case 50%:50% for T1 
and T2, but it says _nothing_ about T_i for each task.

Therefore, Fair Share model is inherently problematic! Imagine, If T1 is 
100% cpuhog, and T2 works like this: work 10ms, sleep 90ms, work 10ms, 
sleep 90ms, ... , work 10ms, sleep 90ms, work constantly (100% cpuhog).  
When T2  enters  its last stage and becomes 100% cpuhog, it will starve 
T1 for arbitrarily amount of time in FS model (depends on how long it 
executes before). The problem here is FS remembers arbitrarily long past 
history and tries to compensate in the future, and this leads to 
starvation, long latency, and weird interactive problems.

Vanilla scheduler approximates the FS model by calculating dynamic 
priorities based on execution time and sleep time _heuristically_. It 
also tries to solve the above problem by: (1) dividing long quanta into 
smaller timeslices (2) only remember limited amount of history, that is 
why it has a upperbound on sleep time for each task, which is used for 
calculating goodness.

Overall, this kind of scheduler is heuristic oriented, targeted to long 
tern fairness with low accuracy, and provides almost not guarantee for 
throughput and response time. Therefore people are constantly looking 
for better ones.

> 2.6.21.1 + cfs-v11:
>
>  5460 vatsa     31   0  2464  460  388 R   70  0.0   0:15.28 3 T1
>  5461 vatsa     29   0  2468  460  388 R   30  0.0   0:05.65 3 T2
>
>
> 2.6.21 + sd-0.48:
>
>  5459 vatsa     23   0  2468  460  388 R   70  0.0   0:17.02 3 T1
>  5460 vatsa     21   0  2464  460  388 R   30  0.0   0:06.21 3 T2
Both CFS and RSDL/SD uses Proportional Share (PS). It was originally 
designed for packet transmission where response time is relatively 
important. It was based on an ideal fluid-flow model called GPS. GPS 
model says, any _active_ task should receive the cpu bandwidth 
proportional to its weight. The only difference between PS and FS above 
is that when deciding B for a task, PS only takes _active_ tasks into 
account, while FS takes all tasks. In other words: PS forgets about 
history and sleep time (different from the time a task stay in run 
queue:-)) does not affect future scheduling. In this way, it can 
implicitly provides upperbounds for T for each active task (the accurate 
bound depends on algorithms and implementations), which is usually 
measured as the difference between actual work done against the work 
should be done in ideal GPS model. For example, here CFS and SD give 
bound of  delay O(n), where n is the number of active tasks.

In your example: When T2 is active, it gets B_2 = w_i/sum(w), 50% share, 
and nothing during it sleeps. Therefor the share overtime is:
              T1: 400 * 100% (share) + 600 * 50% (share) = 700
              T2: 400 * 0% (share) + 600 * 50% (share) = 300
Which is exactly the CPU share given in your above results for both CFS 
and SD!

Overall, proportional share scheduler, such as CFS and RSDL (other 
similar ones worth mentioning: WFQ, WF2Q, SCFQ, SFQ, SFS, EEVDF all 
based on fair queuing approximates GPS), is more accurate, provides 
short term fairness, and gives controlled bound for throughput and 
latency. However, all these come with a cost. These schedulers are more 
difficult to implement,  complicated data structures, may take O(n) or 
O(log n) time for each operation,  need more frequent context switches, 
etc.

Given the fluctuation of workloads, various application behaviors, 
uncertainty of user intentions, etc, it is almost impossible to set up a 
model that captures all of them. Therefore, building a good general 
purpose scheduler is so difficult and many people like Ingo, Con, ... 
are working so hard on it :-)

Sorry for another long email.

Ting

