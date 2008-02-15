Return-Path: <linux-kernel-owner+w=401wt.eu-S932767AbYBOALx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbYBOALx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbYBOALp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:11:45 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:48356 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130AbYBOALn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:11:43 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Thu, 14 Feb 2008 17:13:22 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <alpine.LFD.1.00.0802141456370.6110@woody.linux-foundation.org> <alpine.LFD.1.00.0802141503470.6110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802141503470.6110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141713.23461.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 04:14:45 pm Linus Torvalds wrote:
> 
> On Thu, 14 Feb 2008, Linus Torvalds wrote:
> > 
> > It should insert the resource to the root resource (or a bridge resource), 
> > or not at all. If somebody else has already inserted a real device 
> > resource, we already know about it, and the PnP information is going to be 
> > just making things worse.
> 
> Hmm. The approach I'd take is to always insert the thing into the root 
> resource. If we do want to let PnP insert it into some lower-level bus, 
> we'd need to have some way to distinguish "bus" from "device", and we 
> don't.
> 
> So right now, how about just making PnP/ACPI just use
> 
> 	root = (flags & IORESOURCE_MEM) ? iomem_resource : ioport_resource;
> 	request_resource(root, newresource);
> 
> which is what we do for the e820 map and the other special resources we 
> know about (ie the magic resources we make up ourselves like video ram and 
> our standard PCI/ISA resource lists like the <0x100 DMA/PIC/FPU IO ports 
> etc)

That makes sense, but ...  there are BIOSes that actually list nested
resources, e.g., http://bugzilla.kernel.org/show_bug.cgi?id=9514#c29 :

  [000000290 - 000000294]  Motherboard resources
  [000000290 - 00000029F]  Motherboard resources

We'd have to make sure we don't start with the 0x290-0x294 resource,
because then we'll fail when we try to reserve 0x290-0x29f, and we
really should avoid using the 0x295-0x2f9 piece as well.

And even if we do figure out the "outermost" resources, I'd worry
that some BIOS will have separate ACPI devices that have overlapping
resources.  Then Murphy's Law says that we'll find the device with
the smaller resource first, reserve it, then find a device with an
enclosing resource, and leave something unreserved.

Maybe that's still better than a quirk; I don't know.  I guess it's
pretty ugly either way.

Bjorn
