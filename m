Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYIWOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYIWOMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYIWOMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:12:12 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:34097 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbYIWOMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:12:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsFAA+W2EhMQWq+/2dsb2JhbACBXrZPgWc
Date: Tue, 23 Sep 2008 10:12:05 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Roland Dreier <rdreier@cisco.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
Message-ID: <20080923141205.GB23185@Krystal>
References: <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com> <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com> <alpine.LFD.1.10.0809222106090.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809222106090.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:58:07 up 110 days, 18:38,  7 users,  load average: 0.12, 0.26,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 22 Sep 2008, Steven Rostedt wrote:
> > 
> > But, with that, with a global atomic counter, and the following trace:
> > 
> > cpu 0: trace_point_a
> > cpu 1: trace_point_c
> > cpu 0: trace_point_b
> > cpu 1: trace_point_d
> > 
> > Could the event a really come after event d, even though we already hit 
> > event b?
> 
> Each tracepoint will basically give a partial ordering (if you make it so, 
> of course - and on x86 it's hard to avoid it).
> 
> And with many trace-points, you can narrow down ordering if you're lucky.
> 
> But say that you have code like
> 
> 	CPU#1		CPU#2
> 
> 	trace_a		trace_c
> 	..		..
> 	trace_b		trace_d
> 
> and since each CPU itself is obviously strictly ordered, you a priori know 
> that a < b, and c < d. But your trace buffer can look many different ways:
> 
>  - a -> b -> c -> d
>    c -> d -> a -> b
> 
>    Now you do know that what happened between c and d must all have 
>    happened entirely after/before the things that happened between
>    a and b, and there is no overlap.
> 
>    This is only assuming the x86 full memory barrier from a "lock xadd" of 
>    course, but those are the semantics you'd get on x86. On others, the 
>    ordering might not be that strong.
> 

Hrm, Documentation/atomic_ops.txt states that :

"Unlike the above routines, it is required that explicit memory
barriers are performed before and after the operation.  It must be
done such that all memory operations before and after the atomic
operation calls are strongly ordered with respect to the atomic
operation itself."

So on architectures with weaker ordering, the kernel atomic ops already
require that explicit smp_mb() are inserted before and after the atomic
increment. The same applies to cmpxchg.

Therefore I think it's ok, given the semantic provided by these two
atomic operations, to assume they imply a smp_mb() for any given
architecture. If not, then the architecture-specific implementation
would be broken wrt the semantic.

>  - a -> c -> b -> d
>    a -> c -> d -> b
> 
>    With these trace point orderings, you really don't know anything at all 
>    about the order of any access that happened in between. CPU#1 might 
>    have gone first. Or not. Or partially. You simply do not know.
> 

Yep. If two "real kernel" events happen to belong to the same
overlapping time window, there is not much we can know about their
order. Adding tracing statements before and after traced kernel
operations could help to make this window as small as possible, but I
doubt it's worth the performance penality and event duplication (and
incremented trace size).

Mathieu


> > But I guess you are stating the fact that what the computer does 
> > internally, no one really knows. Without the help of real memory barriers, 
> > ording of memory accesses is mostly determined by tarot cards.
> 
> Well, x86 defines a memory order. But what I'm trying to explain is that 
> memory order still doesn't actually specify what happens to the code that 
> actually does tracing! The trace is only going to show the order of the 
> tracepoints, not the _other_ memory accesses. So you'll have *some* 
> information, but it's very partial.
> 
> And the thing is, all those other memory accesses are the ones that do all 
> the real work. You'll know they happened _somewhere_ between two 
> tracepoints, but not much more than that.
> 
> This is why timestamps aren't really any worse than sequence numbers in 
> all practical matters. They'll get you close enough that you can consider 
> them equivalent to a cache-coherent counter, just one that you don't have 
> to take a cache miss for, and that increments on its own!
> 
> Quite a lot of CPU's have nice, dependable, TSC's that run at constant 
> frequency. 
> 
> And quite a lot of traces care a _lot_ about real time. When you do IO 
> tracing, the problem is almost never about lock ordering or anything like 
> that. You want to see how long a request took. You don't care AT ALL how 
> many tracepoints were in between the beginning and end, you care about how 
> many microseconds there were!
> 
> 			Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
