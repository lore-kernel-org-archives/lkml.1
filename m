Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0BSP3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:29:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:54674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0BSP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:29:33 -0500
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 15:05:16 +0100
Message-ID: <1266588316.1529.370.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 18:16 -0800, Suresh Siddha wrote: 
> On Sat, 2010-02-13 at 02:36 -0800, Peter Zijlstra wrote:
> > On Fri, 2010-02-12 at 17:31 -0800, Suresh Siddha wrote:
> > > 
> > > We have one more problem that Yanmin and Ling Ma reported. On a dual
> > > socket quad-core platforms (for example platforms based on NHM-EP), we
> > > are seeing scenarios where one socket is completely busy (with all the 4
> > > cores running with 4 tasks) and another socket is completely idle.
> > > 
> > > This causes performance issues as those 4 tasks share the memory
> > > controller, last-level cache bandwidth etc. Also we won't be taking
> > > advantage of turbo-mode as much as we like. We will have all these
> > > benefits if we move two of those tasks to the other socket. Now both the
> > > sockets can potentially go to turbo etc and improve performance.
> > > 
> > > In short, your recent change (shown below) broke this behavior. In the
> > > kernel summit you mentioned you made this change with out affecting the
> > > behavior of SMT/MC. And my testing immediately after kernel-summit also
> > > didn't show the problem (perhaps my test didn't hit this specific
> > > change). But apparently we are having performance issues with this patch
> > > (Ling Ma's bisect pointed to this patch). I will look more detailed into
> > > this after the long weekend (to see if we can catch this scenario in
> > > fix_small_imbalance() etc). But wanted to give you a quick heads up.
> > > Thanks.
> > 
> > Right, so the behaviour we want should be provided by SD_PREFER_SIBLING,
> > it provides the capacity==1 thing the cpu_power games used to provide.
> > 
> > Not saying it's not broken, but that's where the we should be looking to
> > fix it.
> 
> Peter, Some portions of code in fix_small_imbalance() and
> calculate_imbalance() are comparing max_load and busiest_load_per_task.
> Some of these comparisons are ok but some of them are broken. Broken
> comparisons are assuming that the cpu_power is SCHED_LOAD_SCALE. Also
> there is one check which still assumes that the world is balanced when
> max_load <= busiest_load_per_task. This is wrong with the recent changes
> (as cpu power no longer reflects the group capacity that is needed to
> implement SCHED_MC/SCHED_SMT).

The whole notion of load_per_task is utterly broken for cgroup stuff
(but I can fully understand you not wanting to care about that).

A smaller breakage is that its constructed using rq->nr_running, not
cfs_rq->nr_running, the problem is that the former includes !fair tasks
and the latter (for the cgroup case) not all tasks.

It would be good to come up with something that does not rely on this
metric at all, although I admit not quite seeing how that would work.

> The appended patch works for me and fixes the SCHED_MC performance
> behavior. I am sending this patch out for a quick review and I will do
> bit more testing tomorrow and If you don't follow what I am doing in
> this patch and why, then stay tuned for a patch with complete changelog
> that I will send tomorrow. Good night. Thanks.

I can mostly follow the code, but I can't seem to quickly see what
particular problem you're trying to solve :-)

In particular, using the below script:

$ cat show-loop
#!/bin/bash
NR=$1; shift

for ((i=0; i<NR; i++)) ; do
  ./loop &
done

for ((i=0; i<3; i++)) ; do
  sleep 1

  ( ps -deo pid,sgi_p,cmd | grep loop | grep bash | while read pid cpu cmd; do

    SOCKET=`cat /sys/devices/system/cpu/cpu${cpu}/topology/physical_package_id`
    CORE=`cat /sys/devices/system/cpu/cpu${cpu}/topology/core_id`
    SIBLINGS=`cat /sys/devices/system/cpu/cpu${cpu}/topology/thread_siblings_list`

    printf "loop-%05d on CPU: %02d SOCKET: %02d CORE: %02d THREADS: ${SIBLINGS}\n" $pid $cpu $SOCKET $CORE

  done ) | sort | awk '{socket[$6]++; th[$8 + (256*$6)]++; print $0} END { for (i in socket) { print "socket-" i ": " socket[i]; } for (i in th) { if (th[i] > 1) { print "thread-" int(i/256)"/"(i%256) ": " th[i]; } } }'

  echo ""
  echo "-------------------"
  echo ""

done

killall loop
---

I can find no difference between tip/master +/- patch for the following
scenarios:

 ./show-loop $nr_sockets

mostly its 1 loop per socket, sometimes I see 2 on a single socket

 ./show-loop $nr_cores_in_machine

mostly it shows 1 loop per core, sometimes one core is idle and one core
uses both threads.

Anything in between also mostly shows an equal distribution of loops per
socket.

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3a8fb30..2f4cac0 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c

FWIW, this code no longer lives in sched.c ;-)

> @@ -3423,6 +3423,7 @@ struct sd_lb_stats {
>  	unsigned long max_load;
>  	unsigned long busiest_load_per_task;
>  	unsigned long busiest_nr_running;
> +	unsigned long busiest_group_capacity;
>  
>  	int group_imb; /* Is there imbalance in this sd */
>  #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> @@ -3880,6 +3881,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  			sds->max_load = sgs.avg_load;
>  			sds->busiest = group;
>  			sds->busiest_nr_running = sgs.sum_nr_running;
> +			sds->busiest_group_capacity = sgs.group_capacity;
>  			sds->busiest_load_per_task = sgs.sum_weighted_load;
>  			sds->group_imb = sgs.group_imb;
>  		}
> @@ -3902,6 +3904,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  {
>  	unsigned long tmp, pwr_now = 0, pwr_move = 0;
>  	unsigned int imbn = 2;
> +	unsigned long scaled_busy_load_per_task;
>  
>  	if (sds->this_nr_running) {
>  		sds->this_load_per_task /= sds->this_nr_running;
> @@ -3912,8 +3915,12 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  		sds->this_load_per_task =
>  			cpu_avg_load_per_task(this_cpu);
>  
> -	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
> -			sds->busiest_load_per_task * imbn) {
> +	scaled_busy_load_per_task = sds->busiest_load_per_task
> +						 * SCHED_LOAD_SCALE;
> +	scaled_busy_load_per_task /= sds->busiest->cpu_power;
> +
> +	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
> +			scaled_busy_load_per_task * imbn) {
>  		*imbalance = sds->busiest_load_per_task;
>  		return;
>  	}

Right, makes sense, max_load/this_load (being samples of avg_load) are
scaled.

calculate_imbalance() seems to always have undone the power scaling,
*cpu_power / SCHED_LOAD_SCALE, as the imbalance is based on avg_load
derivatives.

fix_small_imbalance() also returns an unscaled value, based on the
unscaled load_per_task derivatives.

But what I'm not seeing is how this got introduced recently, looking
at .29 its pretty much the same, comparing the unscaled load_per_task to
avg_load, so my recent change to make cpu_power more fluid may have made
aggrevated the situation, but its not a new issue.

> @@ -3964,7 +3971,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
>  static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
>  		unsigned long *imbalance)
>  {
> -	unsigned long max_pull;
> +	unsigned long max_pull, load_above_capacity = ~0UL;
>  	/*
>  	 * In the presence of smp nice balancing, certain scenarios can have
>  	 * max load less than avg load(as we skip the groups at or below
> @@ -3975,9 +3982,30 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
>  		return fix_small_imbalance(sds, this_cpu, imbalance);
>  	}
>  
> -	/* Don't want to pull so many tasks that a group would go idle */
> -	max_pull = min(sds->max_load - sds->avg_load,
> -			sds->max_load - sds->busiest_load_per_task);
> +	if (!sds->group_imb) {
> +		/*
> + 	 	 * Don't want to pull so many tasks that a group would go idle.
> +	 	 */
> +		load_above_capacity = (sds->busiest_nr_running - 
> +						sds->busiest_group_capacity);
> +
> +		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
> +	
> +		load_above_capacity /= sds->busiest->cpu_power;
> +	}
> +
> +	/*
> +	 * We're trying to get all the cpus to the average_load, so we don't
> +	 * want to push ourselves above the average load, nor do we wish to
> +	 * reduce the max loaded cpu below the average load, as either of these
> +	 * actions would just result in more rebalancing later, and ping-pong
> +	 * tasks around. 


About the ping-pong for the statically infeasible scenario, the problem
with that is that we actually want to ping-pong a little [*], so we
might want to look at maybe doing a sd->next_pingpong jiffy measure to
allow some of that.

[*] I've seen people pretty upset about the fact that when they start 6
similar loads on a quad cpu the tasks will not finish in roughly similar
times.

> 			Thus we look for the minimum possible imbalance.
> +	 * Negative imbalances (*we* are more loaded than anyone else) will
> +	 * be counted as no imbalance for these purposes -- we can't fix that
> +	 * by pulling tasks to us. Be careful of negative numbers as they'll
> +	 * appear as very large values with unsigned longs.
> +	 */
> +	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);

OK, so this bit actually changes behaviour and seems to make sense, the
load above capacity makes more sense than max - load_per_task.

>  	/* How much load to actually move to equalise the imbalance */
>  	*imbalance = min(max_pull * sds->busiest->cpu_power,
> @@ -4069,19 +4097,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
>  		sds.busiest_load_per_task =
>  			min(sds.busiest_load_per_task, sds.avg_load);
>  
> -	/*
> -	 * We're trying to get all the cpus to the average_load, so we don't
> -	 * want to push ourselves above the average load, nor do we wish to
> -	 * reduce the max loaded cpu below the average load, as either of these
> -	 * actions would just result in more rebalancing later, and ping-pong
> -	 * tasks around. Thus we look for the minimum possible imbalance.
> -	 * Negative imbalances (*we* are more loaded than anyone else) will
> -	 * be counted as no imbalance for these purposes -- we can't fix that
> -	 * by pulling tasks to us. Be careful of negative numbers as they'll
> -	 * appear as very large values with unsigned longs.
> -	 */
> -	if (sds.max_load <= sds.busiest_load_per_task)
> -		goto out_balanced;

You'll have to remove item 6) on the comment further up. And we might as
well move the whole busiest_load_per_task computation along into
calculate_imbalance().

>  	/* Looks like there is an imbalance. Compute it */
>  	calculate_imbalance(&sds, this_cpu, imbalance);
> 
> 



