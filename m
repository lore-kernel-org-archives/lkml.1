Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYIWFZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYIWFZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIWFZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:25:36 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:60560
	"EHLO QMTA08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbYIWFZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:25:35 -0400
X-Authority-Analysis: v=1.0 c=1 a=D19gQVrFAAAA:8 a=07d9gI8wAAAA:8
 a=FP58Ms26AAAA:8 a=VE6esQrQcr2oF3tziSAA:9 a=ptGGjXfvWMTrsknNTpQA:7
 a=tdy6LXYDnX2LqHSz8VlFakrfc-AA:4 a=WuK_CZDBSqoA:10
Subject: Re: Unified tracing buffer
From: Tom Zanussi <zanussi@comcast.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 00:25:45 -0500
Message-Id: <1222147545.6875.135.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-09-22 at 16:45 +0200, Peter Zijlstra wrote:
> On Mon, 2008-09-22 at 19:37 +0530, K.Prasad wrote:
> 
> > > > INPUT_FUNCTIONS
> > > > ---------------
> > > > 
> > > > allocate_buffer (name, size)
> > > >         return buffer_handle
> > > > 
> > > > register_event (buffer_handle, event_id, print_function)
> > > >         You can pass in a requested event_id from a fixed set, and
> > > > will be given it, or an error
> > > >         0 means allocate me one dynamically
> > > >         returns event_id     (or -E_ERROR)
> > > > 
> > > > record_event (buffer_handle, event_id, length, *buf)
> > > 
> > > I'd hoped for an interface like:
> > > 
> > > struct ringbuffer *ringbuffer_alloc(const char *name, size_t size);
> > > void ringbuffer_free(struct ringbuffer *buffer);
> > > int ringbuffer_write(struct ringbuffer *buffer, const char *buf, size_t size);
> > > int ringbuffer_read(struct ringbuffer *buffer, int cpu, char *buf, size_t size);
> > > 
> > > On top of which you'd do the event thing, the register event with a
> > > callback idea makes sense, except I'd split the consumption into two:
> > >  - one method to pull the binary event out, which knows how long it
> > > ought to be etc..
> > >  - one method to convert the binary event to ASCII
> > >
> > In conjunction with the previous email on this thread
> > (http://lkml.org/lkml/2008/9/22/160), may I suggest
> > the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:
> > 
> > relay_printk(<some struct with default filenames/pathnames>, <string>,
> > ....) ;
> > relay_dump(<some struct with default filenames/pathnames>, <binary
> > data>);
> > and
> > relay_cleanup_all(<the struct name>); - Single interface that cleans up
> > all files/directories/output data created under a logical entity.
> 
> Dude, relayfs is such a bad performing mess that extending it seems like
> a bad idea. Better to write something new and delete everything relayfs
> related.

Hmm, I haven't seen complaints lately about about relayfs being 'bad
performing'.  The write/reserve functions are pretty fast - they
don't do much else in the fast path other than update an index, but
if they're still too slow, please let me know how to make them faster.
In any case, I'll post a couple patches in a few minutes that give
complete control over the write path for anyone who doesn't want to be
hampered by the existing versions.

As for the interface, yeah, it has gathered some some cruft over time
and has turned out to be too complex for most people.  The reason a lot
of that complexity is there in the first place though, ironically, is
that it was put there in explicit support of the requirements of
LTT/LTTng (sub-buffers, padding, mmap, etc), which supposedly
represented the needs of all 'industrial-strength' tracers at the time.
Well, four years after the 'troll merge' that initially got relayfs
streamlined and into the kernel, in anticipation of a soon-to-follow
streamlined LTT/LTTng which has yet to emerge, apparently those
requirements are no longer valid and neither LTTng nor anything else
needs the capabilities of relayfs.  That's fine, if it isn't needed, it
isn't needed.  But since it no longer has to conform to the requirements
of any imaginary tracer, maybe it should be put through yet another
streamlining effort and everything that's not required to support
current users removed:

- get rid of anything having to do with padding, nobody needs it and its
only affect has been to horribly distort and complicate a lot of the
code
- get rid of sub-buffers, they just cause confusion
- get rid of mmap, nobody uses it
- no sub-buffers and no mmap support means we can get rid of most of the
callbacks, and a lot of API confusion along with them
- add relay flags - they probably should have been used from the
beginning and options made explicit instead of being shoehorned into the
callback functions.

Going even further, why not just replace the current write functions
with versions that write into pages and SPLICE_F_MOVE them to their
destination - normally userspace doesn't want to see the data anyway -
and get rid of everything else.  Add support for splice_write() and
maybe you have an elegant way to do userspace tracing (via vmsplice)
too.

Another source of complexity has turned out to be the removal of the
'fs' part of relayfs - it basically meant adding callback hooks so relay
files could be used in other pseudo filesystems, which is great, but it
further complicated the API and scared away users.  We could add back
the fs part, but that would be going backwards, so those callbacks at
least would have to stay I guess.

Well, I'll post some patches shortly for a few of these things, but I
doubt I'll do much more than that, since on the one hand I only have a
few nights a week to work on this stuff and it's become a not-very-fun
hobby, and since I think you guys have already decided on the way
forward and anything I post would be removed soon anyway.

As for the relay_printk() etc stuff, the part that adds the common code
from blktrace for all tracers would definitely be a benefit, but I still
don't think it goes far enough in providing generic trace control - see
e.g. the kmemtrace-on-utt code where I still had to add code to add a
bunch of control files - it would be nice to have a standard and easy
way to do that.  For the printk() functionality itself, we submitted
something similar a year ago (dti_printk) and nobody was interested:

http://lwn.net/Articles/240330/
http://dti.sourceforge.net/

I told the folks in charge at IBM then that doing that kind of in-kernel
filtering and sorting might be interesting and useful for ad hoc kernel
hacking, but was basically a sideshow; the really useful part of the
blktrace tracing code and 90% of the work needed to make it into a
generically usable tracing system wasn't in the kernel at all, but in
the unglamorous userspace code that did the streaming and display of the
trace data via disk/network/live, etc.  Eventually I did go ahead and do
that 90%, which wasn't a small task, and now anyone can use the blktrace
code for generic tracing:

http://utt.sourceforge.net/

I can't say I did it justice, but it does work, and in fact, it didn't
take much time at all to convert the kmemtrace code to using it:

http://utt.sourceforge.net/kmemtrace-utt-kernel.patch
http://utt.sourceforge.net/kmemtrace-utt-user.patch

It should also be pretty straightforward to extend it to handle the
output from any number of trace sources as has been mentioned, assuming
you have a common sequencing source, so regardless of what you guys end
up replacing relayfs with, you might consider using it anyway...

> 
> Also, it seems prudent to separate the ring-buffer implementation from
> the event encoding/decoding facilities.
> 
> 
> 

