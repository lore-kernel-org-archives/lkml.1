Return-Path: <linux-kernel-owner+w=401wt.eu-S932575AbZHDKZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbZHDKZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932540AbZHDKZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:25:09 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:39966 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbZHDKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:25:07 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090721155648.A17047@sedona.ch.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 12:24:49 +0200
Message-Id: <1249381489.7924.186.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 15:56 +0200, Markus Metzger wrote:
> Implement a performance counter with:
>     attr.type           = PERF_TYPE_HARDWARE
>     attr.config         = PERF_COUNT_HW_BRANCH_INSTRUCTIONS
>     attr.sample_period  = 1
> 
> using branch trace store (BTS) on x86 hardware, if available.
> 
> The from and to address for each branch can be sampled using:
>     PERF_SAMPLE_IP      for the from address
>     PERF_SAMPLE_ADDR    for the to address
> 

Over all looks very nice, some comments below (could be addressed in a
delta patch).

Thanks Markus!

> +static int reserve_bts_hardware(void)
> +{
> +	int cpu, err = 0;
> +
> +	if (!bts_available())
> +		return -EOPNOTSUPP;
> +
> +	get_online_cpus();
> +
> +	for_each_possible_cpu(cpu) {
> +		struct debug_store *ds;
> +		void *buffer;
> +
> +		err = -ENOMEM;
> +		buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
> +		if (unlikely(!buffer))
> +			break;
> +
> +		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
> +		if (unlikely(!ds)) {
> +			kfree(buffer);
> +			break;
> +		}
> +
> +		ds->bts_buffer_base = (u64)(long)buffer;
> +		ds->bts_index = ds->bts_buffer_base;
> +		ds->bts_absolute_maximum =
> +			ds->bts_buffer_base + BTS_BUFFER_SIZE;
> +		ds->bts_interrupt_threshold =
> +			ds->bts_absolute_maximum - BTS_OVFL_TH;
> +
> +		per_cpu(cpu_hw_counters, cpu).ds = ds;
> +		err = 0;
> +	}
> +
> +	if (err)
> +		release_bts_hardware();
> +	else

 {

> +		for_each_online_cpu(cpu)
> +			init_debug_store_on_cpu(cpu);

 }

> +
> +	put_online_cpus();
> +
> +	return err;
> +}


> +static void intel_pmu_enable_bts(u64 config)
> +{
> +	unsigned long debugctlmsr;
> +
> +	debugctlmsr = get_debugctlmsr();
> +
> +	debugctlmsr |= (1 << 6);
> +	debugctlmsr |= (1 << 7);
> +
> +	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
> +		debugctlmsr |= (1 << 9);
> +
> +	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
> +		debugctlmsr |= (1 << 10);
> +
> +	update_debugctlmsr(debugctlmsr);
> +}
> +
> +static void intel_pmu_disable_bts(void)
> +{
> +	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
> +	unsigned long debugctlmsr;
> +
> +	if (!cpuc->ds)
> +		return;
> +
> +	debugctlmsr = get_debugctlmsr();
> +
> +	debugctlmsr &= ~(1 << 6);
> +	debugctlmsr &= ~(1 << 7);
> +	debugctlmsr &= ~(1 << 9);
> +	debugctlmsr &= ~(1 << 10);
> +
> +	update_debugctlmsr(debugctlmsr);
> +}

It would be good to not use these constants but instead use something
like:

#define X86_DEBUGCTL_TR		(1 << 6)
#define X86_DEBUGCTL_BTS	(1 << 7)
#define X86_DEBUGCTL_BTS_OS	(1 << 9)
#define X86_DEBUGCTL_BTS_USR	(1 << 10)

> @@ -1077,11 +1297,16 @@ fixed_mode_idx(struct perf_counter *coun
>  {
>  	unsigned int event;
>  
> +	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
> +
> +	if (unlikely((event ==
> +		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
> +		     (hwc->sample_period == 1)))
> +		return X86_PMC_IDX_FIXED_BTS;

I think we should validate this combination in hw_perf_counter_init()
and fail there if sample_period != 1.

> +static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
> +				       struct perf_sample_data *data)
> +{
> +	struct debug_store *ds = cpuc->ds;
> +	struct bts_record {
> +		u64	from;
> +		u64	to;
> +		u64	flags;
> +	};
> +	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
> +	unsigned long orig_ip = data->regs->ip;
> +	u64 at;
> +
> +	if (!counter)
> +		return;
> +
> +	if (!ds)
> +		return;
> +
> +	for (at = ds->bts_buffer_base;
> +	     at < ds->bts_index;
> +	     at += sizeof(struct bts_record)) {
> +		struct bts_record *rec = (struct bts_record *)(long)at;
> +
> +		data->regs->ip	= rec->from;
> +		data->addr	= rec->to;
> +
> +		perf_counter_output(counter, 1, data);
> +	}
> +
> +	ds->bts_index = ds->bts_buffer_base;
> +
> +	data->regs->ip	= orig_ip;
> +	data->addr	= 0;
> +}

You might want to set data->sample_period to 1 as well, just in case
someone is weird enough to request PERF_SAMPLE_PERIOD on a BTS
counter ;-)



