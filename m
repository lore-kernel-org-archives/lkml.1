Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbZAPO4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbZAPO4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760979AbZAPOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:55:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760552AbZAPOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:55:44 -0500
Subject: Re: [patch 3/5] x86, ftrace, hw-branch-tracer: dump on oops
From: Steven Rostedt <srostedt@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com
In-Reply-To: <20090116115829.A30245@sedona.ch.intel.com>
References: <20090116115829.A30245@sedona.ch.intel.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 16 Jan 2009 09:55:24 -0500
Message-Id: <1232117724.21980.80.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, you have two 1/5 patches but no 2/5 patch.

On Fri, 2009-01-16 at 11:58 +0100, Markus Metzger wrote:
> Dump the branch trace on an oops (based on ftrace_dump_on_oops).

Does the ftrace_dump_on_oops not work?  We may want to change
ftrace_dump to see if a tracer has been registered, and use its format
for output.


> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> ---
> 
> Index: ftrace/arch/x86/kernel/dumpstack.c
> ===================================================================
> --- ftrace.orig/arch/x86/kernel/dumpstack.c	2009-01-14 15:21:46.000000000 +0100
> +++ ftrace/arch/x86/kernel/dumpstack.c	2009-01-14 15:26:11.000000000 +0100
> @@ -14,6 +14,7 @@
>  #include <linux/bug.h>
>  #include <linux/nmi.h>
>  #include <linux/sysfs.h>
> +#include <linux/ftrace.h>
>  
>  #include <asm/stacktrace.h>
>  
> @@ -195,6 +196,11 @@
>  	int cpu;
>  	unsigned long flags;
>  
> +	/* notify the hw-branch tracer so it may disable tracing and
> +	   add the last trace to the trace buffer -
> +	   the earlier this happens, the more useful the trace. */
> +	trace_hw_branch_oops();
> +
>  	oops_enter();
>  
>  	/* racy, but better than risking deadlock. */
> Index: ftrace/kernel/trace/trace.h
> ===================================================================
> --- ftrace.orig/kernel/trace/trace.h	2009-01-14 15:21:46.000000000 +0100
> +++ ftrace/kernel/trace/trace.h	2009-01-14 15:26:11.000000000 +0100
> @@ -415,7 +415,6 @@
>  
>  void trace_graph_return(struct ftrace_graph_ret *trace);
>  int trace_graph_entry(struct ftrace_graph_ent *trace);
> -void trace_hw_branch(struct trace_array *tr, u64 from, u64 to);
>  
>  void tracing_start_cmdline_record(void);
>  void tracing_stop_cmdline_record(void);
> Index: ftrace/kernel/trace/trace_hw_branches.c
> ===================================================================
> --- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-01-14 15:26:07.000000000 +0100
> +++ ftrace/kernel/trace/trace_hw_branches.c	2009-01-14 15:26:11.000000000 +0100
> @@ -39,6 +39,7 @@
>  #define this_buffer per_cpu(buffer, smp_processor_id())
>  
>  static int __read_mostly trace_hw_branches_enabled;
> +static struct trace_array *hw_branch_trace __read_mostly;
>  
> 
>  /*
> @@ -127,6 +128,8 @@
>  
>  static int bts_trace_init(struct trace_array *tr)
>  {
> +	hw_branch_trace = tr;
> +
>  	register_hotcpu_notifier(&bts_hotcpu_notifier);
>  	tracing_reset_online_cpus(tr);
>  	bts_trace_start(tr);
> @@ -138,6 +141,8 @@
>  {
>  	bts_trace_stop(tr);
>  	unregister_hotcpu_notifier(&bts_hotcpu_notifier);
> +
> +	hw_branch_trace = NULL;

unless you test hw_branch_trace for content, I usually never NULL the
local tracer variable. This prevents races. The worst that can happen
without nulling it, is that your tracer will write into another tracer's
buffer. No real harm done. But if you have it as null and a race
happens, you can crash the kernel.


-- Steve

>  }
>  
>  static void bts_trace_print_header(struct seq_file *m)
> @@ -166,8 +171,9 @@
>  	return TRACE_TYPE_UNHANDLED;
>  }
>  
> -void trace_hw_branch(struct trace_array *tr, u64 from, u64 to)
> +void trace_hw_branch(u64 from, u64 to)
>  {
> +	struct trace_array *tr = hw_branch_trace;
>  	struct ring_buffer_event *event;
>  	struct hw_branch_entry *entry;
>  	unsigned long irq1, irq2;
> @@ -200,8 +206,7 @@
>  	local_irq_restore(irq1);
>  }
>  
> -static void trace_bts_at(struct trace_array *tr,
> -			 const struct bts_trace *trace, void *at)
> +static void trace_bts_at(const struct bts_trace *trace, void *at)
>  {
>  	struct bts_struct bts;
>  	int err = 0;
> @@ -216,7 +221,7 @@
>  
>  	switch (bts.qualifier) {
>  	case BTS_BRANCH:
> -		trace_hw_branch(tr, bts.variant.lbr.from, bts.variant.lbr.to);
> +		trace_hw_branch(bts.variant.lbr.from, bts.variant.lbr.to);
>  		break;
>  	}
>  }
> @@ -232,12 +237,15 @@
>  	const struct bts_trace *trace;
>  	unsigned char *at;
>  
> -	if (!this_tracer)
> +	if (unlikely(!tr))
>  		return;
>  
>  	if (unlikely(atomic_read(&tr->data[raw_smp_processor_id()]->disabled)))
>  		return;
>  
> +	if (unlikely(!this_tracer))
> +		return;
> +
>  	ds_suspend_bts(this_tracer);
>  	trace = ds_read_bts(this_tracer);
>  	if (!trace)
> @@ -245,11 +253,11 @@
>  
>  	for (at = trace->ds.top; (void *)at < trace->ds.end;
>  	     at += trace->ds.size)
> -		trace_bts_at(tr, trace, at);
> +		trace_bts_at(trace, at);
>  
>  	for (at = trace->ds.begin; (void *)at < trace->ds.top;
>  	     at += trace->ds.size)
> -		trace_bts_at(tr, trace, at);
> +		trace_bts_at(trace, at);
>  
>  out:
>  	ds_resume_bts(this_tracer);
> @@ -264,6 +272,15 @@
>  	mutex_unlock(&bts_tracer_mutex);
>  }
>  
> +void trace_hw_branch_oops(void)
> +{
> +	mutex_lock(&bts_tracer_mutex);
> +
> +	trace_bts_cpu(hw_branch_trace);
> +
> +	mutex_unlock(&bts_tracer_mutex);
> +}
> +
>  struct tracer bts_tracer __read_mostly =
>  {
>  	.name		= "hw-branch-tracer",
> Index: ftrace/include/linux/ftrace.h
> ===================================================================
> --- ftrace.orig/include/linux/ftrace.h	2009-01-14 15:21:46.000000000 +0100
> +++ ftrace/include/linux/ftrace.h	2009-01-14 15:26:11.000000000 +0100
> @@ -492,4 +492,17 @@
>  
>  #endif /* CONFIG_TRACING */
>  
> +
> +#ifdef CONFIG_HW_BRANCH_TRACER
> +
> +void trace_hw_branch(u64 from, u64 to);
> +void trace_hw_branch_oops(void);
> +
> +#else /* CONFIG_HW_BRANCH_TRACER */
> +
> +static inline void trace_hw_branch(u64 from, u64 to) {}
> +static inline void trace_hw_branch_oops(void) {}
> +
> +#endif /* CONFIG_HW_BRANCH_TRACER */
> +
>  #endif /* _LINUX_FTRACE_H */
> ---------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen Germany
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
> VAT Registration No.: DE129385895
> Citibank Frankfurt (BLZ 502 109 00) 600119052
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 

