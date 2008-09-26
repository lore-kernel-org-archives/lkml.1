Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYIZFcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYIZFcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYIZFby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:31:54 -0400
Received: from gw.goop.org ([64.81.55.164]:55198 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbYIZFbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:31:53 -0400
Message-ID: <48DC73C2.5080309@goop.org>
Date: Thu, 25 Sep 2008 22:31:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org> <alpine.DEB.1.10.0809251848170.32742@gandalf.stny.rr.com> <48DC3A89.9020407@goop.org> <alpine.DEB.1.10.0809252132410.8454@gandalf.stny.rr .com> <48DC43D7.5010008@goop.org> <alpine.DEB.1.10.0809252212480.8454@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809252212480.8454@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> [
>   "When people ask me what language my mother tongue is,
>    I simply reply 'C'" - Steven Rostedt
> ]
>
> This is exactly why I have that saying ;-)
>
>
> On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:
>
>   
>> Steven Rostedt wrote:
>>     
>>> OK, let me rephrase my question.
>>>
>>> How and where do we record this?  Do we keep this information in some 
>>> global variable that we must compare to every time we add a new item in 
>>> the trace?
>>>
>>> Do we have the buffer register a call back to record this information?
>>>   
>>>       
>> Something like (total pseudocode):
>>     
>
> Good enough.
>
>   
>> struct tsc_time_parameters {
>> 	int version;		/* even - values OK; odd - values being updated */
>> 	u64 tsc;
>> 	u32 tsc_freq;
>> 	u64 gtod;
>> };
>>
>> DEFINE_PERCPU(struct tsc_time_parameters, tsc_params);
>>     
>
> These are all global I presume (No "static" in front)
>   

No, they could probably be static, depending where everything ends up. 
It would only need to get accessed from a couple of places.

>> /* To be called after a tsc frequency change, before any new
>>    trace records are being emitted, in a context where we can call get_GTOD() */
>> void update_tsc_params(void)
>>     
>
> So this needs to be called by the cpu freq code?
>   

Yes, and any other place the tsc might get affected, like going into a
C-state which stops the tsc, and things like suspend/resume.

>> {
>> 	struct tsc_time_parameters *p = __get_percpu_var(tsc_params);
>>
>> 	p->version |= 1;
>> 	wmb();
>>
>> 	p->tsc = get_tsc();
>> 	p->tsc_freq = get_tsc_freq();
>> 	p->gtod = get_GTOD();
>>
>> 	wmb();
>> 	p->version++;
>> 	wmb();
>> }
>>
>> DEFINE_PERCPU(unsigned, current_tsc_version);
>> DEFINE_PERCPU(u64, prev_tsc);
>>
>> /* may be called in any context */
>> u64 get_trace_timestamp_delta(void)
>> {
>> 	const struct tsc_time_parameters *p = &__get_percpu_var(tsc_params);
>> 	unsigned *current_version = &__get_cpu_var(current_tsc_version);
>> 	u64 prev = __get_cpu_var(prev_tsc);
>> 	u64 now, ret;
>>
>> 	/* check the current tsc_params version against the last one we emitted;
>> 		if the version is odd, then we interrupted the parameters as they were
>> 		being updated, so just emit a new delta with the old parameters */
>> 	if (unlikely(*current_version != p->version && !(p->version & 1))) {
>> 		/* XXX probably need a loop to deal with p->version changing under our feet */
>> 		emit_tsc_freq_record(p);
>>     
>
> I take it the above is your record to the tracer?
>   

Yeah.  No doubt it needs a few more parameters.

>> 		prev = p->tsc;
>> 		__get_cpu_var(current_tsc_version) = p->version;
>> 	}
>>
>> 	now = read_tsc();
>>     
>
> We probably wont to check here that p didn't change again.
> and try again if it did.
>   

Yeah, you may want to put the whole thing in a loop to make sure that
the version is consistent.  You might end up emitting multiple redundant
tsc parameters, but that should be very rare.

>> 	ret = now - prev;
>> 	__get_cpu_var(prev_tsc) = now;
>>
>> 	return ret;
>> }
>>     
>
>
> Hmm, the beginning of each patch will need to record the global tsc, as 
> well as this information. Simply because in overwrite mode, we do not want 
> to lose it if the producer is faster than te consumer.
>   

Each patch?  Page?

    J
