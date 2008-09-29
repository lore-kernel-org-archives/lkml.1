Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYI2Sip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYI2Sip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI2Sih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:38:37 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52822 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751908AbYI2Sig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:38:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAB234EhMQWq+/2dsb2JhbACBYrpBgWc
Date: Mon, 29 Sep 2008 14:38:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Message-ID: <20080929183833.GA17490@Krystal>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <alpine.DEB.1.10.0809291224470.5493@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809291224470.5493@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:48:59 up 116 days, 22:29,  9 users,  load average: 0.43, 0.32,
	0.31
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> > Ok, I'll try to explain my point of view. The thing is : I want those
> > binary buffers to be exported to userspace, and I fear that the approach
> > taken by Steven (let's write "simple" C structure directly into the
> > buffers) will in fact be much more _complex_ (due to subtle compiler
> > dependencies) that doing our own event payload (event data) format.
> > 
> > Also, things such as 
> > ring_buffer_lock: A way to lock the entire buffer.
> > ring_buffer_unlock: unlock the buffer.
> > will probably become a problem when trying to go for a more efficient
> > locking scheme.
> 
> I plan on nuking the above for something better in v2.
> 
> > 
> > ring_buffer_peek: Look at a next item in the cpu buffer.
> > This kind of feature is useless for data extraction to userspace and
> > poses serious synchronization concerns if you have other writers in the
> > same buffer.
> 
> It absolutely important for ftrace.
> 

As I already told you in person, if you have, say 16 pages for your
buffer, you could peek into all the pages which are not being currently
written into (15 other pages). This would permit to remove unnecessary
writer synchronization from a cmpxchg scheme : it would only have to
push the readers upon page switch rather than at every single even.
Pushing the readers involves, at best, a fully synchronized cmpxchg,
which I would prefer not to do at each and every event

> > 
> > Structure for event records :
> > 
> > struct ring_buffer_event {
> >         u32 type:2, len:3, time_delta:27;
> >         u32 array[];
> > };
> > 
> > The only good thing about reserving 2 bits for event IDs in there is to
> > put the most frequent events in those IDs, which is clearly not the
> > case:
> > RB_TYPE_PADDING: utterly useless. Can be expressed by a sub-buffer
> > header telling the length of data written into the subbuffer (what you
> > guys call a "page", but what I still think might be worthy to be of
> > variable size, especially with a light locking infrastructure and
> > considering we might want to export this data to userspace).
> 
> I now have both. But I think userspace can now easily see when there
> is a place in the buffer that is empty.
> 

(I notice the comment in your v10 says that minimum size for event is 8
bytes, isn't it rather 4 bytes ?)

(len field set to zero for events bigger than 28 bytes.. what do you use
for events with 0 byte payload ? I'd rather use the 28 bytes value to
identify all events >= 28 bytes and then use the first field to identify
the length).

What you propose here is to duplicate the information : have the number
of bytes used in the page header, exported to userspace, and also to
reserve an event ID (which becomes unavailable to encode anything else)
for "padding" event. There is clearly a space loss here.

Also, dealing with end of page padding will become a bit complex : you
have to check whether your padding event fits in the space left at the
end (4-bytes aligned, but minimum event size is 8 bytes, as stated in
your comment ? Is this true ?) Also, what happens if you plan to write
an event bigger than 28 bytes in your subbuffer (or page) and happen to
be at the end of the page ? You'd have to create padding which is larger
than 28 bytes. Your v10 comments seems to indicate the design does not
support it.

> > 
> > RB_TYPE_TIME_EXTENT : I'd reserve a separate bit for this one.
> > 
> > Also, if size _really_ matters, we should just export the event ID and
> > look up the event payload size through a separate table. If the payload
> > consists of a binary blob, then the data structure should start by a
> > payload size and then have a the actual binary blob.
> > 
> > struct ring_buffer_event {
> >         u32 time_ext:1, evid:4, time_lsb:27;
> >         union {
> >           u32 array[];
> >           struct {
> >             u32 ext_id;
> >             u32 array[];
> >           };
> >           struct {
> >             u32 ext_time;
> >             u32 array[];
> >           };
> >           struct {
> >             u32 ext_time;
> >             u32 ext_id;
> >             u32 array[];
> >           };
> > };
> > 
> > Therefore we can encode up to 15 event IDs into this compact
> > representation (we reserve ID 0xF for extended id). If we assign those
> > IDs per subbuffer, it leaves plenty of room before we have to write a
> > supplementary field for more IDs.
> 
> I wanted to push the event ids out of the ring buffer logic. Only a few 
> internal ones are used.  Otherwise, we'll have one hell of a bit enum 
> table with every freaking tracing type in it. That's what I want to avoid.
> 

This is why I propose to dynamically allocate event IDs through the
markers infrastructure. Other you'll have to declare and export such
large enumerations by hand.

> 
> > 
> > OTOH, if we really want to have an event size in there (which is more
> > solid), we could have :
> > 
> > struct ring_buffer_event {
> >         u32 time_ext:1, time_lsb:31;
> >         u16 evid;
> >         u16 evsize;
> >         union {
> >           u32 array[];
> >           struct {
> >             u32 ext_time;
> >             u32 array[];
> >           };
> > };
> 
> My smallest record is 8 bytes. Yours now is 12.
> 

Uh ?

The smallest record here is 8 bytes too. It has time_ext bit, time_lsb,
evid and evsize. It does not contain any event-specific payload.

With this given implementation :

struct ring_buffer_event {
  u32 time_ext:1, evid:4, time_lsb:27;
};

The smallest event is 4-bytes, which is twice smaller than yours.


> > That's a bit bigger, but keeps the event size in the data stream.
> 
> So does mine.
> 

I see the 4 first bytes of this smallest event (the ring_buffer_event).
What does the following 4 bytes contain exactly ?


> > 
> > Also, nobody has explained successfully why we have to encode a time
> > _delta_ (current tsc - prev tsc) rather than just putting the LSBs. So
> > either I fail to see the light here (I doubt it), or I am not clear
> > enough when I say that we can just put the raw LSBs and compute the
> > delta afterward when reading the buffers, manage to keep the same
> > overflow detection power, and also keep the absolute value of the tsc
> > lsb, which makes it much easier to cross-check than "deltas".
> 
> Well, you need to record wraps. Probably more often then you record delta
> wraps.
> 

Nope. You don't even need to record wraps. Say you have the kernel code
that checks for 27 bits overflows between two consecutive events and
write an extended timestamp if this is detected
(that is, if (evBtsc - evAtsc > 0x7FFFFFF)).
Therefore, you are sure that if you have two consecutive events with
only 27 bits TSC lsb in the trace (non-extended timestamp), those are at
most 2^27 cycles apart. Let's call them event A and event B.

Event A would have this TSC value (only 27 LSBs are saved here) :
0x100
Event B would have this TSC LSB value :
0x200

In this case, 0x200 - 0x100 > 0
  -> no overflow

However, if we have :
Event A : 0x2
Event B : 0x1

Then we know that there has been exactly one overflow between those two
events :
0x1 - 0x2 <= 0
  -> overflow

And the extreme case :
Event A : 0x10
Event B : 0x10
0x10 - 0x10 <= 0
  -> overflow

Notice that if event B, in the last case, would be just one cycle above,
the check initially done by the kernel would have switched to an
extended timestamp, so we would have detected the overflow anyway.

> > 
> > Now for the buffer pages implementation :
> > 
> > 
> > +struct buffer_page {
> > +       union {
> > +               struct {
> > +                       unsigned long flags;    /* mandatory */
> > +                       atomic_t _count;        /* mandatory */
> > +                       u64     time_stamp;     /* page time stamp */
> > 
> > Why should we ever associate a time stamp with a page ??
> 
> Because we save it on overwrite, which is the default mode for ftrace.
> 

Sorry, I don't understand this one. You "save it" (where ?) on overwrite
(when ? When you start overwrting a previously populated page ?) and
this serves what purpose exactly ?

> > 
> > I see that we could save the timestamp at which a subbuffer switch
> > happens (which in this patchset semantics happens to be a page), but why
> > would we every want to save that in the page frame ? Especially if we
> > simply write the LSBs instead of a time delta... Also, I would write
> 
> Where do you get the MSBs from?
> 

Just to try to grasp the page frame concept : are those actually bytes
physically located at the beginning of the page (and thus actually
representing a page header) or are they placed elsewhere in the kernel
memory and just serves as memory-management data for pages ?

I doubt this struct page is actually part of the page itself, and thus I
don't see how it exports the TSC MSBs to userspace. I would propose to
keep a few byte at the beginning of every subbuffer (actually pages in
your implementation) to save the full TSC.

> > this timestamp in a subbuffer _header_ which is exported to userspace,
> 
> Well, our subbuffer header is the page frame.
> 

Hrm, this is actually my question above.

> > but I clealry don't see why we keep it here. In addition, it's
> > completely wrong in a layered approach : if we want to switch from pages
> > to video memory or to a statically allocated buffer at boot time, such
> > "page-related" timestamp hacks won't do.
> 
> As Linus said, anything bigger than a page should be outside this buffer.
> All the buffer would then need is a pointer to the data. Then the tracer
> can figure out what to do with the rest of that.
> 

That will lead to memory leaks in flight recorder mode. What happens if
the data is not consumed ? We never free the referenced memory ?

Also, how to we present that to userspace ?

Also, if we have a corrupted buffer, lost events ? Those will call into
kfree in the tracing hot path ? This sounds _very_ instrusive and
dangerous. I am quite sure we'll want to instrumentat the memory
management parts of the kernel too (I actually have patches in LTTng for
that and kmemtrace already does it).

> > 
> > +                       unsigned size;          /* size of page data */
> > 
> > This size should be exported to userspace, and therefore belongs to a
> > subbuffer header, not to the page frame struct.
> 
> Again, page frame == sub buffer, period!
> 

The best argument I have heard yet is from Linus and is based on the
fact that we'll never want to write more than 4096 bytes within locking
such as irq disable and spinlock. This assumption does not hold with a
cmpxchg-based locking scheme.

Also, I kind of sensed that people were unwilling to write large events
in the same stream where small events are put. There is no need to do
that. We can have various buffers for the various tracers (one for
scheduler, one for ftrace, one for network packet sniffing, one for
usbmon...) and therefore manage to keep large events in separate
buffers.

> > 
> > +                       struct list_head list;  /* linked list of free pages */
> > 
> > "free pages" ? Are those "free" ? What does free mean here ? If Steven
> 
> Bah, thanks. "free" is a misnomer.  It should just be list of pages.
> 
> > actually moves head and tail pointers to keep track of which pages data
> > is written into, it will become an utter mess when we'll try to
> > implement a lockless algorithm, since those are all non-atomic
> > operations.
> 
> cmpxchg(head, old_head, head->next) ?
> 

Nope, that won't work because you'll have to cmpxchg two things :
- The offset within the page
- The current page pointer

And you cannot do both at the same time, and therefore any of those two
can fail. Dealing with page switch will therefore become racy by design.

Mathieu

> > 
> > +               };
> > +               struct page page;
> > +       };
> > +};
> > 
> > > As for the page-spanning entries, I think we can do that with Steve's
> > > system just fine, its just that Linus said its a dumb idea and Steve
> > > dropped it, but there is nothing fundamental stopping us from recording
> > > a length that is > PAGE_SIZE and copying data into the pages one at a
> > > time.
> > > 
> > > Nor do I see it impossible to implement splice on top of Steve's
> > > ring-buffer..
> > > 
> > > So again, why?
> > > 
> > 
> > I'd like to separate the layer which deals with data read/write from the
> > layer which deals with synchronization of data write/read to/from the
> > buffers so we can eventually switch to a locking mechanism which
> > provides a sane performance level, and given Steven's linked list
> > implementation, it will just add unneeded locking requirements.
> > 
> > Compared to this, I deal with buffer coherency with two 32 bits counters
> > in LTTng : a write offset and a consumer offset. (plus a per-subbuffer
> > commit count). I'd like to keep this semantic and yet support writing to
> > non-vmap'd memory (which I do in the patch I propose). I'd just have to
> > implement the splice operation in ltt-relay.c (the layer that sits on
> > top of this patch).
> > 
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
