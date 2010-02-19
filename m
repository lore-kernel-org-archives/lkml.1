Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0BSSh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:37:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:1552 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0BSShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,504,1262592000"; 
   d="scan'208";a="597437805"
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266588316.1529.370.camel@laptop>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 19 Feb 2010 10:36:34 -0800
Message-Id: <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 06:05 -0800, Peter Zijlstra wrote:
> The whole notion of load_per_task is utterly broken for cgroup stuff
> (but I can fully understand you not wanting to care about that).

Yep. I will leave that to cgroup folks :)

> A smaller breakage is that its constructed using rq->nr_running, not
> cfs_rq->nr_running, the problem is that the former includes !fair tasks
> and the latter (for the cgroup case) not all tasks.
> 
> It would be good to come up with something that does not rely on this
> metric at all, although I admit not quite seeing how that would work.

I wouldn't mind further enhancements but am currently focused on solving
this regression first :(

> 
> > The appended patch works for me and fixes the SCHED_MC performance
> > behavior. I am sending this patch out for a quick review and I will do
> > bit more testing tomorrow and If you don't follow what I am doing in
> > this patch and why, then stay tuned for a patch with complete changelog
> > that I will send tomorrow. Good night. Thanks.
> 
> I can mostly follow the code, but I can't seem to quickly see what
> particular problem you're trying to solve :-)

Ok. Let me help you understand below.

> 
> In particular, using the below script:
> 
> $ cat show-loop
> #!/bin/bash
> NR=$1; shift
> 
> for ((i=0; i<NR; i++)) ; do
>   ./loop &
> done
> 
> for ((i=0; i<3; i++)) ; do
>   sleep 1
> 
>   ( ps -deo pid,sgi_p,cmd | grep loop | grep bash | while read pid cpu cmd; do
> 
>     SOCKET=`cat /sys/devices/system/cpu/cpu${cpu}/topology/physical_package_id`
>     CORE=`cat /sys/devices/system/cpu/cpu${cpu}/topology/core_id`
>     SIBLINGS=`cat /sys/devices/system/cpu/cpu${cpu}/topology/thread_siblings_list`
> 
>     printf "loop-%05d on CPU: %02d SOCKET: %02d CORE: %02d THREADS: ${SIBLINGS}\n" $pid $cpu $SOCKET $CORE
> 
>   done ) | sort | awk '{socket[$6]++; th[$8 + (256*$6)]++; print $0} END { for (i in socket) { print "socket-" i ": " socket[i]; } for (i in th) { if (th[i] > 1) { print "thread-" int(i/256)"/"(i%256) ": " th[i]; } } }'
> 
>   echo ""
>   echo "-------------------"
>   echo ""
> 
> done
> 
> killall loop
> ---
> 
> I can find no difference between tip/master +/- patch for the following
> scenarios:
> 
>  ./show-loop $nr_sockets
> 
> mostly its 1 loop per socket, sometimes I see 2 on a single socket
> 
>  ./show-loop $nr_cores_in_machine
> 
> mostly it shows 1 loop per core, sometimes one core is idle and one core
> uses both threads.
> 
> Anything in between also mostly shows an equal distribution of loops per
> socket.


exec/fork balance is not broken. i.e., during exec/fork we balance the
load equally among sockets/cores etc. What is broken is:

a) In SMT case, once we end up in a situation where both the threads of
the core are busy , with another core completely idle, load balance is
not moving one of the threads to the idle core. This unbalanced
situation can happen because of a previous wake-up decision and/or
threads on other core went to sleep/died etc. Once we end up in this
unbalanced situation, we continue in that state with out fixing it.

b) Similar to "a", this is MC case where we end up four cores busy in
one socket with other 4 cores in another socket completely idle. And
this is the situation which we are trying to solve in this patch.

In your above example, we test mostly fork/exec balance but not the
above sleep/wakeup scenarios.

> 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 3a8fb30..2f4cac0 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> 
> FWIW, this code no longer lives in sched.c ;-)

Yep. I noticed that in -tip tree but was working on linus's tree to see
if I can address this regression. Based on the remaining time, perhaps
we should first address this in -tip and then back-port the fix
to .33-stable.

> 
> > @@ -3423,6 +3423,7 @@ struct sd_lb_stats {
> >  	unsigned long max_load;
> >  	unsigned long busiest_load_per_task;
> >  	unsigned long busiest_nr_running;
> > +	unsigned long busiest_group_capacity;
> >  
> >  	int group_imb; /* Is there imbalance in this sd */
> >  #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> > @@ -3880,6 +3881,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
> >  			sds->max_load = sgs.avg_load;
> >  			sds->busiest = group;
> >  			sds->busiest_nr_running = sgs.sum_nr_running;
> > +			sds->busiest_group_capacity = sgs.group_capacity;
> >  			sds->busiest_load_per_task = sgs.sum_weighted_load;
> >  			sds->group_imb = sgs.group_imb;
> >  		}
> > @@ -3902,6 +3904,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
> >  {
> >  	unsigned long tmp, pwr_now = 0, pwr_move = 0;
> >  	unsigned int imbn = 2;
> > +	unsigned long scaled_busy_load_per_task;
> >  
> >  	if (sds->this_nr_running) {
> >  		sds->this_load_per_task /= sds->this_nr_running;
> > @@ -3912,8 +3915,12 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
> >  		sds->this_load_per_task =
> >  			cpu_avg_load_per_task(this_cpu);
> >  
> > -	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
> > -			sds->busiest_load_per_task * imbn) {
> > +	scaled_busy_load_per_task = sds->busiest_load_per_task
> > +						 * SCHED_LOAD_SCALE;
> > +	scaled_busy_load_per_task /= sds->busiest->cpu_power;
> > +
> > +	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
> > +			scaled_busy_load_per_task * imbn) {
> >  		*imbalance = sds->busiest_load_per_task;
> >  		return;
> >  	}
> 
> Right, makes sense, max_load/this_load (being samples of avg_load) are
> scaled.
> 
> calculate_imbalance() seems to always have undone the power scaling,
> *cpu_power / SCHED_LOAD_SCALE, as the imbalance is based on avg_load
> derivatives.
> 
> fix_small_imbalance() also returns an unscaled value, based on the
> unscaled load_per_task derivatives.
> 
> But what I'm not seeing is how this got introduced recently, looking
> at .29 its pretty much the same, comparing the unscaled load_per_task to
> avg_load, so my recent change to make cpu_power more fluid may have made
> aggrevated the situation, but its not a new issue.

Your understanding is correct. We now have the issue for MC domains
(because of recent cpu_power changes) whereas previously we had the
issue probably for big NUMA (when I say big numa, probably two or more
sockets per numa domain) systems that I had never tested to observe this
issue before.

> 
> > @@ -3964,7 +3971,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
> >  static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
> >  		unsigned long *imbalance)
> >  {
> > -	unsigned long max_pull;
> > +	unsigned long max_pull, load_above_capacity = ~0UL;
> >  	/*
> >  	 * In the presence of smp nice balancing, certain scenarios can have
> >  	 * max load less than avg load(as we skip the groups at or below
> > @@ -3975,9 +3982,30 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
> >  		return fix_small_imbalance(sds, this_cpu, imbalance);
> >  	}
> >  
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
> > +
> > +	/*
> > +	 * We're trying to get all the cpus to the average_load, so we don't
> > +	 * want to push ourselves above the average load, nor do we wish to
> > +	 * reduce the max loaded cpu below the average load, as either of these
> > +	 * actions would just result in more rebalancing later, and ping-pong
> > +	 * tasks around. 
> 
> 
> About the ping-pong for the statically infeasible scenario, the problem
> with that is that we actually want to ping-pong a little [*], so we
> might want to look at maybe doing a sd->next_pingpong jiffy measure to
> allow some of that.
> 
> [*] I've seen people pretty upset about the fact that when they start 6
> similar loads on a quad cpu the tasks will not finish in roughly similar
> times.

I thought we were doing this (ping-ping a little) already. Unless
something broke here also. I thought fix_small_imbalance() takes care of
this too.

> 
> > 			Thus we look for the minimum possible imbalance.
> > +	 * Negative imbalances (*we* are more loaded than anyone else) will
> > +	 * be counted as no imbalance for these purposes -- we can't fix that
> > +	 * by pulling tasks to us. Be careful of negative numbers as they'll
> > +	 * appear as very large values with unsigned longs.
> > +	 */
> > +	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
> 
> OK, so this bit actually changes behaviour and seems to make sense, the
> load above capacity makes more sense than max - load_per_task.
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
> You'll have to remove item 6) on the comment further up. And we might as
> well move the whole busiest_load_per_task computation along into
> calculate_imbalance().

Ok. I am trying to do a simplified patch first, so that it is acceptable
to be back-ported in to -stable (for 2.6.32 and 2.6.33) so that
distributions based on those versions won't have this regression. I will
do another rev of this patch today. We can do more cleanups following
that.

thanks,
suresh

