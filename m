Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYITAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYITAIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYITAIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:08:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYITAIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:08:23 -0400
Subject: Re: Unified tracing buffer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Bligh <mbligh@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 20 Sep 2008 02:07:58 +0200
Message-Id: <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oddly whitespace damaged mail..

On Fri, 2008-09-19 at 14:33 -0700, Martin Bligh wrote:
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

I'd hoped for an interface like:

struct ringbuffer *ringbuffer_alloc(const char *name, size_t size);
void ringbuffer_free(struct ringbuffer *buffer);
int ringbuffer_write(struct ringbuffer *buffer, const char *buf, size_t size);
int ringbuffer_read(struct ringbuffer *buffer, int cpu, char *buf, size_t size);

On top of which you'd do the event thing, the register event with a
callback idea makes sense, except I'd split the consumption into two:
 - one method to pull the binary event out, which knows how long it
ought to be etc..
 - one method to convert the binary event to ASCII

You don't always need the latter one, esp if you're dumping to disk.

You can also generalize the merge sorting forward iterator when you have
that, by providing an event compare function.

By doing it like this folks can focus on utterly optimizing the
ringbuffer to death, and other folks can toy around with doing fancy
event encodings (/me pitches asn.1-der encoded structured data and runs
like crazy)



