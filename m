Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbXLSUc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbXLSUc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXLSUcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:32:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:37473 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXLSUcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:32:17 -0500
Subject: Re: [RFC/PATCH]] x86: pci: Disable IO/Mem on a device when
	resources can't be allocated
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       jgarzik@pobox.com, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071219134350.GA19698@jurassic.park.msu.ru>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <x7prx4vq3e.fsf@saeurebad.de> <1197936157.13400.9.camel@pasglop>
	 <20071218123715.A7874@jurassic.park.msu.ru>
	 <1198041019.18908.32.camel@pasglop>
	 <20071219134350.GA19698@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 07:29:54 +1100
Message-Id: <1198096194.18908.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-12-19 at 16:43 +0300, Ivan Kokshaysky wrote:
> On Wed, Dec 19, 2007 at 04:10:19PM +1100, Benjamin Herrenschmidt wrote:
> > This patch changes the x86 PCI code to disable IO and/or Memory
> > decoding on a PCI device when a resource of that type failed to
> > be allocated.
> 
> Oh, this opens up a can of worms ;-)
> 
> In ideal world, the patch would be perfectly valid. But on x86 we have
> at least two firmware layers (E820 and ACPI), each with its own (often
> totally crazy) view on system resources. OTOH, we cannot completely ignore
> the firmware - otherwise the resource allocator could step onto some
> hidden/undocumented system decode ranges...
> One of the typical reasons for "dangling BAR" on x86 is that a resource
> allocation failed because BIOS has reserved address region for the
> very same BAR ;-)
> 
> Perhaps you've seen most recent illustration of x86 resource allocation
> problems:
>  http://lkml.org/lkml/2007/12/17/429

Yeah, gives me headaches.

> Plus there are lots of x86 hardware like host bridges with a BAR
> representing the system RAM, IOAPIC BARs with some high order bits
> hardwired to "1" and so on. Which also doesn't make life any easier.

Ok. We tent do have quirks for those on powerpc.

> That's why I still think that res->parent check is not enough for
> x86 and we need some resource flag that tells generic PCI code
> "We failed to allocate this resource, but please don't touch it!".
> Some code is already using IORESOURCE_PCI_FIXED for that purpose, so it
> would suffice.

Yup, possibly. On the other hand, it's also used for other things. It
normally means a fixed decode resource, such as IDE in legacy mode. If
that conflicts for real, then the only option -is- to disable the
device.

The problem on x86 seems to be to differenciate what conflicts for real
and what is just this resource management crackpot.

> On the other hand, with that flag we can move all those horrible
> exceptions like PCI_CLASS_BRIDGE_HOST (which nearly breaks alpha, BTW)
> and PCI_CLASS_SYSTEM_PIC from generic code to arch/x86 where it belongs.

Heh, possibly yeah :-)

> > I'll wait for more comments today and post the whole 5 again tomorrow
> > as official candidates for inclusion :-) (BTW. What is people general
> > feeling about inline vs. non inline for the functions in pci.c ?)
> 
> I think inlines are prettier, but not allowing direct use of the _flag
> function is a valid argument too. So I'm fine with both.

Ok. I'll keep the x86 patch out for now though. I'll let others sort out
what happens on this platform.

Cheers,
Ben.


