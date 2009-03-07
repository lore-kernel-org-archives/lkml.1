Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbZCGFcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbZCGFcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZCGFb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:31:59 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51471 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbZCGFb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:31:58 -0500
Date: Fri, 6 Mar 2009 21:31:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: introduce kfree_rcu V3
Message-ID: <20090307053154.GA10625@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49AD342D.6030609@cn.fujitsu.com> <20090303140955.GD23822@elte.hu> <49AE484C.8020801@cn.fujitsu.com> <20090304114504.GB4916@elte.hu> <84144f020903040400m5a77fc4p2b09796e1111c3b9@mail.gmail.com> <49B0F9AF.7060800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B0F9AF.7060800@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 06:23:43PM +0800, Lai Jiangshan wrote:
> Pekka Enberg wrote:
> > On Wed, Mar 4, 2009 at 1:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>> This is one of patches I test kfree_rcu().
> >>> And it could be an example conversions of this facility.
> >>>
> >>> ---
> >>>  arch/ia64/sn/kernel/irq.c           |   14 +-----------
> >>>  block/genhd.c                       |   10 --------
> >>>  ipc/sem.c                           |   10 +-------
> >>>  kernel/audit_tree.c                 |    8 ------
> >>>  kernel/cgroup.c                     |    9 -------
> >>>  kernel/smp.c                        |   11 ---------
> >>>  mm/vmalloc.c                        |   18 +--------------
> >>>  net/can/af_can.c                    |   14 +-----------
> >>>  net/core/gen_estimator.c            |    9 -------
> >>>  net/core/net_namespace.c            |   10 --------
> >>>  net/ipv4/fib_trie.c                 |    7 ------
> >>>  net/ipv6/addrconf.c                 |   10 --------
> >>>  net/netfilter/nf_conntrack_extend.c |    8 ------
> >>>  net/netlabel/netlabel_unlabeled.c   |   42 +-----------------------------------
> >>>  security/device_cgroup.c            |   10 --------
> >>>  security/keys/keyring.c             |   15 ------------
> >>>  security/keys/user_defined.c        |   18 +--------------
> >>>  security/selinux/netif.c            |   18 ---------------
> >>>  security/selinux/netnode.c          |   20 +----------------
> >>>  security/selinux/netport.c          |   20 +----------------
> >>>  20 files changed, 28 insertions(+), 253 deletions(-)
> >> Looks convincing to me but Nick does not like the extra SLAB
> >> field it uses :-/
> > 
> > FWIW, I'm fine with the patch series. One option for SLQB is to just
> > remove slab coloring as I've suggested in the past (the performance
> > benefit with current cpu caches is questionable).
> > 
> >                                      Pekka
> > 
> > 
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> There are 23 instances where the rcu callback just does
> 
> 	kfree(containerof(head,struct whatever_struct,rcu_member));
> 
> The 23 instances exist because there are 23 'struct whatever_struct' with
> their individual rcu_member. These patches creates a generic kfree_rcu()
> function that removes the need for these 23 helpers.
> 
> The number of this kind of rcu callback will increase, for this is the
> most common way to use rcu and define rcu callback.
> 
> And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
> queue any function which belong to the module, so a rcu_barrier() can
> be avoid when module exit. (If we queue any other function by call_rcu(),
> rcu_barrier() is still needed.)
> 
> Changed From V2:
> 
> Implement kfree_rcu() in rcu subsystem again.
> 
> The object pointer is stored in head->func instead of the
> function pointer, and these rcu head(which are the same batch)
> are queued in a list(per_cpu list). When a batch's grace period
> is completed, the objects in this batch are freed, and then
> we process the next batch(if next batch not empty).
> 
> Changlog V1 -> V2:
> 1) Implement kfree_rcu() in slab layer.
>    In V1, the offset from the container struct to the rcu member
>    is calculated at compile time and stored in head->func instead of the
>    function pointer. This disarrange rcu's algorithm a little, there is
>    no bad side effect when we implement kfree_rcu() in slab layer.
> 
> 2) kfree_rcu() API is changed, use the version that Manfred Spraul designed.
>    This one allows compiler do more checking.

With the double rcu_barrier() replaced by copy to current CPU, and
comments added:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 24c5602..2a8d5a4 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -130,6 +130,20 @@ void kfree(const void *);
>  void kzfree(const void *);
>  size_t ksize(const void *);
> 
> +struct rcu_head;
> +void __kfree_rcu(const void *, struct rcu_head *);
> +
> +/**
> + * kfree_rcu - kfree after a grace period
> + * @ptr: pointer to kfree
> + * @rcu_member: name of the struct rcu_head member.
> + *
> + * Many rcu callbacks just call kfree() on the base structure. This helper
> + * function calls kfree internally. The rcu_head structure must be embedded
> + * in the to be freed structure.
> + */
> +#define kfree_rcu(ptr, rcu_member)	__kfree_rcu((ptr), &(ptr)->rcu_member)
> +
>  /*
>   * Allocator specific definitions. These are mainly used to establish optimized
>   * ways to convert kmalloc() calls to kmem_cache_alloc() invocations by
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index d92a76a..753f10a 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -170,8 +170,91 @@ void rcu_barrier_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> 
> +struct kfree_rcu_cpuwork {
> +	struct rcu_head rcu_head;
> +	struct rcu_head *curr_head;
> +	struct rcu_head *next_head, **next_tail;
> +};

Hmmm...  So ->rcu_head is the callback that kfree_rcu hands to RCU,
->curr_head is the list waiting for the current grace period, and
->next_head is the list whose grace period will start once curr_head's
grace period completes.  Then ->next_tail is the place we enqueue the
callbacks, initially pointing to ->next_head.

> +
> +static void kfree_rcu_advance_batch(struct kfree_rcu_cpuwork *work);
> +
> +static void kfree_rcu_batch_callback(struct rcu_head *rcu_head)
> +{
> +	unsigned long flags;
> +	struct rcu_head *list;
> +	struct kfree_rcu_cpuwork *work = container_of(rcu_head,
> +			struct kfree_rcu_cpuwork, rcu_head);
> +
> +	local_irq_save(flags);
> +	list = work->curr_head;
> +	work->curr_head = NULL;
> +	kfree_rcu_advance_batch(work);
> +	local_irq_restore(flags);
> +
> +	while (list) {
> +		struct rcu_head *next = list->next;
> +		prefetch(next);
> +		kfree((void *)(unsigned long)list->func);
> +		list = next;
> +	}
> +}

We will need to keep an eye on the above loop.  Other loops like it in
RCU have usually ended up having limits to avoid hogging ksoftirqd...
Of course, that would break the double-rcu_barrier() scheme below,
which might be another reason to change as noted below.  However, in
absence of data indicating a problem, I don't see a reason to change
it.  Others might ask for some sort of tracing assist here.

At the very least, a comment is needed.  Otherwise, some poor slob is
going to add a count-and-defer-work scheme above, and end up with a
difficult-to-track-down oddball memory leak associated with CPU hotplug.

If ksoftirqd got going, I guess we could have the second RCU callback
get done with its grace period before the above loop terminated (at
least when running preemptible RCU), but I cannot see how that hurts
anything other than my head.  The second RCU callback could not start
executing until the first one completed.  Something to be careful of if
implementing a count-and-defer-work scheme, of course.

> +static void kfree_rcu_advance_batch(struct kfree_rcu_cpuwork *work)
> +{
> +	if (!work->curr_head && work->next_head) {
> +		work->curr_head = work->next_head;
> +		work->next_head = NULL;
> +		work->next_tail = &work->next_head;
> +
> +		call_rcu(&work->rcu_head, kfree_rcu_batch_callback);
> +	}
> +}
> +
> +static DEFINE_PER_CPU(struct kfree_rcu_cpuwork, kfree_rcu_work);
> +
> +void __kfree_rcu(const void *obj, struct rcu_head *rcu)
> +{
> +	unsigned long flags;
> +	struct kfree_rcu_cpuwork *work;
> +
> +	rcu->func = (typeof(rcu->func))(unsigned long)obj;
> +	rcu->next = NULL;
> +
> +	local_irq_save(flags);
> +	work = &__get_cpu_var(kfree_rcu_work);
> +	*work->next_tail = rcu;
> +	work->next_tail = &rcu->next;
> +	kfree_rcu_advance_batch(work);
> +	local_irq_restore(flags);
> +}
> +EXPORT_SYMBOL(__kfree_rcu);
> +
> +static int __cpuinit kfree_rcu_cpu_notify(struct notifier_block *self,
> +		unsigned long action, void *hcpu)
> +{
> +	if (action == CPU_POST_DEAD) {
> +		rcu_barrier();
> +		rcu_barrier();

OK, we are still under the cpu_add_remove_lock, so we should not race
with this same CPU coming back online.  This is a bit slow, however.
Why not track the tail of both the ->rcu_curr and ->rcu_next lists,
then append them to the currently running CPU's list?  That would be
quite fast, would be pretty simple (and -very- obviously correct),
and would not require any locking.

(Yes, you could loop doing rcu_barrier() until the lists were empty,
but please don't!)

> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static void __init kfree_rcu_init(void)
> +{
> +	int cpu;
> +	struct kfree_rcu_cpuwork *work;
> +
> +	for_each_possible_cpu(cpu) {
> +		work = &per_cpu(kfree_rcu_work, cpu);
> +		work->next_tail = &work->next_head;
> +	}
> +
> +	hotcpu_notifier(kfree_rcu_cpu_notify, 0);
> +}
> +
>  void __init rcu_init(void)
>  {
> +	kfree_rcu_init();
>  	__rcu_init();
>  }

Well, I guess we now need the __rcu_init() indirection.  Guess it was
a good thing I was too lazy to get that removed quickly.  ;-)
