Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYIXQ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYIXQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYIXQ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYIXQ0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:26:16 -0400
Date: Wed, 24 Sep 2008 12:26:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0809241214190.5017@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Peter Zijlstra wrote:

> On Wed, 2008-09-24 at 08:47 -0700, Martin Bligh wrote:
> > Thanks for creating this so quickly ;-)
> > 
> > >> We can record either the fast way of reserving a part of the buffer:
> > >>
> > >> event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
> > >> event->data = record_this_data;
> > >> ring_buffer_unlock_commit(buffer, event, flags);
> > >
> > > This can, in generic, not work. Due to the simple fact that we might
> > > straddle a page boundary. Therefore I think its best to limit our self
> > > to the write interface below, so that it can handle that.
> > 
> > I'm not sure why this is any harder to deal with in write, than it is
> > in reserve? We should be able to make reserve handle this just
> > as well?
> 
> No, imagine the mentioned case where we're straddling a page boundary.
> 
> A----|   |----B
>     ^------|

This would not happen. The ring buffer reserve routine will take care of 
it. If the requested length will straddle a page, I add a "nop" event
into the end of A, and give the user a pointer starting at B.

 A----|  |-----B
     ^^  ^
   |nop| +---- record.

> 
> So when we reserve we get a pointer into page A, but our reserve length
> will run over into page B. A write() method will know how to check for
> this and break up the memcpy to copy up-to the end of A and continue
> into B.
> 
> You cannot expect the reserve/commit interface users to do this
> correctly - it would also require one to expose too much internals,
> you'd need to be able to locate page B for starters.
> 
> > If you use write rather than reserve, you have to copy all the data
> > twice for every event.
> 
> Well, once. I'm not seeing where the second copy comes from.

I'll give you the ftrace example. In ftrace we record the task pid,
preempt count, and interrupt flags.  The reserve commit way is this.

event = ring_buffer_reserve(buffer, sizeof(*event));
event->pid = current->pid;
event->pc = preempt_count();
event->flags = flags;
ring_buffer_commit(buffer, event);

Done! One copy of all this data directly into the buffer. But if we use
the write method that you propose:

struct event event;

event.pid = current->pid;
event.pc = preempt_count();
event.flags = flags;
ring_buffer_write(buffer, &event, sizeof(event));

One copy into event has been done, but we are not done yet. Inside the
write we need to do a...

memcopy(buffer->buf, data, size);

There's the second copy. No way around it.

> > > On top of that foundation build an eventbuffer, which knows about
> > > encoding/decoding/printing events.
> > >
> > > This too needs to be a flexible layer -
> > 
> > That would be nice. However, we need to keep at least the length
> > and timestamp fields common so we can do parsing and the mergesort?
> 
> And here I was thinking you guys bit encoded the event id into the
> timestamp delta :-)
> 
> > +struct ring_buffer_event {
> > +       unsigned long long counter;
> > +       short type;
> > +       short length;
> > +       char body[];
> > +} __attribute__((__packed__))
> > 
> > So type would move into the body here?
> 
> All of it would, basically I have no notion of an event in the
> ringbuffer API. You write $something and your read routine would need to
> be smart enough to figure it out.

Logdev has an internal buffer that does exactly what you are proposing.
I had to give it some minor smarts to improve preformance, and stability.
If you don't even have the length then it is over when you wrap. The
There's no way to know where the next record starts. It gets ugly with
callbacks.

Giving the ring buffer at least the length as a minimum, is what is 
needed. And as I have that nop id as well, I would need to put that
either into a type field or counter (I currently use both for these 
patches).

> 
> The trivial case is a fixed size entry, in which case you always know
> how much to read. A slightly more involved but still easy to understand
> example might be a 7bit encoding and using the 8th bit for continuation.

ftrace is proving to be a pain with this regard.

> 
> Another option is to start out with a fixed sized header that contains a
> length field.

As a minimum, sure.

> 
> But the raw ringbuffer layer, the one concerned with fiddling the pages
> and writing/reading thereto need not be aware of anything else.

As I have learned from both ftrace and logdev, giving the ring buffer a
little intelligence, has paid off a lot. I will say, I have not hit that
minimum with my patches. But I will argue that you are going beneath that
threshold.

> 
> > > as I suspect the google guys
> > > will want their ultra-compressed events back.
> > 
> > Is useful when gathering GB of data across 10,000 machines ;-)
> > Also reduces general overhead for everyone to keep events small.
> 
> Exactly - which is why a flexible encoding layer makes sense to me -
> aside from the abstraction itself.

But being too minimal and flexible, will actually be counter productive. 
That is, you will not be able to enhance it due to the lack of abilities.

That is, the top layers will now be limited.

-- Steve

