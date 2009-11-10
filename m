Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZKJNZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZKJNZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbZKJNZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:25:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:34225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381AbZKJNY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:24:58 -0500
Date: Tue, 10 Nov 2009 13:24:24 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257849980-22640-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] swiotlb: Defer swiotlb init printing, export swiotlb_print_info()
Message-ID: <tip-ad32e8cb86e7894aac51c8963eaa9f36bb8a4e14@git.kernel.org>
Git-Commit-ID: ad32e8cb86e7894aac51c8963eaa9f36bb8a4e14
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad32e8cb86e7894aac51c8963eaa9f36bb8a4e14
Gitweb:     http://git.kernel.org/tip/ad32e8cb86e7894aac51c8963eaa9f36bb8a4e14
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Tue, 10 Nov 2009 19:46:19 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:32:00 +0100

swiotlb: Defer swiotlb init printing, export swiotlb_print_info()

This enables us to avoid printing swiotlb memory info when we
initialize swiotlb. After swiotlb initialization, we could find
that we don't need swiotlb.

This patch removes the code to print swiotlb memory info in
swiotlb_init() and exports the function to do that.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org
Cc: dwmw2@infradead.org
Cc: joerg.roedel@amd.com
Cc: muli@il.ibm.com
Cc: tony.luck@intel.com
Cc: benh@kernel.crashing.org
LKML-Reference: <1257849980-22640-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
[ -v2: merge up conflict ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/kernel/pci-swiotlb.c |    4 ++--
 arch/powerpc/kernel/setup_32.c |    2 +-
 arch/powerpc/kernel/setup_64.c |    2 +-
 arch/x86/kernel/pci-swiotlb.c  |    3 +--
 include/linux/swiotlb.h        |    4 ++--
 lib/swiotlb.c                  |   15 ++++++++-------
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 285aae8..53292ab 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -41,7 +41,7 @@ struct dma_map_ops swiotlb_dma_ops = {
 void __init swiotlb_dma_init(void)
 {
 	dma_ops = &swiotlb_dma_ops;
-	swiotlb_init();
+	swiotlb_init(1);
 }
 
 void __init pci_swiotlb_init(void)
@@ -51,7 +51,7 @@ void __init pci_swiotlb_init(void)
 		swiotlb = 1;
 		printk(KERN_INFO "PCI-DMA: Re-initialize machine vector.\n");
 		machvec_init("dig");
-		swiotlb_init();
+		swiotlb_init(1);
 		dma_ops = &swiotlb_dma_ops;
 #else
 		panic("Unable to find Intel IOMMU");
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 53bcf3d..b152de3 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -345,7 +345,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_SWIOTLB
 	if (ppc_swiotlb_enable)
-		swiotlb_init();
+		swiotlb_init(1);
 #endif
 
 	paging_init();
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 04f638d..df2c9e9 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -550,7 +550,7 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_SWIOTLB
 	if (ppc_swiotlb_enable)
-		swiotlb_init();
+		swiotlb_init(1);
 #endif
 
 	paging_init();
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index aaa6b78..ea20ef7 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -52,8 +52,7 @@ void __init pci_swiotlb_init(void)
 	if (swiotlb_force)
 		swiotlb = 1;
 	if (swiotlb) {
-		printk(KERN_INFO "PCI-DMA: Using software bounce buffering for IO (SWIOTLB)\n");
-		swiotlb_init();
+		swiotlb_init(0);
 		dma_ops = &swiotlb_dma_ops;
 	}
 }
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 59bafa6..eb9bdb4 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -20,8 +20,7 @@ struct scatterlist;
  */
 #define IO_TLB_SHIFT 11
 
-extern void
-swiotlb_init(void);
+extern void swiotlb_init(int verbose);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -94,4 +93,5 @@ extern void __init swiotlb_free(void);
 static inline void swiotlb_free(void) { }
 #endif
 
+extern void swiotlb_print_info(void);
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index eee512b..0c12d7c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -123,8 +123,9 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
-static void swiotlb_print_info(unsigned long bytes)
+void swiotlb_print_info(void)
 {
+	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 	phys_addr_t pstart, pend;
 
 	pstart = virt_to_phys(io_tlb_start);
@@ -142,7 +143,7 @@ static void swiotlb_print_info(unsigned long bytes)
  * structures for the software IO TLB used to implement the DMA API.
  */
 void __init
-swiotlb_init_with_default_size(size_t default_size)
+swiotlb_init_with_default_size(size_t default_size, int verbose)
 {
 	unsigned long i, bytes;
 
@@ -178,14 +179,14 @@ swiotlb_init_with_default_size(size_t default_size)
 	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
-
-	swiotlb_print_info(bytes);
+	if (verbose)
+		swiotlb_print_info();
 }
 
 void __init
-swiotlb_init(void)
+swiotlb_init(int verbose)
 {
-	swiotlb_init_with_default_size(64 * (1<<20));	/* default to 64MB */
+	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
 }
 
 /*
@@ -262,7 +263,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
-	swiotlb_print_info(bytes);
+	swiotlb_print_info();
 
 	late_alloc = 1;
 
