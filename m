Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYAIC6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYAIC6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYAIC6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:58:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:22412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYAIC6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:58:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,260,1196668800"; 
   d="scan'208";a="319224343"
Subject: [PATCH -mm 1/2] kexec/i386: kexec page table code clean up - add
	arch_kimage
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 10:57:47 +0800
Message-Id: <1199847467.8126.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 09 Jan 2008 02:56:56.0640 (UTC) FILETIME=[4BC77400:01C8526B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add an architecture specific struct arch_kimage into struct
kimage. Three pointers to page table pages used by kexec are added to
struct arch_kimage. The page tables pages are dynamically allocated in
machine_kexec_prepare instead of statically from BSS segment. This
will save up to 20k memory when kexec image is not loaded.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c |   68 +++++++++++++++++++++++++------------
 include/asm-x86/kexec_32.h         |   12 ++++++
 include/linux/kexec.h              |    4 ++
 3 files changed, 63 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/numa.h>
+#include <linux/gfp.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
@@ -21,15 +22,6 @@
 #include <asm/desc.h>
 #include <asm/system.h>
 
-#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
-static u32 kexec_pgd[1024] PAGE_ALIGNED;
-#ifdef CONFIG_X86_PAE
-static u32 kexec_pmd0[1024] PAGE_ALIGNED;
-static u32 kexec_pmd1[1024] PAGE_ALIGNED;
-#endif
-static u32 kexec_pte0[1024] PAGE_ALIGNED;
-static u32 kexec_pte1[1024] PAGE_ALIGNED;
-
 static void set_idt(void *newidt, __u16 limit)
 {
 	struct Xgt_desc_struct curidt;
@@ -72,6 +64,28 @@ static void load_segments(void)
 #undef __STR
 }
 
+static void alloc_page_tables(struct kimage *image)
+{
+	image->arch_kimage.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+#ifdef CONFIG_X86_PAE
+	image->arch_kimage.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch_kimage.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+#endif
+	image->arch_kimage.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch_kimage.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+}
+
+static void free_page_tables(struct kimage *image)
+{
+	free_page((unsigned long)image->arch_kimage.pgd);
+#ifdef CONFIG_X86_PAE
+	free_page((unsigned long)image->arch_kimage.pmd0);
+	free_page((unsigned long)image->arch_kimage.pmd1);
+#endif
+	free_page((unsigned long)image->arch_kimage.pte0);
+	free_page((unsigned long)image->arch_kimage.pte1);
+}
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -83,10 +97,21 @@ static void load_segments(void)
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Currently nothing.
+ * - Allocate page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	alloc_page_tables(image);
+	if (!image->arch_kimage.pgd ||
+#ifdef CONFIG_X86_PAE
+	    !image->arch_kimage.pmd0 ||
+	    !image->arch_kimage.pmd1 ||
+#endif
+	    !image->arch_kimage.pte0 ||
+	    !image->arch_kimage.pte1) {
+		free_page_tables(image);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
@@ -96,6 +121,7 @@ int machine_kexec_prepare(struct kimage 
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
+	free_page_tables(image);
 }
 
 /*
@@ -115,18 +141,18 @@ NORET_TYPE void machine_kexec(struct kim
 
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
-	page_list[PA_PGD] = __pa(kexec_pgd);
-	page_list[VA_PGD] = (unsigned long)kexec_pgd;
+	page_list[PA_PGD] = __pa(image->arch_kimage.pgd);
+	page_list[VA_PGD] = (unsigned long)image->arch_kimage.pgd;
 #ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] = __pa(kexec_pmd0);
-	page_list[VA_PMD_0] = (unsigned long)kexec_pmd0;
-	page_list[PA_PMD_1] = __pa(kexec_pmd1);
-	page_list[VA_PMD_1] = (unsigned long)kexec_pmd1;
-#endif
-	page_list[PA_PTE_0] = __pa(kexec_pte0);
-	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
-	page_list[PA_PTE_1] = __pa(kexec_pte1);
-	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_PMD_0] = __pa(image->arch_kimage.pmd0);
+	page_list[VA_PMD_0] = (unsigned long)image->arch_kimage.pmd0;
+	page_list[PA_PMD_1] = __pa(image->arch_kimage.pmd1);
+	page_list[VA_PMD_1] = (unsigned long)image->arch_kimage.pmd1;
+#endif
+	page_list[PA_PTE_0] = __pa(image->arch_kimage.pte0);
+	page_list[VA_PTE_0] = (unsigned long)image->arch_kimage.pte0;
+	page_list[PA_PTE_1] = __pa(image->arch_kimage.pte1);
+	page_list[VA_PTE_1] = (unsigned long)image->arch_kimage.pte1;
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
--- a/include/asm-x86/kexec_32.h
+++ b/include/asm-x86/kexec_32.h
@@ -94,6 +94,18 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address,
 		unsigned int has_pae) ATTRIB_NORET;
 
+#define ARCH_HAS_ARCH_KIMAGE
+
+struct arch_kimage {
+	pgd_t *pgd;
+#ifdef CONFIG_X86_PAE
+	pmd_t *pmd0;
+	pmd_t *pmd1;
+#endif
+	pte_t *pte0;
+	pte_t *pte1;
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _I386_KEXEC_H */
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -98,6 +98,10 @@ struct kimage {
 	unsigned int type : 1;
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
+
+#ifdef ARCH_HAS_ARCH_KIMAGE
+	struct arch_kimage arch_kimage;
+#endif
 };
 
 

