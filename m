Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079Ab0A0OLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0A0OLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865Ab0A0OLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:11:16 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56651 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0A0OLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:11:16 -0500
Date: Wed, 27 Jan 2010 06:11:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127141109.GA21087@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <1264432323.31321.412.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264432323.31321.412.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 10:12:03AM -0500, Steven Rostedt wrote:
> On Sun, 2010-01-24 at 19:48 -0800, Paul E. McKenney wrote:
> 
> > +/*
> > + * Check to see if any future RCU-related work will need to be done
> > + * by the current CPU, even if none need be done immediately, returning
> > + * 1 if so.  This function is part of the RCU implementation; it is -not-
> > + * an exported member of the RCU API.
> > + *
> > + * Because we are not supporting preemptible RCU, attempt to accelerate
> > + * any current grace periods so that RCU no longer needs this CPU, but
> > + * only if all other CPUs are already in dynticks-idle mode.  This will
> > + * allow the CPU cores to be powered down immediately, as opposed to after
> > + * waiting many milliseconds for grace periods to elapse.
> > + */
> > +int rcu_needs_cpu(int cpu)
> > +{
> > +	int c = 1;
> > +	int i;
> > +	int thatcpu;
> > +
> > +	/* Don't bother unless we are the last non-dyntick-idle CPU. */
> > +	for_each_cpu(thatcpu, nohz_cpu_mask)
> > +		if (thatcpu != cpu)
> > +			return rcu_needs_cpu_quick_check(cpu);
> > +
> > +	/* Try to push remaining RCU-sched and RCU-bh callbacks through. */
> > +	for (i = 0; i < RCU_NEEDS_CPU_FLUSHES && c; i++) {
> > +		c = 0;
> > +		if (per_cpu(rcu_sched_data, cpu).nxtlist) {
> > +			c = 1;
> > +			rcu_sched_qs(cpu);
> > +			force_quiescent_state(&rcu_sched_state, 0);
> > +			__rcu_process_callbacks(&rcu_sched_state,
> > +						&per_cpu(rcu_sched_data, cpu));
> 
> > +		}
> > +		if (per_cpu(rcu_bh_data, cpu).nxtlist) {
> > +			c = 1;
> > +			rcu_bh_qs(cpu);
> > +			force_quiescent_state(&rcu_bh_state, 0);
> > +			__rcu_process_callbacks(&rcu_bh_state,
> > +						&per_cpu(rcu_bh_data, cpu));
> > +		}
> > +	}
> > +
> > +	/* If RCU callbacks are still pending, RCU still needs this CPU. */
> > +	return c;
> 
> What happens if the last loop pushes out all callbacks? Then we would be
> returning 1 when we could really be returning 0. Wouldn't a better
> answer be:
> 
> 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
> 		per_cpu(rcu_bh_data, cpu).nxtlist;

Good point!!!

Or I can move the assignment to "c" to the end of each branch of the
"if" statement, and do something like the following:

	c = !!per_cpu(rcu_sched_data, cpu).nxtlist;

But either way, you are right, it does not make sense to go to all the
trouble of forcing a grace period and then failing to take advantage
of it.

							Thanx, Paul
