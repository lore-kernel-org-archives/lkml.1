Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZIWGQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZIWGQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZIWGQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:16:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:34170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZIWGQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:16:21 -0400
Subject: Re: perf sched record hangs machine
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Malley <mail@chrismalley.co.uk>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090922212453.GB6062@nowhere>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <20090922212453.GB6062@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Sep 2009 08:16:25 +0200
Message-Id: <1253686585.7695.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 23:24 +0200, Frederic Weisbecker wrote:
> On Tue, Sep 22, 2009 at 10:09:26PM +0100, Chris Malley wrote:

> > When I run "perf sched record sleep 10", and generate some activity,
> > after a few seconds my machine (single cpu Dell Latitude D400, 32-bit)
> > locks up.
> > This happens almost every time, not always with the same call trace
> > but always in default_send_IPI_self().  Occasionally I get a completed
> > recording but only if the machine is otherwise quiet.
> > 
> > Kernel and perf sched version is current Linus tree (as of 43c1266ce4dc06b).

> > [  389.272175] BUG: unable to handle kernel paging request at ffffb300
> > [  389.272294] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50

> > [  389.274708] Call Trace:
> > [  389.274752]  [<c010e3b4>] ? set_perf_event_pending+0x14/0x20
> > [  389.274801]  [<c01b9751>] ? perf_output_unlock+0x121/0x1a0
> > [  389.274848]  [<c01b981a>] ? perf_output_end+0x4a/0x70

> Ah, that calls perf_output_wakeup(), then perf_pending_counter(),
> ....., wake_up_all()
> 
> And it looks like this event is called with the rq lock
> held, then we have a deadlock.

Not really, rq->lock is IRQ-safe, that is we should have IRQs disabled
while holding it, so the self-IPI should get delayed until we release
rq->lock.

The code from the OOPS seems to decode to something like:

00000000 <_EIP>:
   0:   0f 44 c1                  cmove  %ecx,%eax
   3:   89 02                     mov    %eax,(%edx)
   5:   5b                        pop    %ebx
   6:   5d                        pop    %ebp
   7:   c3                        ret
   8:   8d b6 00 00 00 00         lea    0x0(%esi),%esi
   e:   55                        push   %ebp
   f:   89 00                     mov    %eax,(%eax)


Which matches the tail of:

        .size   default_send_IPI_all, .-default_send_IPI_all
        .p2align 4,,15
.globl default_send_IPI_self
        .type   default_send_IPI_self, @function
default_send_IPI_self:
.LFB1592:
        .loc 1 136 0
.LVL7:
        pushl   %ebp    #
.LCFI3:
        movl    %esp, %ebp      #,
.LCFI4:
        pushl   %ebx    #
.LCFI5:
        .loc 1 136 0
        movl    %eax, %ebx      # vector, vector
        .loc 1 137 0
        movl    apic, %eax      # apic, apic
.LVL8:
        movl    32(%eax), %ecx  # <variable>.dest_logical, D.27494
        jmp     .L27    #
        .p2align 4,,7
        .p2align 3
.L28:
.LBB287:
.LBB288:
.LBB289:
.LBB290:
.LBB291:
.LBB292:
.LBB293:
.LBB294:
        .loc 3 709 0
#APP
# 709 "/mnt/build/linux-2.6/arch/x86/include/asm/processor.h" 1
        rep; nop
# 0 "" 2
#NO_APP
.L27:
.LBE294:
.LBE293:
.LBE292:
.LBE291:
.LBB295:
.LBB296:
        .loc 4 112 0
        movl    __FIXADDR_TOP, %eax     # __FIXADDR_TOP, __FIXADDR_TOP
        leal    -15616(%eax), %edx      #, D.27700
        movl    -15616(%eax), %eax      #, temp.615
.LBE296:
.LBE295:
        .loc 2 56 0
        testb   $16, %ah        #, temp.615
        jne     .L28    #,
.LBE290:
.LBE289:
.LBB297:
.LBB298:
        .loc 2 36 0
        movl    %ecx, %eax      # D.27494, icr
.LVL9:
        .loc 2 40 0
        orl     $263168, %ecx   #, D.27494
        .loc 2 36 0
        orl     $262144, %eax   #, icr
        .loc 2 40 0
        orl     %ebx, %eax      # vector, icr
        cmpl    $2, %ebx        #, vector
        cmove   %ecx, %eax      # D.27494,, icr
.LBE298:
.LBE297:
.LBB299:
.LBB300:
        .loc 4 105 0
#APP
# 105 "/mnt/build/linux-2.6/arch/x86/include/asm/apic.h" 1
        661:
        movl %eax, (%edx)       # v,* D.27700
662:
.section .altinstructions,"a"
 .balign 4
 .long 661b
 .long 663f
         .byte (3*32+19)
         .byte 662b-661b
         .byte 664f-663f
.previous
.section .altinstr_replacement, "ax"
663:
        xchgl %eax, (%edx)      # v,* D.27700
664:
.previous
# 0 "" 2
.LVL10:
#NO_APP
.LBE300:
.LBE299:
.LBE288:
.LBE287:
        .loc 1 138 0
        popl    %ebx    #
.LVL11:
        popl    %ebp    #
        ret
.LFE1592:
        .size   default_send_IPI_self, .-default_send_IPI_self


Which seems to suggest that cmove is in __prepare_ICR, but I'm not sure
how that can cause a page-fault, as that function is rather
pointer-less.

Did it maybe delay evaluating apic->dest_logical that late, it appear to
be the first usage of that argument?

Ingo, any ideas?

