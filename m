Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbZDHVPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbZDHVPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZDHVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:15:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:43021 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbZDHVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:15:38 -0400
Date: Thu, 9 Apr 2009 06:15:07 +0900
To: galak@kernel.crashing.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jeremy@goop.org, fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <7366A4DE-6848-4AF6-AA33-6BD89B0A5153@kernel.crashing.org>
References: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
	<20090408203823.GA14985@infradead.org>
	<7366A4DE-6848-4AF6-AA33-6BD89B0A5153@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090409061444G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 09 Apr 2009 06:15:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 15:56:32 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Apr 8, 2009, at 3:38 PM, Christoph Hellwig wrote:
> 
> > On Wed, Apr 08, 2009 at 09:09:18AM -0500, Kumar Gala wrote:
> >> From: Becky Bruce <beckyb@kernel.crashing.org>
> >>
> >> Some architectures require additional checking to determine
> >> if a device can dma to an address and need to provide their
> >> own address_needs_mapping..
> >
> > Shouldn't we just move it completely to the arch?  I think that ia64  
> > and
> > x86 currently use the same one is more of an accident.
> 
> It seems like the swiotlb code uses __weak for a number of things:
> 
> lib/swiotlb.c:void * __weak __init swiotlb_alloc_boot(size_t size,  
> unsigned long nslabs)
> lib/swiotlb.c:void * __weak swiotlb_alloc(unsigned order, unsigned  
> long nslabs)
> lib/swiotlb.c:dma_addr_t __weak swiotlb_phys_to_bus(struct device  
> *hwdev, phys_addr_t paddr)
> lib/swiotlb.c:phys_addr_t __weak swiotlb_bus_to_phys(struct device  
> *hwdev, dma_addr_t baddr)
> lib/swiotlb.c:void * __weak swiotlb_bus_to_virt(struct device *hwdev,  
> dma_addr_t address)
> lib/swiotlb.c:int __weak swiotlb_arch_address_needs_mapping(struct  
> device *hwdev,
> lib/swiotlb.c:int __weak swiotlb_arch_range_needs_mapping(phys_addr_t  
> paddr, size_t size)
> 
> instead of #ifndef HAVE_ARCH_<FOO>.  Not sure if there is a historical  
> reason for that.

ia64 and x86_64 use swiotlb but neither need this function. And
neither need any above __weak. They were added for dom0 support.
Yeah, swiotlb is much cleaner and better if we don't add dom0 support.

About this patch, I think that we could do better. What we need to do
is allowing each architectures to have is_buffer_dma_capable().

I'm doing the dma_mapping_ops unification. I think that adding
something like is_buffer_dma_capable to dma_map_ops struct is
cleaner. Then we don't need this __weak function. But this patch is
fine by me for now.
