Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZGNFJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZGNFJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 01:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZGNFJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 01:09:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:36268 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZGNFJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 01:09:58 -0400
Date: Tue, 14 Jul 2009 14:08:47 +0900
To: beckyb@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org
Subject: Re: [PATCH 04/15] swiotlb: remove unnecessary swiotlb_bus_to_virt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <5E909C02-3FA2-4BEB-8C73-F4E4A5A404BF@kernel.crashing.org>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1247187904-31999-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<5E909C02-3FA2-4BEB-8C73-F4E4A5A404BF@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090714140805G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Jul 2009 14:08:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 21:17:21 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> 
> On Jul 9, 2009, at 8:04 PM, FUJITA Tomonori wrote:
> 
> > swiotlb_bus_to_virt is unncessary; we can use swiotlb_bus_to_phys and
> > phys_to_virt instead.
> 
> phys_to_virt (also, virt_to_phys) is invalid for highmem addresses on  
> ppc.  In most of the uses in this file, it doesn't matter, as the  
> iotlb buffers themselves are alloc'd out of lowmem,

Right,

> but the  
> dma_mark_clean() calls could happen on a highmem addr.  Currently, on  
> powerpc, dma_mark_clean() doesn't do anything, so it isn't a  
> functional problem.

Oops, I overlooked this. However, as you said, this is not a problem
with the current code.


>  I'm fine with the bulk of this patch, because in  
> reality, if I need to do something with a virtual address of a highmem  
> page, I have to get a kmap for the page.  So the existing  
> swiotlb_bus_to_virt isn't really helping.
> 
> What is dma_mark_clean used for?  Could it be made to take a paddr,  
> and let the implementation deal with making sure there's a valid vaddr  
> for the actual "clean" operation?

I think that it's IA64's optimization (it's a NULL function on X86
like POWERPC). It's defined in arch/ia64/mm/init.c. Looks like POWERPC
could use this optimization, I guess.

dma_mark_clean() just modifies the page flag (what it needs is struct
page) so I think that we can make it take a paddr.


> I'd also like to see a comment with swiotlb_virt_to_bus() that notes  
> that it should only be called on addresses in lowmem.

Ok, I'll do.


Thanks,
