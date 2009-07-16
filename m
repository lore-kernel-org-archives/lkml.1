Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZGPI6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZGPI6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZGPI6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:58:34 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:17546 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZGPI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:58:32 -0400
X-SourceIP: 213.93.53.227
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <20090715231646.GI14993@cs.fsu.edu>
References: <4A5B61DF.8090101@nortel.com>
	 <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
	 <20090715223400.GF14993@cs.fsu.edu>
	 <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
	 <20090715231646.GI14993@cs.fsu.edu>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 10:58:41 +0200
Message-Id: <1247734722.15471.83.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 19:16 -0400, Ted Baker wrote:
> > > 1) The priority of a group seemed to be defined by the priority of
> > > the highest-priority thread in the group's run-queue, which means
> > > it varies dynamically according to which threads in the group are
> > > contending.
> > >
> > 
> > This is true, but it also ensures that the time allocated to the group
> > is also consumed by group if it wants to.
> 
> I don't see how schedulability analysis can be done with this model,
> since a single budget is being expended at varying priorities/deadlines.
> 
> > > 4) On an SMP, more than one thread could be running against
> > > the same budget at the same time, resulting in budget over-charges.
> > >
> > 
> > The rt group scheduler does split the budget per cpu. On expiring the
> > budget, it tries to borrow from other CPUs if possible.
> 
> First, how is the splitting of the budget between CPU's controlled
> by the application?
> 
> Second, I don't see how schedulabiliyt analysis could be done if
> CPU's can "borrow" budget from other CPUs, unless there is some
> mechanism in place to "pay it back".  How do you do the analysis?

Right so control-groups (cgroups for short) are a form of
virtualization. Each controller is specific to a resource. We have
memory controllers, namespace controllers and also a scheduler
controller.

If you would apply all controllers to the same task groups you get a
result like chroot on steroids, or jails etc. But you can also use them
individually to control resources in creative ways.

In order to manage RT resources you want:

  - a minimum bandwidth guarantee
  - isolation

So ideally you want a CBS server that schedules your RT (FIFO/RR) tasks.

Now, let me first state that the current code is a hack, and I know its
nowhere near proper. But it was the best I could come up with on a short
notice -- and Fabio is now looking at doing better :-)

Furthermore the whole feature is still marked EXPERIMENTAL, basically
because I do recognize it for the hack it is -- that said, some people
might find it useful.


So a task can only belong to 1 group of any 1 controller (that is, it
can belong to multiple groups but only of different controllers) and
since there is only 1 scheduler controller, we can, for the purpose of
this discussion say it can only belong to a single group.

These groups get assigned a bandwidth through the use of a period and
runtime group parameter -- the documentation states that using different
periods is currently broken and would require a deadline server.

Therefore we can assume all periods are equal, for the rest of this
description -- and set it to 1s.


So what does it do, its a hierarchical FIFO scheduler, with the prio of
a group being that of the max prio of its children. If a group runs out
of quota it will be dequeued. When the period timer comes along and
refreshes the quota it will be requeued.

      R
     / \
    A   B
   / \  |\
  1   4 C 3
        |
        2

groups in letters, tasks in digits.

If we assume tasks being hogs and have descending priority relative to
their numbering, and A has 40% and B has 30% bandwidth and C has 20%.

Lets first look at UP.

Then since 1 would be the highest priority task, A would have the
priority of 1, and we'd select A->1 to run.

This would continue for 400ms, after that the whole of A will be
dequeued. Next in line would be B->C->2, which can run for 200ms before
C gets dequeued, leaving B->3 as only option, which has a remaining
100ms of B's budget left to run.

Once the refresh timer comes along things get replenished and can run
again.

SMP

the cgroup interface specified bandwidth as per a single cpu, when more
are present in the load-balance domain (see cpusets) the total bandwidth
available to the group is the specified multiplied by the number of
available cpus.

The initial distribution is such that each cpu gets equal bandwidth.

Now on 2 cpus, we'd want A->1 and B->C->2 running, since those are the
highest prio tasks on the system.

Since we have 2 cpus the budget for C is 200ms per cpu, 400ms total.

For the first 200ms we'll run 1 on cpu0 and 2 on cpu1. At that point
we'll find that cpu1's budget for C is depleted.

It will then look at other cpus in the load-balance domain (cpu0) and
transfer half of C's unused budget over to itself (with rounding up so
we can indeed leave the other cpus with 0).

This way C->2 can get to run for up to 400ms on cpu1. After that C gets
dequeued and B->3 will take over as the next highest task.

Now, after 600ms total B will have depleted its quota and the only tasks
left are A->{1,4}. A will have consumed 600 of its 800ms, and will now
have to spread this over 2 cpus. [ basically cpu0 gets to transfer less
of off cpu1 because 4 will be consuming C's quota on it ]

Locks.

Suppose they're not hogs and behave like proper tasks and complete their
work within bugdet. In this case nobody will get throttled and we all
live happily together.

Now suppose one application, say 3, has a bug and runs out of quota
whilst holding a lock.

Further suppose that 1 contends on that lock. The implemented behaviour
is that we PI boost 3. The group is temporarily placed back on the
runqueue and we allow 3 to overcommit on its budget in order to release
the lock.

This overcommit it accounted and only once the budget turns positive
again (due to sufficient refresh) will the group be requeued.


Now, why I did things like this.

Because doing a deadline CBS server
  - is non trivial.
  - would mean we'd have to deal with deadline inheritenace.
  - would significantly complicate the load-balancing.

Is any of that an excuse? No not really but it is something useful for
some people, esp in the case of normal usage where you'd not hit the
limits, and in case you do, you only penalize the one who does.

So as a first approximation it seems to work in practise.

I'm very glad Fabio is working on improving things.

