Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZKECT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZKECT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZKECTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:19:55 -0500
Received: from mga05.intel.com ([192.55.52.89]:39646 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754828AbZKECTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:19:54 -0500
X-ExtLoop1: 1
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, alex.shi@intel.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1257336461.16163.18.camel@marge.simson.net>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
	 <1257222791.16282.46.camel@ymzhang>  <20091103174531.GA14747@elte.hu>
	 <1257299745.16282.49.camel@ymzhang>
	 <1257336461.16163.18.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Nov 2009 10:20:44 +0800
Message-Id: <1257387645.16282.66.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 13:07 +0100, Mike Galbraith wrote:
> On Wed, 2009-11-04 at 09:55 +0800, Zhang, Yanmin wrote:
> > On Tue, 2009-11-03 at 18:45 +0100, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > On Tue, 2009-11-03 at 11:47 +0800, Alex Shi wrote:
> > > > > We found the UDP-U 1k/4k stream of netperf benchmark have some
> > > > > performance regression from 10% to 20% on our Tulsa and some NHM
> > > > > machines. 
> > > > ﻿ perf events shows function find_busiest_group consumes about 4.5% cpu 
> > > > time with the patch while it only consumes 0.5% cpu time without the 
> > > > patch.
> > > > 
> > > > The communication between netperf client and netserver is very fast. 
> > > > When netserver receives a message and there is no new message 
> > > > available, it goes to sleep and scheduler calls idle_balance => 
> > > > load_balance_newidle. load_balance_newidle spends too much time and a 
> > > > new message arrives quickly before load_balance_newidle ends.
> > > > 
> > > > As the comments in the patch say hackbench benefits from it, I tested 
> > > > hackbench on Nehalem and core2 machines. hackbench does benefit from 
> > > > it, about 6% on nehalem machines, but doesn't benefit on core2 
> > > > machines.
> > > 
> > > Can you confirm that -tip:
> > > 
> > >   http://people.redhat.com/mingo/tip.git/README
> > > 
> > > has it fixed (or at least improved)?
> > The latest tips improves netperf loopback result, but doesn't fix it
> > thoroughly. For example, on a Nehalem machine, netperf UDP-U-1k has
> > about 25% regression, but with the tips kernel, the regression becomes
> > less than 10%.
> 

> Can you try the below, and send me 
I tested it on Nehalem machine against the latest tips kernel. netperf loopback
result is good and regression disappears.

tbench result has no improvement.

> your UDP-U-1k args so I can try it? 
#taskset -c 0 ./netserver
#taskset -c 15 ./netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -i 50 3 -I 99 5 -- -P 12384,12888 -s 32768 -S 32768 -m 4096

Pls. check /proc/cpuinfo to make sure cpu 0 and cpu 15 are not in the
same physical cpu.

I also run sysbench(oltp)+mysql testing with thread number 14,16,18,20,32,64,128. The average
number is good. If I compare every single result against 2.6.32-rc5's, I find thread number
﻿14,16,18,20,32's result are better than 2.6.32-rc5's, but 64,128's result are worse. 128's is
the worst.

>  
> 
> The below shows promise for stopping newidle from harming cache, though
> it needs to be more clever than a holdoff.  The fact that it only harms
> the _very_ sensitive to idle time x264 testcase by 5% shows some
> promise.
> 
> tip v2.6.32-rc6-1731-gc5bb4b1
> tbench 8                                1044.66 MB/sec 8 procs
> x264 8                                  366.58 frames/sec -start_debit 392.24 fps -newidle 215.34 fps
> 
> tip+ v2.6.32-rc6-1731-gc5bb4b1
> tbench 8                                1040.08 MB/sec 8 procs .995
> x264 8                                  350.23 frames/sec -start_debit 371.76
>                                           .955                           .947
> 
> mysql+oltp
> clients             1          2          4          8         16         32         64        128        256
> tip          10447.14   19734.58   36038.18   35776.85   34662.76   33682.30   32256.22   28770.99   25323.23
>              10462.61   19580.14   36050.48   35942.63   35054.84   33988.40   32423.89   29259.65   25892.24
>              10501.02   19231.27   36007.03   35985.32   35060.79   33945.47   32400.42   29140.84   25716.16
> tip avg      10470.25   19515.33   36031.89   35901.60   34926.13   33872.05   32360.17   29057.16   25643.87
> 
> tip+         10594.32   19912.01   36320.45   35904.71   35100.37   34003.38   32453.04   28413.57   23871.22
>              10667.96   20000.17   36533.72   36472.19   35371.35   34208.85   32617.80   28893.55   24499.34
>              10463.25   19915.69   36657.20   36419.08   35403.15   34041.80   32612.94   28835.82   24323.52
> tip+ avg     10575.17   19942.62   36503.79   36265.32   35291.62   34084.67   32561.26   28714.31   24231.36
>                 1.010      1.021      1.013      1.010      1.010      1.006      1.006       .988       .944
> 
> 
> ---
>  kernel/sched.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -590,6 +590,7 @@ struct rq {
>  
>  	u64 rt_avg;
>  	u64 age_stamp;
> +	u64 newidle_ratelimit;
>  #endif
>  
>  	/* calc_load related fields */
> @@ -2383,6 +2384,8 @@ static int try_to_wake_up(struct task_st
>  	if (rq != orig_rq)
>  		update_rq_clock(rq);
>  
> +	rq->newidle_ratelimit = rq->clock;
> +
>  	WARN_ON(p->state != TASK_WAKING);
>  	cpu = task_cpu(p);
>  
> @@ -4427,6 +4430,12 @@ static void idle_balance(int this_cpu, s
>  	struct sched_domain *sd;
>  	int pulled_task = 0;
>  	unsigned long next_balance = jiffies + HZ;
> +	u64 delta = this_rq->clock - this_rq->newidle_ratelimit;
> +
> +	if (delta < sysctl_sched_migration_cost)
> +		return;
> +
> +	this_rq->newidle_ratelimit = this_rq->clock;
>  
>  	for_each_domain(this_cpu, sd) {
>  		unsigned long interval;
> 
> 
> 
> 

