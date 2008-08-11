Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYHKT25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYHKT25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYHKT2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:28:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40612 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbYHKT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:28:39 -0400
Date: Mon, 11 Aug 2008 15:28:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20080811182150.GB32207@Krystal>
Message-ID: <alpine.DEB.1.10.0808111515200.456@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808071639420.9449@gandalf.stny.rr.com> <20080808172259.GB8244@Krystal> <alpine.DEB.1.10.0808081334010.4436@gandalf.stny.rr.com> <20080808174607.GG8244@Krystal> <alpine.DEB.1.10.0808081410380.6116@gandalf.stny.rr.com>
 <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com> <20080808190506.GD11376@Krystal> <alpine.DEB.1.10.0808081750590.16691@gandalf.stny.rr.com> <alpine.DEB.1.10.0808082024580.1396@gandalf.stny.rr.com>
 <20080811182150.GB32207@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2008, Mathieu Desnoyers wrote:
> 
> Hi Steven,
> 
> I'm actually a bit worried about this scheduler-centric approach. The
> problem is that any trap that could be generated in the middle of the
> 3/2 nops (think of performance counters if the APIC is set as a trap
> gate) which would stack an interruptible trap handler on top of those
> instructions would lead to having a return IP pointing in the wrong
> spot, but because the scheduler would interrupt the trap handler and not
> the trapped code, it would not detect this.
> 
> I am not sure wheter we do actually have the possibility to have these
> interruptible trap handlers considering the way the kernel sets up the
> gates, but I think the "let's figure out where the IP stopped" approach
> is a bit complex and fragile.
> 
> Trying to find a fast atomic 5-bytes nop, involving the
> microarchitecture guys, seems like a better approach to me.
> 

I agree that the fast atomic 5-byte nop is the optimal approach, but until 
we have that, we need to do this.

I don't think this approach is too complex, I wrote the code in about an 
hour, and the patch isn't that big. albeit my one bug, which was a CS101 
type bug (pointer arithmetic), there wasn't anything to me that was 
complex.

The thing is, I want this to be enabled in a production kernel. If there 
is a 1 in a million chance that this theoretical bug with the trap 
happening in a middle of the double nop, it only affects those that enable 
the tracer. No one else. The code only happens when tracing is being 
enabled.

If we need to put in a non optimal nop in, to replace the call to mcount, 
this affects everyone. Anyone that has CONFIG_FTRACE on, and never plans 
on running a trace.

If it comes down to slowing everyone down, against hitting a 1 in a 
million theoretical bug, I'll take my chances on the bug. Again, that code 
is only performed when tracing is being enabled. That is, when it converts 
all 20 thousand nops into calls to a tracer function. If the crash 
happens, it will only happen after tracing has started. Then we can easily 
point the bug at the tracer.

IOW, I do not want to slow down Linus' box.

-- Steve

