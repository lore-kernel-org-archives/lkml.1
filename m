Return-Path: <linux-kernel-owner+w=401wt.eu-S1422697AbXBURDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422697AbXBURDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422699AbXBURDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:03:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422697AbXBURDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:03:34 -0500
Date: Wed, 21 Feb 2007 12:03:27 -0500 (EST)
From: Chip Coldwell <coldwell@redhat.com>
To: linux-kernel@vger.kernel.org
cc: Andi Kleen <ak@suse.de>, Andy Currid <Acurrid@nvidia.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joe Moriarty <Joe.Moriarty@Sun.COM>, Russ Doty <rdoty@redhat.com>,
       Lonni Friedman <lfriedman@nvidia.com>,
       Thorsten Kellermann <Thorsten.Kellermann@Sun.COM>
Subject: Re: data corruption with nvidia chipsets and IDE/SATA drives (k8
 cpu errata needed?)
In-Reply-To: <200701170829.54540.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0702211144430.10805@bogart.boston.redhat.com>
References: <fa.E9jVXDLMKzMZNCbslzUxjMhsInE@ifi.uio.no> <45AD2D00.2040904@scientia.net>
 <20070116203143.GA4213@tuatara.stupidest.org> <200701170829.54540.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007, Andi Kleen wrote:

> On Wednesday 17 January 2007 07:31, Chris Wedgwood wrote:
> > On Tue, Jan 16, 2007 at 08:52:32PM +0100, Christoph Anton Mitterer wrote:
> > > I agree,... it seems drastic, but this is the only really secure
> > > solution.
> >
> > I'd like to here from Andi how he feels about this?  It seems like a
> > somewhat drastic solution in some ways given a lot of hardware doesn't
> > seem to be affected (or maybe in those cases it's just really hard to
> > hit, I don't know).
> 
> AMD is looking at the issue. Only Nvidia chipsets seem to be affected,
> although there were similar problems on VIA in the past too.
> Unless a good workaround comes around soon I'll probably default
> to iommu=soft on Nvidia.

We (Sun, AMD, Nvidia and Red Hat) have been testing a patch that seems
to solve the problem.  AMD and Nvidia analyzed an HDT trace that
seemed to indicate that CPU updates of the GATT were still in cache
when a subsequent table walk caused by a device load used a stale GATT
PTE.  That analysis inspired this patch, submitted to this list as an
RFC.  It is not obvious (to me, at least) why this problem has only
shown up on Nvidia SATA controllers.

We are continuing to investigate.

diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 030eb37..1dd461a 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -69,6 +69,8 @@ static u32 gart_unmapped_entry;
 #define AGPEXTERN
 #endif
 
+#define GATT_CLFLUSH(i) asm volatile ("clflush (%0)" :: "r" (iommu_gatt_base + (i)))
+
 /* backdoor interface to AGP driver */
 AGPEXTERN int agp_memory_reserved;
 AGPEXTERN __u32 *agp_gatt_table;
@@ -221,6 +223,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = GPTE_ENCODE(phys_mem);
 		SET_LEAK(iommu_page + i);
+		GATT_CLFLUSH(iommu_page + i);
 		phys_mem += PAGE_SIZE;
 	}
 	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
@@ -348,6 +351,7 @@ static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
 		while (pages--) { 
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr); 
 			SET_LEAK(iommu_page);
+			GATT_CLFLUSH(iommu_page);
 			addr += PAGE_SIZE;
 			iommu_page++;
 		}


Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

