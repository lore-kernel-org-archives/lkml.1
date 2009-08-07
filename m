Return-Path: <linux-kernel-owner+w=401wt.eu-S932806AbZHGSlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbZHGSlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZHGSlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:41:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932526AbZHGSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:41:11 -0400
Date: Fri, 7 Aug 2009 11:40:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manuel Lauss <mano@roarinelk.homelinux.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net>
 <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net> <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Aug 2009, Linus Torvalds wrote:
>
> Ok, this is your PCI-PCI bridge to Bus#2, and it has two memory windows:
> 
> 	pci 0000:00:1e.0: transparent bridge
> 	pci 0000:00:1e.0: bridge io port: [0xd000-0xdfff]
> 	pci 0000:00:1e.0: bridge 32bit mmio: [0xff600000-0xff6fffff]
> 	pci 0000:00:1e.0: bridge 32bit mmio pref: [0xdea00000-0xdeafffff]
> 
> so I was wrong - that 0xff600000-0xff6fffff is non-prefetchable.
> 
> So I'm really not seeing why you then get that
> 
> 	pci 0000:02:03.0: BAR 6: address space collision on of device [0xff680000-0xff69ffff]
> 
> because while we've marked the ROM window prefetchable, it should fit 
> perfectly fine into a non-prefetchable PCI bus window.
> 
> Odd.

Oh, not odd at all.

Just after sending that email, I go "Duh!", and realize what's going on.

So because ROM resources are marked as being prefetchable, we have 
pci_find_parent_resource() that _prefers_ a prefetchable window.

So what happens (and now I'm sure) is that 

 - we call 'pci_find_parent_resource()' with the ROM resource, and it does 
   see the parent resource that would match:

	pci 0000:00:1e.0: bridge 32bit mmio: [0xff600000-0xff6fffff]

   but because it's not an _exact_ match (the IORESOURCE_PREFETCH flag 
   doesn't match), it will just remember that bridge resource as being the 
   "best seen so far":

                if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
                        best = r;       /* Approximating prefetchable by non-prefetchable */

 - and then, because the bus is transparent, at the end of the bus 
   resources we'll find the parent resources, which are the whole PCI 
   address space.

   And now it will match things *again* - and set "best" to that 
   transparent parent resource, even if it's not really any better at all 
   (the PCI root resource won't be marked prefetchable either, afaik).

 - so 'pci_find_parent_resource()' will instead of returning that MMIO 
   window (0xff600000-0xff6fffff), it will return the PCI root window. 
   Which technically is correct, since that _is_ a "better" window for 
   something like that.

 - but now we can no longer actually insert the resource directly into 
   that PCI root window, because the existing address of the preferred ROM 
   base is already taken (by the PCI bridge window that we'd want to 
   insert it into!)

 - Then, later on, we'll actually assign the ROM address to another area 
   which is prefetchable (well, except it's not really).

So it all actually makes sense. I see what's going on, and the PCI layer 
actually technically does all the right things. Or at least there's not 
really anything technically _wrong_ going on. We have multiple 
'acceptable' resources, we just picked the wrong one.

Anyway, I think we can fix this by just picking the first 'best' resource. 
That said, I suspect that we should actually make 'pci_claim_resource()' 
do this loop over parents, so that if there are multiple acceptable 
resources, we'd try them all rather than pick one - and then perhaps 
failing.

So this patch is not something that I'm going to apply to my tree, but 
it's worth testing out to just verify that yes, I finally understand 
exactly what's going on. Because if I'm right, your warning will now go 
away (and it could be replaced by _other_ issues, of course ;).

			Linus

---
 drivers/pci/pci.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index dbd0f94..89efbb5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -367,8 +367,12 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 			continue;	/* Wrong type */
 		if (!((res->flags ^ r->flags) & IORESOURCE_PREFETCH))
 			return r;	/* Exact match */
-		if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
-			best = r;	/* Approximating prefetchable by non-prefetchable */
+		/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
+		if (r->flags & IORESOURCE_PREFETCH)
+			continue;
+		/* .. but we can put a prefetchable resource inside a non-prefetchable one */
+		if (!best)
+			best = r;
 	}
 	return best;
 }
