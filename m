Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYFLOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYFLOEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762436AbYFLOET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:04:19 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:40884 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762336AbYFLOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:04:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAJfDUEhMQW1O/2dsb2JhbACBW6wc
Date: Thu, 12 Jun 2008 10:04:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Hideo AOKI <haoki@redhat.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080612140415.GC22348@Krystal>
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <4847F811.7060406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4847F811.7060406@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:53:23 up 7 days, 18:34,  4 users,  load average: 0.44, 0.53,
	0.80
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Peter and Mathieu,
> 
> Peter Zijlstra wrote:
> > On Wed, 2008-06-04 at 19:22 -0400, Mathieu Desnoyers wrote:
> >> * Peter Zijlstra (peterz@infradead.org) wrote:
> > 
> >>> So are you proposing something like:
> >>>
> >>> static inline void 
> >>> trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> >>> {
> >>> 	trace_mark(sched_switch, prev, next);
> >>> }
> >>>
> >> Not exactly. Something more along the lines of
> >>
> >> static inline void 
> >> trace_sched_switch(struct task_struct *prev, struct task_struct *next)
> >> {
> >>   /* Internal tracers. */
> >>   ftrace_sched_switch(prev, next);
> >>   othertracer_sched_switch(prev, next);
> >>   /*
> >>    * System-wide tracing. Useful information is exported here.
> >>    * Probes connecting to these markers are expected to only use the
> >>    * information provided to them for data collection purpose. Type
> >>    * casting pointers is discouraged.
> >>    */
> >> 	trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
> >>     prev->pid, next->pid, prev->state);
> >> }
> > 
> > Advantage of my method would be that ftrace (and othertracer) can use
> > the same marker and doesn't need yet another hoook.
> 
> If so, I'd like to suggest below changes,
> 
> - introduce below macro in marker.h
> 
> #define DEFINE_TRACE(name, vargs, args...)	\
> static inline void trace_##name vargs		\
> {						\
> 	trace_mark(name, #vargs, ##args);	\
> }
> 
> - remove __marker_check_format from __trace_mark
> - and write a definition in sched_trace.h
> 
> DEFINE_TRACE(sched_switch, (struct task_struct *prev, struct task_struct *next),
> 	     prev, next);
> 
> Thus, we can remove fmt string and also ensure the type checking, because;
> - Type checking at the trace point is done by the compiler.
> - Type checking of probe handler can be done by comparing #vargs strings.
> 

Hrm, interesting! The only problem I see with this is that it won't
allow a tracer to efficiently parse the "format information". Parsing C
code is not as straightforward and compact as parsing a format string.

However, Peter and you are about to convince me that an hybrid between
the solution you propose here and the marker scheme could be used.

Your scheme could be used to declare the markers and probes
(DEFINE_TRACE()) in header files. It would declare a static inline
function called at the instrumentation site and a probe prototype
that could then be used in the probe module to declare the probe that
will have to be connected to the marker. This part would allow
custom-made probes.

Within the tracer, we would declare custom-made probes for each of these
DEFINE_TRACE statements and associate them with format strings. Because
the probe has to match the prototype, type correctness is ensured. The
format strings would at that point be the exact same as the current
trace_mark() statements. The information passed to trace_mark() would be
send for direct interpretation or serialization with only basic types
available, similar to printk().

We sould leave the trace_mark() statements available for people who want
to add their own debug-style instrumentation to their kernel without
having to add DEFINE_TRACE() statements and modify the tracer
accordingly.

I guess a bit of polishing will come with the implementation, which I
plan to start soon.

Thanks!

Mathieu


> Thanks,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
