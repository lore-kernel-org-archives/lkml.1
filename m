Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbXCQVBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbXCQVBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 17:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCQVBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 17:01:33 -0400
Received: from mtaout5.012.net.il ([84.95.2.13]:59954 "EHLO mtaout5.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbXCQVBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 17:01:32 -0400
Date: Sat, 17 Mar 2007 22:41:01 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: is RSDL an "unfair" scheduler too?
In-reply-to: <20070317114903.GA20673@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <45FC525D.5000708@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sat,
 17 Mar 2007 22:41:02 +0200 (IST)
References: <200703042335.26785.a1426z@gawab.com>
 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
 <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
>
>   
>> Despite the claims to the contrary, RSDL does not have _less_ 
>> heuristics, it does not have _any_. It's purely entitlement based.
>>     
>
> RSDL still has heuristics very much, but this time it's hardcoded into 
> the design! Let me demonstrate this via a simple experiment.
>
>
>   
[...]

> But it's easy to demonstrate this under RSDL: consider the following two 
> scenarios, which implement precisely the same fundamental computing 
> workload (everything running on the same, default nice 0 level):
>
> 1) a single task runs almost all the time and sleeps about 1 msec every
>    100 msecs.
>
>    [ run "while N=1; do N=1; done &" under bash to create such a 
>      workload. ]
>
> 2) tasks are in a 'ring' where each runs for 100 msec, sleeps for 1
>    msec and passes the 'token' around to the next task in the ring. (in
>    essence every task will sleep 9900 msecs before getting another run)
>
>
> Workload #1 uses 100% of CPU time. Workload #2 uses 99% of CPU time. 
> They both do in essence the same thing.
>
> if RSDL had no heuristics at all then if i mixed #1 with #2, both 
> workloads would get roughly 50%/50% of the CPU, right? (as happens if i 
> mix #1 with #1 - both CPU-intense workloads get half of the CPU)
>   

Well, the heuristic here is that process == job.  I'm not sure heuristic 
is the right name for it, but it does point out a deficieny.

A cpu-bound process with many threads will overwhelm a cpu-bound single 
threaded threaded process.

A job with many processes will overwhelm a job with a single process.

A user with many jobs can starve a user with a single job.

I don't think the problem here is heuristics, rather that the 
scheduler's manages cpu quotas at the task level rather than at the user 
visible level.  If scheduling were managed at all three hierarchies I 
mentioned ('job' is a bit artificial, but process and user are not) then:

- if N users are contending for the cpu on a multiuser machine, each 
should get just 1/N of available cpu power.  As it is, a user can run a 
few of your #1 workloads (or a make -j 20) and slow every other user down
- your example would work perfectly (if we can communicate to the kernel 
what a job is)
- multi-threaded processes would not get an unfair advantage

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

