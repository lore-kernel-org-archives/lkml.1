Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZBLLDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZBLLDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756540AbZBLLDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:03:00 -0500
Received: from viefep16-int.chello.at ([62.179.121.36]:46416 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbZBLLC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:02:59 -0500
X-SourceIP: 213.46.9.244
Subject: Re: Time slice for SCHED_BATCH ( CFS)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: J K Rai <jk.anurag@yahoo.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <466094.58460.qm@web94704.mail.in2.yahoo.com>
References: <315626.71453.qm@web94713.mail.in2.yahoo.com>
	 <20090211102024.GI20518@elte.hu> <1234348436.23438.119.camel@twins>
	 <303179.28635.qm@web94707.mail.in2.yahoo.com>
	 <1234357350.23438.149.camel@twins>
	 <441046.97200.qm@web94712.mail.in2.yahoo.com>
	 <1234430011.23438.200.camel@twins>
	 <466094.58460.qm@web94704.mail.in2.yahoo.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 12:04:56 +0100
Message-Id: <1234436696.23438.239.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 15:51 +0530, J K Rai wrote:
> Thanks a lot,

LKML etiquette prefers if you do not top-post, and your email to at
least have a plain text copy -- thanks.

> Some more queries:
> 
> 1) For a scenario where we can assume to have some 2*n running
> processes and n cpus, which settings should one perform thru sysctl -w
> to get almost constant and reasonable long (server class) slices.
> Should one change both sched_min_granularity_ns and sched_latency_ns.
> Is it OK to use SCHED_BATCH (thru chrt) or SCHED_OTHER (the default)
> will suffice.

At that point each cpu ought to have 2 tasks, which is lower than the
default nr_latency, so you'll end up with 20ms*(1+log2(nr_cpus)) / 2
slices.

Which is plenty long to qualify as server class imho.

> 2) May I know about few more scheduler settings as shown below:
> sched_wakeup_granularity_ns

  measure of unfairness in order to achieve progress. CFS will schedule
that task that has received least service, the wakeup granularity
governs wakeup-preemption and will let a that be that much not left most
and still not preempt it, this is so that it can make some progress.

> sched_batch_wakeup_granularity_ns

This does not exist anymore, you must be running something ancient ;-)

> sched_features

Too much detail, its a bitmask with each bit a 'feature', its basically
a set of things where we had to make a random choice in the
implementation and wanted a switch.

> sched_migration_cost

Measure for how expensive it is to move a task between cpus.

> sched_nr_migrate

Limit on the number of tasks it iterates when load-balancing, this is a
latency thing.

> sched_rt_period_us
> sched_rt_runtime_us

global bandwidth limit on RT tasks, they get runtime every period.

> sched_compat_yield

Some broken programs rely on implementation details of sched_yield() for
SCHED_OTHER -- POSIX doesn't define sched_yield() for anything but FIFO
(maybe RR), so any implementation is a good one :-)

> 3)
> 
>  latency := 20ms * (1 + log2(nr_cpus))
>  min_granularity := 4ms * (1 + log2(nr_cpus))
>  nr_latency := floor(latency / min_granularity)
> 
> min_granularity -- since we let slices get smaller the more tasks
> there
> are in roughly: latency/nr_running fashion, we want to avoid them
> getting too small. min_granularity provides a lower bound.
> 
>         latency ; nr_running <= nr_latency
>  period = {
>           nr_running * min_granularity ; nr_running > nr_latency
>  
>  slice = task_weight * period / runqueue_weight
> 
> 3) In above schema  how the task weights are calculated? 
> That calculation may cause the slices to get smaller as you said. If I
> understand correctly.

Nice value is mapped to task weight:

/*
 * Nice levels are multiplicative, with a gentle 10% change for every
 * nice level changed. I.e. when a CPU-bound task goes from nice 0 to
 * nice 1, it will get ~10% less CPU time than another CPU-bound task
 * that remained on nice 0.
 *
 * The "10% effect" is relative and cumulative: from _any_ nice level,
 * if you go up 1 level, it's -10% CPU usage, if you go down 1 level
 * it's +10% CPU usage. (to achieve that we use a multiplier of 1.25.
 * If a task goes up by ~10% and another task goes down by ~10% then
 * the relative distance between them is ~25%.)
 */
static const int prio_to_weight[40] = {
 /* -20 */     88761,     71755,     56483,     46273,     36291,
 /* -15 */     29154,     23254,     18705,     14949,     11916,
 /* -10 */      9548,      7620,      6100,      4904,      3906,
 /*  -5 */      3121,      2501,      1991,      1586,      1277,
 /*   0 */      1024,       820,       655,       526,       423,
 /*   5 */       335,       272,       215,       172,       137,
 /*  10 */       110,        87,        70,        56,        45,
 /*  15 */        36,        29,        23,        18,        15,
};

fixed point, 10 bits.


