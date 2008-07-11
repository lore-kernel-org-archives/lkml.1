Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbYGKBZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbYGKBZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYGKBYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:24:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:48435 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbYGKBYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:24:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/4] x86: remove ifdef CONFIG_GART_IOMMU in pci-dma.c
Date: Fri, 11 Jul 2008 10:23:43 +0900
Message-Id: <1215739425-28399-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1215739425-28399-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1215739425-28399-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1215739425-28399-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our way to handle gart_* functions for CONFIG_GART_IOMMU and
!CONFIG_GART_IOMMU cases is inconsistent.

We have some dummy gart_* functions in !CONFIG_GART_IOMMU case and
also use ifdef CONFIG_GART_IOMMU tricks in pci-dma.c to call some
gart_* functions in only CONFIG_GART_IOMMU case.

This patch removes ifdef CONFIG_GART_IOMMU in pci-dma.c and always use
dummy gart_* functions in iommu.h.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c |    6 ------
 include/asm-x86/iommu.h   |   10 +++++++++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 6eb7470..034fe1c 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -114,9 +114,7 @@ void __init pci_iommu_alloc(void)
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
 	 */
-#ifdef CONFIG_GART_IOMMU
 	gart_iommu_hole_init();
-#endif
 
 #ifdef CONFIG_CALGARY_IOMMU
 	detect_calgary();
@@ -184,9 +182,7 @@ static __init int iommu_setup(char *p)
 			swiotlb = 1;
 #endif
 
-#ifdef CONFIG_GART_IOMMU
 		gart_parse_options(p);
-#endif
 
 #ifdef CONFIG_CALGARY_IOMMU
 		if (!strncmp(p, "calgary", 7))
@@ -390,9 +386,7 @@ static int __init pci_iommu_init(void)
 
 	amd_iommu_init();
 
-#ifdef CONFIG_GART_IOMMU
 	gart_iommu_init();
-#endif
 
 	no_iommu_init();
 	return 0;
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 068c9a4..d63166f 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -25,10 +25,18 @@ extern void gart_iommu_hole_init(void);
 static inline void early_gart_iommu_check(void)
 {
 }
-
+static inline void gart_iommu_init(void)
+{
+}
 static inline void gart_iommu_shutdown(void)
 {
 }
+static inline void gart_parse_options(char *options)
+{
+}
+static inline void gart_iommu_hole_init(void)
+{
+}
 #endif
 
 #endif
-- 
1.5.5.GIT

