Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYCKVF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYCKVF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYCKVFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:05:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYCKVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:05:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=TEN7N2BOx/XMWU/b9uChLCAh/uwDM0qidVoZBu3MxLI2YK8omUt+gcCvUqYyamB5S
	EmH/F0OZ+y1jmN01Mhskg==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080311075020.A93DB26F991@magilla.localdomain>
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
	 <20080311075020.A93DB26F991@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 11 Mar 2008 14:05:07 -0700
Message-Id: <1205269507.23124.57.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 00:50 -0700, Roland McGrath wrote:
> > correct me when I get it wrong.  I take what you're saying to mean that,
> > first, run_posix_cpu_timers() only needs to be run once per thread group.
> Not quite.  check_process_timers only needs to be run once per thread
> group (per interesting tick).

Where "interesting tick" means "tick in which a process timer has
expired," correct?

> > It _sounds_ like it should be checking the shared fields rather than the
> > per-task fields for timer expiration (in fact, the more I think about it
> > the more sure I am that that's the case).
> run_posix_cpu_timers does two things: thread CPU timers and process CPU
> timers.  The thread CPU timers track the thread CPU clocks, which are
> what the per-thread fields in task_struct count.  check_thread_timers
> finds what thread CPU timers have fired.  The task_struct.it_*_expires
> fields are set when there are thread CPU timers set on those clocks.
> 
> The process CPU timers track the process CPU clocks.  Each process CPU
> clock (virt, prof, sched) is just the sum of the corresponding thread
> CPU clock across all threads in the group.  In the original code, these
> clocks are never maintained in any storage as such, but sampled by
> summing all the thread clocks when a current value is needed.
> check_process_timers finds what process CPU timers have fired.  The
> signal_struct.it_*_expires fields are set when there are process CPU
> timers set on those clocks.

And my changes introduce these clocks as separate fields in the signal
struct, updated at the tick.

> > Since the shared fields are getting all the ticks, this will work for
> > per-thread timers as well.
> 
> I do not follow your logic at all here.  The signal_struct fields being
> proposed track each process CPU clock's value.  The thread CPU timers
> react to the thread CPU clocks, not the process CPU clocks.

Okay, I hadn't been clear on the distinction between process-wide and
thread-only timers.  So, really, run_posix_cpu_timers() needs to check
both sets, the versions in the signal struct for the process-wide timers
and the versions in the task struct for the thread-only timers.

> > It's still probably worthwhile to defer processing to a workqueue
> > thread, though, just because it's still a lot to do at interrupt.  I'll
> > probably end up trying it both ways.

I'm going to table this for now.  Based on my preliminary performance
results, the changes I've made mean that using a workqueue or softirq is
not necessary.  In the profiles of a couple of testcases I've run,
run_posix_cpu_timers() didn't show up at all, whereas before my change
it was right at the top with ~35% of the time.

I'll hang on to your notes, though, for future reference.

> > One thing that's still unclear to me is, if there were only one run of
> > run_posix_cpu_timers() per thread group per tick, how would per-thread
> > timers be serviced?
> What I said is only actually necessary once per thread group is the work
> that check_process_timers does.  In the current style of code where
> there is a loop through all the threads anyway, then you could in fact
> weave in the check_thread_timers work there too and then all that would
> only need to be done once per thread group per tick.  (But I don't think
> that's what I suggested last time.)

So, check_process_timers() checks for and handles any expired timers for
the currently-running process, whereas check_thread_timers() checks for
and handles any expired timers for the currently-running thread.  Is
that correct?

And, since these timers are only counting CPU time, if a thread is never
running at the tick (since that's how we account time in the first
place) any timers it might have will never expire.  Sorry to repeat the
obvious but sometimes it's better to state things very explicitly.

At each tick a process-wide timer may have expired.  Also, at each tick
a thread-only timer may have expired.  Or, of course, both.  So we need
to detect both events and fire the appropriate timer in the appropriate
context.

I think my current code (i.e. the patch I published for comment a few
days ago) does this, with one exception:  If a thread-only timer expires
it _won't_ be detected when run_posix_cpu_timers() runs, since I'm only
checking the process-wide timers.  This implies that I need to do twice
as many checks up front.  I'll think about how to minimize that, though.

> > I've given this some thought.  It seems clear that there's going to be
> > some performance penalty when multiple CPUs are competing trying to
> > update the same field at the tick.
> Indeed.  That's why I said I would not endorse any patch that doesn't
> address this up front, and show concrete measurements about this
> overhead.  (To a first approximation, the overhead on every tick for
> every task in the system is always more important than the complications
> for tasks that are using any CPU timers, including ITIMER_PROF and
> ITIMER_VIRTUAL.)

I've actually gotten a little bit of insight into this.  I don't think
that a straight set of shared fields is sufficient except in UP (and
possibly dual-CPU) environments.  I was able to run a reasonable test on
both a four-core Opteron system and a sixteen-core Opteron system.
(That's two dual-core CPUs and four four-core CPUs, no sixteen-core
Opteron chips here. :-)  They had 1024K and 512K cache respectively.  I
didn't have a chance to actually time the runs but I observed that the
sixteen-core run took substantially longer than the four-core run.
Something like double the time.  While some part of this is likely
attributable to the smaller cache, the testcase was small enough that
that shouldn't have been a real issue.  I'm pretty confident that it was
cache conflict among the sixteen cores that did the damage.

> > It would be much better if there were cacheline-aligned per-cpu fields
> > associated with either the task or the signal structure; that way each
> > CPU could update its own field without competing with the others.
> > Processing in run_posix_cpu_timers would still be constant, although
> > slightly higher for having to consult multiple fields instead of just
> > one.  Not one per thread, though, just one per CPU, a much smaller and
> > fixed number.
> Exactly this is the first idea I had about this.  (I considered this in
> the original implementation and decided for the first crack to err on
> the side of no new code or data structures in the paths taken by every
> thread, with the new hair only affecting processes that actually use any
> process CPU timers.)
> This leads to some obvious follow-on ideas.  With some fancy
> footwork, you could use a pointer to a separately allocated chunk of
> only num_possible_cpus() * SMP_CACHE_BYTES.  You needn't allocate it
> at all until the first timer is set on that process CPU clock.  That
> makes the bloat smaller, and limits it to the processes that actually
> need to check on each tick.

I'm currently working on an implementation that uses the alloc_percpu()
mechanism and a separate structure.  I'm encapsulating access to the
fields in shared_xxx_sum() inline functions, which could have different
implementations for UP, dual-CPU and generic SMP kernels.  Each tick
does something like, for example:

	if (p->signal->shared_times) { /* Set if timer running. */
		cpu = get_cpu();
		shared_times = per_cpu_ptr(p->signal->shared_times, cpu);
		shared_times->shared_stime = cputime_add(shared_times->shared_stime, cputime);
		put_cpu_no_resched();
	}

(Where "shared_times" is the structure encapsulating the shared fields.)
This adds overhead to sum the per-CPU values but means that multiple
CPUs updating at the same tick won't be competing for the cache line and
killing performance.

> An alternative notion is to have single shared fields per clock in
> signal_struct but add to them only at context switch.  If the threads
> in the process don't all yield at the same time, then maybe that
> works out ok for cache contention.  It's not a well-developed idea.

I'll keep this in mind.

> This all adds up to me thinking there is no simple answer.  I think
> we need to consider several alternatives, and get real measurements
> of their overheads in various workloads, etc.  I am hesitant to pick
> any "simple" changes to put in the kernel before we have examined the
> real trade-offs fully.

I personally think that the most promising approach is the one outlined
above (without considering the context-switch scheme for the moment).
It saves as much space as possible, doesn't penalize processes that
aren't using the posix timers and avoids cache contention between CPUs.
I'll go ahead and implement it and try to generate some numbers.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

