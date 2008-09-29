Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYI2Tka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYI2Tka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYI2TkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:40:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYI2TkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:40:17 -0400
Date: Mon, 29 Sep 2008 15:40:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
In-Reply-To: <20080929183833.GA17490@Krystal>
Message-ID: <alpine.DEB.1.10.0809291452180.8145@gandalf.stny.rr.com>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <alpine.DEB.1.10.0809291224470.5493@gandalf.stny.rr.com> <20080929183833.GA17490@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > > 
> > > ring_buffer_peek: Look at a next item in the cpu buffer.
> > > This kind of feature is useless for data extraction to userspace and
> > > poses serious synchronization concerns if you have other writers in the
> > > same buffer.
> > 
> > It absolutely important for ftrace.
> > 
> 
> As I already told you in person, if you have, say 16 pages for your
> buffer, you could peek into all the pages which are not being currently
> written into (15 other pages). This would permit to remove unnecessary
> writer synchronization from a cmpxchg scheme : it would only have to
> push the readers upon page switch rather than at every single even.
> Pushing the readers involves, at best, a fully synchronized cmpxchg,
> which I would prefer not to do at each and every event

Actually, I also have been looking at doing things lockless. Note, the 
peek operation is for the iteration mode of read, which must disable 
writes (for now). The iteration mode does not consume the reader, in fact 
there is no consumer. It is used to give a trace after the fact. No writer 
should be present anyway.

the peek operation will not be used for a consumer read, which allows for 
both readers and writers to run at the same time.

> > 
> > I now have both. But I think userspace can now easily see when there
> > is a place in the buffer that is empty.
> > 
> 
> (I notice the comment in your v10 says that minimum size for event is 8
> bytes, isn't it rather 4 bytes ?)

Yes it is 8 bytes minimum, 4 bytes aligned.

> 
> (len field set to zero for events bigger than 28 bytes.. what do you use
> for events with 0 byte payload ? I'd rather use the 28 bytes value to
> identify all events >= 28 bytes and then use the first field to identify
> the length).

I force a zero type payload to have a len of 1. This keeps the minimum at
8 bytes, with 4 bytes unused.

> 
> What you propose here is to duplicate the information : have the number
> of bytes used in the page header, exported to userspace, and also to
> reserve an event ID (which becomes unavailable to encode anything else)
> for "padding" event. There is clearly a space loss here.

Because my focus is not on userspace. I don't care about user space apps!

My user space app is "cat".  I don't want to map ever single kind of event 
into the buffer. Keeping the length in the header keeps everything more 
robust. I don't have to worry about searching an event hash table, or 
remap what events are. Hell, I don't want to always register an event, I 
might just say, load this data and be done with it.

The user shouldn't need to always keep track of event sizes on reading.
Remember, the user could be something in the kernel space as well.

> 
> Also, dealing with end of page padding will become a bit complex : you
> have to check whether your padding event fits in the space left at the
> end (4-bytes aligned, but minimum event size is 8 bytes, as stated in
> your comment ? Is this true ?) Also, what happens if you plan to write
> an event bigger than 28 bytes in your subbuffer (or page) and happen to
> be at the end of the page ? You'd have to create padding which is larger
> than 28 bytes. Your v10 comments seems to indicate the design does not
> support it.

Yep, we add more than 28 bytes of padding. Linus said this was fine. If
you don't have enough space to fit your event, go to the next page.
If you only have 4 bytes left, yes we have an exception to the rule, the
padding event will be 4 bytes.

> > > Therefore we can encode up to 15 event IDs into this compact
> > > representation (we reserve ID 0xF for extended id). If we assign those
> > > IDs per subbuffer, it leaves plenty of room before we have to write a
> > > supplementary field for more IDs.
> > 
> > I wanted to push the event ids out of the ring buffer logic. Only a few 
> > internal ones are used.  Otherwise, we'll have one hell of a bit enum 
> > table with every freaking tracing type in it. That's what I want to avoid.
> > 
> 
> This is why I propose to dynamically allocate event IDs through the
> markers infrastructure. Other you'll have to declare and export such
> large enumerations by hand.

I don't want to be dependent on markers. No need to be, it's too much for
what I need.

> > 
> > > 
> > > OTOH, if we really want to have an event size in there (which is more
> > > solid), we could have :
> > > 
> > > struct ring_buffer_event {
> > >         u32 time_ext:1, time_lsb:31;
> > >         u16 evid;
> > >         u16 evsize;
> > >         union {
> > >           u32 array[];
> > >           struct {
> > >             u32 ext_time;
> > >             u32 array[];
> > >           };
> > > };
> > 
> > My smallest record is 8 bytes. Yours now is 12.
> > 
> 
> Uh ?
> 
> The smallest record here is 8 bytes too. It has time_ext bit, time_lsb,
> evid and evsize. It does not contain any event-specific payload.

OK, my smallest event with data is 8 bytes, yours is 12. What do I want a 
payload without data for?

I see:

 4 bytes time_ext, time
 2 byts evid
 2 bytes evsize

There's your 8bytes. You need anoter 4 bytes to hold data, which makes it 
12.


> 
> With this given implementation :
> 
> struct ring_buffer_event {
>   u32 time_ext:1, evid:4, time_lsb:27;
> };
> 
> The smallest event is 4-bytes, which is twice smaller than yours.

With no data. I'm not going to worry about saving 4 bytes for a zero 
payload.

> 
> 
> > > That's a bit bigger, but keeps the event size in the data stream.
> > 
> > So does mine.
> > 
> 
> I see the 4 first bytes of this smallest event (the ring_buffer_event).
> What does the following 4 bytes contain exactly ?

The payload.

> 
> 
> > > 
> > > Also, nobody has explained successfully why we have to encode a time
> > > _delta_ (current tsc - prev tsc) rather than just putting the LSBs. So
> > > either I fail to see the light here (I doubt it), or I am not clear
> > > enough when I say that we can just put the raw LSBs and compute the
> > > delta afterward when reading the buffers, manage to keep the same
> > > overflow detection power, and also keep the absolute value of the tsc
> > > lsb, which makes it much easier to cross-check than "deltas".
> > 
> > Well, you need to record wraps. Probably more often then you record delta
> > wraps.
> > 
> 
> Nope. You don't even need to record wraps. Say you have the kernel code
> that checks for 27 bits overflows between two consecutive events and
> write an extended timestamp if this is detected
> (that is, if (evBtsc - evAtsc > 0x7FFFFFF)).
> Therefore, you are sure that if you have two consecutive events with
> only 27 bits TSC lsb in the trace (non-extended timestamp), those are at
> most 2^27 cycles apart. Let's call them event A and event B.
> 
> Event A would have this TSC value (only 27 LSBs are saved here) :
> 0x100
> Event B would have this TSC LSB value :
> 0x200
> 
> In this case, 0x200 - 0x100 > 0
>   -> no overflow
> 
> However, if we have :
> Event A : 0x2
> Event B : 0x1
> 
> Then we know that there has been exactly one overflow between those two
> events :
> 0x1 - 0x2 <= 0
>   -> overflow
> 
> And the extreme case :
> Event A : 0x10
> Event B : 0x10
> 0x10 - 0x10 <= 0
>   -> overflow
> 
> Notice that if event B, in the last case, would be just one cycle above,
> the check initially done by the kernel would have switched to an
> extended timestamp, so we would have detected the overflow anyway.

I actually don't care which method we use. This is something that we can
change later.

> 
> > > 
> > > Now for the buffer pages implementation :
> > > 
> > > 
> > > +struct buffer_page {
> > > +       union {
> > > +               struct {
> > > +                       unsigned long flags;    /* mandatory */
> > > +                       atomic_t _count;        /* mandatory */
> > > +                       u64     time_stamp;     /* page time stamp */
> > > 
> > > Why should we ever associate a time stamp with a page ??
> > 
> > Because we save it on overwrite, which is the default mode for ftrace.
> > 
> 
> Sorry, I don't understand this one. You "save it" (where ?) on overwrite
> (when ? When you start overwrting a previously populated page ?) and
> this serves what purpose exactly ?

Actually, when we write to a new page, we save the timestamp. We don't 
care about pages we overwrite, since the next read page still has the
timestamp value that was record when it was first written to.

I'm saying, every page needs a timestamp value that can be retrieved, 
otherwise, how do you retrieve the timestamp of a page that was 
overwritten several times since the trace was started and never was read.

> 
> > > 
> > > I see that we could save the timestamp at which a subbuffer switch
> > > happens (which in this patchset semantics happens to be a page), but why
> > > would we every want to save that in the page frame ? Especially if we
> > > simply write the LSBs instead of a time delta... Also, I would write
> > 
> > Where do you get the MSBs from?
> > 
> 
> Just to try to grasp the page frame concept : are those actually bytes
> physically located at the beginning of the page (and thus actually
> representing a page header) or are they placed elsewhere in the kernel
> memory and just serves as memory-management data for pages ?

The later.  Yes the page is the page frame management infrastructure.
When the page is allocated somewhere with get_free_page, most of that
structure is not being used. When the page is free or being used as
cache, then that structure matters.

> 
> I doubt this struct page is actually part of the page itself, and thus I
> don't see how it exports the TSC MSBs to userspace. I would propose to
> keep a few byte at the beginning of every subbuffer (actually pages in
> your implementation) to save the full TSC.

Actually, my first versions had that. But I moved it. I'll come up with
a way to get this info later.

> 
> > > this timestamp in a subbuffer _header_ which is exported to userspace,
> > 
> > Well, our subbuffer header is the page frame.
> > 
> 
> Hrm, this is actually my question above.

hehe, answered above.

> 
> > > but I clealry don't see why we keep it here. In addition, it's
> > > completely wrong in a layered approach : if we want to switch from pages
> > > to video memory or to a statically allocated buffer at boot time, such
> > > "page-related" timestamp hacks won't do.
> > 
> > As Linus said, anything bigger than a page should be outside this buffer.
> > All the buffer would then need is a pointer to the data. Then the tracer
> > can figure out what to do with the rest of that.
> > 
> 
> That will lead to memory leaks in flight recorder mode. What happens if
> the data is not consumed ? We never free the referenced memory ?

IIRC, Linus had for these records:

  array[0] = pointer to big data
  array[1] = pointer to free function.

When the data is consumed in overwrite mode, we can call a free function
to get rid of it.

> 
> Also, how to we present that to userspace ?

The tracer layer will make something available for userspace. The ring
buffer layer will not.

> 
> Also, if we have a corrupted buffer, lost events ? Those will call into
> kfree in the tracing hot path ? This sounds _very_ instrusive and
> dangerous. I am quite sure we'll want to instrumentat the memory
> management parts of the kernel too (I actually have patches in LTTng for
> that and kmemtrace already does it).

We could add it to a per_cpu list that can free these later.

> 
> > > 
> > > +                       unsigned size;          /* size of page data */
> > > 
> > > This size should be exported to userspace, and therefore belongs to a
> > > subbuffer header, not to the page frame struct.
> > 
> > Again, page frame == sub buffer, period!
> > 
> 
> The best argument I have heard yet is from Linus and is based on the
> fact that we'll never want to write more than 4096 bytes within locking
> such as irq disable and spinlock. This assumption does not hold with a
> cmpxchg-based locking scheme.
> 
> Also, I kind of sensed that people were unwilling to write large events
> in the same stream where small events are put. There is no need to do
> that. We can have various buffers for the various tracers (one for
> scheduler, one for ftrace, one for network packet sniffing, one for
> usbmon...) and therefore manage to keep large events in separate
> buffers.

Make your tracer layer have a "large event" buffer.  This current code 
will focus on little events.

> 
> > > 
> > > +                       struct list_head list;  /* linked list of free pages */
> > > 
> > > "free pages" ? Are those "free" ? What does free mean here ? If Steven
> > 
> > Bah, thanks. "free" is a misnomer.  It should just be list of pages.
> > 
> > > actually moves head and tail pointers to keep track of which pages data
> > > is written into, it will become an utter mess when we'll try to
> > > implement a lockless algorithm, since those are all non-atomic
> > > operations.
> > 
> > cmpxchg(head, old_head, head->next) ?
> > 
> 
> Nope, that won't work because you'll have to cmpxchg two things :
> - The offset within the page
> - The current page pointer

BTW, I remember telling you that I want the reader and writer to loop
on the same page. I've changed my mind. This code will push the reader
to the next page on overwrite. That is, a writer will not write on a page
that a reader is on (unless the reader is behind it).

Some assumptions that I plan on making.

1) A writer can only write to the CPU buffer it is on.
2) All readers must be synchronized with each other. Two readers can
  not read from the same buffer at the same time (at the API level).

Now, what this gives us is.

1) stack order of writes.

  All interrupts and NMIs will enter and leave in stack fashion.
  Writers will always disable preemption.
  We do not need to worry about SMP for writes.
  That is, if you reserve data and atomically push the head forward
   if the head goes past the end of page, One, you check if your
   start of head (head - length) is still on the page. If it is
   you add your padding (you already reserved it), then you atomically
   push the head forward. Then you start the process again.
  If the start of the head (head - length) is not on the page, that
   means that an IRQ or NMI came in and pushed it before you.


2) Only need to deal with one reader at a time.

 The one reader just helps make the reader side easier. It doesn't make
 much difference with the writer side.

 I've been thinking of various ways to handle the reader.

 1) only consumer mode handle synchronization with writers.
    The iterator mode (read a trace but do not consume) must disable
    writes. This just makes everything easier, and is usually what you
    want, otherwise the read is just corrupted. ftrace currently disables
    recording when the trace is being read (except for the consumer 
    trace_pipe).

 2) Have an extra sub buffer. This might be what you do. That is, have 
    an extra page, and when a reader starts, it will swap the page from
    the buffer with the extra page. The writer will then write on this
    new page.

    We could use atomic inc on the pages to detect if the page changed
    since we copied it, and if we fail try again.

This will also allow you to take these extra pages and push them to a 
file.

This is just the jest of things to come in v2.

-- Steve

> 
> And you cannot do both at the same time, and therefore any of those two
> can fail. Dealing with page switch will therefore become racy by design.
> 
