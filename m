Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYIXU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYIXU5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYIXU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:57:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbYIXU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:56:58 -0400
Date: Wed, 24 Sep 2008 13:49:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@google.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080924180100.GA4374@Krystal>
Message-ID: <alpine.LFD.1.10.0809241341120.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809240921430.3265@nehalem.linux-foundation.org> <20080924180100.GA4374@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Mathieu Desnoyers wrote:
>
>                    [...] Those will likely be low event-rate
> situations where it is useful to take a bigger snapshot of a problematic
> condition, but still to have it synchronized with the rest of the trace
> data. e.g. :
> 
> - Writing a whole video frame into the trace upon video card glitch.
> - Writing a jumbo frame (up to 9000 bytes) into the buffer when a
>   network card error is detected or when some iptables rules (LOG, TRACE
>   ?) are reached.
> - Dumping a kernel stack (potentially 8KB) in a single event when a
>   kernel OOPS is reached.
> - Dumping a userspace process stack into the trace upon SIGILL, SIGSEGV
>   and friends.

But these are _all_ things that would be much better off with a "allocate 
a separate buffer, and just add a pointer to the trace".

Why? If for no other reason than the fact that we don't even want to spend 
lots of time to (atomically) have to copy the big data into the trace 
buffer!

Just allocate the buffer and fill it in (maybe it's pre-allocated already, 
like when a network packet event happens!) and do all of that 
independently of the low-level trace code. And then add the trace with the 
pointer.

We want the low-level trace code to be useful for things like interrupt 
events etc, which makes it a _disaster_ to try to add huge buffers 
directly to the ring buffer. You also don't want to allocate a 
multi-megabyte ring buffer for some odd case that happens rarely, when you 
can allocate the big memory users dynamically.

So limiting a trace entry to 4kB does not mean that you can't add more 
than 4kB to the trace - it just means that you need to have a "data 
indirection" trace type. Nothing more, nothing less.

[ And btw - you'd need that *anyway* for other reasons. You also don't 
  want to have any length fields have to be 32-bit lengths etc - the 
  length field of the trace buffer entry should be something really small 
  like 8 or 16 bits, or even be implicit in the type for some basic event 
  types, so that a trace event doesn't necessarily waste any bits at ALL 
  on the length field ]

		Linus
