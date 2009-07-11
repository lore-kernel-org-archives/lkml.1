Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZGKQIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZGKQIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 12:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZGKQIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 12:08:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:40904 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbZGKQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 12:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FrGNCpJ0U7avL9kleHWsV29PqIKknfHYHxoCuMlkpfGRDFxy/7dWFJY3GdAtTytjET
         7yLlZ70ELSLgT1xImWFmPem/ZLZWwkWR3CFXUOuU1po8WM/WdyU3ZhGbMbxKcFC3GSPJ
         RrA3DuKKorECWxSmSFOMgnyEiKZYwTJOJ+pcQ=
From: tom.leiming@gmail.com
To: linux@arm.linux.org.uk, joerg.roedel@amd.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/3] ARM:dma-mapping:only provide one set of dma-api wrappers
Date: Sun, 12 Jul 2009 00:07:46 +0800
Message-Id: <1247328467-24985-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1247328467-24985-2-git-send-email-tom.leiming@gmail.com>
References: <1247328467-24985-1-git-send-email-tom.leiming@gmail.com>
 <1247328467-24985-2-git-send-email-tom.leiming@gmail.com>
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

