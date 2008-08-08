Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbYHHTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbYHHTFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758506AbYHHTFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:05:11 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62781 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402AbYHHTFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:05:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkFAHQynEhMRKxB/2dsb2JhbACBXKtp
Date: Fri, 8 Aug 2008 15:05:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20080808190506.GD11376@Krystal>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:47:54 up 64 days, 23:28,  7 users,  load average: 0.56, 0.71,
	0.82
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Fri, 8 Aug 2008, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > 
> > > > 
> > > > That's bad :
> > > > 
> > > > #define GENERIC_NOP5 GENERIC_NOP1 GENERIC_NOP4
> > > > 
> > > > #define K8_NOP5 K8_NOP3 K8_NOP2
> > > > 
> > > > #define K7_NOP5 K7_NOP4 ASM_NOP1
> > > > 
> > > > So, when you try, later, to replace these instructions with a single
> > > > 5-bytes instruction, a preempted thread could iret in the middle of your
> > > > 5-bytes insn and cause an illegal instruction ?
> > > 
> > > That's why I use kstop_machine.
> > > 
> > 
> > kstop_machine does not guarantee that you won't have _any_ thread
> > preempted with IP pointing exactly in the middle of your instructions
> > _before_ the modification scheduled back in _after_ the modification and
> > thus causing an illegal instruction.
> > 
> > Still buggy. :/
> 
> Hmm, good point. Unless...
> 
> Can a processor be preempted in a middle of nops?  What do nops do for a 
> processor? Can it skip them nicely in one shot?
> 

Given that those are multiple instructions, I think a processor has all
the rights to preempt in the middle of them. And even if some specific
architecture, for any obscure reason, happens to merge them, I don't
think this will be portable across Intel, AMD, ...

> This means I'll have to do the benchmarks again, and see what the 
> performance difference of a jmp and a nop is significant. I'm thinking 
> that if the processor can safely skip nops without any type of processing, 
> this may be the reason that nops are better than a jmp. A jmp causes the 
> processor to do a little more work.
> 
> I might even run a test to see if I can force a processor that uses the 
> three-two nops to preempt between them.
> 

Yup, although one architecture not triggering this doesn't say much
about the various x86 flavors out there. In any case
- if you trigger the problem, we have to fix it.
- if you do not succeed to trigger the problem, we will have to test it
  on a wider architecture range and maybe end up fixit it anyway to play
  safe with the specs.

So, in every case, we end up fixing the issue.


> I can add a test in x86 ftrace.c to check to see which nop was used, and 
> use the jmp if the arch does not have a 5 byte nop.
> 

I would propose the following alternative :

Create new macros in include/asm-x86/nops.h :

/* short jump, offset 3 bytes : skips total of 5 bytes */
#define GENERIC_ATOMIC_NOP5 ".byte 0xeb,0x03,0x00,0x00,0x00\n"

#if defined(CONFIG_MK7)
#define ATOMIC_NOP5 GENERIC_ATOMIC_NOP5
#elif defined(CONFIG_X86_P6_NOP)
#define ATOMIC_NOP5 P6_NOP5
#elif defined(CONFIG_X86_64)
#define ATOMIC_NOP5 GENERIC_ATOMIC_NOP5
#else
#define ATOMIC_NOP5 GENERIC_ATOMIC_NOP5
#endif

And then optimize if necessary. You will probably find plenty of
knowledgeable people who will know better 5-bytes nop instruction more
efficient than this "generic" short jump offset 0x3.

Then you can use the (buggy) 3nops/2nops as a performance baseline and
see the performance hit on each architecture.

First get it right, then make it fast....

Mathieu

> I'm assuming that jmp is more expensive than the nops because otherwise
> a jmp 0 would have been used as a 5 byte nop.
> 
> -- Steve

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
