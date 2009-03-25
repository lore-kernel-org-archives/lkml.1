Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbZCYJ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbZCYJ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCYJ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:58:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54715 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZCYJ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:58:27 -0400
Date: Wed, 25 Mar 2009 09:57:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325095751.GA31464@n2100.arm.linux.org.uk>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <20090325085418.GA2341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325085418.GA2341@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 09:54:18AM +0100, Ingo Molnar wrote:
> Unwinding is not realistic or desired for the function tracer - it 
> runs in every kernel function so performance is paramount.

Which would also include the unwinder itself as well.

> So, if i understood you correctly, an OABI_COMPAT and FRAME_POINTERS 
> dependency has to be added to the ARM HAVE_FUNCTION_GRAPH_TRACER 
> Kconfig rule.

If we have frame pointers enabled with EABI, then it looks like it will
work as well.  So the dependency should be on FRAME_POINTERS for _every_
feature using the mcount code.

Hmm, and it looks like the ftrace code is rather crap:

ENTRY(mcount)
        stmdb sp!, {r0-r3, lr}
        ldr r0, =ftrace_trace_function
        ldr r2, [r0]
        adr r0, ftrace_stub
        cmp r0, r2
        bne trace
        ldr lr, [fp, #-4]                       @ restore lr
        ldmia sp!, {r0-r3, pc}

trace:
        ldr r1, [fp, #-4]                       @ lr of instrumented routine
        mov r0, lr
        sub r0, r0, #MCOUNT_INSN_SIZE
        mov lr, pc
        mov pc, r2
 XXX calling a C function results in r0-r3,ip,lr being clobbered XXX

        mov lr, r1                              @ restore lr
 XXX not necessarily, r1 might be some other random value

        ldmia sp!, {r0-r3, pc}

In fact, to me the above code looks totally crap, because it's checking
whether the caller is 'ftrace_stub'.  It can never be 'ftrace_stub'
because that is an assembly function:

        .globl ftrace_stub
ftrace_stub:
        mov pc, lr

and therefore gcc has no hand in adding a mcount call to it.

Moreover, the _dynamic_ ftrace code does this:

ENTRY(mcount)
        stmdb sp!, {r0-r3, lr}
        mov r0, lr
        sub r0, r0, #MCOUNT_INSN_SIZE

        .globl mcount_call
mcount_call:
        bl ftrace_stub
        ldr lr, [fp, #-4]                       @ restore lr
        ldmia sp!, {r0-r3, pc}

ENTRY(ftrace_caller)
        stmdb sp!, {r0-r3, lr}
        ldr r1, [fp, #-4]
        mov r0, lr
        sub r0, r0, #MCOUNT_INSN_SIZE

        .globl ftrace_call
ftrace_call:
        bl ftrace_stub
        ldr lr, [fp, #-4]                       @ restore lr
        ldmia sp!, {r0-r3, pc}

In other words, it pushes some words onto the stack, sets r0, calls
an assembly function which does nothing but just returns, reloads lr,
restores the stack and returns.  This ftrace implementation looks like
an exercise in slowing down execution to me with no added value.
