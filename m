Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0CDQK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:10:56 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:55711 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0CDQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:10:54 -0500
Date: Thu, 4 Mar 2010 13:23:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
 barrier (v9)
Message-ID: <20100304122304.GA6864@elte.hu>
References: <20100225232316.GA30196@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225232316.GA30196@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> I am proposing this patch for the 2.6.34 merge window, as I think it is 
> ready for inclusion.

It's a bit late for this merge window i think.

> Here is an implementation of a new system call, sys_membarrier(), which 
> executes a memory barrier on all threads of the current process. It can be 
> used to distribute the cost of user-space memory barriers asymmetrically by 
> transforming pairs of memory barriers into pairs consisting of 
> sys_membarrier() and a compiler barrier. For synchronization primitives that 
> distinguish between read-side and write-side (e.g. userspace RCU, rwlocks), 
> the read-side can be accelerated significantly by moving the bulk of the 
> memory barrier overhead to the write-side.

Why is this such a low level and still special-purpose facility?

Synchronization facilities for high-performance threading may want to do a bit 
more than just execute a barrier instruction on another CPU that has a 
relevant thread running.

You cited signal based numbers:

 > (what we have now, with dynamic sys_membarrier check, expedited scheme)
 > memory barriers in reader: 907693804 reads, 817793 writes
 > sys_membarrier scheme:    4316818891 reads, 503790 writes
 >
 > (dynamic sys_membarrier check, non-expedited scheme)
 > memory barriers in reader: 907693804 reads, 817793 writes
 > sys_membarrier scheme:    8698725501 reads,    313 writes

Much of that signal handler overhead is i think due to:

 - FPU/SSE context save/restore
 - the need to wake up, run and deschedule all threads

Instead i'd suggest for you to try to implement user-space RCU speedups not 
via the new sys_membarrier() syscall, but via two new signal extensions:

 - SA_NOFPU: on x86 to skip the FPU/SSE save/restore, for such fast in/out special 
   purpose signal handlers? (can whip up a quick patch for you if you want)

 - SA_RUNNING: a way to signal only running threads - as a way for user-space 
   based concurrency control mechanisms to deschedule running threads (or, like
   in your case, to implement barrier / garbage collection schemes).

   ( Note: to properly sync back you'll also need an sa_info field to tell
     target tasks how many tasks were woken up. That way a futex can be used 
     as a semaphore to signal back to the issuing thread, and make it all 
     properly event triggered and nicely scalable. Also, queued signals are a 
     must for such a scheme. )

My estimation is that it will be _much_ faster than the naive signal based 
approach - maybe even quite comparable to an open-coded sys_membarrier():

 - as most of the overhead in a real scenario ought to be the IPI sending and 
   latency - not the syscall entry/exit. (with a signal approach we'd still go
   into target thread user-mode, so one more syscall exit+re-entry)

 - or for the common case where there are no other threads running, we are 
   just in/out of SA_RUNNING without having to do any synchronization. In that
   case it should be quite close to sys_membarrier() - modulo some minimal 
   signal API overhead. [which we could optimize some more, if it's visible in
   your benchmarks.]

Signals per se are pretty scalable these days - now that most of the fastpaths 
are decoupled from tasklist_lock and everything is RCU-ized.

Further benefits are:

 - both SA_NOFPU and SA_RUNNING could be used by a _lot_ more user-space 
   facilities than just user-space RCU.

 - synergetic effects: growing some real high-performance facility based on 
   signals would ensure further signal speedups in the future as well. 
   Currently any server app that runs into signal limitations tends to shy 
   away from them and use some different (and often inferior) signalling 
   scheme. It would be better extend signals with 'lightweight' capabilities 
   as well.

All in one, signals are used by like 99.9% of Linux apps, while 
sys_membarrier() would be used only by [WAG] 0.00001% of them.

So before we can merge this (at least via the RCU tree, which you have sent it 
to), i'd like to see you try _much_, _MUCH_ harder to fix the very obvious 
signal overhead performance problems you have demoed via the numbers above so 
nicely.

If _that_ fails, and if we get all the fruits of that, _then_ we might 
perhaps, with a lot of hesitation, concede defeat and think about adding yet 
another syscall.

I know it's cool to add a brand new syscall - but, unfortunately, in practice 
it doesnt help Linux apps all that much. (at least until we have tools/klibc/ 
or so.)

[ There's also a few small cleanliness details i noticed in your patch: enums
  are a tiny bit nicer for ABIs than #define's, the #ifdef SMP is ugly, etc. - 
  but it doesnt really matter much as i think we should concentrate on the
  scalability problems of signals first. ]

Thanks,

	Ingo
