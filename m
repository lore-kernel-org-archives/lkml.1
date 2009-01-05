Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbZAEX6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbZAEX6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZAEX5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:57:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:11090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZAEX5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=asTLRjV/UD6/+Vb+UymYiQso6RC6CkGf631EtstpH3HpwXGB9mowU4mpr4d4YzjRUR
         xZmntyy1QQRF03MGVYcUXHoRjDTwAvlFmM/dXCeWhxx68dgjFfi8vdOHc60JsVET0gg7
         qS5Y6JcF+trwpAk5Uvm1ltTEO2pcKr5y1HU9g=
Date: Tue, 6 Jan 2009 00:57:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: tracing only syscalls
	mode
Message-ID: <20090105235744.GB6531@nowhere>
References: <495abce9.0baa660a.04de.60ae@mx.google.com> <alpine.DEB.1.10.0901051404480.27085@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901051404480.27085@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 02:11:08PM -0500, Steven Rostedt wrote:
> 
> On Tue, 30 Dec 2008, Frederic Weisbecker wrote:
> 
> > Impact: make more easy the syscalls tracing
> > 
> > This patch extends to syscalls the features which let one to trace
> > only one ore more function (and those they call).
> > This way we can get rid of the workqueues, kernel threads, softirqs from
> > ksoftirqd and only have the syscall path on the trace.
> > 
> > Note that hardirq that interrupt the syscalls are still traced. But we could
> > add an option to disable the interrupt tracing as well in the future.
> > 
> > To use this new feature:
> > 
> > echo function_graph > /debugfs/tracing/current_tracer
> > echo syscalls > /debugfs/tracing/set_graph_function
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  arch/x86/include/asm/thread_info.h |    4 +-
> >  arch/x86/kernel/ptrace.c           |    4 ++
> >  include/linux/ftrace.h             |  104 ++++++++++++++++++++----------------
> >  kernel/trace/ftrace.c              |   61 +++++++++++++++++++++
> >  kernel/trace/trace.h               |    3 +-
> >  5 files changed, 127 insertions(+), 49 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> > index efdf938..447fa17 100644
> > --- a/arch/x86/include/asm/thread_info.h
> > +++ b/arch/x86/include/asm/thread_info.h
> > @@ -94,6 +94,7 @@ struct thread_info {
> >  #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
> >  #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
> >  #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
> > +#define TIF_SYSCALL_FTRACE	27	/* For ftrace syscalls tracing */
> >  
> >  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
> >  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> > @@ -116,10 +117,11 @@ struct thread_info {
> >  #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
> >  #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
> >  #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
> > +#define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
> >  
> >  /* work to do in syscall_trace_enter() */
> >  #define _TIF_WORK_SYSCALL_ENTRY	\
> > -	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | \
> > +	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_FTRACE |\
> >  	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
> >  
> >  /* work to do in syscall_trace_leave() */
> > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > index 0a5df5f..1a6e72f 100644
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/audit.h>
> >  #include <linux/seccomp.h>
> >  #include <linux/signal.h>
> > +#include <linux/ftrace.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/pgtable.h>
> > @@ -1397,6 +1398,9 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
> >  {
> >  	long ret = 0;
> >  
> > +	/* Tell the function graph tracer we are entering a system call */
> > +	ftrace_graph_syscall_enter();
> > +
> 
> You would not mind me converting this to a tracepoint so that other
> tracers could tap into this.


Good idea!

 
> >  	/*
> >  	 * If we stepped into a sysenter/syscall insn, it trapped in
> >  	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 677432b..4f22902 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -357,6 +357,52 @@ static inline void trace_power_end(struct power_trace *it) { }
> >  #endif
> >  
> >  
> > +#ifdef CONFIG_TRACING
> > +#include <linux/sched.h>
> > +
> > +/* flags for current->trace */
> > +enum {
> > +	TSK_TRACE_FL_TRACE_BIT	= 0,
> > +	TSK_TRACE_FL_GRAPH_BIT	= 1,
> > +};
> > +enum {
> > +	TSK_TRACE_FL_TRACE	= 1 << TSK_TRACE_FL_TRACE_BIT,
> > +	TSK_TRACE_FL_GRAPH	= 1 << TSK_TRACE_FL_GRAPH_BIT,
> > +};
> > +
> > +static inline void set_tsk_trace_trace(struct task_struct *tsk)
> > +{
> > +	set_bit(TSK_TRACE_FL_TRACE_BIT, &tsk->trace);
> > +}
> > +
> > +static inline void clear_tsk_trace_trace(struct task_struct *tsk)
> > +{
> > +	clear_bit(TSK_TRACE_FL_TRACE_BIT, &tsk->trace);
> > +}
> > +
> > +static inline int test_tsk_trace_trace(struct task_struct *tsk)
> > +{
> > +	return tsk->trace & TSK_TRACE_FL_TRACE;
> > +}
> > +
> > +static inline void set_tsk_trace_graph(struct task_struct *tsk)
> > +{
> > +	set_bit(TSK_TRACE_FL_GRAPH_BIT, &tsk->trace);
> > +}
> > +
> > +static inline void clear_tsk_trace_graph(struct task_struct *tsk)
> > +{
> > +	clear_bit(TSK_TRACE_FL_GRAPH_BIT, &tsk->trace);
> > +}
> > +
> > +static inline int test_tsk_trace_graph(struct task_struct *tsk)
> > +{
> > +	return tsk->trace & TSK_TRACE_FL_GRAPH;
> > +}
> > +
> > +#endif /* CONFIG_TRACING */
> > +
> > +
> >  /*
> >   * Structure that defines an entry function trace.
> >   */
> > @@ -430,7 +476,15 @@ static inline void unpause_graph_tracing(void)
> >  {
> >  	atomic_dec(&current->tracing_graph_pause);
> >  }
> > -#else
> > +
> > +extern bool ftrace_graph_syscalls;
> > +
> > +static inline void ftrace_graph_syscall_enter(void)
> > +{
> > +	if (ftrace_graph_syscalls)
> > +		set_tsk_trace_graph(current);
> 
> We could eliminate this global variable with the tracepoint.


Not really, it is needed on the test when we trace functions on entry
to decide if we ignore or not.

 
> > +}
> > +#else /* !CONFIG_FUNCTION_GRAPH_TRACER */
> >  
> >  #define __notrace_funcgraph
> >  #define __irq_entry
> > @@ -445,51 +499,7 @@ static inline int task_curr_ret_stack(struct task_struct *tsk)
> >  
> >  static inline void pause_graph_tracing(void) { }
> >  static inline void unpause_graph_tracing(void) { }
> > -#endif
> > -
> > -#ifdef CONFIG_TRACING
> > -#include <linux/sched.h>
> > -
> > -/* flags for current->trace */
> > -enum {
> > -	TSK_TRACE_FL_TRACE_BIT	= 0,
> > -	TSK_TRACE_FL_GRAPH_BIT	= 1,
> > -};
> > -enum {
> > -	TSK_TRACE_FL_TRACE	= 1 << TSK_TRACE_FL_TRACE_BIT,
> > -	TSK_TRACE_FL_GRAPH	= 1 << TSK_TRACE_FL_GRAPH_BIT,
> > -};
> > -
> > -static inline void set_tsk_trace_trace(struct task_struct *tsk)
> > -{
> > -	set_bit(TSK_TRACE_FL_TRACE_BIT, &tsk->trace);
> > -}
> > -
> > -static inline void clear_tsk_trace_trace(struct task_struct *tsk)
> > -{
> > -	clear_bit(TSK_TRACE_FL_TRACE_BIT, &tsk->trace);
> > -}
> > -
> > -static inline int test_tsk_trace_trace(struct task_struct *tsk)
> > -{
> > -	return tsk->trace & TSK_TRACE_FL_TRACE;
> > -}
> > -
> > -static inline void set_tsk_trace_graph(struct task_struct *tsk)
> > -{
> > -	set_bit(TSK_TRACE_FL_GRAPH_BIT, &tsk->trace);
> > -}
> > -
> > -static inline void clear_tsk_trace_graph(struct task_struct *tsk)
> > -{
> > -	clear_bit(TSK_TRACE_FL_GRAPH_BIT, &tsk->trace);
> > -}
> > -
> > -static inline int test_tsk_trace_graph(struct task_struct *tsk)
> > -{
> > -	return tsk->trace & TSK_TRACE_FL_GRAPH;
> > -}
> > -
> > -#endif /* CONFIG_TRACING */
> > +static inline void ftrace_graph_syscall_enter(void) { }
> > +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >  
> >  #endif /* _LINUX_FTRACE_H */
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 2f32969..9ed22ee 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1338,6 +1338,40 @@ static DEFINE_MUTEX(graph_lock);
> >  
> >  int ftrace_graph_count;
> >  unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
> > +bool ftrace_graph_syscalls;
> > +static char *syscall_str = "syscalls";
> > +
> > +/* Tell ptrace that we trace all syscalls from all tasks */
> > +static void ftrace_graph_syscalls_start(void)
> > +{
> > +	struct task_struct *g, *t;
> > +	unsigned long flags;
> > +
> > +	ftrace_graph_syscalls = true;
> 
> If we keep this global, it would be better to have it after you set the 
> TIF_SYSCALL_FTRACE flag, otherwise your traces might look funny. With some 
> tasks being traced and others not.
> 
> -- Steve


Nice catch. It's indeed racy.
I will resend a fixed patch when I find some time.
Thanks!


> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +	do_each_thread(g, t) {
> > +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +}
> > +
> > +/* Remove the syscall flag trace for all tasks */
> > +static void ftrace_graph_syscalls_stop(void)
> > +{
> > +	struct task_struct *g, *t;
> > +	unsigned long flags;
> > +
> > +	ftrace_graph_syscalls = false;
> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +	do_each_thread(g, t) {
> > +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +}
> >  
> >  static void *
> >  g_next(struct seq_file *m, void *v, loff_t *pos)
> > @@ -1359,6 +1393,13 @@ static void *g_start(struct seq_file *m, loff_t *pos)
> >  
> >  	mutex_lock(&graph_lock);
> >  
> > +	/*
> > +	 * Syscalls tracing is special and is not on the
> > +	 * ftrace_graph_funcs tab. Print it as the first entry.
> > +	 */
> > +	if (!*pos && ftrace_graph_syscalls)
> > +		return syscall_str;
> > +
> >  	p = g_next(m, p, pos);
> >  
> >  	return p;
> > @@ -1377,6 +1418,11 @@ static int g_show(struct seq_file *m, void *v)
> >  	if (!ptr)
> >  		return 0;
> >  
> > +	if (v == syscall_str) {
> > +		seq_printf(m, "%s\n", syscall_str);
> > +		return 0;
> > +	}
> > +
> >  	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> >  
> >  	seq_printf(m, "%s\n", str);
> > @@ -1403,6 +1449,7 @@ ftrace_graph_open(struct inode *inode, struct file *file)
> >  	if ((file->f_mode & FMODE_WRITE) &&
> >  	    !(file->f_flags & O_APPEND)) {
> >  		ftrace_graph_count = 0;
> > +		ftrace_graph_syscalls_stop();
> >  		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
> >  	}
> >  
> > @@ -1533,6 +1580,15 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
> >  	}
> >  	buffer[index] = 0;
> >  
> > +	/*
> > +	 * Catch the special syscall tracing request,
> > +	 * it is not enabled like other functions.
> > +	 */
> > +	if (!strcmp(syscall_str, buffer)) {
> > +		ftrace_graph_syscalls_start();
> > +		goto out_syscalls;
> > +	}
> > +
> >  	/* we allow only one at a time */
> >  	ret = ftrace_set_func(array, ftrace_graph_count, buffer);
> >  	if (ret)
> > @@ -1540,6 +1596,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
> >  
> >  	ftrace_graph_count++;
> >  
> > +out_syscalls:
> >  	file->f_pos += read;
> >  
> >  	ret = read;
> > @@ -2091,6 +2148,10 @@ void ftrace_graph_init_task(struct task_struct *t)
> >  		t->curr_ret_stack = -1;
> >  		atomic_set(&t->tracing_graph_pause, 0);
> >  		atomic_set(&t->trace_overrun, 0);
> > +
> > +		if (ftrace_graph_syscalls)
> > +			set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +
> >  	} else
> >  		t->ret_stack = NULL;
> >  }
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index a8b624c..f372fbb 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -521,7 +521,8 @@ static inline int ftrace_graph_addr(unsigned long addr)
> >  {
> >  	int i;
> >  
> > -	if (!ftrace_graph_count || test_tsk_trace_graph(current))
> > +	if ((!ftrace_graph_count && !ftrace_graph_syscalls)
> > +			|| test_tsk_trace_graph(current))
> >  		return 1;
> >  
> >  	for (i = 0; i < ftrace_graph_count; i++) {
> > -- 
> > 1.6.0.4
> > 
> > 
> > 
> > 

