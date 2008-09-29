Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYI2Ubh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYI2Ubh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYI2Ub3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:31:29 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:57707 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbYI2Ub2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:31:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAG7T4EhMQWq+/2dsb2JhbACBYrozgWc
Date: Mon, 29 Sep 2008 16:31:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Message-ID: <20080929203124.GA23070@Krystal>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal> <1222709445.23876.70.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222709445.23876.70.camel@twins.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:04:50 up 116 days, 23:45,  9 users,  load average: 1.08, 0.56,
	0.71
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Mon, 2008-09-29 at 11:50 -0400, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > On Sat, 2008-09-27 at 09:40 -0400, Mathieu Desnoyers wrote:
> > > > As I told Martin, I was thinking about taking an axe and moving stuff around in
> > > > relay. Which I just did.
> > > > 
> > > > This patch reimplements relay with a linked list of pages. Provides read/write
> > > > wrappers which should be used to read or write from the buffers. It's the core
> > > > of a layered approach to the design requirements expressed by Martin and
> > > > discussed earlier.
> > > > 
> > > > It does not provide _any_ sort of locking on buffer data. Locking should be done
> > > > by the caller. Given that we might think of very lightweight locking schemes, it
> > > > makes sense to me that the underlying buffering infrastructure supports event
> > > > records larger than 1 page.
> > > > 
> > > > A cache saving 3 pointers is used to keep track of current page used for the
> > > > buffer for write, read and current subbuffer header pointer lookup. The offset
> > > > of each page within the buffer is saved in the page frame structure to permit
> > > > cache lookup without extra locking.
> > > > 
> > > > TODO : Currently, no splice file operations are implemented. Should come soon.
> > > > The idea is to splice the buffers directly into files or to the network.
> > > > 
> > > > This patch is released as early RFC. It builds, that's about it. Testing will
> > > > come when I implement the splice ops.
> > > 
> > > Why? What aspects of Steve's ring-buffer interface will hinder us
> > > optimizing the implementation to be as light-weight as you like?
> > > 
> > > The thing is, I'd like to see it that light as well ;-)
> > > 
> > 
> > Ok, I'll try to explain my point of view. The thing is : I want those
> > binary buffers to be exported to userspace, and I fear that the approach
> > taken by Steven (let's write "simple" C structure directly into the
> > buffers) will in fact be much more _complex_ (due to subtle compiler
> > dependencies) that doing our own event payload (event data) format.
> 
> The only compiler dependant thing in there is the bitfield, which could
> be recoded using regular bitops.
> 
> I'm not seeing anything particularly worrysome about that.
> 


+struct ring_buffer_event {
+       u32             type:2, len:3, time_delta:27;
+       u32             array[];
+};

I am mostly talking about what goes in the array[] part of the event.
This will be where the complex typing will occur.


> > Also, things such as 
> > ring_buffer_lock: A way to lock the entire buffer.
> > ring_buffer_unlock: unlock the buffer.
> > will probably become a problem when trying to go for a more efficient
> > locking scheme.
> 
> You can do
> 
> stop:
> cpu_buffer->stop=1;
> smp_wmb();
> sched_sync();
> 
> start:
> smp_wmb();
> cpu_buffer->stop=0;
> 
> 
> write:
> if (unlikely(smp_rmb(), cpu_buffer->stop))) {
>   return -EBUSY;
>     or
>   while (cpu_buffer->stop)
>     cpu_relax();
> }
> 
> The read in the fast path is just a read, nothing fancy...
> 

That will stop tracing if you want to read a trace at the same time you
want to write it, which does not permit continuous streaming.

I agree that such start/stop is needed to control tracing on/off, but it
should be separate from the actual writer/reader locking.

> > ring_buffer_peek: Look at a next item in the cpu buffer.
> > This kind of feature is useless for data extraction to userspace and
> > poses serious synchronization concerns if you have other writers in the
> > same buffer.
> 
> Sure, its probably possible to rework the merge-iterator to use consume,
> but that would require it having storage for 1 event, which might be a
> bit messy.
> 

Not sure why you'd need storage for 1 event ?

> How would your locking deal with this? - it really is a requirement to
> be able to merge-sort-iterate the output from kernel space..
> 

Sure, I plan to support this. This would be a subset of userspace data
extraction. The in-kernel consumer would be a consumer just like a
splice operation which would extract buffers one event at a time. Rather
than doing a splice to write the data to disk or to the network, this
special in-kernel consumer would merge-sort events from the various
buffers it is connected to and pretty-print one event record at a time
to a seq_file.

Instead of peeking in the "next event", which implies closely coupled
locking with the writer, it would therefore have to ability to consume
all the oldest subbuffers which are not being written to.

Being a standard consumer, it would therefore increment the consumer
offset, which is synchronized by the writer at each subbuffer (page)
switch only.

> > Structure for event records :
> > 
> > struct ring_buffer_event {
> >         u32 type:2, len:3, time_delta:27;
> >         u32 array[];
> > };
> > 
> > The only good thing about reserving 2 bits for event IDs in there is to
> > put the most frequent events in those IDs
> 
> Not so, these types are buffer package types, not actual event types, I
> think thats a useful distinction.
> 

I actually think we only need 1 bit to represent extended timestamp
headers. The rest of these event types are just unneeded and consume
precious ID space for nothing. I have not seen any justification telling
why reserving these events actually does something that cannot be done
by the extended timestamp header or by reserving a small header at the
beginning of the subbuffer (page).

> > , which is clearly not the
> > case:
> > RB_TYPE_PADDING: utterly useless. Can be expressed by a sub-buffer
> > header telling the length of data written into the subbuffer (what you
> > guys call a "page", but what I still think might be worthy to be of
> > variable size, especially with a light locking infrastructure and
> > considering we might want to export this data to userspace).
> 
> But then you'd need a sub-buffer header, which in itself takes space,
> this padding solution seems like a fine middle-ground, it only takes
> space when you need it and it free otherwise.
> 
> The sub-buffer headers would always take space.
> 

Note that you already need to save the timestamp in the subbuffer
header. The question is : should we also save the unused size.

If we don't, keeping a padding event will likely :
- Rarely save space, given the variable size nature of event records,
  the likeliness of needing padding is pretty high. A padding event is
  bigger than just writing the unused size anyway, given the unused size
  can be written in a few bits for a page, but the padding event
  requires at least 8 bytes.
- Add complexity to the buffer structure; we have to make sure there is
  enough room in the page to write the padding event, have to make sure
  we support large padding events (> 28 bytes)...
- It also reserves an event ID, which could be used for other purposes.
  That means if we have 8 event IDs we which to write in a specific
  buffer (let's suppose they have a 0 bytes payload), we therefore need
  to increase the event size from 4-bytes to 8-bytes just because we
  reserved those IDs for "internal" (useless) purpose. OTOH, if we keep
  those IDs free to encode tracer-specific IDs, we can pack a lot of
  data in 4-bytes events rather than 8-bytes, which actually doubles the
  amount of events we can record.


> > RB_TYPE_TIME_EXTENT : I'd reserve a separate bit for this one.
> > 
> > Also, if size _really_ matters,
> 
> You and Martin have been telling it does ;-)
> 
> >  we should just export the event ID and
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
> > 
> > That's a bit bigger, but keeps the event size in the data stream.
> 
> I'm really not seeing what any of these proposals have on top of what
> Steve currently has. We have the ability to encode up to 28 bytes of
> payload in a 4 bytes header, which should suffice for most entries,
> right?
> 

The common entries would be under 28 bytes, right. But the thing is that
Steven's proposal uses 8 bytes for the _smallest_ event when we can in
fact cut that down to 4 bytes.


> > Also, nobody has explained successfully why we have to encode a time
> > _delta_ (current tsc - prev tsc) rather than just putting the LSBs. So
> > either I fail to see the light here (I doubt it), or I am not clear
> > enough when I say that we can just put the raw LSBs and compute the
> > delta afterward when reading the buffers, manage to keep the same
> > overflow detection power, and also keep the absolute value of the tsc
> > lsb, which makes it much easier to cross-check than "deltas".
> 
> Still not quite understanding where you get the MSBs from, how do you
> tell if two LSBs are from the same period?
> 

See my answer to Steven for this.

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
> Discarting the whole sub-buffer idea, it could be used to validate
> whichever time-stamp logic.
> 
> Personally I don't particulary like the sub-buffer concept, and I don't
> think we need it.
> 

Depends on the use-cases I guess, and on the locking used. My question
about this time-stamp is : shouldn't we, instead, put it in a page
header (exposed to userspace) rather than in this page frame, which I
believe is in a separate data structure (and not in the page per se) ?

> > I see that we could save the timestamp at which a subbuffer switch
> > happens (which in this patchset semantics happens to be a page), but why
> > would we every want to save that in the page frame ? Especially if we
> > simply write the LSBs instead of a time delta... Also, I would write
> > this timestamp in a subbuffer _header_ which is exported to userspace,
> 
> Why have sub-buffers at all?
> 

To support events larger than 4kB. Also, to support different backing
storage for the buffers without keeping a limitation specific a single
page-tied implementation of those.

> > but I clealry don't see why we keep it here. In addition, it's
> > completely wrong in a layered approach : if we want to switch from pages
> > to video memory or to a statically allocated buffer at boot time, such
> > "page-related" timestamp hacks won't do.
> 
> I don't think you _ever_ want to insert actual video memory in the
> trace, what you _might_ possibly want to do, is insert a copy of a
> frame, but that you can do with paged buffers like we have, just add an
> entry with 3840*1200*4 bytes (one screen in my case), and use sub-writes
> to copy everything to page-alinged chunks.
> 

No, no :) What I meant is : some people would like to _reserve_ part of
their video card memory so they can use it as backing storage for the
_buffers_. The benefit of doing that is that those buffers will survive
a hot reboot. Rather useful to debug kernel crashes. :)

Copying larger event payloads would actually require to reserve multiple
events in the trace, and would require a cookie or some locking to tell
that a given event is actually the follow-up of the previous one,
because with more evolved locking schemes, each event space reservation
is atomic and we can therefore not assume that a single payload splitted
in two events will be put contiguously in the trace buffers (can be
interrupted, preempted...).

> There is nothing techinically prohibiting this in Steve's scheme, except
> for Linus telling you you're an idiot for doing it.
> 
> The NOP packets you dislike allow us to align regular entries with page
> boundaries, which in turn allows this 0-copy stuff. If you use the
> sub-write iterator stuff we taked about a while ago, you can leave out
> the NOPs.
> 
> Having both makes sense (if you want the large packets stuff), use the
> regular page aligned 0-copy stuff for regular small packets, and use the
> sub-write iterator stuff for your huge packets.
> 

Sorry, I don't understand what the NOP packet gives you that the used
bytes amount in the subbuffer (page) header doesn't provide (given my
explanation above).


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
> 
> How does it differ from your linked list implementation? Reaslistically,
> we want but a single locking scheme for the trace buffer stuff. So
> factoring it out doesn't really make sense.
> 

My linked list implementation does not assume we have to do a "disable
interrupts" around the whole pointer manipulation, simply because there
isn't any complicated manipulation done. Actually, the only linked list
pointer manipulation I need to do a to atomically save one of three
pointers to cache the current page I am writing to/reading from/getting
the header pointer from.

> > Compared to this, I deal with buffer coherency with two 32 bits counters
> > in LTTng : a write offset and a consumer offset. (plus a per-subbuffer
> > commit count). 
> 
> I think that can work just fine on top of Steve's stuff too, it needs a
> bit of trimming etc.. but afaict there isn't anything stopping us from
> implementing his reserve function as light as you want:
> 
> int reserve(buffer, size, flags)
> {
>  preempt_disable()
>  cpu = smp_processor_id();
>  cpu_buf = buffer->buffers[cpu];
> 
>  if (cpu_buf->stop) {
>    ret = -EBUSY;
>    goto out;
>  }
> 
> again:
>  pos = cpu_buf->write_pos;
>  if (flags & CONTIG) {
>    new_pos = pos + size;
>  } else {
>    if (size > PAGE_SIZE) {
>      ret = -ENOSPACE;
>      goto out;
>    }
>    if ((pos + size) & PAGE_MASK != pos & PAGE_MASK) {
>      insert_nops();
>    }
>    new_pos = pos + size;
>  }
>  if (cmpxchg(&cpu_buf->write_pos, pos, new_pos) != pos)

How do you deal with his call to __rb_reserve_next which deals with page
change and plays with tail_page pointer ? This is where the whole
problem lays; you have to atomically update more than a single atomic
variable.

>    goto again;
>  return pos;
> 
> out:
>  preempt_enable();
>  return ret;
> }
> 
> If you put the offset&PAGE_MASK in each page-frame you can use that to
> easily detect when you need to flip to the next page.
> 

Exactly what I have in this patch.

> Which I imagine is similar to what you have... although I must admit to
> not being sure how to deal with over-write here, I guess your buffer
> must be large enough to ensure no nesting depth allows you to
> wrap-around while having an even un-commited.
> 

I deal with overwrite by looking that the commit count value of the
subbuffer (page) I am about to start writing into. If it's not a
multiple of subbuffer (page) size, then I consider the content of that
specific subbuffer as corrupted. And yes, it implies that nesting that
wraps around the number of subbuffers would cause (detected) data
corruption. If it ever happens, the corrupted subbuffers count will be
incremented and the given subbuffer will be overwritten (the subbuffer
commit count is reequilibrated at this moment). When the stale writer
will resume its execution, it will increment the commit count and
therefore cause a second subbuffer corruption. In the end, 2 subbuffers
will be dropped if this kind of situation happens. But I guess the rule
is to make sure nested writes does not overflow the complete buffer
size, or to simply make the buffers large enough.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
