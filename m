Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853Ab0AYPML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853Ab0AYPML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956Ab0AYPMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:12:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab0AYPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:12:06 -0500
X-Authority-Analysis: v=1.0 c=1 a=yYHeZbYeH2cA:10 a=7U3hwN5JcxgA:10 a=t7bN9XTwOkWIhFUyazwA:9 a=2irqs-MymA6yLsAaCicA:7 a=3aZJd6cbtwP7retiYS8c_Vv5n4YA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
 non-dynticked CPU
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <20100125034816.GA14043@linux.vnet.ibm.com>
References: <20100125034816.GA14043@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 25 Jan 2010 10:12:03 -0500
Message-ID: <1264432323.31321.412.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-24 at 19:48 -0800, Paul E. McKenney wrote:

> +/*
> + * Check to see if any future RCU-related work will need to be done
> + * by the current CPU, even if none need be done immediately, returning
> + * 1 if so.  This function is part of the RCU implementation; it is -not-
> + * an exported member of the RCU API.
> + *
> + * Because we are not supporting preemptible RCU, attempt to accelerate
> + * any current grace periods so that RCU no longer needs this CPU, but
> + * only if all other CPUs are already in dynticks-idle mode.  This will
> + * allow the CPU cores to be powered down immediately, as opposed to after
> + * waiting many milliseconds for grace periods to elapse.
> + */
> +int rcu_needs_cpu(int cpu)
> +{
> +	int c = 1;
> +	int i;
> +	int thatcpu;
> +
> +	/* Don't bother unless we are the last non-dyntick-idle CPU. */
> +	for_each_cpu(thatcpu, nohz_cpu_mask)
> +		if (thatcpu != cpu)
> +			return rcu_needs_cpu_quick_check(cpu);
> +
> +	/* Try to push remaining RCU-sched and RCU-bh callbacks through. */
> +	for (i = 0; i < RCU_NEEDS_CPU_FLUSHES && c; i++) {
> +		c = 0;
> +		if (per_cpu(rcu_sched_data, cpu).nxtlist) {
> +			c = 1;
> +			rcu_sched_qs(cpu);
> +			force_quiescent_state(&rcu_sched_state, 0);
> +			__rcu_process_callbacks(&rcu_sched_state,
> +						&per_cpu(rcu_sched_data, cpu));

> +		}
> +		if (per_cpu(rcu_bh_data, cpu).nxtlist) {
> +			c = 1;
> +			rcu_bh_qs(cpu);
> +			force_quiescent_state(&rcu_bh_state, 0);
> +			__rcu_process_callbacks(&rcu_bh_state,
> +						&per_cpu(rcu_bh_data, cpu));
> +		}
> +	}
> +
> +	/* If RCU callbacks are still pending, RCU still needs this CPU. */
> +	return c;

What happens if the last loop pushes out all callbacks? Then we would be
returning 1 when we could really be returning 0. Wouldn't a better
answer be:

	return per_cpu(rcu_sched_data, cpu).nxtlist ||
		per_cpu(rcu_bh_data, cpu).nxtlist;

-- Steve


> +}
> +
> +#endif


