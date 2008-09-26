Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYIZC0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYIZC0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYIZCZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:25:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37855 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYIZCZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:25:55 -0400
Date: Thu, 25 Sep 2008 22:25:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <48DC43D7.5010008@goop.org>
Message-ID: <alpine.DEB.1.10.0809252212480.8454@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
 <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
 <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org>
 <48DC1338.6050107@goop.org> <alpine.DEB.1.10.0809251848170.32742@gandalf.stny.rr.com> <48DC3A89.9020407@goop.org> <alpine.DEB.1.10.0809252132410.8454@gandalf.stny.rr .com> <48DC43D7.5010008@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[
  "When people ask me what language my mother tongue is,
   I simply reply 'C'" - Steven Rostedt
]

This is exactly why I have that saying ;-)


On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > OK, let me rephrase my question.
> >
> > How and where do we record this?  Do we keep this information in some 
> > global variable that we must compare to every time we add a new item in 
> > the trace?
> >
> > Do we have the buffer register a call back to record this information?
> >   
> 
> Something like (total pseudocode):

Good enough.

> 
> struct tsc_time_parameters {
> 	int version;		/* even - values OK; odd - values being updated */
> 	u64 tsc;
> 	u32 tsc_freq;
> 	u64 gtod;
> };
> 
> DEFINE_PERCPU(struct tsc_time_parameters, tsc_params);

These are all global I presume (No "static" in front)

> 
> /* To be called after a tsc frequency change, before any new
>    trace records are being emitted, in a context where we can call get_GTOD() */
> void update_tsc_params(void)

So this needs to be called by the cpu freq code?

> {
> 	struct tsc_time_parameters *p = __get_percpu_var(tsc_params);
> 
> 	p->version |= 1;
> 	wmb();
> 
> 	p->tsc = get_tsc();
> 	p->tsc_freq = get_tsc_freq();
> 	p->gtod = get_GTOD();
> 
> 	wmb();
> 	p->version++;
> 	wmb();
> }
> 
> DEFINE_PERCPU(unsigned, current_tsc_version);
> DEFINE_PERCPU(u64, prev_tsc);
> 
> /* may be called in any context */
> u64 get_trace_timestamp_delta(void)
> {
> 	const struct tsc_time_parameters *p = &__get_percpu_var(tsc_params);
> 	unsigned *current_version = &__get_cpu_var(current_tsc_version);
> 	u64 prev = __get_cpu_var(prev_tsc);
> 	u64 now, ret;
> 
> 	/* check the current tsc_params version against the last one we emitted;
> 		if the version is odd, then we interrupted the parameters as they were
> 		being updated, so just emit a new delta with the old parameters */
> 	if (unlikely(*current_version != p->version && !(p->version & 1))) {
> 		/* XXX probably need a loop to deal with p->version changing under our feet */
> 		emit_tsc_freq_record(p);

I take it the above is your record to the tracer?

> 		prev = p->tsc;
> 		__get_cpu_var(current_tsc_version) = p->version;
> 	}
> 
> 	now = read_tsc();

We probably wont to check here that p didn't change again.
and try again if it did.

> 	ret = now - prev;
> 	__get_cpu_var(prev_tsc) = now;
> 
> 	return ret;
> }


Hmm, the beginning of each patch will need to record the global tsc, as 
well as this information. Simply because in overwrite mode, we do not want 
to lose it if the producer is faster than te consumer.

-- Steve

