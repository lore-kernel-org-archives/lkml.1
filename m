Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYHHTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYHHTJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbYHHTJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:09:11 -0400
Received: from gw.goop.org ([64.81.55.164]:48408 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYHHTJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:09:10 -0400
Message-ID: <489C99C2.1020805@goop.org>
Date: Fri, 08 Aug 2008 12:08:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
References: <20080807182013.984175558@goodmis.org> <20080807184741.GB18164@Krystal> <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Hmm, good point. Unless...
>
> Can a processor be preempted in a middle of nops?  What do nops do for a 
> processor? Can it skip them nicely in one shot?
>   

The CPU can be interrupted between any two instructions, with a couple 
of exceptions (it must, otherwise an unbounded run of nops could cause 
an unbounded interrupt latency).  If you don't want eip to be in the 
middle of your instruction site, you need to make sure it's nopped out 
with a single instruction.

Unfortunately, aside from P6_NOP5, none of the standard asm/nops.h nops 
are suitable.  Something like "0x66, 0x66, 0x66, 0x66, 0x90" would work 
everywhere, but its possible putting more than 3 prefixes on the 
instruction will kick the decoder into a slow path, which may have a 
noticable effect.

> This means I'll have to do the benchmarks again, and see what the 
> performance difference of a jmp and a nop is significant. I'm thinking 
> that if the processor can safely skip nops without any type of processing, 
> this may be the reason that nops are better than a jmp. A jmp causes the 
> processor to do a little more work.
>   

A no-op jmp could be easily converted to a nop early in the pipeline.  
But I don't know whether anyone bothers to do that.

    J
