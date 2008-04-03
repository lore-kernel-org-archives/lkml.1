Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYDCOIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYDCOIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYDCOId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:08:33 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37760 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYDCOIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:08:31 -0400
Date: Thu, 3 Apr 2008 23:07:30 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, tomof@acm.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       tony.luck@intel.com
Subject: Re: [PATCH -mm] SWIOTLB: use iommu_is_span_boundary helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080402141923.2122a8ed.akpm@linux-foundation.org>
References: <1207170155-8065-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080402141923.2122a8ed.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080403230725O.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 14:19:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu,  3 Apr 2008 06:02:35 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > iommu_is_span_boundary in lib/iommu-helper.c was exported for PARISC
> > IOMMUs (commit 3715863aa142c4f4c5208f5f3e5e9bac06006d2f). SWIOTLB can
> > use it instead of the homegrown function.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >  arch/ia64/Kconfig |    5 ++++-
> >  arch/x86/Kconfig  |    5 ++---
> >  lib/swiotlb.c     |   14 +++-----------
> >  3 files changed, 9 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> > index 53b8410..6840a13 100644
> > --- a/arch/ia64/Kconfig
> > +++ b/arch/ia64/Kconfig
> > @@ -47,6 +47,9 @@ config MMU
> >  config SWIOTLB
> >         bool
> >  
> > +config IOMMU_HELPER
> > +       bool
> > +
> >  config GENERIC_LOCKBREAK
> >  	bool
> >  	default y
> > @@ -624,7 +627,7 @@ config IRQ_PER_CPU
> >  	default y
> >  
> >  config IOMMU_HELPER
> > -	def_bool (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC)
> > +	def_bool (IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB || IA64_GENERIC || SWIOTLB)
> >  
> >  source "arch/ia64/hp/sim/Kconfig"
> >  
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 1f44517..e6c01c2 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -502,9 +502,6 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
> >  	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
> >  	  If unsure, say Y.
> >  
> > -config IOMMU_HELPER
> > -	def_bool (CALGARY_IOMMU || GART_IOMMU)
> > -
> >  # need this always selected by IOMMU for the VIA workaround
> >  config SWIOTLB
> >  	bool
> > @@ -515,6 +512,8 @@ config SWIOTLB
> >  	  access 32-bits of memory can be used on systems with more than
> >  	  3 GB of memory. If unsure, say Y.
> >  
> > +config IOMMU_HELPER
> > +	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB)
> >  
> >  config NR_CPUS
> >  	int "Maximum number of CPUs (2-255)"
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index 62c9a18..b50c7e0 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -31,6 +31,7 @@
> >  
> >  #include <linux/init.h>
> >  #include <linux/bootmem.h>
> > +#include <linux/iommu-helper.h>
> >  
> >  #define OFFSET(val,align) ((unsigned long)	\
> >  	                   ( (val) & ( (align) - 1)))
> > @@ -282,15 +283,6 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr)
> >  	return (addr & ~mask) != 0;
> >  }
> >  
> > -static inline unsigned int is_span_boundary(unsigned int index,
> > -					    unsigned int nslots,
> > -					    unsigned long offset_slots,
> > -					    unsigned long max_slots)
> > -{
> > -	unsigned long offset = (offset_slots + index) & (max_slots - 1);
> > -	return offset + nslots > max_slots;
> > -}
> > -
> >  /*
> >   * Allocates bounce buffer and returns its kernel virtual address.
> >   */
> > @@ -338,8 +330,8 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
> >  	wrap = index;
> >  
> >  	do {
> > -		while (is_span_boundary(index, nslots, offset_slots,
> > -				max_slots)) {
> > +		while (iommu_is_span_boundary(index, nslots, offset_slots,
> > +					      max_slots)) {
> >  			index += stride;
> >  			if (index >= io_tlb_nslabs)
> >  				index = 0;
> 
> Fair enough.
> 
> It's confusing that iommu_is_span_boundary() uses index, nr, shift and
> boundary_size whereas is_span_boundary() used index, nslots, offset_slots,
> and max_slots.  Which one was most accurate, clearer, etc?

I'm not sure since swiotlb uses the different wording from the other
IOMMUs. swiotlb calls an entry in an IOMMU 'slot' while the others use
something like 'page'.

shift and offset_slots are a base address (the number of entries) to
be added after adress translation.

boundary_size and max_slots are bounaries (the number of entries) that
a device (DMA) can't cross.
