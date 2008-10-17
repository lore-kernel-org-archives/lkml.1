Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYJQB2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYJQB2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYJQB2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:28:39 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:51527 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbYJQB2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:28:37 -0400
X-Greylist: delayed 2706 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 21:28:37 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEACCC90hMQWq+/2dsb2JhbACBcsISg2w
Date: Thu, 16 Oct 2008 21:28:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081017012835.GA30195@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:44:03 up 134 days,  5:24, 11 users,  load average: 0.85, 0.57,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 16 Oct 2008, Mathieu Desnoyers wrote:
> >
> > +static inline cycles_t ltt_async_tsc_read(void)
> 
> (a) this shouldn't be inline
> 

Ok, will fix. I will put this in a new arch/x86/kernel/ltt.c.

> > +	rdtsc_barrier();
> > +	new_tsc = get_cycles();
> > +	rdtsc_barrier();
> > +	do {
> > +		last_tsc = ltt_last_tsc;
> > +		if (new_tsc < last_tsc)
> > +			new_tsc = last_tsc + LTT_MIN_PROBE_DURATION;
> > +		/*
> > +		 * If cmpxchg fails with a value higher than the new_tsc, don't
> > +		 * retry : the value has been incremented and the events
> > +		 * happened almost at the same time.
> > +		 * We must retry if cmpxchg fails with a lower value :
> > +		 * it means that we are the CPU with highest frequency and
> > +		 * therefore MUST update the value.
> > +		 */
> > +	} while (cmpxchg64(&ltt_last_tsc, last_tsc, new_tsc) < new_tsc);
> 
> (b) This is really quite expensive.
> 

Ok, let's try to figure out what the use-cases are, because we are
really facing an architectural mess (thanks to Intel and AMD). I don't
think there is a single perfect solution for all, but I'll try to
explain why I accept the cache-line bouncing behavior when
unsynchronized TSCs are detected by LTTng.

First, the most important thing in LTTng is to provide the event flow
in the correct order across CPUs. Secondary to that, getting the precise
execution time is a nice-to-have when the architecture supports it, but
the time granularity itself is not crucially important, as long as we
have a way to determine which of two events close in time happens first.
The principal use-case where I have seen such tracer in action is when
one have to understand why one or more processes are slower than
expected. The root cause can easily sit on another CPU, be a locking
delay in a particular race condition, or just a process waiting for
other processes waiting for a timeout.


> Why do things like this? Make the timestamps be per-cpu. If you do things 
> like the above, then just getting the timestamp means that every single 
> trace event will cause a cacheline bounce, and if you do that, you might 
> as well just not have per-cpu tracing at all.
> 

This cache-line bouncing global clock is a best-effort to provide
correct event order in the trace on architectures with unsync tsc. It's
actually better than a global tracing buffer because it limits the
number of cache line transfers required to one per event. Global tracing
buffers may require to transfer many cache lines across CPUs when events
are written across cache lines or larger than a cache line.

> It really boils down to two cases:
> 
>  - you do per-CPU traces
> 
>    If so, you need to ONLY EVER touch per-cpu data when tracing, and the 
>    above is a fundamental BUG. Dirtying shared cachelines makes the whole 
>    per-cpu thing pointless.

Sharing only a single cache-line is not completely pointless, as
explained above, but yes, there is a big performance hit involved.

I agree that we should maybe add a degree of flexibility in this time
infrastructure to let users select the type of time source they want :

- Global clock, potentially slow on unsynchronized CPUs.
- Local clock, fast, possibility unsynchronized across CPUs.

> 
>  - you do global traces
> 
>    Sure, then the above works, but why bother? You'll get the ordering 
>    from the global trace, you might as well do time stamps with local 
>    counts.
> 

I simply don't like the global traces because of the extra cache-line
bouncing experienced by events written on multiple cache-lines.

> So in neither case does it make any sense to try to do that global 
> ltt_last_tsc.
> 
> Perhaps more importantly - if the TSC really are out of whack, that just 
> means that now all your timestamps are worthless, because the value you 
> calculate ends up having NOTHING to do with the timestamp. So you cannot 
> even use it to see how long something took, because it may be that you're 
> running on the CPU that runs behind, and all you ever see is the value of 
> LTT_MIN_PROBE_DURATION.
> 

I thought about this one. There is actually a FIXME in the code which
plans to add an IPI called at each timer interrupt to do a "read tsc" on
each CPU. This would give an HZ upper bound to the time precision, which
would give a trace with events ordered across CPUs and manage to have
the execution time at a HZ precision.

So given that global buffers are less efficient that just synchronizing
a single cache-line and that some people are willing to pay the price to
get events synchronized across CPUs and others are not, what do you
think of leaving the choice to the user about globally/locally
synchronized timestamps ?

Thanks for the feedback,

Mathieu

> 			Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
