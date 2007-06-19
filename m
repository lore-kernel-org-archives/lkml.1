Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXFSWT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXFSWT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbXFSWSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:18:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:50152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbXFSWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="258836655"
Message-Id: <20070619213808.798646000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 14:37:07 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de, gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: [Intel IOMMU 06/10] Avoid memory allocation failures in dma map api calls
Content-Disposition: inline; filename=intel_iommu_pf_memalloc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel IOMMU driver needs memory during DMA map calls to setup its internal
page tables and for other data structures. As we all know that these DMA 
map calls are mostly called in the interrupt context or with the spinlock 
held by the upper level drivers(network/storage drivers), so in order to 
avoid any memory allocation failure due to low memory issues,
this patch makes memory allocation by temporarily setting PF_MEMALLOC
flags for the current task before making memory allocation calls.

We evaluated mempools as a backup when kmem_cache_alloc() fails
and found that mempools are really not useful here because
 1) We don;t know for sure how much to reserve in advance
 2) And mempools are not useful for GFP_ATOMIC case (as we call 
    memory alloc functions with GFP_ATOMIC)


With PF_MEMALLOC flag set in the current->flags, the VM subsystem avoids
any watermark checks before allocating memory thus guarantee'ing the 
memory till the last free page. Further, looking at the code in 
mm/page_alloc.c in __alloc_pages() function, looks like this
flag is useful only in the non-interrupt context.

If we are in the interrupt context and memory allocation in IOMMU
driver fails for some reason, then the DMA map api's will return 
failure and it is up to the higher level drivers to retry. Suppose,
if upper level driver programs the controller with the buggy 
DMA virtual address, the IOMMU will block that DMA transaction
when that happens thus preventing any corruption to main memory.

So far in our test scenario, we were unable to create
any memory allocation failure inside dma map api calls.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/intel-iommu.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.c	2007-06-18 15:45:46.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c	2007-06-19 13:10:29.000000000 -0700
@@ -84,9 +84,31 @@
 static struct kmem_cache *iommu_devinfo_cache;
 static struct kmem_cache *iommu_iova_cache;
 
+static inline void *iommu_kmem_cache_alloc(struct kmem_cache *cachep)
+{
+	unsigned int flags;
+	void *vaddr;
+
+	/* trying to avoid low memory issues */
+	flags = current->flags & PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
+	vaddr = kmem_cache_alloc(cachep, GFP_ATOMIC);
+	current->flags &= (~PF_MEMALLOC | flags);
+	return vaddr;
+}
+
+
 static inline void *alloc_pgtable_page(void)
 {
-	return (void *)get_zeroed_page(GFP_ATOMIC);
+	unsigned int flags;
+	void *vaddr;
+
+	/* trying to avoid low memory issues */
+	flags = current->flags & PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
+	vaddr = (void *)get_zeroed_page(GFP_ATOMIC);
+	current->flags &= (~PF_MEMALLOC | flags);
+	return vaddr;
 }
 
 static inline void free_pgtable_page(void *vaddr)
@@ -96,7 +118,7 @@
 
 static inline void *alloc_domain_mem(void)
 {
-	return kmem_cache_alloc(iommu_domain_cache, GFP_ATOMIC);
+	return iommu_kmem_cache_alloc(iommu_domain_cache);
 }
 
 static inline void free_domain_mem(void *vaddr)
@@ -106,7 +128,7 @@
 
 static inline void * alloc_devinfo_mem(void)
 {
-	return kmem_cache_alloc(iommu_devinfo_cache, GFP_ATOMIC);
+	return iommu_kmem_cache_alloc(iommu_devinfo_cache);
 }
 
 static inline void free_devinfo_mem(void *vaddr)
@@ -116,7 +138,7 @@
 
 struct iova *alloc_iova_mem(void)
 {
-	return kmem_cache_alloc(iommu_iova_cache, GFP_ATOMIC);
+	return iommu_kmem_cache_alloc(iommu_iova_cache);
 }
 
 void free_iova_mem(struct iova *iova)

-- 
