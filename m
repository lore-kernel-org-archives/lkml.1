Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYHMUGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYHMUGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYHMUGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:06:25 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:64554 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbYHMUGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:06:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFACTWokhMRKxB/2dsb2JhbACBYLR/gVU
Date: Wed, 13 Aug 2008 16:01:19 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
Message-ID: <20080813200119.GA18966@Krystal>
References: <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080813193715.GQ1366@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:42:59 up 70 days, 23 min,  6 users,  load average: 5.10, 2.99,
	2.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > Sorry to ask, I feel I must be missing something, but I'm trying to
> > figure out where you propose to add the "call mcount" ? In the caller or
> > in the callee ?
> 
> callee like gcc. caller would be likely more bloated because
> there are more calls than functions. Also if it was at the 
> callee more code would be needed because the function currently
> executed couldn't be gotten from stack directly.
> 
> > Or is it a different scheme I don't see ? I am trying to figure out how
> > you happen to do all that without dynamic code modification and manage
> > not to hurt performance.
> 
> The dynamic code modification is only needed because there is no
> global table of the mcount call sites. So instead it discovers
> them at runtime, but that requires runtime save patching
> 
> With a custom call scheme one could just build up a table of 
> call sites at link time using an ELF section and then when
> tracing is enabled/disabled always patch them all in one go
> in a stop_machine(). Then you wouldn't need parallel execution safe
> patching anymore and it doesn't matter what the nops look like.
> 

I agree that the custom call scheme could let you know the mcount call
site addresses at link time, so you could replace the call instructions
with nops (at link time, so you actually don't know much about the
exact hardware the kernel will be running on, which makes it harder to
choose the best nop). To me, it seems that doing this at link time,
as you propose, is the best approach, as it won't impact the system
bootup time as much as the current ftrace scheme.

However, I disagree with you on one point : if you use nops which are
made of multiple instructions smaller than 5 bytes, enabling the tracer
(patching all the sites in a stop_machine()) still present the risk of
having a preempted thread with a return IP pointing directly in the
middle of what will become a 5-bytes call instruction. When the thread
will be scheduled again after the stop_machine, an illegal instruction
fault (or any random effect) will occur.

Therefore, building a table of mcount call sites in a ELF section,
declaring _single_ 5-bytes nop instruction in the instruction stream
that would fit for all target architectures in lieue of mcount call, so
it can be later patched-in with the 5-bytes call at runtime seems like a
good way to go.

Mathieu

P.S. : It would be good to have a look at the alternative.c lock prefix
vs preemption race I identified a few weeks ago. Actually, this
currently existing cpu hotplug bug is related to the preemption issue I
just explained here. ref. http://lkml.org/lkml/2008/7/30/265,
especially:

"As a general rule, never try to combine smaller instructions into a
bigger one, except in the case of adding a lock-prefix to an instruction :
this case insures that the non-lock prefixed instruction is still
valid after the change has been done. We could however run into a nasty
non-synchronized atomic instruction use in SMP mode if a thread happens
to be scheduled out right after the lock prefix. Hopefully the
alternative code uses the refrigerator... (hrm, it doesn't).

Actually, alternative.c lock-prefix modification is O.K. for spinlocks
because they execute with preemption off, but not for other atomic
operations which may execute with preemption on."


> The other advantage is that it would allow getting rid of
> the frame pointer.
> 
> -Andi
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
