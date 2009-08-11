Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZHKL74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZHKL74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZHKL7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:59:55 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37226 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZHKL7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V6f1y/9yuFR+uOH1aM0xxpYof+zFpbMLnl0nslPjUtM1WKFiavbdJiD9k59VULYEqJ
         SR08zhgT3yr9EJEf4AW7wz5sYHMabvdM6+22W3h4YW7DcRidFlhQSGYK9w6LLWb5vYk2
         emYuDM3O5T76vnDaFLKQgWeTPWLxXD7iHmFXw=
Date: Tue, 11 Aug 2009 12:50:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090811105010.GB4938@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:52:47PM -0400, Jason Baron wrote:
> Layer Frederic's syscall tracer on tracepoints. We create trace events via
> hooking into the SYCALL_DEFINE macros. This allows us to individually toggle
> syscall entry and exit points on/off.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  include/linux/syscalls.h      |   61 +++++++++++++-
>  include/trace/syscall.h       |   18 ++--
>  kernel/trace/trace_syscalls.c |  183 ++++++++++++++++++++---------------------
>  3 files changed, 159 insertions(+), 103 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 80de700..5e5b4d3 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -64,6 +64,7 @@ struct perf_counter_attr;
>  #include <linux/sem.h>
>  #include <asm/siginfo.h>
>  #include <asm/signal.h>
> +#include <linux/unistd.h>
>  #include <linux/quota.h>
>  #include <linux/key.h>
>  #include <trace/syscall.h>
> @@ -112,6 +113,59 @@ struct perf_counter_attr;
>  #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
>  #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
>  
> +
> +#define SYSCALL_TRACE_ENTER_EVENT(sname)				\
> +	static struct ftrace_event_call event_enter_##sname;		\
> +	static int init_enter_##sname(void)				\
> +	{								\
> +		int num;						\
> +		num = syscall_name_to_nr("sys"#sname);			\
> +		if (num < 0)						\
> +			return -ENOSYS;					\
> +		register_ftrace_event(&event_syscall_enter);		\
> +		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
> +		init_preds(&event_enter_##sname);			\
> +		return 0;						\
> +	}								\



You could rather add the struct ftrace_event_call *event as
a parameter to a generic function static int init_enter_syscall()
That would require adding this parameter in the raw_init() callback.
If I remember well, Masami does that in his kprobes events patchset.

May be we can let it as is and wait for his patchset to be integrated
to update that.


> +	static struct ftrace_event_call __used				\
> +	  __attribute__((__aligned__(4)))				\
> +	  __attribute__((section("_ftrace_events")))			\
> +	  event_enter_##sname = {					\
> +		.name                   = "sys_enter"#sname,		\
> +		.system                 = "syscalls",			\
> +		.event                  = &event_syscall_enter,		\
> +		.raw_init		= init_enter_##sname,		\
> +		.regfunc		= reg_event_syscall_enter,	\
> +		.unregfunc		= unreg_event_syscall_enter,	\
> +		.data			= "sys"#sname,			\
> +	}
> +
> +#define SYSCALL_TRACE_EXIT_EVENT(sname)					\
> +	static struct ftrace_event_call event_exit_##sname;		\
> +	static int init_exit_##sname(void)				\
> +	{								\
> +		int num;						\
> +		num = syscall_name_to_nr("sys"#sname);			\
> +		if (num < 0)						\
> +			return -ENOSYS;					\
> +		register_ftrace_event(&event_syscall_exit);		\
> +		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
> +		init_preds(&event_exit_##sname);			\
> +		return 0;						\
> +	}								\
> +	static struct ftrace_event_call __used				\
> +	  __attribute__((__aligned__(4)))				\
> +	  __attribute__((section("_ftrace_events")))			\
> +	  event_exit_##sname = {					\
> +		.name                   = "sys_exit"#sname,		\
> +		.system                 = "syscalls",			\
> +		.event                  = &event_syscall_exit,		\
> +		.raw_init		= init_exit_##sname,		\
> +		.regfunc		= reg_event_syscall_exit,	\
> +		.unregfunc		= unreg_event_syscall_exit,	\
> +		.data			= "sys"#sname,			\
> +	}
> +
>  #define SYSCALL_METADATA(sname, nb)				\
>  	static const struct syscall_metadata __used		\
>  	  __attribute__((__aligned__(4)))			\
> @@ -121,7 +175,9 @@ struct perf_counter_attr;
>  		.nb_args 	= nb,				\
>  		.types		= types_##sname,		\
>  		.args		= args_##sname,			\
> -	}
> +	};							\
> +	SYSCALL_TRACE_ENTER_EVENT(sname);			\
> +	SYSCALL_TRACE_EXIT_EVENT(sname);
>  
>  #define SYSCALL_DEFINE0(sname)					\
>  	static const struct syscall_metadata __used		\
> @@ -131,8 +187,9 @@ struct perf_counter_attr;
>  		.name 		= "sys_"#sname,			\
>  		.nb_args 	= 0,				\
>  	};							\
> +	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
> +	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
>  	asmlinkage long sys_##sname(void)
> -
>  #else
>  #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
>  #endif
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 3951d77..73fb8b4 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -2,6 +2,8 @@
>  #define _TRACE_SYSCALL_H
>  
>  #include <linux/tracepoint.h>
> +#include <linux/unistd.h>
> +#include <linux/ftrace_event.h>
>  
>  #include <asm/ptrace.h>
>  
> @@ -40,15 +42,13 @@ struct syscall_metadata {
>  
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  extern struct syscall_metadata *syscall_nr_to_meta(int nr);
> -extern void start_ftrace_syscalls(void);
> -extern void stop_ftrace_syscalls(void);
> -extern void ftrace_syscall_enter(struct pt_regs *regs);
> -extern void ftrace_syscall_exit(struct pt_regs *regs);
> -#else
> -static inline void start_ftrace_syscalls(void)			{ }
> -static inline void stop_ftrace_syscalls(void)			{ }
> -static inline void ftrace_syscall_enter(struct pt_regs *regs)	{ }
> -static inline void ftrace_syscall_exit(struct pt_regs *regs)	{ }
> +extern int syscall_name_to_nr(char *name);
> +extern struct trace_event event_syscall_enter;
> +extern struct trace_event event_syscall_exit;
> +extern int reg_event_syscall_enter(void *ptr);
> +extern void unreg_event_syscall_enter(void *ptr);
> +extern int reg_event_syscall_exit(void *ptr);
> +extern void unreg_event_syscall_exit(void *ptr);
>  #endif
>  
>  #endif /* _TRACE_SYSCALL_H */
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 08aed43..c7ae25e 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -1,15 +1,16 @@
>  #include <trace/syscall.h>
>  #include <linux/kernel.h>
> +#include <linux/ftrace.h>
>  #include <asm/syscall.h>
>  
>  #include "trace_output.h"
>  #include "trace.h"
>  
> -/* Keep a counter of the syscall tracing users */
> -static int refcount;
> -
> -/* Prevent from races on thread flags toggling */
>  static DEFINE_MUTEX(syscall_trace_lock);
> +static int sys_refcount_enter;
> +static int sys_refcount_exit;
> +static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX);
> +static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX);
>  
>  /* Option to display the parameters types */
>  enum {
> @@ -95,53 +96,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
>  	return TRACE_TYPE_HANDLED;
>  }
>  
> -void start_ftrace_syscalls(void)
> -{
> -	unsigned long flags;
> -	struct task_struct *g, *t;
> -
> -	mutex_lock(&syscall_trace_lock);
> -
> -	/* Don't enable the flag on the tasks twice */
> -	if (++refcount != 1)
> -		goto unlock;
> -
> -	read_lock_irqsave(&tasklist_lock, flags);
> -
> -	do_each_thread(g, t) {
> -		set_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> -	} while_each_thread(g, t);
> -
> -	read_unlock_irqrestore(&tasklist_lock, flags);
> -
> -unlock:
> -	mutex_unlock(&syscall_trace_lock);
> -}
> -
> -void stop_ftrace_syscalls(void)
> -{
> -	unsigned long flags;
> -	struct task_struct *g, *t;
> -
> -	mutex_lock(&syscall_trace_lock);
> -
> -	/* There are perhaps still some users */
> -	if (--refcount)
> -		goto unlock;
> -
> -	read_lock_irqsave(&tasklist_lock, flags);
> -
> -	do_each_thread(g, t) {
> -		clear_tsk_thread_flag(t, TIF_SYSCALL_FTRACE);
> -	} while_each_thread(g, t);
> -
> -	read_unlock_irqrestore(&tasklist_lock, flags);
> -
> -unlock:
> -	mutex_unlock(&syscall_trace_lock);
> -}
> -
> -void ftrace_syscall_enter(struct pt_regs *regs)
> +void ftrace_syscall_enter(struct pt_regs *regs, long id)
>  {
>  	struct syscall_trace_enter *entry;
>  	struct syscall_metadata *sys_data;
> @@ -150,6 +105,8 @@ void ftrace_syscall_enter(struct pt_regs *regs)
>  	int syscall_nr;
>  
>  	syscall_nr = syscall_get_nr(current, regs);
> +	if (!test_bit(syscall_nr, enabled_enter_syscalls))
> +		return;
>  
>  	sys_data = syscall_nr_to_meta(syscall_nr);
>  	if (!sys_data)
> @@ -170,7 +127,7 @@ void ftrace_syscall_enter(struct pt_regs *regs)
>  	trace_wake_up();
>  }
>  
> -void ftrace_syscall_exit(struct pt_regs *regs)
> +void ftrace_syscall_exit(struct pt_regs *regs, long ret)
>  {
>  	struct syscall_trace_exit *entry;
>  	struct syscall_metadata *sys_data;
> @@ -178,6 +135,8 @@ void ftrace_syscall_exit(struct pt_regs *regs)
>  	int syscall_nr;
>  
>  	syscall_nr = syscall_get_nr(current, regs);
> +	if (!test_bit(syscall_nr, enabled_exit_syscalls))
> +		return;
>  
>  	sys_data = syscall_nr_to_meta(syscall_nr);
>  	if (!sys_data)
> @@ -196,54 +155,94 @@ void ftrace_syscall_exit(struct pt_regs *regs)
>  	trace_wake_up();
>  }
>  
> -static int init_syscall_tracer(struct trace_array *tr)
> +int reg_event_syscall_enter(void *ptr)
>  {
> -	start_ftrace_syscalls();
> -
> -	return 0;
> +	int ret = 0;
> +	int num;
> +	char *name;
> +
> +	name = (char *)ptr;
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num >= FTRACE_SYSCALL_MAX)



I wonder if we should WARN once in this case. At least we would
be aware of new yet unsupported syscalls.



> +		return -ENOSYS;
> +	mutex_lock(&syscall_trace_lock);
> +	if (!sys_refcount_enter)
> +		ret = register_trace_syscall_enter(ftrace_syscall_enter);
> +	if (ret) {
> +		pr_info("event trace: Could not activate"
> +				"syscall entry trace point");
> +	} else {
> +		set_bit(num, enabled_enter_syscalls);
> +		sys_refcount_enter++;
> +	}
> +	mutex_unlock(&syscall_trace_lock);
> +	return ret;
>  }
>  
> -static void reset_syscall_tracer(struct trace_array *tr)
> +void unreg_event_syscall_enter(void *ptr)
>  {
> -	stop_ftrace_syscalls();
> -	tracing_reset_online_cpus(tr);
> -}
> -
> -static struct trace_event syscall_enter_event = {
> -	.type	 	= TRACE_SYSCALL_ENTER,
> -	.trace		= print_syscall_enter,
> -};
> -
> -static struct trace_event syscall_exit_event = {
> -	.type	 	= TRACE_SYSCALL_EXIT,
> -	.trace		= print_syscall_exit,
> -};
> +	int num;
> +	char *name;
>  
> -static struct tracer syscall_tracer __read_mostly = {
> -	.name	     	= "syscall",
> -	.init		= init_syscall_tracer,
> -	.reset		= reset_syscall_tracer,
> -	.flags		= &syscalls_flags,
> -};
> +	name = (char *)ptr;
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
> +		return;
> +	mutex_lock(&syscall_trace_lock);
> +	sys_refcount_enter--;
> +	clear_bit(num, enabled_enter_syscalls);
> +	if (!sys_refcount_enter)
> +		unregister_trace_syscall_enter(ftrace_syscall_enter);
> +	mutex_unlock(&syscall_trace_lock);
> +}
>  
> -__init int register_ftrace_syscalls(void)
> +int reg_event_syscall_exit(void *ptr)
>  {
> -	int ret;
> -
> -	ret = register_ftrace_event(&syscall_enter_event);
> -	if (!ret) {
> -		printk(KERN_WARNING "event %d failed to register\n",
> -		       syscall_enter_event.type);
> -		WARN_ON_ONCE(1);
> +	int ret = 0;
> +	int num;
> +	char *name;
> +
> +	name = (char *)ptr;
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
> +		return -ENOSYS;
> +	mutex_lock(&syscall_trace_lock);
> +	if (!sys_refcount_exit)
> +		ret = register_trace_syscall_exit(ftrace_syscall_exit);
> +	if (ret) {
> +		pr_info("event trace: Could not activate"
> +				"syscall exit trace point");
> +	} else {
> +		set_bit(num, enabled_exit_syscalls);
> +		sys_refcount_exit++;
>  	}
> +	mutex_unlock(&syscall_trace_lock);
> +	return ret;
> +}
>  
> -	ret = register_ftrace_event(&syscall_exit_event);
> -	if (!ret) {
> -		printk(KERN_WARNING "event %d failed to register\n",
> -		       syscall_exit_event.type);
> -		WARN_ON_ONCE(1);
> -	}
> +void unreg_event_syscall_exit(void *ptr)
> +{
> +	int num;
> +	char *name;
>  
> -	return register_tracer(&syscall_tracer);
> +	name = (char *)ptr;
> +	num = syscall_name_to_nr(name);
> +	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
> +		return;
> +	mutex_lock(&syscall_trace_lock);
> +	sys_refcount_exit--;
> +	clear_bit(num, enabled_exit_syscalls);
> +	if (!sys_refcount_exit)
> +		unregister_trace_syscall_exit(ftrace_syscall_exit);
> +	mutex_unlock(&syscall_trace_lock);
>  }
> -device_initcall(register_ftrace_syscalls);
> +
> +struct trace_event event_syscall_enter = {
> +	.trace			= print_syscall_enter,
> +	.type			= TRACE_SYSCALL_ENTER
> +};
> +
> +struct trace_event event_syscall_exit = {
> +	.trace			= print_syscall_exit,
> +	.type			= TRACE_SYSCALL_EXIT
> +};
> -- 
> 1.6.2.5
> 

Nice.

It's a bit too bad that enter and exit must be that separated
whereas their callbacks are pretty the same.

But I guess if we want to nicely decouple both, we don't have the choice.

