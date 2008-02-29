Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbYB2HPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYB2HPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 02:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYB2HPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 02:15:42 -0500
Received: from colo.lackof.org ([198.49.126.79]:39455 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbYB2HPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 02:15:41 -0500
Date: Fri, 29 Feb 2008 00:15:25 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: Weirdness in pci_read_bases()
Message-ID: <20080229071525.GA14419@colo.lackof.org>
References: <1204252667.15052.402.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204252667.15052.402.camel@pasglop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 01:37:47PM +1100, Benjamin Herrenschmidt wrote:
> Hi !
> 
> There is something dodgy going on in pci_read_bases().
...
> 		if (l == 0xffffffff)
> 			l = 0;
...
> Thus a l value of 0xffffffff should not happen in practice, and if it
> does, we should -at-least- try to get the address space bits from sz
> (since in this case sz looks allright), not from l, no ? Or maybe just
> skip the whole resource ?

I agree this code looks wrong.

I used "the google" to track this down and at least got a bit
closer to when this was added: 2.3.15 it seems:

	http://www.linuxhq.com/kernel/v2.3/15/drivers/pci/pci.c

--- v2.3.14/linux/drivers/pci/pci.c   Thu Aug 12 11:50:14 1999
+++ linux/drivers/pci/pci.c   Mon Aug 23 13:47:35 1999

It doesn't explain why but I suspect knowing the timeframe should
make the search a bit easier.

I have to confess. This is right around the time I got involved
with the linux kernel developement and specifically the parisc-linux.org
port. I was rewriting Alan Cox's first cut of Dino PCI Host-bus controller
"driver" (IRQ and PCI bus support for Dino chip).


Hrm...found an earlier reference to similar code:

http://www.srcdoc.com/linux_2.2.26/drivers_2pci_2pci_8c-source.html

...
00136         for(reg=0; reg<howmany; reg++) {
00137                 pci_read_config_dword(dev, PCI_BASE_ADDRESS_0 + (reg << 2), &l);
00138                 if (l == 0xffffffff)
00139                         continue;
00140                 dev->base_address[reg] = l;
...

This is a check to avoid mucking with 64-bit BARs.
But a bit later where pci_read_bases is called from:

00225                         pci_read_bases(dev, 6);
00226                         pcibios_read_config_dword(bus->number, devfn, PCI_ROM_ADDRESS, &l);
00227                         dev->rom_address = (l == 0xffffffff) ? 0 : l;
00228                         break;

The Expansion ROM BAR was clearly treated differently and I don't know why.

...
> Do we have practical cases where we see that 0xffffffff value ?

I can think of two cases this _might_ (but shouldn't) happen.
1) We probe the upper 32-bits of a 64-bit BAR and it already
contains 0xffffffff. This would be a bug in the probing IMHO.

2) PCI device ceases to talk to PCI Host and we get a PCI master abort.
I expect ~0 to be returned by HW in this case.
We need to skip this device and/or restart the probing
of this device (and possible others in the same PCI segment.)

hth,
grant
