Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYIXQvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYIXQvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYIXQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:51:35 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:43258 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbYIXQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:51:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEALYK2khMQWq+/2dsb2JhbACBXrwIgWU
Date: Wed, 24 Sep 2008 12:51:31 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Bligh <mbligh@google.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080924165131.GA1045@Krystal>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <20080924161347.GA31451@Krystal> <1222274361.16700.182.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222274361.16700.182.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:41:24 up 111 days, 21:21,  8 users,  load average: 1.54, 0.97,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2008-09-24 at 12:13 -0400, Mathieu Desnoyers wrote:
> > * Martin Bligh (mbligh@google.com) wrote:
> > > Thanks for creating this so quickly ;-)
> > > 
> > > >> We can record either the fast way of reserving a part of the buffer:
> > > >>
> > > >> event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
> > > >> event->data = record_this_data;
> > > >> ring_buffer_unlock_commit(buffer, event, flags);
> > > >
> > > > This can, in generic, not work. Due to the simple fact that we might
> > > > straddle a page boundary. Therefore I think its best to limit our self
> > > > to the write interface below, so that it can handle that.
> > > 
> > > I'm not sure why this is any harder to deal with in write, than it is
> > > in reserve? We should be able to make reserve handle this just
> > > as well?
> > > 
> > > If you use write rather than reserve, you have to copy all the data
> > > twice for every event.
> > > 
> > 
> > I think we all agree that a supplementary copy is no wanted, but I think
> > this question is orthogonal to having a write wrapper. 
> 
> >  This reserve/commit mechanism
> > deals with synchronization (cli/spinlock or cmpxchg_local scheme...).
> 
> Right
> 
> > We can then use this offset to see in which page(s) we have to write.
> > This offset + len can in fact cross multiple page boundaries.
> 
> Sure
> 
> > Doing this elegantly could involve a page array that would represent the
> > buffer data :
> > 
> > struct page **buffer;
> 
> I really don't like the page array, but we can do without..
> 
> > And be given as parameter to the read() and write() methods, which would
> > deal with page-crossing.
> > 
> > e.g.
> 
> > size_t write(struct page **buffer, size_t woffset, void *data, size_t len);
> > 
> > Therefore, we could have code which writes in the buffers, without extra
> > copy, and without using vmap, in multiple writes for a single event,
> > which would deal with data alignment, e.g. :
> > 
> > size_t woffset, evsize = 0;
> > 
> > evsize += write(NULL, evsize, &var1, sizeof(var1));
> > evsize += write(NULL, evsize, &var2, sizeof(var2));
> > evsize += write(NULL, evsize, &var3, sizeof(var3));
> > 
> > woffset = reserve(..., evsize);
> > 
> > woffset += write(buffer, woffset, &var1, sizeof(var1));
> > woffset += write(buffer, woffset, &var2, sizeof(var2));
> > woffset += write(buffer, woffset, &var3, sizeof(var3));
> > 
> > commit(..., evsize);
> > 
> > Does that make sense ?
> 
> Yes, we can do the sub-write, how about:
> 
> struct ringbuffer_write_state 
> ringbuffer_write_start(struct ringbuffer *buffer, unsigned long size);
> 
> int ringbuffer_write(struct ringbuffer_write_state *state, 
>                      const void *buf, unsigned long size);
> 
> void ringbuffer_write_finish(struct ringbuffer_write_state *state);
> 
> 
> That way write_start() can do the reserve and set a local write
> iterator. write() can then do whatever, either the direct copy of break
> it up - will error on overflowing the reserved size. write_finish() will
> clean up (sti, preempt_enable etc..)
> 

Yup, that looks neat. I don't know if it's worth separating data
alignment concerns from this part of the infrastructure so it stays
simple. OTOH, embedding automatic alignment of data elements would be
easy to do here, e.g. :

struct ringbuffer_write_state 
ringbuffer_write_start(struct ringbuffer *buffer, unsigned long size);

int ringbuffer_write(struct ringbuffer_write_state *state, 
                     const void *buf,
                     unsigned long size,
                     unsigned long alignment);

#define ringbuffer_compute_size(size, alignment) \
  ringbuffer_write(NULL, NULL, size, alignment)

void ringbuffer_write_finish(struct ringbuffer_write_state *state);

So ringbuffer_compute_size could be useds to compute the total slot size
needed to write the event before doing the ringbuffer_write_start(). It
would be good to keep ringbuffer_write() mostly as a static inline so
the compiler could statically compile in much of these operations.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
