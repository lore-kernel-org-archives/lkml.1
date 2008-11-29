Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYK2Ne0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYK2Ne0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYK2NeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:34:17 -0500
Received: from elvis.franken.de ([193.175.24.41]:56751 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYK2NeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:34:16 -0500
X-Greylist: delayed 2860 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Nov 2008 08:34:16 EST
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH v3] Fix dma_mapping_error for 32bit x86
To: linux-kernel@vger.kernel.org
Message-Id: <20081129124627.F2ABDFA8C8@solo.franken.de>
Date: Sat, 29 Nov 2008 13:46:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices like b44 ethernet can't dma from addresses above 1GB. The driver
handles this cases by falling back to GFP_DMA allocation. But for detecting
the problem it needs to get an indication from dma_mapping_error.
The bug is triggered by using a VMSPLIT option of 2G/2G.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---


diff -ru orig/linux-2.6.27.4/include/asm-x86/dma-mapping.h linux-2.6.27.4/include/asm-x86/dma-mapping.h
--- orig/linux-2.6.27.4/include/asm-x86/dma-mapping.h	2008-10-26 00:05:07.000000000 +0200
+++ linux-2.6.27.4/include/asm-x86/dma-mapping.h	2008-10-26 11:06:14.000000000 +0100
@@ -74,15 +74,13 @@
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-#ifdef CONFIG_X86_32
-	return 0;
-#else
+#ifdef CONFIG_X86_64
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-	return (dma_addr == bad_dma_address);
 #endif
+	return (dma_addr == bad_dma_address);
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
