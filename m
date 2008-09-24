Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYIXUxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYIXUxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIXUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:53:38 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:53759 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYIXUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:53:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAPdC2khMQWq+/2dsb2JhbACBXrw1gWU
Date: Wed, 24 Sep 2008 16:53:34 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080924205334.GB12248@Krystal>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net> <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:37:39 up 112 days,  1:18,  8 users,  load average: 0.23, 0.36,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 24 Sep 2008, Martin Bligh wrote:
> > 
> > If we just record the TSC unshifted, in 27 bits, at 4GHz, that gives us
> > about 1/30 of a second? So we either shift, use > 27 bits, or record
> > at least 30 events a second, none of which I like much ...
> 
> No, we don't shift (we don't want to lose precision), and we don't use 
> more than 27 bits by default.
> 

The reason why Martin did use only a 27 bits TSC in ktrace was that they
were statically limited to 32 event types. I doubt this will suffice for
general purpose kernel tracing. For simplicity, I would just start with
a header made of the 32 TSC LSBs, 16 bits for events ID and 16 bits for
event size in the buffer header. We can always create extra-compact
schemes later on which can be tied to specific buffers. I actually have
one in LTTng.

> the TSC at each entry should be a _delta_. It's the difference from the 
> last one. And if you get less than 30 events per second, and you need a 
> bigger difference, you insert an extra "sync" tracepoint that has a 59-bit 
> thing (27 bits _plus_ the extra 'data').
> 

I agree that, in the end, we will end up with "delta" information given
by the timestamp, but there is a way to encode that very simply without
having to compute any time delta between events : we just have to keep
the bits we are interested to save (say, the 32 LSBs) and write that as
a time value. Then, whenever we have to write this value, we either have
a heartbeat system making sure we always detect 32 bit overflows by
writing an event at least once per 32-bit overflow or by adding the full
64-bits timestamp as a prefix to the event when this occurs (as you
proposed). Note that the latter proposal imply extra computation at the
tracing site, which could have some performance impact.

There are a few reasons why I would prefer to stay away from enconding
time deltas and use direct LSB tsc representation in the event headers.
First, deltas make it hard to deal with missing information (lost
events, lost buffers); it those cases, you simply don't know what the
delta is. OTOH, if you encode directly the LSBs read from the cycle
counter, you can more easily deal with such lack of information (lost
events) and lost subbuffers by writing an extended 64-bits event header
when needed.

The benefit of using the bigger event header when required over using
heartbeat, even if it makes the tracing fastpath a bit slower, is that
is won't impact systems using dynamic ticks. Heartbeats are generally
bad at that because their require the system to be woken up
periodically.

Mathieu

> Yes, it adds 8 bytes (assuming that minimal format), but it does so only 
> for any trace event that is more than 1/30th of a second from its previous 
> one. IOW, think of this not in bytes, but in bytes-per-second. It adds at 
> most 8*30=240 bytes per second, but what it _saves_ is that when you have 
> tens of thousands of events, it shaves 4 bytes FOR EACH EVENT.
> 
> See?
> 
> Also, quite often, the clock won't be running at 4GHz even if the CPU 
> might. Intel already doesn't make the TSC be the nominal frequency, and 
> other architectures with TSC's have long had the TSC be something like a 
> "divide-by-16" clock rather than every single cycle because it's more 
> power-efficient.
> 
> So there is often a built-in shift, and I doubt we'll see 10GHz TSC's even 
> if we see 10GHz CPU's (which many people consider unlikely anyway, but 
> I'm not going to bet against technology).
> 
> 			Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
