Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbXISXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbXISXGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbXISXGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:06:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47324 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXISXGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:06:32 -0400
Date: Wed, 19 Sep 2007 16:06:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 1/6] lockdep: annotate rcu_read_{,un}lock{,_bh}
Message-ID: <20070919230624.GI8666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070919104125.286538000@chello.nl> <20070919105054.065225000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919105054.065225000@chello.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 12:41:26PM +0200, Peter Zijlstra wrote:
> lockdep annotate rcu_read_{,un}lock{,_bh} in order to catch imbalanced
> usage.

In my message yesterday, I forgot about srcu_read_lock() and
srcu_read_unlock().  :-/ Here is a proto-patch, untested,
probably does not compile.

One interesting side-effect of the overall patch is that one must select
CONFIG_PREEMPT in order for a CONFIG_DEBUG_LOCK_ALLOC build to compile.
Might be OK, but thought I should mention it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff -urpNa -X dontdiff linux-2.6.22-rcudep/kernel/srcu.c linux-2.6.22-srcudep/kernel/srcu.c
--- linux-2.6.22-rcudep/kernel/srcu.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-srcudep/kernel/srcu.c	2007-09-19 12:50:00.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/srcu.h>
+#include <linux/rcupdate.h>
 
 /**
  * init_srcu_struct - initialize a sleep-RCU structure
@@ -116,6 +117,7 @@ int srcu_read_lock(struct srcu_struct *s
 	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]++;
 	srcu_barrier();  /* ensure compiler won't misorder critical section. */
 	preempt_enable();
+	rcu_read_acquire();
 	return idx;
 }
 
@@ -131,6 +133,7 @@ int srcu_read_lock(struct srcu_struct *s
  */
 void srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
+	rcu_read_release();
 	preempt_disable();
 	srcu_barrier();  /* ensure compiler won't misorder critical section. */
 	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h  |    7 +++++++
>  include/linux/rcupdate.h |   12 ++++++++++++
>  kernel/rcupdate.c        |    8 ++++++++
>  3 files changed, 27 insertions(+)
> 
> Index: linux-2.6/include/linux/lockdep.h
> ===================================================================
> --- linux-2.6.orig/include/linux/lockdep.h
> +++ linux-2.6/include/linux/lockdep.h
> @@ -252,6 +252,13 @@ extern void lockdep_init_map(struct lock
>  			     struct lock_class_key *key, int subclass);
> 
>  /*
> + * To initialize a lockdep_map statically use this macro.
> + * Note that _name must not be NULL.
> + */
> +#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
> +	{ .name = (_name), .key = (void *)(_key), }
> +
> +/*
>   * Reinitialize a lock key - for cases where there is special locking or
>   * special initialization of locks so that the validator gets the scope
>   * of dependencies wrong: they are either too broad (they need a class-split)
> Index: linux-2.6/include/linux/rcupdate.h
> ===================================================================
> --- linux-2.6.orig/include/linux/rcupdate.h
> +++ linux-2.6/include/linux/rcupdate.h
> @@ -41,6 +41,7 @@
>  #include <linux/percpu.h>
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
> +#include <linux/lockdep.h>
> 
>  /**
>   * struct rcu_head - callback structure for use with RCU
> @@ -133,6 +134,15 @@ static inline void rcu_bh_qsctr_inc(int 
>  extern int rcu_pending(int cpu);
>  extern int rcu_needs_cpu(int cpu);
> 
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +extern struct lockdep_map rcu_lock_map;
> +# define rcu_read_acquire()	lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
> +# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
> +#else
> +# define rcu_read_acquire()	do { } while (0)
> +# define rcu_read_release()	do { } while (0)
> +#endif
> +
>  /**
>   * rcu_read_lock - mark the beginning of an RCU read-side critical section.
>   *
> @@ -166,6 +176,7 @@ extern int rcu_needs_cpu(int cpu);
>  	do { \
>  		preempt_disable(); \
>  		__acquire(RCU); \
> +		rcu_read_acquire(); \
>  	} while(0)
> 
>  /**
> @@ -175,6 +186,7 @@ extern int rcu_needs_cpu(int cpu);
>   */
>  #define rcu_read_unlock() \
>  	do { \
> +		rcu_read_release(); \
>  		__release(RCU); \
>  		preempt_enable(); \
>  	} while(0)
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
> Index: linux-2.6/kernel/rcupdate.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcupdate.c
> +++ linux-2.6/kernel/rcupdate.c
> @@ -48,6 +48,14 @@
>  #include <linux/cpu.h>
>  #include <linux/mutex.h>
> 
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +static struct lock_class_key rcu_lock_key;
> +struct lockdep_map rcu_lock_map =
> +	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
> +
> +EXPORT_SYMBOL_GPL(rcu_lock_map);
> +#endif
> +
>  /* Definition for rcupdate control block. */
>  static struct rcu_ctrlblk rcu_ctrlblk = {
>  	.cur = -300,
> 
> --
> 
