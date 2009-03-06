Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZCFQ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZCFQ7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZCFQ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:59:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZCFQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:59:25 -0500
Date: Fri, 6 Mar 2009 11:59:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
In-Reply-To: <20090304170015.GB1150@Krystal>
Message-ID: <alpine.DEB.2.00.0903061124400.23248@gandalf.stny.rr.com>
References: <20090304024921.153061228@goodmis.org> <20090304170015.GB1150@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Mar 2009, Mathieu Desnoyers wrote:
> > 
> > From previous patches, we have in include/trace/sched_event_types.h:
> > 
> > #undef TRACE_SYSTEM
> > #define TRACE_SYSTEM sched
> > 
> > TRACE_EVENT_FORMAT(sched_switch,
> > 	TPPROTO(struct rq *rq, struct task_struct *prev,
> > 		struct task_struct *next),
> > 	TPARGS(rq, prev, next),
> > 	TPFMT("task %s:%d ==> %s:%d",
> > 	      prev->comm, prev->pid, next->comm, next->pid),
> > 	TRACE_STRUCT(
> > 		TRACE_FIELD(pid_t, prev_pid, prev->pid)
> > 		TRACE_FIELD(int, prev_prio, prev->prio)
> > 		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
> > 				    next_comm,
> > 				    TPCMD(memcpy(TRACE_ENTRY->next_comm,
> > 						 next->comm,
> > 						 TASK_COMM_LEN)))
> > 		TRACE_FIELD(pid_t, next_pid, next->pid)
> > 		TRACE_FIELD(int, next_prio, next->prio)
> > 	),
> > 	TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
> > 	);
> > 
> 
> I fear that putting these user-visible format strings in tracepoint
> header files will create a big maintainability issue.
> 
> I'll post the LTTng patchset in a jiffy, where the format string
> awareness is done in a tracer-specific module. I don't understand why
> Peter Z. is not yelling against your tracepoints modifications : they
> are actually presenting to userspace an interface that is meant to
> eventually change.
> 
> I used a separate layer for format string presentation for this very
> purpose : I don't want to tie the kernel code instrumentation
> (tracepoints) to any kind of user-visible API.
> 

Hi Mathieu,

Sorry for the late reply, I started to reply but was distracted, and sadly 
forgot about it :-(  (and I rebooted the box that had the reply window 
open)


Just a couple of points to make.

1)  The raw format string is a "hint" for userspace to read the buffers.
The offset and sizeof is the real data that userspace should use. The
print format can be just a way to help them out. But it is by no means 
something that is expected to be constant.

It is also used internal by ftrace because it needs a way to read the 
"fast C style recording" records. It is better to print some text than to 
have a bunch of hex print out in the screen. Say you have the C style 
recording enabled and you take an oops. With ftrace_dumps_on_oops set, the 
buffers will be printed to the console.  This lets ftrace have a means to 
print out the events.

2) The difference between this and markers is that the format string is 
bound to the declaration in the trace header. Not in the code itself. The 
maintainer should only see the trace point function call. It should only 
look like a function call and not some funky printf string that the 
maintainer might not care about.

If the code changes and it breaks the format string, it is up to the 
tracing maintainers to fix it. If the format string was embedded within 
the code, then the maintainer would be burdoned with that duty. But here 
the format string is in the include/trace directory and any breakage there 
should definitely be fixed by a some tracing maintainer. Not the 
maintainer of the subsystem. Unless of course that maintainer wants to fix 
it ;-)


3) TRACE_EVENT_FORMAT is an extension to TRACE_FORMAT. Developers may 
choose to use the more simple, but a bit more expensive TRACE_FORMAT if 
they choose to. Perhaps it may be more prudent to anyway. Recently
Peter Zijlstra was tracing locks and just wanted to trace the name. 
There's really no difference in copying the name via a C style (strcpy) or 
having a printf formatting do the work. Here is a case where just using 
TRACE_FORMAT is a reasonable solution.

4) I actually avoided moving the format string into the tracing utility. 
The tracing utility can ignore it if it wants. I orginially had the 
headers included in the kernel/trace/events.c file and found that was too 
cumbersome. I did not like the fact that I needed to go into some tracing 
infrastructure to add an event.  It was a burdon to me to add a new event 
and I wrote the code!  That's why I moved it all into the include/trace 
directory. One stop shopping.

A developer to add new events only needs to add the trace points in their 
code and then update the files (perhaps add new ones) in include/trace. No 
need to dig through the kernel source to find out where else they need to 
go.


I see that you published your patch queue. I've looked at most of the 
patches already. I'll make my comments shortly.

Thanks,

-- Steve

