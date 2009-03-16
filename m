Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbZCPUPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbZCPUPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758970AbZCPUPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:15:38 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:58858 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759062AbZCPUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GgMzESnxb1Ce4p2LSkL4bEINALGt8TJsPhEPkNL2lM/fy9mZs3ZcYCkvjxzHpQcu9c
         D0YBb0hIexqpxeqTB+bU1dvLzz0NZGTL5H/vPlJFdLeKB2XDuvFEvU1oNBv3x7gsmziD
         QAjPXyYBAopsnUISFAAqR80atkorzju29D9YE=
Date: Mon, 16 Mar 2009 21:15:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090316201526.GE8393@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BEAA5A.4030708@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 03:36:58PM -0400, Masami Hiramatsu wrote:
> Hi Frederic,
> 
> Out of curiously, could you tell me why did you introduce new TIF instead of
> using utrace's tracehook API?
> For example, systemtap already use current utrace/tracehook api for tracing
> all syscalls. If there is any new advantage, it would be good to enhance
> existing utrace/tracehook.
> 
> Thank you,


Hi,

Because the tracehooks rely on ptrace work and both ftrace and ptrace would overlap
in a same flag, creating racy issues. At least ss far as I understood it.
How does systemtap manage it?

Thanks.

> 
> Frederic Weisbecker wrote:
> > The most important drawback that implies the syscall tracing is the variable
> > number of parameters that takes a syscall. Assuming there is a large number of
> > syscall, the goal is to provide as much as possible a generic layer on it.
> > 
> > What we want on tracing time (the hot path):
> > 
> > - Save the parameters and the number of the syscall. That's all. The rest of the
> >   job can be done on the "output path".
> > 
> > On output time:
> > 
> > - Get the raw-binary saved parameters and the syscall number as well as some
> >   usual infos such as the pid, the time...
> > - Depending on the tracing requirements, the user should have the choice to
> >   dump the raw datas or a formatted version.
> > 
> > The core infrastructure has a static array which contains the necessary
> > informations for each syscall (ok, I've only implemented 4 for now).
> > 
> > When a syscall triggers, the tracer look at this array (O(1) access) and get the
> > number of parameters for this syscall. Then these parameters are saved in a
> > binary form on the ring buffer with the syscall number (a generic version, arch
> > independent).
> > 
> > On output time the parameters, the name of the syscall and very basic
> > informations to format the parameters are picket from the ring-buffer and the
> > generic syscall array.
> > 
> > Depending of the level of implementation we want for the syscall inside this
> > array, we can provide just a single mask where the n bit matches the n
> > parameter. If the bit is set, then the parameter will be considered as a string
> > pointer. Otherwise its raw hexadecimal value will be printed.
> > 
> > If needed, we can otherwise provide a specific callback to print the syscall
> > event.
> > 
> > The probem with these approaches comes from the fact that the string might have
> > disappeared from the user memory on output time. Even if we protect against
> > faults, it can give unreliable traces.
> > So perhaps we could think about copying the string on tracing time.
> > 
> > Concerning the return value, it doesn't make any problem, a single raw
> > value is printed for each one.
> > 
> > Note that the current implementation can be easily scaled further to give only
> > binary informations to the user and the matching metadata to decode it.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/ftrace.h        |   44 +++++++
> >  kernel/trace/Kconfig          |   10 ++
> >  kernel/trace/Makefile         |    1 +
> >  kernel/trace/trace.c          |    6 +
> >  kernel/trace/trace.h          |   32 +++++
> >  kernel/trace/trace_syscalls.c |  284 +++++++++++++++++++++++++++++++++++++++++
> >  6 files changed, 377 insertions(+), 0 deletions(-)
> >  create mode 100644 kernel/trace/trace_syscalls.c
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index e1583f2..1798692 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -503,4 +503,48 @@ static inline void trace_hw_branch_oops(void) {}
> >  
> >  #endif /* CONFIG_HW_BRANCH_TRACER */
> >  
> > +/* Index for the ftrace syscalls array */
> > +enum syscall_trace_nr {
> > +	SYSCALL_TRACE_OPEN = 1,
> > +	SYSCALL_TRACE_CLOSE,
> > +	SYSCALL_TRACE_READ,
> > +	SYSCALL_TRACE_WRITE,
> > +
> > +	__SYSCALL_TRACE_END
> > +};
> > +
> > +/*
> > + * A syscall entry in the ftrace syscalls array.
> > + *
> > + * @name: name of the syscall
> > + * @nb_args: number of parameters it takes
> > + * @simple_format: if true, we use string_mask, otherwise the print callback
> > + * @string_mask: rudimentary format mask. If bit nr is set, the nr parameter
> > + *		 will be displayed as a string, otherwise it will be considered
> > + *		 as a raw number (hex displayed).
> > + * @print: implement it if you want a custom output for a given syscall
> > + */
> > +struct syscall_trace_entry {
> > +	const char	*name;
> > +	int		nb_args;
> > +	bool		simple_format;
> > +	union {
> > +		unsigned long string_mask;
> > +		int (*print)(unsigned long *);
> > +	} output;
> > +};
> > +
> > +#ifdef CONFIG_FTRACE_SYSCALLS
> > +extern short arch_syscall_trace_nr[];
> > +extern void start_ftrace_syscalls(void);
> > +extern void stop_ftrace_syscalls(void);
> > +extern void ftrace_syscall_enter(struct pt_regs *regs);
> > +extern void ftrace_syscall_exit(struct pt_regs *regs);
> > +#else
> > +static inline void start_ftrace_syscalls(void) { }
> > +static inline void stop_ftrace_syscalls(void) { }
> > +static inline void ftrace_syscall_enter(struct pt_regs *regs) { }
> > +static inline void ftrace_syscall_exit(struct pt_regs *regs) { }
> > +#endif
> > +
> >  #endif /* _LINUX_FTRACE_H */
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 8e4a2a6..95a0ad1 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -34,6 +34,9 @@ config HAVE_FTRACE_MCOUNT_RECORD
> >  config HAVE_HW_BRANCH_TRACER
> >  	bool
> >  
> > +config HAVE_FTRACE_SYSCALLS
> > +	bool
> > +
> >  config TRACER_MAX_TRACE
> >  	bool
> >  
> > @@ -175,6 +178,13 @@ config EVENT_TRACER
> >  	  allowing the user to pick and choose which trace point they
> >  	  want to trace.
> >  
> > +config FTRACE_SYSCALLS
> > +	bool "Trace syscalls"
> > +	depends on HAVE_FTRACE_SYSCALLS
> > +	select TRACING
> > +	help
> > +	  Basic tracer to catch the syscall entry and exit events.
> > +
> >  config BOOT_TRACER
> >  	bool "Trace boot initcalls"
> >  	select TRACING
> > diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> > index c7a2943..c3feea0 100644
> > --- a/kernel/trace/Makefile
> > +++ b/kernel/trace/Makefile
> > @@ -43,5 +43,6 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
> >  obj-$(CONFIG_EVENT_TRACER) += trace_events.o
> >  obj-$(CONFIG_EVENT_TRACER) += events.o
> >  obj-$(CONFIG_EVENT_TRACER) += trace_export.o
> > +obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
> >  
> >  libftrace-y := ftrace.o
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index cc94f86..5152be3 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -242,6 +242,12 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
> >  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> >  	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
> >  
> > +
> > +struct trace_array *__get_global_trace(void)
> > +{
> > +	return &global_trace;
> > +}
> > +
> >  /**
> >   * trace_wake_up - wake up tasks waiting for trace input
> >   *
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 2bfb7d1..9583830 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -30,6 +30,8 @@ enum trace_type {
> >  	TRACE_GRAPH_ENT,
> >  	TRACE_USER_STACK,
> >  	TRACE_HW_BRANCHES,
> > +	TRACE_SYSCALL_ENTER,
> > +	TRACE_SYSCALL_EXIT,
> >  	TRACE_KMEM_ALLOC,
> >  	TRACE_KMEM_FREE,
> >  	TRACE_POWER,
> > @@ -192,6 +194,19 @@ struct kmemtrace_free_entry {
> >  	const void *ptr;
> >  };
> >  
> > +struct syscall_trace_enter {
> > +	struct trace_entry	ent;
> > +	enum syscall_trace_nr	nr;
> > +	unsigned long		args[];
> > +};
> > +
> > +struct syscall_trace_exit {
> > +	struct trace_entry	ent;
> > +	enum syscall_trace_nr	nr;
> > +	unsigned long		ret;
> > +};
> > +
> > +
> >  /*
> >   * trace_flag_type is an enumeration that holds different
> >   * states when a trace occurs. These are:
> > @@ -304,6 +319,10 @@ extern void __ftrace_bad_type(void);
> >  			  TRACE_KMEM_ALLOC);	\
> >  		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
> >  			  TRACE_KMEM_FREE);	\
> > +		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
> > +			  TRACE_SYSCALL_ENTER);				\
> > +		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
> > +			  TRACE_SYSCALL_EXIT);				\
> >  		__ftrace_bad_type();					\
> >  	} while (0)
> >  
> > @@ -568,6 +587,7 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
> >  #endif /* CONFIG_FTRACE_STARTUP_TEST */
> >  
> >  extern void *head_page(struct trace_array_cpu *data);
> > +extern struct trace_array *__get_global_trace(void);
> >  extern long ns2usecs(cycle_t nsec);
> >  extern int
> >  trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
> > @@ -627,6 +647,18 @@ static inline int ftrace_trace_task(struct task_struct *task)
> >  	return test_tsk_trace_trace(task);
> >  }
> >  
> > +#ifdef CONFIG_FTRACE_SYSCALLS
> > +extern enum print_line_t
> > +print_syscall_enter(struct trace_iterator *iter, int flags);
> > +extern enum print_line_t
> > +print_syscall_exit(struct trace_iterator *iter, int flags);
> > +#else
> > +static inline enum print_line_t
> > +print_syscall_enter(struct trace_iterator *iter, int flags) { }
> > +static inline enum print_line_t
> > +print_syscall_exit(struct trace_iterator *iter, int flags) { }
> > +#endif
> > +
> >  /*
> >   * trace_iterator_flags is an enumeration that defines bit
> >   * positions into trace_flags that controls the output.
> > diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> > new file mode 100644
> > index 0000000..470bb9d
> > --- /dev/null
> > +++ b/kernel/trace/trace_syscalls.c
> > @@ -0,0 +1,284 @@
> > +#include <linux/kernel.h>
> > +#include <linux/ftrace.h>
> > +#include <asm/syscall.h>
> > +
> > +#include "trace_output.h"
> > +#include "trace.h"
> > +
> > +/* Create basic entry on syscall array (with the rudimentary string mask) */
> > +#define SYS_TRACE_ENTRY(sname, args, mask)			  \
> > +	{.name = #sname, .nb_args = args, .simple_format = true,  \
> > +	.output.string_mask = mask}
> > +
> > +/*
> > + * Create a custom defined entry on the syscall array, you will have to
> > + * implement a callback to output the syscall.
> > + */
> > +#define SYS_TRACE_ENTRY_SPECIAL(sname, args, printer)		  \
> > +	{.name = #sname, .nb_args = args, .simple_format = false, \
> > +	.print = printer}
> > +
> > +static const struct syscall_trace_entry syscall_trace_entries[] = {
> > +	/* For open, the first argument is a string, hence the given mask */
> > +	[SYSCALL_TRACE_OPEN]	= SYS_TRACE_ENTRY(open, 3, 0x1),
> > +	[SYSCALL_TRACE_CLOSE]	= SYS_TRACE_ENTRY(close, 1, 0),
> > +	[SYSCALL_TRACE_READ]	= SYS_TRACE_ENTRY(read, 3, 0),
> > +	[SYSCALL_TRACE_WRITE]	= SYS_TRACE_ENTRY(read, 3, 0),
> > +};
> > +
> > +
> > +static atomic_t refcount;
> > +
> > +enum print_line_t
> > +print_syscall_enter(struct trace_iterator *iter, int flags)
> > +{
> > +	struct trace_seq *s = &iter->seq;
> > +	struct trace_entry *ent = iter->ent;
> > +	struct syscall_trace_enter *trace;
> > +	enum syscall_trace_nr syscall;
> > +	const struct syscall_trace_entry *entry;
> > +	char *str = NULL;
> > +	int i, ret;
> > +
> > +	trace_assign_type(trace, ent);
> > +
> > +	syscall = trace->nr;
> > +
> > +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> > +		return TRACE_TYPE_HANDLED;
> > +
> > +	entry = &syscall_trace_entries[syscall];
> > +	if (!entry->simple_format) {
> > +		ret = entry->output.print(trace->args);
> > +		if (!ret)
> > +			return TRACE_TYPE_PARTIAL_LINE;
> > +	}
> > +
> > +	ret = trace_seq_printf(s, "syscall %s :", entry->name);
> > +	if (!ret)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +
> > +	for (i = 0; i < entry->nb_args; i++) {
> > +		/*
> > +		 * FIXME: the string comes from the user, but on tracing
> > +		 * output time, it may have disappeared from the memory.
> > +		 * May be better to strdup it on tracing time.
> > +		 */
> > +		if (entry->output.string_mask & (1 << i)) {
> > +			/* 128 is enough for most path */
> > +			str = strndup_user((char *)trace->args[i], 128);
> > +
> > +			/* If it faulted badly, the error shoud have been
> > +			 * handled while servicing the syscall, just ignore.
> > +			 */
> > +			if (str == ERR_PTR(-EFAULT) || str == ERR_PTR(-EINVAL)
> > +			    || str == ERR_PTR(-ENOMEM))
> > +				return TRACE_TYPE_HANDLED;
> > +
> > +			ret = trace_seq_printf(s, " %s", str);
> > +		} else {
> > +			ret = trace_seq_printf(s, " 0x%lx", trace->args[i]);
> > +		}
> > +		if (!ret)
> > +			goto end_partial;
> > +	}
> > +	if (!trace_seq_printf(s, "\n"))
> > +		goto end_partial;
> > +
> > +	kfree(str);
> > +	return TRACE_TYPE_HANDLED;
> > +
> > +end_partial:
> > +	kfree(str);
> > +	return TRACE_TYPE_PARTIAL_LINE;
> > +}
> > +
> > +enum print_line_t
> > +print_syscall_exit(struct trace_iterator *iter, int flags)
> > +{
> > +	struct trace_seq *s = &iter->seq;
> > +	struct trace_entry *ent = iter->ent;
> > +	struct syscall_trace_exit *trace;
> > +	enum syscall_trace_nr syscall;
> > +	const struct syscall_trace_entry *entry;
> > +	int ret;
> > +
> > +	trace_assign_type(trace, ent);
> > +
> > +	syscall = trace->nr;
> > +
> > +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> > +		return TRACE_TYPE_HANDLED;
> > +
> > +	entry = &syscall_trace_entries[syscall];
> > +
> > +	ret = trace_seq_printf(s, "syscall %s -> 0x%lx\n", entry->name,
> > +				trace->ret);
> > +	if (!ret)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +
> > +	return TRACE_TYPE_HANDLED;
> > +}
> > +
> > +void start_ftrace_syscalls(void)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +
> > +	if (atomic_inc_return(&refcount) != 1)
> > +		goto out;
> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +	do_each_thread(g, t) {
> > +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +out:
> > +	atomic_dec(&refcount);
> > +}
> > +
> > +void stop_ftrace_syscalls(void)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +
> > +	if (atomic_dec_return(&refcount))
> > +		goto out;
> > +
> > +	read_lock_irqsave(&tasklist_lock, flags);
> > +
> > +	do_each_thread(g, t) {
> > +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> > +	} while_each_thread(g, t);
> > +
> > +	read_unlock_irqrestore(&tasklist_lock, flags);
> > +out:
> > +	atomic_inc(&refcount);
> > +}
> > +
> > +void ftrace_syscall_enter(struct pt_regs *regs)
> > +{
> > +	struct trace_array *tr = __get_global_trace();
> > +	struct syscall_trace_enter *entry;
> > +	const struct syscall_trace_entry *sys_data;
> > +	struct ring_buffer_event *event;
> > +	struct trace_array_cpu *data;
> > +	int size;
> > +	int syscall_nr;
> > +	int nr_offset;
> > +	int cpu;
> > +
> > +	syscall_nr = syscall_get_nr(current, regs);
> > +	nr_offset = arch_syscall_trace_nr[syscall_nr];
> > +	if (!nr_offset || nr_offset >= __SYSCALL_TRACE_END)
> > +		return;
> > +
> > +	cpu = raw_smp_processor_id();
> > +	data = tr->data[cpu];
> > +
> > +	if (unlikely(atomic_read(&data->disabled)))
> > +		return;
> > +
> > +	sys_data = &syscall_trace_entries[nr_offset];
> > +	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
> > +
> > +	event = trace_buffer_lock_reserve(tr, TRACE_SYSCALL_ENTER, size, 0, 0);
> > +	if (!event)
> > +		return;
> > +
> > +	entry = ring_buffer_event_data(event);
> > +	entry->nr = nr_offset;
> > +	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
> > +
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> > +	trace_wake_up();
> > +}
> > +
> > +void ftrace_syscall_exit(struct pt_regs *regs)
> > +{
> > +	struct trace_array *tr = __get_global_trace();
> > +	struct syscall_trace_exit *entry;
> > +	const struct syscall_trace_entry *sys_data;
> > +	struct ring_buffer_event *event;
> > +	struct trace_array_cpu *data;
> > +	int syscall_nr;
> > +	int nr_offset;
> > +	int cpu;
> > +
> > +	syscall_nr = syscall_get_nr(current, regs);
> > +	nr_offset = arch_syscall_trace_nr[syscall_nr];
> > +	if (!nr_offset || nr_offset >= __SYSCALL_TRACE_END)
> > +		return;
> > +
> > +	cpu = raw_smp_processor_id();
> > +	data = tr->data[cpu];
> > +
> > +	if (unlikely(atomic_read(&data->disabled)))
> > +		return;
> > +
> > +	sys_data = &syscall_trace_entries[nr_offset];
> > +
> > +	event = trace_buffer_lock_reserve(tr, TRACE_SYSCALL_EXIT,
> > +				sizeof(*entry), 0, 0);
> > +	if (!event)
> > +		return;
> > +
> > +	entry = ring_buffer_event_data(event);
> > +	entry->nr = nr_offset;
> > +	entry->ret = syscall_get_return_value(current, regs);
> > +
> > +	ring_buffer_unlock_commit(tr->buffer, event);
> > +	trace_wake_up();
> > +}
> > +
> > +static int init_syscall_tracer(struct trace_array *tr)
> > +{
> > +	start_ftrace_syscalls();
> > +
> > +	return 0;
> > +}
> > +
> > +static void reset_syscall_tracer(struct trace_array *tr)
> > +{
> > +	stop_ftrace_syscalls();
> > +}
> > +
> > +static struct trace_event syscall_enter_event = {
> > +	.type	 	= TRACE_SYSCALL_ENTER,
> > +	.trace		= print_syscall_enter,
> > +};
> > +
> > +static struct trace_event syscall_exit_event = {
> > +	.type	 	= TRACE_SYSCALL_EXIT,
> > +	.trace		= print_syscall_exit,
> > +};
> > +
> > +static struct tracer syscall_tracer __read_mostly = {
> > +	.name	     	= "syscall",
> > +	.init		= init_syscall_tracer,
> > +	.reset		= reset_syscall_tracer
> > +};
> > +
> > +__init int register_ftrace_syscalls(void)
> > +{
> > +	int ret;
> > +
> > +	ret = register_ftrace_event(&syscall_enter_event);
> > +	if (!ret) {
> > +		printk(KERN_WARNING "event %d failed to register\n",
> > +		       syscall_enter_event.type);
> > +		WARN_ON_ONCE(1);
> > +	}
> > +
> > +	ret = register_ftrace_event(&syscall_exit_event);
> > +	if (!ret) {
> > +		printk(KERN_WARNING "event %d failed to register\n",
> > +		       syscall_exit_event.type);
> > +		WARN_ON_ONCE(1);
> > +	}
> > +
> > +	return register_tracer(&syscall_tracer);
> > +}
> > +device_initcall(register_ftrace_syscalls);
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

