Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbYKXIF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbYKXIF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbYKXIFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:05:15 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:54966 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYKXIFO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:05:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAKHpKUlMROB9/2dsb2JhbACBbc0hgnw
Date: Mon, 24 Nov 2008 03:05:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API :
	trace_mark_tp())
Message-ID: <20081124080511.GA8501@Krystal>
References: <20081114224733.364965865@polymtl.ca> <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu> <20081118044403.GA32759@Krystal> <20081118163037.GD8088@elte.hu> <20081123164012.GA16962@Krystal> <20081123164923.GB11243@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20081123164923.GB11243@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:27:05 up 7 days,  8:07,  3 users,  load average: 0.56, 0.40,
	0.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > ... and in that sense i'd love to see lttng become a "super ftrace 
> > > plugin", and be merged upstream ASAP.
> > 
> > Hrm, a big part of LTTng is its optimized buffering mechanism, which 
> > has been more tested and is more flexible than the one currently 
> > found in ftrace (it has supported lockless NMI-safe tracing for over 
> > 2 years). It also separates the various tracing layers in separated 
> > modules, which helps not mixing the buffer management layer with the 
> > timestamping layer and with the memory backend layer.. I am opened 
> > to try to merge ftrace and lttng together, but I think it will be 
> > more than a simple "make lttng a ftrace plugin".
> 
> Sure, it will certainly be a fair bit of (interesting and useful!) 
> work.
> 
> But it's something we should do iteratively, instead of merging a 
> parallel framework. Steve's ring-buffer should be a fair step in the 
> right direction. Could we improve on that?
> 

I think it's a very good thing that both Steve and me went through the
effort of creating such buffering mechanism, because it created healthy
competition and we have been able to cross-check each other code (well,
I actually pointed out some bugs he had in his tracer code just because
I ran into the same issues).

The only thing is that ftrace needs are a subset of what LTTng needs and
provides. As Steve stated very clearly in the past weeks, he doesn't
care about exporting binary data in an organized self-described manner.
This is actually a key component of LTTng. Therefore, there seems to be
no will nor need to self-describe the information in the trace buffers
from Steve's point of view.

However, even if such self-description is not used by ftrace-type
tracers within the kernel, it could just be *there* so we can support
high-throughput streaming of organized (non-opaque) binary data when
needed. A ftrace tracer could then participate to this information flow
and make the data available for high-speed extraction. I think this
would be very beneficial to the LTTng use-cases and would not hurt
ftrace tracers at all.

> i see nothing in the feature list of LTTng that we wouldnt want to 
> have for ftrace, agreed?

Yes, the only thing is that LTTng might be doing a little bit more than
what ftrace needs, because it needs to export the information to
userspace.

> And we could do an ftrace tracer named 
> 'LTTng' which would interact with lttng userspace in the customary 
> way.

Or we could think of making ftrace be a LTTng information source, so it
would be able to export all its information to userspace through the
high-speed self-described binary trace buffers (channels) and also
manage to keep all of its current features. The way I see it, because
ftrace has simpler requirements due to the fact it does not export
binary data across the kernel boundary, ftrace buffering can be seen as
a subset of the LTTng requirements.

Besides, looking at LWN reviews of Steve's ring buffer implementation
"A casual perusal of the patch might well leave a reader confused; 2000
lines of relatively complex code to implement what is, in the end, just
a circular buffer. This circular buffer is not even suitable for use by
tracing frameworks yet; a separate "tracing" layer is to be added for
that."

I achieve all the core work of atomic-ops based buffering,
self-description of traces and all I said above with a design easier to
review in a few more lines, but distributed in smaller files :

   850 ltt-marker-control.c   (marker userspace control, event ID
                               management)
   179 ltt-relay.h
   701 ltt-relay-alloc.c      (buffer memory backend, vmap-less,
                               contiguous memory range emulated by software)
  1648 ltt-relay.c            (atomic buffer writer/reader
                               synchronization)
   780 ltt-tracer.h           (header definitions, prototypes, inlines)

Compared to : 
  2241 ring_buffer.c
   130 ring_buffer.h

So in the end, my argumentation is not based on a simple "I prefer my
code to someone else's code", but simply that I think it could be easier
to integrate the tracer with the fewer constraints into the tracer with
the more constraints (principally exporting data to userspace) than to
do the opposite.

And all ftrace could need that LTTng currently lacks (like in-kernel
binary-to-text converter) is currently on the LTTng roadmap.

Mathieu

> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
