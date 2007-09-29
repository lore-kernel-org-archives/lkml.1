Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXI2QHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXI2QHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXI2QHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:07:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbXI2QHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:07:37 -0400
Date: Sat, 29 Sep 2007 09:07:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
In-Reply-To: <20070929131708.GD14159@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0709290843120.3579@woody.linux-foundation.org>
References: <20070928154832.GB12538@wotan.suse.de> <20070928170719.2f617a7a@the-village.bc.nu>
 <alpine.LFD.0.999.0709280911100.3579@woody.linux-foundation.org>
 <20070929131708.GD14159@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 29 Sep 2007, Nick Piggin wrote:
> > 
> > The non-temporal stores should be basically considered to be "IO", not any 
> > normal memory operation.
> 
> Maybe you're thinking of uncached / WC? Non-temporal stores to cacheable
> RAM apparently can go out of order too, and they are being used in the kernel
> for some things.

I'm really saying that people to a first approximation should think "NT is 
an IO (DMA) thing". Whether cached or not. Exactly because they do not 
honor the normal memory ordering.

It may be worth noting that "clflush" falls under that heading too - even 
if all the actual *writes* were done with totally normal writes, if 
anybody does a clflush instruction, that breaks the ordering, and that 
turns it to "DMA ordering" again - ie we're not talking about the normal 
SMP ordering rules at all.

So all the spinlocks and all the smp_*mb() barriers have never really done 
*anything* for those things (in particular, "smp_wmb()" has *always* 
ignored them on i386!)

> Likewise for rep stos, apparently.

No. As far as I can tell, the fast string operations are unordered 
*within*themselves*, but not wrt the operations around it.

In other words, you cannot depend on the ordering of stores *in* the 
memcpy() or memset() when it is implemented by "rep movs/stos" - but that 
is 100% equivalent to the fact that you cannot depend on the ordering even 
when it isn't - since the "memcpy()" library routine might be copying 
memory backwards for all you know!

The Intel memory ordering paper doesn't talk about the fast string 
instructions (except to say that the rules it *does* speak about do not 
hold), but the regular IA manuals do say (for example):

   "Code dependent upon sequential store ordering should not use the 
    string operations for the entire data structure to be stored. Data and 
    semaphores should be separated. Order dependent code should use a 
    discrete semaphore uniquely stored to after any string operations to 
    allow correctly ordered data to be seen by all processors."

and note how it says you should just store to the semaphore. If you think 
about it, that semahore will be involving all the memory ordering 
requirements that we *already* depend on, so if a semaphore is sufficient 
to order the fast string instruction, then by definition using a spinlock 
around them must be the same thing!

In other words, by Intels architecture manual, fast string instructions 
cannot escape a "semaphore" - but that means that they cannot escape a 
spinlock either (since the two are exactly the same wrt memory ordering 
rules! In other words, whenever the Intel docs say "semaphore", think 
"mutual exclusion lock", not necessarily the kernel kind of "sleeping 
semaphore").

But it might be good to have that explicitly mentioned in the IA memory 
ordering thing, so I'll ask the Intel people about that. However, I'd say 
that given our *current* documentation, string instructions may be 
*internally* out-of-order, but they would not escape a lock.

> But this means they are already at odds with spin_unlock, unless they 
> are enclosed with mfences everywhere they are used (of which I think 
> most are not). So this is an existing bug in the kernel.

See above. I do not believe that it's an existing bug, but the basic point 
that the change to "smp_rmb()" doesn't change our existing rules is true.

			Linus
