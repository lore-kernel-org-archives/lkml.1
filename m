Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZDHWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZDHWLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZDHWLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 18:11:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:60041 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZDHWK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 18:10:59 -0400
Date: Thu, 9 Apr 2009 07:10:32 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49DD1D6B.6030001@goop.org>
References: <7366A4DE-6848-4AF6-AA33-6BD89B0A5153@kernel.crashing.org>
	<20090409061444G.fujita.tomonori@lab.ntt.co.jp>
	<49DD1D6B.6030001@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090409071032M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 09 Apr 2009 07:10:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 14:55:55 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 8 Apr 2009 15:56:32 -0500
> > Kumar Gala <galak@kernel.crashing.org> wrote:
> >
> >   
> >> On Apr 8, 2009, at 3:38 PM, Christoph Hellwig wrote:
> >>
> >>     
> >>> On Wed, Apr 08, 2009 at 09:09:18AM -0500, Kumar Gala wrote:
> >>>       
> >>>> From: Becky Bruce <beckyb@kernel.crashing.org>
> >>>>
> >>>> Some architectures require additional checking to determine
> >>>> if a device can dma to an address and need to provide their
> >>>> own address_needs_mapping..
> >>>>         
> >>> Shouldn't we just move it completely to the arch?  I think that ia64  
> >>> and
> >>> x86 currently use the same one is more of an accident.
> >>>       
> >> It seems like the swiotlb code uses __weak for a number of things:
> >>
> >> lib/swiotlb.c:void * __weak __init swiotlb_alloc_boot(size_t size,  
> >> unsigned long nslabs)
> >> lib/swiotlb.c:void * __weak swiotlb_alloc(unsigned order, unsigned  
> >> long nslabs)
> >> lib/swiotlb.c:dma_addr_t __weak swiotlb_phys_to_bus(struct device  
> >> *hwdev, phys_addr_t paddr)
> >> lib/swiotlb.c:phys_addr_t __weak swiotlb_bus_to_phys(struct device  
> >> *hwdev, dma_addr_t baddr)
> >> lib/swiotlb.c:void * __weak swiotlb_bus_to_virt(struct device *hwdev,  
> >> dma_addr_t address)
> >> lib/swiotlb.c:int __weak swiotlb_arch_address_needs_mapping(struct  
> >> device *hwdev,
> >> lib/swiotlb.c:int __weak swiotlb_arch_range_needs_mapping(phys_addr_t  
> >> paddr, size_t size)
> >>
> >> instead of #ifndef HAVE_ARCH_<FOO>.  Not sure if there is a historical  
> >> reason for that.
> >>     
> >
> > ia64 and x86_64 use swiotlb but neither need this function. And
> > neither need any above __weak. They were added for dom0 support.
> > Yeah, swiotlb is much cleaner and better if we don't add dom0 support.
> >   
> 
> Some architectures need non-trivial bus<->phys conversion routines, etc, 

Only Xen needs such conversion for swiotlb.


> so either we can require it that all architectures wishing to use 
> swiotlb define these functions, or have weak default functions that can 
> be overridden by architectures where necessary.

Can you give an example? I don't think IA64, X86_64 or POWER (which
will use swiotlb) need any __weak functions. If you say other archs
could use swiotlb, please tell me how they need these __weak.


> This isn't a specific Xen dom0 requirement, except that enabling it in 

Yes, it is.


> the config will override these functions (but now in a Xen-only file, 
> rather than affecting the normal x86 pci-swiotlb.c).

And again, x86' pci-swiotlb is much cleaner without dom0 support.
