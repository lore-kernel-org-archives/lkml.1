Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIXRuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIXRuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:50:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYIXRuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:50:01 -0400
Date: Wed, 24 Sep 2008 13:49:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Wed, 24 Sep 2008, Martin Bligh wrote:
> > 
> > Can't the reserve interface just put a padding event into page A,
> > or otherwise mark it, and return the start of page B?
> 
> Yes, I think having a "padding" entry that just gets skipped on read would 
> simplify things. Use that to fill up the end of the page.

Yep, that is what the RFC patch did.

> 
> > > And here I was thinking you guys bit encoded the event id into the
> > > timestamp delta :-)
> > 
> > +/* header plus 32-bits of event data */
> > +struct ktrace_entry {
> > +       u32 event_type:5, tsc_shifted:27;
> > +       u32 data;
> > +};
> > 
> > was our basic data type. So ... sort of ;-)
> 
> Why "tsc_shifted"?
> 
> I think 27 bits is probably fine, but not by removing precision. Instead 
> of shifting it so it will fit (and dropping low bits as uninteresting), do 
> it by encoding it as a delta against the previous thing. 27 bits would 
> still be sufficient for any high-performance thing that has tons and tons 
> of packets, and if you only have a few trace events you can afford to have 
> the "TSC overflow" event type (and if you want it that dense, you could 
> just make 'data' be the high bits, for a total of 59 bits rather than 64 
> bits of TSC.
> 
> 59 bits of cycle counters is perfectly fine unless you are talking trace 
> events over a year or so (I didn't do the math, but let's assume a 4GHz 
> TSC as a reasonable thing even going forward - even _if_ CPU's get faster 
> than that, the TSC is unlikely to tick faster since it's just not worth it 
> from a power standpoint).
> 
> Ok, I did the math. 1<<27 seconds (assuming the low 32 bits are just 
> fractions) is something like 4+ years. I _really_ don't think we need more 
> than that (or even close to that) in TSC timestamps for tracing within one 
> single buffer.
> 
> Once you go to the next ring buffer, you'd get a new time-base anyway.

Right now I have a list of pages that make up the ring buffer. Are you 
saying that the first entry in the page should be a timestamp?

Anyway, after talking with Peter Zijlstra, I'm working on RFC-v2, which
splits up the ring buffer a bit more. I'm removing all the debugfs crud, 
and I even will remove the merge sort from the ring buffer.

I will now have a ring_buffer API, which will do basic recording. It will 
have two modes when allocated. Fixed sized entry mode where you can just 
put whatever you want in (I'm still aligning everything by 8 bytes, just 
since memory is cheap). Or you can have variable length mode that will 
make the following event header:

struct {
	unsigned char length;
	unsigned char buff[];
};

The length will be shifted 3 since we are 8 byte aligned anyway, making 
the largest entry 2046 bytes (2045 bytes of data since 1 byte is already 
taken for the length field). If the next entry is not large enough to fit
on the page, I will enter a zero length and that will tell the tracer that 
the entry is padding to the end of the page.

For fixed sized entries, a simple calculation of whether an entry can fit 
on a page will determine if there is an entry or padding.

Then I will add a trace_buffer API that will add the counting and merge 
sort on top of this interface. If you don't care about the 
trace_buffering, one could simply use the ring_buffering and be done with 
it.

Note, I am still keeping the reserve and commit interface for now.

-- Steve

