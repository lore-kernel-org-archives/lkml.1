Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYF0P63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYF0P63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYF0P5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:57:55 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43667 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYF0P5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:57:53 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/6] avr32: Clean up and optimize the TLB operations
Date: Fri, 27 Jun 2008 17:57:51 +0200
Message-Id: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 27 Jun 2008 15:57:42.0013 (UTC) FILETIME=[88059AD0:01C8D86E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This and the following patches aim to optimize the code dealing with
page tables and TLB operations. Each patch reduces the time it takes
to gzip a 16 MB file slightly, but I expect things like fork() and
mmap() will improve somewhat more.

This patch deals with the low-level TLB operations:

  * Remove unused _TLBEHI_I define
  * Use gcc builtins instead of inline assembly
  * Remove a few unnecessary pipeline flushes and nops
  * Introduce NR_TLB_ENTRIES define and use it instead of hardcoding it
    to 32 a few places throughout the code.
  * Use sysreg bitops instead of hardcoded shifts and masks
  * Make a few needlessly global functions static

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/mm/tlb.c          |  175 +++++++++++++++++++++---------------------
 include/asm-avr32/tlbflush.h |    1 -
 2 files changed, 87 insertions(+), 89 deletions(-)

diff --git a/arch/avr32/mm/tlb.c b/arch/avr32/mm/tlb.c
index cd12edb..06677be 100644
--- a/arch/avr32/mm/tlb.c
+++ b/arch/avr32/mm/tlb.c
@@ -11,21 +11,21 @@
 
 #include <asm/mmu_context.h>
 
-#define _TLBEHI_I	0x100
+/* TODO: Get the correct number from the CONFIG1 system register */
+#define NR_TLB_ENTRIES 32
 
-void show_dtlb_entry(unsigned int index)
+static void show_dtlb_entry(unsigned int index)
 {
-	unsigned int tlbehi, tlbehi_save, tlbelo, mmucr, mmucr_save;
+	u32 tlbehi, tlbehi_save, tlbelo, mmucr, mmucr_save;
 	unsigned long flags;
 
 	local_irq_save(flags);
 	mmucr_save = sysreg_read(MMUCR);
 	tlbehi_save = sysreg_read(TLBEHI);
-	mmucr = mmucr_save & 0x13;
-	mmucr |= index << 14;
+	mmucr = SYSREG_BFINS(DRP, index, mmucr_save);
 	sysreg_write(MMUCR, mmucr);
 
-	asm volatile("tlbr" : : : "memory");
+	__builtin_tlbr();
 	cpu_sync_pipeline();
 
 	tlbehi = sysreg_read(TLBEHI);
@@ -33,15 +33,17 @@ void show_dtlb_entry(unsigned int index)
 
 	printk("%2u: %c %c %02x   %05x %05x %o  %o  %c %c %c %c\n",
 	       index,
-	       (tlbehi & 0x200)?'1':'0',
-	       (tlbelo & 0x100)?'1':'0',
-	       (tlbehi & 0xff),
-	       (tlbehi >> 12), (tlbelo >> 12),
-	       (tlbelo >> 4) & 7, (tlbelo >> 2) & 3,
-	       (tlbelo & 0x200)?'1':'0',
-	       (tlbelo & 0x080)?'1':'0',
-	       (tlbelo & 0x001)?'1':'0',
-	       (tlbelo & 0x002)?'1':'0');
+	       SYSREG_BFEXT(TLBEHI_V, tlbehi) ? '1' : '0',
+	       SYSREG_BFEXT(G, tlbelo) ? '1' : '0',
+	       SYSREG_BFEXT(ASID, tlbehi),
+	       SYSREG_BFEXT(VPN, tlbehi) >> 2,
+	       SYSREG_BFEXT(PFN, tlbelo) >> 2,
+	       SYSREG_BFEXT(AP, tlbelo),
+	       SYSREG_BFEXT(SZ, tlbelo),
+	       SYSREG_BFEXT(TLBELO_C, tlbelo) ? 'C' : ' ',
+	       SYSREG_BFEXT(B, tlbelo) ? 'B' : ' ',
+	       SYSREG_BFEXT(W, tlbelo) ? 'W' : ' ',
+	       SYSREG_BFEXT(TLBELO_D, tlbelo) ? 'D' : ' ');
 
 	sysreg_write(MMUCR, mmucr_save);
 	sysreg_write(TLBEHI, tlbehi_save);
@@ -54,29 +56,33 @@ void dump_dtlb(void)
 	unsigned int i;
 
 	printk("ID  V G ASID VPN   PFN   AP SZ C B W D\n");
-	for (i = 0; i < 32; i++)
+	for (i = 0; i < NR_TLB_ENTRIES; i++)
 		show_dtlb_entry(i);
 }
 
-static unsigned long last_mmucr;
-
-static inline void set_replacement_pointer(unsigned shift)
+static void update_dtlb(unsigned long address, pte_t pte)
 {
-	unsigned long mmucr, mmucr_save;
+	u32 tlbehi;
+	u32 mmucr;
 
-	mmucr = mmucr_save = sysreg_read(MMUCR);
+	/*
+	 * We're not changing the ASID here, so no need to flush the
+	 * pipeline.
+	 */
+	tlbehi = sysreg_read(TLBEHI);
+	tlbehi = SYSREG_BF(ASID, SYSREG_BFEXT(ASID, tlbehi));
+	tlbehi |= address & MMU_VPN_MASK;
+	tlbehi |= SYSREG_BIT(TLBEHI_V);
+	sysreg_write(TLBEHI, tlbehi);
 
 	/* Does this mapping already exist? */
-	__asm__ __volatile__(
-		"	tlbs\n"
-		"	mfsr %0, %1"
-		: "=r"(mmucr)
-		: "i"(SYSREG_MMUCR));
+	__builtin_tlbs();
+	mmucr = sysreg_read(MMUCR);
 
 	if (mmucr & SYSREG_BIT(MMUCR_N)) {
 		/* Not found -- pick a not-recently-accessed entry */
-		unsigned long rp;
-		unsigned long tlbar = sysreg_read(TLBARLO);
+		unsigned int rp;
+		u32 tlbar = sysreg_read(TLBARLO);
 
 		rp = 32 - fls(tlbar);
 		if (rp == 32) {
@@ -84,30 +90,14 @@ static inline void set_replacement_pointer(unsigned shift)
 			sysreg_write(TLBARLO, -1L);
 		}
 
-		mmucr &= 0x13;
-		mmucr |= (rp << shift);
-
+		mmucr = SYSREG_BFINS(DRP, rp, mmucr);
 		sysreg_write(MMUCR, mmucr);
 	}
 
-	last_mmucr = mmucr;
-}
-
-static void update_dtlb(unsigned long address, pte_t pte, unsigned long asid)
-{
-	unsigned long vpn;
-
-	vpn = (address & MMU_VPN_MASK) | _TLBEHI_VALID | asid;
-	sysreg_write(TLBEHI, vpn);
-	cpu_sync_pipeline();
-
-	set_replacement_pointer(14);
-
 	sysreg_write(TLBELO, pte_val(pte) & _PAGE_FLAGS_HARDWARE_MASK);
 
 	/* Let's go */
-	asm volatile("nop\n\ttlbw" : : : "memory");
-	cpu_sync_pipeline();
+	__builtin_tlbw();
 }
 
 void update_mmu_cache(struct vm_area_struct *vma,
@@ -120,39 +110,40 @@ void update_mmu_cache(struct vm_area_struct *vma,
 		return;
 
 	local_irq_save(flags);
-	update_dtlb(address, pte, get_asid());
+	update_dtlb(address, pte);
 	local_irq_restore(flags);
 }
 
-void __flush_tlb_page(unsigned long asid, unsigned long page)
+static void __flush_tlb_page(unsigned long asid, unsigned long page)
 {
-	unsigned long mmucr, tlbehi;
+	u32 mmucr, tlbehi;
 
-	page |= asid;
-	sysreg_write(TLBEHI, page);
-	cpu_sync_pipeline();
-	asm volatile("tlbs");
+	/*
+	 * Caller is responsible for masking out non-PFN bits in page
+	 * and changing the current ASID if necessary. This means that
+	 * we don't need to flush the pipeline after writing TLBEHI.
+	 */
+	tlbehi = page | asid;
+	sysreg_write(TLBEHI, tlbehi);
+
+	__builtin_tlbs();
 	mmucr = sysreg_read(MMUCR);
 
 	if (!(mmucr & SYSREG_BIT(MMUCR_N))) {
-		unsigned long tlbarlo;
-		unsigned long entry;
+		unsigned int entry;
+		u32 tlbarlo;
 
 		/* Clear the "valid" bit */
-		tlbehi = sysreg_read(TLBEHI);
-		tlbehi &= ~_TLBEHI_VALID;
 		sysreg_write(TLBEHI, tlbehi);
-		cpu_sync_pipeline();
 
 		/* mark the entry as "not accessed" */
-		entry = (mmucr >> 14) & 0x3f;
+		entry = SYSREG_BFEXT(DRP, mmucr);
 		tlbarlo = sysreg_read(TLBARLO);
-		tlbarlo |= (0x80000000 >> entry);
+		tlbarlo |= (0x80000000UL >> entry);
 		sysreg_write(TLBARLO, tlbarlo);
 
 		/* update the entry with valid bit clear */
-		asm volatile("tlbw");
-		cpu_sync_pipeline();
+		__builtin_tlbw();
 	}
 }
 
@@ -190,17 +181,22 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 
 		local_irq_save(flags);
 		size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+
 		if (size > (MMU_DTLB_ENTRIES / 4)) { /* Too many entries to flush */
 			mm->context = NO_CONTEXT;
 			if (mm == current->mm)
 				activate_context(mm);
 		} else {
-			unsigned long asid = mm->context & MMU_CONTEXT_ASID_MASK;
-			unsigned long saved_asid = MMU_NO_ASID;
+			unsigned long asid;
+			unsigned long saved_asid;
+
+			asid = mm->context & MMU_CONTEXT_ASID_MASK;
+			saved_asid = MMU_NO_ASID;
 
 			start &= PAGE_MASK;
 			end += (PAGE_SIZE - 1);
 			end &= PAGE_MASK;
+
 			if (mm != current->mm) {
 				saved_asid = get_asid();
 				set_asid(asid);
@@ -218,33 +214,34 @@ void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 }
 
 /*
- * TODO: If this is only called for addresses > TASK_SIZE, we can probably
- * skip the ASID stuff and just use the Global bit...
+ * This function depends on the pages to be flushed having the G
+ * (global) bit set in their pte. This is true for all
+ * PAGE_KERNEL(_RO) pages.
  */
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	unsigned long flags;
 	int size;
 
-	local_irq_save(flags);
 	size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
 	if (size > (MMU_DTLB_ENTRIES / 4)) { /* Too many entries to flush */
 		flush_tlb_all();
 	} else {
-		unsigned long asid = init_mm.context & MMU_CONTEXT_ASID_MASK;
-		unsigned long saved_asid = get_asid();
+		unsigned long asid;
+
+		local_irq_save(flags);
+		asid = get_asid();
 
 		start &= PAGE_MASK;
 		end += (PAGE_SIZE - 1);
 		end &= PAGE_MASK;
-		set_asid(asid);
+
 		while (start < end) {
 			__flush_tlb_page(asid, start);
 			start += PAGE_SIZE;
 		}
-		set_asid(saved_asid);
+		local_irq_restore(flags);
 	}
-	local_irq_restore(flags);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
@@ -280,7 +277,7 @@ static void *tlb_start(struct seq_file *tlb, loff_t *pos)
 {
 	static unsigned long tlb_index;
 
-	if (*pos >= 32)
+	if (*pos >= NR_TLB_ENTRIES)
 		return NULL;
 
 	tlb_index = 0;
@@ -291,7 +288,7 @@ static void *tlb_next(struct seq_file *tlb, void *v, loff_t *pos)
 {
 	unsigned long *index = v;
 
-	if (*index >= 31)
+	if (*index >= NR_TLB_ENTRIES - 1)
 		return NULL;
 
 	++*pos;
@@ -313,16 +310,16 @@ static int tlb_show(struct seq_file *tlb, void *v)
 	if (*index == 0)
 		seq_puts(tlb, "ID  V G ASID VPN   PFN   AP SZ C B W D\n");
 
-	BUG_ON(*index >= 32);
+	BUG_ON(*index >= NR_TLB_ENTRIES);
 
 	local_irq_save(flags);
 	mmucr_save = sysreg_read(MMUCR);
 	tlbehi_save = sysreg_read(TLBEHI);
-	mmucr = mmucr_save & 0x13;
-	mmucr |= *index << 14;
+	mmucr = SYSREG_BFINS(DRP, *index, mmucr_save);
 	sysreg_write(MMUCR, mmucr);
 
-	asm volatile("tlbr" : : : "memory");
+	/* TLBR might change the ASID */
+	__builtin_tlbr();
 	cpu_sync_pipeline();
 
 	tlbehi = sysreg_read(TLBEHI);
@@ -334,16 +331,18 @@ static int tlb_show(struct seq_file *tlb, void *v)
 	local_irq_restore(flags);
 
 	seq_printf(tlb, "%2lu: %c %c %02x   %05x %05x %o  %o  %c %c %c %c\n",
-	       *index,
-	       (tlbehi & 0x200)?'1':'0',
-	       (tlbelo & 0x100)?'1':'0',
-	       (tlbehi & 0xff),
-	       (tlbehi >> 12), (tlbelo >> 12),
-	       (tlbelo >> 4) & 7, (tlbelo >> 2) & 3,
-	       (tlbelo & 0x200)?'1':'0',
-	       (tlbelo & 0x080)?'1':'0',
-	       (tlbelo & 0x001)?'1':'0',
-	       (tlbelo & 0x002)?'1':'0');
+		   *index,
+		   SYSREG_BFEXT(TLBEHI_V, tlbehi) ? '1' : '0',
+		   SYSREG_BFEXT(G, tlbelo) ? '1' : '0',
+		   SYSREG_BFEXT(ASID, tlbehi),
+		   SYSREG_BFEXT(VPN, tlbehi) >> 2,
+		   SYSREG_BFEXT(PFN, tlbelo) >> 2,
+		   SYSREG_BFEXT(AP, tlbelo),
+		   SYSREG_BFEXT(SZ, tlbelo),
+		   SYSREG_BFEXT(TLBELO_C, tlbelo) ? '1' : '0',
+		   SYSREG_BFEXT(B, tlbelo) ? '1' : '0',
+		   SYSREG_BFEXT(W, tlbelo) ? '1' : '0',
+		   SYSREG_BFEXT(TLBELO_D, tlbelo) ? '1' : '0');
 
 	return 0;
 }
diff --git a/include/asm-avr32/tlbflush.h b/include/asm-avr32/tlbflush.h
index 5bc7c88..bf90a78 100644
--- a/include/asm-avr32/tlbflush.h
+++ b/include/asm-avr32/tlbflush.h
@@ -26,7 +26,6 @@ extern void flush_tlb_mm(struct mm_struct *mm);
 extern void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end);
 extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long page);
-extern void __flush_tlb_page(unsigned long asid, unsigned long page);
 
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
-- 
1.5.5.4

