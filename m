Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZJLRes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZJLRes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbZJLRes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:34:48 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25915 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbZJLRer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:34:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: Patch "USB: Work around BIOS bugs by quiescing USB controllers earlier" causes MCEs
Date: Mon, 12 Oct 2009 11:34:08 -0600
User-Agent: KMail/1.9.10
Cc: Mikael Pettersson <mikpe@it.uu.se>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Patterson <andrew.patterson@hp.com>
References: <20091002073400.GV6327@wotan.suse.de> <19142.21600.475756.10647@pilspetsen.it.uu.se> <20091006044401.GA30316@wotan.suse.de>
In-Reply-To: <20091006044401.GA30316@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121134.09200.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009 10:44:01 pm Nick Piggin wrote:
> On Fri, Oct 02, 2009 at 09:28:32PM +0200, Mikael Pettersson wrote:
> > Mikael Pettersson writes:
> >  > Nick Piggin writes:
> >  >  > Hi,
> >  >  > 
> >  >  > Your patch db8be50c4307dac2b37305fc59c8dc0f978d09ea is causing my
> >  >  > ia64 Altix system to die with an MCE in early boot.
> >  > 
> >  > The same commit has been confirmed by two people on the ARM list
> >  > to cause boot failures on two different Intel XScale IOP machines.
> >  > The machines have serial consoles, but only show
> >  > 
> >  > Uncompressing Linux... done. Booting the kernel.
> >  > 
> >  > before they hang.
> > 
> > I've just investigated this on one of my ARM boxes that this commit kills.
> > 
> > The commit changed quirk_usb_early_handoff to be a FIXUP_HEADER, which
> > caused it to be invoked during the early stages of the platform's PCI
> > init (arch/arm/kernel/bios32.c). quirk_usb_handoff_uhci() gets a bogus
> > I/O base address, passes that down to uhci_reset_hc(), causing a kernel
> > page fault in the first "outw(UHCI_USBCMD_HCRESET, base + UHCI_USBCMD);",
> > causing the kernel to oops.
> > 
> > (All this occurs before the serial console works, so I had to add a
> > platform-specific puts() and lots of tracing statements.)
> > 
> > Changing this quirk back to a FIXUP_FINAL allows the platform's PCI
> > init to complete. Later on the generic pci_init() calls the quirk,
> > which now gets the correct I/O base address, and the outw()s in
> > uhci_reset_hc() don't fail.
> 
> Thanks for this, I guess we await David's response.

The problem seen by Andrew on ia64 is that FIXUP_HEADER happens between
device discovery and the PCI fixups, and in this interval, the struct
pci_dev contains PCI bus addresses, not CPU (host) addresses.  Often
the PCI bus address and the CPU address are the same, but on machines
where they differ, we can't access PCI BARs in this interval.

I don't know about ARM, but on ia64, we do have enough information to
avoid this problem by always putting the CPU addresses in the pci_dev,
i.e., by doing the PCI fixups immediately at device discovery-time.

I think this is the best solution, because it removes the restriction
that FIXUP_HEADER can't access PCI BARs on certain machines.

Bjorn
