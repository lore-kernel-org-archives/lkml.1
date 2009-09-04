Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZIDEhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZIDEhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZIDEhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:37:06 -0400
Received: from foo.birdnet.se ([213.88.146.6]:48201 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752384AbZIDEhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:37:05 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 00:37:05 EDT
Message-ID: <20090904043025.2774.qmail@stuge.se>
Date: Fri, 4 Sep 2009 06:30:25 +0200
From: Peter Stuge <peter@stuge.se>
To: Frans Pop <elendil@planet.nl>,
       Christian =?utf-8?Q?Kr=C3=A4mer?= <christian@kraemer-eu.de>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Mail-Followup-To: Frans Pop <elendil@planet.nl>,
	Christian =?utf-8?Q?Kr=C3=A4mer?= <christian@kraemer-eu.de>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909032007.18484.christian@kraemer-eu.de> <200909032035.10342.elendil@planet.nl> <200909040145.14807.christian@kraemer-eu.de> <200909021856.29565.christian@kraemer-eu.de> <200909021953.02190.elendil@planet.nl> <200909030042.45081.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200909040145.14807.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Frans Pop wrote:
> Summary: WLAN Card (Proxim Orinoco Gold 8470-WD) is not recognized
> by either 2.6.24 or 2.6.30. After inserting it, 'lspci' does not
> list the card, but 'lspci -H1' does.
> Original message with lspci and dmesg output for .24 is at:
> http://lkml.org/lkml/2009/9/2/199

It would help to also see dmesg from .30 or newer, and, say, .9 or
something similarly old.

The issue is that the PCI bridge (which is what a CardBus controller
is) isn't completely configured by the kernel.

Parts of the kernel believe it is ok, which is why lspci says irq 11
for 00:02.0 and 00:02.1, but the value actually configured in the
CardBus controller hardware is 255 = unconfigured.

lspci -H1 -s 2.0 -xxx might be interesting.

The .24 dmesg shows an error initializing the PCI bus:

--8<--
PCI: Probing PCI hardware
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
 [<c0187ceb>] sysfs_add_one+0x54/0xb8
 [<c01888da>] sysfs_create_link+0xaf/0xfd
 [<c02c8020>] pci_bus_add_devices+0xba/0xff
 [<c037ac1d>] pcibios_scan_root+0x25/0x80
 [<c011ab3d>] printk+0x1b/0x1f
 [<c052822f>] pci_legacy_init+0x53/0xe1
 [<c0505769>] kernel_init+0x154/0x2b6
 [<c0102546>] ret_from_fork+0x6/0x20
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0103877>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:02.0: Error creating sysfs bridge symlink, continuing...
-->8--

This is bad, and is either the cause for the problem, or another
symptom.

.24 is a bit old, so it would be interesting to see dmesg from recent
(vanilla) sources.


Christian Krämer wrote:
> > That means that the card should be supported by the ath5k
> > wireless driver if it was correctly initialized by the cardbus
> > drivers.

Frans is right, but the bridge isn't set up right, so cards behind it
will not work correctly either.


> Yes, but on the LiveCD, when I load the module via "modprobe ath5k",
> ifconfig 
> doesn't show any interface except for lo and also dmesg don't
> display anything about a found device. In the gentoo-system I
> installed, I also tried the madwifi-ng driver package, but with the
> same result.

This is expected, until the CardBus PCI bridge starts working.


> > I don't think I can help you any further. Hopefully one of the
> > PCMCIA developers can.

To be clear, this looks like a CardBus/PCI issue. CardBus is more
like PCI and PCMCIA is more like ISA. It could maybe be an ACPI
issue, but first get to the bottom of the pci error.


> I admit I'am not very familiar with the community around the
> linux-kernel and this is my first request on the official mailing
> list.

I hope it'll be resolved, but at this point more information is
needed. Try the latest vanilla kernel. Try combinations of some
kernel parameters:

lapic
pci=biosirq

They will change how the kernel reads and thinks about interrupts.
It's important to have interrupts working right, but at this point it
seems there's a more fundamental PCI problem with the CardBus
bridges. :\


//Peter
