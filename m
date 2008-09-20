Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYITJDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYITJDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 05:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYITJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 05:03:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYITJDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 05:03:35 -0400
Date: Sat, 20 Sep 2008 05:03:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809200451420.9362@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Martin,

First I like to express my appreciation to you for writing this up. Not 
only that, but being the one person from keeping us from killing each 
other ;-)


On Fri, 19 Sep 2008, Martin Bligh wrote:

> During kernel summit and Plumbers conference, Linus and others
> expressed a desire for a unified
> tracing buffer system for multiple tracing applications (eg ftrace,
> lttng, systemtap, blktrace, etc) to use.
> This provides several advantages, including the ability to interleave
> data from multiple sources,
> not having to learn 200 different tools, duplicated code/effort, etc.
> 
> Several of us got together last night and tried to cut this down to
> the simplest usable system
> we could agree on (and nobody got hurt!). This will form version 1.

Yes, we kept the chairs on the floor the whole time.

> I've sketched out a few
> enhancements we know that we want, but have agreed to leave these
> until version 2.
> The answer to most questions about the below is "yes we know, we'll
> fix that in version 2"
> (or 3). Simplicity was the rule ...
> 
> Sketch of design.  Enjoy flaming me. Code will follow shortly.
> 
> 
> STORAGE
> -------
> 
> We will support multiple buffers for different tracing systems, with
> separate names, event id spaces.
> Event ids are 16 bit, dynamically allocated.
> A "one line of text" print function will be provided for each event,
> or use the default (probably hex printf)
> Will provide a "flight data recorder" mode, and a "spool to disk" mode.

I don't remember talking about the "spool to disk" for version 1.
We still want to do this? I thought we would have overwrite mode (flight
data record), and a "throw all new data away when the producer fills the 
buffer before the consumer takes" mode.

> 
> Circular buffer per cpu, protected by per-cpu spinlock_irq
> Word aligned records.

As stated in another email "8 byte aligned" words should be fine.

> Variable record length, header will start with length record.
> Timestamps in fixed timebase, monotonically increasing (across all CPUs)
> 
> 
> INPUT_FUNCTIONS
> ---------------
> 
> allocate_buffer (name, size)
>         return buffer_handle
> 
> register_event (buffer_handle, event_id, print_function)
>         You can pass in a requested event_id from a fixed set, and
> will be given it, or an error
>         0 means allocate me one dynamically
>         returns event_id     (or -E_ERROR)
> 
> record_event (buffer_handle, event_id, length, *buf)

I was talking with Thomas about this, and we probably want (and I'm sure 
Mathieu and others would agree), a...

  event_handle = reserve_event(buffer_handle, event_id, length)

as well as a..

  comit_event(event_handle).


Oh, and all commands should start with the namespace.

  ring_buffer_alloc()
  ring_buffer_free()
  ring_buffer_record_event()

  etc.

> 
> 
> OUTPUT
> ------
> 
> Data will be output via debugfs, and provide the following output streams:
> 
> /debugfs/tracing/<name>/buffers/text
>     clear text stream (will merge the per-cpu streams via insertion
> sort, and use the print functions)
> 
> /debugfs/tracing/<name>/buffers/binary[cpu_number]
>     per-cpu binary data

Ah, I thought we were going to have:

  /debugfs/tracing/buffers/<name>/<buffer crap>

and each tracer have

  /debugfs/tracing/<name>/<trace command crap>

This way we can easily see all the buffers in one place that are allocated
without having to see a tracer name first.

The reason I like the way I propose, is that a utility that needs to read 
all the buffers, doesn't need to go into directories that don't even have 
buffers. Not all tracers will allocate a buffer.


> 
> 
> CONTROL
> -------
> 
> Sysfs style tree under debugfs
> 
> /debugfs/tracing/<name>/buffers/enabed         <--- binary value
> 
> /debugfs/tracing/<name>/<event1>
> /debugfs/tracing/<name>/<event2>
>     etc ...

I wonder if we should make this another sub dir:

 /debugfs/tracing/buffers/events/<event-name>


>     provides a way to enable/disable events, see what's available, and
> what's enabled.
> 
> 
> KNOWN ISSUES / PLANS
> -------------------
> 
> No way to unregister buffers and events.
>     Will provide an unregister_buffer and unregister_event call

I can see registering events, but shouldn't we "allocate" buffers?

> 
> 
> Generating systemwide time is hard on some platforms
>     Yes. Time-based output provides a lot of simplicity for the user though
>     We won't support these platforms at first, we'll add functionality
> to make it work for them later.
>     (plan based on tick-based ms timing, plus counter offset from that
> if needed).
> 
> Spinlock_irq is ineffecient, and doesn't support tracing in NMIs
>     True. We'll implement a lockless scheme later (see lttng)
> 
> Putting a length record in every event is inefficient
>     True. Fixed record length with optional extensions is better, but
> more complex. v2.
> 
> Putting a full timestamp rather than an offset in every event is inefficient
>     See above. True, but v2.
> 
> Relayfs already exists! use that!
>     People were universally not keen on that idea. Complexity, interface, etc.
>     We're also providing some higher level shared functions for time &
> event ids.
> 
> There's no way to decode the binary data stream
>     Code will be shared from the kernel to decode it, so that we can
> get the compact binary
>     format and decode it later. That code will be kept in the kernel
> tree (it's a trivial piece of C).
>     Version 1.1 ;-)
> 

Sounds good,

Thanks!

-- Steve

