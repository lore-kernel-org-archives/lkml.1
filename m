Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbZL0Icq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbZL0Icq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 03:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZL0Icq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 03:32:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:60167 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750762AbZL0Icp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 03:32:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/LR3EixkvLT/NnZ//3DXDurUNMsd1qIOuxRGsykF
	KTP14TwKNMeqfZ
Subject: Re: tbench regression with 2.6.33-rc1
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1261739467.10685.18.camel@minggr.sh.intel.com>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Sun, 27 Dec 2009 09:32:40 +0100
Message-Id: <1261902760.6201.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-25 at 19:11 +0800, Lin Ming wrote:
> Hi,
> 
> Test machine: 16 cpus (4P/2Core/HT), 8G mem
> tbench test command:
> tbench_srv &
> tbench 32
> 
> Compared with 2.6.32, tbench has ~4% regression in 2.6.33-rc1.
> 
> >>From vmstat data, the context switch number also drop ~4%.
> perf top data does not show much differences.
> 
> But lockstat data shows huge difference in rq->lock, as below.
> See the attachment for the full lockstat data.
> 
> Any clue of this regression?

Nope, but I see regression I haven't been able to identify as well.

Tbench state of the union according to my box below.

With a max performance config, 32.2 is down ~4% vs 31.9, most of which
is doing affinity checks on every wakeup.  That has it's benefits too,
but definitely ain't free, or even particularly cheap for fast movers.
Would be nice to find a way to keep the ramp-up improvements without
this much cost.

Perf also isn't free, and in 33, we lost the ability to config it out,
but even doing so via axe, there's an unidentified regression.

As usual, bisection of tbench variance was a wasted effort.

2.6.31.9  = -CONFIG_PERF_COUNTERS
2.6.31.9p = +CONFIG_PERF_COUNTERS
2.6.32.2  = -CONFIG_PERF_EVENTS
2.6.32.2p = +CONFIG_PERF_EVENTS
git = v2.6.33-rc2
tip = v2.6.33-rc1-306-gae7a88c

tbench 8
2.6.31.9             1190 MB/sec
2.6.31.9p            1172 MB/sec  .984
2.6.32.2             1146 MB/sec  .977 vs 31.9 .963
2.6.32.2p            1129 MB/sec  .985 vs 31.9 .948
2.6.33.git           1117 MB/sec  .989 vs 31.9 .938
2.6.33.tip           1121 MB/sec 1.003 vs 31.9 .942

2.6.32.2             1146 MB/sec 1.000
2.6.32.2x            1181 MB/sec 1.030 vs 31.9 .992

2.6.33.git           1117 MB/sec 1.000
2.6.33.gitx          1145 MB/sec 1.025 vs 32.2x .969 vs 31.9 .962  (perf/hwbp off via axe)

2.6.32.2x diff
diff --git a/kernel/sched.c b/kernel/sched.c
index d079a9f..b71cb91 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2363,6 +2363,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	orig_cpu = cpu;
 
 #ifdef CONFIG_SMP
+	if (cpu == this_cpu)
+		goto out_stats;
+
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
@@ -2389,6 +2392,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
 
+out_stats:
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);
 	if (cpu == this_cpu)


