Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZIMXbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZIMXbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZIMXbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:31:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212AbZIMXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:31:38 -0400
Date: Sun, 13 Sep 2009 16:30:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       peterz@infradead.org, yanmin_zhang@linux.intel.com,
       torvalds@linux-foundation.org, jens.axboe@oracle.com
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-Id: <20090913163007.a1b967c2.akpm@linux-foundation.org>
In-Reply-To: <20090911174019.1ed02737@infradead.org>
References: <20090911174019.1ed02737@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 17:40:19 +0200 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] cpuidle: A new variant of the menu governor
> 
> This patch adds a new idle governor which balances power savings,
> energy efficiency and performance impact.
> 
> The reason for a reworked governor is that there have been
> serious performance issues reported with the existing code
> on Nehalem server systems.
> 
> To show this I'm sure Andrew wants to see benchmark results:
> (benchmark is "fio", "no cstates" is using "idle=poll")
> 
> 		no cstates	current linux	new algorithm
> 1 disk		107 Mb/s	85 Mb/s		105 Mb/s
> 2 disks		215 Mb/s	123 Mb/s	209 Mb/s
> 12 disks	590 Mb/s	320 Mb/s	585 Mb/s
> 
> In various power benchmark measurements, no degredation was found
> by our measurement&diagnostics team. Obviously a bit more power was
> used in the "fio" benchmark, due to the much higher performance.
> 
> The integration plan for this is to first add the new governor,
> but for one kernel generation, leave the old menu governor in place
> so that it's possible to separate out behavior from this governor
> versus other things in diagnostics. If no issues are found,
> I'll remove the old governor in the kernel cycle after that.

We can't just fix up the existing code?

What worries me about the integration plan is that we find that there
are some machines/workloads where the old code worked better and we
can't find a way to fix the new code so we end up with two
implementations for users to choose between.  As happened (and
continues to happen) with slab.

> While it would be a novel idea to describe the new algorithm in this
> commit message, I cheaped out and described it in comments in the
> code instead.
> 
>
> ...
>
> +#define BUCKETS 12
> +#define RESOLUTION 1024
> +#define DECAY 4
> +#define MAX_INTERESTING 50000

Interesting!  Unobvious what it does though.

>
> ...
>
> +static int menu_select(struct cpuidle_device *dev)
> +{
> +	struct menu_device *data = &__get_cpu_var(menu_devices);
> +	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
> +	int i, multiplier;
> +
> +	data->last_state_idx = 0;
> +	data->exit_us = 0;
> +
> +	/* Special case when user has set very strict latency requirement */
> +	if (unlikely(latency_req == 0))
> +		return 0;
> +
> +	/* determine the expected residency time, round up */
> +	data->expected_us =
> +		(u32) (ktime_to_ns(tick_nohz_get_sleep_length())+999) / 1000;

That's DIV_ROUND_UP().

> +
> +	data->bucket = which_bucket(data->expected_us);
> +
> +	multiplier = performance_multiplier();
> +
> +	/*
> +	 * if the correction factor is 0 (eg first time init or cpu hotplug
> +	 * etc), we actually want to start out with a unity factor.
> +	 */
> +	if (data->correction_factor[data->bucket] == 0)
> +		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
> +
> +	/* Make sure to round up for half microseconds */
> +	data->predicted_us =
> +		(data->expected_us * data->correction_factor[data->bucket] +
> +		RESOLUTION * DECAY/2) / RESOLUTION / DECAY;
> +
> +	/*
> +	 * We want to default to C1 (hlt), not to busy polling
> +	 * unless the timer is happening really really soon.
> +	 */
> +	if (data->expected_us > 5)
> +		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
> +
> +
> +	/* find the deepest idle state that satisfies our constraints */
> +	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
> +		struct cpuidle_state *s = &dev->states[i];
> +
> +		if (s->target_residency > data->predicted_us)
> +			break;
> +		if (s->exit_latency > latency_req)
> +			break;
> +		if (s->exit_latency * multiplier > data->predicted_us)
> +			break;
> +		data->exit_us = s->exit_latency;
> +		data->last_state_idx = i;
> +	}
> +
> +	return data->last_state_idx;
> +}
> +
>
> ...
>
> +static void menu_reflect(struct cpuidle_device *dev)
> +{
> +	struct menu_device *data = &__get_cpu_var(menu_devices);
> +	int last_idx = data->last_state_idx;
> +	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
> +	struct cpuidle_state *target = &dev->states[last_idx];
> +	unsigned int measured_us;
> +	u64 new_factor;
> +
> +	/*
> +	 * Ugh, this idle state doesn't support residency measurements, so we
> +	 * are basically lost in the dark.  As a compromise, assume we slept
> +	 * for the whole expected time.
> +	 */
> +	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID)))
> +		last_idle_us = data->expected_us;
> +
> +
> +	measured_us = last_idle_us;
> +
> +	/*
> +	 * We correct for the exit latency; we are assuming here that the
> +	 * exit latency happens after the event that we're interested in.
> +	 */
> +	if (measured_us > data->exit_us)
> +		measured_us -= data->exit_us;
> +
> +
> +	/* update our correction ratio */
> +
> +	new_factor = data->correction_factor[data->bucket]
> +			* (DECAY - 1) / DECAY;

This code is available on 32-bit.  I wouldn't be surprised if we see
some udivdi2-isn't-there problems with some compiler versions.  We'll see.

> +	if (data->expected_us > 0 && data->measured_us < MAX_INTERESTING)
> +		new_factor += RESOLUTION * measured_us / data->expected_us;
> +	else
> +		/*
> +		 * we were idle so long that we count it as a perfect
> +		 * prediction
> +		 */
> +		new_factor += RESOLUTION;
> +
> +	/*
> +	 * We don't want as factor; we always want at least
> +	 * a tiny bit of estimated time.
> +	 */
> +	if (new_factor == 0)
> +		new_factor = 1;
> +
> +	data->correction_factor[data->bucket] = new_factor;
> +}
> +
>
> ...
>
> +unsigned long nr_iowait_cpu(void)
> +{
> +	int this_cpu = smp_processor_id();
> +	struct rq *this_rq = cpu_rq(this_cpu);
> +	return atomic_read(&this_rq->nr_iowait);
> +}
> +
> +unsigned long this_cpu_load(void)
> +{
> +	int this_cpu = smp_processor_id();
> +	struct rq *this_rq = cpu_rq(this_cpu);
> +	return this_rq->cpu_load[0];
> +}

hm, how come we don't get smp_processor_id-in-preemptible warnings. 
Are all current callers pinned to a CPU?


some spelling fixlets:


--- a/drivers/cpuidle/governors/menu-tng.c~cpuidle-a-new-variant-of-the-menu-governor-to-boost-io-performance-fix
+++ a/drivers/cpuidle/governors/menu-tng.c
@@ -32,7 +32,7 @@
  *
  * For the menu-tng governor, there are 3 decision factors for picking a C
  * state:
- * 1) Energie break even point
+ * 1) Energy break even point
  * 2) Performance impact
  * 3) Latency tolerance (from pmqos infrastructure)
  * These these three factors are treated independently.
@@ -55,12 +55,12 @@
  * menu-tng uses a running average for this correction factor, however it uses a
  * set of factors, not just a single factor. This stems from the realization
  * that the ratio is dependent on the order of magnitude of the expected
- * duration; if we expect 500 milliseconds of idle time the likelyhood of
+ * duration; if we expect 500 milliseconds of idle time the likelihood of
  * getting an interrupt very early is much higher than if we expect 50 micro
  * seconds of idle time. A second independent factor that has big impact on
  * the actual factor is if there is (disk) IO outstanding or not.
  * (as a special twist, we consider every sleep longer than 50 milliseconds
- * as perfect; there is no power gains for sleeping longer than this)
+ * as perfect; there are no power gains for sleeping longer than this)
  *
  * For these two reasons we keep an array of 12 independent factors, that gets
  * indexed based on the magnitude of the expected duration as well as the
_

