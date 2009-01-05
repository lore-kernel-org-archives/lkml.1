Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZAETkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZAETkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZAETjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:39:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbZAETjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:39:51 -0500
Date: Mon, 5 Jan 2009 11:39:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Peter Klotz <peter.klotz@aon.at>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
 soft lockup - is this XFS problem?)
In-Reply-To: <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901051131090.3057@localhost.localdomain>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org> <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de>
 <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de> <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2009, Linus Torvalds wrote:
> 
> Either the value can change, or it can not. It's that simple.
> 
> If it cannot change, then we can load it just once, or we can load it 
> multiple times, and it won't matter. Barriers won't do anything but screw 
> up the code.
> 
> If it can change from under us, you need to use rcu_dereference(), or 
> open-code it with an ACCESS_ONCE() or put in barriers. But your placement 
> of a barrier was NONSENSICAL. Your barrier didn't protect anything else - 
> like the test for the RADIX_TREE_INDIRECT_PTR bit.
> 
> And that was the fundamental problem.

Btw, this is the real issue with anything that does "locking vs 
optimistic" accesses.

If you use locking, then by definition (if you did things right), the 
values you are working with do not change. As a result, it doesn't matter 
if the compiler re-orders accesses, splits them up, or coalesces them. 
It's why normal code should never need barriers, because it doesn't matter 
whether some access gets optimized away or gets done multiple times.

But whenever you use an optimistic algorithm, and the data may change 
under you, you need to use barriers or other things to limit the things 
the CPU and/or compiler does.

And yes, "rcu_dereference()" is one such thing - it's not a barrier in the 
sense that it doesn't necessarily affect ordering of accesses to other 
variables around it (although the read_barrier_depends() obviously _is_ a 
very special kind of ordering wrt the pointer itself on alpha). But it 
does make sure that the compiler at least does not coalesce - or split - 
that _one_ particular access.

It's true that it has "rcu" in its name, and it's also true that that may 
be a bit misleading in that it's very much useful not just for rcu, but 
for _any_ algorithm that depends on rcu-like behavior - ie optimistic 
accesses to data that may change underneath it. RCU is just the most 
commonly used (and perhaps best codified) variant of that kind of code.

			Linus
