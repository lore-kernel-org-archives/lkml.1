Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYIYOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYIYOyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIYOyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:54:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:38493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYIYOyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:54:15 -0400
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Bligh <mbligh@mbligh.org>
Cc: Martin Bligh <mbligh@google.com>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com>
References: <20080924051056.650388887@goodmis.org>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>
	 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
	 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
	 <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>
	 <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 16:53:28 +0200
Message-Id: <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 07:33 -0700, Martin Bligh wrote:
> > I rather like this idea, as it gives small entries (the common case) the
> > least overhead but does allow for larger ones.
> >
> > By also putting the time in there you can do the merge sort iterator,
> > Linus was right that everybody wants this anyway.
> >
> > As for delta encoding the time, we could make the tick log the absolute
> > time packet, that's at least 100Hz and it already has to compute the
> > full gtod thing anyway.
> >
> > I don't much like Linus' idea of bringing type information back into the
> > primitive header (sorry Linus ;-)). I'd much rather keep that
> > abstraction in the next layer.
> 
> There is part of the type stuff that belongs in the lower layer, it seems -
> the padding events for the up-to-end-of-page buffering, and the timestamp
> extensions. It seems wrong to split those across two layers.

Hmm, you've got a point there, then it would be 3 package types:
 
 - regular
 - full time
 - nop

Which can be encoded using 2 bits

> But perhaps we can keep a couple of bits for this, and three of the bits
> to represent the length of the data payload (maybe in 4 byte multiples
> rather than bytes?) That'd let up to 28 bytes as a payload in a short event.

Right - if you use raw tsc you're dependent on clock speed, if we'd
normalize that on ns instead you'd need at least:

l(10000000)/l(2)
23.25349666421153643532

bits to handle HZ=100, leaving us with 32-2-24 = 6 bits for size.

Sounds doable (unless I mis-counted on the 0's).

Also, I agree on the 4byte alignment, rather than the 8byte Steve seems
to favour.

