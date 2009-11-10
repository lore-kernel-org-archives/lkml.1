Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZKJNYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZKJNYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZKJNYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:24:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:34169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbZKJNYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:24:07 -0500
Date: Tue, 10 Nov 2009 13:23:37 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257849980-22640-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: intel-iommu: Convert detect_intel_iommu to use iommu_init hook
Message-ID: <tip-9d5ce73a64be2be8112147a3e0b551ad9cd1247b@git.kernel.org>
Git-Commit-ID: 9d5ce73a64be2be8112147a3e0b551ad9cd1247b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d5ce73a64be2be8112147a3e0b551ad9cd1247b
Gitweb:     http://git.kernel.org/tip/9d5ce73a64be2be8112147a3e0b551ad9cd1247b
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Tue, 10 Nov 2009 19:46:16 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:31:36 +0100

x86: intel-iommu: Convert detect_intel_iommu to use iommu_init hook

This changes detect_intel_iommu() to set intel_iommu_init() to
iommu_init hook if detect_intel_iommu() finds the IOMMU.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org
Cc: dwmw2@infradead.org
Cc: joerg.roedel@amd.com
Cc: muli@il.ibm.com
LKML-Reference: <1257849980-22640-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
[ -v2: build fix for the !CONFIG_DMAR case ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    2 --
 drivers/pci/dmar.c        |    4 ++++
 include/linux/dmar.h      |   15 ++++-----------
 3 files changed, 8 insertions(+), 13 deletions(-)

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
index 4a2b162..5de4c9e 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -208,16 +208,9 @@ struct dmar_atsr_unit {
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
-#endif
-}
-#endif /* !CONFIG_DMAR */
+#else /* !CONFIG_DMAR: */
+static inline int intel_iommu_init(void) { return -ENODEV; }
+#endif /* CONFIG_DMAR */
+
 #endif /* __DMAR_H__ */
