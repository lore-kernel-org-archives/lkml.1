Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbZHUR6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbZHUR6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZHUR6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:58:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZHUR6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:58:53 -0400
Date: Fri, 21 Aug 2009 13:57:38 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 2/2] tracing: Create generic syscall TRACE_EVENTs
Message-ID: <20090821175737.GB2684@redhat.com>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250795373-32363-2-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250795373-32363-2-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 12:09:33PM -0700, Josh Stone wrote:
> This converts the syscall_enter/exit tracepoints into TRACE_EVENTs, so
> you can have generic ftrace events that capture all system calls with
> arguments and return values.  These generic events are also renamed to
> sys_enter/exit, so they're more closely aligned to the specific
> sys_enter_foo events.
> 
> Signed-off-by: Josh Stone <jistone@redhat.com>
> Cc: Jason Baron <jbaron@redhat.com>
> ---
>  arch/s390/kernel/ptrace.c       |    8 ++--
>  arch/x86/kernel/ptrace.c        |   12 +++----
>  include/trace/events/syscalls.h |   66 +++++++++++++++++++++++++++++++++++++++
>  include/trace/syscall.h         |   13 --------
>  kernel/trace/trace_syscalls.c   |   17 +++++-----
>  5 files changed, 84 insertions(+), 32 deletions(-)
>  create mode 100644 include/trace/events/syscalls.h
> 
> diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
> index 26194b0..8e578a9 100644
> --- a/arch/s390/kernel/ptrace.c
> +++ b/arch/s390/kernel/ptrace.c
> @@ -51,8 +51,8 @@
>  #include "compat_ptrace.h"
>  #endif
>  
> -DEFINE_TRACE_WITH_CALLBACK(syscall_enter, syscall_regfunc, syscall_unregfunc);
> -DEFINE_TRACE_WITH_CALLBACK(syscall_exit, syscall_regfunc, syscall_unregfunc);
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
>  
>  enum s390_regset {
>  	REGSET_GENERAL,
> @@ -665,7 +665,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
>  	}
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		trace_syscall_enter(regs, regs->gprs[2]);
> +		trace_sys_enter(regs, regs->gprs[2]);
>  
>  	if (unlikely(current->audit_context))
>  		audit_syscall_entry(is_compat_task() ?
> @@ -683,7 +683,7 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs)
>  				   regs->gprs[2]);
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		trace_syscall_exit(regs, regs->gprs[2]);
> +		trace_sys_exit(regs, regs->gprs[2]);
>  
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall_exit(regs, 0);
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 692fc14..dc87a04 100644
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
> @@ -1501,7 +1499,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
>  		ret = -1L;
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		trace_syscall_enter(regs, regs->orig_ax);
> +		trace_sys_enter(regs, regs->orig_ax);
>  
>  	if (unlikely(current->audit_context)) {
>  		if (IS_IA32)
> @@ -1527,7 +1525,7 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
>  		audit_syscall_exit(AUDITSC_RESULT(regs->ax), regs->ax);
>  
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_FTRACE)))
> -		trace_syscall_exit(regs, regs->ax);
> +		trace_sys_exit(regs, regs->ax);
>  
>  	if (test_thread_flag(TIF_SYSCALL_TRACE))
>  		tracehook_report_syscall_exit(regs, 0);
> diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
> new file mode 100644
> index 0000000..9cd78fc
> --- /dev/null
> +++ b/include/trace/events/syscalls.h
> @@ -0,0 +1,66 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM syscalls
> +
> +#if !defined(_TRACE_EVENTS_SYSCALLS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EVENTS_SYSCALLS_H
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
> +TRACE_EVENT_WITH_CALLBACK(sys_enter,

don't we want to change this to something like 'sys_enter_generic'?
otherwise, looks good.

thanks,

-Jason

