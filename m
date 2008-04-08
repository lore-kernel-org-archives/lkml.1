Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYDHQbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYDHQbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758564AbYDHQ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbYDHQ2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:12 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 14/28] x86: merge iommu initialization parameters
Date: Tue,  8 Apr 2008 13:20:56 -0300
Message-Id: <12076717633226-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we merge the iommu initialization parameters in pci-dma.c
Nice thing, that both architectures at least recognize the same
parameters.

usedac i386 parameter is marked for deprecation

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 Documentation/feature-removal-schedule.txt |    7 +++
 arch/x86/kernel/pci-dma.c                  |   81 ++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c               |   12 ----
 arch/x86/kernel/pci-dma_64.c               |   79 ---------------------------
 include/asm-x86/dma-mapping.h              |    1 +
 5 files changed, 89 insertions(+), 91 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1092b2e..537c88b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -306,3 +306,10 @@ Why:	Not used in-tree. The current out-of-tree users used it to
 	code / infrastructure should be in the kernel and not in some
 	out-of-tree driver.
 Who:	Thomas Gleixner <tglx@linutronix.de>
+
+----------------------------
+
+What:	usedac i386 kernel parameter
+When:	2.6.27
+Why:	replaced by allowdac and no dac combination
+Who:	Glauber Costa <gcosta@redhat.com>
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4289a9b..e04f42c 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -24,6 +24,18 @@ int panic_on_overflow __read_mostly = 0;
 int force_iommu __read_mostly = 0;
 #endif
 
+int iommu_merge __read_mostly = 0;
+
+int no_iommu __read_mostly;
+/* Set this to 1 if there is a HW IOMMU in the system */
+int iommu_detected __read_mostly = 0;
+
+/* This tells the BIO block layer to assume merging. Default to off
+   because we cannot guarantee merging later. */
+int iommu_bio_merge __read_mostly = 0;
+EXPORT_SYMBOL(iommu_bio_merge);
+
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
@@ -183,3 +195,72 @@ void __init pci_iommu_alloc(void)
 #endif
 }
 #endif
+
+/*
+ * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
+ * documentation.
+ */
+static __init int iommu_setup(char *p)
+{
+	iommu_merge = 1;
+
+	if (!p)
+		return -EINVAL;
+
+	while (*p) {
+		if (!strncmp(p, "off", 3))
+			no_iommu = 1;
+		/* gart_parse_options has more force support */
+		if (!strncmp(p, "force", 5))
+			force_iommu = 1;
+		if (!strncmp(p, "noforce", 7)) {
+			iommu_merge = 0;
+			force_iommu = 0;
+		}
+
+		if (!strncmp(p, "biomerge", 8)) {
+			iommu_bio_merge = 4096;
+			iommu_merge = 1;
+			force_iommu = 1;
+		}
+		if (!strncmp(p, "panic", 5))
+			panic_on_overflow = 1;
+		if (!strncmp(p, "nopanic", 7))
+			panic_on_overflow = 0;
+		if (!strncmp(p, "merge", 5)) {
+			iommu_merge = 1;
+			force_iommu = 1;
+		}
+		if (!strncmp(p, "nomerge", 7))
+			iommu_merge = 0;
+		if (!strncmp(p, "forcesac", 8))
+			iommu_sac_force = 1;
+		if (!strncmp(p, "allowdac", 8))
+			forbid_dac = 0;
+		if (!strncmp(p, "nodac", 5))
+			forbid_dac = -1;
+		if (!strncmp(p, "usedac", 6)) {
+			forbid_dac = -1;
+			return 1;
+		}
+#ifdef CONFIG_SWIOTLB
+		if (!strncmp(p, "soft", 4))
+			swiotlb = 1;
+#endif
+
+#ifdef CONFIG_GART_IOMMU
+		gart_parse_options(p);
+#endif
+
+#ifdef CONFIG_CALGARY_IOMMU
+		if (!strncmp(p, "calgary", 7))
+			use_calgary = 1;
+#endif /* CONFIG_CALGARY_IOMMU */
+
+		p += strcspn(p, ",");
+		if (*p == ',')
+			++p;
+	}
+	return 0;
+}
+early_param("iommu", iommu_setup);
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 1d4091a..eea52df 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -153,15 +153,3 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 	return mem->virt_base + (pos << PAGE_SHIFT);
 }
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
-
-#ifdef CONFIG_PCI
-static int check_iommu(char *s)
-{
-	if (!strcmp(s, "usedac")) {
-		forbid_dac = -1;
-		return 1;
-	}
-	return 0;
-}
-__setup("iommu=", check_iommu);
-#endif
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index c80da76..e7d45cf 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -14,22 +14,9 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
-int iommu_merge __read_mostly = 0;
-
 dma_addr_t bad_dma_address __read_mostly;
 EXPORT_SYMBOL(bad_dma_address);
 
-/* This tells the BIO block layer to assume merging. Default to off
-   because we cannot guarantee merging later. */
-int iommu_bio_merge __read_mostly = 0;
-EXPORT_SYMBOL(iommu_bio_merge);
-
-extern int iommu_sac_force;
-
-int no_iommu __read_mostly;
-/* Set this to 1 if there is a HW IOMMU in the system */
-int iommu_detected __read_mostly = 0;
-
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to i386. */
@@ -160,69 +147,3 @@ void dma_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 EXPORT_SYMBOL(dma_free_coherent);
-
-/*
- * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
- * documentation.
- */
-static __init int iommu_setup(char *p)
-{
-	iommu_merge = 1;
-
-	if (!p)
-		return -EINVAL;
-
-	while (*p) {
-		if (!strncmp(p, "off", 3))
-			no_iommu = 1;
-		/* gart_parse_options has more force support */
-		if (!strncmp(p, "force", 5))
-			force_iommu = 1;
-		if (!strncmp(p, "noforce", 7)) {
-			iommu_merge = 0;
-			force_iommu = 0;
-		}
-
-		if (!strncmp(p, "biomerge", 8)) {
-			iommu_bio_merge = 4096;
-			iommu_merge = 1;
-			force_iommu = 1;
-		}
-		if (!strncmp(p, "panic", 5))
-			panic_on_overflow = 1;
-		if (!strncmp(p, "nopanic", 7))
-			panic_on_overflow = 0;
-		if (!strncmp(p, "merge", 5)) {
-			iommu_merge = 1;
-			force_iommu = 1;
-		}
-		if (!strncmp(p, "nomerge", 7))
-			iommu_merge = 0;
-		if (!strncmp(p, "forcesac", 8))
-			iommu_sac_force = 1;
-		if (!strncmp(p, "allowdac", 8))
-			forbid_dac = 0;
-		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
-
-#ifdef CONFIG_SWIOTLB
-		if (!strncmp(p, "soft", 4))
-			swiotlb = 1;
-#endif
-
-#ifdef CONFIG_GART_IOMMU
-		gart_parse_options(p);
-#endif
-
-#ifdef CONFIG_CALGARY_IOMMU
-		if (!strncmp(p, "calgary", 7))
-			use_calgary = 1;
-#endif /* CONFIG_CALGARY_IOMMU */
-
-		p += strcspn(p, ",");
-		if (*p == ',')
-			++p;
-	}
-	return 0;
-}
-early_param("iommu", iommu_setup);
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index d82517d..7580736 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -15,6 +15,7 @@ extern int iommu_merge;
 extern struct device fallback_dev;
 extern int panic_on_overflow;
 extern int forbid_dac;
+extern int force_iommu;
 
 struct dma_mapping_ops {
 	int             (*mapping_error)(dma_addr_t dma_addr);
-- 
1.5.0.6

