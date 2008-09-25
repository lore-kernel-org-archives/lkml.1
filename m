Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYIYRVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYIYRVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYIYRVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:21:06 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:64612 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292AbYIYRVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:21:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABNi20hMQWq+/2dsb2JhbACBXrk4gWU
Date: Thu, 25 Sep 2008 13:15:59 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925171559.GB29392@Krystal>
References: <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net> <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org> <20080924205334.GB12248@Krystal> <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:38:11 up 112 days, 21:18, 10 users,  load average: 1.39, 1.54,
	1.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 24 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > The reason why Martin did use only a 27 bits TSC in ktrace was that they
> > were statically limited to 32 event types.
> 
> Well, I actually think we could do the same - for the "internal" types.
> 
> So why not do something like 4-5 bits for the basic type information, and 
> then oen of those cases is a "freeform" thing, and the others are reserved 
> for other uses.
> 
> So a trace entry header could easily look something like
> 
> 	struct trace_entry {
> 		u32 tsc_delta:27,
> 		     type:5;
> 		u32 data;
> 		u64 array[];
> 	}
> 
> and then depending on the that 5-bit type, the "data" field in the header 
> means different things, and the size of the trace_entry also is different.
> 
> So it could be something like
> 
>  - case 0: EnfOfPage marker
> 	(data is ignored)
> 	size = 8
> 

We could use a page header instead to contain the "unused_size"
information. It does not need to be an event per se. Putting this
information in the page header makes it easy for a consumer to just read
the amount of bytes needed, excluding the padding (turns up to be useful
for network streaming of trace data). Also, it frees up one event ID for
other uses. I think the event ID real estate is pretty important,
because every event ID we don't keep for "internal uses" could be used
to encode standard tracer event IDs.


>  - case 1: TSCExtend marker
> 	data = extended TSC (bits 28..59)
> 	size = 8
> 

I would prefer to put the extended timestamp within the event header
instead of creating a separate entry for this for atomicity concerns
(what happens if a long interrupt executes between the TSCExtend marker
event and the event expecting to be written right next to it ?). If we
choose to have such "full tsc" event headers, we would have to reserve 1
selection bit. It leaves us 4 bits for event IDs. If we remove
heartbeats, we need even less "internal" IDs.

Given that we can allocate event IDs per buffer, if in general we assume
that buffer users will have few event IDs, I think we can find a way to
minimize the number of "internal" event IDs and keep possibly all the 4
bits (16 IDs) for real tracer events. One way to achieve it is to encode
the extra typing information within a table (dumped in a separate buffer)
indexed by event ID.


>  - case 2: TimeStamp marker
> 	data = tv_nsec
> 	array[0] = tv_sec
> 	size = 16
> 

This one could even be a standard event put in a single buffer. There is
no need to repeat it in various buffers all over the place.

>  - case 3: LargeBinaryBlob marker
> 	data = 32-bit length of binary data
> 	array[0] = 64-bit pointer to binary blob
> 	array[1] = 64-bit pointer to "free" function
> 	size = 24
> 
>  - case 4: SmallBinaryBlob marker
> 	data = inline length in bytes, must be < 4096
> 	array[0..(len+7)/8] = inline data, padded
> 	size = (len+15) & ~7
> 
>  - case 5: AsciiFormat marker
> 	data = number of arguments
> 	array[0] = 64-bit pointer to static const format string
> 	array[1..arg] = argument values
> 	size = 8*(2+arg)
> 
>   ...
> 
> ie we use a few bits for "trace _internal_ type fields", and then for a 
> few of those types we have internal meanings, and other types just means 
> that the user can fill in the data itself.
> 
> IOW, you _could_ have an interface like
> 
> 	ascii_marker_2(ringbuffer,
> 		"Reading sector %lu-%lu",
> 		sector, sector+nsec);
> 
> and what it would create would be a fairly small trace packet that looks 
> something like
> 
> 	.type = 5,
> 	.tsc_delta = ...,
> 	.data = 2,
> 	.array[0] = (const char *) "Reading sector %lu-%lu\n"
> 	.array[1] = xx,
> 	.array[2] = yy
> 

I agree that exporting semantic information is important. Moreover, I
think this should also be made available when the trace is exported in
binary format to userspace. The markers currently in mainline has been
designed to do this efficiently. With small adaptation of the markers,
one could do a :

  trace_mark(block, read,
             "Reading sector sec_from to sec_to",
             "sec_from %lu sec_to %lu",
             sector, sector + nsec);

The nice part about the markers is that it keeps tables for the
description "Reading sector sec_from to sec_to" and the typing
information "sec_from %lu sec_to %lu" in a separate section. Therefore,
we only need to dump this information once (at trace start or when the
module containing this specific marker is loaded). It automatically
deals with module load/unload and does not require to write their format
string in the trace buffers.

The strings can be looked up by a userspace pretty-printer by dumping a
table mapping event IDs to marker names, which in turn map to
description and event types. This implies creating a small "metadata"
buffer along with each data transfer buffer to export these tables. This
metadata buffer must be read first to get the event typing information,
and then the userspace program is all set to pretty-print the binary
information.

An efficient ID -> format string mapping could also be kept around in
the kernel (or built on demand) to simplify the task for an in-kernel
pretty-printer.

Mathieu

> and you would not actually print it out as ASCII until somebody read it 
> from the kernel (and any "binary" interface would get the string as a 
> string, not as a pointer, because the pointer is obviously meaningless 
> outside the kernel.
> 
> Also note how you'd literally just have a single copy of the string, 
> because the rule would be that a trace user must use a static string, not 
> some generated one that can go away (module unloading would need to be 
> aware of any trace buffer entries, of course - perhaps by just disallowing 
> unloading while trace buffers are active).
> 
> And note! Everything above is meant as an example of something that 
> _could_ work. I do like the notion of putting pointers to strings in the 
> markers, rather than having some odd magic numerical meaning that user 
> space has to just magically know that "event type 56 for ring buffer type 
> 171 means that there are two words that mean 'sector' and 'end-sector' 
> respectively".
> 
> But it's still meant more as an RFC. But I think it could work.
> 
> 		Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
