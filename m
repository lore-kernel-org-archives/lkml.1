Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYLCVa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYLCVa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYLCV3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:29:41 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39112 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611AbYLCV3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:29:39 -0500
Message-Id: <1228339777.2982.1288110715@webmail.messagingengine.com>
X-Sasl-Enc: S0DFJ1+MhF6EWj9MxKyPZvlFM8JweJxXYlMHje0oluvL 1228339777
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Frederic Weisbecker" <fweisbec@gmail.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <49347147.8070405@gmail.com>
Subject: Re: [PATCH] tracing/function-branch-tracer: support for x86-64
In-Reply-To: <49347147.8070405@gmail.com>
Date: Wed, 03 Dec 2008 22:29:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Dec 2008 00:20:39 +0100, "Frederic Weisbecker"
<fweisbec@gmail.com> said:
> Small note: Ingo, I have only one test box and I had to install a 64 bits
> distro to
> make this patch. So I can't verify if it breaks something in x86-32. I
> don't know
> what could be broken here but we never know.
> For further patches, I will use a virtual machine to test under 32.
> 
> --
> This patch implements the support for function branch tracer under
> x86-64.
> Both static and dynamic tracing are supported.
> 
> This causes some small CPP conditional asm on arch/x86/kernel/ftrace.c
> I wanted to use probe_kernel_read/write to make the return address
> saving/patching
> code more generic but it causes tracing recursion.
> 
> That would be perhaps useful to implement a notrace version of these
> function for other
> archs ports.
> 
> Note that arch/x86/process_64.c is not traced, as in X86-32. I first
> thought __switch_to()
> was responsible of crashes during tracing because I believed current task
> were changed
> inside but that's actually not the case (actually yes, but not the
> "current" pointer).
> 
> So I will have to investigate to find the functions that harm here, to
> enable tracing
> of the other functions inside (but there is no issue at this time, while
> process_64.c
> stays out of -pg flags).
> 
> A little possible race condition is fixed inside this patch too. When the
> tracer allocate
> a return stack dynamically, the current depth is not initialized before
> but after.
> An interrupt could occur at this time and, after seeing that the return
> stack is
> allocated, the tracer could try to trace it with a random uninitialized
> depth. 
> It's a prevention, even if I hadn't problems with it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/Kconfig           |    2 +-
>  arch/x86/kernel/Makefile   |    1 +
>  arch/x86/kernel/entry_64.S |   74 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/ftrace.c   |   11 ++++++-
>  kernel/trace/ftrace.c      |    2 +-
>  5 files changed, 87 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e7c0a1b..c216882 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -29,7 +29,7 @@ config X86
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FUNCTION_TRACER
> -	select HAVE_FUNCTION_GRAPH_TRACER if X86_32
> +	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
>  	select HAVE_ARCH_KGDB if !X86_VOYAGER
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 6bc8aef..5ee1ba6 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -18,6 +18,7 @@ endif
>  ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  # Don't trace __switch_to() but let it for function tracer
>  CFLAGS_REMOVE_process_32.o = -pg
> +CFLAGS_REMOVE_process_64.o = -pg
>  endif
>  
>  #
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 5e63b53..c433d86 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -97,6 +97,12 @@ ftrace_call:
>  	movq (%rsp), %rax
>  	addq $0x38, %rsp
>  
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +.globl ftrace_graph_call
> +ftrace_graph_call:
> +	jmp ftrace_stub
> +#endif
> +
>  .globl ftrace_stub
>  ftrace_stub:
>  	retq
> @@ -109,6 +115,12 @@ ENTRY(mcount)
>  
>  	cmpq $ftrace_stub, ftrace_trace_function
>  	jnz trace
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	cmpq $ftrace_stub, ftrace_graph_return
> +	jnz ftrace_graph_caller
> +#endif
> +
>  .globl ftrace_stub
>  ftrace_stub:
>  	retq
> @@ -144,6 +156,68 @@ END(mcount)
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +ENTRY(ftrace_graph_caller)
> +	cmpl $0, function_trace_stop
> +	jne ftrace_stub
> +
> +	subq $0x38, %rsp
> +	movq %rax, (%rsp)
> +	movq %rcx, 8(%rsp)
> +	movq %rdx, 16(%rsp)
> +	movq %rsi, 24(%rsp)
> +	movq %rdi, 32(%rsp)
> +	movq %r8, 40(%rsp)
> +	movq %r9, 48(%rsp)
> +
> +	leaq 8(%rbp), %rdi
> +	movq 0x38(%rsp), %rsi
> +
> +	call	prepare_ftrace_return
> +
> +	movq 48(%rsp), %r9
> +	movq 40(%rsp), %r8
> +	movq 32(%rsp), %rdi
> +	movq 24(%rsp), %rsi
> +	movq 16(%rsp), %rdx
> +	movq 8(%rsp), %rcx
> +	movq (%rsp), %rax
> +	addq $0x38, %rsp
> +	retq
> +END(ftrace_graph_caller)
> +
> +
> +.globl return_to_handler
> +return_to_handler:
> +	subq  $80, %rsp
> +
> +	movq %rax, (%rsp)
> +	movq %rcx, 8(%rsp)
> +	movq %rdx, 16(%rsp)
> +	movq %rsi, 24(%rsp)
> +	movq %rdi, 32(%rsp)
> +	movq %r8, 40(%rsp)
> +	movq %r9, 48(%rsp)
> +	movq %r10, 56(%rsp)
> +	movq %r11, 64(%rsp)
> +
> +	call ftrace_return_to_handler
> +
> +	movq %rax, 72(%rsp)
> +	movq 64(%rsp), %r11
> +	movq 56(%rsp), %r10
> +	movq 48(%rsp), %r9
> +	movq 40(%rsp), %r8
> +	movq 32(%rsp), %rdi
> +	movq 24(%rsp), %rsi
> +	movq 16(%rsp), %rdx
> +	movq 8(%rsp), %rcx
> +	movq (%rsp), %rax
> +	addq $72, %rsp
> +	retq
> +#endif
> +
> +
>  #ifndef CONFIG_PREEMPT
>  #define retint_kernel retint_restore_args
>  #endif

Hi Frederic,

The changes to entry_64.S look simple enough. The order of
saving the registers on the stack is not important in any
way, right?

> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 7ef914e..5883247 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -467,8 +467,13 @@ void prepare_ftrace_return(unsigned long *parent,
> unsigned long self_addr)
>  	 * ignore such a protection.
>  	 */
>  	asm volatile(
> +#ifdef CONFIG_X86_64
> +		"1: movq (%[parent_old]), %[old]\n"
> +		"2: movq %[return_hooker], (%[parent_replaced])\n"
> +#else
>  		"1: movl (%[parent_old]), %[old]\n"
>  		"2: movl %[return_hooker], (%[parent_replaced])\n"
> +#endif

The following should work in both cases, right?

"1: mov (%[parent_old]), %[old]\n"
"2: mov %[return_hooker], (%[parent_replaced])\n"

>  		"   movl $0, %[faulted]\n"
>  
>  		".section .fixup, \"ax\"\n"
> @@ -476,8 +481,13 @@ void prepare_ftrace_return(unsigned long *parent,
> unsigned long self_addr)
>  		".previous\n"

>  		".section __ex_table, \"a\"\n"
> +#ifdef CONFIG_X86_64
> +		"   .quad 1b, 3b\n"
> +		"   .quad 2b, 3b\n"
> +#else
>  		"   .long 1b, 3b\n"
>  		"   .long 2b, 3b\n"
> +#endif
>  		".previous\n"

I think this can be done with:

_ASM_EXTABLE(1b,3b)
_ASM_EXTABLE(2b,3b)

(from: arch/x86/include/asm/asm.h)

Greetings,
    Alexander

>  		: [parent_replaced] "=r" (parent), [old] "=r" (old),
> @@ -509,5 +519,4 @@ void prepare_ftrace_return(unsigned long *parent,
> unsigned long self_addr)
>  	ftrace_graph_entry(&trace);
>  
>  }
> -
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 08b536a..1e9379d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1673,8 +1673,8 @@ static int alloc_retstack_tasklist(struct
> ftrace_ret_stack **ret_stack_list)
>  		}
>  
>  		if (t->ret_stack == NULL) {
> -			t->ret_stack = ret_stack_list[start++];
>  			t->curr_ret_stack = -1;
> +			t->ret_stack = ret_stack_list[start++];
>  			atomic_set(&t->trace_overrun, 0);
>  		}
>  	} while_each_thread(g, t);
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

