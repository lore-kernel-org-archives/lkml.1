Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYJFUqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYJFUqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYJFUqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:46:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYJFUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:46:12 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power optimization
From: Andi Kleen <andi@firstfloor.org>
References: <20081006102640.481acd23@infradead.org>
Date: Mon, 06 Oct 2008 22:46:09 +0200
In-Reply-To: <20081006102640.481acd23@infradead.org> (Arjan van de Ven's message of "Mon, 6 Oct 2008 10:26:40 -0700")
Message-ID: <87y711moz2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

This might be a subtle issue, but when someone starts synchronizing
their clocksource read with idle (which makes sense in some circumstances) 
then your timing will break because ktime_get() might be inaccurate directly 
coming out of idle before other code ran.

That's theoretical right now, but could be a real danger in the future.
  
> @@ -426,6 +428,8 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
>  		}
>  	}
>  
> +	trace_power_mark(&it, POWER_PSTATE, next_perf_state);

Wouldn't that be better higher up in the cpufreq system?  It would
seem bad to duplicate that in all low level cpufreq modules.

Also I suspect some higher level format would be good here too.
Just put the frequency in? 

> +	bool "Trace power consumption behavior"
> +	depends on DEBUG_KERNEL
> +	depends on X86
> +	select TRACING
> +	help
> +	  This tracer helps developers to analyize and optimize the kernels
> +	  power management decisions, specifically the C-state and P-state
> +	  behavior.

Reference to the required userland?

> +	stamp = ktime_to_timespec(it->stamp);
> +	duration = ktime_to_timespec(ktime_sub(it->end, it->stamp));
> +
> +	if (entry->type == TRACE_POWER) {
> +		if (it->type == POWER_CSTATE)
> +			ret = trace_seq_printf(s, "[%5ld.%09ld] CSTATE: Going to C%i on cpu %i for %ld.%09ld\n",
> +					  stamp.tv_sec,
> +					  stamp.tv_nsec,
> +					  it->state, iter->cpu,
> +					  duration.tv_sec,
> +					  duration.tv_nsec);
> +		if (it->type == POWER_PSTATE)
> +			ret = trace_seq_printf(s, "[%5ld.%09ld] PSTATE: Going to P%i on cpu %i\n",
> +					  stamp.tv_sec,
> +					  stamp.tv_nsec,
> +					  it->state, iter->cpu);

I suspect a less verbose output format would be better.

> +{
> +	if (!trace_power_enabled)
> +		return;
> +
> +	memset(it, 0, sizeof(struct power_trace));

The memset seems redundant.


> +void trace_power_end(struct power_trace *it)
> +{
> +	struct ring_buffer_event *event;
> +	struct trace_power *entry;
> +	struct trace_array_cpu *data;
> +	unsigned long irq_flags;
> +	struct trace_array *tr = power_trace;
> +
> +	if (!trace_power_enabled)
> +		return;
> +
> +	preempt_disable();
> +	it->end = ktime_get();
> +	data = tr->data[smp_processor_id()];
> +
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> +					 &irq_flags);
> +	if (!event)
> +		goto out;
> +	entry	= ring_buffer_event_data(event);
> +	tracing_generic_entry_update(&entry->ent, 0, 0);
> +	entry->ent.type = TRACE_POWER;
> +	entry->state_data = *it;
> +	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);

When ring_buffer_lock_reserve really disables interrupts (I haven't
checked since it's not in 2.6.27rc8) you could avoid the
preempt_disable by moving the data = tr->data ... one below.

Similar comments to trace_power_mark. Also it would be probably good 
to use a common function instead of duplicating so much code.


> +	it->state = level;
> +	it->type = type;
> +	it->stamp = ktime_get();
> +	preempt_disable();
> +	it->end = it->stamp;
> +	data = tr->data[smp_processor_id()];
> +
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
> +					 &irq_flags);
> +	if (!event)
> +		goto out;
> +	entry	= ring_buffer_event_data(event);
> +	tracing_generic_entry_update(&entry->ent, 0, 0);
> +	entry->ent.type = TRACE_POWER;
> +	entry->state_data = *it;
> +	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
> +
> +	trace_wake_up();

Hmm, that does a unconditional wake_up() in idle. Doesn't this cause a loop
on UP?

idle -> wakeup -> idle -> wakeup -> ... etc.

Am I missing something?

> +#
> +# 	cat /sys/kernel/debug/tracer/trace | perl power.pl > out.svg

The cat is not needed

-Andi
-- 
ak@linux.intel.com
