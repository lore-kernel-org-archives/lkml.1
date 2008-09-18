Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYIRGpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYIRGpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 02:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYIRGo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 02:44:58 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33810 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYIRGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 02:44:58 -0400
Date: Wed, 17 Sep 2008 23:44:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, manfred@colorfullife.com
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
Message-ID: <20080918064406.GC6397@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48D1D694.9010802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D1D694.9010802@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 12:18:28PM +0800, Lai Jiangshan wrote:
> 
> sometimes a rcu callback is just calling kfree() to free a struct's memory
> (we say this callback is a trivial callback.).
> this patch introduce kfree_rcu() to do these things directly, easily.

Interesting!  Please see questions and comments below.

> There are 4 reasons that we need kfree_rcu():
> 
> 1) unloadable modules:
>    a module(rcu callback is defined in this module) using rcu must
>    call rcu_barrier() when unload. rcu_barrier() will increase
>    the system's overhead(the more cpus the worse) and
>    rcu_barrier() is very time-consuming. if all rcu callback defined
>    in this module are trivial callback, we can just call kfree_rcu()
>    instead, save a rcu_barrier() when unload.

You lost me on this one.  Suppose that the following sequence of
events occurred:

a.	The module invokes call_rcu() or kfree_rcu().  The callback
	is queued on CPU 0.

b.	Perhaps a grace period completes, and the callback is therefore
	moved to CPU 0's donelist.  But CPU 0 is busy, so doesn't get
	around to invoking the callback.  (For example, ksoftirqd.)

c.	The module is unloaded, and uses kfree_rcu() instead of
	rcu_barrier().  The callback is queued on CPU 1.

d.	A grace period completes, and CPU 1 is relatively idle, so
	invokes its callback quickly.  The module is therefore unloaded.

e.	CPU 0 finally gets around to executing its callback, but the
	module has been unloaded, so there is nothingness where the
	callback function used to be.  We get an oops.

What prevents this sequence of events from happening?

> 2) duplicate code:
>    all trivial callback are duplicate code though the structs to be freed
>    are different. it's just a container_of() and a kfree().
>    There are about 50% callbacks are trivial callbacks for call_rcu() in
>    current kernel code.

Indeed!  There was something similar to kfree_rcu() proposed some
years back, but it was rejected because it contained more code than
did the trivial callbacks.  :-/

But there are more such callbacks these days, so might be worth
revisiting.

> 3) cache:
>    the instructions of trivial callback is not in the cache supposedly.
>    calling a trivial callback will let to cache missing very likely.
>    the more trivial callback the more cache missing. OK, this is
>    not a problem now or in a few days: Only less than 1% trivial callback
>    are called in running kernel.

Reducing code footprint would be a good thing.  Do you have stats on
the kernel text size, before and after?

> 4) future:
>    the number of user of rcu is increasing. new code for rcu is
>    trivial callback very likely. it means more modules using rcu
>    and more duplicate code(may come to 90% of callbacks is trivial
>    callbacks) and more cache missing.

Ditto.

> Implementation:
>    there were a lot of ideas came out when i implemented kfree_rcu().
>    I chose the simplest one as this patch shows. but these implementation
>    may cannot be used for to free a struct larger than 16KBytes.
> 
> kfree_rcu_bh()? kfree_rcu_sched()?
>    these two are not need current. call_rcu_bh() & call_rcu_sched()
>    are hardly be called(and hardly be called for trivial callback).
> 
> vfree_rcu()?
>    No, vfree() is not atomic function, will not be called in softirq.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index e8b4039..04c654f 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -253,4 +253,25 @@ extern void rcu_barrier_sched(void);
>  extern void rcu_init(void);
>  extern int rcu_needs_cpu(int cpu);
> 
> +#define __KFREE_RCU_MAX_OFFSET 4095
> +#define KFREE_RCU_MAX_OFFSET (sizeof(void *) * __KFREE_RCU_MAX_OFFSET)
> +
> +#define __rcu_reclaim(head) \
> +do { \
> +	unsigned long __offset = (unsigned long)head->func; \
> +	if (__offset <= __KFREE_RCU_MAX_OFFSET) \
> +		kfree((void *)head - sizeof(void *) * __offset); \
> +	else \
> +		head->func(head); \
> +} while(0)

OK, so the idea is that structures whose rcu_head is near the front
of the structure have the offset of the rcu_head put into the
->func field instead of a pointer to the callback function?

Of course, it doesn't need to be too near the beginning of the
function...

All arches are guaranteed not to have kernel text in the low 16K
of memory (for 32-bit arches) or low 32K of memory (for 64-bit arches)?

> +/**
> + * kfree_rcu - free previously allocated memory after a grace period.
> + * @ptr:  pointer returned by kmalloc.
> + * @head: structure to be used for queueing the RCU updates. This structure
> + *        is a part of previously allocated memory @ptr.
> + */
> +extern void kfree_rcu(const void *ptr, struct rcu_head *head);
> +
>  #endif /* __LINUX_RCUPDATE_H */
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index aad93cd..5a14190 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -232,7 +232,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
>  	while (list) {
>  		next = list->next;
>  		prefetch(next);
> -		list->func(list);
> +		__rcu_reclaim(list);

OK, consistent with above.

>  		list = next;
>  		if (++count >= rdp->blimit)
>  			break;
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 467d594..aa9b56a 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -162,6 +162,18 @@ void rcu_barrier_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> 
> +void kfree_rcu(const void *ptr, struct rcu_head *head)
> +{
> +	unsigned long offset;
> +	typedef void (*rcu_callback)(struct rcu_head *);
> +
> +	offset = (void *)head - (void *)ptr;
> +	BUG_ON(offset > KFREE_RCU_MAX_OFFSET);
> +
> +	call_rcu(head, (rcu_callback)(offset / sizeof(void *)));

OK, so we pass in the pointer to the rcu_head structure, followed
by the offset in pointer-sized units, but with the latter cast to
a pointer to a callback function?  Hmmm....  Kinky....

Then after the grace period completes, the __rcu_reclaim() sorts
things out.

> +}
> +EXPORT_SYMBOL_GPL(kfree_rcu);
> +
>  void __init rcu_init(void)
>  {
>  	__rcu_init();
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index 2782793..62a9e54 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -1108,7 +1108,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  	while (list) {
>  		next = list->next;
> -		list->func(list);
> +		__rcu_reclaim(list);

And we do this for preemptable RCU as well.

>  		list = next;
>  		RCU_TRACE_ME(rcupreempt_trace_invoke);
>  	}
> 
