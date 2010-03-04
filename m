Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0CDPwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:52:24 -0500
Received: from mail.openrapids.net ([64.15.138.104]:44019 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755204Ab0CDPwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:52:22 -0500
Date: Thu, 4 Mar 2010 10:52:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20100304155218.GA26468@Krystal>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304122304.GA6864@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:15:25 up 40 days, 17:52,  7 users,  load average: 1.33, 0.55,
	0.67
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > I am proposing this patch for the 2.6.34 merge window, as I think it is 
> > ready for inclusion.
> 
> It's a bit late for this merge window i think.

OK, no problem. Thanks for taking time to review the patch. See below for
response to your comments.

> 
> > Here is an implementation of a new system call, sys_membarrier(), which 
> > executes a memory barrier on all threads of the current process. It can be 
> > used to distribute the cost of user-space memory barriers asymmetrically by 
> > transforming pairs of memory barriers into pairs consisting of 
> > sys_membarrier() and a compiler barrier. For synchronization primitives that 
> > distinguish between read-side and write-side (e.g. userspace RCU, rwlocks), 
> > the read-side can be accelerated significantly by moving the bulk of the 
> > memory barrier overhead to the write-side.
> 
> Why is this such a low level and still special-purpose facility?
> 
> Synchronization facilities for high-performance threading may want to do a bit 
> more than just execute a barrier instruction on another CPU that has a 
> relevant thread running.

Yep, I'm aware of that.

> 
> You cited signal based numbers:
> 
>  > (what we have now, with dynamic sys_membarrier check, expedited scheme)
>  > memory barriers in reader: 907693804 reads, 817793 writes
>  > sys_membarrier scheme:    4316818891 reads, 503790 writes
>  >
>  > (dynamic sys_membarrier check, non-expedited scheme)
>  > memory barriers in reader: 907693804 reads, 817793 writes
>  > sys_membarrier scheme:    8698725501 reads,    313 writes
> 
> Much of that signal handler overhead is i think due to:
> 
>  - FPU/SSE context save/restore
>  - the need to wake up, run and deschedule all threads

This second point hurts, especially if we have more threads than processors.

> 
> Instead i'd suggest for you to try to implement user-space RCU speedups not 
> via the new sys_membarrier() syscall, but via two new signal extensions:
> 
>  - SA_NOFPU: on x86 to skip the FPU/SSE save/restore, for such fast in/out special 
>    purpose signal handlers? (can whip up a quick patch for you if you want)

This could help.

> 
>  - SA_RUNNING: a way to signal only running threads - as a way for user-space 
>    based concurrency control mechanisms to deschedule running threads (or, like
>    in your case, to implement barrier / garbage collection schemes).
> 
>    ( Note: to properly sync back you'll also need an sa_info field to tell
>      target tasks how many tasks were woken up. That way a futex can be used 
>      as a semaphore to signal back to the issuing thread, and make it all 
>      properly event triggered and nicely scalable. Also, queued signals are a 
>      must for such a scheme. )

Ah, nice! I wondered how you'd propose to deal with that one. It was actually my
main problem: how to wait for all running threads to complete their execution.
This added sa_info count and futex usage will indeed deal with the problem. And
rt_sigqueueinfo() will ensure that we don't collapse multiple concurrent
requests for execution of the same signal. For syncing back, I think we can do
this without modifying sa_info. Simply passing a pointer to the counter to
increment in the sigval value to rt_sigqueueinfo() should do the trick.

> 
> My estimation is that it will be _much_ faster than the naive signal based 
> approach - maybe even quite comparable to an open-coded sys_membarrier():

Yes, especially given that your proposal permits to send all signals in in
"broadcast to all running threads" mode, in a single system call.

> 
>  - as most of the overhead in a real scenario ought to be the IPI sending and 
>    latency - not the syscall entry/exit. (with a signal approach we'd still go
>    into target thread user-mode, so one more syscall exit+re-entry)
> 
>  - or for the common case where there are no other threads running, we are 
>    just in/out of SA_RUNNING without having to do any synchronization. In that
>    case it should be quite close to sys_membarrier() - modulo some minimal 
>    signal API overhead. [which we could optimize some more, if it's visible in
>    your benchmarks.]
> 
> Signals per se are pretty scalable these days - now that most of the fastpaths 
> are decoupled from tasklist_lock and everything is RCU-ized.
> 
> Further benefits are:
> 
>  - both SA_NOFPU and SA_RUNNING could be used by a _lot_ more user-space 
>    facilities than just user-space RCU.
> 
>  - synergetic effects: growing some real high-performance facility based on 
>    signals would ensure further signal speedups in the future as well. 
>    Currently any server app that runs into signal limitations tends to shy 
>    away from them and use some different (and often inferior) signalling 
>    scheme. It would be better extend signals with 'lightweight' capabilities 
>    as well.
> 
> All in one, signals are used by like 99.9% of Linux apps, while 
> sys_membarrier() would be used only by [WAG] 0.00001% of them.
> 
> So before we can merge this (at least via the RCU tree, which you have sent it 
> to), i'd like to see you try _much_, _MUCH_ harder to fix the very obvious 
> signal overhead performance problems you have demoed via the numbers above so 
> nicely.

I think we can start with the SA_RUNNING+modified sa_info approach to signal
only running threads. I expect that much of the benefit will come from there.
Then, from that point, we can see if SA_NOFPU provides a significant performance
improvement.

Now, a very basic questions: in the signal-based approach I currently use, I
reserve SIGUSR1 _from my liburcu library_ (yeah, that's pretty ugly). The
problem is: how can I reserve new signal numbers from a library point of view
without having the applications using it too ? We have room left in the rt
signals numbers, so maybe this is a lesser problem than with standard signals,
which are quite full, but the problem of making sure the application does not
conflict stays.

> 
> If _that_ fails, and if we get all the fruits of that, _then_ we might 
> perhaps, with a lot of hesitation, concede defeat and think about adding yet 
> another syscall.
> 
> I know it's cool to add a brand new syscall - but, unfortunately, in practice 
> it doesnt help Linux apps all that much. (at least until we have tools/klibc/ 
> or so.)
> 
> [ There's also a few small cleanliness details i noticed in your patch: enums
>   are a tiny bit nicer for ABIs than #define's, the #ifdef SMP is ugly, etc. - 
>   but it doesnt really matter much as i think we should concentrate on the
>   scalability problems of signals first. ]

OK, let's do that.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
