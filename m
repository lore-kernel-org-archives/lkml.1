Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYL1KCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYL1KCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 05:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYL1KCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 05:02:46 -0500
Received: from sh.osrg.net ([192.16.179.4]:45645 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYL1KCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 05:02:45 -0500
Date: Sun, 28 Dec 2008 19:02:12 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org, ian.campbell@citrix.com, beckyb@kernel.crashing.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 0 of 9] swiotlb: use phys_addr_t for pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081228093751.GC9022@elte.hu>
References: <20081228020312K.fujita.tomonori@lab.ntt.co.jp>
	<20081228142900W.fujita.tomonori@lab.ntt.co.jp>
	<20081228093751.GC9022@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081228190111H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008 10:37:51 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > If we really want to clean up the dma mapping operations, we should 
> > define struct dma_mapping_ops in a generic place (such as 
> > include/linux/dma-mapping.h) instead each architecture define the own 
> > struct dma_mapping_ops. These dma_mapping_ops structures are very 
> > similar but a bit different. That's the root cause of the dma mapping 
> > operation ugliness.
> >
> > If we do, X86 and IA64 can share swiotlb and intel VTD code cleanly, 
> > X86, IA64, and POWERPC can share swiotlb cleanly too. For example, we 
> > can define swiotlb_dma_ops in lib/swiotlb.c and then everyone can share 
> > it. Currently, X86 and IA64 define the own swiotlb_dma_ops (and X86 
> > needs swiotlb_map_single_phys hack). It doesn't make sense.
> 
> Sure.
> 
> Note that we went through this process (of unifying dma_mapping_ops) 
> recently on x86 recently - 32-bit and 64-bit x86 had such differences.

Not really. x86_32 did not use the dma_ops scheme.


> Note that the main complication wasnt even the small variations in 
> signatures, but the different _semantics_: one dma_mapping_ops 
> implementation passed in kernel-virtual addresses, the other physical 
> addresses. Unifying that was invasive and non-trivial, and it can break 

I guess that you are talking about the dma_map_single difference
between x86_32 and x86_64. As far as I know, Only x64_64 uses physical
address with dma_map_single.


> stuff not at the build level but at the runtime level. We can expect 
> similar complications when done over 20 architectures as well.

We don't need to touch 20 architectures. We are talking about
unifying dma_mapping_ops. Only architectures that need to handle
multiple dma mapping operations use the dma_mapping_ops scheme; X86,
IA64, POWERPC, SPARC, and PARISC. Unifying X86, IA64 and POWERPC is a
must since they actually share dma_mapping_ops.


> But yes, it's all desired. Obviously extending swiotlb to highmem and 
> using it on xen and powerpc is an essential first step in the direction of 
> generalizing all this code.

No, it's not about swiotlb highmem patchset.

Due to this problem, IA64 and X86_64 share swiotlb in a very hacky
way. We added more hacky code due to this problem again when we added
VT-d support to IA64.

This problem has been for long time. We added ugly hacks again and
again instead of fixing the root cause.
