Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab0CLV7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:59:41 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15153 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0CLV7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:59:39 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.33: pci 0000:00:00.0: address space collision / spontaenous reboots
Date: Fri, 12 Mar 2010 14:59:28 -0700
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <alpine.DEB.2.00.1003120522550.6420@p34.internal.lan> <86802c441003121144y24e763e6n16f237928df1f676@mail.gmail.com> <alpine.DEB.2.00.1003121520120.6929@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003121520120.6929@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201003121459.29793.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 March 2010 01:32:17 pm Justin Piszcz wrote:

> >> Even with all boards removed:
> >> [    0.133537] pci 0000:00:00.0: address space collision: [mem
> >> 0xe0000000-0xffffffff 64bit] already in use
> >>
> >> 00:00.0 Host bridge: ATI Technologies Inc RD790 Northbridge only dual slot
> >> PCI-e_GFX and HT3 K8 part
> >
> > how about current linus' tree with pci=nocrs or pci=use_crs?
> 
> Hi, I saw your second e-mail, so it sounds like a bad board or something
> that Linux does not have a quirk for yet, but in any case, per your
> recommendations:
> 
> pci=nocrs:
> http://home.comcast.net/~jpiszcz/20100312/dmesg-pci-nocrs.txt
> 
> pci=use_crs:
> http://home.comcast.net/~jpiszcz/20100312/dmesg-use-crs.txt
> 
> No collision when pci=use_crs is used, BUT the system still crashes.
> 
> Instead of collision, it says this:
> 
> [    0.133598] PCI: pci_cache_line_size set to 64 bytes
> [    0.133603] pci 0000:00:00.0: BAR 3: reserving [mem 0xe0000000-0xffffffff flags 0x120204] (d=0, p=0)
> [    0.133606] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
> [    0.133610] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]
> [    0.133617] pci 0000:00:11.0: BAR 0: reserving [io  0xff00-0xff07 flags 0x20101] (d=0, p=0)
> 
> [    0.133735] Expanded resource reserved due to conflict with PCI Bus 0000:00

Let's look at some of these messages:

  pci_root PNP0A03:00: host bridge window [mem 0x40000000-0xfed0ffff]

That looks normal to me.  If you could boot a current upstream kernel,
e.g., 2.6.34-rc1, I think it might print more information about your
AMD PCI address space routing.  BTW, it looks like you have four CPUs,
but your kernel is only compiled to support two.

  pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
  pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
  pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]

These are just telling us that the device BAR 0xe0000000-0xffffffff
doesn't fit inside the bridge window of 0x40000000-0xfed0ffff.  I don't
know why the device has that weird-looking BAR, but that by itself
shouldn't be fatal because we don't have any drivers that try to use
that BAR.

  Expanded resource reserved due to conflict with PCI Bus 0000:00

This comes from e820_reserve_resources_late().  I wish it were a
more useful message and showed the actual conflict and what was
expanded, but I don't think it's a problem in itself.

  pnp 00:0a: disabling [mem 0x000f0000-0x000f3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]

We failed to reserve the 0xe0000000-0xffffffff region above, so we just
cleared out the resource.  It keeps the same size, so it ends up at
0x00000000-0x1fffffff, where it appears to conflict with a lot of PNP
devices.  But this isn't a real conflict; it's just Linux being stupid
because we don't handle that PCI resource correctly.

So the messages *look* alarming, but I don't see anything there that
should cause a spontaneous reboot.

Is this a regression?  Did the system ever work reliably with any
Linux kernel?  If not, I'd suspect a hardware problem like bad memory.

Bjorn










