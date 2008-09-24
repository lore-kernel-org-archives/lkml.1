Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYIXSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYIXSGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYIXSGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:06:05 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:48989 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYIXSGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:06:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAFwb2khMQWq+/2dsb2JhbACBXrxrgWU
Date: Wed, 24 Sep 2008 14:01:00 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@google.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080924180100.GA4374@Krystal>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809240921430.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809240921430.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:34:08 up 111 days, 22:14,  8 users,  load average: 0.53, 0.49,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 24 Sep 2008, Peter Zijlstra wrote:
> > 
> > So when we reserve we get a pointer into page A, but our reserve length
> > will run over into page B. A write() method will know how to check for
> > this and break up the memcpy to copy up-to the end of A and continue
> > into B.
> 
> I would suggest just not allowing page straddling.
> 
> Yeah, it would limit event size to less than a page, but seriously, do 
> people really want more than that? If you have huge events, I suspect it 
> would be a hell of a lot better to support some kind of indirection 
> scheme than to force the ring buffer to handle insane cases.
> 
> Most people will want the events to be as _small_ as humanly possible. The 
> normal event size should hopefully be in the 8-16 bytes, and I think the 
> RFC patch is already broken because it allocates that insane 64-bit event 
> counter for things. Who the hell wants a 64-bit event counter that much? 
> That's broken.
> 
> 		Linus
> 

Hi Linus,

I agree that the standard "high event rate" use-case, when events are as
small as possible, would fit perfectly in 4kB sub-subbfers. However,
I see a few use-cases where having the ability to write across page
boundaries would be useful. Those will likely be low event-rate
situations where it is useful to take a bigger snapshot of a problematic
condition, but still to have it synchronized with the rest of the trace
data. e.g. :

- Writing a whole video frame into the trace upon video card glitch.
- Writing a jumbo frame (up to 9000 bytes) into the buffer when a
  network card error is detected or when some iptables rules (LOG, TRACE
  ?) are reached.
- Dumping a kernel stack (potentially 8KB) in a single event when a
  kernel OOPS is reached.
- Dumping a userspace process stack into the trace upon SIGILL, SIGSEGV
  and friends.

That's only what I come up with from the top of my head, and I am sure
we'll find very ingenious users who will find plenty of other use-cases
where 4kB events won't be enough.

(It reminds me of someone saying "640K ought to be enough for anybody.")
;-)

If the write abstraction supports page straddling, I think it would be a
huge gain in simplicity for such users because they would not have to
break their payload in various events and have to create another event
layer on top of all that which would identify events uniquely with a
"cookie" or to protect writing events into the buffers with another
layer of locking.

Besides, there are other memory backends where the buffers can be put
that do not depend on the page size, namely video card memory. It can be
very useful to collect data that survives reboots. Given that this
memory will likely consist of contiguous pages, I see no need to limit
the maximum event size to a page on such support. Therefore, I think the
support for page-crossing should be placed in the "write" abstraction
(which would be specific to the type of memory used to back the
buffers) rather that the reserve/commit layer (which can simply
do reserve/commit in terms of offset from the buffer start, without
having to know the gory buffer implementation details (e.g. : array of
pages, linear mapping at boot time, video card memory...).

So, given the relative simplicity of doing a write() abstraction layer
which would deal with page-crossing writes compared to the complexity
that users would have to deal with when splitting up their large events,
I would recommend to abstract page straddling when writing to a page
array.

I think having the ability to break the buffers into sub-buffers is
still required, because it's good to have the ability to seek quickly in
such data, and the way to do this is to separate the buffer in
fixed-size sub-buffers which each contains many variable-sized events.
But I would recommend to make the sub-buffer size configurable by the
tracers so we can support events bigger than 4kB when needed.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
