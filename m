Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYKQVfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYKQVfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYKQVfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:35:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286AbYKQVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:35:03 -0500
Date: Mon, 17 Nov 2008 13:34:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: skb_release_head_state(): Re: [Bug #11308] tbench regression on
 each kernel release from 2.6.22 -&gt; 2.6.28
In-Reply-To: <20081117205530.GE12020@elte.hu>
Message-ID: <alpine.LFD.2.00.0811171325260.18283@nehalem.linux-foundation.org>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com>
 <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117205530.GE12020@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Ingo Molnar wrote:
> 
> this function _really_ hurts from a 16-bit op:
> 
> ffffffff8048943e:     6503 	66 c7 83 a8 00 00 00 	movw   $0x0,0xa8(%rbx)
> ffffffff80489445:        0 	00 00 
> ffffffff80489447:   174101 	5b                   	pop    %rbx

I don't think that is it, actually. The 16-bit store just before it had a 
zero count, even though anything that executes the second one will always 
execute the first one too.

The fact is, x86 profiles are subtle at an instruction level, and you tend 
to get profile hits _after_ the instruction that caused the cost because 
an interrupt (even an NMI) is always delayed to the next instruction (the 
one that didn't complete). And since the core will execute out-of-order, 
you don't even know what that one is, since there could easily be 
branches, but even in the absense of branches you have many instructions 
executing together.

For example, in many situations the two 16-bit stores will happily execute 
together, and what you see may simply be a cache miss on the line that was 
stored to. The store buffer needs to resolve the read of the "pop" in 
order to complete, so having a big count in between stores and a 
subsequent load is not all that unlikely.

So doing per-instruction profiling is not useful unless you start looking 
at what preceded the instruction, and because of the out-of-order nature, 
you really almost have to look for cache misses or branch mispredicts.

One common reason for such a big count on an instruction that looks 
perfectly simple is often that there is a branch to that instruction that 
was mispredicted. Or that there was an instruction that was costly _long_ 
before, and that other instructions were in the shadow of that one 
completing (ie they had actually completed first, but didn't retire until 
the earlier instruction did).

So you really should never just look at the previous instruction or 
anythign as simplistic as that. The time of in-order execution is long 
past.

		Linus
