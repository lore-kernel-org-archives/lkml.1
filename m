Return-Path: <linux-kernel-owner+w=401wt.eu-S1752902AbZEUK3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbZEUK3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZEUK3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:29:18 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:21058 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbZEUK3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:29:17 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, okir@suse.de, beckyb@kernel.crashing.org
In-Reply-To: <1242901630.22654.135.camel@zakaz.uk.xensource.com>
References: <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
	 <1242748597.22654.44.camel@zakaz.uk.xensource.com>
	 <4A143885.1050502@goop.org> <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
	 <1242901630.22654.135.camel@zakaz.uk.xensource.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 11:28:53 +0100
Message-Id: <1242901733.22654.138.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Where do we stand with the Xen patches?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=GMTY6ZCfsGoA:10 a=UU1a1liyotcA:10 a=tHz9FfFoAAAA:8 a=_TPtRl0Wiwxm06zNxrQA:9 a=23P6lQeqVUxG9C5Jaf9VeYygDBEA:4 a=6O0IECtVFhoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 11:27 +0100, Ian Campbell wrote:
> The corresponding the Xen updates will...
...follow.

Subject:swiotlb/xen: add implementation of swiotlb_range_needs_mapping hook

This function is now implemented via asm/dma-mapping.h rather than as
a weak hook in swiotlb.c

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index a80139a..ed51bd1 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -315,9 +315,15 @@ static inline int is_buffer_dma_capable(struct device *dev, u64 mask,
 	return addr + size <= mask;
 }
 
+#ifdef CONFIG_PCI_XEN
+extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
+#else
+static inline int xen_range_needs_mapping(phys_addr_t paddr, size_t size) { return 0; }
+#endif
+
 static int inline swiotlb_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
-	return 0;
+	return xen_range_needs_mapping(paddr, size);
 }
 
 #endif
diff --git a/arch/x86/xen/pci-swiotlb.c b/arch/x86/xen/pci-swiotlb.c
index 5a46418..e23b00b 100644
--- a/arch/x86/xen/pci-swiotlb.c
+++ b/arch/x86/xen/pci-swiotlb.c
@@ -43,11 +43,3 @@ phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 
 	return baddr;
 }
-
-int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
-{
-	if (xen_pv_domain())
-		return xen_range_needs_mapping(paddr, size);
-
-	return 0;
-}
diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 41c276f..003ffe3 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -132,6 +132,8 @@ static int range_straddles_page_boundary(phys_addr_t p, size_t size)
 
 int xen_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
+	if (!xen_pv_domain())
+		return 0;
 	return range_straddles_page_boundary(paddr, size);
 }
 


-- 
Ian Campbell
Current Noise: Isis - Wills Dissolve

"Hey Ivan, check your six."
-- Sidewinder missile jacket patch, showing a Sidewinder driving up the tail
 of a Russian Su-27

