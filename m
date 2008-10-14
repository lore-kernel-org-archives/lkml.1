Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbYJNNZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbYJNNZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 09:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYJNNZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 09:25:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:60752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYJNNZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 09:25:11 -0400
Subject: Re: [RFC PATCH v2 0/5] sched: modular find_busiest_group()
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, arjan <arjan@infradead.org>
In-Reply-To: <20081014130754.GD3995@dirshya.in.ibm.com>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com>
	 <1223561968.7382.42.camel@lappy.programming.kicks-ass.net>
	 <1223986153.9557.4.camel@twins>  <20081014130754.GD3995@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 15:25:03 +0200
Message-Id: <1223990703.9557.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 18:37 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <peterz@infradead.org> [2008-10-14 14:09:13]:
> 
> > 
> > Hi,
> > 
> > So the basic issue is sched_group::cpu_power should become more dynamic.
> 
> Hi Peter,
> 
> This is a good idea.  Dynamically increasing cpu power to some groups
> will automatically help power savings when we want to consolidate
> better to one cpu package when overall system utilisation is very low.  

Ah, yes another use case of this ;-)

> > Dynamic Speed Technology
> > ------------------------
> > 
> > With cpus actively fiddling with their processing capacity we get into
> > similar issues. Again we can measure this, but this would require the
> > addition of a clock that measures work instead of time.
> > 
> > Having that, we can even acturately measure the old SMT case, which has
> > always been approximated by a static percentage - even though the actual
> > gain is very workload dependent.
> > 
> > The idea is to introduce sched_work_clock() so that:
> > 
> >         work_delta / time_delta gives the power for a cpu. <1 means we
> >         did less work than a dedicated pipeline, >1 means we did more.
> 
> The challenge here is measurement of 'work'.  What will be the
> parameter that will be fair for most workloads and easy to measure on
> most systems?
> 
> * Instructions completion count
> * APERF or similar CPU specific counter on x86
> * POWER has PURR and SPURR to have a measure of relative work done  

Right - I was hoping for some feedback from the arch folks (maybe I
should have CC'ed linux-arch) on this issue.

> > So, if for example our core's canonical freq would be 2.0GHz but we get
> > boosted to 2.2GHz while the other core would get lowered to 1.8GHz we
> > can observe and attribute this asymetric power balance.
> > 
> > [ This assumes that the total power is preserved for non-idle situations
> > - is that true?, if not this gets real interesting ]
> 
> I would assume total compute power will be preserved over a long
> period of time.  But certain workloads can benefit more from acceleration
> on the same system challenging the above assumption.

Yes, trouble is that as soon as its not a constant, we get into a
generic optimisation problem, which I'd rather not try to solve in the
CPU scheduler.

> > Also, an SMT thread, when sharing the core with its sibling will get <1,
> > but together they might be >1.
> 
> In this case what is the normalised value of '1'  It is difficult to
> estimate the nominal cpu power with threads.  If we can assume
> normalised value to be theoretical max, then sum of both threads can
> be less than 1 and will never achieve 1 in practice :)

Agreed, getting a normalized value is possibly non-trivial. If we'd look
at things like (avg) cpu-speed over a measured time interval its doable,
but once we start looking at instructions completed and similar things
this might be a little more difficult.

Then again, we could perhaps re-normalize the value such that the avg
value over all cpus ends up being 1 - then again, SMT might ruin this
scheme.

> > Funny corner cases
> > ------------------
> > 
> > Like mentioned in the RT time note, there is the possiblity that a core
> > has 0 power (left) for SCHED_OTHER. This has a consequence for the
> > balance cpu. Currently we let the first cpu in the domain do the
> > balancing, however if that CPU has 0 power it might not be the best
> > choice (esp since part of the balancing can be done from softirq context
> > - which would basically starve that group).
> 
> Agreed, but relative easy to solve compared to other challenges :)

Yes, I just tossed it in to not forget about it ;-)

The thing is, I know I wanted to write about two corner cases, but I've
already forgotten one.. I'm still hoping it will again occur to me :-)

> > Sched domains
> > -------------
> > 
> > There seems to be a use-case where we need both the cache and the
> > package levels. So I wanted to have both levels in there.
> > 
> > Currently each domain level can only be one of:
> > 
> > SD_LV_NONE = 0,
> > SD_LV_SIBLING,
> > SD_LV_MC,
> > SD_LV_CPU,
> > SD_LV_NODE,
> > SD_LV_ALLNODES,
> > 
> > So to avoid a double domain with 'native' multi-core chips where the
> > cache and package level have the same span, I want to encode this
> > information in the sched_domain::flags as bits, which means a level can
> > be both cache and package.
> 
> This will help power savings balance and make the implementation
> clean.  You have suggested this previously also.
> Similarly collapse the NODE level if it is redundant?

Exactly, using a bitmask type systems allows doing that more easily,
because then a domain can be multiple types at once.

We can even consider adding more information like: shared_l1, shared_l2
and shared_l3. So that we have the full cache hierarchy available.

> > Over balancing
> > --------------
> > 
> > Lastly, we might need to introduce SD_OVER_BALANCE, which toggles the
> > over-balance logic. While over-balancing brings better fairness for a
> > number of cases, its also hard on power savings.
> 
> I did not understand this over balance.  Can you please explain.

Ah, lets assume a 2 cpu system.

When presented with 2 tasks of weight 1024 and 1536, this constitues an
infeasible weight distribution.

There is no work-conserving way to schedule those two tasks, such that
their received cpu-time is proportionally fair.

However, when presented with 3 tasks each of weight 1024, this is
statically-infeasible but dynamically-feasible.

That is, there is no static distribution of tasks such that each tasks
receives a proportionally fair share of the cpu-time. However, by
rotating the excess task between the 2 cpus, we can ensure fairness.

In the latter case, we always have an imbalance between runqueues which
is smaller than 1 task.

In this case we can do two things, not schedule in which case we choose
to maintain the static distribution, this is called under-scheduling.

Or we move 1 task despite the fact that we'll tip the imbalance the
other way around, this is called over-scheduling.

As you can see, over-scheduling allows for fairness in more cases, but
at some expense.

A lot of people prefer the added determinism of the extra fairness, but
not everybody. Hence the tunable.

