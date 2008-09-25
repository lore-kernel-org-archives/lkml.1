Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYIYW5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYIYW5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYIYW4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:56:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYIYW4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:56:54 -0400
Date: Fri, 26 Sep 2008 00:55:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925225558.GA5768@elte.hu>
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC1338.6050107@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Linus Torvalds wrote:

> > The reason I say "and no" is that it's not technically really 
> > possible to atomically give the exact TSC at which the frequency 
> > change took place. We just don't have the information, and I doubt 
> > we will ever have it.
> 
> Well, you don't need the tsc at the precise moment of the frequency 
> change.  You just need to emit the current tsc+frequency+wallclock 
> time before you emit any more delta records after the frequency 
> change.  You can't fetch all those values instantaneously, but you can 
> get close.

hm, i'm not sure you've thought through this delta record idea.

Take a system that goes idle thousands of times a second. (it's easy - 
just some networking workload)

Now take a tracer that just wants to emit a trace entry every now and 
then. Once or twice a second or so.

Note that suddenly you have thousands of totally artificial 'delta' time 
records between two real events, and have to post-process all your way 
up between these events to get to the real timeline.

... it is totally impractical and costly.

and then i havent even mentioned some other big complications:

 - the numeric errors that mount up over thousands of delta events

 - the memory overhead over thousands of entries

 - the fact that cpufreq and PLL changes are rarely atomic and that the
   TSC can flip-flop between two frequencies.

TSC based delta time post-processing is just not practical. Micro-time 
has to be synced up to GTOD in some manner - OR you might declare that 
the TSC _has_ to never stop and has to be constant. (no modern x86 CPU 
meets that criterium at the moment though.)

... and the moment you accept the fact that the GTOD _has_ to be mixed 
into it, all the rest follows pretty much automatically: either you 
store the (GTOD,freq,TSC) triple and post-process that absolute 
timestamp, and you accept the in-memory cost of that and do 
post-processing, or you compress that triple in situ and store the 
result only.

[ You will then also want some fall-back implementation for CPUs that 
  have no TSCs, and for architectures that have no default 
  implementation - something jiffies based. And you want some special 
  hooks for paravirt, as always. ]

I.e. you will end up having something quite close to 
cpu_clock()/sched_clock().

_Or_ if you manage to get any better than that for tracing then please 
tell us about it because we want to apply those concepts to 
cpu_clock()/sched_clock() too :-)

	Ingo
