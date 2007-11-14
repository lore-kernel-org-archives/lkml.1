Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXKNBhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXKNBhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXKNBhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:37:37 -0500
Received: from palrel12.hp.com ([156.153.255.237]:60201 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757834AbXKNBhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:37:35 -0500
Date: Tue, 13 Nov 2007 18:37:32 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071114013732.GB31301@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113201102.GK17785@parisc-linux.org> <20071113230804.GA14570@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113230804.GA14570@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

* Gary Hade <garyhade@us.ibm.com>:
> On Tue, Nov 13, 2007 at 01:11:02PM -0700, Matthew Wilcox wrote:
> > On Tue, Nov 13, 2007 at 10:51:22AM -0800, Greg KH wrote:
> > > Ok, again, I want to see the IBM people sign off on this, after testing
> > > on all of their machines, before I'll consider this, as I know the IBM
> > > acpi tables are "odd".
> > 
> > That seems a little higher standard than patches are normally held to.
> > How about the patches get sent to the appropriate people at IBM (who are
> > they?) 
> 
> I be one of them. :)  I have been involved in many (but not all)
> of IBM's x86 based (IBM System x) servers with hotplug capable
> PCI slots.  I have mostly worked on 'acpiphp' associated issues.

Thanks for testing the series. It's much appreciated.

> Have you possibly considered a kernel option as a kinder and
> gentler way of introducing the changes?

That is a good idea. I will work on that.

> ====
> IBM x3850
> Slots 1-2: PCI-X under PCI root bridges
> Slots 3-6: PCIe under transparent P2P bridges
> Slot 1: PCI-X - populated
> Slot 2: PCI-X - !populated
> Slot 3: PCIe -  populated
> Slot 4: PCIe -  !populated
> Slot 5: PCIe -  !populated
> Slot 6: PCIe -  populated
> 
> result is with 2.6.24-rc2 plus all 4 proposed patches

Silly question, but I have to ask. :)

I sent out 5 patches -- is this simply a typo on your part, or
did you only apply 4/5 patches?

> problem: acpiphp failed to register empty PCIe slots 4 and 5

Ok, so acpiphp wasn't going to register those slots anyway, since
they are empty. It would have bailed out after not seeing _ADR or
_EJ0 on those slots.

The acpi-pci-slot driver created those slots anyway, which is one
of the points of the patch -- to create sysfs entries even for
empty slots.

> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:0f:00.0

This is the real address of slot 4.

> acpiphp_glue: found ACPI PCI Hotplug slot 4 at PCI 0000:10:00
> acpiphp: pci_hp_register failed with error -17
> acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)
[repeated 7x]

We saw this message 8x, once for each SxFy object under your p2p
bridge. I actually somewhat did expect to see this error message
(hence the RFC part of my patch ;)

I currently don't have a good way to determine if we've already
seen an empty slot under a p2p bridge, so we try to register
every SxFy object. Of course, a /sys/bus/pci/slots/4/ entry
already exists, so that's why we're getting -17 (-EEXIST).

> acpiphp_glue: found PCI-to-PCI bridge at PCI 0000:14:00.0
> acpiphp_glue: found ACPI PCI Hotplug slot 5 at PCI 0000:15:00
> acpiphp: pci_hp_register failed with error -17
> acpiphp_glue: acpiphp_register_hotplug_slot failed(err code = 0xffffffef)

Same explanation as above.

> # find /sys/bus/pci/slots
> /sys/bus/pci/slots

[snip]

> /sys/bus/pci/slots/4
> /sys/bus/pci/slots/4/address
> /sys/bus/pci/slots/5
> /sys/bus/pci/slots/5/address

Arguably, the right thing happened here. We got entries for empty
slots, and we know their addresses.

If anyone can clue me in on a better way to implement patch 4/5
in my series so that we're not seeing those multiple attempts to
register slots under p2p bridges, I'd love to hear your ideas.

Thanks again for testing.

/ac

