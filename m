Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZLMX54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZLMX54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZLMX5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbZLMX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:47 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
       gregkh@suse.de, hpa@zytor.com, torvalds@linux-foundation.org
Subject: [PATCH 09/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:24 +0100
Message-Id: <48723dccdb6e229e9db99ffa98a8078e1d893d12.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/include/asm/device.h      |    2 +-
 arch/x86/include/asm/dma-mapping.h |   10 +++++-----
 arch/x86/include/asm/iommu.h       |    4 +++-
 arch/x86/kernel/amd_iommu.c        |    2 +-
 arch/x86/kernel/pci-calgary_64.c   |    2 +-
 arch/x86/kernel/pci-dma.c          |    4 ++--
 arch/x86/kernel/pci-gart_64.c      |    2 +-
 arch/x86/kernel/pci-nommu.c        |    2 +-
 arch/x86/kernel/pci-swiotlb.c      |    2 +-
 9 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 029f230..0b9b1b3 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -6,7 +6,7 @@ struct dev_archdata {
 	void	*acpi_handle;
 #endif
 #ifdef CONFIG_X86_64
-struct dma_map_ops *dma_ops;
+	const struct dma_map_ops *dma_ops;
 #endif
 #if defined(CONFIG_DMAR) || defined(CONFIG_AMD_IOMMU)
 	void *iommu; /* hook for IOMMU specific extension */
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 0f6c02f..335d2db 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -26,9 +26,9 @@ extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 
-extern struct dma_map_ops *dma_ops;
+extern const struct dma_map_ops *dma_ops;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #ifdef CONFIG_X86_32
 	return dma_ops;
@@ -45,7 +45,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
@@ -123,7 +123,7 @@ static inline void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	void *memory;
 
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
@@ -150,7 +150,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *vaddr, dma_addr_t bus)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	WARN_ON(irqs_disabled());       /* for portability */
 
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 345c99c..8b13915 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -1,7 +1,9 @@
 #ifndef _ASM_X86_IOMMU_H
 #define _ASM_X86_IOMMU_H
 
-extern struct dma_map_ops nommu_dma_ops;
+extern void pci_iommu_shutdown(void);
+extern void no_iommu_init(void);
+extern const struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int iommu_pass_through;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b990b5c..c3db8bb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2205,7 +2205,7 @@ static void prealloc_protection_domains(void)
 	}
 }
 
-static struct dma_map_ops amd_iommu_dma_ops = {
+static const struct dma_map_ops amd_iommu_dma_ops = {
 	.alloc_coherent = alloc_coherent,
 	.free_coherent = free_coherent,
 	.map_page = map_page,
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index c563e4c..1a7d201 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -470,7 +470,7 @@ static void calgary_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
-static struct dma_map_ops calgary_dma_ops = {
+static const struct dma_map_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.free_coherent = calgary_free_coherent,
 	.map_sg = calgary_map_sg,
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index afcc58b..49cb25b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -15,7 +15,7 @@
 
 static int forbid_dac __read_mostly;
 
-struct dma_map_ops *dma_ops = &nommu_dma_ops;
+const struct dma_map_ops *dma_ops = &nommu_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -238,7 +238,7 @@ early_param("iommu", iommu_setup);
 
 int dma_supported(struct device *dev, u64 mask)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index e6a0d40..2752c6f 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -695,7 +695,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-static struct dma_map_ops gart_dma_ops = {
+static const struct dma_map_ops gart_dma_ops = {
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
 	.map_page			= gart_map_page,
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 22be12b..c17b32c 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -94,7 +94,7 @@ static void nommu_sync_sg_for_device(struct device *dev,
 	flush_write_buffers();
 }
 
-struct dma_map_ops nommu_dma_ops = {
+const struct dma_map_ops nommu_dma_ops = {
 	.alloc_coherent		= dma_generic_alloc_coherent,
 	.free_coherent		= nommu_free_coherent,
 	.map_sg			= nommu_map_sg,
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index e3c0a66..a5e3ec9 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -25,7 +25,7 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-static struct dma_map_ops swiotlb_dma_ops = {
+static const struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
-- 
1.6.5.3

