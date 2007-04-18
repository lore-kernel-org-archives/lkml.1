Return-Path: <linux-kernel-owner+w=401wt.eu-S1422977AbXDRMuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422977AbXDRMuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422978AbXDRMuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:50:55 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:48622 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422977AbXDRMuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:50:54 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Wed, 18 Apr 2007 22:49:45 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
References: <20070413202100.GA9957@elte.hu> <20070418095334.GA26525@elte.hu> <20070418121304.GA878@wotan.suse.de>
In-Reply-To: <20070418121304.GA878@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704182249.46200.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2007 22:13, Nick Piggin wrote:
> On Wed, Apr 18, 2007 at 11:53:34AM +0200, Ingo Molnar wrote:
> > * Nick Piggin <npiggin@suse.de> wrote:
> > > So looking at elapsed time, a granularity of 100ms is just behind the
> > > mainline score. However it is using slightly less user time and
> > > slightly more idle time, which indicates that balancing might have got
> > > a bit less aggressive.
> > >
> > > But anyway, it conclusively shows the efficiency impact of such tiny
> > > timeslices.
> >
> > yeah, the 4% drop in a CPU-cache-sensitive workload like kernbench is
> > not unexpected when going to really frequent preemption. Clearly, the
> > default preemption granularity needs to be tuned up.
> >
> > I think you said you measured ~3msec average preemption rate per CPU?
>
> This was just looking at ctxsw numbers from running 2 cpu hogs on the
> same runqueue.
>
> > That would suggest the average cache-trashing cost was 120 usecs per
> > every 3 msec window. Taking that as a ballpark figure, to get the
> > difference back into the noise range we'd have to either use ~5 msec:
> >
> >     echo 5000000 > /proc/sys/kernel/sched_granularity
> >
> > or 15 msec:
> >
> >     echo 15000000 > /proc/sys/kernel/sched_granularity
> >
> > (depending on whether it's 5x 3msec or 5x 1msec - i'm still not sure i
> > correctly understood your 3msec value. I'd have to know your kernbench
> > workload's approximate 'steady state' context-switch rate to do a more
> > accurate calculation.)
>
> The kernel compile (make -j8 on 4 thread system) is doing 1800 total
> context switches per second (450/s per runqueue) for cfs, and 670
> for mainline. Going up to 20ms granularity for cfs brings the context
> switch numbers similar, but user time is still a % or so higher. I'd
> be more worried about compute heavy threads which naturally don't do
> much context switching.

While kernel compiles are nice and easy to do I've seen enough criticism of 
them in the past to wonder about their usefulness as a standard benchmark on 
their own.

>
> Some other numbers on the same system
> Hackbench:	2.6.21-rc7	cfs-v2 1ms[*]	nicksched
> 10 groups: Time: 1.332		0.743		0.607
> 20 groups: Time: 1.197		1.100		1.241
> 30 groups: Time: 1.754		2.376		1.834
> 40 groups: Time: 3.451		2.227		2.503
> 50 groups: Time: 3.726		3.399		3.220
> 60 groups: Time: 3.548		4.567		3.668
> 70 groups: Time: 4.206		4.905		4.314
> 80 groups: Time: 4.551		6.324		4.879
> 90 groups: Time: 7.904		6.962		5.335
> 100 groups: Time: 7.293		7.799		5.857
> 110 groups: Time: 10.595	8.728		6.517
> 120 groups: Time: 7.543		9.304		7.082
> 130 groups: Time: 8.269		10.639		8.007
> 140 groups: Time: 11.867	8.250		8.302
> 150 groups: Time: 14.852	8.656		8.662
> 160 groups: Time: 9.648		9.313		9.541

Hackbench even more so. A prolonged discussion with Rusty Russell on this 
issue he suggested hackbench was more a pass/fail benchmark to ensure there 
was no starvation scenario that never ended, and very little value should be 
placed on the actual results returned from it.

Wli's concerns regarding some sort of standard framework for a battery of 
accepted meaningful benchmarks comes to mind as important rather than ones 
that highlight one over the other. So while interesting for their own 
endpoints, I certainly wouldn't put either benchmark as some sort of 
yardstick for a "winner". Note I'm not saying that we shouldn't be looking at 
them per se, but since the whole drive for a new scheduler is trying to be 
more objective we need to start expanding the range of benchmarks. Even 
though I don't feel the need to have SD in the "race" I guess it stands for 
more data to compare what is possible/where as well.

> Mainline seems pretty inconsistent here.
>
> lmbench 0K ctxsw latency bound to CPU0:
> tasks
> 2		2.59		3.42		2.50
> 4		3.26		3.54		3.09
> 8		3.01		3.64		3.22
> 16		3.00		3.66		3.50
> 32		2.99		3.70		3.49
> 64		3.09		4.17		3.50
> 128		4.80		5.58		4.74
> 256		5.79		6.37		5.76
>
> cfs is noticably disadvantaged.
>
> [*] 500ms didn't make much difference in either test.

-- 
-ck
