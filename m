Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbYIWOAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbYIWOAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYIWNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:50:36 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:37660 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362AbYIWNue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:50:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsFABeP2EhMQWq+/2dsb2JhbACBXrZBgWc
Date: Tue, 23 Sep 2008 09:50:32 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923135031.GA23185@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <1222147545.6875.135.camel@charm-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222147545.6875.135.camel@charm-linux>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:35:23 up 110 days, 18:15,  7 users,  load average: 0.27, 0.26,
	0.20
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (zanussi@comcast.net) wrote:
 
> - get rid of anything having to do with padding, nobody needs it and its
> only affect has been to horribly distort and complicate a lot of the
> code
> - get rid of sub-buffers, they just cause confusion
> - get rid of mmap, nobody uses it

LTTng uses relay mmap. That's about the only feature of relay it uses
along with memory allocation.  It however implements its own buffer
management mechanism with poll() and ioctl GET_SUBBUF/PUT_SUBBUF to read
subbuffers. But these ops are all within LTTng.

BTW it would be good to change relay so it can take a buffer pointer as
input for relay_open. That would help getting memory mapped in the
linear mapping to be used for tracing when known at boot time.

Mathieu

> - no sub-buffers and no mmap support means we can get rid of most of the
> callbacks, and a lot of API confusion along with them
> - add relay flags - they probably should have been used from the
> beginning and options made explicit instead of being shoehorned into the
> callback functions.
> 
> Going even further, why not just replace the current write functions
> with versions that write into pages and SPLICE_F_MOVE them to their
> destination - normally userspace doesn't want to see the data anyway -
> and get rid of everything else.  Add support for splice_write() and
> maybe you have an elegant way to do userspace tracing (via vmsplice)
> too.

Sounds interesting. So then vmsplice would be used to support sending
trace data over the network or to disk ?

> 
> Another source of complexity has turned out to be the removal of the
> 'fs' part of relayfs - it basically meant adding callback hooks so relay
> files could be used in other pseudo filesystems, which is great, but it
> further complicated the API and scared away users.  We could add back
> the fs part, but that would be going backwards, so those callbacks at
> least would have to stay I guess.
> 
> Well, I'll post some patches shortly for a few of these things, but I
> doubt I'll do much more than that, since on the one hand I only have a
> few nights a week to work on this stuff and it's become a not-very-fun
> hobby, and since I think you guys have already decided on the way
> forward and anything I post would be removed soon anyway.
> 

I am not sure of that. I think there is some room for relay improvements
we could work on. As for the mechanism used to insure data coherency, I
think relay does not provide any. Could it be changed to an interrupt
disable+spinlock ? Then, in a second phase, we can optimize it by using
a lockless mechanism like LTTng does.

> As for the relay_printk() etc stuff, the part that adds the common code
> from blktrace for all tracers would definitely be a benefit, but I still
> don't think it goes far enough in providing generic trace control - see
> e.g. the kmemtrace-on-utt code where I still had to add code to add a
> bunch of control files - it would be nice to have a standard and easy
> way to do that.  For the printk() functionality itself, we submitted
> something similar a year ago (dti_printk) and nobody was interested:
> 
> http://lwn.net/Articles/240330/
> http://dti.sourceforge.net/
> 
> I told the folks in charge at IBM then that doing that kind of in-kernel
> filtering and sorting might be interesting and useful for ad hoc kernel
> hacking, but was basically a sideshow; the really useful part of the
> blktrace tracing code and 90% of the work needed to make it into a
> generically usable tracing system wasn't in the kernel at all, but in
> the unglamorous userspace code that did the streaming and display of the
> trace data via disk/network/live, etc.  Eventually I did go ahead and do
> that 90%, which wasn't a small task, and now anyone can use the blktrace
> code for generic tracing:
> 
> http://utt.sourceforge.net/
> 
> I can't say I did it justice, but it does work, and in fact, it didn't
> take much time at all to convert the kmemtrace code to using it:
> 
> http://utt.sourceforge.net/kmemtrace-utt-kernel.patch
> http://utt.sourceforge.net/kmemtrace-utt-user.patch
> 
> It should also be pretty straightforward to extend it to handle the
> output from any number of trace sources as has been mentioned, assuming
> you have a common sequencing source, so regardless of what you guys end
> up replacing relayfs with, you might consider using it anyway...
> 

I did the same with LTTV :) Writing userspace tools, including GUIs and
everything, can be quite a big task.

I would be good to keep in mind that a layered infrastructure would be
good. A bit like network packet encapsulation, we could have :

Layer 2 : Event payload (dealt by a unified event encoding
                         infrastructure)
          - Structure defined by event ID/type mapping table

Layer 1 : Events (dealt by a unified buffer layout infrastructure)
          - Event header
            - Timestamp
            - Event ID
            - Event size

Layer 0 : Buffers (dealt by a unified buffering infrastructure)
          - Buffer header
          - Subbuffers

Mathieu


> > 
> > Also, it seems prudent to separate the ring-buffer implementation from
> > the event encoding/decoding facilities.
> > 
> > 
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
