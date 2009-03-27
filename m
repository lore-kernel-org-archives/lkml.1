Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbZC0Bv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbZC0Bv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763377AbZC0Bvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:51:44 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:45806 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763164AbZC0Bvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:51:39 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 13/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFB3F5306C.4CEBF166-ON48257586.0009E897-48257586.000A2E5E@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:49:27 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:49:29,
	Serialize complete at 2009/03/27 ?? 09:49:29
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch


diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/ioremap.c 
linux-2.6-git.new/arch/score/mm/ioremap.c
--- linux-2.6-git.ori/arch/score/mm/ioremap.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/ioremap.c   2009-03-23 
14:31:25.000000000 +0800
@@ -0,0 +1,56 @@
+/*
+ * arch/score/mm/ioremap.c
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
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+
+#include <asm/io.h>
+#include <asm/fixmap.h>
+
+/*
+ * Remap an arbitrary physical address space into the kernel virtual
+ * address space. Needed when the kernel wants to access high addresses
+ * directly.
+ *
+ * NOTE! We need to allow non-page-aligned mappings too: we will 
obviously
+ * have to convert them into an offset in a page-aligned mapping, but the
+ * caller shouldn't need to know that small detail.
+ */
+void __iomem *__ioremap(phys_t phys_addr, phys_t size, unsigned long 
flags)
+{
+       if ((phys_addr > PHY_IO_BASE) &&
+           (phys_addr < (PHY_IO_BASE + IO_SPACE_SIZE)))
+               return (void *) (VIRTUAL_IO_BASE + phys_addr - 
PHY_IO_BASE);
+       else
+               return NULL;
+}
+EXPORT_SYMBOL(__ioremap);
+
+void __iounmap(const volatile void __iomem *addr)
+{
+       return;
+}
+EXPORT_SYMBOL(__iounmap);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/Makefile 
linux-2.6-git.new/arch/score/mm/Makefile
--- linux-2.6-git.ori/arch/score/mm/Makefile    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/Makefile    2009-03-24 
08:59:19.000000000 +0800
@@ -0,0 +1,10 @@
+#
+# Makefile for the Linux/SCORE-specific parts of the memory manager.
+#
+
+obj-y  += cache.o dma-default.o extable.o fault.o init.o \
+           tlb-miss.o tlb-score.o ioremap.o pgtable.o
+
+obj-$(CONFIG_HIGHMEM)  += highmem.o
+
+EXTRA_CFLAGS +=
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/pgtable.c 
linux-2.6-git.new/arch/score/mm/pgtable.c
--- linux-2.6-git.ori/arch/score/mm/pgtable.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/pgtable.c   2009-03-23 
14:31:51.000000000 +0800
@@ -0,0 +1,61 @@
+/*
+ * arch/score/mm/pgtable-32.c
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
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <asm/fixmap.h>
+#include <asm/pgtable.h>
+
+void pgd_init(unsigned long page)
+{
+       unsigned long *p = (unsigned long *) page;
+       int i;
+
+       for (i = 0; i < USER_PTRS_PER_PGD; i += 8) {
+               p[i + 0] = (unsigned long) invalid_pte_table;
+               p[i + 1] = (unsigned long) invalid_pte_table;
+               p[i + 2] = (unsigned long) invalid_pte_table;
+               p[i + 3] = (unsigned long) invalid_pte_table;
+               p[i + 4] = (unsigned long) invalid_pte_table;
+               p[i + 5] = (unsigned long) invalid_pte_table;
+               p[i + 6] = (unsigned long) invalid_pte_table;
+               p[i + 7] = (unsigned long) invalid_pte_table;
+       }
+}
+
+void __init pagetable_init(void)
+{
+       unsigned long vaddr;
+       pgd_t *pgd_base;
+
+       /* Initialize the entire pgd. */
+       pgd_init((unsigned long) swapper_pg_dir);
+       pgd_init((unsigned long) swapper_pg_dir
+               + sizeof(pgd_t) * USER_PTRS_PER_PGD);
+
+       pgd_base = swapper_pg_dir;
+       vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/tlb-miss.S 
linux-2.6-git.new/arch/score/mm/tlb-miss.S
--- linux-2.6-git.ori/arch/score/mm/tlb-miss.S  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/tlb-miss.S  2009-03-23 
17:30:15.000000000 +0800
@@ -0,0 +1,205 @@
+/*
+ * arch/score/mm/tlbex.S
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
+#include <asm/scoreregs.h>
+#include <asm/page.h>
+#include <asm/pgtable-bits.h>
+#include <asm/asm.h>
+
+/*
+* After this macro runs, the pte faulted on is
+* in register PTE, a ptr into the table in which
+* the pte belongs is in PTR.
+*/
+       .macro  load_pte, pte, ptr
+       la      \ptr, pgd_current
+       lw      \ptr, [\ptr, 0]
+       mfcr    \pte, cr6
+       srli    \pte, \pte, 22
+       slli    \pte, \pte, 2
+       add     \ptr, \ptr, \pte
+       lw      \ptr, [\ptr, 0]
+       mfcr    \pte, cr6
+       srli    \pte, \pte, 10
+       andi    \pte, 0xffc
+       add     \ptr, \ptr, \pte
+       lw      \pte, [\ptr, 0]
+       .endm
+
+       .macro  pte_reload, ptr
+       lw      \ptr, [\ptr, 0]
+       mtcr    \ptr, cr12
+       nop
+       nop
+       nop
+       nop
+       nop
+       .endm
+
+       .macro do_fault, write
+       SAVE_ALL
+       mfcr    r6, cr6
+       mv      r4, r0
+       ldi     r5, \write
+       la      r8, do_page_fault
+       brl     r8
+       j       ret_from_exception
+       .endm
+
+       .macro  pte_writable, pte, ptr, label
+       andi    \pte, 0x280
+       cmpi.c  \pte, 0x280
+       bne     \label
+       lw      \pte, [\ptr, 0]         /*reload PTE*/
+       .endm
+
+/*
+ * Make PTE writable, update software status bits as well,
+ * then store at PTR.
+ */
+       .macro  pte_makewrite, pte, ptr
+       ori     \pte, 0x426
+       sw      \pte, [\ptr, 0]
+       .endm
+
+       .text
+       .globl  score7_FTLB_refill_Handler
+score7_FTLB_refill_Handler:
+       la      r31, pgd_current        /* get pgd pointer */
+       lw      r31, [r31, 0]           /* get the address of PGD */
+       mfcr    r30, cr6
+       srli    r30, r30, 22            /* PGDIR_SHIFT = 22*/
+       slli    r30, r30, 2 
+       add     r31, r31, r30 
+       lw      r31, [r31, 0]           /* get the address of the start 
address of PTE table */
+
+       mfcr    r30, cr9
+       andi    r30, 0xfff              /* equivalent to get PET index and 
right shift 2 bits */
+       add     r31, r31, r30 
+       lw      r30, [r31, 0]           /* load pte entry */
+       mtcr    r30, cr12
+       nop
+       nop
+       nop
+       nop
+       nop
+       mtrtlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte                             /* 6 cycles to make sure tlb entry 
works */
+
+       .globl  score7_KSEG_refill_Handler
+score7_KSEG_refill_Handler:
+       la      r31, pgd_current        /* get pgd pointer */
+       lw      r31, [r31, 0]           /* get the address of PGD */
+       mfcr    r30, cr6
+       srli    r30, r30, 22            /* PGDIR_SHIFT = 22 */
+       slli    r30, r30, 2 
+       add     r31, r31, r30 
+       lw      r31, [r31, 0]           /* get the address of the start 
address of PTE table */
+
+       mfcr    r30, cr6                /* get Bad VPN */
+       srli    r30, r30, 10
+       andi    r30, 0xffc              /* PTE VPN mask (bit 11~2) */
+ 
+       add     r31, r31, r30
+       lw      r30, [r31, 0]           /* load pte entry */
+       mtcr    r30, cr12
+       nop
+       nop
+       nop
+       nop
+       nop
+       mtrtlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte                             /* 6 cycles to make sure tlb entry 
works */
+
+nopage_tlbl:
+       do_fault        0               /* Read */
+
+       .globl  handle_tlb_refill
+handle_tlb_refill:
+       load_pte        r30, r31
+       pte_writable    r30, r31, handle_tlb_refill_nopage
+       pte_makewrite   r30, r31        /* Access|Modify|Dirty|Valid */
+       pte_reload      r31
+       mtrtlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte
+handle_tlb_refill_nopage:
+       do_fault        0               /* Read */
+
+       .globl  handle_tlb_invaild
+handle_tlb_invaild:
+       load_pte        r30, r31
+       stlb                            /* find faulting entry */
+       pte_writable    r30, r31, handle_tlb_invaild_nopage
+       pte_makewrite   r30, r31        /* Access|Modify|Dirty|Valid */
+       pte_reload      r31
+       mtptlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte
+handle_tlb_invaild_nopage:
+       do_fault        0               /* Read */
+
+       .globl  handle_mod
+handle_mod:
+       load_pte        r30, r31
+       stlb                            /* find faulting entry */
+       andi    r30, _PAGE_WRITE        /* Writable? */
+       cmpz.c  r30
+       beq     nowrite_mod
+       lw      r30, [r31, 0]           /* reload into r30 */
+
+       /* Present and writable bits set, set accessed and dirty bits. */
+       pte_makewrite   r30, r31
+
+       /* Now reload the entry into the tlb. */
+       pte_reload      r31
+       mtptlb
+       nop
+       nop
+       nop
+       nop
+       nop
+       rte
+
+nowrite_mod:
+       do_fault        1       /* Write */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/tlb-score.c 
linux-2.6-git.new/arch/score/mm/tlb-score.c
--- linux-2.6-git.ori/arch/score/mm/tlb-score.c 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/tlb-score.c 2009-03-23 
14:33:28.000000000 +0800
@@ -0,0 +1,250 @@
+/*
+ * arch/score/mm/tlb-score.c
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
+#include <asm/mmu_context.h>
+#include <asm/pgtable.h>
+#include <asm/irq.h>
+
+#define TLBSIZE 32
+
+unsigned long asid_cache=ASID_FIRST_VERSION;
+EXPORT_SYMBOL(asid_cache);
+
+void local_flush_tlb_all(void)
+{
+       unsigned long flags;
+       unsigned long old_ASID;
+       int entry;
+
+       local_irq_save(flags);
+       old_ASID = (get_PEVN() & ASID_MASK);
+       set_PECTX(0);                   /* invalid */
+       entry = get_TLBLOCK();          /* skip locked entries*/
+
+       for (; entry < TLBSIZE; entry++) {
+               set_TLBPT(entry);
+               set_PEVN(KSEG1);
+               barrier();
+               tlb_write_indexed();
+       }
+       set_PEVN(old_ASID);
+       local_irq_restore(flags);
+}
+
+/*
+ * If mm is currently active_mm, we can't really drop it. Instead,
+ * we will get a new one for it.
+ */
+static inline void
+drop_mmu_context(struct mm_struct *mm, unsigned cpu)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       get_new_mmu_context(mm, 0);
+       set_PEVN(cpu_asid(0, mm));
+       local_irq_restore(flags);
+}
+
+void local_flush_tlb_mm(struct mm_struct *mm)
+{
+       if (cpu_context(0, mm) != 0) {
+               drop_mmu_context(mm, 0);
+       }
+}
+
+void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long 
start,
+       unsigned long end)
+{
+       struct mm_struct *mm = vma->vm_mm;
+       unsigned long vma_mm_context = mm->context[0];
+       if (mm->context != 0) {
+               unsigned long flags;
+               int size;
+
+               local_irq_save(flags);
+               size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+               if (size <= TLBSIZE) {
+                       int oldpid = (get_PEVN() & ASID_MASK);
+                       int newpid = vma_mm_context & ASID_MASK;
+
+                       start &= PAGE_MASK;
+                       end += (PAGE_SIZE - 1);
+                       end &= PAGE_MASK;
+                       while (start < end) {
+                               int idx;
+
+                               set_PEVN(start | newpid);
+                               start += PAGE_SIZE;
+                               barrier();
+                               tlb_probe();
+                               idx = get_TLBPT();
+                               set_PECTX(0);
+                               set_PEVN(KSEG1);
+                               if (idx < 0)
+                                       continue;
+                               tlb_write_indexed();
+                       }
+                       set_PEVN(oldpid);
+               } else {
+                       /* Bigger than TLBSIZE, get new ASID directly */
+                       get_new_mmu_context(mm, 0);
+                       if (mm == current->active_mm)
+                               set_PEVN(vma_mm_context & ASID_MASK);
+               }
+               local_irq_restore(flags);
+       }
+}
+
+void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+       unsigned long flags;
+       int size;
+
+       local_irq_save(flags);
+       size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+       if (size <= TLBSIZE) {
+               int pid = get_PEVN();
+
+               start &= PAGE_MASK;
+               end += PAGE_SIZE - 1;
+               end &= PAGE_MASK;
+
+               while (start < end) {
+                       long idx;
+
+                       set_PEVN(start);
+                       start += PAGE_SIZE;
+                       tlb_probe();
+                       idx = get_TLBPT();
+                       if (idx < 0)
+                               continue;
+                       set_PECTX(0);
+                       set_PEVN(KSEG1);
+                       barrier();
+                       tlb_write_indexed();
+               }
+               set_PEVN(pid);
+       } else {
+               local_flush_tlb_all();
+       }
+
+       local_irq_restore(flags);
+}
+
+void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
+{
+       if (!vma || vma->vm_mm->context != 0) {
+               unsigned long flags;
+               int oldpid, newpid, idx;
+               unsigned long vma_ASID=vma->vm_mm->context[0];
+
+               newpid = (vma_ASID & ASID_MASK);
+               page &= PAGE_MASK;
+               local_irq_save(flags);
+               oldpid = (get_PEVN() & ASID_MASK);
+               set_PEVN(page | newpid);
+               barrier();
+               tlb_probe();
+               idx = get_TLBPT();
+               set_PECTX(0);
+               set_PEVN(KSEG1);
+               if (idx < 0)            /* p_bit(31) - 1: miss, 0: hit*/
+                       goto finish;
+               barrier();
+               tlb_write_indexed();
+finish:
+               set_PEVN(oldpid);
+               local_irq_restore(flags);
+       }
+}
+
+/*
+ * This one is only used for pages with the global bit set so we don't 
care
+ * much about the ASID.
+ */
+void local_flush_tlb_one(unsigned long page)
+{
+       unsigned long flags;
+       int oldpid, idx;
+
+       local_irq_save(flags);
+       oldpid = get_PEVN();
+       page &= (PAGE_MASK << 1);
+       set_PEVN(page);
+       barrier();
+       tlb_probe();
+       idx = get_TLBPT();
+       set_PECTX(0);
+       if (idx >= 0) {
+               /* Make sure all entries differ. */
+               set_PEVN(KSEG1);
+               barrier();
+               tlb_write_indexed();
+       }
+       set_PEVN(oldpid);
+       local_irq_restore(flags);
+}
+
+void __update_tlb(struct vm_area_struct *vma, unsigned long address, 
pte_t pte)
+{
+       unsigned long flags;
+       int idx, pid;
+
+       /*
+        * Handle debugger faulting in for debugee.
+        */
+       if (current->active_mm != vma->vm_mm)
+               return;
+
+       pid = get_PEVN() & ASID_MASK;
+
+       local_irq_save(flags);
+       address &= PAGE_MASK;
+       set_PEVN(address | pid);
+       barrier();
+       tlb_probe();
+       idx = get_TLBPT();
+       set_PECTX(pte_val(pte));
+       set_PEVN(address | pid);
+       if (idx < 0)
+               tlb_write_random();
+       else
+               tlb_write_indexed();
+ 
+       set_PEVN(pid);
+       local_irq_restore(flags);
+}
+
+extern void score7_FTLB_refill_Handler(void);
+void __cpuinit tlb_init(void)
+{
+       set_TLBLOCK(0);
+       local_flush_tlb_all();
+       memcpy((void *)(EXCEPTION_VECTOR_BASE_ADDR + 0x100), 
&score7_FTLB_refill_Handler, 0xFC);
+       flush_icache_range(EXCEPTION_VECTOR_BASE_ADDR + 0x100, 
EXCEPTION_VECTOR_BASE_ADDR + 0x1FC);
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/drivers/serial/Kconfig 
linux-2.6-git.new/drivers/serial/Kconfig
--- linux-2.6-git.ori/drivers/serial/Kconfig    2009-03-23 
11:24:50.000000000 +0800
+++ linux-2.6-git.new/drivers/serial/Kconfig    2009-03-23 
17:32:43.000000000 +0800
@@ -1412,4 +1412,31 @@ config SPORT_BAUD_RATE
        default 19200 if (SERIAL_SPORT_BAUD_RATE_19200)
        default 9600 if (SERIAL_SPORT_BAUD_RATE_9600)
 
+config SERIAL_SCT
+       tristate "SunplusCT compatible serial support"
+       depends on (SCORE)
+       select SERIAL_CORE
+       ---help---
+         Most people will say Y or M here, so that they can use serial 
mice,
+         modems and similar devices connecting to the standard serial 
ports.
+
+config SERIAL_SCT_CONSOLE
+       bool "Console on SunplusCT compatible serial port"
+       depends on (SERIAL_SCT)
+       select SERIAL_CORE_CONSOLE
+       ---help---
+         If you don't have a VGA card installed and you say Y here, the
+         kernel will automatically use the first serial line, /dev/ttyS0, 
as
+         system console.
+
+         You can set that using a kernel command line option such as
+         "console=sct_uart,"
+         "console=uart,"
+         and it will switch to normal serial console when the 
corresponding
+         port is ready.
+         "earlycon=sct_uart,"
+         "earlycon=uart,"
+         it will not only setup early console.
+
+         If unsure, say N.
 endmenu
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/drivers/serial/Makefile 
linux-2.6-git.new/drivers/serial/Makefile
--- linux-2.6-git.ori/drivers/serial/Makefile   2009-03-23 
11:24:50.000000000 +0800
+++ linux-2.6-git.new/drivers/serial/Makefile   2009-03-23 
16:08:57.000000000 +0800
@@ -76,3 +76,4 @@ obj-$(CONFIG_SERIAL_OF_PLATFORM_NWPSERIA
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
 obj-$(CONFIG_KGDB_SERIAL_CONSOLE) += kgdboc.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
+obj-$(CONFIG_SERIAL_SCT) += sct_serial.o
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/drivers/serial/sct_serial.c 
linux-2.6-git.new/drivers/serial/sct_serial.c
--- linux-2.6-git.ori/drivers/serial/sct_serial.c       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/drivers/serial/sct_serial.c       2009-03-23 
16:36:35.000000000 +0800
@@ -0,0 +1,546 @@
+/*
+ * File: linux/drivers/serial/sct_serial.c
+ *
+ * Based on: linux/drivers/serial/8250.c
+ * Author: Chang Yu-ming
+ *
+ * Created: Nov 29, 2008
+ * Copyright:   (C) Sunplus Core Technology Co., Ltd.
+ * Description: Driver for SunplusCT  Serial ports.
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
+/*
+ *  Currently don't support modem line status...
+ *  maybe the only 1 need to be care is CTS,
+ *  DCD.DSR seems not too important
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#ifdef CONFIG_SERIAL_SCT_CONSOLE
+#include <linux/console.h>
+#endif
+#include <linux/platform_device.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+#include <asm/irq.h>
+#include <asm/irq.h>
+
+#include "sct_serial.h"
+
+
+/* DEBUG macro*/
+/*
+#define DEBUG_MESSAGE  0
+#if DEBUG_MESSAGE == 1
+#define DEBUG(args...) printk(args)
+#else
+#define DEBUG(args...)
+#endif
+*/
+
+#ifdef CONFIG_SCORE_SIM
+static void send_char(char c)
+{
+       riteb(c, UART_THR);
+       f (c == '\n')
+               writeb('\r', UART_THR);
+}
+#endif
+
+/* send a character to an UART */
+static void
+sct_uart_putc(struct uart_port *port, unsigned char c)
+{
+#ifdef CONFIG_SCORE_SIM
+       send_char(c);
+#else
+       unsigned int base = port->mapbase;
+
+       /* wait until not busy */
+       while (readw(UART_ST(base)) & UART_ST_BY);
+       writeb(c, UART_DR(base));
+
+       if (c == '\n') {
+               while(readw(UART_ST(base)) & UART_ST_BY);
+               writeb('\r', UART_DR(base));
+       }
+#endif
+}
+
+/* get a character from an UART */
+static unsigned char
+sct_uart_getc(struct uart_port *port)
+{
+       unsigned int base = port->mapbase;
+
+#ifdef CONFIG_SCORE_SIM
+       return readb(UART_RBR);
+#else
+       /* wait until receive FIFO is not empty */
+       while(readw(UART_ST(base)) & UART_ST_RE);
+       return readb(UART_DR(base));
+#endif
+}
+
+/* Receive interrupt handler */
+static irqreturn_t
+sct_uart_rxint(int irq, void *dev_id)
+{
+       struct uart_port *port = (struct uart_port *) dev_id;
+       struct tty_struct *tty = port->info->port.tty;
+       unsigned int data, status, base = port->mapbase;
+
+#ifdef CONFIG_SCORE_SIM
+       if (readw(UART_LSR) & 1) {
+               data = readb(UART_RBR);
+               tty_insert_flip_char(tty, data, 0);
+       }
+#else
+       do {
+               data = sct_uart_getc(port);
+               status = readw(UART_ERR(base)) & 0xf;
+               switch (status) {
+               case UART_ERR_OE:
+                       status = TTY_OVERRUN;
+                       break;
+               case UART_ERR_BE:
+                       status = TTY_BREAK;
+                       break;
+               case UART_ERR_PE:
+                       status = TTY_PARITY;
+                       break;
+               case UART_ERR_FE:
+                       status = TTY_FRAME;
+                       break;
+               default:
+                       status = 0;
+               }
+
+               tty_insert_flip_char(tty, data, status);
+       } while (!(readw(UART_ST(base)) & UART_ST_RE));
+#endif
+       tty_flip_buffer_push(tty);
+       return IRQ_HANDLED;
+}
+
+/*
+ * Claim the memory region attached to a UART port.
+ * Called when the driver adds an UART port via
+ * uart_add_one_port().
+ */
+static int
+sct_uart_request_port(struct uart_port *port)
+{
+       if (!request_mem_region(port->mapbase, UART_REGISTER_SPACE, 
"sct_uart"))
+               return -EBUSY;
+
+       return 0;
+}
+
+/*
+ * Release the memory region attached to a UART port.
+ * Called when the driver removes an UART port via
+ * uart_remove_one_port().
+ */
+static void
+sct_uart_release_port(struct uart_port *port)
+{
+       release_mem_region(port->mapbase, UART_REGISTER_SPACE);
+}
+
+/*
+ * Configure a UART port.
+ * Called when the driver adds an UART port.
+ */
+static void
+sct_uart_config_port(struct uart_port *port, int flags)
+{
+       if (flags & UART_CONFIG_TYPE && sct_uart_request_port(port) == 0)
+               port->type = PORT_SCT;
+}
+
+/* Set port type */
+static const char*
+sct_uart_type(struct uart_port *port)
+{
+       return port->type == PORT_SCT ? "SCT_UART" : NULL;
+}
+
+/* Start transmitting bytes. */
+static void
+sct_uart_start_tx(struct uart_port *port)
+{
+       while (1) {
+               sct_uart_putc(port, 
port->info->xmit.buf[port->info->xmit.tail]);
+               port->info->xmit.tail = (port->info->xmit.tail + 1) &
+                                        (UART_XMIT_SIZE - 1);
+               port->icount.tx++;
+               if (uart_circ_empty(&port->info->xmit))
+                       break;
+       }
+}
+
+/* Initialize an UART port */
+static void
+sct_uart_init_port(unsigned int base, int early)
+{
+#ifndef CONFIG_SCORE_SIM
+       unsigned short val = 0;
+
+       /* Clear error and status register */
+       writew(0, UART_ERR(base));
+       writew(0, UART_ST(base));
+
+       /* Set UART baudrate to 1152000 */
+       writew(UART_BAUDRATE, UART_BUD(base));
+
+       /* Set UART Control Register. 8-N-1 */
+       val |= UART_CR_8BITS;   /* Word Length Definition=8 Bits */
+       val &= ~UART_CR_PEN;    /* Disable Party Check */
+       val &= ~UART_CR_SBSEL;  /* Stop-Bit Size Selection: 1 Stop Bit */
+
+       /* don't enable interrupts when init an early port */
+       if (!early) {
+               val |= UART_CR_RIE;     /* Enable receive interrupt */
+               val |= UART_CR_RT;      /* Enable receive timeout 
interrupt */
+       }
+       val |= UART_CR_FEN;     /* Enable FIFO buffer */
+       val |= UART_CR_UEN;     /* Enable UART */
+       writew(val, UART_CR(base));
+#endif
+}
+
+/* Called when an application opens an UART */
+static int
+sct_uart_startup(struct uart_port *port)
+{
+       int retval = 0;
+
+       if ((retval = request_irq(port->irq, sct_uart_rxint, 0,
+                                 "sct_uart", (void *)port))) {
+               return retval;
+       }
+
+       sct_uart_init_port(port->mapbase, 0);
+       return retval;
+}
+
+/* Called when an application closes an UART*/
+static void
+sct_uart_shutdown(struct uart_port *port)
+{
+#ifndef CONFIG_SERIAL_SCT_CONSOLE
+       writew(0, UART_CR(port->mapbase));
+#endif
+       free_irq(port->irq, port);
+}
+
+static void
+sct_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{}
+
+static void
+sct_uart_set_termios(struct uart_port *port, struct ktermios *new,
+                       struct ktermios *old)
+{}
+
+static unsigned int sct_uart_tx_empty(struct uart_port *port)
+{
+       return (readw(UART_ST(port->mapbase)) & UART_ST_TE) ? TIOCSER_TEMT 
: 0;
+}
+
+static void sct_uart_stop_rx(struct uart_port *port)
+{}
+
+static struct uart_ops sct_uart_ops = {
+       .tx_empty       = sct_uart_tx_empty,
+       .stop_rx        = sct_uart_stop_rx,
+       .start_tx       = sct_uart_start_tx,
+       .startup        = sct_uart_startup,
+       .shutdown       = sct_uart_shutdown,
+       .type           = sct_uart_type,
+       .config_port    = sct_uart_config_port,
+       .request_port   = sct_uart_request_port,
+       .release_port   = sct_uart_release_port,
+       .set_mctrl      = sct_uart_set_mctrl,
+       .set_termios    = sct_uart_set_termios,
+};
+
+#ifdef CONFIG_SERIAL_SCT_CONSOLE
+static struct console sct_uart_console;
+#endif
+static struct uart_driver sct_uart_reg = {
+       .owner          = THIS_MODULE,
+       .driver_name    = "sct_uart",
+       .dev_name       = "ttyS",
+       .major           = UART_MAJOR,
+       .minor          = UART_MINOR_START,
+       .nr             = UART_PORT_NR,
+#ifdef CONFIG_SERIAL_SCT_CONSOLE
+       .cons           = &sct_uart_console,
+#else
+       .cons           = NULL,
+#endif
+};
+
+static struct uart_port sct_uart_port[] = {
+       {
+#ifdef CONFIG_SCORE_SIM
+       .mapbase        = (unsigned int) UART_BASE,
+       .irq            = UART_IRQ,
+       .fifosize       = UART_FIFO_SIZE,
+#else
+       .mapbase        = (unsigned int) UART0_BASE,
+       .irq            = UART0_IRQ,
+       .fifosize       = UART0_FIFO_SIZE,
+#endif
+       .iotype         = UPIO_MEM,
+       .ops            = &sct_uart_ops,
+       .flags          = UPF_BOOT_AUTOCONF,
+       .line           = 0,
+       },
+};
+
+static int __init
+sct_uart_probe(struct platform_device *dev)
+{
+       uart_add_one_port(&sct_uart_reg, &sct_uart_port[dev->id]);
+       platform_set_drvdata(dev, &sct_uart_port[dev->id]);
+       return 0;
+}
+
+static int
+sct_uart_remove(struct platform_device *dev)
+{
+       platform_set_drvdata(dev, NULL);
+       uart_remove_one_port(&sct_uart_reg, &sct_uart_port[dev->id]);
+       return 0;
+}
+
+static int
+sct_uart_suspend(struct platform_device *dev, pm_message_t state)
+{
+       uart_suspend_port(&sct_uart_reg, &sct_uart_port[dev->id]);
+       return 0;
+}
+
+static int
+sct_uart_resume(struct platform_device *dev)
+{
+       uart_resume_port(&sct_uart_reg, &sct_uart_port[dev->id]);
+       return 0;
+}
+
+struct platform_device *sct_uart_plat_device0;
+
+static struct platform_driver sct_uart_driver = {
+       .probe          = sct_uart_probe,
+       .remove         = __exit_p(sct_uart_remove),
+       .suspend        = sct_uart_suspend,
+       .resume         = sct_uart_resume,
+       .driver         = {
+               .name   = "sct_uart",
+               .owner  = THIS_MODULE,
+       },
+};
+
+/* Driver module initialization */
+static int __init
+sct_uart_init(void)
+{
+       int retval;
+
+       if ((retval = uart_register_driver(&sct_uart_reg)))
+               return retval;
+
+       sct_uart_plat_device0 = 
platform_device_register_simple("sct_uart",
+                                                                0, NULL, 
0);
+       if (IS_ERR(sct_uart_plat_device0)) {
+               uart_unregister_driver(&sct_uart_reg);
+               return PTR_ERR(sct_uart_plat_device0);
+       }
+
+       if ((retval = platform_driver_register(&sct_uart_driver))) {
+               platform_device_unregister(sct_uart_plat_device0);
+               uart_unregister_driver(&sct_uart_reg);
+       }
+       return 0;
+}
+
+/* Driver module exit */
+static void __exit sct_uart_exit(void)
+{
+       platform_driver_unregister(&sct_uart_driver);
+       platform_device_unregister(sct_uart_plat_device0);
+       uart_unregister_driver(&sct_uart_reg);
+}
+
+module_init(sct_uart_init);
+module_exit(sct_uart_exit);
+MODULE_LICENSE("GPL");
+
+#ifdef CONFIG_SERIAL_SCT_CONSOLE
+asmlinkage void sct_uart_out(const char *s)
+{
+#ifdef CONFIG_SCORE_SIM
+       unsigned int i;
+
+       for (i = 0; *s != '\0'; i++, s++)
+               send_char(*s);
+#else
+       unsigned int i, base = UART0_BASE;
+       unsigned short val = 0;
+
+       if (readw(UART_CR(base)) == 0) {
+               /* Clear error and status register */
+               writew(0, UART_ERR(base));
+               writew(0, UART_ST(base));
+
+               /* Set UART Control Register. 8-N-1 */
+               val |= UART_CR_8BITS;   /* Word Length Definition=8 Bits 
*/
+               val &= ~UART_CR_PEN;    /* Disable Party Check */
+               val &= ~UART_CR_SBSEL;  /* Stop-Bit Size Selection: 1 Stop 
Bit */
+               val |= UART_CR_FEN;     /* Enable FIFO buffer */
+               val |= UART_CR_UEN;     /* Enable UART */
+               writew(val, UART_CR(base));
+       }
+
+       /* Set UART baudrate to 1152000 */
+       writew(UART_BAUDRATE, UART_BUD(base));
+
+       for (i = 0; *s != '\0'; i++, s++) {
+               /* wait until not busy */
+               while (readw(UART_ST(base)) & UART_ST_BY);
+               writeb(*s, UART_DR(base));
+
+               if (*s == '\n') {
+                       while(readw(UART_ST(base)) & UART_ST_BY);
+                       writeb('\r', UART_DR(base));
+               }
+       }
+#endif
+}
+
+static void
+sct_uart_console_write(struct console *con, const char *s, u_int count)
+{
+       int i;
+
+       for (i = 0; i < count; i++, s++)
+               sct_uart_putc(&sct_uart_port[con->index], *s);
+}
+
+static void __init
+sct_uart_console_get_options(struct uart_port *port, int *baud,
+                               int *parity, int *bits)
+{
+       *parity = 'n';
+       *bits = 8;
+       *baud = 115200;
+}
+
+static int __init
+sct_uart_console_setup(struct console *con, char *options)
+{
+       struct uart_port *port;
+       int baud, bits, parity, flow;
+
+       if (con->index == -1 || con->index >= UART_PORT_NR)
+               con->index = 0;
+
+       port = &sct_uart_port[con->index];
+
+       if (options)
+               uart_parse_options(options, &baud, &parity, &bits, &flow);
+       else
+               sct_uart_console_get_options(port, &baud, &parity, &bits);
+
+       return uart_set_options(port, con, baud, parity, bits, flow);
+}
+
+static int __init
+sct_uart_console_early_setup(void)
+{
+       return 0;
+}
+
+
+static struct console sct_uart_console = {
+       .name           = "ttyS",
+       .write          = sct_uart_console_write,
+       .device         = uart_console_device,
+       .setup          = sct_uart_console_setup,
+       .early_setup    = sct_uart_console_early_setup,
+       .flags          = CON_PRINTBUFFER,
+       .index          = -1,
+       .data           = &sct_uart_reg,
+};
+
+static struct console sct_early_uart_console __initdata = {
+       .name   = "uart",
+       .write  = sct_uart_console_write,
+       .flags  = CON_PRINTBUFFER | CON_BOOT,
+       .index  = -1,
+};
+
+/* init an uart console during init calls*/
+static int __init
+sct_uart_console_init(void)
+{
+#ifdef CONFIG_SCORE_SIM
+       sct_uart_init_port(UART_BASE, 0);
+#else
+       sct_uart_init_port(UART0_BASE, 0);
+#endif
+       register_console(&sct_uart_console);
+       return 0;
+}
+console_initcall(sct_uart_console_init);
+
+/*
+ * setup an early uart console when user
+ * specifies "earlycon" option.
+ */
+int __init
+setup_early_sct_uart_console(char *cmdline)
+{
+       char *options;
+
+       options = strstr(cmdline, "sct_uart,");
+
+       if (!options) {
+               options = strstr(cmdline, "uart,");
+               if (!options)
+                       return 0;
+       }
+
+#ifdef CONFIG_SCORE_SIM
+       sct_uart_init_port(UART_BASE, 1);
+#else
+       sct_uart_init_port(UART0_BASE, 1);
+#endif
+       register_console(&sct_early_uart_console);
+       return 0;
+}
+early_param("earlycon", setup_early_sct_uart_console);
+
+#endif /* CONFIG_SERIAL_SCT_CONSOLE */
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/drivers/serial/sct_serial.h 
linux-2.6-git.new/drivers/serial/sct_serial.h
--- linux-2.6-git.ori/drivers/serial/sct_serial.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/drivers/serial/sct_serial.h       2009-03-23 
16:42:24.000000000 +0800
@@ -0,0 +1,138 @@
+/*
+ * File: linux/drivers/serial/sct_serial.h
+ *
+ * Based on: linux/drivers/serial/8250.h
+ * Author: Chang Yu-ming
+ *
+ * Created: Nov 29, 2008
+ * Copyright:   (C) Sunplus Core Technology Co., Ltd.
+ * Description: Driver for SunplusCT  Serial ports.
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
+#ifndef _SCT_SERIAL_H_
+#define _SCT_SERIAL_H_
+
+#define UART_MAJOR             4
+#define UART_MINOR_START       64
+#define UART_PORT_NR           1
+
+/* define UART IRQ */
+#define UART0_IRQ              16
+#define UART_IRQ               16
+
+/* define UART I/O base address */
+#if defined(CONFIG_MACH_SPG300) || defined(CONFIG_MACH_SPCT6600)
+#define UART0_BASE             0x96070000
+#define UART_REGISTER_SPACE    0x24
+#define UART0_FIFO_SIZE                8
+#elif defined(CONFIG_SCORE_SIM)
+#define UART_BASE              0x88250000
+#define UART_REGISTER_SPACE    0x18
+#define UART_FIFO_SIZE         1
+#endif
+
+/* define UART baudrate parameter */
+#if defined(CONFIG_MACH_IAB050) || defined(CONFIG_SCORE_SPG300)
+#define UART_BAUDRATE          233
+#elif defined(CONFIG_MACH_SCT6600_TWN)
+#define UART_BAUDRATE          70
+#elif defined(CONFIG_MACH_SPG300) || defined(CONFIG_MACH_SPCT6600)
+#define UART_BAUDRATE          0x39            //27Mhz
+#elif defined(CONFIG_MACH_SCT6600_SD)
+#define UART_BAUDRATE          0xe9
+#elif defined(CONFIG_MACH_SCT6600_USB)
+#define UART_BAUDRATE          0x33
+#else
+#define UART_BAUDRATE          0                //Don't care
+#endif
+
+/* define UART register address */
+#ifdef CONFIG_SCORE_SIM
+#define UART_RBR               (UART_BASE+0x00)        /* Rx buffer */
+#define UART_THR               (UART_BASE+0x00)        /* Tx buffer */
+#define UART_IER               (UART_BASE+0x04)        /* interrupt 
enable */
+#define UART_LSR               (UART_BASE+0x14)        /* line status */
+#else
+#define UART_DR(_base)         (_base+0x00)            /* Rx\Tx buffer */
+#define UART_ERR(_base)                (_base+0x04)            /* Rx\Tx 
Error Flag Register */
+#define UART_CR(_base)         (_base+0x08)            /* Conrol register 
*/
+#define UART_BUD(_base)                (_base+0x0C)            /* Baud 
Rate Setup Register */
+#define UART_ST(_base)         (_base+0x10)            /* Status Register 
*/
+#define UART_IRDABUD(_base)    (_base+0x14)            /* IRDA Baud Rate 
Setup Register */
+#define UART_IRDALP(_base)     (_base+0x18)            /* IRDA Low Power 
Setup Register */
+#define UART_IRDACR(_base)     (_base+0x1C)            /* IRDA Control 
Register */
+#define UART_TWTR(_base)       (_base+0x20)            /* Transmitter 
Waiting time Register */
+#endif
+
+
+/*
+ * Bit definition of Rx/Tx error flag register
+ *   rUARTEFR    (_base+0x04)
+ */
+#define UART_ERR_RXD           (1 << 15)       /* UART RXD signal, 0: in 
process of receiving data
+                                                       1: receive data 
have completed */
+#define UART_ERR_OE            (1 << 3)        /* overrun error */
+#define UART_ERR_BE            (1 << 2)        /* break error */
+#define UART_ERR_PE            (1 << 1)        /* parity error */
+#define UART_ERR_FE            1               /* frame error */
+
+/*
+ * Bit definition of control register:
+ *   rUARTCR    (_base+0x04)
+ */
+#define UART_CR_RIE            (1 << 15)       /* receive interrupt 
enable */
+#define UART_CR_TIE            (1 << 14)       /* transmit interrupt 
enable */
+#define UART_CR_RT             (1 << 13)       /* receive timeout 
interrupt enable */
+#define UART_CR_UEN            (1 << 12)       /* UART enable */
+#define UART_CR_MSIE           (1 << 11)       /* modem status interrupt 
enable */
+#define UART_CR_SLT            (1 << 10)       /* self loop test */
+#define UART_CR_MEN            (1 << 9)        /* modem enable */
+#define UART_CR_WKUEN          (1 << 8)        /* wake up enable */
+#define UART_CR_8BITS          (0x3 << 5)
+#define UART_CR_7BITS          (0x2 << 5)
+#define UART_CR_6BITS          (0x1 << 5)
+#define UART_CR_5BITS          0x0
+#define UART_CR_FEN            (1 << 4)        /* FIFO buffer enable */
+#define UART_CR_SBSEL          (1 << 3)        /* stop bit size 
selection, 0: one stop bit, 1: two stop bits */
+#define UART_CR_PSEL           (1 << 2)        /* parity selection, 0: 
odd parity, 1: even parity */
+#define UART_CR_PEN            (1 << 1)        /* parity enable */
+#define UART_CR_SB             1               /* send break */
+
+/*
+ * Bit definition of status register
+ *   rUARTST     (_base+0x10)
+ */
+#define UART_ST_RI             (1 << 15)       /* receive interrupt flag 
*/
+#define UART_ST_TI             (1 << 14)       /* transmit interrupt flag 
*/
+#define UART_ST_RT             (1 << 13)       /* receive timeout 
interrupt flag */
+#define UART_ST_MIT            (1 << 12)       /* modem status interrupt 
flag */
+#define UART_ST_MRI            (1 << 10)       /* complement of 
nUARTRI(Ring Indicator) modem status input */
+#define UART_ST_RTS            (1 << 9)        /* modem output (Request 
to Send) */
+#define UART_ST_DTR            (1 << 8)        /* modem output (Data 
Terminal Ready) */
+#define UART_ST_TE             (1 << 7)        /* transmit FIFO empty 
flag */
+#define UART_ST_RF             (1 << 6)        /* receive FIFO full flag 
*/
+#define UART_ST_TF             (1 << 5)        /* transmit FIFO full flag 
*/
+#define UART_ST_RE             (1 << 4)        /* receive FIFO empty flag 
*/
+#define UART_ST_BY             (1 << 3)        /* busy */
+#define UART_ST_MDCD           (1 << 2)        /* complement of 
nUARTDCD(Data Carrier Detect) modem status input */
+#define UART_ST_MDSR           (1 << 1)        /* complement of 
nUARTDSR(Data Set Ready) modem status input */
+#define UART_ST_MCTS           1               /* complement of 
nUARTCTS(Clear to Send) modem status input */
+
+#define PORT_SCT               86
+#endif /* _SCT_SERIAL_H_ */
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/MAINTAINERS linux-2.6-git.new/MAINTAINERS
--- linux-2.6-git.ori/MAINTAINERS       2009-03-23 11:24:36.000000000 
+0800
+++ linux-2.6-git.new/MAINTAINERS       2009-03-23 17:32:21.000000000 
+0800
@@ -3772,6 +3772,14 @@ M:       rml@tech9.net
 L:     linux-kernel@vger.kernel.org
 S:     Maintained
 
+SCORE ARCHITECTURE
+P:     Chen Liqin
+M:     liqin.chen@sunplusct.com
+P:     Lennox Wu
+M:     lennox.wu@sunplusct.com
+W:     http://www.sunplusct.com
+S:     Supported
+
 SCSI CDROM DRIVER
 P:     Jens Axboe
 M:     axboe@kernel.dk

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
