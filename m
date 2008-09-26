Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYIZBtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYIZBtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYIZBtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:49:12 -0400
Received: from gw.goop.org ([64.81.55.164]:34314 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZBtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:49:11 -0400
Message-ID: <48DC3F95.4040201@goop.org>
Date: Thu, 25 Sep 2008 18:49:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
References: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org> <20080925225558.GA5768@elte.hu> <48DC382A.8000407@goop.org> <alpine.DEB.1.10.0809252123580.8454@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809252123580.8454@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:
>   
>> No, as I said:  "You just need to emit the current
>> tsc+frequency+wallclock time before you emit any more delta records
>> after the frequency change."
>>
>> When an event which affects the tsc occurs, like a frequency change or
>> pause, set a flag.  When you're next about to emit a delta, check the
>> flag and emit new timing parameters (or instead).
>>     
>
> This is where I get confused.  When do we add this to the trace buffer?
> Every record (currently) records the delta time from the last event.
> If a frequency changes, do we need to record the tuple at that moment?
>   

No, you just need to save away a consistent (tsc,freq,GTOD) triple at
some point in time; it doesn't matter when it is, so long as the tsc
frequency hasn't changed since then.  Once you have that, you can insert
it into your trace buffer, and then use it as the base for subsequent
deltas.

And as I mentioned in the other mail, if you don't mind backtracking
when you process the log, you can even record (tsc,freq) (tsc,GTOD)
separately (but in that order).

> If so, we have an issue. We can be in the middle of tracing the GTOD
> and we can not recurse back into the GTOD for fear of deadlocking on
> the GTOD spinlocks.
>   

Right, you don't need to read the GTOD when you actually write a record.

    J
