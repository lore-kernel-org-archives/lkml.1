Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYJ3Vpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYJ3Vpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760395AbYJ3VpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:45:15 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:34717 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbYJ3VpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:45:10 -0400
From: Henrik Austad <henrik@austad.us>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Deadline scheduling (was: Re: Rearranging layout of code in the scheduler)
Date: Thu, 30 Oct 2008 22:44:52 +0100
User-Agent: KMail/1.9.10
Cc: faggioli@gandalf.sssup.it, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, fabio@gandalf.sssup.it,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "gregory.haskins" <gregory.haskins@gmail.com>
References: <200810281634.11285.henrik@austad.us> <20081030174925.36023f19jy3o832t@feanor.sssup.it> <1225387034.7803.182.camel@twins>
In-Reply-To: <1225387034.7803.182.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810302244.52329.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2008 18:17:14 Peter Zijlstra wrote:
> On Thu, 2008-10-30 at 17:49 +0100, faggioli@gandalf.sssup.it wrote:
> > Quoting Peter Zijlstra <peterz@infradead.org>:
> > >> Before I dive in, I should probably justify my motivations for writing
> > >> this email. I'm working away on implementing an EDF scheduler for real
> > >> time tasks in the kernel. This again leads to hacking at the existing
> > >> source as I'm not about to toss out the entire scheduler - just
> > >> replace (by some Kconfig switch) the RR/FIFO classes. As to why I'm
> > >> looking at EDF, I think the answer to that is a bit too long (and not
> > >> appropriate for this email anyway) so I'll leave that part out.
> >
> > Well, I understand that, but it could be interesting... At least to me.
> > :-)

ok, simply put:
* give each task a relative deadline (will probably introduce a new syscall, 
please don't shoot me).
* when the task enters TASK_RUNNING, set abosolute deadline to time_now + 
rel_deadline.
* insert task in rq, sorted by abs_deadline
* pick leftmost task and run it
* when task is done, pick next task

that's it.

Then, of course, you have to add all the logic to make the thing work :)

> >
> > > You and a few other folks.
> >
> > Yes, here we are! :-)
> >
> > We also have some code, but it still is highly experimental and we are
> > deeply rearranging it.

I have a very clear idea about *what* the scheduler should do, the problem is 
how to get it to work :-)

Things would be a lot easier if code in the scheduler was a bit 'more 
separated. I have started separating things and moving it to separate files. 
I'll ship off a few patches for comments if it's interesting?

> >
> > > The most interesting part of EDF is not the
> > > actual scheduler itself (although there are fun issues with that as
> > > well), but extending the Priority Inheritance framework to deal with
> > > all the fun cases that come with EDF.

Well, I find EDF intersting because it is so blissfully simple. :-)

> > The main problem is that, especially to deal with SMP systems, we also
> > need to investigate theoretical issues and find out what the best
> > approach could be.

Yes, well, EDF is not optimal for SMP systems, only for single core. However, 
you can do a pretty good attempt by assigning tasks to cores in a greedy 
fashion (simply put the next task at the CPU with the lowest load).

As a further optimization, I guess you could do the whole sced-domain thing to 
minimize the search space.

> > > Well, adding a sched_class, no need to replace anything besides that.
> >
> > I'm not saying anything in possible sched.c and sched_{fair|rt}.c code
> > rearranging, I also only wonder why replacing fixed priority RT
> > scheduling with EDF.
> >
> > I think they both could be in... Maybe we can discuss on where, I mean
> > on which position, in the linked list of scheduling classes, to put
> > each of them.

No. You should have *either* FIFO/RR *or* EDF, not both at the same time. If 
you absolutely require both, you should at least separate them on a per-core 
basis. If you mix them, they need to be aware of the other in order to make 
the right descision, and that is not good. 

> Right, ideally I'd like to see 2 EDF classes on top of FIFO, so that we
> end up with the following classes
>
>   hedf     - hard EDF
>   sedf     - soft EDF (bounded tardiness)
>   fifo/rr  - the current static priority scheduler
>   fair     - the current proportional fair scheduler
>   idle     - the idle scheduler
>
> The two edf classes must share some state, so that the sedf class knows
> about the utilisation consumed by hedf, and the main difference between
> these two classes is the schedulability test.

Well.. why not just treat *all* RT-tasks as *either* FIFO/RR or EDF? Having 
fifo and edf together will complicate things. And, people looking for edf, 
will not use fifo/rr anyway (famous last words).

Furthermore, hard/firm/soft could be treated as one class, but it should be 
treated differently at missed deadlines. 
* Soft: nothing. Scheduled at best effort, when deadline passes, prioritize 
other tasks to avoid cascading effect of deadlinemissies
* Firm: keep some statistics that the user can modify and a possible 
event-handler when limits are exceeded
* Hard: immediatly call a user registred function, or send signal to notify 
task.

> [ NOTE: read EDF as any deadline scheduler, so it might as well be
>         pfair PD^2 scheduler. ]

Well, the nice thing about EDF, is that it is provable optimal for any 
feasible schedule,  IOW, if all the tasks are schedulable, you can have 100% 
utilization of the CPU.

On a multicore, EDF is not optimal, as rearranging the tasks becomes NP-hard 
(basically a knapsack problem) for several backpacks :-)

Besides that, EDF is the simplest, most brain-dead scheduler you can imagine. 
Basically you want to add the deadline to the tasks, put it in a sorted list 
and pick the leftmost task every time untill it completes.

> The few problems this gives are things like kstopmachine and the
> migration threads, which should run at the max priority available on the
> system.
>
> [ NOTE: although possibly we could make an exception for the migration
>         threads, as we generally don't need to migrate running RT tasks]
>
> Perhaps we can introduce another class on top of hedf which will run
> just these two tasks and is not exposed to userspace (yes, I understand
> it will ruin just about any schedulability analysis).
>
> Which leaves us with the big issue of priority inversion ;-)

Couldn't above idea solve a bit of this? I have some papers on deadline 
inheritance laying aorund somewhere, I can have a look at that, I think it 
was a fairly elegant solution to some of these issues there.

>
> We can do deadline inheritance and bandwidth inheritance by changing
> plist to a rb-tree/binary heap and mapping the static priority levels
> somewhere at the back and also propagating the actual task responsible
> for the boost down the chain (so as to be able to do bandwidth
> inheritance).

IMHO, you are complicating things unnecessary. EDF is simple. Why not go for a 
*very* basic system, not offer things that will be very difficult to 
guarantee.

> >From what I gather the sssup folks are doing that, although they
>
> reported that DI between disjoint schedule domains (partitions) posed an
> interesting problem.
>
> Personally I'd like to see the full priority inversion issue solved by
> something like the proxy execution protocol, however the SMP extension
> thereof seems to be a tad expensive - found a book on graph theory, all
> that remains is finding time to read it :-)
>
> The advantage of proxy execution is that its fully invariant to the
> schedule function and thus even works for proportional fair schedulers
> and any kind of scheduler hierarchy.



-- 
 -> henrik
