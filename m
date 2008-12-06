Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYLFNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYLFNtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 08:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYLFNtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 08:49:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbYLFNtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 08:49:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [patch,rfc] usb: restore config before enabling device on resume
Date: Sat, 6 Dec 2008 14:48:30 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org> <200812061020.19546.elendil@planet.nl>
In-Reply-To: <200812061020.19546.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061448.31468.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Frans Pop wrote:
> On Thursday 04 December 2008, Linus Torvalds wrote:
> > Greg, Jesse, can you think about and look at the USB PCI resume
> > ordering?
> [...]
> > In many ways the bigger worry is actually in the totally unrelated USB
> > UHCI and EHCI drivers that resume _before_ the bridge does:
> >
> > 	uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
> > 	uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> > 	uhci_hcd 0000:00:1d.2: setting latency timer to 64
> > 	uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
> >	uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
> >	usb usb7: root hub lost power or was reset
> > 	ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
> > 	ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> > 	ehci_hcd 0000:00:1d.7: setting latency timer to 64
> > 	ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> >	ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
> >
> > and the worry I have here is that we actually enable the device
> > _before_ we've restored the BAR information. That sounds very iffy. It
> > sounds doubly iffy in the 'resume from hibernate' case, where we are
> > going to have an already-set-up PCI bus and the config space values are
> > going to all be live as we reprogram them.
> >
> > That "restoring config space at offset 0x8" thing is where we restore
> > the BAR (dword 0x8 = offset 0x20 = PCI_BASE_ADDRESS_4), and we're
> > changing it from 0x1 to 0x2101, with the IO BAR enabled. In this case,
> > the old value meant that the BAR started out disabled, but hibernate
> > would have been different.
> >
> > So I'd _much_ rather have seen the sequence have the BAR restore
> > sequence be something like
> >
> > 	uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
> >	uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
> >	uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
> > 	uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> > 	uhci_hcd 0000:00:1d.2: setting latency timer to 64
> >
> > instead. Possibly even with an explicit disable of the
> > memory/IO/busmaster bits before the whole sequence.
> 
> I've taken a very naive look at this, basically by comparing what usb
> (usb/core/hcd-pci.c) is doing compared to other drivers.
> 
> I used the following command to get an overview:
> $ git grep -E -n -C5 "pci_(enable_device|set_master|restore_state|power_state.*D0)"
> (The line numbers give some indication whether work is split over functions.)
> 
> Most drivers seem to do some variation of the following, which looks
> logical and is in line with Documentation/power/pci.txt:
> pci_set_power_state(dev, PCI_D0);
> pci_restore_state(dev);
> pci_enable_device(dev);
> pci_set_master(dev);
> 
> But quite a lot of drivers (including usb and e.g. ide/setup-pci.c) do
> something like:
> pci_enable_device(dev);
> pci_set_master(dev);
> pci_restore_state(dev);
> 
> Maybe the whole tree should get a review for this?

I think so.

> Anyway, I gave the patch below a try on both my notebook and desktop.
> My desktop has USB keyboard and mouse and the notebook has wireless and
> a fingerprint scanner on USB. Everything still worked after resume.
> 
> Diff of the resume dmesg of my motebook attached. Looks better I think?

Yes, to me it does.

In fact, I think you could even move the pci_restore_state(dev) into
usb_hcd_pci_resume_early() that would be executed with interrupts off and
drop the pci_set_power_state(dev, PCI_D0); entirely (the
pci_enable_device(dev); would invoke it anyway).

Thanks,
Rafael


PS
Please append patches instead of attaching them, they are a lot easier to
discuss this way.
