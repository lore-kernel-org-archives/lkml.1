Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbZDQTb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbZDQTb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZDQTbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:31:47 -0400
Received: from gw.goop.org ([64.81.55.164]:60282 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbZDQTbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:31:46 -0400
Message-ID: <49E8D91F.1060005@goop.org>
Date: Fri, 17 Apr 2009 12:31:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu>
In-Reply-To: <20090417162326.GG8253@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I meant to suggest to Jeremy to measure the effect of this 
> out-of-lining, in terms of instruction count in the hotpath.
>   

OK, here's a comparison for trace_sched_switch, comparing inline and out 
of line tracing functions, with CONFIG_PREEMPT enabled:

The inline __DO_TRACE version of trace_sched_switch inserts 20 
instructions, assembling to 114 bytes of code in the hot path:

        cmpl    $0, __tracepoint_sched_switch+8(%rip)   #, __tracepoint_sched_switch.state
        je      .L1582  #,
        movq %gs:per_cpu__kernel_stack,%rax     # per_cpu__kernel_stack, ret__
        incl    -8124(%rax)     # <variable>.preempt_count
        movq    __tracepoint_sched_switch+16(%rip), %r12        #, it_func
        testq   %r12, %r12      # it_func
.L1603:
        je      .L1583  #,
        movq    -136(%rbp), %rdx        # next,
        movq    -144(%rbp), %rsi        # prev,
        movq    %rbx, %rdi      # rq,
        call    *(%r12) #* it_func
        addq    $8, %r12        #, it_func
        cmpq    $0, (%r12)      #,* it_func
        jmp     .L1603  #
.L1583:
        movq %gs:per_cpu__kernel_stack,%rax     # per_cpu__kernel_stack, ret__
        decl    -8124(%rax)     # <variable>.preempt_count
        movq %gs:per_cpu__kernel_stack,%rax     # per_cpu__kernel_stack, ret__
        testb   $8, -8136(%rax) #,
        je      .L1582  #,
        call    preempt_schedule        #
.L1582:


Taking __do_trace_sched_switch out of lines inserts this into the hot 
path (6 instructions, 31 bytes):

        cmpl    $0, __tracepoint_sched_switch+8(%rip)   #, __tracepoint_sched_switch.state
        je      .L1748  #,
        movq    -136(%rbp), %rdx        # next,
        movq    -144(%rbp), %rsi        # prev,
        movq    %rbx, %rdi      # rq,
        call    __do_trace_sched_switch #
.L1748:


__do_trace_sched_switch is a fair bit larger, mostly due to function 
preamble frame and reg save/restore, and some unfortunate and 
unnecessary register thrashing (why not keep rdi,rsi,rdx where they 
are?).  But it isn't that much larger than the inline version: 34 
instructions, 118 bytes.  This code will also be shared among all 
instances of the tracepoint (not in this case, because sched_switch is 
unique, but other tracepoints have multiple users).

__do_trace_sched_switch:
        pushq   %rbp    #
        movq    %rsp, %rbp      #,
        pushq   %r14    #
        movq    %rdi, %r14      # rq, rq
        pushq   %r13    #
        movq    %rsi, %r13      # prev, prev
        pushq   %r12    #
        movq    %rdx, %r12      # next, next
        pushq   %rbx    #
        movq %gs:per_cpu__kernel_stack,%rax     # per_cpu__kernel_stack, ret__
        incl    -8124(%rax)     # <variable>.preempt_count
        movq    __tracepoint_sched_switch+16(%rip), %rax        #, _________p1
        testq   %rax, %rax      # _________p1
        je      .L2403  #,
        movq    %rax, %rbx      # _________p1, it_func
.L2404:
        movq    %r12, %rdx      # next,
        movq    %r13, %rsi      # prev,
        movq    %r14, %rdi      # rq,
        call    *(%rbx) #* it_func
        addq    $8, %rbx        #, it_func
        cmpq    $0, (%rbx)      #,* it_func
        jne     .L2404  #,
.L2403:
        movq %gs:per_cpu__kernel_stack,%rax     # per_cpu__kernel_stack, ret__
        decl    -8124(%rax)     # <variable>.preempt_count
        movq %gs:per_cpu__kernel_stack,%rax     # per_cpu__kernel_stack, ret__
        testb   $8, -8136(%rax) #,
        je      .L2406  #,
        call    preempt_schedule        #
.L2406:
        popq    %rbx    #
        popq    %r12    #
        popq    %r13    #
        popq    %r14    #
        leave
        ret


So, conclusion: putting the tracepoint code out of line significantly 
reduces the hot-path code size at each tracepoint (114 bytes down to 31 
in this case, 27% the size).  This should reduce the overhead of having 
tracing configured but not enabled.  The saving won't be as large for 
tracepoints with fewer arguments or without CONFIG_PREEMPT, but I chose 
this example because it is realistic and undeniably a hot path.  And 
when doing pvops tracing, 80 new events with hundreds of callsites 
around the kernel, this is really going to add up.

The tradeoff is that the actual tracing function is a little larger, but 
not dramatically so.  I would expect some performance hit when the 
tracepoint is actually enabled.  This may be mitigated increased icache 
hits when a tracepoint has multiple sites.

(BTW, I realized that we don't need to pass &__tracepoint_FOO to 
__do_trace_FOO(), since its always going to be the same; this simplifies 
the calling convention at the callsite, and it also makes void 
tracepoints work again.)

    J
