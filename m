Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbZDXM11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbZDXM11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbZDXM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:27:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZDXM1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:27:17 -0400
Date: Fri, 24 Apr 2009 08:27:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] tracing: increase size of number of possible
 events
In-Reply-To: <49F15607.1090707@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904240821130.24293@gandalf.stny.rr.com>
References: <20090424043005.338878133@goodmis.org> <20090424043111.983189535@goodmis.org> <49F15607.1090707@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Apr 2009, Li Zefan wrote:

> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > With the new event tracing registration, we must increase the number
> > of events that can be registered. Currently the type field is only
> > one byte, which leaves us only 256 possible events.
> > 
> > Since we do not save the CPU number in the tracer anymore (it is determined
> > by the per cpu ring buffer that is used) we have an extra byte to use.
> > 
> > This patch increases the size of type from 1 byte (256 events) to
> > 2 bytes (65,536 events).
> > 
> 
> You forgot to change this:
> 
> @@ -198,7 +198,7 @@ ftrace_define_fields_##call(void)					\
>  	struct ftrace_event_call *event_call = &event_##call;		\
>  	int ret;							\
>  									\
> -	__common_field(int, type);					\
> +	__common_field(unsigned short, type);				\
> 
> And we can apply the check in 3/6 to __common_field(). :)

Heh, that's what happens when I forward port a patch. I did not look at 
all the changes that had happened.

Thanks.

> 
> > It also adds a WARN_ON_ONCE if we exceed that limit.
> > 
> 
> WARN_ON_ONCE() may not be sufficient IMO:
> 
> We can reach 65536 this way (It took me 15 mins):
> 
> while (foo_bar.id < 65536) {
> 	insmod trace-events-sample.ko
> 	rmmod trace-events-sample.ko
> }
> 

Grumble, this patch was also written before events could be in modules.
I need to change the way register events works to reuse events.

I could have it search the list of events on overflow to find a new 
number.

> Now next id will be 0! Then do this:
> 
> console 1:
>  # cat /debug/tracing/trace_pipe
> 
> console 2:
> while (1) {
> 	insmod trace-events-sample.ko
> 	echo foo_bar > /debug/tracing/set_event
> 	rmmod trace-events-sample.ko
> }
> 
> I got this immediately:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000006f
> IP: [<c05210f3>] bstr_printf+0x2ce/0x302
> ...
> Call Trace:
>  [<c0476d12>] ? trace_seq_bprintf+0x28/0x41
>  [<c0477569>] ? trace_bprint_print+0x58/0x6c
>  [<c0472ffc>] ? print_trace_line+0x2c5/0x2df
>  [<c0428a41>] ? sub_preempt_count+0x85/0xa0
>  [<c04758cf>] ? tracing_read_pipe+0x118/0x191
>  [<c04757b7>] ? tracing_read_pipe+0x0/0x191
>  [<c04b09f9>] ? vfs_read+0x8f/0x136
>  [<c04b0da3>] ? sys_read+0x40/0x65
>  [<c0402a68>] ? sysenter_do_call+0x12/0x36

Ooh, that looks like a different bug. Thanks, I'll investigate that one.

> 
> (We can even get other crashes..)
> 
> So I think we should fail the initialization of the event, instead of
> WARN_ON().
> 
> > @@ -537,6 +537,8 @@ int register_ftrace_event(struct trace_event *event)
> >   out:
> >  	mutex_unlock(&trace_event_mutex);
> >  
> > +	WARN_ON_ONCE(next_event_type > FTRACE_MAX_EVENT);
> > +
> 
> This WARN_ON is triggered when we create an event with id == 65535,
> but not 65536.

Or search for an available number and fail (and warn on) if it fails.

Thanks,

-- Steve

