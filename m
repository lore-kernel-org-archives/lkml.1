Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZI2O5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZI2O5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZI2O47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:56:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37885 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZI2O46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:56:58 -0400
Date: Tue, 29 Sep 2009 07:56:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 3/3] rcu: make hot-unplugged CPU relinquish
	its own RCU callbacks
Message-ID: <20090929145653.GA6237@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090929135017.GB22112@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929135017.GB22112@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 09:50:17AM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > The current interaction between RCU and CPU hotplug requires that
> > RCU block in CPU notifiers waiting for callbacks to drain.  This can
> > be greatly simplified by haing each CPU relinquish its own callbacks,
> 
> "having"

I plead jet lag.

> > and for both _rcu_barrier() and CPU_DEAD notifiers to adopt all callbacks
> > that were previously relinquished.  This change also eliminates the
> > possibility of certain types of hangs due to the previous practice of
> > waiting for callbacks to be invoked from within CPU notifiers.  If you
> > don't every wait, you cannot hang.
> 
> "ever"

Twice.  ;-)

> This idea reminds me a discussion we had at Plumbers, good ! ;)
> 
> Simplification of RCU vs CPU hotplug interaction will clearly be
> welcome. How does it deal with many processors going offline at once
> while the system is under large RCU callback queue loads ?

Right now, the "orphan" variables are protected by the rcu_state
structure's ->onofflock spinlock.  The code appends the CPU's callbacks
to whatever is already on the orphan list, so it should work in this
case.  If multiple CPUs go offline, they will serialize appending
their callbacks onto the orphan list.

This single lock might well turn out to be a scalability bottleneck,
but someone is going to have to demonstrate this to me before I would
be willing to complicate the code to increase scalability.

> I guess the rationale for letting cpu hotplug wait for callback
> execution being going offline is close to telling a CPU : "you asked for
> this callback to be executed, well, _you_ do it before going to sleep.
> And no, don't try to push this task on your little brothers."

Not only that, but I am getting really paranoid about RCU and CPU
hotplug waiting on each other.  Getting some hangs that this patchset
seems to fix.

> The only problem I see here is that a CPU could really load up the
> system and, in the worse case scenario, never execute its own callbacks
> and let the others do the work. Have you considered this issue ?

Hmmmm...  The only way I can see for this to happen is for the CPU to
generate a bunch of callbacks, be taken offline, be brought online,
generate more callbacks, and so on.  The thing to remember is that
it typically takes longer than a grace period to take a CPU offline
and bring it back online, so callbacks should not normally "pile up".

> (haha ! just seen the "orphan" variables _after_ writing this up) ;)

;-)

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c        |  151 ++++++++++++++++++++++++----------------------
> >  kernel/rcutree.h        |   11 +++-
> >  kernel/rcutree_plugin.h |   34 +++++++++++
> >  kernel/rcutree_trace.c  |    4 +-
> >  4 files changed, 125 insertions(+), 75 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 678b2e2..13b016b 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -62,6 +62,9 @@
> >  	.gpnum = -300, \
> >  	.completed = -300, \
> >  	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
> > +	.orphan_cbs_list = NULL, \
> > +	.orphan_cbs_tail = &name.orphan_cbs_list, \
> > +	.orphan_qlen = 0, \
> >  	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
> >  	.n_force_qs = 0, \
> >  	.n_force_qs_ngp = 0, \
> > @@ -833,17 +836,63 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  
> >  /*
> > + * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
> > + * specified flavor of RCU.  The callbacks will be adopted by the next
> > + * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
> > + * comes first.  Because this is invoked from the CPU_DYING notifier,
> > + * irqs are already disabled.
> > + */
> > +static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> > +{
> > +	int i;
> > +	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
> > +
> > +	if (rdp->nxtlist == NULL)
> > +		return;  /* irqs disabled, so comparison is stable. */
> > +	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
> > +	*rsp->orphan_cbs_tail = rdp->nxtlist;
> > +	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
> > +	rdp->nxtlist = NULL;
> > +	for (i = 0; i < RCU_NEXT_SIZE; i++)
> > +		rdp->nxttail[i] = &rdp->nxtlist;
> > +	rsp->orphan_qlen += rdp->qlen;
> > +	rdp->qlen = 0;
> > +	spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
> > +}
> > +
> > +/*
> > + * Adopt previously orphaned RCU callbacks.
> > + */
> > +static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
> > +{
> > +	unsigned long flags;
> > +	struct rcu_data *rdp;
> > +
> > +	spin_lock_irqsave(&rsp->onofflock, flags);
> > +	rdp = rsp->rda[smp_processor_id()];
> > +	if (rsp->orphan_cbs_list == NULL) {
> > +		spin_unlock_irqrestore(&rsp->onofflock, flags);
> > +		return;
> > +	}
> > +	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
> > +	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
> > +	rdp->qlen += rsp->orphan_qlen;
> > +	rsp->orphan_cbs_list = NULL;
> > +	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
> > +	rsp->orphan_qlen = 0;
> > +	spin_unlock_irqrestore(&rsp->onofflock, flags);
> > +}
> > +
> > +/*
> >   * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
> >   * and move all callbacks from the outgoing CPU to the current one.
> >   */
> >  static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
> >  {
> > -	int i;
> >  	unsigned long flags;
> >  	long lastcomp;
> >  	unsigned long mask;
> >  	struct rcu_data *rdp = rsp->rda[cpu];
> > -	struct rcu_data *rdp_me;
> >  	struct rcu_node *rnp;
> >  
> >  	/* Exclude any attempts to start a new grace period. */
> > @@ -866,32 +915,9 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
> >  	} while (rnp != NULL);
> >  	lastcomp = rsp->completed;
> >  
> > -	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
> > +	spin_unlock_irqrestore(&rsp->onofflock, flags);
> >  
> > -	/*
> > -	 * Move callbacks from the outgoing CPU to the running CPU.
> > -	 * Note that the outgoing CPU is now quiescent, so it is now
> > -	 * (uncharacteristically) safe to access its rcu_data structure.
> > -	 * Note also that we must carefully retain the order of the
> > -	 * outgoing CPU's callbacks in order for rcu_barrier() to work
> > -	 * correctly.  Finally, note that we start all the callbacks
> > -	 * afresh, even those that have passed through a grace period
> > -	 * and are therefore ready to invoke.  The theory is that hotplug
> > -	 * events are rare, and that if they are frequent enough to
> > -	 * indefinitely delay callbacks, you have far worse things to
> > -	 * be worrying about.
> > -	 */
> > -	if (rdp->nxtlist != NULL) {
> > -		rdp_me = rsp->rda[smp_processor_id()];
> > -		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
> > -		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> > -		rdp->nxtlist = NULL;
> > -		for (i = 0; i < RCU_NEXT_SIZE; i++)
> > -			rdp->nxttail[i] = &rdp->nxtlist;
> > -		rdp_me->qlen += rdp->qlen;
> > -		rdp->qlen = 0;
> > -	}
> > -	local_irq_restore(flags);
> > +	rcu_adopt_orphan_cbs(rsp);
> >  }
> >  
> >  /*
> > @@ -909,6 +935,14 @@ static void rcu_offline_cpu(int cpu)
> >  
> >  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> >  
> > +static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> > +{
> > +}
> > +
> > +static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
> > +{
> > +}
> > +
> >  static void rcu_offline_cpu(int cpu)
> >  {
> >  }
> > @@ -1362,9 +1396,6 @@ static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
> >  static atomic_t rcu_barrier_cpu_count;
> >  static DEFINE_MUTEX(rcu_barrier_mutex);
> >  static struct completion rcu_barrier_completion;
> > -static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
> > -static struct rcu_head rcu_migrate_head[3];
> > -static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
> >  
> >  static void rcu_barrier_callback(struct rcu_head *notused)
> >  {
> > @@ -1387,21 +1418,16 @@ static void rcu_barrier_func(void *type)
> >  	call_rcu_func(head, rcu_barrier_callback);
> >  }
> >  
> > -static inline void wait_migrated_callbacks(void)
> > -{
> > -	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
> > -	smp_mb(); /* In case we didn't sleep. */
> > -}
> > -
> >  /*
> >   * Orchestrate the specified type of RCU barrier, waiting for all
> >   * RCU callbacks of the specified type to complete.
> >   */
> > -static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
> > +static void _rcu_barrier(struct rcu_state *rsp,
> > +			 void (*call_rcu_func)(struct rcu_head *head,
> >  					       void (*func)(struct rcu_head *head)))
> >  {
> >  	BUG_ON(in_interrupt());
> > -	/* Take cpucontrol mutex to protect against CPU hotplug */
> > +	/* Take mutex to serialize concurrent rcu_barrier() requests. */
> >  	mutex_lock(&rcu_barrier_mutex);
> >  	init_completion(&rcu_barrier_completion);
> >  	/*
> > @@ -1414,29 +1440,22 @@ static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
> >  	 * early.
> >  	 */
> >  	atomic_set(&rcu_barrier_cpu_count, 1);
> > +	preempt_disable(); /* stop CPU_DYING from filling orphan_cbs_list */
> > +	rcu_adopt_orphan_cbs(rsp);
> >  	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
> > +	preempt_enable(); /* CPU_DYING can again fill orphan_cbs_list */
> >  	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
> >  		complete(&rcu_barrier_completion);
> >  	wait_for_completion(&rcu_barrier_completion);
> >  	mutex_unlock(&rcu_barrier_mutex);
> > -	wait_migrated_callbacks();
> > -}
> > -
> > -/**
> > - * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
> > - */
> > -void rcu_barrier(void)
> > -{
> > -	_rcu_barrier(call_rcu);
> >  }
> > -EXPORT_SYMBOL_GPL(rcu_barrier);
> >  
> >  /**
> >   * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
> >   */
> >  void rcu_barrier_bh(void)
> >  {
> > -	_rcu_barrier(call_rcu_bh);
> > +	_rcu_barrier(&rcu_bh_state, call_rcu_bh);
> >  }
> >  EXPORT_SYMBOL_GPL(rcu_barrier_bh);
> >  
> > @@ -1445,16 +1464,10 @@ EXPORT_SYMBOL_GPL(rcu_barrier_bh);
> >   */
> >  void rcu_barrier_sched(void)
> >  {
> > -	_rcu_barrier(call_rcu_sched);
> > +	_rcu_barrier(&rcu_sched_state, call_rcu_sched);
> >  }
> >  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> >  
> > -static void rcu_migrate_callback(struct rcu_head *notused)
> > -{
> > -	if (atomic_dec_and_test(&rcu_migrate_type_count))
> > -		wake_up(&rcu_migrate_wq);
> > -}
> > -
> >  /*
> >   * Do boot-time initialization of a CPU's per-CPU RCU data.
> >   */
> > @@ -1551,27 +1564,21 @@ int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> >  	case CPU_UP_PREPARE_FROZEN:
> >  		rcu_online_cpu(cpu);
> >  		break;
> > -	case CPU_DOWN_PREPARE:
> > -	case CPU_DOWN_PREPARE_FROZEN:
> > -		/* Don't need to wait until next removal operation. */
> > -		/* rcu_migrate_head is protected by cpu_add_remove_lock */
> > -		wait_migrated_callbacks();
> > -		break;
> >  	case CPU_DYING:
> >  	case CPU_DYING_FROZEN:
> >  		/*
> > -		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
> > +		 * preempt_disable() in _rcu_barrier() prevents stop_machine(),
> >  		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
> > -		 * returns, all online cpus have queued rcu_barrier_func(),
> > -		 * and the dead cpu(if it exist) queues rcu_migrate_callback()s.
> > -		 *
> > -		 * These callbacks ensure _rcu_barrier() waits for all
> > -		 * RCU callbacks of the specified type to complete.
> > +		 * returns, all online cpus have queued rcu_barrier_func().
> > +		 * The dying CPU clears its cpu_online_mask bit and
> > +		 * moves all of its RCU callbacks to ->orphan_cbs_list
> > +		 * in the context of stop_machine(), so subsequent calls
> > +		 * to _rcu_barrier() will adopt these callbacks and only
> > +		 * then queue rcu_barrier_func() on all remaining CPUs.
> >  		 */
> > -		atomic_set(&rcu_migrate_type_count, 3);
> > -		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
> > -		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
> > -		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
> > +		rcu_send_cbs_to_orphanage(&rcu_bh_state);
> > +		rcu_send_cbs_to_orphanage(&rcu_sched_state);
> > +		rcu_preempt_send_cbs_to_orphanage();
> >  		break;
> >  	case CPU_DEAD:
> >  	case CPU_DEAD_FROZEN:
> > diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> > index 676eecd..b40ac57 100644
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -244,7 +244,15 @@ struct rcu_state {
> >  	/* End  of fields guarded by root rcu_node's lock. */
> >  
> >  	spinlock_t onofflock;			/* exclude on/offline and */
> > -						/*  starting new GP. */
> > +						/*  starting new GP.  Also */
> > +						/*  protects the following */
> > +						/*  orphan_cbs fields. */
> > +	struct rcu_head *orphan_cbs_list;	/* list of rcu_head structs */
> > +						/*  orphaned by all CPUs in */
> > +						/*  a given leaf rcu_node */
> > +						/*  going offline. */
> > +	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
> > +	long orphan_qlen;			/* Number of orphaned cbs. */
> >  	spinlock_t fqslock;			/* Only one task forcing */
> >  						/*  quiescent states. */
> >  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
> > @@ -305,6 +313,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
> >  static int rcu_preempt_pending(int cpu);
> >  static int rcu_preempt_needs_cpu(int cpu);
> >  static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
> > +static void rcu_preempt_send_cbs_to_orphanage(void);
> >  static void __init __rcu_init_preempt(void);
> >  
> >  #endif /* #else #ifdef RCU_TREE_NONCORE */
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index d88dfd3..2fa3f39 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -411,6 +411,15 @@ static int rcu_preempt_needs_cpu(int cpu)
> >  	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
> >  }
> >  
> > +/**
> > + * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
> > + */
> > +void rcu_barrier(void)
> > +{
> > +	_rcu_barrier(&rcu_preempt_state, call_rcu);
> > +}
> > +EXPORT_SYMBOL_GPL(rcu_barrier);
> > +
> >  /*
> >   * Initialize preemptable RCU's per-CPU data.
> >   */
> > @@ -420,6 +429,14 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
> >  }
> >  
> >  /*
> > + * Move preemptable RCU's callbacks to ->orphan_cbs_list.
> > + */
> > +static void rcu_preempt_send_cbs_to_orphanage(void)
> > +{
> > +	rcu_send_cbs_to_orphanage(&rcu_preempt_state);
> > +}
> > +
> > +/*
> >   * Initialize preemptable RCU's state structures.
> >   */
> >  static void __init __rcu_init_preempt(void)
> > @@ -565,6 +582,16 @@ static int rcu_preempt_needs_cpu(int cpu)
> >  }
> >  
> >  /*
> > + * Because preemptable RCU does not exist, rcu_barrier() is just
> > + * another name for rcu_barrier_sched().
> > + */
> > +void rcu_barrier(void)
> > +{
> > +	rcu_barrier_sched();
> > +}
> > +EXPORT_SYMBOL_GPL(rcu_barrier);
> > +
> > +/*
> >   * Because preemptable RCU does not exist, there is no per-CPU
> >   * data to initialize.
> >   */
> > @@ -573,6 +600,13 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
> >  }
> >  
> >  /*
> > + * Because there is no preemptable RCU, there are no callbacks to move.
> > + */
> > +static void rcu_preempt_send_cbs_to_orphanage(void)
> > +{
> > +}
> > +
> > +/*
> >   * Because preemptable RCU does not exist, it need not be initialized.
> >   */
> >  static void __init __rcu_init_preempt(void)
> > diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> > index f09af28..4b31c77 100644
> > --- a/kernel/rcutree_trace.c
> > +++ b/kernel/rcutree_trace.c
> > @@ -159,13 +159,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
> >  	struct rcu_node *rnp;
> >  
> >  	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
> > -		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
> > +		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
> >  		   rsp->completed, rsp->gpnum, rsp->signaled,
> >  		   (long)(rsp->jiffies_force_qs - jiffies),
> >  		   (int)(jiffies & 0xffff),
> >  		   rsp->n_force_qs, rsp->n_force_qs_ngp,
> >  		   rsp->n_force_qs - rsp->n_force_qs_ngp,
> > -		   rsp->n_force_qs_lh);
> > +		   rsp->n_force_qs_lh, rsp->orphan_qlen);
> >  	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
> >  		if (rnp->level != level) {
> >  			seq_puts(m, "\n");
> > -- 
> > 1.5.2.5
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
