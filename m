Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXLICNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXLICNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 21:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXLICNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 21:13:10 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41207 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbXLICNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 21:13:08 -0500
Date: Sun, 9 Dec 2007 02:12:32 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071209021231.GA13729@linux-mips.org>
References: <200710122305.l9CN5tFI008240@hera.kernel.org> <1196899818.7033.11.camel@pasglop> <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net> <1196917447.7033.17.camel@pasglop> <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net> <1196922262.7033.33.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196922262.7033.33.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 05:24:22PM +1100, Benjamin Herrenschmidt wrote:

> On Thu, 2007-12-06 at 14:58 +0900, Yoichi Yuasa wrote:
> > > What I don't understand is thus why you are calling resource_to_bus
> > on 0x1f0
> > > which is -not- a resource value, but is already a BAR value...
> > 
> > 0x1f0 is resource value on MIPS Cobalt.
> > All RAW BAR values contain the offset(0x10000000) on it.
> > 
> > Do the BAR values on your target contain the offset?
> 
> No, and I don't understand... raw BAR values don't contain such offset.
> The physical address where the PIO is mapped might, but that's not what
> we put in struct resource for IO resources and definitely not the BAR
> value.
> 
> The legacy IDE device will decode cycles at 0x1f0, not cycles at
> 0x100001f0.
> 
> Take for example PowerPC. Imagine that I have a bus whose IO space is
> mapped at 0xf0000000 in the processor physical address space (this is a
> real example, my powermac does that for the x16 PCI-Express slot though
> other slots use other offsets).
> 
> Now, the kernel on ppc64 will map that virtually at some allocated
> virtual address that we'll call we call bus_io_virt for this
> explanation. In addition, inb() and outb() will apply an offset (which
> can be different) that we call _IO_BASE to the port numbers. In general,
> bus_io_virt of the first bus == _IO_BASE on ppc32 but that's not a
> strict rule.
> 
> Let's say for the sake of the example, that _IO_BASE is 0xd0000000 and
> our bus has been mapped at 0xd0010000 (bus_io_virt). So 0xd0010000 maps
> to 0xf0000000 via the MMU.
> 
> When we scan the bus, we read the BAR content. So for example, a device
> whose IOs have been assigned at 0x1000 will read that as a RAW bar value
> and pci_scan_slot() (or whoever does the reading) will put 0x1000 in the
> struct resource. In a similar vein, such a legacy controller would thus
> be expected to have 0x1f0 in the resource.
> 
> Later, when we fixup (in a head quirk on ppc32 and in pcibios_fixup_bus
> on ppc64, though that's changing wit 2.6.25 to use the same mechanism),
> we see an IO resource, and we fixup by adding to it basically
> (bus_io_virt - _IO_BASE).
> 
> That is, for our device that has a 0x1000 BAR value, we'll do:
> 
> 	resource = 0x1000 + (0xd0010000 - 0xd0000000) = 0x11000
> 
> And for the legacy IDE:
> 
> 	resource = 0x1f0 + (0xd0010000 - 0xd0000000) = 0x101f0
> 
> Now, if you do an inb or outb to one of these, the inb() and oub()
> accessors will add _IO_BASE, which is 0xd0000000 in our example, so
> you'll end up doing accesses to respectively:
> 
> 	access = 0xd0011000 for the example device or
> 	access = 0xd00101f0 for the IDE controller
> 
> That translates via the MMU to
> 
> 	phys = 0xf0001000 for the example device or
> 	phys = 0xf00001f0 for the IDE controller
> 
> Which translates on to the bus into an IO cycle at the raw BAR
> address (which is what is in the BAR content or hard-decoded in the case
> of the legacy IDE):
> 
> 	bus = 0x1000 for the example device
> 	bus = 0x01f0 for the IDE controller
> 
> which ... is what we started with.
> 
> Now I don't understand how MIPS does things differently, but I can't see
> how it can be legal to call pci_resource_to_bus() on 0x1f0 in
> pci_setup_device(), because at this stage, we are putting raw BAR values
> in the struct resource (that is PCI bus addresses) and 0x1f0 _is_ such a
> value.
> 
> Calling pci_resource_to_bus() would somewhat mean that 0x1f0 is not, and
> instead is some kind of already fixed up resource value that we want
> converted back into a BAR value, which is not the case.
> 
> So I suspect your patch works by accident more than by design, or I am
> missing something...

So where do we stand with this?

As I understand the Cobalt system controller it is not possible to address
ioport addresses below 0x10000000 at all on the PCI bus of the GT-64111.
As such I think the best solution is a GT-64111-specific PCI fixup to
clear out legacy resources.  The IDE controller in the VIA VT82C586 could
then be used only by its normal that is non-legacy address and
commit fd6e732186ab522c812ab19c2c5e5befb8ec8115 could be reverted and PPC
would be happy too?

  Ralf
