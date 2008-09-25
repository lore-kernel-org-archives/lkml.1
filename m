Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYIYRCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYIYRCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYIYRCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:02:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYIYRC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:02:29 -0400
Date: Thu, 25 Sep 2008 13:02:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809250941490.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251301240.27920@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
 <20080925163722.GA29392@Krystal> <alpine.LFD.1.10.0809250941490.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Linus Torvalds wrote:
> 
> On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > I remembered other concerns about 27 vs 32 bits TSC decision, which are
> > rather important. First, if we have a 27 bits TSC, with overflow every
> > 33ms at 4GHz, we assume the kernel will _never_ have an interrupt
> > latency longer than this for correct heartbeat behavior.
> 
> We do no such thing.
> 
> Guys, the heartbeat is a _separate_ thing from overflow handling.
> 
> You don't handle overflow by having a heartbeat that beats fifty times a 
> second just to insert events, just so that the TSC delta would always fit 
> in 27 bits. That would work, but be stupid. It would mean that you fill up 
> your event buffer with uninteresting crud just because nothing happens.
> 
> Yes, many people want to have a heartbeat (a "Mark" event) every once in a 
> while, but what I suggest is independent of heartbeats, even if it _could_ 
> be implemented that way. What I suggest is simply that when you insert an 
> event, you always read the full 64 bits of TSC (on x86 - others will do 
> other things), and then you insert the delta against the last one.
> 
> After all, you cannot read just 27 bits of the TSC anyway. You _have_ to 
> read the whole 64 bits, and then you subtract the pervious trace event TSC 
> (that you have in the per-CPU trace buffer header) from that. You now have 
> a delta value.
> 
> And if the delta doesn't fit in 27 bits, you generate a 59-bit TSC event!

Note: RFC v2 implements this.

-- Steve

> 
> None of this has _anything_ to do with interrupt latency. There is no 
> dependency on a heartbeat, or any dependency on always inserting a trace 
> event at least 30 times a second. There's no worry about conversions, and 
> these are all trivial single assembly instructions to do (or a couple, on 
> a 32-bit architecture that needs to do a sub/sbb pair and test two 
> different registers to see if the result fits in 27 bits).
> 
> The only issue is that if you insert trace events more seldom, you'll 
> always get the extra TSC event as well, inserted automatically in front of 
> the event you explicitly inserted. The tracer doesn't need to know.
