Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYIYKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYIYKnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYIYKnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:43:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYIYKnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:43:22 -0400
Date: Thu, 25 Sep 2008 12:38:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Tom Zanussi <zanussi@comcast.net>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925103821.GA15720@elte.hu>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <alpine.DEB.1.10.0809241106210.1860@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809241106210.1860@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > Or if we already have the data together:
> > > 
> > > ring_buffer_write(buffer, event_id, length, data);
> > 
> > Don't like the event_id, just stick to plain binary data, and leave 
> > interpretation open to whoemever uses it.
> 
> This is up to debate. I know you don't like this extra event layer, 
> but seriously, all my uses with ring buffers has had some kind of 
> event. But then I'm sure you can argue that if you are using a single 
> type you can can the event.
> 
> I'm open to doing this, but I would like a consensus on this.
> 
> Martin, Thomas, Ingo, Linus?

i'd prefer Peter's simplification and not pass event_id along. Since 
static types are lost anyway (which is the biggest cost and risk of any 
such abstraction), we have to convert between types early on. Whether 
event_id is visible in the API is no big difference.

(It might be cheaper to not pass it along even if everyone ends up using 
it - as it has no semantic meaning anyway.)

pretty much the only generic tracing information is time and payload 
size. ( but even a time key is debatable - there are various resolutions 
needed by different usecases. Some usecases are even fine without any 
timestamps at all - they just want to know the ordering of events and 
that's it.)

i'd like to see some automatic type protection though, as an 
off-by-default debug option: encode the record type on storing and 
double-check it on extraction. So it should be possible to reliably 
store/restore a typed trace buffer and notice corruption early in 
testing.

because there's one thing that is far more important tracer feature than 
sheer performance: robustness.

Automated type checking in debug mode would also mean we could go for 
RLE encoding much more agressively. Most of the risks of a more complex, 
more compressed and pointer-laden data format come from type mismatches 
and the loss of compiler protection against human errors/stupidity. 
(running off the end of the page, misinterpreting a pointer, a record, 
etc.)

	Ingo
