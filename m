Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYIXPsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYIXPsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXPr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:47:59 -0400
Received: from smtp-out.google.com ([216.239.33.17]:63317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYIXPr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:47:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=T3wQII57My+QtJWW8r/awaipV38tyr6tUOANXMWa20CuWhajXlfiITJ2TKwaJT+Kj
	KRdL/PULB9t19Ql2zusuw==
Message-ID: <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
Date: Wed, 24 Sep 2008 08:47:42 -0700
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
In-Reply-To: <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
X-GMailtapped-By: 172.24.198.85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for creating this so quickly ;-)

>> We can record either the fast way of reserving a part of the buffer:
>>
>> event = ring_buffer_lock_reserve(buffer, event_id, length, &flags);
>> event->data = record_this_data;
>> ring_buffer_unlock_commit(buffer, event, flags);
>
> This can, in generic, not work. Due to the simple fact that we might
> straddle a page boundary. Therefore I think its best to limit our self
> to the write interface below, so that it can handle that.

I'm not sure why this is any harder to deal with in write, than it is
in reserve? We should be able to make reserve handle this just
as well?

If you use write rather than reserve, you have to copy all the data
twice for every event.

> On top of that foundation build an eventbuffer, which knows about
> encoding/decoding/printing events.
>
> This too needs to be a flexible layer -

That would be nice. However, we need to keep at least the length
and timestamp fields common so we can do parsing and the mergesort?

+struct ring_buffer_event {
+       unsigned long long counter;
+       short type;
+       short length;
+       char body[];
+} __attribute__((__packed__))

So type would move into the body here?

> as I suspect the google guys
> will want their ultra-compressed events back.

Is useful when gathering GB of data across 10,000 machines ;-)
Also reduces general overhead for everyone to keep events small.
