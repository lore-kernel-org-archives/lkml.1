Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYIYRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYIYRGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYIYRGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:06:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYIYRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:06:07 -0400
Date: Thu, 25 Sep 2008 11:26:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251120420.27300@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> 
 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>  <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> 
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>  <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>  <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Linus Torvalds wrote:
> On Thu, 25 Sep 2008, Peter Zijlstra wrote:
> > 
> > Right - if you use raw tsc you're dependent on clock speed, if we'd
> > normalize that on ns instead you'd need at least: [...]
> 
> Please don't normalize to ns.
> 
> It's really quite hard, and it's rather _expensive_ on many CPU's. It 
> involves a non-constant 64-bit divide, after all. I bet it can be 
> optimized to be a multiply-by-inverse instead, but it would be a 128-bit 
> (or maybe just 96-bit?) multiply, and the code would be nasty, and likely 
> rather more expensive than the TSC reading itself.
> 
> Sure, you have to normalize at _some_ point, and normalizing early might 
> make some things simpler, but the main thing that would become easier is 
> people messing about in the raw log buffer on their own directly, which 
> would hopefully be something that we'd discourage _anyway_ (ie we should 
> try to use helper functions for people to do things like "get the next 
> event data", not only because the headers are going to be odd due to 
> trying to pack things together, but because maybe we can more easily 
> extend on them later that way when nobody accesses the headers by hand).
> 
> And I don't think normalizing later is in any way more fundamentally hard. 
> It just means that you do part of the expensive things after you have 
> gathered the trace, rather than during.

I've been just using sched_clock() which already normalizes to ns. But I 
use a wrapper (ring_buffer_time_stamp) so we can decide on how to keep 
track later.

If we do not normalize, then we must come up yet another generic way to read 
the CPU clock for all archs. And then we also need to come up with another 
generic way to normalize it later for output.

If I'm missing that this already exists, then I'll go and use it, but I do 
not think that tracing is worthy enough to implement this timing 
infrastructure just to get faster traces.

-- Steve

