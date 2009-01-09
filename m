Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZAIWdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZAIWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbZAIWd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:33:29 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41958 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbZAIWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:33:28 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Can't allocate resources for PCI video card behind bridge
Date: Fri, 9 Jan 2009 15:30:57 -0700
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Connor Behan <connor.behan@gmail.com>,
       linux-kernel@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl> <200901081226.38909.jbarnes@virtuousgeek.org>
In-Reply-To: <200901081226.38909.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091530.58694.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009 01:26:38 pm Jesse Barnes wrote:
> > On Thursday 08 January 2009, Connor Behan wrote:
> > > Hello, I am trying to use two video cards. One is the built in ATI Rage
> > > Mobility M3 AGP card which drives the screen of my laptop (Thinkpad a22m
> > > 2628-S1U if that matters), the other is the ATI Radeon X1550 PCI card in
> > > the Thinkpad Dock II which is supposed to drive an external monitor.
> > > X1550 is a PCI-E chipset but my card is a PCI card with an onboard PCI
> > > to PCI-E bridge. I first tried this with kernel 2.6.27 as packaged by
> > > Archlinux and got the following startup errors:
> > >
> > > pci 0000:00:04.0: BAR 7: can't allocate resource
> > > pci 0000:00:04.0: BAR 8: can't allocate resource
> > > pci 0000:00:04.0: BAR 9: can't allocate resource

The 00:04.0 bridge starts out with relatively small windows.  From
http://pastebin.com/f3ae15a58:

  181. pci 0000:00:04.0: transparent bridge
  182. PCI: bridge 0000:00:04.0 io port: [0, fff]            ("BAR 7")
  183. PCI: bridge 0000:00:04.0 32bit mmio: [0, fffff]       ("BAR 8")
  184. PCI: bridge 0000:00:04.0 32bit mmio pref: [0, fffff]  ("BAR 9")

but by here:

  285. pci 0000:00:04.0: PCI bridge, secondary bus 0000:0a
  286. pci 0000:00:04.0:   IO window: 0x4000-0x4fff
  287. pci 0000:00:04.0:   MEM window: 0x40000000-0x47ffffff
  288. pci 0000:00:04.0:   PREFETCH window: 0x00000048000000-0x0000004fffffff

the windows have been assigned and the MEM and PREFETCH ones enlarged.
I don't know enough to reconcile this with the "can't allocate resource"
messages, which happen in between, at line 247.

> > > ... Also my lspci output shows a large
> > > gap 01:00.0 to 06:00.0 so some part of my system must have expected
> > > other devices in that range. When I had the video card working it was
> > > 02:00.0.

Here's how I interpret your lspci at http://pastebin.com/f126dc794;
see if it makes sense to you:

Bus 00 has a bunch of devices that are built into the laptop.
Bus 01 has your built-in VGA below the AGP bridge at 00:01.0.
Buses 02-05 are for a laptop CardBus slot below the bridge at 00:02.0.
Buses 06-09 are for a laptop CardBus slot below the bridge at 00:02.1.
Buses 0a-12 are for things below the docking bridge at 00:04.0.
  Buses 0b-0e are for a Dock II CardBus slot below the bridge at 0a:02.0.
  Buses 0f-12 are for a Dock II CardBus slot below the bridge at 0a:02.1.

I don't see your plug-in X1550 card.  If it were there, I suppose the
PCI to PCI-E bridge would be on bus 0a, with the actual video device
on some secondary bus like 13?

> It may be that we want the "don't allocate resources for transparent bridges" 
> patch after all:
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index ea979f2..586451c 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -467,8 +467,12 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
>                 }
>         }
>  
> -       /* The root bus? */
> -       if (!bus->self)
> +       /*
> +        * We don't need to allocate PCI bridging windows
> +        * for a root bus (everything bridged) or for a
> +        * transparent one.
> +        */
> +       if (!bus->self || bus->self->transparent)
>                 return;

I don't understand this transparent bridge stuff very well, but it's
common for a bridge to support both positive and subtractive decode.
In that case, don't we still want to allocate resources for the
positive decode windows?

> Since in your case it looks like it's incorrectly causing some of your other 
> resources to be disabled:
> 
> pnp 00:02: io resource (0x22-0x22) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), disabling
> pnp 00:02: io resource (0x92-0x92) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), disabling
> pnp 00:02: io resource (0xb2-0xb3) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), disabling
> pnp 00:0a: io resource (0x2e-0x2f) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), disabling

I don't think this would cause the 00:04.0 resource allocation
failures, but it seems wrong.  It looks like another case of the
PCI BARs just not being initialized.  The PNP resources look fine,
and we shouldn't disable them in this case.

Bjorn
