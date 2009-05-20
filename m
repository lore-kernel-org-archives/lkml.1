Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZETCeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZETCeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZETCej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:34:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56704 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZETCei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KQGkNm0j0zIwXxnZeOvtfgKrS4txgxKYuh+14HTxM9wmqRHjc53qjCo0i/zBODqKTp
         LyWOw/hNYGRs/t/1BUMhWpC4r/eKJusoA08tyEPMS5YwPybGYSkcNKyxeTV5P/JHaF7c
         fZZxXOFIPF1xhH/MjZygMy3HtS/o+KI+0Xl0M=
Date: Wed, 20 May 2009 04:34:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 2/2] ftrace: add function-graph tracer support for ARM
	v2
Message-ID: <20090520023432.GJ6066@nowhere>
References: <49FB79CF.3020101@am.sony.com> <20090502001100.GH6404@nowhere> <c62985530905090914odb4dcc6pc7ea789f02515167@mail.gmail.com> <20090515210636.GQ650@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090515210636.GQ650@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:06:36PM +0100, Russell King - ARM Linux wrote:
> On Sat, May 09, 2009 at 06:14:32PM +0200, Frédéric Weisbecker wrote:
> > Ingo, Russell.
> > What do you think about this?
> 
> If it's suitable for the next merge window, lets get it queued up for
> it.    What are the dependencies for the patch?  Does it rely on
> anything queued in anyone elses tree (eg, the addition of
> ftrace_return_to_handler) ?



No, until now since -rc1 we hadn't any modifications on the function
graph tracer that affects arch code.
It should be fine with upstream tracing code.


 
> However, I'm not sure that this code is entirely right (and I'm not
> sure what's going on with this patch - my editor is randomly changing
> the placement of characters in it.  Are you submitting patches using
> UTF-8 characters in the code?)
> 
> > >> @@ -139,8 +144,16 @@ ENTRY(mcount)
> > >>       adr r0, ftrace_stub
> > >>       cmp r0, r2
> > >>       bne trace
> 
> If this is r0 != ftrace_stub, go to trace.  So the next block will
> only be executed if r0 /was/ ftrace_stub, in which case it can't be
> ftrace_graph_return.



Ah! This part concerns the function tracer.
Let's see how it looks like in the original code: (added more comments inside)


ENTRY(mcount)
	stmdb sp!, {r0-r3, lr}
	@ ftrace_trace_function points to the function tracer handler
	ldr r0, =ftrace_trace_function
	ldr r2, [r0]
	adr r0, ftrace_stub

@- check if the function tracer is running: ftrace_trace_function != ftrace_stub

	cmp r0, r2

@ if so, go to trace where we jump to the handler (mov pc, r2 in trace:)

	bne trace


	ldr lr, [fp, #-4]			@ restore lr
	ldmia sp!, {r0-r3, pc}

trace:
	ldr r1, [fp, #-4]			@ lr of instrumented routine
	mov r0, lr
	sub r0, r0, #MCOUNT_INSN_SIZE
	mov lr, pc
	mov pc, r2
	mov lr, r1				@ restore lr
	ldmia sp!, {r0-r3, pc}


See? trace actually only handles the function tracer, not the function graph tracer.

Now that we have the function graph tracer, the logic remains the same,
with a small difference:

- check if function tracer running (ftrace_trace_function != ftrace_stub)
- if so, then jump to trace
- otherwise, check if function graph tracer is running (ftrace_graph_return != ftrace_stub)
- if so, then jump to ftrace_graph_caller
- otherwise return

Hm?

Frederic.

> > >> +
> > >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > >> +     ldr r1, =ftrace_graph_return
> > >> +     ldr r2, [r1]
> > >> +     cmp r0, r2              @ if *ftrace_graph_return != ftrace_stub
> > >> +     bne ftrace_graph_caller
> > >> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> > >> +
> > >>       ldr lr, [fp, #-4]                       @ restore lr
> > >> -     ldmia sp!, {r0-r3, pc}
> > >> +     ldmia sp!, {r0-r3, pc}                  @ return doing nothing
> > >>
> > >>  trace:
> 
> So surely you want your code above placed here?
> 
> > >>       ldr r1, [fp, #-4]                       @ lr of instrumented routine
> > >> @@ -151,6 +164,25 @@ trace:
> > >>       mov lr, r1                              @ restore lr
> > >>       ldmia sp!, {r0-r3, pc}
> > >>
> > >> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > >> +ENTRY(ftrace_graph_caller)
> > >> +     sub r0, fp, #4                  @ &lr of instrumented routine (&parent)
> > >> +     mov r1, lr                      @ instrumented routine (func)
> > >> +     sub r1, r1, #MCOUNT_INSN_SIZE
> > >> +     bl prepare_ftrace_return
> > >> +     ldr lr, [fp, #-4]               @ restore lr
> > >> +     ldmia sp!, {r0-r3, pc}
> > >> +
> > >> +     .globl return_to_handler
> > >> +return_to_handler:
> > >> +     stmdb sp!, {r0-r3}
> > >> +     bl ftrace_return_to_handler
> > >> +     mov lr, r0                      @ r0 has real ret addr
> > >> +     ldmia sp!, {r0-r3}
> > >> +     mov pc, lr
> > >> +
> > >> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> > >
> > >
> > >
> > > Looks good.
> > >
> > >
> > >
> > >>  #endif /* CONFIG_DYNAMIC_FTRACE */
> > >>
> > >>       .globl ftrace_stub
> > >> --- /dev/null
> > >> +++ b/arch/arm/kernel/ftrace_return.c
> > >
> > >
> > >
> > > Because it is more commonly known as function graph,
> > > I would suggest ftrace_graph.c so that people can
> > > find it more easily.
> > >
> > >
> > >
> > >> @@ -0,0 +1,44 @@
> > >> +/*
> > >> + * function return tracing support.
> > >> + *
> > >> + * Copyright (C) 2009 Tim Bird <tim.bird@am.sony.com>
> > >> + *
> > >> + * For licencing details, see COPYING.
> > >> + *
> > >> + * Defines routine needed for ARM return trampoline for tracing
> > >> + * function exits.
> > >> + */
> > >> +
> > >> +#include <linux/ftrace.h>
> > >> +
> > >> +/*
> > >> + * Hook the return address and push it in the stack of return addrs
> > >> + * in current thread info.
> > >> + */
> > >> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
> > >> +{
> > >> +     unsigned long old;
> > >> +
> > >> +     struct ftrace_graph_ent trace;
> > >> +     unsigned long return_hooker = (unsigned long)
> > >> +                             &return_to_handler;
> > >> +
> > >> +     if (unlikely(atomic_read(&current->tracing_graph_pause)))
> > >> +             return;
> > >> +
> > >> +     old = *parent;
> > >> +     *parent = return_hooker;
> > >> +
> > >> +     if (ftrace_push_return_trace(old, self_addr, &trace.depth) == -EBUSY) {
> > >> +             *parent = old;
> > >> +             return;
> > >> +     }
> > >> +
> > >> +     trace.func = self_addr;
> > >> +
> > >> +     /* Only trace if the calling function expects to */
> > >> +     if (!ftrace_graph_entry(&trace)) {
> > >> +             current->curr_ret_stack--;
> > >> +             *parent = old;
> > >> +     }
> > >> +}
> > >> --- a/arch/arm/kernel/vmlinux.lds.S
> > >> +++ b/arch/arm/kernel/vmlinux.lds.S
> > >> @@ -99,6 +99,7 @@ SECTIONS
> > >>                       SCHED_TEXT
> > >>                       LOCK_TEXT
> > >>                       KPROBES_TEXT
> > >> +                     IRQENTRY_TEXT
> > >>  #ifdef CONFIG_MMU
> > >>                       *(.fixup)
> > >>  #endif
> > >
> > >
> > > Well, it looks good to me.
> > > May be you can also add the fault protection against the return address,
> > > as a paranoid check. But that can be done later.
> > >
> > > Also I wonder how far we are from the dynamic ftrace support, which seems
> > > half implemented or broken or not tested for a while?
> > >
> > > Thanks!
> > >
> > > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > >
> > 
> > -------------------------------------------------------------------
> > List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> > FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> > Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

