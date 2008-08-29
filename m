Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYH2R1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYH2R1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYH2R1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:27:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYH2R1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:27:05 -0400
Date: Fri, 29 Aug 2008 10:26:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
In-Reply-To: <20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org> <20080829080809.0e42a323@infradead.org> <alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org> <20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Alan Cox wrote:
>
> > "schedule_timeout()", there's a big difference between asking for two 
> > ticks and asking for two seconds. The latter should probably try to round 
> > to a nice timer tick basis for power reasons).
> 
> I disagree - that is fixing the problem in the wrong place. The timer
> structure needs an accuracy field of some form that the existing timer
> functions initialise to 0.

I do agree that we could do that too, but you miss one big issue: even if 
we were to add an accuracy field inside the kernel, there is no such field 
in the user interfaces.

We just pass timevals (and sometimes timespecs) around, and no, they don't 
have any way to specify accuracy.

Yeah, we could use the high bits in the usec/nsec words, but then older 
kernels would basically do random things, so that would be a horrible 
interface.

The other thing to do would be to just add totally new system calls with 
totally new interfaces, but (a) nobody would use them anyway and (b) it's 
simply not worth it.

So given that reality, and _if_ we want to support nice high-resolution 
sleeping by select/poll, the only reasonable thing to do is to estimate 
some kind of expected accuracy from the existing timeval/timespec.

And the only reasonable way to do that is to just look at the range. You 
can probably do something fairly trivial with

	/* Estimate expected accuracy in ns from a timeval */
	unsigned long estimate_accuracy(struct timeval *tv)
	{
		/*
		 * Tens of ms if we're looking at seconds, even
		 * more for 10s+ sleeping
		 */
		if (tv->tv_sec) {
			/* Tenths of seconds for long sleeps */
			if (tv->tv_sec > 10)
				return 100000000;
			/*
			 * Tens of ms for second-granularity sleeps. This,
			 * btw, is the historical Linux 100Hz timer range.
			 */
			return 10000000;
		}

		/* Single msecs if we're looking at milliseconds */
		if (tv->tv_usec > 1000)
			return 1000000;

		/* Aim for tenths of msecs otherwise */
		return 100000;
	}

and yes, it's just a heuristic, but it's probably not a horribly stupid 
one or a very unreasonable one. 

			Linus
