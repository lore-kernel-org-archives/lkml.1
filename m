Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbXGRTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbXGRTDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964809AbXGRTDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:03:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936401AbXGRTDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:03:03 -0400
Subject: [PATCH] Use read and write crX in .c files
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 18 Jul 2007 16:03:52 -0300
Message-Id: <1184785432.14337.6.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the read and write functions provided at system.h
for control registers instead of writting raw assembly over and
over again in .c files. Functions to manipulate cr2 and cr8 were
provided, as they were lacking.
    
Also, removed some extra space after closing brackets
    
Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---

diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 5909039..adbf487 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -340,10 +340,10 @@ void __show_regs(struct pt_regs * regs)
 	rdmsrl(MSR_GS_BASE, gs); 
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs); 
 
-	asm("movq %%cr0, %0": "=r" (cr0));
-	asm("movq %%cr2, %0": "=r" (cr2));
-	asm("movq %%cr3, %0": "=r" (cr3));
-	asm("movq %%cr4, %0": "=r" (cr4));
+	cr0 = read_cr0();
+	cr2 = read_cr2();
+	cr3 = read_cr3();
+	cr4 = read_cr4();
 
 	printk("FS:  %016lx(%04x) GS:%016lx(%04x) knlGS:%016lx\n", 
 	       fs,fsindex,gs,gsindex,shadowgs); 
diff --git a/arch/x86_64/kernel/suspend.c b/arch/x86_64/kernel/suspend.c
index 6a5a98f..b39d478 100644
--- a/arch/x86_64/kernel/suspend.c
+++ b/arch/x86_64/kernel/suspend.c
@@ -55,11 +55,11 @@ void __save_processor_state(struct saved_context *ctxt)
 	 * control registers 
 	 */
 	rdmsrl(MSR_EFER, ctxt->efer);
-	asm volatile ("movq %%cr0, %0" : "=r" (ctxt->cr0));
-	asm volatile ("movq %%cr2, %0" : "=r" (ctxt->cr2));
-	asm volatile ("movq %%cr3, %0" : "=r" (ctxt->cr3));
-	asm volatile ("movq %%cr4, %0" : "=r" (ctxt->cr4));
-	asm volatile ("movq %%cr8, %0" : "=r" (ctxt->cr8));
+	ctxt->cr0 = read_cr0();
+	ctxt->cr2 = read_cr2();
+	ctxt->cr3 = read_cr3();
+	ctxt->cr4 = read_cr4();
+	ctxt->cr8 = read_cr8();
 }
 
 void save_processor_state(void)
@@ -81,12 +81,12 @@ void __restore_processor_state(struct saved_context *ctxt)
 	 * control registers
 	 */
 	wrmsrl(MSR_EFER, ctxt->efer);
-	asm volatile ("movq %0, %%cr8" :: "r" (ctxt->cr8));
-	asm volatile ("movq %0, %%cr4" :: "r" (ctxt->cr4));
-	asm volatile ("movq %0, %%cr3" :: "r" (ctxt->cr3));
-	asm volatile ("movq %0, %%cr2" :: "r" (ctxt->cr2));
-	asm volatile ("movq %0, %%cr0" :: "r" (ctxt->cr0));
-
+	write_cr8(ctxt->cr8);
+	write_cr4(ctxt->cr4);
+	write_cr3(ctxt->cr3);
+	write_cr2(ctxt->cr2);
+	write_cr0(ctxt->cr0);
+	
 	/*
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 635e58d..282b942 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -159,7 +159,7 @@ void dump_pagetable(unsigned long address)
 	pmd_t *pmd;
 	pte_t *pte;
 
-	asm("movq %%cr3,%0" : "=r" (pgd));
+	pgd = (pgd_t *)read_cr3();
 
 	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK); 
 	pgd += pgd_index(address);
@@ -326,7 +326,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	prefetchw(&mm->mmap_sem);
 
 	/* get the address */
-	__asm__("movq %%cr2,%0":"=r" (address));
+	address = read_cr2();
 
 	info.si_code = SEGV_MAPERR;
 
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index 9a0e98a..653ddf0 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -383,7 +383,7 @@ void __meminit init_memory_mapping(unsigned long start, unsigned long end)
 	} 
 
 	if (!after_bootmem)
-		asm volatile("movq %%cr4,%0" : "=r" (mmu_cr4_features));
+		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
 }
 
diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index ead9f9a..b5f171c 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -75,19 +75,31 @@ static inline unsigned long read_cr0(void)
 	unsigned long cr0;
 	asm volatile("movq %%cr0,%0" : "=r" (cr0));
 	return cr0;
-} 
+}
 
 static inline void write_cr0(unsigned long val) 
 { 
 	asm volatile("movq %0,%%cr0" :: "r" (val));
-} 
+}
+
+static inline unsigned long read_cr2(void)
+{ 
+	unsigned long cr2;
+	asm("movq %%cr2,%0" : "=r" (cr2));
+	return cr2;
+}
+
+static inline void write_cr2(unsigned long val) 
+{ 
+	asm volatile("movq %0,%%cr2" :: "r" (val));
+}
 
 static inline unsigned long read_cr3(void)
 { 
 	unsigned long cr3;
 	asm("movq %%cr3,%0" : "=r" (cr3));
 	return cr3;
-} 
+}
 
 static inline void write_cr3(unsigned long val)
 {
@@ -99,12 +111,24 @@ static inline unsigned long read_cr4(void)
 	unsigned long cr4;
 	asm("movq %%cr4,%0" : "=r" (cr4));
 	return cr4;
-} 
+}
 
 static inline void write_cr4(unsigned long val)
 { 
 	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
-} 
+}
+
+static inline unsigned long read_cr8(void)
+{ 
+	unsigned long cr8;
+	asm("movq %%cr8,%0" : "=r" (cr8));
+	return cr8;
+}
+
+static inline void write_cr8(unsigned long val)
+{ 
+	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
+}
 
 #define stts() write_cr0(8 | read_cr0())
 


