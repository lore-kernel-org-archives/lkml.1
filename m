Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZFBJ2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZFBJ2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZFBJ17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:27:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57981 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZFBJ16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:27:58 -0400
X-IronPort-AV: E=Sophos;i="4.41,290,1241409600"; 
   d="scan'208";a="4498416"
Subject: Re: [PATCH 11/11] swiotlb: allow initialisation with pre-allocated
	bounce-buffer
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>, "okir@suse.de" <okir@suse.de>,
       "gregkh@suse.de" <gregkh@suse.de>, "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <20090602130023W.fujita.tomonori@lab.ntt.co.jp>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
	 <1243870383-12954-12-git-send-email-ian.campbell@citrix.com>
	 <20090602130023W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Tue, 2 Jun 2009 10:27:58 +0100
Message-ID: <1243934878.8488.44.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 00:08 -0400, FUJITA Tomonori wrote:
> Please tell me a pointer to Xen code to use this patch. I think that
> we could have more clean interfaces.

Certainly. This is the relevant bit of my current WIP patch. I'm not
happy about the interaction with the global swiotlb/swiotlb_force flags
at the moment, I was planning to spend today figuring out something
nicer (hence its WIP status).

Ian.

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 4918938..ca005d8 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -5,8 +5,11 @@
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/scatterlist.h>
+#include <linux/swiotlb.h>
+#include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/bug.h>
+#include <linux/bootmem.h>
 
 #include <xen/interface/xen.h>
 #include <xen/grant_table.h>
@@ -44,3 +47,33 @@ static phys_addr_t xen_dma_to_phys(struct device *hwdev, dma_addr_t daddr)
 	return machine_to_phys(XMADDR(daddr)).paddr;
 }
 
+
+static int max_dma_bits = 32;
+
+static void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
+{
+	int i, rc;
+	int dma_bits;
+
+	printk(KERN_DEBUG "xen_swiotlb_fixup: buf=%p size=%zu\n",
+		buf, size);
+
+	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
+
+	i = 0;
+	do {
+		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
+
+		do {
+			rc = xen_create_contiguous_region(
+				(unsigned long)buf + (i << IO_TLB_SHIFT),
+				get_order(slabs << IO_TLB_SHIFT),
+				dma_bits);
+		} while (rc && dma_bits++ < max_dma_bits);
+		if (rc)
+			panic(KERN_ERR "xen_create_contiguous_region failed\n");
+
+		i += slabs;
+	} while(i < nslabs);
+}
+
@@ -300,9 +340,42 @@ void __init xen_iommu_init(void)
 
 	dma_ops = &xen_dma_ops;
 
-	if (swiotlb) {
+	if (xen_initial_domain() || swiotlb_force) {
+		unsigned long bytes;
+		void *buffer, *overflow;
+		size_t default_size = 64 * (1<<20);	/* default to 64MB */
+
 		printk(KERN_INFO "Xen: Enabling DMA fallback to swiotlb\n");
+
+		swiotlb = 0; /* Avoid native swiotlb initialisation path. */
+		swiotlb_force = 0;
+
 		dma_ops = &xen_swiotlb_dma_ops;
+
+		if (!io_tlb_nslabs) {
+			io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
+			io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+		}
+
+		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+
+		/*
+		 * Get IO TLB memory. No need for low low pages under Xen.
+		 */
+		buffer = alloc_bootmem_pages(bytes);
+		if (!buffer)
+			panic("Cannot allocate SWIOTLB buffer");
+		xen_swiotlb_fixup(buffer, bytes, io_tlb_nslabs);
+
+		/*
+		 * Get the overflow emergency buffer
+		 */
+		overflow = alloc_bootmem(io_tlb_overflow);
+		if (!overflow)
+			panic("Cannot allocate SWIOTLB overflow buffer!\n");
+		xen_swiotlb_fixup(overflow, io_tlb_overflow, io_tlb_overflow >> IO_TLB_SHIFT);
+
+		swiotlb_init_with_buffer(bytes, buffer, overflow);
 	}
 }
 


