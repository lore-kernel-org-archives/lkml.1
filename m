Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbZFOKNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbZFOKNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZFOKMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:12:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:57047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbZFOKMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:12:53 -0400
Date: Mon, 15 Jun 2009 12:12:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615101254.GB10294@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245059476.12400.7.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:51:16PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-15 at 11:41 +0200, Nick Piggin wrote:
> > 
> > > Btw, you should not need to use GFP_NOWAIT anymore and GFP_KERNEL
> > > should be fine even during early boot.
> > 
> > Is this the agreed way forward? 
> 
> Yes.
> 
> > I would like to maybe continue to
> > try having early allocations pass in special flags where possible
> > (it could even be a GFP_BOOT or something). It can make it easier
> > to perhaps reduce branches in core code in future and things can
> > be flagged in warnings....
> 
> The whole point of the exercise in removing the need for alloc_bootmem
> in a whole bunch of code is defeated if you now also want specific flags
> passed. I think we can cope reasonably easily.

Why? The best reason to use slab allocator is that the allocations
are much more efficient and also can be freed later.

 
> > I just like the idea of keeping such annotations.
> 
> I think the boot order is too likely to change to make it a sane thing
> to have all call sites "know" at what point they are in the boot
> process.

I disagree.

> In your example, what does GFP_BOOT would mean ? Before
> scheduler is initialized ? before interrupts are on ?

Before initcalls is probably easiest. But it really does not
matter that much. Why? Because if we run out of memory before
then, then there is not going to be anything to reclaim
anyway.


> There's just too much stuff involved and we don't want random
> allocations in various subsystem or arch code to be done with that
> special knowledge of where specifically in that process they are done.

If they're done that early, of course they have to know where
they are because they only get to use a subset of kernel
services depending exactly on what has already been done.

> Especially since it may change.

"it" meaning the ability to reclaim memory? Not really. Not a
significant amount of memory may be reclaimed really until
after init process starts running.
 

> Additionally, I believe the flag test/masking can be moved easily enough
> out of the fast path... slub shouldn't need it there afaik and if it's
> pushed down into the allocation of new slab's then it shouldn't be a big
> deal.

Given that things have been apparently coping fine so far, I
think it will be a backward step to just give up now and say
it is too hard simply because slab is available to use slightly
earlier.

It's not that the world is going to come to an end if we
can't remove the masking, but just maybe the information
can be used in future to avoid adding more overhead, or
maybe some other debugging features can be added or something.
I just think it is cleaner to go that way if possible, and
claiming that callers can't be expected to know what context
they clal the slab allocator from just sounds like a
contradiction to me.
