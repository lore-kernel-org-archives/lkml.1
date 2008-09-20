Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYITOzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYITOzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYITOyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:54:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYITOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:54:55 -0400
Date: Sat, 20 Sep 2008 10:54:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: "Frank Ch. Eigler" <fche@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com
Subject: Re: Unified tracing buffer
In-Reply-To: <alpine.DEB.1.10.0809200946020.12824@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0809201043490.13681@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919231841.GB3456@redhat.com> <alpine.DEB.1.10.0809200435470.9362@gandalf.stny.rr.com> <20080920133752.GA23215@Krystal> <alpine.DEB.1.10.0809200946020.12824@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Sep 2008, Steven Rostedt wrote:

> 
> 
> > > > 
> > > Markers and the buffers are two separate things. Perhaps I'm just tired, 
> > > but I'm thinking that you are thinking we are going to remove markers and 
> > > trace points.
> > > 
> > > This code is only to give the kernel a ring buffer to use. Not a way to 
> > > put hooks into kernel code. We have tracepoints and markers for that.
> > > 
> > 
> > I think what Frank tries to express is that we would not lose any
> > flexibility, but make life much easier for everyone, if we use the
> > markers as the API to register event ids, keep their type table and to
> > export the data at runtime.
> 
> No, absolutely not!
> 
> Sorry, I don't want to touch markers. I'm fine with tracepoints, but
> there should be no need to use a damn marker if I want to use the tracer.
> I shouldn't need to even touch tracepoints to use the trace buffer.
> That is making things too complicated again. The tracepoints and markers 
> should allow you to hook into the buffers. They are separate. I can 
> imagine using tracepoints without needing buffers and I can see using the 
> buffers without using tracepoints or markers. They are separate things. Do 
> not bind the use of the buffers around markers.
> 
> 
> Markers are great for you and for many others, but this is about the 
> tracing mechanism and one should not be forced to use markers if they want 
> to do a trace.
> 

Mathieu,

Think about the function tracer itself. It gets called at every funtion, 
where I record the interrupts enabled state, task pid, preempt state, 
function addr, and parent function addr. (that's just off the top of my 
head, I may even record more).

What I don't want is a:

function_call(unsigned long func, unsigned long parent)
{
	struct ftrace_event event;

	event.pid = current->pid;
	event.pc = preempt_count();
	event.irq = local_irq_flags();
	event.func = func;
	event.parent = parent;

	trace_mark(func_event_id, "%p",
		sizeof(event), &event);
}


and then to turn on function tracing, I need to hook into this marker. I'd 
rather just push the data right into the buffer here without having to 
make another function call to hook into this.

I'd rather have instead a simple:

	struct ftrace_event *event;

	event = ring_buffer_reserve(func_event_id,
				sizeof(*event));

	event->pid = current->pid;
	event->pc = preempt_count();
	event->irq = local_irq_flags();
	event->func = func;
	event->parent = parent;

	ring_buffer_commit(event);


-- Steve

