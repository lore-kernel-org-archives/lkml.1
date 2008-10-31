Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYJaPFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYJaPFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYJaPFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:05:31 -0400
Received: from mail42.e.nsc.no ([193.213.115.42]:39260 "EHLO mail42.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYJaPF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:05:29 -0400
From: Henrik Austad <henrik@austad.us>
Reply-To: henrik@austad.us
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in the scheduler)
Date: Fri, 31 Oct 2008 16:05:07 +0100
User-Agent: KMail/1.9.10
Cc: faggioli@gandalf.sssup.it, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
References: <200810281634.11285.henrik@austad.us> <20081031120921.GA6824@alecto.austad.us> <1225459808.7803.1481.camel@twins>
In-Reply-To: <1225459808.7803.1481.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810311605.09782.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2008 14:30:08 Peter Zijlstra wrote:
> On Fri, 2008-10-31 at 13:09 +0100, Henrik Austad wrote:
> > Ah, ok, I thought introducing new syscalls was *really* frowned upon.
>
> We prefer not to, but sometimes there just isn't any other option.
> If we want to extend struct sched_param, we need 2 new syscalls.
>
> > > Sure, but implementing an EDF class isn't really all that hard - esp if
> > > you only want UP.
> > >
> > > The real fun is in the PI stuff and schedulability tests on SMP.
> >
> > As a start, that is the approach at least I would like to take. Once you
> > have a proven, functional EDF on a single core, you can extend that to
> > handle several cores, if you really want to.
>
> Well, you're of course free to do so, but I don't think its a very
> interesting thing to do.
>
> > > > > > The main problem is that, especially to deal with SMP systems, we
> > > > > > also need to investigate theoretical issues and find out what the
> > > > > > best approach could be.
> > > >
> > > > Yes, well, EDF is not optimal for SMP systems, only for single core.
> > > > However, you can do a pretty good attempt by assigning tasks to cores
> > > > in a greedy fashion (simply put the next task at the CPU with the
> > > > lowest load).
> > > >
> > > > As a further optimization, I guess you could do the whole sced-domain
> > > > thing to minimize the search space.
> > >
> > > The problem with greedy binpacking heuristics is that your
> > > schedulablity test are out the window, making the whole thing useless.
> >
> > Well, not really. I mean, to be optimal, you should also consider WCET,
> > but then, that's really not interesting as IMHO that's the
> > userspace-programmer's responsibility. If the user wants to add tasks
> > that sum up to 210% utilization, it's really not much we can do anyway.
> > You certainly wouldn't want the kernel to stop accepting new jobs.
> >
> > So, keep the kernel logic as simple as possible and move the job to the
> > user. By keeping the kernel logic simple - we make the job easier for the
> > end-users. A very complex EDF-scheduler will make the testing very
> > difficult.
> >
> > If, on the other hand, we *know* that the scheduler is not optimal, but
> > that it behaves in a predictable manner, the end users have a simpler
> > task of finding out why something bad happened.
> >
> > Because, no matter *what* you do, and *how* you implement it, with
> > *whatever* features, there will be cases when things fall apart, and 
> > having a simple, predictable scheduler will be necessary to figure it
> > out.
>
> I agree that the scheduler should be simple, and even something like
> PD^2 is relatively simple.
>
> But I disagree that we should not do schedulability tests. Doing those,
> and esp. enforcing tasks to their given limits increases the QoS for
> others in the presence of faulty/malicious tasks.
>
> Also, WCET is still the users responsibility.
>
> If for each deadline task you specify a period, a deadline and a budget.
> Then the WCET computation is reflected in the budget.
>
> By enforcing the schedulability test and execution budget you raise the
> quality of service, because even in the presence of a mis-behaving task
> only that task will be impacted. The other tasks will still meet their
> deadlines.

Ah, ok. I see.

>
> > > > No. You should have *either* FIFO/RR *or* EDF, not both at the same
> > > > time. If you absolutely require both, you should at least separate
> > > > them on a per-core basis. If you mix them, they need to be aware of
> > > > the other in order to make the right descision, and that is not good.
> > >
> > > We _have_ to have both. Its that simple.
> >
> > No, we do not. Or, at least not at the same time (see below)
> >
> > > POSIX mandates we have SCHED_FIFO/RR, there is tons and tons of
> > > userspace that uses it, we cannot just replace it with a deadline
> > > scheduler.
> >
> > I didn't mean to rip the whole fifo/rr out of the kernel, but adding a
> > switch at compile-time so that you could choose *either* normal, static
> > RT *or* EDF. Then we could, at least for the first few versions, have it
> > depend on !SMP to avoid the whole SMP-non-optimal-mess.
>
> But _why_? why not leave FIFO/RR in? There is absolutely no downside to
> keeping it around.

My motivation was the increased complexity in meeting deadlines etc. By having 
only EDF (or only RR/FIFO) things would be a lot simpler. Life is not simple 
it seems :-)

>
> > > Thing is, you have to run hard tasks first, and scheduler weaker forms
> > > in its slack time, otherwise you cannot guarantee anything.
> >
> > Well, then you suddenly introduce priorities to the deadlines, and that
> > is not good. A hard task is not more important than a soft, but the
> > effect of missing the deadline is. If the schedule is infeasible, it
> > really doesn't matter what you do, as you will miss deadlines, and if you
> > prioritize hard tasks, you will end up starving firm and soft
> >
> > Before you go on and tell me how wrong I am, note that I don't disagree
> > with you, I think choosing hrt before the others, is the best solution
> > from an implementation point of view.
>
> This is, if you make the soft-deadline class aware of the hard-deadline
> class's tasks and schedulability contraints, then you can keep the
> soft-rt class schedulable too.
>
> So srt is in no way less important, its just has less restrictions on
> the schedule, therefore we can run it in the hrt slack/idle time.
>
> And adding the schedulability test in the kernel avoids these starvation
> issues, because you just cannot.
>
> > > On UP - which is not interesting on a general purpose kernel that runs
> > > on machines with up to 4096 CPUs.
> >
> > But, and pardon my ignorance, will an EDF-scheduler be intersting for
> > such a large system? From what I've gathered, small systems are the ones
> > that could benefit from an EDF as you can analyze and predict behaviour,
> > and then, since EDF is optimal, tune the CPU-freq down and still know
> > that things will work.
> >
> > Some embedded people can probably provide a lot better input here than
> > me, as this is just a general idea I snapped up 'somewhere' (where
> > somewhere is an element of the set of all places I've been the last 6
> > months).
>
> Not that large indeed, but people are interested in running RT workloads
> on machines in the 32/64 scale.
>
> And even the embedded folks are now staring quad core arm11 chips in the
> face, wondering how to do things.

Hmm, I must admit, that is a very good point.

>
> > > Then there are the pfair class of scheduling algorithms which can
> > > theoretically yield up to 100% utilization on SMP systems.
> >
> > Do you know about any pratical attempts on this, and what kind of result
> > that produced?
>
> Fairly decent, http://www.cs.unc.edu/~anderson/papers/rtss08b.pdf

Thanks!

>
> > > > Besides that, EDF is the simplest, most brain-dead scheduler you can
> > > > imagine. Basically you want to add the deadline to the tasks, put it
> > > > in a sorted list and pick the leftmost task every time untill it
> > > > completes.
> > >
> > > Sure, and all that is useless without schedulability tests.
> >
> > Yes, but should the kernel do the schedulability test? Or should the ball
> > be passed on to userspace? To analyze the schedulability, you would need
> > the worst case execution time (WCET) of the process, and if the
> > kernel/scheduler should start trying to estimate that...
> >
> > So, as a start, why not just 'ignore' WCET in the first versions, and
> > that can be added later on, if necessary.
>
> Like said above, WCET is represented in the execution budget.
>
> > A lot of good points, and I certainly see your side of it. However (and
> > yes, I have to argue a bit more ;)), I don't think an EDF-scheduler
> > should contain a lot of features.
> >
> > If you want to use the EDF, why not give the user a list of consequenses
> > like - Only a single core
>
> There won't be a single core machine left soon ;-)
>
> > - No other RT-scheduler, if other userspace program breaks, so be it, the
> > user has been warned.
>
> That's a no go, and I don't see why you would need that.
>
> > - Best effort only
>
> That's pretty useless imho. Best-effort and RT are a bit contradictory.
>
> > - Provide handlers for a given set of signals that will be sent to any
> >   application missing a deadline
>
> Yeah, the idea was to send SIGXCPU to tasks who exceed their budget (and
> thus will miss their deadline).
>
> > - no cpu-scaling
> > - ... keep going, basically strip away every piece of dynamic behaviour
> > and complex scheduling code
>
> I'm thinking there's little useful left after all that ;-)

bah, you just picked all my arguments to shreds and convinced me I'm wrong. I 
guess it's back to the drawing board then, but now I have a better 
understanding at least.

Thans for all the feedback guys, especially Peter! I really appreciate this!

-- 
med Vennlig Hilsen - Yours Sincerely
Henrik Austad
