Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYI0Rut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYI0Rut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYI0Rlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:41:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbYI0Rla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:41:30 -0400
Date: Sat, 27 Sep 2008 19:36:52 +0200
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
Message-ID: <20080927173652.GA11126@elte.hu>
References: <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809251325450.3265@nehalem.linux-foundation.org> <20080925211017.GA12689@elte.hu> <20080925214134.GA23025@elte.hu> <alpine.LFD.1.10.0809251458020.3265@nehalem.linux-foundation.org> <20080925221441.GA29060@elte.hu> <alpine.LFD.1.10.0809251631460.3265@nehalem.linux-foundation.org> <20080927171640.GA1990@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927171640.GA1990@elte.hu>
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

> Historically we've been flip-flopping on that issue in ftrace, whether 
> it should be coherent by default or not. We had at least three of four 
> variations of global synchronization. (one was an atomic generation 
> counter, another variant a global lock)

let me outline why that flip-flopping occured.

 - coherent tracer: has built-in serialization of global events. If the
   tracer shows events to be after each other, they were after each
   other.

 - incoherent tracer: events might be mixed up slightly on the micro
   scale.

In your tree you'll see dozens of fixes from me in the past 10 years or 
so where i used various tracers to find some bug. Some of them were done 
with coherent tracers, some of them were done with incoherent tracers.

Here a few common patterns that influenced which kind of tracer i used:

 - SMP races. There it's really important to see the ordering of events, 
   and coherent tracers (where the ordering of events as displayed by 
   the tracer can be trusted) are used by default

 - EXCEPT: _very_ often an SMP race goes away if we add global
   synchronization to trace events. Sometimes the pure delay can hide
   races. So incoherent tracers are very important here.

 - analysis of performance problems: here incoherent tracers win hands 
   down. It's important to see all events on all CPUs, but it's not at 
   all important to see the precise micro-ordering of events on a global
   basis. We want to see rough workload behavior, how tasks iteract - 
   and most importantly, we want tracing to be as low-overhead as 
   possible.

 - [ in many cases coherency does not matter because we only look at a 
     single CPU's or app's trace. ]

for example on an 16-way CPU, when i run a high-event-count workload and 
add global serialization to events, the workload can easily be slower by 
10% or more. Sometimes even the characteristics of the workload changes 
due to having a globally synchronized tracer.

So ... neither coherent nor incoherent tracers are a clear, obvious 
default.

IMO incoherent is the more useful default in terms of being able to find 
bugs with it, because it has a higher utility factor. People have to 
interpret traces anyway, and the main usecase of ftrace is that i ask a 
tester to do a trace, and then i interpret it.

Coherent is the more fool-proof default - but less generally usable.

ftrace was coherent not so long ago - so we can certainly switch back to 
that, as a default. But coherency must not be hardcoded into a multi-CPU 
tracer.

Since the overhead and serialization skew shows up very quickly in 
ftrace we do not serialize globally and use cpu_clock() and try to make 
that accurate enough.

But in any case, cpu_clock()/sched_clock() is non-serialized, so it can 
be used in coherent and non-coherent tracers just as well. So i dont see 
the fundamental connection.

	Ingo
