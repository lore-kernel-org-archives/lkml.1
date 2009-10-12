Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZJLRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZJLRgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZJLRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:36:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757310AbZJLRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:36:52 -0400
Date: Mon, 12 Oct 2009 10:35:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Woodhouse <david.woodhouse@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
In-Reply-To: <1255362962.32729.63.camel@macbook.infradead.org>
Message-ID: <alpine.LFD.2.01.0910121028040.3438@localhost.localdomain>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>  <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>  <1255342738.24732.265.camel@macbook.infradead.org>  <alpine.LFD.2.01.0910120725350.3438@localhost.localdomain>
 <1255362962.32729.63.camel@macbook.infradead.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, David Woodhouse wrote:
> 
> > The other solution would be to just _enable_ (and do all the setup) of the 
> > IOMMU early. And then just leave a legacy mapping for the IOMMU, and then 
> > _after_all_devices_are_set_up_ can you then remove the legacy mapping.
> 
> That involves allocating a _shitload_ of page tables for a 1:1 mapping
> of all of physical memory.

I don't think that's true.

Nobody cares about "all physical memory". For one thing, we know that 
anything that we consider to be normal memory (ie it's listed in the e820 
tables as RAM) can't be all that interesting, since the BIOS definitely 
released that to us.

That said, as long as the IOMMU is clearly enabled after the quirks have 
run, for this particular case we don't much care.

But I could also imagine something similar happening for some BIOS-enabled 
ethernet device being set up to listen to packets into some BIOS data 
areas (left-overs from whatever bootp thing or other), which doesn't have 
a quirk, and which ends up doing DMA until we actually load the driver.

Of course, we'd hope that the DMA just fails and nothing bad really 
happens (hopefully the driver re-init will clear up any hung device). But 
I can also imagine the hardware simply being really really unhappy, and 
not recovering.

So in many ways it would be safest to leave memory that we don't know 
about and we don't own as DMA'able in the IOMMU.

And no, I don't think it would be a shitload of pages. Quite the reverse. 
It's probably not very many at all.

		Linus
