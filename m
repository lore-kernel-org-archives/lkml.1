Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXCQMCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXCQMCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 08:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXCQMCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 08:02:41 -0400
Received: from mail33.syd.optusnet.com.au ([211.29.132.104]:34102 "EHLO
	mail33.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbXCQMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 08:02:40 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: is RSDL an "unfair" scheduler too?
Date: Sat, 17 Mar 2007 23:02:10 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
In-Reply-To: <20070317114903.GA20673@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172302.10819.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 22:49, Ingo Molnar wrote:
> * Con Kolivas <kernel@kolivas.org> wrote:
> > Despite the claims to the contrary, RSDL does not have _less_
> > heuristics, it does not have _any_. It's purely entitlement based.
>
> RSDL still has heuristics very much, but this time it's hardcoded into
> the design! Let me demonstrate this via a simple experiment.
>
> in the vanilla scheduler, the heuristics are ontop of a fairly basic
> (and fast) scheduler, they are plain visible and thus 'optional'. In
> RSDL, the heuristics are still present but more hidden and more
> engrained into the design.
>
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
>    [ run http://redhat.com/~mingo/scheduler-patches/ring-test.c to
>      create this workload. If the 100 tasks default is too much for you
>      then you can run "./ring-test 10" - that will show similar effects.
>    ]
>
> Workload #1 uses 100% of CPU time. Workload #2 uses 99% of CPU time.
> They both do in essence the same thing.
>
> if RSDL had no heuristics at all then if i mixed #1 with #2, both
> workloads would get roughly 50%/50% of the CPU, right? (as happens if i
> mix #1 with #1 - both CPU-intense workloads get half of the CPU)
>
> in reality, in the 'ring workload' case, RSDL will only give about _5%_
> of CPU time to the #1 CPU-intense task, and will give 95% of CPU time to
> the #2 'ring' of tasks. So the distribution of timeslices is
> significantly unfair!
>
> Why? Because RSDL still has heuristics, just elsewhere and more hidden:
> in the "straightforward CPU intense task" case RSDL will 'penalize' the
> task by depleting its quota for running nearly all the time, in the
> "ring of tasks" case the 100 tasks will each run near their priority
> maximum, fed by 'major epoch' events of RSDL, thus they get 'rewarded'
> for seemingly sleeping alot and spreading things out. So RSDL has
> fundamental unfairness built in as well - it's just different from the
> vanilla scheduler.

We're obviously disagreeing on what heuristics are so call it what you like.

You're simply cashing in on the deep pipes that do kernel work for other 
tasks. You know very well that I dropped the TASK_NONINTERACTIVE flag from 
rsdl which checks that tasks are waiting on pipes and you're exploiting it. 
That's not the RSDL heuristics at work at all, but you're trying to make it 
look like it is the intrinsic RSDL system at work. Putting that flag back in 
is simple enough when I'm not drugged. You could have simply pointed that out 
instead of trying to make my code look responsible. 

For the moment I'll assume you're not simply trying to make my code look bad 
and that you thought there really was an intrinsic design problem, otherwise 
I'd really be unhappy with what was happening to me.

-- 
-ck
