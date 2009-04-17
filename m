Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZDQGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZDQGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbZDQGjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:39:55 -0400
Received: from gw.goop.org ([64.81.55.164]:56741 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760110AbZDQGjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:39:51 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: mathieu.desnoyers@polymtl.ca
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 5/5] x86/pvops: move tracing around to match CREATE_PVOPS_TRACE_POINTS
Date: Thu, 16 Apr 2009 23:39:34 -0700
Message-Id: <1239950374-1252-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239950374-1252-1-git-send-email-jeremy@goop.org>
References: <1239950374-1252-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use CREATE_PVOPS_TRACE_POINTS to do targeted instantiation.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt-trace.h | 1182 --------------------------------
 arch/x86/include/asm/paravirt.h       |    2 +-
 arch/x86/kernel/paravirt-trace.c      |    6 +-
 include/trace/events/pvops.h          | 1183 +++++++++++++++++++++++++++++++++
 4 files changed, 1188 insertions(+), 1185 deletions(-)
 delete mode 100644 arch/x86/include/asm/paravirt-trace.h
 create mode 100644 include/trace/events/pvops.h

diff --git a/arch/x86/include/asm/paravirt-trace.h b/arch/x86/include/asm/paravirt-trace.h
deleted file mode 100644
index 00e755a..0000000
--- a/arch/x86/include/asm/paravirt-trace.h
+++ /dev/null
@@ -1,1182 +0,0 @@
-#if !defined(_ASM_X86_PARAVIRT_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _ASM_X86_PARAVIRT_TRACE_H
-
-#include <linux/tracepoint.h>
-#include <asm/paravirt_types.h>
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM pvops
-
-#define TRACE_INCLUDE_FILE	paravirt-trace
-#define TRACE_INCLUDE_PATH	asm
-
-struct tss_struct;
-struct thread_struct;
-struct task_struct;
-
-/* width for %0*x */
-#define HEX_FIELD(type)	((int)sizeof(type) * 2)
-
-/* 
- * Define tracepoints for all significant pvops.
- *
- * Some general rules I used to determine what to record:
- *  - no global state (lazy modes, etc), since that can be
- *    derived from tracing
- *  - record old values where practical, so that updates can be
- *    self-contained (somewhat contradictory to point 1, but
- *    could be useful)
- *  - display pte/pmd/pud/pgds in "cooked" rather than raw form
- *    (ie, the result of "X_val" rather than the naked bitpattern
- *    in the X_t type).
- */
-
-TRACE_EVENT(load_sp0,
-	    TP_PROTO(struct tss_struct *tss, struct thread_struct *thread),
-	    TP_ARGS(tss, thread),
-	    TP_STRUCT__entry(
-		    __field(struct tss_struct *, tss)
-		    __field(struct thread_struct *, thread)
-		    ),
-	    TP_fast_assign(
-		    __entry->tss = tss;
-		    __entry->thread = thread;
-		    ),
-	    TP_printk("task %p tss = %p",
-		      __entry->thread, __entry->tss)
-	);
-
-TRACE_EVENT(get_debugreg,
-	    TP_PROTO(int reg, unsigned long val),
-	    TP_ARGS(reg, val),
-	    TP_STRUCT__entry(
-		    __field(int, reg)
-		    __field(unsigned long, val)
-		    ),
-	    TP_fast_assign(
-		    __entry->reg = reg;
-		    __entry->val = val;
-		    ),
-	    TP_printk("reg %d = %lx", __entry->reg, __entry->val)
-	);
-
-TRACE_EVENT(set_debugreg,
-	    TP_PROTO(int reg, unsigned long val),
-	    TP_ARGS(reg, val),
-	    TP_STRUCT__entry(
-		    __field(int, reg)
-		    __field(unsigned long, val)
-		    ),
-	    TP_fast_assign(
-		    __entry->reg = reg;
-		    __entry->val = val;
-		    ),
-	    TP_printk("reg %d = %lx", __entry->reg, __entry->val)
-	);
-
-TRACE_EVENT(clts,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(read_cr0,
-	    TP_PROTO(unsigned long cr0),
-	    TP_ARGS(cr0),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr0)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr0 = cr0;
-		    ),
-	    TP_printk("%lx", __entry->cr0)
-	);
-
-TRACE_EVENT(write_cr0,
-	    TP_PROTO(unsigned long cr0),
-	    TP_ARGS(cr0),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr0)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr0 = cr0;
-		    ),
-	    TP_printk("%lx", __entry->cr0)
-	);
-
-TRACE_EVENT(read_cr2,
-	    TP_PROTO(unsigned long cr2),
-	    TP_ARGS(cr2),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr2)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr2 = cr2;
-		    ),
-	    TP_printk("%lx", __entry->cr2)
-	);
-
-TRACE_EVENT(write_cr2,
-	    TP_PROTO(unsigned long cr2),
-	    TP_ARGS(cr2),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr2)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr2 = cr2;
-		    ),
-	    TP_printk("%lx", __entry->cr2)
-	);
-
-TRACE_EVENT(read_cr3,
-	    TP_PROTO(unsigned long cr3),
-	    TP_ARGS(cr3),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr3)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr3 = cr3;
-		    ),
-	    TP_printk("%lx", __entry->cr3)
-	);
-
-TRACE_EVENT(write_cr3,
-	    TP_PROTO(unsigned long cr3),
-	    TP_ARGS(cr3),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr3)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr3 = cr3;
-		    ),
-	    TP_printk("%lx", __entry->cr3)
-	);
-
-TRACE_EVENT(write_cr4,
-	    TP_PROTO(unsigned long cr4),
-	    TP_ARGS(cr4),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr4)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr4 = cr4;
-		    ),
-	    TP_printk("%lx", __entry->cr4)
-	);
-
-TRACE_EVENT(read_cr4,
-	    TP_PROTO(unsigned long cr4),
-	    TP_ARGS(cr4),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr4)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr4 = cr4;
-		    ),
-	    TP_printk("%lx", __entry->cr4)
-	);
-
-TRACE_EVENT(write_cr8,
-	    TP_PROTO(unsigned long cr8),
-	    TP_ARGS(cr8),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr8)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr8 = cr8;
-		    ),
-	    TP_printk("%lx", __entry->cr8)
-	);
-
-TRACE_EVENT(read_cr8,
-	    TP_PROTO(unsigned long cr8),
-	    TP_ARGS(cr8),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, cr8)
-		    ),
-	    TP_fast_assign(
-		    __entry->cr8 = cr8;
-		    ),
-	    TP_printk("%lx", __entry->cr8)
-	);
-
-TRACE_EVENT(safe_halt,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(wbinvd,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(read_msr,
-	    TP_PROTO(unsigned msr, u64 val),
-	    TP_ARGS(msr, val),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, val)
-		    __field(unsigned, msr)
-		    ),
-	    TP_fast_assign(
-		    __entry->msr = msr;
-		    __entry->val = val;
-		    ),
-	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
-	);
-
-TRACE_EVENT(read_msr_amd,
-	    TP_PROTO(unsigned msr, u64 val),
-	    TP_ARGS(msr, val),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, val)
-		    __field(unsigned, msr)
-		    ),
-	    TP_fast_assign(
-		    __entry->msr = msr;
-		    __entry->val = val;
-		    ),
-	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
-	);
-
-TRACE_EVENT(write_msr,
-	    TP_PROTO(unsigned msr, unsigned low, unsigned high),
-	    TP_ARGS(msr, low, high),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, val)
-		    __field(unsigned, msr)
-		    ),
-	    TP_fast_assign(
-		    __entry->msr = msr;
-		    __entry->val = ((u64)high << 32) | low;
-		    ),
-	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
-	);
-
-TRACE_EVENT(read_tsc,
-	    TP_PROTO(unsigned long long tsc),
-	    TP_ARGS(tsc),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, tsc)
-		    ),
-	    TP_fast_assign(
-		    __entry->tsc = tsc;
-		    ),
-	    TP_printk("%llx", __entry->tsc)
-	);
-
-TRACE_EVENT(sched_clock,
-	    TP_PROTO(unsigned long long clock),
-	    TP_ARGS(clock),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, clock)
-		    ),
-	    TP_fast_assign(
-		    __entry->clock = clock;
-		    ),
-	    TP_printk("%llx", __entry->clock)
-	);
-
-TRACE_EVENT(read_pmc,
-	    TP_PROTO(unsigned pmc, u64 val),
-	    TP_ARGS(pmc, val),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, val)
-		    __field(unsigned, pmc)
-		    ),
-	    TP_fast_assign(
-		    __entry->pmc = pmc;
-		    __entry->val = val;
-		    ),
-	    TP_printk("%x -> %llx", __entry->pmc, __entry->val)
-	);
-
-TRACE_EVENT(read_tscp,
-	    TP_PROTO(unsigned long long tsc, unsigned aux),
-	    TP_ARGS(tsc, aux),
-	    TP_STRUCT__entry(
-		    __field(unsigned long long, tsc)
-		    __field(unsigned, aux)
-		    ),
-	    TP_fast_assign(
-		    __entry->tsc = tsc;
-		    __entry->aux = aux;
-		    ),
-	    TP_printk("tsc:%llx aux:%x", __entry->tsc, __entry->aux)
-	);
-
-TRACE_EVENT(alloc_ldt,
-	    TP_PROTO(struct desc_struct *ldt, unsigned entries),
-	    TP_ARGS(ldt, entries),
-	    TP_STRUCT__entry(
-		    __field(struct desc_struct *, ldt)
-		    __field(unsigned, entries)
-		    ),
-	    TP_fast_assign(
-		    __entry->ldt = ldt;
-		    __entry->entries = entries;
-		    ),
-	    TP_printk("ldt:%p entries:%d",
-		      __entry->ldt, __entry->entries)
-	);
-
-TRACE_EVENT(free_ldt,
-	    TP_PROTO(struct desc_struct *ldt, unsigned entries),
-	    TP_ARGS(ldt, entries),
-	    TP_STRUCT__entry(
-		    __field(struct desc_struct *, ldt)
-		    __field(unsigned, entries)
-		    ),
-	    TP_fast_assign(
-		    __entry->ldt = ldt;
-		    __entry->entries = entries;
-		    ),
-	    TP_printk("ldt:%p entries:%d",
-		      __entry->ldt, __entry->entries)
-	);
-
-TRACE_EVENT(load_TR_desc,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(load_gdt,
-	    TP_PROTO(const struct desc_ptr *gdt),
-	    TP_ARGS(gdt),
-	    TP_STRUCT__entry(
-		    __field(struct desc_ptr, gdtptr)
-		    ),
-	    TP_fast_assign(
-		    __entry->gdtptr = *gdt;
-		    ),
-	    TP_printk("gdt:%lx size:%d",
-		      __entry->gdtptr.address, __entry->gdtptr.size)
-	);
-
-TRACE_EVENT(load_idt,
-	    TP_PROTO(const struct desc_ptr *idt),
-	    TP_ARGS(idt),
-	    TP_STRUCT__entry(
-		    __field(struct desc_ptr, idtptr)
-		    ),
-	    TP_fast_assign(
-		    __entry->idtptr = *idt;
-		    ),
-	    TP_printk("idt:%lx size:%d",
-		      __entry->idtptr.address, __entry->idtptr.size)
-	);
-
-TRACE_EVENT(set_ldt,
-	    TP_PROTO(const struct desc_struct *ldt, unsigned entries),
-	    TP_ARGS(ldt, entries),
-	    TP_STRUCT__entry(
-		    __field(const struct desc_struct *, ldt)
-		    __field(unsigned, entries)
-		    ),
-	    TP_fast_assign(
-		    __entry->ldt = ldt;
-		    __entry->entries = entries;
-		    ),
-	    TP_printk("ldt:%p entries:%d",
-		      __entry->ldt, __entry->entries)
-	);
-
-TRACE_EVENT(store_gdt,
-	    TP_PROTO(const struct desc_ptr *gdt),
-	    TP_ARGS(gdt),
-	    TP_STRUCT__entry(
-		    __field(struct desc_ptr, gdtptr)
-		    ),
-	    TP_fast_assign(
-		    __entry->gdtptr = *gdt;
-		    ),
-	    TP_printk("gdt:%lx size:%d",
-		      __entry->gdtptr.address, __entry->gdtptr.size)
-	);
-
-TRACE_EVENT(store_idt,
-	    TP_PROTO(const struct desc_ptr *idt),
-	    TP_ARGS(idt),
-	    TP_STRUCT__entry(
-		    __field(struct desc_ptr, idtptr)
-		    ),
-	    TP_fast_assign(
-		    __entry->idtptr = *idt;
-		    ),
-	    TP_printk("idt:%lx size:%d",
-		      __entry->idtptr.address, __entry->idtptr.size)
-	);
-
-TRACE_EVENT(store_tr,
-	    TP_PROTO(unsigned long tr),
-	    TP_ARGS(tr),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, tr)
-		    ),
-	    TP_fast_assign(
-		    __entry->tr = tr;
-		    ),
-	    TP_printk("%lx", __entry->tr)
-	);
-
-TRACE_EVENT(load_TLS,
-	    TP_PROTO(const struct thread_struct *t, unsigned cpu),
-	    TP_ARGS(t, cpu),
-	    TP_STRUCT__entry(
-		    __array(struct desc_struct, tls, GDT_ENTRY_TLS_ENTRIES)
-		    __field(unsigned, cpu)
-		    ),
-	    TP_fast_assign(
-		    memcpy(__entry->tls, t->tls_array, sizeof(__entry->tls));
-		    __entry->cpu = cpu;
-		    ),
-	    TP_printk("cpu:%d", __entry->cpu)
-	);
-
-TRACE_EVENT(load_gs_index,
-	    TP_PROTO(unsigned gs),
-	    TP_ARGS(gs),
-	    TP_STRUCT__entry(
-		    __field(unsigned, gs)
-		    ),
-	    TP_fast_assign(
-		    __entry->gs = gs;
-		    ),
-	    TP_printk("gs:%x", __entry->gs)
-	);
-
-TRACE_EVENT(write_ldt_entry,
-	    TP_PROTO(struct desc_struct *dt, int idx, const void *desc),
-	    TP_ARGS(dt, idx, desc),
-	    TP_STRUCT__entry(
-		    __field(struct desc_struct *, dt)
-		    __field(int, idx)
-		    __field(const void *, desc)
-		    ),
-	    TP_fast_assign(
-		    __entry->dt = dt;
-		    __entry->idx = idx;
-		    __entry->desc = desc;
-		    ),
-	    TP_printk("dt:%p entry:%d desc:%p",
-		      __entry->dt, __entry->idx, __entry->desc)
-	);
-
-TRACE_EVENT(write_gdt_entry,
-	    TP_PROTO(struct desc_struct *dt, int idx, void *desc, int type),
-	    TP_ARGS(dt, idx, desc, type),
-	    TP_STRUCT__entry(
-		    __field(struct desc_struct *, dt)
-		    __field(int, idx)
-		    __field(void *, desc)
-		    __field(int, type)
-		    ),
-	    TP_fast_assign(
-		    __entry->dt = dt;
-		    __entry->idx = idx;
-		    __entry->desc = desc;
-		    __entry->type = type;
-		    ),
-	    TP_printk("dt:%p entry:%d desc:%p type:%d",
-		      __entry->dt, __entry->idx, __entry->desc, __entry->type)
-	);
-
-TRACE_EVENT(write_idt_entry,
-	    TP_PROTO(gate_desc *dt, int idx, const gate_desc *g),
-	    TP_ARGS(dt, idx, g),
-	    TP_STRUCT__entry(
-		    __field(gate_desc *, dt)
-		    __field(int, idx)
-		    __field(const gate_desc *, gate)
-		    ),
-	    TP_fast_assign(
-		    __entry->dt = dt;
-		    __entry->idx = idx;
-		    __entry->gate = g;
-		    ),
-	    TP_printk("dt:%p entry:%d gate:%p",
-		      __entry->dt, __entry->idx, __entry->gate)
-	);
-
-TRACE_EVENT(set_iopl_mask,
-	    TP_PROTO(unsigned mask),
-	    TP_ARGS(mask),
-	    TP_STRUCT__entry(
-		    __field(unsigned, mask)
-		    ),
-	    TP_fast_assign(
-		    __entry->mask = mask;
-		    ),
-	    TP_printk("mask:%x", __entry->mask)
-	);
-
-TRACE_EVENT(activate_mm,
-	    TP_PROTO(struct mm_struct *prev, struct mm_struct *next),
-	    TP_ARGS(prev, next),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, prev)
-		    __field(struct mm_struct *, next)
-		    ),
-	    TP_fast_assign(
-		    __entry->prev = prev;
-		    __entry->next = next;
-		    ),
-	    TP_printk("prev=%p next=%p",
-		      __entry->prev, __entry->next)
-	);
-
-TRACE_EVENT(dup_mmap,
-	    TP_PROTO(struct mm_struct *prev, struct mm_struct *next),
-	    TP_ARGS(prev, next),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, prev)
-		    __field(struct mm_struct *, next)
-		    ),
-	    TP_fast_assign(
-		    __entry->prev = prev;
-		    __entry->next = next;
-		    ),
-	    TP_printk("oldmm=%p mm=%p",
-		      __entry->prev, __entry->next)
-	);
-
-TRACE_EVENT(exit_mmap,
-	    TP_PROTO(struct mm_struct *mm),
-	    TP_ARGS(mm),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    ),
-	    TP_printk("mm=%p", __entry->mm)
-	);
-
-TRACE_EVENT(flush_tlb_user,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(flush_tlb_kernel,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(flush_tlb_single,
-	    TP_PROTO(unsigned long addr),
-	    TP_ARGS(addr),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, addr)
-		    ),
-	    TP_fast_assign(
-		    __entry->addr = addr;
-		    ),
-	    TP_printk("addr:%lx", __entry->addr)
-	);
-
-TRACE_EVENT(flush_tlb_others,
-	    TP_PROTO(const struct cpumask *cpumask, struct mm_struct *mm, unsigned long va),
-	    TP_ARGS(cpumask, mm, va),
-	    TP_STRUCT__entry(
-		    __field(struct cpumask, cpumask)
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, va)
-		    ),
-	    TP_fast_assign(
-		    __entry->cpumask = *cpumask;
-		    __entry->mm = mm;
-		    __entry->va = va;
-		    ),
-	    TP_printk("cpumask:<> mm:%p addr:%lx",
-		      __entry->mm, __entry->va)
-	);
-
-TRACE_EVENT(pgd_alloc,
-	    TP_PROTO(struct mm_struct *mm),
-	    TP_ARGS(mm),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(pgd_t *, pgd)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->pgd = mm->pgd;
-		    ),
-	    TP_printk("mm:%p pgd:%p", __entry->mm, __entry->pgd)
-	);
-
-
-TRACE_EVENT(pgd_free,
-	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
-	    TP_ARGS(mm, pgd),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(pgd_t *, pgd)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->pgd = pgd;
-		    ),
-	    TP_printk("mm:%p pgd:%p", __entry->mm, __entry->pgd)
-	);
-
-TRACE_EVENT(alloc_pte,
-	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
-	    TP_ARGS(mm, pfn),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, pfn)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->pfn = pfn;
-		    ),
-	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
-	);
-
-TRACE_EVENT(release_pte,
-	    TP_PROTO(unsigned long pfn),
-	    TP_ARGS(pfn),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, pfn)
-		    ),
-	    TP_fast_assign(
-		    __entry->pfn = pfn;
-		    ),
-	    TP_printk("pfn:%lx", __entry->pfn)
-	);
-
-TRACE_EVENT(alloc_pmd,
-	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
-	    TP_ARGS(mm, pfn),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, pfn)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->pfn = pfn;
-		    ),
-	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
-	);
-
-TRACE_EVENT(alloc_pmd_clone,
-	    TP_PROTO(unsigned long pfn, unsigned long clonepfn,
-		     unsigned long start, unsigned long count),
-	    TP_ARGS(pfn, clonepfn, start, count),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, pfn)
-		    __field(unsigned long, clonepfn)
-		    __field(unsigned long, start)
-		    __field(unsigned long, count)
-		    ),
-	    TP_fast_assign(
-		    __entry->pfn = pfn;
-		    __entry->clonepfn = clonepfn;
-		    __entry->start = start;
-		    __entry->count = count;
-		    ),
-	    TP_printk("pfn:%lx clonepfn:%lx start:%lx count:%lx",
-		      __entry->pfn, __entry->clonepfn, __entry->start, __entry->count)
-	);
-
-TRACE_EVENT(release_pmd,
-	    TP_PROTO(unsigned long pfn),
-	    TP_ARGS(pfn),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, pfn)
-		    ),
-	    TP_fast_assign(
-		    __entry->pfn = pfn;
-		    ),
-	    TP_printk("pfn:%lx", __entry->pfn)
-	);
-
-TRACE_EVENT(alloc_pud,
-	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
-	    TP_ARGS(mm, pfn),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, pfn)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->pfn = pfn;
-		    ),
-	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
-	);
-
-TRACE_EVENT(release_pud,
-	    TP_PROTO(unsigned long pfn),
-	    TP_ARGS(pfn),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, pfn)
-		    ),
-	    TP_fast_assign(
-		    __entry->pfn = pfn;
-		    ),
-	    TP_printk("pfn:%lx", __entry->pfn)
-	);
-
-TRACE_EVENT(kmap_atomic_pte,
-	    TP_PROTO(struct page *page, enum km_type type, unsigned long addr),
-	    TP_ARGS(page, type, addr),
-	    TP_STRUCT__entry(
-		    __field(unsigned long, pfn)
-		    __field(unsigned long, addr)
-		    __field(enum km_type, type)
-		    ),
-	    TP_fast_assign(
-		    __entry->pfn = page_to_pfn(page);
-		    __entry->type = type;
-		    __entry->addr = addr;
-		    ),
-	    TP_printk("pfn:%lx type:%d addr:%lx",
-		      __entry->pfn, __entry->type, __entry->addr)
-	);
-
-TRACE_EVENT(pte_update,
-	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
-	    TP_ARGS(mm, addr, ptep),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, pteval)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->addr = addr;
-		    __entry->ptep = ptep;
-		    __entry->pteval = pte_val_notrace(*ptep);
-		    ),
-	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
-		      __entry->mm, __entry->addr, __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
-	);
-
-TRACE_EVENT(pte_update_defer,
-	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
-	    TP_ARGS(mm, addr, ptep),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, pteval)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->addr = addr;
-		    __entry->ptep = ptep;
-		    __entry->pteval = pte_val_notrace(*ptep);
-		    ),
-	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
-		      __entry->mm, __entry->addr, __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
-	);
-
-TRACE_EVENT(make_pte,
-	    TP_PROTO(pteval_t pteval, pteval_t pte),
-	    TP_ARGS(pteval, pte),
-	    TP_STRUCT__entry(
-		    __field(pteval_t, pteval)
-		    __field(pteval_t, pte)
-		    ),
-	    TP_fast_assign(
-		    __entry->pteval = pteval;
-		    __entry->pte = pte;
-		    ),
-	    TP_printk("pteval:%0*llx pte:%0*llx",
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pte)
-	);
-
-TRACE_EVENT(pte_val,
-	    TP_PROTO(pte_t pte, pteval_t pteval),
-	    TP_ARGS(pte, pteval),
-	    TP_STRUCT__entry(
-		    __field(pte_t, pte)
-		    __field(pteval_t, pteval)
-		    ),
-	    TP_fast_assign(
-		    __entry->pte = pte;
-		    __entry->pteval = pteval;
-		    ),
-	    TP_printk("pte:%0*llx pteval:%0*llx",
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pte.pte,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
-	);
-
-TRACE_EVENT(make_pgd,
-	    TP_PROTO(pgdval_t pgdval, pgdval_t pgd),
-	    TP_ARGS(pgdval, pgd),
-	    TP_STRUCT__entry(
-		    __field(pgdval_t, pgdval)
-		    __field(pgdval_t, pgd)
-		    ),
-	    TP_fast_assign(
-		    __entry->pgdval = pgdval;
-		    __entry->pgd = pgd;
-		    ),
-	    TP_printk("pgdval:%0*llx pgd:%0*llx",
-		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgdval,
-		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgd)
-	);
-
-TRACE_EVENT(pgd_val,
-	    TP_PROTO(pgd_t pgd, pgdval_t pgdval),
-	    TP_ARGS(pgd, pgdval),
-	    TP_STRUCT__entry(
-		    __field(pgd_t, pgd)
-		    __field(pgdval_t, pgdval)
-		    ),
-	    TP_fast_assign(
-		    __entry->pgd = pgd;
-		    __entry->pgdval = pgdval;
-		    ),
-	    TP_printk("pgd:%0*llx pgdval:%0*llx",
-		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgd.pgd,
-		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgdval)
-	);
-
-TRACE_EVENT(ptep_modify_prot_start,
-	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
-	    TP_ARGS(mm, addr, ptep),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, pteval)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->addr = addr;
-		    __entry->ptep = ptep;
-		    __entry->pteval = pte_val_notrace(*ptep);
-		    ),
-	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
-		      __entry->mm, __entry->addr, __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
-	);
-
-TRACE_EVENT(ptep_modify_prot_commit,
-	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte),
-	    TP_ARGS(mm, addr, ptep, pte),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, pteval)
-		    __field(pteval_t, newpte)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->addr = addr;
-		    __entry->ptep = ptep;
-		    __entry->pteval = pte_val_notrace(*ptep);
-		    __entry->newpte = pte_val_notrace(pte);
-		    ),
-	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx newpte:%0*llx",
-		      __entry->mm, __entry->addr, __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
-	);
-
-TRACE_EVENT(set_pte,
-	    TP_PROTO(pte_t *ptep, pte_t pte),
-	    TP_ARGS(ptep, pte),
-	    TP_STRUCT__entry(
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, oldpte)
-		    __field(pteval_t, newpte)
-		    ),
-	    TP_fast_assign(
-		    __entry->ptep = ptep;
-		    __entry->oldpte = pte_val_notrace(*ptep);
-		    __entry->newpte = pte_val_notrace(pte);
-		    ),
-	    TP_printk("ptep:%p oldpte:%0*llx newpte:%0*llx",
-		      __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
-	);
-
-TRACE_EVENT(set_pte_at,
-	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte),
-	    TP_ARGS(mm, addr, ptep, pte),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, oldpte)
-		    __field(pteval_t, newpte)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->addr = addr;
-		    __entry->ptep = ptep;
-		    __entry->oldpte = pte_val_notrace(*ptep);
-		    __entry->newpte = pte_val_notrace(pte);
-		    ),
-	    TP_printk("mm:%p addr:%lx ptep:%p oldpte:%0*llx newpte:%0*llx",
-		      __entry->mm, __entry->addr, __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
-	);
-
-TRACE_EVENT(set_pmd,
-	    TP_PROTO(pmd_t *pmdp, pmd_t pmd),
-	    TP_ARGS(pmdp, pmd),
-	    TP_STRUCT__entry(
-		    __field(pmd_t *, pmdp)
-		    __field(pmdval_t, oldpmd)
-		    __field(pmdval_t, newpmd)
-		    ),
-	    TP_fast_assign(
-		    __entry->pmdp = pmdp;
-		    __entry->oldpmd = pmd_val_notrace(*pmdp);
-		    __entry->newpmd = pmd_val_notrace(pmd);
-		    ),
-	    TP_printk("pmdp:%p oldpmd:%0*llx newpmd:%0*llx",
-		      __entry->pmdp,
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->oldpmd,
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->newpmd)
-	);
-
-#if PAGETABLE_LEVELS >= 3
-TRACE_EVENT(make_pmd,
-	    TP_PROTO(pmdval_t pmdval, pmdval_t pmd),
-	    TP_ARGS(pmdval, pmd),
-	    TP_STRUCT__entry(
-		    __field(pmdval_t, pmdval)
-		    __field(pmdval_t, pmd)
-		    ),
-	    TP_fast_assign(
-		    __entry->pmdval = pmdval;
-		    __entry->pmd = pmd;
-		    ),
-	    TP_printk("pmdval:%0*llx pmd:%0*llx",
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmdval,
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmd)
-	);
-
-TRACE_EVENT(pmd_val,
-	    TP_PROTO(pmd_t pmd, pmdval_t pmdval),
-	    TP_ARGS(pmd, pmdval),
-	    TP_STRUCT__entry(
-		    __field(pmd_t, pmd)
-		    __field(pmdval_t, pmdval)
-		    ),
-	    TP_fast_assign(
-		    __entry->pmd = pmd;
-		    __entry->pmdval = pmdval;
-		    ),
-	    TP_printk("pmd:%0*llx pmdval:%0*llx",
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmd.pmd,
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmdval)
-	);
-
-TRACE_EVENT(set_pud,
-	    TP_PROTO(pud_t *pudp, pud_t pud),
-	    TP_ARGS(pudp, pud),
-	    TP_STRUCT__entry(
-		    __field(pud_t *, pudp)
-		    __field(pudval_t, oldpud)
-		    __field(pudval_t, newpud)
-		    ),
-	    TP_fast_assign(
-		    __entry->pudp = pudp;
-		    __entry->oldpud = pud_val_notrace(*pudp);
-		    __entry->newpud = pud_val_notrace(pud);
-		    ),
-	    TP_printk("pudp:%p oldpud:%0*llx newpud:%0*llx",
-		      __entry->pudp,
-		      HEX_FIELD(pudval_t), (unsigned long long)__entry->oldpud,
-		      HEX_FIELD(pudval_t), (unsigned long long)__entry->newpud)
-	);
-
-#if PAGETABLE_LEVELS == 4
-
-TRACE_EVENT(make_pud,
-	    TP_PROTO(pudval_t pudval, pudval_t pud),
-	    TP_ARGS(pudval, pud),
-	    TP_STRUCT__entry(
-		    __field(pudval_t, pudval)
-		    __field(pudval_t, pud)
-		    ),
-	    TP_fast_assign(
-		    __entry->pudval = pudval;
-		    __entry->pud = pud;
-		    ),
-	    TP_printk("pudval:%0*llx pud:%0*llx",
-		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pudval,
-		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pud)
-	);
-
-TRACE_EVENT(pud_val,
-	    TP_PROTO(pud_t pud, pudval_t pudval),
-	    TP_ARGS(pud, pudval),
-	    TP_STRUCT__entry(
-		    __field(pud_t, pud)
-		    __field(pudval_t, pudval)
-		    ),
-	    TP_fast_assign(
-		    __entry->pud = pud;
-		    __entry->pudval = pudval;
-		    ),
-	    TP_printk("pud:%0*llx pudval:%0*llx",
-		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pud.pud,
-		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pudval)
-	);
-
-TRACE_EVENT(set_pgd,
-	    TP_PROTO(pgd_t *pgdp, pgd_t pgd),
-	    TP_ARGS(pgdp, pgd),
-	    TP_STRUCT__entry(
-		    __field(pgd_t *, pgdp)
-		    __field(pgdval_t, oldpgd)
-		    __field(pgdval_t, newpgd)
-		    ),
-	    TP_fast_assign(
-		    __entry->pgdp = pgdp;
-		    __entry->oldpgd = pgd_val_notrace(*pgdp);
-		    __entry->newpgd = pgd_val_notrace(pgd);
-		    ),
-	    TP_printk("pgdp:%p oldpgd:%0*llx newpgd:%0*llx",
-		      __entry->pgdp,
-		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->oldpgd,
-		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->newpgd)
-	);
-
-#endif	/* PAGETABLE_LEVELS == 4 */
-
-#endif	/* PAGETABLE_LEVELS >= 3 */
-
-#ifdef CONFIG_X86_PAE
-TRACE_EVENT(set_pte_atomic,
-	    TP_PROTO(pte_t *ptep, pte_t pte),
-	    TP_ARGS(ptep, pte),
-	    TP_STRUCT__entry(
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, oldpte)
-		    __field(pteval_t, newpte)
-		    ),
-	    TP_fast_assign(
-		    __entry->ptep = ptep;
-		    __entry->oldpte = pte_val_notrace(*ptep);
-		    __entry->newpte = pte_val_notrace(pte);
-		    ),
-	    TP_printk("ptep:%p oldpte:%0*llx newpte:%0*llx",
-		      __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
-	);
-
-TRACE_EVENT(pte_clear,
-	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
-	    TP_ARGS(mm, addr, ptep),
-	    TP_STRUCT__entry(
-		    __field(struct mm_struct *, mm)
-		    __field(unsigned long, addr)
-		    __field(pte_t *, ptep)
-		    __field(pteval_t, oldpte)
-		    ),
-	    TP_fast_assign(
-		    __entry->mm = mm;
-		    __entry->addr = addr;
-		    __entry->ptep = ptep;
-		    __entry->oldpte = pte_val_notrace(*ptep);
-		    ),
-	    TP_printk("mm:%p addr:%lx ptep:%p oldpte:%0*llx",
-		      __entry->mm, __entry->addr, __entry->ptep,
-		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte)
-	);
-
-TRACE_EVENT(pmd_clear,
-	    TP_PROTO(pmd_t *pmdp),
-	    TP_ARGS(pmdp),
-	    TP_STRUCT__entry(
-		    __field(pmd_t *, pmdp)
-		    __field(pmdval_t, oldpmd)
-		    ),
-	    TP_fast_assign(
-		    __entry->pmdp = pmdp;
-		    __entry->oldpmd = pmd_val_notrace(*pmdp);
-		    ),
-	    TP_printk("pmdp:%p oldpmd:%0*llx",
-		      __entry->pmdp,
-		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->oldpmd)
-	);
-
-#endif	/* CONFIG_X86_PAE */
-
-TRACE_EVENT(start_context_switch,
-	    TP_PROTO(struct task_struct *prev),
-	    TP_ARGS(prev),
-	    TP_STRUCT__entry(
-		    __field(struct task_struct *, prev)
-		    ),
-	    TP_fast_assign(
-		    __entry->prev = prev
-		    ),
-	    TP_printk("prev:%p", __entry->prev)
-	);
-
-TRACE_EVENT(end_context_switch,
-	    TP_PROTO(struct task_struct *next),
-	    TP_ARGS(next),
-	    TP_STRUCT__entry(
-		    __field(struct task_struct *, next)
-		    ),
-	    TP_fast_assign(
-		    __entry->next = next
-		    ),
-	    TP_printk("next:%p", __entry->next)
-	);
-
-TRACE_EVENT(enter_lazy_mmu,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(leave_lazy_mmu,
-	    TP_PROTO(int __dummy),
-	    TP_ARGS(__dummy),
-	    ,
-	    ,
-	);
-
-TRACE_EVENT(set_fixmap,
-	    TP_PROTO(unsigned idx, phys_addr_t phys, pgprot_t flags),
-	    TP_ARGS(idx, phys, flags),
-	    TP_STRUCT__entry(
-		    __field(unsigned, idx)
-		    __field(phys_addr_t, phys)
-		    __field(pgprot_t, flags)
-		    ),
-	    TP_fast_assign(
-		    __entry->idx = idx;
-		    __entry->phys = phys;
-		    __entry->flags = flags;
-		    ),
-	    TP_printk("idx:%d phys:%llx flags:%*llx",
-		      __entry->idx, (unsigned long long)__entry->phys,
-		      HEX_FIELD(pgprotval_t), (unsigned long long)pgprot_val(__entry->flags))
-	);
-
-#endif	/* _ASM_X86_PARAVIRT_TRACE_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 07b4e97..2020f1e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -15,7 +15,7 @@
 
 #include <asm/kmap_types.h>
 #include <asm/desc_defs.h>
-#include <asm/paravirt-trace.h>
+#include <trace/events/pvops.h>
 
 static inline int paravirt_enabled(void)
 {
diff --git a/arch/x86/kernel/paravirt-trace.c b/arch/x86/kernel/paravirt-trace.c
index ca0ef16..e595831 100644
--- a/arch/x86/kernel/paravirt-trace.c
+++ b/arch/x86/kernel/paravirt-trace.c
@@ -2,8 +2,10 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
-#define CREATE_TRACE_POINTS
-#include <asm/paravirt-trace.h>
+#include <asm/paravirt_types.h>
+
+#define CREATE_PVOPS_TRACE_POINTS
+#include <trace/events/pvops.h>
 
 char paravirt_trace_lazy_mode(void)
 {
diff --git a/include/trace/events/pvops.h b/include/trace/events/pvops.h
new file mode 100644
index 0000000..ec2c356
--- /dev/null
+++ b/include/trace/events/pvops.h
@@ -0,0 +1,1183 @@
+#if !defined(_ASM_X86_PARAVIRT_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _ASM_X86_PARAVIRT_TRACE_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM pvops
+
+struct tss_struct;
+struct thread_struct;
+struct task_struct;
+
+/* width for %0*x */
+#define HEX_FIELD(type)	((int)sizeof(type) * 2)
+
+/* 
+ * Define tracepoints for all significant pvops.
+ *
+ * Some general rules I used to determine what to record:
+ *  - no global state (lazy modes, etc), since that can be
+ *    derived from tracing
+ *  - record old values where practical, so that updates can be
+ *    self-contained (somewhat contradictory to point 1, but
+ *    could be useful)
+ *  - display pte/pmd/pud/pgds in "cooked" rather than raw form
+ *    (ie, the result of "X_val" rather than the naked bitpattern
+ *    in the X_t type).
+ */
+
+TRACE_EVENT(load_sp0,
+	    TP_PROTO(struct tss_struct *tss, struct thread_struct *thread),
+	    TP_ARGS(tss, thread),
+	    TP_STRUCT__entry(
+		    __field(struct tss_struct *, tss)
+		    __field(struct thread_struct *, thread)
+		    ),
+	    TP_fast_assign(
+		    __entry->tss = tss;
+		    __entry->thread = thread;
+		    ),
+	    TP_printk("task %p tss = %p",
+		      __entry->thread, __entry->tss)
+	);
+
+TRACE_EVENT(get_debugreg,
+	    TP_PROTO(int reg, unsigned long val),
+	    TP_ARGS(reg, val),
+	    TP_STRUCT__entry(
+		    __field(int, reg)
+		    __field(unsigned long, val)
+		    ),
+	    TP_fast_assign(
+		    __entry->reg = reg;
+		    __entry->val = val;
+		    ),
+	    TP_printk("reg %d = %lx", __entry->reg, __entry->val)
+	);
+
+TRACE_EVENT(set_debugreg,
+	    TP_PROTO(int reg, unsigned long val),
+	    TP_ARGS(reg, val),
+	    TP_STRUCT__entry(
+		    __field(int, reg)
+		    __field(unsigned long, val)
+		    ),
+	    TP_fast_assign(
+		    __entry->reg = reg;
+		    __entry->val = val;
+		    ),
+	    TP_printk("reg %d = %lx", __entry->reg, __entry->val)
+	);
+
+TRACE_EVENT(clts,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(read_cr0,
+	    TP_PROTO(unsigned long cr0),
+	    TP_ARGS(cr0),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr0)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr0 = cr0;
+		    ),
+	    TP_printk("%lx", __entry->cr0)
+	);
+
+TRACE_EVENT(write_cr0,
+	    TP_PROTO(unsigned long cr0),
+	    TP_ARGS(cr0),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr0)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr0 = cr0;
+		    ),
+	    TP_printk("%lx", __entry->cr0)
+	);
+
+TRACE_EVENT(read_cr2,
+	    TP_PROTO(unsigned long cr2),
+	    TP_ARGS(cr2),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr2)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr2 = cr2;
+		    ),
+	    TP_printk("%lx", __entry->cr2)
+	);
+
+TRACE_EVENT(write_cr2,
+	    TP_PROTO(unsigned long cr2),
+	    TP_ARGS(cr2),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr2)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr2 = cr2;
+		    ),
+	    TP_printk("%lx", __entry->cr2)
+	);
+
+TRACE_EVENT(read_cr3,
+	    TP_PROTO(unsigned long cr3),
+	    TP_ARGS(cr3),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr3)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr3 = cr3;
+		    ),
+	    TP_printk("%lx", __entry->cr3)
+	);
+
+TRACE_EVENT(write_cr3,
+	    TP_PROTO(unsigned long cr3),
+	    TP_ARGS(cr3),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr3)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr3 = cr3;
+		    ),
+	    TP_printk("%lx", __entry->cr3)
+	);
+
+TRACE_EVENT(write_cr4,
+	    TP_PROTO(unsigned long cr4),
+	    TP_ARGS(cr4),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr4)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr4 = cr4;
+		    ),
+	    TP_printk("%lx", __entry->cr4)
+	);
+
+TRACE_EVENT(read_cr4,
+	    TP_PROTO(unsigned long cr4),
+	    TP_ARGS(cr4),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr4)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr4 = cr4;
+		    ),
+	    TP_printk("%lx", __entry->cr4)
+	);
+
+TRACE_EVENT(write_cr8,
+	    TP_PROTO(unsigned long cr8),
+	    TP_ARGS(cr8),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr8)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr8 = cr8;
+		    ),
+	    TP_printk("%lx", __entry->cr8)
+	);
+
+TRACE_EVENT(read_cr8,
+	    TP_PROTO(unsigned long cr8),
+	    TP_ARGS(cr8),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, cr8)
+		    ),
+	    TP_fast_assign(
+		    __entry->cr8 = cr8;
+		    ),
+	    TP_printk("%lx", __entry->cr8)
+	);
+
+TRACE_EVENT(safe_halt,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(wbinvd,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(read_msr,
+	    TP_PROTO(unsigned msr, u64 val),
+	    TP_ARGS(msr, val),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, msr)
+		    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = val;
+		    ),
+	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
+	);
+
+TRACE_EVENT(read_msr_amd,
+	    TP_PROTO(unsigned msr, u64 val),
+	    TP_ARGS(msr, val),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, msr)
+		    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = val;
+		    ),
+	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
+	);
+
+TRACE_EVENT(write_msr,
+	    TP_PROTO(unsigned msr, unsigned low, unsigned high),
+	    TP_ARGS(msr, low, high),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, msr)
+		    ),
+	    TP_fast_assign(
+		    __entry->msr = msr;
+		    __entry->val = ((u64)high << 32) | low;
+		    ),
+	    TP_printk("%x -> %llx", __entry->msr, __entry->val)
+	);
+
+TRACE_EVENT(read_tsc,
+	    TP_PROTO(unsigned long long tsc),
+	    TP_ARGS(tsc),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, tsc)
+		    ),
+	    TP_fast_assign(
+		    __entry->tsc = tsc;
+		    ),
+	    TP_printk("%llx", __entry->tsc)
+	);
+
+TRACE_EVENT(sched_clock,
+	    TP_PROTO(unsigned long long clock),
+	    TP_ARGS(clock),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, clock)
+		    ),
+	    TP_fast_assign(
+		    __entry->clock = clock;
+		    ),
+	    TP_printk("%llx", __entry->clock)
+	);
+
+TRACE_EVENT(read_pmc,
+	    TP_PROTO(unsigned pmc, u64 val),
+	    TP_ARGS(pmc, val),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, val)
+		    __field(unsigned, pmc)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmc = pmc;
+		    __entry->val = val;
+		    ),
+	    TP_printk("%x -> %llx", __entry->pmc, __entry->val)
+	);
+
+TRACE_EVENT(read_tscp,
+	    TP_PROTO(unsigned long long tsc, unsigned aux),
+	    TP_ARGS(tsc, aux),
+	    TP_STRUCT__entry(
+		    __field(unsigned long long, tsc)
+		    __field(unsigned, aux)
+		    ),
+	    TP_fast_assign(
+		    __entry->tsc = tsc;
+		    __entry->aux = aux;
+		    ),
+	    TP_printk("tsc:%llx aux:%x", __entry->tsc, __entry->aux)
+	);
+
+TRACE_EVENT(alloc_ldt,
+	    TP_PROTO(struct desc_struct *ldt, unsigned entries),
+	    TP_ARGS(ldt, entries),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, ldt)
+		    __field(unsigned, entries)
+		    ),
+	    TP_fast_assign(
+		    __entry->ldt = ldt;
+		    __entry->entries = entries;
+		    ),
+	    TP_printk("ldt:%p entries:%d",
+		      __entry->ldt, __entry->entries)
+	);
+
+TRACE_EVENT(free_ldt,
+	    TP_PROTO(struct desc_struct *ldt, unsigned entries),
+	    TP_ARGS(ldt, entries),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, ldt)
+		    __field(unsigned, entries)
+		    ),
+	    TP_fast_assign(
+		    __entry->ldt = ldt;
+		    __entry->entries = entries;
+		    ),
+	    TP_printk("ldt:%p entries:%d",
+		      __entry->ldt, __entry->entries)
+	);
+
+TRACE_EVENT(load_TR_desc,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(load_gdt,
+	    TP_PROTO(const struct desc_ptr *gdt),
+	    TP_ARGS(gdt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, gdtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->gdtptr = *gdt;
+		    ),
+	    TP_printk("gdt:%lx size:%d",
+		      __entry->gdtptr.address, __entry->gdtptr.size)
+	);
+
+TRACE_EVENT(load_idt,
+	    TP_PROTO(const struct desc_ptr *idt),
+	    TP_ARGS(idt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, idtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->idtptr = *idt;
+		    ),
+	    TP_printk("idt:%lx size:%d",
+		      __entry->idtptr.address, __entry->idtptr.size)
+	);
+
+TRACE_EVENT(set_ldt,
+	    TP_PROTO(const struct desc_struct *ldt, unsigned entries),
+	    TP_ARGS(ldt, entries),
+	    TP_STRUCT__entry(
+		    __field(const struct desc_struct *, ldt)
+		    __field(unsigned, entries)
+		    ),
+	    TP_fast_assign(
+		    __entry->ldt = ldt;
+		    __entry->entries = entries;
+		    ),
+	    TP_printk("ldt:%p entries:%d",
+		      __entry->ldt, __entry->entries)
+	);
+
+TRACE_EVENT(store_gdt,
+	    TP_PROTO(const struct desc_ptr *gdt),
+	    TP_ARGS(gdt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, gdtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->gdtptr = *gdt;
+		    ),
+	    TP_printk("gdt:%lx size:%d",
+		      __entry->gdtptr.address, __entry->gdtptr.size)
+	);
+
+TRACE_EVENT(store_idt,
+	    TP_PROTO(const struct desc_ptr *idt),
+	    TP_ARGS(idt),
+	    TP_STRUCT__entry(
+		    __field(struct desc_ptr, idtptr)
+		    ),
+	    TP_fast_assign(
+		    __entry->idtptr = *idt;
+		    ),
+	    TP_printk("idt:%lx size:%d",
+		      __entry->idtptr.address, __entry->idtptr.size)
+	);
+
+TRACE_EVENT(store_tr,
+	    TP_PROTO(unsigned long tr),
+	    TP_ARGS(tr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, tr)
+		    ),
+	    TP_fast_assign(
+		    __entry->tr = tr;
+		    ),
+	    TP_printk("%lx", __entry->tr)
+	);
+
+TRACE_EVENT(load_TLS,
+	    TP_PROTO(const struct thread_struct *t, unsigned cpu),
+	    TP_ARGS(t, cpu),
+	    TP_STRUCT__entry(
+		    __array(struct desc_struct, tls, GDT_ENTRY_TLS_ENTRIES)
+		    __field(unsigned, cpu)
+		    ),
+	    TP_fast_assign(
+		    memcpy(__entry->tls, t->tls_array, sizeof(__entry->tls));
+		    __entry->cpu = cpu;
+		    ),
+	    TP_printk("cpu:%d", __entry->cpu)
+	);
+
+TRACE_EVENT(load_gs_index,
+	    TP_PROTO(unsigned gs),
+	    TP_ARGS(gs),
+	    TP_STRUCT__entry(
+		    __field(unsigned, gs)
+		    ),
+	    TP_fast_assign(
+		    __entry->gs = gs;
+		    ),
+	    TP_printk("gs:%x", __entry->gs)
+	);
+
+TRACE_EVENT(write_ldt_entry,
+	    TP_PROTO(struct desc_struct *dt, int idx, const void *desc),
+	    TP_ARGS(dt, idx, desc),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, dt)
+		    __field(int, idx)
+		    __field(const void *, desc)
+		    ),
+	    TP_fast_assign(
+		    __entry->dt = dt;
+		    __entry->idx = idx;
+		    __entry->desc = desc;
+		    ),
+	    TP_printk("dt:%p entry:%d desc:%p",
+		      __entry->dt, __entry->idx, __entry->desc)
+	);
+
+TRACE_EVENT(write_gdt_entry,
+	    TP_PROTO(struct desc_struct *dt, int idx, void *desc, int type),
+	    TP_ARGS(dt, idx, desc, type),
+	    TP_STRUCT__entry(
+		    __field(struct desc_struct *, dt)
+		    __field(int, idx)
+		    __field(void *, desc)
+		    __field(int, type)
+		    ),
+	    TP_fast_assign(
+		    __entry->dt = dt;
+		    __entry->idx = idx;
+		    __entry->desc = desc;
+		    __entry->type = type;
+		    ),
+	    TP_printk("dt:%p entry:%d desc:%p type:%d",
+		      __entry->dt, __entry->idx, __entry->desc, __entry->type)
+	);
+
+TRACE_EVENT(write_idt_entry,
+	    TP_PROTO(gate_desc *dt, int idx, const gate_desc *g),
+	    TP_ARGS(dt, idx, g),
+	    TP_STRUCT__entry(
+		    __field(gate_desc *, dt)
+		    __field(int, idx)
+		    __field(const gate_desc *, gate)
+		    ),
+	    TP_fast_assign(
+		    __entry->dt = dt;
+		    __entry->idx = idx;
+		    __entry->gate = g;
+		    ),
+	    TP_printk("dt:%p entry:%d gate:%p",
+		      __entry->dt, __entry->idx, __entry->gate)
+	);
+
+TRACE_EVENT(set_iopl_mask,
+	    TP_PROTO(unsigned mask),
+	    TP_ARGS(mask),
+	    TP_STRUCT__entry(
+		    __field(unsigned, mask)
+		    ),
+	    TP_fast_assign(
+		    __entry->mask = mask;
+		    ),
+	    TP_printk("mask:%x", __entry->mask)
+	);
+
+TRACE_EVENT(activate_mm,
+	    TP_PROTO(struct mm_struct *prev, struct mm_struct *next),
+	    TP_ARGS(prev, next),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, prev)
+		    __field(struct mm_struct *, next)
+		    ),
+	    TP_fast_assign(
+		    __entry->prev = prev;
+		    __entry->next = next;
+		    ),
+	    TP_printk("prev=%p next=%p",
+		      __entry->prev, __entry->next)
+	);
+
+TRACE_EVENT(dup_mmap,
+	    TP_PROTO(struct mm_struct *prev, struct mm_struct *next),
+	    TP_ARGS(prev, next),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, prev)
+		    __field(struct mm_struct *, next)
+		    ),
+	    TP_fast_assign(
+		    __entry->prev = prev;
+		    __entry->next = next;
+		    ),
+	    TP_printk("oldmm=%p mm=%p",
+		      __entry->prev, __entry->next)
+	);
+
+TRACE_EVENT(exit_mmap,
+	    TP_PROTO(struct mm_struct *mm),
+	    TP_ARGS(mm),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    ),
+	    TP_printk("mm=%p", __entry->mm)
+	);
+
+TRACE_EVENT(flush_tlb_user,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(flush_tlb_kernel,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(flush_tlb_single,
+	    TP_PROTO(unsigned long addr),
+	    TP_ARGS(addr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, addr)
+		    ),
+	    TP_fast_assign(
+		    __entry->addr = addr;
+		    ),
+	    TP_printk("addr:%lx", __entry->addr)
+	);
+
+TRACE_EVENT(flush_tlb_others,
+	    TP_PROTO(const struct cpumask *cpumask, struct mm_struct *mm, unsigned long va),
+	    TP_ARGS(cpumask, mm, va),
+	    TP_STRUCT__entry(
+		    __field(struct cpumask, cpumask)
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, va)
+		    ),
+	    TP_fast_assign(
+		    __entry->cpumask = *cpumask;
+		    __entry->mm = mm;
+		    __entry->va = va;
+		    ),
+	    TP_printk("cpumask:<> mm:%p addr:%lx",
+		      __entry->mm, __entry->va)
+	);
+
+TRACE_EVENT(pgd_alloc,
+	    TP_PROTO(struct mm_struct *mm),
+	    TP_ARGS(mm),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(pgd_t *, pgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pgd = mm->pgd;
+		    ),
+	    TP_printk("mm:%p pgd:%p", __entry->mm, __entry->pgd)
+	);
+
+
+TRACE_EVENT(pgd_free,
+	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
+	    TP_ARGS(mm, pgd),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(pgd_t *, pgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pgd = pgd;
+		    ),
+	    TP_printk("mm:%p pgd:%p", __entry->mm, __entry->pgd)
+	);
+
+TRACE_EVENT(alloc_pte,
+	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
+	    TP_ARGS(mm, pfn),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
+	);
+
+TRACE_EVENT(release_pte,
+	    TP_PROTO(unsigned long pfn),
+	    TP_ARGS(pfn),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("pfn:%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(alloc_pmd,
+	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
+	    TP_ARGS(mm, pfn),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
+	);
+
+TRACE_EVENT(alloc_pmd_clone,
+	    TP_PROTO(unsigned long pfn, unsigned long clonepfn,
+		     unsigned long start, unsigned long count),
+	    TP_ARGS(pfn, clonepfn, start, count),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    __field(unsigned long, clonepfn)
+		    __field(unsigned long, start)
+		    __field(unsigned long, count)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    __entry->clonepfn = clonepfn;
+		    __entry->start = start;
+		    __entry->count = count;
+		    ),
+	    TP_printk("pfn:%lx clonepfn:%lx start:%lx count:%lx",
+		      __entry->pfn, __entry->clonepfn, __entry->start, __entry->count)
+	);
+
+TRACE_EVENT(release_pmd,
+	    TP_PROTO(unsigned long pfn),
+	    TP_ARGS(pfn),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("pfn:%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(alloc_pud,
+	    TP_PROTO(struct mm_struct *mm, unsigned long pfn),
+	    TP_ARGS(mm, pfn),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("mm:%p pfn:%lx", __entry->mm, __entry->pfn)
+	);
+
+TRACE_EVENT(release_pud,
+	    TP_PROTO(unsigned long pfn),
+	    TP_ARGS(pfn),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = pfn;
+		    ),
+	    TP_printk("pfn:%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(kmap_atomic_pte,
+	    TP_PROTO(struct page *page, enum km_type type, unsigned long addr),
+	    TP_ARGS(page, type, addr),
+	    TP_STRUCT__entry(
+		    __field(unsigned long, pfn)
+		    __field(unsigned long, addr)
+		    __field(enum km_type, type)
+		    ),
+	    TP_fast_assign(
+		    __entry->pfn = page_to_pfn(page);
+		    __entry->type = type;
+		    __entry->addr = addr;
+		    ),
+	    TP_printk("pfn:%lx type:%d addr:%lx",
+		      __entry->pfn, __entry->type, __entry->addr)
+	);
+
+TRACE_EVENT(pte_update,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(pte_update_defer,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(make_pte,
+	    TP_PROTO(pteval_t pteval, pteval_t pte),
+	    TP_ARGS(pteval, pte),
+	    TP_STRUCT__entry(
+		    __field(pteval_t, pteval)
+		    __field(pteval_t, pte)
+		    ),
+	    TP_fast_assign(
+		    __entry->pteval = pteval;
+		    __entry->pte = pte;
+		    ),
+	    TP_printk("pteval:%0*llx pte:%0*llx",
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pte)
+	);
+
+TRACE_EVENT(pte_val,
+	    TP_PROTO(pte_t pte, pteval_t pteval),
+	    TP_ARGS(pte, pteval),
+	    TP_STRUCT__entry(
+		    __field(pte_t, pte)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pte = pte;
+		    __entry->pteval = pteval;
+		    ),
+	    TP_printk("pte:%0*llx pteval:%0*llx",
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pte.pte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(make_pgd,
+	    TP_PROTO(pgdval_t pgdval, pgdval_t pgd),
+	    TP_ARGS(pgdval, pgd),
+	    TP_STRUCT__entry(
+		    __field(pgdval_t, pgdval)
+		    __field(pgdval_t, pgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pgdval = pgdval;
+		    __entry->pgd = pgd;
+		    ),
+	    TP_printk("pgdval:%0*llx pgd:%0*llx",
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgdval,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgd)
+	);
+
+TRACE_EVENT(pgd_val,
+	    TP_PROTO(pgd_t pgd, pgdval_t pgdval),
+	    TP_ARGS(pgd, pgdval),
+	    TP_STRUCT__entry(
+		    __field(pgd_t, pgd)
+		    __field(pgdval_t, pgdval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pgd = pgd;
+		    __entry->pgdval = pgdval;
+		    ),
+	    TP_printk("pgd:%0*llx pgdval:%0*llx",
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgd.pgd,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->pgdval)
+	);
+
+TRACE_EVENT(ptep_modify_prot_start,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(ptep_modify_prot_commit,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte),
+	    TP_ARGS(mm, addr, ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->pteval = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p pte:%0*llx newpte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->pteval,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(set_pte,
+	    TP_PROTO(pte_t *ptep, pte_t pte),
+	    TP_ARGS(ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("ptep:%p oldpte:%0*llx newpte:%0*llx",
+		      __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(set_pte_at,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte),
+	    TP_ARGS(mm, addr, ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p oldpte:%0*llx newpte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(set_pmd,
+	    TP_PROTO(pmd_t *pmdp, pmd_t pmd),
+	    TP_ARGS(pmdp, pmd),
+	    TP_STRUCT__entry(
+		    __field(pmd_t *, pmdp)
+		    __field(pmdval_t, oldpmd)
+		    __field(pmdval_t, newpmd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmdp = pmdp;
+		    __entry->oldpmd = pmd_val_notrace(*pmdp);
+		    __entry->newpmd = pmd_val_notrace(pmd);
+		    ),
+	    TP_printk("pmdp:%p oldpmd:%0*llx newpmd:%0*llx",
+		      __entry->pmdp,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->oldpmd,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->newpmd)
+	);
+
+#if PAGETABLE_LEVELS >= 3
+TRACE_EVENT(make_pmd,
+	    TP_PROTO(pmdval_t pmdval, pmdval_t pmd),
+	    TP_ARGS(pmdval, pmd),
+	    TP_STRUCT__entry(
+		    __field(pmdval_t, pmdval)
+		    __field(pmdval_t, pmd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmdval = pmdval;
+		    __entry->pmd = pmd;
+		    ),
+	    TP_printk("pmdval:%0*llx pmd:%0*llx",
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmdval,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmd)
+	);
+
+TRACE_EVENT(pmd_val,
+	    TP_PROTO(pmd_t pmd, pmdval_t pmdval),
+	    TP_ARGS(pmd, pmdval),
+	    TP_STRUCT__entry(
+		    __field(pmd_t, pmd)
+		    __field(pmdval_t, pmdval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmd = pmd;
+		    __entry->pmdval = pmdval;
+		    ),
+	    TP_printk("pmd:%0*llx pmdval:%0*llx",
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmd.pmd,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->pmdval)
+	);
+
+TRACE_EVENT(set_pud,
+	    TP_PROTO(pud_t *pudp, pud_t pud),
+	    TP_ARGS(pudp, pud),
+	    TP_STRUCT__entry(
+		    __field(pud_t *, pudp)
+		    __field(pudval_t, oldpud)
+		    __field(pudval_t, newpud)
+		    ),
+	    TP_fast_assign(
+		    __entry->pudp = pudp;
+		    __entry->oldpud = pud_val_notrace(*pudp);
+		    __entry->newpud = pud_val_notrace(pud);
+		    ),
+	    TP_printk("pudp:%p oldpud:%0*llx newpud:%0*llx",
+		      __entry->pudp,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->oldpud,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->newpud)
+	);
+
+#if PAGETABLE_LEVELS == 4
+
+TRACE_EVENT(make_pud,
+	    TP_PROTO(pudval_t pudval, pudval_t pud),
+	    TP_ARGS(pudval, pud),
+	    TP_STRUCT__entry(
+		    __field(pudval_t, pudval)
+		    __field(pudval_t, pud)
+		    ),
+	    TP_fast_assign(
+		    __entry->pudval = pudval;
+		    __entry->pud = pud;
+		    ),
+	    TP_printk("pudval:%0*llx pud:%0*llx",
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pudval,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pud)
+	);
+
+TRACE_EVENT(pud_val,
+	    TP_PROTO(pud_t pud, pudval_t pudval),
+	    TP_ARGS(pud, pudval),
+	    TP_STRUCT__entry(
+		    __field(pud_t, pud)
+		    __field(pudval_t, pudval)
+		    ),
+	    TP_fast_assign(
+		    __entry->pud = pud;
+		    __entry->pudval = pudval;
+		    ),
+	    TP_printk("pud:%0*llx pudval:%0*llx",
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pud.pud,
+		      HEX_FIELD(pudval_t), (unsigned long long)__entry->pudval)
+	);
+
+TRACE_EVENT(set_pgd,
+	    TP_PROTO(pgd_t *pgdp, pgd_t pgd),
+	    TP_ARGS(pgdp, pgd),
+	    TP_STRUCT__entry(
+		    __field(pgd_t *, pgdp)
+		    __field(pgdval_t, oldpgd)
+		    __field(pgdval_t, newpgd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pgdp = pgdp;
+		    __entry->oldpgd = pgd_val_notrace(*pgdp);
+		    __entry->newpgd = pgd_val_notrace(pgd);
+		    ),
+	    TP_printk("pgdp:%p oldpgd:%0*llx newpgd:%0*llx",
+		      __entry->pgdp,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->oldpgd,
+		      HEX_FIELD(pgdval_t), (unsigned long long)__entry->newpgd)
+	);
+
+#endif	/* PAGETABLE_LEVELS == 4 */
+
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
+#ifdef CONFIG_X86_PAE
+TRACE_EVENT(set_pte_atomic,
+	    TP_PROTO(pte_t *ptep, pte_t pte),
+	    TP_ARGS(ptep, pte),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    __field(pteval_t, newpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    __entry->newpte = pte_val_notrace(pte);
+		    ),
+	    TP_printk("ptep:%p oldpte:%0*llx newpte:%0*llx",
+		      __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->newpte)
+	);
+
+TRACE_EVENT(pte_clear,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, oldpte)
+		    ),
+	    TP_fast_assign(
+		    __entry->mm = mm;
+		    __entry->addr = addr;
+		    __entry->ptep = ptep;
+		    __entry->oldpte = pte_val_notrace(*ptep);
+		    ),
+	    TP_printk("mm:%p addr:%lx ptep:%p oldpte:%0*llx",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      HEX_FIELD(pteval_t), (unsigned long long)__entry->oldpte)
+	);
+
+TRACE_EVENT(pmd_clear,
+	    TP_PROTO(pmd_t *pmdp),
+	    TP_ARGS(pmdp),
+	    TP_STRUCT__entry(
+		    __field(pmd_t *, pmdp)
+		    __field(pmdval_t, oldpmd)
+		    ),
+	    TP_fast_assign(
+		    __entry->pmdp = pmdp;
+		    __entry->oldpmd = pmd_val_notrace(*pmdp);
+		    ),
+	    TP_printk("pmdp:%p oldpmd:%0*llx",
+		      __entry->pmdp,
+		      HEX_FIELD(pmdval_t), (unsigned long long)__entry->oldpmd)
+	);
+
+#endif	/* CONFIG_X86_PAE */
+
+TRACE_EVENT(start_context_switch,
+	    TP_PROTO(struct task_struct *prev),
+	    TP_ARGS(prev),
+	    TP_STRUCT__entry(
+		    __field(struct task_struct *, prev)
+		    ),
+	    TP_fast_assign(
+		    __entry->prev = prev
+		    ),
+	    TP_printk("prev:%p", __entry->prev)
+	);
+
+TRACE_EVENT(end_context_switch,
+	    TP_PROTO(struct task_struct *next),
+	    TP_ARGS(next),
+	    TP_STRUCT__entry(
+		    __field(struct task_struct *, next)
+		    ),
+	    TP_fast_assign(
+		    __entry->next = next
+		    ),
+	    TP_printk("next:%p", __entry->next)
+	);
+
+TRACE_EVENT(enter_lazy_mmu,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(leave_lazy_mmu,
+	    TP_PROTO(int __dummy),
+	    TP_ARGS(__dummy),
+	    ,
+	    ,
+	);
+
+TRACE_EVENT(set_fixmap,
+	    TP_PROTO(unsigned idx, phys_addr_t phys, pgprot_t flags),
+	    TP_ARGS(idx, phys, flags),
+	    TP_STRUCT__entry(
+		    __field(unsigned, idx)
+		    __field(phys_addr_t, phys)
+		    __field(pgprot_t, flags)
+		    ),
+	    TP_fast_assign(
+		    __entry->idx = idx;
+		    __entry->phys = phys;
+		    __entry->flags = flags;
+		    ),
+	    TP_printk("idx:%d phys:%llx flags:%*llx",
+		      __entry->idx, (unsigned long long)__entry->phys,
+		      HEX_FIELD(pgprotval_t), (unsigned long long)pgprot_val(__entry->flags))
+	);
+
+#endif	/* _ASM_X86_PARAVIRT_TRACE_H */
+
+/* This part must be outside protection */
+#ifdef CREATE_PVOPS_TRACE_POINTS
+#undef CREATE_PVOPS_TRACE_POINTS	/* avoid infinite recursion */
+#include <trace/instantiate_trace.h>
+#else
+#include <trace/define_trace.h>
+#endif
-- 
1.6.0.6

