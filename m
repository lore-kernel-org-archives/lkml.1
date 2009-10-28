Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbZJ1GyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbZJ1GyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbZJ1GyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:54071 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbZJ1GyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:15 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 01/10] Add iommu_init to x86_init_ops
Date: Wed, 28 Oct 2009 15:47:35 +0900
Message-Id: <1256712464-21472-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call the detections functions of all the IOMMUs then all their
initialization functions. THe latter is pointless since we don't
detect multiple different IOMMUs. What we need to do is calling the
initialization function of the detected IOMMU.

This adds iommu_init hook to x86_init_ops so if an IOMMU detection
function can set its initialization function to the hook.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/iommu.h    |    1 +
 arch/x86/include/asm/x86_init.h |    9 +++++++++
 arch/x86/kernel/pci-dma.c       |    2 ++
 arch/x86/kernel/x86_init.c      |    5 +++++
 4 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index fd6d21b..42aa977 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -3,6 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
+static inline int iommu_init_noop(void) { return 0; }
 extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2c756fd..a58644a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -91,6 +91,14 @@ struct x86_init_timers {
 };
 
 /**
+ * struct x86_init_iommu - platform specific iommu setup
+ * @iommu_init:			platform specific iommu setup
+ */
+struct x86_init_iommu {
+	int (*iommu_init)(void);
+};
+
+/**
  * struct x86_init_ops - functions for platform specific setup
  *
  */
@@ -101,6 +109,7 @@ struct x86_init_ops {
 	struct x86_init_oem		oem;
 	struct x86_init_paging		paging;
 	struct x86_init_timers		timers;
+	struct x86_init_iommu		iommu;
 };
 
 /**
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b2a71dc..5609973 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -292,6 +292,8 @@ static int __init pci_iommu_init(void)
 	dma_debug_add_bus(&pci_bus_type);
 #endif
 
+	x86_init.iommu.iommu_init();
+
 	calgary_iommu_init();
 
 	intel_iommu_init();
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 4449a4a..d89ce53 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -14,6 +14,7 @@
 #include <asm/time.h>
 #include <asm/irq.h>
 #include <asm/tsc.h>
+#include <asm/iommu.h>
 
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
@@ -62,6 +63,10 @@ struct x86_init_ops x86_init __initdata = {
 		.tsc_pre_init		= x86_init_noop,
 		.timer_init		= hpet_time_init,
 	},
+
+	.iommu = {
+		.iommu_init		= iommu_init_noop,
+	},
 };
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
-- 
1.5.6.5

