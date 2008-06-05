Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYFEINE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYFEINE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYFEIMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:12:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbYFEIMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:12:41 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20080604232241.GA8488@Krystal>
References: <48447052.3030300@redhat.com>
	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
	 <20080602232135.GA20173@Krystal>
	 <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>
	 <20080604232241.GA8488@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 10:12:19 +0200
Message-Id: <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 19:22 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:

> > So are you proposing something like:
> > 
> > static inline void 
> > trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> > {
> > 	trace_mark(sched_switch, prev, next);
> > }
> > 
> 
> Not exactly. Something more along the lines of
> 
> static inline void 
> trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> {
>   /* Internal tracers. */
>   ftrace_sched_switch(prev, next);
>   othertracer_sched_switch(prev, next);
>   /*
>    * System-wide tracing. Useful information is exported here.
>    * Probes connecting to these markers are expected to only use the
>    * information provided to them for data collection purpose. Type
>    * casting pointers is discouraged.
>    */
> 	trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
>     prev->pid, next->pid, prev->state);
> }

Advantage of my method would be that ftrace (and othertracer) can use
the same marker and doesn't need yet another hoook.

> > dropping the silly fmt string but using the multiplex of trace_mark, and
> > then doing the stringify bit:
> > 
> >        "prev_pid %d next_pid %d prev_state %ld\n"
> > 
> > in the actual tracer?
> > 
> 
> It would make much more sense to put this formatting information along
> with the trace point (e.g. in a a kernel/sched-trace.h header) rather
> that to hide it in a tracer (loadable module) because this information
> is an interface to the trace point.

I'm not sure - it seems to me it should be part of the tracer because
its a detail/subset of the actual data - rendering it useless for others
who'd like a different set.

> > IMHO the 'type safety' of the fmt string is over-rated, since it cannot
> > distinguish between a task_struct * or a bio *, both are a pointers -
> > and half arsed type safely is worse than no type safety.
> > 
> 
> I totally agree with you that not having the capacity to inspect pointer
> types is a problem for tracers which wants to receive the "raw" pointer
> and deal with the data they need like big boys. On the other hand, it
> requires them to be closely tied to the kernel internals and therefore
> it makes sense to call them directly from the tracing site, thus
> bypassing the marker format string.
> 
> However, letting the marker specify the data format so a tracer could
> format it into a memory buffer (in a binary or text format, depending on
> the implementation) or so that a tool like systemtap can use this
> identified information without having to be closely tied to the kernel
> makes sense to me.

So s-tap is meant to parse this sting and interpret the varargs without
being closely tied to the kernel? - Somehow that doesn't make me feel
warm and fuzzy. That not only ties userspace to the information present
in the marker, but to the actual string as well.

The stronger you make this bind the less I like it.



