Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYIZBfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYIZBfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYIZBf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:35:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYIZBf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:35:26 -0400
Date: Thu, 25 Sep 2008 21:35:23 -0400 (EDT)
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
In-Reply-To: <48DC3A89.9020407@goop.org>
Message-ID: <alpine.DEB.1.10.0809252132410.8454@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org>
 <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org> <alpine.DEB.1.10.0809251848170.32742@gandalf.stny.rr.com> <48DC3A89.9020407@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > How do you get this GTOD read in the ring buffer? If the ring buffer does
> > it without any knowledge from the tracer, it may be doing it a 
> > inappropriate times. This would also imply that the GTOD infrastructure 
> > itself is reentrent safe.  Imagine tracing the GTOD code when the buffer 
> > decides it is about time to add the GTOD timestamp into the buffer. Can 
> > the GTOD handle this recursion. If the GTOD has spinlocks, probably not.
> >   
> 
> It doesn't need to read the GTOD synchronously when writing the trace
> record.  When a tsc event occurs, it needs to store the
> GTOD/tsc/frequency somewhere at that point.  When you next write a trace
> record, if that structure has been updated, you write it into the trace
> before emitting the next delta timestamp.
> 
> In fact you can read the GTOD at almost any time between tsc frequency
> updates, so you can defer it to whenever is convenient.  At the time the
> tsc changes frequency, you emit: (tsc,frequency), and a bit later
> (before it changes again) you emit (tsc,GTOD).  That allows you to
> retroactively compute GTODs for all timestamps.  Obviously it would be
> good to get them as close as possible together.

OK, let me rephrase my question.

How and where do we record this?  Do we keep this information in some 
global variable that we must compare to every time we add a new item in 
the trace?

Do we have the buffer register a call back to record this information?

-- Steve

