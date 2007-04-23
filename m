Return-Path: <linux-kernel-owner+w=401wt.eu-S965693AbXDWJnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbXDWJnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 05:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965694AbXDWJnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 05:43:32 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:31807 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965693AbXDWJnb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 05:43:31 -0400
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: make GART PTEs uncacheable
Date: Mon, 23 Apr 2007 11:45:11 +0200
User-Agent: KMail/1.9.5
cc: linux-kernel@vger.kernel.org, "Langsdorf, Mark" <mark.langsdorf@amd.com>
References: <200704231114.10327.joachim.deguara@amd.com>
 <200704231132.30736.ak@suse.de>
In-Reply-To: <200704231132.30736.ak@suse.de>
MIME-Version: 1.0
Message-ID: <200704231145.11806.joachim.deguara@amd.com>
X-OriginalArrivalTime: 23 Apr 2007 09:43:15.0867 (UTC)
 FILETIME=[D11D86B0:01C7858B]
X-WSS-ID: 6A32A0321SK68974-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 11:32, Andi Kleen wrote:
> On Monday 23 April 2007 11:14:10 Joachim Deguara wrote:
> > This patches fixes the silent data corruption problems being seen using
> > the GART iommu where 4kB of data where incorrect (seen mostly on Nvidia
> > CK804 systems).
>
> Performance numbers? How much slower does this make this? Is it still
> faster than swiotlb?

I can work on that as a side note, but while the GART IOMMU is still in the 
kernel then we need this fix.

> Also this will always split up the direct memory mapping of the kernel,
> so you'll lose more TLB entries even for other data.
>
> > This fix, to mark the memory regin the GART PTEs reside on as
> > uncacheable, also brings the code in line with the AGP specification.
>
> Where in the AGP specification? I can't find any such requirement
> in AGPv3
>

Mark pointed this out and he can answer best.  I believe he was referring to 
section 5.3.4 point 8:
"Core-logic accesses to the GART are not guaranteed to be coherent with host 
processor caches. In
order to avoid having to flush the cache after every GART update, portable 
system software should
place the GART in a range of the physical memory space that is considered 
un-cacheable by host
processors. (A good example is mapping the GART as UC in an IntelÒ PentiumÒ II 
processor).
However, the specification does not preclude the placement of the GART in 
cachable memory
space in cases where the coherency is guaranteed through some hardware or 
software
mechanism."

updated patch follows with corrected long lone.

-Joachim

---
This patches fixes the silent data corruption problems being seen using the 
GART iommu where 4kB of data where incorrect (seen mostly on Nvidia CK804 
systems).  This fix to mark the memory regin the GART PTEs reside on as 
uncacheable also brings the code in line with the AGP specification.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>

---
 
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index 2bac8c6..8fb4957 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -519,7 +519,12 @@ static __init int init_k8_gatt(struct ag
 	gatt_size = (aper_size >> PAGE_SHIFT) * sizeof(u32); 
 	gatt = (void *)__get_free_pages(GFP_KERNEL, get_order(gatt_size)); 
 	if (!gatt) 
-		panic("Cannot allocate GATT table"); 
+		panic("Cannot allocate GATT table");
+	if (change_page_attr_addr((unsigned long)gatt, gatt_size >> PAGE_SHIFT,
+				PAGE_KERNEL_NOCACHE))
+		panic("Could not set GART PTEs to uncacheable pages");
+	global_flush_tlb();
+
 	memset(gatt, 0, gatt_size); 
 	agp_gatt_table = gatt;
 


