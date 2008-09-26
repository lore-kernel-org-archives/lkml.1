Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYIZBRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYIZBRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYIZBRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:17:34 -0400
Received: from gw.goop.org ([64.81.55.164]:56089 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYIZBRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:17:33 -0400
Message-ID: <48DC382A.8000407@goop.org>
Date: Thu, 25 Sep 2008 18:17:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org> <20080925225558.GA5768@elte.hu>
In-Reply-To: <20080925225558.GA5768@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, i'm not sure you've thought through this delta record idea.
>
> Take a system that goes idle thousands of times a second. (it's easy - 
> just some networking workload)
>
> Now take a tracer that just wants to emit a trace entry every now and 
> then. Once or twice a second or so.
>
> Note that suddenly you have thousands of totally artificial 'delta' time 
> records between two real events, and have to post-process all your way 
> up between these events to get to the real timeline.
>
> ... it is totally impractical and costly.
>   

No, as I said:  "You just need to emit the current
tsc+frequency+wallclock time before you emit any more delta records
after the frequency change."

When an event which affects the tsc occurs, like a frequency change or
pause, set a flag.  When you're next about to emit a delta, check the
flag and emit new timing parameters (or instead).

> and then i havent even mentioned some other big complications:
>
>  - the numeric errors that mount up over thousands of delta events
>  - the memory overhead over thousands of entries
>   
No, you only need to emit records as needed.

>  - the fact that cpufreq and PLL changes are rarely atomic and that the
>    TSC can flip-flop between two frequencies.
>   

You need to know the frequency at the time you sample the tsc, and you
need to know when the frequency changes.  If you don't, you can't use
the tsc for time, regardless of whether you process it immediately or
post-process it.

> ... and the moment you accept the fact that the GTOD _has_ to be mixed 
> into it, all the rest follows pretty much automatically: either you 
> store the (GTOD,freq,TSC) triple and post-process that absolute 
> timestamp, and you accept the in-memory cost of that and do 
> post-processing, or you compress that triple in situ and store the 
> result only.
>   

Right.  You store (GTOD,freq,tsc) every time you need that information,
and then interpolate with the tsc while you know its monotonic.

Unless your tsc is completely screwed, the (GTOD,freq,tsc) triple is
going to be stored at a fairly low frequency, and won't fill your event
buffer very much (though it might be a large proportion of your recorded
events if you're only recording stuff at a low frequency).

> [ You will then also want some fall-back implementation for CPUs that 
>   have no TSCs, and for architectures that have no default 
>   implementation - something jiffies based

Well, whatever the best timer the platform has.  And maybe its already
processed into real time, in which case you just emit raw deltas and
never worry about updating the timing parameters.

> . And you want some special hooks for paravirt, as always. ]
>   
Yeah.  The scheme relies on a cpu's tsc remaining the cpu's tsc.

> I.e. you will end up having something quite close to 
> cpu_clock()/sched_clock().
>
> _Or_ if you manage to get any better than that for tracing then please 
> tell us about it because we want to apply those concepts to 
> cpu_clock()/sched_clock() too :-)

Well, its what Xen does already for time.  It works well.

    J
