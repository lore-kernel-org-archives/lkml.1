Return-Path: <linux-kernel-owner+w=401wt.eu-S935790AbYBVOYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935790AbYBVOYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761666AbYBVOXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:23:35 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:64444 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760768AbYBVOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:23:33 -0500
From: Andi Kleen <ak@suse.de>
References: <20080222323.714291012@suse.de>
In-Reply-To: <20080222323.714291012@suse.de>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [3/3] Remove dmam_{declare,release}_coherent_memory
Message-Id: <20080222142330.DDE091B4178@basil.firstfloor.org>
Date: Fri, 22 Feb 2008 15:23:30 +0100 (CET)
X-OriginalArrivalTime: 22 Feb 2008 14:17:05.0790 (UTC) FILETIME=[9A1A91E0:01C8755D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No callers in tree, so get rid of them.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/linux/dma-mapping.h
===================================================================
--- linux.orig/include/linux/dma-mapping.h
+++ linux/include/linux/dma-mapping.h
@@ -128,22 +128,5 @@ extern void *dmam_alloc_noncoherent(stru
 				    dma_addr_t *dma_handle, gfp_t gfp);
 extern void dmam_free_noncoherent(struct device *dev, size_t size, void *vaddr,
 				  dma_addr_t dma_handle);
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-					dma_addr_t device_addr, size_t size,
-					int flags);
-extern void dmam_release_declared_memory(struct device *dev);
-#else /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
-static inline int dmam_declare_coherent_memory(struct device *dev,
-				dma_addr_t bus_addr, dma_addr_t device_addr,
-				size_t size, gfp_t gfp)
-{
-	return 0;
-}
-
-static inline void dmam_release_declared_memory(struct device *dev)
-{
-}
-#endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
 #endif
Index: linux/drivers/base/dma-mapping.c
===================================================================
--- linux.orig/drivers/base/dma-mapping.c
+++ linux/drivers/base/dma-mapping.c
@@ -161,58 +161,3 @@ void dmam_free_noncoherent(struct device
 				&match_data));
 }
 EXPORT_SYMBOL(dmam_free_noncoherent);
-
-#ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-
-static void dmam_coherent_decl_release(struct device *dev, void *res)
-{
-	dma_release_declared_memory(dev);
-}
-
-/**
- * dmam_declare_coherent_memory - Managed dma_declare_coherent_memory()
- * @dev: Device to declare coherent memory for
- * @bus_addr: Bus address of coherent memory to be declared
- * @device_addr: Device address of coherent memory to be declared
- * @size: Size of coherent memory to be declared
- * @flags: Flags
- *
- * Managed dma_declare_coherent_memory().
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int dmam_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				 dma_addr_t device_addr, size_t size, int flags)
-{
-	void *res;
-	int rc;
-
-	res = devres_alloc(dmam_coherent_decl_release, 0, GFP_KERNEL);
-	if (!res)
-		return -ENOMEM;
-
-	rc = dma_declare_coherent_memory(dev, bus_addr, device_addr, size,
-					 flags);
-	if (rc == 0)
-		devres_add(dev, res);
-	else
-		devres_free(res);
-
-	return rc;
-}
-EXPORT_SYMBOL(dmam_declare_coherent_memory);
-
-/**
- * dmam_release_declared_memory - Managed dma_release_declared_memory().
- * @dev: Device to release declared coherent memory for
- *
- * Managed dmam_release_declared_memory().
- */
-void dmam_release_declared_memory(struct device *dev)
-{
-	WARN_ON(devres_destroy(dev, dmam_coherent_decl_release, NULL, NULL));
-}
-EXPORT_SYMBOL(dmam_release_declared_memory);
-
-#endif
