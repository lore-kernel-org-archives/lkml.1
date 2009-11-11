Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZKKPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZKKPzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbZKKPzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:55:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:59958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbZKKPzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:55:23 -0500
Date: Wed, 11 Nov 2009 15:54:45 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, sfr@canb.auug.org.au,
       mingo@elte.hu
In-Reply-To: <20091112000258F.fujita.tomonori@lab.ntt.co.jp>
References: <20091112000258F.fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] swiotlb: Remove the swiotlb variable usage
Message-ID: <tip-b18485e7acfe1a634615d1c628ef644c0d58d472@git.kernel.org>
Git-Commit-ID: b18485e7acfe1a634615d1c628ef644c0d58d472
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b18485e7acfe1a634615d1c628ef644c0d58d472
Gitweb:     http://git.kernel.org/tip/b18485e7acfe1a634615d1c628ef644c0d58d472
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Thu, 12 Nov 2009 00:03:28 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 16:51:18 +0100

swiotlb: Remove the swiotlb variable usage

POWERPC doesn't expect it to be used.

This fixes the linux-next build failure reported by
Stephen Rothwell:

  lib/swiotlb.c: In function 'setup_io_tlb_npages':
  lib/swiotlb.c:114: error: 'swiotlb' undeclared (first use in this function)

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: peterz@infradead.org
LKML-Reference: <20091112000258F.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/swiotlb.h |    5 +++--
 arch/x86/kernel/pci-dma.c      |    5 +----
 arch/x86/kernel/pci-swiotlb.c  |   13 ++++++++++++-
 lib/swiotlb.c                  |    5 ++---
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index b9e4e20..940f13a 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -9,11 +9,12 @@ extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
-extern void pci_swiotlb_init(void);
+extern int pci_swiotlb_init(void);
 #else
 #define swiotlb 0
-static inline void pci_swiotlb_init(void)
+static inline int pci_swiotlb_init(void)
 {
+	return 0;
 }
 #endif
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f79870e..0b11bf1 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -125,16 +125,13 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
-	/* swiotlb is forced by the boot option */
-	int use_swiotlb = swiotlb;
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #else
 	dma_ops = &nommu_dma_ops;
 #endif
-	pci_swiotlb_init();
-	if (use_swiotlb)
+	if (pci_swiotlb_init())
 		return;
 
 	gart_iommu_hole_init();
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 17ce422..a6e5d0f 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -42,16 +42,27 @@ static struct dma_map_ops swiotlb_dma_ops = {
 	.dma_supported = NULL,
 };
 
-void __init pci_swiotlb_init(void)
+/*
+ * pci_swiotlb_init - initialize swiotlb if necessary
+ *
+ * This returns non-zero if we are forced to use swiotlb (by the boot
+ * option).
+ */
+int __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
 	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
 		swiotlb = 1;
 #endif
+	if (swiotlb_force)
+		swiotlb = 1;
+
 	if (swiotlb) {
 		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	} else
 		dma_ops = &nommu_dma_ops;
+
+	return swiotlb_force;
 }
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e6755a0..795472d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -109,10 +109,9 @@ setup_io_tlb_npages(char *str)
 	}
 	if (*str == ',')
 		++str;
-	if (!strcmp(str, "force")) {
+	if (!strcmp(str, "force"))
 		swiotlb_force = 1;
-		swiotlb = 1;
-	}
+
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
