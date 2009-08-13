Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbZHMGbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbZHMGbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZHMGbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:31:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:54404 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZHMGbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:31:09 -0400
Date: Thu, 13 Aug 2009 15:30:51 +0900
To: luming.yu@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, fenghua.yu@intel.com, dwmw2@infradead.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
References: <20090812181722.GA32653@linux-os.sc.intel.com>
	<20090813132845R.fujita.tomonori@lab.ntt.co.jp>
	<3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813153014Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 15:30:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 13:48:45 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> >>
> >> This check can not be removed. Otherwise, swiotlb_dma_ops will always override
> >> previous dma_ops value.
> >
> > Yeah.
> 
> I think pci_swiotlb_init needs to be cleaned up for both x86_{32,64} and ia64.

Yeah, it has been on my todo list. But we can't clean up only
pci_swiotlb_init. We need to take care of the whole dma setup code.


> it should be used to init default dma_ops, and the call site of it should be
> as early as platform_dma_init in mem_init. SInce swiotlb_dma_ops is pitched as
> default dma_ops for x86, ia64,

It's more complicated. x86_32 should use nommu_dma_ops. x86_64 should
use nommu_dma_ops if swiotlb is not necessary.

About IA64, swiotlb is not always available (IA64_HP_ZX1 and
IA64_SIG_SN2).


> we really don't need to let pci_swiotlb_init
> know iommu_deteced, dmar_disabled or iommu_passthrough...and anything
> like that..

Yeah. That's one of reasons why I want to rewrite the IA64 and X86 dma
setup code again.


> Please note the major wrong assumption of the current implementation is
> "iommu_deteced == iommu working" that I was trying to fix.

Yeah, I see that. But it had been correct for long time; we had been
happy about the logic that if we detect iommu but it doesn't work then
we are dead.

The x86 dma setup code can enable both hardware IOMMU and
swiotlb. It's a bit similar to what you need for IA64.


Anyway, my patch should fix this problem. Have you tried it?

http://marc.info/?l=linux-kernel&m=125013354518721&w=2


It's fine for now, I think.
