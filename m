Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYIYRQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYIYRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYIYRQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:16:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34665 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYIYRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:16:49 -0400
Date: Thu, 25 Sep 2008 13:16:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/2 v2] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251312010.27920@gandalf.stny.rr.com>
References: <20080925155807.158539649@goodmis.org> <20080925160048.641420646@goodmis.org> <alpine.LFD.1.10.0809250952460.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Linus Torvalds wrote:
> On Thu, 25 Sep 2008, Steven Rostedt wrote:
> > +
> > +/**
> > + * ring_buffer_event_length - return the length of the event
> > + * @event: the event to get the length of
> > + *
> > + * Note, if the event is bigger than 256 bytes, the length
> > + * can not be held in the shifted 5 bits. The length is then
> > + * added as a short (unshifted) in the body.
> 
> The comment seems stale ;)

hehe, this code is in so much flux, that I gave up on keeping the
comments up to date.

> 
> > +
> > +/**
> > + * ring_buffer_peek - peek at the next event to be read
> > + * @iter: The ring buffer iterator
> > + * @iter_next_cpu: The CPU that the next event belongs on
> > + *
> > + * This will return the event that will be read next, but does
> > + * not increment the iterator.
> > + */
> > +struct ring_buffer_event *
> > +ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
> > +{
> > +	struct ring_buffer_per_cpu *cpu_buffer;
> > +	struct ring_buffer_event *event;
> > +	u64 delta;
> > +
> > +	cpu_buffer = buffer->buffers[cpu];
> > +
> > + again:
> > +	if (ring_buffer_per_cpu_empty(cpu_buffer))
> > +		return NULL;
> > +
> > +	event = ring_buffer_head_event(cpu_buffer);
> > +
> > +	switch (event->type) {
> > +	case RB_TYPE_PADDING:
> > +		ring_buffer_inc_page(buffer, &cpu_buffer->head_page);
> > +		rb_reset_read_page(cpu_buffer);
> > +		goto again;
> > +
> > +	case RB_TYPE_TIME_EXTENT:
> > +		delta = event->data;
> > +		delta <<= TS_SHIFT;
> > +		delta += event->time_delta;
> > +		cpu_buffer->read_stamp += delta;
> > +		goto again;
> > +
> > +	case RB_TYPE_TIME_STAMP:
> > +		/* FIXME: not implemented */
> > +		goto again;
> > +
> > +	case RB_TYPE_SMALL_DATA:
> > +	case RB_TYPE_LARGE_DATA:
> > +	case RB_TYPE_STRING:
> > +		if (ts)
> > +			*ts = cpu_buffer->read_stamp + event->time_delta;
> > +		return event;
> 
> Your timestamp handling seems odd. You do it per-event, but I think it 
> should happen for all events, ie just do
> 
> 	*ts += event->time_delta;
> 
> _outside_ the case statement, and then in RB_TYPE_TIME_EXTENT you'd do 
> either
> 
>  - relative:
> 	*ts += event->data << TS_SHIFT;
> 
>  - absolute timestamp events:
> 	*ts = (event->data << TS_SHIFT) + event->time_delta;
> 
> but the bigger issue is that I think the timestamp should be relative to 
> the _previous_ event, not relative to the page start. IOW, you really 
> should accumulate them. 
> 
> IOW, the base timestamp cannot be in the cpu_buffer, it needs to be in the 
> iterator data structure, since it updates as you walk over it.
> 
> Otherwise the extended TSC format will be _horrible_. You don't want to 
> add it in front of every event in the page just because you had a pause at 
> the beginning of the page. You want to have a running update, so that you 
> only need to add it after there was a pause.

The problem with this is overwrite mode, which is the only mode ftace 
currently offers. What happens when your writer starts overwriting the 
ring buffer and there is no reader?

What happens is that the start value is gone. You do not have a way to use 
all the deltas to catch up to the remaining events.

-- Steve
