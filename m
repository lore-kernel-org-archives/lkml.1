Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZKJKvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZKJKvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZKJKvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:51:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:33799 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZKJKuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:50:03 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 5/9] intel-iommu: convert detect_intel_iommu to use iommu_init hook
Date: Tue, 10 Nov 2009 19:46:16 +0900
Message-Id: <1257849980-22640-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 19:49:33 +0900 (JST)
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
index 5ca44a9..bed05e2 100644
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
index a05cd1c..d814d7d 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -218,16 +218,6 @@ struct dmar_atsr_unit {
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

