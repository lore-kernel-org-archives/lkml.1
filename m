Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZGWC0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZGWC0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 22:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZGWC0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 22:26:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZGWC0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 22:26:08 -0400
Date: Wed, 22 Jul 2009 22:26:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       jsquyres@cisco.com
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
In-Reply-To: <20090722124208.97d7d9d7.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0907221606360.1059@gandalf.stny.rr.com>
References: <ada3a8oobis.fsf@cisco.com> <20090722111538.58a126e3.akpm@linux-foundation.org> <adad47smsb5.fsf@cisco.com> <20090722124208.97d7d9d7.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Jul 2009, Andrew Morton wrote:

> On Wed, 22 Jul 2009 12:27:42 -0700
> Roland Dreier <rdreier@cisco.com> wrote:
> 
> >  > >  1. ioctl() to register/unregister an address range to watch in the
> >  > >     kernel (cf struct ummunot_register_ioctl in <linux/ummunot.h>).
> >  > > 
> >  > >  2. read() to retrieve events generated when a mapping in a watched
> >  > >     address range is invalidated (cf struct ummunot_event in
> >  > >     <linux/ummunot.h>).  select()/poll()/epoll() and SIGIO are handled
> >  > >     for this IO.
> >  > > 
> >  > >  3. mmap() one page at offset 0 to map a kernel page that contains a
> >  > >     generation counter that is incremented each time an event is
> >  > >     generated.  This allows userspace to have a fast path that checks
> >  > >     that no events have occurred without a system call.

Looks like a vsyscall to me.

> >  > 
> >  > If you stand back and squint, each of 1, 2 and 3 are things which the
> >  > kernel already provides for the delivery of ftrace events to userspace.
> >  > 
> >  > Did you look at reusing all that stuff?
> > 
> > No, not really... will investigate a bit further.  Any pointers to how
> > the ftrace stuff might work?
> 
> I know who to cc ;)

You would wouldn't you ;-)

> 
> >  Specifically how #3 maps to ftrace is a
> > little obscure to me; and also as I understand it, ftrace is controlled
> > through debugfs, which means there's a bit of hassle to make this usable
> > on a default install.  And also I'm not sure how the ftrace control path

On Fedora 11 (early ftrace kernel)

# mount -t debugfs nodev /sys/kernel/debug
# ls /sys/kernel/debug/tracing
available_filter_functions     set_ftrace_filter
available_tracers              set_ftrace_notrace
buffer_size_kb                 set_ftrace_pid
current_tracer                 stack_max_size
dyn_ftrace_total_info          stack_trace
failures                       sysprof_sample_period
latency_trace                  trace
process_follow_pid             trace_marker
process_trace_lifecycle        trace_options
process_trace_README           trace_pipe
process_trace_signals          tracing_cpumask
process_trace_syscalls         tracing_enabled
process_trace_taskcomm_filter  tracing_max_latency
process_trace_uid_filter       tracing_on
README                         tracing_thresh

Not too hard

> > really maps to "here's a 100 address ranges I'd like events for".

Now to boot into a more recent kernel:

# cd /sys/kernel/debug/tracing
# echo "ptr > 0xffffffff81100000 && ptr < 0xffffffff8113000" > events/kmem/kmalloc/filter 
# echo 1 > events/kmem/kmalloc/enable
# cat events/kmem/kmalloc/filter
 ptr > 0xffffffff81100000 && ptr < 0xffffffff81130000
# cat trace
# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            bash-6652  [002] 80345.390536: kmalloc: call_site=ffffffff810d76e1 ptr=ffff88001e8e7c80 bytes_req=53 bytes_alloc=64 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390542: kmalloc: call_site=ffffffff810ba480 ptr=ffff88003c5a2700 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390543: kmalloc: call_site=ffffffff810d76e1 ptr=ffff88003c5a2540 bytes_req=4 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390544: kmalloc: call_site=ffffffff810ba210 ptr=ffff8800318c4d00 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390550: kmalloc: call_site=ffffffff810ba480 ptr=ffff8800318c43c0 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390551: kmalloc: call_site=ffffffff810d76e1 ptr=ffff8800318c4ca0 bytes_req=19 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390552: kmalloc: call_site=ffffffff810ba320 ptr=ffff8800318c4d00 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390552: kmalloc: call_site=ffffffff810ba210 ptr=ffff8800318c4e20 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390554: kmalloc: call_site=ffffffff810ba480 ptr=ffff8800318c4400 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390555: kmalloc: call_site=ffffffff810d76e1 ptr=ffff8800318c4380 bytes_req=4 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390555: kmalloc: call_site=ffffffff810ba210 ptr=ffff8800318c42e0 bytes_req=24 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390561: kmalloc: call_site=ffffffff810ba480 ptr=ffff8800318c4d20 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390562: kmalloc: call_site=ffffffff810d76e1 ptr=ffff8800318c4240 bytes_req=19 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390563: kmalloc: call_site=ffffffff810ba320 ptr=ffff8800318c42e0 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390563: kmalloc: call_site=ffffffff810ba320 ptr=ffff8800318c4e20 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390566: kmalloc: call_site=ffffffff810bb0ee ptr=ffff88003d4e2680 bytes_req=176 bytes_alloc=192 gfp_flags=GFP_KERNEL|GFP_ZERO
            bash-6652  [002] 80345.390566: kmalloc: call_site=ffffffff810d76e1 ptr=ffff8800318c42c0 bytes_req=4 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390570: kmalloc: call_site=ffffffff810d76e1 ptr=ffff8800285405c0 bytes_req=4 bytes_alloc=32 gfp_flags=GFP_KERNEL
            bash-6652  [002] 80345.390574: kmalloc: call_site=ffffffff810bb320 ptr=ffff88003d4e2680 bytes_req=176 bytes_alloc=192 gfp_flags=GFP_KERNEL|GFP_ZERO

> >
> > So at a first glance after unsquinting a bit I'm not sure how good the
> > fit really is.

Well, if you need to add hooks, definitely at least use tracepoints. (see 
the TRACE_EVENT code in include/trace/events/*.h)

I'm not exactly sure what requirements you have, but it may be something 
we can work together on. Eliminate some duplicate code, or at least, 
ftrace can piggy back on it ;-)

> 
> Oh.  Here was I hoping that all that code was about to become useful.
> <runs away>

You better run!

-- Steve
