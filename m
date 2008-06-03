Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYFCQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYFCQxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYFCQxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:53:09 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:48577 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752599AbYFCQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:53:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: MMIO and gcc re-ordering issue
Date: Tue, 3 Jun 2008 09:52:09 -0700
User-Agent: KMail/1.9.9
Cc: Jes Sorensen <jes@sgi.com>, Jeremy Higdon <jeremy@sgi.com>,
       Roland Dreier <rdreier@cisco.com>, benh@kernel.crashing.org,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
References: <1211852026.3286.36.camel@pasglop> <4843C3D7.7000609@sgi.com> <200806031433.12460.nickpiggin@yahoo.com.au>
In-Reply-To: <200806031433.12460.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030952.10360.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 02, 2008 9:33 pm Nick Piggin wrote:
> On Monday 02 June 2008 19:56, Jes Sorensen wrote:
> > Jeremy Higdon wrote:
> > > We don't actually have that problem on the Altix.  All writes issued
> > > by CPU X will be ordered with respect to each other.  But writes by
> > > CPU X and CPU Y will not be, unless an mmiowb() is done by the
> > > original CPU before the second CPU writes.  I.e.
> > >
> > > 	CPU X	writel
> > > 	CPU X	writel
> > > 	CPU X	mmiowb
> > >
> > > 	CPU Y	writel
> > > 	...
> > >
> > > Note that this implies some sort of locking.  Also note that if in
> > > the above, CPU Y did the mmiowb, that would not work.
> >
> > Hmmm,
> >
> > Then it's less bad than I thought - my apologies for the confusion.
> >
> > Would we be able to use Ben's trick of setting a per cpu flag in
> > writel() then and checking that in spin unlock issuing the mmiowb()
> > there if needed?
>
> Yes you could, but your writels would still not be strongly ordered
> within (or outside) spinlock regions, which is what Linus wants (and
> I kind of agree with).

I think you mean wrt cacheable memory accesses here (though iirc on ia64 
spin_unlock has release semantics, so at least it'll barrier other stores).

> This comes back to my posting about mmiowb and io_*mb barriers etc.
>
> Despite what you say, what you've done really _does_ change the semantics
> of wmb() for all drivers. It is a really sad situation we've got ourselves
> into somehow, AFAIKS in the hope of trying to save ourselves a tiny bit
> of work upfront :( (this is not just the sgi folk with mmiowb I'm talking
> about, but the whole random undefinedness of ordering and io barriers).
>
> The right way to make any change is never to weaken the postcondition of
> an existing interface *unless* you are willing to audit the entire tree
> and fix it. Impossible for drivers, so the correct thing to do is introduce
> a new interface, and move things over at an easier pace. Not rocket
> science.

Well, given how undefined things have been in the past, each arch has had to 
figure out what things mean (based on looking at drivers & core code) then 
come up with appropriate primitives.  On Altix, we went both directions:  we 
made regular PIO reads (readX etc.) *very* expensive to preserve 
compatibility with what existing drivers expect, and added a readX_relaxed to 
give a big performance boost to tuned drivers.

OTOH, given that posted PCI writes were nothing new to Linux, but the Altix 
network topology was, we introduced mmiowb() (with lots of discussion I might 
add), which has clear and relatively simple usage guidelines.

Now, in hindsight, using a PIO write set & test flag approach in 
writeX/spin_unlock (ala powerpc) might have been a better approach, but iirc 
that never came up in the discussion, probably because we were focused on PCI 
posting and not uncached vs. cached ordering.

> The argument that "Altix only uses a few drivers so this way we can just
> fix these up rather than make big modifications to large numbers of
> drivers" is bogus. It is far worse even for Altix if you make incompatible
> changes, because you first *break* every driver on your platform, then you
> have to audit and fix them. If you make compatible changes, then you have
> to do exactly the same audits to move them over to the new API, but you go
> from slower->faster rather than broken->non broken. As a bonus, you haven't
> got random broken stuff all over the tree that you forgot to audit.

I agree, but afaik the only change Altix ended up forcing on people was 
mmiowb(), but that turned out to be necessary on mips64 (and maybe some other 
platforms?) anyway.

> I don't know how there is still so much debate about this :(
>
> I have a proposal: I am a neutral party here, not being an arch maintainer,
> so I'll take input and write up a backward compatible API specification
> and force everybody to conform to it ;)

Aside from the obvious performance impact of making all the readX/writeX 
routines strongly ordered, both in terms of PCI posting and cacheable vs. 
uncacheable accesses, it also makes things inconsistent.  Both core code & 
drivers will still have to worry about regular, cacheable memory barriers for 
correctness, but it looks like you're proposing that they not have to think 
about I/O ordering.

At any rate, I don't think anyone would argue against defining the ordering 
semantics of all of these routines (btw you should also include ordering wrt 
DMA & PCI posting); the question is what's the best balance between keeping 
the driver requirements simple and the performance cost on complex arches.

Jesse
