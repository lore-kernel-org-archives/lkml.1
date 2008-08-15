Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbYHOVet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbYHOVet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 17:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHOVel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 17:34:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYHOVek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 17:34:40 -0400
Date: Fri, 15 Aug 2008 17:34:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20080813193715.GQ1366@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0808151535300.24788@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org>
 <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com> <20080813175213.GA8679@Krystal> <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal>
 <20080813193715.GQ1366@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Finally got my goodmis email back ]

On Wed, 13 Aug 2008, Andi Kleen wrote:

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

The new code does not discover the places at runtime. The old code did 
that. The "to kill a daemon" removed the runtime discovery and replaced it 
with discovery at compile time.

> 
> With a custom call scheme one could just build up a table of 
> call sites at link time using an ELF section and then when
> tracing is enabled/disabled always patch them all in one go
> in a stop_machine(). Then you wouldn't need parallel execution safe
> patching anymore and it doesn't matter what the nops look like.

The current patch set, pretty much does exactly this. Yes, I patch
at boot up all in one go, before the other CPUS are even active.
This takes all of 6 milliseconds to do. Not much extra time for bootup.

> 
> The other advantage is that it would allow getting rid of
> the frame pointer.

This is the only advantage that you have.

-- Steve

