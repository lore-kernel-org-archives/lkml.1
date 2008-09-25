Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYIYUNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYIYUNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYIYUNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:13:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYIYUNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:13:09 -0400
Date: Thu, 25 Sep 2008 22:12:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925201211.GA1878@elte.hu>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925195522.GA22248@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> firstly, for the sake of full disclosure, the very first versions of 
> the latency tracer (which, through hundreds of revisions, morphed into 
> ftrace), used raw TSC timestamps.
> 
> I stuck to that simple design for a _long_ time because i shared your 
> exact views about robustness and simplicity. But it was pure utter 
> nightmare to get the timings right after the fact, and i got a _lot_ 
> of complaints about the quality of timings, and i could never _trust_ 
> the timings myself for certain types of analysis.
> 
> So i eventually went to the scheduler clock and never looked back.
> 
> So i've been there, i've done that. In fact i briefly tried to use the 
> _GTOD_ clock for tracing - that was utter nightmare as well, because 
> the scale and breath of the GTOD code is staggering.

heh, and i even have a link for a latency tracing patch for 2005 that is 
still alive that proves it:

   http://people.redhat.com/mingo/latency-tracing-patches/patches/latency-tracing.patch

(dont look at the quality of that code too much)

It has this line for timestamp generation:

+       timestamp = get_cycles();

i.e. we used the raw TSC, we used RDTSC straight away, and we used that 
for _years_, literally.

So i can tell you my direct experience with it: i had far more problems 
with the tracer due to inexact timings and traces that i could not 
depend on, than i had problems with sched_clock() locking up or 
crashing.

Far more people complained about the accuracy of timings than about 
performance or about the ability (or inability) to stream gigs of 
tracing data to user-space.

It was a very striking difference:

  - every second person who used the tracer observed that the timings 
    looked odd at places.

  - only every 6 months has someone asked whether he could save 
    gigabytes of trace data.

For years i maintained a tracer with TSC timestamps, and for years i 
maintained another tracer that used sched_clock(). Exact timings are a 
feature most people are willing to spend extra cycles on.

You seem to dismiss that angle by calling my arguments bullshit, but i 
dont know on what basis you dismiss it. Sure, a feature and extra 
complexity _always_ has a robustness cost. If your argument is that we 
should move cpu_clock() to assembly to make it more dependable - i'm all 
for it.

	Ingo
