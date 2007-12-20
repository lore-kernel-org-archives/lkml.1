Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXLTW0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXLTW0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXLTW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:26:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763661AbXLTW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:26:19 -0500
Date: Thu, 20 Dec 2007 14:24:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <20071220215204.GA5636@twiddle.net>
Message-ID: <alpine.LFD.0.9999.0712201406190.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
 <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <20071218215143.GA24769@twiddle.net> <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org>
 <20071220215204.GA5636@twiddle.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Richard Henderson wrote:

> On Tue, Dec 18, 2007 at 05:38:58PM -0800, Linus Torvalds wrote:
> > That
> > 
> > 	PCI: Cannot allocate resource region 9 of bridge 0000:00:01.0
> > 	PCI: Cannot allocate resource region 1 of device 0000:01:00.0
> > 
> > thing is really starting to bug me.
> > 
> > I bet that is the real problem here, but it's not printing out enough 
> > information about the resource to actually give us much of a clue about 
> > what is wrong.
> > 
> > I suspect that it had a bridge mapping (device 0:01.0) that included the 
> > range from 0xc0000000 to 0xcfffffff, but there was something stupid wrong 
> > with it (eg the BIOS had allocated overlapping regions), so we disabled 
> > it. That, in turn, then caused us to also refuse the existing 0xc0000000 
> > mapping for the graphics card (device 01:00.0), because now there was no 
> > valid resource for it.
> 
> That is exactly it.  The relevant section of the debug info is
> 
> PCI: Bridge 0000:00:01.0
> PCI: Bridge resource 7 00008000-00008fff (%f=100)
> PCI: Bridge resource 8 f7d00000-fddfffff (%f=200)
> PCI: Bridge resource 9 bdf00000-ddefffff (%f=1201)
> 
> The bridge was assigned to a piece of the end of physical memory.  

Oh, wow. That's just really bogus. So the kernel message about

	PCI: Cannot allocate resource region 9 of bridge 0000:00:01.0

was perfectly fine, and we did absolutely the right thing.

But it also says that if the graphics adaptor really had a resource mapped 
at 0xc0000000 - 0xcfffffff by the BIOS, then that mapping never worked at 
all, since it never had any bridge mapping it could rely on. So our 
decision to unmap that one as invalid was _also_ right.

Damn. Very irritating.

You know what? I think this simple (BUT TOTALLY UNTESTED!) patch will get 
your case right, and I think it is preferable to just always lowering the 
"minimum" starting point.

What it does is to just take the minimum PCI address for new allocations 
(which is only used for the case where we don't have an explicit starting 
point for the parent bus anyway!), and just saying "we'll always align it 
down to the required alignment of the allocation".

I'm not exactly 100% happy with it, but it does mean that if we need a big 
area, we'll relax the suggested starting point by that amount. It's not 
wonderful, but it essentially admits that the minimum for the allocations 
is really just a hint, and if we need lots of space for a resource, we'll 
relax the minimum point appropriately.

So in your case, it should *result* in the exact same situation that your 
patch did, but at the same time, when dealing with the (more common) case 
of smaller allocations, we still continue to try to avoid being too close 
to the top-of-memory.

So it's not perfect, but perhaps it is a good compromise between being 
careful and having to make room?

Does this work for your case?

		Linus

---
 drivers/pci/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 9e5ea07..d48d270 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -61,7 +61,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
-					r->start ? : min,
+					r->start ? : min & -align,
 					-1, align,
 					alignf, alignf_data);
 		if (ret == 0)
