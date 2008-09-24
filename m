Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYIXUcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYIXUcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYIXUci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:32:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYIXUch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:32:37 -0400
Date: Wed, 24 Sep 2008 13:30:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Bligh <mbligh@google.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>  <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Martin Bligh wrote:
> 
> If we just record the TSC unshifted, in 27 bits, at 4GHz, that gives us
> about 1/30 of a second? So we either shift, use > 27 bits, or record
> at least 30 events a second, none of which I like much ...

No, we don't shift (we don't want to lose precision), and we don't use 
more than 27 bits by default.

the TSC at each entry should be a _delta_. It's the difference from the 
last one. And if you get less than 30 events per second, and you need a 
bigger difference, you insert an extra "sync" tracepoint that has a 59-bit 
thing (27 bits _plus_ the extra 'data').

Yes, it adds 8 bytes (assuming that minimal format), but it does so only 
for any trace event that is more than 1/30th of a second from its previous 
one. IOW, think of this not in bytes, but in bytes-per-second. It adds at 
most 8*30=240 bytes per second, but what it _saves_ is that when you have 
tens of thousands of events, it shaves 4 bytes FOR EACH EVENT.

See?

Also, quite often, the clock won't be running at 4GHz even if the CPU 
might. Intel already doesn't make the TSC be the nominal frequency, and 
other architectures with TSC's have long had the TSC be something like a 
"divide-by-16" clock rather than every single cycle because it's more 
power-efficient.

So there is often a built-in shift, and I doubt we'll see 10GHz TSC's even 
if we see 10GHz CPU's (which many people consider unlikely anyway, but 
I'm not going to bet against technology).

			Linus
