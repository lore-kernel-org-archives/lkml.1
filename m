Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYIWD1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYIWD1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYIWD1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:27:09 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:35877 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754151AbYIWD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:27:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAPT910hMQWq+/2dsb2JhbACBXbU2gWY
Date: Mon, 22 Sep 2008 23:27:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, od@novell.com
Subject: Re: Unified tracing buffer
Message-ID: <20080923032707.GJ24937@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <20080919231841.GB3456@redhat.com> <alpine.DEB.1.10.0809200435470.9362@gandalf.stny.rr.com> <20080920133752.GA23215@Krystal> <alpine.DEB.1.10.0809200946020.12824@gandalf.stny.rr.com> <alpine.DEB.1.10.0809201043490.13681@gandalf.stny.rr.com> <20080922184538.GB6349@Krystal> <alpine.DEB.1.10.0809221734510.23852@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809221734510.23852@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:14:33 up 110 days,  7:54,  7 users,  load average: 0.62, 0.59,
	0.58
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 22 Sep 2008, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> > > and then to turn on function tracing, I need to hook into this marker. I'd 
> > > rather just push the data right into the buffer here without having to 
> > > make another function call to hook into this.
> > > 
> > 
> > The scheme you propose here is based on a few inherent assumptions :
> > 
> > - You assume ring_buffer_reserve() and ring_buffer_commit() are static
> >   inline and thus does not turn into function calls.
> > - You assume these are small enough so they can be inlined without
> >   causing L1 insn cache trashing when tracing is activated.
> > - You therefore assume they use a locking scheme that lets them be
> >   really really compact (e.g. interrupt disable and spin lock).
> > - You assume that the performance impact of doing a function call is
> >   bigger than the impact of locking, which is false by at least a factor
> >   10.
> 
> I don't assume anything. I will have the requirement that reserve and 
> commit must be paired, and for the first version, hold locks.
> 

By saying you don't want to do any function call, the only technical
reason I see for you wanting that is performance, and thus you would
assume the above. If not, why don't you want to make another function
call ? This all I mean by "assumption" here.

> Maybe I should rename it to: ring_buffer_lock_reserve and 
> ring_buffer_unlock_commit. To show this.
> 
> [...]
> 
> > kernel/trace/ftrace.c :
> > 
> > /*
> >  * the following macro would only do the "declaration" part of the
> >  * markers, without doing all the function call stuff.
> >  */
> > DECLARE_MARKER(function_entry,
> >   "pid %d pc %d flags %lu func 0x%lX parent 0x%lX");
> > 
> > void ftrace_mcount(unsigned long ip, unsigned long parent_ip)
> > {
> >   size_t ev_size = 0;
> >   char *buffer;
> > 
> >   /*
> >    * We assume event payload aligned on sizeof(void *).
> >    * Event size calculated statically.
> >    */
> >   ev_size += sizeof(int);
> >   ev_size += var_align(ev_size, sizeof(int));
> >   ev_size += sizeof(int);
> >   ev_size += var_align(ev_size, sizeof(unsigned long));
> >   ev_size += sizeof(unsigned long);
> >   ev_size += var_align(ev_size, sizeof(unsigned long));
> >   ev_size += sizeof(unsigned long);
> >   ev_size += var_align(ev_size, sizeof(unsigned long));
> >   ev_size += sizeof(unsigned long);
> > 
> >   /*
> >    * Now reserve space and copy data.
> >    */
> >   buffer = ring_buffer_reserve(func_event_id, ev_size);
> >   /* Write pid */
> >   *(int *)buffer = current->pid;
> >   buffer += sizeof(int);
> > 
> >   /* Write pc */
> >   buffer += var_align(buffer, sizeof(int));
> >   *(int *)buffer = preempt_count();
> >   buffer += sizeof(int);
> > 
> >   /* Write flags */
> >   buffer += var_align(buffer, sizeof(unsigned long));
> >   *(unsigned long *)buffer = local_irq_flags();
> >   buffer += sizeof(unsigned long);
> > 
> >   /* Write func */
> >   buffer += var_align(buffer, sizeof(unsigned long));
> >   *(unsigned long *)buffer = func;
> >   buffer += sizeof(unsigned long);
> > 
> >   /* Write parent */
> >   buffer += var_align(buffer, sizeof(unsigned long));
> >   *(unsigned long *)buffer = parent;
> >   buffer += sizeof(unsigned long);
> > 
> >   ring_buffer_commit(buffer, ev_size);
> > }
> > 
> > 
> > Would that be suitable for you ?
> 
> YUCK YUCK YUCK!!!!
> 
> Mathieu,
> 
> Do I have to bring up the argument of simplicity again? I will never use
> such an API.  Mine was very simple, I have to spend 10 minutes trying to
> figure out what the above is. I only spent 5 so I'm still at a lost.
> 

I was actually waiting for you to propose an alternative, but I fear you
already did without me noticing :)

How do you deal with exporting data across kernel/user boundary in your
proposal exactly ? How does this work on architecture with 64-bits
kernel and 32-bits userland... ? A simple C structure copy might be
simple to _code_, but hellish to export to userspace and lead to hard to
debug binary incompatibilities (different gcc flags, 32/64 bits
user/kernel). And this is without telling about the non-portability of
the exported data.

If gcc/icc-knowledgeful people can reassure me by certifying it won't
generate a mess, fine, but until then, I stay very doubtful about
solutions involving to imply binary compability between kernel and
userland.

And common.. 10 minutes to understand the above code. Your _are_ kidding
me right ? Would that help if I create a small 4 lineish wrapper around
the buffer write ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
