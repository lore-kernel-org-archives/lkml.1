Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXHBE72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXHBE72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXHBE7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:59:12 -0400
Received: from 1wt.eu ([62.212.114.60]:1081 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXHBE7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:59:10 -0400
Date: Thu, 2 Aug 2007 06:57:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <andi@firstfloor.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070802045710.GA8720@1wt.eu>
References: <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011525560.1817@scrub.home> <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 07:17:51PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 1 Aug 2007, Roman Zippel wrote:
> > 
> > I'm not so sure about that. sched_clock() has to be fast, so many archs 
> > may want to continue to use jiffies. As soon as one does that one can also 
> > save a lot of computational overhead by using 32bit instead of 64bit.
> > The question is then how easy that is possible.
> 
> I have to say, it would be interesting to try to use 32-bit arithmetic.
> 
> I also think it's likely a mistake to do a nanosecond resolution. That's 
> part of what forces us to 64 bits, and it's just not even an *interesting* 
> resolution.

I would add that I have been bothered by the 64-bit arithmetics when
trying to see what could be improved in the code. In fact, it's very
hard to optimize anything when you have arithmetics on integers larger
than the CPU's, and gcc is known not to emit very good code in this
situation (I remember it could not play with registers renaming, etc...).

However, I undertand why Ingo chose to use 64 bits. It has the advantage
that the numbers never wrap within 584 years. I'm well aware that it's
very difficult to keep tasks ordered according to a key which can wrap.

But if we consider that we don't need to be more precise than the return
value from gettimeofday() that all applications use, we see that a bunch
of microseconds is enough. 32 bits at the microsecond level wraps around
every hour. We may accept to recompute all keys every hour. It's not that
dramatic. The problem is how to detect that we will need to.

I remember a trick used by Tim Schmielau in his jiffies64 patch for 2.4.
He kept a copy of the highest bit of the lower word in the lowest bit of
the higher word, and considered that the lower one could not wrap before
we could check it. I liked this approach, which could be translated here
in something like the following :

Have all keys use 32-bit resolution, and monitor the 32nd bit. All tasks
must have the same value in this bit, otherwise we consider that their
keys have wrapped. The "current" value of this bit is copied somewhere.
When we walk the tree and find a task with a key which does not have its
32nd bit equal to the current value, it means that this key has wrapped,
so we have to use this information in our arithmetics.

When all keys have their 32nd bit different from the "current" value,
then we switch this value to reflect the new 32nd bit, and everything is
in sync again. The only requirement is that no key wraps around before
the "current" value is switched. This implies that no couple of tasks
could have their keys distant by more than 31 bits (35 minutes), which
seems reasonable. If we can recompute all tasks' keys when all of them
have wrapped, then we do not have to store the "current" bit value
anymore, and consider that it is always zero instead (I don't know if
the code permits this).

It is possible that using the 32nd bit to detect the wrapping may impose
us to perform some computations on 33 bits. If this is the case, then it
would be fine if we reduced the range to 31 bits, with all tasks distant
from at most 30 bits (17 minutes).

Also, I remember that the key is signed. I've never experimented with the
tricks above on signed values, but we might be able to define something
like this for the higher bits :

  00 = positive, no wrap
  01 = positive, wrapped
  10 = negative, wrapped
  11 = negative, no wrap

I have no code to show, I just wanted to expose this idea. I know that if
Ingo likes it, he will beat everyone at implementing it ;-)

> 			Linus

Willy

