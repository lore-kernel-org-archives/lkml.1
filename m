Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYCCUnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYCCUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYCCUm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:42:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:56373 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYCCUmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:42:55 -0500
Subject: Re: Weirdness in pci_read_bases()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <200803031112.27658.jbarnes@virtuousgeek.org>
References: <1204252667.15052.402.camel@pasglop>
	 <200803031112.27658.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 07:42:34 +1100
Message-Id: <1204576954.21545.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 11:12 -0800, Jesse Barnes wrote:
> On Thursday, February 28, 2008 6:37 pm Benjamin Herrenschmidt wrote:
> > Hi !
> >
> > There is something dodgy going on in pci_read_bases().
> >
> > In addition to the fact (or related to it) that we tend to treat
> > res->start == 0 as meaning "unassigned" (which at this stage is mostly
> > incorrect, but let's say I can cope),
> 
> Yeah, that sounds like trouble.  I expect this may become a problem even for 
> PC architectures in the future (IOMMUs on multiple busses for example), so 
> maybe it makes sense to change the core to not assume 0 == unassigned?

Not only iommu's. On lots of platforms, we have the PCI MMIO space
mapped 1:N, that is, an access at MMIO location N turns into a PCI cycle
with address 0. So outbound PCI is effectively remapped, thus allowing
access to things like 0 etc... without punching holes in RAM and without
other dirty x86-like tricks.

The main question regarding 0 in a BAR is do we know of devices that
consider it as "disabled" and don't operate/decode 0 ? (That would be
gross and out of spec but who knows...)

If not, then there is no notion of "unassigned" at all... Anything is
"assigned", it's just a matter of whether the value we get at boot time
overlaps with something else or not, or is within the range of the host
bridge or not.

Unfortunately, while pretty much all architectures have a clear idea of
what is decoded by a given bridge, and what overlap with others and what
not, x86 doesn't :-)

But that can be solved, using something akin to IORESOURCE_UNSET, like
we do on powerpc, generalizing it, and having an x86-specific quirk set
it on anything that comes up with resource->start == 0.

> But we should never hit the l == 0xffffffff case if it's a memory BAR, since 
> the low bit will be 0, right?

And for an IO BAR, there's another bit that should be 0, so that's
simply an impossible value for a BAR.

> I think Grant is probably right that the only time we'd hit this is if the bus 
> is down and we're getting back all 1s for every read (though that's a PC 
> specific assumption).

But the next two write/reads for sizing would have worked ? Unlikely...
I wonder if we can just remove that test completely :-)

> Yeah, it seems like it could be safely removed, but this is an area where we 
> should probably move slowly (i.e. one, very small change to the probing code 
> at a time) or it may be difficult to isolate any bugs in the wild.

True.

Cheers,
Ben.


