Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYHHTF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYHHTF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbYHHTFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:05:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759757AbYHHTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:05:41 -0400
Date: Fri, 8 Aug 2008 12:04:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0808081149530.3462@nehalem.linux-foundation.org>
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal>
 <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Steven Rostedt wrote:
> 
> Can a processor be preempted in a middle of nops?

Sure. If you have two nops in a row (and the kernel definition of the NOP 
array does _not_ guarantee that it's a single-instruction one), you may 
get a profile hit (ie any interrupt) on the second one. It's less 
_likely_, but it certainly is not architecturally in any way guaranteed 
that the kernel "nop[]" tables would be atomic.

> What do nops do for a  processor?

Depends on the microarchitecture. But many will squash it in the decode 
stage, and generate no uops for them at all, so it's purely a decode 
throughput issue and has absolutely _zero_ impact for any later CPU 
stages.

> Can it skip them nicely in one shot?

See above. It needs to decode them, and the decoder itself may well have 
some limitations - for example, the longer nops may not even decode in all 
decoders, which is why some uarchs might prefer two short nops to one long 
one, but _generally_ a nop will not make it any further than the decoder. 
But separate nops do count as separate instructions, ie they will hit all 
the normal decode limits (mostly three or four instructions decoded per 
cycle).

> I'm assuming that jmp is more expensive than the nops because otherwise
> a jmp 0 would have been used as a 5 byte nop.

Yes. A CPU core _could_ certainly do special decoding for 'jmp 0' too, but 
I don't know any that do. The 'jmp' is much more likely to be special in 
the front-end and the decoder, and can easily cause things like the 
prefetcher to hickup (ie it tries to start prefetching at the "new" target 
address).

So I would absolutely _expect_ a 'jmp' to be noticeably more expensive 
than one of the special nop's that can be squashed by the decoder. 

A nop that is squashed by the decoder will literally take absolutely no 
other resources. It doesn't even need to be tracked from an instruction 
completion standpoint (which _may_ end up meaning that a profiler would 
actually never see a hit on the second nop, but it's quite likely to 
depend on which decoder it hits etc).

			Linus
