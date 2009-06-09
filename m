Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbZFIGne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbZFIGne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZFIGnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:43:25 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:46270 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbZFIGnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:43:21 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 26/27] score: create mm files cache.c extable.c fault.c init.c
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF6C8C1388.34499E4F-ON482575D0.00246FC1-482575D0.0024E068@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:38:30 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:38:30,
	Serialize complete at 2009/06/09 ?? 02:38:30
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a8b318df27a959dc552d99f6502e24e35b33e2a1 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:19 +0800
Subject: [PATCH 26/27] score: create mm files cache.c extable.c fault.c 
init.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/mm/cache.c   |  308 
+++++++++++++++++++++++++++++++++++++++++++++++
 arch/score/mm/extable.c |   38 ++++++
 arch/score/mm/fault.c   |  235 ++++++++++++++++++++++++++++++++++++
 arch/score/mm/init.c    |  173 ++++++++++++++++++++++++++
 4 files changed, 754 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/mm/cache.c
 create mode 100644 arch/score/mm/extable.c
 create mode 100644 arch/score/mm/fault.c
 create mode 100644 arch/score/mm/init.c

diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
new file mode 100644
index 0000000..1ebc67f
--- /dev/null
+++ b/arch/score/mm/cache.c
@@ -0,0 +1,308 @@
+/*
+ * arch/score/mm/cache.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+
+#include <asm/mmu_context.h>
+
+/* Cache operations. */
+void (*flush_cache_all)(void);
+void (*__flush_cache_all)(void);
+void (*flush_cache_mm)(struct mm_struct *mm);
+void (*flush_cache_range)(struct vm_area_struct *vma,
+                       unsigned long start, unsigned long end);
+void (*flush_cache_page)(struct vm_area_struct *vma,
+                       unsigned long page, unsigned long pfn);
+void (*flush_icache_range)(unsigned long start, unsigned long end);
+void (*__flush_cache_vmap)(void);
+void (*__flush_cache_vunmap)(void);
+void (*flush_cache_sigtramp)(unsigned long addr);
+void (*flush_data_cache_page)(unsigned long addr);
+EXPORT_SYMBOL(flush_data_cache_page);
+void (*flush_icache_all)(void);
+
+/*Score 7 cache operations*/
+static inline void s7___flush_cache_all(void);
+static void s7_flush_cache_mm(struct mm_struct *mm);
+static void s7_flush_cache_range(struct vm_area_struct *vma,
+                               unsigned long start, unsigned long end);
+static void s7_flush_cache_page(struct vm_area_struct *vma,
+                               unsigned long page, unsigned long pfn);
+static void s7_flush_icache_range(unsigned long start, unsigned long 
end);
+static void s7_flush_cache_sigtramp(unsigned long addr);
+static void s7_flush_data_cache_page(unsigned long addr);
+static void s7_flush_dcache_range(unsigned long start, unsigned long 
end);
+
+void __update_cache(struct vm_area_struct *vma, unsigned long address,
+               pte_t pte)
+{
+       struct page *page;
+       unsigned long pfn, addr;
+       int exec = (vma->vm_flags & VM_EXEC);
+
+       pfn = pte_pfn(pte);
+       if (unlikely(!pfn_valid(pfn)))
+               return;
+       page = pfn_to_page(pfn);
+       if (page_mapping(page) && test_bit(PG_arch_1, &page->flags)) {
+               addr = (unsigned long) page_address(page);
+               if (exec)
+                       s7_flush_data_cache_page(addr);
+               clear_bit(PG_arch_1, &page->flags);
+       }
+}
+
+static inline void setup_protection_map(void)
+{
+       protection_map[0] = PAGE_NONE;
+       protection_map[1] = PAGE_READONLY;
+       protection_map[2] = PAGE_COPY;
+       protection_map[3] = PAGE_COPY;
+       protection_map[4] = PAGE_READONLY;
+       protection_map[5] = PAGE_READONLY;
+       protection_map[6] = PAGE_COPY;
+       protection_map[7] = PAGE_COPY;
+       protection_map[8] = PAGE_NONE;
+       protection_map[9] = PAGE_READONLY;
+       protection_map[10] = PAGE_SHARED;
+       protection_map[11] = PAGE_SHARED;
+       protection_map[12] = PAGE_READONLY;
+       protection_map[13] = PAGE_READONLY;
+       protection_map[14] = PAGE_SHARED;
+       protection_map[15] = PAGE_SHARED;
+}
+
+void __devinit cpu_cache_init(void)
+{
+       flush_cache_all = s7_flush_cache_all;
+       __flush_cache_all = s7___flush_cache_all;
+       flush_cache_mm = s7_flush_cache_mm;
+       flush_cache_range = s7_flush_cache_range;
+       flush_cache_page = s7_flush_cache_page;
+       flush_icache_range = s7_flush_icache_range;
+       flush_cache_sigtramp = s7_flush_cache_sigtramp;
+       flush_data_cache_page = s7_flush_data_cache_page;
+
+       setup_protection_map();
+}
+
+void s7_flush_icache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_icache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+void s7_flush_dcache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_dcache_all\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+void s7_flush_cache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_cache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+void s7___flush_cache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_cache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       : : : "r8");
+}
+
+static void s7_flush_cache_mm(struct mm_struct *mm)
+{
+       if (!(mm->context))
+               return;
+       s7_flush_cache_all();
+}
+
+/*if we flush a range precisely , the processing may be very long.
+We must check each page in the range whether present. If the page is 
present,
+we can flush the range in the page. Be careful, the range may be cross 
two
+page, a page is present and another is not present.
+*/
+/*
+The interface is provided in hopes that the port can find
+a suitably efficient method for removing multiple page
+sized regions from the cache.
+*/
+static void
+s7_flush_cache_range(struct vm_area_struct *vma,
+               unsigned long start, unsigned long end)
+{
+       struct mm_struct *mm = vma->vm_mm;
+       int exec = vma->vm_flags & VM_EXEC;
+       pgd_t *pgdp;
+       pud_t *pudp;
+       pmd_t *pmdp;
+       pte_t *ptep;
+
+       if (!(mm->context))
+               return;
+
+       pgdp = pgd_offset(mm, start);
+       pudp = pud_offset(pgdp, start);
+       pmdp = pmd_offset(pudp, start);
+       ptep = pte_offset(pmdp, start);
+
+       while (start <= end) {
+               unsigned long tmpend;
+               pgdp = pgd_offset(mm, start);
+               pudp = pud_offset(pgdp, start);
+               pmdp = pmd_offset(pudp, start);
+               ptep = pte_offset(pmdp, start);
+
+               if (!(pte_val(*ptep) & _PAGE_PRESENT)) {
+                       start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+                       continue;
+               }
+               tmpend = (start | (PAGE_SIZE-1)) > end ?
+                                end : (start | (PAGE_SIZE-1));
+
+               s7_flush_dcache_range(start, tmpend);
+               if (exec)
+                       s7_flush_icache_range(start, tmpend);
+               start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+       }
+}
+
+static void
+s7_flush_cache_page(struct vm_area_struct *vma,
+               unsigned long addr, unsigned long pfn)
+{
+       int exec = vma->vm_flags & VM_EXEC;
+       unsigned long kaddr = 0xa0000000 | (pfn << PAGE_SHIFT);
+
+       s7_flush_dcache_range(kaddr, kaddr + PAGE_SIZE);
+
+       if (exec)
+               s7_flush_icache_range(kaddr, kaddr + PAGE_SIZE);
+}
+
+static void s7_flush_cache_sigtramp(unsigned long addr)
+{
+       __asm__ __volatile__(
+       "cache 0x02, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       "cache 0x02, [%0, 0x4]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+
+       "cache 0x0d, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       "cache 0x0d, [%0, 0x4]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+
+       "cache 0x1a, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (addr));
+}
+
+/*
+Just flush entire Dcache!!
+You must ensure the page doesn't include instructions, because
+the function will not flush the Icache.
+The addr must be cache aligned.
+*/
+static void s7_flush_data_cache_page(unsigned long addr)
+{
+       unsigned int i;
+       for (i = 0; i < (PAGE_SIZE / L1_CACHE_BYTES); i += L1_CACHE_BYTES) 
{
+               __asm__ __volatile__(
+               "cache 0x0e, [%0, 0]\n"
+               "cache 0x1a, [%0, 0]\n"
+               "nop\n"
+               : : "r" (addr));
+               addr += L1_CACHE_BYTES;
+       }
+}
+
+/*
+1. WB and invalid a cache line of Dcache
+2. Drain Write Buffer
+the range must be smaller than PAGE_SIZE
+*/
+static void s7_flush_dcache_range(unsigned long start, unsigned long end)
+{
+       int size, i;
+
+       start = start & ~(L1_CACHE_BYTES - 1);
+       end = end & ~(L1_CACHE_BYTES - 1);
+       size = end - start;
+       /* flush dcache to ram, and invalidate dcache lines. */
+       for (i = 0; i < size; i += L1_CACHE_BYTES) {
+               __asm__ __volatile__(
+               "cache 0x0e, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               "cache 0x1a, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (start));
+               start += L1_CACHE_BYTES;
+       }
+}
+
+static void s7_flush_icache_range(unsigned long start, unsigned long end)
+{
+       int size, i;
+       start = start & ~(L1_CACHE_BYTES - 1);
+       end = end & ~(L1_CACHE_BYTES - 1);
+
+       size = end - start;
+       /* invalidate icache lines. */
+       for (i = 0; i < size; i += L1_CACHE_BYTES) {
+               __asm__ __volatile__(
+               "cache 0x02, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               : : "r" (start));
+               start += L1_CACHE_BYTES;
+       }
+}
diff --git a/arch/score/mm/extable.c b/arch/score/mm/extable.c
new file mode 100644
index 0000000..01ff644
--- /dev/null
+++ b/arch/score/mm/extable.c
@@ -0,0 +1,38 @@
+/*
+ * arch/score/mm/extable.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+       const struct exception_table_entry *fixup;
+
+       fixup = search_exception_tables(regs->cp0_epc);
+       if (fixup) {
+               regs->cp0_epc = fixup->fixup;
+               return 1;
+       }
+       return 0;
+}
diff --git a/arch/score/mm/fault.c b/arch/score/mm/fault.c
new file mode 100644
index 0000000..47b600e
--- /dev/null
+++ b/arch/score/mm/fault.c
@@ -0,0 +1,235 @@
+/*
+ * arch/score/mm/fault.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ */
+asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
+                               unsigned long address)
+{
+       struct vm_area_struct *vma = NULL;
+       struct task_struct *tsk = current;
+       struct mm_struct *mm = tsk->mm;
+       const int field = sizeof(unsigned long) * 2;
+       siginfo_t info;
+       int fault;
+
+       info.si_code = SEGV_MAPERR;
+
+       /*
+       * We fault-in kernel-space virtual memory on-demand. The
+       * 'reference' page table is init_mm.pgd.
+       *
+       * NOTE! We MUST NOT take any locks for this case. We may
+       * be in an interrupt or a critical region, and should
+       * only copy the information from the master page table,
+       * nothing more.
+       */
+       if (unlikely(address >= VMALLOC_START && address <= VMALLOC_END))
+               goto vmalloc_fault;
+#ifdef MODULE_START
+       if (unlikely(address >= MODULE_START && address < MODULE_END))
+               goto vmalloc_fault;
+#endif
+
+       /*
+       * If we're in an interrupt or have no user
+       * context, we must not take the fault..
+       */
+       if (in_atomic() || !mm)
+               goto bad_area_nosemaphore;
+
+       down_read(&mm->mmap_sem);
+       vma = find_vma(mm, address);
+       if (!vma)
+               goto bad_area;
+       if (vma->vm_start <= address)
+               goto good_area;
+       if (!(vma->vm_flags & VM_GROWSDOWN))
+               goto bad_area;
+       if (expand_stack(vma, address))
+               goto bad_area;
+       /*
+       * Ok, we have a good vm_area for this memory access, so
+       * we can handle it..
+        */
+good_area:
+       info.si_code = SEGV_ACCERR;
+
+       if (write) {
+               if (!(vma->vm_flags & VM_WRITE))
+                       goto bad_area;
+       } else {
+               if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
+                       goto bad_area;
+       }
+
+survive:
+       /*
+       * If for any reason at all we couldn't handle the fault,
+       * make sure we exit gracefully rather than endlessly redo
+       * the fault.
+       */
+       fault = handle_mm_fault(mm, vma, address, write);
+       if (unlikely(fault & VM_FAULT_ERROR)) {
+               if (fault & VM_FAULT_OOM)
+                       goto out_of_memory;
+               else if (fault & VM_FAULT_SIGBUS)
+                       goto do_sigbus;
+               BUG();
+       }
+       if (fault & VM_FAULT_MAJOR)
+               tsk->maj_flt++;
+       else
+               tsk->min_flt++;
+
+       up_read(&mm->mmap_sem);
+       return;
+
+       /*
+       * Something tried to access memory that isn't in our memory map..
+       * Fix it, but check if it's kernel or user first..
+        */
+bad_area:
+       up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+       /* User mode accesses just cause a SIGSEGV */
+       if (user_mode(regs)) {
+               tsk->thread.cp0_badvaddr = address;
+               tsk->thread.error_code = write;
+               info.si_signo = SIGSEGV;
+               info.si_errno = 0;
+               /* info.si_code has been set above */
+               info.si_addr = (void __user *) address;
+               force_sig_info(SIGSEGV, &info, tsk);
+               return;
+       }
+
+no_context:
+       /* Are we prepared to handle this kernel fault? */
+       if (fixup_exception(regs)) {
+               current->thread.cp0_baduaddr = address;
+               return;
+       }
+
+       /*
+       * Oops. The kernel tried to access some bad page. We'll have to
+       * terminate things with extreme prejudice.
+       */
+       bust_spinlocks(1);
+
+       printk(KERN_ALERT "CPU %d Unable to handle kernel paging request 
at "
+                       "virtual address %0*lx, epc == %0*lx, ra == 
%0*lx\n",
+                       0, field, address, field, regs->cp0_epc,
+                       field, regs->regs[3]);
+       die("Oops", regs);
+
+       /*
+       * We ran out of memory, or some other thing happened to us that 
made
+       * us unable to handle the page fault gracefully.
+       */
+out_of_memory:
+       up_read(&mm->mmap_sem);
+       if (is_global_init(tsk)) {
+               yield();
+               down_read(&mm->mmap_sem);
+               goto survive;
+       }
+       printk("VM: killing process %s\n", tsk->comm);
+       if (user_mode(regs))
+               do_group_exit(SIGKILL);
+       goto no_context;
+
+do_sigbus:
+       up_read(&mm->mmap_sem);
+       /* Kernel mode? Handle exceptions or die */
+       if (!user_mode(regs))
+               goto no_context;
+       else
+       /*
+       * Send a sigbus, regardless of whether we were in kernel
+       * or user mode.
+       */
+       tsk->thread.cp0_badvaddr = address;
+       info.si_signo = SIGBUS;
+       info.si_errno = 0;
+       info.si_code = BUS_ADRERR;
+       info.si_addr = (void __user *) address;
+       force_sig_info(SIGBUS, &info, tsk);
+       return;
+vmalloc_fault:
+       {
+               /*
+               * Synchronize this task's top level page-table
+               * with the 'reference' page table.
+               *
+               * Do _not_ use "tsk" here. We might be inside
+               * an interrupt in the middle of a task switch..
+               */
+               int offset = __pgd_offset(address);
+               pgd_t *pgd, *pgd_k;
+               pud_t *pud, *pud_k;
+               pmd_t *pmd, *pmd_k;
+               pte_t *pte_k;
+
+               pgd = (pgd_t *) pgd_current + offset;
+               pgd_k = init_mm.pgd + offset;
+
+               if (!pgd_present(*pgd_k))
+                       goto no_context;
+               set_pgd(pgd, *pgd_k);
+
+               pud = pud_offset(pgd, address);
+               pud_k = pud_offset(pgd_k, address);
+               if (!pud_present(*pud_k))
+                       goto no_context;
+
+               pmd = pmd_offset(pud, address);
+               pmd_k = pmd_offset(pud_k, address);
+               if (!pmd_present(*pmd_k))
+                       goto no_context;
+               set_pmd(pmd, *pmd_k);
+
+               pte_k = pte_offset_kernel(pmd_k, address);
+               if (!pte_present(*pte_k))
+                       goto no_context;
+               return;
+       }
+}
diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
new file mode 100644
index 0000000..7780eec
--- /dev/null
+++ b/arch/score/mm/init.c
@@ -0,0 +1,173 @@
+/*
+ * arch/score/mm/init.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/errno.h>
+#include <linux/bootmem.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/pagemap.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <asm-generic/sections.h>
+
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+/*
+ * We have up to 8 empty zeroed pages so we can map one of the right 
colour
+ * when needed.
+ */
+unsigned long zero_page_mask;
+unsigned long empty_zero_page;
+EXPORT_SYMBOL_GPL(empty_zero_page);
+
+static struct kcore_list kcore_mem, kcore_vmalloc;
+
+unsigned long setup_zero_pages(void)
+{
+       unsigned int order = 0;
+       unsigned long size;
+       struct page *page;
+
+       empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 
order);
+       if (!empty_zero_page)
+               panic("Oh boy, that early out of memory?");
+
+       page = virt_to_page((void *) empty_zero_page);
+       split_page(page, order);
+       while (page < virt_to_page((void *) (empty_zero_page +
+                                            (PAGE_SIZE << order)))) {
+               SetPageReserved(page);
+               page++;
+       }
+
+       size = PAGE_SIZE << order;
+       zero_page_mask = (size - 1) & PAGE_MASK;
+
+       return 1UL << order;
+}
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+static int __init page_is_ram(unsigned long pagenr)
+{
+       if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
+               return 1;
+       else
+               return 0;
+}
+
+void __init paging_init(void)
+{
+       unsigned long max_zone_pfns[MAX_NR_ZONES];
+       unsigned long lastpfn;
+
+       pagetable_init();
+       max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+       lastpfn = max_low_pfn;
+       free_area_init_nodes(max_zone_pfns);
+}
+
+void __init mem_init(void)
+{
+       unsigned long codesize, reservedpages, datasize, initsize;
+       unsigned long tmp, ram = 0;
+
+       max_mapnr = max_low_pfn;
+       high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
+       totalram_pages += free_all_bootmem();
+       totalram_pages -= setup_zero_pages();   /* Setup zeroed pages. */
+       reservedpages = 0;
+
+       for (tmp = 0; tmp < max_low_pfn; tmp++)
+               if (page_is_ram(tmp)) {
+                       ram++;
+                       if (PageReserved(pfn_to_page(tmp)))
+                               reservedpages++;
+               }
+
+       num_physpages = ram;
+       codesize = (unsigned long) &_etext - (unsigned long) &_text;
+       datasize = (unsigned long) &_edata - (unsigned long) &_etext;
+       initsize = (unsigned long) &__init_end - (unsigned long) 
&__init_begin;
+
+       kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+       kclist_add(&kcore_vmalloc, (void *) VMALLOC_START,
+                       VMALLOC_END - VMALLOC_START);
+
+       printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
+                       "%ldk reserved, %ldk data, %ldk init, %ldk 
highmem)\n",
+                       (unsigned long) nr_free_pages() << 
(PAGE_SHIFT-10),
+                       ram << (PAGE_SHIFT-10), codesize >> 10,
+                       reservedpages << (PAGE_SHIFT-10), datasize >> 10,
+                       initsize >> 10,
+                       (unsigned long) (totalhigh_pages << 
(PAGE_SHIFT-10)));
+}
+#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+
+void free_init_pages(const char *what, unsigned long begin, unsigned long 
end)
+{
+       unsigned long pfn;
+
+       for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
+               struct page *page = pfn_to_page(pfn);
+               void *addr = phys_to_virt(PFN_PHYS(pfn));
+
+               ClearPageReserved(page);
+               init_page_count(page);
+               memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
+               __free_page(page);
+               totalram_pages++;
+       }
+       printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) 
>> 10);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+       free_init_pages("initrd memory",
+       virt_to_phys((void *) start),
+       virt_to_phys((void *) end));
+}
+#endif
+
+void __init_refok free_initmem(void)
+{
+       free_init_pages("unused kernel memory",
+           (unsigned long)__init_begin, (unsigned long)__init_end);
+}
+
+unsigned long pgd_current;
+
+#define __page_aligned(order) 
__attribute__((__aligned__(PAGE_SIZE<<order)))
+
+/*
+ * gcc 3.3 and older have trouble determining that PTRS_PER_PGD and 
PGD_ORDER
+ * are constants.  So we use the variants from asm-offset.h until that 
gcc
+ * will officially be retired.
+ */
+pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
-- 
1.6.2

