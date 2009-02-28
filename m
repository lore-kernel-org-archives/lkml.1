Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZB1RRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZB1RRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZB1RR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:17:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662AbZB1RRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:17:25 -0500
Date: Sat, 28 Feb 2009 09:16:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to
 __copy_from_user_*nocache()
In-Reply-To: <20090228125816.GA14917@elte.hu>
Message-ID: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu> <200902282249.57479.nickpiggin@yahoo.com.au> <20090228125816.GA14917@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Feb 2009, Ingo Molnar wrote:
> 
> Can you suggest some other workload that should show sensitivity 
> to this detail too? Like a simple write() loop of non-4K-sized 
> files or so?

I bet you can find it, but I also suspect that it will depend quite a bit 
on the microarchitecture. What does 'movntq' actually _do_ on different 
CPU's (bypass L1 or L2 or just turn the L1 cache policy to "write through 
and invalidate")? How expensive is the sfence when there are still stores 
in the write buffer? Does 'movqnt' even use the write buffer for cached 
stores, or is doing some special path the the last-level cache?

If you want to be really subtle, ask questions like what are the 
implications for last-level caches that are inclusive? The last-level 
cache would take not just the new write, but it also has logic to make 
sure that it's a superset of the inner caches, so what does that do to 
replacement policy for that cache? Or does it cause invalidations in the 
inner caches?

Non-temporal stores are really quite different from normal stores. 
Depending on microarchitecture, that may be totally a non-issue (bypassing 
the L1 may be trivial and have no impact on anything else at all). Or it 
could be that a movntq is really expensive because it needs to do odd 
things.

So if you want to test this, I'd suggest using the same program that did 
the 256-byte writes (Unixbench's fstime thing), but just change the 
numbers, and just try different things. But I'd _also_ suggest that if 
you're going for anything more complicated (ie if you really want to 
have a good argument for that 'total_size' thing), then you should try out 
at least three different microarchitectures.

The "different" ones would be at a minimum P4, Core2 and Opteron. They 
really could have very different behavior. 

I suspect Core2 and Core i7 are fairly similar, but at the same time Ci7 
has that L3 cache thing, so it's quite possible that movntq is actually 
fundamentally different (does it bypass both L1 and L2? If so, latencies 
to the L3 are _much_ longer to Ci7 than the very cheap L2 latencies on 
C2).

			Linus
