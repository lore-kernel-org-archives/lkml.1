Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYISVeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYISVeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYISVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:33:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23499 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYISVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:33:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=YRQpGeaNS6lxom3PvTBZ+eMApFuoUv0tElRiNtJSQLqw5CIjlYVjvRrHSR/G+xe8S
	IzW+vxqiY8kVPQUKrsXIg==
Message-ID: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:33:42 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Unified tracing buffer
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During kernel summit and Plumbers conference, Linus and others
expressed a desire for a unified
tracing buffer system for multiple tracing applications (eg ftrace,
lttng, systemtap, blktrace, etc) to use.
This provides several advantages, including the ability to interleave
data from multiple sources,
not having to learn 200 different tools, duplicated code/effort, etc.

Several of us got together last night and tried to cut this down to
the simplest usable system
we could agree on (and nobody got hurt!). This will form version 1.
I've sketched out a few
enhancements we know that we want, but have agreed to leave these
until version 2.
The answer to most questions about the below is "yes we know, we'll
fix that in version 2"
(or 3). Simplicity was the rule ...

Sketch of design.  Enjoy flaming me. Code will follow shortly.


STORAGE
-------

We will support multiple buffers for different tracing systems, with
separate names, event id spaces.
Event ids are 16 bit, dynamically allocated.
A "one line of text" print function will be provided for each event,
or use the default (probably hex printf)
Will provide a "flight data recorder" mode, and a "spool to disk" mode.

Circular buffer per cpu, protected by per-cpu spinlock_irq
Word aligned records.
Variable record length, header will start with length record.
Timestamps in fixed timebase, monotonically increasing (across all CPUs)


INPUT_FUNCTIONS
---------------

allocate_buffer (name, size)
        return buffer_handle

register_event (buffer_handle, event_id, print_function)
        You can pass in a requested event_id from a fixed set, and
will be given it, or an error
        0 means allocate me one dynamically
        returns event_id     (or -E_ERROR)

record_event (buffer_handle, event_id, length, *buf)


OUTPUT
------

Data will be output via debugfs, and provide the following output streams:

/debugfs/tracing/<name>/buffers/text
    clear text stream (will merge the per-cpu streams via insertion
sort, and use the print functions)

/debugfs/tracing/<name>/buffers/binary[cpu_number]
    per-cpu binary data


CONTROL
-------

Sysfs style tree under debugfs

/debugfs/tracing/<name>/buffers/enabed         <--- binary value

/debugfs/tracing/<name>/<event1>
/debugfs/tracing/<name>/<event2>
    etc ...
    provides a way to enable/disable events, see what's available, and
what's enabled.


KNOWN ISSUES / PLANS
-------------------

No way to unregister buffers and events.
    Will provide an unregister_buffer and unregister_event call


Generating systemwide time is hard on some platforms
    Yes. Time-based output provides a lot of simplicity for the user though
    We won't support these platforms at first, we'll add functionality
to make it work for them later.
    (plan based on tick-based ms timing, plus counter offset from that
if needed).

Spinlock_irq is ineffecient, and doesn't support tracing in NMIs
    True. We'll implement a lockless scheme later (see lttng)

Putting a length record in every event is inefficient
    True. Fixed record length with optional extensions is better, but
more complex. v2.

Putting a full timestamp rather than an offset in every event is inefficient
    See above. True, but v2.

Relayfs already exists! use that!
    People were universally not keen on that idea. Complexity, interface, etc.
    We're also providing some higher level shared functions for time &
event ids.

There's no way to decode the binary data stream
    Code will be shared from the kernel to decode it, so that we can
get the compact binary
    format and decode it later. That code will be kept in the kernel
tree (it's a trivial piece of C).
    Version 1.1 ;-)
