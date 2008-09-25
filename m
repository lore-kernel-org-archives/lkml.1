Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYIYRNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYIYRNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYIYRNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:13:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbYIYRNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:13:41 -0400
Date: Thu, 25 Sep 2008 10:07:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809251002290.3265@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
 <alpine.DEB.1.10.0809251247010.27920@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Steven Rostedt wrote:
> 
> Slight correction. You can annotate the function with "notrace" and 
> that function will not be traced. So the "only be disabled on a per-file
> basis" statement is false.

Ok. It's still true that we absolutely don't want to add random notrace 
markers to code just because it's shared with the scheduler. And 
"sched_clock()" is not a single function with just a few well-defined 
places, nor are all versions of it at all appropriate for tracing (the 
non-TSC ones are a total joke - it works for scheduling, but not tracing. 
Same goes for the virtualized versions).

> Currently my code calls "ring_buffer_time_stamp" to get the time stamp, 
> whatever it will be.  Currently it is using sched_clock, but since I have 
> it as a wrapper, it shouldn't be too hard to modify later.

Yes. The code looked fine, and had a FIXME. I have no objection to using 
it as a known buggy approximation for TSC in order to not force every 
architecture to immediately write one when the patch is discussed. But I 
literally would expect that on x86, we'd basically just have a function 
that does "rdtsc" for the common case, along with possibly a generic 
fallback that does "xadd" in the absense of any other reasonable 
alternative.

				Linus
