Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZFHXCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZFHXCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZFHXCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:02:42 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56588 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZFHXCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L1QApeh1Zu8Oj3VIfsjGZr+W9lV7M3HTcvltHRJDG5f9oNbOwZmHC4VZTAUKYpzhIQ
         AogUtSCvN21E8H7HdZVdCAmCE+9VeXXAzynIeoinjLXwoHQBDSU0NGqPBeL1gai5ST4A
         DTPbK6jScxUNTrGx47PLYXS1YDCBA8pQHVXXY=
Date: Tue, 9 Jun 2009 01:02:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090608230234.GA5758@nowhere>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com> <20090607132936.GC12088@elte.hu> <20090608202406.GA3181@redhat.com> <20090608204056.GA26832@elte.hu> <20090608211150.GC3181@redhat.com> <20090608212526.GA22049@elte.hu> <20090608213833.GD3181@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608213833.GD3181@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 05:38:33PM -0400, Jason Baron wrote:
> On Mon, Jun 08, 2009 at 11:25:26PM +0200, Ingo Molnar wrote:
> > > On Mon, Jun 08, 2009 at 10:40:56PM +0200, Ingo Molnar wrote:
> > > > * Jason Baron <jbaron@redhat.com> wrote:
> > > > 
> > > > > +#ifdef __NR_time
> > > > > +trace_event_syscall(1, time, time_t __user *, tloc);
> > > > > +#endif
> > > > > +
> > > > > +#ifdef __NR_stime
> > > > > +trace_event_syscall(1, stime, time_t __user *, tptr);
> > > > > +#endif
> > > > > +
> > > > > +#ifdef __NR_gettimeofday
> > > > > +trace_event_syscall(2, gettimeofday, struct timeval __user *, tv, struct timezone __user *, tz);
> > > > > +#endif
> > > > 
> > > > This could be reduced to a single line: just add a Kconfig entry 
> > > > (say TRACE_SYSCALL_TRACEPOINTS) wether an arch supports syscall 
> > > > tracepoints, enable it on a sane arch, make sure it has all the 
> > > > syscalls and list them ...
> > > > 
> > > > As more architectures turn on SYSCALL_TRACEPOINTS, they'll have to 
> > > > resolve any deviations in syscall entry points. Ideally we'd have 
> > > > one generic table that covers 95% of all syscalls, and the remaining 
> > > > 5% in some architecture specific #ifdef section.
> > > > 
> > > 
> > > true, but this implementation works for all arches now, why would 
> > > want to slowly add this over time? [...]
> > 
> > Because the current solution is butt-ugly ...
> > 
> > > [...] I think its unnecessary work that could be error prone.
> > 
> > This area needs cleanups - making it messier doesnt help. (I've 
> > Cc:-ed hpa - he has expressed interest in auto-generating all the 
> > syscall related details from another angle ...)
> > 
> > > > But, more generally, i'm not at all convinced that we need _any_ 
> > > > of this enumeration. Look how much the above lines duplicate 
> > > > DEFINE_SYSCALL macros. Why arent those macros re-used?
> > > 
> > > The DEFINE_SYSCALL() are located all over the code in various .c files.
> > 
> > yes, and that's good.
> > 
> > > Thus, if we define the tracpoints via the DEFINE_SYSCALL() macros 
> > > we are going to have 'static inline functions' (which is how 
> > > tracepoints are implemented) defined in all these .c files. Now, I 
> > > need to call all these 'static inline functions' from ptrace.c. 
> > > How do I do that? [...]
> > 
> > And that's bad.
> > 
> > We dont want a per syscall tracepoint call site. AT ALL.
> > 
> > We want to collect the record information, we want to construct 
> > /debug/tracing/events/syscalls/ directories with all the proper 
> > tracepoint-lookalike entries, and then we want to use the 
> > _existing_, _zero overhead_ method implemented by Frederic to get 
> > per syscall functionality.
> > 
> 
> Yes, this can easily be done....but that wasn't the problem I was
> interested in solving. I wanted a per syscall tracepoint site. I thought
> I had been making that clear all along...Please notice that the
> implementation I've proposed obtains the syscall number, and then jumps
> to the appropriate tracepoint and then exits. Its quite efficient. In
> fact, I've enabled all of the syscalls using my proposed method and
> running tbench I'm able to get more throughput then using the current
> syscall method. I've also done 'getpid()' loops and seen no performance
> difference between the approaches. I'm happy to run any other
> benchmarks...
> 
> > Have you looked at how the syscall attributes information is 
> > constructed by using .section tricks? See: 
> > kernel/trace/trace_syscalls.c.
> > 
> 
> yes, I believe I understand the problem space. I had been talking about
> a per-syscall tracepoint all along...maybe I wasn't clear...
> 
> thanks,
> 
> -Jason


Ok, I understand the problem.
Well, the fact is that we can use the artifact from the current syscall tracer
to solve a part of this problem.

Currently the syscall tracer does the following:

- create a section with all syscalls informations, provided by DEFINE_SYSCALL()
  That includes the size, type, name of parameters.

- map a table during the boot which resolves a syscall number to its information
  in the syscall metadata section

- uses a generic "trace_syscall()" (or something like that) in ptrace.c (x86)
  which gather informations from the current syscalls (get from the mapped table)
  and then send the trace to the ring buffer.

- have a pretty printing (well, not that much actually) callback which, again,
  retrieve the syscall information from its number after getting the trace from
  the ring buffer. And then the raw field values aree printed, with the field
  names, and their types, optionally.

Now what I would suggest to avoid this whole listing of syscalls in your patch
is to avoid the use of hardcoded tracepoints.

We can't really use TRACE_EVENT() here without using the listing you did.
Instead, you could define a custom struct ftrace_event_call from DEFINE_SYSCALL().

In regfunc() you can turn on TIF_FTRACE (using a refcounter).

The struct trace_event ftrace_event_type can reuse the existing output callback
for syscall tracing which retrieve the syscall informations.

void ftrace_raw_event_##call() can be replaced by calling directly the existing
generic callback for syscall tracing trace insertion.

And the arch mapping table can resolve a syscall number to its matching
event.



The rest of the challenge is the pretty printing because of complex types
such as structures pointers, strings, etc...
We can think about it later, the above is more important.

But some ideas if we do that later: through a quick access table that mapps
the types and gives us informations about them (should they be dereferenced,
how, which size, etc....). Again, this one can be generic and would
factorize some work.

Imagine that we have:

void syscall_foo(struct bar *b);
void syscall_foo2(struct bar *b, int blah);

If we hash each complex types such as struct bar* somewhere with
the appropriate callback and/or direct informations to handle them,
then we can build a hash of this type in the syscall metadata
which would give us an index to retrieve the appropriate callback
to handle it, or just the size of this field to know how much
we hav to copy in the ring buffer.

Better even to avoid more than one level to derefenc in the tracing fast
path, we can build the right things on boot, having a bit
for each parameter which tells whether the field has to be dereferenced
and which size in this case. We would just need to put these informations
for each complex types somewhere and glue them  dynamically
on each syscall metadata that need it during the boot.


Example:

struct syscall_param_meta {
	.name = "struct bar __user *",
	.deref = 1,
	.size = sizeof(struct bar)
	.print = bar_printer
};

Put it in a param_meta hash table:

[ hash_to_struct_bar_meta, hash_to_other_complex_type, etc...]

Now we can add some fields in the syscall metadata, such as

	.param_name = "struct bar __user*" (added on DEFINE_SYSCALL())
	.deref = 0 (filled on boot)
	.size = 0 (filled on boot, or by default sizeof(struct bar __user*))

Then on boot, we iterate through the syscalls metadata, hash each types,
find the matching syscall param meta, and copy the relevant informations
for the fast path (tracing) which are deref and size.

And the slow path (printing) we can retrieve more informations such as
the callback to handle this type.

The interesting thing is that we define how to handle this type once
and it's propagated for each syscalls that use it.


Hmm?

