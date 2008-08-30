Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYH3FyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYH3FyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYH3Fx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:53:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYH3Fx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:53:58 -0400
Date: Fri, 29 Aug 2008 22:52:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808292216310.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>  <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>  <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>  <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
  <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>  <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org> <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
> 
> if we don't add the IORESOURCE_BUSY, why bother to add these entries...

You don't understand how the resource allocator works.

IORESOURCE_BUSY is really more of a "legacy bit". It has almost no bearing 
on the actual allocations.

Just grep for IORSOURCE_BUSY in kernel/resource.c. The _only_ thing that 
cares about busy/non-busy is the legact "request_region()" function. That 
one isn't actually used by any core PCI code - it's more of a driver 
issue to claim exclusive ownership of particular resources by inserting a 
marker in that resource.

So IORESOURCE_BUSY is a red herring. The only reason I said you can clear 
it is because you claimed it causes problems, but the more I look at it, 
the more I think you're likely just mistaken - because IORESOURCE_BUSY 
doesn't make any difference at all to normal resource handling until you 
get to actual drivers.

The bigger issue is that just inserting the resource (and it really 
doesn't matter if it is marked busy or not) is in itself a mark of 
"there's something here". THAT is what all the resource code cares about. 
The IORESOURCE_BUSY bit is almost immaterial (ie _is_ immaterial except 
for some very specific cases).

And the reason we need to add the e820 resources is exactly so that we 
don't try to allocate PCI resources on top of some system resources we 
don't even know about!

> good layout from BIOS, it should only reserve mmio range is not showing in BAR.

I agree, but "good layour" and "BIOS" don't really go together. There's 
too many broken BIOSes.

> if one stupid BIOS set
> 0xdc000000 - 0x100000000 for reserved.
> 
> then when in insert that range late

Sure, but really, the only point of even caring about e820 resources in 
the first place has really nothing to do with the BAR's we can see 
(because the kernel can handle _those_ perfectly well on its own), and has 
everything to do with teh fact that a lot of devices have invisible 
resources that we _cannot_ see (ie magic non-standard BAR's for the 
motherboard chips).

And those are exactly why we want to populate the resource map with the 
e820 information - to avoid having dynamic resources (like Cardbus or PCI 
hotplug, or just devices that weren't set up statically by the BIOS) be 
then allocated by the kernel on top of those "invisible" resources.

And the dynamic code actually doesn't care about IORESOURCE_BUSY at all: 
it will avoid _any_ resource it can see. Think about it: it has to - since 
existing PCI resources we have set up will _not_ have that IORESOURCE_BUSY 
set.

In many ways, IORESOURCE_BUSY is pure legacy stuff, and is meant for "this 
is a black hole and you must not look into it at all". It originates with 
a need to originally having to lock drivers away from other drives by 
marking their resources busy - in an ISA world, where there are no other 
ways of saying "I own this device".

(Yeah, yeah, PCI drivers do the same thing too - they mark their BAR's by 
inserting a per-driver entry in the BAR to say 'I own this resource').

But this is where adding the e820 resources _after_ doing PCI discovery 
comes in. We don't want to clash with PCI discovery per se - we just want 
to make sure that later allocations don't allocate over anything that we 
either saw earlier (the BAR's we found set up in regular PCI discovery) 
_or_ anything that the system has said is reserved (e820 reserved 
entries).

Doing it before obviously works too - in fact, it has worked for us for 
years. But it does mean that we consider the e820 reserved areas _so_ 
reserved that we don't allow PCI BAR's in them. Which is apparently a 
mistake.

We want to consider them so reserved that we don't add _new_ PCI resources 
to them (and perhaps we might even want to stop regular PCI drivers from 
attaching to them), but not so exclusive that we don't allow BARs that 
have been set up by the BIOS in them.

			Linus
