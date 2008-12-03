Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYLCAmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYLCAmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYLCAmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:42:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233AbYLCAmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:42:07 -0500
Date: Tue, 2 Dec 2008 16:41:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812030100.18400.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812021608520.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812022338.51284.rjw@sisk.pl> <alpine.LFD.2.00.0812021518160.3256@nehalem.linux-foundation.org> <200812030100.18400.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> 
> Hm, what about (from the copy of /proc/iomem without the patch at
> http://www.sisk.pl/kernel/debug/mainline/2.6.28-rc7/rc7-nopatch/iomem):
> 
> 88000000-8bffffff : PCI Bus 0000:03
>   88000000-8bffffff : PCI CardBus 0000:04
> 8c000000-91ffffff : PCI Bus 0000:03
>   8c000000-8fffffff : PCI CardBus 0000:04
> 
> (1) Why two ranges are allocated for 0000:03 without the patch while there is
>     only one range with the patch:
> 
> 88000000-880fffff : PCI Bus 0000:03

So look at the lspci information that has more details for info on this.

Basically, a Cardbus controller (as well as a PCI bridge) has _two_ very 
different MMIO windows - one for prefetchable MMIO, and one for 
non-prefetchable.

And the windows should match up, although it's always ok to map a 
prefetchable region in a non-prefetchable window (although you may lose 
some performance, since the upstream will now not be able to prefetch).

And it's not really different, exactly because 00:1e.0 is a transparent 
bridge. That "transparency" means that there is an implied decoding window 
DESPITE a lack of an explicit one - it may just be a few PCI cycles slower 
(or not, depending on how the bridge is implemented. It's probably 
technically quite ok for a transparent bridge to ignore its IO/MEM window 
contents entirely).

So those "PCI Bus 0000:03" windows are technically irrelevant, except as a 
possible performance improvement. The bridge will forward PCI cycles 
whether they are there or not. That is what "transparent" means.

> (2) Why are they so large without the patch while with the patch they are much
>     smaller (O(2^28) vs O(2^21) if I'm not mistaken)?

Because without the patch, we'll size the PCI bridge windows according to 
the default setup of the CardBus controller, namely:

 - two IO regions of size 'pci_cardbus_io_size' (256 bytes)

 - one prefetchable and one non-prefetchable IO region of size 
   'pci_cardbus_mem_size' (64MB by default, you can change it with 
   the 'pci=cbmemsize=xyz' kernel command line parameter but nobody ever 
   does)

See pci_bus_size_cardbus() in drivers/pci/setup-bus.c for details.

HOWEVER - when the alignment is wrong, we skip all that, and don't set up 
the CardBus regions there at all, because the whole "pbus_size_mem()" 
thing will just give up.

And then what happens is that we won't set up the CardBus bridge during 
PCI bus setup AT ALL, but later, by the Yenta code. And that one will try 
to do something else entirely.

[ And yes, if you think that it might be a good idea to try to share the 
  code and not have two different cardbus sizing logics, I'm not going to 
  argue against that AT ALL! ]

In the yenta code, we don't try to to just have a fixed maximum size, 
because that code is literally designed to be a fallback case for when the 
PCI sizing fails (ie literally "oops, we had so little space that we 
couldn't use the default max size!" case).

For the yenta code, see drivers/pcmcia/yenta_socket.c ("Yenta" is just the 
name for the CardBus standard programming model), and notice all the logic 
there, see:

 - BRIDGE_MEM_MAX/ACC/MIN and BRIDGE_IO_MAX/ACC/MIN for "max", 
   "acceptable" and "minimum" values respectively.

   Realize thatt he "MAX" value is just 4MB, which is obviously smaller 
   than the 64MB mentioned above, and that's exactly because this is 
   assumed to be a "uhhuh, we ran out of space" case.

 - See yenta_allocate_res() and the helper functions above it that in 
   addition try to shrink the window further if it doesn't fit.

 - Notice how the Yenta code - unlike the generic PCI code - does _not_ 
   try to allocate parent PCI bridge memory window resources, so if we 
   fall into this case, we're going to depend on previously set up windows 
   and/or the fact that a transparent bridge doesn't need them.

So this explains why in one case you'd see a 64M resource, and in another 
just a 4M resource.

_Most_ cardbus cards by far only need a few kB of IOMEM resources, but 
there are some crazy people who do CardBus graphics cards and/or video 
capture cards, and they really do want 32MB+ of MMIO, which is why we try 
to get such a big CardBus MMIO window by default.

As mentioned, you could try to just use

	pci=cbmemsize=4M

on the kernel command line, and see if that also hides the bug. It's 
entirely possible that your suspend/resume problem is not so much about 
the cardbus allocation itself, as about some other memory area that wants 
to use it (eg hidden RAM used by the bios SMM code, whatever).

> (3) Why are they overlapping with the ranges for CardBus 0000:04, although
>     without the patch they aren't?  Is that actually correct at all?

See the earlier explanation of the topology, and realize the 
overlappingness is actually _required_ in order for a PCI bridge to work, 
and forward the PCI cycles to the right lower bus.

But then, with a transparent bridge, if nobody else overlaps, it will 
do what's called "negative decode", which just means that "if nobody else 
said they wanted this PCI cycle, I'll decode it and forward it to the 
lower bus", so a transparent bridge doesn't _need_ the overlap.

Do

	/sbin/lspci -t

to understand the relationship, in particular see how device 0:1e.0 is the 
one that bridges _to_ that CardBus controller.

See the comments about "topology" in my previous email.

> > So in many ways, the debug patch that gets the alignment wrong (on 
> > purpose) is really the inferior one. Plain -rc7 seems to do everything 
> > right.
> 
> Well, I'm not sure ...

I'm pretty sure. 

The fact that you then have hibernation issues is almost certainly due to 
something else. Most likely something else that we don't know about from a 
resource angle that now got "hidden" by the fact that we programmed the 
0:1e.0 bridge to forward to the cardbus controller rather than to some 
insane power management chip.

It's why we have all those quirks in drivers/pci/quirks.c. It's very 
possible that your chipset is missing some quirk.

> > So are you saying that the unpatched kernel still reliably doesn't 
> > hibernate for you, while the (arguably _incorrect_) patched kernel 
> > reliably does hibernate?
> 
> Yes, I am.

So see what happens if you add

	pci=cbmemsize=4M

to make the cardbus allocations smaller. Perhaps that will just change the 
allocations enough that now it doesn't cover something else.

Oh, and please do a "lspci -vvxxx" (as root) too so that I can see the 
actual values in your PCI config space. We have two quirks already 
triggering for you:

  pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH6 ACPI/GPIO/TCO
  pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH6 GPIO

but I'm maybe there's another one missing.

		Linus
