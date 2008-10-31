Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYJaJDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYJaJDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYJaJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:03:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYJaJDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:03:40 -0400
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in
 the scheduler)
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: faggioli@gandalf.sssup.it, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
In-Reply-To: <200810302244.52329.henrik@austad.us>
References: <200810281634.11285.henrik@austad.us>
	 <20081030174925.36023f19jy3o832t@feanor.sssup.it>
	 <1225387034.7803.182.camel@twins>  <200810302244.52329.henrik@austad.us>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Oct 2008 10:03:52 +0100
Message-Id: <1225443832.7803.1160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 22:44 +0100, Henrik Austad wrote:
> On Thursday 30 October 2008 18:17:14 Peter Zijlstra wrote:
> > On Thu, 2008-10-30 at 17:49 +0100, faggioli@gandalf.sssup.it wrote:
> > > Quoting Peter Zijlstra <peterz@infradead.org>:
> > > >> Before I dive in, I should probably justify my motivations for writing
> > > >> this email. I'm working away on implementing an EDF scheduler for real
> > > >> time tasks in the kernel. This again leads to hacking at the existing
> > > >> source as I'm not about to toss out the entire scheduler - just
> > > >> replace (by some Kconfig switch) the RR/FIFO classes. As to why I'm
> > > >> looking at EDF, I think the answer to that is a bit too long (and not
> > > >> appropriate for this email anyway) so I'll leave that part out.
> > >
> > > Well, I understand that, but it could be interesting... At least to me.
> > > :-)
> 
> ok, simply put:
> * give each task a relative deadline (will probably introduce a new syscall, 
> please don't shoot me).

We call that sys_sched_setscheduler2().

> * when the task enters TASK_RUNNING, set abosolute deadline to time_now + 
> rel_deadline.
> * insert task in rq, sorted by abs_deadline
> * pick leftmost task and run it
> * when task is done, pick next task
> 
> that's it.
> 
> Then, of course, you have to add all the logic to make the thing work :)

Well, yes, I know how to do EDF, and its trivially simple - on UP.
Deadline scheduling on SMP otoh is not.

> > >
> > > > You and a few other folks.
> > >
> > > Yes, here we are! :-)
> > >
> > > We also have some code, but it still is highly experimental and we are
> > > deeply rearranging it.
> 
> I have a very clear idea about *what* the scheduler should do, the problem is 
> how to get it to work :-)
> 
> Things would be a lot easier if code in the scheduler was a bit 'more 
> separated. I have started separating things and moving it to separate files. 
> I'll ship off a few patches for comments if it's interesting?

Sure, but implementing an EDF class isn't really all that hard - esp if
you only want UP.

The real fun is in the PI stuff and schedulability tests on SMP.

> > >
> > > > The most interesting part of EDF is not the
> > > > actual scheduler itself (although there are fun issues with that as
> > > > well), but extending the Priority Inheritance framework to deal with
> > > > all the fun cases that come with EDF.
> 
> Well, I find EDF intersting because it is so blissfully simple. :-)

Yes it is, until you do SMP :-)

> > > The main problem is that, especially to deal with SMP systems, we also
> > > need to investigate theoretical issues and find out what the best
> > > approach could be.
> 
> Yes, well, EDF is not optimal for SMP systems, only for single core. However, 
> you can do a pretty good attempt by assigning tasks to cores in a greedy 
> fashion (simply put the next task at the CPU with the lowest load).
> 
> As a further optimization, I guess you could do the whole sced-domain thing to 
> minimize the search space.

The problem with greedy binpacking heuristics is that your schedulablity
test are out the window, making the whole thing useless.

> > > > Well, adding a sched_class, no need to replace anything besides that.
> > >
> > > I'm not saying anything in possible sched.c and sched_{fair|rt}.c code
> > > rearranging, I also only wonder why replacing fixed priority RT
> > > scheduling with EDF.
> > >
> > > I think they both could be in... Maybe we can discuss on where, I mean
> > > on which position, in the linked list of scheduling classes, to put
> > > each of them.
> 
> No. You should have *either* FIFO/RR *or* EDF, not both at the same time. If 
> you absolutely require both, you should at least separate them on a per-core 
> basis. If you mix them, they need to be aware of the other in order to make 
> the right descision, and that is not good. 

We _have_ to have both. Its that simple.

POSIX mandates we have SCHED_FIFO/RR, there is tons and tons of
userspace that uses it, we cannot just replace it with a deadline
scheduler.

Also, start a linux-rt kernel and look at all the RT threads you have
(and that's only going to get worse when we go to threads per interrupt
handler instead of threads per interrupt source).

Who is going to assign useful and meaningful periods, deadlines and
execution times to all those threads?

So the only other option is to add a deadline scheduler and allow people
to use it.

When you do that, you'll see that you have to add it above the FIFO/RR
class because otherwise your schedulability is out the window again.

> > Right, ideally I'd like to see 2 EDF classes on top of FIFO, so that we
> > end up with the following classes
> >
> >   hedf     - hard EDF
> >   sedf     - soft EDF (bounded tardiness)
> >   fifo/rr  - the current static priority scheduler
> >   fair     - the current proportional fair scheduler
> >   idle     - the idle scheduler
> >
> > The two edf classes must share some state, so that the sedf class knows
> > about the utilisation consumed by hedf, and the main difference between
> > these two classes is the schedulability test.
> 
> Well.. why not just treat *all* RT-tasks as *either* FIFO/RR or EDF? Having 
> fifo and edf together will complicate things. And, people looking for edf, 
> will not use fifo/rr anyway (famous last words).

errr, not so, see above. FIFO/RR are static priority schedulers, whereas
deadline schedulers are job-static or dynamic priority schedulers. You
cannot simply map FIFO onto them, you need more information and who is
going to provide that?

Also, with the above mentioned requirement that we must have FIFO/RR,
there really is no choice.

> Furthermore, hard/firm/soft could be treated as one class, but it should be 
> treated differently at missed deadlines. 
> * Soft: nothing. Scheduled at best effort, when deadline passes, prioritize 
> other tasks to avoid cascading effect of deadlinemissies
> * Firm: keep some statistics that the user can modify and a possible 
> event-handler when limits are exceeded
> * Hard: immediatly call a user registred function, or send signal to notify 
> task.

Thing is, you have to run hard tasks first, and scheduler weaker forms
in its slack time, otherwise you cannot guarantee anything.

And the easiest way to do that slack time stealing, is with such a
hierarchy. Sure, you can share a lot of code etc. but you need separate
classes.

> > [ NOTE: read EDF as any deadline scheduler, so it might as well be
> >         pfair PD^2 scheduler. ]
> 
> Well, the nice thing about EDF, is that it is provable optimal for any 
> feasible schedule,  IOW, if all the tasks are schedulable, you can have 100% 
> utilization of the CPU.

On UP - which is not interesting on a general purpose kernel that runs
on machines with up to 4096 CPUs.

> On a multicore, EDF is not optimal, as rearranging the tasks becomes NP-hard 
> (basically a knapsack problem) for several backpacks :-)

That is partitioned EDF or PEDF for short. There are many other EDF
variants who do not suffer this, for example global EDF (GEDF).

GEDF can guarantee a utilization bound of 50% for hard-rt and is soft-rt
up to 100%.

Then there are the pfair class of scheduling algorithms which can
theoretically yield up to 100% utilization on SMP systems.

> Besides that, EDF is the simplest, most brain-dead scheduler you can imagine. 
> Basically you want to add the deadline to the tasks, put it in a sorted list 
> and pick the leftmost task every time untill it completes.

Sure, and all that is useless without schedulability tests.

> > The few problems this gives are things like kstopmachine and the
> > migration threads, which should run at the max priority available on the
> > system.
> >
> > [ NOTE: although possibly we could make an exception for the migration
> >         threads, as we generally don't need to migrate running RT tasks]
> >
> > Perhaps we can introduce another class on top of hedf which will run
> > just these two tasks and is not exposed to userspace (yes, I understand
> > it will ruin just about any schedulability analysis).
> >
> > Which leaves us with the big issue of priority inversion ;-)
> 
> Couldn't above idea solve a bit of this? I have some papers on deadline 
> inheritance laying aorund somewhere, I can have a look at that, I think it 
> was a fairly elegant solution to some of these issues there.

Yes, its brilliant, on UP :-)

But it should work on SMP as well with a bit more effort. But you really
need bandwidth inheritance as well, which is yet another bit of effort.

But the Pisa folks mentioned some issues wrt partitioned EDF; Michael,
was that because the deadline clock wasn't synchronized or something? -
Could you explain that again, my brain seems to have mis-filed it.

This is relevant, because even if you do GEDF or better, linux allows
you to break your system into partitions using cpusets.

> > We can do deadline inheritance and bandwidth inheritance by changing
> > plist to a rb-tree/binary heap and mapping the static priority levels
> > somewhere at the back and also propagating the actual task responsible
> > for the boost down the chain (so as to be able to do bandwidth
> > inheritance).
> 
> IMHO, you are complicating things unnecessary. EDF is simple. Why not go for a 
> *very* basic system, not offer things that will be very difficult to 
> guarantee.

If you want a system that can guarantee anything, you must solve the
priority inversion issue, and for deadline scheduling that means both DI
and BI, even if you do PEDF.

Because even if you do not allow your tasks to migrate, there will be
shared resources (if not in userspace, then at least in the kernel), and
as long as you have that....


