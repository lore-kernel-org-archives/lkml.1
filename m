Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZKQHVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZKQHVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZKQHVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:21:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53735 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZKQHVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:21:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] Revert "Intel IOMMU: Avoid memory allocation failures in dma map api calls"
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117162041.3DE5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:21:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit eb3fa7cb51 said Intel IOMMU

    Intel IOMMU driver needs memory during DMA map calls to setup its
    internal page tables and for other data structures.  As we all know
    that these DMA map calls are mostly called in the interrupt context
    or with the spinlock held by the upper level drivers(network/storage
    drivers), so in order to avoid any memory allocation failure due to
    low memory issues, this patch makes memory allocation by temporarily
    setting PF_MEMALLOC flags for the current task before making memory
    allocation calls.

    We evaluated mempools as a backup when kmem_cache_alloc() fails
    and found that mempools are really not useful here because
     1) We don't know for sure how much to reserve in advance
     2) And mempools are not useful for GFP_ATOMIC case (as we call
        memory alloc functions with GFP_ATOMIC)

    (akpm: point 2 is wrong...)

The above description doesn't justify to waste system emergency memory
at all. Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need
few memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Plus, akpm already pointed out what we should do.

Then, this patch revert it.

Cc: Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/pci/intel-iommu.c |   30 ++++--------------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1840a05..17d6f1e 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -386,31 +386,9 @@ static struct kmem_cache *iommu_domain_cache;
 static struct kmem_cache *iommu_devinfo_cache;
 static struct kmem_cache *iommu_iova_cache;
 
-static inline void *iommu_kmem_cache_alloc(struct kmem_cache *cachep)
-{
-	unsigned int flags;
-	void *vaddr;
-
-	/* trying to avoid low memory issues */
-	flags = current->flags & PF_MEMALLOC;
-	current->flags |= PF_MEMALLOC;
-	vaddr = kmem_cache_alloc(cachep, GFP_ATOMIC);
-	current->flags &= (~PF_MEMALLOC | flags);
-	return vaddr;
-}
-
-
 static inline void *alloc_pgtable_page(void)
 {
-	unsigned int flags;
-	void *vaddr;
-
-	/* trying to avoid low memory issues */
-	flags = current->flags & PF_MEMALLOC;
-	current->flags |= PF_MEMALLOC;
-	vaddr = (void *)get_zeroed_page(GFP_ATOMIC);
-	current->flags &= (~PF_MEMALLOC | flags);
-	return vaddr;
+	return (void *)get_zeroed_page(GFP_ATOMIC);
 }
 
 static inline void free_pgtable_page(void *vaddr)
@@ -420,7 +398,7 @@ static inline void free_pgtable_page(void *vaddr)
 
 static inline void *alloc_domain_mem(void)
 {
-	return iommu_kmem_cache_alloc(iommu_domain_cache);
+	return kmem_cache_alloc(iommu_domain_cache, GFP_ATOMIC);
 }
 
 static void free_domain_mem(void *vaddr)
@@ -430,7 +408,7 @@ static void free_domain_mem(void *vaddr)
 
 static inline void * alloc_devinfo_mem(void)
 {
-	return iommu_kmem_cache_alloc(iommu_devinfo_cache);
+	return kmem_cache_alloc(iommu_devinfo_cache, GFP_ATOMIC);
 }
 
 static inline void free_devinfo_mem(void *vaddr)
@@ -440,7 +418,7 @@ static inline void free_devinfo_mem(void *vaddr)
 
 struct iova *alloc_iova_mem(void)
 {
-	return iommu_kmem_cache_alloc(iommu_iova_cache);
+	return kmem_cache_alloc(iommu_iova_cache, GFP_ATOMIC);
 }
 
 void free_iova_mem(struct iova *iova)
-- 
1.6.2.5



