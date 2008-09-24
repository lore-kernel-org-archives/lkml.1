Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYIXQM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYIXQM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYIXQMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:12:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYIXQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:12:47 -0400
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Bligh <mbligh@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 18:11:25 +0200
Message-Id: <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 08:47 -0700, Martin Bligh wrote:
> Thanks for creating this so quickly ;-)
> 
> >> We can record either the fast way of reserving a part of the buffer:
> >>
> >> event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
> >> event->data = record_this_data;
> >> ring_buffer_unlock_commit(buffer, event, flags);
> >
> > This can, in generic, not work. Due to the simple fact that we might
> > straddle a page boundary. Therefore I think its best to limit our self
> > to the write interface below, so that it can handle that.
> 
> I'm not sure why this is any harder to deal with in write, than it is
> in reserve? We should be able to make reserve handle this just
> as well?

No, imagine the mentioned case where we're straddling a page boundary.

A----|   |----B
    ^------|

So when we reserve we get a pointer into page A, but our reserve length
will run over into page B. A write() method will know how to check for
this and break up the memcpy to copy up-to the end of A and continue
into B.

You cannot expect the reserve/commit interface users to do this
correctly - it would also require one to expose too much internals,
you'd need to be able to locate page B for starters.

> If you use write rather than reserve, you have to copy all the data
> twice for every event.

Well, once. I'm not seeing where the second copy comes from.

> > On top of that foundation build an eventbuffer, which knows about
> > encoding/decoding/printing events.
> >
> > This too needs to be a flexible layer -
> 
> That would be nice. However, we need to keep at least the length
> and timestamp fields common so we can do parsing and the mergesort?

And here I was thinking you guys bit encoded the event id into the
timestamp delta :-)

> +struct ring_buffer_event {
> +       unsigned long long counter;
> +       short type;
> +       short length;
> +       char body[];
> +} __attribute__((__packed__))
> 
> So type would move into the body here?

All of it would, basically I have no notion of an event in the
ringbuffer API. You write $something and your read routine would need to
be smart enough to figure it out.

The trivial case is a fixed size entry, in which case you always know
how much to read. A slightly more involved but still easy to understand
example might be a 7bit encoding and using the 8th bit for continuation.

Another option is to start out with a fixed sized header that contains a
length field.

But the raw ringbuffer layer, the one concerned with fiddling the pages
and writing/reading thereto need not be aware of anything else.

> > as I suspect the google guys
> > will want their ultra-compressed events back.
> 
> Is useful when gathering GB of data across 10,000 machines ;-)
> Also reduces general overhead for everyone to keep events small.

Exactly - which is why a flexible encoding layer makes sense to me -
aside from the abstraction itself.

