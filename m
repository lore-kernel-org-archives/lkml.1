Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYAOVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYAOVa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYAOVas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:30:48 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:50239 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbYAOVar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:30:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAOO0jEdMROHU/2dsb2JhbACBWKot
Date: Tue, 15 Jan 2008 16:30:44 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 28/30 v3] Generic command line storage
Message-ID: <20080115213044.GC17439@Krystal>
References: <20080115204907.838227723@goodmis.org> <20080115205026.559348520@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080115205026.559348520@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:21:58 up 73 days,  2:27,  5 users,  load average: 0.83, 1.73,
	1.79
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> Saving the comm of tasks for each trace is very expensive.
> This patch includes in the context switch hook, a way to
> store the last 100 command lines of tasks. This table is
> examined when a trace is to be printed.
> 

Instead of saving the comm at context switch, could we save them when a
process exits ? (actually, if we want to do this right, we would also
have to trace the changes of "comm" upon exec(), so we deal correctly
with processes that do multiple execs).

This way, we would not duplicate the comm of processes still active in
the system, and would trigger on a much lower event-rate trace point.

And the idea would be to save only the comm of processes present in your
summary (top X processes); why do you save the last 100 ? (if the system
has more than 100 active tasks, this code will always be executed, which
seems bad)

Also, if we do as I propose, we would have to keep process exit/exec
tracing active until the summary is cleared, even though the rest of
"high event rate" tracing could be stopped sooner.

Mathieu

> Note: The comm may be destroyed if other traces are performed.
> Later (TBD) patches may simply store this information in the trace
> itself.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  lib/tracing/Kconfig              |    1 
>  lib/tracing/trace_function.c     |    2 
>  lib/tracing/trace_irqsoff.c      |    3 +
>  lib/tracing/trace_sched_switch.c |   14 +++-
>  lib/tracing/tracer.c             |  112 +++++++++++++++++++++++++++++++++++++--
>  lib/tracing/tracer.h             |    5 +
>  6 files changed, 128 insertions(+), 9 deletions(-)
> 
> Index: linux-compile.git/lib/tracing/Kconfig
> ===================================================================
> --- linux-compile.git.orig/lib/tracing/Kconfig	2008-01-15 10:34:22.000000000 -0500
> +++ linux-compile.git/lib/tracing/Kconfig	2008-01-15 10:41:28.000000000 -0500
> @@ -19,6 +19,7 @@ config FUNCTION_TRACER
>  	default n
>  	select MCOUNT
>  	select TRACING
> +	select CONTEXT_SWITCH_TRACER
>  	help
>  	  Use profiler instrumentation, adding -pg to CFLAGS. This will
>  	  insert a call to an architecture specific __mcount routine,
> Index: linux-compile.git/lib/tracing/trace_function.c
> ===================================================================
> --- linux-compile.git.orig/lib/tracing/trace_function.c	2008-01-15 10:26:28.000000000 -0500
> +++ linux-compile.git/lib/tracing/trace_function.c	2008-01-15 10:41:28.000000000 -0500
> @@ -70,9 +70,11 @@ static void function_trace_ctrl_update(s
>  	if (tr->ctrl ^ val) {
>  		if (val) {
>  			trace_enabled = 1;
> +			atomic_inc(&trace_record_cmdline);
>  			register_mcount_function(&trace_ops);
>  		} else {
>  			trace_enabled = 0;
> +			atomic_dec(&trace_record_cmdline);
>  			unregister_mcount_function(&trace_ops);
>  		}
>  		tr->ctrl = val;
> Index: linux-compile.git/lib/tracing/trace_irqsoff.c
> ===================================================================
> --- linux-compile.git.orig/lib/tracing/trace_irqsoff.c	2008-01-15 10:27:32.000000000 -0500
> +++ linux-compile.git/lib/tracing/trace_irqsoff.c	2008-01-15 10:41:28.000000000 -0500
> @@ -93,6 +93,9 @@ static void update_max_tr(struct tracing
>  	save->policy = current->policy;
>  	save->rt_priority = current->rt_priority;
>  
> +	/* record this tasks comm */
> +	tracing_record_cmdline(current);
> +
>  	/* from memcpy above: save->trace = data->trace */
>  	data->trace = max_buffer;
>  	max_buffer = save->trace;
> Index: linux-compile.git/lib/tracing/trace_sched_switch.c
> ===================================================================
> --- linux-compile.git.orig/lib/tracing/trace_sched_switch.c	2008-01-15 10:37:11.000000000 -0500
> +++ linux-compile.git/lib/tracing/trace_sched_switch.c	2008-01-15 10:41:28.000000000 -0500
> @@ -31,7 +31,7 @@ static notrace void sched_switch_callbac
>  	va_list ap;
>  	int cpu;
>  
> -	if (!trace_enabled)
> +	if (!atomic_read(&trace_record_cmdline))
>  		return;
>  
>  	va_start(ap, format);
> @@ -49,6 +49,11 @@ static notrace void sched_switch_callbac
>  	/* Ignore prev_state, since we get that from prev itself */
>  	va_end(ap);
>  
> +	tracing_record_cmdline(prev);
> +
> +	if (!trace_enabled)
> +		return;
> +
>  	raw_local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
>  	data = tr->data[cpu];
> @@ -82,10 +87,13 @@ static void sched_switch_trace_ctrl_upda
>  		sched_switch_reset(tr);
>  
>  	if (tr->ctrl ^ val) {
> -		if (val)
> +		if (val) {
> +			atomic_inc(&trace_record_cmdline);
>  			trace_enabled = 1;
> -		else
> +		} else {
> +			atomic_dec(&trace_record_cmdline);
>  			trace_enabled = 0;
> +		}
>  		tr->ctrl = val;
>  	}
>  }
> Index: linux-compile.git/lib/tracing/tracer.c
> ===================================================================
> --- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-15 10:37:38.000000000 -0500
> +++ linux-compile.git/lib/tracing/tracer.c	2008-01-15 10:42:46.000000000 -0500
> @@ -49,6 +49,88 @@ void notrace tracing_reset(struct tracin
>  	atomic_set(&data->underrun, 0);
>  }
>  
> +#define SAVED_CMDLINES 128
> +static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
> +static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
> +static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
> +static int cmdline_idx;
> +static DEFINE_SPINLOCK(trace_cmdline_lock);
> +atomic_t trace_record_cmdline;
> +atomic_t trace_record_cmdline_disabled;
> +
> +static void trace_init_cmdlines(void)
> +{
> +	memset(&map_pid_to_cmdline, -1, sizeof(map_pid_to_cmdline));
> +	memset(&map_cmdline_to_pid, -1, sizeof(map_cmdline_to_pid));
> +	cmdline_idx = 0;
> +}
> +
> +notrace void trace_stop_cmdline_recording(void);
> +
> +static void notrace trace_save_cmdline(struct task_struct *tsk)
> +{
> +	unsigned map;
> +	unsigned idx;
> +
> +	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
> +		return;
> +
> +	/*
> +	 * It's not the end of the world if we don't get
> +	 * the lock, but we also don't want to spin
> +	 * nor do we want to disable interrupts,
> +	 * so if we miss here, then better luck next time.
> +	 */
> +	if (!spin_trylock(&trace_cmdline_lock))
> +		return;
> +
> +	idx = map_pid_to_cmdline[tsk->pid];
> +	if (idx >= SAVED_CMDLINES) {
> +		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
> +
> +		map = map_cmdline_to_pid[idx];
> +		if (map <= PID_MAX_DEFAULT)
> +			map_pid_to_cmdline[map] = (unsigned)-1;
> +
> +		map_pid_to_cmdline[tsk->pid] = idx;
> +
> +		cmdline_idx = idx;
> +	}
> +
> +	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
> +
> +	spin_unlock(&trace_cmdline_lock);
> +}
> +
> +static notrace char *trace_find_cmdline(int pid)
> +{
> +	char *cmdline = "<...>";
> +	unsigned map;
> +
> +	if (!pid)
> +		return "<idle>";
> +
> +	if (pid > PID_MAX_DEFAULT)
> +		goto out;
> +
> +	map = map_pid_to_cmdline[pid];
> +	if (map >= SAVED_CMDLINES)
> +		goto out;
> +
> +	cmdline = saved_cmdlines[map];
> +
> + out:
> +	return cmdline;
> +}
> +
> +void tracing_record_cmdline(struct task_struct *tsk)
> +{
> +	if (atomic_read(&trace_record_cmdline_disabled))
> +		return;
> +
> +	trace_save_cmdline(tsk);
> +}
> +
>  static inline notrace struct tracing_entry *
>  tracing_get_trace_entry(struct tracing_trace *tr,
>  			struct tracing_trace_cpu *data)
> @@ -90,7 +172,6 @@ tracing_generic_entry_update(struct trac
>  		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
>  		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
>  		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
> -	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
>  }
>  
>  notrace void tracing_function_trace(struct tracing_trace *tr,
> @@ -242,6 +323,8 @@ static void *s_start(struct seq_file *m,
>  	loff_t l = 0;
>  	int i;
>  
> +	atomic_inc(&trace_record_cmdline_disabled);
> +
>  	/* let the tracer grab locks here if needed */
>  	if (iter->tr->start)
>  		iter->tr->start(iter);
> @@ -269,6 +352,8 @@ static void s_stop(struct seq_file *m, v
>  {
>  	struct tracing_iterator *iter = m->private;
>  
> +	atomic_dec(&trace_record_cmdline_disabled);
> +
>  	/* let the tracer release locks here if needed */
>  	if (iter->tr->stop)
>  		iter->tr->stop(iter);
> @@ -390,8 +475,11 @@ static void notrace
>  lat_print_generic(struct seq_file *m, struct tracing_entry *entry, int cpu)
>  {
>  	int hardirq, softirq;
> +	char *comm;
>  
> -	seq_printf(m, "%8.8s-%-5d ", entry->comm, entry->pid);
> +	comm = trace_find_cmdline(entry->pid);
> +
> +	seq_printf(m, "%8.8s-%-5d ", comm, entry->pid);
>  	seq_printf(m, "%d", cpu);
>  	seq_printf(m, "%c%c",
>  		   (entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
> @@ -453,9 +541,12 @@ print_lat_fmt(struct seq_file *m, struct
>  	abs_usecs = cycles_to_usecs(entry->t - iter->tr->time_start);
>  
>  	if (verbose) {
> +		char *comm;
> +
> +		comm = trace_find_cmdline(entry->pid);
>  		seq_printf(m, "%16s %5d %d %d %08x %08x [%08lx]"
>  			   " %ld.%03ldms (+%ld.%03ldms): ",
> -			   entry->comm,
> +			   comm,
>  			   entry->pid, cpu, entry->flags,
>  			   entry->preempt_count, trace_idx,
>  			   cycles_to_usecs(entry->t),
> @@ -491,6 +582,9 @@ static void notrace print_trace_fmt(stru
>  	unsigned long secs;
>  	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
>  	unsigned long long t;
> +	char *comm;
> +
> +	comm = trace_find_cmdline(iter->ent->pid);
>  
>  	t = cycles_to_usecs(iter->ent->t);
>  	usec_rem = do_div(t, 1000000ULL);
> @@ -498,7 +592,7 @@ static void notrace print_trace_fmt(stru
>  
>  	seq_printf(m, "[%5lu.%06lu] ", secs, usec_rem);
>  	seq_printf(m, "CPU %d: ", iter->cpu);
> -	seq_printf(m, "%s:%d ", iter->ent->comm,
> +	seq_printf(m, "%s:%d ", comm,
>  		   iter->ent->pid);
>  	switch (iter->ent->type) {
>  	case TRACE_FN:
> @@ -812,6 +906,14 @@ static __init int trace_init_debugfs(voi
>  	return 0;
>  }
>  
> -device_initcall(trace_init_debugfs);
> +static __init int trace_init(void)
> +{
> +	trace_init_cmdlines();
> +
> +	return trace_init_debugfs();
> +
> +}
> +
> +device_initcall(trace_init);
>  
>  #endif /* CONFIG_DEBUG_FS */
> Index: linux-compile.git/lib/tracing/tracer.h
> ===================================================================
> --- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-15 10:34:22.000000000 -0500
> +++ linux-compile.git/lib/tracing/tracer.h	2008-01-15 10:41:28.000000000 -0500
> @@ -25,7 +25,6 @@ struct tracing_entry {
>  	char preempt_count; /* assumes PREEMPT_MASK is 8 bits or less */
>  	int pid;
>  	cycle_t t;
> -	char comm[TASK_COMM_LEN];
>  	union {
>  		struct tracing_function fn;
>  		struct tracing_sched_switch ctx;
> @@ -92,11 +91,15 @@ void tracing_sched_switch_trace(struct t
>  				struct task_struct *prev,
>  				int next_pid,
>  				unsigned long flags);
> +void tracing_record_cmdline(struct task_struct *tsk);
>  
>  extern struct file_operations tracing_fops;
>  extern struct file_operations tracing_lt_fops;
>  extern struct file_operations tracing_ctrl_fops;
>  
> +extern atomic_t trace_record_cmdline;
> +extern atomic_t trace_record_cmdline_disabled;
> +
>  static inline notrace cycle_t now(void)
>  {
>  	return get_monotonic_cycles();
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
