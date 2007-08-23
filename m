Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXHWE0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXHWE0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 00:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXHWE0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 00:26:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45948 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXHWE0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 00:26:45 -0400
Date: Thu, 23 Aug 2007 09:56:39 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH RFC] Priority boosting for preemptible RCU
Message-ID: <20070823042639.GA28026@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070822190254.GA1135@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822190254.GA1135@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, 
On Wed, Aug 22, 2007 at 12:02:54PM -0700, Paul E. McKenney wrote:
> +/*
> + * Print out RCU booster task statistics at the specified interval.
> + */
> +static void rcu_boost_dat_stat_print(void)
> +{
> +	/* Three decimal digits per byte plus spacing per number and line. */
> +	char buf[N_RCU_BOOST_STATE * (sizeof(long) * 3 + 2) + 2];
> +	int cpu;
> +	int event;
> +	int i;
> +	static time_t lastprint = 0;
> +	struct rcu_boost_dat *rbdp;
> +	int state;
> +	struct rcu_boost_dat sum;
> +
> +	/* Wait a graceful interval between printk spamming. */
> +
> +	if (xtime.tv_sec - lastprint <
> +	    CONFIG_PREEMPT_RCU_BOOST_STATS_INTERVAL)
> +		return;
> +
> +	/* Sum up the state/event-independent counters. */
> +
> +	sum.rbs_blocked = 0;
> +	sum.rbs_boost_attempt = 0;
> +	sum.rbs_boost = 0;
> +	sum.rbs_unlock = 0;
> +	sum.rbs_unboosted = 0;
> +	for_each_possible_cpu(cpu)
> +		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
> +			rbdp = per_cpu(rcu_boost_dat, cpu);
> +			sum.rbs_blocked += rbdp[i].rbs_blocked;
> +			sum.rbs_boost_attempt += rbdp[i].rbs_boost_attempt;
> +			sum.rbs_boost += rbdp[i].rbs_boost;
> +			sum.rbs_unlock += rbdp[i].rbs_unlock;
> +			sum.rbs_unboosted += rbdp[i].rbs_unboosted;
> +		}

I feel we should still be able to use for_each_online_cpu(cpu) instead
of for_each_possible_cpu. Again, there's a good chance that I might
be mistaken!

How about the following ?

	preempt_disable(); /* We Dont want cpus going down here */
	for_each_online_cpu(cpu) 
		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
			rbdp = per_cpu(rcu_boost_dat, cpu);
			sum.rbs_blocked += rbdp[i].rbs_blocked;
			sum.rbs_boost_attempt += rbdp[i].rbs_boost_attempt;
			sum.rbs_boost += rbdp[i].rbs_boost;
			sum.rbs_unlock += rbdp[i].rbs_unlock;
			sum.rbs_unboosted += rbdp[i].rbs_unboosted;
		}
	preempt_enable(); 


	static int rcu_boost_cpu_callback(struct notifier_bloack *nb, 
					unsigned long action, void *hcpu) 
	{
		int this_cpu, cpu;
		rcu_boost_data *rbdp, *this_rbdp;

		switch (action) {
		case CPU_DEAD:
			this_cpu = get_cpu();
			cpu = (long)hcpu;
			this_cpu = smp_processor_id();
			rbdp = per_cpu(rcu_boost_dat, cpu);
			this_rbdp = per_cpu(rcu_boost_dat, cpu);
			/* 
			 *  Transfer all of rbdp's statistics to
			 *  this_rbdp here.
			 */	
			 put_cpu();
	
			return NOTIFY_OK;
		}
	}


Won't this work in this case?


Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
