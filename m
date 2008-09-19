Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYISXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYISXUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYISXUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:20:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISXUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:20:41 -0400
Date: Fri, 19 Sep 2008 19:18:41 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Martin Bligh <mbligh@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com
Subject: Re: Unified tracing buffer
Message-ID: <20080919231841.GB3456@redhat.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


On Fri, Sep 19, 2008 at 02:33:42PM -0700, Martin Bligh wrote:

> During kernel summit and Plumbers conference, Linus and others
> expressed a desire for a unified tracing buffer system for multiple
> tracing applications (eg ftrace, lttng, systemtap, blktrace, etc) to
> use.

OK.


> [...]
> STORAGE
> -------
> 
> We will support multiple buffers for different tracing systems, with
> separate names, event id spaces. [...]

OK.  This is completely orthogonal to ...


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

How do you imagine record_event() being used from the point of view of
the instrumented module?  Is it to be protected by some sort of test
of the control variable?  Is the little binary event buffer supposed
to be constructed unconditionally?  (On the stack?)


You should compare this to markers and tracepoints.  It sounds to me like
this is not that different from

     trace_mark (event_name, "%*b", length, buf);

where the goofy "%*b" could be some magic to identify the proposed
"everything is a short blob" event record type.

By the way, systemtap supports formatted printing that generates
binary records via directives like "%4b" for 4-byte ints.  I wonder if
that would be a suitable facility for this and/or markers to allow
instrumentation code to *generate* those binary event records.


Do you believe that fans of tracepoints would support a single
void*/length struct parametrization?



> Data will be output via debugfs, and provide the following output streams:
> 
> /debugfs/tracing/<name>/buffers/text
>     clear text stream (will merge the per-cpu streams via insertion
> sort, and use the print functions)

Can you spell out this part a little more?  I wonder because at the
tracing miniconf on Wednesday we talked about systemtap's likely need
to *consume* these trace events as they are being generated.

If systemtap can only see them as a binary blob or a rendered ascii
string, they would not be as useful as if the record was decomposable
in kernel.  Perhaps the event-type-registration call can declare the
binary struct, like a perl pack directive ... or a marker (binary)
format string.


> CONTROL
> 
> Sysfs style tree under debugfs
> 
> /debugfs/tracing/<name>/buffers/enabed         <--- binary value
> 
> /debugfs/tracing/<name>/<event1>
> /debugfs/tracing/<name>/<event2>
>     etc ...
>     provides a way to enable/disable events, see what's available, and
> what's enabled.

This sort of control is (or should be) already available for markers.


- FChE
