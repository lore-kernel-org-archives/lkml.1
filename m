Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYIWEGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYIWEGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYIWEGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:06:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYIWEGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:06:46 -0400
Date: Mon, 22 Sep 2008 21:05:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Roland Dreier <rdreier@cisco.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <20080923033635.GK24937@Krystal>
Message-ID: <alpine.LFD.1.10.0809222050370.3265@nehalem.linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org> <20080923033635.GK24937@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Sep 2008, Mathieu Desnoyers wrote:
> 
> Unless I am missing something, in the case we use an atomic operation
> which implies memory barriers (cmpxchg and atomic_add_return does), one
> can be sure that all memory operations done before the barrier are
> completed at the barrier and that all memory ops following the barrier
> will happen after.

Sure (if you have a barrier - not all architectures will imply that for an 
incrment).

But that still doesn't mean a thing.

You have two events (a) and (b), and you put trace-points on each. In your 
trace, you see (a) before (b) by comparing the numbers. But what does that 
mean? 

The actual event that you traced is not the trace-point - the trace-point 
is more like a fancy "printk". And the fact that one showed up before 
another in the trace buffer, doesn't mean that the events _around_ the 
trace happened in the same order.

You can use the barriers to make a partial ordering, and if you have a 
separate tracepoint for entry into a region and exit, you can perhaps show 
that they were totally disjoint. Or maybe they were partially overlapping, 
and you'll never know exactly how they overlapped.

Example:

	trace(..);
	do_X();

being executed on two different CPU's. In the trace, CPU#1 was before 
CPU#2. Does that mean that "do_X()" happened first on CPU#1?

No.

The only way to show that would be to put a lock around the whole trace 
_and_ operation X, ie

	spin_lock(..);
	trace(..);
	do_X();
	spin_unlock(..);

and now, if CPU#1 shows up in the trace first, then you know that do_X() 
really did happen first on CPU#1. Otherwise you basically know *nothing*, 
and the ordering of the trace events was totally and utterly meaningless.

See? Trace events themselves may be ordered, but the point of the trace 
event is never to know the ordering of the trace itself - it's to know the 
ordering of the code we're interested in tracing. The ordering of the 
trace events themselves is irrelevant and not useful.

And I'd rather see people _understand_ that, than if they think the 
ordering is somehow something they can trust.

Btw, if you _do_ have locking, then you can also know that the "do_X()" 
operations will be essentially as far apart in some theoretical notion of 
"time" (let's imagine that we do have global time, even if we don't) as 
the cost of the trace operation and do_X() itself.

So if we _do_ have locking (and thus a valid ordering that actually can 
matter), then the TSC doesn't even have to be synchronized on a cycle 
basis across CPU's - it just needs to be close enough that you can tell 
which one happened first (and with ordering, that's a valid thing to do). 

So you don't even need "perfect" synchronization, you just need something 
reasonably close, and you'll be able to see ordering from TSC counts 
without having that horrible bouncing cross-CPU thing that will impact 
performance a lot.

Quite frankly, I suspect that anybody who wants to have a global counter 
might as well almost just have a global ring-buffer. The trace events 
aren't going to be CPU-local anyway if you need to always update a shared 
cacheline - and you might as well make the shared cacheline be the ring 
buffer head with a spinlock in it.

That may not be _quite_ true, but it's probably close enough.

		Linus
