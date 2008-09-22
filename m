Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbYIVVjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbYIVVjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIVVj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:39:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYIVVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:39:26 -0400
Date: Mon, 22 Sep 2008 17:39:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: "Frank Ch. Eigler" <fche@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com
Subject: Re: Unified tracing buffer
In-Reply-To: <20080922184538.GB6349@Krystal>
Message-ID: <alpine.DEB.1.10.0809221734510.23852@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919231841.GB3456@redhat.com> <alpine.DEB.1.10.0809200435470.9362@gandalf.stny.rr.com> <20080920133752.GA23215@Krystal> <alpine.DEB.1.10.0809200946020.12824@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0809201043490.13681@gandalf.stny.rr.com> <20080922184538.GB6349@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Sep 2008, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> > 
> > Think about the function tracer itself. It gets called at every funtion, 
> > where I record the interrupts enabled state, task pid, preempt state, 
> > function addr, and parent function addr. (that's just off the top of my 
> > head, I may even record more).
> > 
> > What I don't want is a:
> > 
> > function_call(unsigned long func, unsigned long parent)
> > {
> > 	struct ftrace_event event;
> > 
> > 	event.pid = current->pid;
> > 	event.pc = preempt_count();
> > 	event.irq = local_irq_flags();
> > 	event.func = func;
> > 	event.parent = parent;
> > 
> > 	trace_mark(func_event_id, "%p",
> > 		sizeof(event), &event);
> > }
> > 
> > 
> > and then to turn on function tracing, I need to hook into this marker. I'd 
> > rather just push the data right into the buffer here without having to 
> > make another function call to hook into this.
> > 
> > I'd rather have instead a simple:
> > 
> > 	struct ftrace_event *event;
> > 
> > 	event = ring_buffer_reserve(func_event_id,
> > 				sizeof(*event));
> > 
> > 	event->pid = current->pid;
> > 	event->pc = preempt_count();
> > 	event->irq = local_irq_flags();
> > 	event->func = func;
> > 	event->parent = parent;
> > 
> > 	ring_buffer_commit(event);
> > 
> 
> The scheme you propose here is based on a few inherent assumptions :
> 
> - You assume ring_buffer_reserve() and ring_buffer_commit() are static
>   inline and thus does not turn into function calls.
> - You assume these are small enough so they can be inlined without
>   causing L1 insn cache trashing when tracing is activated.
> - You therefore assume they use a locking scheme that lets them be
>   really really compact (e.g. interrupt disable and spin lock).
> - You assume that the performance impact of doing a function call is
>   bigger than the impact of locking, which is false by at least a factor
>   10.

I don't assume anything. I will have the requirement that reserve and 
commit must be paired, and for the first version, hold locks.

Maybe I should rename it to: ring_buffer_lock_reserve and 
ring_buffer_unlock_commit. To show this.

[...]

> kernel/trace/ftrace.c :
> 
> /*
>  * the following macro would only do the "declaration" part of the
>  * markers, without doing all the function call stuff.
>  */
> DECLARE_MARKER(function_entry,
>   "pid %d pc %d flags %lu func 0x%lX parent 0x%lX");
> 
> void ftrace_mcount(unsigned long ip, unsigned long parent_ip)
> {
>   size_t ev_size = 0;
>   char *buffer;
> 
>   /*
>    * We assume event payload aligned on sizeof(void *).
>    * Event size calculated statically.
>    */
>   ev_size += sizeof(int);
>   ev_size += var_align(ev_size, sizeof(int));
>   ev_size += sizeof(int);
>   ev_size += var_align(ev_size, sizeof(unsigned long));
>   ev_size += sizeof(unsigned long);
>   ev_size += var_align(ev_size, sizeof(unsigned long));
>   ev_size += sizeof(unsigned long);
>   ev_size += var_align(ev_size, sizeof(unsigned long));
>   ev_size += sizeof(unsigned long);
> 
>   /*
>    * Now reserve space and copy data.
>    */
>   buffer = ring_buffer_reserve(func_event_id, ev_size);
>   /* Write pid */
>   *(int *)buffer = current->pid;
>   buffer += sizeof(int);
> 
>   /* Write pc */
>   buffer += var_align(buffer, sizeof(int));
>   *(int *)buffer = preempt_count();
>   buffer += sizeof(int);
> 
>   /* Write flags */
>   buffer += var_align(buffer, sizeof(unsigned long));
>   *(unsigned long *)buffer = local_irq_flags();
>   buffer += sizeof(unsigned long);
> 
>   /* Write func */
>   buffer += var_align(buffer, sizeof(unsigned long));
>   *(unsigned long *)buffer = func;
>   buffer += sizeof(unsigned long);
> 
>   /* Write parent */
>   buffer += var_align(buffer, sizeof(unsigned long));
>   *(unsigned long *)buffer = parent;
>   buffer += sizeof(unsigned long);
> 
>   ring_buffer_commit(buffer, ev_size);
> }
> 
> 
> Would that be suitable for you ?

YUCK YUCK YUCK!!!!

Mathieu,

Do I have to bring up the argument of simplicity again? I will never use
such an API.  Mine was very simple, I have to spend 10 minutes trying to
figure out what the above is. I only spent 5 so I'm still at a lost.

> 
> We could also think of passing the function pointer of the bin to ascii
> converter to DECLARE_MARKER(), such as :
> 
> void function_entry_show(struct seq_file *m, char *buffer);
> 
> DECLARE_MARKER(function_entry, function_entry_show,
>   "pid %d pc %d flags %lu func 0x%lX parent 0x%lX");
> 
> void function_entry_show(struct seq_file *m, char *buffer)
> {
>   /* Read pid */
>   seq_printf(m, "pid = %d ", *(int *)buffer);
>   buffer += sizeof(int);
> 
>   /* Read pc */
>   buffer += var_align(buffer, sizeof(int));
>   seq_printf(m, "pc = %d ", *(int *)buffer);
>   buffer += sizeof(int);
> 
>   /* Read flags */
>   buffer += var_align(buffer, sizeof(unsigned long));
>   seq_printf(m, "flags = %lu ", *(unsigned long *)buffer);
>   buffer += sizeof(unsigned long);
> 
>   /* Read func */
>   buffer += var_align(buffer, sizeof(unsigned long));
>   seq_printf(m, "func = 0x%lX ", *(unsigned long *)buffer);
>   buffer += sizeof(unsigned long);
> 
>   /* Read parent */
>   buffer += var_align(buffer, sizeof(unsigned long));
>   seq_printf(m, "parent = 0x%lX ", *(unsigned long *)buffer);
>   buffer += sizeof(unsigned long);
> }
> 
> Note that in this particular case, given we would not need any special
> "dump everything as if it was an unorganized array of bytes", the
> function_entry_show() would be totally useless if we provide a sane
> vsnprintf-like decoder based on the format string.
> 
> I did this example to show you how we could deal with the special cases
> where people would be interested to write a whole network packet (or any
> similar structure) directly to the trace (given it has field structures
> which are not too tied to the compiler internals and has field sizes
> portable across architectures). We could do this without much problem by
> adding a format string type which specified such a binary blob, and we
> could even leave room for people to provide their ascii formatting
> function pointer, as shows my second example here.
> 

These are not special cases, these are what I use often. They are not 
special for me.

-- Steve

