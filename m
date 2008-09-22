Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYIVOJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYIVOJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYIVOJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:09:40 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:55252 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752281AbYIVOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:09:39 -0400
Date: Mon, 22 Sep 2008 19:37:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, zanussi@comcast.net
Subject: Re: Unified tracing buffer
Message-ID: <20080922140740.GB5279@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 02:07:58AM +0200, Peter Zijlstra wrote:
> Oddly whitespace damaged mail..
> 
> On Fri, 2008-09-19 at 14:33 -0700, Martin Bligh wrote:
> > During kernel summit and Plumbers conference, Linus and others
> > expressed a desire for a unified
> > tracing buffer system for multiple tracing applications (eg ftrace,
> > lttng, systemtap, blktrace, etc) to use.
> > This provides several advantages, including the ability to interleave
> > data from multiple sources,
> > not having to learn 200 different tools, duplicated code/effort, etc.
> > 
> > Several of us got together last night and tried to cut this down to
> > the simplest usable system
> > we could agree on (and nobody got hurt!). This will form version 1.
> > I've sketched out a few
> > enhancements we know that we want, but have agreed to leave these
> > until version 2.
> > The answer to most questions about the below is "yes we know, we'll
> > fix that in version 2"
> > (or 3). Simplicity was the rule ...
> > 
> > Sketch of design.  Enjoy flaming me. Code will follow shortly.
> > 
> > 
> > STORAGE
> > -------
> > 
> > We will support multiple buffers for different tracing systems, with
> > separate names, event id spaces.
> > Event ids are 16 bit, dynamically allocated.
> > A "one line of text" print function will be provided for each event,
> > or use the default (probably hex printf)
> > Will provide a "flight data recorder" mode, and a "spool to disk" mode.
> > 
> > Circular buffer per cpu, protected by per-cpu spinlock_irq
> > Word aligned records.
> > Variable record length, header will start with length record.
> > Timestamps in fixed timebase, monotonically increasing (across all CPUs)
> > 
> > 
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
> I'd hoped for an interface like:
> 
> struct ringbuffer *ringbuffer_alloc(const char *name, size_t size);
> void ringbuffer_free(struct ringbuffer *buffer);
> int ringbuffer_write(struct ringbuffer *buffer, const char *buf, size_t size);
> int ringbuffer_read(struct ringbuffer *buffer, int cpu, char *buf, size_t size);
> 
> On top of which you'd do the event thing, the register event with a
> callback idea makes sense, except I'd split the consumption into two:
>  - one method to pull the binary event out, which knows how long it
> ought to be etc..
>  - one method to convert the binary event to ASCII
>
In conjunction with the previous email on this thread
(http://lkml.org/lkml/2008/9/22/160), may I suggest
the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:

relay_printk(<some struct with default filenames/pathnames>, <string>,
...) ;
relay_dump(<some struct with default filenames/pathnames>, <binary
data>);
and
relay_cleanup_all(<the struct name>); - Single interface that cleans up
all files/directories/output data created under a logical entity.

Thanks,
K.Prasad

