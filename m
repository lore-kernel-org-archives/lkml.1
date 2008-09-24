Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbYIXUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbYIXUl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIXUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:41:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbYIXUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:41:16 -0400
Date: Wed, 24 Sep 2008 13:39:54 -0700 (PDT)
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
In-Reply-To: <33307c790809241104k2af4b900w781aba1a1393004b@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809241330270.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>  <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <33307c790809241104k2af4b900w781aba1a1393004b@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Martin Bligh wrote:
> 
> If we use 32 bits instead of 27, then the timestamp events are only
> about once per second, which is probably fine for overhead ... ?

You'd have them ONCE IN A BLUE MOON.

If there is nothing going on, you don't need the timestamps at all.

Yes, some people will _want_ a heartbeat, of course, and there might be 
serialization points where we want to serialize some external clock to the 
TSC, but that's a separate issue from generating a full TSC value. We may 
well decide that once a second we want a whole packet with TSC _and_ 
HR-timer sync information, for example. But that's a separate issue.

And if there is a lot of things going on (eg you're tracing things like a 
block device performance issue), you have events _much_ closer to each 
other than 1/30th of a second, and you again _never_ need a full 59-bit 
timestamp. Because the delta would be cumulative, and as long as you are 
generating events, you're also updating the base TSC.

The only case you'll see lots of those timestamps (where "lots" is 
guaranteed to be less than 30 in one second) would be if you're tracing 
something that literally does a couple of events per second. But then you 
sure as hell don't need to worry about performance _or_ memory use. If you 
have some trace that gives you five hits per second (and spread out, to 
boot!), you'll generate twice the number of trace entries because each 
entry would always be preceded by an extended thing, but hey, do we really 
worry about five trace events per second?

And quite frankly, most of the tracing I've ever done really does fall 
into the "either nothing" or "a flood of events" thing. The "5-25 events 
per second at regular intervals" case really doesn't sound very common at 
all - not that I would worry about it if it was since it's going to be a 
really simple case..

And btw, this would be an issue only on really fast CPU's anyway. If 
you're in the mobile space, your TSC will be clocking at less than that, 
so the slower the machine, the less the overhead. Again, that's exactly 
what you want - the overhead is not some fixed thing that is detemined by 
the fastest possible TSC and hurts slower machines too, it's relative to 
the speed of the machine itself.

(Of course, with cpufreq and fixed TSC's, a 2GHz CPU will have a 2GHz TSC 
even when it's running at just 1GHz, but the worry is more about trying to 
trace on an embedded board with some pitiful 500MHz thing that is pretty 
overworked anyway).

			Linus
