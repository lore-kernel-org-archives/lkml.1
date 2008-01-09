Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYAIC6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYAIC6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYAIC6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:58:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:22412 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYAIC6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:58:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,260,1196668800"; 
   d="scan'208";a="319224338"
Subject: [PATCH -mm 2/2] kexec/i386: kexec page table code clean up - page
	table setup in C
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Jan 2008 10:57:50 +0800
Message-Id: <1199847470.8126.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 09 Jan 2008 02:57:00.0218 (UTC) FILETIME=[4DE969A0:01C8526B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch transforms the kexec page tables setup code from assembler
code to C code in machine_kexec_prepare. This improves readability and
reduces code line number.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c   |   50 +++++++++++----
 arch/x86/kernel/relocate_kernel_32.S |  114 -----------------------------------
 include/asm-x86/kexec_32.h           |   18 -----
 3 files changed, 40 insertions(+), 142 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -86,6 +86,42 @@ static void free_page_tables(struct kima
 	free_page((unsigned long)image->arch_kimage.pte1);
 }
 
+static void page_table_set_one(pgd_t *pgd, pmd_t *pmd, pte_t *pte,
+			       unsigned long vaddr, unsigned long paddr)
+{
+	pud_t *pud;
+
+	pgd += pgd_index(vaddr);
+#ifdef CONFIG_X86_PAE
+	if (!(pgd_val(*pgd) & _PAGE_PRESENT))
+		set_pgd(pgd, __pgd(__pa(pmd) | _PAGE_PRESENT));
+#endif
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT))
+		set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+	pte = pte_offset_kernel(pmd, vaddr);
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+}
+
+static void prepare_page_tables(struct kimage *image)
+{
+	void *control_page;
+	pmd_t *pmd = 0;
+
+	control_page = page_address(image->control_code_page);
+#ifdef CONFIG_X86_PAE
+	pmd = image->arch_kimage.pmd0;
+#endif
+	page_table_set_one(image->arch_kimage.pgd, pmd, image->arch_kimage.pte0,
+			   (unsigned long)relocate_kernel, __pa(control_page));
+#ifdef CONFIG_X86_PAE
+	pmd = image->arch_kimage.pmd1;
+#endif
+	page_table_set_one(image->arch_kimage.pgd, pmd, image->arch_kimage.pte1,
+			   __pa(control_page), __pa(control_page));
+}
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -98,6 +134,7 @@ static void free_page_tables(struct kima
  * later.
  *
  * - Allocate page tables
+ * - Setup page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
@@ -112,6 +149,7 @@ int machine_kexec_prepare(struct kimage 
 		free_page_tables(image);
 		return -ENOMEM;
 	}
+	prepare_page_tables(image);
 	return 0;
 }
 
@@ -140,19 +178,7 @@ NORET_TYPE void machine_kexec(struct kim
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
 
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
-	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
 	page_list[PA_PGD] = __pa(image->arch_kimage.pgd);
-	page_list[VA_PGD] = (unsigned long)image->arch_kimage.pgd;
-#ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] = __pa(image->arch_kimage.pmd0);
-	page_list[VA_PMD_0] = (unsigned long)image->arch_kimage.pmd0;
-	page_list[PA_PMD_1] = __pa(image->arch_kimage.pmd1);
-	page_list[VA_PMD_1] = (unsigned long)image->arch_kimage.pmd1;
-#endif
-	page_list[PA_PTE_0] = __pa(image->arch_kimage.pte0);
-	page_list[VA_PTE_0] = (unsigned long)image->arch_kimage.pte0;
-	page_list[PA_PTE_1] = __pa(image->arch_kimage.pte1);
-	page_list[VA_PTE_1] = (unsigned long)image->arch_kimage.pte1;
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -16,126 +16,12 @@
 
 #define PTR(x) (x << 2)
 #define PAGE_ALIGNED (1 << PAGE_SHIFT)
-#define PAGE_ATTR 0x63 /* _PAGE_PRESENT|_PAGE_RW|_PAGE_ACCESSED|_PAGE_DIRTY */
-#define PAE_PGD_ATTR 0x01 /* _PAGE_PRESENT */
 
 	.text
 	.align PAGE_ALIGNED
 	.globl relocate_kernel
 relocate_kernel:
 	movl	8(%esp), %ebp /* list of pages */
-
-#ifdef CONFIG_X86_PAE
-	/* map the control page at its virtual address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xc0000000, %eax
-	shrl	$27, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PMD_0)(%ebp), %edx
-	orl	$PAE_PGD_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PMD_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x3fe00000, %eax
-	shrl	$18, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_0)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x001ff000, %eax
-	shrl	$9, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	/* identity map the control page at its physical address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xc0000000, %eax
-	shrl	$27, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PMD_1)(%ebp), %edx
-	orl	$PAE_PGD_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PMD_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x3fe00000, %eax
-	shrl	$18, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_1)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x001ff000, %eax
-	shrl	$9, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-#else
-	/* map the control page at its virtual address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xffc00000, %eax
-	shrl	$20, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_0)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x003ff000, %eax
-	shrl	$10, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	/* identity map the control page at its physical address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xffc00000, %eax
-	shrl	$20, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_1)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x003ff000, %eax
-	shrl	$10, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-#endif
-
-relocate_new_kernel:
 	/* read the arguments and say goodbye to the stack */
 	movl  4(%esp), %ebx /* page_list */
 	movl  8(%esp), %ebp /* list of pages */
--- a/include/asm-x86/kexec_32.h
+++ b/include/asm-x86/kexec_32.h
@@ -2,22 +2,8 @@
 #define _I386_KEXEC_H
 
 #define PA_CONTROL_PAGE  0
-#define VA_CONTROL_PAGE  1
-#define PA_PGD           2
-#define VA_PGD           3
-#define PA_PTE_0         4
-#define VA_PTE_0         5
-#define PA_PTE_1         6
-#define VA_PTE_1         7
-#ifdef CONFIG_X86_PAE
-#define PA_PMD_0         8
-#define VA_PMD_0         9
-#define PA_PMD_1         10
-#define VA_PMD_1         11
-#define PAGES_NR         12
-#else
-#define PAGES_NR         8
-#endif
+#define PA_PGD           1
+#define PAGES_NR         2
 
 #ifndef __ASSEMBLY__
 

