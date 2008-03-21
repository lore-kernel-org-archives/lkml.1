Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYCUHTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYCUHTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYCUHSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:18:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbYCUHSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:18:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Thursday, 13 March 2008 17:37:30 -0700 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
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
X-Windows: foiled again.
Message-Id: <20080321071846.1B22B26F9A7@magilla.localdomain>
Date: Fri, 21 Mar 2008 00:18:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

> Please take a look and let me know what you think.  In the meantime I'll
> be working on a similar patch to 2.6-head that has optimizations for
> uniprocessor and two-CPU operation, to avoid the overhead of the percpu
> functions when they are unneeded.

My mention of a 2-CPU special case was just an off-hand idea.  I don't
really have any idea if that would be optimal given the tradeoff of
increaing signal_struct size.  The performance needs be analyzed.

> 	disappeared entirely and the arm_timer() routine merely fills
> 	p->signal->it_*_expires from timer->it.cpu.expires.*.  The
> 	cpu_clock_sample_group_locked() loses its summing loops, using the
> 	the shared structure instead.  Finally, set_process_cpu_timer() sets
> 	tsk->signal->it_*_expires directly rather than calling the deleted
> 	rebalance routine.

I think I misled you about the use of the it_*_expires fields, sorry.
The task_struct.it_*_expires fields are used solely as a cache of the
head of cpu_timers[].  Despite the poor choice of the same name, the
signal_struct.it_*_expires fields serve a different purpose.  For an
analogous cache of the soonest timer to expire, you need to add new
fields.  The signal_struct.it_{prof,virt}_{expires,incr} fields hold
the setitimer settings for ITIMER_{PROF,VTALRM}.  You can't change
those in arm_timer.  For a quick cache you need a new field that is
the sooner of it_foo_expires or the head cpu_timers[foo] expiry time.

The shared_utime_sum et al names are somewhat oblique to anyone who
hasn't just been hacking on exactly this thing like you and I have.
Things like thread_group_*time make more sense.

There are now several places where you call both shared_utime_sum and
shared_stime_sum.  It looks simple because they're nicely encapsulated.
But now you have two loops through all CPUs, and three loops in
check_process_timers.

I think what we want instead is this:

	struct task_cputime
	{
		cputime_t utime;
		cputime_t stime;
		unsigned long long schedtime;
	};

Use one in task_struct to replace the utime, stime, and sum_sched_runtime
fields, and another to replace it_*_expires.  Use a single inline function
thread_group_cputime() that fills a sum struct task_cputime using a single
loop.  For the places only one or two of the sums is actually used, the
compiler should optimize away the extra summing from the loop.

Don't use __cacheline_aligned on this struct type itself, because most of
the uses don't need that.  When using alloc_percpu, you can rely on it to
take care of those needs--that's what it's for.  If you implement a
variant that uses a flat array, you can use a wrapper struct with
__cacheline_aligned for that.


Thanks,
Roland
