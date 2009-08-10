Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZHJIri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZHJIri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZHJIrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:47:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:46638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZHJIrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:47:35 -0400
Date: Mon, 10 Aug 2009 08:46:26 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249872797-1314-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249872797-1314-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Subject: [tip:core/iommu] dma-ops: Remove flush_write_buffers() in dma-mapping-common.h
Message-ID: <tip-a8ad568dd8ca122aa8048ea067d3599820d1c1b4@git.kernel.org>
Git-Commit-ID: a8ad568dd8ca122aa8048ea067d3599820d1c1b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 08:46:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8ad568dd8ca122aa8048ea067d3599820d1c1b4
Gitweb:     http://git.kernel.org/tip/a8ad568dd8ca122aa8048ea067d3599820d1c1b4
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Mon, 10 Aug 2009 11:53:10 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 09:34:57 +0200

dma-ops: Remove flush_write_buffers() in dma-mapping-common.h

This moves flush_write_buffers() in
asm-generic/dma-mapping-common.h to
arch/x86/kernel/pci-nommu.c.

The purpose of this patch is that, we can avoid defining NULL
flush_write_buffers() on IA64 and SPARC.

dma-mapping-common.h is used by X86 and IA64 (and SPARC soon)
but only X86 with CONFIG_X86_OOSTORE or CONFIG_X86_PPRO_FENCE
actually uses flush_write_buffers(). CONFIG_X86_OOSTORE or
CONFIG_X86_PPRO_FENCE is usable with only kernel/pci-nommu.c
(that is, not usable with other X86 IOMMU implementations such
as SWIOTLB, VT-d, etc) so we can safely move
flush_write_buffers() in asm-generic/dma-mapping-common.h to
arch/x86/kernel/pci-nommu.c.

The further discussion is:

  http://lkml.org/lkml/2009/6/28/104

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net
Cc: tony.luck@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1249872797-1314-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/pci-nommu.c              |   27 ++++++++++++++++++++++-----
 include/asm-generic/dma-mapping-common.h |    6 ------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index c0a4222..a3933d4 100644
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
