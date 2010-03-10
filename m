Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0CJAyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:54:12 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49917 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab0CJAyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TDg1LmHLSQYG5nkqZh1sd8Xyubl9xOdTDWrtQuXDFdEneHIcd8IpMQX1ai14rQ1UlG
         w9fzPBoDBrOUOu6JMBzrudrp+/+P8Iw6RcVwcEEuAawMkmPZ7s+lCY9h4Sq4fecvP2cB
         u82IY1MDSS/lzT9gxkkMYE/SwxOVSdwM/PrTs=
Date: Wed, 10 Mar 2010 01:54:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, josh@joshtriplett.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] rcu: don't ignore preempt_disable() in the idle
	loop
Message-ID: <20100310005401.GH5058@nowhere>
References: <4B962D57.1000406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B962D57.1000406@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> 
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



This is neat. But I wonder about something. It means that in most of
the idle loop, we won't be able to schedule the rcu callbacks
So if I understand well, this is going to needlessly delay
rcu callbacks for no strong reason most of the time. I'm not sure
if this is going to have any bad impact, but if so may be
do we want this as a feature, and check we currently have
running users of this feature (I only have function tracers in mind,
may be I'm missing some others). Altough I wonder how racy such
a check could be. At least we can make it a CONFIG.

