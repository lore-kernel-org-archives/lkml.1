Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZEOVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZEOVH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZEOVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:07:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41575 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZEOVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:07:09 -0400
Date: Fri, 15 May 2009 22:06:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 2/2] ftrace: add function-graph tracer support for ARM
	v2
Message-ID: <20090515210636.GQ650@n2100.arm.linux.org.uk>
References: <49FB79CF.3020101@am.sony.com> <20090502001100.GH6404@nowhere> <c62985530905090914odb4dcc6pc7ea789f02515167@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530905090914odb4dcc6pc7ea789f02515167@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 06:14:32PM +0200, Frédéric Weisbecker wrote:
> Ingo, Russell.
> What do you think about this?

If it's suitable for the next merge window, lets get it queued up for
it.    What are the dependencies for the patch?  Does it rely on
anything queued in anyone elses tree (eg, the addition of
ftrace_return_to_handler) ?

However, I'm not sure that this code is entirely right (and I'm not
sure what's going on with this patch - my editor is randomly changing
the placement of characters in it.  Are you submitting patches using
UTF-8 characters in the code?)

> >> @@ -139,8 +144,16 @@ ENTRY(mcount)
> >>       adr r0, ftrace_stub
> >>       cmp r0, r2
> >>       bne trace

If this is r0 != ftrace_stub, go to trace.  So the next block will
only be executed if r0 /was/ ftrace_stub, in which case it can't be
ftrace_graph_return.

> >> +
> >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> +     ldr r1, =ftrace_graph_return
> >> +     ldr r2, [r1]
> >> +     cmp r0, r2              @ if *ftrace_graph_return != ftrace_stub
> >> +     bne ftrace_graph_caller
> >> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >> +
> >>       ldr lr, [fp, #-4]                       @ restore lr
> >> -     ldmia sp!, {r0-r3, pc}
> >> +     ldmia sp!, {r0-r3, pc}                  @ return doing nothing
> >>
> >>  trace:

So surely you want your code above placed here?

> >>       ldr r1, [fp, #-4]                       @ lr of instrumented routine
> >> @@ -151,6 +164,25 @@ trace:
> >>       mov lr, r1                              @ restore lr
> >>       ldmia sp!, {r0-r3, pc}
> >>
> >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> +ENTRY(ftrace_graph_caller)
> >> +     sub r0, fp, #4                  @ &lr of instrumented routine (&parent)
> >> +     mov r1, lr                      @ instrumented routine (func)
> >> +     sub r1, r1, #MCOUNT_INSN_SIZE
> >> +     bl prepare_ftrace_return
> >> +     ldr lr, [fp, #-4]               @ restore lr
> >> +     ldmia sp!, {r0-r3, pc}
> >> +
> >> +     .globl return_to_handler
> >> +return_to_handler:
> >> +     stmdb sp!, {r0-r3}
> >> +     bl ftrace_return_to_handler
> >> +     mov lr, r0                      @ r0 has real ret addr
> >> +     ldmia sp!, {r0-r3}
> >> +     mov pc, lr
> >> +
> >> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >
> >
> >
> > Looks good.
> >
> >
> >
> >>  #endif /* CONFIG_DYNAMIC_FTRACE */
> >>
> >>       .globl ftrace_stub
> >> --- /dev/null
> >> +++ b/arch/arm/kernel/ftrace_return.c
> >
> >
> >
> > Because it is more commonly known as function graph,
> > I would suggest ftrace_graph.c so that people can
> > find it more easily.
> >
> >
> >
> >> @@ -0,0 +1,44 @@
> >> +/*
> >> + * function return tracing support.
> >> + *
> >> + * Copyright (C) 2009 Tim Bird <tim.bird@am.sony.com>
> >> + *
> >> + * For licencing details, see COPYING.
> >> + *
> >> + * Defines routine needed for ARM return trampoline for tracing
> >> + * function exits.
> >> + */
> >> +
> >> +#include <linux/ftrace.h>
> >> +
> >> +/*
> >> + * Hook the return address and push it in the stack of return addrs
> >> + * in current thread info.
> >> + */
> >> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> >> +{
> >> +     unsigned long old;
> >> +
> >> +     struct ftrace_graph_ent trace;
> >> +     unsigned long return_hooker = (unsigned long)
> >> +                             &return_to_handler;
> >> +
> >> +     if (unlikely(atomic_read(&current->tracing_graph_pause)))
> >> +             return;
> >> +
> >> +     old = *parent;
> >> +     *parent = return_hooker;
> >> +
> >> +     if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
> >> +             *parent = old;
> >> +             return;
> >> +     }
> >> +
> >> +     trace.func = self_addr;
> >> +
> >> +     /* Only trace if the calling function expects to */
> >> +     if (!ftrace_graph_entry(&trace)) {
> >> +             current->curr_ret_stack--;
> >> +             *parent = old;
> >> +     }
> >> +}
> >> --- a/arch/arm/kernel/vmlinux.lds.S
> >> +++ b/arch/arm/kernel/vmlinux.lds.S
> >> @@ -99,6 +99,7 @@ SECTIONS
> >>                       SCHED_TEXT
> >>                       LOCK_TEXT
> >>                       KPROBES_TEXT
> >> +                     IRQENTRY_TEXT
> >>  #ifdef CONFIG_MMU
> >>                       *(.fixup)
> >>  #endif
> >
> >
> > Well, it looks good to me.
> > May be you can also add the fault protection against the return address,
> > as a paranoid check. But that can be done later.
> >
> > Also I wonder how far we are from the dynamic ftrace support, which seems
> > half implemented or broken or not tested for a while?
> >
> > Thanks!
> >
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> >
> 
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
