Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZDQEQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZDQEQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZDQEQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:16:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZDQEQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:16:42 -0400
Date: Fri, 17 Apr 2009 00:16:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
In-Reply-To: <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>  <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>  <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop>
 <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's the dump that I get that triggers the lockdep warning:

WARNING: at kernel/lockdep.c:2893 check_flags+0x1a7/0x1d0()
Hardware name: Precision WorkStation 470    
Modules linked in: radeon drm autofs4 hidp rfcomm l2cap bluetooth sunrpc 

[snip]

Pid: 3768, comm: sshd Not tainted 2.6.30-rc1 #1036
Call Trace:
 [<ffffffff8025c321>] warn_slowpath+0xe1/0x110
 [<ffffffff80287f7c>] ? __lock_acquire+0x3ac/0xb20
 [<ffffffff80286dca>] ? validate_chain+0x4ca/0x12d0
 [<ffffffff80286dca>] ? validate_chain+0x4ca/0x12d0
 [<ffffffff80286dca>] ? validate_chain+0x4ca/0x12d0
 [<ffffffff80286dca>] ? validate_chain+0x4ca/0x12d0
 [<ffffffff80287f7c>] ? __lock_acquire+0x3ac/0xb20
 [<ffffffff8051a5a9>] ? __alloc_skb+0x49/0x160
 [<ffffffff80282407>] check_flags+0x1a7/0x1d0
 [<ffffffff80284d63>] lockdep_trace_alloc+0x33/0xe0
 [<ffffffff802f3682>] kmem_cache_alloc+0x32/0x160
 [<ffffffff8051a5a9>] __alloc_skb+0x49/0x160
 [<ffffffff8059192d>] tcp_send_ack+0x2d/0xe0
 [<ffffffff8058e941>] __tcp_ack_snd_check+0x61/0xb0
 [<ffffffff80590408>] tcp_rcv_established+0x398/0x600
 [<ffffffff80596a58>] tcp_v4_do_rcv+0x228/0x380
 [<ffffffff80228ed6>] ? ftrace_call+0x5/0x2b
 [<ffffffff8058454e>] ? tcp_prequeue_process+0x2e/0xa0
 [<ffffffff8058458d>] tcp_prequeue_process+0x6d/0xa0
 [<ffffffff8058734a>] tcp_recvmsg+0x49a/0x880
 [<ffffffff80514267>] sock_common_recvmsg+0x37/0x50
 [<ffffffff805116b9>] sock_aio_read+0x109/0x110
 [<ffffffff802f75f1>] do_sync_read+0xf1/0x130
 [<ffffffff8022ec33>] ? sched_clock+0x13/0x20
 [<ffffffff8022ec5d>] ? native_sched_clock+0x1d/0x50
 [<ffffffff802737d0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80228ed6>] ? ftrace_call+0x5/0x2b
 [<ffffffff80381469>] ? cap_file_permission+0x9/0x10
 [<ffffffff80380116>] ? security_file_permission+0x16/0x20
 [<ffffffff802f7fc9>] vfs_read+0x159/0x170
 [<ffffffff802f8285>] sys_read+0x55/0x90
 [<ffffffff802291af>] system_call_fastpath+0x16/0x1b
---[ end trace 03d889e04bc7a9a7 ]---
possible reason: unannotated irqs-on.
irq event stamp: 12569
hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0


Note, for some reason we hit int3 ??

Tracepoints do not use int3 does it?

I have kprobes defined but not any kprobe self tests on.

Anyway, let me describe what the above is and what I found in my 
investigation.

The lockdep took a check_flags error when it noticed that interrupts were 
enabled, but the current->hardirqs_enabled was 0. Lockdep thought 
interrupts were disabled but they were in fact enabled.


The last 4 lines of the warning have the numbers in the parenthesis 
annotate the order of events: (Here they are in order)

softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0
hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40

The last change that lockdep saw was interrupts being disabled by int3. I 
still don't understand why int3 was enabled. I have startup tests for 
ftrace and the event tracer, but this blob happened when I first ssh'd 
into the box.

In arch/x86/kernel/entry_64.S we have:

paranoidzeroentry_ist int3 do_int3 DEBUG_STACK

.macro paranoidzeroentry sym do_sym
ENTRY(\sym)
        INTR_FRAME
        PARAVIRT_ADJUST_EXCEPTION_FRAME
        pushq $-1               /* ORIG_RAX: no syscall to restart */
        CFI_ADJUST_CFA_OFFSET 8
        subq $15*8, %rsp
        call save_paranoid
        TRACE_IRQS_OFF
        movq %rsp,%rdi          /* pt_regs pointer */
        xorl %esi,%esi          /* no error code */
        call \do_sym
        jmp paranoid_exit       /* %ebx: no swapgs flag */
        CFI_ENDPROC
END(\sym)
.endm


ENTRY(paranoid_exit)
        INTR_FRAME
        DISABLE_INTERRUPTS(CLBR_NONE)
        TRACE_IRQS_OFF
        testl %ebx,%ebx                         /* swapgs needed? */
        jnz paranoid_restore
        testl $3,CS(%rsp)
        jnz   paranoid_userspace
paranoid_swapgs:
        TRACE_IRQS_IRETQ 0
        SWAPGS_UNSAFE_STACK
paranoid_restore:
        RESTORE_ALL 8
        jmp irq_return


irq_return:
        INTERRUPT_RETURN


INTERRUPT_RETURN is simply defined as iretq


I see that we call TRACE_IRQS_OFF when entering paranoid_exit, but if we 
do not need to swapgs (we don't because int3 looks like it happened in 
kernel space) we just call irq_return and jump back. We miss the fact that 
the irq_return enables interrupts for us.

I'd try to come up with a fix, but this gets a bit complex, and I figured 
I let the lockdep irq-tracing guru's play with this magic. I'm just 
reporting the problem ;-)

-- Steve

