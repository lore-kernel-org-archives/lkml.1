Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYCEEIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYCEEIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYCEEIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:08:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbYCEEIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:08:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: parag.warudkar@gmail.com,
       Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: Frank Mayhar's message of  Tuesday, 4 March 2008 11:52:56 -0800 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080206165045.89b809cc.akpm@linux-foundation.org>
	<1202345893.8525.33.camel@peace.smo.corp.google.com>
	<alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	<20080207162203.3e3cf5ab@Varda>
	<alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	<alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	<20080207165455.04ec490b@Varda>
	<alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	<alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	<1204314904.4850.23.camel@peace.smo.corp.google.com>
	<20080304070016.903E127010A@magilla.localdomain>
	<1204660376.9768.1.camel@bobble.smo.corp.google.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080305040826.D0E6127010A@magilla.localdomain>
Date: Tue,  4 Mar 2008 20:08:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My first patch did essentially what you outlined above, incrementing
> shared utime/stime/sched_time fields, except that they were in the
> task_struct of the group leader rather than in the signal_struct.  It's
> not clear to me exactly how the signal_struct is shared, whether it is
> shared among all threads or if each has its own version.

There is a 1:1 correspondence between "shares signal_struct" and "member of
same thread group".  signal_struct is the right place for such new fields.
Don't be confused by the existing fields utime, stime, gtime, and
sum_sched_runtime.  All of those are accumulators only touched when a
non-leader thread dies (in __exit_signal), and governed by the siglock.
Their only purpose now is to represent the threads that are dead and gone
when calculating the cumulative total for the whole thread group.  If you
were to provide cumulative totals that are updated on every tick, then
these old fields would not be needed.

> So each timer routine had something like:
> 
> 	/* If we're part of a thread group, add our time to the leader. */
> 	if (p->group_leader != NULL)
> 		p->group_leader->threads_sched_time += tmp;

The task_struct.group_leader field is never NULL.  Every thread is a member
of some thread group.  The degenerate case is that it's the only member of
the group; then p->group_leader == p.

> and check_process_timers() had
> 
> 	/* Times for the whole thread group are held by the group leader. */
> 	utime = cputime_add(utime, tsk->group_leader->threads_utime);
> 	stime = cputime_add(stime, tsk->group_leader->threads_stime);
> 	sched_time += tsk->group_leader->threads_sched_time;
> 
> Of course, this alone is insufficient.  It speeds things up a tiny bit
> but not nearly enough.

It sounds like you sped up only one of the sampling loops.  Having a
cumulative total already on hand means cpu_clock_sample_group can also
become simple and cheap, as can the analogues in do_getitimer and
k_getrusage.  These are what's used in clock_gettime and in the timer
manipulation calls, and in getitimer and getrusage.  That's all just gravy.

The real benefit of having a cumulative total is for the basic logic of
run_posix_cpu_timers (check_process_timers) and the timer expiry setup.  
It sounds like you didn't take advantage of the new fields for that.

When a cumulative total is on hand in the tick handler, then there is no
need at all to derive per-thread expiry times from group-wide CPU timers
("rebalance") either there or when arming the timer in the first place.
All of that complexity can just disappear from the implementation.

check_process_timers can look just like check_thread_timers, but
consulting the shared fields instead of the per-thread ones for both the
clock accumulators and the timers' expiry times.  Likewise, arm_timer
only has to set signal->it_*_expires; process_timer_rebalance goes away.

If you do all that then the time spent in run_posix_cpu_timers should
not be affected at all by the number of threads.  The only "walking the
timer lists" that happens is popping the expired timers off the head of
the lists that are kept in ascending order of expiry time.  For each
flavor of timer, there are n+1 steps in the "walk" for n timers that
have expired.  So already no costs here should scale with the number of
timers, just the with the number of timers that all expire at the same time.

Back for a moment to the status quo and your second patch.

> The other issue has to do with the rest of the processing in
> run_posix_cpu_timers(), walking the timer lists and walking the whole
> thread group (again) to rebalance expiry times.  My second patch moved
> all that work to a workqueue, but only if there were more than 100
> threads in the process.  This basically papered over the problem by
> moving the processing out of interrupt and into a kernel thread.  It's
> still insufficient, though, because it takes just as long and will get
> backed up just as badly on large numbers of threads.  This was made
> clear in a test I ran yesterday where I generated some 200,000 threads.
> The work queue was unreasonably large, as you might expect.

What I would expect is that there be at most one item in the queue for
each process (thread group).  If you have 200000 threads in one process,
you still only need one iteration of check_process_timers to run.  If it
hasn't run by the time more threads in the same group get more ticks,
then all that matters is that it indeed runs once reasonably soon (for
an overall effect of not much less often than once per tick interval).

> I am looking for a way to do everything that needs to be done in fewer
> operations, but unfortunately I'm not familiar enough with the
> SIGPROF/SIGVTALRM semantics or with the details of the Linux
> implementation to know where it is safe to consolidate things.

I can help you with all of that.  What I'll need from you is careful
performance analysis of all the effects of any changes we consider.

The simplifications I described above will obviously greatly improve
your test case (many threads and with some process timers expiring
pretty frequently).  We need to consider and analyze the other kinds of
cases too.  That is, cases with a few threads (not many more than the
number of CPUs); cases where no timer is close to expiring very often.
The most common cases, from one-thread cases to one-million thread
cases, are when no timers are going off before next Tuesday (if any are
set at all).  Then run_posix_cpu_timers always bails out early, and none
of the costs you've seen become relevant at all.  Any change to what the
timer interrupt handler does on every tick affects those cases too.

As I mentioned in my last message, my concern about this originally was
with the SMP cache/lock effects of multiple CPUs touching the same
memory in signal_struct on every tick (which presumably all tend to
happen simultaneously on all the CPUs).  I'd insist that we have
measurements and analysis as thorough as possible of the effects of
introducing that frequent/synchronized sharing, before endorsing such
changes.  I have a couple of guesses as to what might be reasonable ways
to mitigate that.  But it needs a lot of measurement and wise opinion on
the low-level performance effects of each proposal.


Thanks,
Roland

