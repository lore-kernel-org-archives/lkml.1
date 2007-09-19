Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXISTgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXISTgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXISTgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:36:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:61925 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXISTgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:36:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,275,1186383600"; 
   d="scan'208";a="282414049"
Date: Wed, 19 Sep 2007 12:35:57 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git] CFS-devel, group scheduler, fixes
Message-ID: <20070919193557.GD20863@linux-os.sc.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu> <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:03:59PM -0700, Tong Li wrote:
> This patch attempts to improve CFS's SMP global fairness based on the new 
> virtual time design.
> 
> Removed vruntime adjustment in set_task_cpu() as it skews global fairness.
> 
> Modified small_imbalance logic in find_busiest_group(). If there's small 
> imbalance, move tasks from busiest to local sched_group only if the local 
> group contains a CPU whose min_vruntime is the maximum among all CPUs in 
> the same sched_domain. This prevents any CPU from advancing too far ahead 
> in virtual time and avoids tasks thrashing between two CPUs without 
> utilizing other CPUs in the system. For example, for 10 tasks on 8 CPUs, 
> since the load is not evenly divisible by the number of CPUs, we want the 
> extra load to have a fair use of every CPU in the system.
> 
> Tested with a microbenchmark running 10 nice-0 tasks on 8 CPUs. Each task 

Just as an experiment, can you run 82 tasks on 8 CPUs. Current
imbalance_pct logic will not detect and fix the global fairness issue
even with this patch.

>  	if (*imbalance < busiest_load_per_task) {
> -		unsigned long tmp, pwr_now, pwr_move;
> -		unsigned int imbn;
> -
>  small_imbalance:
> -		pwr_move = pwr_now = 0;
> -		imbn = 2;
> -		if (this_nr_running) {
> -			this_load_per_task /= this_nr_running;
> -			if (busiest_load_per_task > this_load_per_task)
> -				imbn = 1;
> -		} else
> -			this_load_per_task = SCHED_LOAD_SCALE;
> -
> -		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
> -					busiest_load_per_task * imbn) {
> -			*imbalance = busiest_load_per_task;
> -			return busiest;
> -		}

This patch removes quite a few lines and all this is logic is not for
fairness :( Especially the above portion handles some of the HT/MC
optimizations.

> -
> -		/*
> -		 * OK, we don't have enough imbalance to justify moving 
> tasks,
> -		 * however we may be able to increase total CPU power used by
> -		 * moving them.
> +		/* 
> +		 * When there's small imbalance, move tasks only if this
> +		 * sched_group contains a CPU whose min_vruntime is the 
> +		 * maximum among all CPUs in the same domain.
>  		 */
> -
> -		pwr_now += busiest->__cpu_power *
> -				min(busiest_load_per_task, max_load);
> -		pwr_now += this->__cpu_power *
> -				min(this_load_per_task, this_load);
> -		pwr_now /= SCHED_LOAD_SCALE;
> -
> -		/* Amount of load we'd subtract */
> -		tmp = sg_div_cpu_power(busiest,
> -				busiest_load_per_task * SCHED_LOAD_SCALE);
> -		if (max_load > tmp)
> -			pwr_move += busiest->__cpu_power *
> -				min(busiest_load_per_task, max_load - tmp);
> -
> -		/* Amount of load we'd add */
> -		if (max_load * busiest->__cpu_power <
> -				busiest_load_per_task * SCHED_LOAD_SCALE)
> -			tmp = sg_div_cpu_power(this,
> -					max_load * busiest->__cpu_power);
> -		else
> -			tmp = sg_div_cpu_power(this,
> -				busiest_load_per_task * SCHED_LOAD_SCALE);
> -		pwr_move += this->__cpu_power *
> -				min(this_load_per_task, this_load + tmp);
> -		pwr_move /= SCHED_LOAD_SCALE;
> -
> -		/* Move if we gain throughput */
> -		if (pwr_move > pwr_now)
> +		if (max_vruntime_group == this)
>  			*imbalance = busiest_load_per_task;
> +		else
> +			*imbalance = 0;

Not sure how this all interacts when some of the cpu's are idle. I have to
look more closely.

thanks,
suresh
