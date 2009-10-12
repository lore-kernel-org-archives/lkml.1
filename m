Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbZJLP4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbZJLP4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676AbZJLP4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:56:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:45909 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbZJLP4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:56:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,546,1249282800"; 
   d="scan'208";a="197967059"
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
From: David Woodhouse <david.woodhouse@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.2.01.0910120725350.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
	 <1255342738.24732.265.camel@macbook.infradead.org>
	 <alpine.LFD.2.01.0910120725350.3438@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation. Pipers Way, Swindon, Wiltshire, SN3 1RJ,
 UK.
Date: Mon, 12 Oct 2009 16:56:02 +0100
Message-Id: <1255362962.32729.63.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 16:24 +0100, Linus Torvalds wrote:
> 
> On Mon, 12 Oct 2009, David Woodhouse wrote:
> > 
> > Well, according to the design, the IOMMU code is doing the right thing¹.
> > 
> > The theory is that the BIOS _tells_
> 
> There is no "theory". There is only crap BIOSes. Stop living in a dream 
> world, and stop making arguments that are only relevant in that dream 
> world.

You're preaching to the choir, Linus.

> > The only viable solution (short of an open source BIOS written by sober
> > people)
> 
> Again, you're living in that dream world. Wake up, sheeple.

 ... 

> So your arguments about RMRR tables and "should do" are POINTLESS. Just 
> give it up.

I didn't intend that as an argument. That was just a statement of how
the architecture specifies it's _supposed_ to work. I _said_ it was
nonsense, in my own footnote.

> The sane thing to do is to have a legacy IOMMU mapping until all devices 
> are initialized, so that things work _despite_ the inevitable BIOS 
> crapola. End of story.

Damn right.

That's precisely what the original "kill USB DMA early" patch was
intending to do -- and that's why I've been telling the people
responsible for the RMRR design that it was a stupid idea in the first
place.

The problem with the original patch was just that I didn't realise that
some architectures didn't have ioremap() working at the time that
PCI_FIXUP_HEADER() runs.

> So stop blaming the BIOS. We _know_ firmware is crap - there is no point 
> in blaming it. The response to "firmware bug" should be "oh, of course - 
> and our code was too fragile, since it didn't take that into account".

Yes. That's why our code has grown a metric shitload of BIOS
workarounds, and been refactored to be less fragile, since I've taken
over responsibility for it.

You won't stop me hating the BIOS for it though. And although I agree
that it wouldn't be perfect if we had an open source BIOS, it _would_ be
a whole lot better.

> The other solution would be to just _enable_ (and do all the setup) of the 
> IOMMU early. And then just leave a legacy mapping for the IOMMU, and then 
> _after_all_devices_are_set_up_ can you then remove the legacy mapping.

That involves allocating a _shitload_ of page tables for a 1:1 mapping
of all of physical memory. We used to do that to pander to broken
graphics drivers, and the AMD guys asked me to stop because it was
actually quite painful for them to do the same.

> But your patch looks fine.
> 
> That said, I think your choice of initcall is odd, even if it is 
> understandable. Right now we have, at least on x86:
> 
> 	fs_initcall(pcibios_assign_resources);
> 
> and I assume you picked fs_initcall_sync() so that it happens after that 
> one. No?

Right.

> Which makes sense, but at the same time, it all looks just random. 

No more random than the fact that pcibios_assign_resources() is marked
as a FILE SYSTEM initcall in the first place, surely?

We have a very limited method of expressing ordering constraints for
initcalls; we make do with what we have. Some people around here have
been known to argue _very_ vocally against a more comprehensive
framework for ordering them.

Yes, sometimes it looks odd :)

> And 
> different architectures actually do it in different places (some seem to 
> do it inside pcibios_init() at subsys_initcall time). So I'm not even sure 
> fs_initcall_sync() will do it for other architectures, although it looks 
> like most others do their final PCI setup _earlier_ rather than later.

They will do it earlier; never later. It would be completely broken to
do it any later -- fs_initcall_sync() and rootfs_initcall() are new
inventions, so such an architecture would have to be doing it in
device_initcall(). And that would just be totally broken.

> But I guess there could be random ACPI initcalls etc involved too, and 
> subtle ordering constraints with _those_. And we have way too many 
> arch-specific details here. So your patch may be the simplest one, but I 
> wish we could also make some of this be less of a jungle of different 
> initcalls.

Yeah, it's a complete mess of generic and arch-specific initcalls, all
invoked at different times. It would be good to clean that up, perhaps,
but maybe not for 2.6.32.

> Basically, it seems silly to have this kind of subtlety for just the final 
> quirk, when the _other_ quirks are all handled by generic code in very 
> well-defined places.

I did think briefly about adding it to pci_subsys_init(), but moving it
into arch-specific code didn't seem like a great idea. And the
pcibios_assign_resources() initcall happens _after_ that, anyway.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

