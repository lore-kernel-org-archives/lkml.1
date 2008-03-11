Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYCKHuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYCKHuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 03:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYCKHu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 03:50:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYCKHuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 03:50:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Thursday, 6 March 2008 11:04:03 -0800 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
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
	<20080305040826.D0E6127010A@magilla.localdomain>
	<1204830243.20004.31.camel@bobble.smo.corp.google.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080311075020.A93DB26F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 00:50:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I changed the subject and trimmed the CC list, as this is now quite far
away from the "some mysterious NPTL problem" subject.  If anyone else
wanted to be individually CC'd, you can add them back in followups.]

> correct me when I get it wrong.  I take what you're saying to mean that,
> first, run_posix_cpu_timers() only needs to be run once per thread group.

Not quite.  check_process_timers only needs to be run once per thread
group (per interesting tick).

> It _sounds_ like it should be checking the shared fields rather than the
> per-task fields for timer expiration (in fact, the more I think about it
> the more sure I am that that's the case).

run_posix_cpu_timers does two things: thread CPU timers and process CPU
timers.  The thread CPU timers track the thread CPU clocks, which are
what the per-thread fields in task_struct count.  check_thread_timers
finds what thread CPU timers have fired.  The task_struct.it_*_expires
fields are set when there are thread CPU timers set on those clocks.

The process CPU timers track the process CPU clocks.  Each process CPU
clock (virt, prof, sched) is just the sum of the corresponding thread
CPU clock across all threads in the group.  In the original code, these
clocks are never maintained in any storage as such, but sampled by
summing all the thread clocks when a current value is needed.
check_process_timers finds what process CPU timers have fired.  The
signal_struct.it_*_expires fields are set when there are process CPU
timers set on those clocks.

The "rebalance" stuff also sets the task_struct.it_*_expires fields of
all the threads in the group when there are process CPU timers.  So each
of these fields is really the minimum of the expiration time of the
earliest thread CPU timer and the "balanced" sample-and-update time
computed from the earliest process CPU timer's expiration time.

> The old process_timer_rebalance() routine was intended to distribute the
> remaining ticks across all the threads, so that the per-task fields
> would cause run_posix_cpu_timers() to run at the appropriate time.  With
> it checking the shared fields this becomes no longer necessary.

This is true of check_process_timers.

> Since the shared fields are getting all the ticks, this will work for
> per-thread timers as well.

I do not follow your logic at all here.  The signal_struct fields being
proposed track each process CPU clock's value.  The thread CPU timers
react to the thread CPU clocks, not the process CPU clocks.

> The arm_timers() routine, instead of calling posix_timer_rebalance(),
> should just directly set signal->it_*_expires to the expiration time,

Correct.

> It's still probably worthwhile to defer processing to a workqueue
> thread, though, just because it's still a lot to do at interrupt.  I'll
> probably end up trying it both ways.

I think the natural place for it is run_timer_softirq.  This is where
natural time timers run.  The posix-cpu-timers processing is analogous
to the posix-timers processing, which runs via timer callbacks from
here.  That roughly means doing it right after the interrupt normally,
and falling back to something similar to a workqueue when the load is
too heavy.  In the common case, it doesn't entail any context switches,
as workqueues always do.

The issue with either the workqueue or the softirq approach is that it
means the call will sometimes (softirq) or always (workqueue) be made by
another task.  Currently we always have current taking samples of its
own clocks and firing timers set on them.  (Because of this you can't
actually use softirq in the simple fashion, i.e. moving the call to
run_posix_cpu_timers.  It would only be guaranteed to run once per CPU
and wouldn't know which task it was supposed to look at.  You'd have to
keep a per-CPU list of tasks pending consideration, i.e. a workqueue.)

I can't tell you off hand about serious complications of doing this work
from another task rather than by current on current.  I think I might
have had some in mind when I did the original implementation, but I just
don't remember any more.  It seems like a potential can of worms.  My
first inclination is to do every other cleanup we like first before
touching this question.

Also note that the bulk of the work (and everything that's not O(1))
has to be done with interrupts disabled anyway.  That's necessary to
take siglock.  That lock both protects signal_struct, and it protects
the task_struct.cpu_timers lists.  (You can do a cheap and lossy test
on current->signal->it_*_expires without taking the lock, for the
nothing-fires fast path.)

> One thing that's still unclear to me is, if there were only one run of
> run_posix_cpu_timers() per thread group per tick, how would per-thread
> timers be serviced?

What I said is only actually necessary once per thread group is the work
that check_process_timers does.  In the current style of code where
there is a loop through all the threads anyway, then you could in fact
weave in the check_thread_timers work there too and then all that would
only need to be done once per thread group per tick.  (But I don't think
that's what I suggested last time.)

> I've given this some thought.  It seems clear that there's going to be
> some performance penalty when multiple CPUs are competing trying to
> update the same field at the tick.

Indeed.  That's why I said I would not endorse any patch that doesn't
address this up front, and show concrete measurements about this
overhead.  (To a first approximation, the overhead on every tick for
every task in the system is always more important than the complications
for tasks that are using any CPU timers, including ITIMER_PROF and
ITIMER_VIRTUAL.)

> It would be much better if there were cacheline-aligned per-cpu fields
> associated with either the task or the signal structure; that way each
> CPU could update its own field without competing with the others.
> Processing in run_posix_cpu_timers would still be constant, although
> slightly higher for having to consult multiple fields instead of just
> one.  Not one per thread, though, just one per CPU, a much smaller and
> fixed number.

Exactly this is the first idea I had about this.  (I considered this in
the original implementation and decided for the first crack to err on
the side of no new code or data structures in the paths taken by every
thread, with the new hair only affecting processes that actually use any
process CPU timers.)

But this is not without its own issues.  Currently on my configuration
(64-bit) the utime, stime, sum_sched_runtime fields (which now only
accumulate the contributions to process CPU clocks of threads that are
already dead) take 24 bytes.  Throw in gtime (which is analogous in its
bookkeeping, but has no POSIX clock/timer interface to it) and call it
32 bytes.  That's out of 904 bytes total in signal_struct.

On some common configurations, SMP_CACHE_BYTES is 128 and NR_CPUS is 64.
So the obvious static addition to signal_struct would bloat it by 8192
bytes (i.e. 904 to 9096, or more than 10x), of which 96*NR_CPUS (2/3)
would be wasted even when you really have NR_CPUS running.  That is way
beyond the acceptable size (it's too big to even work right with the
kernel allocators), even if it weren't mostly wasted space.

This leads to some obvious follow-on ideas.  With some fancy
footwork, you could use a pointer to a separately allocated chunk of
only num_possible_cpus() * SMP_CACHE_BYTES.  You needn't allocate it
at all until the first timer is set on that process CPU clock.  That
makes the bloat smaller, and limits it to the processes that actually
need to check on each tick.

With all of this properly encapsulated in a struct and some helper
functions, it would be simple to conditionalize the implementation.
For uniprocessor kernels, clearly it would be preferable just to use
the existing signal_struct fields.  For NR_CPUS=2, it might be
reasonable to use the static aligned fields bloating signal_struct
(or perhaps for NR_CPUS * SMP_CACHE_BYTES < some threshold).  etc.

An alternative notion is to have single shared fields per clock in
signal_struct but add to them only at context switch.  If the threads
in the process don't all yield at the same time, then maybe that
works out ok for cache contention.  It's not a well-developed idea.

This all adds up to me thinking there is no simple answer.  I think
we need to consider several alternatives, and get real measurements
of their overheads in various workloads, etc.  I am hesitant to pick
any "simple" changes to put in the kernel before we have examined the
real trade-offs fully.


Thanks,
Roland
