Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYL0PG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYL0PG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 10:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYL0PGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 10:06:50 -0500
Received: from sh.osrg.net ([192.16.179.4]:51524 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbYL0PGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 10:06:49 -0500
Date: Sun, 28 Dec 2008 00:06:15 +0900
To: mingo@elte.hu
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081227104823.GI14639@elte.hu>
References: <patchbomb.1229970362@abulafia.goop.org>
	<20081227104823.GI14639@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228000558I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 11:48:23 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Hi all,
> > 
> > Here's a work in progress series whcih does a partial revert of the 
> > previous swiotlb changes, and does a partial replacement with Becky 
> > Bruce's series.
> > 
> > The most important difference is Becky's use of phys_addr_t rather than 
> > page+offset to represent arbitrary pages.  This turns out to be simpler.
> > 
> > I didn't replicate the map_single_page changes, since I'm not exactly 
> > sure of ppc's requirements here, and it seemed like something that could 
> > be easily added.
> > 
> > Quick testing showed no problems, but I haven't had the chance to do 
> > anything extensive.
> > 
> > I've made some small changes to Becky's patches to make them apply, but 
> > I've separated any functional changes into separate patches with 
> > appropriate authorship.
> 
> looks good to me in principle. Fujita-san, do you have any principal 
> objections against these generalizations?

Well, I asked Jeremy to use Becky's approach so I don't have though
this patchset isn't enough for Becky (possibly for Xen too) since
Jeremy didn't put Becky's map_single_page changes. These changes are
necessary to support map_map_page with highmem. I think that we can do
it simpler than his patch. I'll send patches to that in a different
way soon.

It's not principal objection, but as I said, the patches to revert
Jeremy's highmem patches in this patchset like the following are
pointless.

Commit e58c866b9b74a825771e2024d4a059bd07359d75
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Mon Dec 22 10:26:03 2008 -0800

    revert "swiotlb: support bouncing of HighMem pages."

    git commit ef9b189352f2eb78f14e52996f4780a523b04a49


This doesn't explain why we reverted it. The two approaches are
different so there is no point to merge these patch in this way.

There is no patches in tip/core/iommu except for this swiotlb
stuff. The end result is exactly same (I just reordered patches). So
there is nothing to worry. You can safely replace tip/core/iommu with
this tree.

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb


> Also, this patch will interact with ia64 materially:
> 
>   Subject: [PATCH 9 of 9] ia64/x86/swiotlb: use enum dma_data_direciton in dma_ops
> 
> So we'll need a bit more confidence in the testing status of this queue, 
> and we probably want to wait until Tony merged the pending .29 ia64 
> changes, and also get an Ack from Tony for these bits:
> 
>  arch/ia64/dig/dig_vtd_iommu.c       |    9 +++--
>  arch/ia64/hp/common/hwsw_iommu.c    |   22 ++++++++------
>  arch/ia64/hp/common/sba_iommu.c     |   12 ++++---
>  arch/ia64/include/asm/dma-mapping.h |   29 +++++++++---------
>  arch/ia64/include/asm/swiotlb.h     |   26 ++++++++++------
>  arch/ia64/kernel/machvec.c          |    6 ++-
>  arch/ia64/sn/kernel/io_common.c     |    3 +-
>  arch/ia64/sn/pci/pci_dma.c          |   21 ++++++++-----
>  arch/ia64/sn/pci/pcibr/pcibr_dma.c  |    3 +-
>  arch/ia64/sn/pci/tioca_provider.c   |    3 +-
> 
> (Tony Cc:-ed)
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
