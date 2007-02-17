Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbXBQVEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbXBQVEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbXBQVEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:04:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:44973 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbXBQVEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:04:37 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <m1y7mxb20a.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <1171664993.5644.92.camel@localhost.localdomain>
	 <m1y7mxb20a.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 08:04:00 +1100
Message-Id: <1171746241.5644.124.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> No.  I don't think we should make your irq_hwnumber_t thingy general
> because it is not general.  I don't understand why you need it to be
> an unsigned long, that still puzzles me.  But for the rest it actually
> appears that ppc has a simpler model to deal with.

I think you might have misunderstood becaues I do beleive it's actually
very general :-)

Let me explain below.

> I don't think I actually can describe x86 hardware in you hwnumber_t
> world.  Although I can approximate.

And I think it fits well...

> In non-legacy mode at the top of the tree I have a network cooperating
> irq controllers.  For each cpu there is an lapic next to each cpu that
> catches interrupt packets and below that I have interrupt controllers
> that throw interrupt packets.  In the network of cooperating interrupt
> controllers a interrupt packet has a destination address that looks
> like (cpu#, vector#) where cpu# is currently at 8 bits and slowly
> growing and the vector# is a fixed 8 bits.
> 
> The interrupt controllers that throw those packets have a fixed
> number of irq slots usually 24 or so.  Each slot (referred to in the
> code as a pin) can be programmed which (cpu#, vector#) packet it
> throws when an interrupt occurs. Including an option to vary the cpu#
> between a set of cpus.
> 
> So to be frank to handle this model properly I need to deal with
> this properly I need.
> #define NR_IRQS (NR_CPUS*256)
> 
> There is enough flexibility in this model that hardware vectors
> have not found a need to cascade interrupt controllers.

This is roughly similar to the cell "toplevel" model where interrupt
messages encode the source unit/node, target and class. The chip has an
interrupt "controller" (receiver of those messages) for each thread. In
the kernel, I use a "flat" model, that is I create one host for all of
them and my hardware numbers are mode of a similar bit encoding of those
"routing" infos.

That is, with a remapping model like mine, the x86 non-legacy situation
could be easily expressed by having one domain (I call them hosts in the
code) covering the whole fabric and the hw number be your (CPU << 16) |
vector thing.

In addition, but you don't need that on x86, cell has an external
controller cascaded on one of those interrupt, I use a separate domain
for it.

The reason my hwnumber thingy is a generic type is that i provide
generic functions to create a linux interrupt for a domain/number pair
and generic mecanism to do the reverse mapping. That's where I think my
code might be of some use as with the "numbers" going away, pretty
everybody will need a wat to reverse map from HW numbers back to
irq_desc *.

I use an unsigned long because I needed to choose a type that would fit
the biggest number potentially used by an interrupt controller, and that
can be real big with some hypervisors for which those are "tokens" which
are potentially 64 bits.

> Ben I have no problem with a number that is specific to an irq
> controller for dealing with the internal irq controller
> implementations, heck I think everyone has that to some degree
> 
> The linux irq number will remain an arbitrary software number for
> use by the linux system for talking about the source of the
> interrupt.

So you do intend to keep the linux number which is what I call the
"virtual interrupt" number on powerpc... I wouldn't have thought that to
be necessary except as a special case of an array of 16 entries for ISA
interrupts...

> Why in a sparse address space you would find it hard to allocate a
> range of numbers to an irq controller that only has a fixed number of
> irqs it can deal with is something I don't understand and I think
> it is does a disservice to your users.  But that is all it is
> a quality of implementation issue.  ia64 does the same foolish
> thing.

It would be fairly easy to change my powerpc code to pre-allocate a full
range for a given domain/pic when initializing it instead of doing
"lazy" scattered allocation like I do, though it won't bring much I
think. It's not possible for all PICs though, for example, the pSeries
needs to use the radix tree reverse mapper because of how large HW
interrupt numbers can be.

I chose not to do it. In the long run, the only remotely meaningful way
to expose interrupt to users would be to -add- columns
to /proc/interrupts that provide the "host" and the HW number on that
host, though I'm not sure that wouldn't break some userland tools.

> The only time it really makes sense to me to let the irq number vary
> arbitrary are when things are truly dynamic, like with MSI, a
> hypervisor, or hot plug interrupt controllers.

I don't understand why you would go to all that lenght to replace irq
numbers with irq_desc * and ... keep then numbers :-)

But again, as I said, this is in no way a fundamental limitation of the
powerpc code. It could be modified easily to allocate the whole range of
a given PIC that uses the "linear" remapping. It makes no sense for PICs
that use the "radix tree" remapping though.

> Sure, and I have the same issue with a big "DESIGNED FOR ppc" in the middle,
> or "DESIGNED FOR arch/x".   However the unfortunate truth is that the x86
> has enough volume that frequently other architectures use some x86
> hardware and thus get some of x86's warts.   So anything that doesn't
> cope with the x86's warts is frequently doomed to failure.

I fait to see how what I described would not apply nicely to x86 ..

Ben.


