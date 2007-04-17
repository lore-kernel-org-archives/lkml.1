Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbXDQNoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbXDQNoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbXDQNoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:44:37 -0400
Received: from omta03sl.mx.bigpond.com ([144.140.92.155]:22829 "EHLO
	omta03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbXDQNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:44:36 -0400
Message-ID: <4624CF3B.6040704@bigpond.net.au>
Date: Tue, 17 Apr 2007 23:44:27 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net> <20070417041420.GF25513@wotan.suse.de> <20070417095140.GB22626@elte.hu>
In-Reply-To: <20070417095140.GB22626@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta03sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 13:44:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nick Piggin <npiggin@suse.de> wrote:
> 
>>>> Maybe the progress is that more key people are becoming open to 
>>>> the idea of changing the scheduler.
>>> Could be.  All was quiet for quite a while, but when RSDL showed up, 
>>> it aroused enough interest to show that scheduling woes is on folks 
>>> radar.
>> Well I know people have had woes with the scheduler for ever (I guess 
>> that isn't going to change :P). [...]
> 
> yes, that part isnt going to change, because the CPU is a _scarce 
> resource_ that is perhaps the most frequently overcommitted physical 
> computer resource in existence, and because the kernel does not (yet) 
> track eye movements of humans to figure out which tasks are more 
> important them. So critical human constraints are unknown to the 
> scheduler and thus complaints will always come.
> 
> The upstream scheduler thought it had enough information: the sleep 
> average. So now the attempt is to go back and _simplify_ the scheduler 
> and remove that information, and concentrate on getting fairness 
> precisely right. The magic thing about 'fairness' is that it's a pretty 
> good default policy if we decide that we simply have not enough 
> information to do an intelligent choice.
> 
> ( Lets be cautious though: the jury is still out whether people actually 
>   like this more than the current approach. While CFS feedback looks 
>   promising after a whopping 3 days of it being released [ ;-) ], the 
>   test coverage of all 'fairness centric' schedulers, even considering 
>   years of availability is less than 1% i'm afraid, and that < 1% was 
>   mostly self-selecting. )

At this point I'd like to make the observation that spa_ebs is a very 
fair scheduler if you consider "nice" to be an indication of the 
relative entitlement of tasks to CPU bandwidth.

It works by mapping nice to shares using a function very similar to the 
one for calculating p->load weight except it's not offset by the RT 
priorities as RT is handled separately.  In theory, a runnable task's 
entitlement to CPU bandwidth at any time is the ratio of its shares to 
the total shares held by runnable tasks on the same CPU (in reality, a 
smoothed average of this sum is used to make scheduling smoother).  The 
dynamic priorities of the runnable tasks are then fiddled to try to keep 
each tasks CPU bandwidth usage in proportion to its entitlement.

That's the theory anyway.

The actual implementation looks a bit different due to efficiency 
considerations.  The modifications to the above theory boil down to 
keeping a running measure of the (recent) highest CPU bandwidth use per 
share for tasks running on the CPU -- I call this the yardstick for this 
CPU.  When it's time to put a task on the run queue it's dynamic 
priority is determined by comparing its CPU bandwidth per share value 
with the yardstick for its CPU.  If it's greater than the yardstick this 
value becomes the new yardstick and the task gets given the lowest 
possible dynamic priority (for its scheduling class).  If the value is 
zero it gets the highest possible priority (for its scheduling class) 
which would be MAX_RT_PRIO for a SCHED_OTHER task.  Otherwise it gets 
given a priority between these two extremes proportional to ratio of its 
CPU bandwidth per share value and the yardstick.  Quite simple really.

The other way in which the code deviates from the original as that (for 
a few years now) I no longer calculated CPU bandwidth usage directly. 
I've found that the overhead is less if I keep a running average of the 
size of a tasks CPU bursts and the length of its scheduling cycle (i.e. 
from on CPU one time to on CPU next time) and using the ratio of these 
values as a measure of bandwidth usage.

Anyway it works and gives very predictable allocations of CPU bandwidth 
based on nice.

Another good feature is that (in this pure form) it's starvation free. 
However, if you fiddle with it and do things like giving bonus priority 
boosts to interactive tasks it becomes susceptible to starvation.  This 
can be fixed by using an anti starvation mechanism such as SPA's 
promotion scheme and that's what spa_ebs does.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
