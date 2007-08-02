Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbXHBCSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbXHBCSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbXHBCS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:18:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbXHBCS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:18:26 -0400
Date: Wed, 1 Aug 2007 19:17:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <Pine.LNX.4.64.0708011525560.1817@scrub.home>
Message-ID: <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org> <20070711214649.GK14435@v2.random>
 <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0708011525560.1817@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Aug 2007, Roman Zippel wrote:
> 
> I'm not so sure about that. sched_clock() has to be fast, so many archs 
> may want to continue to use jiffies. As soon as one does that one can also 
> save a lot of computational overhead by using 32bit instead of 64bit.
> The question is then how easy that is possible.

I have to say, it would be interesting to try to use 32-bit arithmetic.

I also think it's likely a mistake to do a nanosecond resolution. That's 
part of what forces us to 64 bits, and it's just not even an *interesting* 
resolution.

It would be better, I suspect, to make the scheduler clock totally 
distinct from the other clock sources (many architectures have per-cpu 
cycle counters), and *not* try to even necessarily force it to be a 
"time-based" one.

So I think it would be entirely appropriate to

 - do something that *approximates* microseconds.

   Using microseconds instead of nanoseconds would likely allow us to do 
   32-bit arithmetic in more areas, without any real overflow.

   And quite frankly, even on fast CPU's, the scheduler is almost 
   certainly not going to be able to take any advantage of the nanosecond 
   resolution. Just about anything takes a microsecond - including IO. I 
   don't think nanoseconds are worth the ten extra bits they need, if we 
   could do microseconds in 32 bits.

   And the "approximates" thing would be about the fact that we don't 
   actually care about "absolute" microseconds as much as something that 
   is in the "roughly a microsecond" area. So if we say "it doesn't have 
   to be microseconds, but it should be within a factor of two of a ms", 
   we could avoid all the expensive divisions (even if they turn into 
   multiplications with reciprocals), and just let people *shift* the CPU 
   counter instead.

   In fact, we could just say that we don't even care about CPU counters 
   that shift frequency - so what? It gets a bit further off the "ideal 
   microsecond", but the scheduler just cares about _relative_ times 
   between tasks (and that the total latency is within some reasonable 
   value), it doesn't really care about absolute time.

Hmm?

It would still be true that something that is purely based on timer ticks 
will always be liable to have rounding errors that will inevitably mean 
that you don't get good fairness - tuning threads to run less than a timer 
tick at a time would effectively "hide" them from the scheduler 
accounting. However, in the end, I think that's pretty much unavoidable. 
We should make sure that things mostly *work* for that situation, but I 
think it's ok to say that the *quality* of the fairness will obviously 
suffer (and possibly a lot in the extreme cases).

			Linus
