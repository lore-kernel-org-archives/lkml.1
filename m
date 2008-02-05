Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYBEQXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYBEQXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbYBEQXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:23:33 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:44921 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbYBEQXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:23:31 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Tue, 5 Feb 2008 00:03:32 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802041341.37313.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802041300170.3034@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802041300170.3034@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802050003.32591.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008 02:16:52 pm Linus Torvalds wrote:
> 
> On Mon, 4 Feb 2008, Bjorn Helgaas wrote:
> > 
> So where in this would you put the
> 
> 	pcibios_init() -> pcibios_resource_survey()
> 
> call (it's a subsys_initcall)?
> 
> THAT is the thing that actually registers the PCI resurces we've found 
> into the resource tree!

I think pcibios_init() currently happens after we register
ACPI & PNP drivers, i.e., at 3 below:

  1) enumerate PNP & ACPI devices
  2) initialize PNP & ACPI drivers
     2a) register ACPI PCI root bridge driver, which enumerates PCI
         devices behind the bridge
     2b) register PNP system driver and reserve resources (this is
         where the current quirk skips some reservations)
  3) pcibios_init() -> pcibios_resource_survey()
  4) initialize PCI drivers
     4a) register intel8x0 sound driver and reserve resources
         (conflict happens here)

> The ACPI/PnP tables shouldn't be able to break the enumeration of the 
> actual hardware devices, now should it?

Well, no :-)  We have to make PNP & ACPI smart enough to not cause
trouble, and I fully accept that the burden is on PNP.

But PNPBIOS and ACPI by definition are for devices that don't have
their own enumeration protocol.  Obviously, we have a lot of legacy
drivers that blindly probe for devices at magic addresses, but
that's validating guesswork, not actually enumerating anything.

In this particular case, we can easily enumerate all the PCI devices
in domain 0.  But for machines that have multiple PCI domains, I don't
think we want to exhaustively scan all possible domains.  ACPI tells us
what root bridges exist and what domain each is in, so we can scan a
little more efficiently.

> We should enumerate the PCI devices, then register their resources (and 
> no, I'm not at *all* convinced it should happen as a separate 
> subsys_initcall), and then register the PnP resources. 
> 
> So I think we should have roughly something like:
> 
>  - arch_initcall: this could enumerate the ACPI/PnP devices (but not 
>    register anything). Alternatively, do it as subsys_initcall, and just
>    make sure it happens early with link-order.

Scanning PCI buses has to happen here, which currently means that we
have to register the ACPI PCI root driver so we know which domains and
buses to scan.

>  - subsys_initcall: this should do that pcibios_init() thing that surveys 
>    the resources (and the PCI enumeration needs to have happened before, 
>    probably in the same initcall thanks to link order)
> 
>  - PnP/ACPI resource allocation *after* it, but before driver loading 
>    (which wll cause new resources to be allocated). This could be 
>    fs_initcall, or whatever (that's what things like "acpi_event_init" 
>    already do).

If we put the PNP system driver here, we can easily do a quirk that
ignores PNP resources that overlap PCI resources.  But it's kind of
ugly to have the ACPI PCI root driver early and other PNP drivers
later because they're basically similar animals.

>  - regular drivers will come along much later, as part of 
>    driver_initcall, and by the time this happens, we've now reserved all 
>    resources we know about.
> 
> Basically, we just want to register the most trust-worthy resources before 
> we register anything less trust-worthy. And actual device probing simply 
> tends to be more trust-worthy than any randomly broken ACPI/PnP tables.

I agree that PCI BARs are likely more trustworthy than firmware
tables.  Maybe we could figure out a way to do the PNP reservations,
then revert them if we find an overlapping PCI BAR.

Does anybody with this motherboard (or the Supermicro board with
similar SATA problems) also have Windows on it?  I'm curious to
see how Windows deals with this conflict, e.g., what shows up in
the device manager?

Bjorn
