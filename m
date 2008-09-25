Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYIYRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYIYRYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYIYRYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:24:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbYIYRYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:24:03 -0400
Date: Thu, 25 Sep 2008 10:22:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809251120420.27300@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809251010291.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> 
 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>  <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> 
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>  <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>  <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251120420.27300@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Steven Rostedt wrote:
> 
> If we do not normalize, then we must come up yet another generic way to read 
> the CPU clock for all archs. And then we also need to come up with another 
> generic way to normalize it later for output.

Why would any of this be "generic"?

Quite the reverse. It should be as trace-buffer specific as possible, so 
that we do *not* share any code or any constraints with other people.

Just do rdtsc at first, and make it depend on x86. If the thing is made 
simple enough, it will be a couple of lines of code for architectures to 
read their own timestamp counters.

And since the normalization is then no longer in the critical part, _that_ 
can be architecture-independent, but obviously still trace-specific. You 
need to know the frequency, and that involves having frequency events in 
the trace if it changes, but if you don't see any frequency events you 
just take "current frequency".

And doing it at trace parse time, we can some day enable a boot trace that 
actually WORKS. Have you looked at the timestamp events we get from 
"sched_clock()" in early bootup? They show up in the kernel logs when you 
have CONFIG_PRINTK_TIME. And they are totally and utterly broken and 
_useless_ for the early stages right now. And they shouldn't have to be 
that way.

Yeah, we'll never be able to trace stuff that happens really early 
(tracing will obviously always need kernel page tables and some really 
basic stuf working), but we should be able to trace through things like 
TSC calibration for boot time analysis. It wasn't that long ago that we 
had the whole discussion about TSC calibration taking 200ms. Or the early 
ACPI code. And get meaningful data.

			Linus
