Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0BAIam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:30:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:60802 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab0BAIaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:30:30 -0500
Date: Mon, 1 Feb 2010 18:33:42 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
Message-ID: <20100201073341.GH9085@laptop>
References: <20100131205254.407214951@polymtl.ca>
 <20100131210013.446503342@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100131210013.446503342@polymtl.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 03:52:56PM -0500, Mathieu Desnoyers wrote:
> Depends on:
> "Create spin lock/spin unlock with distinct memory barrier"
> 
> A full memory barrier is wanted before and after runqueue data structure
> modifications so these can be read safely by sys_membarrier without holding the
> rq lock.
> 
> Adds no overhead on x86, because LOCK-prefixed atomic operations of the spin
> lock/unlock already imply a full memory barrier. Combines the spin lock
> acquire/release barriers with the full memory barrier to diminish the
> performance impact on other architectures. (per-architecture spinlock-mb.h
> should be gradually implemented to replace the generic version)

It does add overhead on x86, as well as most other architectures.

This really seems like the wrong optimisation to make, especially
given that there's not likely to be much using librcu yet, right?

I'd go with the simpler and safer version of sys_membarrier that does
not do tricky synchronisation or add overhead to the ctxsw fastpath.
Then if you see some actual improvement in a real program using librcu
one day we can discuss making it faster.

As it is right now, the change will definitely slow down everybody
not using librcu (ie. nearly everything).

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Nicholas Miell <nmiell@comcast.net>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: mingo@elte.hu
> CC: laijs@cn.fujitsu.com
> CC: dipankar@in.ibm.com
> CC: akpm@linux-foundation.org
> CC: josh@joshtriplett.org
> CC: dvhltc@us.ibm.com
> CC: niv@us.ibm.com
> CC: tglx@linutronix.de
> CC: peterz@infradead.org
> CC: Valdis.Kletnieks@vt.edu
> CC: dhowells@redhat.com
> ---
>  kernel/sched.c |   24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/sched.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-31 14:59:42.000000000 -0500
> +++ linux-2.6-lttng/kernel/sched.c	2010-01-31 15:09:51.000000000 -0500
> @@ -893,7 +893,12 @@ static inline void finish_lock_switch(st
>  	 */
>  	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
>  
> -	raw_spin_unlock_irq(&rq->lock);
> +	/*
> +	 * Order mm_cpumask and rq->curr updates before following memory
> +	 * accesses. Required by sys_membarrier().
> +	 */
> +	smp_mb__before_spin_unlock();
> +	raw_spin_unlock_irq__no_release(&rq->lock);
>  }
>  
>  #else /* __ARCH_WANT_UNLOCKED_CTXSW */
> @@ -916,10 +921,15 @@ static inline void prepare_lock_switch(s
>  	 */
>  	next->oncpu = 1;
>  #endif
> +	/*
> +	 * Order mm_cpumask and rq->curr updates before following memory
> +	 * accesses. Required by sys_membarrier().
> +	 */
> +	smp_mb__before_spin_unlock();
>  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> -	raw_spin_unlock_irq(&rq->lock);
> +	raw_spin_unlock_irq__no_release(&rq->lock);
>  #else
> -	raw_spin_unlock(&rq->lock);
> +	raw_spin_unlock__no_release(&rq->lock);
>  #endif
>  }
>  
> @@ -5490,7 +5500,13 @@ need_resched_nonpreemptible:
>  	if (sched_feat(HRTICK))
>  		hrtick_clear(rq);
>  
> -	raw_spin_lock_irq(&rq->lock);
> +	raw_spin_lock_irq__no_acquire(&rq->lock);
> +	/*
> +	 * Order memory accesses before mm_cpumask and rq->curr updates.
> +	 * Required by sys_membarrier() when prev != next. We only learn about
> +	 * next later, so we issue this mb() unconditionally.
> +	 */
> +	smp_mb__after_spin_lock();
>  	update_rq_clock(rq);
>  	clear_tsk_need_resched(prev);
>  
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
