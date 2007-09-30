Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbXI3MQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbXI3MQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 08:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXI3MQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 08:16:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:48787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbXI3MQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 08:16:28 -0400
Date: Sun, 30 Sep 2007 14:16:26 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] x86: improved memory barrier implementation
Message-ID: <20070930121626.GD7697@wotan.suse.de>
References: <20070928154832.GB12538@wotan.suse.de> <20070928170719.2f617a7a@the-village.bc.nu> <alpine.LFD.0.999.0709280911100.3579@woody.linux-foundation.org> <20070929131708.GD14159@wotan.suse.de> <alpine.LFD.0.999.0709290843120.3579@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709290843120.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 09:07:30AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 29 Sep 2007, Nick Piggin wrote:
> > > 
> > > The non-temporal stores should be basically considered to be "IO", not any 
> > > normal memory operation.
> > 
> > Maybe you're thinking of uncached / WC? Non-temporal stores to cacheable
> > RAM apparently can go out of order too, and they are being used in the kernel
> > for some things.
> 
> I'm really saying that people to a first approximation should think "NT is 
> an IO (DMA) thing". Whether cached or not. Exactly because they do not 
> honor the normal memory ordering.
> 
> It may be worth noting that "clflush" falls under that heading too - even 
> if all the actual *writes* were done with totally normal writes, if 
> anybody does a clflush instruction, that breaks the ordering, and that 
> turns it to "DMA ordering" again - ie we're not talking about the normal 
> SMP ordering rules at all.
> 
> So all the spinlocks and all the smp_*mb() barriers have never really done 
> *anything* for those things (in particular, "smp_wmb()" has *always* 
> ignored them on i386!)

Yes that's true. I'm just noting that in some places, we do nontemporal
stores to cacheable RAM, and in that case we just have to remember to be
careful of memory ordering (especially in library functions like
copy_user_nocache where we never know exactly what it will be used for,
even if it seems safe).

Speaking of which, would it be a good idea to put an sfence before and
after this function? It seems like the safe thing to do...


> > Likewise for rep stos, apparently.
> 
> No. As far as I can tell, the fast string operations are unordered 
> *within*themselves*, but not wrt the operations around it.
> 
> In other words, you cannot depend on the ordering of stores *in* the 
> memcpy() or memset() when it is implemented by "rep movs/stos" - but that 
> is 100% equivalent to the fact that you cannot depend on the ordering even 
> when it isn't - since the "memcpy()" library routine might be copying 
> memory backwards for all you know!
> 
> The Intel memory ordering paper doesn't talk about the fast string 
> instructions (except to say that the rules it *does* speak about do not 
> hold), but the regular IA manuals do say (for example):
> 
>    "Code dependent upon sequential store ordering should not use the 
>     string operations for the entire data structure to be stored. Data and 
>     semaphores should be separated. Order dependent code should use a 
>     discrete semaphore uniquely stored to after any string operations to 
>     allow correctly ordered data to be seen by all processors."
> 
> and note how it says you should just store to the semaphore. If you think 
> about it, that semahore will be involving all the memory ordering 
> requirements that we *already* depend on, so if a semaphore is sufficient 
> to order the fast string instruction, then by definition using a spinlock 
> around them must be the same thing!
> 
> In other words, by Intels architecture manual, fast string instructions 
> cannot escape a "semaphore" - but that means that they cannot escape a 
> spinlock either (since the two are exactly the same wrt memory ordering 
> rules! In other words, whenever the Intel docs say "semaphore", think 
> "mutual exclusion lock", not necessarily the kernel kind of "sleeping 
> semaphore").
> 
> But it might be good to have that explicitly mentioned in the IA memory 
> ordering thing, so I'll ask the Intel people about that. However, I'd say 
> that given our *current* documentation, string instructions may be 
> *internally* out-of-order, but they would not escape a lock.

OK, it's good to hear that from you :) The one tiny doubt I have left
is that IIRC Intel talk about lock prefixed operations as semaphore
operations sometimes? I don't suppose that would be the case here? Anyway,
if you can get them to put something in writing, that would be grand.

 
> > But this means they are already at odds with spin_unlock, unless they 
> > are enclosed with mfences everywhere they are used (of which I think 
> > most are not). So this is an existing bug in the kernel.
> 
> See above. I do not believe that it's an existing bug, but the basic point 
> that the change to "smp_rmb()" doesn't change our existing rules is true.

OK, so all that's left is to restore the locked smp_rmb case for broken
ppro and resend the patch?

