Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbYH3RlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbYH3RlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYH3RlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:41:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYH3RlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:41:12 -0400
Date: Sat, 30 Aug 2008 10:39:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <200808300030.32905.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808292157.24179.rjw@sisk.pl> <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org> <200808300030.32905.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Rafael J. Wysocki wrote:
> 
> > And if you have the whole dmesg, that would be useful.
> 
> dmesg from -rc5 with the offending commit reverted and with the patch
> below applied is at:
> 
> http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/2.6.27-rc5-git.log

Ok, the more I look at this, the more interesting it gets.

In particular, this:

	...
	ACPI: bus type pnp registered
	pnp 00:08: mem resource (0xfec00000-0xfec00fff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
	pnp 00:08: mem resource (0xfee00000-0xfee00fff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
	pnp 00:09: mem resource (0xffb80000-0xffbfffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
	pnp 00:09: mem resource (0xfff00000-0xffffffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
	pnp 00:0b: mem resource (0xe0000000-0xefffffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
	pnp 00:0c: mem resource (0xfec00000-0xffffffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
	pnp: PnP ACPI: found 13 devices
	ACPI: ACPI bus type pnp unregistered
	SCSI subsystem initialized
	libata version 3.00 loaded.
	usbcore: registered new interface driver usbfs
	usbcore: registered new interface driver hub
	usbcore: registered new device driver usb
	PCI: Using ACPI for IRQ routing
	pci 0000:00:00.0: BAR 3: can't allocate resource
	...

there's a few things to note here:

 - the resource at 0000:00:00.0 BAR 3 is totally bogus.

   We know it's totally bogus because you actually have other resources in 
   the 0xf....... range, and they work fine. It's also likely to be 
   totally bogus because it so happens that the end-point of 0xffffffff is 
   commonly something that the BIOS leaves as a "I sized this resource", 
   because that's how resources are sized (you write all ones into them 
   and look what you can read back).

   But your lspci -vxx output clearly shows that (a) MEM is enabled in 
   the command word, and yes, the BAR register at 0x18 does indeed have 
   value 0xe0000000. So it's just the length that is really bogus.

 - pnp clearly sees that bogus resource at 0xe0000000-0xffffffff

 - BUT: the "can't allocate resource" thing is from 
   pcibios_allocate_resources(), and means that the request_resource() 
   failed _despite_ the fact that you hadn't reserved the e820 resources 
   yet with the new patch.

The thing that seems to save you is that we've already allocated something 
in that region. There's a few things there, like:

	fee00000-fee00fff : Local APIC

but that particular one is actually reserved much later, so that doesn't 
explain it. I think that what happens is that we have allocated the _bus_ 
resources earlier in "pcibios_allocate_bus_resources()", and that means 
that we already have these resources:

	fe700000-fe7fffff : PCI Bus 0000:01
	fe800000-fe8fffff : PCI Bus 0000:02
	fe900000-fe9fffff : PCI Bus 0000:03
	fea00000-feafffff : PCI Bus 0000:04
	feb00000-febfffff : PCI Bus 0000:05

in the resource tree, and that in turn means that when we try to allocate 
the bogus MCFG resource, it fails.

Which is good - it mustn't succeed.

What _broke_ for you is that the horrible patch that got reverted said 
that "if we recognize this as an MCFG resource, we will _always_ try to 
insert it", so it fundamentally broke the whole resource tree, because it 
force-inserted that totally crap resource.

Now, the thing that worries me a bit is that I wonder how common this kind 
of crap is. And in particular, I wonder how often we've been saved from 
horrible issues like this by the fact that we've inserted the e820 
resources first. Of course - it can work both ways - sometimes it saves 
us, and sometimes it just causes more problems (eg when we then 
re-allocate the resource successfully somewhere else).

		Linus
