Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZHSQSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZHSQSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZHSQSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:18:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56030 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751803AbZHSQSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:18:13 -0400
Date: Wed, 19 Aug 2009 12:16:52 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH] tracing: Create generic syscall TRACE_EVENTs
Message-ID: <20090819161651.GC2649@redhat.com>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250634359-31642-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250634359-31642-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:25:59PM -0700, Josh Stone wrote:
> This converts the syscall_enter/exit tracepoints into TRACE_EVENTs, so
> you can have generic ftrace events that capture all system calls with
> arguments and return values.
> 
> The existing event_syscall_enter/exit trace_event structs are renamed to
> event_sys_enter/exit, so they don't conflict with the names generated
> automatically by ftrace.
> 
> Signed-off-by: Josh Stone <jistone@redhat.com>
> Cc: Jason Baron <jbaron@redhat.com>
> ---
>  arch/s390/kernel/ptrace.c       |    3 ++
>  arch/x86/kernel/ptrace.c        |    8 ++---
>  include/linux/syscalls.h        |    4 +-
>  include/trace/events/syscalls.h |   66 +++++++++++++++++++++++++++++++++++++++
>  include/trace/syscall.h         |   17 +---------
>  kernel/trace/trace_syscalls.c   |    5 ++-
>  6 files changed, 79 insertions(+), 24 deletions(-)
>  create mode 100644 include/trace/events/syscalls.h
> 
> diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
> index 05f57cd..8730fa7 100644
> --- a/arch/s390/kernel/ptrace.c
> +++ b/arch/s390/kernel/ptrace.c
> @@ -51,6 +51,9 @@
>  #include "compat_ptrace.h"
>  #endif
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
> +
>  enum s390_regset {
>  	REGSET_GENERAL,
>  	REGSET_FP,

this will have to be rebased to remove the new s390 DECLARE_TRACE()
calls here like x86.

> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 692fc14..530ff6f 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -35,13 +35,11 @@
>  #include <asm/proto.h>
>  #include <asm/ds.h>
>  
> -#include <trace/syscall.h>
> -
> -DEFINE_TRACE_WITH_CALLBACK(syscall_enter, syscall_regfunc, syscall_unregfunc);
> -DEFINE_TRACE_WITH_CALLBACK(syscall_exit, syscall_regfunc, syscall_unregfunc);
> -
>  #include "tls.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
> +
>  enum x86_regset {
>  	REGSET_GENERAL,
>  	REGSET_FP,
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 87d06c1..19b49fd 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -187,7 +187,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
>  	  event_enter_##sname = {					\
>  		.name                   = "sys_enter"#sname,		\
>  		.system                 = "syscalls",			\
> -		.event                  = &event_syscall_enter,		\
> +		.event                  = &event_sys_enter,		\
>  		.raw_init		= init_enter_##sname,		\
>  		.show_format		= ftrace_format_syscall,	\
>  		.regfunc		= reg_event_syscall_enter,	\
> @@ -223,7 +223,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
>  	  event_exit_##sname = {					\
>  		.name                   = "sys_exit"#sname,		\
>  		.system                 = "syscalls",			\
> -		.event                  = &event_syscall_exit,		\
> +		.event                  = &event_sys_exit,		\
>  		.raw_init		= init_exit_##sname,		\
>  		.regfunc		= reg_event_syscall_exit,	\
>  		.unregfunc		= unreg_event_syscall_exit,	\
> diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
> new file mode 100644
> index 0000000..75ccc61
> --- /dev/null
> +++ b/include/trace/events/syscalls.h
> @@ -0,0 +1,66 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM syscalls
> +
> +#if !defined(_TRACE_EVENTS_SYSCALL_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EVENTS_SYSCALL_H
> +
> +#include <linux/tracepoint.h>
> +
> +#include <asm/ptrace.h>
> +#include <asm/syscall.h>
> +
> +extern void syscall_regfunc(void);
> +extern void syscall_unregfunc(void);
> +
> +
> +TRACE_EVENT_WITH_CALLBACK(syscall_enter,
> +

do we want to call this something like, 'syscall_enter_generic'? to make
it more clear this is the high level syscall tracepoint. similar for
exit.

> +	TP_PROTO(struct pt_regs *regs, long id),
> +
> +	TP_ARGS(regs, id),
> +
> +	TP_STRUCT__entry(
> +		__field(	long,	id		)
> +		__array(	long,	args,	6	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->id	= id;
> +		syscall_get_arguments(current, regs, 0, 6, __entry->args);
> +	),
> +
> +	TP_printk("NR %ld (%ld, %ld, %ld, %ld, %ld, %ld)",
> +		  __entry->id,
> +		  __entry->args[0], __entry->args[1], __entry->args[2],
> +		  __entry->args[3], __entry->args[4], __entry->args[5]),
> +
> +	syscall_regfunc, syscall_unregfunc
> +);
> +
> +TRACE_EVENT_WITH_CALLBACK(syscall_exit,
> +
> +	TP_PROTO(struct pt_regs *regs, long ret),
> +
> +	TP_ARGS(regs, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(	long,	id		)
> +		__field(	long,	ret		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->id	= syscall_get_nr(current, regs);
> +		__entry->ret	= ret;
> +	),
> +
> +	TP_printk("NR %ld = %ld",
> +		  __entry->id, __entry->ret),
> +
> +	syscall_regfunc, syscall_unregfunc
> +);
> +
> +#endif /* _TRACE_EVENTS_SYSCALL_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 49e7ec2..5181893 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -8,19 +8,6 @@
>  #include <asm/ptrace.h>
>  
>  
> -extern void syscall_regfunc(void);
> -extern void syscall_unregfunc(void);
> -
> -DECLARE_TRACE(syscall_enter,
> -	TP_PROTO(struct pt_regs *regs, long id),
> -	TP_ARGS(regs, id)
> -);
> -
> -DECLARE_TRACE(syscall_exit,
> -	TP_PROTO(struct pt_regs *regs, long ret),
> -	TP_ARGS(regs, ret)
> -);
> -
>  /*
>   * A syscall entry in the ftrace syscalls array.
>   *
> @@ -45,8 +32,8 @@ extern struct syscall_metadata *syscall_nr_to_meta(int nr);
>  extern int syscall_name_to_nr(char *name);
>  void set_syscall_enter_id(int num, int id);
>  void set_syscall_exit_id(int num, int id);
> -extern struct trace_event event_syscall_enter;
> -extern struct trace_event event_syscall_exit;
> +extern struct trace_event event_sys_enter;
> +extern struct trace_event event_sys_exit;
>  extern int reg_event_syscall_enter(void *ptr);
>  extern void unreg_event_syscall_enter(void *ptr);
>  extern int reg_event_syscall_exit(void *ptr);
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index f130dac..b174169 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -1,4 +1,5 @@
>  #include <trace/syscall.h>
> +#include <trace/events/syscalls.h>
>  #include <linux/kernel.h>
>  #include <linux/ftrace.h>
>  #include <linux/perf_counter.h>
> @@ -277,11 +278,11 @@ void unreg_event_syscall_exit(void *ptr)
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> -struct trace_event event_syscall_enter = {
> +struct trace_event event_sys_enter = {
>  	.trace			= print_syscall_enter,
>  };
>  
> -struct trace_event event_syscall_exit = {
> +struct trace_event event_sys_exit = {
>  	.trace			= print_syscall_exit,
>  };
>  
> -- 
> 1.6.2.5
> 


looks good.

Acked-by: Jason Baron <jbaron@redhat.com>

thanks,

-Jason
