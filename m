Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbZFOLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbZFOLWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZFOLWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:22:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbZFOLWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:22:06 -0400
Date: Mon, 15 Jun 2009 13:22:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615112205.GA6012@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245062388.12400.17.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 08:39:48PM +1000, Benjamin Herrenschmidt wrote:
> 
> > Why? The best reason to use slab allocator is that the allocations
> > are much more efficient and also can be freed later.
> 
> I think you are making the mistake of reasoning too much in term of
> implementation of the allocator itself, and not enough in term of the
> consistency of the API exposed to the rest of the kernel.

No I just think giving accurate context information is better
than giving inaccurate and then fixing it post facto by testing
some global flag.

 
> I think the current approach is a good compromise. If you can make it
> more optimal (by pushing the masking in slow path for example), then go
> for it, but from an API standpoint, I don't like having anybody who
> needs to allocate memory have to know about seemingly unrelated things
> such as whether interrupts have been enabled globally yet, scheduler
> have been initialized, or whatever else we might stumble upon.

"pre initcalls" is pretty fair. Before then you are talking about
pretty specialised boot code that has to know a lot of context
about what other subsystems are up anyway.

 
> > > I think the boot order is too likely to change to make it a sane thing
> > > to have all call sites "know" at what point they are in the boot
> > > process.
> > 
> > I disagree.
> 
> How so ? IE. We are changing things in the boot order today, and I'm
> expecting things to continue to move in that area. I believe it's going
> to be endless headaches and breakage if we have to get the right set of
> flags on every caller.

If you replace alloc_bootmem with kmalloc(GFP_KERNEL), then what do
you expect to happen? What would be the problem with using GFP_ATOMIC
like everybody else does?

It's not like it's constantly changing or something that cannot be
detected and warned about. How many times has it moved in the entire
2.5/2.6 series I wonder? Once would be my guess.

 
> In addition, there's the constant issue of code that can be called both
> at boot and non-boot time and shouldn't have to know where it has been
> called from, while wanting to make allocations, such as get_vm_area().
> 
> I don't think it will make anybody's life better to push out the "boot
> state" up into those APIs, duplicating them, etc...

I don't see that one example being a significant or common problem.
 

> > > In your example, what does GFP_BOOT would mean ? Before
> > > scheduler is initialized ? before interrupts are on ?
> > 
> > Before initcalls is probably easiest. But it really does not
> > matter that much. Why? Because if we run out of memory before
> > then, then there is not going to be anything to reclaim
> > anyway.
> 
> Precisely. It -doesn't matter- (to the caller). So why make it matter in
> term of API ? There's a whole bunch of things in arch code or subsystems
> that really don't have any business knowing in what context or at what
> time they have been called.

Wait, what? The context does of course still matter because we don't
want to, for example, reenable interrupts.

"it does not matter" when I said it means that it is not critical
the exact where we would decide to mandate the use of GFP_BOOT.


> > > There's just too much stuff involved and we don't want random
> > > allocations in various subsystem or arch code to be done with that
> > > special knowledge of where specifically in that process they are done.
> > 
> > If they're done that early, of course they have to know where
> > they are because they only get to use a subset of kernel
> > services depending exactly on what has already been done.
> 
> To a certain extent, yes. But not -that- much, expecially when it comes
> to a very basic service such as allocating memory.

Disagree. See bootmem.

 
> > > Especially since it may change.
> > 
> > "it" meaning the ability to reclaim memory? Not really. Not a
> > significant amount of memory may be reclaimed really until
> > after init process starts running.
> 
> How much stuff allocated during boot needs to be reclaimed ?

IIRC the last one I wrote may have been sched-domains or something.
And not just reclaimed but also efficiency of allocation. And it
actually does matter a few hundred bytes even on tiny systems.


> > > Additionally, I believe the flag test/masking can be moved easily enough
> > > out of the fast path... slub shouldn't need it there afaik and if it's
> > > pushed down into the allocation of new slab's then it shouldn't be a big
> > > deal.
> > 
> > Given that things have been apparently coping fine so far, I
> > think it will be a backward step to just give up now and say
> > it is too hard simply because slab is available to use slightly
> > earlier.
> 
> Things have been coping thanks to horrors such as
> 
> 	if (slab_is_available())
> 		kmalloc
> 	else
> 		alloc_bootmem.
> 
> Now you are proposing to change that into
> 
> 	if (whatever_are_we_talking_about())
> 		kmalloc(... GFP_KERNEL)
> 	else
> 		kmalloc(... GFP_BOOT)
> 
> Not a very big improvement in my book :-)

Of core code, we have one in kernel/params.c that cannot go away,
one in kernel/profile.c that goes away regardless, one in lib/cpumask.c
that can probably just go away, ones in mm/page_alloc.c and page_cgroup.c
that cannot go away, and some in the memory model code that cannot
go away.

None of them would transform from your sequence A to B.

The rest of the callers are in s390, which probably tells you something
about the state of their init code. Don't know enough to know whether
your concerns hold there or not though.

But I think this is just scare mongering ;) If we actually look at
the code on a case by case basis then I think it won't be too much
problem.


> > It's not that the world is going to come to an end if we
> > can't remove the masking, but just maybe the information
> > can be used in future to avoid adding more overhead, or
> > maybe some other debugging features can be added or something.
> > I just think it is cleaner to go that way if possible, and
> > claiming that callers can't be expected to know what context
> > they clal the slab allocator from just sounds like a
> > contradiction to me.
> 
> I agree with the general principle of pushing state information out to
> the caller as much as possible. But like all principles, there are
> meaningful exceptions and I believe this is a good example of one.

And I'm willing to accept some burden on core services to
relieve callers of hard work, but I don't see the big problem
with boot code.

Code that is called from both sleeping and non-sleeping context
for example is *far far* more common than code that is called
from both early boot and normal running situation.

The preferred solution we take is not to test if (in_interrupt())
or other hacks like that, but simply to have the caller pass in
that information. Really, why does that not work other than
laziness?

I believe the principle of having hacks in the boot code like
that which is different to our normal idea of clean code is
a big part of the problem of why it is so ugly there. I can
live with that because it is well tested and not performance
critical code (and I don't usually have to ever look at it).
But I won't live with having it shit in our nice core code...
Well, at least I won't throw up my hands and give up this
early.

If we are talking about something that makes life of regular
driver/fs/subsystem/etc writer easier then I would give it much
more consideration. But we're talking about adding hacks in
the core allocators because we're too lazy to write early boot
code that even knows what context it is in...

