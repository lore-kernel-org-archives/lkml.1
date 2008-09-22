Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYIVN76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYIVN76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYIVN7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:59:50 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:49480 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222AbYIVN7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:59:49 -0400
Date: Mon, 22 Sep 2008 19:27:23 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Martin Bligh <mbligh@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, zanussi@comcast.net
Subject: Re: Unified tracing buffer
Message-ID: <20080922135723.GA5279@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 02:33:42PM -0700, Martin Bligh wrote:
> During kernel summit and Plumbers conference, Linus and others
> expressed a desire for a unified
> tracing buffer system for multiple tracing applications (eg ftrace,
> lttng, systemtap, blktrace, etc) to use.
> This provides several advantages, including the ability to interleave
> data from multiple sources,
> not having to learn 200 different tools, duplicated code/effort, etc.
> 

With due apologies for pitching-in late, I thought I'd bring visibility to
the two new interfaces - namely relay_printk() and relay_dump() - now a part
of -mm tree (since 2.6.27-rc5-mm1) are meant to address such needs;
although not completely in its present form but quite substantially.
(Refer: Documentation/filesystems/relay.txt). As far as re-usability is
concerned, many parts of this interface are directly adopted from
SystemTap's runtime. Blktrace had been made to work using these interfaces
(http://tinyurl.com/4q9d4p) reducing about ~130 lines of code from the
blktrace related files.

With more effort, say additions such as a)ability to specify custom
names for files b)ability to create user-defined control files (in
addition to what comes default) will make it usable along with tracers
such as ftrace (ref:http://tinyurl.com/3ppbwh) (and is something that I
intended to work upon).

While relay_printk() interface brings a high-level abstract interface
over 'relay' by masking all the setup/tear-down details and the ability
to use per-CPU buffers; relay_dump() is its equivalent that performs
binary dumping through debugfs interface (a requirement for the unified
tracing buffer, as I learn from the email). Also the use of default
file-names, debugfs output path results in huge reduction of setup code
required by the end-user along with the ability to override the defaults
if required in a special case. Examples of the resulting code-brevity can
be seen at samples/relay/*.c in 2.6.27-rc5-mm1 tree.

I am quite sure that with minimal changes to infrastructure underlying
beneath these two interfaces, we can meet out most of the requirements
stated above; and am open for suggestions.

Kindly let me know what the community thinks about the same.

Thanks,
K.Prasad

> Several of us got together last night and tried to cut this down to
> the simplest usable system
> we could agree on (and nobody got hurt!). This will form version 1.
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
> 
> Circular buffer per cpu, protected by per-cpu spinlock_irq
> Word aligned records.
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
>     provides a way to enable/disable events, see what's available, and
> what's enabled.
> 
> 
> KNOWN ISSUES / PLANS
> -------------------
> 
> No way to unregister buffers and events.
>     Will provide an unregister_buffer and unregister_event call
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
