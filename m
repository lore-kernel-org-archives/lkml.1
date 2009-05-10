Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZEJG7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZEJG7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZEJG7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:59:14 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:60684 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbZEJG7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:59:13 -0400
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
From: Tom Zanussi <zanussi@comcast.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
In-Reply-To: <20090509083737.GE3656@elte.hu>
References: <20090508210347.GA3121@redhat.com>
	 <20090509083737.GE3656@elte.hu>
Content-Type: text/plain
Date: Sun, 10 May 2009 01:59:10 -0500
Message-Id: <1241938750.5651.115.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-09 at 10:37 +0200, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > Hi,
> > 
> > I've been thinking about converting the current ftrace syscall 
> > tracer to the TRACE_EVENT() macros. There are a few issues with 
> > the current syscall tracer approach:
> > 
> > 1) It has to be enabled for all processes and all syscalls. By 
> > moving to TRACE_EVENT(), it can be enabled/disabled per tracepoint 
> > and can also make use of the generic tracing filters, such as 
> > "trace all process for pid x"
> > 
> > 2) Other tracers can not tie into it, since its not tracepoint 
> > based. TRACE_EVENT() fixes this.
> > 
> > 3) data formatting. The syscall tracer I don't believe understands 
> > all the various types for output formatting. By moving to 
> > TRACE_EVENT(), we can print out a more readible syscall trace.
> > 
> > 4) The ftrace syscall tracer needs a new arch specific code for 
> > each architecture. By converting to TRACE_EVENT() we don't need 
> > any architecutre specific code.
> > 
> > Other issues to consider:
> > 
> > * Maintainence. The current syscall tracer automatically picks up 
> > new syscalls. The TRACE_EVENT() will be harder to initially set 
> > up. But once its done, syscalls are obviously not added often. So 
> > I don't think this will be too bad.
> > 
> > * Performance. The current syscall tracer adds a 
> > 'test_thread_flag()' to syscall entry/exit. The TRACE_EVENT() 
> > would add a per-syscall global to check. So they are going to have 
> > different cache profiles...however, the tracepoint infrastructure 
> > is hopefully moving to the 'immediate' value work, which will make 
> > this more highly optimized.
> > 
> > I've also tested the patch shown below (which uses, 
> > DECLARE_TRACE(), as a preliminary proof of concept), using 
> > getpid() in a loop, and tbench, and saw very small performance 
> > differences. Obviously we would have to do more extensive testing 
> > before deciding.
> > 
> > Patch is pretty rough, but should give a rough sense of what the 
> > DECLARE_TRACE() type patch might look like...
> 
> Yeah, i very much agree with the direction. (I've Cc:-ed Tom Zanussi 
> who also has expressed interest in this.)
> 
> I'm not sure about the implementation as you've posted it though:
> 
> Firstly, it adds two new tracepoints to every system call. That is 
> unnecessary - we already have the TIF flag based callbacks, and we 
> can use the existing syscall attributes table to get to tracepoints 
> - without slow down (or impacting) the fast path in any way.
> 
> Secondly, we should reuse the information we get in SYSCALL_DEFINE, 
> to construct the TRACE_EVENT tracepoints directly - without having 
> to list all syscalls again in a separate file.
> 

I looked at it a bit last night, but only with an eye to adding
filtering to the current implentation, nothing more ambitious than that.
As such, I came up with some vague ideas for what I thought I'd want to
do for that, but this is the kind of thing you really need to sit down
and try coding up to see whether it really makes any sense, and I
haven't had a chance to do that yet.

Anyway, I wanted to be able to reuse as much of the ftrace_event_call machinery
as possible, but not have it create any actual tracepoints, since that's
already taken care of by the syscall tracer itself.  So something that
doesn't define a regfunc/unregfunc, like what's in trace_export.c.  The
main thing I was interested in here was the automatic creation of a
'syscall' subsystem, with a subdir for each syscall, containing just the
'format' and 'filter' files, but not the 'enable' since I wasn't
thinking of them as being separate tracepoints and the enabling is taken
care of by the syscall tracer.  With just those two files, a user could
look at the field names in the format file and use those to set a filter
on any given syscall.

In the syscall_metadata there would be a pointer to the corresponding
ftrace_event_call which would be used for checking the associated filter
when logging the event, or the syscall ftrace_event_calls could be kept
in a separate section indexed in the same way as the syscall_metadata
array and the corresponding ftrace_event_call retrieved by syscall_nr.
One complication is that the actual trace data for the syscall arguments
is an array of unsigned longs, regardless of the actual type of the
arguments; the metadata has the type information for the args - it could
possibly be used to create the appropriate filters, but I haven't
thought much about that.

Anyway, the main reason I avoided the TRACE_EVENT() and TP_fast_assign()
approach was that the existing syscall_get_arguments() efficiently
assigns all the fields at the same time, whereas TRACE_EVENT() is
designed to do that field by field.  I guess there's a version or was a
version that lets you override that, but I can't remember what it was.

But I agree, it would be much nicer if it could all be done using the
individually enable-able TRACE_EVENT() syscall events, especially if the
events defined for that could be reused in the existing syscall tracer,
in which case some of the above might still be useful.

Tom

> 	Ingo

