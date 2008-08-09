Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYHIBap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYHIBap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYHIBag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:30:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYHIBag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:30:36 -0400
Date: Fri, 8 Aug 2008 21:30:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <20080809011955.GE9038@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0808082126500.3707@gandalf.stny.rr.com>
References: <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
 <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <20080809011955.GE9038@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 9 Aug 2008, Andi Kleen wrote:

> > I wish we had a true 5 byte nop. The alternative is a jmp 0, which is 
> > measurable.  This is replacing mcount from a kernel compile with the -pg 
> 
> Scary usage.  How much is the difference? 
> 
> BTW a good way to get most of that back would be to not use frame 
> pointers if you have them enabled ;-) Unfortunately recently
> the "select FRAME_POINTER"s keep creeping all over so far too many kernels
> suffer from this slow mode now :-/

Funny, CONFIG_FTRACE happens to select that. Now the question is, would 
mcount work without it?

i386:
ENTRY(mcount)
        pushl %eax
        pushl %ecx
        pushl %edx
        movl 0xc(%esp), %eax
        movl 0x4(%ebp), %edx  <-- we record the parent ip here
        subl $MCOUNT_INSN_SIZE, %eax

        call *ftrace_trace_function

        popl %edx
        popl %ecx
        popl %eax
	ret


x86_64:
ENTRY(mcount)
        subq $0x38, %rsp
        movq %rax, (%rsp)
        movq %rcx, 8(%rsp)
        movq %rdx, 16(%rsp)
        movq %rsi, 24(%rsp)
        movq %rdi, 32(%rsp)
        movq %r8, 40(%rsp)
        movq %r9, 48(%rsp)

        movq 0x38(%rsp), %rdi
        movq 8(%rbp), %rsi <-- we record the parent pointer here
        subq $MCOUNT_INSN_SIZE, %rdi

        call   *ftrace_trace_function

        movq 48(%rsp), %r9
        movq 40(%rsp), %r8
        movq 32(%rsp), %rdi
        movq 24(%rsp), %rsi
        movq 16(%rsp), %rdx
        movq 8(%rsp), %rcx
        movq (%rsp), %rax
        addq $0x38, %rsp
	retq

-- Steve

