Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYIYVPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYIYVPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYIYVOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:14:49 -0400
Received: from gw.goop.org ([64.81.55.164]:52213 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbYIYVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:14:48 -0400
Message-ID: <48DBFF46.1060405@goop.org>
Date: Thu, 25 Sep 2008 14:14:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
References: <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org> <20080925195522.GA22248@elte.hu> <20080925201211.GA1878@elte.hu> <alpine.LFD.1.10.0809251318270.3265@nehalem.linux-foundation.org> <20080925205218.GA8997@elte.hu>
In-Reply-To: <20080925205218.GA8997@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>   
>> On Thu, 25 Sep 2008, Ingo Molnar wrote:
>>     
>>> You seem to dismiss that angle by calling my arguments bullshit, but 
>>> i dont know on what basis you dismiss it. Sure, a feature and extra 
>>> complexity _always_ has a robustness cost. If your argument is that 
>>> we should move cpu_clock() to assembly to make it more dependable - 
>>> i'm all for it.
>>>       
>> Umm. cpu_clock() isn't even cross-cpu synchronized, and has actually 
>> thrown away all the information that can make it so, afaik. At least 
>> the comments say "never more than 2 jiffies difference"). You do 
>> realize that if you want to order events across CPU's, we're not 
>> talking about "jiffies" here, we're talking about 50-100 CPU _cycles_.
>>     
>
> Steve got the _worst-case_ cpu_clock() difference down to 60 usecs not 
> so long ago. It might have regressed since then, it's really hard to do 
> it without cross-CPU synchronization.
>
> ( But it's not impossible, as Steve has proven it, because physical time
>   goes on linearly on each CPU so we have a chance to do it: by
>   accurately correlating the GTOD timestamps we get at to-idle/from-idle
>   times to the TSC. )
>
> And note that i'm not only talking about cross-CPU synchronization, i'm 
> also talking about _single CPU_ timestamps. How do you get it right with 
> TSCs via a pure postprocessing method? A very large body of modern CPUs 
> will halt the TSC when they go into idle. (about 70% of the installed 
> base or so)
>
> Note, we absolutely cannot do accurate timings in a pure 
> TSC-post-processing environment: unless you want to trace _every_ 
> to-idle and from-idle event, which can easily be tens of thousands of 
> extra events per seconds.
>
> What we could do perhaps is a hybrid method:
>
>  - save a GTOD+TSC pair at important events, such as to-idle and
>    from-idle, and in the periodic sched_tick(). [ perhaps also save it 
>    when we change cpufreq. ]
>
>  - save the (last_GTOD, _relative_-TSC) pair in the trace entry
>
> with that we have a chance to do good post-processed correlation - at 
> the cost of having 12-16 bytes of timestamp, per trace entry.
>
> Or we could upscale the GTOD to 'TSC time', at go-idle and from-idle. 
> Which is rather complicated with cpufreq - which frequency do we want to 
> upscale to if we have a box with three available frequencies? We could 
> ignore cpufreq altogether - but then there goes dependable tracing on 
> another range of boxes.
>   

The "full timestamp" records should include:

    * absolute tsc
    * absolute monotonic timestamp
    * new tsc freqency

If you then make sure that all the cpufreq/idle/suspend-resume code
emits appropriate records when changing the tsc frequency, then you
should always be able to fully regenerate an absolute timestamp.

If you generate the monotonic timestamp with a good clocksource, then
you should be able to correlate the timestamps between cpus.

Oddly enough, this is identical to the Xen clocksource's use of the tsc ;)

    J
