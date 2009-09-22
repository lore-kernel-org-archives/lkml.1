Return-Path: <linux-kernel-owner+w=401wt.eu-S1751332AbZIVSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbZIVSg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZIVSgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:36:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:44951 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZIVSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:36:54 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: claudio@evidence.eu.com, michael@evidence.eu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253623867.20345.156.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
	 <1253617510.7695.23.camel@twins>  <1253623867.20345.156.camel@Palantir>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:36:43 +0200
Message-Id: <1253644603.18939.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 14:51 +0200, Raistlin wrote:

> On Tue, 2009-09-22 at 13:05 +0200, Peter Zijlstra wrote:
> > >  * It does not make any restrictive assumption about the characteristics
> > >    of the tasks: it can handle periodic, sporadic or aperiodic tasks
> > >    (see below)
> > 
> > sched_param_ex seems to only contain two of the three sporadic task
> > model parameters ;-)
> > 
> Yes, that is true. Fact is that, inside the kernel, we deal only with
> the runtime and a period, which is also equal to the (relative!)
> deadline.
> In fact, the (absolute) deadline of a task is set by adding _that_
> period to the old deadline value, or to current time.
> 
> The, let's say, proper task period is left to the userspace, i.e.,
> suspending until the next period/sporadic activation is not done in the
> kernel, it is up to the task.
> This is the most flexible interface we have been able to design, while
> trying to reduce the amount of information that has to be added to the
> minimum... Different ideas are more than welcome. :-)

No bright ideas at the moment, but it might be worth-while to describe
this task model somewhere near sched_param_ex :-)

> > >  * We decided to put the new scheduling class in between sched_rt and
> > >    sched_fair, for the following reasons:
> > 
> > I'd argue to put it above rt, since having it below renders any
> > guarantees void, since you have no idea about how much time is actually
> > available.
> > 
> Well, I think it might be possible, if rt is bandwidth constrained, as
> it is/it is becoming... Don't you?

Ah, the problem I see there is that your minimum deadline gets
constrained by whatever you configure your SCHED_FIFO bit to, this
doesn't seem ideal.

> > >    - Backward compatibility and (POSIX) standard compliance require
> > >      SCHED_FIFO/SCHED_RR tasks to run as soon as they can
> > 
> > In short, sod POSIX.
> > 
> > Simply define 'as soon as they can' to exclude EDF time ;-)
> > 
> Well, I definitely am not going to fight to death for POSIX
> compliance! :-P
> 
> It's just that we've heard a lot of times sentences like "not break well
> known/standard behaviours, especially if exported to userspace" and we
> have not been brave enough to contradict this. :D

Ah, very easy, since POSIX doesn't describe SCHED_EDF/DEADLINE any
system that does run such a task is per definition not POSIX compliant,
is it? ;-)

> Apart from that, I truly think that --again, if rt is bandwidth
> constrained-- having fixed priority above EDF may lead to a solution
> able to provide both, the predictability of the former, and the
> flexibility of the latter, as said below (original mail).
> Anyway, this is not going to be an issue, since moving edf forward is
> quite easy.

See the problem with the SCHED_FIFO period above.

> Damn! I would like to find some time to design and run a couple of
> examples and experiments on both configurations, and see what it comes
> out... If I ever do, I'll let you know.

:-)

> > The only two tasks that need to be the absolute highest priority are
> > kstopmachine and migrate, so those would need to be lifted above EDF,
> > the rest is not important :-)
> > 
> Ok, I think this could be done easily... Maybe also making them EDF with
> very small deadline, but then we would have to think about a reasonable
> budget... Or, obviously, we can simply use something like a "system"
> scheduling class.
> 
> But now, isn't this bringing will bring some unknown amount of
> interference which may disable again the guarantees for edf? Do you
> think this could be the case?

I would argue that kstopmachine is going to break pretty much
everything, so a workload that contains one (module unload, cpu-hotplug)
will not be analyzable. Although Ted Baker mentioned something about
modeling it at a system state change or somesuch.

I'd rather say that anything kstopmachine will violate RT guarantees.

As to migrate, I think we can model that as a regular non-preempt
section (we could actually remove the migrate thread and actually make
it such). 

> > >  * We will migrate the tasks among the runqueues trying to always have,
> > >    on a system with m CPUs, the m earliest deadline ready tasks running
> > >    on the CPUs.
> > >    This is not present in the attached patch, but will be available
> > >    soon.
> > 
> > Ah, ok, so now its fully paritioned, but you'll add that push-pull logic
> > to make it 'global-ish'.
> > 
> Yes, consistently with Linux "distributed runqueue" scheduling approach.
> For now, I'm just "porting" the push/pull rt logic to deadlines, inside
> sched-edf.
> This may be suboptimal and rise at least overhead, clock synchronization
> and locking issue, but I hope, again, it could be a start... A (bad?)
> solution to compare against, when designing better implementations, at
> least.

Agreed, its a pragmatic starting point, and only by implementing it can
we evaluate it.

> Right, I have getparam, I can easily add getscheduler. :-)

Ah, no, I got stuff mixed up, getparam is indeed the one!

> > >  * We did not add any further system call to allow periodic tasks to
> > >    specify the end of the current instance, and the semantics of the
> > >    existing sched_yield() system call has been extended for this
> > >    purpose.
> > 
> > OK, so a wakeup after a yield, before a period elapses also raises some
> > warning/exception/signal thing?
> > 
> I thought about that, and I finally concluded that this should be not
> needed. In fact, when a task "arrives" with a new instance (which is
> what happen if it yield-suspend-resume), its deadline is set to:
> 
>  max(clock, old_deadline) + period
> 
> Thus, even if a task slept few than expected, it makes no benefit out of
> it, since the deadline advances --at best-- from the old value, and it
> is not preempting other tasks, if any, with earlier deadline.
> 
> Do you agree?

I think I do :-)

> The rationale behind this is, again, we tried to avoid as much as we
> can, was to introduce some need of the kernel to be aware of the task
> sleeping/resuming behaviour, since this was judged to be too much
> restrictive.

Makes sense.

> Another thing I would like to have, is a task receiving a SIGXCPU if it
> misses its deadline, which might happen actually, e.g., if you load an
> UP system/a CPU more than 100% with EDF tasks.

Missing a deadline, and possibly over-running a deadline too.

Maybe add a flags field to the sched_param_ex thing ;-)

> > >  * In case a SCHED_EDF tasks forks, parent's budget is split among
> > >    parent and child.
> > 
> > Right, I guess there's really nothing else you can do here...
> > 
> Well, me too... But during tests I run into a poor EDF shell that, after
> each `ls' or `cat', lost half of its bandwidth up to be no longer
> capable of running at all! :(
> 
> We may avoid this having the son giving back its bandwidth to the father
> when dieing (what a sad story! :( ) but this would need distinguishing
> between fork-ed and setschedul-ed EDF tasks. Moreover, e.g., what if the
> son changed its EDF bandwidth in the meanwhile? Or worse if it changed
> its scheduling policy?
> 
> At the current time, I'm just splitting the bandwidth, and nothing more.
> Actually, I also think the solution is the right one, but I would really
> like to discuss the issues it raises.

Ooh, good point,.. yes we can put some exit hooks in there folding the
runtime back.

An alternative is starting the child out with 0 runtime, and have the
parent run sched_setscheduler() on it giving us a clear point to run
admission on.

