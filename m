Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYJDSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYJDSR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 14:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYJDSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 14:17:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYJDSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 14:17:49 -0400
Date: Sat, 4 Oct 2008 14:17:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Add a C-state tracer to help power
 optimization
In-Reply-To: <20081004105447.0e48d6d4@infradead.org>
Message-ID: <alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
References: <20081004105447.0e48d6d4@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My comments are more towards Ingo than to Arjan.

On Sat, 4 Oct 2008, Arjan van de Ven wrote:
> +++ b/kernel/trace/Kconfig
> @@ -134,6 +134,17 @@ config BOOT_TRACER
>  	  be enabled if this tracer is selected since only one tracer
>  	  should touch the tracing buffer at a time.
>  
> +config CSTATE_TRACER
> +	bool "Trace C-state behavior"
> +	depends on HAVE_FTRACE

Ingo, here's the confusion again between the FTRACE infrastructure and
the ftrace "function tracer". the HAVE_FTRACE should really be
HAVE_FUNCTION_TRACER. The infrastructure of a lot of the ftrace tracers
do not depend on the function tracer.

The CSTATE_TRACER also does not depend on HAVE_FTRACE. Think we should 
rename this? Otherwise more kernel developers will get confused by it. :-(

> +	depends on DEBUG_KERNEL
> +	depends on X86
> +	select TRACING
> +	help
> +	  This tracer helps developers to analyize and optimize the kernels
> +	  power management decisions, specifically the C-state behavior.
> +
> +
>  config STACK_TRACER
>  	bool "Trace max stack"
>  	depends on HAVE_FTRACE
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index a85dfba..2b85724 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
>  obj-$(CONFIG_STACK_TRACER) += trace_stack.o
>  obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
>  obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
> +obj-$(CONFIG_CSTATE_TRACER) += trace_cstate.o
>  
>  libftrace-y := ftrace.o
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index a921ba5..1ef1ded 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -117,6 +117,11 @@ struct trace_boot {
>  	struct boot_trace	initcall;
>  };
>  
> +struct trace_cstate {
> +	struct trace_entry	ent;
> +	struct cstate_trace	state_data;
> +};
> +
>  /*
>   * trace_flag_type is an enumeration that holds different
>   * states when a trace occurs. These are:
> diff --git a/kernel/trace/trace_cstate.c b/kernel/trace/trace_cstate.c
> new file mode 100644
> index 0000000..272c577
> --- /dev/null
> +++ b/kernel/trace/trace_cstate.c
> @@ -0,0 +1,131 @@
> +/*
> + * ring buffer based C-state tracer
> + *
> + * Arjan van de Ven <arjan@linux.intel.com>
> + * Copyright (C) 2009 Intel Corporation
> + *
> + * Much is borrowed from trace_boot.c which is
> + * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/debugfs.h>
> +#include <linux/ftrace.h>
> +#include <linux/kallsyms.h>
> +
> +#include "trace.h"
> +
> +static struct trace_array *cstate_trace;
> +static int trace_cstate_enabled;
> +
> +
> +static void start_cstate_trace(void)
> +{
> +	trace_cstate_enabled = 1;
> +}
> +
> +static void stop_cstate_trace(struct trace_array *tr)
> +{
> +	trace_cstate_enabled = 0;
> +}
> +
> +static void cstate_trace_init(struct trace_array *tr)
> +{
> +	int cpu;
> +	cstate_trace = tr;
> +
> +	trace_cstate_enabled = 1;
> +
> +	for_each_cpu_mask(cpu, cpu_possible_map)
> +		tracing_reset(tr, cpu);
> +}
> +
> +static void cstate_trace_ctrl_update(struct trace_array *tr)
> +{
> +	if (tr->ctrl)
> +		start_cstate_trace();
> +	else
> +		stop_cstate_trace(tr);
> +}
> +
> +static enum print_line_t cstate_print_line(struct trace_iterator *iter)
> +{
> +	int ret;
> +	struct trace_entry *entry = iter->ent;
> +	struct trace_cstate *field = (struct trace_cstate *)entry;

Ingo, isn't the trace_assign_type in your latest tree?

-- Steve

> +	struct cstate_trace *it = &field->state_data;
> +	struct trace_seq *s = &iter->seq;
> +	struct timespec stamp = ktime_to_timespec(it->stamp);
> +	struct timespec duration = ktime_to_timespec(
> +					ktime_sub(it->end, it->stamp));
> +
> +	if (entry->type == TRACE_BOOT) {
> +		ret = trace_seq_printf(s, "[%5ld.%09ld] Going to C%i on cpu %i for %ld.%09ld\n",
> +					  stamp.tv_sec,
> +					  stamp.tv_nsec,
> +					  it->state, iter->cpu,
> +					  duration.tv_sec,
> +					  duration.tv_nsec);
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +		return TRACE_TYPE_HANDLED;
> +	}
> +	return TRACE_TYPE_UNHANDLED;
> +}
> +
