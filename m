Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbYJaMLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbYJaMLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 08:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYJaMLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 08:11:16 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:37191 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJaMLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 08:11:15 -0400
Date: Fri, 31 Oct 2008 13:09:21 +0100
From: Henrik Austad <henrik@austad.us>
To: Peter Zijlstra <peterz@infradead.org>
Cc: faggioli@gandalf.sssup.it, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in
	the scheduler)
Message-ID: <20081031120921.GA6824@alecto.austad.us>
References: <200810281634.11285.henrik@austad.us> <20081030174925.36023f19jy3o832t@feanor.sssup.it> <1225387034.7803.182.camel@twins> <200810302244.52329.henrik@austad.us> <1225443832.7803.1160.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225443832.7803.1160.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:03:52AM +0100, Peter Zijlstra wrote:
> On Thu, 2008-10-30 at 22:44 +0100, Henrik Austad wrote:
> > On Thursday 30 October 2008 18:17:14 Peter Zijlstra wrote:
> > > On Thu, 2008-10-30 at 17:49 +0100, faggioli@gandalf.sssup.it wrote:
> > > > Quoting Peter Zijlstra <peterz@infradead.org>:
> > > > >> Before I dive in, I should probably justify my motivations for writing
> > > > >> this email. I'm working away on implementing an EDF scheduler for real
> > > > >> time tasks in the kernel. This again leads to hacking at the existing
> > > > >> source as I'm not about to toss out the entire scheduler - just
> > > > >> replace (by some Kconfig switch) the RR/FIFO classes. As to why I'm
> > > > >> looking at EDF, I think the answer to that is a bit too long (and not
> > > > >> appropriate for this email anyway) so I'll leave that part out.
> > > >
> > > > Well, I understand that, but it could be interesting... At least to me.
> > > > :-)
> > 
> > ok, simply put:
> > * give each task a relative deadline (will probably introduce a new syscall, 
> > please don't shoot me).
> 
> We call that sys_sched_setscheduler2().

Ah, ok, I thought introducing new syscalls was *really* frowned upon.

> 
> > * when the task enters TASK_RUNNING, set abosolute deadline to time_now + 
> > rel_deadline.
> > * insert task in rq, sorted by abs_deadline
> > * pick leftmost task and run it
> > * when task is done, pick next task
> > 
> > that's it.
> > 
> > Then, of course, you have to add all the logic to make the thing work :)
> 
> Well, yes, I know how to do EDF, and its trivially simple - on UP.
> Deadline scheduling on SMP otoh is not.

True.

> > > >
> > > > > You and a few other folks.
> > > >
> > > > Yes, here we are! :-)
> > > >
> > > > We also have some code, but it still is highly experimental and we are
> > > > deeply rearranging it.
> > 
> > I have a very clear idea about *what* the scheduler should do, the problem is 
> > how to get it to work :-)
> > 
> > Things would be a lot easier if code in the scheduler was a bit 'more 
> > separated. I have started separating things and moving it to separate files. 
> > I'll ship off a few patches for comments if it's interesting?
> 
> Sure, but implementing an EDF class isn't really all that hard - esp if
> you only want UP.
> 
> The real fun is in the PI stuff and schedulability tests on SMP.

As a start, that is the approach at least I would like to take. Once you have a 
proven, functional EDF on a single core, you can extend that to handle several 
cores, if you really want to.

> > > > > The most interesting part of EDF is not the
> > > > > actual scheduler itself (although there are fun issues with that as
> > > > > well), but extending the Priority Inheritance framework to deal with
> > > > > all the fun cases that come with EDF.
> > 
> > Well, I find EDF intersting because it is so blissfully simple. :-)
> 
> Yes it is, until you do SMP :-)

Well, I have a simple solution to that to ;)

> > > > The main problem is that, especially to deal with SMP systems, we also
> > > > need to investigate theoretical issues and find out what the best
> > > > approach could be.
> > 
> > Yes, well, EDF is not optimal for SMP systems, only for single core. However, 
> > you can do a pretty good attempt by assigning tasks to cores in a greedy 
> > fashion (simply put the next task at the CPU with the lowest load).
> > 
> > As a further optimization, I guess you could do the whole sced-domain thing to 
> > minimize the search space.
> 
> The problem with greedy binpacking heuristics is that your schedulablity
> test are out the window, making the whole thing useless.

Well, not really. I mean, to be optimal, you should also consider WCET, but 
then, that's really not interesting as IMHO that's the userspace-programmer's 
responsibility. If the user wants to add tasks that sum up to 210% utilization, 
it's really not much we can do anyway. You certainly wouldn't want the kernel to 
stop accepting new jobs.

So, keep the kernel logic as simple as possible and move the job to the user. 
By keeping the kernel logic simple - we make the job easier for the end-users. A 
very complex EDF-scheduler will make the testing very difficult.

If, on the other hand, we *know* that the scheduler is not optimal, but that it 
behaves in a predictable manner, the end users have a simpler task of finding 
out why something bad happened.

Because, no matter *what* you do, and *how* you implement it, with *whatever* 
features, there will be cases when things fall apart, and  having a simple, 
predictable scheduler will be necessary to figure it out.

> > > > > Well, adding a sched_class, no need to replace anything besides that.
> > > >
> > > > I'm not saying anything in possible sched.c and sched_{fair|rt}.c code
> > > > rearranging, I also only wonder why replacing fixed priority RT
> > > > scheduling with EDF.
> > > >
> > > > I think they both could be in... Maybe we can discuss on where, I mean
> > > > on which position, in the linked list of scheduling classes, to put
> > > > each of them.
> > 
> > No. You should have *either* FIFO/RR *or* EDF, not both at the same time. If 
> > you absolutely require both, you should at least separate them on a per-core 
> > basis. If you mix them, they need to be aware of the other in order to make 
> > the right descision, and that is not good.
> 
> We _have_ to have both. Its that simple.

No, we do not. Or, at least not at the same time (see below)

> POSIX mandates we have SCHED_FIFO/RR, there is tons and tons of userspace that 
> uses it, we cannot just replace it with a deadline scheduler.

I didn't mean to rip the whole fifo/rr out of the kernel, but adding a switch at 
compile-time so that you could choose *either* normal, static RT *or* EDF. Then 
we could, at least for the first few versions, have it depend on !SMP to avoid 
the whole SMP-non-optimal-mess.

> Also, start a linux-rt kernel and look at all the RT threads you have (and 
> that's only going to get worse when we go to threads per interrupt handler 
> instead of threads per interrupt source).

yes, that would certainly be a problem. But, if we can configure in either EDF 
or FIFO/RR, adding this to the kernel-rt-threads should be possible. 

> Who is going to assign useful and meaningful periods, deadlines and execution 
> times to all those threads?

well, periods is not that difficult. Basically you treat everything as 
asynchronus events and put them in the runqueue when they become runnable. And 
the application itself should set a relative deadline via the syscall to tell 
the kernel "when I become runnable, I must finish before time_now + 
rel_deadline"

RT-tasks that runs forever will certainly be a problem, but what about something 
like mark it as soft/firm and for every time a deadline is missed, have the 
trigger function set a new deadline? It would mean you have to rewrite a whole 
lot of apps though. 

> So the only other option is to add a deadline scheduler and allow people to 
> use it.
> 
> When you do that, you'll see that you have to add it above the FIFO/RR class 
> because otherwise your schedulability is out the window again.
> 
> > > Right, ideally I'd like to see 2 EDF classes on top of FIFO, so that we 
> > > end up with the following classes
> > >
> > >   hedf - hard EDF sedf - soft EDF (bounded tardiness) fifo/rr - the 
> > >   current static priority scheduler fair - the current proportional fair 
> > >   scheduler idle - the idle scheduler
> > >
> > > The two edf classes must share some state, so that the sedf class knows 
> > > about the utilisation consumed by hedf, and the main difference between 
> > > these two classes is the schedulability test.
> > 
> > Well.. why not just treat *all* RT-tasks as *either* FIFO/RR or EDF? Having 
> > fifo and edf together will complicate things. And, people looking for edf, 
> > will not use fifo/rr anyway (famous last words).
> 
> errr, not so, see above. FIFO/RR are static priority schedulers, whereas
> deadline schedulers are job-static or dynamic priority schedulers. You
> cannot simply map FIFO onto them, you need more information and who is
> going to provide that?

I'm not going to map anything anywhere. EDF is very different from priority 
based scheduling and we should try to map something back (as priorities, 
strictly speaking, are a set of deadlines analyzed and mapped to priorities 
sothat the deadlines are met).

> Also, with the above mentioned requirement that we must have FIFO/RR,
> there really is no choice.
> 
> > Furthermore, hard/firm/soft could be treated as one class, but it should be 
> > treated differently at missed deadlines. 
> > * Soft: nothing. Scheduled at best effort, when deadline passes, prioritize 
> > other tasks to avoid cascading effect of deadlinemissies
> > * Firm: keep some statistics that the user can modify and a possible 
> > event-handler when limits are exceeded
> > * Hard: immediatly call a user registred function, or send signal to notify 
> > task.
> 
> Thing is, you have to run hard tasks first, and scheduler weaker forms
> in its slack time, otherwise you cannot guarantee anything.

Well, then you suddenly introduce priorities to the deadlines, and that is not 
good. A hard task is not more important than a soft, but the effect of missing 
the deadline is. If the schedule is infeasible, it really doesn't matter what 
you do, as you will miss deadlines, and if you prioritize hard tasks, you will 
end up starving firm and soft

Before you go on and tell me how wrong I am, note that I don't disagree with 
you, I think choosing hrt before the others, is the best solution from an 
implementation point of view.

> And the easiest way to do that slack time stealing, is with such a
> hierarchy. Sure, you can share a lot of code etc. but you need separate
> classes.
> 
> > > [ NOTE: read EDF as any deadline scheduler, so it might as well be
> > >         pfair PD^2 scheduler. ]
> > 
> > Well, the nice thing about EDF, is that it is provable optimal for any 
> > feasible schedule,  IOW, if all the tasks are schedulable, you can have 100% 
> > utilization of the CPU.
> 
> On UP - which is not interesting on a general purpose kernel that runs
> on machines with up to 4096 CPUs.

But, and pardon my ignorance, will an EDF-scheduler be intersting for such a 
large system? From what I've gathered, small systems are the ones that could 
benefit from an EDF as you can analyze and predict behaviour, and then, since 
EDF is optimal, tune the CPU-freq down and still know that things will work.

Some embedded people can probably provide a lot better input here than me, as 
this is just a general idea I snapped up 'somewhere' (where somewhere is an 
element of the set of all places I've been the last 6 months).

> > On a multicore, EDF is not optimal, as rearranging the tasks becomes NP-hard 
> > (basically a knapsack problem) for several backpacks :-)
> 
> That is partitioned EDF or PEDF for short. There are many other EDF
> variants who do not suffer this, for example global EDF (GEDF).
> 
> GEDF can guarantee a utilization bound of 50% for hard-rt and is soft-rt
> up to 100%.
> 
> Then there are the pfair class of scheduling algorithms which can
> theoretically yield up to 100% utilization on SMP systems.

Do you know about any pratical attempts on this, and what kind of result that 
produced?

> 
> > Besides that, EDF is the simplest, most brain-dead scheduler you can imagine. 
> > Basically you want to add the deadline to the tasks, put it in a sorted list 
> > and pick the leftmost task every time untill it completes.
> 
> Sure, and all that is useless without schedulability tests.

Yes, but should the kernel do the schedulability test? Or should the ball be 
passed on to userspace? To analyze the schedulability, you would need the worst 
case execution time (WCET) of the process, and if the kernel/scheduler should 
start trying to estimate that...

So, as a start, why not just 'ignore' WCET in the first versions, and that can 
be added later on, if necessary.

> > > The few problems this gives are things like kstopmachine and the
> > > migration threads, which should run at the max priority available on the
> > > system.
> > >
> > > [ NOTE: although possibly we could make an exception for the migration
> > >         threads, as we generally don't need to migrate running RT tasks]
> > >
> > > Perhaps we can introduce another class on top of hedf which will run
> > > just these two tasks and is not exposed to userspace (yes, I understand
> > > it will ruin just about any schedulability analysis).

Or, have the task run with minimal deadline, and then set to TASK_INTERRUPTIBLE, 
use a timer to awaken it again in a short time, run it, yield and so on. Make a 
periodic tick that will preempt whatever task that's running?


> > >
> > > Which leaves us with the big issue of priority inversion ;-)
> > 
> > Couldn't above idea solve a bit of this? I have some papers on deadline 
> > inheritance laying aorund somewhere, I can have a look at that, I think it 
> > was a fairly elegant solution to some of these issues there.
> 
> Yes, its brilliant, on UP :-)
> 
> But it should work on SMP as well with a bit more effort. But you really
> need bandwidth inheritance as well, which is yet another bit of effort.
> 
> But the Pisa folks mentioned some issues wrt partitioned EDF; Michael,
> was that because the deadline clock wasn't synchronized or something? -
> Could you explain that again, my brain seems to have mis-filed it.
> 
> This is relevant, because even if you do GEDF or better, linux allows
> you to break your system into partitions using cpusets.
> 
> > > We can do deadline inheritance and bandwidth inheritance by changing
> > > plist to a rb-tree/binary heap and mapping the static priority levels
> > > somewhere at the back and also propagating the actual task responsible
> > > for the boost down the chain (so as to be able to do bandwidth
> > > inheritance).
> > 
> > IMHO, you are complicating things unnecessary. EDF is simple. Why not go for a 
> > *very* basic system, not offer things that will be very difficult to 
> > guarantee.
> 
> If you want a system that can guarantee anything, you must solve the
> priority inversion issue, and for deadline scheduling that means both DI
> and BI, even if you do PEDF.
> 
> Because even if you do not allow your tasks to migrate, there will be
> shared resources (if not in userspace, then at least in the kernel), and
> as long as you have that....

A lot of good points, and I certainly see your side of it. However (and yes, I 
have to argue a bit more ;)), I don't think an EDF-scheduler should contain a 
lot of features.

If you want to use the EDF, why not give the user a list of consequenses like
- Only a single core
- No other RT-scheduler, if other userspace program breaks, so be it, the user 
  has been warned.
- Best effort only
- Provide handlers for a given set of signals that will be sent to any 
  application missing a deadline
- no cpu-scaling
- ... keep going, basically strip away every piece of dynamic behaviour and 
  complex scheduling code

henrik
