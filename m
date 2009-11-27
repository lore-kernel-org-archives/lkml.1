Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZK0RTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZK0RTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 12:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZK0RTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 12:19:45 -0500
Received: from mail-yx0-f170.google.com ([209.85.210.170]:48287 "EHLO
	mail-yx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZK0RTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 12:19:44 -0500
X-Greylist: delayed 69682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 12:19:44 EST
MIME-Version: 1.0
Date: Fri, 27 Nov 2009 09:19:35 -0800 (PST)
In-Reply-To: <dL7XP-2R5-13@gated-at.bofh.it>
X-IP: 174.6.25.208
References: <dKVtE-7Jt-21@gated-at.bofh.it> <dKVtE-7Jt-23@gated-at.bofh.it> 
	<dKVtE-7Jt-25@gated-at.bofh.it> <dKVtE-7Jt-27@gated-at.bofh.it> 
	<dKVtE-7Jt-19@gated-at.bofh.it> <dL7XP-2R5-13@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) 
	Gecko/20091109 Ubuntu/9.10 (karmic) Firefox/3.5.5,gzip(gfe),gzip(gfe)
Message-ID: <bfecdd00-53a1-4b3c-9c76-035db37ffb86@b36g2000prf.googlegroups.com>
Subject: Re: observe and act upon workload parallelism: PERF_TYPE_PARALLELISM  
	(Was: [RFC][PATCH] sched_wait_block: wait for blocked threads)
From: Buck <charles.krasic@gmail.com>
To: Stijn Devriendt <highguy@gmail.com>
Cc: linux-kernel@vger.kernel.org, asinha@zeugmasystems.com, krasic@cs.ubc.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stijn,

Thanks for replying!

I agree that our goals are slightly different, but I think they are
not so different as one might think on first glance.

Using the CPU to the fullest is certainly our goal also, to be "work
conserving" is a long-standing feature of any good scheduler.

I assert that our interface could certainly be used by a
thread-pool to achieve the "only run one of us at a time/don't
pre-empt us unless we misbehave" semantic.

I think it is not true however that our approach only works when
timing is available from applications.  It's true that the evaluation
in our paper is focussed on those cases, but we do also have
non-timesensitive tasks in our workloads (e.g. gcc).

The trick is that even if the application doesn't provide timing, our
kernel scheduler will.  When a task uses our coop_poll call, it
receives a time value as a return value.  This may be interpreted as
"you may run until this time without fear of pre-emption, but you must
voluntarily yield back to the kernel by this time, and you may not
block before such yield".  I'll discuss the "you must not block"
below.

The time value returned by coop_poll is calculated by the kernel based
on release times of other coop_poll tasks *and* the fairshare
scheduling timeslice set by the kernel scheduling algorithm.  So even
if there are no other coop_poll release times (because the
applications did not provide times to coop poll), the interface will
still default to the kernel's fairshare timeslice based time.

Back to your case.  Suppose the threads of a pool are running using
coop_poll, but none of them provide times.  If one of them is running
and it blocks, the kernel removes it from the pool (coop group).  The
remaining members of the pool remain eligible for execution.  Which
task runs next depends on fair sharing criteria (maybe a task from
another pool).  Later when the blocked thread awakes, it will resume
as a "best-effort" thread (still not in a thread pool), until it again
yields by calling coop_poll, at that point it "re-joins" it's thread
pool.

What does it mean?

 1) if CPU intensive tasks avoid blocking (by isolating blocking calls
    to helper threads), and they honor coop_poll times, they will
    never be pre-empted.  [ this is maybe where we differ, we assume
    that time sensitive applications have good reasons to isolate
    their time-sensitive and CPU intensive code from synchronous IO ]

 2) if IO tasks are not CPU intensive, they will likely never be
    pre-empted either, even though they lose their "cooperative"
    status in the period between blocking on IO, waking up, until
    calling coop_poll again.

 3) only "best-effort" tasks, i.e. tasks that don't use coop_poll
    at all, are pre-empted, in the normal way they would under
    regular fair share scheduling.

-- Buck



On Nov 27, 4:20 am, Stijn Devriendt <high...@gmail.com> wrote:
> Hi Buck,
>
> Thanks for taking the time to inform me about your research.
> I've just read up on it, but as far as I can tell there's still
> quite some difference between our goals. My goal was to utilize the
> CPU to it's fullest, regardless of blocking calls, in the context of a
> threadpool. Your approach seems to try and do away with scheduling
> latency and is better suited when timing information is available.
>
> A generic threadpool doesn't have timing information about the work-items
> it is processing, so it cannot take part in this type of cooperative scheduling.
>
> Secondly you're using coop_poll() to wait for timeout and/or fds. In my case
> I'm trying to let every blocking syscall cause the wake-up of the next
> thread. This means that the threadpool should make no assumptions
> about work-items and threadpool users can write any code they want.
>
> Regards,
> Stijn
>
>
>
> On Thu, Nov 26, 2009 at 10:08 PM, Buck <charles.kra...@gmail.com> wrote:
> > Hi,
>
> > I think our research on scheduling is somewhat related to this topic.
>
> > I posted to the kernel list a while back, but I'm not sure anyone
> > noticed.   Here is a link to
> > that post, which contains links to slides and our paper.
>
> >http://lwn.net/Articles/358295/
>
> > -- Buck
>
> > On Nov 21, 3:27 am, Stijn Devriendt <high...@gmail.com> wrote:
> >> > Think of it like a classic user-level threading package, where one process
> >> > implements multiple threads entirely in user space, and switches between
> >> > them. Except we'd do the exact reverse: create multiple threads in the
> >> > kernel, but only run _one_ of them at a time. So as far as the scheduler
> >> > is concerned, it acts as just a single thread - except it's a single
> >> > thread that has multiple instances associated with it.
>
> >> > And every time the "currently active" thread in that group runs out of CPU
> >> > time - or any time it sleeps - we'd just go on to the next thread in the
> >> > group.
>
> >> Without trying to sound selfish: after some thinking I can't see how this
> >> solves my problem. This is fine for the case you mentioned later on,
> >> like UI threads, but it's not powerful enough for what I'm trying to achieve.
>
> >> Let's make the round-trip for the thread pool case and start with an empty
> >> thread pool queue:
> >> - All threads are blocked on the queue condition variable untill new work
> >> is queued.
> >> - Thread 1 happily wakes up and runs the work item untill it's blocked.
> >> - A new work item arrives and Thread 2 is woken to handle the new work
> >>   item.
> >> - As long as new work arrives and Thread 2 is not blocked (regardless
> >>   of preemption because the deal was that they will not preempt each
> >>   other) Thread 2 keeps running this work.
> >>   Even when Thread 1 is woken, it will not preempt Thread 1.
>
> >> One solution would be to let Thread 2 call sched_yield, but the
> >> question then is "when" and "how much". Every time a lightweight
> >> thread yields, you'll incur context switches. Because you don't
> >> know when or how much, you'll be penalized for context switching
> >> even when not needed. (Consider 1 blocked thread and 4 extra threads
> >> sched_yield'ing every 5 work items)
>
> >> Another option is to have a group-leader. Non-leader threads will call
> >> sched_yield once in a while in order to try and jump back to the group-leader.
> >> The group-leader will always continue work without sched_yield'ing.
> >> There's no preemption between these threads.
> >> The down-side is that in case multiple of these threads are waiting for
> >> an event, wake-ups must wake the group leader rather than the other
> >> coop-scheduled threads for this model to work.
> >> Another down-side is that when a non-leader thread is blocked and the
> >> group-leader is run, the non-leader thread is treated unfair.
>
> >> Either solution's end-result is a very unfair threadpool where one cannot
> >> guarantee even a loose FIFO-model where items are handled more or
> >> less in the order they are queued and a library that needs to make
> >> trade-offs in performance to get this behaviour back.
>
> >> The solution is great when the threads are blocked most of the time
> >> and have little CPU processing to do (like UI threads), but doesn't
> >> scale beyond that.
>
> >> As ever, enlighten me when you have a great solution to this problem.
>
> >> Stijn
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majord...@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majord...@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

