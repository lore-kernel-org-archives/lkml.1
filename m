Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbZJGM4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbZJGM4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbZJGM4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:56:16 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:54249 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933079AbZJGM4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:56:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAC8mzEpMROOX/2dsb2JhbACBUtNdhCoE
Date: Wed, 7 Oct 2009 08:55:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: make hot-unplugged CPU
	relinquish its own RCU callbacks
Message-ID: <20091007125535.GA29632@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:55:17 up 49 days, 23:44,  2 users,  load average: 0.06, 0.20,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> The current interaction between RCU and CPU hotplug requires that
> RCU block in CPU notifiers waiting for callbacks to drain.  This can
> be greatly simplified by haing each CPU relinquish its own callbacks,
> and for both _rcu_barrier() and CPU_DEAD notifiers to adopt all callbacks
> that were previously relinquished.  This change also eliminates the
> possibility of certain types of hangs due to the previous practice of
> waiting for callbacks to be invoked from within CPU notifiers.  If you
> don't every wait, you cannot hang.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  kernel/rcutree.c        |  151 ++++++++++++++++++++++++----------------------
>  kernel/rcutree.h        |   11 +++-
>  kernel/rcutree_plugin.h |   34 +++++++++++
>  kernel/rcutree_trace.c  |    4 +-
>  4 files changed, 125 insertions(+), 75 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0108570..d8d9865 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -63,6 +63,9 @@
>  	.gpnum = -300, \
>  	.completed = -300, \
>  	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
> +	.orphan_cbs_list = NULL, \
> +	.orphan_cbs_tail = &name.orphan_cbs_list, \
> +	.orphan_qlen = 0, \
>  	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
>  	.n_force_qs = 0, \
>  	.n_force_qs_ngp = 0, \
> @@ -838,17 +841,63 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
>  #ifdef CONFIG_HOTPLUG_CPU
>  
>  /*
> + * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
> + * specified flavor of RCU.  The callbacks will be adopted by the next
> + * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
> + * comes first.  Because this is invoked from the CPU_DYING notifier,
> + * irqs are already disabled.
> + */
> +static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> +{
> +	int i;
> +	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
> +
> +	if (rdp->nxtlist == NULL)
> +		return;  /* irqs disabled, so comparison is stable. */
> +	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
> +	*rsp->orphan_cbs_tail = rdp->nxtlist;
> +	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
> +	rdp->nxtlist = NULL;
> +	for (i = 0; i < RCU_NEXT_SIZE; i++)
> +		rdp->nxttail[i] = &rdp->nxtlist;
> +	rsp->orphan_qlen += rdp->qlen;
> +	rdp->qlen = 0;
> +	spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
> +}
> +
> +/*
> + * Adopt previously orphaned RCU callbacks.
> + */
> +static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
> +{
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +
> +	spin_lock_irqsave(&rsp->onofflock, flags);
> +	rdp = rsp->rda[smp_processor_id()];
> +	if (rsp->orphan_cbs_list == NULL) {
> +		spin_unlock_irqrestore(&rsp->onofflock, flags);
> +		return;
> +	}
> +	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
> +	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
> +	rdp->qlen += rsp->orphan_qlen;
> +	rsp->orphan_cbs_list = NULL;
> +	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
> +	rsp->orphan_qlen = 0;
> +	spin_unlock_irqrestore(&rsp->onofflock, flags);
> +}
> +
> +/*
>   * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
>   * and move all callbacks from the outgoing CPU to the current one.
>   */
>  static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
>  {
> -	int i;
>  	unsigned long flags;
>  	long lastcomp;
>  	unsigned long mask;
>  	struct rcu_data *rdp = rsp->rda[cpu];
> -	struct rcu_data *rdp_me;
>  	struct rcu_node *rnp;
>  
>  	/* Exclude any attempts to start a new grace period. */
> @@ -871,32 +920,9 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
>  	} while (rnp != NULL);
>  	lastcomp = rsp->completed;
>  
> -	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
> +	spin_unlock_irqrestore(&rsp->onofflock, flags);
>  
> -	/*
> -	 * Move callbacks from the outgoing CPU to the running CPU.
> -	 * Note that the outgoing CPU is now quiescent, so it is now
> -	 * (uncharacteristically) safe to access its rcu_data structure.
> -	 * Note also that we must carefully retain the order of the
> -	 * outgoing CPU's callbacks in order for rcu_barrier() to work
> -	 * correctly.  Finally, note that we start all the callbacks
> -	 * afresh, even those that have passed through a grace period
> -	 * and are therefore ready to invoke.  The theory is that hotplug
> -	 * events are rare, and that if they are frequent enough to
> -	 * indefinitely delay callbacks, you have far worse things to
> -	 * be worrying about.
> -	 */
> -	if (rdp->nxtlist != NULL) {
> -		rdp_me = rsp->rda[smp_processor_id()];
> -		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
> -		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> -		rdp->nxtlist = NULL;
> -		for (i = 0; i < RCU_NEXT_SIZE; i++)
> -			rdp->nxttail[i] = &rdp->nxtlist;
> -		rdp_me->qlen += rdp->qlen;
> -		rdp->qlen = 0;
> -	}
> -	local_irq_restore(flags);
> +	rcu_adopt_orphan_cbs(rsp);
>  }
>  
>  /*
> @@ -914,6 +940,14 @@ static void rcu_offline_cpu(int cpu)
>  
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
>  
> +static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> +{
> +}
> +
> +static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
> +{
> +}
> +
>  static void rcu_offline_cpu(int cpu)
>  {
>  }
> @@ -1367,9 +1401,6 @@ static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
>  static atomic_t rcu_barrier_cpu_count;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
>  static struct completion rcu_barrier_completion;
> -static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
> -static struct rcu_head rcu_migrate_head[3];
> -static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
>  
>  static void rcu_barrier_callback(struct rcu_head *notused)
>  {
> @@ -1392,21 +1423,16 @@ static void rcu_barrier_func(void *type)
>  	call_rcu_func(head, rcu_barrier_callback);
>  }
>  
> -static inline void wait_migrated_callbacks(void)
> -{
> -	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
> -	smp_mb(); /* In case we didn't sleep. */
> -}
> -
>  /*
>   * Orchestrate the specified type of RCU barrier, waiting for all
>   * RCU callbacks of the specified type to complete.
>   */
> -static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
> +static void _rcu_barrier(struct rcu_state *rsp,
> +			 void (*call_rcu_func)(struct rcu_head *head,
>  					       void (*func)(struct rcu_head *head)))
>  {
>  	BUG_ON(in_interrupt());
> -	/* Take cpucontrol mutex to protect against CPU hotplug */
> +	/* Take mutex to serialize concurrent rcu_barrier() requests. */
>  	mutex_lock(&rcu_barrier_mutex);
>  	init_completion(&rcu_barrier_completion);
>  	/*
> @@ -1419,29 +1445,22 @@ static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
>  	 * early.
>  	 */
>  	atomic_set(&rcu_barrier_cpu_count, 1);
> +	preempt_disable(); /* stop CPU_DYING from filling orphan_cbs_list */
> +	rcu_adopt_orphan_cbs(rsp);
>  	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
> +	preempt_enable(); /* CPU_DYING can again fill orphan_cbs_list */
>  	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
>  		complete(&rcu_barrier_completion);
>  	wait_for_completion(&rcu_barrier_completion);
>  	mutex_unlock(&rcu_barrier_mutex);
> -	wait_migrated_callbacks();
> -}
> -
> -/**
> - * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
> - */
> -void rcu_barrier(void)
> -{
> -	_rcu_barrier(call_rcu);
>  }
> -EXPORT_SYMBOL_GPL(rcu_barrier);
>  
>  /**
>   * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
>   */
>  void rcu_barrier_bh(void)
>  {
> -	_rcu_barrier(call_rcu_bh);
> +	_rcu_barrier(&rcu_bh_state, call_rcu_bh);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_bh);
>  
> @@ -1450,16 +1469,10 @@ EXPORT_SYMBOL_GPL(rcu_barrier_bh);
>   */
>  void rcu_barrier_sched(void)
>  {
> -	_rcu_barrier(call_rcu_sched);
> +	_rcu_barrier(&rcu_sched_state, call_rcu_sched);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
>  
> -static void rcu_migrate_callback(struct rcu_head *notused)
> -{
> -	if (atomic_dec_and_test(&rcu_migrate_type_count))
> -		wake_up(&rcu_migrate_wq);
> -}
> -
>  /*
>   * Do boot-time initialization of a CPU's per-CPU RCU data.
>   */
> @@ -1556,27 +1569,21 @@ int __cpuinit rcu_cpu_notify(struct notifier_block *self,
>  	case CPU_UP_PREPARE_FROZEN:
>  		rcu_online_cpu(cpu);
>  		break;
> -	case CPU_DOWN_PREPARE:
> -	case CPU_DOWN_PREPARE_FROZEN:
> -		/* Don't need to wait until next removal operation. */
> -		/* rcu_migrate_head is protected by cpu_add_remove_lock */
> -		wait_migrated_callbacks();
> -		break;
>  	case CPU_DYING:
>  	case CPU_DYING_FROZEN:
>  		/*
> -		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
> +		 * preempt_disable() in _rcu_barrier() prevents stop_machine(),
>  		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
> -		 * returns, all online cpus have queued rcu_barrier_func(),
> -		 * and the dead cpu(if it exist) queues rcu_migrate_callback()s.
> -		 *
> -		 * These callbacks ensure _rcu_barrier() waits for all
> -		 * RCU callbacks of the specified type to complete.
> +		 * returns, all online cpus have queued rcu_barrier_func().
> +		 * The dying CPU clears its cpu_online_mask bit and
> +		 * moves all of its RCU callbacks to ->orphan_cbs_list
> +		 * in the context of stop_machine(), so subsequent calls
> +		 * to _rcu_barrier() will adopt these callbacks and only
> +		 * then queue rcu_barrier_func() on all remaining CPUs.
>  		 */
> -		atomic_set(&rcu_migrate_type_count, 3);
> -		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
> -		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
> -		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
> +		rcu_send_cbs_to_orphanage(&rcu_bh_state);
> +		rcu_send_cbs_to_orphanage(&rcu_sched_state);
> +		rcu_preempt_send_cbs_to_orphanage();
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 676eecd..b40ac57 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -244,7 +244,15 @@ struct rcu_state {
>  	/* End  of fields guarded by root rcu_node's lock. */
>  
>  	spinlock_t onofflock;			/* exclude on/offline and */
> -						/*  starting new GP. */
> +						/*  starting new GP.  Also */
> +						/*  protects the following */
> +						/*  orphan_cbs fields. */
> +	struct rcu_head *orphan_cbs_list;	/* list of rcu_head structs */
> +						/*  orphaned by all CPUs in */
> +						/*  a given leaf rcu_node */
> +						/*  going offline. */
> +	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
> +	long orphan_qlen;			/* Number of orphaned cbs. */
>  	spinlock_t fqslock;			/* Only one task forcing */
>  						/*  quiescent states. */
>  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
> @@ -305,6 +313,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
>  static int rcu_preempt_pending(int cpu);
>  static int rcu_preempt_needs_cpu(int cpu);
>  static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
> +static void rcu_preempt_send_cbs_to_orphanage(void);
>  static void __init __rcu_init_preempt(void);
>  
>  #endif /* #else #ifdef RCU_TREE_NONCORE */
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 57200fe..c0cb783 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -410,6 +410,15 @@ static int rcu_preempt_needs_cpu(int cpu)
>  	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
>  }
>  
> +/**
> + * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
> + */
> +void rcu_barrier(void)
> +{
> +	_rcu_barrier(&rcu_preempt_state, call_rcu);
> +}
> +EXPORT_SYMBOL_GPL(rcu_barrier);
> +
>  /*
>   * Initialize preemptable RCU's per-CPU data.
>   */
> @@ -419,6 +428,14 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
>  }
>  
>  /*
> + * Move preemptable RCU's callbacks to ->orphan_cbs_list.
> + */
> +static void rcu_preempt_send_cbs_to_orphanage(void)
> +{
> +	rcu_send_cbs_to_orphanage(&rcu_preempt_state);
> +}
> +
> +/*
>   * Initialize preemptable RCU's state structures.
>   */
>  static void __init __rcu_init_preempt(void)
> @@ -564,6 +581,16 @@ static int rcu_preempt_needs_cpu(int cpu)
>  }
>  
>  /*
> + * Because preemptable RCU does not exist, rcu_barrier() is just
> + * another name for rcu_barrier_sched().
> + */
> +void rcu_barrier(void)
> +{
> +	rcu_barrier_sched();
> +}
> +EXPORT_SYMBOL_GPL(rcu_barrier);
> +
> +/*
>   * Because preemptable RCU does not exist, there is no per-CPU
>   * data to initialize.
>   */
> @@ -572,6 +599,13 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
>  }
>  
>  /*
> + * Because there is no preemptable RCU, there are no callbacks to move.
> + */
> +static void rcu_preempt_send_cbs_to_orphanage(void)
> +{
> +}
> +
> +/*
>   * Because preemptable RCU does not exist, it need not be initialized.
>   */
>  static void __init __rcu_init_preempt(void)
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index f09af28..4b31c77 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -159,13 +159,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
>  	struct rcu_node *rnp;
>  
>  	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
> -		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
> +		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
>  		   rsp->completed, rsp->gpnum, rsp->signaled,
>  		   (long)(rsp->jiffies_force_qs - jiffies),
>  		   (int)(jiffies & 0xffff),
>  		   rsp->n_force_qs, rsp->n_force_qs_ngp,
>  		   rsp->n_force_qs - rsp->n_force_qs_ngp,
> -		   rsp->n_force_qs_lh);
> +		   rsp->n_force_qs_lh, rsp->orphan_qlen);
>  	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
>  		if (rnp->level != level) {
>  			seq_puts(m, "\n");
> -- 
> 1.5.2.5
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
