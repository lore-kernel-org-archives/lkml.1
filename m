Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbYDHQbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbYDHQbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758720AbYDHQ2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758704AbYDHQ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:35 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 16/28] x86: isolate coherent mapping functions
Date: Tue,  8 Apr 2008 13:20:58 -0300
Message-Id: <12076717773700-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 implements the declare coherent memory API, and x86_64 does not
it is reflected in pieces of dma_alloc_coherent and dma_free_coherent.
Those pieces are isolated in separate functions, that are declared
as empty macros in x86_64. This way we can make the code the same.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |   51 ++++++++++++++++++++++++++++-------------
 arch/x86/kernel/pci-dma_64.c |   11 ++++++++-
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 818d95e..78c7640 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -18,27 +18,50 @@
 dma_addr_t bad_dma_address __read_mostly = 0x0;
 EXPORT_SYMBOL(bad_dma_address);
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t gfp)
+static int dma_alloc_from_coherent_mem(struct device *dev, ssize_t size,
+				       dma_addr_t *dma_handle, void **ret)
 {
-	void *ret;
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
-	/* ignore region specifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
 	if (mem) {
 		int page = bitmap_find_free_region(mem->bitmap, mem->size,
 						     order);
 		if (page >= 0) {
 			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(ret, 0, size);
-			return ret;
+			*ret = mem->virt_base + (page << PAGE_SHIFT);
+			memset(*ret, 0, size);
 		}
 		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			return NULL;
+			*ret = NULL;
+	}
+	return (mem != NULL);
+}
+
+static int dma_release_coherent(struct device *dev, int order, void *vaddr)
+{
+	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
+
+	if (mem && vaddr >= mem->virt_base && vaddr <
+		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
+		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
+
+		bitmap_release_region(mem->bitmap, page, order);
+		return 1;
 	}
+	return 0;
+}
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			   dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *ret = NULL;
+	int order = get_order(size);
+	/* ignore region specifiers */
+	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
+
+	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &ret))
+		return ret;
 
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
@@ -56,15 +79,11 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle)
 {
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
 	WARN_ON(irqs_disabled());	/* for portability */
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else
-		free_pages((unsigned long)vaddr, order);
+	if (dma_release_coherent(dev, order, vaddr))
+		return;
+	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index e7d45cf..6eacd58 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -39,6 +39,8 @@ dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
 	return page ? page_address(page) : NULL;
 }
 
+#define dma_alloc_from_coherent_mem(dev, size, handle, ret) (0)
+#define dma_release_coherent(dev, order, vaddr) (0)
 /*
  * Allocate memory for a coherent mapping.
  */
@@ -50,6 +52,10 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	unsigned long dma_mask = 0;
 	u64 bus;
 
+
+	if (dma_alloc_from_coherent_mem(dev, size, dma_handle, &memory))
+		return memory;
+
 	if (!dev)
 		dev = &fallback_dev;
 	dma_mask = dev->coherent_dma_mask;
@@ -141,9 +147,12 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t bus)
 {
+	int order = get_order(size);
 	WARN_ON(irqs_disabled());	/* for portability */
+	if (dma_release_coherent(dev, order, vaddr))
+		return;
 	if (dma_ops->unmap_single)
 		dma_ops->unmap_single(dev, bus, size, 0);
-	free_pages((unsigned long)vaddr, get_order(size));
+	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
-- 
1.5.0.6

