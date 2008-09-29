Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYI2Qit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYI2Qit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYI2Qim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:38:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47095 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYI2Qil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:38:41 -0400
Date: Mon, 29 Sep 2008 12:38:39 -0400 (EDT)
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
In-Reply-To: <20080929155004.GA11029@Krystal>
Message-ID: <alpine.DEB.1.10.0809291224470.5493@gandalf.stny.rr.com>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <20080929155004.GA11029@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> Ok, I'll try to explain my point of view. The thing is : I want those
> binary buffers to be exported to userspace, and I fear that the approach
> taken by Steven (let's write "simple" C structure directly into the
> buffers) will in fact be much more _complex_ (due to subtle compiler
> dependencies) that doing our own event payload (event data) format.
> 
> Also, things such as 
> ring_buffer_lock: A way to lock the entire buffer.
> ring_buffer_unlock: unlock the buffer.
> will probably become a problem when trying to go for a more efficient
> locking scheme.

I plan on nuking the above for something better in v2.

> 
> ring_buffer_peek: Look at a next item in the cpu buffer.
> This kind of feature is useless for data extraction to userspace and
> poses serious synchronization concerns if you have other writers in the
> same buffer.

It absolutely important for ftrace.

> 
> Structure for event records :
> 
> struct ring_buffer_event {
>         u32 type:2, len:3, time_delta:27;
>         u32 array[];
> };
> 
> The only good thing about reserving 2 bits for event IDs in there is to
> put the most frequent events in those IDs, which is clearly not the
> case:
> RB_TYPE_PADDING: utterly useless. Can be expressed by a sub-buffer
> header telling the length of data written into the subbuffer (what you
> guys call a "page", but what I still think might be worthy to be of
> variable size, especially with a light locking infrastructure and
> considering we might want to export this data to userspace).

I now have both. But I think userspace can now easily see when there
is a place in the buffer that is empty.

> 
> RB_TYPE_TIME_EXTENT : I'd reserve a separate bit for this one.
> 
> Also, if size _really_ matters, we should just export the event ID and
> look up the event payload size through a separate table. If the payload
> consists of a binary blob, then the data structure should start by a
> payload size and then have a the actual binary blob.
> 
> struct ring_buffer_event {
>         u32 time_ext:1, evid:4, time_lsb:27;
>         union {
>           u32 array[];
>           struct {
>             u32 ext_id;
>             u32 array[];
>           };
>           struct {
>             u32 ext_time;
>             u32 array[];
>           };
>           struct {
>             u32 ext_time;
>             u32 ext_id;
>             u32 array[];
>           };
> };
> 
> Therefore we can encode up to 15 event IDs into this compact
> representation (we reserve ID 0xF for extended id). If we assign those
> IDs per subbuffer, it leaves plenty of room before we have to write a
> supplementary field for more IDs.

I wanted to push the event ids out of the ring buffer logic. Only a few 
internal ones are used.  Otherwise, we'll have one hell of a bit enum 
table with every freaking tracing type in it. That's what I want to avoid.


> 
> OTOH, if we really want to have an event size in there (which is more
> solid), we could have :
> 
> struct ring_buffer_event {
>         u32 time_ext:1, time_lsb:31;
>         u16 evid;
>         u16 evsize;
>         union {
>           u32 array[];
>           struct {
>             u32 ext_time;
>             u32 array[];
>           };
> };

My smallest record is 8 bytes. Yours now is 12.

> 
> That's a bit bigger, but keeps the event size in the data stream.

So does mine.

> 
> Also, nobody has explained successfully why we have to encode a time
> _delta_ (current tsc - prev tsc) rather than just putting the LSBs. So
> either I fail to see the light here (I doubt it), or I am not clear
> enough when I say that we can just put the raw LSBs and compute the
> delta afterward when reading the buffers, manage to keep the same
> overflow detection power, and also keep the absolute value of the tsc
> lsb, which makes it much easier to cross-check than "deltas".

Well, you need to record wraps. Probably more often then you record delta
wraps.

> 
> Now for the buffer pages implementation :
> 
> 
> +struct buffer_page {
> +       union {
> +               struct {
> +                       unsigned long flags;    /* mandatory */
> +                       atomic_t _count;        /* mandatory */
> +                       u64     time_stamp;     /* page time stamp */
> 
> Why should we ever associate a time stamp with a page ??

Because we save it on overwrite, which is the default mode for ftrace.

> 
> I see that we could save the timestamp at which a subbuffer switch
> happens (which in this patchset semantics happens to be a page), but why
> would we every want to save that in the page frame ? Especially if we
> simply write the LSBs instead of a time delta... Also, I would write

Where do you get the MSBs from?

> this timestamp in a subbuffer _header_ which is exported to userspace,

Well, our subbuffer header is the page frame.

> but I clealry don't see why we keep it here. In addition, it's
> completely wrong in a layered approach : if we want to switch from pages
> to video memory or to a statically allocated buffer at boot time, such
> "page-related" timestamp hacks won't do.

As Linus said, anything bigger than a page should be outside this buffer.
All the buffer would then need is a pointer to the data. Then the tracer
can figure out what to do with the rest of that.

> 
> +                       unsigned size;          /* size of page data */
> 
> This size should be exported to userspace, and therefore belongs to a
> subbuffer header, not to the page frame struct.

Again, page frame == sub buffer, period!

> 
> +                       struct list_head list;  /* linked list of free pages */
> 
> "free pages" ? Are those "free" ? What does free mean here ? If Steven

Bah, thanks. "free" is a misnomer.  It should just be list of pages.

> actually moves head and tail pointers to keep track of which pages data
> is written into, it will become an utter mess when we'll try to
> implement a lockless algorithm, since those are all non-atomic
> operations.

cmpxchg(head, old_head, head->next) ?

> 
> +               };
> +               struct page page;
> +       };
> +};
> 
> > As for the page-spanning entries, I think we can do that with Steve's
> > system just fine, its just that Linus said its a dumb idea and Steve
> > dropped it, but there is nothing fundamental stopping us from recording
> > a length that is > PAGE_SIZE and copying data into the pages one at a
> > time.
> > 
> > Nor do I see it impossible to implement splice on top of Steve's
> > ring-buffer..
> > 
> > So again, why?
> > 
> 
> I'd like to separate the layer which deals with data read/write from the
> layer which deals with synchronization of data write/read to/from the
> buffers so we can eventually switch to a locking mechanism which
> provides a sane performance level, and given Steven's linked list
> implementation, it will just add unneeded locking requirements.
> 
> Compared to this, I deal with buffer coherency with two 32 bits counters
> in LTTng : a write offset and a consumer offset. (plus a per-subbuffer
> commit count). I'd like to keep this semantic and yet support writing to
> non-vmap'd memory (which I do in the patch I propose). I'd just have to
> implement the splice operation in ltt-relay.c (the layer that sits on
> top of this patch).
> 

-- Steve

