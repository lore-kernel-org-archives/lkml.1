Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXL1Ee2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXL1Ee2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 23:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXL1EeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 23:34:18 -0500
Received: from iabervon.org ([66.92.72.58]:40599 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbXL1EeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 23:34:17 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2007 23:34:17 EST
Date: Thu, 27 Dec 2007 23:27:35 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Loic Prylli <loic@myri.com>, Robert Hancock <hancockr@shaw.ca>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <47742498.1060900@tragetaschen.dyndns.org>
Message-ID: <alpine.LNX.1.00.0712272204520.13593@iabervon.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca> <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org> <477414C9.3040906@myri.com>
 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007, Kai Ruhnau wrote:

> Linus Torvalds wrote:
> > On Thu, 27 Dec 2007, Linus Torvalds wrote:
> >   
> >> Kai, can you try that? Just remove the call to pci_enable_crs() in 
> >> pci_scan_bridge() in drivers/pci/probe.c, and see if mmconfig starts 
> >> working for you?
> >>     
> >
> > We could also make the error handling more permissive, and just check for 
> > the low 16 bits, which is the part that the CRS spec mentions the actual 
> > value for. The whole vendor ID of 0x0001 is mentioned int he CRS spec as 
> > being explicitly chosen exactly because it's invalid.
> >
> > That said, given that we don't actually reap any benefits from CRS support 
> > right now *anyway*, I think the right thing to do is disable it by 
> > default. But it would be interesting to know if this patch makes it work 
> > on those ATI bridges..
> >
> > 		Linus
> >
> > ---
> >  drivers/pci/probe.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 2f75d69..94cd3a4 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -908,7 +908,7 @@ pci_scan_device(struct pci_bus *bus, int devfn)
> >  		return NULL;
> >  
> >  	/* Configuration request Retry Status */
> > -	while (l == 0xffff0001) {
> > +	while ((l & 0xffff) == 0x0001) {
> >  		msleep(delay);
> >  		delay *= 2;
> >  		if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &l)
> 
> That one did not work out so well.
> I reenabled the call to pci_enable_crs() and changed the line as above.
> That resulted in two timeouts (from dmesg):
> 
> [....]
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOACPI for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> Device 0000:01:00.0 not responding
> Device 0000:02:00.0 not responding
> [....]
> 
> Then, the kernel boots up normally except of graphics and network card
> not showing up at all in lspci.

Uh, right. We already know that your northbridge, mmconfig, CRS, and this 
device combine to always return 0001 for the Vendor ID. If we loop on 
getting that, we must time out.

I'd actually bet that the hardware bug is actually that any device that 
gives a CRS response the first time will have its Vendor ID appear as 0001 
on subsequent mmconfig accesses, which means that it's actually a bus 
quirk that probably only affects mmconfig access to something in the 
conf1-visible space. The only per-device aspect would be that it uses CRS 
(possibly correctly), and that doesn't mean that mmconfig won't be safe in 
general for the device, or even that it won't be necessary. Actually, we 
already know that per-driver enabling mmconfig is broken: sky2 is one that 
wants to opt in but there are also reports of the Vendor ID 0001 bug with 
it.

	-Daniel
*This .sig left intentionally blank*
