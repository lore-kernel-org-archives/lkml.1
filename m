Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbXCQLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbXCQLtU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCQLtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 07:49:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbXCQLtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 07:49:18 -0400
Date: Sat, 17 Mar 2007 12:49:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070317114903.GA20673@elte.hu>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703172048.46267.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Con Kolivas <kernel@kolivas.org> wrote:

> Despite the claims to the contrary, RSDL does not have _less_ 
> heuristics, it does not have _any_. It's purely entitlement based.

RSDL still has heuristics very much, but this time it's hardcoded into 
the design! Let me demonstrate this via a simple experiment.

in the vanilla scheduler, the heuristics are ontop of a fairly basic 
(and fast) scheduler, they are plain visible and thus 'optional'. In 
RSDL, the heuristics are still present but more hidden and more 
engrained into the design.

But it's easy to demonstrate this under RSDL: consider the following two 
scenarios, which implement precisely the same fundamental computing 
workload (everything running on the same, default nice 0 level):

1) a single task runs almost all the time and sleeps about 1 msec every
   100 msecs.

   [ run "while N=1; do N=1; done &" under bash to create such a 
     workload. ]

2) tasks are in a 'ring' where each runs for 100 msec, sleeps for 1
   msec and passes the 'token' around to the next task in the ring. (in
   essence every task will sleep 9900 msecs before getting another run)

   [ run http://redhat.com/~mingo/scheduler-patches/ring-test.c to
     create this workload. If the 100 tasks default is too much for you 
     then you can run "./ring-test 10" - that will show similar effects. 
   ]

Workload #1 uses 100% of CPU time. Workload #2 uses 99% of CPU time. 
They both do in essence the same thing.

if RSDL had no heuristics at all then if i mixed #1 with #2, both 
workloads would get roughly 50%/50% of the CPU, right? (as happens if i 
mix #1 with #1 - both CPU-intense workloads get half of the CPU)

in reality, in the 'ring workload' case, RSDL will only give about _5%_ 
of CPU time to the #1 CPU-intense task, and will give 95% of CPU time to 
the #2 'ring' of tasks. So the distribution of timeslices is 
significantly unfair!

Why? Because RSDL still has heuristics, just elsewhere and more hidden: 
in the "straightforward CPU intense task" case RSDL will 'penalize' the 
task by depleting its quota for running nearly all the time, in the 
"ring of tasks" case the 100 tasks will each run near their priority 
maximum, fed by 'major epoch' events of RSDL, thus they get 'rewarded' 
for seemingly sleeping alot and spreading things out. So RSDL has 
fundamental unfairness built in as well - it's just different from the 
vanilla scheduler.

	Ingo
