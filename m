Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbYBINi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbYBINi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYBINhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:37:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46233 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbYBINhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:37:00 -0500
Date: Sat, 9 Feb 2008 15:12:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, davej@codemonkey.org.uk,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080209141213.GA22569@one.firstfloor.org>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu> <20080207200308.GA26555@one.firstfloor.org> <20080207203705.GA19083@elte.hu> <20080208114419.GB4745@one.firstfloor.org> <20080209094037.GA23418@elte.hu> <20080209114826.GA21172@one.firstfloor.org> <20080209114725.GB5273@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209114725.GB5273@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would be a completely new and totally untested modus operandi for a 
> large array of x86 CPUs. You should read the Intel manual about the 
> recommended way to change MTRRs (Vol. 3A 10-41) - it describes disabling 

I did -- that was the base I was working from.

BTW if you had read it closely you would have noticed that
the code as written currently violates the specification in a non trivial
way currently. If you worry so much about it that might be a good
area to investigate.

> the PGE during MTRR changes if it's enabled. The primary purpose of that 
> is of course to flush the TLB entries - but still it's documented that 
> way and the current code does it that way. It would be rather stupid for 

There are no global TLBs around during the MTRR change period because 
they have been all flushed just before. If any get prefetched they
will be in the TLB no matter if PGE is on or not.  That is because even
with PGE disabled TLBs are active. Then as soon as the MTRR changing
is done all TLBs (global or not) will be flushed.

[I admit I should have put that rationale into the original changelog,
then my thinking would have been clearer]

> us to do otherwise: we simply cannot guarantee that x86 CPUs that 
> implement MTRRs and PGE have no undocumented or _unknown_ erratas in 
> this area. It _might_ be fine, while what you say is that it _is_ fine - 
> which we simply cannot know. (And yes, there are documented CPU erratas 
> related to global TLBs and MTRR's, so this area is far from being an 
> unwritten page.)

If there are any global TLBs around they will be flushed at the 
end (even two times) 

Anyways the only theoretical problem I could think of if there is some CPU
that does not flush all global TLBs on a global TLB flush, but if that
really happens the only sane thing we could on that CPU is to never
use global TLBs. But I'm not aware of any x86 CPU that broken around
(are you?)

> So i refuse to apply such a pointless and risky "cleanup" patch from you 

Ok I cannot argue with you being so overly cautious. Caution
is a non exact heuristic that is hard to argue against.

I would appreciate though if you could clearly lay out which areas you
consider so risky that you think they cannot be changed anymore.

Does this cover all TLB flushes in general? Or only in some 
specific circumstances? If yes in which? 

Thanks.

That is just I can avoid stepping on your toes for those areas
for merely cleanups. They tend to be not important enough to warrant
a longer argument.

> to arch/x86 [which increases code size as well], 

Yes, a whole ~10 bytes or so in two non duplicated functions :-) I like
the code size argument as well as the next guy, but if you use it 
for rounding errors like this it blunts.

-Andi

