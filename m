Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbZAGSyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbZAGSyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZAGSym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:54:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZAGSyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:54:41 -0500
Date: Wed, 7 Jan 2009 19:53:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ftrace: important updates
Message-ID: <20090107185349.GC16193@elte.hu>
References: <20090107041605.168020089@goodmis.org> <20090107094905.GB16025@elte.hu> <20090107195456.3247bab5@daedalus.pq.iki.fi> <alpine.DEB.1.10.0901071302260.17678@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901071302260.17678@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 7 Jan 2009, Pekka Paalanen wrote:
> 
> > On Wed, 7 Jan 2009 10:49:05 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > >       ring-buffer: rename debugfs file tracing_on to writing_enabled
> > > 
> > > writing_enabled is at least as confusing as tracing_on - if not more so.
> > > 
> > > The user really does not care about all the deeper machinery that happens 
> > > in ftrace - the difference between a 'light' disabling of a tracer and a 
> > > 'heavy' disabling of a tracer (which means it unregisters itself 
> > > completely in essence).
> > > 
> > > To resolve this, we should probably hide this difference altogether (as i 
> > > have suggested to do many months ago, when this first came up), by 
> > > removing tracing_enabled.
> > > 
> > > A tracer can still be fully unregistered: by simply switching the current 
> > > tracer to the 'nop' tracer. tracing_on/off remains the lightweight version 
> > > that most users are interested in anyway.
> > 
> > This sounds even better. We should not need tracing_enabled anymore, since
> > the buffer size can be changed regardless. tracing_on is more useful to
> > mmiotrace than tracing_enabled, too, since mmiotrace does not implement
> > the proper pausing behaviour on the tracing_enabled trigger.
> > 
> > But if Steven wants to keep the "pause" semantics, should there be a
> > callback dispatched to the tracer from tracing_on, just like there is
> > from tracing_enabled currently? Of course the callback semantics would
> > be different and the usual reaction would be to do nothing. It would
> > only be meaningful to tracers that update data outside the ring buffer,
> > so that they can properly pause.
> 
> The tracing_on is implemented by the ring buffer, and disables all ring 
> buffers, even those that are not part of ftrace. This file really has no 
> concept of a tracer. It simply stops writing to the ring buffer.
> 
> Things like the irq latency tracer is will still update its "max time" 
> when tracing is off, although the trace output will not be updated.
> 
> I could remove tracing_enabled, and move the tracing_on to trace.c, that 
> just calls the tracing_off of the ring buffer, and then the file will be 
> at the higher layer, and have a concept of the current tracer.

Sounds good to me. I think the highest utility is in the 'lightweight' 
tracing_on toggle - even though it does not do as thorough of a job of 
disabling a tracer as writing 0 to tracing_on.

I think we shouldnt even _try_ to provide a simple toggle for unregister: 
it is clear from looking at /debug/tracing/current_tracer that the current 
tracer is still active - so asking people to change that back to 'nop' 
will be rather intuitive IMO.

	Ingo
