Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYHMS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYHMS3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHMS3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbYHMS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:29:12 -0400
Date: Wed, 13 Aug 2008 11:27:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
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
In-Reply-To: <20080813175213.GA8679@Krystal>
Message-ID: <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com>
 <87tzdv2g05.fsf@basil.nowhere.org> <alpine.DEB.1.10.0808082030500.1396@gandalf.stny.rr.com> <489CE90D.1040902@goop.org> <alpine.LFD.1.10.0808081750060.3462@nehalem.linux-foundation.org> <alpine.DEB.1.10.0808082113090.3707@gandalf.stny.rr.com>
 <20080813175213.GA8679@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Mathieu Desnoyers wrote:
> 
> I also did some microbenchmarks on my Intel Xeon 64 bits, AMD64 and
> Intel Pentium 4 boxes to compare a baseline

Note that the biggest problems of a jump-based nop are likely to happen 
when there are I$ misses and/or when there are other jumps involved. Ie a 
some microarchitectures tend to have issues with jumps to jumps, or when 
there are multiple control changes in the same (possibly partial) 
cacheline because the instruction stream prediction may be predecoded in 
the L1 I$, and multiple branches in the same cacheline - or in the same 
execution cycle - can pollute that kind of thing.

So microbenchmarking this way will probably make some things look 
unrealistically good. 

On the P4, the trace cache makes things even more interesting, since it's 
another level of I$ entirely, with very different behavior for the hit 
case vs the miss case.

And I$ misses for the kernel are actually fairly high. Not in 
microbenchmarks that tend to have very repetive behavior and a small I$ 
footprint, but in a lot of real-life loads the *bulk* of all action is in 
user space, and then the kernel side is often invoced with few loops (the 
kernel has very few loops indeed) and a cold I$.

So your numbers are interesting, but it would be really good to also get 
some info from Intel/AMD who may know about microarchitectural issues for 
the cases that don't show up in the hot-I$-cache environment.

			Linus
