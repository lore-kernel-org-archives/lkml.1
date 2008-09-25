Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYIYKmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYIYKmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYIYKmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:42:35 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10144 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbYIYKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:42:34 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7QZ2C-04-AY5-01
Date: Thu, 25 Sep 2008 12:42:12 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 3/3] x86/iommu: use __GFP_ZERO instead of memset for GART
Message-ID: <20080925104212.GA27928@amd.com>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com> <1222337635-28285-4-git-send-email-joerg.roedel@amd.com> <20080925102012.GA13631@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080925102012.GA13631@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Sep 2008 10:42:13.0009 (UTC) FILETIME=[5EA25010:01C91EFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 12:20:12PM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> >  #ifdef CONFIG_IOMMU_LEAK
> >  	if (leak_trace) {
> > -		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL,
> > +		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
> >  				  get_order(iommu_pages*sizeof(void *)));
> > -		if (iommu_leak_tab)
> > -			memset(iommu_leak_tab, 0, iommu_pages * 8);
> >  		else
> >  			printk(KERN_DEBUG
> >  			       "PCI-DMA: Cannot allocate leak trace area\n");
> 
> hm, that looks broken.

Argh, yes. Please try this one:

=
>From c402fd7f5fe930d45a02ef863bf3fb61851e6ad0 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 25 Sep 2008 12:39:06 +0200
Subject: [PATCH] x86/iommu: use __GFP_ZERO instead of memset for GART

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index aecea06..d077116 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -674,13 +674,13 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	info->aper_size = aper_size >> 20;
 
 	gatt_size = (aper_size >> PAGE_SHIFT) * sizeof(u32);
-	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size));
+	gatt = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					get_order(gatt_size));
 	if (!gatt)
 		panic("Cannot allocate GATT table");
 	if (set_memory_uc((unsigned long)gatt, gatt_size >> PAGE_SHIFT))
 		panic("Could not set GART PTEs to uncacheable pages");
 
-	memset(gatt, 0, gatt_size);
 	agp_gatt_table = gatt;
 
 	enable_gart_translations();
@@ -788,19 +788,16 @@ void __init gart_iommu_init(void)
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
-	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL,
+	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						      get_order(iommu_pages/8));
 	if (!iommu_gart_bitmap)
 		panic("Cannot allocate iommu bitmap\n");
-	memset(iommu_gart_bitmap, 0, iommu_pages/8);
 
 #ifdef CONFIG_IOMMU_LEAK
 	if (leak_trace) {
-		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL,
+		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 				  get_order(iommu_pages*sizeof(void *)));
-		if (iommu_leak_tab)
-			memset(iommu_leak_tab, 0, iommu_pages * 8);
-		else
+		if (!iommu_leak_tab)
 			printk(KERN_DEBUG
 			       "PCI-DMA: Cannot allocate leak trace area\n");
 	}
-- 
1.5.6.4


-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

