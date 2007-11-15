Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbXKOAlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbXKOAlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbXKOAku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:40:50 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54427 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbXKOAkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:40:47 -0500
Date: Wed, 14 Nov 2007 16:40:39 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071115004039.GC6269@us.ibm.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113201102.GK17785@parisc-linux.org> <20071113230804.GA14570@us.ibm.com> <20071114013732.GB31301@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114013732.GB31301@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 06:37:32PM -0700, Alex Chiang wrote:
> Hi Gary,
> 
> * Gary Hade <garyhade@us.ibm.com>:
> > On Tue, Nov 13, 2007 at 01:11:02PM -0700, Matthew Wilcox wrote:
> > > On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> > > > Ok, again, I want to see the IBM people sign off on this, after testing
> > > > on all of their machines, before I'll consider this, as I know the IBM
> > > > acpi tables are "odd".
> > > 
> > > That seems a little higher standard than patches are normally held to.
> > > How about the patches get sent to the appropriate people at IBM (who are
> > > they?) 
> > 
> > I be one of them. :)  I have been involved in many (but not all)
> > of IBM's x86 based (IBM System x) servers with hotplug capable
> > PCI slots.  I have mostly worked on 'acpiphp' associated issues.
> 
> Thanks for testing the series. It's much appreciated.
> 
> > Have you possibly considered a kernel option as a kinder and
> > gentler way of introducing the changes?
> 
> That is a good idea. I will work on that.

Thanks.  This will allow everyone to focus on the systems where
the changes are most beneficial and not waste a bunch of time
trying to test everywhere.

> 
> > ====
> > IBM x3850
> > Slots 1-2: PCI-X under PCI root bridges
> > Slots 3-6: PCIe under transparent P2P bridges
> > Slot 1: PCI-X - populated
> > Slot 2: PCI-X - !populated
> > Slot 3: PCIe -  populated
> > Slot 4: PCIe -  !populated
> > Slot 5: PCIe -  !populated
> > Slot 6: PCIe -  populated
> > 
> > result is with 2.6.24-rc2 plus all 4 proposed patches
> 
> Silly question, but I have to ask. :)

Hey, this isn't a silly question. :)

> 
> I sent out 5 patches -- is this simply a typo on your part, or
> did you only apply 4/5 patches?

Yes, it is just a typo.  I did apply all 5 patches.

> 
> > problem: acpiphp failed to register empty PCIe slots 4 and 5
> 
> Ok, so acpiphp wasn't going to register those slots anyway, since
> they are empty.

No, acpiphp should (and did before your changes) register all 
hotplug capable slots.  All 6 slots (2 PCI-X, 4 PCIe) in that
system are hotplug capable.  Emptyness shouldn't matter.  If
the empty slots are not registered it is not be possible to
successfully hotplug cards to them.

Without your changes acpiphp loads with the following output.
  acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
  acpiphp: Slot [1] registered
  acpiphp: Slot [2] registered
  acpiphp: Slot [3] registered
  acpiphp: Slot [4] registered
  acpiphp: Slot [5] registered
  acpiphp: Slot [6] registered

With your changes I confirmed that an attempted hotplug
to a boot-time vacant PCIe slot failed as expected.  The
driver saw the insertion event but didn't find anything
to enable:
acpiphp_glue: handle_hotplug_event_bridge: Bus check notify on \_SB_.VP05.CALG
acpiphp_glue: handle_hotplug_event_bridge: re-enumerating slots under \_SB_.VP05.CALG
acpiphp_glue: acpiphp_check_bridge: 0 enabled, 0 disabled

> It would have bailed out after not seeing _ADR or
> _EJ0 on those slots.

Well, both _ADR and _EJ0 exist for each of the 4 PCIe slots.

> 
> The acpi-pci-slot driver created those slots anyway, which is one
> of the points of the patch -- to create sysfs entries even for
> empty slots.
> 
> > acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:0f:00.0
> 
> This is the real address of slot 4.

No, the P2P parent bus is 0000:0f and the P2P child bus is
0000:10 so I believe the real address for slot 4 should be
0000:10:00.

kernel without your changes after loading acpiphp:
  # cat /sys/bus/pci/slots/4/address
  0000:10:00

kernel with your changes both before and after loading acpiphp:
  # cat /sys/bus/pci/slots/4/address
  0000:0f:00

> 
> > acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
> > acpiphp: pci_hp_register failed with error -17
> > acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
> [repeated 7x]
> 
> We saw this message 8x, once for each SxFy object under your p2p
> bridge. I actually somewhat did expect to see this error message
> (hence the RFC part of my patch ;)
> 
> I currently don't have a good way to determine if we've already
> seen an empty slot under a p2p bridge, so we try to register
> every SxFy object. Of course, a /sys/bus/pci/slots/4/ entry
> already exists, so that's why we're getting -17 (-EEXIST).

Of course, this kind of confusing noise would not be acceptable
in the final version of your changes.

> 
> > acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:14:00.0
> > acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
> > acpiphp: pci_hp_register failed with error -17
> > acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
> 
> Same explanation as above.
> 
> > # find /sys/bus/pci/slots
> > /sys/bus/pci/slots
> 
> [snip]
> 
> > /sys/bus/pci/slots/4
> > /sys/bus/pci/slots/4/address
> > /sys/bus/pci/slots/5
> > /sys/bus/pci/slots/5/address
> 
> Arguably, the right thing happened here. We got entries for empty
> slots, and we know their addresses.

No, the wrong thing happened here.  I expect the slot directories
for the empty slots to look the same as they did before your changes.
This is what the slot directories for empty slots look like without 
your changes.
  # find /sys/bus/pci/slots/[45]
  /sys/bus/pci/slots/4
  /sys/bus/pci/slots/4/power
  /sys/bus/pci/slots/4/attention
  /sys/bus/pci/slots/4/latch
  /sys/bus/pci/slots/4/adapter
  /sys/bus/pci/slots/4/address
  /sys/bus/pci/slots/5
  /sys/bus/pci/slots/5/power
  /sys/bus/pci/slots/5/attention
  /sys/bus/pci/slots/5/latch
  /sys/bus/pci/slots/5/adapter
  /sys/bus/pci/slots/5/address

Note that with your changes the slot directories for the PCI-X
slots (slot 1 populated, slot 2 empty) look fine.
  # find /sys/bus/pci/slots/[12]
  /sys/bus/pci/slots/1
  /sys/bus/pci/slots/1/address
  /sys/bus/pci/slots/1/power
  /sys/bus/pci/slots/1/attention
  /sys/bus/pci/slots/1/latch
  /sys/bus/pci/slots/1/adapter
  /sys/bus/pci/slots/2
  /sys/bus/pci/slots/2/address
  /sys/bus/pci/slots/2/power
  /sys/bus/pci/slots/2/attention
  /sys/bus/pci/slots/2/latch
  /sys/bus/pci/slots/2/adapter

> 
> If anyone can clue me in on a better way to implement patch 4/5
> in my series so that we're not seeing those multiple attempts to
> register slots under p2p bridges, I'd love to hear your ideas.

At first I thought you were talking about the acpiphp
register failure messages that I reported here.  Since the
new functions added with patch 4/5 are not visited when acpiphp
loads you must be talking about the ACPI complaints during boot
(see below) which are mentioned in the comment you included
in your patch.  I don't have any ideas right now.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F1 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F2 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F3 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F4 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F5 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F6 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device S1F7 [20070126]
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F1 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F2 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F3 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F4 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F5 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F6 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E3F7 [20070126]
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E6F2 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E6F3 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E6F4 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E6F5 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E6F6 [20070126]
ACPI Exception (pci_bind-0086): AE_NOT_FOUND, Invalid ACPI-PCI context for device E6F7 [20070126]
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
ACPI: Invalid ACPI Bus context for device <NULL>
