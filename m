Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYGVLt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYGVLt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYGVLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:49:47 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52309 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYGVLtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:49:46 -0400
Date: Tue, 22 Jul 2008 05:49:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: eran liberty <eran.liberty@gmail.com>
Cc: Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
Message-ID: <20080722114929.GA7337@parisc-linux.org>
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:21:06AM +0300, eran liberty wrote:
> > I think this is your real problem, that you're rescanning the entire
> > bus.  I don't think that's the route we'd recommend taking.
> 
> My stating point was that I have loaded a new design into a
> programmable device which sits on the pci device. The new design can
> implement numerous pci devices or non at all. I can think of an easy
> way (or clean one) to scan only the programmable device. Scanning the
> whole bus seemed reasonable.

That's what pci_scan_slot() is for.  It scans the first function at the
device number, then (if the header indicates it's a multifunction
device) scans the other functions associated with that device.  eg you
could call pci_scan_slot(bus, 0x30) and it will create function 06.0
(and potentially 06.1, 06.2, ...)

You presumably already have the devfn for the existing device since
you're able to call pci_remove_bus_device().

> > Why don't you call pci_scan_slot() instead?  You won't get the benefit of
> > pcibios_fixup_bus(), but I'm not convinced that's safe to call on a bus
> > that's already been scanned.
> 
> As said its not exactly a slot its more like a regular pci device that
> someone suddenly welded into the pci bus. Its not a hotplug as well,
> and I do not want to give up on the pcibios_fixup_bus()

Why not?  What architecture are you using?  What does
pcibios_fixup_bus() do for you?

(as a side-note, I'd like to reimplement the pcibios_fixup_*() routines;
I think a lot of what they do can be done more generically these days.
It'll take a while and isn't high on my priority list).

> As it is, with my patch applied i successfully go over the bus and
> remove my own devices before I reprogram the
> programmable device.
> 
> while ((dev = pci_get_device(PCI_VENDOR_ID_MYCOMP,PCI_DEVICE_ID_MYDEV,NULL))
> != NULL) {
> 	pci_remove_bus_device(dev);
> 	pci_dev_put(dev);
> }
> 
> Load a new design into it.
> 
> Then scan the entire bus and add the newly discovered devices.
> 
> bus = null;
> while ((bus = pci_find_next_bus(bus)) != NULL) {
> 	pci_scan_child_bus(bus);
> 	pci_bus_assign_resources(bus);
> 	pci_bus_add_devices(bus);
> }
> 
> As seen here, this sequence of instructions seems very intuitive. It
> will fail without the patch upon pci_bus_add_devices().

Seems utterly unintuitive to me.  You're doing a lot of unnecessary work
here, and if you have two cards in your machine, you'll take away both
of them when you reload either of them.

What you should do is cache the pci_bus and the devfn at startup:

static struct pci_bus *my_bus;
static int my_devfn;

	struct pci_dev *dev = pci_get_device(PCI_VENDOR_ID_MYCOMP,
					PCI_DEVICE_ID_MYDEV, NULL);
	if (!dev)
		return -ENODEV;
	my_bus = dev->bus;
	my_devfn = dev->devfn;
	pci_dev_put(dev);

when you want to remove it:

	for (func = 0; func < 8; func++)
		struct pci_dev *dev = pci_get_slot(my_bus, my_devfn + func);
		if (!dev)
			continue;
		pci_remove_bus_device(dev);
		pci_dev_put(dev);
	}

when you want to rescan it:

	pci_scan_slot(my_bus, my_devfn);

(this only handles one programmable card.  The basic idea could be
extended to handle multiple cards if you need to do that).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
