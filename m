Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYLLUUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYLLUUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYLLUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:19:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49871 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYLLUT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:19:57 -0500
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
From: Steven Rostedt <srostedt@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec <fweisbec@gmail.com>
In-Reply-To: <20081212184136.GB14192@localhost>
References: <20081212184136.GB14192@localhost>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 12 Dec 2008 15:19:27 -0500
Message-Id: <1229113167.32623.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-12-12 at 21:41 +0300, Cyrill Gorcunov wrote:
> Impact: clean up
> 
> Itroduce FTRACE_SAVE/RESTORE_FRAME which allow us to
> save a number of lines on source level.
> 
> Also fix a comment in ftrace.h.
> 
> ---
> Actually I'm not that sure about bringing new macros there
> since we already have a lot so feel free to just drop it.
> 
> Maybe it would be good to comment args passed
> to ftrace_call on ABI level :)

Actually that is pretty much the same as mcount call. But we may change
it in the future. We probably should document (if it is not already) the
ftrace call graph ABI.

> 
> Ah, the patch is on top of -tip e3bdf48

If you have tested this with and without dynamic ftrace, for both the
function tracer and the function graph tracer, then you have my...

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

> 
>  arch/x86/include/asm/ftrace.h |    2 -
>  arch/x86/kernel/entry_64.S    |   70 +++++++++++++++---------------------------
>  2 files changed, 26 insertions(+), 46 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/ftrace.h
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/ftrace.h
> +++ linux-2.6.git/arch/x86/include/asm/ftrace.h
> @@ -46,7 +46,7 @@ struct ftrace_ret_stack {
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
> @@ -66,10 +66,7 @@ ENTRY(mcount)
>  	retq
>  END(mcount)
>  
> -ENTRY(ftrace_caller)
> -	cmpl $0, function_trace_stop
> -	jne  ftrace_stub
> -
> +	.macro FTRACE_SAVE_FRAME
>  	/* taken from glibc */
>  	subq $0x38, %rsp
>  	movq %rax, (%rsp)
> @@ -79,15 +76,9 @@ ENTRY(ftrace_caller)
>  	movq %rdi, 32(%rsp)
>  	movq %r8, 40(%rsp)
>  	movq %r9, 48(%rsp)
> +	.endm
>  
> -	movq 0x38(%rsp), %rdi
> -	movq 8(%rbp), %rsi
> -	subq $MCOUNT_INSN_SIZE, %rdi
> -
> -.globl ftrace_call
> -ftrace_call:
> -	call ftrace_stub
> -
> +	.macro FTRACE_RESTORE_FRAME
>  	movq 48(%rsp), %r9
>  	movq 40(%rsp), %r8
>  	movq 32(%rsp), %rdi
> @@ -96,6 +87,23 @@ ftrace_call:
>  	movq 8(%rsp), %rcx
>  	movq (%rsp), %rax
>  	addq $0x38, %rsp
> +	.endm
> +
> +ENTRY(ftrace_caller)
> +	cmpl $0, function_trace_stop
> +	jne  ftrace_stub
> +
> +	FTRACE_SAVE_FRAME
> +
> +	movq 0x38(%rsp), %rdi
> +	movq 8(%rbp), %rsi
> +	subq $MCOUNT_INSN_SIZE, %rdi
> +
> +.globl ftrace_call
> +ftrace_call:
> +	call ftrace_stub
> +
> +	FTRACE_RESTORE_FRAME
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  .globl ftrace_graph_call
> @@ -129,15 +137,7 @@ ftrace_stub:
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
> @@ -145,14 +145,7 @@ trace:
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
> @@ -164,14 +157,7 @@ ENTRY(ftrace_graph_caller)
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
> @@ -179,14 +165,8 @@ ENTRY(ftrace_graph_caller)
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

