Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZE2CBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZE2CBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 22:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZE2CBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 22:01:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZE2CBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 22:01:35 -0400
Date: Thu, 28 May 2009 22:01:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: wuzhangjin@gmail.com
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v1 3/5] mips function graph tracer support
In-Reply-To: <99ab6b652c259579a34b3592af06f59e28d5f570.1243543471.git.wuzj@lemote.com>
Message-ID: <alpine.DEB.2.00.0905282158020.11238@gandalf.stny.rr.com>
References: <cover.1243543471.git.wuzj@lemote.com> <99ab6b652c259579a34b3592af06f59e28d5f570.1243543471.git.wuzj@lemote.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:
> diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> index ce8a0ba..bd58f16 100644
> --- a/arch/mips/kernel/mcount.S
> +++ b/arch/mips/kernel/mcount.S
> @@ -28,6 +28,10 @@
>  	PTR_SUBU	sp, PT_SIZE
>  	PTR_S	ra, PT_R31(sp)
>  	PTR_S	$1, PT_R1(sp)
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	PTR_S	v0, PT_R2(sp)
> +	PTR_S	v1, PT_R3(sp)
> +#endif
>  	PTR_S	a0, PT_R4(sp)
>  	PTR_S	a1, PT_R5(sp)
>  	PTR_S	a2, PT_R6(sp)
> @@ -43,6 +47,10 @@
>  	.macro MCOUNT_RESTORE_REGS
>  	PTR_L	ra, PT_R31(sp)
>  	PTR_L	$1, PT_R1(sp)
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	PTR_L	v0, PT_R2(sp)
> +	PTR_L	v1, PT_R3(sp)
> +#endif
>  	PTR_L	a0, PT_R4(sp)
>  	PTR_L	a1, PT_R5(sp)
>  	PTR_L	a2, PT_R6(sp)
> @@ -89,6 +97,14 @@ ftrace_call:
>  	nop
>  
>  	MCOUNT_RESTORE_REGS
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	.globl ftrace_graph_call
> +ftrace_graph_call:
> +	j	ftrace_stub
> +	nop
> +#endif
> +
>  	.globl ftrace_stub
>  ftrace_stub:
>  	RETURN_BACK
> @@ -106,7 +122,15 @@ NESTED(_mcount, PT_SIZE, ra)
>  	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
>  	bne	t0, t1, static_trace
>  	nop
> -
> +#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
> +	PTR_L	t2, ftrace_graph_return
> +	bne	t0,	t2, ftrace_graph_caller
> +	nop
> +	PTR_LA	t0, ftrace_graph_entry_stub
> +	PTR_L	t2, ftrace_graph_entry
> +	bne	t0,	t2, ftrace_graph_caller
> +	nop
> +#endif
>  	j	ftrace_stub
>  	nop
>  
> @@ -125,5 +149,37 @@ ftrace_stub:
>  
>  #endif	/* ! CONFIG_DYNAMIC_FTRACE */
>  
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +
> +NESTED(ftrace_graph_caller, PT_SIZE, ra)
> +	MCOUNT_SAVE_REGS
> +
> +	MCOUNT_SET_ARGS
> +	jal	prepare_ftrace_return
> +	nop
> +
> +	/* overwrite the parent as &return_to_handler: v0 -> $1(at) */
> +	PTR_S	v0, PT_R1(sp)
> +
> +	MCOUNT_RESTORE_REGS
> +	RETURN_BACK
> +	END(ftrace_graph_caller)
> +
> +	.align	2
> +	.globl	return_to_handler
> +return_to_handler:
> +	MCOUNT_SAVE_REGS

I'm not sure which version of function_graph tracer you looked at, but I'm 
pretty sure you can just save the return code registers of the function.

return_to_handler is called on the return of a function. Thus, any callee 
saved registers have already been restored and would also be restored by 
ftrace_return_to_handler.  Any callee registers would have been saved by 
the function you are about to return to.

Thus the only things you need to save are the return code registers.

-- Steve


> +
> +	jal	ftrace_return_to_handler
> +	nop
> +
> +	/* restore the real parent address: v0 -> ra */
> +	PTR_S	v0, PT_R31(sp)
> +
> +	MCOUNT_RESTORE_REGS
> +	RETURN_BACK
> +
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
>  	.set at
>  	.set reorder
> diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> index 58738c8..67435e5 100644
> --- a/arch/mips/kernel/vmlinux.lds.S
> +++ b/arch/mips/kernel/vmlinux.lds.S
> @@ -36,6 +36,7 @@ SECTIONS
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT
> +		IRQENTRY_TEXT
>  		*(.text.*)
>  		*(.fixup)
>  		*(.gnu.warning)
> -- 
> 1.6.0.4
> 
> 
