Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbZFIGn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbZFIGn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbZFIGnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:43:47 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:46375 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbZFIGnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:43:45 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Subject: [PATCH 27/27] score: create mm files Makefile pgtable.c tlb-miss.S
 tlb-score.c MAINTAINERS
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF3FCD7D17.46B74348-ON482575D0.00247D15-482575D0.0024EF46@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:39:08 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:39:08,
	Serialize complete at 2009/06/09 ?? 02:39:08
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d6d79cbcf39cd522208231ed717e1c12e5401b33 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:20 +0800
Subject: [PATCH 27/27] score: create mm files Makefile pgtable.c 
tlb-miss.S tlb-score.c MAINTAINERS


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 MAINTAINERS               |    8 ++
 arch/score/mm/Makefile    |    8 ++
 arch/score/mm/pgtable.c   |   60 +++++++++++
 arch/score/mm/tlb-miss.S  |  204 ++++++++++++++++++++++++++++++++++++
 arch/score/mm/tlb-score.c |  251 
+++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 531 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/mm/Makefile
 create mode 100644 arch/score/mm/pgtable.c
 create mode 100644 arch/score/mm/tlb-miss.S
 create mode 100644 arch/score/mm/tlb-score.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b349ba..d6993a1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4881,6 +4881,14 @@ S:       Maintained
 F:     kernel/sched*
 F:     include/linux/sched.h
 
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
diff --git a/arch/score/mm/Makefile b/arch/score/mm/Makefile
new file mode 100644
index 0000000..6da8ce5
--- /dev/null
+++ b/arch/score/mm/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the Linux/SCORE-specific parts of the memory manager.
+#
+
+obj-y += cache.o extable.o fault.o init.o \
+       tlb-miss.o tlb-score.o pgtable.o
+
+EXTRA_CFLAGS +=
diff --git a/arch/score/mm/pgtable.c b/arch/score/mm/pgtable.c
new file mode 100644
index 0000000..10b0962
--- /dev/null
+++ b/arch/score/mm/pgtable.c
@@ -0,0 +1,60 @@
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
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/pfn.h>
+#include <linux/mm.h>
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
diff --git a/arch/score/mm/tlb-miss.S b/arch/score/mm/tlb-miss.S
new file mode 100644
index 0000000..bd5face
--- /dev/null
+++ b/arch/score/mm/tlb-miss.S
@@ -0,0 +1,204 @@
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
+#include <asm/asmmacro.h>
+#include <asm/pgtable-bits.h>
+#include <asm/scoreregs.h>
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
diff --git a/arch/score/mm/tlb-score.c b/arch/score/mm/tlb-score.c
new file mode 100644
index 0000000..4fa5aa5
--- /dev/null
+++ b/arch/score/mm/tlb-score.c
@@ -0,0 +1,251 @@
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
+#include <linux/highmem.h>
+#include <linux/module.h>
+
+#include <asm/irq.h>
+#include <asm/mmu_context.h>
+#include <asm/tlb.h>
+
+#define TLBSIZE 32
+
+unsigned long asid_cache = ASID_FIRST_VERSION;
+EXPORT_SYMBOL(asid_cache);
+
+void local_flush_tlb_all(void)
+{
+       unsigned long flags;
+       unsigned long old_ASID;
+       int entry;
+
+       local_irq_save(flags);
+       old_ASID = pevn_get() & ASID_MASK;
+       pectx_set(0);                   /* invalid */
+       entry = tlblock_get();          /* skip locked entries*/
+
+       for (; entry < TLBSIZE; entry++) {
+               tlbpt_set(entry);
+               pevn_set(KSEG1);
+               barrier();
+               tlb_write_indexed();
+       }
+       pevn_set(old_ASID);
+       local_irq_restore(flags);
+}
+
+/*
+ * If mm is currently active_mm, we can't really drop it. Instead,
+ * we will get a new one for it.
+ */
+static inline void
+drop_mmu_context(struct mm_struct *mm)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       get_new_mmu_context(mm);
+       pevn_set(mm->context & ASID_MASK);
+       local_irq_restore(flags);
+}
+
+void local_flush_tlb_mm(struct mm_struct *mm)
+{
+       if (mm->context != 0)
+               drop_mmu_context(mm);
+}
+
+void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long 
start,
+       unsigned long end)
+{
+       struct mm_struct *mm = vma->vm_mm;
+       unsigned long vma_mm_context = mm->context;
+       if (mm->context != 0) {
+               unsigned long flags;
+               int size;
+
+               local_irq_save(flags);
+               size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
+               if (size <= TLBSIZE) {
+                       int oldpid = pevn_get() & ASID_MASK;
+                       int newpid = vma_mm_context & ASID_MASK;
+
+                       start &= PAGE_MASK;
+                       end += (PAGE_SIZE - 1);
+                       end &= PAGE_MASK;
+                       while (start < end) {
+                               int idx;
+
+                               pevn_set(start | newpid);
+                               start += PAGE_SIZE;
+                               barrier();
+                               tlb_probe();
+                               idx = tlbpt_get();
+                               pectx_set(0);
+                               pevn_set(KSEG1);
+                               if (idx < 0)
+                                       continue;
+                               tlb_write_indexed();
+                       }
+                       pevn_set(oldpid);
+               } else {
+                       /* Bigger than TLBSIZE, get new ASID directly */
+                       get_new_mmu_context(mm);
+                       if (mm == current->active_mm)
+                               pevn_set(vma_mm_context & ASID_MASK);
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
+               int pid = pevn_get();
+
+               start &= PAGE_MASK;
+               end += PAGE_SIZE - 1;
+               end &= PAGE_MASK;
+
+               while (start < end) {
+                       long idx;
+
+                       pevn_set(start);
+                       start += PAGE_SIZE;
+                       tlb_probe();
+                       idx = tlbpt_get();
+                       if (idx < 0)
+                               continue;
+                       pectx_set(0);
+                       pevn_set(KSEG1);
+                       barrier();
+                       tlb_write_indexed();
+               }
+               pevn_set(pid);
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
+               unsigned long vma_ASID = vma->vm_mm->context;
+
+               newpid = vma_ASID & ASID_MASK;
+               page &= PAGE_MASK;
+               local_irq_save(flags);
+               oldpid = pevn_get() & ASID_MASK;
+               pevn_set(page | newpid);
+               barrier();
+               tlb_probe();
+               idx = tlbpt_get();
+               pectx_set(0);
+               pevn_set(KSEG1);
+               if (idx < 0)            /* p_bit(31) - 1: miss, 0: hit*/
+                       goto finish;
+               barrier();
+               tlb_write_indexed();
+finish:
+               pevn_set(oldpid);
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
+       oldpid = pevn_get();
+       page &= (PAGE_MASK << 1);
+       pevn_set(page);
+       barrier();
+       tlb_probe();
+       idx = tlbpt_get();
+       pectx_set(0);
+       if (idx >= 0) {
+               /* Make sure all entries differ. */
+               pevn_set(KSEG1);
+               barrier();
+               tlb_write_indexed();
+       }
+       pevn_set(oldpid);
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
+       pid = pevn_get() & ASID_MASK;
+
+       local_irq_save(flags);
+       address &= PAGE_MASK;
+       pevn_set(address | pid);
+       barrier();
+       tlb_probe();
+       idx = tlbpt_get();
+       pectx_set(pte_val(pte));
+       pevn_set(address | pid);
+       if (idx < 0)
+               tlb_write_random();
+       else
+               tlb_write_indexed();
+
+       pevn_set(pid);
+       local_irq_restore(flags);
+}
+
+void __cpuinit tlb_init(void)
+{
+       tlblock_set(0);
+       local_flush_tlb_all();
+       memcpy((void *)(EXCEPTION_VECTOR_BASE_ADDR + 0x100),
+                       &score7_FTLB_refill_Handler, 0xFC);
+       flush_icache_range(EXCEPTION_VECTOR_BASE_ADDR + 0x100,
+                       EXCEPTION_VECTOR_BASE_ADDR + 0x1FC);
+}
-- 
1.6.2

