Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbZIOTyC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbZIOTyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:54:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZIOTx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:53:56 -0400
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:33318 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZIOTxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:53:55 -0400
Date: Tue, 15 Sep 2009 12:53:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/rcu 3/4] Simplify rcu_read_unlock_special()
 quiescent-state accounting
Message-ID: <20090915195340.GD3283@feather>
References: <20090913161438.GA32550@linux.vnet.ibm.com>
 <12528585111945-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12528585111945-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 09:15:10AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> The earlier approach required two scheduling-clock ticks to note
> an preemptable-RCU quiescent state in the situation in which the
> scheduling-clock interrupt is unlucky enough to always interrupt an RCU
> read-side critical section.  With this change, the quiescent state is
> instead noted by the outermost rcu_read_unlock() immediately following the
> first scheduling-clock tick, or, alternatively, by the first subsequent
> context switch.  Therefore, this change also speeds up grace periods.
> 
> Suggested-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Josh Triplett <josh@joshtriplett.org>

(patch left quoted for context)

> ---
>  include/linux/sched.h   |    1 -
>  kernel/rcutree.c        |   15 +++++-------
>  kernel/rcutree_plugin.h |   54 ++++++++++++++++++++++------------------------
>  3 files changed, 32 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 855fd0d..e00ee56 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1731,7 +1731,6 @@ extern cputime_t task_gtime(struct task_struct *p);
>  
>  #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
>  #define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
> -#define RCU_READ_UNLOCK_GOT_QS  (1 << 2) /* CPU has responded to RCU core. */
>  
>  static inline void rcu_copy_process(struct task_struct *p)
>  {
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3a01405..2454999 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -106,27 +106,23 @@ static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
>   */
>  void rcu_sched_qs(int cpu)
>  {
> -	unsigned long flags;
>  	struct rcu_data *rdp;
>  
> -	local_irq_save(flags);
>  	rdp = &per_cpu(rcu_sched_data, cpu);
> -	rdp->passed_quiesc = 1;
>  	rdp->passed_quiesc_completed = rdp->completed;
> -	rcu_preempt_qs(cpu);
> -	local_irq_restore(flags);
> +	barrier();
> +	rdp->passed_quiesc = 1;
> +	rcu_preempt_note_context_switch(cpu);
>  }
>  
>  void rcu_bh_qs(int cpu)
>  {
> -	unsigned long flags;
>  	struct rcu_data *rdp;
>  
> -	local_irq_save(flags);
>  	rdp = &per_cpu(rcu_bh_data, cpu);
> -	rdp->passed_quiesc = 1;
>  	rdp->passed_quiesc_completed = rdp->completed;
> -	local_irq_restore(flags);
> +	barrier();
> +	rdp->passed_quiesc = 1;
>  }
>  
>  #ifdef CONFIG_NO_HZ
> @@ -610,6 +606,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
>  
>  	/* Advance to a new grace period and initialize state. */
>  	rsp->gpnum++;
> +	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
>  	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
>  	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
>  	record_gp_stall_check_time(rsp);
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 51413cb..eb4bae3 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -64,34 +64,42 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
>   * not in a quiescent state.  There might be any number of tasks blocked
>   * while in an RCU read-side critical section.
>   */
> -static void rcu_preempt_qs_record(int cpu)
> +static void rcu_preempt_qs(int cpu)
>  {
>  	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
> -	rdp->passed_quiesc = 1;
>  	rdp->passed_quiesc_completed = rdp->completed;
> +	barrier();
> +	rdp->passed_quiesc = 1;
>  }
>  
>  /*
> - * We have entered the scheduler or are between softirqs in ksoftirqd.
> - * If we are in an RCU read-side critical section, we need to reflect
> - * that in the state of the rcu_node structure corresponding to this CPU.
> - * Caller must disable hardirqs.
> + * We have entered the scheduler, and the current task might soon be
> + * context-switched away from.  If this task is in an RCU read-side
> + * critical section, we will no longer be able to rely on the CPU to
> + * record that fact, so we enqueue the task on the appropriate entry
> + * of the blocked_tasks[] array.  The task will dequeue itself when
> + * it exits the outermost enclosing RCU read-side critical section.
> + * Therefore, the current grace period cannot be permitted to complete
> + * until the blocked_tasks[] entry indexed by the low-order bit of
> + * rnp->gpnum empties.
> + *
> + * Caller must disable preemption.
>   */
> -static void rcu_preempt_qs(int cpu)
> +static void rcu_preempt_note_context_switch(int cpu)
>  {
>  	struct task_struct *t = current;
> +	unsigned long flags;
>  	int phase;
>  	struct rcu_data *rdp;
>  	struct rcu_node *rnp;
>  
>  	if (t->rcu_read_lock_nesting &&
>  	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
> -	    	WARN_ON_ONCE(cpu != smp_processor_id());
>  
>  		/* Possibly blocking in an RCU read-side critical section. */
>  		rdp = rcu_preempt_state.rda[cpu];
>  		rnp = rdp->mynode;
> -		spin_lock(&rnp->lock);
> +		spin_lock_irqsave(&rnp->lock, flags);
>  		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
>  		t->rcu_blocked_node = rnp;
>  
> @@ -112,7 +120,7 @@ static void rcu_preempt_qs(int cpu)
>  		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
>  		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
>  		smp_mb();  /* Ensure later ctxt swtch seen after above. */
> -		spin_unlock(&rnp->lock);
> +		spin_unlock_irqrestore(&rnp->lock, flags);
>  	}
>  
>  	/*
> @@ -124,9 +132,8 @@ static void rcu_preempt_qs(int cpu)
>  	 * grace period, then the fact that the task has been enqueued
>  	 * means that we continue to block the current grace period.
>  	 */
> -	rcu_preempt_qs_record(cpu);
> -	t->rcu_read_unlock_special &= ~(RCU_READ_UNLOCK_NEED_QS |
> -					RCU_READ_UNLOCK_GOT_QS);
> +	rcu_preempt_qs(cpu);
> +	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
>  }
>  
>  /*
> @@ -162,7 +169,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  	special = t->rcu_read_unlock_special;
>  	if (special & RCU_READ_UNLOCK_NEED_QS) {
>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
> -		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_QS;
> +		rcu_preempt_qs(smp_processor_id());
>  	}
>  
>  	/* Hardware IRQ handlers cannot block. */
> @@ -199,9 +206,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
>  		 */
>  		if (!empty && rnp->qsmask == 0 &&
>  		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
> -			t->rcu_read_unlock_special &=
> -				~(RCU_READ_UNLOCK_NEED_QS |
> -				  RCU_READ_UNLOCK_GOT_QS);
> +			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
>  			if (rnp->parent == NULL) {
>  				/* Only one rcu_node in the tree. */
>  				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
> @@ -352,19 +357,12 @@ static void rcu_preempt_check_callbacks(int cpu)
>  	struct task_struct *t = current;
>  
>  	if (t->rcu_read_lock_nesting == 0) {
> -		t->rcu_read_unlock_special &=
> -			~(RCU_READ_UNLOCK_NEED_QS | RCU_READ_UNLOCK_GOT_QS);
> -		rcu_preempt_qs_record(cpu);
> +		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
> +		rcu_preempt_qs(cpu);
>  		return;
>  	}
>  	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
> -		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_GOT_QS) {
> -			rcu_preempt_qs_record(cpu);
> -			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_GOT_QS;
> -		} else if (!(t->rcu_read_unlock_special &
> -			     RCU_READ_UNLOCK_NEED_QS)) {
> -			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
> -		}
> +		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
>  	}
>  }
>  
> @@ -451,7 +449,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
>   * Because preemptable RCU does not exist, we never have to check for
>   * CPUs being in quiescent states.
>   */
> -static void rcu_preempt_qs(int cpu)
> +static void rcu_preempt_note_context_switch(int cpu)
>  {
>  }
>  
