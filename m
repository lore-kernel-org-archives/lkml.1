Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0BSTRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:17:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:60266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab0BSTRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:17:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,504,1262592000"; 
   d="scan'208";a="597448375"
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
In-Reply-To: <20100219130318.GA20884@dirshya.in.ibm.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <20100219130318.GA20884@dirshya.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 19 Feb 2010 11:15:48 -0800
Message-Id: <1266606948.2814.62.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 05:03 -0800, Vaidyanathan Srinivasan wrote:
> > -	/* Don't want to pull so many tasks that a group would go idle */
> > -	max_pull = min(sds->max_load - sds->avg_load,
> > -			sds->max_load - sds->busiest_load_per_task);
> > +	if (!sds->group_imb) {
> > +		/*
> > + 	 	 * Don't want to pull so many tasks that a group would go idle.
> > +	 	 */
> > +		load_above_capacity = (sds->busiest_nr_running - 
> > +						sds->busiest_group_capacity);
> > +
> > +		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
> > +	
> > +		load_above_capacity /= sds->busiest->cpu_power;
> > +	}
> 
> This seems tricky.  max_load - avg_load will be less than
> load_above_capacity most of the time.  How does this expression
> increase the max_pull from previous expression?

I am not trying to increase/decrease from the previous expression. Just
trying to do the right thing (to ultimately address smt/mc
power-savings), as the "max_load - busiest_load_per_task" no longer
represents the load above capacity.

> 
> > +	/*
> > +	 * We're trying to get all the cpus to the average_load, so we don't
> > +	 * want to push ourselves above the average load, nor do we wish to
> > +	 * reduce the max loaded cpu below the average load, as either of these
> > +	 * actions would just result in more rebalancing later, and ping-pong
> > +	 * tasks around. Thus we look for the minimum possible imbalance.
> > +	 * Negative imbalances (*we* are more loaded than anyone else) will
> > +	 * be counted as no imbalance for these purposes -- we can't fix that
> > +	 * by pulling tasks to us. Be careful of negative numbers as they'll
> > +	 * appear as very large values with unsigned longs.
> > +	 */
> > +	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
> 
> Does this increase or decrease the value of max_pull from previous
> expression?

Does the above help answer your question, Vaidy?

>  
> >  	/* How much load to actually move to equalise the imbalance */
> >  	*imbalance = min(max_pull * sds->busiest->cpu_power,
> > @@ -4069,19 +4097,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
> >  		sds.busiest_load_per_task =
> >  			min(sds.busiest_load_per_task, sds.avg_load);
> > 
> > -	/*
> > -	 * We're trying to get all the cpus to the average_load, so we don't
> > -	 * want to push ourselves above the average load, nor do we wish to
> > -	 * reduce the max loaded cpu below the average load, as either of these
> > -	 * actions would just result in more rebalancing later, and ping-pong
> > -	 * tasks around. Thus we look for the minimum possible imbalance.
> > -	 * Negative imbalances (*we* are more loaded than anyone else) will
> > -	 * be counted as no imbalance for these purposes -- we can't fix that
> > -	 * by pulling tasks to us. Be careful of negative numbers as they'll
> > -	 * appear as very large values with unsigned longs.
> > -	 */
> > -	if (sds.max_load <= sds.busiest_load_per_task)
> > -		goto out_balanced;
> 
> This is right.  This condition was treating most cases as balanced and
> exit right here. However if this check is removed, we will have to
> execute more code to detect/ascertain balanced case.

To add, in update_sd_lb_stats() we are already doing this:

               } else if (sgs.avg_load > sds->max_load &&
                           (sgs.sum_nr_running > sgs.group_capacity ||
                                sgs.group_imb)) {

So we are already checking sum_nr_running > group_capacity to select the
busiest group. So we are doing the equivalent of this balanced check
much before.

thanks,
suresh

