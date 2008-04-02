Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYDBCHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYDBCHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 22:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYDBCHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 22:07:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbYDBCHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 22:07:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Monday, 31 March 2008 13:24:32 -0700 <1206995072.14649.41.camel@bobble.smo.corp.google.com>
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
X-Windows: the joke that kills.
Message-Id: <20080402020707.151E126F8DC@magilla.localdomain>
Date: Tue,  1 Apr 2008 19:07:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, I'm very much having to read between the lines of what you've
> written.  And, obviously, getting it wrong at least half the time. :-)

I'm sorry I wasn't able to communicate more clearly.  Please ask me to
elaborate whenever it would help.  I hope the experience will inspire
you to add some good comments to the code.  If the comments come to
explain everything you now wish had been brought to your attention
from the start, we should be in very good shape.

>         	unsigned long long sched_runtime; /* Scheduler time. */

This is what I'd called it originally (based on the sched_clock() name).
Now it's an aggregate of task_struct.se.sum_exec_runtime, so perhaps
sum_exec_runtime is the right name to use.

> (since that structure refers to this one).  Following that:
> 
>         struct thread_group_cputime;
> 
> Which is a forward reference to the real definition later in the file.

There is no need for that.  This struct is used directly in signal_struct
and so has to be defined before it anyway.  (And when a struct is used
only as the type of a pointer in another type declaration, no forward
declaration is required.)

> The SMP version is percpu, the UP version is just a substructure.  In
> signal_struct itself, delete utime & stime, add
>         struct thread_group_cputime cputime;

Correct, and also delete sum_sched_runtime.

> The inline functions include the ones you defined for UP plus equivalent
> ones for SMP.

Right.  And if we were to try different variants based on NR_CPUS or
whatever, that would entail just a new struct thread_group_cputime
definition and new versions of these functions, touching nothing else.

> A representative inline for SMP is:

Looks correct.

> To deal with the need for bookkeeping with multiple threads in the SMP
> case (where there isn't a per-cpu structure until it's needed), I'll
> allocate the per-cpu structure in __exit_signal() where the relevant
> fields are updated.  I'll also allocate it where I do now, in
> do_setitimer(), when needed.  The allocation will be a "return 0" for UP
> and a call to "thread_group_times_alloc_smp()" (which lives in sched.c)
> for SMP.

By do_setitimer, you mean set_process_cpu_timer and posix_cpu_timer_set.

In the last message I said "there are several options" for dealing with
the dead-threads issue on SMP and did not go into it.  This is one option.
It is attractive in being as lazy as possible.  But I think it is a
prohibitively dubious proposition to do any allocation in __exit_signal.
That is part of the hot path for recovering from OOM situations and all
sorts of troubles; it's also expected to be reliable so that I am not
comfortable with the bookkeeping dropping bits in extreme conditions
(i.e. when you cannot possibly succeed in the allocation and have to
proceed without it or ultimately wedge the system).

The first thing to do is move the existing summation of utime, stime, and
sum_exec_runtime in __exit_signal into an inline thread_group_cputime_exit.
That abstracts it into the set of inlines that can vary for the different
flavors of storage model.  For UP, it does nothing.

1. One set of options keeps static storage for dead-threads accounting, as we
   have now.  i.e., utime, stime, sum_sched_runtime in signal_struct are
   replaced by a "struct task_cputime dead_totals;" in thread_group_cputime.

   a. thread_group_cputime_exit adds into dead_totals as now, unconditionally.
      In thread_group_cputime_exit, if there is a percpu pointer allocated,
      then we subtract current's values from the perpcu counts.
      In posix_cpu_clock_get, if there is no percpu pointer allocated,
      we sum dead_totals plus iterate over live threads, as done now;
      if a percpu pointer is allocated, we sum percpu counters plus dead_totals.

   b. thread_group_cputime_exit adds into dead_totals unless there is a
      percpu pointer allocated.  When we first allocate the percpu
      counters, we fill some chosen CPU's values with dead_totals.
      posix_cpu_clock_get uses just the percpu counters if allocated.

2. No separate storage for dead-threads totals.

   a. Allocate percpu storage in thread_group_cputime_exit.
      I think this is ruled out for the reasons I gave above.

   b. Allocate percpu storage in copy_signal CLONE_THREAD case:

	if (clone_flags & CLONE_THREAD) {
		ret = thread_group_cputime_clone_thread(current, tsk);
		if (likely(!ret)) {
			atomic_inc(&current->signal->count);
			atomic_inc(&current->signal->live);
		}
		return ret;
	}

      That is a safe place to fail with -ENOMEM.  This pays the storage
      cost of the percpu array up front in every multithreaded program; but
      it still avoids that cost in single-threaded programs, and avoids the
      other pressures of enlarging signal_struct itself.  It has the
      benefit of making clock samples (clock_gettime on process CPU clocks)
      in a process not using any CPU timers go from O(n) in live threads to
      O(n) in num_possible_cpus().

There are more variations possible.


Thanks,
Roland
