Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYAWAGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYAWAGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYAWAGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:06:37 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:2557 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYAWAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pigcw7UczVh2fnQ5V3hSHGutwGQDoHO8DiWWyi5CRcWHDH1t2Rn/ohYIjzq8/cRYomkIgDMOaiy1DojJNkEL/q1zM4n3hgHN7LCcXxjRy1zlPwByQTQg4DX9B7GsncmnnYTaai6ts5GPYTRbv853SWZ57qJJK0n8vFyaDM1RBzc=
Subject: [PATCH 1/3] x86: Unify fault_32|64.c by ifdef'd function bodies
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 16:06:43 -0800
Message-Id: <1201046803.16972.92.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's about time to get on with unifying these files, elimination
of the ugly ifdefs can occur in the unified file.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
OK, time to bite the bullet, it's ugly, but we can now do the cleanups
once in the unified files.

 arch/x86/mm/fault_32.c |  116 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault_64.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 263 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index f85e7c9..2d8a577 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -172,8 +172,17 @@ static void force_sig_info_fault(int si_signo, int si_code,
 	force_sig_info(si_signo, &info, tsk);
 }
 
+#ifdef CONFIG_X86_64
+static int bad_address(void *p)
+{
+	unsigned long dummy;
+	return probe_kernel_address((unsigned long *)p, dummy);
+}
+#endif
+
 void dump_pagetable(unsigned long address)
 {
+#ifdef CONFIG_X86_32
 	__typeof__(pte_val(__pte(0))) page;
 
 	page = read_cr3();
@@ -208,8 +217,42 @@ void dump_pagetable(unsigned long address)
 	}
 
 	printk("\n");
+#else /* CONFIG_X86_64 */
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = (pgd_t *)read_cr3();
+
+	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK);
+	pgd += pgd_index(address);
+	if (bad_address(pgd)) goto bad;
+	printk("PGD %lx ", pgd_val(*pgd));
+	if (!pgd_present(*pgd)) goto ret;
+
+	pud = pud_offset(pgd, address);
+	if (bad_address(pud)) goto bad;
+	printk("PUD %lx ", pud_val(*pud));
+	if (!pud_present(*pud))	goto ret;
+
+	pmd = pmd_offset(pud, address);
+	if (bad_address(pmd)) goto bad;
+	printk("PMD %lx ", pmd_val(*pmd));
+	if (!pmd_present(*pmd) || pmd_large(*pmd)) goto ret;
+
+	pte = pte_offset_kernel(pmd, address);
+	if (bad_address(pte)) goto bad;
+	printk("PTE %lx", pte_val(*pte));
+ret:
+	printk("\n");
+	return;
+bad:
+	printk("BAD\n");
+#endif
 }
 
+#ifdef CONFIG_X86_32
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 {
 	unsigned index = pgd_index(address);
@@ -245,6 +288,7 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
 	return pmd_k;
 }
+#endif
 
 #ifdef CONFIG_X86_64
 static const char errata93_warning[] =
@@ -325,6 +369,7 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 			    unsigned long address)
 {
+#ifdef CONFIG_X86_32
 	if (!oops_may_print())
 		return;
 
@@ -349,7 +394,39 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 	printk(KERN_ALERT "IP:");
 	printk_address(regs->ip, 1);
 	dump_pagetable(address);
+#else /* CONFIG_X86_64 */
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
+	if (address < PAGE_SIZE)
+		printk(KERN_CONT "NULL pointer dereference");
+	else
+		printk(KERN_CONT "paging request");
+	printk(KERN_CONT " at %016lx\n", address);
+
+	printk(KERN_ALERT "IP:");
+	printk_address(regs->ip, 1);
+	dump_pagetable(address);
+#endif
+}
+
+#ifdef CONFIG_X86_64
+static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
+				 unsigned long error_code)
+{
+	unsigned long flags = oops_begin();
+	struct task_struct *tsk;
+
+	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
+	       current->comm, address);
+	dump_pagetable(address);
+	tsk = current;
+	tsk->thread.cr2 = address;
+	tsk->thread.trap_no = 14;
+	tsk->thread.error_code = error_code;
+	if (__die("Bad pagetable", regs, error_code))
+		regs = NULL;
+	oops_end(flags, regs, SIGKILL);
 }
+#endif
 
 /*
  * Handle a fault on the vmalloc or module mapping area
@@ -705,6 +782,7 @@ do_sigbus:
 
 void vmalloc_sync_all(void)
 {
+#ifdef CONFIG_X86_32
 	/*
 	 * Note that races in the updates of insync and start aren't
 	 * problematic: insync can only get set bits added, and updates to
@@ -739,4 +817,42 @@ void vmalloc_sync_all(void)
 		if (address == start && test_bit(pgd_index(address), insync))
 			start = address + PGDIR_SIZE;
 	}
+#else /* CONFIG_X86_64 */
+	/*
+	 * Note that races in the updates of insync and start aren't
+	 * problematic: insync can only get set bits added, and updates to
+	 * start are only improving performance (without affecting correctness
+	 * if undone).
+	 */
+	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
+	static unsigned long start = VMALLOC_START & PGDIR_MASK;
+	unsigned long address;
+
+	for (address = start; address <= VMALLOC_END; address += PGDIR_SIZE) {
+		if (!test_bit(pgd_index(address), insync)) {
+			const pgd_t *pgd_ref = pgd_offset_k(address);
+			struct page *page;
+
+			if (pgd_none(*pgd_ref))
+				continue;
+			spin_lock(&pgd_lock);
+			list_for_each_entry(page, &pgd_list, lru) {
+				pgd_t *pgd;
+				pgd = (pgd_t *)page_address(page) + pgd_index(address);
+				if (pgd_none(*pgd))
+					set_pgd(pgd, *pgd_ref);
+				else
+					BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
+			}
+			spin_unlock(&pgd_lock);
+			set_bit(pgd_index(address), insync);
+		}
+		if (address == start)
+			start = address + PGDIR_SIZE;
+	}
+	/* Check that there is no need to do the same for the modules area. */
+	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
+	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
+				(__START_KERNEL & PGDIR_MASK)));
+#endif
 }
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 1c381c1..bea77b2 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -175,14 +175,52 @@ static void force_sig_info_fault(int si_signo, int si_code,
 	force_sig_info(si_signo, &info, tsk);
 }
 
+#ifdef CONFIG_X86_64
 static int bad_address(void *p)
 {
 	unsigned long dummy;
 	return probe_kernel_address((unsigned long *)p, dummy);
 }
+#endif
 
 void dump_pagetable(unsigned long address)
 {
+#ifdef CONFIG_X86_32
+	__typeof__(pte_val(__pte(0))) page;
+
+	page = read_cr3();
+	page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
+#ifdef CONFIG_X86_PAE
+	printk("*pdpt = %016Lx ", page);
+	if ((page >> PAGE_SHIFT) < max_low_pfn
+	    && page & _PAGE_PRESENT) {
+		page &= PAGE_MASK;
+		page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
+		                                         & (PTRS_PER_PMD - 1)];
+		printk(KERN_CONT "*pde = %016Lx ", page);
+		page &= ~_PAGE_NX;
+	}
+#else
+	printk("*pde = %08lx ", page);
+#endif
+
+	/*
+	 * We must not directly access the pte in the highpte
+	 * case if the page table is located in highmem.
+	 * And let's rather not kmap-atomic the pte, just in case
+	 * it's allocated already.
+	 */
+	if ((page >> PAGE_SHIFT) < max_low_pfn
+	    && (page & _PAGE_PRESENT)
+	    && !(page & _PAGE_PSE)) {
+		page &= PAGE_MASK;
+		page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
+		                                         & (PTRS_PER_PTE - 1)];
+		printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
+	}
+
+	printk("\n");
+#else /* CONFIG_X86_64 */
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -214,8 +252,47 @@ ret:
 	return;
 bad:
 	printk("BAD\n");
+#endif
 }
 
+#ifdef CONFIG_X86_32
+static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
+{
+	unsigned index = pgd_index(address);
+	pgd_t *pgd_k;
+	pud_t *pud, *pud_k;
+	pmd_t *pmd, *pmd_k;
+
+	pgd += index;
+	pgd_k = init_mm.pgd + index;
+
+	if (!pgd_present(*pgd_k))
+		return NULL;
+
+	/*
+	 * set_pgd(pgd, *pgd_k); here would be useless on PAE
+	 * and redundant with the set_pmd() on non-PAE. As would
+	 * set_pud.
+	 */
+
+	pud = pud_offset(pgd, address);
+	pud_k = pud_offset(pgd_k, address);
+	if (!pud_present(*pud_k))
+		return NULL;
+
+	pmd = pmd_offset(pud, address);
+	pmd_k = pmd_offset(pud_k, address);
+	if (!pmd_present(*pmd_k))
+		return NULL;
+	if (!pmd_present(*pmd)) {
+		set_pmd(pmd, *pmd_k);
+		arch_flush_lazy_mmu_mode();
+	} else
+		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
+	return pmd_k;
+}
+#endif
+
 #ifdef CONFIG_X86_64
 static const char errata93_warning[] =
 KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
@@ -295,6 +372,32 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 			    unsigned long address)
 {
+#ifdef CONFIG_X86_32
+	if (!oops_may_print())
+		return;
+
+#ifdef CONFIG_X86_PAE
+	if (error_code & PF_INSTR) {
+		int level;
+		pte_t *pte = lookup_address(address, &level);
+
+		if (pte && pte_present(*pte) && !pte_exec(*pte))
+			printk(KERN_CRIT "kernel tried to execute "
+				"NX-protected page - exploit attempt? "
+				"(uid: %d)\n", current->uid);
+	}
+#endif
+	printk(KERN_ALERT "BUG: unable to handle kernel ");
+	if (address < PAGE_SIZE)
+		printk(KERN_CONT "NULL pointer dereference");
+	else
+		printk(KERN_CONT "paging request");
+	printk(KERN_CONT " at %08lx\n", address);
+
+	printk(KERN_ALERT "IP:");
+	printk_address(regs->ip, 1);
+	dump_pagetable(address);
+#else /* CONFIG_X86_64 */
 	printk(KERN_ALERT "BUG: unable to handle kernel ");
 	if (address < PAGE_SIZE)
 		printk(KERN_CONT "NULL pointer dereference");
@@ -305,8 +408,10 @@ static void show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 	printk(KERN_ALERT "IP:");
 	printk_address(regs->ip, 1);
 	dump_pagetable(address);
+#endif
 }
 
+#ifdef CONFIG_X86_64
 static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 				 unsigned long error_code)
 {
@@ -324,6 +429,7 @@ static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
 		regs = NULL;
 	oops_end(flags, regs, SIGKILL);
 }
+#endif
 
 /*
  * Handle a fault on the vmalloc area
@@ -589,12 +695,15 @@ bad_area:
 bad_area_nosemaphore:
 	/* User mode accesses just cause a SIGSEGV */
 	if (error_code & PF_USER) {
-
 		/*
 		 * It's possible to have interrupts off here.
 		 */
 		local_irq_enable();
 
+		/*
+		 * Valid to do another page fault here because this one came
+		 * from user space.
+		 */
 		if (is_prefetch(regs, address, error_code))
 			return;
 
@@ -695,6 +804,42 @@ LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
+#ifdef CONFIG_X86_32
+	/*
+	 * Note that races in the updates of insync and start aren't
+	 * problematic: insync can only get set bits added, and updates to
+	 * start are only improving performance (without affecting correctness
+	 * if undone).
+	 */
+	static DECLARE_BITMAP(insync, PTRS_PER_PGD);
+	static unsigned long start = TASK_SIZE;
+	unsigned long address;
+
+	if (SHARED_KERNEL_PMD)
+		return;
+
+	BUILD_BUG_ON(TASK_SIZE & ~PGDIR_MASK);
+	for (address = start; address >= TASK_SIZE; address += PGDIR_SIZE) {
+		if (!test_bit(pgd_index(address), insync)) {
+			unsigned long flags;
+			struct page *page;
+
+			spin_lock_irqsave(&pgd_lock, flags);
+			for (page = pgd_list; page; page =
+					(struct page *)page->index)
+				if (!vmalloc_sync_one(page_address(page),
+								address)) {
+					BUG_ON(page != pgd_list);
+					break;
+				}
+			spin_unlock_irqrestore(&pgd_lock, flags);
+			if (!page)
+				set_bit(pgd_index(address), insync);
+		}
+		if (address == start && test_bit(pgd_index(address), insync))
+			start = address + PGDIR_SIZE;
+	}
+#else /* CONFIG_X86_64 */
 	/*
 	 * Note that races in the updates of insync and start aren't
 	 * problematic: insync can only get set bits added, and updates to
@@ -731,4 +876,5 @@ void vmalloc_sync_all(void)
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
+#endif
 }
-- 
1.5.4.rc3.1118.gf6754c


