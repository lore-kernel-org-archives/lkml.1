Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYHHSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYHHSlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYHHSlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:41:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYHHSlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:41:10 -0400
Date: Fri, 8 Aug 2008 14:41:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20080808182104.GA11376@Krystal>
Message-ID: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal>
 <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 Aug 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > 
> > > 
> > > That's bad :
> > > 
> > > #define GENERIC_NOP5 GENERIC_NOP1 GENERIC_NOP4
> > > 
> > > #define K8_NOP5 K8_NOP3 K8_NOP2
> > > 
> > > #define K7_NOP5 K7_NOP4 ASM_NOP1
> > > 
> > > So, when you try, later, to replace these instructions with a single
> > > 5-bytes instruction, a preempted thread could iret in the middle of your
> > > 5-bytes insn and cause an illegal instruction ?
> > 
> > That's why I use kstop_machine.
> > 
> 
> kstop_machine does not guarantee that you won't have _any_ thread
> preempted with IP pointing exactly in the middle of your instructions
> _before_ the modification scheduled back in _after_ the modification and
> thus causing an illegal instruction.
> 
> Still buggy. :/

Hmm, good point. Unless...

Can a processor be preempted in a middle of nops?  What do nops do for a 
processor? Can it skip them nicely in one shot?

This means I'll have to do the benchmarks again, and see what the 
performance difference of a jmp and a nop is significant. I'm thinking 
that if the processor can safely skip nops without any type of processing, 
this may be the reason that nops are better than a jmp. A jmp causes the 
processor to do a little more work.

I might even run a test to see if I can force a processor that uses the 
three-two nops to preempt between them.

I can add a test in x86 ftrace.c to check to see which nop was used, and 
use the jmp if the arch does not have a 5 byte nop.

I'm assuming that jmp is more expensive than the nops because otherwise
a jmp 0 would have been used as a 5 byte nop.

-- Steve
