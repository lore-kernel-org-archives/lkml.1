Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYDBQf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYDBQf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYDBQfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:35:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYDBQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:35:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=v+jNzCGeie2GLB8pqXv9RCLATuR+K9h0WhI2WO/8MbbUyyAYRrkY0xXsmueVj3Y94
	HDopBa5dPkYymzfKEvYcg==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080402020707.151E126F8DC@magilla.localdomain>
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
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
	 <1206380079.21896.20.camel@bobble.smo.corp.google.com>
	 <20080331054404.78CDB26F8E9@magilla.localdomain>
	 <1206995072.14649.41.camel@bobble.smo.corp.google.com>
	 <20080402020707.151E126F8DC@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 02 Apr 2008 09:34:22 -0700
Message-Id: <1207154062.11976.30.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-01 at 19:07 -0700, Roland McGrath wrote:
> I'm sorry I wasn't able to communicate more clearly.  Please ask me to
> elaborate whenever it would help.  I hope the experience will inspire
> you to add some good comments to the code.  If the comments come to
> explain everything you now wish had been brought to your attention
> from the start, we should be in very good shape.

At least it's beginning to make sense.  Rather than worrying overmuch
about commentary, though, I'll think about writing an explanation for
the Documentation directory.  The implementation is pretty scattered so
there's no obvious single place for good commentary; a separate document
might be easier.

> > (since that structure refers to this one).  Following that:
> > 
> >         struct thread_group_cputime;
> > 
> > Which is a forward reference to the real definition later in the file.
> 
> There is no need for that.  This struct is used directly in signal_struct
> and so has to be defined before it anyway.  (And when a struct is used
> only as the type of a pointer in another type declaration, no forward
> declaration is required.)

Yeah, I remembered this finally.  The structures are declared before
signal_struct in all cases, with the inlines appearing (much) later in
the file.

Here are the declarations (starting at around line 425; the inlines
start at around line 2010 or so):

        struct task_cputime {
        	cputime_t utime;			/* User time. */
        	cputime_t stime;			/* System time. */
        	unsigned long long sum_exec_runtime;	/* Scheduler time. */
        };
        /* Alternate field names when used to cache expirations. */
        #define prof_exp	stime
        #define virt_exp	utime
        #define sched_exp	sum_exec_runtime
        
        #ifdef CONFIG_SMP
        struct thread_group_cputime {
        	struct task_cputime *totals;
        };
        #else
        struct thread_group_cputime {
        	struct task_cputime totals;
        };
        #endif

The #defines there are for when I refer to the task_cputime fields as
expiration values, to make it a little more self-explanatory (and less
confusing).  I can remove them if it violates a Linux kernel coding
style rule.

> > To deal with the need for bookkeeping with multiple threads in the SMP
> > case (where there isn't a per-cpu structure until it's needed), I'll
> > allocate the per-cpu structure in __exit_signal() where the relevant
> > fields are updated.  I'll also allocate it where I do now, in
> > do_setitimer(), when needed.  The allocation will be a "return 0" for UP
> > and a call to "thread_group_times_alloc_smp()" (which lives in sched.c)
> > for SMP.
> 
> By do_setitimer, you mean set_process_cpu_timer and posix_cpu_timer_set.

Um, right.  I think.  I'll check.

> In the last message I said "there are several options" for dealing with
> the dead-threads issue on SMP and did not go into it.  This is one option.
> It is attractive in being as lazy as possible.  But I think it is a
> prohibitively dubious proposition to do any allocation in __exit_signal.
> That is part of the hot path for recovering from OOM situations and all
> sorts of troubles; it's also expected to be reliable so that I am not
> comfortable with the bookkeeping dropping bits in extreme conditions
> (i.e. when you cannot possibly succeed in the allocation and have to
> proceed without it or ultimately wedge the system).

Yeah, that bothered me, too.  It's obviously impossible to do the
allocate itself in __exit_signal() itself (since the caller,
release_task() is holding tasklist_lock) and doing it in release_task()
is problematic for the reasons you give.

> The first thing to do is move the existing summation of utime, stime, and
> sum_exec_runtime in __exit_signal into an inline thread_group_cputime_exit.
> That abstracts it into the set of inlines that can vary for the different
> flavors of storage model.  For UP, it does nothing.
> 
> 1. One set of options keeps static storage for dead-threads accounting, as we
>    have now.  i.e., utime, stime, sum_sched_runtime in signal_struct are
>    replaced by a "struct task_cputime dead_totals;" in thread_group_cputime.
> 
>    a. thread_group_cputime_exit adds into dead_totals as now, unconditionally.
>       In thread_group_cputime_exit, if there is a percpu pointer allocated,
>       then we subtract current's values from the perpcu counts.
>       In posix_cpu_clock_get, if there is no percpu pointer allocated,
>       we sum dead_totals plus iterate over live threads, as done now;
>       if a percpu pointer is allocated, we sum percpu counters plus dead_totals.

This seems kind of hacky to me, particularly the bit about subtracting
values from the percpu counts.

>    b. thread_group_cputime_exit adds into dead_totals unless there is a
>       percpu pointer allocated.  When we first allocate the percpu
>       counters, we fill some chosen CPU's values with dead_totals.
>       posix_cpu_clock_get uses just the percpu counters if allocated.

This is a little better and is along the lines I was thinking at one
point, but it still has the dead_totals field which becomes redundant
when the percpu structure is allocated.  I would rather eliminate that
field entirely, especially since we're growing signal_struct in other
ways.

> 2. No separate storage for dead-threads totals.
> 
>    a. Allocate percpu storage in thread_group_cputime_exit.
>       I think this is ruled out for the reasons I gave above.

Right.

>    b. Allocate percpu storage in copy_signal CLONE_THREAD case:
> 
> 	if (clone_flags & CLONE_THREAD) {
> 		ret = thread_group_cputime_clone_thread(current, tsk);
> 		if (likely(!ret)) {
> 			atomic_inc(&current->signal->count);
> 			atomic_inc(&current->signal->live);
> 		}
> 		return ret;
> 	}
> 
>       That is a safe place to fail with -ENOMEM.  This pays the storage
>       cost of the percpu array up front in every multithreaded program; but
>       it still avoids that cost in single-threaded programs, and avoids the
>       other pressures of enlarging signal_struct itself.  It has the
>       benefit of making clock samples (clock_gettime on process CPU clocks)
>       in a process not using any CPU timers go from O(n) in live threads to
>       O(n) in num_possible_cpus().

I had also thought hard about doing this.  One the one hand, it makes
dealing with thread groups a little simpler, since I don't have to
special-case a thread group with a single thread anywhere (i.e. I don't
deal with thread_group_empty(tsk) being true anywhere).  On the other,
it does cause every multithreaded process to pay the cost of the percpu
array, as you say.  Adding the cputime_expires cache to signal_struct
and checking that in run_posix_cpu_timers() (as you suggested last time)
gets a little of that cost back, though, for multithreaded processes
that don't use any of the timers.

Any solution that avoids using a dead_totals field, in addition to
partly offsetting the growth of the signal_struct, also has the minor
advantage that it requires no handling at all in __exit_signal() and
makes that function a couple of lines shorter.

> There are more variations possible.

But I don't think I'm going to worry about them.  I would like the
solution to be as simple and clear as possible and I think the last one
above qualifies.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

