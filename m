Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbZDIM1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbZDIM1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDIM1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:27:24 -0400
Received: from 8bytes.org ([88.198.83.132]:44840 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596AbZDIM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:27:23 -0400
Date: Thu, 9 Apr 2009 14:27:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Enable GART-IOMMU only after setting up protection
	methods
Message-ID: <20090409122720.GB12440@8bytes.org>
References: <200903171457.25582.mark.langsdorf@amd.com> <200904081608.55746.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904081608.55746.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 04:08:55PM -0500, Mark Langsdorf wrote:
> The current code to set up the GART as an IOMMU enables GART
> translations before it removes the aperture from the kernel
> memory map, sets the GART PTEs to UC, sets up the guard and
> scratch pages, or does a wbinvd().  This leaves the possibility
> of cache aliasing open and can cause system crashes.

This patch looks broken.  I don't think that there are any aliasing
problems in the existing code.  Can you elaborate were do you see these
problems? Is there any existing bug report for this?

> Re-order the code and add tlbflush so as to enable the 
> GART translations only after all safeguards are in place and
> the tlb has been flushed.
> 
> AMD has tested this patch and seen no adverse effects.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> diff -r 0d1744c7acc7 arch/x86/kernel/pci-gart_64.c
> --- a/arch/x86/kernel/pci-gart_64.c	Fri Mar 27 16:47:28 2009 -0500
> +++ b/arch/x86/kernel/pci-gart_64.c	Mon Mar 30 15:05:47 2009 -0500
> @@ -38,6 +38,7 @@
>  #include <asm/swiotlb.h>
>  #include <asm/dma.h>
>  #include <asm/k8.h>
> +#include <asm/tlbflush.h>
>  
>  static unsigned long iommu_bus_base;	/* GART remapping area (physical) */
>  static unsigned long iommu_size;	/* size of remapping area bytes */
> @@ -682,9 +683,9 @@
>  	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
>  		panic("Could not set GART PTEs to uncacheable pages");
>  
> +	wbinvd();
> +
>  	agp_gatt_table = gatt;
> -
> -	enable_gart_translations();

To enable the GART here has the advantage that all other CPUs are not
yet up. Since the GATT has only non-present entries there is no cache
aliasing problem here. If you enable it later you need to flush the
cache on _all_ CPUs and not just the CPU where the GART initialization
code runs.

>  
>  	error = sysdev_class_register(&gart_sysdev_class);
>  	if (!error)
> @@ -855,6 +856,11 @@
>  	for (i = EMERGENCY_PAGES; i < iommu_pages; i++)
>  		iommu_gatt_base[i] = gart_unmapped_entry;
>  
> +	wbinvd();

Why a wbinvd() here? A few lines above is already one.

> +	flush_tlb_all();

Same with TLB flush. The set_memory_np() function does that for us.

> +
> +	enable_gart_translations();
> +

If we change the enablement logic like done in this patch you need to
invalidate the caches on _all_ cpus. I don't think this is necessary if
we just enable all GARTs when only the boot cpu is up.

>  	flush_gart();
>  	dma_ops = &gart_dma_ops;
>  }
