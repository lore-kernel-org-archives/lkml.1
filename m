Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYCaFoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYCaFoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 01:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYCaFoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 01:44:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYCaFoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 01:44:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Monday, 24 March 2008 10:34:39 -0700 <1206380079.21896.20.camel@bobble.smo.corp.google.com>
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
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080331054404.78CDB26F8E9@magilla.localdomain>
Date: Sun, 30 Mar 2008 22:44:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, if it's acceptable, for a first cut (and the patch I'll submit),
> I'll handle the UP and SMP cases, encapsulating them in sched.h in such
> a way as to make it invisible (as much as is possible) to the rest of
> the code.

That's fine.

> After looking at the code again, I now understand what you're talking
> about.  You overloaded it_*_expires to support both the POSIX interval
> timers and RLIMIT_CPU.  So the way I have things, setting one can stomp
> the other.

For clarity, please never mention that identifier without indicating which
struct you're talking about.  signal_struct.it_*_expires has never been
overloaded.  signal_struct.it_prof_expires is the ITIMER_PROF setting;
signal_struct.it_virt_expires is the ITIMER_VIRTUAL setting; there is no
signal_struct.it_sched_expires field.  task_struct.it_*_expires has never
been overloaded.  task_struct.it_prof_expires is the next value of
(task_struct.utime + task_struct.stime) at which run_posix_cpu_timers()
needs to check for work to do.

> Might it be cleaner to handle the RLIMIT_CPU stuff separately, rather
> than rolling it into the itimer handling?

It is not "rolled into the itimer handling".  
run_posix_cpu_timers() handles three separate features:

1. ITIMER_VIRTUAL, ITIMER_PROF itimers (setitimer/getitimer)
2. POSIX timers CPU timers (timer_* calls)
3. CPU time rlimits (RLIMIT_CPU for process-wide, RLIMIT_RTTIME for each thread)

The poorly-named task_struct.it_*_expires fields serve a single purpose:
to optimize run_posix_cpu_timers().  task_struct.it_prof_expires is the
minimum of the values at which any of those three features need attention.

> Okay, my proposed fix for this is to introduce a new field in
> signal_struct, rlim_expires, a cputime_t.  Everywhere that the
> RLIMIT_CPU code formerly set it_prof_expires it will now set
> rlim_expires and in run_posix_cpu_timers() I'll check it against the
> thread group prof_time.

I don't see the point of adding this field at all.  It serves solely to
cache the secs_to_cputime calculation on the RLIMIT_CPU rlim_cur value,
which is just a division.

> I've changed the uniprocessor case to retain the dynamic allocation of
> the thread_group_cputime structure as needed; this makes the code
> somewhat more consistent between SMP and UP and retains the feature of
> reducing overhead for processes that don't use interval timers.

This does not make sense.  There is no need for any new state at all in
the UP case, just reorganizing what is already there.

The existing signal_struct fields utime, stime, and sum_sched_runtime are
no longer needed.  These accumulate the times of dead threads in the group
(see __exit_signal in exit.c) solely so cpu_clock_sample_group can add
them in.  Keeping both those old fields and the dynamically allocated
per-CPU counters is wrong.  You will count double all the threads that
died since the struct was allocated (i.e. since the first timer was set).

For the UP case, just replace these with a single struct thread_group_cputime
in signal_struct, and increment it directly on every tick.  __exit_signal
never touches it.

For the SMP case, you need a bit of complication.  When there are no
expirations (none of the three features in use on a process-wide CPU
clock) or only one live thread, then you don't need to allocate the
per-CPU counters.  But you need one or the other kind of state as soon
as a thread dies while others live, or there are multiple threads while
any process-wide expiration is set.  There are several options for how
to reconcile the dead-threads tracking with the started-on-demand
per-CPU counters.

You did not follow what I had in mind for abstracting the code.
Here is what I think will make it easiest to work through all these
angles without rewriting much of the code for each variant.

Define:

	struct task_cputime {
		cputime_t utime;
		cputime_t stime;
		unsigned long long sched_runtime;
	};

and then a second type to use in signal_struct.  
You can clean up task_struct by replacing its it_*_expires fields with one:
	
	struct task_cputime cputime_expires;

(That is, overload cputime_expires.stime for the utime+stime expiration
time.  Even with that kludge, I think it's cleaner to use this struct
for all these places.)

In signal_struct there are no conditionals, it's just:

	struct thread_group_cputime cputime;

The variants provide struct thread_group_cputime and the functions to go
with it.  However many sorts we need can be different big #if blocks
keeping all the related code together.

The UP version just does:

	struct thread_group_cputime {
		struct task_cputime totals;
	};

	static inline void thread_group_cputime(struct signal_struct *sig,
						struct task_cputime *cputime)
	{
		*cputime = sig->cputime;
	}

	static inline void account_group_user_time(struct task_struct *task,
						   cputime_t cputime)
	{
		struct task_cputime *times = &task->signal->cputime.totals;
		times->utime = cputime_add(times->utime, cputime);
	}

	static inline void account_group_system_time(struct task_struct *task,
						     cputime_t cputime)
	{
		struct task_cputime *times = &task->signal->cputime.totals;
		times->stime = cputime_add(times->stime, cputime);
	}

	static inline void account_group_exec_runtime(struct task_struct *task,
						      unsigned long long ns)
	{
		struct task_cputime *times = &task->signal->cputime.totals;
		times->sched_runtime += ns;
	}

Finally, you could consider adding another field to signal_struct:

	struct task_cputime cputime_expires;

This would be a cache, for each of the three process CPU clocks, of the
earliest expiration from any of the three features.  Each of setitimer,
timer_settime, setrlimit, and implicit timer/itimer reloading, would
recalculate the minimum of the head of the cpu_timers list, the itimer
(it_*_expires), and the rlimit.  The reason to do this is that the
common case in run_posix_cpu_timers() stays almost as cheap as it is now.
It also makes a nice parallel with the per-thread expiration cache.
i.e.:

	static int task_cputime_expired(const struct task_cputime *sample,
					const struct task_cputime *expires)
	{
		if (!cputime_eq(expires->utime, cputime_zero) &&
		    cputime_ge(sample->utime, expires->utime))
			return 1;
		if (!cputime_eq(expires->stime, cputime_zero) &&
		    cputime_ge(cputime_add(sample->utime, sample->stime),
			       expires->stime))
			return 1;
		if (expires->sched_runtime != 0 &&
		    sample->sched_runtime >= expires->sched_runtime)
			return 1;
		return 0;
	}

	...

		struct signal_struct *sig = task->signal;
		struct task_cputime task_sample = {
			.utime = task->utime,
			.stime = task->stime,
			.sched_runtime = task->se.sum_exec_runtime
		};
		struct task_cputime group_sample;
		thread_group_cputime(sig, &group_sample);

		if (!task_cputime_expired(&task_sample,
					  &task->cputime_expired) &&
		    !task_cputime_expired(&group_sample,
					  &sig->cputime_expired))
			return 0;

	...



Thanks,
Roland
