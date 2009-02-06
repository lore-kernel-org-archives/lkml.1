Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZBFTpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZBFTpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZBFTpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:45:35 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:49747 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbZBFTpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:45:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAAIfjElMQWt2/2dsb2JhbACBbsxvhBYG
Date: Fri, 6 Feb 2009 14:40:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/7] ring-buffer: add NMI protection for spinlocks
Message-ID: <20090206194030.GB32652@Krystal>
References: <20090206152151.962749733@goodmis.org> <20090206152720.441757059@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090206152720.441757059@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:39:16 up 36 days, 19:37,  3 users,  load average: 0.10, 0.16,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: prevent deadlock in NMI
> 
> The ring buffers are not yet totally lockless with writing to
> the buffer. When a writer crosses a page, it grabs a per cpu spinlock
> to protect against a reader. The spinlocks taken by a writer are not
> to protect against other writers, since a writer can only write to
> its own per cpu buffer. The spinlocks protect against readers that
> can touch any cpu buffer. The writers are made to be reentrant
> with the spinlocks disabling interrupts.
> 
> The problem arises when an NMI writes to the buffer, and that write
> crosses a page boundary. If it grabs a spinlock, it can be racing
> with another writer (since disabling interrupts does not protect
> against NMIs) or with a reader on the same CPU. Luckily, most of the
> users are not reentrant and protects against this issue. But if a
> user of the ring buffer becomes reentrant (which is what the ring
> buffers do allow), if the NMI also writes to the ring buffer then
> we risk the chance of a deadlock.
> 
> This patch moves the ftrace_nmi_enter called by nmi_enter() to the
> ring buffer code. It replaces the current ftrace_nmi_enter that is
> used by arch specific code to arch_ftrace_nmi_enter and updates
> the Kconfig to handle it.
> 
> When an NMI is called, it will set a per cpu variable in the ring buffer
> code and will clear it when the NMI exits. If a write to the ring buffer
> crosses page boundaries inside an NMI, a trylock is used on the spin
> lock instead. If the spinlock fails to be acquired, then the entry
> is discarded.
> 
> This bug appeared in the ftrace work in the RT tree, where event tracing
> is reentrant. This workaround solved the deadlocks that appeared there.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/Kconfig           |    1 +
>  arch/x86/kernel/ftrace.c   |    8 +++---
>  include/linux/ftrace_irq.h |   10 ++++++++-
>  kernel/trace/Kconfig       |    8 +++++++
>  kernel/trace/ring_buffer.c |   48 ++++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4277640..3da7121 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -34,6 +34,7 @@ config X86
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
> +	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE || FUNCTION_GRAPH_TRACER
>  	select HAVE_KVM
>  	select HAVE_ARCH_KGDB
>  	select HAVE_ARCH_TRACEHOOK
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 4d33224..4c68358 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -113,7 +113,7 @@ static void ftrace_mod_code(void)
>  					     MCOUNT_INSN_SIZE);
>  }
>  
> -void ftrace_nmi_enter(void)
> +void arch_ftrace_nmi_enter(void)
>  {
>  	atomic_inc(&in_nmi);
>  	/* Must have in_nmi seen before reading write flag */
> @@ -124,7 +124,7 @@ void ftrace_nmi_enter(void)
>  	}
>  }
>  
> -void ftrace_nmi_exit(void)
> +void arch_ftrace_nmi_exit(void)
>  {
>  	/* Finish all executions before clearing in_nmi */
>  	smp_wmb();
> @@ -376,12 +376,12 @@ int ftrace_disable_ftrace_graph_caller(void)
>   */
>  static atomic_t in_nmi;
>  
> -void ftrace_nmi_enter(void)
> +void arch_ftrace_nmi_enter(void)
>  {
>  	atomic_inc(&in_nmi);
>  }
>  
> -void ftrace_nmi_exit(void)
> +void arch_ftrace_nmi_exit(void)
>  {
>  	atomic_dec(&in_nmi);
>  }
> diff --git a/include/linux/ftrace_irq.h b/include/linux/ftrace_irq.h
> index 366a054..29de677 100644
> --- a/include/linux/ftrace_irq.h
> +++ b/include/linux/ftrace_irq.h
> @@ -2,7 +2,15 @@
>  #define _LINUX_FTRACE_IRQ_H
>  
>  
> -#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_FUNCTION_GRAPH_TRACER)
> +#ifdef CONFIG_FTRACE_NMI_ENTER
> +extern void arch_ftrace_nmi_enter(void);
> +extern void arch_ftrace_nmi_exit(void);
> +#else
> +static inline void arch_ftrace_nmi_enter(void) { }
> +static inline void arch_ftrace_nmi_exit(void) { }
> +#endif
> +
> +#ifdef CONFIG_RING_BUFFER
>  extern void ftrace_nmi_enter(void);
>  extern void ftrace_nmi_exit(void);
>  #else
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 28f2644..25131a5 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -9,6 +9,9 @@ config USER_STACKTRACE_SUPPORT
>  config NOP_TRACER
>  	bool
>  
> +config HAVE_FTRACE_NMI_ENTER
> +	bool
> +
>  config HAVE_FUNCTION_TRACER
>  	bool
>  
> @@ -37,6 +40,11 @@ config TRACER_MAX_TRACE
>  config RING_BUFFER
>  	bool
>  
> +config FTRACE_NMI_ENTER
> +       bool
> +       depends on HAVE_FTRACE_NMI_ENTER
> +       default y
> +
>  config TRACING
>  	bool
>  	select DEBUG_FS
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index b36d737..a60a6a8 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
>   */
>  #include <linux/ring_buffer.h>
> +#include <linux/ftrace_irq.h>
>  #include <linux/spinlock.h>
>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
> @@ -19,6 +20,35 @@
>  #include "trace.h"
>  
>  /*
> + * Since the write to the buffer is still not fully lockless,
> + * we must be careful with NMIs. The locks in the writers
> + * are taken when a write crosses to a new page. The locks
> + * protect against races with the readers (this will soon
> + * be fixed with a lockless solution).
> + *
> + * Because we can not protect against NMIs, and we want to
> + * keep traces reentrant, we need to manage what happens
> + * when we are in an NMI.
> + */
> +static DEFINE_PER_CPU(int, rb_in_nmi);
> +
> +void ftrace_nmi_enter(void)
> +{
> +	__get_cpu_var(rb_in_nmi)++;
> +	/* call arch specific handler too */
> +	arch_ftrace_nmi_enter();
> +}
> +
> +void ftrace_nmi_exit(void)
> +{
> +	arch_ftrace_nmi_exit();
> +	__get_cpu_var(rb_in_nmi)--;
> +	/* NMIs are not recursive */
> +	WARN_ON_ONCE(__get_cpu_var(rb_in_nmi));
> +}
> +
> +
> +/*
>   * A fast way to enable or disable all ring buffers is to
>   * call tracing_on or tracing_off. Turning off the ring buffers
>   * prevents all ring buffers from being recorded to.
> @@ -982,6 +1012,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  	struct ring_buffer *buffer = cpu_buffer->buffer;
>  	struct ring_buffer_event *event;
>  	unsigned long flags;
> +	bool lock_taken = false;
>  
>  	commit_page = cpu_buffer->commit_page;
>  	/* we just need to protect against interrupts */
> @@ -995,7 +1026,19 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  		struct buffer_page *next_page = tail_page;
>  
>  		local_irq_save(flags);
> -		__raw_spin_lock(&cpu_buffer->lock);
> +		/*
> +		 * NMIs can happen after we take the lock.
> +		 * If we are in an NMI, only take the lock
> +		 * if it is not already taken. Otherwise
> +		 * simply fail.
> +		 */
> +		if (unlikely(__get_cpu_var(rb_in_nmi))) {
> +			if (!__raw_spin_trylock(&cpu_buffer->lock))
> +				goto out_unlock;

Hi Steven,

You're not silently discarding an event, aren't you ? ;)

Please keep at least a count of "events_lost" so it can be reported
later by a printk().

Mathieu


> +		} else
> +			__raw_spin_lock(&cpu_buffer->lock);
> +
> +		lock_taken = true;
>  
>  		rb_inc_page(cpu_buffer, &next_page);
>  
> @@ -1097,7 +1140,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
>  	if (tail <= BUF_PAGE_SIZE)
>  		local_set(&tail_page->write, tail);
>  
> -	__raw_spin_unlock(&cpu_buffer->lock);
> +	if (likely(lock_taken))
> +		__raw_spin_unlock(&cpu_buffer->lock);
>  	local_irq_restore(flags);
>  	return NULL;
>  }
> -- 
> 1.5.6.5
> 
> -- 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
