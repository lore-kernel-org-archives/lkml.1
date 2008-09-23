Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYIWEUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYIWEUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYIWEUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:20:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbYIWEUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:20:09 -0400
Date: Mon, 22 Sep 2008 21:19:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Roland Dreier <rdreier@cisco.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809222106090.3265@nehalem.linux-foundation.org>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com> <alpine.LFD.1.10.0809222021230.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809222335400.26011@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Sep 2008, Steven Rostedt wrote:
> 
> But, with that, with a global atomic counter, and the following trace:
> 
> cpu 0: trace_point_a
> cpu 1: trace_point_c
> cpu 0: trace_point_b
> cpu 1: trace_point_d
> 
> Could the event a really come after event d, even though we already hit 
> event b?

Each tracepoint will basically give a partial ordering (if you make it so, 
of course - and on x86 it's hard to avoid it).

And with many trace-points, you can narrow down ordering if you're lucky.

But say that you have code like

	CPU#1		CPU#2

	trace_a		trace_c
	..		..
	trace_b		trace_d

and since each CPU itself is obviously strictly ordered, you a priori know 
that a < b, and c < d. But your trace buffer can look many different ways:

 - a -> b -> c -> d
   c -> d -> a -> b

   Now you do know that what happened between c and d must all have 
   happened entirely after/before the things that happened between
   a and b, and there is no overlap.

   This is only assuming the x86 full memory barrier from a "lock xadd" of 
   course, but those are the semantics you'd get on x86. On others, the 
   ordering might not be that strong.

 - a -> c -> b -> d
   a -> c -> d -> b

   With these trace point orderings, you really don't know anything at all 
   about the order of any access that happened in between. CPU#1 might 
   have gone first. Or not. Or partially. You simply do not know.

> But I guess you are stating the fact that what the computer does 
> internally, no one really knows. Without the help of real memory barriers, 
> ording of memory accesses is mostly determined by tarot cards.

Well, x86 defines a memory order. But what I'm trying to explain is that 
memory order still doesn't actually specify what happens to the code that 
actually does tracing! The trace is only going to show the order of the 
tracepoints, not the _other_ memory accesses. So you'll have *some* 
information, but it's very partial.

And the thing is, all those other memory accesses are the ones that do all 
the real work. You'll know they happened _somewhere_ between two 
tracepoints, but not much more than that.

This is why timestamps aren't really any worse than sequence numbers in 
all practical matters. They'll get you close enough that you can consider 
them equivalent to a cache-coherent counter, just one that you don't have 
to take a cache miss for, and that increments on its own!

Quite a lot of CPU's have nice, dependable, TSC's that run at constant 
frequency. 

And quite a lot of traces care a _lot_ about real time. When you do IO 
tracing, the problem is almost never about lock ordering or anything like 
that. You want to see how long a request took. You don't care AT ALL how 
many tracepoints were in between the beginning and end, you care about how 
many microseconds there were!

			Linus
