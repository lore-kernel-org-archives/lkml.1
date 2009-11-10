Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZKJKwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZKJKwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZKJKv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:51:59 -0500
Received: from sh.osrg.net ([192.16.179.4]:33791 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZKJKt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:49:57 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 1/9] add iommu_init to x86_init_ops
Date: Tue, 10 Nov 2009 19:46:12 +0900
Message-Id: <1257849980-22640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 19:49:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call the detections functions of all the IOMMUs then all their
initialization functions. The latter is pointless since we don't
detect multiple different IOMMUs. What we need to do is calling the
initialization function of the detected IOMMU.

This adds iommu_init hook to x86_init_ops so if an IOMMU detection
function can set its initialization function to the hook.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/x86_init.h |    9 +++++++++
 arch/x86/kernel/pci-dma.c       |    2 ++
 arch/x86/kernel/x86_init.c      |    5 +++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 66008ed..d8e7145 100644
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
index 839d49a..a13478d 100644
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
index bc9b230..c46984d 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -19,6 +19,7 @@
 void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
+int __init iommu_init_noop(void) { return 0; }
 
 /*
  * The platform setup functions are preset with the default functions
@@ -63,6 +64,10 @@ struct x86_init_ops x86_init __initdata = {
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

