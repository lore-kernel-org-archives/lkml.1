Return-Path: <linux-kernel-owner+w=401wt.eu-S1762610AbYALWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610AbYALWK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYALWKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:10:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:47205 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbYALWKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:10:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=suLP4OcHaZ11X0za8tp4hqxw5//1wBafQJsOg/8ahm5EyJ81xSwstjfATT9NRCj133aLBEYL3rQW/VUIfEPQFak5HKun0VHnAi2kU1yZ6gZdNAfbajqAaY6kp1xLVD8QIOFdppNtmeQ8bg9srVyWmUQuEVra6WjTlEJz1sGuEAk=
Subject: [PATCH 2/2] x86: Function ifdefs in fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 14:10:19 -0800
Message-Id: <1200175819.19760.95.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add caller of is_errata93() to X86_32, ifdef'd to do
nothing.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |   59 +++++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/mm/fault_64.c |   30 ++++++++++++++++++++++--
 2 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 5a52489..7361f96 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -228,6 +228,7 @@ KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
 KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
 KERN_ERR "******* Please consider a BIOS update.\n"
 KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
+#endif
 
 /* Workaround for K8 erratum #93 & buggy BIOS.
    BIOS SMM functions are required to use a specific workaround
@@ -235,10 +236,12 @@ KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
    A lot of BIOS that didn't get tested properly miss this.
    The OS sees this as a page fault with the upper 32bits of RIP cleared.
    Try to work around it here.
-   Note we only handle faults in kernel here. */
-
+   Note we only handle faults in kernel here.
+   Does nothing for X86_32
+ */
 static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
+#ifdef CONFIG_X86_64
 	static int warned;
 	if (address != regs->ip)
 		return 0;
@@ -254,9 +257,10 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 		regs->ip = address;
 		return 1;
 	}
+#endif
 	return 0;
 }
-#endif
+
 
 /*
  * Handle a fault on the vmalloc or module mapping area
@@ -265,6 +269,7 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
  */
 static inline int vmalloc_fault(unsigned long address)
 {
+#ifdef CONFIG_X86_32
 	unsigned long pgd_paddr;
 	pmd_t *pmd_k;
 	pte_t *pte_k;
@@ -283,6 +288,51 @@ static inline int vmalloc_fault(unsigned long address)
 	if (!pte_present(*pte_k))
 		return -1;
 	return 0;
+#else
+	pgd_t *pgd, *pgd_ref;
+	pud_t *pud, *pud_ref;
+	pmd_t *pmd, *pmd_ref;
+	pte_t *pte, *pte_ref;
+
+	/* Copy kernel mappings over when needed. This can also
+	   happen within a race in page table update. In the later
+	   case just flush. */
+
+	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd_ref = pgd_offset_k(address);
+	if (pgd_none(*pgd_ref))
+		return -1;
+	if (pgd_none(*pgd))
+		set_pgd(pgd, *pgd_ref);
+	else
+		BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
+
+	/* Below here mismatches are bugs because these lower tables
+	   are shared */
+
+	pud = pud_offset(pgd, address);
+	pud_ref = pud_offset(pgd_ref, address);
+	if (pud_none(*pud_ref))
+		return -1;
+	if (pud_none(*pud) || pud_page_vaddr(*pud) != pud_page_vaddr(*pud_ref))
+		BUG();
+	pmd = pmd_offset(pud, address);
+	pmd_ref = pmd_offset(pud_ref, address);
+	if (pmd_none(*pmd_ref))
+		return -1;
+	if (pmd_none(*pmd) || pmd_page(*pmd) != pmd_page(*pmd_ref))
+		BUG();
+	pte_ref = pte_offset_kernel(pmd_ref, address);
+	if (!pte_present(*pte_ref))
+		return -1;
+	pte = pte_offset_kernel(pmd, address);
+	/* Don't use pte_page here, because the mappings can point
+	   outside mem_map, and the NUMA hash lookup cannot handle
+	   that. */
+	if (!pte_present(*pte) || pte_pfn(*pte) != pte_pfn(*pte_ref))
+		BUG();
+	return 0;
+#endif
 }
 
 int show_unhandled_signals = 1;
@@ -524,6 +574,9 @@ no_context:
 	if (is_prefetch(regs, address, error_code))
 		return;
 
+	if (is_errata93(regs, address))
+		return;
+
 /*
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index befe9da..481e045 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -234,6 +234,7 @@ KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
 KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
 KERN_ERR "******* Please consider a BIOS update.\n"
 KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
+#endif
 
 /* Workaround for K8 erratum #93 & buggy BIOS.
    BIOS SMM functions are required to use a specific workaround
@@ -241,10 +242,12 @@ KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
    A lot of BIOS that didn't get tested properly miss this.
    The OS sees this as a page fault with the upper 32bits of RIP cleared.
    Try to work around it here.
-   Note we only handle faults in kernel here. */
-
+   Note we only handle faults in kernel here.
+   Does nothing for X86_32
+ */
 static int is_errata93(struct pt_regs *regs, unsigned long address)
 {
+#ifdef CONFIG_X86_64
 	static int warned;
 	if (address != regs->ip)
 		return 0;
@@ -260,9 +263,9 @@ static int is_errata93(struct pt_regs *regs, unsigned long address)
 		regs->ip = address;
 		return 1;
 	}
+#endif
 	return 0;
 }
-#endif
 
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
@@ -289,6 +292,26 @@ static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
  */
 static int vmalloc_fault(unsigned long address)
 {
+#ifdef CONFIG_X86_32
+	unsigned long pgd_paddr;
+	pmd_t *pmd_k;
+	pte_t *pte_k;
+	/*
+	 * Synchronize this task's top level page-table
+	 * with the 'reference' page table.
+	 *
+	 * Do _not_ use "current" here. We might be inside
+	 * an interrupt in the middle of a task switch..
+	 */
+	pgd_paddr = read_cr3();
+	pmd_k = vmalloc_sync_one(__va(pgd_paddr), address);
+	if (!pmd_k)
+		return -1;
+	pte_k = pte_offset_kernel(pmd_k, address);
+	if (!pte_present(*pte_k))
+		return -1;
+	return 0;
+#else
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
 	pmd_t *pmd, *pmd_ref;
@@ -332,6 +355,7 @@ static int vmalloc_fault(unsigned long address)
 	if (!pte_present(*pte) || pte_pfn(*pte) != pte_pfn(*pte_ref))
 		BUG();
 	return 0;
+#endif
 }
 
 int show_unhandled_signals = 1;
-- 
1.5.4.rc2.1164.g6451

