Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbZJ1GyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbZJ1GyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZJ1GyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:54072 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbZJ1GyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:16 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 05/10] intel-iommu: convert detect_intel_iommu to use iommu_init hook
Date: Wed, 28 Oct 2009 15:47:39 +0900
Message-Id: <1256712464-21472-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes detect_intel_iommu() to set intel_iommu_init() to
iommu_init hook if detect_intel_iommu() finds the IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c |    2 --
 drivers/pci/dmar.c        |    4 ++++
 include/linux/dmar.h      |   10 ----------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 6abb8c2..f70b766 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -294,8 +294,6 @@ static int __init pci_iommu_init(void)
 
 	x86_init.iommu.iommu_init();
 
-	intel_iommu_init();
-
 	no_iommu_init();
 	return 0;
 }
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 22b02c6..bce9cd7 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -617,6 +617,10 @@ void __init detect_intel_iommu(void)
 		    !dmar_disabled)
 			iommu_detected = 1;
 #endif
+#ifdef CONFIG_X86
+		if (ret)
+			x86_init.iommu.iommu_init = intel_iommu_init;
+#endif
 	}
 	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 4a2b162..3d12f28 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -208,16 +208,6 @@ struct dmar_atsr_unit {
 	u8 include_all:1;		/* include all ports */
 };
 
-/* Intel DMAR  initialization functions */
 extern int intel_iommu_init(void);
-#else
-static inline int intel_iommu_init(void)
-{
-#ifdef CONFIG_INTR_REMAP
-	return dmar_dev_scope_init();
-#else
-	return -ENODEV;
 #endif
-}
-#endif /* !CONFIG_DMAR */
 #endif /* __DMAR_H__ */
-- 
1.5.6.5

