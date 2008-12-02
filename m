Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYLBLKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYLBLKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYLBLKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:10:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:4964 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYLBLKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:10:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TuFTZa9SeKznKW7ExmEDmaeE9wdyacC4a8E+tcLLS8Xe+3ydGpOjZ8l9ROgpoGjfX3
         VSYS2lHTntwzSHVVdqQ3X03YOuostC/Rq1SucgLZwFWAMTTQ6J+JSqfNthEwPq6+v8wj
         Ix0VwYaYDwc43sMAlhKhwCJ91OriALvhBRQfY=
Message-ID: <c62985530812020310h42c3e58v28c080a7eaaab1ad@mail.gmail.com>
Date: Tue, 2 Dec 2008 12:10:28 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-branch-tracer: support for x86-64
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
In-Reply-To: <20081202090205.GA11632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49347147.8070405@gmail.com> <20081202090205.GA11632@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/2 Ingo Molnar <mingo@elte.hu>:
> it's this bit:
>
>> +#ifdef CONFIG_X86_64
>> +             "1: movq (%[parent_old]), %[old]\n"
>> +             "2: movq %[return_hooker], (%[parent_replaced])\n"
>> +#else
>>               "1: movl (%[parent_old]), %[old]\n"
>>               "2: movl %[return_hooker], (%[parent_replaced])\n"
>> +#endif
>>               "   movl $0, %[faulted]\n"
>>
>>               ".section .fixup, \"ax\"\n"
>> @@ -476,8 +481,13 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>>               ".previous\n"
>>
>>               ".section __ex_table, \"a\"\n"
>> +#ifdef CONFIG_X86_64
>> +             "   .quad 1b, 3b\n"
>> +             "   .quad 2b, 3b\n"
>> +#else
>>               "   .long 1b, 3b\n"
>>               "   .long 2b, 3b\n"
>> +#endif
>
> i think we might want to introduce a few assembly helpers/defines to
> standardize such constructs - they are quite frequent. Something like:
>
>                "   .ip_ptr 1b, 3b\n"
>                "   .ip_ptr 2b, 3b\n"


Yeah. Note that in this particular case I could use EX_TABLE() macro
too (if it is defined for x86, I can't verify yet).

> (Cc:-ed Alexander and Cyrill who have done work in this area recently)
>
> we might also introduce instruction helpers:
>
>                "1: mov_ptr (%[parent_old]), %[old]\n"
>                "2: mov_ptr %[return_hooker], (%[parent_replaced])\n"
>
> and avoid the #ifdefs altogether.


Good idea.

>
>> Note that arch/x86/process_64.c is not traced, as in X86-32. I first
>> thought __switch_to() was responsible of crashes during tracing because
>> I believed current task were changed inside but that's actually not the
>> case (actually yes, but not the "current" pointer).
>>
>> So I will have to investigate to find the functions that harm here, to
>> enable tracing of the other functions inside (but there is no issue at
>> this time, while process_64.c stays out of -pg flags).
>
> ok. You should take a look at arch/x86/include/asm/system.h's switch_to()
> macros - it has special stack switching smarts for context-switching.
>
> the other special stack layout case is the starting of kernel threads -
> ret_from_fork and its details in process*.c.


Ok, I will have a look inside.

>> A little possible race condition is fixed inside this patch too. When
>> the tracer allocate a return stack dynamically, the current depth is
>> not initialized before but after. An interrupt could occur at this time
>> and, after seeing that the return stack is allocated, the tracer could
>> try to trace it with a random uninitialized depth. It's a prevention,
>> even if I hadn't problems with it.
>
>> index 08b536a..1e9379d 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -1673,8 +1673,8 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
>>               }
>>
>>               if (t->ret_stack == NULL) {
>> -                     t->ret_stack = ret_stack_list[start++];
>>                       t->curr_ret_stack = -1;
>> +                     t->ret_stack = ret_stack_list[start++];
>>                       atomic_set(&t->trace_overrun, 0);
>>               }
>>       } while_each_thread(g, t);
>
> okay - the (optimization-)safe way to tell the compiler about such local
> CPU ordering information is:
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 08b536a..f724996 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1673,8 +1673,10 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
>                }
>
>                if (t->ret_stack == NULL) {
> -                       t->ret_stack = ret_stack_list[start++];
>                        t->curr_ret_stack = -1;
> +                       /* Make sure IRQs see the -1 first: */
> +                       barrier();
> +                       t->ret_stack = ret_stack_list[start++];
>                        atomic_set(&t->trace_overrun, 0);
>                }
>        } while_each_thread(g, t);
>
> i changed the patch to do that.


Oops, I forgot it one more time.

That reminds me: I don't know why I always confuse the name of this
tracer: function-branch-tracer instead of function-graph-tracer.
Weird :-)


> All in one, great stuff!


Thanks :-)
