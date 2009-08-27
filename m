Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZH0WEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZH0WEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZH0WEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:04:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50658 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZH0WEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:04:36 -0400
Subject: Re: [PATCH tip/core/rcu] Changes from reviews: avoid casts,
 fix/add warnings, improve comments.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
In-Reply-To: <20090827220012.GA30525@linux.vnet.ibm.com>
References: <20090827220012.GA30525@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 15:05:00 -0700
Message-Id: <1251410700.2705.5.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 15:00 -0700, Paul E. McKenney wrote:
> Changes suggested by review comments from Josh Triplett and Mathieu
> Desnoyers.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Josh Triplett <josh@joshtriplett.org>

> ---
> 
>  include/linux/sched.h   |    4 +++-
>  kernel/rcutree.c        |   13 ++++++-------
>  kernel/rcutree.h        |    2 ++
>  kernel/rcutree_plugin.h |   10 ++++++----
>  4 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 3fe0315..855fd0d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1163,6 +1163,8 @@ struct sched_rt_entity {
>  #endif
>  };
> 
> +struct rcu_node;
> +
>  struct task_struct {
>  	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
>  	void *stack;
> @@ -1208,7 +1210,7 @@ struct task_struct {
>  #ifdef CONFIG_TREE_PREEMPT_RCU
>  	int rcu_read_lock_nesting;
>  	char rcu_read_unlock_special;
> -	void *rcu_blocked_node;
> +	struct rcu_node *rcu_blocked_node;
>  	struct list_head rcu_node_entry;
>  #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d903e2f..71bc797 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -229,7 +229,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>  #endif /* #ifdef CONFIG_SMP */
> 
>  #ifdef CONFIG_NO_HZ
> -static DEFINE_RATELIMIT_STATE(rcu_rs, 10 * HZ, 5);
> 
>  /**
>   * rcu_enter_nohz - inform RCU that current CPU is entering nohz
> @@ -249,7 +248,7 @@ void rcu_enter_nohz(void)
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	rdtp->dynticks++;
>  	rdtp->dynticks_nesting--;
> -	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
> +	WARN_ON_ONCE(rdtp->dynticks & 0x1);
>  	local_irq_restore(flags);
>  }
> 
> @@ -268,7 +267,7 @@ void rcu_exit_nohz(void)
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	rdtp->dynticks++;
>  	rdtp->dynticks_nesting++;
> -	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
> +	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
>  	local_irq_restore(flags);
>  	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
>  }
> @@ -287,7 +286,7 @@ void rcu_nmi_enter(void)
>  	if (rdtp->dynticks & 0x1)
>  		return;
>  	rdtp->dynticks_nmi++;
> -	WARN_ON_RATELIMIT(!(rdtp->dynticks_nmi & 0x1), &rcu_rs);
> +	WARN_ON_ONCE(!(rdtp->dynticks_nmi & 0x1));
>  	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
>  }
> 
> @@ -306,7 +305,7 @@ void rcu_nmi_exit(void)
>  		return;
>  	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
>  	rdtp->dynticks_nmi++;
> -	WARN_ON_RATELIMIT(rdtp->dynticks_nmi & 0x1, &rcu_rs);
> +	WARN_ON_ONCE(rdtp->dynticks_nmi & 0x1);
>  }
> 
>  /**
> @@ -322,7 +321,7 @@ void rcu_irq_enter(void)
>  	if (rdtp->dynticks_nesting++)
>  		return;
>  	rdtp->dynticks++;
> -	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
> +	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
>  	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
>  }
> 
> @@ -341,7 +340,7 @@ void rcu_irq_exit(void)
>  		return;
>  	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
>  	rdtp->dynticks++;
> -	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
> +	WARN_ON_ONCE(rdtp->dynticks & 0x1);
> 
>  	/* If the interrupt queued a callback, get out of dyntick mode. */
>  	if (__get_cpu_var(rcu_sched_data).nxtlist ||
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index ca56036..bf8a6f9 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -81,6 +81,8 @@ struct rcu_dynticks {
>  struct rcu_node {
>  	spinlock_t lock;
>  	long	gpnum;		/* Current grace period for this node. */
> +				/*  This will either be equal to or one */
> +				/*  behind the root rcu_node's gpnum. */
>  	unsigned long qsmask;	/* CPUs or groups that need to switch in */
>  				/*  order for current grace period to proceed.*/
>  	unsigned long qsmaskinit;
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 04343be..4778936 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -92,7 +92,7 @@ static void rcu_preempt_qs(int cpu)
>  		rnp = rdp->mynode;
>  		spin_lock(&rnp->lock);
>  		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
> -		t->rcu_blocked_node = (void *)rnp;
> +		t->rcu_blocked_node = rnp;
> 
>  		/*
>  		 * If this CPU has already checked in, then this task
> @@ -176,9 +176,9 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  		 * most one time.  So at most two passes through loop.
>  		 */
>  		for (;;) {
> -			rnp = (struct rcu_node *)t->rcu_blocked_node;
> +			rnp = t->rcu_blocked_node;
>  			spin_lock(&rnp->lock);
> -			if (rnp == (struct rcu_node *)t->rcu_blocked_node)
> +			if (rnp == t->rcu_blocked_node)
>  				break;
>  			spin_unlock(&rnp->lock);
>  		}
> @@ -288,8 +288,10 @@ static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
>  	struct rcu_node *rnp_root = rcu_get_root(rsp);
>  	struct task_struct *tp;
> 
> -	if (rnp == rnp_root)
> +	if (rnp == rnp_root) {
> +		WARN_ONCE(1, "Last CPU thought to be offlined?");
>  		return;  /* Shouldn't happen: at least one CPU online. */
> +	}
> 
>  	/*
>  	 * Move tasks up to root rcu_node.  Rely on the fact that the

