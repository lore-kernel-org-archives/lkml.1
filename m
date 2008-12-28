Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYL1Fah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYL1Fah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 00:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYL1Fa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 00:30:28 -0500
Received: from sh.osrg.net ([192.16.179.4]:50552 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYL1Fa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 00:30:28 -0500
Date: Sun, 28 Dec 2008 14:29:54 +0900
To: mingo@elte.hu
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228020312K.fujita.tomonori@lab.ntt.co.jp>
References: <20081228014432L.fujita.tomonori@lab.ntt.co.jp>
	<20081227165622.GA19796@elte.hu>
	<20081228020312K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228142900W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 02:03:37 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Sat, 27 Dec 2008 17:56:22 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Sat, 27 Dec 2008 11:48:23 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Also, this patch will interact with ia64 materially:
> > > > 
> > > >   Subject: [PATCH 9 of 9] ia64/x86/swiotlb: use enum dma_data_direciton in dma_ops
> > > > 
> > > > So we'll need a bit more confidence in the testing status of this queue, 
> > > > and we probably want to wait until Tony merged the pending .29 ia64 
> > > > changes, and also get an Ack from Tony for these bits:
> > > > 
> > > >  arch/ia64/dig/dig_vtd_iommu.c       |    9 +++--
> > > >  arch/ia64/hp/common/hwsw_iommu.c    |   22 ++++++++------
> > > >  arch/ia64/hp/common/sba_iommu.c     |   12 ++++---
> > > >  arch/ia64/include/asm/dma-mapping.h |   29 +++++++++---------
> > > >  arch/ia64/include/asm/swiotlb.h     |   26 ++++++++++------
> > > >  arch/ia64/kernel/machvec.c          |    6 ++-
> > > >  arch/ia64/sn/kernel/io_common.c     |    3 +-
> > > >  arch/ia64/sn/pci/pci_dma.c          |   21 ++++++++-----
> > > >  arch/ia64/sn/pci/pcibr/pcibr_dma.c  |    3 +-
> > > >  arch/ia64/sn/pci/tioca_provider.c   |    3 +-
> > > > 
> > > > (Tony Cc:-ed)
> > > 
> > > BTW, the above patch breaks IA64 build.
> > > 
> > > It's fixable but I think that it would be better to just drop this huge 
> > > patch and add some cast in powerpc code. the types of SWIOTBL function 
> > > arguments don't need to mach to DAM_API.txt though it might be nice if 
> > > so. There are other type mismatches. If we really want to do this 
> > > cleanups, we should fix up all the mismatches.
> > 
> > hm, we shouldnt do ugly typecasts - lets fix all the places. As Jeremy 
> > indicated, this is work in progress.
> 
> It's not about this patchset, swiotlb. I'm talking about all the
> mismatches of dma mapping operations. But it need huge patches
> (touching lots of the architectures). I'm not sure it is worth doing
> it. Even if we want, it's not the job that this swiotlb patches does.

If we really want to clean up the dma mapping operations, we should
define struct dma_mapping_ops in a generic place (such as
include/linux/dma-mapping.h) instead each architecture define the own
struct dma_mapping_ops. These dma_mapping_ops structures are very
similar but a bit different. That's the root cause of the dma mapping
operation ugliness.

If we do, X86 and IA64 can share swiotlb and intel VTD code cleanly,
X86, IA64, and POWERPC can share swiotlb cleanly too. For example, we
can define swiotlb_dma_ops in lib/swiotlb.c and then everyone can
share it. Currently, X86 and IA64 define the own swiotlb_dma_ops (and
X86 needs swiotlb_map_single_phys hack). It doesn't make sense.

If we want to clean up all the dma mapping operation ugliness, the
above patch is wrong.
