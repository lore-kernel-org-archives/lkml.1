Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIZOK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIZOK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYIZOKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:10:14 -0400
Received: from www.tglx.de ([62.245.132.106]:38269 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYIZOKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:10:12 -0400
Date: Fri, 26 Sep 2008 16:04:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809251840430.32742@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809261006030.27026@apollo.tec.linutronix.de>
References: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org>
 <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <20080925222548.GA28309@elte.hu> <alpine.DEB.1.10.0809251840430.32742@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Steven Rostedt wrote:
> On Fri, 26 Sep 2008, Ingo Molnar wrote:
> > 
> > Firstly they need a low-frequency (10khz-100khz) shared clock line 
> > across all CPUs. A single line - and since it's low frequency it could 
> > be overlaid on some existing data line and filtered out. That works 
> > across NUMA nodes as well and physics allows it to be nanosec accurate 
> > up to dozens of meters or so.
> 
> Can this possibly be true? I mean, light travels only one foot every
> nanosecond. Can it really keep nanosecond accuracy up to dozens of  meters 
> away? If you send the same signal to CPU1 that is 1 foot away, as well as 
> send it to CPU2 that is 2 feet away. CPU2 will get that signal at least 1 
> nanosec after CPU1 receives it.
> 
> Of course if the hardware is smart enough to know this topology, then it 
> could account for these delays in traffic.

Yup, it can be done. Ingo's proposal reminds me on a project we did in
1999 for distributed computing.

|------------|
|master clock|
|1 MHz       |===========[slave 1]=========[slave 2] ..........
|sync pulse  |
|1 Hz        |
|------------|

The slave implementation was a simple PLL driven by the master clock
with an output frequency of 1GHz. The micro seconds counter was driven
by the 1MHz clock and the nanoseconds part by the PLL clock. 

The nanoseconds counter was implemented so it stopped counting at 999
and it was reset to 0 when the 1MHz pulse came in. That made sure that
the PLL inaccuracy was corrected with every 1MHz pulse.

When a slave attached itself to the system, then it waited for the 1Hz
sync pulse, queried the absolute time from the master via the network
and synced itself to the next 1Hz sync pulse.

The signal runtime was compensated by the position of the node in the
topology, i.e. the distance to the master clock. That's simple math.
Signal runtime is known for a given wiring / PCB layout. So you just
have to know the distance.

For twisted pair the signal speed is ~ 0.6 * c =~ 180000 km/s. 

So a node which is 1m away from the master gets the signal delayed by:
 0.001 / 180000 s ~= 5.5 nsec

That's constant and easy to account for. You can get into the +/-
10nsec accuracy accross a large distributed system that way.

The sad part is, that we talked to AMD/Intel about this back then and
they both thought it would be a nice idea for cross socket synced
counters and could be easy implemented in hardware. Then they went off
and did the sh*t which we have to deal with right now.

Thanks,

	tglx
