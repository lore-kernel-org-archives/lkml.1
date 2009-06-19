Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZFSEMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZFSEMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 00:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZFSEMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 00:12:03 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50610 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZFSEMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 00:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RWQnmqTjZ09b7exG2kIyD/wEHBt4P69TcHJlTbtIc1O8QBcT3ukVA9zF+oKmAZVT+i
         LHgAG/VOJIBLsuV+kqJxNk7BIyrgvyJp/FAp29rbMta49XFm2NVR9/prLhmHiUIGVTok
         V+Ny4FS7hqAXCj7zdJ8dap5iszk3htGyKtuhw=
Date: Fri, 19 Jun 2009 06:11:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH 2/2] function-graph: add stack frame test
Message-ID: <20090619041158.GK7903@nowhere>
References: <20090618224409.916725341@goodmis.org> <20090618225248.706493256@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618225248.706493256@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 06:44:11PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> In case gcc does something funny with the stack frames, or the return
> from function code, we would like to detect that.
> 
> An arch may implement passing of a variable that is unique to the
> function and can be saved on entering a function and can be tested
> when exiting the function. Usually the frame pointer can be used for
> this purpose.
> 
> This patch also implements this for x86. Where it passes in the stack
> frame of the parent function, and will test that frame on exit.
> 
> There was a case in x86_32 with optimize for size (-Os) where, for a
> few functions, gcc would align the stack frame and place a copy of the
> return address into it. The function graph tracer modified the copy and
> not the actual return address. On return from the funtion, it did not go
> to the tracer hook, but returned to the parent. This broke the function
> graph tracer, because the return of the parent (where gcc did not do
> this funky manipulation) returned to the location that the child function
> was suppose to. This caused strange kernel crashes.
> 
> This test detected the problem and pointed out where the issue was.
> 
> This modifies the parameters of one of the functions that the arch
> specific code calls, so it includes changes to arch code to accommodate
> the new prototype.
> 
> Note, I notice that the parsic arch implements its own push_return_trace.
> This is now a generic function and the ftrace_push_return_trace should be
> used instead. This patch does not touch that code.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/powerpc/kernel/ftrace.c         |    2 +-
>  arch/s390/kernel/ftrace.c            |    2 +-
>  arch/x86/Kconfig                     |    1 +
>  arch/x86/kernel/entry_32.S           |    2 +
>  arch/x86/kernel/entry_64.S           |    2 +
>  arch/x86/kernel/ftrace.c             |    6 +++-
>  include/linux/ftrace.h               |    4 ++-
>  kernel/trace/Kconfig                 |    7 ++++++
>  kernel/trace/trace_functions_graph.c |   36 ++++++++++++++++++++++++++++++---
>  9 files changed, 53 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
> index 2d182f1..58d6a61 100644
> --- a/arch/powerpc/kernel/ftrace.c
> +++ b/arch/powerpc/kernel/ftrace.c
> @@ -605,7 +605,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  		return;
>  	}
>  
> -	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
> +	if (ftrace_push_return_trace(old, self_addr, &trace.depth, 0) == -EBUSY) {
>  		*parent = old;
>  		return;
>  	}
> diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
> index 82ddfd3..3e298e6 100644
> --- a/arch/s390/kernel/ftrace.c
> +++ b/arch/s390/kernel/ftrace.c
> @@ -190,7 +190,7 @@ unsigned long prepare_ftrace_return(unsigned long ip, unsigned long parent)
>  		goto out;
>  	if (unlikely(atomic_read(&current->tracing_graph_pause)))
>  		goto out;
> -	if (ftrace_push_return_trace(parent, ip, &trace.depth) == -EBUSY)
> +	if (ftrace_push_return_trace(parent, ip, &trace.depth, 0) == -EBUSY)
>  		goto out;
>  	trace.func = ftrace_mcount_call_adjust(ip) & PSW_ADDR_INSN;
>  	/* Only trace if the calling function expects to. */
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 356d2ec..fcf12af 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -33,6 +33,7 @@ config X86
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_GRAPH_TRACER
> +	select HAVE_FUNCTION_GRAPH_FP_TEST
>  	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
>  	select HAVE_FTRACE_SYSCALLS
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index c929add..0d4b285 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1154,6 +1154,7 @@ ENTRY(ftrace_graph_caller)
>  	pushl %edx
>  	movl 0xc(%esp), %edx
>  	lea 0x4(%ebp), %eax
> +	movl (%ebp), %ecx
>  	subl $MCOUNT_INSN_SIZE, %edx
>  	call prepare_ftrace_return
>  	popl %edx
> @@ -1168,6 +1169,7 @@ return_to_handler:
>  	pushl %eax
>  	pushl %ecx
>  	pushl %edx
> +	movl %ebp, %eax


Ah, I see...



>  	call ftrace_return_to_handler
>  	movl %eax, 0xc(%esp)
>  	popl %edx
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index de74f0a..c251be7 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -135,6 +135,7 @@ ENTRY(ftrace_graph_caller)
>  
>  	leaq 8(%rbp), %rdi
>  	movq 0x38(%rsp), %rsi
> +	movq (%rbp), %rdx
>  	subq $MCOUNT_INSN_SIZE, %rsi
>  
>  	call	prepare_ftrace_return
> @@ -150,6 +151,7 @@ GLOBAL(return_to_handler)
>  	/* Save the return values */
>  	movq %rax, (%rsp)
>  	movq %rdx, 8(%rsp)
> +	movq %rbp, %rdi
>  
>  	call ftrace_return_to_handler
>  
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index b79c553..d94e1ea 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -408,7 +408,8 @@ int ftrace_disable_ftrace_graph_caller(void)
>   * Hook the return address and push it in the stack of return addrs
>   * in current thread info.
>   */
> -void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> +			   unsigned long frame_pointer)
>  {
>  	unsigned long old;
>  	int faulted;
> @@ -453,7 +454,8 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  		return;
>  	}
>  
> -	if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
> +	if (ftrace_push_return_trace(old, self_addr, &trace.depth,
> +		    frame_pointer) == -EBUSY) {
>  		*parent = old;
>  		return;
>  	}
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 39b95c5..dc3b132 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -362,6 +362,7 @@ struct ftrace_ret_stack {
>  	unsigned long func;
>  	unsigned long long calltime;
>  	unsigned long long subtime;
> +	unsigned long fp;
>  };
>  
>  /*
> @@ -372,7 +373,8 @@ struct ftrace_ret_stack {
>  extern void return_to_handler(void);
>  
>  extern int
> -ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth);
> +ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
> +			 unsigned long frame_pointer);
>  
>  /*
>   * Sometimes we don't want to trace a function with the function
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 1eac852..b17ed87 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -18,6 +18,13 @@ config HAVE_FUNCTION_TRACER
>  config HAVE_FUNCTION_GRAPH_TRACER
>  	bool
>  
> +config HAVE_FUNCTION_GRAPH_FP_TEST
> +	bool
> +	help
> +	 An arch may pass in a unique value (frame pointer) to both the
> +	 entering and exiting of a function. On exit, the value is compared
> +	 and if it does not match, then it will panic the kernel.
> +
>  config HAVE_FUNCTION_TRACE_MCOUNT_TEST
>  	bool
>  	help
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 8b59241..d2249ab 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -57,7 +57,8 @@ static struct tracer_flags tracer_flags = {
>  
>  /* Add a function return address to the trace stack on thread info.*/
>  int
> -ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
> +ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
> +			 unsigned long frame_pointer)
>  {
>  	unsigned long long calltime;
>  	int index;
> @@ -85,6 +86,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
>  	current->ret_stack[index].func = func;
>  	current->ret_stack[index].calltime = calltime;
>  	current->ret_stack[index].subtime = 0;
> +	current->ret_stack[index].fp = frame_pointer;
>  	*depth = index;
>  
>  	return 0;
> @@ -92,7 +94,8 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth)
>  
>  /* Retrieve a function return address to the trace stack on thread info.*/
>  static void
> -ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
> +ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
> +			unsigned long frame_pointer)
>  {
>  	int index;
>  
> @@ -106,6 +109,31 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
>  		return;
>  	}
>  
> +#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
> +	/*
> +	 * The arch may choose to record the frame pointer used
> +	 * and check it here to make sure that it is what we expect it
> +	 * to be. If gcc does not set the place holder of the return
> +	 * address in the frame pointer, and does a copy instead, then
> +	 * the function graph trace will fail. This test detects this
> +	 * case.
> +	 *
> +	 * Currently, x86_32 with optimize for size (-Os) makes the latest
> +	 * gcc do the above.
> +	 */
> +	if (unlikely(current->ret_stack[index].fp != frame_pointer)) {
> +		ftrace_graph_stop();
> +		WARN(1, "Bad frame pointer: expected %lx, received %lx\n"
> +		     "  from func %pF return to %lx\n",
> +		     current->ret_stack[index].fp,
> +		     frame_pointer,
> +		     (void *)current->ret_stack[index].func,
> +		     current->ret_stack[index].ret);
> +		*ret = (unsigned long)panic;
> +		return;
> +	}
> +#endif


Nice thing! I don't see another solution to detect this problem for
now.

BTW, does this weird copy of return address in the stack only occur
in few functions or most of them?

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> +
>  	*ret = current->ret_stack[index].ret;
>  	trace->func = current->ret_stack[index].func;
>  	trace->calltime = current->ret_stack[index].calltime;
> @@ -117,12 +145,12 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
>   * Send the trace to the ring-buffer.
>   * @return the original return address.
>   */
> -unsigned long ftrace_return_to_handler(void)
> +unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
>  {
>  	struct ftrace_graph_ret trace;
>  	unsigned long ret;
>  
> -	ftrace_pop_return_trace(&trace, &ret);
> +	ftrace_pop_return_trace(&trace, &ret, frame_pointer);
>  	trace.rettime = trace_clock_local();
>  	ftrace_graph_return(&trace);
>  	barrier();
> -- 
> 1.6.3.1
> 
> -- 

