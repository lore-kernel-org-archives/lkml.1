Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYIKJLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYIKJLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 05:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYIKJK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 05:10:58 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:17332 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYIKJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 05:10:57 -0400
X-BigFish: VPS-33(zz1432R98dR936eQ1805M936fQ873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K70XHU-04-HS2-01
Date: Thu, 11 Sep 2008 11:10:00 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080911091000.GI24392@amd.com>
References: <20080910135347.GI6329@amd.com> <20080910232446O.fujita.tomonori@lab.ntt.co.jp> <20080910143818.GA31506@8bytes.org> <20080910234510S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080910234510S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 11 Sep 2008 09:10:01.0007 (UTC) FILETIME=[2B854BF0:01C913EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:45:34PM +0900, FUJITA Tomonori wrote:
> On Wed, 10 Sep 2008 16:38:18 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> > Ok, thats a valid point. I queue your patch with the AMD IOMMU updates
> > for 2.6.28. Thanks.
> 
> Ingo already has queued it his tree, I think.

I asked Ingo to remove it from his tree to avoid merge conflicts with
updates I am currently preparing. Here is the patch I queued into my
2.6.28 update chain.

Joerg

===
commit 42a7fa8d8a7f1680cba76e4824dba30bfd1c9d70
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Wed Sep 10 20:19:40 2008 +0900

    x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
    
    x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
    up the gfp flag according to the device dma_mask but AMD IOMMU doesn't
    need it for devices that the IOMMU can do virtual mappings for. This
    patch avoids unnecessary low zone allocation.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ae38b24..09261dc 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1360,6 +1360,9 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	if (!check_device(dev))
 		return NULL;
 
+	if (!get_device_resources(dev, &iommu, &domain, &devid))
+		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
 		return 0;
@@ -1367,8 +1370,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	memset(virt_addr, 0, size);
 	paddr = virt_to_phys(virt_addr);
 
-	get_device_resources(dev, &iommu, &domain, &devid);
-
 	if (!iommu || !domain) {
 		*dma_addr = (dma_addr_t)paddr;
 		return virt_addr;

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

