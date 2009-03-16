Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbZCPVpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbZCPVpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbZCPVpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:45:36 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:40004 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbZCPVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:45:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFAJVgvklMQW1W/2dsb2JhbACBTtNRg38G
Date: Mon, 16 Mar 2009 17:45:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090316214526.GA15119@Krystal>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <49BEAA5A.4030708@redhat.com> <20090316201526.GE8393@nowhere> <49BEB8C4.2010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49BEB8C4.2010606@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:52:48 up 16 days, 17:19,  1 user,  load average: 0.52, 0.44,
	0.57
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Frederic Weisbecker wrote:
> > On Mon, Mar 16, 2009 at 03:36:58PM -0400, Masami Hiramatsu wrote:
> >> Hi Frederic,
> >>
> >> Out of curiously, could you tell me why did you introduce new TIF instead of
> >> using utrace's tracehook API?
> >> For example, systemtap already use current utrace/tracehook api for tracing
> >> all syscalls. If there is any new advantage, it would be good to enhance
> >> existing utrace/tracehook.
> >>
> >> Thank you,
> > 
> > 
> > Hi,
> > 
> > Because the tracehooks rely on ptrace work and both ftrace and ptrace would overlap
> > in a same flag, creating racy issues. At least ss far as I understood it.
> > How does systemtap manage it?
> 
> As far as I know, utrace supports multiple trace-engines on a process.
> Since ptrace is just an engine of utrace, you can add another engine on utrace.
> 
> utrace-+-ptrace_engine---owner_process
>        |
>        +-systemtap_module
>        |
>        +-ftrace_plugin
> 
> Here, Frank had posted an example of utrace->ftrace engine.
> http://lkml.org/lkml/2009/1/27/294
> 
> And here is the latest his patch(which seems to support syscall tracing...)
> http://git.kernel.org/?p=linux/kernel/git/frob/linux-2.6-utrace.git;a=blob;f=kernel/trace/trace_process.c;h=619815f6c2543d0d82824139773deb4ca460a280;hb=ab20efa8d8b5ded96e8f8c3663dda3b4cb532124
> 

Reminder : we are looking at system-wide tracing here. Here are some
comments about the current utrace implementation.

Looking at include/linux/utrace.h from the tree

17  * A tracing engine starts by calling utrace_attach_task() or
18  * utrace_attach_pid() on the chosen thread, passing in a set of hooks
19  * (&struct utrace_engine_ops), and some associated data.  This produces a
20  * &struct utrace_engine, which is the handle used for all other
21  * operations.  An attached engine has its ops vector, its data, and an
22  * event mask controlled by utrace_set_events().

So if the system has, say 3000 threads, then we have 3000 struct
utrace_engine created ? I wonder what effet this could have one
cachelines if this is used to trace hot paths like system call
entry/exit. Have you benchmarked this kind of scenario under tbench ?


24  * For each event bit that is set, that engine will get the
25  * appropriate ops->report_*() callback when the event occurs.  The
26  * &struct utrace_engine_ops need not provide callbacks for an event
27  * unless the engine sets one of the associated event bits.

Looking at utrace_set_events(), we seem to be limited to 32 events on a
32-bits architectures because it uses a bitmask ? Isn't it a bit small?


682 /**
683  * utrace_set_events_pid - choose which event reports a tracing engine gets
684  * @pid:                thread to affect
685  * @engine:             attached engine to affect
686  * @eventmask:          new event mask
687  *
688  * This is the same as utrace_set_events(), but takes a &struct pid
689  * pointer rather than a &struct task_struct pointer.  The caller must
690  * hold a ref on @pid, but does not need to worry about the task
691  * staying valid.  If it's been reaped so that @pid points nowhere,
692  * then this call returns -%ESRCH.


Comments like "but does not need to worry about the task staying valid"
does not make me feel safe and comfortable at all, could you explain
how you can assume that derefencing an "invalid" pointer will return
NULL ?

About the utrace_attach_task() :

244         if (unlikely(target->flags & PF_KTHREAD))
245                 /*
246                  * Silly kernel, utrace is for users!
247                  */
248                 return ERR_PTR(-EPERM);

So we cannot trace kernel threads ?


118 /*
119  * Called without locks, when we might be the first utrace engine to attach.
120  * If this is a newborn thread and we are not the creator, we have to wait
121  * for it.  The creator gets the first chance to attach.  The PF_STARTING
122  * flag is cleared after its report_clone hook has had a chance to run.
123  */
124 static inline int utrace_attach_delay(struct task_struct *target)
125 {
126         if ((target->flags & PF_STARTING) && target->real_parent != current)
127                 do {
128                         schedule_timeout_interruptible(1);
129                         if (signal_pending(current))
130                                 return -ERESTARTNOINTR;
131                 } while (target->flags & PF_STARTING);
132
133         return 0;
134 }

Why do we absolutely have to poll until the thread has started ?


utrace_add_engine()
  set_notify_resume(target);

ok, so this is where the TIF_NOTIFY_RESUME thread flag is set. I notice
that it is set asynchronously with the execution of the target thread
(as I do with my TIF_KERNEL_TRACE thread flag).

However, on x86_64, _TIF_DO_NOTIFY_MASK is only tested in 
entry_64.S

int_signal:
and
retint_signal:

code paths. However, if there is no syscall tracing to do upon syscall
entry, the thread flags are not re-read at syscall exit and you will
miss the syscall exit returning from your target thread if this thread
was blocked while you set its TIF_NOTIFY_RESUME. Or is it handled in
some subtle way I did not figure out ? BTW re-reading the TIF flags from
the thread_info at syscall exit on the fast path is out of question
because it considerably degrades the kernel performances. entry_*.S is
a very, very critical path.

Mathieu


> Frank, Roland, could you explain that?
> Perhaps, we'd better discuss utrace on LKML for avoiding any redundant
> code problems.
> 
> Thank you,
> 
> > 
> > Thanks.
> > 
> >> Frederic Weisbecker wrote:
> >>> The most important drawback that implies the syscall tracing is the variable
> >>> number of parameters that takes a syscall. Assuming there is a large number of
> >>> syscall, the goal is to provide as much as possible a generic layer on it.
> >>>
> >>> What we want on tracing time (the hot path):
> >>>
> >>> - Save the parameters and the number of the syscall. That's all. The rest of the
> >>>   job can be done on the "output path".
> >>>
> >>> On output time:
> >>>
> >>> - Get the raw-binary saved parameters and the syscall number as well as some
> >>>   usual infos such as the pid, the time...
> >>> - Depending on the tracing requirements, the user should have the choice to
> >>>   dump the raw datas or a formatted version.
> >>>
> >>> The core infrastructure has a static array which contains the necessary
> >>> informations for each syscall (ok, I've only implemented 4 for now).
> >>>
> >>> When a syscall triggers, the tracer look at this array (O(1) access) and get the
> >>> number of parameters for this syscall. Then these parameters are saved in a
> >>> binary form on the ring buffer with the syscall number (a generic version, arch
> >>> independent).
> >>>
> >>> On output time the parameters, the name of the syscall and very basic
> >>> informations to format the parameters are picket from the ring-buffer and the
> >>> generic syscall array.
> >>>
> >>> Depending of the level of implementation we want for the syscall inside this
> >>> array, we can provide just a single mask where the n bit matches the n
> >>> parameter. If the bit is set, then the parameter will be considered as a string
> >>> pointer. Otherwise its raw hexadecimal value will be printed.
> >>>
> >>> If needed, we can otherwise provide a specific callback to print the syscall
> >>> event.
> >>>
> >>> The probem with these approaches comes from the fact that the string might have
> >>> disappeared from the user memory on output time. Even if we protect against
> >>> faults, it can give unreliable traces.
> >>> So perhaps we could think about copying the string on tracing time.
> >>>
> >>> Concerning the return value, it doesn't make any problem, a single raw
> >>> value is printed for each one.
> >>>
> >>> Note that the current implementation can be easily scaled further to give only
> >>> binary informations to the user and the matching metadata to decode it.
> >>>
> >>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> >>> ---
> >>>  include/linux/ftrace.h        |   44 +++++++
> >>>  kernel/trace/Kconfig          |   10 ++
> >>>  kernel/trace/Makefile         |    1 +
> >>>  kernel/trace/trace.c          |    6 +
> >>>  kernel/trace/trace.h          |   32 +++++
> >>>  kernel/trace/trace_syscalls.c |  284 +++++++++++++++++++++++++++++++++++++++++
> >>>  6 files changed, 377 insertions(+), 0 deletions(-)
> >>>  create mode 100644 kernel/trace/trace_syscalls.c
> >>>
> >>> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> >>> index e1583f2..1798692 100644
> >>> --- a/include/linux/ftrace.h
> >>> +++ b/include/linux/ftrace.h
> >>> @@ -503,4 +503,48 @@ static inline void trace_hw_branch_oops(void) {}
> >>>  
> >>>  #endif /* CONFIG_HW_BRANCH_TRACER */
> >>>  
> >>> +/* Index for the ftrace syscalls array */
> >>> +enum syscall_trace_nr {
> >>> +	SYSCALL_TRACE_OPEN = 1,
> >>> +	SYSCALL_TRACE_CLOSE,
> >>> +	SYSCALL_TRACE_READ,
> >>> +	SYSCALL_TRACE_WRITE,
> >>> +
> >>> +	__SYSCALL_TRACE_END
> >>> +};
> >>> +
> >>> +/*
> >>> + * A syscall entry in the ftrace syscalls array.
> >>> + *
> >>> + * @name: name of the syscall
> >>> + * @nb_args: number of parameters it takes
> >>> + * @simple_format: if true, we use string_mask, otherwise the print callback
> >>> + * @string_mask: rudimentary format mask. If bit nr is set, the nr parameter
> >>> + *		 will be displayed as a string, otherwise it will be considered
> >>> + *		 as a raw number (hex displayed).
> >>> + * @print: implement it if you want a custom output for a given syscall
> >>> + */
> >>> +struct syscall_trace_entry {
> >>> +	const char	*name;
> >>> +	int		nb_args;
> >>> +	bool		simple_format;
> >>> +	union {
> >>> +		unsigned long string_mask;
> >>> +		int (*print)(unsigned long *);
> >>> +	} output;
> >>> +};
> >>> +
> >>> +#ifdef CONFIG_FTRACE_SYSCALLS
> >>> +extern short arch_syscall_trace_nr[];
> >>> +extern void start_ftrace_syscalls(void);
> >>> +extern void stop_ftrace_syscalls(void);
> >>> +extern void ftrace_syscall_enter(struct pt_regs *regs);
> >>> +extern void ftrace_syscall_exit(struct pt_regs *regs);
> >>> +#else
> >>> +static inline void start_ftrace_syscalls(void) { }
> >>> +static inline void stop_ftrace_syscalls(void) { }
> >>> +static inline void ftrace_syscall_enter(struct pt_regs *regs) { }
> >>> +static inline void ftrace_syscall_exit(struct pt_regs *regs) { }
> >>> +#endif
> >>> +
> >>>  #endif /* _LINUX_FTRACE_H */
> >>> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> >>> index 8e4a2a6..95a0ad1 100644
> >>> --- a/kernel/trace/Kconfig
> >>> +++ b/kernel/trace/Kconfig
> >>> @@ -34,6 +34,9 @@ config HAVE_FTRACE_MCOUNT_RECORD
> >>>  config HAVE_HW_BRANCH_TRACER
> >>>  	bool
> >>>  
> >>> +config HAVE_FTRACE_SYSCALLS
> >>> +	bool
> >>> +
> >>>  config TRACER_MAX_TRACE
> >>>  	bool
> >>>  
> >>> @@ -175,6 +178,13 @@ config EVENT_TRACER
> >>>  	  allowing the user to pick and choose which trace point they
> >>>  	  want to trace.
> >>>  
> >>> +config FTRACE_SYSCALLS
> >>> +	bool "Trace syscalls"
> >>> +	depends on HAVE_FTRACE_SYSCALLS
> >>> +	select TRACING
> >>> +	help
> >>> +	  Basic tracer to catch the syscall entry and exit events.
> >>> +
> >>>  config BOOT_TRACER
> >>>  	bool "Trace boot initcalls"
> >>>  	select TRACING
> >>> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> >>> index c7a2943..c3feea0 100644
> >>> --- a/kernel/trace/Makefile
> >>> +++ b/kernel/trace/Makefile
> >>> @@ -43,5 +43,6 @@ obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
> >>>  obj-$(CONFIG_EVENT_TRACER) += trace_events.o
> >>>  obj-$(CONFIG_EVENT_TRACER) += events.o
> >>>  obj-$(CONFIG_EVENT_TRACER) += trace_export.o
> >>> +obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
> >>>  
> >>>  libftrace-y := ftrace.o
> >>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> >>> index cc94f86..5152be3 100644
> >>> --- a/kernel/trace/trace.c
> >>> +++ b/kernel/trace/trace.c
> >>> @@ -242,6 +242,12 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
> >>>  unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> >>>  	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
> >>>  
> >>> +
> >>> +struct trace_array *__get_global_trace(void)
> >>> +{
> >>> +	return &global_trace;
> >>> +}
> >>> +
> >>>  /**
> >>>   * trace_wake_up - wake up tasks waiting for trace input
> >>>   *
> >>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> >>> index 2bfb7d1..9583830 100644
> >>> --- a/kernel/trace/trace.h
> >>> +++ b/kernel/trace/trace.h
> >>> @@ -30,6 +30,8 @@ enum trace_type {
> >>>  	TRACE_GRAPH_ENT,
> >>>  	TRACE_USER_STACK,
> >>>  	TRACE_HW_BRANCHES,
> >>> +	TRACE_SYSCALL_ENTER,
> >>> +	TRACE_SYSCALL_EXIT,
> >>>  	TRACE_KMEM_ALLOC,
> >>>  	TRACE_KMEM_FREE,
> >>>  	TRACE_POWER,
> >>> @@ -192,6 +194,19 @@ struct kmemtrace_free_entry {
> >>>  	const void *ptr;
> >>>  };
> >>>  
> >>> +struct syscall_trace_enter {
> >>> +	struct trace_entry	ent;
> >>> +	enum syscall_trace_nr	nr;
> >>> +	unsigned long		args[];
> >>> +};
> >>> +
> >>> +struct syscall_trace_exit {
> >>> +	struct trace_entry	ent;
> >>> +	enum syscall_trace_nr	nr;
> >>> +	unsigned long		ret;
> >>> +};
> >>> +
> >>> +
> >>>  /*
> >>>   * trace_flag_type is an enumeration that holds different
> >>>   * states when a trace occurs. These are:
> >>> @@ -304,6 +319,10 @@ extern void __ftrace_bad_type(void);
> >>>  			  TRACE_KMEM_ALLOC);	\
> >>>  		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
> >>>  			  TRACE_KMEM_FREE);	\
> >>> +		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
> >>> +			  TRACE_SYSCALL_ENTER);				\
> >>> +		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
> >>> +			  TRACE_SYSCALL_EXIT);				\
> >>>  		__ftrace_bad_type();					\
> >>>  	} while (0)
> >>>  
> >>> @@ -568,6 +587,7 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
> >>>  #endif /* CONFIG_FTRACE_STARTUP_TEST */
> >>>  
> >>>  extern void *head_page(struct trace_array_cpu *data);
> >>> +extern struct trace_array *__get_global_trace(void);
> >>>  extern long ns2usecs(cycle_t nsec);
> >>>  extern int
> >>>  trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
> >>> @@ -627,6 +647,18 @@ static inline int ftrace_trace_task(struct task_struct *task)
> >>>  	return test_tsk_trace_trace(task);
> >>>  }
> >>>  
> >>> +#ifdef CONFIG_FTRACE_SYSCALLS
> >>> +extern enum print_line_t
> >>> +print_syscall_enter(struct trace_iterator *iter, int flags);
> >>> +extern enum print_line_t
> >>> +print_syscall_exit(struct trace_iterator *iter, int flags);
> >>> +#else
> >>> +static inline enum print_line_t
> >>> +print_syscall_enter(struct trace_iterator *iter, int flags) { }
> >>> +static inline enum print_line_t
> >>> +print_syscall_exit(struct trace_iterator *iter, int flags) { }
> >>> +#endif
> >>> +
> >>>  /*
> >>>   * trace_iterator_flags is an enumeration that defines bit
> >>>   * positions into trace_flags that controls the output.
> >>> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> >>> new file mode 100644
> >>> index 0000000..470bb9d
> >>> --- /dev/null
> >>> +++ b/kernel/trace/trace_syscalls.c
> >>> @@ -0,0 +1,284 @@
> >>> +#include <linux/kernel.h>
> >>> +#include <linux/ftrace.h>
> >>> +#include <asm/syscall.h>
> >>> +
> >>> +#include "trace_output.h"
> >>> +#include "trace.h"
> >>> +
> >>> +/* Create basic entry on syscall array (with the rudimentary string mask) */
> >>> +#define SYS_TRACE_ENTRY(sname, args, mask)			  \
> >>> +	{.name = #sname, .nb_args = args, .simple_format = true,  \
> >>> +	.output.string_mask = mask}
> >>> +
> >>> +/*
> >>> + * Create a custom defined entry on the syscall array, you will have to
> >>> + * implement a callback to output the syscall.
> >>> + */
> >>> +#define SYS_TRACE_ENTRY_SPECIAL(sname, args, printer)		  \
> >>> +	{.name = #sname, .nb_args = args, .simple_format = false, \
> >>> +	.print = printer}
> >>> +
> >>> +static const struct syscall_trace_entry syscall_trace_entries[] = {
> >>> +	/* For open, the first argument is a string, hence the given mask */
> >>> +	[SYSCALL_TRACE_OPEN]	= SYS_TRACE_ENTRY(open, 3, 0x1),
> >>> +	[SYSCALL_TRACE_CLOSE]	= SYS_TRACE_ENTRY(close, 1, 0),
> >>> +	[SYSCALL_TRACE_READ]	= SYS_TRACE_ENTRY(read, 3, 0),
> >>> +	[SYSCALL_TRACE_WRITE]	= SYS_TRACE_ENTRY(read, 3, 0),
> >>> +};
> >>> +
> >>> +
> >>> +static atomic_t refcount;
> >>> +
> >>> +enum print_line_t
> >>> +print_syscall_enter(struct trace_iterator *iter, int flags)
> >>> +{
> >>> +	struct trace_seq *s = &iter->seq;
> >>> +	struct trace_entry *ent = iter->ent;
> >>> +	struct syscall_trace_enter *trace;
> >>> +	enum syscall_trace_nr syscall;
> >>> +	const struct syscall_trace_entry *entry;
> >>> +	char *str = NULL;
> >>> +	int i, ret;
> >>> +
> >>> +	trace_assign_type(trace, ent);
> >>> +
> >>> +	syscall = trace->nr;
> >>> +
> >>> +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> >>> +		return TRACE_TYPE_HANDLED;
> >>> +
> >>> +	entry = &syscall_trace_entries[syscall];
> >>> +	if (!entry->simple_format) {
> >>> +		ret = entry->output.print(trace->args);
> >>> +		if (!ret)
> >>> +			return TRACE_TYPE_PARTIAL_LINE;
> >>> +	}
> >>> +
> >>> +	ret = trace_seq_printf(s, "syscall %s :", entry->name);
> >>> +	if (!ret)
> >>> +		return TRACE_TYPE_PARTIAL_LINE;
> >>> +
> >>> +	for (i = 0; i < entry->nb_args; i++) {
> >>> +		/*
> >>> +		 * FIXME: the string comes from the user, but on tracing
> >>> +		 * output time, it may have disappeared from the memory.
> >>> +		 * May be better to strdup it on tracing time.
> >>> +		 */
> >>> +		if (entry->output.string_mask & (1 << i)) {
> >>> +			/* 128 is enough for most path */
> >>> +			str = strndup_user((char *)trace->args[i], 128);
> >>> +
> >>> +			/* If it faulted badly, the error shoud have been
> >>> +			 * handled while servicing the syscall, just ignore.
> >>> +			 */
> >>> +			if (str == ERR_PTR(-EFAULT) || str == ERR_PTR(-EINVAL)
> >>> +			    || str == ERR_PTR(-ENOMEM))
> >>> +				return TRACE_TYPE_HANDLED;
> >>> +
> >>> +			ret = trace_seq_printf(s, " %s", str);
> >>> +		} else {
> >>> +			ret = trace_seq_printf(s, " 0x%lx", trace->args[i]);
> >>> +		}
> >>> +		if (!ret)
> >>> +			goto end_partial;
> >>> +	}
> >>> +	if (!trace_seq_printf(s, "\n"))
> >>> +		goto end_partial;
> >>> +
> >>> +	kfree(str);
> >>> +	return TRACE_TYPE_HANDLED;
> >>> +
> >>> +end_partial:
> >>> +	kfree(str);
> >>> +	return TRACE_TYPE_PARTIAL_LINE;
> >>> +}
> >>> +
> >>> +enum print_line_t
> >>> +print_syscall_exit(struct trace_iterator *iter, int flags)
> >>> +{
> >>> +	struct trace_seq *s = &iter->seq;
> >>> +	struct trace_entry *ent = iter->ent;
> >>> +	struct syscall_trace_exit *trace;
> >>> +	enum syscall_trace_nr syscall;
> >>> +	const struct syscall_trace_entry *entry;
> >>> +	int ret;
> >>> +
> >>> +	trace_assign_type(trace, ent);
> >>> +
> >>> +	syscall = trace->nr;
> >>> +
> >>> +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> >>> +		return TRACE_TYPE_HANDLED;
> >>> +
> >>> +	entry = &syscall_trace_entries[syscall];
> >>> +
> >>> +	ret = trace_seq_printf(s, "syscall %s -> 0x%lx\n", entry->name,
> >>> +				trace->ret);
> >>> +	if (!ret)
> >>> +		return TRACE_TYPE_PARTIAL_LINE;
> >>> +
> >>> +	return TRACE_TYPE_HANDLED;
> >>> +}
> >>> +
> >>> +void start_ftrace_syscalls(void)
> >>> +{
> >>> +	unsigned long flags;
> >>> +	struct task_struct *g, *t;
> >>> +
> >>> +	if (atomic_inc_return(&refcount) != 1)
> >>> +		goto out;
> >>> +
> >>> +	read_lock_irqsave(&tasklist_lock, flags);
> >>> +
> >>> +	do_each_thread(g, t) {
> >>> +		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> >>> +	} while_each_thread(g, t);
> >>> +
> >>> +	read_unlock_irqrestore(&tasklist_lock, flags);
> >>> +out:
> >>> +	atomic_dec(&refcount);
> >>> +}
> >>> +
> >>> +void stop_ftrace_syscalls(void)
> >>> +{
> >>> +	unsigned long flags;
> >>> +	struct task_struct *g, *t;
> >>> +
> >>> +	if (atomic_dec_return(&refcount))
> >>> +		goto out;
> >>> +
> >>> +	read_lock_irqsave(&tasklist_lock, flags);
> >>> +
> >>> +	do_each_thread(g, t) {
> >>> +		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> >>> +	} while_each_thread(g, t);
> >>> +
> >>> +	read_unlock_irqrestore(&tasklist_lock, flags);
> >>> +out:
> >>> +	atomic_inc(&refcount);
> >>> +}
> >>> +
> >>> +void ftrace_syscall_enter(struct pt_regs *regs)
> >>> +{
> >>> +	struct trace_array *tr = __get_global_trace();
> >>> +	struct syscall_trace_enter *entry;
> >>> +	const struct syscall_trace_entry *sys_data;
> >>> +	struct ring_buffer_event *event;
> >>> +	struct trace_array_cpu *data;
> >>> +	int size;
> >>> +	int syscall_nr;
> >>> +	int nr_offset;
> >>> +	int cpu;
> >>> +
> >>> +	syscall_nr = syscall_get_nr(current, regs);
> >>> +	nr_offset = arch_syscall_trace_nr[syscall_nr];
> >>> +	if (!nr_offset || nr_offset >= __SYSCALL_TRACE_END)
> >>> +		return;
> >>> +
> >>> +	cpu = raw_smp_processor_id();
> >>> +	data = tr->data[cpu];
> >>> +
> >>> +	if (unlikely(atomic_read(&data->disabled)))
> >>> +		return;
> >>> +
> >>> +	sys_data = &syscall_trace_entries[nr_offset];
> >>> +	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
> >>> +
> >>> +	event = trace_buffer_lock_reserve(tr, TRACE_SYSCALL_ENTER, size, 0, 0);
> >>> +	if (!event)
> >>> +		return;
> >>> +
> >>> +	entry = ring_buffer_event_data(event);
> >>> +	entry->nr = nr_offset;
> >>> +	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
> >>> +
> >>> +	ring_buffer_unlock_commit(tr->buffer, event);
> >>> +	trace_wake_up();
> >>> +}
> >>> +
> >>> +void ftrace_syscall_exit(struct pt_regs *regs)
> >>> +{
> >>> +	struct trace_array *tr = __get_global_trace();
> >>> +	struct syscall_trace_exit *entry;
> >>> +	const struct syscall_trace_entry *sys_data;
> >>> +	struct ring_buffer_event *event;
> >>> +	struct trace_array_cpu *data;
> >>> +	int syscall_nr;
> >>> +	int nr_offset;
> >>> +	int cpu;
> >>> +
> >>> +	syscall_nr = syscall_get_nr(current, regs);
> >>> +	nr_offset = arch_syscall_trace_nr[syscall_nr];
> >>> +	if (!nr_offset || nr_offset >= __SYSCALL_TRACE_END)
> >>> +		return;
> >>> +
> >>> +	cpu = raw_smp_processor_id();
> >>> +	data = tr->data[cpu];
> >>> +
> >>> +	if (unlikely(atomic_read(&data->disabled)))
> >>> +		return;
> >>> +
> >>> +	sys_data = &syscall_trace_entries[nr_offset];
> >>> +
> >>> +	event = trace_buffer_lock_reserve(tr, TRACE_SYSCALL_EXIT,
> >>> +				sizeof(*entry), 0, 0);
> >>> +	if (!event)
> >>> +		return;
> >>> +
> >>> +	entry = ring_buffer_event_data(event);
> >>> +	entry->nr = nr_offset;
> >>> +	entry->ret = syscall_get_return_value(current, regs);
> >>> +
> >>> +	ring_buffer_unlock_commit(tr->buffer, event);
> >>> +	trace_wake_up();
> >>> +}
> >>> +
> >>> +static int init_syscall_tracer(struct trace_array *tr)
> >>> +{
> >>> +	start_ftrace_syscalls();
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static void reset_syscall_tracer(struct trace_array *tr)
> >>> +{
> >>> +	stop_ftrace_syscalls();
> >>> +}
> >>> +
> >>> +static struct trace_event syscall_enter_event = {
> >>> +	.type	 	= TRACE_SYSCALL_ENTER,
> >>> +	.trace		= print_syscall_enter,
> >>> +};
> >>> +
> >>> +static struct trace_event syscall_exit_event = {
> >>> +	.type	 	= TRACE_SYSCALL_EXIT,
> >>> +	.trace		= print_syscall_exit,
> >>> +};
> >>> +
> >>> +static struct tracer syscall_tracer __read_mostly = {
> >>> +	.name	     	= "syscall",
> >>> +	.init		= init_syscall_tracer,
> >>> +	.reset		= reset_syscall_tracer
> >>> +};
> >>> +
> >>> +__init int register_ftrace_syscalls(void)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	ret = register_ftrace_event(&syscall_enter_event);
> >>> +	if (!ret) {
> >>> +		printk(KERN_WARNING "event %d failed to register\n",
> >>> +		       syscall_enter_event.type);
> >>> +		WARN_ON_ONCE(1);
> >>> +	}
> >>> +
> >>> +	ret = register_ftrace_event(&syscall_exit_event);
> >>> +	if (!ret) {
> >>> +		printk(KERN_WARNING "event %d failed to register\n",
> >>> +		       syscall_exit_event.type);
> >>> +		WARN_ON_ONCE(1);
> >>> +	}
> >>> +
> >>> +	return register_tracer(&syscall_tracer);
> >>> +}
> >>> +device_initcall(register_ftrace_syscalls);
> >> -- 
> >> Masami Hiramatsu
> >>
> >> Software Engineer
> >> Hitachi Computer Products (America) Inc.
> >> Software Solutions Division
> >>
> >> e-mail: mhiramat@redhat.com
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
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

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
