Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZFGTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZFGTTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZFGTTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:19:09 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64332 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZFGTTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A5huWtXtcrg1T1Wcto/rU9dBp1CEv/WPkDYsm0z3TDuppyqEjTxOlVIZB1mxxFICwp
         pe5ZPYsY6c5OcIJ9yV7TxQyFJ1teibxtYymwJZuiC8hL2OLCCCdVlsZtx0mUdHHU2DBy
         utU8MF7IF3frYebAyoqXURicECGwdOaBx2P8Y=
Date: Sun, 7 Jun 2009 21:19:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090607191903.GA6021@nowhere>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 02:08:08PM -0400, Jason Baron wrote:
> 
> Implements syscall tracer via tracepoints and TRACE_EVENT(). Introduces
> a new tracing flag 'trace_syscalls', which must be toggled to enable this
> feature.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  arch/x86/kernel/ptrace.c        |    8 +-
>  include/asm-generic/syscall.h   |    3 +
>  include/trace/events/syscalls.h | 4202 +++++++++++++++++++++++++++++++++++++++
>  include/trace/syscall.h         |    6 +
>  kernel/trace/Makefile           |    1 -
>  kernel/trace/trace.c            |  101 +
>  kernel/trace/trace_syscalls.c   |  250 ---
>  7 files changed, 4317 insertions(+), 254 deletions(-)
>  create mode 100644 include/trace/events/syscalls.h
>  delete mode 100644 kernel/trace/trace_syscalls.c
> 
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 09ecbde..1016619 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -35,7 +35,9 @@
>  #include <asm/proto.h>
>  #include <asm/ds.h>
>  
> -#include <trace/syscall.h>
> +#include <linux/ftrace.h>
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
>  
>  #include "tls.h"
>  
> @@ -1498,7 +1500,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
>  		ret = -1L;
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		ftrace_syscall_enter(regs);
> +		syscall_tracepoints_enter(regs);
>  
>  	if (unlikely(current->audit_context)) {
>  		if (IS_IA32)
> @@ -1524,7 +1526,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
>  		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		ftrace_syscall_exit(regs);
> +		syscall_tracepoints_exit(regs);
>  
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall_exit(regs, 0);
> diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
> index ea8087b..ef4c68e 100644
> --- a/include/asm-generic/syscall.h
> +++ b/include/asm-generic/syscall.h
> @@ -22,6 +22,9 @@
>  struct task_struct;
>  struct pt_regs;
>  
> +
> +struct syscall_metadata *syscall_nr_to_meta(int nr);
> +
>  /**
>   * syscall_get_nr - find what system call a task is executing
>   * @task:	task of interest, must be blocked
> diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
> new file mode 100644
> index 0000000..de7143d
> --- /dev/null
> +++ b/include/trace/events/syscalls.h
> @@ -0,0 +1,4202 @@
> +#if !defined(_TRACE_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_SYSCALLS_H
> +
> +#include <asm/syscall.h>
> +#include <asm-generic/syscall.h>
> +#include <linux/tracepoint.h>
> +#include <trace/syscall.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM syscalls
> +
> +struct epoll_event;
> +struct iattr;
> +struct inode;
> +struct iocb;
> +struct io_event;
> +struct iovec;
> +struct itimerspec;
> +struct itimerval;
> +struct kexec_segment;
> +struct linux_dirent;
> +struct linux_dirent64;
> +struct list_head;
> +struct msgbuf;
> +struct msghdr;
> +struct msqid_ds;
> +struct new_utsname;
> +struct nfsctl_arg;
> +struct __old_kernel_stat;
> +struct pollfd;
> +struct rlimit;
> +struct rusage;
> +struct sched_param;
> +struct semaphore;
> +struct sembuf;
> +struct shmid_ds;
> +struct sockaddr;
> +struct stat;
> +struct stat64;
> +struct statfs;
> +struct statfs64;
> +struct __sysctl_args;
> +struct sysinfo;
> +struct timespec;
> +struct timeval;
> +struct timex;
> +struct timezone;
> +struct tms;
> +struct utimbuf;
> +struct mq_attr;
> +struct compat_stat;
> +struct compat_timeval;
> +struct robust_list_head;
> +struct getcpu_cache;
> +struct old_linux_dirent;
> +struct perf_counter_hw_event;
> +
> +/* misc macros */
> +
> +#define clock_id_toname(id) \
> +	(id == CLOCK_REALTIME ? "CLOCK_REALTIME" : \
> +		id == CLOCK_MONOTONIC ? "CLOCK_MONOTONIC" : \
> +		id == CLOCK_PROCESS_CPUTIME_ID ? "CLOCK_PROCESS_CPUTIME_ID" : \
> +		id == CLOCK_MONOTONIC_RAW ? "CLOCK_MONOTONIC_RAW" : \
> +		id == CLOCK_SGI_CYCLE ? "CLOCK_SGI_CYCLE" : \
> +		"UNKNOWN CLOCK")
> +
> +/* enter helper macros */
> +
> +#define MAX_SYS_ARGS 6
> +
> +#define expand_enter_sys_args_0()
> +#define expand_enter_sys_args_1(t1) (t1) sys_args[0]
> +#define expand_enter_sys_args_2(t1, t2) expand_enter_sys_args_1(t1), (t2) sys_args[1]
> +#define expand_enter_sys_args_3(t1, t2, t3) expand_enter_sys_args_2(t1, t2), (t3) sys_args[2]
> +#define expand_enter_sys_args_4(t1, t2, t3, t4) expand_enter_sys_args_3(t1, t2, t3), (t4) sys_args[3]
> +#define expand_enter_sys_args_5(t1, t2, t3, t4, t5) expand_enter_sys_args_4(t1, t2, t3, t4), (t5) sys_args[4]
> +#define expand_enter_sys_args_6(t1, t2, t3, t4, t5, t6) expand_enter_sys_args_5(t1, t2, t3, t4, t5), (t6) sys_args[5]
> +
> +#define create_syscall_enter(n, sysname, ...)		\
> +        case __NR_##sysname:				\
> +		syscall_get_arguments(current, regs, 0, n, sys_args); \
> +		trace_sysenter_##sysname(expand_enter_sys_args_##n(__VA_ARGS__)); \
> +		break;
> +
> +#define expand_enter_proto_0() void
> +#define expand_enter_proto_1(t1, p1) t1 p1
> +#define expand_enter_proto_2(t2, p2, ...) t2 p2, expand_enter_proto_1(__VA_ARGS__)
> +#define expand_enter_proto_3(t3, p3, ...) t3 p3, expand_enter_proto_2(__VA_ARGS__)
> +#define expand_enter_proto_4(t4, p4, ...) t4 p4, expand_enter_proto_3(__VA_ARGS__)
> +#define expand_enter_proto_5(t5, p5, ...) t5 p5, expand_enter_proto_4(__VA_ARGS__)
> +#define expand_enter_proto_6(t6, p6, ...) t6 p6, expand_enter_proto_5(__VA_ARGS__)
> +
> +#define expand_enter_args_0()
> +#define expand_enter_args_1(t1, p1) p1
> +#define expand_enter_args_2(t2, p2, ...) p2, expand_enter_args_1(__VA_ARGS__)
> +#define expand_enter_args_3(t3, p3, ...) p3, expand_enter_args_2(__VA_ARGS__)
> +#define expand_enter_args_4(t4, p4, ...) p4, expand_enter_args_3(__VA_ARGS__)
> +#define expand_enter_args_5(t5, p5, ...) p5, expand_enter_args_4(__VA_ARGS__)
> +#define expand_enter_args_6(t6, p6, ...) p6, expand_enter_args_5(__VA_ARGS__)
> +
> +#define expand_enter_entry_0()
> +#define expand_enter_entry_1(t1, p1) __field(t1, p1) 
> +#define expand_enter_entry_2(t2, p2, ...) __field(t2, p2) expand_enter_entry_1(__VA_ARGS__)
> +#define expand_enter_entry_3(t3, p3, ...) __field(t3, p3) expand_enter_entry_2(__VA_ARGS__)
> +#define expand_enter_entry_4(t4, p4, ...) __field(t4, p4) expand_enter_entry_3(__VA_ARGS__)
> +#define expand_enter_entry_5(t5, p5, ...) __field(t5, p5) expand_enter_entry_4(__VA_ARGS__)
> +#define expand_enter_entry_6(t6, p6, ...) __field(t6, p6) expand_enter_entry_5(__VA_ARGS__)
> +
> +#define expand_enter_assign_0()
> +#define expand_enter_assign_1(t1, p1) __entry->p1 = p1; 
> +#define expand_enter_assign_2(t2, p2, ...) __entry->p2 = p2; expand_enter_assign_1(__VA_ARGS__)
> +#define expand_enter_assign_3(t3, p3, ...) __entry->p3 = p3; expand_enter_assign_2(__VA_ARGS__)
> +#define expand_enter_assign_4(t4, p4, ...) __entry->p4 = p4; expand_enter_assign_3(__VA_ARGS__)
> +#define expand_enter_assign_5(t5, p5, ...) __entry->p5 = p5; expand_enter_assign_4(__VA_ARGS__)
> +#define expand_enter_assign_6(t6, p6, ...) __entry->p6 = p6; expand_enter_assign_5(__VA_ARGS__)
> +
> +#define expand_enter_printk_1(t1, p1) (u64)__entry->p1
> +#define expand_enter_printk_2(t2, p2, ...) (u64)__entry->p2, expand_enter_printk_1(__VA_ARGS__)
> +#define expand_enter_printk_3(t3, p3, ...) (u64)__entry->p3, expand_enter_printk_2(__VA_ARGS__)
> +#define expand_enter_printk_4(t4, p4, ...) (u64)__entry->p4, expand_enter_printk_3(__VA_ARGS__)
> +#define expand_enter_printk_5(t5, p5, ...) (u64)__entry->p5, expand_enter_printk_4(__VA_ARGS__)
> +#define expand_enter_printk_6(t6, p6, ...) (u64)__entry->p6, expand_enter_printk_5(__VA_ARGS__)
> +
> +#define TP_printk_0() TP_printk()
> +#define TP_printk_1(...) TP_printk("%016Lx", expand_enter_printk_1(__VA_ARGS__))
> +#define TP_printk_2(...) TP_printk("%016Lx %016Lx", expand_enter_printk_2(__VA_ARGS__))
> +#define TP_printk_3(...) TP_printk("%016Lx %016Lx %016Lx", expand_enter_printk_3(__VA_ARGS__))
> +#define TP_printk_4(...) TP_printk("%016Lx %016Lx %016Lx %016Lx", expand_enter_printk_4(__VA_ARGS__))
> +#define TP_printk_5(...) TP_printk("%016Lx %016Lx %016Lx %016Lx %016Lx", \
> +						expand_enter_printk_5(__VA_ARGS__))
> +#define TP_printk_6(...) TP_printk("%016Lx %016Lx %016Lx %016Lx %016Lx %016Lx", \
> +						expand_enter_printk_6(__VA_ARGS__))



Hmm, may be just use %p so that it will adapt to the arch len.
Anyway we'll need to custom the syscall args printing, once we
have these tracepoints.



> +
> +#define trace_event_syscall_enter(n, name, ...)			\
> +	TRACE_EVENT(sysenter_##name,				\
> +		TP_PROTO(expand_enter_proto_##n(__VA_ARGS__)),	\
> +		TP_ARGS(expand_enter_args_##n(__VA_ARGS__)),	\
> +		TP_STRUCT__entry(expand_enter_entry_##n(__VA_ARGS__)), \
> +		TP_fast_assign(expand_enter_assign_##n(__VA_ARGS__)), \
> +		TP_printk_##n(__VA_ARGS__) \
> +	);							
> +
> +/* exit helper macros */
> +
> +#define create_syscall_exit(sysname)               		\
> +        case __NR_##sysname:					\
> +                trace_sysexit_##sysname(ret);                   \
> +                break;                                          \
> +
> +#define trace_event_syscall_exit(name)				\
> +	TRACE_EVENT(sysexit_##name,				\
> +		TP_PROTO(long ret),				\
> +		TP_ARGS(ret),					\
> +		TP_STRUCT__entry(				\
> +			__field(long, retval)			\
> +		),						\
> +		TP_fast_assign(					\
> +			__entry->retval = ret;			\
> +		),						\
> +		TP_printk("return value: %ld", __entry->retval) \
> +	);							


Until there it looks good, these helpers can be applied in SYSCALL_DEFINE(),
but I really think the manually written per syscall tracepoints definition
is not a good idea.

What you did above may be fine to be integrated inside SYSCALL_DEFINEx() so
that we can benefit from the magic of defining each syscall tracepoints
in a single generic code.

It will probably require some tuning such as setting the TIF_FTRACE
flags from the reg() callback in TRACE_EVENT.
And probably some other things.

Thanks.

Frederic.


> +#ifdef __NR_time
> +trace_event_syscall_enter(1, time, time_t __user *, tloc);
> +trace_event_syscall_exit(time);
> +#define ENTERCASEtime create_syscall_enter(1, time, time_t __user *);
> +#define EXITCASEtime create_syscall_exit(time);
> +#else
> +#define ENTERCASEtime
> +#define EXITCASEtime
> +#endif
> +
> +#ifdef __NR_stime
> +trace_event_syscall_enter(1, stime, time_t __user *, tptr);
> +trace_event_syscall_exit(stime);
> +#define ENTERCASEstime create_syscall_enter(1, stime, time_t __user *);
> +#define EXITCASEstime create_syscall_exit(stime);
> +#else
> +#define ENTERCASEstime
> +#define EXITCASEstime
> +#endif

