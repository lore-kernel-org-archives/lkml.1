Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYGVONx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYGVONx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYGVONp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:13:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59491 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGVONo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:13:44 -0400
Date: Tue, 22 Jul 2008 08:13:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eran Liberty <liberty@extricom.com>
Cc: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
Message-ID: <20080722141327.GB7337@parisc-linux.org>
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885DD41.9010202@extricom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 04:14:41PM +0300, Eran Liberty wrote:
> Each slot represent a single device which can have more then one 
> function.  pci_scan_slot is aimed for scanning these multiple functions.

Exactly.

> I, on the other hand, have programmable device on the pci bus which is, 
> for the sake of this discussion, a complete black box.
> This black box up on loading can implement more then one device, which 
> can have more then one function each.
> So as far as I see it, now I need to scan all slots on the bus.

That's quite interesting.  A normal PCI device has its IDSEL pin
connected to one of the AD lines, so it's not possible for it to respond
to more then one of the 32 possible devices.  I suppose by decoding
the configuration cycles on the bus, it's possible to make a
programmable device respond to more than one device.  I suppose you have
to be careful to program it to not respond to the same device numbers as
any other device on the bus.  Or are there no other devices on this bus
(in which case I have another solution for you)?

> But to be honest, upon looking a way to make my device work I dismissed 
> the "pci_scan_slot()" option as It did not reach the "fixup_resource ()" 
> part.
[...]
> I work with ARCH=powerpc. pcibios_fixup_bus() will deal with all the 
> resource bars allocation.
> I needed Linux to renegotiate the resources bars on the PCI devices.

OK.  I don't think it's safe to call powerpc's fixup_resource() more
than once for a given resource.

> >(as a side-note, I'd like to reimplement the pcibios_fixup_*() routines;
> >I think a lot of what they do can be done more generically these days.
> >It'll take a while and isn't high on my priority list).
> >  
> If I can lend a hand there, let me know and I will try to squeeze it in 
> somewhere.

What I want to do is get rid of fixup_resource() and its equivalent on
other architectures and call pcibios_bus_to_resource() from
drivers/pci/probe.c.

I've been working in this area recently; here's my current tree:

http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=pci-read-base

I've had a quick hack at doing what I want, but I haven't tested it.

> I think there is a hidden assumption in this code, again please correct 
> me if I missed the point.
> This code assumes that the devices which will re-appear after the 
> programmable unit is loaded has the same devfn and bus as the devices 
> which were present before the reload.
> This assumption might be wrong.

Yes, I did make that assumption ... I'm used to real PCI devices, not
this unusual box ;-)

> For example, I have a basic programmable image which has no pci devices 
> at all.
> upon unloading I do not remove any device (as non are present) and up on 
> reloading I suddenly have two. What is their bus? their devfn?
> 
> Ultimately I would have expected to find a "int pci_scan_bus(struct 
> pci_bus *bus );" the "pci_scan_child_bus ()" was the closest to the mark

If this is all alone on a bus of its own, we can certainly handle that.
Maybe we can make it a module parameter or something.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
