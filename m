Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXLVJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXLVJVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 04:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXLVJVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 04:21:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbXLVJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 04:21:03 -0500
Date: Sat, 22 Dec 2007 01:20:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>
Subject: Re: PCI resource problems caused by improper address rounding
Message-Id: <20071222012006.39249396.akpm@linux-foundation.org>
In-Reply-To: <20071222011218.0a5cfa42.akpm@linux-foundation.org>
References: <47671377.6000405@redhat.com>
	<alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org>
	<47680489.6040809@redhat.com>
	<alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org>
	<20071218202234.GA24525@twiddle.net>
	<20071219002349.A12278@jurassic.park.msu.ru>
	<alpine.LFD.0.9999.0712181338150.21557@woody.linux-foundation.org>
	<20071220084616.GA28578@jurassic.park.msu.ru>
	<20071222011218.0a5cfa42.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 01:12:18 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 20 Dec 2007 11:46:16 +0300 Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> 
> > PCI: do respect full 64-bit address for bridge prefetch window
> > 
> > Prevent the prefetch window from being programmed with a bogus address
> > when its respective resource gets allocated above the 4G mark.
> > 
> > Note that we cannot yet guarantee correct resource allocations
> > above 4G, though it might work in some simple cases.
> > 
> 
> So.. did we agree that this patch is good to go?

Oh, I see Greg merged a differnet patch.

> > --- a/drivers/pci/setup-bus.c
> > +++ b/drivers/pci/setup-bus.c
> > @@ -208,8 +208,11 @@ pci_setup_bridge(struct pci_bus *bus)
> >  	}
> >  	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
> >  
> > -	/* Clear out the upper 32 bits of PREF base. */
> > -	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, 0);
> > +	/* Set up the upper 32 bits of PREF base/limit. */
> > +	l = region.start >> 16 >> 16;
> 
> We have the little upper_32_bits() helper for this.
> 

Which could use this.

--- a/drivers/pci/setup-bus.c~gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources-cleanup
+++ a/drivers/pci/setup-bus.c
@@ -206,10 +206,8 @@ pci_setup_bridge(struct pci_bus *bus)
 	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-#ifdef CONFIG_RESOURCES_64BIT
-		bu = region.start >> 32;
-		lu = region.end >> 32;
-#endif
+		bu = upper_32_bits(region.start);
+		lu = upper_32_bits(region.end);
 		DBG(KERN_INFO "  PREFETCH window: 0x%016llx-0x%016llx\n",
 		    (unsigned long long)region.start,
 		    (unsigned long long)region.end);

