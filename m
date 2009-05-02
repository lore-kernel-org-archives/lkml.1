Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZEBALU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZEBALU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZEBALH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:11:07 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:39622 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZEBALG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X8QCPCcGvco+TtClBbLCBg5nmwViRN4afRM9JWFXrEtIV1PCKuvgBefXnhMblocvYj
         ddl9qKuojCE6opQwwdY00p3KSr9Ht466srg2woU07d8Njrj3V/04FIvUuhJZCJOgqO9g
         GnC7knIE8YjBkXYFc3e/oa3s/wxf7P6/ETizI=
Date: Sat, 2 May 2009 02:11:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] ftrace: add function-graph tracer support for ARM
	v2
Message-ID: <20090502001100.GH6404@nowhere>
References: <49FB79CF.3020101@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FB79CF.3020101@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:38:07PM -0700, Tim Bird wrote:
> Add ftrace function-graph tracer support for ARM.
> 
> This includes adding code in mcount to check for
> (and call) a registered function graph trace entry
> routine, and adding infrastructure to support a return
> trampoline to the threadinfo structure.
> 
> The code in arch/arm/kernel/ftrace_return.c was
> cloned from arch/x86/kernel/ftrace.c
> 
> IRQENTRY_TEXT was added to vmlinux.lds.S (to eliminate
> a compiler error on kernel/trace/trace_functions_graph.c),
> although no routines were marked as __irq_entry.
> 
> This works for me with a gcc 4.1.1 compiler on an
> OMAP OSK board.  This is against -tip (or at least,
> -tip a few weeks ago - 2.6.30-rc3)
> 
> This (v2) patch addresses previously received feedback,
> except for one issue.  In this version of the code,
> a function_graph tracer overrides regular function
> tracers.  I'll try to address that in a subsequent
> patch, but I didn't want to go too long without posting
> something.
> 
> Note: this code is much cleaner now that much of the
> common return-handling code was moved into
> kernel/trace_functions_graph.c
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/Kconfig                |    1
>  arch/arm/kernel/Makefile        |    4 +--
>  arch/arm/kernel/entry-common.S  |   34 ++++++++++++++++++++++++++++++
>  arch/arm/kernel/ftrace_return.c |   44 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/vmlinux.lds.S   |    1
>  5 files changed, 81 insertions(+), 3 deletions(-)
> 
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -17,6 +17,7 @@ config ARM
>  	select HAVE_KPROBES if (!XIP_KERNEL)
>  	select HAVE_KRETPROBES if (HAVE_KPROBES)
>  	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> +	select HAVE_FUNCTION_GRAPH_TRACER if (!XIP_KERNEL)
>  	select HAVE_GENERIC_DMA_COHERENT
>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -4,9 +4,8 @@
> 
>  AFLAGS_head.o := -DTEXT_OFFSET=$(TEXT_OFFSET)
> 
> -ifdef CONFIG_DYNAMIC_FTRACE
>  CFLAGS_REMOVE_ftrace.o = -pg
> -endif
> +CFLAGS_REMOVE_ftrace_return.o = -pg
> 
>  # Object file lists.
> 
> @@ -23,6 +22,7 @@ obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
>  obj-$(CONFIG_PCI)		+= bios32.o isa.o
>  obj-$(CONFIG_SMP)		+= smp.o
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
> +obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace_return.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
>  obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-decode.o
>  obj-$(CONFIG_ATAGS_PROC)	+= atags.o
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -112,6 +112,11 @@ ENTRY(mcount)
>  	mov r0, lr
>  	sub r0, r0, #MCOUNT_INSN_SIZE
> 
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	@ FIXTHIS - DYNAMIC_FTRACE does not support function graph tracing
> +	@ when the dynamic work is revived, this should be supported as well
> +#endif
> +
>  	.globl mcount_call
>  mcount_call:
>  	bl ftrace_stub
> @@ -139,8 +144,16 @@ ENTRY(mcount)
>  	adr r0, ftrace_stub
>  	cmp r0, r2
>  	bne trace
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	ldr r1, =ftrace_graph_return
> +	ldr r2, [r1]
> +	cmp r0, r2		@ if *ftrace_graph_return != ftrace_stub
> +	bne ftrace_graph_caller
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
>  	ldr lr, [fp, #-4]			@ restore lr
> -	ldmia sp!, {r0-r3, pc}
> +	ldmia sp!, {r0-r3, pc}			@ return doing nothing
> 
>  trace:
>  	ldr r1, [fp, #-4]			@ lr of instrumented routine
> @@ -151,6 +164,25 @@ trace:
>  	mov lr, r1				@ restore lr
>  	ldmia sp!, {r0-r3, pc}
> 
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +ENTRY(ftrace_graph_caller)
> +	sub r0, fp, #4			@ &lr of instrumented routine (&parent)
> +	mov r1, lr			@ instrumented routine (func)
> +	sub r1, r1, #MCOUNT_INSN_SIZE
> +	bl prepare_ftrace_return
> +	ldr lr, [fp, #-4]		@ restore lr
> +	ldmia sp!, {r0-r3, pc}
> +
> +	.globl return_to_handler
> +return_to_handler:
> +	stmdb sp!, {r0-r3}
> +	bl ftrace_return_to_handler
> +	mov lr, r0			@ r0 has real ret addr
> +	ldmia sp!, {r0-r3}
> +	mov pc, lr
> +
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */



Looks good.



>  #endif /* CONFIG_DYNAMIC_FTRACE */
> 
>  	.globl ftrace_stub
> --- /dev/null
> +++ b/arch/arm/kernel/ftrace_return.c



Because it is more commonly known as function graph,
I would suggest ftrace_graph.c so that people can
find it more easily.



> @@ -0,0 +1,44 @@
> +/*
> + * function return tracing support.
> + *
> + * Copyright (C) 2009 Tim Bird <tim.bird@am.sony.com>
> + *
> + * For licencing details, see COPYING.
> + *
> + * Defines routine needed for ARM return trampoline for tracing
> + * function exits.
> + */
> +
> +#include <linux/ftrace.h>
> +
> +/*
> + * Hook the return address and push it in the stack of return addrs
> + * in current thread info.
> + */
> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> +{
> +	unsigned long old;
> +
> +	struct ftrace_graph_ent trace;
> +	unsigned long return_hooker = (unsigned long)
> +				&return_to_handler;
> +
> +	if (unlikely(atomic_read(&current->tracing_graph_pause)))
> +		return;
> +
> +	old = *parent;
> +	*parent = return_hooker;
> +
> +	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
> +		*parent = old;
> +		return;
> +	}
> +
> +	trace.func = self_addr;
> +
> +	/* Only trace if the calling function expects to */
> +	if (!ftrace_graph_entry(&trace)) {
> +		current->curr_ret_stack--;
> +		*parent = old;
> +	}
> +}
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -99,6 +99,7 @@ SECTIONS
>  			SCHED_TEXT
>  			LOCK_TEXT
>  			KPROBES_TEXT
> +			IRQENTRY_TEXT
>  #ifdef CONFIG_MMU
>  			*(.fixup)
>  #endif


Well, it looks good to me.
May be you can also add the fault protection against the return address,
as a paranoid check. But that can be done later.

Also I wonder how far we are from the dynamic ftrace support, which seems
half implemented or broken or not tested for a while?

Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

