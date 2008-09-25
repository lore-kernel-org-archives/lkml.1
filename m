Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbYIYPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbYIYPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYIYPhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:37:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYIYPhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:37:13 -0400
Date: Thu, 25 Sep 2008 17:36:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Bligh <mbligh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925153635.GA12840@elte.hu>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com>
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


* Martin Bligh <mbligh@google.com> wrote:

> > And I don't think normalizing later is in any way more fundamentally 
> > hard. It just means that you do part of the expensive things after 
> > you have gathered the trace, rather than during.
> 
> Agree with you on doing the expensive stuff later. If we wanted to get 
> something that'd pack down to a couple fewer bits, and approximate ns, 
> we could always >> 1 if you were > 2GHz, and >> 2 if you where > 4GHz, 
> etc. which is at least cheap.

... which is exactly what sched_clock() does, combined with a 
multiplication. (which is about as expensive as normal linear 
arithmetics on most CPUs - i.e. in the 1 cycle range)

Normalizing has the advantage that we dont have to worry about it ever 
again. Not about a changing scale due to cpufreq, slowing down or 
speeding up TSCs due to C2/C3. We have so much TSC breakage all across 
the spectrum that post-processing it is a nightmare in practice. Plus we 
want sched_clock() to be fast anyway.

in the distant future we not only will have constant-TSC but it wont 
stop in C2/C3 either at a whim (which they do right now, messing up 
timestamps). At that stage fast time readout it will be so sane that CPU 
makers should really provide a nanosec readout - it's easy to do a 
simple multiplicator and hide the few cycles multiplicator latency to 
RDTSC (this is continuous time after all so it's easy for the hw).

Hm?

	Ingo
