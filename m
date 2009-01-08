Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbZAHU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbZAHU0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZAHU0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:26:41 -0500
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:54963 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750873AbZAHU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:26:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=lgwRyOLpSF8NLopfnmGfjWHkg9/JvIZoZSScoMO0p0ihfWAfIoob4i90hWKaoFtgvd1Z6h8rE2FBZU3uq7G10xmzs3C4GErClnuh1WcmuLNqQuawUsX//VBmN2mCjgPV;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Can't allocate resources for PCI video card behind bridge
Date: Thu, 8 Jan 2009 12:26:38 -0800
User-Agent: KMail/1.9.10
Cc: Connor Behan <connor.behan@gmail.com>, linux-kernel@vger.kernel.org,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl>
In-Reply-To: <200901082057.00170.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081226.38909.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 8, 2009 11:56 am Rafael J. Wysocki wrote:
> Cc-ing linux-pci and Jesse.
>
> On Thursday 08 January 2009, Connor Behan wrote:
> > Hello, I am trying to use two video cards. One is the built in ATI Rage
> > Mobility M3 AGP card which drives the screen of my laptop (Thinkpad a22m
> > 2628-S1U if that matters), the other is the ATI Radeon X1550 PCI card in
> > the Thinkpad Dock II which is supposed to drive an external monitor.
> > X1550 is a PCI-E chipset but my card is a PCI card with an onboard PCI
> > to PCI-E bridge. I first tried this with kernel 2.6.27 as packaged by
> > Archlinux and got the following startup errors:
> >
> > pci 0000:00:04.0: BAR 7: can't allocate resource
> > pci 0000:00:04.0: BAR 8: can't allocate resource
> > pci 0000:00:04.0: BAR 9: can't allocate resource
> >
> > I've seen this problem discussed in the archives and couldn't find what
> > looked like a fix. I WAS able to fix this by loading dock, pci_slot,
> > pci_hotplug and acpiphp and appending pci=assign-busses. However since
> > then I have run a package update to kernel 2.6.27.10 and I am once again
> > getting the same problem even with the same modules and parameters. I
> > have since tried appending irqpoll, pci=bios, pci=routeirq and acpi=off
> > with no success. I have even rolled back my kernel to 2.6.27 (and the
> > headers and a few other packages) setup my system the way it was setup
> > before to the best of my knowledge but I still can't get the PCI card
> > working again. Another subtle change must be responsible.
> >
> > Certain PCI devices in the dock are working such as the Cardbus slots...
> > but I could care less about them... is there a way I could tell the
> > kernel to prioritize the video card and sacrifice Cardbus slots first if
> > it can't allocate enough resources? Also my lspci output shows a large
> > gap 01:00.0 to 06:00.0 so some part of my system must have expected
> > other devices in that range. When I had the video card working it was
> > 02:00.0. I have tried changing the four IRQ numbers in the BIOS but this
> > is pointless at best and sometimes causes my soundcard to be disabled.
> > My dmesg, lspci and (trimmed) kernel config are pasted:
> >
> > dmesg: http://pastebin.com/f3ae15a58
> > lspci: http://pastebin.com/f5d7dee6e
> > .config: http://pastebin.com/fb925760
> >
> > I'm hoping for a solution that doesn't require recompiling the kernel
> > but I definitely would if that's necessary. In any event I'll be much
> > more vigilant about system updates if I get this working again.
> > Thank-you very much for your time.

Can you post the output of lspci -vvv somewhere as well after trying 2.6.28?  
It may be that we want the "don't allocate resources for transparent bridges" 
patch after all:

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index ea979f2..586451c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -467,8 +467,12 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
                }
        }
 
-       /* The root bus? */
-       if (!bus->self)
+       /*
+        * We don't need to allocate PCI bridging windows
+        * for a root bus (everything bridged) or for a
+        * transparent one.
+        */
+       if (!bus->self || bus->self->transparent)
                return;
 
        switch (bus->self->class >> 8) {


Since in your case it looks like it's incorrectly causing some of your other 
resources to be disabled:

pnp 00:02: io resource (0x22-0x22) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), 
disabling
pnp 00:02: io resource (0x92-0x92) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), 
disabling
pnp 00:02: io resource (0xb2-0xb3) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), 
disabling
pnp 00:0a: io resource (0x2e-0x2f) overlaps 0000:00:04.0 BAR 7 (0x0-0xfff), 
disabling

Sorry but you might have to build a few kernels to help us fix this one. :)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
