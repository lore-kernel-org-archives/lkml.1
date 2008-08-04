Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYHDSGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYHDSGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYHDSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:06:22 -0400
Received: from gw.goop.org ([64.81.55.164]:51364 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698AbYHDSGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:06:21 -0400
Message-ID: <48974512.7000206@goop.org>
Date: Mon, 04 Aug 2008 11:06:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl> <20080804131012.246115111@chello.nl>
In-Reply-To: <20080804131012.246115111@chello.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Expose the new lock protection lock.
>
> This can be used to annotate places where we take multiple locks of the
> same class and avoid deadlocks by always taking another (top-level) lock
> first.
>   

OK, so the expected usage is:

	spin_lock(&outer_lock);
	/* take in any order */
	spin_lock_nest_lock(&inner[0], &outer_lock);
	spin_lock_nest_lock(&inner[2], &outer_lock);
	spin_lock_nest_lock(&inner[1], &outer_lock);
	...

?

And it's OK to

   1. take inner locks one at a time without holding the outer lock
   2. use plain spin_lock on inner locks when you're taking them one at
      a time, and
   3. release the outer lock before releasing the inner locks

but it's not OK to try to use different outer locks for a given inner lock.

Yes?

    J

> NOTE: we're still bound to the MAX_LOCK_DEPTH (48) limit.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h  |    2 ++
>  include/linux/spinlock.h |    6 ++++++
>  kernel/spinlock.c        |   11 +++++++++++
>  3 files changed, 19 insertions(+)
>
> Index: linux-2.6/include/linux/lockdep.h
> ===================================================================
> --- linux-2.6.orig/include/linux/lockdep.h
> +++ linux-2.6/include/linux/lockdep.h
> @@ -410,8 +410,10 @@ static inline void print_irqtrace_events
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  # ifdef CONFIG_PROVE_LOCKING
>  #  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
> +#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
>  # else
>  #  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
> +#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
>  # endif
>  # define spin_release(l, n, i)			lock_release(l, n, i)
>  #else
> Index: linux-2.6/include/linux/spinlock.h
> ===================================================================
> --- linux-2.6.orig/include/linux/spinlock.h
> +++ linux-2.6/include/linux/spinlock.h
> @@ -183,8 +183,14 @@ do {								\
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  # define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
> +# define spin_lock_nest_lock(lock, nest_lock)				\
> +	 do {								\
> +		 typecheck(struct lockdep_map *, &nest_lock->dep_map);	\
> +		 _spin_lock_nest_lock(lock, &nest_lock->dep_map);	\
> +	 } while (0)
>  #else
>  # define spin_lock_nested(lock, subclass) _spin_lock(lock)
> +# define spin_lock_nest_lock(lock, nest_lock) _spin_lock(lock)
>  #endif
>  
>  #define write_lock(lock)		_write_lock(lock)
> Index: linux-2.6/kernel/spinlock.c
> ===================================================================
> --- linux-2.6.orig/kernel/spinlock.c
> +++ linux-2.6/kernel/spinlock.c
> @@ -292,6 +292,7 @@ void __lockfunc _spin_lock_nested(spinlo
>  }
>  
>  EXPORT_SYMBOL(_spin_lock_nested);
> +
>  unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
>  {
>  	unsigned long flags;
> @@ -314,6 +315,16 @@ unsigned long __lockfunc _spin_lock_irqs
>  
>  EXPORT_SYMBOL(_spin_lock_irqsave_nested);
>  
> +void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
> +				     struct lockdep_map *nest_lock)
> +{
> +	preempt_disable();
> +	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
> +	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
> +}
> +
> +EXPORT_SYMBOL(_spin_lock_nest_lock)
> +
>  #endif
>  
>  void __lockfunc _spin_unlock(spinlock_t *lock)
>
>   

