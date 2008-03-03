Return-Path: <linux-kernel-owner+w=401wt.eu-S1760726AbYCCVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726AbYCCVEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760120AbYCCVEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:04:21 -0500
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:57657 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759873AbYCCVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:04:20 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz, benh@kernel.crashing.org
Subject: Re: Weirdness in pci_read_bases()
Date: Mon, 3 Mar 2008 12:57:33 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
References: <1204252667.15052.402.camel@pasglop> <200803031112.27658.jbarnes@virtuousgeek.org> <1204576954.21545.10.camel@pasglop>
In-Reply-To: <1204576954.21545.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031257.33249.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 03, 2008 12:42 pm Benjamin Herrenschmidt wrote:
> On Mon, 2008-03-03 at 11:12 -0800, Jesse Barnes wrote:
> > On Thursday, February 28, 2008 6:37 pm Benjamin Herrenschmidt wrote:
> > > Hi !
> > >
> > > There is something dodgy going on in pci_read_bases().
> > >
> > > In addition to the fact (or related to it) that we tend to treat
> > > res->start == 0 as meaning "unassigned" (which at this stage is mostly
> > > incorrect, but let's say I can cope),
> >
> > Yeah, that sounds like trouble.  I expect this may become a problem even
> > for PC architectures in the future (IOMMUs on multiple busses for
> > example), so maybe it makes sense to change the core to not assume 0 ==
> > unassigned?
>
> Not only iommu's. On lots of platforms, we have the PCI MMIO space
> mapped 1:N, that is, an access at MMIO location N turns into a PCI cycle
> with address 0. So outbound PCI is effectively remapped, thus allowing
> access to things like 0 etc... without punching holes in RAM and without
> other dirty x86-like tricks.

Right, bus address space is really a separate entity; I was just using IOMMUs 
as an example of that...

> The main question regarding 0 in a BAR is do we know of devices that
> consider it as "disabled" and don't operate/decode 0 ? (That would be
> gross and out of spec but who knows...)

I don't know of any offhand (yeah does sound gross).

> If not, then there is no notion of "unassigned" at all... Anything is
> "assigned", it's just a matter of whether the value we get at boot time
> overlaps with something else or not, or is within the range of the host
> bridge or not.
>
> Unfortunately, while pretty much all architectures have a clear idea of
> what is decoded by a given bridge, and what overlap with others and what
> not, x86 doesn't :-)

Yep, but that's just an artifact of the way PCs are typically laid out.  
There's nothing preventing certain platforms from doing things differently, 
either with special bridges or just funky address space layout.

> But that can be solved, using something akin to IORESOURCE_UNSET, like
> we do on powerpc, generalizing it, and having an x86-specific quirk set
> it on anything that comes up with resource->start == 0.

Yeah, that would be an improvement...

>
> > But we should never hit the l == 0xffffffff case if it's a memory BAR,
> > since the low bit will be 0, right?
>
> And for an IO BAR, there's another bit that should be 0, so that's
> simply an impossible value for a BAR.

Right.

> > I think Grant is probably right that the only time we'd hit this is if
> > the bus is down and we're getting back all 1s for every read (though
> > that's a PC specific assumption).
>
> But the next two write/reads for sizing would have worked ? Unlikely...
> I wonder if we can just remove that test completely :-)
>
> > Yeah, it seems like it could be safely removed, but this is an area where
> > we should probably move slowly (i.e. one, very small change to the
> > probing code at a time) or it may be difficult to isolate any bugs in the
> > wild.
>
> True.

I think we can just kill that test...

Jesse

