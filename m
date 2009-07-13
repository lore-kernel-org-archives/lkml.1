Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZGMG3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZGMG3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZGMG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:28:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:60442 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZGMG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:28:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       reif@earthlink.net, x86@kernel.org, tony.luck@intel.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/8] remove flush_write_buffers() in dma-mapping-common.h
Date: Mon, 13 Jul 2009 15:25:53 +0900
Message-Id: <1247466360-13330-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jul 2009 15:27:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This moves flush_write_buffers() in asm-generic/dma-mapping-common.h to
arch/x86/kernel/pci-nommu.c.

The purpose of this patch is that, we can avoid defining NULL
flush_write_buffers() on IA64 and SPARC.

dma-mapping-common.h is used by X86 and IA64 (and SPARC soon) but only
X86 with CONFIG_X86_OOSTORE or CONFIG_X86_PPRO_FENCE actually uses
flush_write_buffers(). CONFIG_X86_OOSTORE or CONFIG_X86_PPRO_FENCE is
usable with only kernel/pci-nommu.c (that is, not usable with other
X86 IOMMU implementations such as SWIOTLB, VT-d, etc) so we can safely
move flush_write_buffers() in asm-generic/dma-mapping-common.h to
arch/x86/kernel/pci-nommu.c.

The further discussion is:

http://lkml.org/lkml/2009/6/28/104

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-nommu.c              |   27 ++++++++++++++++++++++-----
 include/asm-generic/dma-mapping-common.h |    6 ------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 71d412a..f7eb967 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -79,12 +79,29 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static void nommu_sync_single_for_device(struct device *dev,
+			dma_addr_t addr, size_t size,
+			enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
+
+
+static void nommu_sync_sg_for_device(struct device *dev,
+			struct scatterlist *sg, int nelems,
+			enum dma_data_direction dir)
+{
+	flush_write_buffers();
+}
+
 struct dma_map_ops nommu_dma_ops = {
-	.alloc_coherent	= dma_generic_alloc_coherent,
-	.free_coherent	= nommu_free_coherent,
-	.map_sg		= nommu_map_sg,
-	.map_page	= nommu_map_page,
-	.is_phys	= 1,
+	.alloc_coherent		= dma_generic_alloc_coherent,
+	.free_coherent		= nommu_free_coherent,
+	.map_sg			= nommu_map_sg,
+	.map_page		= nommu_map_page,
+	.sync_single_for_device = nommu_sync_single_for_device,
+	.sync_sg_for_device	= nommu_sync_sg_for_device,
+	.is_phys		= 1,
 };
 
 void __init no_iommu_init(void)
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 5406a60..e694263 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -103,7 +103,6 @@ static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
 	if (ops->sync_single_for_cpu)
 		ops->sync_single_for_cpu(dev, addr, size, dir);
 	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_for_device(struct device *dev,
@@ -116,7 +115,6 @@ static inline void dma_sync_single_for_device(struct device *dev,
 	if (ops->sync_single_for_device)
 		ops->sync_single_for_device(dev, addr, size, dir);
 	debug_dma_sync_single_for_device(dev, addr, size, dir);
-	flush_write_buffers();
 }
 
 static inline void dma_sync_single_range_for_cpu(struct device *dev,
@@ -132,7 +130,6 @@ static inline void dma_sync_single_range_for_cpu(struct device *dev,
 		ops->sync_single_range_for_cpu(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_cpu(dev, addr, size, dir);
 }
@@ -150,7 +147,6 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 		ops->sync_single_range_for_device(dev, addr, offset, size, dir);
 		debug_dma_sync_single_range_for_device(dev, addr, offset, size, dir);
 
-		flush_write_buffers();
 	} else
 		dma_sync_single_for_device(dev, addr, size, dir);
 }
@@ -165,7 +161,6 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	if (ops->sync_sg_for_cpu)
 		ops->sync_sg_for_cpu(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_cpu(dev, sg, nelems, dir);
-	flush_write_buffers();
 }
 
 static inline void
@@ -179,7 +174,6 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		ops->sync_sg_for_device(dev, sg, nelems, dir);
 	debug_dma_sync_sg_for_device(dev, sg, nelems, dir);
 
-	flush_write_buffers();
 }
 
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
-- 
1.6.0.6

