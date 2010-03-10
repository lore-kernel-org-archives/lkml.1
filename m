Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0CJBan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 20:30:43 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47156 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab0CJBaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 20:30:39 -0500
Date: Tue, 9 Mar 2010 17:30:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, josh@joshtriplett.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] rcu: don't ignore preempt_disable() in the idle
	loop
Message-ID: <20100310013035.GB6203@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4B962D57.1000406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B962D57.1000406@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 07:13:27PM +0800, Lai Jiangshan wrote:
> 
> Current, synchronize_sched() ignores preempt-disable()
> sequences in the idle loop. It makes synchronize_sched()
> is not so pure, and it hurts tracing.
> 
> Paul have a proposal before:
> http://lkml.org/lkml/2009/4/5/140
> http://lkml.org/lkml/2009/4/6/496
> But old fix needs to hack into all architectures' idle loops.
> 
> This is another try, it uses the fact that idle loops
> are executing with preept_count()=1.
> But I didn't look deep into all idle loops.

Hello, Lai!

One question below...

						Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3ec8160..0761723 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -80,6 +80,10 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
>  struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
>  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> 
> +#ifndef IDLE_CORE_LOOP_PREEMPT_COUNT
> +#define IDLE_CORE_LOOP_PREEMPT_COUNT (1)
> +#endif
> +
>  /*
>   * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
>   * permit this function to be invoked without holding the root rcu_node
> @@ -1114,6 +1118,26 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  		raise_softirq(RCU_SOFTIRQ);
>  }
> 
> +static inline int rcu_idle_qs(int cpu)
> +{
> +	if (!idle_cpu(cpu))
> +		return 0;
> +
> +	if (!rcu_scheduler_active)
> +		return 0;
> +
> +	if (in_softirq())
> +		return 0;
> +
> +	if (hardirq_count() > (1 << HARDIRQ_SHIFT))
> +		return 0;
> +
> +	if ((preempt_count() & PREEMPT_MASK) > IDLE_CORE_LOOP_PREEMPT_COUNT)
> +		return 0;

How does this work in CONFIG_PREEMPT=n kernels?  I don't see how it
does, regardless of what preempt_count() returns in this case.

Any enlightenment?

> +
> +	return 1;
> +}
> +
>  /*
>   * Check to see if this CPU is in a non-context-switch quiescent state
>   * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
> @@ -1127,9 +1151,7 @@ void rcu_check_callbacks(int cpu, int user)
>  {
>  	if (!rcu_pending(cpu))
>  		return; /* if nothing for RCU to do. */
> -	if (user ||
> -	    (idle_cpu(cpu) && rcu_scheduler_active &&
> -	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> +	if (user || rcu_idle_qs(cpu)) {
> 
>  		/*
>  		 * Get here if this CPU took its interrupt from user
> 
