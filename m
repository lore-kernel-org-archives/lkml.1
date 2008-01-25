Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYAYJsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYAYJsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYAYJsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:48:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47412 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYAYJsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:48:37 -0500
Date: Fri, 25 Jan 2008 10:48:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
Message-ID: <20080125094824.GH23708@elte.hu>
References: <1201240501.15972.46.camel@caritas-dev.intel.com> <20080125091655.GD23708@elte.hu> <1201253177.15972.57.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201253177.15972.57.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> On Fri, 2008-01-25 at 10:16 +0100, Ingo Molnar wrote:
> > * Huang, Ying <ying.huang@intel.com> wrote:
> > 
> > > This patch fixes some bugs of making EFI runtime code executable.
> > > 
> > > - Use change_page_attr in i386 too. Because the runtime code may be
> > >   mapped not through ioremap.
> > > 
> > > - If there is no _PAGE_NX in __supported_pte_mask, the change_page_attr
> > >   is not called.
> > > 
> > > - Make efi_ioremap map pages as PAGE_KERNEL_EXEC, because EFI runtime
> > >   code may be mapped through efi_ioremap.
> > 
> > thanks, applied.
> > 
> > note that here:
> > 
> > > -		set_fixmap_nocache(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
> > > -				   offset);
> > > +		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
> > > +			     offset, PAGE_KERNEL_EXEC);
> > 
> > you've changed it from nocache-noexec to cached-exec. I suspect 
> > that's what we want - except if an early EFI area can be 
> > non-prefetchable device memory. Can that ever happen? Would you like 
> > to have PAGE_KERNEL_NOCACHE_EXEC perhaps? I implemented that 
> > yesterday but did not commit it yet. (see the patch below)
> 
> Yes. EFI area can be non-prefetchable device memory. I should use 
> PAGE_KERNEL_NOCACHE_EXEC.

ok, i fixed that in the patch and reordered the PAGE_KERNEL_NOCACHE_EXEC 
patch to come before yours.

> A question about this:
> 
> The MTRR on x86 should have set the memory area as un-cachable. Why do 
> we bother to set it in page table?

you are right in that there is no immediate correctness reason for it. 
The reason is to eventually get away from any MTRR dependencies. If some 
other OS uses PATs and the BIOS sets up the wrong MTRR, then the other 
OS might still having a working EFI, while Linux might crash and burn. 

So we try to get both the MTRRs and the pagetable attributes match the 
purpose of the area in question. If _both_ levels of attributes agree it 
cannot hurt, but if one of them is wrong, the other one still saves the 
day.

that's why we changed all ioremaps to default to cache-disabled (PCD) in 
latest x86.git as well. For years the x86 architecture set the ioremap 
pagetable entries to cacheable by default and only the MTRRs (and the 
BIOS writers) saved us from trouble. Now we try to be a bit more 
defensive and avoid "BIOS bug causes only Linux to crash and burn while 
other OSs work fine" type of scenarios.

	Ingo
