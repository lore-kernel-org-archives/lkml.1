Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZGTO04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZGTO04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZGTO0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:26:55 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:33655 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZGTO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MkItDoVygklFsAKnpwO3yPMDYLB6Sa37NKsdfpP1ROe0XXC0mge4ehZ4svZXTE5+GG
         +/U9zcIT2h05sBYXvGNh2Sy22IlSYc8qwTOI995xkNlhE79pC/bbzdV9mIuQ++fzyd/d
         S2uxwtt+UtoUR9+XEXS5cboxNR8vZy/7KqGIE=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 2/4] ARM:dma-mapping:only provide one set of dma-api wrappers
Date: Mon, 20 Jul 2009 22:25:52 +0800
Message-Id: <1248099954-6666-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248099954-6666-2-git-send-email-tom.leiming@gmail.com>
References: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
 <1248099954-6666-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/include/asm/dma-mapping.h |   53 +++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 0e87498..86f2964 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -273,22 +273,6 @@ extern dma_addr_t __dma_map_page(struct device *, struct page *,
 extern void __dma_unmap_single(struct device *, dma_addr_t, size_t,
 		enum dma_data_direction);
 
-static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
-		size_t size, enum dma_data_direction dir)
-{
-	return __dma_map_single(dev, cpu_addr, size, dir);
-}
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-		unsigned long offset, size_t size, enum dma_data_direction dir)
-{
-	return __dma_map_page(dev, page, offset, size, dir);
-}
-static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir)
-{
-	__dma_unmap_single(dev, handle, size, dir);
-}
-
 /*
  * Private functions
  */
@@ -309,6 +293,28 @@ static inline int dmabounce_sync_for_device(struct device *d, dma_addr_t addr,
 	return 1;
 }
 
+static inline dma_addr_t __dma_map_single(struct device *dev, void *cpu_addr,
+		size_t size, enum dma_data_direction dir)
+{
+	if (!arch_is_coherent())
+		dma_cache_maint(cpu_addr, size, dir);
+
+	return virt_to_dma(dev, cpu_addr);
+}
+static inline dma_addr_t __dma_map_page(struct device *dev, struct page *page,
+	     unsigned long offset, size_t size, enum dma_data_direction dir)
+{
+	if (!arch_is_coherent())
+		dma_cache_maint_page(page, offset, size, dir);
+
+	return page_to_dma(dev, page) + offset;
+}
+static inline void __dma_unmap_single(struct device *dev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
+{
+	/* nothing to do */
+}
+#endif /* CONFIG_DMABOUNCE */
 
 /**
  * dma_map_single - map a single buffer for streaming DMA
@@ -328,11 +334,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
 		size_t size, enum dma_data_direction dir)
 {
 	BUG_ON(!valid_dma_direction(dir));
-
-	if (!arch_is_coherent())
-		dma_cache_maint(cpu_addr, size, dir);
-
-	return virt_to_dma(dev, cpu_addr);
+	return __dma_map_single(dev, cpu_addr, size, dir);
 }
 
 /**
@@ -353,11 +355,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir)
 {
 	BUG_ON(!valid_dma_direction(dir));
-
-	if (!arch_is_coherent())
-		dma_cache_maint_page(page, offset, size, dir);
-
-	return page_to_dma(dev, page) + offset;
+	return __dma_map_page(dev, page, offset, size, dir);
 }
 
 /**
@@ -377,9 +375,8 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
 static inline void dma_unmap_single(struct device *dev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir)
 {
-	/* nothing to do */
+	__dma_unmap_single(dev, handle, size, dir);
 }
-#endif /* CONFIG_DMABOUNCE */
 
 /**
  * dma_unmap_page - unmap a buffer previously mapped through dma_map_page()
-- 
1.6.0.GIT

