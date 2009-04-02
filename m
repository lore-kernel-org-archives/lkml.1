Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbZDBNIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbZDBNIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 09:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZDBNIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:08:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbZDBNIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:08:24 -0400
Date: Thu, 2 Apr 2009 09:08:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/4] ring-buffer: add ring_buffer_discard_commit
In-Reply-To: <20090401224814.a1c533ba.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904020905020.30963@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org> <20090402053522.594497414@goodmis.org> <20090401224814.a1c533ba.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Apr 2009, Andrew Morton wrote:

> On Thu, 02 Apr 2009 01:27:24 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The ring_buffer_discard_commit is similar to ring_buffer_event_discard
> > but it can only be done on an event that has yet to be commited.
> > Unpredictable results can happen otherwise.
> > 
> > The main difference between ring_buffer_discard_commit and
> > ring_buffer_event_discard is that ring_buffer_discard_commit will try
> > to free the data in the ring buffer if nothing has addded data
> > after the reserved event. If something did, then it acts almost the
> > same as ring_buffer_event_discard followed by a
> > ring_buffer_unlock_commit.
> > 
> > Note, either ring_buffer_commit_discard and ring_buffer_unlock_commit
> > can be called on an event, not both.
> > 
> > This commit also exports both discard functions to be usable by
> > GPL modules.
> > 
> > ...
> >
> > +/*
> > + * ring_buffer_event_discard can discard any event in the ring buffer.
> > + *   it is up to the caller to protect against a reader from
> > + *   consuming it or a writer from wrapping and replacing it.
> > + *
> > + * No external protection is needed if this is called before
> > + * the event is commited. But in that case it would be better to
> > + * use ring_buffer_discard_commit.
> > + *
> > + * Note, if an event that has not been committed is discarded
> > + * with ring_buffer_event_discard, it must still be committed.
> > + */
> >  void ring_buffer_event_discard(struct ring_buffer_event *event);
> >  
> > ...
> >
> >  /**
> > + * ring_buffer_event_discard - discard any event in the ring buffer
> > + * @event: the event to discard
> > + *
> > + * Sometimes a event that is in the ring buffer needs to be ignored.
> > + * This function lets the user discard an event in the ring buffer
> > + * and then that event will not be read later.
> > + *
> > + * Note, it is up to the user to be careful with this, and protect
> > + * against races. If the user discards an event that has been consumed
> > + * it is possible that it could corrupt the ring buffer.
> > + */
> > +void ring_buffer_event_discard(struct ring_buffer_event *event)
> > +{
> > +	event->type = RINGBUF_TYPE_PADDING;
> > +	/* time delta must be non zero */
> > +	if (!event->time_delta)
> > +		event->time_delta = 1;
> > +}
> > +EXPORT_SYMBOL_GPL(ring_buffer_event_discard);
> 
> Seems a bit cumbersome to document the interface partly in the .h file
> and partly in the .c file?
> 
> Doing all of it in the .c file would be typical.

I thought the full documentation was in the .c file. I actually added the 
.h documentation because I was afraid that developers would just look at 
the header file and pick the wrong option. The kernel-doc documentation is 
for the C file. The .h file was a quick reference for those that wanted to 
know which function they needed. Since the two are similar, I wanted to 
make it clear what the differences were both in the .c and .h files.

It would even remind me on which to use ;-)

-- Steve

