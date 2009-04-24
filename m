Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZDXM3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZDXM3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbZDXM30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:29:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZDXM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:29:25 -0400
Date: Fri, 24 Apr 2009 08:29:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] tracing: increase size of number of possible
 events
In-Reply-To: <20090424070953.GC24912@elte.hu>
Message-ID: <alpine.DEB.2.00.0904240827190.24293@gandalf.stny.rr.com>
References: <20090424043005.338878133@goodmis.org> <20090424043111.983189535@goodmis.org> <49F15607.1090707@cn.fujitsu.com> <20090424070953.GC24912@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Fri, 24 Apr 2009, Ingo Molnar wrote:

> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > With the new event tracing registration, we must increase the number
> > > of events that can be registered. Currently the type field is only
> > > one byte, which leaves us only 256 possible events.
> > > 
> > > Since we do not save the CPU number in the tracer anymore (it is determined
> > > by the per cpu ring buffer that is used) we have an extra byte to use.
> > > 
> > > This patch increases the size of type from 1 byte (256 events) to
> > > 2 bytes (65,536 events).
> > > 
> > 
> > You forgot to change this:
> > 
> > @@ -198,7 +198,7 @@ ftrace_define_fields_##call(void)					\
> >  	struct ftrace_event_call *event_call = &event_##call;		\
> >  	int ret;							\
> >  									\
> > -	__common_field(int, type);					\
> > +	__common_field(unsigned short, type);				\
> > 
> > And we can apply the check in 3/6 to __common_field(). :)
> > 
> > > It also adds a WARN_ON_ONCE if we exceed that limit.
> > > 
> > 
> > WARN_ON_ONCE() may not be sufficient IMO:
> > 
> > We can reach 65536 this way (It took me 15 mins):
> > 
> > while (foo_bar.id < 65536) {
> > 	insmod trace-events-sample.ko
> > 	rmmod trace-events-sample.ko
> > }
> > 
> > Now next id will be 0! Then do this:
> > 
> > console 1:
> >  # cat /debug/tracing/trace_pipe
> > 
> > console 2:
> > while (1) {
> > 	insmod trace-events-sample.ko
> > 	echo foo_bar > /debug/tracing/set_event
> > 	rmmod trace-events-sample.ko
> > }
> > 
> > I got this immediately:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000006f
> > IP: [<c05210f3>] bstr_printf+0x2ce/0x302
> > ...
> > Call Trace:
> >  [<c0476d12>] ? trace_seq_bprintf+0x28/0x41
> >  [<c0477569>] ? trace_bprint_print+0x58/0x6c
> >  [<c0472ffc>] ? print_trace_line+0x2c5/0x2df
> >  [<c0428a41>] ? sub_preempt_count+0x85/0xa0
> >  [<c04758cf>] ? tracing_read_pipe+0x118/0x191
> >  [<c04757b7>] ? tracing_read_pipe+0x0/0x191
> >  [<c04b09f9>] ? vfs_read+0x8f/0x136
> >  [<c04b0da3>] ? sys_read+0x40/0x65
> >  [<c0402a68>] ? sysenter_do_call+0x12/0x36
> > 
> > (We can even get other crashes..)
> > 
> > So I think we should fail the initialization of the event, instead of
> > WARN_ON().
> 
> Hm, i think this might also call for a 32-bit event ID after all, 
> right? Especially if we get some more dynamic form of injecting such 
> tracepoints, 64K does not sound all that far in the future anymore. 
> It is stretching things, but still it would be a silly limit to 
> leave in place, hm?

I would like to keep the size of the buffer down as much as possible. 
There are only 22,000 functions (with full function tracing) so 65000 
events should be more than enough.

The problem happens when we load and unload modules. If 65000 is not 
enough, 4G wont be enough either. We would only need to run the module 
load/unload a bit longer ;-)

I'll work on adding a way to reuse event keys.

-- Steve

