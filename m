Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZL2CZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZL2CZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 21:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZL2CZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 21:25:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:41384 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZL2CZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 21:25:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,465,1257148800"; 
   d="scan'208";a="759788150"
Subject: Re: tbench regression with 2.6.33-rc1
From: Lin Ming <ming.m.lin@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1261902760.6201.33.camel@marge.simson.net>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 29 Dec 2009 10:09:42 +0800
Message-Id: <1262052582.10685.59.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-27 at 16:32 +0800, Mike Galbraith wrote:
> On Fri, 2009-12-25 at 19:11 +0800, Lin Ming wrote:
> > Hi,
> > 
> > Test machine: 16 cpus (4P/2Core/HT), 8G mem
> > tbench test command:
> > tbench_srv &
> > tbench 32
> > 
> > Compared with 2.6.32, tbench has ~4% regression in 2.6.33-rc1.
> > 
> > >>From vmstat data, the context switch number also drop ~4%.
> > perf top data does not show much differences.
> > 
> > But lockstat data shows huge difference in rq->lock, as below.
> > See the attachment for the full lockstat data.
> > 
> > Any clue of this regression?
> 
> Nope, but I see regression I haven't been able to identify as well.

Hi, Mike

More info here,
I only saw regression on Tulsa machine.
No regression on Nehalem core 2 machine.

And also no regression if I run tbench with RT scheduler on tulsa
machine, as below command,

schedtool -R -p 20 -e tbench_srv &
schedtool -R -p 20 -e tbench 32

So seems this regression is CFS scheduler related.
I also did a lot of bisect, but the result was not stable.
Looks like this regression was not caused by a single commit.

Lin Ming

> 
> Tbench state of the union according to my box below.
> 
> With a max performance config, 32.2 is down ~4% vs 31.9, most of which
> is doing affinity checks on every wakeup.  That has it's benefits too,
> but definitely ain't free, or even particularly cheap for fast movers.
> Would be nice to find a way to keep the ramp-up improvements without
> this much cost.
> 
> Perf also isn't free, and in 33, we lost the ability to config it out,
> but even doing so via axe, there's an unidentified regression.
> 
> As usual, bisection of tbench variance was a wasted effort.
> 
> 2.6.31.9  = -CONFIG_PERF_COUNTERS
> 2.6.31.9p = +CONFIG_PERF_COUNTERS
> 2.6.32.2  = -CONFIG_PERF_EVENTS
> 2.6.32.2p = +CONFIG_PERF_EVENTS
> git = v2.6.33-rc2
> tip = v2.6.33-rc1-306-gae7a88c
> 
> tbench 8
> 2.6.31.9             1190 MB/sec
> 2.6.31.9p            1172 MB/sec  .984
> 2.6.32.2             1146 MB/sec  .977 vs 31.9 .963
> 2.6.32.2p            1129 MB/sec  .985 vs 31.9 .948
> 2.6.33.git           1117 MB/sec  .989 vs 31.9 .938
> 2.6.33.tip           1121 MB/sec 1.003 vs 31.9 .942
> 
> 2.6.32.2             1146 MB/sec 1.000
> 2.6.32.2x            1181 MB/sec 1.030 vs 31.9 .992
> 
> 2.6.33.git           1117 MB/sec 1.000
> 2.6.33.gitx          1145 MB/sec 1.025 vs 32.2x .969 vs 31.9 .962  (perf/hwbp off via axe)
> 
> 2.6.32.2x diff
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d079a9f..b71cb91 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2363,6 +2363,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
>  	orig_cpu = cpu;
>  
>  #ifdef CONFIG_SMP
> +	if (cpu == this_cpu)
> +		goto out_stats;
> +
>  	if (unlikely(task_running(rq, p)))
>  		goto out_activate;
>  
> @@ -2389,6 +2392,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
>  	WARN_ON(p->state != TASK_WAKING);
>  	cpu = task_cpu(p);
>  
> +out_stats:
>  #ifdef CONFIG_SCHEDSTATS
>  	schedstat_inc(rq, ttwu_count);
>  	if (cpu == this_cpu)
> 
> 

