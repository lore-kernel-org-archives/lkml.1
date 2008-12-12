Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYLLVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYLLVXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYLLVWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:22:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYLLVWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:22:51 -0500
Date: Fri, 12 Dec 2008 16:22:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
In-Reply-To: <20081212205729.GA28554@localhost>
Message-ID: <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Dec 2008, Cyrill Gorcunov wrote:

> [Steven Rostedt - Fri, Dec 12, 2008 at 03:52:56PM -0500]
> | 
> ... 
> | You can put them in arch/x86/include/asm/ftrace.h That's assembly safe.
> | 
> | -- Steve
> | 
> 
> Yep, while you were typing the message I was testing the change :)
> Do you like it?
> 
> 		- Cyrill -
> 
> ---
>  arch/x86/include/asm/ftrace.h |   29 ++++++++++++++++++++-
>  arch/x86/kernel/entry_64.S    |   57 +++++-------------------------------------
>  2 files changed, 35 insertions(+), 51 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
> +++ linux-2.6.git/arch/x86/include/asm/ftrace.h
> @@ -1,6 +1,33 @@
>  #ifndef _ASM_X86_FTRACE_H
>  #define _ASM_X86_FTRACE_H
>  
> +#ifdef __ASSEMBLY__

Why add assembly condition? We only want this if CONFIG_FUNCTION_TRACER 
is enabled, right?  We could combine it with the current #ifndef inside 
the CONFIG_FUNCTION_TRACER. But I would make do:

#ifdef __ASSEMBLY__
<your stuff>
#else
< C stuff >
#endif

-- Steve


> +
> +	.macro FTRACE_SAVE_FRAME
> +	/* taken from glibc */
> +	subq $0x38, %rsp
> +	movq %rax, (%rsp)
> +	movq %rcx, 8(%rsp)
> +	movq %rdx, 16(%rsp)
> +	movq %rsi, 24(%rsp)
> +	movq %rdi, 32(%rsp)
> +	movq %r8, 40(%rsp)
> +	movq %r9, 48(%rsp)
> +	.endm
> +
> +	.macro FTRACE_RESTORE_FRAME
> +	movq 48(%rsp), %r9
> +	movq 40(%rsp), %r8
> +	movq 32(%rsp), %rdi
> +	movq 24(%rsp), %rsi
> +	movq 16(%rsp), %rdx
> +	movq 8(%rsp), %rcx
> +	movq (%rsp), %rax
> +	addq $0x38, %rsp
> +	.endm
> +
> +#endif
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  #define MCOUNT_ADDR		((long)(mcount))
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
> @@ -46,7 +73,7 @@ struct ftrace_ret_stack {
>  /*
>   * Primary handler of a function return.
>   * It relays on ftrace_return_to_handler.
> - * Defined in entry32.S
> + * Defined in entry_32/64.S
>   */
>  extern void return_to_handler(void);
>  
> Index: linux-2.6.git/arch/x86/kernel/entry_64.S
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
> +++ linux-2.6.git/arch/x86/kernel/entry_64.S
> @@ -70,15 +70,7 @@ ENTRY(ftrace_caller)
>  	cmpl $0, function_trace_stop
>  	jne  ftrace_stub
>  
> -	/* taken from glibc */
> -	subq $0x38, %rsp
> -	movq %rax, (%rsp)
> -	movq %rcx, 8(%rsp)
> -	movq %rdx, 16(%rsp)
> -	movq %rsi, 24(%rsp)
> -	movq %rdi, 32(%rsp)
> -	movq %r8, 40(%rsp)
> -	movq %r9, 48(%rsp)
> +	FTRACE_SAVE_FRAME
>  
>  	movq 0x38(%rsp), %rdi
>  	movq 8(%rbp), %rsi
> @@ -88,14 +80,7 @@ ENTRY(ftrace_caller)
>  ftrace_call:
>  	call ftrace_stub
>  
> -	movq 48(%rsp), %r9
> -	movq 40(%rsp), %r8
> -	movq 32(%rsp), %rdi
> -	movq 24(%rsp), %rsi
> -	movq 16(%rsp), %rdx
> -	movq 8(%rsp), %rcx
> -	movq (%rsp), %rax
> -	addq $0x38, %rsp
> +	FTRACE_RESTORE_FRAME
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  .globl ftrace_graph_call
> @@ -129,15 +114,7 @@ ftrace_stub:
>  	retq
>  
>  trace:
> -	/* taken from glibc */
> -	subq $0x38, %rsp
> -	movq %rax, (%rsp)
> -	movq %rcx, 8(%rsp)
> -	movq %rdx, 16(%rsp)
> -	movq %rsi, 24(%rsp)
> -	movq %rdi, 32(%rsp)
> -	movq %r8, 40(%rsp)
> -	movq %r9, 48(%rsp)
> +	FTRACE_SAVE_FRAME
>  
>  	movq 0x38(%rsp), %rdi
>  	movq 8(%rbp), %rsi
> @@ -145,14 +122,7 @@ trace:
>  
>  	call   *ftrace_trace_function
>  
> -	movq 48(%rsp), %r9
> -	movq 40(%rsp), %r8
> -	movq 32(%rsp), %rdi
> -	movq 24(%rsp), %rsi
> -	movq 16(%rsp), %rdx
> -	movq 8(%rsp), %rcx
> -	movq (%rsp), %rax
> -	addq $0x38, %rsp
> +	FTRACE_RESTORE_FRAME
>  
>  	jmp ftrace_stub
>  END(mcount)
> @@ -164,14 +134,7 @@ ENTRY(ftrace_graph_caller)
>  	cmpl $0, function_trace_stop
>  	jne ftrace_stub
>  
> -	subq $0x38, %rsp
> -	movq %rax, (%rsp)
> -	movq %rcx, 8(%rsp)
> -	movq %rdx, 16(%rsp)
> -	movq %rsi, 24(%rsp)
> -	movq %rdi, 32(%rsp)
> -	movq %r8, 40(%rsp)
> -	movq %r9, 48(%rsp)
> +	FTRACE_SAVE_FRAME
>  
>  	leaq 8(%rbp), %rdi
>  	movq 0x38(%rsp), %rsi
> @@ -179,14 +142,8 @@ ENTRY(ftrace_graph_caller)
>  
>  	call	prepare_ftrace_return
>  
> -	movq 48(%rsp), %r9
> -	movq 40(%rsp), %r8
> -	movq 32(%rsp), %rdi
> -	movq 24(%rsp), %rsi
> -	movq 16(%rsp), %rdx
> -	movq 8(%rsp), %rcx
> -	movq (%rsp), %rax
> -	addq $0x38, %rsp
> +	FTRACE_RESTORE_FRAME
> +
>  	retq
>  END(ftrace_graph_caller)
>  
> 
> 
