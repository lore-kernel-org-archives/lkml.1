Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYKLBlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYKLBlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYKLBkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:40:35 -0500
Received: from sh.osrg.net ([192.16.179.4]:55657 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbYKLBkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:40:33 -0500
Date: Wed, 12 Nov 2008 10:40:18 +0900
To: cl@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, y-goto@jp.fujitsu.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0811111431440.26610@quilx.com>
References: <Pine.LNX.4.64.0811101600490.32282@quilx.com>
	<20081111145418P.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0811111431440.26610@quilx.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081112104048C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 14:32:46 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 11 Nov 2008, FUJITA Tomonori wrote:
> 
> > Is it because it does some kinda address translation
> > (provider->dma_map_consistent) later? The zone flag is meaningless if
> > you do sorta address translation (e.g. hardware IOMMU like VT-d).
> 
> Yes it can do address translation. Therefore a < 4G address can show up at
> any 64 bit address. So no need for a special DMA zone. The same is true
> for more x86_64 platforms that have an IOMMU.

Yes, with address translation hardware such as IOMMU, the zone is
meaningless. The IOMMU drivers ignore the zone flag
(e.g. intel_alloc_coherent).

But the GFP_DMA in IA64's platform_dma_alloc_coherent() is still
necessary for swiotlb with devices that don't have DMA_64BIT_MASK
coherent_dma_mask. They need a < 4G address.

This is exactly what x86 and x86_64 do, dma_alloc_coherent in
arch/x86/include/asm/dma-mapping.h. It sets GFP_DMA and GFP_DMA32 for
swiotlb and pci-nommu.c when necessary.
