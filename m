Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZFHVNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZFHVNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZFHVM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:12:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZFHVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:12:58 -0400
Date: Mon, 8 Jun 2009 17:11:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090608211150.GC3181@redhat.com>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com> <20090607132936.GC12088@elte.hu> <20090608202406.GA3181@redhat.com> <20090608204056.GA26832@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608204056.GA26832@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 10:40:56PM +0200, Ingo Molnar wrote:
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > +#ifdef __NR_time
> > +trace_event_syscall(1, time, time_t __user *, tloc);
> > +#endif
> > +
> > +#ifdef __NR_stime
> > +trace_event_syscall(1, stime, time_t __user *, tptr);
> > +#endif
> > +
> > +#ifdef __NR_gettimeofday
> > +trace_event_syscall(2, gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
> > +#endif
> 
> This could be reduced to a single line: just add a Kconfig entry 
> (say TRACE_SYSCALL_TRACEPOINTS) wether an arch supports syscall 
> tracepoints, enable it on a sane arch, make sure it has all the 
> syscalls and list them ...
> 
> As more architectures turn on SYSCALL_TRACEPOINTS, they'll have to 
> resolve any deviations in syscall entry points. Ideally we'd have 
> one generic table that covers 95% of all syscalls, and the remaining 
> 5% in some architecture specific #ifdef section.
> 

true, but this implementation works for all arches now, why would want to
slowly add this over time? I think its unnecessary work that could be
error prone.

> But, more generally, i'm not at all convinced that we need _any_ of 
> this enumeration. Look how much the above lines duplicate 
> DEFINE_SYSCALL macros. Why arent those macros re-used?
> 

The DEFINE_SYSCALL() are located all over the code in various .c files.
Thus, if we define the tracpoints via the DEFINE_SYSCALL() macros we are
going to have 'static inline functions' (which is how tracepoints are
implemented) defined in all these .c files. Now, I need to call all these
'static inline functions' from ptrace.c. How do I do that? By defining
these as I've done in syscalls.h I can include that header file and
create an efficient 'case' statement. I've verified in the assembly that
the 'case' statments resolve to jumps. Thus, this implementation is
pretty efficient. Further, by creating a header file other users of the
tracepoints can include that header. If we use DEFINE_SYSCALL() that is
not possible. I'd be more than happy to use the DEFINE_SYSCALL() macros,
if you could explain how to resolve the above issues...We could write a
pre-processor that creates a dynamic header file from the
DEFINE_SYSCALL() points? I'm not sure that's simpler...


> We dont need too smart pretty-printing i think - we only want to 
> know the field size and the field name - nothing else. Duplicating 
> all those definitions looks outright wrong to me. Do we really, 
> really, really have to do it?
> 

In terms of pretty-printing, it should be fairly easy to add size and
the field name to what I have without bloating the syscalls.h file at
all.

thanks,

-Jason
