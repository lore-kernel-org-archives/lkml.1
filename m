Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075Ab0AVOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0AVOgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712Ab0AVOgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:36:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51443 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0AVOgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:36:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=cyKlVyN3Dn4A:10 a=7U3hwN5JcxgA:10 a=7mOBRU54AAAA:8 a=XvmqOta_KQa_nXUF7jsA:9 a=migb1Gs2_p0TiU6bE5UA:7 a=vzLqAb9aVxCMUKyNbRsmHPX45PAA:4 a=WeOa-AV5lc8A:10 a=fin6bCTcAjhkVmbh:21 a=p0OY-9nIzUBFXL52:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 22 Jan 2010 09:36:17 -0500
Message-ID: <1264170977.31321.382.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Heiko Carstens and Paul Mundt to Cc ]

On Fri, 2010-01-22 at 08:43 -0500, Mike Frysinger wrote:
> Every arch_syscall_addr() implementation thus far is the same, so unify
> them as a default weak in common code so more arches don't have to waste
> time copying & pasting this simple function.  The Blackfin version is
> going to be exactly the same.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> note: only thing that needs double checking is s390 and sparc where they
> declared the sys_call_table as an array of ints.  considering this table
> is supposed to be an array of function pointers, this seems like more of
> a typo to me ...

I would not be too sure. s390 is very strange, and I would definitely
want to get an Ack from the arch maintainers first.


> 
> also, does the arch_syscall_addr() even really need to be weak ?  or can
> we assume that everyone is going to be sane and do it the same way ...
> 
>  Documentation/trace/ftrace-design.txt |    6 +++++-
>  arch/s390/kernel/ftrace.c             |   10 ----------
>  arch/sh/kernel/ftrace.c               |    9 ---------
>  arch/sparc/kernel/ftrace.c            |   11 -----------
>  arch/x86/kernel/ftrace.c              |   10 ----------
>  include/linux/ftrace.h                |    6 ++++++
>  kernel/trace/trace_syscalls.c         |    6 +++++

Actually for this patch to be accepted, we need to get the acks from the
maintainers of s390, sh, and sparc since it touches their code. Doesn't
matter if it is just removing duplicate code. Still need their acks.

Thanks,

-- Steve

> +
>  7 files changed, 17 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
> index 6a5a579..1a67b8c 100644
> --- a/Documentation/trace/ftrace-design.txt
> +++ b/Documentation/trace/ftrace-design.txt
> @@ -240,8 +240,12 @@ You need very few things to get the syscalls tracing in an arch.
>  
>  - Have a NR_syscalls variable in <asm/unistd.h> that provides the number
>    of syscalls supported by the arch.
> +- Implement <asm/syscall.h>.
>  - Implement arch_syscall_addr() that resolves a syscall address from a
> -  syscall number.
> +  syscall number.  For the simple arches where your syscall table is an
> +  array of longs named "sys_call_table", there is a default implementation
> +  in kernel/trace/trace_syscalls.c.  If your arch needs something weird,
> +  then you'll have to define the function yourself.
>  - Support the TIF_SYSCALL_TRACEPOINT thread flags
>  - Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
>    in the ptrace syscalls tracing path.
> diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
> index 5a82bc6..9e69449 100644
> --- a/arch/s390/kernel/ftrace.c
> +++ b/arch/s390/kernel/ftrace.c
> @@ -200,13 +200,3 @@ out:
>  	return parent;
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> -
> -#ifdef CONFIG_FTRACE_SYSCALLS
> -
> -extern unsigned int sys_call_table[];
> -
> -unsigned long __init arch_syscall_addr(int nr)
> -{
> -	return (unsigned long)sys_call_table[nr];
> -}
> -#endif
> diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
> index a48cded..30e1319 100644
> --- a/arch/sh/kernel/ftrace.c
> +++ b/arch/sh/kernel/ftrace.c
> @@ -399,12 +399,3 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  	}
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> -
> -#ifdef CONFIG_FTRACE_SYSCALLS
> -extern unsigned long *sys_call_table;
> -
> -unsigned long __init arch_syscall_addr(int nr)
> -{
> -	return (unsigned long)sys_call_table[nr];
> -}
> -#endif /* CONFIG_FTRACE_SYSCALLS */
> diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
> index 29973da..9103a56 100644
> --- a/arch/sparc/kernel/ftrace.c
> +++ b/arch/sparc/kernel/ftrace.c
> @@ -91,14 +91,3 @@ int __init ftrace_dyn_arch_init(void *data)
>  	return 0;
>  }
>  #endif
> -
> -#ifdef CONFIG_FTRACE_SYSCALLS
> -
> -extern unsigned int sys_call_table[];
> -
> -unsigned long __init arch_syscall_addr(int nr)
> -{
> -	return (unsigned long)sys_call_table[nr];
> -}
> -
> -#endif
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 3096892..0d93a94 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -484,13 +484,3 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
>  	}
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> -
> -#ifdef CONFIG_FTRACE_SYSCALLS
> -
> -extern unsigned long *sys_call_table;
> -
> -unsigned long __init arch_syscall_addr(int nr)
> -{
> -	return (unsigned long)(&sys_call_table)[nr];
> -}
> -#endif
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 0b4f97d..1cbb36f 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -511,4 +511,10 @@ static inline void trace_hw_branch_oops(void) {}
>  
>  #endif /* CONFIG_HW_BRANCH_TRACER */
>  
> +#ifdef CONFIG_FTRACE_SYSCALLS
> +
> +unsigned long arch_syscall_addr(int nr);
> +
> +#endif /* CONFIG_FTRACE_SYSCALLS */
> +
>  #endif /* _LINUX_FTRACE_H */
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 75289f3..671c670 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -394,6 +394,12 @@ int init_syscall_trace(struct ftrace_event_call *call)
>  	return 0;
>  }
>  
> +unsigned long __init __weak arch_syscall_addr(int nr)
> +{
> +	extern const unsigned long sys_call_table[];
> +	return sys_call_table[nr];
> +}
> +
>  int __init init_ftrace_syscalls(void)
>  {
>  	struct syscall_metadata *meta;


