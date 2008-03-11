Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYCKVfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYCKVfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYCKVfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:35:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYCKVfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:35:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Tuesday, 11 March 2008 14:05:07 -0700 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
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
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080311213507.5BCDF26F991@magilla.localdomain>
Date: Tue, 11 Mar 2008 14:35:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Not quite.  check_process_timers only needs to be run once per thread
> > group (per interesting tick).
> 
> Where "interesting tick" means "tick in which a process timer has
> expired," correct?

Or might have expired, in the current implementation style.  Correct.

> > The process CPU timers track the process CPU clocks.  [...]
> 
> And my changes introduce these clocks as separate fields in the signal
> struct, updated at the tick.

Correct.

> Okay, I hadn't been clear on the distinction between process-wide and
> thread-only timers.  So, really, run_posix_cpu_timers() needs to check
> both sets, the versions in the signal struct for the process-wide timers
> and the versions in the task struct for the thread-only timers.

Correct.

> I'm going to table this for now.  [...]

Agreed.

> So, check_process_timers() checks for and handles any expired timers for
> the currently-running process, whereas check_thread_timers() checks for
> and handles any expired timers for the currently-running thread.  Is
> that correct?

Correct.

> And, since these timers are only counting CPU time, if a thread is never
> running at the tick (since that's how we account time in the first
> place) any timers it might have will never expire.  

Correct.

> At each tick a process-wide timer may have expired.  Also, at each tick
> a thread-only timer may have expired.  Or, of course, both.  So we need
> to detect both events and fire the appropriate timer in the appropriate
> context.

Correct.

> [...]  I'm pretty confident that it was
> cache conflict among the sixteen cores that did the damage.

I'm not surprised by this result.  (I do want to see much more detailed
performance analysis before we decide on a final change.)

> I'm currently working on an implementation that uses the alloc_percpu()
> mechanism and a separate structure.  I'm encapsulating access to the
> fields in shared_xxx_sum() inline functions, which could have different
> implementations for UP, dual-CPU and generic SMP kernels.  

That is exactly what I had in mind.  (I hadn't noticed alloc_percpu, and it
has one more level of indirection than I'd planned.  But that wastes less
space when num_possible_cpus() is far greater than num_online_cpus(), and I
imagine it's vastly superior for NUMA.)

Don't forget do_[gs]etitimer and k_getrusage can use this too.
(Though maybe no reason to bother in k_getrusage since it has
to loop to sum the non-time counters anyway.)

> I personally think that the most promising approach is the one outlined
> above (without considering the context-switch scheme for the moment).

I tend to agree.  It's the only plan I've thought through in detail.
But my remarks stand, about thorough analysis of performance impacts
of options we can think of.


Thanks,
Roland
