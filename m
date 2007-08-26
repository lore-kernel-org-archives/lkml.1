Return-Path: <linux-kernel-owner+w=401wt.eu-S934804AbXHZB1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbXHZB1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 21:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbXHZB1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 21:27:43 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:62182 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbXHZB1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 21:27:42 -0400
Date: Sat, 25 Aug 2007 21:26:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RT 3/3 - take two ] fix get_monotonic_cycles for latency
 tracer
In-Reply-To: <y0modgv50vl.fsf@ton.toronto.redhat.com>
Message-ID: <Pine.LNX.4.58.0708252121310.26667@gandalf.stny.rr.com>
References: <1187978236.2941.19.camel@localhost.localdomain>
 <1187982149.4574.1.camel@localhost.localdomain> <y0modgv50vl.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Sat, 25 Aug 2007, Frank Ch. Eigler wrote:

>
> Steven Rostedt <rostedt@goodmis.org> writes:
>
> > [...]
> > +		 * [...] We don't need to grab
> > +		 * any locks, we just keep trying until get all the
> > +		 * calculations together in one state.
> > +		 *
> > +		 * In fact, we __cant__ grab any locks. This
> > +		 * function is called from the latency_tracer which can
> > +		 * be called anywhere. To grab any locks (including
> > +		 * seq_locks) we risk putting ourselves into a deadlock.
>
> Perhaps you could add a comment about why the loop, which appears
> potentially infinite as written, avoids livelock.  (It looks rather
> like a seqlock read loop.)
>

I guess I need to rewrite that comment. It shouldn't appear infinitely
looping, since it is basically: do { x=A; func() } while (x != A); which
to me seems that while is most likely to fail unless something touches A.

But yes, it _is_ basically a seq lock, but its on what we are working
with.  And we don't even need any memory barriers that a seq lock might
do, since it is very obvious to gcc that the function call can modify the
variables that we are testing.

But do you still think that looks inifinte?  If so, I'll reword it.

-- Steve

