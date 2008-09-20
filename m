Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbYITIuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbYITIuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYITIuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:50:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYITIuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:50:07 -0400
Date: Sat, 20 Sep 2008 04:50:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, od@novell.com
Subject: Re: Unified tracing buffer
In-Reply-To: <20080919231841.GB3456@redhat.com>
Message-ID: <alpine.DEB.1.10.0809200435470.9362@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919231841.GB3456@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Note, It is very late for me and I probably should be finishing up 
packing for my trip home, but I'm stupid and decided to respond now 
instead ]


On Fri, 19 Sep 2008, Frank Ch. Eigler wrote:

> Hi -
> 
> 
> On Fri, Sep 19, 2008 at 02:33:42PM -0700, Martin Bligh wrote:
> 
> > During kernel summit and Plumbers conference, Linus and others
> > expressed a desire for a unified tracing buffer system for multiple
> > tracing applications (eg ftrace, lttng, systemtap, blktrace, etc) to
> > use.
> 
> OK.
> 
> 
> > [...]
> > STORAGE
> > -------
> > 
> > We will support multiple buffers for different tracing systems, with
> > separate names, event id spaces. [...]
> 
> OK.  This is completely orthogonal to ...
> 
> 
> > INPUT_FUNCTIONS
> > ---------------
> > 
> > allocate_buffer (name, size)
> >         return buffer_handle
> > 
> > register_event (buffer_handle, event_id, print_function)
> >         You can pass in a requested event_id from a fixed set, and
> > will be given it, or an error
> >         0 means allocate me one dynamically
> >         returns event_id     (or -E_ERROR)
> > 
> > record_event (buffer_handle, event_id, length, *buf)
> 
> How do you imagine record_event() being used from the point of view of
> the instrumented module?  Is it to be protected by some sort of test
> of the control variable?  Is the little binary event buffer supposed
> to be constructed unconditionally?  (On the stack?)

The event buffer is allocated when you create the buffer. The tracer will 
do that on initialization.

> 
> 
> You should compare this to markers and tracepoints.  It sounds to me like
> this is not that different from
> 
>      trace_mark (event_name, "%*b", length, buf);
> 
> where the goofy "%*b" could be some magic to identify the proposed
> "everything is a short blob" event record type.

This is completely separate from the trace buffer itself. The trace points 
and trace markers simply write whatever they want into the trace buffer.
The tracepoints and trace markers are something to hook points of code to 
do some type of tracing. The trace buffer record_event is how it will do 
it if it chooses to do so.

> 
> By the way, systemtap supports formatted printing that generates
> binary records via directives like "%4b" for 4-byte ints.  I wonder if
> that would be a suitable facility for this and/or markers to allow
> instrumentation code to *generate* those binary event records.
> 

The tracepoints and markers can generate anything they want.

> 
> Do you believe that fans of tracepoints would support a single
> void*/length struct parametrization?

The "record_event" would not (I repeat, "not") be in general code. It will 
be used by the different tracers. The markers/tracepoints will be in the 
code that can hooked to do things like profiling, or if you want, record 
the data into the trace buffer via the record event.

> 
> 
> 
> > Data will be output via debugfs, and provide the following output streams:
> > 
> > /debugfs/tracing/<name>/buffers/text
> >     clear text stream (will merge the per-cpu streams via insertion
> > sort, and use the print functions)
> 
> Can you spell out this part a little more?  I wonder because at the
> tracing miniconf on Wednesday we talked about systemtap's likely need
> to *consume* these trace events as they are being generated.

What does this mean exactly. I should have asked more details about this
but I was too worried about time constraints (since Linus was speaking 
next to think about it at the time.

That is, when you read a marker, who and when does that data get consumed?
Where does that data go? Do you even need to store it in this ring buffer?

> 
> If systemtap can only see them as a binary blob or a rendered ascii
> string, they would not be as useful as if the record was decomposable
> in kernel.  Perhaps the event-type-registration call can declare the
> binary struct, like a perl pack directive ... or a marker (binary)
> format string.

I don't understand the above. I'm also thinking that we are 
miscommunicating a bit here.

Let make make an example with something that I know, ftrace.

We hit the tracepoint in, lets say, scheduler. Previously at 
initialization time, ftrace would have registered with this trace point 
and would have allocated a buffer. When the tracepoint is actually hit, it 
jumps to the function that ftrace registered. Then this function would 
record the event into the buffer using 'record_event'. At a later time, 
the user could read the buffer from the filesystem using either the pretty 
print format or raw binary format.

This code is not replacing tracepoints or markers. When you say you will 
consume at reading, it sounds like you don't even need to use the buffer 
mechanism and the trace points/markers is good enough for you. The 
tracepoints and markers are not something that is being replaced. The 
trace buffers are just something to use that we can record data to that we 
can retrieve at a later time.

> 
> 
> > CONTROL
> > 
> > Sysfs style tree under debugfs
> > 
> > /debugfs/tracing/<name>/buffers/enabed         <--- binary value
> > 
> > /debugfs/tracing/<name>/<event1>
> > /debugfs/tracing/<name>/<event2>
> >     etc ...
> >     provides a way to enable/disable events, see what's available, and
> > what's enabled.
> 
> This sort of control is (or should be) already available for markers.

Markers and the buffers are two separate things. Perhaps I'm just tired, 
but I'm thinking that you are thinking we are going to remove markers and 
trace points.

This code is only to give the kernel a ring buffer to use. Not a way to 
put hooks into kernel code. We have tracepoints and markers for that.

-- Steve

