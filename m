Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZGTO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZGTO0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZGTO0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:26:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25105 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZGTO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sYgXKOv0iHRw1vA13WGEWlrlqHtzdHctXD7vnOjoqQrycvcqqXRyaY1UioG+8l+wTg
         +uBtzNp/Si6tIxsqsFzLxl41WqtvbaAdwyqwBZSTr5foE1MbjWErpmp8vl/v8zzqM0h0
         HmUshyuhcX63HYpiLmEvCQwD7DeDXVyLCTG7I=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 1/4] ARM:dma-mapping:wrappers for dma-api
Date: Mon, 20 Jul 2009 22:25:51 +0800
Message-Id: <1248099954-6666-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
References: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/common/dmabounce.c        |   12 +++---
 arch/arm/include/asm/dma-mapping.h |   67 +++++++++++++++++++++++++++++++-----
 arch/arm/mm/dma-mapping.c          |   24 ++++++------
 3 files changed, 76 insertions(+), 27 deletions(-)

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 734ac91..15353a3 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -330,7 +330,7 @@ static inline void unmap_single(struct device *dev, dma_addr_t dma_addr,
  * substitute the safe buffer for the unsafe one.
  * (basically move the buffer from an unsafe area to a safe one)
  */
-dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+dma_addr_t __dma_map_single(struct device *dev, void *ptr, size_t size,
 		enum dma_data_direction dir)
 {
 	dev_dbg(dev, "%s(ptr=%p,size=%d,dir=%x)\n",
@@ -340,9 +340,9 @@ dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 
 	return map_single(dev, ptr, size, dir);
 }
-EXPORT_SYMBOL(dma_map_single);
+EXPORT_SYMBOL(__dma_map_single);
 
-dma_addr_t dma_map_page(struct device *dev, struct page *page,
+dma_addr_t __dma_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir)
 {
 	dev_dbg(dev, "%s(page=%p,off=%#lx,size=%zx,dir=%x)\n",
@@ -358,7 +358,7 @@ dma_addr_t dma_map_page(struct device *dev, struct page *page,
 
 	return map_single(dev, page_address(page) + offset, size, dir);
 }
-EXPORT_SYMBOL(dma_map_page);
+EXPORT_SYMBOL(__dma_map_page);
 
 /*
  * see if a mapped address was really a "safe" buffer and if so, copy
@@ -367,7 +367,7 @@ EXPORT_SYMBOL(dma_map_page);
  * should be)
  */
 
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+void __dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		enum dma_data_direction dir)
 {
 	dev_dbg(dev, "%s(ptr=%p,size=%d,dir=%x)\n",
@@ -375,7 +375,7 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	unmap_single(dev, dma_addr, size, dir);
 }
-EXPORT_SYMBOL(dma_unmap_single);
+EXPORT_SYMBOL(__dma_unmap_single);
 
 int dmabounce_sync_for_cpu(struct device *dev, dma_addr_t addr,
 		unsigned long off, size_t sz, enum dma_data_direction dir)
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index ff46dfa..0e87498 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -129,6 +129,9 @@ static inline void dma_free_noncoherent(struct device *dev, size_t size,
 {
 }
 
+extern void *__dma_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
+extern void __dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
+
 /**
  * dma_alloc_coherent - allocate consistent memory for DMA
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
@@ -140,7 +143,11 @@ static inline void dma_free_noncoherent(struct device *dev, size_t size,
  * return the CPU-viewed address, and sets @handle to be the
  * device-viewed address.
  */
-extern void *dma_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
+static inline void *dma_alloc_coherent(struct device *dev, size_t size,
+	dma_addr_t *handle, gfp_t gfp)
+{
+	return __dma_alloc_coherent(dev, size, handle, gfp);
+}
 
 /**
  * dma_free_coherent - free memory allocated by dma_alloc_coherent
@@ -155,7 +162,11 @@ extern void *dma_alloc_coherent(struct device *, size_t, dma_addr_t *, gfp_t);
  * References to memory and mappings associated with cpu_addr/handle
  * during and after this call executing are illegal.
  */
-extern void dma_free_coherent(struct device *, size_t, void *, dma_addr_t);
+static inline void dma_free_coherent(struct device *dev, size_t size,
+	void *cpu_addr, dma_addr_t handle)
+{
+	__dma_free_coherent(dev, size, cpu_addr, handle);
+}
 
 /**
  * dma_mmap_coherent - map a coherent DMA allocation into user space
@@ -255,13 +266,29 @@ extern int dma_needs_bounce(struct device*, dma_addr_t, size_t);
 /*
  * The DMA API, implemented by dmabounce.c.  See below for descriptions.
  */
-extern dma_addr_t dma_map_single(struct device *, void *, size_t,
+extern dma_addr_t __dma_map_single(struct device *, void *, size_t,
 		enum dma_data_direction);
-extern dma_addr_t dma_map_page(struct device *, struct page *,
+extern dma_addr_t __dma_map_page(struct device *, struct page *,
 		unsigned long, size_t, enum dma_data_direction);
-extern void dma_unmap_single(struct device *, dma_addr_t, size_t,
+extern void __dma_unmap_single(struct device *, dma_addr_t, size_t,
 		enum dma_data_direction);
 
+static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
+		size_t size, enum dma_data_direction dir)
+{
+	return __dma_map_single(dev, cpu_addr, size, dir);
+}
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size, enum dma_data_direction dir)
+{
+	return __dma_map_page(dev, page, offset, size, dir);
+}
+static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
+{
+	__dma_unmap_single(dev, handle, size, dir);
+}
+
 /*
  * Private functions
  */
@@ -429,15 +456,37 @@ static inline void dma_sync_single_for_device(struct device *dev,
 /*
  * The scatter list versions of the above methods.
  */
-extern int dma_map_sg(struct device *, struct scatterlist *, int,
+extern int __dma_map_sg(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
-extern void dma_unmap_sg(struct device *, struct scatterlist *, int,
+extern void __dma_unmap_sg(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
-extern void dma_sync_sg_for_cpu(struct device *, struct scatterlist *, int,
+extern void __dma_sync_sg_for_cpu(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
-extern void dma_sync_sg_for_device(struct device *, struct scatterlist *, int,
+extern void __dma_sync_sg_for_device(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
 
+static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
+		int nents, enum dma_data_direction dir)
+{
+	return __dma_map_sg(dev, sg, nents, dir);
+}
+static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+		int nents, enum dma_data_direction dir)
+{
+	 __dma_unmap_sg(dev, sg, nents, dir);
+}
+static inline void dma_sync_sg_for_cpu(struct device *dev,
+		struct scatterlist *sg, int nents,
+		enum dma_data_direction dir)
+{
+	 __dma_sync_sg_for_cpu(dev, sg, nents, dir);
+}
+static inline void dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sg, int nents,
+		enum dma_data_direction dir)
+{
+	 __dma_sync_sg_for_device(dev, sg, nents, dir);
+}
 
 #endif /* __KERNEL__ */
 #endif
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 510c179..654cd82 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -273,7 +273,7 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
  * virtual and bus address for that space.
  */
 void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
+__dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
 {
 	void *memory;
 
@@ -294,7 +294,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gf
 	return __dma_alloc(dev, size, handle, gfp,
 			   pgprot_noncached(pgprot_kernel));
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
+EXPORT_SYMBOL(__dma_alloc_coherent);
 
 /*
  * Allocate a writecombining region, in much the same way as
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(dma_mmap_writecombine);
  * free a page as defined by the above mapping.
  * Must not be called with IRQs disabled.
  */
-void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr_t handle)
+void __dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr_t handle)
 {
 	struct arm_vm_region *c;
 	unsigned long flags, addr;
@@ -444,7 +444,7 @@ void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr
 	       __func__, cpu_addr);
 	dump_stack();
 }
-EXPORT_SYMBOL(dma_free_coherent);
+EXPORT_SYMBOL(__dma_free_coherent);
 
 /*
  * Initialise the consistent memory allocation.
@@ -602,7 +602,7 @@ EXPORT_SYMBOL(dma_cache_maint_page);
  * Device ownership issues as mentioned for dma_map_single are the same
  * here.
  */
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+int __dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		enum dma_data_direction dir)
 {
 	struct scatterlist *s;
@@ -621,7 +621,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
 	return 0;
 }
-EXPORT_SYMBOL(dma_map_sg);
+EXPORT_SYMBOL(__dma_map_sg);
 
 /**
  * dma_unmap_sg - unmap a set of SG buffers mapped by dma_map_sg
@@ -633,7 +633,7 @@ EXPORT_SYMBOL(dma_map_sg);
  * Unmap a set of streaming mode DMA translations.  Again, CPU access
  * rules concerning calls here are the same as for dma_unmap_single().
  */
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
+void __dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 		enum dma_data_direction dir)
 {
 	struct scatterlist *s;
@@ -642,7 +642,7 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
 	for_each_sg(sg, s, nents, i)
 		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
 }
-EXPORT_SYMBOL(dma_unmap_sg);
+EXPORT_SYMBOL(__dma_unmap_sg);
 
 /**
  * dma_sync_sg_for_cpu
@@ -651,7 +651,7 @@ EXPORT_SYMBOL(dma_unmap_sg);
  * @nents: number of buffers to map (returned from dma_map_sg)
  * @dir: DMA transfer direction (same as was passed to dma_map_sg)
  */
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+void __dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *s;
@@ -662,7 +662,7 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 					sg_dma_len(s), dir);
 	}
 }
-EXPORT_SYMBOL(dma_sync_sg_for_cpu);
+EXPORT_SYMBOL(__dma_sync_sg_for_cpu);
 
 /**
  * dma_sync_sg_for_device
@@ -671,7 +671,7 @@ EXPORT_SYMBOL(dma_sync_sg_for_cpu);
  * @nents: number of buffers to map (returned from dma_map_sg)
  * @dir: DMA transfer direction (same as was passed to dma_map_sg)
  */
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+void __dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir)
 {
 	struct scatterlist *s;
@@ -687,4 +687,4 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 					     s->length, dir);
 	}
 }
-EXPORT_SYMBOL(dma_sync_sg_for_device);
+EXPORT_SYMBOL(__dma_sync_sg_for_device);
-- 
1.6.0.GIT

