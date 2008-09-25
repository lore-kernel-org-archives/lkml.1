Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYIYQXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYIYQXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYIYQXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:23:23 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:46729 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593AbYIYQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:23:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPJU20hMQWq+/2dsb2JhbACBXrksgWU
Date: Thu, 25 Sep 2008 12:23:15 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Bligh <mbligh@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925162315.GA649@Krystal>
References: <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080925153635.GA12840@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:17:09 up 112 days, 20:57, 11 users,  load average: 1.85, 1.90,
	1.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Martin Bligh <mbligh@google.com> wrote:
> 
> > > And I don't think normalizing later is in any way more fundamentally 
> > > hard. It just means that you do part of the expensive things after 
> > > you have gathered the trace, rather than during.
> > 
> > Agree with you on doing the expensive stuff later. If we wanted to get 
> > something that'd pack down to a couple fewer bits, and approximate ns, 
> > we could always >> 1 if you were > 2GHz, and >> 2 if you where > 4GHz, 
> > etc. which is at least cheap.
> 
> ... which is exactly what sched_clock() does, combined with a 
> multiplication. (which is about as expensive as normal linear 
> arithmetics on most CPUs - i.e. in the 1 cycle range)
> 
> Normalizing has the advantage that we dont have to worry about it ever 
> again. Not about a changing scale due to cpufreq, slowing down or 
> speeding up TSCs due to C2/C3. We have so much TSC breakage all across 
> the spectrum that post-processing it is a nightmare in practice. Plus we 
> want sched_clock() to be fast anyway.
> 
> in the distant future we not only will have constant-TSC but it wont 
> stop in C2/C3 either at a whim (which they do right now, messing up 
> timestamps). At that stage fast time readout it will be so sane that CPU 
> makers should really provide a nanosec readout - it's easy to do a 
> simple multiplicator and hide the few cycles multiplicator latency to 
> RDTSC (this is continuous time after all so it's easy for the hw).
> 
> Hm?
> 
> 	Ingo
> 

Hi Ingo,

The problem with sched_clock is that it gives a 1 HZ timestamp accuracy
for events happening across different CPUs. Within this 1 HZ range, it
uses the TSC and clip when it reaches a max. Good enough for scheduler
or for tracing events on a single CPU, but I think it is not exactly
what we need to reorder events happening across CPUs.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
