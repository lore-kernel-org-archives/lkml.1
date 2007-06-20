Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbXFTRgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbXFTRgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXFTRgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:36:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756641AbXFTRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:36:09 -0400
Date: Wed, 20 Jun 2007 10:34:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
cc: Ingo Molnar <mingo@elte.hu>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070620093612.GA1626@ff.dom.local>
Message-ID: <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Jarek Poplawski wrote:
> 
> I don't agree with this (+ I know it doesn't matter).
> 
> The real bug is what Chuck Ebbert wrote: "Spinlocks aren't fair".
> And here they are simply lawlessly not fair.

Well, that's certainly a valid standpoint. I wouldn't claim you're 
_wrong_.

At least in theory.

In *practice*, fair spinlocks are simply not possible. Not as in "it's 
hard to do", but as in "you simply cannot do it".

The thing is, most spinlocks get held for a rather short time (if that 
wasn't the case, you'd use something like a mutex), and it's acually a 
short time not on a "human scale", but on a "CPU core scale".

IOW, the cost of doing the cacheline bouncing is often equal to, or bigger 
than, the actual cost of the operation that happens inside the spinlock!

What does this result in? It automatically means that software simply 
*cannot* do fair spinlocks, because all the timing costs are in parts that 
software doesn't even have any visibility into, or control over!

Yeah, you could add artificial delays, by doing things like cycle counting 
around the spinlock operation to see if you got the lock when it was 
_contended_, or whether you got a lock that wasn't, and then adding some 
statistics etc, but at that point, you don't have a spinlock any more, you 
have something else. I don't know what to call it.

And you could add flags like "this spinlock is getting a lot of 
contention", try some other algorithm etc. But it's all complicated and 
against the whole *point* of a spinlock, which is to get in and out as 
fast as humanly possible.

So in practice, spinlock fairness is inherently tied to the hardware 
behaviour of the cache coherency algorithm.

Which gets us to the next level: we can consider hardware that isn't 
"fair" in its cache coherency to be buggy hardware.

That's also a perfectly fine standpoint, and it's actually one that I have 
a lot of sympathy for. I think it's much easier to some degree to do 
fairness in the cache coherency than at any other level, because it's 
something where the hardware really *could* do things like counting 
bouncing etc.

However, while it's a perfectly fine standpoint, it's also totally 
unrealistic. First off, the hardware doesn't even know whether the 
spinlock "failed" or not on any architecture platform I'm aware of. On 
x86, the spinlock operation under Linux is actually just an atomic 
decrement, and it so happens that the rules for failure was that it didn't 
go negative. But that's just a Linux internal rule - the hardware doesn't 
know.

So you'd have to actualyl have some specific sequence with specific 
fairness rules (maybe you could make the rule be that a failed atomic 
"cmpxchg" counts as a real failure, and if you give higher priority to 
cores with lots of failures etc).

IOW, it's certainly possible *in*theory* to try to make hardware that has 
fairness guarantees. However, any hardware designer will tell you that 
 (a) they have enough problems as it is
 (b) it's simply not worth their time, since there are other (simpler) 
     things that are much much more important.

So the end result:
 - hardware won't do it, and they'd be crazy to really even try (apart 
   from maybe some really simplistic stuff that doesn't _guarantee_ 
   anything, but maybe helps fairness a bit)
 - software cannot do it, without turning spinlocks into something really 
   slow and complicated, at which point they've lost all meaning, and you 
   should just use a higher-level construct like a mutex instead.

In other words, spinlocks are optimized for *lack* of contention. If a 
spinlock has contention, you don't try to make the spinlock "fair". No, 
you try to fix the contention instead!

That way, you fix many things. You probably speed things up, _and_ you 
make it fairer. It might sometimes take some brains and effort, but it's 
worth it.

The patch I sent out was an example of that. You *can* fix contention 
problems. Does it take clever approaches? Yes. It's why we have hashed 
spinlocks, RCU, and code sequences that are entirely lockless and use 
optimistic approaches. And suddenly you get fairness *and* performance!

It's a win-win situation. It does require a bit of effort, but hey, we're 
good at effort.

			Linus
