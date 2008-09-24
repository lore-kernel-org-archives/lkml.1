Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYIXWah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYIXWah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYIXWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335AbYIXWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:30:28 -0400
Date: Wed, 24 Sep 2008 15:28:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080924205334.GB12248@Krystal>
Message-ID: <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
 <20080924205334.GB12248@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Mathieu Desnoyers wrote:
> 
> The reason why Martin did use only a 27 bits TSC in ktrace was that they
> were statically limited to 32 event types.

Well, I actually think we could do the same - for the "internal" types.

So why not do something like 4-5 bits for the basic type information, and 
then oen of those cases is a "freeform" thing, and the others are reserved 
for other uses.

So a trace entry header could easily look something like

	struct trace_entry {
		u32 tsc_delta:27,
		     type:5;
		u32 data;
		u64 array[];
	}

and then depending on the that 5-bit type, the "data" field in the header 
means different things, and the size of the trace_entry also is different.

So it could be something like

 - case 0: EnfOfPage marker
	(data is ignored)
	size = 8

 - case 1: TSCExtend marker
	data = extended TSC (bits 28..59)
	size = 8

 - case 2: TimeStamp marker
	data = tv_nsec
	array[0] = tv_sec
	size = 16

 - case 3: LargeBinaryBlob marker
	data = 32-bit length of binary data
	array[0] = 64-bit pointer to binary blob
	array[1] = 64-bit pointer to "free" function
	size = 24

 - case 4: SmallBinaryBlob marker
	data = inline length in bytes, must be < 4096
	array[0..(len+7)/8] = inline data, padded
	size = (len+15) & ~7

 - case 5: AsciiFormat marker
	data = number of arguments
	array[0] = 64-bit pointer to static const format string
	array[1..arg] = argument values
	size = 8*(2+arg)

  ...

ie we use a few bits for "trace _internal_ type fields", and then for a 
few of those types we have internal meanings, and other types just means 
that the user can fill in the data itself.

IOW, you _could_ have an interface like

	ascii_marker_2(ringbuffer,
		"Reading sector %lu-%lu",
		sector, sector+nsec);

and what it would create would be a fairly small trace packet that looks 
something like

	.type = 5,
	.tsc_delta = ...,
	.data = 2,
	.array[0] = (const char *) "Reading sector %lu-%lu\n"
	.array[1] = xx,
	.array[2] = yy

and you would not actually print it out as ASCII until somebody read it 
from the kernel (and any "binary" interface would get the string as a 
string, not as a pointer, because the pointer is obviously meaningless 
outside the kernel.

Also note how you'd literally just have a single copy of the string, 
because the rule would be that a trace user must use a static string, not 
some generated one that can go away (module unloading would need to be 
aware of any trace buffer entries, of course - perhaps by just disallowing 
unloading while trace buffers are active).

And note! Everything above is meant as an example of something that 
_could_ work. I do like the notion of putting pointers to strings in the 
markers, rather than having some odd magic numerical meaning that user 
space has to just magically know that "event type 56 for ring buffer type 
171 means that there are two words that mean 'sector' and 'end-sector' 
respectively".

But it's still meant more as an RFC. But I think it could work.

		Linus
