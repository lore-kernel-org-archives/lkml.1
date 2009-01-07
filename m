Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZAGSMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZAGSMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZAGSMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:12:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbZAGSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:12:31 -0500
Date: Wed, 7 Jan 2009 13:12:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ftrace: important updates
In-Reply-To: <20090107195456.3247bab5@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0901071302260.17678@gandalf.stny.rr.com>
References: <20090107041605.168020089@goodmis.org> <20090107094905.GB16025@elte.hu> <20090107195456.3247bab5@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 Jan 2009, Pekka Paalanen wrote:

> On Wed, 7 Jan 2009 10:49:05 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > >       ring-buffer: rename debugfs file tracing_on to writing_enabled
> > 
> > writing_enabled is at least as confusing as tracing_on - if not more so.
> > 
> > The user really does not care about all the deeper machinery that happens 
> > in ftrace - the difference between a 'light' disabling of a tracer and a 
> > 'heavy' disabling of a tracer (which means it unregisters itself 
> > completely in essence).
> > 
> > To resolve this, we should probably hide this difference altogether (as i 
> > have suggested to do many months ago, when this first came up), by 
> > removing tracing_enabled.
> > 
> > A tracer can still be fully unregistered: by simply switching the current 
> > tracer to the 'nop' tracer. tracing_on/off remains the lightweight version 
> > that most users are interested in anyway.
> 
> This sounds even better. We should not need tracing_enabled anymore, since
> the buffer size can be changed regardless. tracing_on is more useful to
> mmiotrace than tracing_enabled, too, since mmiotrace does not implement
> the proper pausing behaviour on the tracing_enabled trigger.
> 
> But if Steven wants to keep the "pause" semantics, should there be a
> callback dispatched to the tracer from tracing_on, just like there is
> from tracing_enabled currently? Of course the callback semantics would
> be different and the usual reaction would be to do nothing. It would
> only be meaningful to tracers that update data outside the ring buffer,
> so that they can properly pause.

The tracing_on is implemented by the ring buffer, and disables all ring 
buffers, even those that are not part of ftrace. This file really has no 
concept of a tracer. It simply stops writing to the ring buffer.

Things like the irq latency tracer is will still update its "max time" 
when tracing is off, although the trace output will not be updated.

I could remove tracing_enabled, and move the tracing_on to trace.c,
that just calls the tracing_off of the ring buffer, and then the file will 
be at the higher layer, and have a concept of the current tracer.

-- Steve

