Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZFOKqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZFOKqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFOKqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:46:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:36409 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZFOKqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:46:12 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <20090615101254.GB10294@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 20:39:48 +1000
Message-Id: <1245062388.12400.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why? The best reason to use slab allocator is that the allocations
> are much more efficient and also can be freed later.

I think you are making the mistake of reasoning too much in term of
implementation of the allocator itself, and not enough in term of the
consistency of the API exposed to the rest of the kernel.

I think the current approach is a good compromise. If you can make it
more optimal (by pushing the masking in slow path for example), then go
for it, but from an API standpoint, I don't like having anybody who
needs to allocate memory have to know about seemingly unrelated things
such as whether interrupts have been enabled globally yet, scheduler
have been initialized, or whatever else we might stumble upon.

> > I think the boot order is too likely to change to make it a sane thing
> > to have all call sites "know" at what point they are in the boot
> > process.
> 
> I disagree.

How so ? IE. We are changing things in the boot order today, and I'm
expecting things to continue to move in that area. I believe it's going
to be endless headaches and breakage if we have to get the right set of
flags on every caller.

In addition, there's the constant issue of code that can be called both
at boot and non-boot time and shouldn't have to know where it has been
called from, while wanting to make allocations, such as get_vm_area().

I don't think it will make anybody's life better to push out the "boot
state" up into those APIs, duplicating them, etc...

> > In your example, what does GFP_BOOT would mean ? Before
> > scheduler is initialized ? before interrupts are on ?
> 
> Before initcalls is probably easiest. But it really does not
> matter that much. Why? Because if we run out of memory before
> then, then there is not going to be anything to reclaim
> anyway.

Precisely. It -doesn't matter- (to the caller). So why make it matter in
term of API ? There's a whole bunch of things in arch code or subsystems
that really don't have any business knowing in what context or at what
time they have been called.

> > There's just too much stuff involved and we don't want random
> > allocations in various subsystem or arch code to be done with that
> > special knowledge of where specifically in that process they are done.
> 
> If they're done that early, of course they have to know where
> they are because they only get to use a subset of kernel
> services depending exactly on what has already been done.

To a certain extent, yes. But not -that- much, expecially when it comes
to a very basic service such as allocating memory.

> > Especially since it may change.
> 
> "it" meaning the ability to reclaim memory? Not really. Not a
> significant amount of memory may be reclaimed really until
> after init process starts running.

How much stuff allocated during boot needs to be reclaimed ?
> 
> > Additionally, I believe the flag test/masking can be moved easily enough
> > out of the fast path... slub shouldn't need it there afaik and if it's
> > pushed down into the allocation of new slab's then it shouldn't be a big
> > deal.
> 
> Given that things have been apparently coping fine so far, I
> think it will be a backward step to just give up now and say
> it is too hard simply because slab is available to use slightly
> earlier.

Things have been coping thanks to horrors such as

	if (slab_is_available())
		kmalloc
	else
		alloc_bootmem.

Now you are proposing to change that into

	if (whatever_are_we_talking_about())
		kmalloc(... GFP_KERNEL)
	else
		kmalloc(... GFP_BOOT)

Not a very big improvement in my book :-)

> It's not that the world is going to come to an end if we
> can't remove the masking, but just maybe the information
> can be used in future to avoid adding more overhead, or
> maybe some other debugging features can be added or something.
> I just think it is cleaner to go that way if possible, and
> claiming that callers can't be expected to know what context
> they clal the slab allocator from just sounds like a
> contradiction to me.

I agree with the general principle of pushing state information out to
the caller as much as possible. But like all principles, there are
meaningful exceptions and I believe this is a good example of one.

Cheers,
Ben.


