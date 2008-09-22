Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYIVSux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYIVSux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYIVSuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:50:44 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:59936 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbYIVSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:50:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAGyG10hMQWq+/2dsb2JhbACBXbY7gWY
Date: Mon, 22 Sep 2008 14:45:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com
Subject: Re: Unified tracing buffer
Message-ID: <20080922184538.GB6349@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919231841.GB3456@redhat.com> <alpine.DEB.1.10.0809200435470.9362@gandalf.stny.rr.com> <20080920133752.GA23215@Krystal> <alpine.DEB.1.10.0809200946020.12824@gandalf.stny.rr.com> <alpine.DEB.1.10.0809201043490.13681@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809201043490.13681@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:44:11 up 109 days, 21:24,  7 users,  load average: 0.95, 1.21,
	1.15
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Sat, 20 Sep 2008, Steven Rostedt wrote:
> 
> > 
> > 
> > > > > 
> > > > Markers and the buffers are two separate things. Perhaps I'm just tired, 
> > > > but I'm thinking that you are thinking we are going to remove markers and 
> > > > trace points.
> > > > 
> > > > This code is only to give the kernel a ring buffer to use. Not a way to 
> > > > put hooks into kernel code. We have tracepoints and markers for that.
> > > > 
> > > 
> > > I think what Frank tries to express is that we would not lose any
> > > flexibility, but make life much easier for everyone, if we use the
> > > markers as the API to register event ids, keep their type table and to
> > > export the data at runtime.
> > 
> > No, absolutely not!
> > 
> > Sorry, I don't want to touch markers. I'm fine with tracepoints, but
> > there should be no need to use a damn marker if I want to use the tracer.
> > I shouldn't need to even touch tracepoints to use the trace buffer.
> > That is making things too complicated again. The tracepoints and markers 
> > should allow you to hook into the buffers. They are separate. I can 
> > imagine using tracepoints without needing buffers and I can see using the 
> > buffers without using tracepoints or markers. They are separate things. Do 
> > not bind the use of the buffers around markers.
> > 
> > 
> > Markers are great for you and for many others, but this is about the 
> > tracing mechanism and one should not be forced to use markers if they want 
> > to do a trace.
> > 
> 

Hi Steven,

As I expressed above, this is merely one way I propose data could be
exported to user-space. If you have other simpler design ideas in mind,
I look forward to hear them so we can discuss the technical difficulties
associated with that kind of exercice : sending binary data across the
kernel-userspace boundary.

See below for comments.

> Mathieu,
> 
> Think about the function tracer itself. It gets called at every funtion, 
> where I record the interrupts enabled state, task pid, preempt state, 
> function addr, and parent function addr. (that's just off the top of my 
> head, I may even record more).
> 
> What I don't want is a:
> 
> function_call(unsigned long func, unsigned long parent)
> {
> 	struct ftrace_event event;
> 
> 	event.pid = current->pid;
> 	event.pc = preempt_count();
> 	event.irq = local_irq_flags();
> 	event.func = func;
> 	event.parent = parent;
> 
> 	trace_mark(func_event_id, "%p",
> 		sizeof(event), &event);
> }
> 
> 
> and then to turn on function tracing, I need to hook into this marker. I'd 
> rather just push the data right into the buffer here without having to 
> make another function call to hook into this.
> 
> I'd rather have instead a simple:
> 
> 	struct ftrace_event *event;
> 
> 	event = ring_buffer_reserve(func_event_id,
> 				sizeof(*event));
> 
> 	event->pid = current->pid;
> 	event->pc = preempt_count();
> 	event->irq = local_irq_flags();
> 	event->func = func;
> 	event->parent = parent;
> 
> 	ring_buffer_commit(event);
> 

The scheme you propose here is based on a few inherent assumptions :

- You assume ring_buffer_reserve() and ring_buffer_commit() are static
  inline and thus does not turn into function calls.
- You assume these are small enough so they can be inlined without
  causing L1 insn cache trashing when tracing is activated.
- You therefore assume they use a locking scheme that lets them be
  really really compact (e.g. interrupt disable and spin lock).
- You assume that the performance impact of doing a function call is
  bigger than the impact of locking, which is false by at least a factor
  10.

Interrupt disable and spin locks are _really_ slow. So I think putting
the function call concern up front here is really a matter of premature
optimization gone wrong.

I've got burned in the past history of LTTng. The first versions has a
code generator which created specialized code to serialize the
information into the buffers, exactly like you propose to do. But the
overall impact on kernel code size ended up being too big because we
have to repeat all the code to deal with the buffers for every different
type.

However, I think there might be a way to satisfy us both. An information
source like dynamic function trace happen to fit in a particular
use-case where one single execution site is used to format the data
received as parameter for a _lot_ of instrumented sites, and the type
and event names happen to be the same everywhere. This would therefore
benefit widely of having the capability to write directly into the
buffers.

The thing is that I would like ftrace to expose the types it expects to
write into the trace buffers so a generic trace buffer userspace
consumer could read it.

One way to do it, which would let you write data directly into the
buffers, would be something like : (before anyone says "that's many
lines of code", please compile it and look at the assembly result. A lot
of this translates in precomputed values, especially for the event size
computation). (And no, the following code has not been compile-tested)

include/linux/someheader.h :

/* Calculate the offset needed to align the type */
static inline unsigned int var_align(size_t align_drift,
                 size_t size_of_type)
{
        size_t alignment = min(sizeof(void *), size_of_type);
        return ((alignment - align_drift) & (alignment-1));
}

kernel/trace/ftrace.c :

/*
 * the following macro would only do the "declaration" part of the
 * markers, without doing all the function call stuff.
 */
DECLARE_MARKER(function_entry,
  "pid %d pc %d flags %lu func 0x%lX parent 0x%lX");

void ftrace_mcount(unsigned long ip, unsigned long parent_ip)
{
  size_t ev_size = 0;
  char *buffer;

  /*
   * We assume event payload aligned on sizeof(void *).
   * Event size calculated statically.
   */
  ev_size += sizeof(int);
  ev_size += var_align(ev_size, sizeof(int));
  ev_size += sizeof(int);
  ev_size += var_align(ev_size, sizeof(unsigned long));
  ev_size += sizeof(unsigned long);
  ev_size += var_align(ev_size, sizeof(unsigned long));
  ev_size += sizeof(unsigned long);
  ev_size += var_align(ev_size, sizeof(unsigned long));
  ev_size += sizeof(unsigned long);

  /*
   * Now reserve space and copy data.
   */
  buffer = ring_buffer_reserve(func_event_id, ev_size);
  /* Write pid */
  *(int *)buffer = current->pid;
  buffer += sizeof(int);

  /* Write pc */
  buffer += var_align(buffer, sizeof(int));
  *(int *)buffer = preempt_count();
  buffer += sizeof(int);

  /* Write flags */
  buffer += var_align(buffer, sizeof(unsigned long));
  *(unsigned long *)buffer = local_irq_flags();
  buffer += sizeof(unsigned long);

  /* Write func */
  buffer += var_align(buffer, sizeof(unsigned long));
  *(unsigned long *)buffer = func;
  buffer += sizeof(unsigned long);

  /* Write parent */
  buffer += var_align(buffer, sizeof(unsigned long));
  *(unsigned long *)buffer = parent;
  buffer += sizeof(unsigned long);

  ring_buffer_commit(buffer, ev_size);
}


Would that be suitable for you ?

We could also think of passing the function pointer of the bin to ascii
converter to DECLARE_MARKER(), such as :

void function_entry_show(struct seq_file *m, char *buffer);

DECLARE_MARKER(function_entry, function_entry_show,
  "pid %d pc %d flags %lu func 0x%lX parent 0x%lX");

void function_entry_show(struct seq_file *m, char *buffer)
{
  /* Read pid */
  seq_printf(m, "pid = %d ", *(int *)buffer);
  buffer += sizeof(int);

  /* Read pc */
  buffer += var_align(buffer, sizeof(int));
  seq_printf(m, "pc = %d ", *(int *)buffer);
  buffer += sizeof(int);

  /* Read flags */
  buffer += var_align(buffer, sizeof(unsigned long));
  seq_printf(m, "flags = %lu ", *(unsigned long *)buffer);
  buffer += sizeof(unsigned long);

  /* Read func */
  buffer += var_align(buffer, sizeof(unsigned long));
  seq_printf(m, "func = 0x%lX ", *(unsigned long *)buffer);
  buffer += sizeof(unsigned long);

  /* Read parent */
  buffer += var_align(buffer, sizeof(unsigned long));
  seq_printf(m, "parent = 0x%lX ", *(unsigned long *)buffer);
  buffer += sizeof(unsigned long);
}

Note that in this particular case, given we would not need any special
"dump everything as if it was an unorganized array of bytes", the
function_entry_show() would be totally useless if we provide a sane
vsnprintf-like decoder based on the format string.

I did this example to show you how we could deal with the special cases
where people would be interested to write a whole network packet (or any
similar structure) directly to the trace (given it has field structures
which are not too tied to the compiler internals and has field sizes
portable across architectures). We could do this without much problem by
adding a format string type which specified such a binary blob, and we
could even leave room for people to provide their ascii formatting
function pointer, as shows my second example here.

Mathieu

> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
