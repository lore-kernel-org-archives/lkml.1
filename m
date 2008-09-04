Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYIDI0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYIDI0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757868AbYIDIXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:23:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757368AbYIDIXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:23:48 -0400
Date: Thu, 4 Sep 2008 01:23:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 3
In-Reply-To: <86802c440809040014w5a6d2921k8c99b3978772e1fb@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0809040102260.3378@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>  <20080903214634.ea17ff53.akpm@linux-foundation.org>  <alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>  <20080903223318.84b6ce8b.akpm@linux-foundation.org>
 <86802c440809040014w5a6d2921k8c99b3978772e1fb@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Yinghai Lu wrote:
> >
> > --- x   2008-09-03 21:38:24.000000000 -0700
> > +++ y   2008-09-03 22:29:04.000000000 -0700
> > ...
> > @@ -503,15 +503,15 @@
> >  calling  init_acpi_pm_clocksource+0x0/0x14a
> >  initcall init_acpi_pm_clocksource+0x0/0x14a returned 0 after 32 msecs
> >  calling  pcibios_assign_resources+0x0/0x70
> > -pci 0000:06:05.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff
> >  pci 0000:06:05.0: CardBus bridge, secondary bus 0000:07
> >  pci 0000:06:05.0:   IO window: 0x002400-0x0024ff
> >  pci 0000:06:05.0:   IO window: 0x002800-0x0028ff
> > -pci 0000:06:05.0:   MEM window: 0x54000000-0x57ffffff
> > +pci 0000:06:05.0:   PREFETCH window: 0x50000000-0x53ffffff
> > +pci 0000:06:05.0:   MEM window: 0x58000000-0x5bffffff
> >  pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
> >  pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
> >  pci 0000:00:1e.0:   MEM window: 0xb0100000-0xb01fffff
> > -pci 0000:00:1e.0:   PREFETCH window: disabled
> > +pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x00000053ffffff
> >  pci 0000:00:1e.0: setting latency timer to 64
> >  pci 0000:06:05.0: power state changed by ACPI to D0
> 
> 06:05.0 is under 00:1e.0

Right. This is the depth-first bus assignment, so what happens is that 
pci_assign_unassigned_resources() does:

        /* Depth first, calculate sizes and alignments of all
           subordinate buses. */
        list_for_each_entry(bus, &pci_root_buses, node) {
                pci_bus_size_bridges(bus);
        }

where pci_bus_size_bridges() does depth-first (and _has_ to, of course, 
since it needs to look at the inner bridges in order to be able to size 
the outer ones!)

And there it will now successfully see that BAR 9 that used to get 
ignored, so now it sizes the PCI bridge that leads _to_ the Cardbus bridge 
with that in mind. So that is why the "BAR 9 too large" message has gone 
away, but that is all that got printed out at the resource _sizing_ stage.

And then, after all the sizing has been done, the odd ordering of the 
printout is because we next do:

        /* Depth last, allocate resources and update the hardware. */
        list_for_each_entry(bus, &pci_root_buses, node) {
                pci_bus_assign_resources(bus); 
                pci_enable_bridges(bus);
        }

and that "Depth last" comment is a bit mis-leading.

It is true that "pci_bus_assign_resources()" will make the actual call to 
"pbus_assign_resources_sorted()" depth-last, but if you look at how it 
then actually writes those assigned resources to the actual bridge 
devices, it will do those "pci_setup_bridge/cardbus()" calls depth-first: 
if you look at pci_bus_assign_resources(), you'll see that it does the 
recursive call for the subordinate bus _before_ it sets up the upper 
bridge.

And since the _printout_ comes when the final setup is done, that means 
that the Cardbus bridge (that is deeper in the resource chain) will print 
out first. So even though the resource was _allocated_ depth-last, it is 
written out depth-first!

> wonder if some pci code change cause that.... doesn't get pref mem assigned.
> 
> can you apply attached patches to get more dump?

It all works fine, and makes sense (well, except for the printout order, 
which is a bit non-obvious, but it all boils down to us wanting to have 
all the inner bridges set up correctly before we "enable" them through the 
outer bridge mapping, so that depth-first makes sense, I think).

			Linus
