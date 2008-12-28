Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYL1Keu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYL1Keu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 05:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYL1Kel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 05:34:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYL1Kek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 05:34:40 -0500
Date: Sun, 28 Dec 2008 11:34:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org, joerg.roedel@amd.com
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
Message-ID: <20081228103419.GA7128@elte.hu>
References: <20081228020312K.fujita.tomonori@lab.ntt.co.jp> <20081228142900W.fujita.tomonori@lab.ntt.co.jp> <20081228093751.GC9022@elte.hu> <20081228190111H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081228190111H.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > Note that the main complication wasnt even the small variations in 
> > signatures, but the different _semantics_: one dma_mapping_ops 
> > implementation passed in kernel-virtual addresses, the other physical 
> > addresses. Unifying that was invasive and non-trivial, and it can 
> > break
> 
> I guess that you are talking about the dma_map_single difference between 
> x86_32 and x86_64. As far as I know, Only x64_64 uses physical address 
> with dma_map_single.

yes - dma_map_single() has this signature:

 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size, int direction)

on x86 dma_mapping_ops.map_single has this signature:

        dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
                                size_t size, int direction);

ia64 and powerpc uses kernel-virt addresses for map_single(). So there's 
material semantic differences between the dma_mapping_ops implementations.

> > stuff not at the build level but at the runtime level. We can expect 
> > similar complications when done over 20 architectures as well.
> 
> We don't need to touch 20 architectures. We are talking about unifying 
> dma_mapping_ops. Only architectures that need to handle multiple dma 
> mapping operations use the dma_mapping_ops scheme; X86, IA64, POWERPC, 
> SPARC, and PARISC. Unifying X86, IA64 and POWERPC is a must since they 
> actually share dma_mapping_ops.

if it's just dma_mapping_ops - then it's those 3 architectures. But 
there's no reason why the various DMA bouncing implementations in other 
architectures couldnt use the common code - for example couldnt 
arch/arm/common/dmabounce.c use the swiotlb too?

> > But yes, it's all desired. Obviously extending swiotlb to highmem and 
> > using it on xen and powerpc is an essential first step in the 
> > direction of generalizing all this code.
> 
> No, it's not about swiotlb highmem patchset.
> 
> Due to this problem, IA64 and X86_64 share swiotlb in a very hacky way. 
> We added more hacky code due to this problem again when we added VT-d 
> support to IA64.
> 
> This problem has been for long time. We added ugly hacks again and again 
> instead of fixing the root cause.

well the swiotlb highmem patches are what enable xen (and now powerpc too) 
to make full use of the swiotlb dma bouncing facilities. And that gives a 
common platform for unifying all the rest of the lowlevel DMA mapping APIs 
as well.

Without that, the swiotlb code is limited, life is going on in separate 
islands, with everyone doing their own private variations and hacks. We 
would still probably be nowhere with this had Jeremy not sent the highmem 
patches.

	Ingo
