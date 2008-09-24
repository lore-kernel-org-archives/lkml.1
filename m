Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYIXQu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYIXQu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYIXQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:49:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:13323 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754402AbYIXQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:49:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=Re0MV7QnOLrog7NG09jS+iGcvdRT4NrY3PsX3DhYl317ld7cwGIQqPfoqgXF/E0J0
	m2zfM17c5HGE5duCrH47w==
Message-ID: <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:49:25 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
X-GMailtapped-By: 172.28.16.146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm not sure why this is any harder to deal with in write, than it is
>> in reserve? We should be able to make reserve handle this just
>> as well?
>
> No, imagine the mentioned case where we're straddling a page boundary.
>
> A----|   |----B
>    ^------|
>
> So when we reserve we get a pointer into page A, but our reserve length
> will run over into page B. A write() method will know how to check for
> this and break up the memcpy to copy up-to the end of A and continue
> into B.
>
> You cannot expect the reserve/commit interface users to do this
> correctly - it would also require one to expose too much internals,
> you'd need to be able to locate page B for starters.

Can't the reserve interface just put a padding event into page A,
or otherwise mark it, and return the start of page B?

>> If you use write rather than reserve, you have to copy all the data
>> twice for every event.
>
> Well, once. I'm not seeing where the second copy comes from.

Depends how you count ;-) One more time than you would have to
with reserve - the temporarily packed structure doesn't exist.

>> > On top of that foundation build an eventbuffer, which knows about
>> > encoding/decoding/printing events.
>> >
>> > This too needs to be a flexible layer -
>>
>> That would be nice. However, we need to keep at least the length
>> and timestamp fields common so we can do parsing and the mergesort?
>
> And here I was thinking you guys bit encoded the event id into the
> timestamp delta :-)

+/* header plus 32-bits of event data */
+struct ktrace_entry {
+       u32 event_type:5, tsc_shifted:27;
+       u32 data;
+};

was our basic data type. So ... sort of ;-)

>> So type would move into the body here?
>
> All of it would, basically I have no notion of an event in the
> ringbuffer API. You write $something and your read routine would need to
> be smart enough to figure it out.

If you don't have timestamps, you need domain-specific context to merge
the per-cpu buffers back together. As long as these are common format
amongst all the event-level alternatives, I guess it doesn't matter.

> Another option is to start out with a fixed sized header that contains a
> length field.

That's what we discussed at KS/plumbers, and seems like the simplest
option by far to start with.

> But the raw ringbuffer layer, the one concerned with fiddling the pages
> and writing/reading thereto need not be aware of anything else.

When you loop around the ringbuffer, you need to shift the starting "read"
pointer up to the next event, don't you? How do you do that to start on
a whole event without knowing the event size?

> Exactly - which is why a flexible encoding layer makes sense to me -
> aside from the abstraction itself.

I like the abstraction, yes ;-) Just not convinced how much we can put in it.
