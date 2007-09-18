Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbXIRVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXIRVVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXIRVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:21:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47770 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbXIRVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:21:08 -0400
Date: Tue, 18 Sep 2007 14:21:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] lockdep: rcu_dereference() vs rcu_read_lock()
Message-ID: <20070918212105.GL8665@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070918091728.GA6766@localhost.sw.ru> <20070918031723.05689e92.akpm@linux-foundation.org> <46EFA8DC.2020909@bull.net> <20070918033400.495b02dd.akpm@linux-foundation.org> <20070918142451.418b3b51@twins> <20070918161337.GC8665@linux.vnet.ibm.com> <20070918095715.05899d12.akpm@linux-foundation.org> <20070918182924.GF8665@linux.vnet.ibm.com> <20070918222701.7c9aa1c4@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918222701.7c9aa1c4@lappy>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 10:27:01PM +0200, Peter Zijlstra wrote:
> 
> 
> warn when rcu_dereference() is used outside of rcu_read_lock()

Cool!!!

> [ generates a _lot_ of output when booted ]

I bet!  If you create an annotation for rcu_read_lock_bh()
and rcu_read_unlock_bh() like you did for rcu_read_lock() and
rcu_read_unlock(), I suspect that much of the noise will go away.

Of course, preempt_disable() / preempt_enable() is a bit of a two-edged
sword here.  It is OK to do rcu_dereference() under explicit
preempt_disable(), but not OK under the implicit preempt_disable()
implied by spin_lock() in CONFIG_PREEMPT.  One way to handle this
would be to have _rcu() wrappers for preempt_disable() and
preempt_enable() that are annotated.

There is probably a better way...  Can't think of one right off, though...

							Thanx, Paul

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h  |    3 ++
>  include/linux/rcupdate.h |    5 ++++
>  kernel/lockdep.c         |   53 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 61 insertions(+)
> 
> Index: linux-2.6/include/linux/lockdep.h
> ===================================================================
> --- linux-2.6.orig/include/linux/lockdep.h
> +++ linux-2.6/include/linux/lockdep.h
> @@ -303,6 +303,8 @@ extern void lock_acquire(struct lockdep_
>  extern void lock_release(struct lockdep_map *lock, int nested,
>  			 unsigned long ip);
> 
> +extern int lock_is_held(struct lockdep_map *lock);
> +
>  # define INIT_LOCKDEP				.lockdep_recursion = 0,
> 
>  #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
> @@ -319,6 +321,7 @@ static inline void lockdep_on(void)
> 
>  # define lock_acquire(l, s, t, r, c, i)		do { } while (0)
>  # define lock_release(l, n, i)			do { } while (0)
> +# define lock_is_held(l)			(0)
>  # define lockdep_init()				do { } while (0)
>  # define lockdep_info()				do { } while (0)
>  # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
> Index: linux-2.6/include/linux/rcupdate.h
> ===================================================================
> --- linux-2.6.orig/include/linux/rcupdate.h
> +++ linux-2.6/include/linux/rcupdate.h
> @@ -138,9 +138,11 @@ extern int rcu_needs_cpu(int cpu);
>  extern struct lockdep_map rcu_lock_map;
>  # define rcu_read_acquire()	lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
>  # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
> +# define rcu_read_held()	WARN_ON_ONCE(!lock_is_held(&rcu_lock_map))
>  #else
>  # define rcu_read_acquire()	do { } while (0)
>  # define rcu_read_release()	do { } while (0)
> +# define rcu_read_held()	do { } while (0)
>  #endif
> 
>  /**
> @@ -216,6 +218,7 @@ extern struct lockdep_map rcu_lock_map;
>  	do { \
>  		local_bh_disable(); \
>  		__acquire(RCU_BH); \
> +		rcu_read_acquire(); \
>  	} while(0)
> 
>  /*
> @@ -225,6 +228,7 @@ extern struct lockdep_map rcu_lock_map;
>   */
>  #define rcu_read_unlock_bh() \
>  	do { \
> +		rcu_read_release(); \
>  		__release(RCU_BH); \
>  		local_bh_enable(); \
>  	} while(0)
> @@ -254,6 +258,7 @@ extern struct lockdep_map rcu_lock_map;
>  #define rcu_dereference(p)     ({ \
>  				typeof(p) _________p1 = ACCESS_ONCE(p); \
>  				smp_read_barrier_depends(); \
> +				rcu_read_held(); \
>  				(_________p1); \
>  				})
> 
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -2624,6 +2624,36 @@ static int lock_release_nested(struct ta
>  	return 1;
>  }
> 
> +static int __lock_is_held(struct lockdep_map *lock)
> +{
> +	struct task_struct *curr = current;
> +	struct held_lock *hlock, *prev_hlock;
> +	unsigned int depth;
> +       	int i;
> +
> +	/*
> +	 * Check whether the lock exists in the current stack
> +	 * of held locks:
> +	 */
> +	depth = curr->lockdep_depth;
> +	if (DEBUG_LOCKS_WARN_ON(!depth))
> +		return 0;
> +
> +	prev_hlock = NULL;
> +	for (i = depth-1; i >= 0; i--) {
> +		hlock = curr->held_locks + i;
> +		/*
> +		 * We must not cross into another context:
> +		 */
> +		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
> +			break;
> +		if (hlock->instance == lock)
> +			return 1;
> +		prev_hlock = hlock;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Remove the lock to the list of currently held locks - this gets
>   * called on mutex_unlock()/spin_unlock*() (or on a failed
> @@ -2727,6 +2757,29 @@ void lock_release(struct lockdep_map *lo
> 
>  EXPORT_SYMBOL_GPL(lock_release);
> 
> +int lock_is_held(struct lockdep_map *lock)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	if (unlikely(!lock_stat && !prove_locking))
> +		return 0;
> +
> +	if (unlikely(current->lockdep_recursion))
> +		return -EBUSY;
> +
> +	raw_local_irq_save(flags);
> +	check_flags(flags);
> +	current->lockdep_recursion = 1;
> +	ret = __lock_is_held(lock);
> +	current->lockdep_recursion = 0;
> +	raw_local_irq_restore(flags);
> +
> +	return ret;
> +}
> +
> +EXPORT_SYMBOL_GPL(lock_is_held);
> +
>  #ifdef CONFIG_LOCK_STAT
>  static int
>  print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
