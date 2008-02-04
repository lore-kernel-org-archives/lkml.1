Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYBDVSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYBDVSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYBDVRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435AbYBDVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:11 -0500
Date: Mon, 4 Feb 2008 13:16:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802041341.37313.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802041300170.3034@hp.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802041039.36100.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802041014410.3034@hp.linux-foundation.org> <200802041341.37313.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Feb 2008, Bjorn Helgaas wrote:
> 
> I'm sure you're right, but I don't understand why yet.  Here's what
> I think is happening; please correct me where I'm going wrong:
> 
>   1) enumerate PNP & ACPI devices
>   2) initialize PNP & ACPI drivers
>      2a) register ACPI PCI root bridge driver, which enumerates PCI
>          devices behind the bridge
>      2b) register PNP system driver and reserve resources (this is
>          where the current quirk skips some reservations)
>   3) initialize PCI drivers
>      3a) register intel8x0 sound driver and reserve conflicting
>          resources

So where in this would you put the

	pcibios_init() -> pcibios_resource_survey()

call (it's a subsys_initcall)?

THAT is the thing that actually registers the PCI resurces we've found 
into the resource tree!

It's very inconveniently placed as-is, since it literally depends on the 
whole initcall ordering (and the link order within that subsys_initcall 
thing), and all of this is architecture-driven rather than driven from 
some central place.

So this is the thing that I think should happen before any PnP or ACPI 
drivers actually start registerign themselves (but obviously needs to 
happen after the PCI buses have been enumerated).

The ACPI/PnP tables shouldn't be able to break the enumeration of the 
actual hardware devices, now should it?

> I think you're suggesting that we should do 2a first, to enumerate all
> PCI devices, and only later do 2b.  But I don't know how to accomplish
> that cleanly.

We should enumerate the PCI devices, then register their resources (and 
no, I'm not at *all* convinced it should happen as a separate 
subsys_initcall), and then register the PnP resources. 

So I think we should have roughly something like:

 - arch_initcall: this could enumerate the ACPI/PnP devices (but not 
   register anything). Alternatively, do it as subsys_initcall, and just
   make sure it happens early with link-order.

 - subsys_initcall: this should do that pcibios_init() thing that surveys 
   the resources (and the PCI enumeration needs to have happened before, 
   probably in the same initcall thanks to link order)

 - PnP/ACPI resource allocation *after* it, but before driver loading 
   (which wll cause new resources to be allocated). This could be 
   fs_initcall, or whatever (that's what things like "acpi_event_init" 
   already do).

 - regular drivers will come along much later, as part of 
   driver_initcall, and by the time this happens, we've now reserved all 
   resources we know about.

Basically, we just want to register the most trust-worthy resources before 
we register anything less trust-worthy. And actual device probing simply 
tends to be more trust-worthy than any randomly broken ACPI/PnP tables.

		Linus
