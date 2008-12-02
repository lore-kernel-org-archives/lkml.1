Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYLBVZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYLBVZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYLBVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:25:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYLBVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:25:50 -0500
Date: Tue, 2 Dec 2008 16:25:48 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] tracing/function-branch-tracer: support for x86-64
In-Reply-To: <20081202090205.GA11632@elte.hu>
Message-ID: <alpine.DEB.1.10.0812021619080.22547@gandalf.stny.rr.com>
References: <49347147.8070405@gmail.com> <20081202090205.GA11632@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm, I had issues with my mail server so I just received this. I was 
porting it to x86-64 last night too.

On Tue, 2 Dec 2008, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > This patch implements the support for function branch tracer under x86-64.
> > Both static and dynamic tracing are supported.
> 
> Fantastic stuff! :-)
> 
> > Small note: Ingo, I have only one test box and I had to install a 64 
> > bits distro to make this patch. So I can't verify if it breaks 
> > something in x86-32. I don't know what could be broken here but we 
> > never know. For further patches, I will use a virtual machine to test 
> > under 32.
> 
> that's OK. The patch looks fairly safe on the 32-bit side.
> 
> > This causes some small CPP conditional asm on arch/x86/kernel/ftrace.c 
> > I wanted to use probe_kernel_read/write to make the return address 
> > saving/patching code more generic but it causes tracing recursion.
> 
> it's this bit:
> 
> > +#ifdef CONFIG_X86_64
> > +		"1: movq (%[parent_old]), %[old]\n"
> > +		"2: movq %[return_hooker], (%[parent_replaced])\n"
> > +#else
> >  		"1: movl (%[parent_old]), %[old]\n"
> >  		"2: movl %[return_hooker], (%[parent_replaced])\n"
> > +#endif
> >  		"   movl $0, %[faulted]\n"
> >  
> >  		".section .fixup, \"ax\"\n"
> > @@ -476,8 +481,13 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> >  		".previous\n"
> >  
> >  		".section __ex_table, \"a\"\n"
> > +#ifdef CONFIG_X86_64
> > +		"   .quad 1b, 3b\n"
> > +		"   .quad 2b, 3b\n"
> > +#else
> >  		"   .long 1b, 3b\n"
> >  		"   .long 2b, 3b\n"
> > +#endif
> 
> i think we might want to introduce a few assembly helpers/defines to 
> standardize such constructs - they are quite frequent. Something like:
> 
> 		"   .ip_ptr 1b, 3b\n"
> 		"   .ip_ptr 2b, 3b\n"
> 
> (Cc:-ed Alexander and Cyrill who have done work in this area recently)
> 
> we might also introduce instruction helpers:
> 
> 		"1: mov_ptr (%[parent_old]), %[old]\n"
> 		"2: mov_ptr %[return_hooker], (%[parent_replaced])\n"
> 
> and avoid the #ifdefs altogether.

I fixed this in my last patch queue.

> 
> > Note that arch/x86/process_64.c is not traced, as in X86-32. I first 
> > thought __switch_to() was responsible of crashes during tracing because 
> > I believed current task were changed inside but that's actually not the 
> > case (actually yes, but not the "current" pointer).
> > 
> > So I will have to investigate to find the functions that harm here, to 
> > enable tracing of the other functions inside (but there is no issue at 
> > this time, while process_64.c stays out of -pg flags).
> 
> ok. You should take a look at arch/x86/include/asm/system.h's switch_to() 
> macros - it has special stack switching smarts for context-switching.
> 
> the other special stack layout case is the starting of kernel threads - 
> ret_from_fork and its details in process*.c.

I'm hitting some crashes but it does not seem to be related to this.
I'm still investigating, but it looks like it is due to some strange race
because I can run for hours sometimes and other times it crashes right
away.

> 
> > A little possible race condition is fixed inside this patch too. When 
> > the tracer allocate a return stack dynamically, the current depth is 
> > not initialized before but after. An interrupt could occur at this time 
> > and, after seeing that the return stack is allocated, the tracer could 
> > try to trace it with a random uninitialized depth. It's a prevention, 
> > even if I hadn't problems with it.
> 
> > index 08b536a..1e9379d 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1673,8 +1673,8 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
> >  		}
> >  
> >  		if (t->ret_stack == NULL) {
> > -			t->ret_stack = ret_stack_list[start++];
> >  			t->curr_ret_stack = -1;
> > +			t->ret_stack = ret_stack_list[start++];
> >  			atomic_set(&t->trace_overrun, 0);
> >  		}
> >  	} while_each_thread(g, t);
> 
> okay - the (optimization-)safe way to tell the compiler about such local 
> CPU ordering information is:
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 08b536a..f724996 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1673,8 +1673,10 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
>  		}
>  
>  		if (t->ret_stack == NULL) {
> -			t->ret_stack = ret_stack_list[start++];
>  			t->curr_ret_stack = -1;
> +			/* Make sure IRQs see the -1 first: */
> +			barrier();
> +			t->ret_stack = ret_stack_list[start++];
>  			atomic_set(&t->trace_overrun, 0);
>  		}
>  	} while_each_thread(g, t);
> 
> i changed the patch to do that.
> 
> All in one, great stuff!

Agree, this is really awesome. I'm also working on a way to trigger 
specific functions to trace instead of tracing all functions.

-- Steve

